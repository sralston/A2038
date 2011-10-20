class Bid < ActiveRecord::Base
	attr_accessible	:bid_amount
	
	belongs_to :player
	belongs_to :bid_on, :polymorphic => true
	
	def up_bid(amount)
		player.spend(amount-self.bid_amount)
		Bid.update(self.id, amount)
	end
	
	def lose_bid(company, player)
		player.gain(self.bid_amount)
		Event.bidding_war_drop_out(company, player, self.bid_amount)
		company.bids.delete(self)
	end
	
end
