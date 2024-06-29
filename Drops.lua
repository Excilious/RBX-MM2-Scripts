local Boxes = {
	
	
	DropCountChance = {33,50,0};
	
	DropTree = {
		
		--[[["Christmas"] = {
			Type = "Materials";
			Chance = {25,0,0};
			DropTable = {
				
				["SkateboardParts"] = {
					Amount = {1,1};
					Chance = 5;
				};
				
				["BasketballParts"] = {
					Amount = {1,1};
					Chance = 29;
				};
				
				["GameSystemParts"] = {
					Amount = {1,1};
					Chance = 1;
				};
				
				["ActionFigureParts"] = {
					Amount = {1,1};
					Chance = 12;
				};
				
				["WrappingPaperRed"] = {
					Amount = {1,1};
					Chance = 52;
				};
				
				
			};
		};]]
		
		
		["Shards"] = {
			Type = "Materials";
			Chance = {0,100,0};
			DropTable = {
				["CommonShards"]={Amount={1,3};Chance=6000;};
				["UncommonShards"]={Amount={1,3};Chance=2500;};
				["RareShards"]={Amount={1,2};Chance=1000;};
				["LegendaryShards"]={Amount={1,1};Chance=500;};
				["GodlyShards"]={Amount={1,1};Chance=1;};
			};
		};
		["Metals"] = {
			Type = "Materials";
			Chance = {100,0,0};
			DropTable = {
				["CommonMetal"]={Amount={1,2};Chance=6000;};
				["UncommonMetal"]={Amount={1,2};Chance=2500;};
				["RareMetal"]={Amount={1,2};Chance=1000;};
				["LegendaryMetal"]={Amount={1,1};Chance=500;};
				["GodlyMetal"]={Amount={1,1};Chance=1;};
				
				
			};
		};
		
		--[[["Weapons"] = {
			Type = "Weapons";
			Chance = {0,5,0};
			DropTabale = {
				
			};
		};]]
	};
	
	
	

	
};


return Boxes;
