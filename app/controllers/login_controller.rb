class LoginController < ApplicationController
respond_to :html, :js

	def index
		@title = "Login to the 2038 Asteroid Mining Game! [by Roth]"
	end
	
	def waiting
		@players = this_player.game.players.order("player_number ASC")
		@last_event_num = this_player.game.events.where(:code => "LOGIN_PLAYER").last.id
		@title = "Waiting for other player(s)..."
  		respond_to do |format|
  			format.js
  		end		
	end
	
	def logged_in
		@player = this_player
		@game = @player.game
		
		#need to include stuff about where to direct client
		#i.e. based on game_status (NEW=>init; ONGOING=>something else)	
		# change this to a case or something like that...diagram out the states
									
		#all activated? && game.current_state == "NEW" -> game#start
		if (@game.players.where(:activated => false).count == 0) && (@player.game.current_state == "NEW")
			Event.all_in(@player, game_start_url)
			render :js => "$.redirect('"+ game_start_url + "');"
		else
			redirect_to login_waiting_path(:format => :js)
		end			
	end
	
	def update
		@last_event_num = params[:last_event_num]
		@events = this_player.game.events.select("id, code, text, value").where("id > ?",@last_event_num).where("code LIKE ?","LOG%").order("id ASC")
			
		if (@events.count == 0)
			noEvent = Event.new
			noEvent.code = "NO_UPDATE"
			noEvent.id = @last_event_num
			noEvent.text = "No new players have logged in..."
			noEvent.value = 0
			a = Array.new
			a << noEvent
			render :json => a.to_json
		else
			render :json => @events.to_json
		end
	end
end
