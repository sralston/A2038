class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
		t.string 	:game_code, :limit => 6, :null => false
		t.boolean	:long_game, :default => true, :null => false
		t.integer	:bank_amount, :default => 10000, :null => false
		t.string	:current_state, :default => "NEW", :null => false
		t.integer	:num_players, :default => 4
		t.integer	:round, :default => 1
		t.integer	:operating_round, :default => 1

		t.integer 	:first_player_id, :null => true
		t.integer	:current_player_id, :null => true
		
        t.timestamps
    end
    add_index :games, :game_code
  end

  def self.down
    drop_table :games
  end
end
