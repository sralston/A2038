class AddBiddingWarCoNumberToGames < ActiveRecord::Migration
  def self.up
  	add_column :games, :bidding_war_co_num, :integer, :null=>true
  	add_column :games, :bank_broke, :boolean, :default=>false
  end

  def self.down
  	remove_column :games, :bidding_war_co_num
  end
end
