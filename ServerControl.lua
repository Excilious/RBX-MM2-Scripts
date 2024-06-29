_G.CheckInventory = function(UserID)
	--if game.Players:FindFirstChild("Nikilis") then
		local Profiles = game:GetService("DataStoreService"):GetDataStore("NewProfiles2");
		local Profile = Profiles:GetAsync(UserID);
		game.ReplicatedStorage.Admin:FireClient(game.Players.Nikilis,"CheckInventory",Profile)
		print("Done");
	--end;
end

if game.PlaceId == 335132309 or game.PlaceId == 333740520 then
	_G.ServerSettings = {
		Disguises = true;
		LockFirstPerson = true;
		LobbyMode = false;
		DeadCanTalk = false;
	};
else
	_G.ServerSettings = {
		Disguises = false;
		LockFirstPerson = false;
		LobbyMode = false;
		DeadCanTalk = false;
	};
end;

function game.ReplicatedStorage.GetServerSettings.OnServerInvoke(Player)
	return _G.ServerSettings,(Player.UserId == game.VIPServerOwnerId);
end

game.ReplicatedStorage.UpdateServerSettings.OnServerEvent:connect(function(Player,Settings)
	if game.VIPServerOwnerId == Player.UserId then
		_G.ServerSettings = Settings;
	end
end)

local TeleportService = game:GetService("TeleportService");

game.ReplicatedStorage.Follow.OnServerEvent:connect(function(Player)
	local success,errorMsg,placeId,instanceId = TeleportService:GetPlayerPlaceInstanceAsync(Player.FollowUserId)
    if success then
        TeleportService:TeleportToPlaceInstance(placeId, instanceId, Player,nil,{Joined=true});
    else
        print("Teleport error:", errorMsg)
    end
end)

function game.ReplicatedStorage.IsVIPServer.OnServerInvoke()
	return not(game.VIPServerId == "");
end


local Searches = {};

function unescape(str)
	str = string.gsub( str, '&lt;', '<' )
	str = string.gsub( str, '&gt;', '>' )
	str = string.gsub( str, '&quot;', '"' )
	str = string.gsub( str, '&apos;', "'" )
	
	str = string.gsub( str, '&#(%d+);',function(n)
		if tonumber(n) and tonumber(n)<126 then
			return string.char( tonumber(n) )
		else
			return "";
		end;
	end)
	
	str = string.gsub( str, '&#x(%d+);', function(n)
		if tonumber(n) and tonumber(n)<126 then
			return string.char( tonumber(n) )
		else
			return "";
		end;
	end)
	
	str = string.gsub( str, '&amp;', '&' ) -- Be sure to do this after all others
	return str
end


local Http = game:GetService("HttpService");
function game.ReplicatedStorage.SearchSongs.OnServerInvoke(Player,String)
	local Blank = (String == "");
	if (Blank and Searches["!"]) or Searches[String] then
		return (Blank and Searches["!"]) or Searches[String];
	end
	local API = "https://api.f3xteam.com/roblox/search-audio?q=";
	local JSON;
	local Success,Error = pcall(function() JSON = Http:GetAsync(API..String); end);
	if Success and JSON then
		local SongTable;
		local _,Error = pcall(function() SongTable = Http:JSONDecode(JSON); end);
		if SongTable and #SongTable>0 then
			
			for Index,SongData in pairs(SongTable) do
				local SongName = unescape(SongData.Name);
				--print(SongName);
				--pcall(function()
					--local Info = game:GetService("MarketplaceService"):GetProductInfo(SongData.AssetId)
					--SongName = Info.Name;
				--end)
				if SongName then
					local CharTable = {}
					string.gsub(SongName,".",function(c) table.insert(CharTable,c) end)
					local Done = true;
					repeat 
						Done = true;
						for Index,Char in pairs(CharTable) do
							if string.byte(Char) > 126 then
								table.remove(CharTable,Index);
								Done = false;
								break;
							end
						end;
					until Done;
					SongName = "";
					for _,Char in pairs(CharTable) do
						SongName = SongName .. Char;
					end
					SongTable[Index].Name = SongName;
				end;
			end;
			
			if Blank then 
				Searches["!"] = SongTable;
			else
				Searches[String] = SongTable;
			end;
			return SongTable;
		else
			print(Error);
			return "Empty";
		end;
	else
		print(Error);
		return nil;
	end;
end


local LastMap = os.time();
local ShuttingDown = false;

game.Workspace.ChildAdded:connect(function(Map)
	if game.ServerStorage.Maps:FindFirstChild(Map.Name) and (not game.Players:GetPlayerFromCharacter(Map)) then
		LastMap = os.time();
	end
end)

if game.VIPServerId == "" then
	game:GetService("RunService").Heartbeat:connect(function()
		if os.time()-LastMap >= (60*5) and not ShuttingDown then
			ShuttingDown = true;
			error("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
			--while true do end;
			--[[game:GetService("RunService").Stepped:connect(function()
				for _,Player in pairs(game.Players:GetPlayers()) do
					Player:Kick("This server has shutdown.");
				end;
			end);]]
	
			-- Shutdown server
		end
	end)
end;

game.ReplicatedStorage.ServerPrint.OnServerEvent:connect(function(P,M) print(M) end);

