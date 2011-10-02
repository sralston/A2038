class PrivateCompany < ActiveRecord::Base
	attr_accessible :tag_line
	
	belongs_to :priv_co_owner, :polymorphic => true
	has_many :bids, :as => :bid_on
	has_one :free_item
	has_one :share
	#has_one :ship, :as => :ship_owner
	#has_one :base
end
