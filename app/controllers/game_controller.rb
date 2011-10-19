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
	
	def init
		@game = Game.find_by_game_code("ABCD01")
		init_initial_firms(@game)
		redirect_to :root
	end
	
	def buy
		player = Player.find(params[:buy][:id])
		co_num = params[:buy][:co_num]
		co_num = co_num.to_i
		company = nil
		if (co_num.between?(1,6))
			company = player.game.independent_companies.find_by_number(co_num)
			player.independent_companies << company
		else
			company = player.game.private_companies.find_by_number(co_num)
			player.shares << company.share unless company.share.nil?
			player.private_companies << company
		end
		cost = params[:buy][:amount]
		cost = cost.to_i
		company.bought_for=cost
		company.status = "BOUGHT"
		if (company.class.to_s == "IndependentCompany")
			tres = cost
			company.treasury = 100 + (( !(tres % 2).zero? ? tres -= 5 : tres)-100)/2
		end
		company.save
		player.cash_held -= cost
		player.previous_pass = false
		player.save
		player.game.bank_amount += cost
		player.game.save
		Event.buy_company(player,cost,company)
		# does this trigger a bidding war?
			# yes, update next co#s' bids with war=true
			# event -> bid war (creates a new flag)
			# new player is the lowest bidding (new player event has regarding bidding war & co #)
				# has opportunity to quit or up (via a new controller action)
				# remove bid if quit / update if up the bid
			# move on to next person until 1 bid left
				# this triggers the buy controller
				# bidding war over event
				# do same method again to see if next co is bidding war
		# no, regular new_player method	
			
				
		new_player(player)
  		render :js => "$.requestInitBidUpdate()"	
	end
	
	def pass
		player = Player.find(params[:pass][:id])
		player.previous_pass = true
		player.save
		Event.pass(player)
		if player.game.players.where("previous_pass = true").count == player.game.num_players
			player.game.round += 1
			player.game.operating_round += 1
			player.game.save
			Event.all_pass(player, game_operating_round_url)
			redirect to game_operating_round_path
		end
		new_player(player)
		render :js => "$.requestInitBidUpdate()"
	end
	
	def bid
		player = Player.find(params[:bid][:id])
		co_num = params[:bid][:co_num]
		co_num = co_num.to_i
		company = nil
		if (co_num.between?(1,6))
			company = player.game.independent_companies.find_by_number(co_num)
		else
			company = player.game.private_companies.find_by_number(co_num)
		end
		bid = company.bids.build
		player.bids << bid
		amount = params[:bid][:amount]
		amount = amount.to_i
		bid.bid_amount = amount
		player.cash_held -= amount
		player.previous_pass = false
		player.save
		bid.save
		Event.bid(player,bid,company)	
		new_player(player)
  		render :js => "$.requestInitBidUpdate()"	
	end
	
	def update
		@last_event_num = params[:last_event_num]
		@events = this_player.game.events.where("id > ?",@last_event_num).order("id ASC")
			
		if (@events.count == 0)
			noEvent = Event.new
			noEvent.code = "NO_UPDATE"
			noEvent.id = @last_event_num
			a =	[] << noEvent
			render :json => a.to_json
		else
			render :json => @events.to_json
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
	
	private
	
	def new_player(old_player)
		n = old_player.game.num_players
		i = old_player.player_number
		new_player = (i+1)==n ? i+1 : (i+1)%n
		Event.new_player(Player.find(new_player))
		old_player.game.first_player = old_player.game.players.find_by_player_number(new_player)
		old_player.game.save
	end
end
