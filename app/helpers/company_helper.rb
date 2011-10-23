module CompanyHelper

	def buy_for(cost, player, game, bid_war_buy)
		self.status = "BOUGHT"
		self.bought_for = cost
		game_gain = cost
		if self.class.to_s == "PrivateCompany"
			player.transfer_share_from_bought_company(self)
			player.private_companies << self
		else
			tres = cost
			self.treasury = 100 + (( !(tres % 2).zero? ? tres -= 5 : tres)-100)/2
			player.independent_companies << self
			game_gain -= self.treasury
		end
		if self.bids.empty? #don't take money out if this was bid on; money is already gone.
			player.spend(cost) 
		end
		game.gain(game_gain)
		Player.update(player.id, :previous_pass=>false) unless bid_war_buy
		Event.buy_company(player,cost,self)
		self.save
	end
	
	def add_bid(player, amount)
		bid = self.bids.build
		bid.bid_amount = amount
		player.bids << bid
		player.spend(amount)
		Player.update(player.id, :previous_pass=>false)
		return bid
	end

end
