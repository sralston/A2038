class AddStatusToBids < ActiveRecord::Migration
  def self.up
  	add_column :bids, :active, :boolean, :default=>true
  end

  def self.down
  	remove_column :bids, :active
  end
end
