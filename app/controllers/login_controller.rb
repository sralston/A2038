class LoginController < ApplicationController

	def index
		@title = "Login to the 2038 Asteroid Mining Game! [by Roth]"
	end
	
	def waiting
		@players = this_player.game.players.order("player_number ASC")
		@last_event_num = this_player.game.events.where(:code => "LOGIN_PLAYER").last.id
		@title = "Waiting for other player(s)..."
	end
	
	def logged_in
		@player = this_player
		@game = @player.game
		
		#need to include stuff about where to direct client
		#i.e. based on game_status (NEW=>init; ONGOING=>something else)	
		# change this to a case or something like that...diagram out the states
									
		#all activated? && game.current_state == "NEW" -> game#start
		if (@game.players.where(:activated => false).count == 0) && (@player.game.current_state == "NEW")
			Event.all_in(@player)
			redirect_to game_start_path
		else
			redirect_to login_waiting_path
		end			
	end
	
	def update
		#@last_event_num = params[:login][:last_event_num]
		@last_event_num = params[:last_event_num]
		if (this_player.game.players.where(:activated => false).count == 0) && (this_player.game.current_state == "NEW")
		# all players are in, redirect to game_start_path
			#send event to waiting to say everyone in
	 		render :js => "$.redirect('" + game_start_url + "');" 
		else
			@events = this_player.game.events.select("id, code, text, value").where("id > ?",@last_event_num).where("code LIKE ?","LOG%").order("id ASC")
			
			if (@events.count == 0)
				#render :js => "$.no_updates();"
				render :json => '[{"event":{"code":"NO_UPDATE","id":' + @last_event_num + ',"text":"No new players have logged in...","value":0}}]'
			else
				#respond_to do |format|
  				#format.js
  				#format.json { render :json => @events.to_json }
  				render :json => @events.to_json
  			end
  		end
	end
end
