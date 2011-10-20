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
		@last_event_num = this_player.game.events.last
		(@last_event_num.nil? ? @last_event_num=0 : @last_event_num = @last_event_num.id)
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
		company = player.game.get_init_bid_company(co_num)
		company.buy_for(cost, player)
		eval_company_number(co_num) #goto <a>; possibly start bidding wars on next co's
		player.game.new_first_player(player)
 		render :js => "$.requestInitBidUpdate();"	
	end
	
	def bidding_war
		new_bid = (params[:bidding_war][:new_bid]).to_i
		player = Player.find(params[:bidding][:id])
		co_num = (params[:bidding_war][:co_num]).to_i
		company = player.game.get_init_bid_company(co_num)
		bid = company.bids.find_by_player_id(player)
		if new_bid == -1
			bid.lose_bid(company, player)
			# meaning player dropped out of bidding, loop to (b) to see if one player left or who is next in bidding war
			eval_bid_war(company)
		else
			Event.bidding_war_up_bid(company,player,new_bid,bid.bid_amount)
			bid.upBid(new_bid)
			# determine next bidder, loop to (c)
			bidding_war(company)
		end
	end
	
	def pass
		player = Player.find(params[:pass][:id])
		Player.update(player.id, :previous_pass => true)
		Event.pass(player)
		if game.all_pass?
			Event.all_pass(player, game_operating_round_url)
			player.game.new_first_player(player)
			player.game.end_init_bidding(player)
			redirect to game_operating_round_path
		end
		player.game.new_first_player(player)
		render :js => "$.requestInitBidUpdate();"
	end
	
	def bid
		player = Player.find(params[:bid][:id])
		co_num = (params[:bid][:co_num]).to_i
		amount = (params[:bid][:amount]).to_i
		company = player.game.get_init_bid_company(co_num)
		company.add_bid(player, amount)
		Event.bid(player,bid,company)	
		player.game.new_first_player(player)
  	render :js => "$.requestInitBidUpdate();"	
	end
	
	def update
		last_event_num = params[:last_event_num]
		events = this_player.game.events.where("id > ?",last_event_num).order("id ASC")
		if (events.count == 0)
			noEvent = Event.noUpdate(last_event_num)
			render :json => noEvent.to_json
		else
			render :json => events.to_json
		end
	end
	
	def bought_flag
		@co_num = params[:co_number]
		respond_to do |format|
			format.js
		end
	end
	
	def bid_flag
		@co_num = params[:co_number]
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
	
		def eval_company_number(co_num) # (a)
			if co_num == 11
				# last company has been bought, move to first operating round
				Event.init_bidding_complete(player, game_operating_round_url)
			else
				# if next co in line has no bids, that becomes avail for outright purchase
				next_co_num = co_num + 1
				next_company = get_init_bid_company(player.game, next_co_num)
				if next_company.bids.empty?
					#this company is now available for outright purchase
					Event.new_company_available_for_purchase(player.game, next_company)
				else 
					eval_bid_war(next_company)   # goto <b>
				end		
			end
		end
		
		def eval_bid_war(company) # (b)
			if company.bids.count == 1
				# if only a single bid, that bidder buys co for that price
				company.buy_for(company.bids.first.bid_amount, company.bids.first.player)
				this_player.game.set_bidding_war_co_num(nil)
				eval_company_number(company.number) #loop back to <a>
			else
				#bidding War!
				bidding_war(company) # goto <c>
			end
		end
		
		def bidding_war(company) # (c)
			next_bidder = company.bids.order("bid_amount ASC").first.player
			next_bidder.game.set_bidding_war_co_num(company.number)
			Event.bidding_war(company, next_bidder, company.bids.order("bid_amount ASC").last.bid_amount, company.bids.order("bid_amount ASC").first.bid_amount)
			render :js => "$.requestInitBidUpdate();"		
		end	

	# end of private methods
end
