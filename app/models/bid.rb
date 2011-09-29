class Bid < ActiveRecord::Base
	attr_accessible	:bid_amount
	
	belongs_to :player
	belongs_to :bid_on, :polymorphic => true
end
