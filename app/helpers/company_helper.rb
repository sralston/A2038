module CompanyHelper

	def buy_for(cost, player)
		self.status = "BOUGHT"
		self.bought_for = cost
		game_gain = cost
		if self.class.to_s == "PrivateCompany"
			player.transfer_share_from_bought_company(company)
			player.private_companies << company
		else
			tres = cost
			self.treasury = 100 + (( !(tres % 2).zero? ? tres -= 5 : tres)-100)/2
			player.independent_companies << company
			game_gain -= self.treasury
		end
		player.spend(cost)
		player.game.gain(game_gain)
		Player.update(player.id, :previous_pass=>false)
		Event.buy_company(player,cost,self)
		self.save
	end
	
	def add_bid(player, amount)
		bid = self.bids.build
		bid.bid_amount = amount
		player.bids << bid
		player.spend(amount)
		Player.update(player.id, :previous_pass=>false)
	end

end
