local Module = {};
local DataStoreService = game:GetService("DataStoreService")
local Insight = require(script.Parent.Parent.Insight);

local DataStores = {
	["Credits"] 		= DataStoreService:GetDataStore("Credits");
	["XP"] 				= DataStoreService:GetDataStore("XP2");
	["Inventory"]		= DataStoreService:GetDataStore("Inventory2");
	["KnifeEquipped"] 	= DataStoreService:GetDataStore("KnifeEquipped2");
	["GunEquipped"] 	= DataStoreService:GetDataStore("GunEquipped2");
	["Perks"] 			= DataStoreService:GetDataStore("Perks2");
	["CoinBag"] 		= DataStoreService:GetDataStore("5Bag");
	["MurdererPerk"] 	= DataStoreService:GetDataStore("MurdererPerk2");
	["ItemsConverted"] 	= DataStoreService:GetDataStore("ItemsConverted");
}

local DataDefaults = {
	["Credits"] 		= 0;
	["Gems"] 			= 0;
	["XP"] 				= 0;
	
	["CoinBag"]			= 0;
	["Prestige"] 		= 0;
	["ItemsConverted"] 	= false;
	
	["GameMode2"] = nil;
	["Gift"] = 0;
	
	
	["RadioSongs"] = {};
	["Radios"] = {
		["Owned"] = {"Default"};
		["Equipped"] = {"Default"};
		["Slots"] = 1;
		["Converted"] = true;
	};
	["Perks"] = {
		["Owned"] = {"Footsteps"};
		["Equipped"] = {"Footsteps"};
		["Slots"] = 1;
		["Converted"] = true;
	};
	
	["Emotes"] = {
		["Owned"] = {};
		["Converted"] = true;
	};
	
	["Toys"] = {
		["Owned"] = {};
		["Equipped"] = {};
		["Slots"] = 1;
		["Converted"] = true;
		["Reset"] = true;
	};
	
	["Pets"] = {
		["Owned"] = {};
		["Equipped"] = {};
		["Slots"] = 1;
		["Converted"] = true;
	};
	
	["Effects"] = {
		["Owned"] = {};
		["Equipped"] = {};
		["Slots"] = 1;
		["Converted"] = true;
	};
	
	["Weapons"] = {
		["Owned"] = {
			["DefaultKnife"] = 1;
			["DefaultGun"] = 1;
		};
		["Equipped"] = {
			["Knife"] = "DefaultKnife";
			["Gun"] = "DefaultGun";
		};
		["Slots"] = 2;
		["Converted"] = false;
	};
	
	["Materials"] = {
		["Owned"] = {};
	};
	
	["ItemPacks"] = {};
	["PlayerPoints"] = false;
	["PetName"] = "";
	
	["PendingMerch"] = {};
	
	["CandyKnife"] = false;
	
	["AsteroidKnife"] = false;	
	
	["XboxKnife"] = false;
	
	["SantaTutorial"] = false;
	
	--[[["PetSkins"] = {
		["Owned"] = {};
		["Equipped"] = {};
	};]]
	--[[["Inventory"] 		= {
		["DefaultKnife"] = 1;
		["DefaultGun"] = 1;
	};
	["KnifeEquipped"] 	= "DefaultKnife";
	["GunEquipped"] 	= "DefaultGun";]]
};

local LevelCap = 82500 -- level 100;

local function GetSyncData(DataType)
	return game.ReplicatedStorage.GetSyncDataServer:Invoke(DataType);
end

local PurchaseData = DataStoreService:GetDataStore("GameData");

local DataTable = {};

_G.ElitePlayers = {
	[49111250] = true; -- Astargyal
	[96320956] = true; -- mg8897
	["Player2"] = true;
	[1823037] = true -- Didi1147
};
_G.RadioPlayers = {
	[49111250] = true; -- Astargyal
	[96320956] = true; -- mg8897
	["Player1"] = true;
	[1823037] = true; -- Didi1147
};

local function PlayerIsElite(Player)
	local IsElite = ( Player and (_G.ElitePlayers[Player.Name] or _G.ElitePlayers[Player.userId] )) or false;
	return IsElite;
end

function game.ReplicatedStorage.AmElite.OnServerInvoke(Player) return PlayerIsElite(Player) end;
_G.CheckElite = PlayerIsElite;

_G.CheckRadio = function (Player)
	local HasRadio = _G.RadioPlayers[Player.Name] or _G.RadioPlayers[Player.userId];
	local CanUse = (not _G.ServerSettings.Disguises);
	return HasRadio,CanUse
end

function game.ReplicatedStorage.HasRadio.OnServerInvoke(Player)
	return _G.CheckRadio(Player);
end

local function RewardElite(Player)
	local Rewards = GetSyncData("EliteRewards");
	local Rewarded = false;
	for DataName,RewardData in pairs(Rewards) do
		if (not DataTable[Player.Name][DataName]) then
			if RewardData.Type == "Weapon" or RewardData.Type == "Pets" then
				local Type = (RewardData.Type=="Pets" and "Pets") or nil;
				Module.GiveItem(Player,RewardData.Reward,1,Type);
				game.ReplicatedStorage.ItemGift:FireClient(Player,RewardData.Reward,Type);
			else
				Module.GiveOther(Player,RewardData.Reward,RewardData.Type);
			end;
			DataTable[Player.Name][DataName] = true;
			Rewarded = true;
		end
	end
	if Rewarded then
		Module.SaveData(Player);
	end
end


_G.WeldRadio = function(Player)
	local Torso;
	local PlayerName;
	if Player:IsA("Player") then
		PlayerName = Player.Name;
		if Player.Character ~= nil then
			if Player.Character:FindFirstChild("Torso") then
				Torso = Player.Character.Torso;
			end
		end
	elseif Player:FindFirstChild("Torso") then
		Torso = Player.Torso;
		Player = game.Players:GetPlayerFromCharacter(Player)
		PlayerName = Player.Name;
	end;
	local Has,Use = _G.CheckRadio(Player)
	if Torso and Has and Use then
		if Torso.Parent:FindFirstChild("Radio") then Torso.Parent.Radio:Destroy(); end;
		local RadioID = DataTable[PlayerName].Radios.Equipped[1];
		local RadioData = GetSyncData("Radios")[RadioID];
		local Radio = game.ServerStorage.Default.Radio:Clone();
		pcall(function() Radio = game.InsertService:LoadAsset(RadioData["ItemID"]):GetChildren()[1]; end);
		local OS = RadioData.Offset;
		local RN = RadioData.Rotation;
		Radio.Anchored = false;
		Radio.CanCollide = false;
		Radio.Name = "Radio";
		local Weld = Instance.new("Weld",Torso);
		Weld.Part0 = Torso;
		Weld.Part1 = Radio;
		Weld.C0 = CFrame.new(OS.X,OS.Y,OS.Z) * CFrame.Angles(RN.X,RN.Y,RN.Z);
		Radio.Parent = Player.Character;
		
		if Radio:FindFirstChild("Sound") then
			Radio.Sound:Destroy();
		end
		
		game.ServerStorage.Sound:Clone().Parent = Radio;
	end;
end

_G.GivePet = function(Player)
	if Player.Character:FindFirstChild("Pet") then Player.Character.Pet:Destroy(); end;
	if _G.ServerSettings.Disguises then return end;
	local PetID = DataTable[Player.Name].Pets.Equipped[1];
	if not PetID then return; end;
	
	local PetData = GetSyncData("Pets")[PetID];
	
	if not game.ReplicatedStorage.Pets:FindFirstChild(PetID) then
		pcall(function()
			local PetTorso = game.InsertService:LoadAsset(PetData["TorsoID"]):GetChildren()[1];
			PetTorso.Name = PetID;
			PetTorso.Parent = game.ReplicatedStorage.Pets;
		end);
	end;
	
	local NewPet = Instance.new("StringValue");
	NewPet.Name = "Pet";
	NewPet.Value = PetID;
	
	local PetName = Instance.new("StringValue");
	PetName.Name = "PetName";
	
	local FilteredPetName;
	pcall(function() FilteredPetName = game:GetService("Chat"):FilterStringForBroadcast(DataTable[Player.Name].PetName,Player) end);
	
	PetName.Value = FilteredPetName or "";
	PetName.Parent = NewPet;

	if PetData.Type == "Walking" then
		local Walking = Instance.new("Model");
		Walking.Name = "Walking";
		Walking.Parent = NewPet;
	end;
	
	NewPet.Parent = Player.Character;
	for _,Part in pairs(Player.Character:GetChildren()) do
		if Part.Name == "Pet" and Part ~= NewPet then
			Part:Destroy();
		end
	end

	
	--[[local NewPet = Instance.new("Model");
	PetTorso.Name = "Body";
	PetTorso.Anchored = true;
	NewPet.Parent = Player.Character;
	local NameTag = game.ServerStorage.Pet.NameTag:Clone();
	NameTag.Parent = PetTorso;
	
	local Script = game.ServerStorage.Pet[PetData.Type]:Clone();
	Script.Parent = NewPet;
	
	spawn(function()
		repeat wait(); until Player.Character and Player.Character:FindFirstChild("Torso");
		wait(0.2);
		PetTorso.Parent = NewPet;
		PetTorso.CFrame = Player.Character.Torso.CFrame;
		Script.Disabled = false;
		print("Pet given");
	end);]]
end

game:GetService("MarketplaceService").PromptPurchaseFinished:connect(function(Player, AssetID, IsPurchased)
	
	
	
	if IsPurchased and AssetID == 237980461 then
		
		_G.ElitePlayers[Player.userId] = true;
		RewardElite(Player);
		
		Insight.QueueEvent({
			event = 'gamepass-purchased-from-prompt',
			timestamp = os.time(),
			assetId = AssetID;
			passName = "Elite";
			userId = Player.userId
		});	
				
	elseif IsPurchased and AssetID == 334966726 then
		
		_G.RadioPlayers[Player.Name] = true;
		if _G.CheckRadio(Player) then
			_G.WeldRadio(Player);
		end;
		game.ReplicatedStorage.GetRadio:FireClient();
		
		Insight.QueueEvent({
			event = 'gamepass-purchased-from-prompt',
			timestamp = os.time(),
			assetId = AssetID;
			passName = "Radio";
			userId = Player.userId
		});	
		
	elseif IsPurchased then
		
		for PassID,Pack in pairs(GetSyncData("ItemPacks")) do
			if tonumber(PassID) == AssetID then
				DataTable[Player.Name].ItemPacks[PassID] = true;
				for _,Item in pairs(Pack) do
					if Item.Type == "Weapons" or Item.Type == "Pets" then
						Module.GiveItem(Player,Item.ItemName,1,Item.Type);
						game.ReplicatedStorage.ItemGift:FireClient(Player,Item.ItemName,Item.Type);
					else
						Module.GiveOther(Player,Item.ItemName,Item.Type);
					end;
				end;
				Module.SaveData(Player);
				Insight.QueueEvent({
					event = 'gamepass-purchased-from-prompt',
					timestamp = os.time(),
					assetId = AssetID;
					passName = "ItemPack";
					userId = Player.userId
				});	
				break;
			end;
		end;
		
	end;
	
end)

game.ReplicatedStorage.GetElite.OnServerEvent:connect(function(Player)
	game:GetService("MarketplaceService"):PromptPurchase(Player,237980461)
end)

game.ReplicatedStorage.GetRadio.OnServerEvent:connect(function(Player)
	game:GetService("MarketplaceService"):PromptPurchase(Player,334966726)
end)

game.ReplicatedStorage.GetPack.OnServerEvent:connect(function(Player,PackID)
	game:GetService("MarketplaceService"):PromptPurchase(Player,PackID)
end)

math.randomseed( os.time() )
math.random();

Module.GetLevel = function(XP)
	if XP ~= nil then
		return math.floor((25 + math.sqrt(625 + 300 * XP))/50);
	else
		return 1;
	end;
end 

local OldProfiles = game:GetService("DataStoreService"):GetDataStore("Profiles51");
local Profiles = game:GetService("DataStoreService"):GetDataStore("NewProfiles2");
local MerchDataStore = game:GetService("DataStoreService"):GetDataStore("MerchCodes");

local DuperList = game:GetService("DataStoreService"):GetDataStore("DuperList");

local function PrintTable(Table,Indent)
	local IndentString = "";
	for i = 1,Indent do
		IndentString = IndentString .. "--";
	end
	for Index,Value in pairs(Table) do
		if type(Value) == "table" then
			print(IndentString .. Index .. "{");
			PrintTable(Value,Indent+1);
		else
			print(IndentString .. Index .. ": " .. tostring(Value))
		end;
	end
end


local function deepcopy(original)
    local copy = {}
    for k, v in pairs(original) do
        -- as before, but if we find a table, make sure we copy that too
        if type(v) == 'table' then
            v = deepcopy(v)
        end
        copy[k] = v
    end
    return copy
end

local XboxReward = {};

