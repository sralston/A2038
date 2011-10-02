class IndependentCompany < ActiveRecord::Base
	attr_accessible :tag_line

	belongs_to :ind_co_owner, :polymorphic => true
	#has_one :pilot
	has_many :bids, :as => :bid_on
	#has_many :mines, :as => :claim
	#has_one  :base, :as => :base_owner
	#has_many  :ships, :as => :ship_owner
	
end
