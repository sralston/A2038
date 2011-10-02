class Game < ActiveRecord::Base
	attr_accessible :long_game, :num_players

	has_many 	:players
	belongs_to	:first_player, :class_name=>"Player"
	belongs_to	:current_player, :class_name=>"Player"
	has_many	:customers, :through => :players
	has_many	:corporations, :as => :corp_owner
	has_many	:private_companies, :as => :priv_co_owner
	has_many	:independent_companies, :as => :ind_co_owner
	has_many	:events
	#has_many	:locations
	has_many 	:shares, :as => :stock_owner
end