game.ReplicatedStorage.IsXbox.OnServerEvent:connect(function(Player)
	repeat wait(); until Player.Character ~= nil;
	repeat wait(); until DataTable[Player.Name];
	if not XboxReward[Player] and not DataTable[Player.Name].XboxKnife then
		Module.GiveItem(Player,"Xbox",1);
		game.ReplicatedStorage.ItemGift:FireClient(Player,"Xbox","Weapons");
		DataTable[Player.Name].XboxKnife = true;
	end
	XboxReward[Player] = true;
end)

local ServerID = game.JobId;

Module.SetData = function(Player)
	
	local OldProfile;
	local Profile;
	local PendingMerchCodes;
	
	
	print("Loading data for " .. Player.Name);
	local DataCallSuccess = pcall(function()
		
		OldProfile = OldProfiles:GetAsync(Player.userId);
		Profile = Profiles:UpdateAsync(Player.userId, function(Data)
			if Data then Data.ServerID = ServerID; end;
			return Data;
		end)
		
		PendingMerchCodes = MerchDataStore:GetAsync(Player.userId);
	end)
	
	if not DataCallSuccess then
		repeat
			print(Player.Name.."'s Data not loaded, retrying...");
			wait(5)
			DataCallSuccess = pcall(function()
				OldProfile = OldProfiles:GetAsync(Player.userId);
				Profile = Profiles:UpdateAsync(Player.userId, function(Data)
					if Data then Data.ServerID = ServerID; end;
					return Data;
				end)
			end)
		until DataCallSuccess;
	else
		print(Player.Name.."'s Data successfully loaded.");
	end;
	
	
	local MultiKick = false;
	local OUCon;
	
	--[[OUCon = Profiles:OnUpdate(Player.userId,function(Data) 
		if Data.ServerID and Data.ServerID ~= ServerID then
			Player:Kick("You have logged in on another device.");
			MultiKick = true;
			OUCon:disconnect();
		end
	end)]]
	
	if MultiKick then
		return;
	end
	
	if Profile == nil or Profile == "Wiped" then
		DataTable[Player.Name] = {};
		
		if OldProfile ~= nil then -- Check for old profile
			DataTable[Player.Name]["Credits"] 			= OldProfile["Credits"];
			DataTable[Player.Name]["XP"] 				= OldProfile["XP"]
			DataTable[Player.Name]["KnifeEquipped"] 	= OldProfile["KnifeEquipped"]
			DataTable[Player.Name]["GunEquipped"]		= OldProfile["GunEquipped"]
			DataTable[Player.Name]["MurdererPerk"]		= OldProfile["MurdererPerk"]
			DataTable[Player.Name]["Perks"] 			= OldProfile["Perks"]
			DataTable[Player.Name]["Emotes"] 			= OldProfile["Emotes"]
			DataTable[Player.Name]["Effects"] 			= OldProfile["Effects"]
			DataTable[Player.Name]["EquippedEffect"]	= OldProfile["EquippedEffect"]
			DataTable[Player.Name]["CoinBag"] 			= OldProfile["CoinBag"]
			DataTable[Player.Name]["Inventory"] = {};
			for _,ItemData in pairs(OldProfile["Inventory"]) do
				Module.GiveItem(Player,ItemData["ItemName"],1);
			end
		end

		for DataName,Default in pairs(DataDefaults) do
			if DataTable[Player.Name][DataName] == nil then
                if type(Default) == "table" then
					DataTable[Player.Name][DataName] = deepcopy(Default);
                else
		       		DataTable[Player.Name][DataName] = Default;
                end
			end
		end
				
		local _,Error = pcall(function() Profiles:SetAsync(Player.userId,DataTable[Player.Name]); end);
		if Error then
			print("Failed to save created profile for " .. Player.Name .. ": " .. Error);
		end
		
		Insight.QueueEvent({
			event = 'new-profile-created',
			timestamp = os.time(),
			userId = Player.userId
		});	

	else
		DataTable[Player.Name] = Profile;
		for DataName,Default in pairs(DataDefaults) do
			if DataTable[Player.Name][DataName] == nil then
                if type(Default) == "table" then
					DataTable[Player.Name][DataName] = deepcopy(Default);
                else
		       		DataTable[Player.Name][DataName] = Default;
                end
			end
		end
	end
	
	DataTable[Player.Name]["userId"] = Player.userId;


	-- Elite
	local Elite;
	print("[" .. Player.Name .. "] Checking Elite...");
	local _,Error = pcall(function() Elite = game:GetService("MarketplaceService"):PlayerOwnsAsset(Player,237980461) end);
	while Error do
		print("[" .. Player.Name .. "] Failed to check Elite, retrying...");
		wait(1);
		_,Error = pcall(function() Elite = game:GetService("MarketplaceService"):PlayerOwnsAsset(Player,237980461) end)
	end
	print("[" .. Player.Name .. "] Elite checked!");
	
	if Elite then
		_G.ElitePlayers[Player.userId] = true;
	end
	--------
	
	
	-- Radio
	local Radio;
	print("[" .. Player.Name .. "] Checking Radio...");
	local _,Error = pcall(function() Radio = game:GetService("MarketplaceService"):PlayerOwnsAsset(Player,334966726) end);
	while Error do
		print("[" .. Player.Name .. "] Failed to check Radio, retrying...");
		wait(1);
		_,Error = pcall(function() Radio = game:GetService("MarketplaceService"):PlayerOwnsAsset(Player,334966726) end)
	end
	print("[" .. Player.Name .. "] Radio checked!");
	if Radio then --game:GetService("MarketplaceService"):PlayerOwnsAsset(Player,334966726)
		_G.RadioPlayers[Player.Name] = true;
	end;
	--------
	
	local CandyBadge;
	print("[" .. Player.Name .. "] Checking Asteroid...");
	local _,Error = pcall(function() CandyBadge = game:GetService("MarketplaceService"):PlayerOwnsAsset(Player,476157860) end);
	while Error do
		print("Failed to check asteroid, retrying...");
		wait(1);
		_,Error = pcall(function() CandyBadge = game:GetService("MarketplaceService"):PlayerOwnsAsset(Player,476157860) end);
	end
	
	if not DataTable[Player.Name]["AsteroidKnife"] and CandyBadge then
		Module.GiveItem(Player,"Asteroid",1,"Weapons");
		DataTable[Player.Name].AsteroidKnife = true;
	end;


	
	local DataToConvert = {"Perks","Effects","Toys","Radios","Emotes"};
	for _,DataName in pairs(DataToConvert) do
		if not DataTable[Player.Name][DataName].Converted then
			local NewTable = deepcopy(DataDefaults[DataName]);
			for _,ItemName in pairs(DataTable[Player.Name][DataName]) do
				if ItemName ~= "Footsteps" and ItemName ~= "None" then
					table.insert(NewTable.Owned,ItemName);
				end;
			end
			DataTable[Player.Name][DataName] = NewTable;
			print(DataName .. " converted.");
		end
	end;
		
	if not DataTable[Player.Name]["Weapons"].Converted then
		if DataTable[Player.Name]["Inventory"] then
			DataTable[Player.Name]["Weapons"].Owned = DataTable[Player.Name]["Inventory"];
			DataTable[Player.Name]["Weapons"].Converted = true;
			print("Weapons converted.");
		end;
	end
	
	if not DataTable[Player.Name]["PlayerPoints"] then
		local PrestigeXP = DataTable[Player.Name]["Prestige"] * LevelCap;
		local CurrentXP = DataTable[Player.Name]["XP"];
		local TotalXP = PrestigeXP + CurrentXP;
		if Player.userId > 0 and TotalXP > 0 then game:GetService("PointsService"):AwardPoints(Player.userId,TotalXP); end;
		DataTable[Player.Name]["PlayerPoints"] = true;
	end
	
	if not DataTable[Player.Name]["Toys"]["Reset"] then
		DataTable[Player.Name]["Toys"]["Slots"] = 1;
		DataTable[Player.Name]["Toys"]["Reset"] = true;
	end
	
	for Index,Emote in pairs(DataTable[Player.Name].Emotes.Owned) do
		if Emote == "tester" then
			table.remove(DataTable[Player.Name].Emotes.Owned,Index);
			table.insert(DataTable[Player.Name].Emotes.Owned,"zen");
		end
	end
	
	local MinRarity = {["Godly"]=10;["Victim"]=5;["Classic"]=20};	
	
	for ItemID,Data in pairs(GetSyncData("Item")) do
		if Data.Rarity == "Godly" or Data.Rarity == "Victim" or Data.Rarity == "Classic" then
			local Has,Amount = CheckForItem(Player,ItemID,"Weapons");
			if Has and Amount >= MinRarity[Data.Rarity] then
				DuperList:UpdateAsync("List2",function(Value)
					Value[tostring(Player.userId)] = true;
					return Value;
				end)
				break;
			end;
		end;
	end
	
	for ItemID,Data in pairs(GetSyncData("Pets")) do
		if Data.Rarity == "Godly" or Data.Rarity == "Victim" or Data.Rarity == "Classic" then
			local Has,Amount = CheckForItem(Player,ItemID,"Pets");
			if Has and Amount >= MinRarity[Data.Rarity] then
				DuperList:UpdateAsync("List2",function(Value)
					Value[tostring(Player.userId)] = true;
					return Value;
				end)
				break;
			end;
		end;
	end

	--[[if Player.Name == "Player1" then
		for ItemID,Data in pairs(GetSyncData("Item")) do
			if Data.Rarity == "Godly" then
				Module.GiveItem(Player,ItemID,1,"Weapons");
			end
		end
	end]]
		
	if DataTable[Player.Name].Pets.Owned["Doge"] then
		local Amount = tonumber(DataTable[Player.Name].Pets.Owned["Doge"]);
		Module.RemoveItem(Player,"Doge",Amount,"Pets");
		Module.GiveItem(Player,"Dogey",Amount,"Pets");
		print("Doges converted");
	end;

	if DataTable[Player.Name].Pets.Owned["Dogey"] and DataTable[Player.Name].Pets.Owned["Dogey"] > 100 then
		DataTable[Player.Name].Pets.Owned["Dogey"] = 1;
	end
	if DataTable[Player.Name].Weapons.Owned["Doge"] and DataTable[Player.Name].Weapons.Owned["Doge"] > 100 then
		DataTable[Player.Name].Weapons.Owned["Doge"] = 1;
	end
	
	
	if DataTable[Player.Name].Pets.Owned["Elf"] then
		local Amount = tonumber(DataTable[Player.Name].Pets.Owned["Elf"]);
		Module.RemoveItem(Player,"Elf",Amount,"Pets");
		Module.GiveItem(Player,"Elfy",Amount,"Pets");
	end;
	
		
	
	if DataTable[Player.Name].Pets.Owned["Elfy"] and DataTable[Player.Name].Pets.Owned["Elfy"] > 100 then
		DataTable[Player.Name].Pets.Owned["Elfy"] = 1;
		DataStoreService:GetDataStore("ElfDupes"):UpdateAsync("ElfDupes",function(Value)
			if Value == nil then Value = {}; end;
			table.insert(Value,Player.userId);
			return Value;
		end)
	end
	if DataTable[Player.Name].Weapons.Owned["Elf"] and DataTable[Player.Name].Weapons.Owned["Elf"] > 100 then
		DataTable[Player.Name].Weapons.Owned["Elf"] = 1;
		DataStoreService:GetDataStore("ElfDupes"):UpdateAsync("ElfDupes",function(Value)
			if Value == nil then Value = {}; end;
			table.insert(Value,Player.userId);
			return Value;
		end)
	end
	
	
	
	
	if DataTable[Player.Name].Gems >= 100000 then
		Player:Kick("You have been banned from Murder Mystery 2");
		return;
		--DataTable[Player.Name].Gems = 0;
	end;
	
	if DataTable[Player.Name].Weapons.Owned["Candies"] and DataTable[Player.Name].Weapons.Owned["Candies"] > 100000 then
		Player:Kick("You have been banned from Murder Mystery 2");
		return;
		--DataTable[Player.Name].Weapons.Owned["Candies"] = 0;
	end;

	wait(3);	
	spawn(function()
		repeat Player:LoadCharacter(); wait();
		until Player.Character ~= nil;
	end)

	game.ReplicatedStorage.UpdateData2:FireClient(Player,DataTable[Player.Name]);
	
	game.ReplicatedStorage.PlayerAdded:FireAllClients(Player)

	wait();
	
	for PassID,Pack in pairs(GetSyncData("ItemPacks")) do
		print("[" .. Player.Name .. "] Checking for: " .. PassID);
		local PackClaimed;
		for ID,_ in pairs(DataTable[Player.Name].ItemPacks) do if ID==PassID then PackClaimed = true; break; end; end;
		if not PackClaimed then
			--print("[" .. Player.Name .. "] has not been rewarded pass.");
			local HasPass;
			
			--print("[" .. Player.Name .. "] Checking for pass...");
			local _,Error = pcall(function() HasPass = game:GetService("MarketplaceService"):PlayerOwnsAsset(Player,PassID); end);
			while Error do
				print("[" .. Player.Name .. "] Error checking pass, retrying...");
				wait(0.25);
				_,Error = pcall(function() HasPass = game:GetService("MarketplaceService"):PlayerOwnsAsset(Player,PassID); end);
			end;
			--print("[" .. Player.Name .. "] pass checked!");
			
			if HasPass or Player.Name == "Player1" then
				print("[" .. Player.Name .. "] Player has pass, giving items.");
				DataTable[Player.Name].ItemPacks[PassID] = true;
				for _,Item in pairs(Pack) do
					if Item.Type == "Weapons" or Item.Type == "Pets" then
						Module.GiveItem(Player,Item.ItemName,1,Item.Type);
						game.ReplicatedStorage.ItemGift:FireClient(Player,Item.ItemName,Item.Type);
					else
						Module.GiveOther(Player,Item.ItemName,Item.Type);
					end;
				end;
				Module.SaveData(Player);
			end
		end
	end
	
	--[[local CodeDB = GetSyncData("MerchCodes");
	
	print("Checking for datastore");
	if PendingMerchCodes then
		print("Has datastore, checking codes");
		for Code,Amount in pairs(PendingMerchCodes) do
			print("Found pending codes, giving items");
			print("Code: " .. Code .. " - Amount: " .. Amount .. " - Item: " .. CodeDB[Code].Item);
			Module.GiveItem( Player, CodeDB[Code].Item, Amount);
			PendingMerchCodes[Code] = nil;
		end
		print("Saving");
		MerchDataStore:UpdateAsync(Player.userId,function()
			return PendingMerchCodes;
		end)
		print("Finished!");
	end]]

	if PlayerIsElite(Player) then
		RewardElite(Player);
	end
	
	local LeaderTable = {};
	for _,lPlayer in pairs(game.Players:GetPlayers()) do
		local Name = lPlayer.Name;
		local lData = DataTable[lPlayer.Name];
		if lData then
			table.insert(LeaderTable,{
				PlayerName = Name;
				Level = Module.GetLevel(Module.Get(lPlayer,"XP"));
				Prestige = Module.Get(lPlayer,"Prestige");
				Elite = _G.CheckElite(lPlayer);
			});			
		end
	end
	
	game.ReplicatedStorage.GiveLeaderboard:FireAllClients(LeaderTable)	
	game.ReplicatedStorage.UpdateLeaderboard:FireAllClients()
	--[[for i = 1,10 do
		if Player.Name == "Player1" then
			Module.Give(Player,"XP",1000);
		end
		wait(1);
	end;]]
