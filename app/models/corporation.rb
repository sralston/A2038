class Corporation < ActiveRecord::Base
	attr_accessible :tag_line, :par_value

	belongs_to :corp_owner, :polymorphic => true
	#has_many :ships, :as => :ship_owner
	has_many  :shares
	has_many  :private_companies, :as => :priv_co_owner
	#has_many :pilots
	#has_many :mines, :as => :claim
	#has_many :bases, :as => :base_owner
	#has_many :refuel_stations
	has_many  :free_items, :through => :private_companies
end
