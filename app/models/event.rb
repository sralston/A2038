class Event < ActiveRecord::Base
	attr_accessible #none
	
	belongs_to :game
	
	def self.activate(player)
		event = player.game.events.build
		event.code = "LOGIN_PLAYER"
		event.text = "Player " + player.customer.username + " (" + player.player_number.to_s + ") has logged in."
		event.value = player.player_number
		event.regarding = "Player"
		event.save
	end
	
	def self.deactivate(player)
		event = player.game.events.build
		event.code = "LOGOUT_PLAYER"
		event.text = "Player " + player.customer.username + " (" + player.player_number.to_s + ") has logged out."
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
		event.value2 = player.player_number
		event.save
	end
	
	def self.new_first_player(player)
		event = player.game.events.build
		event.code = "NEW_FIRST_PLAYER"
		event.text = "New Player stock/bidding turn: " + player.customer.username + " (" + player.player_number.to_s + ")."
		event.regarding = "Player"
		event.value = player.player_number
		event.save
	end
	
	def self.pass(player)
		event = player.game.events.build
		event.code = "PASS"
		event.text = "Player " + player.customer.username + " (" + player.player_number.to_s + ") passed their turn."
		event.regarding = "Player"
		event.value = player.player_number
		event.save
	end
	
	def self.all_pass(player, url)
		event = player.game.events.build
		event.code = "ALL_PASS"
		event.text = url
		event.regarding = "Player"
		event.save
	end
	
		def self.bid(player, bid, co)
		event = player.game.events.build
		event.code = "INITBID_BID"
		event.text = "Player " + player.customer.username + " (" + player.player_number.to_s + ") bid on " + co.name + " for *" + bid.bid_amount.to_s + "."
		event.regarding = co.number
		event.value = bid.bid_amount
		event.value2 = player.player_number
		event.save
	end
	
	def self.init_bidding_complete(player, url)
		event = player.game.events.build
		event.code = "INITBID_END"
		event.text = url
		event.regarding = "Bidding"
		event.save
	end
	
	def self.noUpdate(last_event_num)
		noEvent = Event.new
		noEvent.code = "NO_UPDATE"
		noEvent.id = last_event_num
		a =	[] << noEvent
		return a
	end
	
	def self.new_company_available_for_purchase(game, company)
		event = game.events.build
		event.code = "INITBID_CO_AVAIL_FOR_PURCHASE"
		event.text = "Company " + company.name + " (" + company.number.to_s + ") now available for purchase."
		event.regarding = "Company"
		event.value = company.number
		event.value2 = company.starting_bid
		event.save
	end
	
	def self.bidding_war(company, player, high_bid, original_bid)
		event = player.game.events.build
		event.code = "INITBID_BIDDING_WAR"
		event.text = "Bidding War for Company " + company.name + " (" + company.number.to_s + "); Player " +player.player_number.to_s + "'s turn with a *" + amount.to_s + "bid"
		event.regarding = high_bid.to_s + "/" + original_bid.to_s #highest bid amount / original bid
		event.value = player.player_number #next bidder:  bidder with lowest bid/earlier to place bid
		event.value2 = company.number.to_s
		event.save		
	end
	
	def self.bidding_war_drop_out(company, player, original_bid)
		event = player.game.events.build
		event.code = "INITBID_BIDDING_WAR_DROP_OUT"
		event.text = "Player " + player.player_number.to_s + " dropped out of the Bidding War for " + company.name + "."
		event.regarding = company.number.to_s
		event.value = player.player_number
		event.value2 = original_bid
		event.save		
	end
	
	def self.bidding_war_up_bid(company,player,new_bid,old_bid)	
		event = player.game.events.build
		event.code = "INITBID_BIDDING_WAR_UP_BID"
		event.text = "Player "+player.player_number.to_s+" upped their bid for "+company.name+" from *" + old_bid.to_s + " to *" + new_bid.to_s
		event.regarding = new_bid.to_s + "/" + old_bid.to_s
		event.value = player.player_number #next bidder:  bidder with lowest bid/earlier to place bid
		event.value2 = company.number.to_s
		event.save		
	end
	
end
