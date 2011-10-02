class Player < ActiveRecord::Base
	attr_accessible #none
	
	belongs_to :game
	belongs_to :customer
	has_many :independent_companies, :as => :ind_co_owner
	has_many :corporations, :as => :corp_owner
	has_many :private_companies, :as => :priv_co_owner
	has_many :bids
	has_one  :first_player, :class_name => "Game", :foreign_key => "first_player_id"
	has_one	 :current_player, :class_name => "Game", :foreign_key => "current_player_id"
	has_many :shares, :as => :stock_owner
	
	def self.authenticate_with_salt(id, cookie_salt)
		player = find_by_id(id)
		(player.customer && player.customer.salt == cookie_salt) ? player : nil
	end
	
	def self.activate(player)
		player.activated = true
		player.save
		Event.activate(player)
	end
	
	def self.deactivate(player)
		player.activated = false
		player.save
		Event.deactivate(player)
	end
end
