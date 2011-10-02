class GameController < ApplicationController

	def start
		#start the game!!
		@player = this_player
		@game = @player.game
		init_initial_firms(@game)
	end
end
