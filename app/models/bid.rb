class Bid < ActiveRecord::Base
	attr_accessible	:bid_amount
	
	belongs_to :player
	belongs_to :bid_on, :polymorphic => true
	
	def up_bid(amount, player)
		player.spend(amount-self.bid_amount)
		self.bid_amount = amount
		self.save
	end
	
	def lose_bid(company, player)
		player.gain(self.bid_amount)
		self.active = false;
		self.save
		Event.bidding_war_drop_out(company, player, self.bid_amount)
	end
	
end
