print("Ragdoll Physics Loaded")
function OnEntered(Player)
	while Player.Character == nil do 
		wait()
	end
	wait(1)
	Player.Changed:connect(function(Property)
		if Property == "Character" then
			if Player.Character then
				local Mods = script:GetChildren()
				for X = 1, # Mods do
					if Mods[X].className == "Script" or Mods[X].className == "LocalScript" then
						local S = Mods[X]:Clone()
						S.Disabled = false
						S.Parent = Player.Character
					end
				end
			end
		end
	end)
	local Mods = script:GetChildren()
	for X = 1, # Mods do
		if Mods[X].className == "Script" or Mods[X].className == "LocalScript" then
			local S = Mods[X]:Clone()
			S.Disabled = false
			S.Parent = Player.Character
		end
	end
end
game.Players.ChildAdded:connect(OnEntered)
for _, player in pairs(game.Players:GetPlayers()) do OnEntered(player) end
