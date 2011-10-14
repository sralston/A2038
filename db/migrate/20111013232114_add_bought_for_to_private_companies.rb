class AddBoughtForToPrivateCompanies < ActiveRecord::Migration
  def self.up
  	add_column :private_companies, :bought_for, :integer, :null=>true
  end

  def self.down
  	remove_column :private_companies, :bought_for
  end
end
