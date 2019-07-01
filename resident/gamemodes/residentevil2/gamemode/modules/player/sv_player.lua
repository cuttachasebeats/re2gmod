--[[function GM:ShowTeam( ply )
	if ply:Team() == TEAM_SPECTATOR || #ents.FindByClass("Re2_Merchant") == 0 || (GetGlobalString("Mode") == "Merchant" && ply:Team() == TEAM_HUNK ) then
		ply:ConCommand( "Re2_MerchantMenu" )
	end
end

function GM:ShowHelp( ply )
	ply:ConCommand( "ShowOptionsMenu" )
end

function GM:ShowSpare1( ply )
	if ply:Team() == TEAM_SPECTATOR || #ents.FindByClass("Re2_Chest") == 0 || (GetGlobalString("Mode") == "Merchant" && ply:Team() == TEAM_HUNK) then
		ply:ConCommand( "Re2_ChestMenu" )
	end
end

function GM:ShowSpare2( ply )
	ply:ConCommand( "Re2_VoteMenu" )
end
]]--
function GM:PlayerInitialSpawn(ply)

	if ply:Team() != TEAM_HUNK then
	ply:SetNoCollideWithTeammates( true )
	end

	ply:SetViewEntity(ply)
	ply.ActivePerks = {0,0}
	ply.CanEarn = true

	ply:SetNWString("RE2_DisplayAmmotype", "CombineCannon")

	if GAMEMODE.TEMP_DeadPlayers[ply:UniqueID()] || GAMEMODE.TEMP_DeadPlayers[ply:UniqueID()] == nil then
		ply:SetTeam(TEAM_HUNK)
	elseif !GAMEMODE.TEMP_DeadPlayers[ply:UniqueID()] or !ply:Team(TEAM_BUNK) or !ply:Team(TEAM_FUNK) then
		ply:SetTeam(TEAM_SPECTATOR)
		ply:Spectate( OBS_MODE_ROAMING )
	end

	ply:SetNWInt("Speed",165)

	GAMEMODE:Load(ply)
	timer.Simple(10,function()
		if GetGlobalString("Mode") != "Merchant" && ents.FindByClass("Re2_player_round_start") != nil then
			local randomspawnpoint = table.Random(ents.FindByClass("Re2_player_round_start"))
			ply:SetPos(randomspawnpoint:GetPos())
		end
	end)
	if GAMEMODE.Gamemode[GetGlobalString("Re2_Game")] != nil then
		if GAMEMODE.Gamemode[GetGlobalString("Re2_Game")].JoinFunction != nil then
			GAMEMODE.Gamemode[GetGlobalString("Re2_Game")].JoinFunction(ply)
		end
	end

end


local mdls = {}

mdls["kleiner"] = "models/player/Kleiner.mdl"
mdls["mossman"] = "models/player/mossman.mdl"
mdls["alyx"] = "models/player/alyx.mdl"
mdls["barney"] = "models/player/barney.mdl"
mdls["breen"] = "models/player/breen.mdl"
mdls["monk"] = "models/player/monk.mdl"
mdls["odessa"] = "models/player/odessa.mdl"
mdls["combine"] = "models/player/combine_soldier.mdl"
mdls["prison"] = "models/player/combine_soldier_prisonguard.mdl"
mdls["super"] = "models/player/combine_super_soldier.mdl"
mdls["police"] = "models/player/police.mdl"
mdls["gman"] = "models/player/gman_high.mdl"

mdls["female1"] = "models/player/Group01/female_01.mdl"
mdls["female2"] = "models/player/Group01/female_02.mdl"
mdls["female3"] = "models/player/Group01/female_03.mdl"
mdls["female4"] = "models/player/Group01/female_04.mdl"
mdls["female5"] = "models/player/Group01/female_06.mdl"
mdls["female7"] = "models/player/Group03/female_01.mdl"
mdls["female8"] = "models/player/Group03/female_02.mdl"
mdls["female9"] = "models/player/Group03/female_03.mdl"
mdls["female10"] = "models/player/Group03/female_04.mdl"
mdls["female11"] = "models/player/Group03/female_06.mdl"

