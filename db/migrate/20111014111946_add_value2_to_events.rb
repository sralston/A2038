class AddValue2ToEvents < ActiveRecord::Migration
  def self.up
  	add_column :events, :value2, :integer, :null=>true
  end

  def self.down
  	remove_column :events, :value2
  end
end
