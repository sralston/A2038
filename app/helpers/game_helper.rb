module GameHelper

	def init_initial_firms(game)
		# create the 12 initial firms for bidding at start of game
		# also, create Asteroid League & TSI for the shares
		
		# indipendent companies
		#1 -- Fast Buck
		i = game.independent_companies.build
		i.name = "Fast Buck"
		i.abbreviation = "FB"
		i.number = 1
		i.income = 15
		i.bonus_text = "*15 per operating round is placed into FB treasury."
		i.save
		
		#2 -- Ice Finder
		i = game.independent_companies.build
		i.name = "Ice Finder"
		i.abbreviation = "IF"
		i.number = 2
		i.bonus_type = "ICE"
		i.bonus_amount = 10
		i.bonus_text = "Must draw a second tile when exploring a hex if the first tile drawn has no Ice mines.  Bonus *10 for Ice."
		i.save
		
		#3 -- Drill Hound
		i = game.independent_companies.build
		i.name = "Drill Hound"
		i.abbreviation = "DH"
		i.number = 3
		i.bonus_type = "RARE"
		i.bonus_amount = 10
		i.bonus_text = "Must draw a second tile when exploring a hex if the first tile drawn has no Rare mines.  Bonus *10 for Rare."
		i.save
		
		#4 -- Ore Crusher
		i = game.independent_companies.build
		i.name = "Ore Crusher"
		i.abbreviation = "OC"
		i.number = 4
		i.bonus_type = "NICKEL"
		i.bonus_amount = 10
		i.bonus_text = "Bonus *10 for Nickel."
		i.save
		
		#5 -- Torch
		i = game.independent_companies.build
		i.name = "Torch"
		i.abbreviation = "T"
		i.number = 5
		i.bonus_text = "Its spaceship(s) have +1 Movement."
		i.save
		
		#6 -- Lucky
		i = game.independent_companies.build
		i.name = "Lucky"
		i.abbreviation = "L"
		i.number = 6
		i.bonus_text = "Draws two tiles when exploring a hex and then chooses which tile to place."
		i.save
		
		# need to create TSI & AL for the shares
		
		# creating AL
		c = game.corporations.build
		c.name = "Asteroid League"
		c.abbreviation = "AL"
		c.max_bases = 7
		c.max_refuels = 4
		c.max_claims = 15
		c.max_ships = 7
		c.par_value = 125
		c.treasury = 250
		c.group = "-"
		c.bonus_text = "May place 3 claims / round; 2nd claim costs *75 (3rd costs *100). Its last ship may not be bought. *250 initial capitalization."
		c.save

		# creating the AI 10% shares
		ai_shares = Array.new
		(0..7).each do |x|
			ai_shares[x] = c.shares.build
			ai_shares[x].save
		end
		# giving ownership of AI 10% shares to game
		game.shares << ai_shares
		
		#creating the AI 20% pres share
		ai_pres_share = c.shares.build
		ai_pres_share.share_type = "20% Pres Share"
		ai_pres_share.percent = 0.2
		ai_pres_share.save
		
		
		#creating TSI
		c = game.corporations.build
		c.name = "Trans-Space, Inc."
		c.abbreviation = "TSI"
		c.max_bases = 1
		c.max_refuels = 3
		c.max_claims = 10
		c.max_ships = 4
		game.long_game ? c.par_value = 100 : c.par_value = 67
		c.treasury = c.par_value * 10
		c.stock_value = c.par_value
		c.group = "-"
		c.bonus_text = "Receives Probe as one of its four initially allowed spaceships."
		c.save
		
		# creating the TSI 10% shares	
		tsi_shares = Array.new
		(0..7).each do |x|
			tsi_shares[x] = c.shares.build
			tsi_shares[x].save
		end
		
		# giving ownership of non-private company held shares to game
		tsiGameShares = Array.new(tsi_shares[3..7])
		game.shares << tsiGameShares
		
		#creating the TSI 20% pres share
		tsi_pres_share = c.shares.build
		tsi_pres_share.share_type = "20% Pres Share"
		tsi_pres_share.percent = 0.2
		tsi_pres_share.save

		
		# Private Companies

		#0 -- Planetary Imports
		p = game.private_companies.build
		p.name = "Planetary Imports"
		p.abbreviation = "PI"
		p.income = 10
		p.number = 0
		p.starting_bid = 50
		p.save
		
		#7 -- Tunnel Systems
		p = game.private_companies.build
		p.name = "Tunnel Systems"
		p.abbreviation = "TS"
		p.income = 5
		p.number = 7
		p.starting_bid = 120
		p.bonus_text = "Corp. may place 1 free Base on any explored and unclaimed tile.  Player receives one 10% TSI Share."
		p.save
		
			# Add free item	
			fi = FreeItem.create(:item_type => "BASE")
			p.free_item = fi
			# Add TSI 10% Share
			p.share = tsi_shares[0]
		
		#8 -- Vacuum Associates
		p = game.private_companies.build
		p.name = "Vacuum Associates"
		p.abbreviation = "VA"
		p.income = 10
		p.number = 8
		p.starting_bid = 140
		p.bonus_text = "Corp. may place 1 free Refueling Station within range.  Player receives one 10% TSI Share."
		p.save
		
			# Add free item	
			fi = FreeItem.create(:item_type => "REFUEL")
			p.free_item = fi
			# Add TSI 10% Share
			p.share = tsi_shares[1]
		
		#9 -- Robot Smelters
		p = game.private_companies.build
		p.name = "Robot Smelters"
		p.abbreviation = "RS"
		p.income = 15
		p.number = 9
		p.starting_bid = 120
		p.bonus_text = "Corp. may place 1 free Claim within range.  Player receives one 10% TSI Share."
		p.save
		
			# Add free item	
			fi = FreeItem.create(:item_type => "CLAIM")
			p.free_item = fi
			# Add TSI 10% Share
			p.share = tsi_shares[2]
		
		#10 -- Space Expl
		p = game.private_companies.build
		p.name = "Space Exploration Co."
		p.abbreviation = "SEC"
		p.income = 20
		p.number = 10
		p.starting_bid = 180
		p.bonus_text = "Flies Probe if TSI is inactive.  Remove SEC certificate after TSI Corp buys a ship.  Player receives TSI's 20% President share"
		p.sell_to_corp = false
		p.save				
		
			#add TSI 20% pres share
			p.share = tsi_pres_share
			
		#11 -- Asteroid Export Co
		p = game.private_companies.build
		p.name = "Asteroid Export Co."
		p.abbreviation = "AEC"
		p.income = 30
		p.number = 11
		p.starting_bid = 180
		p.bonus_text = "May start Asteroid League in Phase III; must start it in Phase IV.  Remove AEC certificate after AL acquires a spaceship.  Player receives AL's 20% President share"
		p.sell_to_corp = false
		p.save				
		
			#add TSI 20% pres share
			p.share = ai_pres_share
			
						
	end

end
