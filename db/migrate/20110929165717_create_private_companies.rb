class CreatePrivateCompanies < ActiveRecord::Migration
  def self.up
    create_table :private_companies do |t|
		t.references 	:priv_co_owner, :polymorphic => true, :null => true
		t.string		:name, :limit => 50, :null => false
		t.string		:tag_line, :limit => 255, :null => true
		t.integer		:income
		t.integer		:number
		t.integer 		:starting_bid
		t.string		:status, :null => false, :default => "UNBOUGHT"
		t.boolean		:or_finished, :default=>false
		t.boolean		:sell_to_corp, :default => true
      	t.timestamps
    end
    	add_index :private_companies, [:priv_co_owner_id, :priv_co_owner_type], :name=>"priv_co_indx"
  end

  def self.down
    drop_table :private_companies
  end
end
