class Player < ActiveRecord::Base
	attr_accessible #none
	
	belongs_to :game
	belongs_to :customer
	has_many :independent_companies
	has_many :corporations
	has_many :private_companies, :as => :priv_co_owner
	has_many :bids
	has_one  :first_player, :class_name => :game, :foreign_key => "first_person_id"
	has_one	 :current_player, :class_name => :game, :foreign_key => "current_player_id"
	
	#has_many :shares
end
