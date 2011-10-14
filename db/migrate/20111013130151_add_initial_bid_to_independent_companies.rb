class AddInitialBidToIndependentCompanies < ActiveRecord::Migration
  def self.up
  	add_column :independent_companies, :starting_bid, :integer, :default=>100
  end

  def self.down
  	remove_column :independent_companies, :starting_bid
  end
end
