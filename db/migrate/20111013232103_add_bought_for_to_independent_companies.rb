class AddBoughtForToIndependentCompanies < ActiveRecord::Migration
  def self.up
  	add_column :independent_companies, :bought_for, :integer, :null=>true
  end

  def self.down
  	remove_column :independent_companies, :bought_for
  end
end
