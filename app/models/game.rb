class Game < ActiveRecord::Base
	attr_accessible :long_game, :num_players

	has_many 	:players
	has_one		:first_player, :foreign_key => "first_person_id", :class_name=>"Player"
	has_one		:current_player, :foreign_key => "current_player_id", :class_name=>"Player"
	#has_many :event_logs
	#has_many :locations
end
