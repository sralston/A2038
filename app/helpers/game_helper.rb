module GameHelper

	def init_initial_firms(game)
		# create the 12 initial firms for bidding at start of game
		
		# indipendent companies
		#1 -- Fast Buck
		i = game.independent_companies.build
		i.name = "Fast Buck"
		i.abbreviation = "FB"
		i.number = 1
		i.income = 15
		i.bonus_text = "$15 per operating round is placed into FB treasury"
		i.save
		
		#2 -- Ice Finder
		i = game.independent_companies.build
		i.name = "Ice Finder"
		i.abbreviation = "IF"
		i.number = 2
		i.bonus_type = "ICE"
		i.bonus_amount = 10
		i.bonus_text = "Must draw a second tile when exploring a hex if the first tile drawn has no Ice mines"
		i.save
		
		#3 -- Drill Hound
		i = game.independent_companies.build
		i.name = "Drill Hound"
		i.abbreviation = "DH"
		i.number = 3
		i.bonus_type = "RARE"
		i.bonus_amount = 10
		i.bonus_text = "Must draw a second tile when exploring a hex if the first tile drawn has no Rare mines"
		i.save
		
		#4 -- Ore Crusher
		i = game.independent_companies.build
		i.name = "Ore Crusher"
		i.abbreviation = "OC"
		i.number = 4
		i.bonus_type = "NICKEL"
		i.bonus_amount = 10
		i.save
		
		#5 -- Torch
		i = game.independent_companies.build
		i.name = "Torch"
		i.abbreviation = "T"
		i.number = 5
		i.bonus_text = "Its spaceship(s) have +1 Movement"
		i.save
		
		#6 -- Lucky
		i = game.independent_companies.build
		i.name = "Lucky"
		i.abbreviation = "L"
		i.number = 6
		i.bonus_text = "Draws two tiles when exploring a hex and then chooses which tile to place"
		i.save
		
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
		p.save
		
		
		
	end

end
