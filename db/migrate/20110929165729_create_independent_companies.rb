class CreateIndependentCompanies < ActiveRecord::Migration
  def self.up
    create_table :independent_companies do |t|
		t.references	:player, :null=>true
		t.string		:name, :null=>false, :limit=>50
		t.string		:tag_line, :limit=>255, :null=>true
		t.integer		:bonus_amount, :null=>true
		t.string		:bonus_type, :limit=>4, :null=>true
		t.integer		:max_ships, :default=>2
		t.integer		:max_claims, :default=>2
		t.integer		:number
		t.integer		:treasury, :default=>100
		t.string		:status, :null=>false, :default=>"UNBOUGHT"
		t.integer		:income, :default=>0
		t.boolean		:or_finished, :default => false
		
      	t.timestamps
    end
  end

  def self.down
    drop_table :independent_companies
  end
end
