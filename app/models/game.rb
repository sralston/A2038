class Game < ActiveRecord::Base
	attr_accessible :long_game, :num_players

	has_many 	:players
	belongs_to	:first_player, :foreign_key => "first_person_id", :class_name=>"Player"
	belongs_to	:current_player, :foreign_key => "current_player_id", :class_name=>"Player"
	#has_many :event_logs
	#has_many :locations
end
