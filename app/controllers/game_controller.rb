class GameController < ApplicationController
respond_to :html, :js

	def start
		#start the game -- Initial Bidding Round!!!
		@player = this_player
		@game = @player.game
		@companies = Array.new
		@game.players.each do |p|
			@companies.concat(p.private_companies).concat(p.independent_companies)
		end
		@companies.concat(@game.private_companies).concat(@game.independent_companies)
		@companies = @companies.sort_by { |c| c.number }
		@last_event_num = @game.events.last
		@last_event_num.nil? ? @last_event_num=0 : @last_event_num = @last_event_num.id
		@event = Event.new
		if !@game.bidding_war_first_player.nil?
			@event = @game.events.where("code = 'INITBID_BIDDING_WAR'").last
		end
	end
	
	def init #need to update
		@game = Game.find_by_game_code("ABCD01")
		init_initial_firms(@game)
		redirect_to :root
	end
	
	def buy
		player = Player.find(params[:buy][:id])
		co_num = (params[:buy][:co_num]).to_i
		cost = (params[:buy][:amount]).to_i
		game = player.game
		company = game.get_init_bid_company(co_num)
		company.buy_for(cost, player, game, false)
		if eval_company_number(co_num, game) #goto <a>; possibly start bidding wars on next co's
			#bid war on! change first_player, but don't create the event that would trigger that person's turn
			game.first_player = game.determine_next_player(player)
			game.save
		else	
			game.new_first_player(player)
		end
 		render :js => "$.requestInitBidUpdate();"	
	end
	
	def bw
		new_bid = (params[:bidding_war][:new_bid]).to_i
		player = Player.find(params[:bidding_war][:id])
		co_num = (params[:bidding_war][:co_num]).to_i
		game = player.game
		company = game.get_init_bid_company(co_num)
		bid = company.bids.where(:active=>true).find_by_player_id(player)
		if new_bid == -1
			bid.lose_bid(company, player)
			# meaning player dropped out of bidding, loop to (b) to see if one player left or who is next in bidding war
			if !eval_bid_war(company, game) # <b>
				Event.new_first_player(game.first_player) unless game.all_pass?
				game.bidding_war_first_player = nil
				game.save
			end
		else
			Event.bidding_war_up_bid(company,player,new_bid,bid.bid_amount)
			bid.up_bid(new_bid, player)
			# determine next bidder, loop to (c)
			bidding_war(company, game) # <c>
		end
		render :js => "$.requestInitBidUpdate();"
	end
	
	def pass
		player = Player.find(params[:pass][:id])
		Player.update(player.id, :previous_pass => true)
		game = player.game
		Event.pass(player)
		if game.all_pass?
			Event.all_pass(player)
			if !eval_remaining_bids(game)
				Event.init_bidding_complete(player, game_operating_round_url)
			end
		end
		game.new_first_player(player)
		render :js => "$.requestInitBidUpdate();"
	end
	
	def bid
		player = Player.find(params[:bid][:id])
		co_num = (params[:bid][:co_num]).to_i
		amount = (params[:bid][:amount]).to_i
		company = player.game.get_init_bid_company(co_num) 
		bid_made = company.add_bid(player, amount)
		Event.bid(player,bid_made,company)	
		player.game.new_first_player(player)
  	render :js => "$.requestInitBidUpdate();"	
	end
	
	def update
		last_event_num = params[:last_event_num]
		game = Game.find(params[:id])
		player = game.players.find_by_player_number(params[:playernum])
		events = game.events.where("id > ?",last_event_num).order("id ASC")
		if (events.count == 0)
			events = Event.noUpdate(last_event_num)
		end
		if !(game.bidding_war_first_player == player || (game.bidding_war_first_player.nil? && game.first_player == player))
			events << Event.setPing(events.last.id)
		end
		render :json => events.to_json
	end
	
	def bought_flag
		@co_num = params[:co_number]
		respond_to do |format|
			format.js
		end
	end
	
	def bid_flag
		@co_num = params[:co_number]
		@company = this_player.game.get_init_bid_company(@co_num.to_i)
		respond_to do |format|
			format.js
		end
	end
	
	def buy_flag
		@co_num = params[:co_number]
		respond_to do |format|
			format.js
		end
	end
	
	def bidwar_flag
		@co_num = params[:co_number]
		respond_to do |format|
			format.js
		end
	end
	
	private
	
		def eval_company_number(co_num, game) # (a)
			if game.all_pass?
				if !(status = eval_remaining_bids(game)) # goto <d>
					# last company has been bought, move to first operating round
					Event.init_bidding_complete(this_player, game_operating_round_url)
				end
				return status
			else		
				if co_num == 11
					# last company has been bought, move to first operating round
					Event.init_bidding_complete(this_player, game_operating_round_url)
					return false
				else
					# if next co in line has no bids, that becomes avail for outright purchase
					next_co_num = co_num + 1
					next_company = game.get_init_bid_company(next_co_num)
					if next_company.bids.where(:active=>true).empty?
						#this company is now available for outright purchase
						Event.new_company_available_for_purchase(game, next_company)
						return false
					else 
						eval_bid_war(next_company, game)   # goto <b>	
					end		
				end
			end
		end
		
		def eval_bid_war(company, game) # (b)
			if company.bids.where(:active=>true).count == 1
				# if only a single bid, that bidder buys co for that price
				if company.bids.count > 1
					Event.bid_war_ended(company.bids.where(:active=>true).first.player, company)
				end
				company.buy_for(company.bids.where(:active=>true).first.bid_amount, company.bids.where(:active=>true).first.player, game, true)
				eval_company_number(company.number, game) #loop back to <a>
			else
				#bidding War!
				bidding_war(company, game) # goto <c>
			end
		end
		
		def bidding_war(company, game) # (c)
			next_bidder = company.bids.where(:active=>true).order("bid_amount ASC").first.player
			game.bidding_war_first_player = next_bidder
			game.save
			Event.bidding_war(company, next_bidder, company.bids.where(:active=>true).order("bid_amount ASC").last.bid_amount, company.bids.where(:active=>true).order("bid_amount ASC").first.bid_amount)
			return true
		end	
		
		def eval_remaining_bids(game) # (d)
			companies = Array.new
			companies.concat(game.private_companies).concat(game.independent_companies)
			companies = companies.sort_by { |c| c.number }
			companies.each do |co|
				if co.bids.where(:active=>true).count == 1
					co.buy_for(co.bids.where(:active=>true).first.bid_amount, co.bids.where(:active=>true).first.player, game, true)
				elsif co.bids.where(:active=>true).count > 1
					return bidding_war(co, game)
				end
			end
			return false
		end	
	# end of private methods
end