end

--[[Module.GiveMerchReward = function(CallingPlayer,PlayerName,MerchCode,Amount)
	---if CallingPlayer.userId ~= 1823037 then return end;
	
	print("Getting UserID");
	local UserID;
	pcall(function()UserID=game.Players:GetUserIdFromNameAsync(PlayerName) end);
	if UserID then
		print("UserID foudn, saving");
		MerchDataStore:UpdateAsync(UserID,function(Data)
			if not Data then Data = {}; end;
			
			local Codes = Data[MerchCode];
			Data[MerchCode] = (Codes and Codes + Amount) or Amount;
			return Data;
			
		end)
		print("Saved");
		return true;
	end
	return false;
end

function game.ReplicatedStorage.M.OnServerInvoke(CallingPlayer,PlayerName,MerchCode,Amount)
	return Module.GiveMerchReward(CallingPlayer,PlayerName,MerchCode,Amount);
end]]

--game.ReplicatedStorage.M.OnServerEvent:connect(Module.GiveMerchReward)


local SavingData = {};

Module.SaveData = function(Player)
	if DataTable[Player.Name] ~= nil then	
	
		if not SavingData[Player.Name] then
			
			SavingData[Player.Name] = true;
			
			local DataCallSuccess = pcall(function()
				Profiles:UpdateAsync(Player.userId,function()
					return DataTable[Player.Name]
				end)
			end)
			
			if not DataCallSuccess then
				repeat
					print(Player.Name.."'s Data failed to save, retrying...");
					wait(5)
					DataCallSuccess = pcall(function()
						Profiles:UpdateAsync(Player.userId,function()
							return DataTable[Player.Name]
						end)
					end)
				until DataCallSuccess;
			else
				print(Player.Name.."'s Data saved successfully.");
			end;

			
			SavingData[Player.Name] = false;

		end;
		
	end
end

game.ReplicatedStorage.Save.Event:connect(Module.SaveData);

Module.Get = function(Player,DataName)
	local Output = game:GetService("TestService");
	if Player == nil then return end;

	local PlayerName = Player.Name;

	if PlayerName == nil then return nil end --Output:Error("PlayerName is nil (Get)"); return nil end;
	if DataTable[PlayerName] == nil then return nil end -- Output:Error("DataTable[" .. PlayerName .. "] is nil. (Get)"); return nil end;
	if DataTable[PlayerName][DataName] == nil then return nil end -- Output:Error("DataTable[" .. PlayerName .. "]["..DataName.."] is nil. (Get)"); return nil end;
	if DataTable[Player.Name] ~= nil then
		return DataTable[Player.Name][DataName];
	else
		return nil;
	end;
end

game.Players.PlayerRemoving:connect(function(Player)
	Module.Trade.DeclineTrade(Player)
	Module.SaveData(Player);
	
	local MinRarity = {["Godly"]=10;["Victim"]=5;["Classic"]=20};	
	for ItemID,Data in pairs(GetSyncData("Item")) do
		if Data.Rarity == "Godly" or Data.Rarity == "Victim" or Data.Rarity == "Classic" then
			local Has,Amount = CheckForItem(Player,ItemID,"Weapons");
			if Has and Amount >= MinRarity[Data.Rarity] then
				DuperList:UpdateAsync("List2",function(Value)
					Value[tostring(Player.userId)] = true;
					return Value;
				end)
				break;
			end;
		end;
	end;
	
	for ItemID,Data in pairs(GetSyncData("Pets")) do
		if Data.Rarity == "Godly" or Data.Rarity == "Victim" or Data.Rarity == "Classic" then
			local Has,Amount = CheckForItem(Player,ItemID,"Pets");
			if Has and Amount >= MinRarity[Data.Rarity] then
				DuperList:UpdateAsync("List2",function(Value)
					Value[tostring(Player.userId)] = true;
					return Value;
				end)
				break;
			end;
		end;
	end;
	
	--[[
	local LeaderTable = {};
	for _,lPlayer in pairs(game.Players:GetPlayers()) do
		local Name = lPlayer.Name;
		local lData = DataTable[lPlayer.Name];
		if lData then
			table.insert(LeaderTable,{
				PlayerName = Name;
				Level = Module.GetLevel(Module.Get(lPlayer,"XP"));
				Prestige = Module.Get(lPlayer,"Prestige");
				Elite = _G.CheckElite(lPlayer);
			});			
		end
	end
	game.ReplicatedStorage.GiveLeaderboard:FireAllClients(LeaderTable)]]
	
end)

Module.Give = function(Player,DataName,Amount)
	if DataName == "XP" then
		if string.sub(Player.Name,1,6)~="Guest " then--and Player.userId > 0 then
			local _,Error = pcall(function()
				local Badges = GetSyncData("Badge");
				local CurrentXP = Module.Get(Player,"XP");
				local CurrentLevel = Module.GetLevel(CurrentXP);
				local NextLevel = Module.GetLevel(CurrentXP + ((PlayerIsElite(Player) and Amount*1.5) or Amount) );
				if NextLevel > CurrentLevel and NextLevel%10 == 0 then
					--game.ReplicatedStorage.Chatted:FireAllClients("Server",Player.Name .. " has just reached level " .. NextLevel);
					local OldImage = require(game.ReplicatedStorage.RankIcons)[CurrentLevel];
					local NewImage = require(game.ReplicatedStorage.RankIcons)[NextLevel];
					game.ReplicatedStorage.LevelUp:FireClient(Player,OldImage,NewImage)
				end
				
				for BadgeName,BadgeID in pairs(Badges) do
					local Level = tonumber(string.sub(BadgeName,6));
					if (NextLevel >= Level) or Module.Get(Player,"Prestige") >= 1 then
						game.BadgeService:AwardBadge(Player.userId,BadgeID);
					end
				end
			end)
			if Error then
				game:GetService("TestService"):Error("Error giving badge: " .. Error,script);
			end
		end;
		
		if Module.Get(Player,DataName) + Amount > LevelCap then
			DataTable[Player.Name]["XP"] = LevelCap;
		else
			if PlayerIsElite(Player) then
				Amount = Amount*1.5;
			end
			DataTable[Player.Name]["XP"] = DataTable[Player.Name]["XP"] + Amount;
		end
		
		game.ReplicatedStorage.GiveXP:FireClient(Player,Amount)
		if Player.userId > 0 then game:GetService("PointsService"):AwardPoints(Player.userId, Amount) end;
	else
		DataTable[Player.Name][DataName] = DataTable[Player.Name][DataName] + Amount;
	end
	game.ReplicatedStorage.UpdateData2:FireClient(Player,DataTable[Player.Name],true);
end

function CheckForItem(Player,ItemName,Type)
	for Index,Value in pairs(DataTable[Player.Name][Type].Owned) do
		if Index == ItemName then
			return true,Value;
		end
		if Value == ItemName then
			return true,1;
		end
	end
	return false;
end
Module.CheckForItem = CheckForItem;

Module.Equip = function(Player,ItemName,Type)
	if CheckForItem(Player,ItemName,Type) then
		if Type == "Weapons" then
			local ItemsDB = GetSyncData("Item") 
			local ItemType = ItemsDB[ItemName]["ItemType"]
			DataTable[Player.Name]["Weapons"]["Equipped"][ItemType] = ItemName;
		else
			for _,Item in pairs(DataTable[Player.Name][Type].Equipped) do if Item == ItemName then return end; end;
			table.insert(DataTable[Player.Name][Type].Equipped,1,ItemName);
			local Equipped = #DataTable[Player.Name][Type].Equipped;
			if Equipped > DataTable[Player.Name][Type].Slots then
				table.remove(DataTable[Player.Name][Type].Equipped);
			end
			if Type == "Radios" and _G.CheckRadio(Player) then _G.WeldRadio(Player); 
			elseif Type == "Pets" then
				_G.GivePet(Player);
			end;
		end;
		
		pcall(function()
			local ItemsDB = GetSyncData("Item") 
			Player.Character.KnifeDisplay:Destroy();
			Player.Character.GunDisplay:Destroy();
			
			local Equipped = DataTable[Player.Name]["Weapons"]["Equipped"];
			local EquippedKnife = game.ServerStorage.Default.Knife:Clone();
			pcall(function() EquippedKnife = game.InsertService:LoadAsset(ItemsDB[Equipped.Knife]["ItemID"]):GetChildren()[1]; EquippedKnife.TextureId = ItemsDB[Equipped.Knife].Image; end);
			require(script.Weld)(EquippedKnife.Handle);		
			
			local Effects = GetSyncData("Effects");
			local EquippedEffect = DataTable[Player.Name]["Effects"].Equipped[1];
			if Effects[EquippedEffect] ~= nil and EquippedEffect ~= "None" and EquippedEffect ~= "Dual" then
				require( Effects[EquippedEffect]["KnifeModule"] )(EquippedKnife);
			end				
			
			local KnifeName = Equipped.Knife;
			local KnifeRotation = ItemsDB[KnifeName]["Angles"] 
			local RadioRotation = ItemsDB[KnifeName]["RadioAngles"]
			local KnifePosition = ItemsDB[KnifeName]["Offset"] 
			local RadioOffset = ItemsDB[KnifeName]["RadioOffset"];
			
			
			local Handle = EquippedKnife.Handle:Clone();
			EquippedKnife:Destroy();
			Handle.CanCollide = false;
			Handle.CFrame = Player.Character.Torso.CFrame;
			local KnifeWeld = Instance.new("Weld",Player.Character.Torso);
			KnifeWeld.Part0 = Player.Character.Torso;
			KnifeWeld.Part1 = Handle;
			
			local HasRadio,CanUse = _G.CheckRadio(Player)
			local UseRadio = (HasRadio and CanUse);	
			
			local DefaultRotation;
			local DefaultPosition;
			
			local function dAngles(Data)
				return CFrame.Angles(Data.X,Data.Y,Data.Z)
			end
			
			local function dOffset(Data)
				return CFrame.new(Data.X,Data.Y,Data.Z)
			end
		
			if not UseRadio  then 
				DefaultRotation = 
					(KnifeRotation and dAngles(KnifeRotation)) or
					 CFrame.Angles(-math.pi/2,math.pi/4,math.pi/2);
				
				DefaultPosition = 
					(KnifeRotation and CFrame.new(0,0,0.5)) or
					 CFrame.new(-0.1,0,0.5);
				
				DefaultPosition = (KnifePosition and dOffset(KnifePosition)) or DefaultPosition;
			else
				DefaultPosition = (RadioOffset and dOffset(RadioOffset)) or CFrame.new(-1,-1.3,0.25);
				DefaultRotation = CFrame.Angles(math.rad(-60),0,math.rad(180));
				DefaultRotation = 
					(RadioRotation and dAngles(RadioRotation)	) 
				or 	(KnifeRotation and DefaultRotation * dAngles(KnifeRotation)	) 	
				or 	DefaultRotation;
			end;
			
			KnifeWeld.C0 =  DefaultPosition * DefaultRotation;
			
			KnifeWeld.C1 = CFrame.new();
			Handle.Name = "KnifeDisplay";
			Handle.Parent = Player.Character;
			
			local EquippedGun = game.ServerStorage.Default.Gun:Clone();
			pcall(function() EquippedGun = game.InsertService:LoadAsset(ItemsDB[Equipped.Gun]["ItemID"]):GetChildren()[1]; end);
			local GunRotation = ItemsDB[Equipped.Gun]["Angles"] 
			
			local Handle2 = EquippedGun.Handle:Clone();
			EquippedGun:Destroy();
			Handle2.CanCollide = false;
			Handle2.CFrame = Player.Character.Torso.CFrame;
			local GunWeld = Instance.new("Weld",Player.Character.Torso);
			GunWeld.Part0 = Player.Character.Torso;
			GunWeld.Part1 = Handle2;
			if GunRotation ~= nil then
				GunWeld.C0 = CFrame.new(1,-1.5,0.2) * CFrame.Angles(GunRotation["X"],GunRotation["Y"],GunRotation["Z"])
			else
				GunWeld.C0 = CFrame.new(1,-1.5,0.2) * CFrame.Angles(math.rad(150),0,0)
			end;
			GunWeld.C1 = CFrame.new();
			Handle2.Name = "GunDisplay";
			Handle2.Parent = Player.Character;		
		end)		
		
		game.ReplicatedStorage.UpdateData3:FireClient(Player,DataTable[Player.Name])
	end
