class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
		t.string		:name, :limit => 30, :null => false
		t.string		:username, :limit => 15, :null => false
		t.string		:email, :limit => 120, :null => false
		t.string		:motto, :limit => 255, :null => true
		t.string		:salt
		t.string		:encrypted_password
		t.boolean		:admin, :default => false
        t.timestamps
    end
    add_index :customers, :username, :unique => true
  end

  def self.down
    drop_table :customers
  end
end
