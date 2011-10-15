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
		@last_event_num = this_player.game.events.where("code LIKE ?","INITBID%").last
		(@last_event_num.nil? ? @last_event_num=0 : @last_event_num = @last_event_num.id)
	end
	
	def init
		@game = Game.find_by_game_code("ABCD01")
		init_initial_firms(@game)
		redirect_to :root
	end
	
	def buy
		@player = Player.find(params[:buy][:id])
		co_num = params[:buy][:co_num]
		co_num = co_num.to_i
		company = nil
		if (co_num.between?(1,6))
			company = @player.game.independent_companies.find_by_number(co_num)
			@player.independent_companies << company
		else
			company = @player.game.private_companies.find_by_number(co_num)
			@player.private_companies << company
		end
		cost = params[:buy][:amount]
		cost = cost.to_i
		company.bought_for=cost
		company.save
		@player.cash_held -= cost
		@player.save
		@player.game.bank_amount += cost
		@player.game.save
		Event.buy_company(@player,cost,company)
		new_player(@player)
  		render :js => "$.requestInitBidUpdate()"	
	end
	
	def update
		@last_event_num = params[:last_event_num]
		@events = this_player.game.events.where("id > ?",@last_event_num).order("id ASC")
			
		if (@events.count == 0)
			noEvent = Event.new
			noEvent.code = "NO_UPDATE"
			noEvent.id = @last_event_num
			noEvent.text = "No updates..."
			noEvent.value = 0
			a =	[] << noEvent
			render :json => a.to_json
		else
			render :json => @events.to_json
		end
	end
	
	def bought_flag
		co_num = params[:co_number]
		co_num = co_num.to_i
		player_num = params[:player_num]
		@player = this_player.game.players.find(player_num.to_i)
		@company = nil
		@right = true
		if (co_num.between?(1,6))
			@company = @player.independent_companies.find_by_number(co_num)
		else
			@company = @player.private_companies.find_by_number(co_num)
			@right = false
		end
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
	end
end
