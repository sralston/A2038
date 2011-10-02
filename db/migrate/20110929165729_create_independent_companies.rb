class CreateIndependentCompanies < ActiveRecord::Migration
  def self.up
    create_table :independent_companies do |t|
		t.references	:ind_co_owner, :polymorphic => true
		t.string		:name, :null=>false, :limit=>50
		t.string		:tag_line, :limit=>255, :null=>true
		t.integer		:bonus_amount, :null=>true
		t.string		:bonus_type, :limit=>6, :null=>true
		t.integer		:max_ships, :default=>2
		t.integer		:max_claims, :default=>2
		t.integer		:number
		t.integer		:treasury, :default=>100
		t.string		:status, :null=>false, :default=>"UNBOUGHT"
		t.integer		:income, :default=>0
		t.boolean		:or_finished, :default => false
		t.string		:abbreviation, :limit=>3
  		t.string		:bonus_text, :limit => 255
      	t.timestamps
    end
    add_index		:independent_companies, :name
    add_index		:independent_companies, :abbreviation
    add_index		:independent_companies, [:ind_co_owner_id, :ind_co_owner_type], :name=>"ind_co_indx"
  end

  def self.down
    drop_table :independent_companies
  end
end
