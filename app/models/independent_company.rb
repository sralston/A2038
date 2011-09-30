class IndependentCompany < ActiveRecord::Base
	attr_accessible :tag_line

	belongs_to :player
	#has_many :ships
	has_many :bids, :as => :bid_on
	#has_many :mines, :as => :claim
	#has_one  :base, :as => :owner
end
