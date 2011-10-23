class ChangeBiddingWarColName < ActiveRecord::Migration
  def self.up
  	rename_column :games, :bidding_war_co_num, :bidding_war_first_player_id
  end

  def self.down
  	rename_column :games, :bidding_war_first_player_id, :bidding_war_co_num
  end
end
