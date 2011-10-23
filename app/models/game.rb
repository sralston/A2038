class Game < ActiveRecord::Base
	attr_accessible :long_game, :num_players

	has_many 	:players
	belongs_to	:first_player, :class_name=>"Player"
	belongs_to	:current_player, :class_name=>"Player"
	belongs_to	:bidding_war_first_player, :class_name=>"Player"
	has_many	:customers, :through => :players
	has_many	:corporations, :as => :corp_owner
	has_many	:private_companies, :as => :priv_co_owner
	has_many	:independent_companies, :as => :ind_co_owner
	has_many	:events
	#has_many	:locations
	has_many 	:shares, :as => :stock_owner
	#has_many	:ships, :as => :ship_owner
	
	def gain(money)
		self.bank_amount += money
		self.save
	end
		
	def spend(mone)
		self.bank_amount -= money
		# check to see if bank is broken
		self.save
	end
	
	def get_init_bid_company(co_num)
		company = nil
		if (co_num.between?(1,6))
			company = self.independent_companies.find_by_number(co_num)
		else
			company = self.private_companies.find_by_number(co_num)
		end
	end		

	def new_first_player(old_player)
		new_player = determine_next_player(old_player)
		Event.new_first_player(new_player)
		self.first_player = new_player
		self.save
	end
	
	def determine_next_player(old_player)
		n = self.num_players
		i = old_player.player_number
		new_player_number = (i+1)==n ? i+1 : (i+1)%n
		new_player = self.players.find_by_player_number(new_player_number)
		return new_player
	end

	def end_init_bidding()
		self.round = 1
		self.operating_round = 1
		self.save
	end
	
	def all_pass?
		return self.players.where("previous_pass = true").count == self.num_players
	end

end
