class Player < ActiveRecord::Base
	attr_accessible :name, :username, :email, :motto, :password
	
	belongs_to :game
	has_many :independent_companies, :as => :ind_co_owner
	has_many :corporations
	has_many :private_companies, :as => :priv_co_owner
	has_many :bids
	#has_many :shares
end
