module SessionsHelper

	def sign_in(player)
		cookies.permanent.signed[:remember_token] = [player.id, player.customer.salt]
		this_player = player
		Player.activate(player)
	end
	
	def sign_out(player)
		cookies.delete(:remember_token)
		Player.deactivate(player)
		this_player = nil
	end

	def this_player=(player)
		@this_player = player
	end

	def this_player
		@this_player ||= player_from_remember_token
	end
	
	def signed_in?
		!this_player.nil?
	end
	
	def game_code
		cookies.signed[:game_code]
	end

	private
		
		def player_from_remember_token
			player = Player.authenticate_with_salt(*remember_token)
		end

		def remember_token
			cookies.signed[:remember_token] || [nil,nil]
		end
end