mdls["male1"] = "models/player/Group01/male_01.mdl"
mdls["male2"] = "models/player/Group01/male_02.mdl"
mdls["male3"] = "models/player/Group01/male_03.mdl"
mdls["male4"] = "models/player/Group01/male_04.mdl"
mdls["male5"] = "models/player/Group01/male_05.mdl"
mdls["male6"] = "models/player/Group01/male_06.mdl"
mdls["male7"] = "models/player/Group01/male_07.mdl"
mdls["male8"] = "models/player/Group01/male_08.mdl"
mdls["male9"] = "models/player/Group01/male_09.mdl"

mdls["male10"] = "models/player/Group03/male_01.mdl"
mdls["male11"] = "models/player/Group03/male_02.mdl"
mdls["male12"] = "models/player/Group03/male_03.mdl"
mdls["male13"] = "models/player/Group03/male_04.mdl"
mdls["male14"] = "models/player/Group03/male_05.mdl"
mdls["male15"] = "models/player/Group03/male_06.mdl"
mdls["male16"] = "models/player/Group03/male_07.mdl"
mdls["male17"] = "models/player/Group03/male_08.mdl"
mdls["male18"] = "models/player/Group03/male_09.mdl"

function GM:PlayerSpawn(ply)

	if ply:Team() == TEAM_HUNK || ply:Team() == TEAM_FUNK then
		ply:SetNWBool("Infected", false)
		ply:SetNWInt("InfectedPercent", 0)
		ply:SetModel(table.Random(mdls))
		GAMEMODE:PlayerLoadout(ply)
		ply:SetNWInt("killcount",0)
		ply:SetNWInt("Time",0)
		ply:SetNWInt("MaxHP", 100)
		ply:SetNWInt("Immunity", 25)
		ply:AllowFlashlight(true)
	else
		ply:AllowFlashlight(false)
		if GetGlobalBool("Re2_Crows") then
			ply:BecomeCrow()
			ply:SetNoCollideWithTeammates( true )
		else
			ply:Spectate( OBS_MODE_ROAMING )
		end
	end
	if ply:Team() != TEAM_SPECTATOR then
		ply:EmitSound("residentevil/residentevilfx_re.mp3",110,100)
	end

	GAMEMODE:SetPlayerSpeed(ply,ply:GetNWInt("Speed"),ply:GetNWInt("Speed"))
	ply.CanUse = true
	GAMEMODE:SendDataToAClient(ply)
end

function GM:DoPlayerDeath(ply,attacker,dmginfo)
	ply:CreateRagdoll()

	ply:SetTeam(TEAM_SPECTATOR)

	ply:Freeze(false)

	ply.NextSpawnTime = CurTime() + 30
	ply.DeathTime = CurTime()

	for _,explosive in pairs(ents.FindByClass("item_base")) do
		if explosive:GetNWString("Class") == "item_c4" || explosive:GetNWString("Class") == "item_landmine" then
			if explosive.Owner == ply && explosive.Armed then
				explosive.Owner = nil
				explosive.Armed = nil
				explosive.Flare:Remove()
			end
		end
	end

	if GetGlobalString("Mode") != "End" then
		for k,v in pairs(ply.Perks) do
			ply:ConCommand("UnMountPerk",v.Perk)
		end
	end


	GAMEMODE:GameCheck()
end

function GM:CanPlayerSuicide( ply )
	ply:PrintTranslatedMessage(HUD_PRINTTALK, "cant_suicide")
	return true
end


function GM:PlayerDeathThink( ply )

	if (  ply.NextSpawnTime && ply.NextSpawnTime > CurTime() ) then return end

	if ( ply:KeyPressed( IN_ATTACK ) || ply:KeyPressed( IN_ATTACK2 ) || ply:KeyPressed( IN_JUMP ) ) then
		ply:SetNWBool("Infected", false)
		ply:SetNWInt("InfectedPercent", 0)

		ply:DeathReward()

		ply:SetTeam(TEAM_SPECTATOR)
		ply:Spawn()
	end

end

function GM:PlayerLoadout(ply)
	for k,v in pairs(ply.RE2Data["Inventory"]) do
		for a,b in pairs(GAMEMODE.Weapons) do
			if v.Item == a && b.Weapon != nil then
				ply:Give(b.Weapon)
			end
		end
	end
	ply:Give("weapon_detonator_re")
	ply:Give("weapon_knife")
	ply:SelectWeapon("weapon_knife")
	for _,ammo in pairs(GAMEMODE.AmmoMax) do
		if _ != "none" then
			ply:GiveAmmo(ammo.number,tostring(_),true)
		end
	end
