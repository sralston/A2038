class CreateBids < ActiveRecord::Migration
  def self.up
    create_table :bids do |t|
		t.references	:player
		t.references	:bid_on, :polymorphic => true
		t.integer		:bid_amount
      t.timestamps
    end
    	add_index :bids, [:player_id, :bid_on_id, :bid_on_type], :name => "bids_indx"
  end

  def self.down
    drop_table :bids
  end
end