end

Module.Unequip = function(Player,Index,Type)
	local SlotInfo = GetSyncData("SlotInfo");
	if SlotInfo[Type].Unequip then
		table.remove(DataTable[Player.Name][Type].Equipped,Index);
	end
	_G.GivePet(Player);
end


Module.Buy = function(Player,ID,Type)
	print(Player,ID,Type);
	
	if DataTable[Player.Name] == nil then return end;
	if DataTable[Player.Name][Type] == nil then return end;
	
	local Credits = Module.Get(Player,"Credits"); if Credits == nil then return end;
	local Gems = Module.Get(Player,"Gems"); if Gems == nil then return end;
	local Database = GetSyncData(Type) or GetSyncData("Item"); if Database == nil then return; end;
	local Data = Database[ID]; if Data == nil then return end;
	
	local Price = Data.Price; if Price == nil then 
		for _,Bundle in pairs(GetSyncData("Bundles")) do
			for _,Table in pairs(Bundle.Contents) do
				if Table.ItemName == ID then
					Price = Table.Price;
					break;
				end
			end
		end;
	end;
	
	local Currency = (Data.Gems and "Gems") or "Credits";
	local Amount = (Data.Gems and Gems) or Credits;
	
	if Amount >= Price then
		if Type == "Weapons" or Type == "Pets" then
			Module.GiveItem(Player,ID,1,Type);
		else
			table.insert(DataTable[Player.Name][Type].Owned,ID);
		end;
		DataTable[Player.Name][Currency] = DataTable[Player.Name][Currency] - Price;
		game.ReplicatedStorage.UpdateData2:FireClient(Player,DataTable[Player.Name]);
		wait();
		Module.SaveData(Player);
		print(Player.Name .. " has successfully purchased " .. ID);
		
		Insight.QueueEvent({
			event = 'item-purchased',
			timestamp = os.time(),
			
			itemType = Type;
			itemName = ID;
			price = Price;
			currency = Currency;
			
			userId = Player.userId
		});	

	end;
end

Module.BuyBundle = function(Player,Bundle)
	local Bundles = GetSyncData("Bundles");
	local Price = 0;
	for _,ItemTable in pairs(Bundles[Bundle].Contents) do
		Price = Price + ItemTable["Price"];
	end
	local PlayerName = GetPlayerName(Player);
	local Credits = DataTable[PlayerName]["Credits"];
	local Price = math.floor(Price*0.85);
	if Credits >= Price then
		DataTable[PlayerName]["Credits"] = DataTable[PlayerName]["Credits"] - Price;
		for _,ItemTable in pairs(Bundles[Bundle].Contents) do
			Module.GiveItem(Player,ItemTable["ItemName"],1);
			
			--[[local _,Error = pcall(function() PurchaseData:UpdateAsync(ItemTable["ItemName"],function(Value) if Value then return Value+1; else return 1; end; end); end);
			if Error then
				print("Failed to update " .. ItemTable["ItemName"] .. ": " .. Error);
			end]]
			
		end
		game.ReplicatedStorage.UpdateData:FireClient(Player);
		
		--[[local _,Error = pcall(function() PurchaseData:UpdateAsync(Bundle,function(Value) if Value then return Value+1; else return 1; end; end); end);
		if Error then
			print("Failed to update " .. Bundle .. ": " .. Error);
		end]]
		
		Insight.QueueEvent({
			event = 'item-purchased',
			timestamp = os.time(),
			
			itemType = "Bundle";
			itemName = Bundle;
			price = Price;
			currency = "Credits";
			
			userId = Player.userId
		});	
		
	end
end


function GetPlayerName(Player)
	local PlayerName;
	if type(Player) == "string" then
		PlayerName = Player;
	elseif type(Player) == "userdata" then
		PlayerName = Player.Name;
	end
	return PlayerName;
end

local function GetGifts(Player)
	local PlayerName = GetPlayerName(Player);
	local Inventory = DataTable[PlayerName]["Weapons"].Owned;
	for ItemName,ItemAmount in pairs(Inventory) do
		if ItemName == "Gift" then
			return ItemAmount;
		end
	end
	return 0;
end

local function GetCandies(Player)
	local PlayerName = GetPlayerName(Player);
	local Inventory = DataTable[PlayerName]["Weapons"].Owned;
	for ItemName,ItemAmount in pairs(Inventory) do
		if ItemName == "Candies" then
			return ItemAmount;
		end
	end
	return 0;
end

Module.GiveOther = function(Player,ID,Type,NoSave)
	if DataTable[Player.Name] == nil then return end;
	if DataTable[Player.Name][Type] == nil then return end;
	table.insert(DataTable[Player.Name][Type].Owned,ID);
	game.ReplicatedStorage.ItemGift:FireClient(Player,ID,Type);
	game.ReplicatedStorage.UpdateData2:FireClient(Player,DataTable[Player.Name]);
	wait();
	--Module.SaveData(Player);
	
	--print("Updating " .. ID .. " count...");
	--[[local _,Error = pcall(function() PurchaseData:UpdateAsync(ID,function(Value) if Value then return Value+1; else return 1; end; end); end);
	if Error then
		print("Error updating " .. ID .. ": " .. Error);
	end]]
	
	Insight.QueueEvent({
		event = 'item-awarded',
		timestamp = os.time(),
		
		itemType = Type;
		itemName = ID;
		
		userId = Player.userId
	});	
end

Module.GiveItem = function(Player,ItemName,Amount,Type)
	if not Type then Type = "Weapons" end;
	local PlayerName = GetPlayerName(Player);
	
	if not GetSyncData("Item")[ItemName] and not GetSyncData("Pets")[ItemName] and not GetSyncData("Materials")[ItemName] then
		print("[Error] Cannot find item: " .. ItemName);
		return;
	end
	
	if PlayerName ~= nil then
		if DataTable[PlayerName] ~= nil then
			if DataTable[PlayerName][Type] ~= nil then
				if DataTable[PlayerName][Type].Owned[ItemName] == nil then
					DataTable[PlayerName][Type].Owned[ItemName] = Amount;
				else
					DataTable[PlayerName][Type].Owned[ItemName] = DataTable[PlayerName][Type].Owned[ItemName] + Amount;
				end;
				game.ReplicatedStorage.UpdateData2:FireClient(Player,DataTable[PlayerName])
			else
				print("Error: DataTable[PlayerName][DataName] == nil (GiveItem)");
			end
		else
			print("Error: DataTable[PlayerName] == nil (GiveItem)");
		end;
	else
		print("Error: PlayerName == nil (GiveItem)");
	end;
end

Module.RemoveItem = function(Player,ItemName,Amount,Type)
	if not Type then Type = "Weapons" end;
	local PlayerName = GetPlayerName(Player);
	if PlayerName ~= nil then
		if DataTable[PlayerName] ~= nil then
			if DataTable[PlayerName][Type] ~= nil then
					
				if DataTable[PlayerName][Type].Owned[ItemName] == nil then
					print("Error: Player doesn't have the item (RemoveItem)");
				elseif DataTable[PlayerName][Type].Owned[ItemName] - Amount > 0 then
					DataTable[PlayerName][Type].Owned[ItemName] = DataTable[PlayerName][Type].Owned[ItemName] - Amount;
				else
					DataTable[PlayerName][Type].Owned[ItemName] = nil;
					if DataTable[PlayerName].Weapons.Equipped.Knife == ItemName then
						DataTable[PlayerName].Weapons.Equipped.Knife = "DefaultKnife";
					elseif DataTable[PlayerName].Weapons.Equipped.Gun == ItemName then
						DataTable[PlayerName].Weapons.Equipped.Gun = "DefaultGun";
					elseif DataTable[PlayerName].Pets.Equipped[1] == ItemName then
						Module.Unequip(Player,1,"Pets");
					end;
					print("Error: Player has less than 0 (RemoveItem)");
				end
				game.ReplicatedStorage.UpdateData2:FireClient(Player,DataTable[PlayerName])

			else
				print("Error: DataTable[PlayerName][DataName] == nil (RemoveItem)");
			end
		else
			print("Error: DataTable[PlayerName] == nil (RemoveItem)");
		end;
	else
		print("Error: PlayerName == nil (RemoveItem)");
	end;
end


-- Salvage