end

function GM:PlayerHurt(ply,attacker)
	if ply:Team() == TEAM_HUNK then
		if ply:Health() >= 51 and ply:Health() <= 74 then
			ply:SetNWInt("Speed",155)
		elseif ply:Health() >= 20 and ply:Health() <= 50 then
			ply:SetNWInt("Speed",145)
		elseif ply:Health() <= 19 then
			ply:SetNWInt("Speed",135)
		end
		if ply.CurSpeed == ply:GetNWInt("Speed") then
			GAMEMODE:SetPlayerSpeed(ply,ply:GetNWInt("Speed"),ply:GetNWInt("Speed"))
		end
	end
	if attacker:GetClass() == "snpc_shambler3" or (attacker:GetClass() == "snpc_zombie_dog" && GAMEMODE.ZombieData[GetGlobalString("Re2_Difficulty")].Modifier >= 7) or (attacker:GetClass() == "snpc_shamblerb2" && GAMEMODE.ZombieData[GetGlobalString("Re2_Difficulty")].Modifier >= 7) then
		local ResistChance = math.random(1,200)
		if ResistChance >= ply:GetNWInt("Immunity") then
			if !ply:GetNWBool("Infected") then
				ply:EmitSound("HL1/fvox/biohazard_detected.wav",110,100)
				ply:SetNWBool("Infected",true)

				ply:AddStat("Infections",1)

				GAMEMODE:DoInfection(ply)
			end
		elseif ply:GetNWBool("Infected") == false then
			//ply:PrintMessage(HUD_PRINTTALK,"resisted infection")
		elseif ply:SetNWInt("Immunity", 101 ) then
			ply:SetNWBool("Infected", false)
		end
	elseif attacker:IsPlayer() && attacker:Team() == ply:Team() then
		return false
	end
end

function GM:SetPlayerSpeed( ply, walk, run )

	ply.CurSpeed = tonumber(walk)
	ply.Speeds = {Walk = walk, Run = walk, Sprint = run}
	ply:SetWalkSpeed( walk )
	ply:SetRunSpeed( run )

end


function GM:PlayerUse( ply, ent )
	if !ply.CanUse then return end
	if ply:Team() != TEAM_HUNK then return false end
		local pos = ply:GetShootPos()
		local ang = ply:GetAimVector()
		local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = pos+(ang*80)
		tracedata.filter = ply
		local trace = util.TraceLine(tracedata)
		if trace.HitNonWorld && trace.Entity:GetClass() == "item_base" then
		   ent = trace.Entity
		end
	return true
end

function GM:PlayerDisconnected( ply )
	GAMEMODE:Save(ply)
	for k,v in pairs(ply.Perks) do
		ply:ConCommand("UnMountPerk",v.Perk)
	end
	if GetGlobalString("Mode") == "On" then
		GAMEMODE.TEMP_DeadPlayers[ply:UniqueID()] = false
	end
	if GAMEMODE.Gamemode[GetGlobalString("RE2_Game")].DisconnectFunction != nil then
		GAMEMODE.Gamemode[GetGlobalString("RE2_Game")].DisconnectFunction(ply)
	end
	GAMEMODE:GameCheck()
end

function GM:PlayerShouldTakeDamage(victim,attacker)
	if victim == attacker then return true end
		if attacker:IsPlayer() && victim:IsPlayer() && attacker:Team() == victim:Team() then
			return false
		end
	if attacker:GetClass() == "env_explosion" && attacker.Owner != nil then
		if attacker.Suicidal && attacker.Owner != victim then
			return false
		elseif attacker.Suicidal && attacker.Owner == victim then
			return true
		elseif attacker.Owner == victim || (attacker.Owner:IsPlayer() && attacker.Owner:Team() == victim:Team())  then
			return false
		else
			return true
		end
	end
	return true
end

function GM:EntityTakeDamage( ent, dmginfo )

	if ( ent:IsPlayer() ) then
		ent:AddStat("DamageTaken",math.Round(dmginfo:GetDamage()))
	end
	if ( ent:IsPlayer() and dmginfo:IsExplosionDamage() ) then

		dmginfo:ScaleDamage( 0.4 ) // Damage is now half of what you would normally take.

	end


end
