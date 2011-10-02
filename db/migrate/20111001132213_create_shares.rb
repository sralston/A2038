class CreateShares < ActiveRecord::Migration
  def self.up
    create_table :shares do |t|
		t.references 	:corporation
		t.references	:stock_owner, :polymorphic => true
		t.string		:type, :null=>false, :default => "10% Share"
		t.string		:status, :null=>false, :limit => 6
		t.decimal		:percent, :precision=>2, :scale=>1, :default=>"0.1"
	    t.timestamps
    end
  end

  def self.down
    drop_table :shares
  end
end
