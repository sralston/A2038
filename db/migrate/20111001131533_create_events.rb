class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
    	t.references	:game
		t.string		:code, :limit=>100, :null=>false
		t.string		:text, :limit=>255
		t.integer		:value, :default=>0
		t.string		:regarding, :limit=>50
		
      	t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
