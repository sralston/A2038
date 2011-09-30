class CreateCorporations < ActiveRecord::Migration
  def self.up
    create_table :corporations do |t|
		t.references	:player, :null=>true	
		t.string		:name, :limit=>50, :null=>false
		t.string		:group, :limit=>1, :null=>true
		t.string		:tag_line, :limit=>255, :null=>true
		t.string		:bonus_type, :limit=>4, :null=>true
		t.integer		:bonus_amount, :null=>true
		t.integer		:max_bases, :default=>0
		t.integer		:max_refuels, :default=>0
		t.integer		:max_claims, :default=>0
		t.integer		:max_ships, :default=>0
		t.integer		:par_value, :default=>0
		t.integer		:stock_value, :default=>0		
		t.integer		:treasury, :default=>0
		t.string		:status, :null=>false, :default=>"UNLAUNCHED"
		t.boolean		:or_finished, :default=>false
      	t.timestamps
    end
  end

  def self.down
    drop_table :corporations
  end
end
