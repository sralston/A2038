class CreateShares < ActiveRecord::Migration
  def self.up
    create_table :shares do |t|
		t.references 	:corporation
		t.references	:stock_owner, :polymorphic => true
		t.string		:share_type, :null=>false, :limit => 14, :default => "10% Share"
		t.string		:status, :null=>false, :limit => 6, :default => "NEW"
		t.decimal		:percent, :precision=>2, :scale=>1, :default=>"0.1"
	    t.timestamps
    end
    add_index :shares, :corporation_id
    add_index :shares, [:stock_owner_id, :stock_owner_type], :name => "shares_own_indx"
  end

  def self.down
    drop_table :shares
  end
end
