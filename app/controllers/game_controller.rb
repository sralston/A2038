class GameController < ApplicationController

	def start
		#start the game!!
		@player = this_player
		@game = @player.game
		@privs = @game.private_companies.order('private_companies.number ASC')
		@inds = @game.independent_companies.order('independent_companies.number ASC')
	end
	
	def init
		@game = Game.find_by_game_code("ABCD01")
		init_initial_firms(@game)
		redirect_to :root
	end
end