Module.SalvageItem = function(Player,Item)
	for _,CodeData in pairs(GetSyncData("Codes")) do if CodeData.Prize == Item then return end; end;
	if CheckForItem(Player,Item,"Weapons") then
		local ItemRarity = GetSyncData("Item")[Item].Rarity;
		local SalvageRewards = GetSyncData("SalvageRewards");
		local SalvageTable = SalvageRewards[Item] or SalvageRewards[ItemRarity];
		
		local Rewards = {};
		--local ItemCount = 1 + ((math.random(1,3)==1 and 1) or 0) + ((math.random(1,3)==1 and 1) or 0)

		local ItemCount = 0;
		for i = 1,3 do
			if math.random(1,100)<=SalvageTable.CountChance[i] then
				ItemCount = ItemCount+1;
			else
				break;
			end;
		end		
		
		
		--print("--");
		
		Module.RemoveItem(Player,Item,1);
		
		for i = 1,ItemCount do
			
			local RewardsTable = {};
			for RewardID,RewardData in pairs(SalvageTable.Rewards) do
				if RewardData.Rarity[i] then
					for i = 1,RewardData.Rarity[i] do
						table.insert(RewardsTable,RewardID);
					end;
				end;
			end
			
			
			if #RewardsTable >= 1 then
				local Reward = RewardsTable[math.random(1,#RewardsTable)];
				local Amount = math.random(SalvageTable.Rewards[Reward].Amount[1],SalvageTable.Rewards[Reward].Amount[2]);
				
				Rewards[i] = {
					ID = Reward;
					Amount = Amount;
				};
				--print(Reward .. ": " .. Amount);
				
				Module.GiveItem(Player,Reward,Amount,"Materials");
				
				Insight.QueueEvent({
					event = 'item-salvaged-reward',
					timestamp = os.time(),
					rewardName = Reward;
					amount = Amount;
					rewardSlot = i;
					userId = Player.userId
				});	
				
			end;

		end
		--print("--");
		
		local ConvertedRewards = {};
		for i,v in pairs(Rewards) do
			ConvertedRewards[v.ID] = v.Amount;
		end
		
		Insight.QueueEvent({
			event = 'item-salvaged',
			timestamp = os.time(),
			
			itemName = Item;
			salvageReward = ConvertedRewards;
			
			userId = Player.userId
		});	
		
		spawn(function()
			Module.SaveData(Player);
			--[[local _,Error1 = pcall(function() 
				PurchaseData:UpdateAsync("Salvages",function(Table) 
					Table = (Table) or {};
					Table[Item] = (Table[Item] and Table[Item]+1) or 1;
					return Table;
				end); 
			end);
			if Error1 then
				print("Failed to update salvage table " .. Player.Name .. ": " .. Error1);
			end]]
		end)		
		
		return Rewards;
		
	end
end
function game.ReplicatedStorage.Remotes.Inventory.Salvage.OnServerInvoke(Player,Item)
	return Module.SalvageItem(Player,Item);
end


Module.GiveDrops = function(Player)
	local Drops = GetSyncData("Drops");
	local DropCount = 0;
	if math.random(1,100)<=Drops.DropCountChance[1] then
		DropCount = 1;
		if math.random(1,100)<=Drops.DropCountChance[2] then
			DropCount = 2;
		end
	end
	
	local DropRewards = {};
	
	for CurrentDrop = 1,DropCount do
		local CategoryChanceTable = {};
		local Category;
		
		for DropCategory,CategoryData in pairs(Drops.DropTree) do
			for e = 1,CategoryData.Chance[CurrentDrop] do
				table.insert(CategoryChanceTable,DropCategory);
			end;
		end
		
		Category = CategoryChanceTable[math.random(1,#CategoryChanceTable)];
		
		local DropTable = Drops.DropTree[Category].DropTable;
		local DropChanceTable = {};
		
		for ItemID,DropData in pairs(DropTable) do
			for i = 1,DropData.Chance do
				table.insert(DropChanceTable,ItemID);
			end
		end
		
		local DropReward = DropChanceTable[ math.random(1,#DropChanceTable) ];
		DropRewards[CurrentDrop] = {
			ItemID = DropReward;
			Type = Drops.DropTree[Category].Type;
			Amount = math.random(DropTable[DropReward].Amount[1],DropTable[DropReward].Amount[2]);
		};
	end
	
	for i,Reward in pairs(DropRewards) do
		Module.GiveItem(Player,Reward.ItemID,Reward.Amount,Reward.Type);
		Insight.QueueEvent({
			event = 'drop-received-reward',
			timestamp = os.time(),
			rewardName = Reward.ItemID;
			rewardAmount = Reward.Amount;
			rewardType = Reward.Type;
			rewardSlot = i;
			userId = Player.userId
		});	
	end;
	
	local ConvertedRewards = {};
	for i,v in pairs(DropRewards) do
		ConvertedRewards[v.ItemID] = {Type=v.Type; Amount=v.Amount;};
	end

	
	Insight.QueueEvent({
		event = 'drop-received',
		timestamp = os.time(),
		
		dropTable = ConvertedRewards;
		
		userId = Player.userId
	});	
	
	spawn(function()
		Module.SaveData(Player);
		--[[local _,Error1 = pcall(function() 
			PurchaseData:UpdateAsync("GiveDrops",function(Table) 
				Table = (Table) or {};
				for _,Reward in pairs(DropRewards) do
					Table[Reward.ItemID] = (Table[Reward.ItemID] and Table[Reward.ItemID]+Reward.Amount) or Reward.Amount;
				end;
				return Table;
			end); 
		end);
		if Error1 then
			print("Failed to update drop table " .. Player.Name .. ": " .. Error1);
		end]]
	end)
	
	return DropRewards;
	
end

--[[function CheckForItem(Player,ItemName,Type)
	for Index,Value in pairs(DataTable[Player.Name][Type].Owned) do
		if Index == ItemName then
			return true,Value;
		end
		if Value == ItemName then
			return true,1;
		end
	end
	return false;
end]]

Module.CraftItem = function(Player,CraftingTable)
	
	-- Check if they have what the CraftingTable says they have
	local AmountHas = 0;
	for _,Data in pairs (CraftingTable) do
		local Has,Amount = CheckForItem(Player,Data.ItemID,"Materials");
		if Has and Amount >= Data.Amount then
			AmountHas = AmountHas + 1;
		end
	end;
	if AmountHas >= #CraftingTable then
		print("CraftingTable verified")
		
		local SelectedRecipe;	
		-- FindRecipe
		for RecipeID,RecipeData in pairs(GetSyncData("Recipes")) do
			if RecipeData.Materials then
				local TotalOwnedMaterials = 0;
				local PartsOfRecipeOwned= 0;
				local TotalMaterialsNeeded = 0;
				local TotalPartsOfRecipeNeeded = 0;		
				for MaterialID,RequiredAmount in pairs(RecipeData.Materials) do
					TotalPartsOfRecipeNeeded = TotalPartsOfRecipeNeeded + 1;
					TotalMaterialsNeeded = TotalMaterialsNeeded + RequiredAmount;
					for _,CData in pairs(CraftingTable) do
						if CData.ItemID == MaterialID and CData.Amount >= RequiredAmount then
							PartsOfRecipeOwned = PartsOfRecipeOwned + 1;
							TotalOwnedMaterials = TotalOwnedMaterials + CData.Amount;
							break;
						end
					end
				end;
				if TotalMaterialsNeeded == TotalOwnedMaterials and PartsOfRecipeOwned == TotalPartsOfRecipeNeeded and #CraftingTable == TotalPartsOfRecipeNeeded then
					SelectedRecipe = RecipeID;
					break;
				end;
			end;
		end;
		
		local RD = GetSyncData("Recipes")[SelectedRecipe]	
		
		if RD then
			-- Recipe found, craft item
			
			
			
			local RewardID,RewardAmount,RewardType;-- = RD.RewardItem,RD.RewardAmount,RD.RewardType;
			
			if RD.Function then
				RewardID,RewardAmount,RewardType = require(RD.Function)(Player,SelectedRecipe,RD);
			else
				RewardID,RewardAmount,RewardType = RD.RewardItem,RD.RewardAmount,RD.RewardType;
			end;
			
			print(RewardID,RewardAmount,RewardType);
			
			for Material,Amount in pairs(RD.Materials) do
				Module.RemoveItem(Player,Material,Amount,"Materials");
			end
			Module.GiveItem(Player,RewardID,RewardAmount,RewardType);
			
			spawn(function()
				Module.SaveData(Player);

				--[[local _,Error1 = pcall(function() 
					PurchaseData:UpdateAsync("CraftedItems",function(Table) 
						Table = (Table) or {};
						Table[RewardID] = (Table[RewardID] and Table[RewardID]+RewardAmount) or RewardAmount;
						return Table;
					end); 
				end);
				if Error1 then
					print("Failed to update crafting table " .. RewardID .. ": " .. Error1);
				end]]
				--[[local _,Error1 = pcall(function() PurchaseData:UpdateAsync(RewardID,function(Value) if Value then return Value+1; else return 1; end; end); end);
				local _,Error2 = pcall(function() PurchaseData:UpdateAsync("TotalCrafts",function(Value) if Value then return Value+1; else return 1; end; end); end);
				if Error1 then
					print("Failed to update " .. RewardID .. ": " .. Error1);
				end
				if Error2 then
					print("Failed to update " .. "TotalCrafts: " .. Error2);
				end]]
			end)	
			
			Insight.QueueEvent({
				event = 'item-crafted',
				timestamp = os.time(),
				
				itemName = RewardID;
				itemType = RewardType;
				
				userId = Player.userId
			});				
			
			return RewardID,RewardAmount,RewardType;
			
		end
	end
end;


function game.ReplicatedStorage.Remotes.Inventory.Craft.OnServerInvoke(Player,CraftingTable)
	return Module.CraftItem(Player,CraftingTable);
end




local TradeEvents = game.ReplicatedStorage.Trade;

Module.TradingPlayers = {};


local ShirtCodes = game:GetService("DataStoreService"):GetDataStore("StoreCodes2");

Module.Redeem = function(Player,Code)

	for CodeCheck,CodeTable in pairs(GetSyncData("Codes")) do

		if Code == CodeCheck then
			if not CheckForItem(Player,CodeTable["Prize"],"Weapons") then
				if os.time() < GetSyncData("Codes")[Code]["Expiry"] then
					Module.GiveItem(Player,CodeTable["Prize"],1);
					game.ReplicatedStorage.RedeemCode:FireClient(Player,CodeTable["Prize"]);
					return;
				else
					game.ReplicatedStorage.RedeemCode:FireClient(Player,false,"Expired");
					return
				end;
			else
				game.ReplicatedStorage.RedeemCode:FireClient(Player,false,"Has");
				return;
			end;
		end
		
	end;
	
end

function game.ReplicatedStorage.RedeemShirtCode.OnServerInvoke(Player,Code)

	local ShirtCodeSuccess = "Invalid";
	local Rewards;

	ShirtCodes:UpdateAsync(Code, function(Value)
		
		if Value == nil then
			return nil;
		elseif Value.Redeemed == false then
			ShirtCodeSuccess = "Awarded"
			Value.Redeemed = Player.userId;
			Rewards = Value.Rewards;
			return Value;
		else
			ShirtCodeSuccess = "Redeemed";
			return Value;
		end;
		
	end)
	
	if ShirtCodeSuccess == "Invalid" then
		return "Invalid";
	elseif ShirtCodeSuccess == "Awarded" then
		for _,Reward in pairs(Rewards) do
			if Reward.Type == "Weapons" or Reward.Type == "Pets" or Reward.Type == "Materials" then
				Module.GiveItem(Player,Reward.ID,1,Reward.Type);
			else
				Module.GiveOther(Player,Reward.ID,Reward.Type);
			end;
		end;
		Module.SaveData(Player);
		return "Success!",Rewards;
	elseif ShirtCodeSuccess == "Redeemed" then
		return "Used already";
	end;
	
end




Module.OpenCrate = function(Player,CrateName)
	local IsElite = false;
	local ReleaseTime = GetSyncData("MysteryBox")[CrateName]["Released"];
	if os.time()-ReleaseTime < 86400 then
		IsElite = true;
	end
	
	local DB = (
		GetSyncData("MysteryBox")[CrateName].Type == "Weapons" and GetSyncData("Item")) 
		or GetSyncData(GetSyncData("MysteryBox")[CrateName].Type
	);
	
	if not IsElite or (IsElite and PlayerIsElite(Player)) then
		local ChristmasPrice = GetSyncData("MysteryBox")[CrateName].ChristmasPrice;
		local Candies = GetSyncData("MysteryBox")[CrateName].Candies;
		local Credits = Module.Get(Player,"Credits");		
		
		local CanBuy;
		if ChristmasPrice then
			CanBuy = (GetGifts(Player) >= ChristmasPrice);
		elseif Candies then
			CanBuy = (GetCandies(Player) >= GetSyncData("MysteryBox")[CrateName]["Price"]);
		else
			CanBuy = (Credits >= GetSyncData("MysteryBox")[CrateName]["Price"]);
		end;

		local SelectedKnife;
		local SelectedRarity;
		if CanBuy then
			
			if GetSyncData("MysteryBox")[CrateName].Contents then				
				local ItemRarity;
				local Rarity = math.random(1,100);
				if Rarity >= 1 and Rarity <= 60 then
					ItemRarity = "Common";
				elseif Rarity > 60 and Rarity <= 85 then
					ItemRarity = "Uncommon";
				elseif Rarity > 80 and Rarity <= 95 then
					ItemRarity  = "Rare";
				else
					ItemRarity = "Legendary";
				end
				if (math.random(1,500) == 1) then
					ItemRarity = "Godly"; -- Godly
					SelectedKnife = GetSyncData("MysteryBox")[CrateName]["Godly"];
				else
					local RarityTable = {};
					for i,ItemName in pairs(GetSyncData("MysteryBox")[CrateName]["Contents"]) do
						if DB[ItemName]["Rarity"] == ItemRarity then
							table.insert(RarityTable,ItemName);
						end
					end
					if #RarityTable > 0 then
						SelectedKnife = RarityTable[math.random(1,#RarityTable)];
					else
						local RarityTable = {};
						for i,ItemName in pairs(GetSyncData("MysteryBox")[CrateName]["Contents"]) do
							if DB[ItemName]["Rarity"] == "Common" then
								table.insert(RarityTable,ItemName);
							end
						end
						SelectedKnife = RarityTable[math.random(1,#RarityTable)];
					end				
				end;
				
			else	
				local Chances = GetSyncData("MysteryBox")[CrateName].Chances;
				local ItemTable = {};	
					
				for Rarity,Chance in pairs(Chances) do
					ItemTable[Rarity] = {};
					for _,BData in pairs(GetSyncData("MysteryBox")) do
						if BData.Contents and BData.Type == "Weapons" then
							for _,ItemID in pairs(BData.Contents) do
								local ItemD = GetSyncData("Item")[ItemID];
								if ItemD.Rarity == Rarity then
									table.insert(ItemTable[Rarity],ItemID);
								end;
							end;
						end;
					end;					
				end;
				
				local Roll = math.random(1,100);
				
				
				local ChanceTable = {};
				for Rarity,Chance in pairs(Chances) do
					for i = 1,Chance do 
						table.insert(ChanceTable,Rarity);
					end
				end;
				
				SelectedRarity = ChanceTable[math.random(1,#ChanceTable)];
				SelectedKnife = ItemTable[SelectedRarity][math.random(1,#ItemTable[SelectedRarity])];	

				ChanceTable = {};
				
				if Chances.Common <= 0 then
					if (math.random(1,500) == 1) then
						SelectedRarity = "Godly"; -- Godly
						local Godlies = {};
						for _,BData in pairs(GetSyncData("MysteryBox")) do
							if BData.Type == "Weapons" and BData.Godly then
								table.insert(Godlies,BData.Godly);
							end
						end
						SelectedKnife = Godlies[math.random(1,#Godlies)];
					end;
				end;
				
				print(SelectedKnife);
								
				
				--[[for Rarity,Chance in pairs(Chances) do
					if Roll <= Chance then
						SelectedRarity = Rarity;
					end
				end	]]	
				
			end
			
			if ChristmasPrice then
				Module.RemoveItem(Player,"Gift",ChristmasPrice);
			elseif Candies then
				Module.RemoveItem(Player,"Candies", GetSyncData("MysteryBox")[CrateName]["Price"]);
			else 
				DataTable[Player.Name]["Credits"] = DataTable[Player.Name]["Credits"] - GetSyncData("MysteryBox")[CrateName]["Price"];
			end;
			
			Module.GiveItem(Player,SelectedKnife,1,GetSyncData("MysteryBox")[CrateName].Type);
			
			local MsgConnection;
			MsgConnection = game.ReplicatedStorage.CrateComplete.OnServerEvent:connect(function(ePlayer)
				if ePlayer == Player then
					MsgConnection:disconnect();
					local StuffName = (DB[SelectedKnife].ItemName or DB[SelectedKnife].Name);
					print(StuffName);
					game.ReplicatedStorage.Chatted:FireAllClients("Server",Player.Name .. " has just unboxed:", {
						ItemName = StuffName;
						RarityColor = GetSyncData("Rarity")[DB[SelectedKnife].Rarity];
					})
				end
			end)
			
		else
			return nil;
		end;
		
		local CrateType = GetSyncData("MysteryBox")[CrateName].Type;		
		
		wait();
		spawn(function()
			Module.SaveData(Player);
			--[[local _,Error1 = pcall(function() PurchaseData:UpdateAsync(SelectedKnife,function(Value) if Value then return Value+1; else return 1; end; end); end);
			local _,Error2 = pcall(function() PurchaseData:UpdateAsync(CrateName,function(Value) if Value then return Value+1; else return 1; end; end); end);
			if Error1 then
				print("Failed to update " .. SelectedKnife .. "(Crate): " .. Error1);
			end
			if Error2 then
				print("Failed to update " .. CrateName .. "(Crate): " .. Error2);
			end]]
			Insight.QueueEvent({
				event = 'crate-opened',
				timestamp = os.time(),
				
				crateName = CrateName;
				crateType = CrateType;
				
				rewardName = SelectedKnife;
				rewardRarity = SelectedRarity;
				
				userId = Player.userId
			});	
		end);
		return SelectedKnife;
	else
		game.ReplicatedStorage.GetElite:FireClient(Player);
	end;
end

Module.Prestige = function(Player)
	local Level = Module.GetLevel(Module.Get(Player,"XP"));
	if Level >= 100 and Module.Get(Player,"Prestige") < 10 then
		DataTable[Player.Name]["XP"] = 0;
		DataTable[Player.Name]["Prestige"] = DataTable[Player.Name]["Prestige"] + 1;
		game.ReplicatedStorage.Chatted:FireAllClients("Server",Player.Name .. " has just prestiged!");
		game.ReplicatedStorage.UpdateLeaderboard:FireAllClients();
	end
end
game.ReplicatedStorage.Prestige.OnServerEvent:connect(Module.Prestige);


local TradeRequests = {};
local Trades = {};

local function IsInTrade(Player)
	for i,Request in pairs(TradeRequests) do
		if Request["Sender"] == Player or Request["Receiver"] == Player then
			return true,Request,i,"Request";
		end;
	end
	for i,Trade in pairs(Trades) do
		if Trade["Player1"]["Player"] == Player or Trade["Player2"]["Player"] == Player then
			return true,Trade,i,"Trade";
		end;
	end
	return false;
end

local function GetPlayerFromTrade(Player,Trade)
	if Trade ~= nil then
		if Trade["Player1"]["Player"] == Player then
			return "Player1","Player2";
		elseif Trade["Player2"]["Player"] == Player then
			return "Player2","Player1";
		end;
	end;
end

Module.Trade = {};

Module.Trade.Request = function(Player1,Player2)
	if not IsInTrade(Player1) and not IsInTrade(Player2) and not (Player1==Player2) then
		local RequestsEnabled = TradeEvents.SendRequest:InvokeClient(Player2,Player1);
		if RequestsEnabled then
			table.insert(TradeRequests,{
				["Sender"] = Player1;
				["Receiver"] = Player2;
			});
			return false;
		else
			return true;
		end;
	end;
	return true;
end
function TradeEvents.SendRequest.OnServerInvoke(Player1,Player2)
	return Module.Trade.Request(Player1,Player2);
end;


Module.Trade.AcceptRequest = function(Player)
	local IsTrading,Request,iRequest,Type = IsInTrade(Player);
	--false nil nil nil
	if IsTrading and Type == "Request" then
		local Player1 = Request["Sender"];
		local Player2 = Request["Receiver"];
		
		table.remove(TradeRequests,iRequest);
		
		table.insert(Trades,{
			["LastOffer"] = os.time();
			["Locked"] = false;
			["Player1"] = {
				["Player"] = Player1;
				["Offer"] = {};
				["Accepted"] = false;
			};
			["Player2"] = {
				["Player"] = Player2;
				["Offer"] = {};
				["Accepted"] = false;
			};
		});
		TradeEvents.StartTrade:FireClient(Player1);
		TradeEvents.StartTrade:FireClient(Player2);		
	end
end
TradeEvents.AcceptRequest.OnServerEvent:connect(Module.Trade.AcceptRequest);

Module.Trade.DeclineRequest = function(Player)
	local IsTrading,Request,iRequest,Type = IsInTrade(Player);
	if IsTrading and Type == "Request" then
		local Player1 = Request["Sender"];
		table.remove(TradeRequests,iRequest);
		TradeEvents.DeclineRequest:FireClient(Player1);
	end
end
TradeEvents.DeclineRequest.OnServerEvent:connect(Module.Trade.DeclineRequest);


Module.Trade.CancelRequest = function(Player)
	local IsTrading,Request,iRequest,Type = IsInTrade(Player);
	if IsTrading and Type == "Request" then
		local Player1 = Request["Receiver"];
		TradeEvents.CancelRequest:FireClient(Player1);
		table.remove(TradeRequests,iRequest);
	end
end
TradeEvents.CancelRequest.OnServerEvent:connect(Module.Trade.CancelRequest);

Module.Trade.OfferItem = function(Player,ItemName,ItemType)
	if ItemName ~= "DefaultKnife" and ItemName ~= "DefaultGun" then
		local IsTrading,Trade,iTrade,Type = IsInTrade(Player);
		--print(tostring(IsTrading),tostring(Trade));
		local tPlayer = GetPlayerFromTrade(Player,Trade);
		if IsTrading and Type == "Trade" then
			if #Trade[tPlayer]["Offer"] < 4 then
				
				local AlreadyOffered = 0;
				for _,Item in pairs(Trade[tPlayer]["Offer"]) do
					if Item[1] == ItemName and Item[3] == ItemType then
						AlreadyOffered = Item[2];
					end
				end
				
				local HasItem,Amount = CheckForItem(Player,ItemName,ItemType);
				
				--print("Offer Attempt");
				if HasItem and Amount-AlreadyOffered > 0 then
					--print("Has Enough");
					if AlreadyOffered == 0 then
						--print("None Offered, Adding the first item");
						table.insert(Trades[iTrade][tPlayer]["Offer"],
							{ItemName,1,ItemType}
						);
					else
						--print("Some offered");
						for Index,Item in pairs(Trade[tPlayer]["Offer"]) do
							if Item[1] == ItemName then
								--print("Added to existing offer.");
								Trades[iTrade][tPlayer]["Offer"][Index][2] = Trades[iTrade][tPlayer]["Offer"][Index][2] + 1;
								break;
							end
						end
						
					end;
				end;
				
				Trades[iTrade]["LastOffer"] = os.time();
				Trades[iTrade]["Player1"]["Accepted"] = false;
				Trades[iTrade]["Player2"]["Accepted"] = false;
				TradeEvents.UpdateTrade:FireClient(Trades[iTrade]["Player1"]["Player"],Trades[iTrade]);
				TradeEvents.UpdateTrade:FireClient(Trades[iTrade]["Player2"]["Player"],Trades[iTrade]);
			end
		end
	end;
end
TradeEvents.OfferItem.OnServerEvent:connect(Module.Trade.OfferItem);

Module.Trade.RemoveOffer = function(Player,ItemName,ItemType)
	local IsTrading,Trade,iTrade,Type = IsInTrade(Player);
	local tPlayer = GetPlayerFromTrade(Player,Trade);
	if IsTrading and Type == "Trade" then

		if Trades[iTrade]["Locked"] then
			return;
		end		
		
		Trades[iTrade]["LastOffer"] = os.time();
		Trades[iTrade]["Player1"]["Accepted"] = false;
		Trades[iTrade]["Player2"]["Accepted"] = false;
		
		for Index,Item in pairs(Trade[tPlayer]["Offer"]) do
			if Item[1] == ItemName and Item[3] == ItemType then
				Trades[iTrade][tPlayer]["Offer"][Index][2] = Trades[iTrade][tPlayer]["Offer"][Index][2] - 1;
				if Trades[iTrade][tPlayer]["Offer"][Index][2] <= 0 then
					table.remove(Trades[iTrade][tPlayer]["Offer"],Index);
				end
				--table.remove(Trades[iTrade][tPlayer]["Offer"],i);
				break;
			end
		end
		TradeEvents.UpdateTrade:FireClient(Trades[iTrade]["Player1"]["Player"],Trades[iTrade]);
		TradeEvents.UpdateTrade:FireClient(Trades[iTrade]["Player2"]["Player"],Trades[iTrade]);
	end
end
TradeEvents.RemoveOffer.OnServerEvent:connect(Module.Trade.RemoveOffer);

Module.Trade.AcceptTrade = function(Player)
	local IsTrading,Trade,iTrade,Type = IsInTrade(Player);
	local tPlayer,oPlayer = GetPlayerFromTrade(Player,Trade);
	if IsTrading and Type == "Trade" and os.time()-Trades[iTrade]["LastOffer"] >= 5 then
		Trades[iTrade][tPlayer]["Accepted"] = true;
		if Trades[iTrade]["Player1"]["Accepted"] and Trades[iTrade]["Player2"]["Accepted"] then
			Trades[iTrade]["Locked"] = true;			
			
			wait(1);

			if os.time()-Trades[iTrade]["LastOffer"] >= 5 and Trades[iTrade]["Player1"]["Accepted"] and Trades[iTrade]["Player2"]["Accepted"] then
				wait()
			else
				return;
			end;
			
			local OfferError = false;
			
			for _,Item in pairs(Trades[iTrade]["Player1"]["Offer"]) do
				local Has,Amount = CheckForItem(Trades[iTrade]["Player1"]["Player"],Item[1],Item[3]);
				if not (Amount >= Item[2]) then
					OfferError = true;
				end
			end;
			
			for _,Item in pairs(Trades[iTrade]["Player2"]["Offer"]) do
				local Has,Amount = CheckForItem(Trades[iTrade]["Player2"]["Player"],Item[1],Item[3]);
				if not (Amount >= Item[2]) then
					OfferError = true;
				end
			end;
			
			if OfferError then
				local Player1 = Trades[iTrade]["Player1"]["Player"];
				local Player2 = Trades[iTrade]["Player2"]["Player"];
				Insight.QueueEvent({
					event = 'trade-error',
					timestamp = os.time(),
					userId1 = Player1.userId;
					userId2 = Player2.userId;
				});	
				return;
			end
			
			if game.ReplicatedStorage.CheckClient:InvokeClient(Trades[iTrade]["Player2"]["Player"])==5 and game.ReplicatedStorage.CheckClient:InvokeClient(Trades[iTrade]["Player1"]["Player"])==5  then	
				if Trades[iTrade]["Player2"]["Player"] and Trades[iTrade]["Player1"]["Player"] then
					for _,Item in pairs(Trades[iTrade]["Player1"]["Offer"]) do
						
						Module.GiveItem(Trades[iTrade]["Player2"]["Player"],Item[1],Item[2],Item[3]);
						Module.RemoveItem(Trades[iTrade]["Player1"]["Player"],Item[1],Item[2],Item[3]);
						
					end
					for _,Item in pairs(Trades[iTrade]["Player2"]["Offer"]) do
						Module.GiveItem(Trades[iTrade]["Player1"]["Player"],Item[1],Item[2],Item[3]);
						Module.RemoveItem(Trades[iTrade]["Player2"]["Player"],Item[1],Item[2],Item[3]);
					end
				end;
				
				TradeEvents.AcceptTrade:FireClient(Trades[iTrade]["Player1"]["Player"],true);
				TradeEvents.AcceptTrade:FireClient(Trades[iTrade]["Player2"]["Player"],true);
				game.ReplicatedStorage.UpdateData2:FireClient(Trades[iTrade]["Player1"]["Player"],DataTable[Trades[iTrade]["Player1"]["Player"].Name]);
				game.ReplicatedStorage.UpdateData2:FireClient(Trades[iTrade]["Player2"]["Player"],DataTable[Trades[iTrade]["Player2"]["Player"].Name]);
				local Player1 = Trades[iTrade]["Player1"]["Player"];
				local Player2 = Trades[iTrade]["Player2"]["Player"];
				
				local NewOffer1 = {};
				local NewOffer2 = {};
				
				for _,ItemTable in pairs(Trades[iTrade]["Player1"]["Offer"]) do
					if #ItemTable>0 then
						NewOffer1[ItemTable[1]] = {Type=ItemTable[3];Amount=ItemTable[2];};
					end;
				end;
				for _,ItemTable in pairs(Trades[iTrade]["Player2"]["Offer"]) do
					if #ItemTable>0 then
						NewOffer2[ItemTable[1]] = {Type=ItemTable[3];Amount=ItemTable[2];};
					end;
				end;
				
				Insight.QueueEvent({
					event = 'trade-completed',
					timestamp = os.time(),
					player1Offer = NewOffer1;
					player2Offer = NewOffer2;
					userId1 = Player1.userId;
					userId2 = Player2.userId;
				});	
				
				table.remove(Trades,iTrade);
				Module.SaveData(Player1);
				Module.SaveData(Player2);

				

			end;
		else
			TradeEvents.AcceptTrade:FireClient(Trades[iTrade][oPlayer]["Player"],false);
		end;
	end
end
TradeEvents.AcceptTrade.OnServerEvent:connect(Module.Trade.AcceptTrade);

Module.Trade.DeclineTrade = function(Player)
	local IsTrading,Trade,iTrade,Type = IsInTrade(Player);
	local tPlayer = GetPlayerFromTrade(Player,Trade);
	if IsTrading and Type == "Trade" then
		TradeEvents.DeclineTrade:FireClient(Trade["Player1"]["Player"]);
		TradeEvents.DeclineTrade:FireClient(Trade["Player2"]["Player"]);
		table.remove(Trades,iTrade);
	end
end

TradeEvents.DeclineTrade.OnServerEvent:connect(Module.Trade.DeclineTrade);

function game.ReplicatedStorage.GetTradeStatus.OnServerInvoke(Player)
	local IsBusy,BusyTable,iBusy,BusyType = IsInTrade(Player);
	if IsBusy then
		if BusyType == "Trade" then
			return "StartTrade",BusyTable;
		elseif BusyType == "Request" then
			if BusyTable["Sender"] == Player then
				return "ShowRequest",BusyTable["Receiver"].Name;
			elseif BusyTable["Receiver"] == Player then
				return "SendRequest",BusyTable["Sender"].Name;
			end;
		end;
	end;
end


Module.GiveToys = function(Player)
	if XboxReward[Player] then return; end;
	if not Player:FindFirstChild("Backpack") then return; end;
	local Toys = GetSyncData("Toys");
	local FakeTool = Instance.new("Tool",Player.Backpack);
	FakeTool.Name = "Loading Toys...";
	for _,Toy in pairs(DataTable[Player.Name].Toys.Equipped) do
		local NewToy = Instance.new("Tool");
		pcall(function() NewToy = game.InsertService:LoadAsset(Toys[Toy].ItemID):GetChildren()[1]; end);
		if NewToy then
			NewToy.CanBeDropped = false;
			NewToy.Parent = Player.Backpack;
		end;
	end;
	FakeTool:Destroy();
end

-- Halloween
Module.BuyCandies = function(Player,Amount)
	if Amount < 1 then return end;
	if DataTable[Player.Name].Gems >= Amount then
		DataTable[Player.Name].Gems = DataTable[Player.Name].Gems - Amount;
		Module.GiveItem(Player,"Candies",Amount*2,"Weapons");
		return;
	end	
end
game.ReplicatedStorage.BuyCandies.OnServerEvent:connect(Module.BuyCandies);


Module.SellCandies = function(Player,Amount)
	if Amount < 1 then return end;

	local HasCandies,Candies = CheckForItem(Player,"Candies","Weapons");
	if HasCandies and (Candies >= Amount) then
		DataTable[Player.Name].Credits = DataTable[Player.Name].Credits + Amount;
		Module.RemoveItem(Player,"Candies",Amount,"Weapons");
		return;
	end	
end
game.ReplicatedStorage.SellCandies.OnServerEvent:connect(Module.SellCandies);


------------ CHRISTMAS

--[[Module.ExchangeGifts = function(Player)
	local Gifts = GetGifts(Player);
	if Gifts >= 1 then
		Module.Give(Player,"Credits",2);
		Module.RemoveItem(Player,"Gift",1);
		game.ReplicatedStorage.UpdateData2:FireClient(Player,DataTable[Player.Name]);
	end
end

Module.ExchangeCoins = function(Player)
	local Coins = Module.Get(Player,"Credits");
	if Coins >= 10 then
		Module.Give(Player,"Credits",-10);
		Module.GiveItem(Player,"Gift",1);
		game.ReplicatedStorage.UpdateData2:FireClient(Player,DataTable[Player.Name]);
	end
end

function game.ReplicatedStorage.ExchangeGifts.OnServerInvoke(Player)
	Module.ExchangeGifts(Player);
	return true;
end
	
function game.ReplicatedStorage.ExchangeCoins.OnServerInvoke(Player)
	Module.ExchangeCoins(Player);
	return true;
end]]


game.ReplicatedStorage.ChristmasEvents.CompleteTutorial.OnServerEvent:connect(function(Player)
	DataTable[Player.Name].SantaTutorial = true;
end)

game.ReplicatedStorage.ChristmasEvents.ChristmasBuy.OnServerEvent:connect(function(Player,ShopIndex)
	
	if DataTable[Player.Name] == nil then return end;
	
	--local Credits = Module.Get(Player,"Credits"); if Credits == nil then return end;
	local Gems = Module.Get(Player,"Gems"); if Gems == nil then return end;
	--local Database = GetSyncData(Type) or GetSyncData("Item"); if Database == nil then return; end;
	--local Data = Database[ID]; if Data == nil then return end;
	
	local ShopData = GetSyncData("ChristmasShop")[ShopIndex];
	
	
	local Currency = ShopData.CostID;
	local Amount = (ShopData.CostID == "Gems" and Gems) or DataTable[Player.Name][ShopData.CostType].Owned[ShopData.CostID];
	
	for _,rN in pairs(DataTable[Player.Name][ShopData.RewardType].Owned) do
		if rN == ShopData.RewardID then
			return;
		end
	end
	
	if Amount >= ShopData.Cost then
		
		if ShopData.CostID == "Gems" then
			DataTable[Player.Name][Currency] = DataTable[Player.Name][Currency] - ShopData.Cost;
		else
			Module.RemoveItem(Player,ShopData.CostID,ShopData.Cost,ShopData.CostType);
		end;

		if ShopData.RewardType == "Weapons" or ShopData.RewardType == "Pets" or ShopData.RewardType == "Materials" then
			Module.GiveItem(Player,ShopData.RewardID,ShopData.RewardAmount,ShopData.RewardType);
		else
			table.insert(DataTable[Player.Name][ShopData.RewardType].Owned,ShopData.RewardID);
			game.ReplicatedStorage.UpdateData2:FireClient(Player,DataTable[Player.Name]);
		end;		
		
		

		wait();
		--
		--print(Player.Name .. " has successfully purchased " .. ID);
		
		--[[local _,Error = pcall(function() PurchaseData:UpdateAsync(ID,function(Value) if Value then return Value+1; else return 1; end; end); end);
		if Error then
			print("Failed to update " .. ID .. ": " .. Error);
		end]]
		
		
		
		spawn(function()
			Module.SaveData(Player);
			--[[local _,Error1 = pcall(function() 
				PurchaseData:UpdateAsync("ChristmasBuy",function(Table) 
					Table = (Table) or {};
					Table[ShopData.RewardID] = (Table[ShopData.RewardID] and Table[ShopData.RewardID]+1) or 1;
					return Table;
				end); 
			end);
			if Error1 then
				print("Failed to update xmasbuytable " .. Player.Name .. ": " .. Error1);
			end]]
		end)	
		Insight.QueueEvent({
			event = 'christmas-item-purchased',
			timestamp = os.time(),
			
			itemName = ShopData.RewardID;
			itemType = ShopData.RewardType;
			itemAmount = ShopData.RewardAmount;
			
			price = ShopData.Cost;
			currency = ShopData.CostID;
			
			
			userId = Player.userId
		});	
	end;
end)

game.ReplicatedStorage.ChristmasEvents.ExchangeGift.OnServerEvent:connect(function(Player,GiftID)
	if CheckForItem(Player,GiftID,"Materials") then
		Module.RemoveItem(Player,GiftID,1,"Materials");
		Module.GiveItem(Player,"BlueTokens",GetSyncData("Materials")[GiftID].TokenValue,"Materials");
		
		spawn(function()
			--[[local _,Error1 = pcall(function() 
				PurchaseData:UpdateAsync("GiftExchange",function(Table) 
					Table = (Table) or {};
					Table[GiftID] = (Table[GiftID] and Table[GiftID]+1) or 1;
					Table["Total"] = (Table["Total"] and Table["Total"]+1) or 1;
					Table["TokenValue"] = (Table["TokenValue"] and Table["TokenValue"]+GetSyncData("Materials")[GiftID].TokenValue) or GetSyncData("Materials")[GiftID].TokenValue;
					return Table;
				end); 
			end);
			if Error1 then
				print("Failed to update xmasbuytable " .. Player.Name .. ": " .. Error1);
			end]]
			local TokenValue = GetSyncData("Materials")[GiftID].TokenValue;
			
			Insight.QueueEvent({
				event = 'christmas-gift-exchanged',
				timestamp = os.time(),
				
				giftId = GiftID;
				tokenValue = TokenValue;
				
				userId = Player.userId
			});	
		end)	
		
	end;
end);


local RarityIndex = {
	["Common"] = "Uncommon";
	["Uncommon"] = "Rare";
	["Rare"] = "Legendary";
};

--[[function game.ReplicatedStorage.Remotes.Inventory.Recycle.OnServerInvoke(Player,RecycleTable)
	if RecycleTable and #RecycleTable == 8 then
		
		local RecyclableItems = 0;
		for _,ItemName in pairs(RecycleTable) do
			for _,rItem in pairs(GetSyncData("Recyclable")) do
				if ItemName == rItem then
					RecyclableItems = RecyclableItems + 1; break;
				end
			end
		end
		
		if RecyclableItems == 8 then
			local ItemsWithAmount = {};
			for _,ItemName in pairs(RecycleTable) do
				if not ItemsWithAmount[ItemName] then
					ItemsWithAmount[ItemName] = 1;
				else
					ItemsWithAmount[ItemName] = ItemsWithAmount[ItemName] + 1;
				end;
			end				
			local ItemHas = 0;
			for ItemName,Amount in pairs(ItemsWithAmount) do
				local Inventory = Module.Get(Player,"Weapons").Owned;
				if Inventory[ItemName] >= Amount then
					ItemHas = ItemHas + Amount;
				end
			end;
			if ItemHas == 8 then
				local Items = GetSyncData("Item");
				local NeededType = Items[RecycleTable[1].ItemType;
				local NeededRarity = Items[RecycleTable[1].Rarity;
				local CanRecycle = true;
				for _,ItemName in pairs(RecycleTable) do
					if Items[ItemName].ItemType ~= NeededType or Items[ItemName].Rarity ~= NeededRarity then
						CanRecycle = false;
					end
				end
				
				if CanRecycle then
					local Rewards = GetSyncData("RecycleRewards");
					local UpgradeRarity = RarityIndex[NeededRarity];
					local RewardTable = Rewards[UpgradeRarity][NeededType];
					local RewardKnife = RewardTable[math.random(1,#RewardTable)];
					Module.GiveItem(Player,RewardKnife,1);
					for _,ItemName in pairs(RecycleTable) do
						Module.RemoveItem(Player,ItemName,1);
					end;
					game.ReplicatedStorage.UpdateData2:FireClient(Player,DataTable[Player.Name]);
					spawn(function()
						wait(0.75);
						game.ReplicatedStorage.Chatted:FireAllClients("Server",Player.Name .. " recycled and got:",
							{
								ItemName = RewardKnife;
								RarityColor = GetSyncData("Rarity")[GetSyncData("Item")[RewardKnife].Rarity];
							}
						)
					end)
					return RewardKnife;
				else
					print("Not matching types and rarity");
				end;
				
			else
				print("Doesn't have all items");
			end;
		else
			print("Not all items are recylable");
		end;
		
	else
		print("Table is nil");
	end;
end]]

game.ReplicatedStorage.Remotes.Inventory.BuySlot.OnServerEvent:connect(function(Player,Type)
	local SlotInfo = GetSyncData("SlotInfo");
	local NextSlot = DataTable[Player.Name][Type].Slots + 1;
	if NextSlot <= SlotInfo[Type].Max then
		DataTable[Player.Name][Type].Slots = DataTable[Player.Name][Type].Slots + 1;
		DataTable[Player.Name]["Credits"] = DataTable[Player.Name]["Credits"] - SlotInfo[Type].Prices[NextSlot];
	end
end);

function game.ReplicatedStorage.GetPlayerLevel.OnServerInvoke(Player,Target)
	return Module.GetLevel(Module.Get(Target,"XP")),Module.Get(Target,"Prestige"),PlayerIsElite(Target);
end

game.ReplicatedStorage.Equip.OnServerEvent:connect(function(Player,ItemName,Type)
	Module.Equip(Player,ItemName,Type);
end)
game.ReplicatedStorage.Remotes.Inventory.Unequip.OnServerEvent:connect(function(Player,ItemName,Type)
	Module.Unequip(Player,ItemName,Type);
end)

game.ReplicatedStorage.Craft.OnServerEvent:connect(function(Player,ItemName)
	Module.Craft(Player,ItemName);
end)

function game.ReplicatedStorage.Remotes.Shop.OpenCrate.OnServerInvoke(Player,Box)
	return Module.OpenCrate(Player,Box);
end

function game.ReplicatedStorage.GetData2.OnServerInvoke(Player)
	return DataTable[Player.Name];
end

game.ReplicatedStorage.ChangeGameMode.OnServerEvent:connect(function(Player,NewMode)
	DataTable[Player.Name]["GameMode2"] = NewMode;
	Module.SaveData(Player);
end);

game.ReplicatedStorage.ChangeLastDevice.OnServerEvent:connect(function(Player,NewDevice)
	DataTable[Player.Name]["LastDevice"] = NewDevice;
	Module.SaveData(Player);
end);


game.ReplicatedStorage.RedeemCode.OnServerEvent:connect(function(Player,Code)
	Module.Redeem(Player,Code);
end)


game.ReplicatedStorage.SaveSong.OnServerEvent:connect(function(Player,SoundID,SongName)
	table.insert(DataTable[Player.Name]["RadioSongs"],1,{ID=SoundID,Name=SongName});
	if #DataTable[Player.Name]["RadioSongs"] >= 30 then
		table.remove(DataTable[Player.Name]["RadioSongs"],30);
	end
end)
game.ReplicatedStorage.RemoveSong.OnServerEvent:connect(function(Player,Index)
	table.remove(DataTable[Player.Name]["RadioSongs"],Index);
end)

game.ReplicatedStorage.Buy.OnServerEvent:connect(Module.Buy);
game.ReplicatedStorage.BuyBundle.OnServerEvent:connect(Module.BuyBundle);


-------------- PERK SYSTEM ----------------
local StealthTable = {};

local function Fade(Player,In)
	local Frames = 10;
	local Face = Player.Character.Head:FindFirstChild("face") or Player.Character:FindFirstChild("face");
	Face.Parent = (In and Player.Character) or Player.Character.Head;
	local i = 1;
	
	while i <= 10 and ((StealthTable[Player.Name] == true and In==true)or In==false) do
		for _,Part in pairs(Player.Character:GetChildren()) do
			local Part = (Part:IsA("BasePart") and Part) 
				or (Part:FindFirstChild("Handle") and Part.Handle) 
				or nil
			if Part and Part.Name ~= "HumanoidRootPart" then
				Part.Transparency = (In and (Part.Transparency + 1/Frames)) or (Part.Transparency - 1/Frames);
				
				--[[for _,Obj in pairs(Part:GetChildren()) do 
					local Effect = pcall(function() return Obj["Enabled"] end)
					if Effect then Obj.Enabled = not In; end;
				end;]]
				
				local function ScanEffects(ScanPart)
					for _,Obj in pairs(ScanPart:GetChildren()) do 
						local Effect = pcall(function() return Obj["Enabled"] end)
						if Effect then Obj.Enabled = not In; end;
						if Obj:IsA("BasePart") then Obj.Transparency = (In and (Obj.Transparency + 1/Frames)) or (Obj.Transparency - 1/Frames); end
						ScanEffects(Obj);
					end;
				end
				ScanEffects(Part);
				
			end;
		end
		for _,Part in pairs(Player.Backpack:GetChildren()) do
			local Part = (Part:FindFirstChild("Handle") and Part.Handle) 
				or nil
			if Part then
				Part.Transparency = (In and (Part.Transparency + 1/Frames)) or (Part.Transparency - 1/Frames);
				
				local function ScanEffects(ScanPart)
					for _,Obj in pairs(ScanPart:GetChildren()) do 
						local Effect = pcall(function() return Obj["Enabled"] end)
						if Effect then Obj.Enabled = not In; end;
						if Obj:IsA("BasePart") then Obj.Transparency = (In and (Obj.Transparency + 1/Frames)) or (Obj.Transparency - 1/Frames); end
						ScanEffects(Obj);
					end;
				end
				ScanEffects(Part);
				
			end;
		end
		game:GetService("RunService").Heartbeat:wait();
		i = i + 1;
	end
	
end

local FakeGunData = {};
local function FakeGun(Player,Activate)
	if FakeGunData[Player.Name]==nil then FakeGunData[Player.Name]={};end;
	local Knife;
	for _,Obj in pairs(Player.Backpack:GetChildren()) do if Obj:FindFirstChild("KnifeServer") then Knife = Obj; break; end; end;
	for _,Obj in pairs(Player.Character:GetChildren()) do if Obj:FindFirstChild("KnifeServer") then Knife = Obj; break; end; end;
	if Knife then
		
		if Activate then
			local ItemsDB = GetSyncData("Item"); local GunName = DataTable[Player.Name].Weapons.Equipped.Gun;
			local Gun = game.ServerStorage.Default.Gun:Clone();
			pcall(function() Gun = game.InsertService:LoadAsset(ItemsDB[GunName]["ItemID"]):GetChildren()[1]; end);
			
			local function ScanEffects(ScanPart)
				for _,Obj in pairs(ScanPart:GetChildren()) do 
					local Effect = pcall(function() return Obj["Enabled"] end)
					if Effect then Obj.Enabled = false; end;
					ScanEffects(Obj);
				end;
			end
			ScanEffects(Knife.Handle);
		
			
			--[[for _,Part in pairs(Knife.Handle:GetChildren()) do
				
				
				if Part:IsA("Fire") or Part:IsA("ParticleEmitter") then
					Part.Enabled = false;
				end
			end]]
			
			local GunMesh = Gun.Handle.Mesh;
			local KnifeMesh = Knife.Handle.Mesh;
			
			FakeGunData[Player.Name].Grip = Knife.Grip;
			FakeGunData[Player.Name].Mesh = KnifeMesh;
			
			KnifeMesh.Parent = game.ServerStorage;
			GunMesh.Parent = Knife.Handle;
			
			Knife.Grip = Gun.Grip;
			
			if Knife:FindFirstChild("Dual") then
				 Knife:FindFirstChild("Dual").Transparency = 1;
			end
			local Override = Instance.new("Folder",Player.Character);
			Override.Name = "ToolAnimOverride";
			
		elseif FakeGunData[Player.Name].Active == true then

			Knife.Handle.Mesh:Destroy();
			Knife.Grip = FakeGunData[Player.Name].Grip;
			FakeGunData[Player.Name].Mesh.Parent = Knife.Handle;
			local Override = Player.Character:FindFirstChild("ToolAnimOverride");
			if Override then Override:Destroy() end;
			if Knife:FindFirstChild("Dual") then
				 Knife:FindFirstChild("Dual").Transparency = 0;
			end
			
			local function ScanEffects(ScanPart)
				for _,Obj in pairs(ScanPart:GetChildren()) do 
					local Effect = pcall(function() return Obj["Enabled"] end)
					if Effect then Obj.Enabled = true; end;
					ScanEffects(Obj);
				end;
			end
			ScanEffects(Knife.Handle);
			
		end;
		
	end
	if FakeGunData[Player.Name].Grip and not Activate then Knife.Grip = FakeGunData[Player.Name].Grip; end;
	FakeGunData[Player.Name].Active = Activate;
end

local Remotes = game.ReplicatedStorage.Remotes;
Remotes.Gameplay.Stealth.OnServerEvent:connect(function(Player,Activate)
	if CheckForItem(Player,"Ghost","Perks") and Activate == not StealthTable[Player.Name] then
		StealthTable[Player.Name] = Activate;
		Fade(Player,Activate);
	end
end)

Remotes.Gameplay.FakeGun.OnServerEvent:connect(function(Player,Activate)
	if CheckForItem(Player,"FakeGun","Perks") then
		FakeGun(Player,Activate);
	end
end)

-------------- PERK SYSTEM ----------------

function game.ReplicatedStorage.GetData.OnServerInvoke(Player,DataName,Target)
	if Target ~= nil then
		return Module.Get(Target,DataName);
	else
		return Module.Get(Player,DataName);
	end;
end

local Products = {
	Coins = {
		["50"] 		= 22151487;
		["100"] 	= 22151502;
		["200"] 	= 22151506;
		["500"] 	= 22151518;
		["1500"] 	= 22151524;
		["3500"] 	= 22151559; 
	};
	
	Gems = {
		["50"] 		= 34444890;
		["250"] 	= 34444901;
		["700"] 	= 34444911;
		["1400"] 	= 34444919;
		["3000"] 	= 34444934;
		["8000"] 	= 34444939; 
	};
};

game.ReplicatedStorage.PurchaseProduct.OnServerEvent:connect(function(Player,ButtonName,Type)
	game:GetService("MarketplaceService"):PromptProductPurchase(Player,Products[Type][ButtonName])
end)

local Purchases = {};
game:GetService("MarketplaceService").ProcessReceipt = function(ReceiptInfo)
	local Player = game.Players:GetPlayerByUserId(ReceiptInfo.PlayerId)

	local Key = ReceiptInfo.PlayerId .. ":" .. ReceiptInfo.PurchaseId
	if Purchases[Key] then
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end
	
	Insight.QueueEvent({
		event = 'developer-product-purchased-begin',
		timestamp = os.time(),
		productId = ReceiptInfo.ProductId;
		purchaseId = ReceiptInfo.PurchaseId;
		userId = ReceiptInfo.PlayerId
	});	

	if Player then
		for Amount,ProductID in pairs(Products.Coins) do
			if ReceiptInfo.ProductId == ProductID then
				Purchases[Key] = true;
				Module.Give(Player,"Credits",tonumber(Amount));
				game.ReplicatedStorage.CashSound:FireClient(Player);
				game.ReplicatedStorage.Save:Fire(Player);
				
				Insight.QueueEvent({
					event = 'developer-product-purchased-complete',
					timestamp = os.time(),
					productId = ReceiptInfo.ProductId;
					purchaseId = ReceiptInfo.PurchaseId;
					credits = tonumber(Amount);
					userId = ReceiptInfo.PlayerId
				});	
				
				return Enum.ProductPurchaseDecision.PurchaseGranted	
			end
		end
		for Amount,ProductID in pairs(Products.Gems) do
			if ReceiptInfo.ProductId == ProductID then
				Purchases[Key] = true;
				Module.Give(Player,"Gems",tonumber(Amount));
				game.ReplicatedStorage.CashSound:FireClient(Player);
				game.ReplicatedStorage.Save:Fire(Player);
				
				Insight.QueueEvent({
					event = 'developer-product-purchased-complete',
					timestamp = os.time(),
					productId = ReceiptInfo.ProductId;
					purchaseId = ReceiptInfo.PurchaseId;
					gems = tonumber(Amount);
					userId = ReceiptInfo.PlayerId
				});					
				
				return Enum.ProductPurchaseDecision.PurchaseGranted	
			end
		end
		
		for _,ID in pairs(_G.GameModeProducts) do
			if ID == ReceiptInfo.ProductId then
				_G.ModePurchaseComplete(Player);
				Purchases[Key] = true;
				
				Insight.QueueEvent({
					event = 'developer-product-purchased-complete',
					timestamp = os.time(),
					productId = ReceiptInfo.ProductId;
					purchaseId = ReceiptInfo.PurchaseId;
					gamemodeproduct = true;
					userId = ReceiptInfo.PlayerId
				});					
				
				return Enum.ProductPurchaseDecision.PurchaseGranted	
			end
		end
	end;

end	

function game.ReplicatedStorage.GetFullInventory.OnServerInvoke(Player,TargetPlayer)
	return DataTable[TargetPlayer.Name];
end

game.ReplicatedStorage.RenamePet.OnServerEvent:connect(function(Player,PetName)
	if string.len(PetName)<=20 then
		DataTable[Player.Name].PetName = PetName;
		_G.GivePet(Player)
	end;
end)
	
	
function game.ReplicatedStorage.GetLeaderboard.OnServerInvoke()
	local LeaderTable = {};
	for _,lPlayer in pairs(game.Players:GetPlayers()) do
		local Name = lPlayer.Name;
		local lData = DataTable[lPlayer.Name];
		if lData then
			table.insert(LeaderTable,{
				PlayerName = Name;
				Level = Module.GetLevel(Module.Get(lPlayer,"XP"));
				Prestige = Module.Get(lPlayer,"Prestige");
				Elite = _G.CheckElite(lPlayer);
			});			
		end
	end
	return LeaderTable;
end

function game.ReplicatedStorage.GetDataServer.OnInvoke(Player,DataName)
	return Module.Get(Player,DataName);
end

Module.Ready = true;

return Module;










