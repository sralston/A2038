class LoginController < ApplicationController

	def index
		@title = "Login to the 2038 Asteroid Mining Game! [by Roth]"
	end
	
	def waiting
		@players = this_player.game.players.order("player_number ASC")
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
			redirect_to game_start_path
		else
			redirect_to login_waiting_path
		end			
	end
end
