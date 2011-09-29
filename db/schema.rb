# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110929190407) do

  create_table "bids", :force => true do |t|
    t.integer  "player_id"
    t.integer  "bid_on_id"
    t.string   "bid_on_type"
    t.integer  "bid_amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bids", ["player_id", "bid_on_id", "bid_on_type"], :name => "bids_indx"

  create_table "corporations", :force => true do |t|
    t.integer  "player_id"
    t.string   "name",         :limit => 50,                           :null => false
    t.string   "group",        :limit => 1
    t.string   "tag_line"
    t.string   "bonus_type",   :limit => 4
    t.integer  "bonus_amount"
    t.integer  "max_bases",                  :default => 0
    t.integer  "max_refuels",                :default => 0
    t.integer  "max_claims",                 :default => 0
    t.integer  "max_ships",                  :default => 0
    t.integer  "par_value",                  :default => 0
    t.integer  "stock_value",                :default => 0
    t.integer  "treasury",                   :default => 0
    t.string   "status",                     :default => "UNLAUNCHED", :null => false
    t.boolean  "or_finished",                :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "corporations", ["player_id"], :name => "index_corporations_on_player_id"

  create_table "games", :force => true do |t|
    t.string   "game_code",         :limit => 6,                    :null => false
    t.boolean  "long_game",                      :default => true,  :null => false
    t.integer  "bank_amount",                    :default => 10000, :null => false
    t.string   "current_state",                  :default => "NEW", :null => false
    t.integer  "num_players",                    :default => 4
    t.integer  "round",                          :default => 1
    t.integer  "operating_round",                :default => 1
    t.integer  "first_player_id"
    t.integer  "current_player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "games", ["game_code"], :name => "index_games_on_game_code"

  create_table "independent_companies", :force => true do |t|
    t.integer  "ind_co_owner_id"
    t.string   "ind_co_owner_type"
    t.string   "name",              :limit => 50,                         :null => false
    t.string   "tag_line"
    t.integer  "starting_bid",                    :default => 100
    t.integer  "bonus_amount"
    t.string   "bonus_type",        :limit => 4
    t.integer  "max_ships",                       :default => 0
    t.integer  "max_claims",                      :default => 0
    t.integer  "number"
    t.integer  "treasury",                        :default => 100
    t.string   "status",                          :default => "UNBOUGHT", :null => false
    t.integer  "income",                          :default => 0
    t.boolean  "or_finished",                     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "independent_companies", ["ind_co_owner_id", "ind_co_owner_type"], :name => "ind_co_indx"

  create_table "players", :force => true do |t|
    t.integer  "game_id"
    t.string   "name",          :limit => 30,                     :null => false
    t.string   "username",      :limit => 30,                     :null => false
    t.integer  "cash_held",                    :default => 0,     :null => false
    t.string   "email",         :limit => 120,                    :null => false
    t.boolean  "activated",                    :default => false
    t.string   "motto"
    t.string   "password",      :limit => 30,                     :null => false
    t.boolean  "admin",                        :default => false
    t.boolean  "previous_pass",                :default => false
    t.integer  "player_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "players", ["game_id"], :name => "index_players_on_game_id"

  create_table "private_companies", :force => true do |t|
    t.integer  "priv_co_owner_id"
    t.string   "priv_co_owner_type"
    t.string   "name",               :limit => 50,                         :null => false
    t.string   "tag_line"
    t.integer  "income"
    t.integer  "number"
    t.integer  "starting_bid"
    t.string   "status",                           :default => "UNBOUGHT", :null => false
    t.boolean  "or_finished",                      :default => false
    t.boolean  "sell_to_corp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "private_companies", ["priv_co_owner_id", "priv_co_owner_type"], :name => "priv_co_indx"

end