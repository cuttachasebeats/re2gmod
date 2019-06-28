---------VOTING

net.Receive("VoteTransfer", function(len, ply)

--Look Into Init.lua for reference--

		if ply.Voted then
			GAMEMODE:RemoveVote(ply,ply.Voted)
		end
		local VoteMap = net.ReadString()
		local VoteGame = net.ReadString()
		local VoteDifficulty = net.ReadString()

		GAMEMODE.VotingMaps[tostring(VoteMap)] = GAMEMODE.VotingMaps[tostring(VoteMap)] + 1


		GAMEMODE.VotingDifficulty[tostring(VoteDifficulty)] = GAMEMODE.VotingDifficulty[tostring(VoteDifficulty)] + 1
		if VoteDifficulty == "Easy" then
			GAMEMODE.VotingDifficulty["Normal"] = GAMEMODE.VotingDifficulty["Normal"] + .4
		elseif VoteDifficulty == "Normal" then
			GAMEMODE.VotingDifficulty["Easy"] = GAMEMODE.VotingDifficulty["Easy"] + .4
			GAMEMODE.VotingDifficulty["Difficult"] = GAMEMODE.VotingDifficulty["Difficult"] + .4
		elseif VoteDifficulty == "Difficult" then
			GAMEMODE.VotingDifficulty["Normal"] = GAMEMODE.VotingDifficulty["Normal"] + .4
			GAMEMODE.VotingDifficulty["Expert"] = GAMEMODE.VotingDifficulty["Expert"] + .4
		elseif VoteDifficulty == "Expert" then
			GAMEMODE.VotingDifficulty["Difficult"] = GAMEMODE.VotingDifficulty["Difficult"] + .4
			GAMEMODE.VotingDifficulty["Suicidal"] = GAMEMODE.VotingDifficulty["Suicidal"] + .4
		elseif VoteDifficulty == "Suicidal" then
			GAMEMODE.VotingDifficulty["Expert"] = GAMEMODE.VotingDifficulty["Expert"] + .4
		end

		PrintMessage(HUD_PRINTTALK,ply:Nick().." Voted "..VoteDifficulty.." on "..VoteMap.." and gamemode "..VoteGame)

		for tablename,data in pairs(GAMEMODE.Gamemode) do
			if data.Name != nil && VoteGame == data.Name then
				VoteGame = tablename
			end
		end

		if VoteGame == "Team_VIP" then
			GAMEMODE.VotingGamemodes["VIP"] = GAMEMODE.VotingGamemodes["VIP"] + .5
		elseif VoteGame == "VIP" then
			GAMEMODE.VotingGamemodes["Team_VIP"] = GAMEMODE.VotingGamemodes["Team_VIP"] + .5
		end
		GAMEMODE.VotingGamemodes[tostring(VoteGame)] = GAMEMODE.VotingGamemodes[tostring(VoteGame)] + 1

		ply.Voted = {VoteMap,VoteGame,VoteCrows,VoteDifficulty,VoteMerchantTime,VoteClassic,}

	end
)


function GM:RemoveVote(ply,RemoveTable)
	local VoteMap = RemoveTable[1]
	local VoteGame = RemoveTable[2]
	local VoteDifficulty = RemoveTable[4]

	local classicmessage = ""

	GAMEMODE.VotingMaps[tostring(VoteMap)] = GAMEMODE.VotingMaps[tostring(VoteMap)] - 1

	GAMEMODE.VotingDifficulty[tostring(VoteDifficulty)] = GAMEMODE.VotingDifficulty[tostring(VoteDifficulty)] - 1
	if VoteDifficulty == "Easy" then
		GAMEMODE.VotingDifficulty["Normal"] = GAMEMODE.VotingDifficulty["Normal"] - .4
	elseif VoteDifficulty == "Normal" then
		GAMEMODE.VotingDifficulty["Easy"] = GAMEMODE.VotingDifficulty["Easy"] - .4
		GAMEMODE.VotingDifficulty["Difficult"] = GAMEMODE.VotingDifficulty["Difficult"] - .4
	elseif VoteDifficulty == "Difficult" then
		GAMEMODE.VotingDifficulty["Normal"] = GAMEMODE.VotingDifficulty["Normal"] - .4
		GAMEMODE.VotingDifficulty["Expert"] = GAMEMODE.VotingDifficulty["Expert"] - .4
	elseif VoteDifficulty == "Expert" then
		GAMEMODE.VotingDifficulty["Difficult"] = GAMEMODE.VotingDifficulty["Difficult"] - .4
		GAMEMODE.VotingDifficulty["Suicidal"] = GAMEMODE.VotingDifficulty["Suicidal"] - .4
	elseif VoteDifficulty == "Suicidal" then
		GAMEMODE.VotingDifficulty["Expert"] = GAMEMODE.VotingDifficulty["Expert"] - .4
	end

	for tablename,data in pairs(GAMEMODE.Gamemode) do
		if data.Name != nil && VoteGame == data.Name then
			VoteGame = tablename
		end
	end

	if VoteGame == "Team_VIP" then
		GAMEMODE.VotingGamemodes["VIP"] = GAMEMODE.VotingGamemodes["VIP"] - .5
	elseif VoteGame == "VIP" then
		GAMEMODE.VotingGamemodes["Team_VIP"] = GAMEMODE.VotingGamemodes["Team_VIP"] - .5
	end

	GAMEMODE.VotingGamemodes[tostring(VoteGame)] = GAMEMODE.VotingGamemodes[tostring(VoteGame)] - 1

