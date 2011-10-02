class CreateCorporations < ActiveRecord::Migration
  def self.up
    create_table :corporations do |t|
		t.references	:corp_owner, :polymorphic => true
		t.string		:name, :limit=>50, :null=>false
		t.string		:group, :limit=>1
		t.string		:tag_line, :limit=>255, :null=>true
		t.string		:bonus_type, :limit=>6, :null=>true
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
  		t.string		:abbreviation, :limit=>3, :null=>false
  		t.integer		:stock_price_order, :default=>1
  		t.string		:bonus_text, :limit=>255
      	t.timestamps
    end
    add_index	:corporations, [:corp_owner_id, :corp_owner_type], :name => "corp_own_indx"
    add_index	:corporations, :name
    add_index	:corporations, :abbreviation
  end

  def self.down
    drop_table :corporations
  end
end
