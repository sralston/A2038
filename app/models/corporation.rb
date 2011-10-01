class Corporation < ActiveRecord::Base
	attr_accessible :tag_line, :par_value

	belongs_to :player
	#has_many :ships
	#has_many :shares
	has_many  :private_companies, :as => :priv_co_owner
	#has_many :pilots
	#has_many :mines, :as => :claim
	#has_many :bases, :as => :owner
	#has_many :refuel_stations, :class=>"base", :foreign_key=>"refuel_owner_id"
end
