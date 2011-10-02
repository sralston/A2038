class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
    	t.references	:game
    	t.references	:customer
   		t.integer		:cash_held, :default => 0, :null => false
		t.boolean		:activated, :default => false
		t.boolean		:previous_pass, :default => false
		t.integer		:player_number
		
        t.timestamps
    end
    	add_index :players, :game_id
    	add_index :players, :customer_id
    	add_index :players, [:game_id, :customer_id], :name => "game_cust_indx"
  end

  def self.down
    drop_table :players
  end
end
