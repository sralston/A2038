class GameController < ApplicationController

	def start
		#start the game -- Initial Bidding Round!!!
		@player = this_player
		@game = @player.game
		@companies = Array.new
		@companies.concat(@game.private_companies).concat(@game.independent_companies)
		@companies = @companies.sort_by { |c| c.number }
	end
	
	def init
		@game = Game.find_by_game_code("ABCD01")
		init_initial_firms(@game)
		redirect_to :root
	end
end
