class Event < ActiveRecord::Base
	attr_accessible #none
	
	belongs_to :game
	
	def self.activate(player)
		event = player.game.events.build
		event.code = "LOGIN_PLAYER"
		event.text = "Player " + player.customer.username + " has logged in."
		event.value = player.player_number
		event.regarding = "Player"
		event.save
	end
	
	def self.deactivate(player)
		event = player.game.events.build
		event.code = "LOGOUT_PLAYER"
		event.text = "Player " + player.customer.username + " has logged out."
		event.value = player.player_number
		event.regarding = "Player"
		event.save
	
	end
	
	def self.all_in(player, url)
		event = player.game.events.build
		event.code = "LOGIN_ALL_IN"
		event.text = url
		event.regarding = "Player"
		event.save
	end
	
	def self.buy_company(player, cost, co)
		event = player.game.events.build
		event.code = "INITBID_BUY"
		event.text = "Player " + player.customer.username + " (" + player.player_number.to_s + ") bought " + co.name + " for *" + cost.to_s + "."
		event.regarding = co.number
		event.value = cost
		event.value2 = player.id
		event.save
	end
	
	def self.new_player(player)
		event = player.game.events.build
		event.code = "INITBID_NEW_PLAYER"
		event.text = "New Player turn: " + player.customer.username + " (" + player.player_number.to_s + ")."
		event.regarding = "Player"
		event.value = player.player_number
		event.save
	end
end
