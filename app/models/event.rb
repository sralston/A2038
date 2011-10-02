class Event < ActiveRecord::Base
	attr_accessible #none
	
	belongs_to :game
	
	def self.activate(player)
		event = player.game.events.build
		event.code = "LOGIN_PLAYER"
		event.text = "Player " + player.customer.username + " has logged in"
		event.value = player.player_number
		event.regarding = "Player"
		event.save
	end
	
	def self.deactivate(player)
		event = player.game.events.build
		event.code = "LOGOUT_PLAYER"
		event.text = "Player " + player.customer.username + " has logged out"
		event.value = player.player_number
		event.regarding = "Player"
		event.save
	
	end
	
	def self.all_in(player)
		event = player.game.events.build
		event.code = "ALL_IN"
		event.text = "All players logged in...let's start!"
		event.regarding = "Player"
		event.save
	end
end
