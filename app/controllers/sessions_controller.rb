class SessionsController < ApplicationController
respond_to :html, :js
	
	def create
		customer = Customer.authenticate(params[:session][:username], params[:session][:password])
		
		if customer.nil?
			flash[:error] = "Invalid username and/or password"
			redirect_to :root
		else
			# valid Customer, checking game code
			game = Game.find_by_game_code(params[:session][:gamecode])
			
			if game.nil?
				flash[:error] = "Gamecode not recognized"
				redirect_to :root
			else
				# valid Customer && valid Game Code, checking if assigned to game
				player = game.players.where(:customer_id => customer.id).first
				if player.nil?
					flash[:error] = "Username not assigned to game '#{game.game_code}'"
					redirect_to :root
				else
					sign_in player  #includes setting the activated? flag
					redirect_to login_logged_in_path(:format=>:js), 
				end
			end
		end
	end
	
	def destroy
		@player = Player.find(params[:id])
		sign_out @player
		redirect_to :root
	end
end
