--Resident Evil: 2 Garry's Mod


-------------------------------------------------------------------------------
--SavingAndLoading

function GM:Save(ply)
	local str_Steam = string.Replace(ply:SteamID(),":",";")
	local path_FilePath = "re2/"..str_Steam..".txt"
	local Savetable = {}
	Savetable["Money"] = ply:GetNWInt("Money")
	Savetable["Inventory"] = {}
	Savetable["Inventory"] = ply.RE2Data["Inventory"]
	Savetable["Upgrades"] = {}
	Savetable["Upgrades"] = ply.RE2Data["Upgrades"]
	Savetable["Chest"] = {}
	Savetable["Chest"] = ply.RE2Data["Chest"]
	Savetable["Perks"] = ply.Perks
	local StrindedItems = util.TableToKeyValues(Savetable)
	file.Write(path_FilePath,StrindedItems)
end

function GM:Load(ply)
	local str_Steam = string.Replace(ply:SteamID(),":",";")
	local path_FilePath = "re2/"..str_Steam..".txt"
	ply.RE2Data = {}
	ply.RE2Data["Inventory"] = {	{Item = "none", Amount = 0},
		{Item = "none", Amount = 0},	{Item = "none", Amount = 0},	{Item = "none", Amount = 0},
		{Item = "none", Amount = 0},	{Item = "none", Amount = 0},}
	ply.RE2Data["Chest"] = {
		{Weapon = "none", Upgrades = {}},{Weapon = "none", Upgrades = {}},{Weapon = "none", Upgrades = {}},
		{Weapon = "none", Upgrades = {}},{Weapon = "none", Upgrades = {}},{Weapon = "none", Upgrades = {}},
		{Weapon = "none", Upgrades = {}},{Weapon = "none", Upgrades = {}},{Weapon = "none", Upgrades = {}},
		{Weapon = "none", Upgrades = {}},{Weapon = "none", Upgrades = {}},{Weapon = "none", Upgrades = {}},
		{Weapon = "none", Upgrades = {}},{Weapon = "none", Upgrades = {}},{Weapon = "none", Upgrades = {}},
		{Weapon = "none", Upgrades = {}},{Weapon = "none", Upgrades = {}},{Weapon = "none", Upgrades = {}},
		{Weapon = "none", Upgrades = {}},{Weapon = "none", Upgrades = {}},	}
	ply.RE2Data["Upgrades"] = {}

	ply.RE2Data["Stats"] = {}
	ply.RE2Data["Crosshaircolor"] = {}

	for _,weapon in pairs(GAMEMODE.Weapons) do
		ply.RE2Data["Upgrades"][_] = {}
		ply.RE2Data["Upgrades"][_] = {pwrlvl = 1, acclvl = 1, clplvl = 1, fislvl = 1,reslvl = 1}
	end
	

	if not file.Exists(path_FilePath, "DATA") then
		ply:SetNWInt("Money",GAMEMODE.Config.StartingMoney)
		inv_AddToInventory(ply,"item_9mmhandgun")
		ply.Perks = {}
	elseif file.Exists(path_FilePath, "DATA") then
		local savetable = util.KeyValuesToTable(file.Read(path_FilePath) )
		local inv = savetable["inventory"]
		local muney = savetable["money"]
		local upg = savetable["upgrades"]
		local chestie = savetable["chest"]
		local purks = savetable["perks"]

		ply:SetNWInt("Money",tonumber(muney) )

		for k,v in pairs(inv) do
			if v["item"] != "none" then
				for i=1, v.amount do
					inv_AddToInventory(ply,v["item"])
				end
			end
		end
		ply.RE2Data["Upgrades"] = {}
		ply.RE2Data["Upgrades"] =  upg
		-----------------------------------------
		--------------------------------------
		---------perks-----------------
		ply.Perks = {}
		if purks != nil then
			PrintTable(purks)
			for k,v in pairs(purks) do
				if v != nil then
					ply.Perks[tonumber(k)] = {}
					ply.Perks[tonumber(k)].Perk = v.perk
					ply.Perks[tonumber(k)].Active = false
				end
			end
			PrintTable(purks)
		end
		-----------------------------------------
		-------------------------------------------
		-----------------------------------------

		for k,v in pairs(chestie) do
			if v.weapon != "none" then
				ply.RE2Data["Chest"][tonumber(k)].Weapon = tostring(v.weapon)
				ply.RE2Data["Chest"][tonumber(k)].Upgrades = v["upgrades"]
				if v.weapon == 0 then
					ply.RE2Data["Chest"][tonumber(k)].Weapon = "none"
					ply.RE2Data["Chest"][tonumber(k)].Upgrades = {}
				end
			end
		end
	end
	GAMEMODE:SendDataToAClient(ply)
end











-------------Vote Savings

function GM:EstablishRules()

	local FilePath = "re2/rules/rules.txt"

	if file.Exists(FilePath, "DATA") then
		local NewRules = util.KeyValuesToTable(file.Read(FilePath))

		SetGlobalString("Re2_Difficulty",tostring(NewRules["difficulty"]))

		local NewGamemode = NewRules["gamemode"]
			if GAMEMODE.Gamemode[NewGamemode] != nil then
				SetGlobalString( "RE2_Game", NewGamemode)
			else
				local chance = math.random(1,3)
				if chance == 1 then
					SetGlobalString( "RE2_Game", "Survivor" )
				elseif chance == 2 then
					SetGlobalString( "RE2_Game", "Survivor" )
				elseif chance == 3 then
					SetGlobalString( "RE2_Game", "Survivor" )
				end
			end
	else

		SetGlobalString("Re2_Difficulty","Normal")

		local chance = math.random(1,3)
		if chance == 1 then
			SetGlobalString( "RE2_Game", "Survivor" )
		elseif chance == 2 then
			SetGlobalString( "RE2_Game", "Survivor" )
		elseif chance == 3 then
			SetGlobalString( "RE2_Game", "Survivor" )
		end
	end

end