end

local RandomMapNames = {}
local RandomDifficulties = {}



function GM:DecideVotes()
	local FilePath = "re2/rules/rules.txt"

	local gamemode = "Survivor"

		for a,b in pairs(GAMEMODE.VotingGamemodes) do
			if GAMEMODE.VotingGamemodes[a] > GAMEMODE.VotingGamemodes[gamemode] && a != gamemode then
				gamemode = tostring(a)
			end
		end
		RandomMapNames = {}
		for k,v in pairs(GAMEMODE.MapListTable) do
			table.insert(RandomMapNames,k)
		end
		RandomDifficulties = {}
		for k,v in pairs(GAMEMODE.ZombieData) do
			if k != "Zombies" then
				table.insert(RandomDifficulties,k)
			end
		end

	local NewMap = table.Random(RandomMapNames)

		for map,data in pairs(GAMEMODE.VotingMaps) do
			if GAMEMODE.VotingMaps[map] > GAMEMODE.VotingMaps[NewMap] && map != NewMap then
				NewMap = tostring(map)
			end
		end
		for map,data in pairs(GAMEMODE.MapListTable) do
			if NewMap == map && GAMEMODE.MapListTable[NewMap].Escape != nil && gamemode != "Escape" then
				local RandomVotemaps = {}
				for name,votes in pairs(GAMEMODE.VotingMaps) do
					--if GAMEMODE.Table[name].Escape == nil && votes >= 0 then
					if GAMEMODE.VotingGamemodes.Escape == nil && votes >= 0 then
						table.insert(RandomVotemaps,name)
					end
				end
				NewMap = table.Random(RandomVotemaps)
				break
			elseif NewMap == map && GAMEMODE.MapListTable[NewMap].Escape == nil && gamemode == "Escape" then
				gamemode = "Survivor"
			end
		end

	local NewDifficulty = table.Random(RandomDifficulties)
		for key,difficulty in pairs(GAMEMODE.VotingDifficulty) do
			if key != "Zombies" && GAMEMODE.VotingDifficulty[key] > 0 && difficulty >= GAMEMODE.VotingDifficulty[NewDifficulty] && GAMEMODE.VotingDifficulty[key] != NewDifficulty then
				NewDifficulty = key
			end
		end

	local VoteTable = {
	gamemode = gamemode,
	difficulty = NewDifficulty,
	
	}
	
	
	
	if (!file.Exists("re2/rules/","DATA")) then
		file.CreateDir("re2/rules/", "DATA")
	end

	file.Write(FilePath,util.TableToKeyValues(VoteTable))

	timer.Simple(5,function() RunConsoleCommand("changelevel", tostring(NewMap) ) end)
	if GAMEMODE.Gamemode[gamemode].Name != nil then
		gamemode = GAMEMODE.Gamemode[gamemode].Name
	end
	if NewMap != nil then
		print(NewMap)
		PrintMessage(HUD_PRINTTALK,"Changing to "..NewMap.." in 5 seconds. The gamemode will be "..gamemode.." and it will be "..NewDifficulty)
	else
		RunConsoleCommand("changelevel", "re2_policestation" )
	end
end
