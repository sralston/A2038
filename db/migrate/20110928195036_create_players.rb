class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
    	t.references	:game
    
		t.string		:name, :limit => 30, :null => false
		t.string		:username, :limit => 30, :null => false
		t.integer		:cash_held, :default => 0, :null => false
		t.string		:email, :limit => 120, :null => false
		t.boolean		:activated, :default => false
		t.string		:motto, :limit => 255, :null => true
		t.string		:password, :limit => 30, :null => false
		t.boolean		:admin, :default => false
		t.boolean		:previous_pass, :default => false
		t.integer		:player_number
		
        t.timestamps
    end
    	add_index :players, :game_id
  end

  def self.down
    drop_table :players
  end
end
