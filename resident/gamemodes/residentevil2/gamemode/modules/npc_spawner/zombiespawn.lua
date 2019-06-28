include("zombiedata.lua")
 

--SpawningZombies

GM.ZombieData.Zombies = {
	"snpc_zombie",
	"snpc_zombie",
	"snpc_zombie",
	"snpc_zombie",
	"snpc_zombie",
	"snpc_zombie",
	"snpc_zombie",
	"snpc_zombie_crimzon",
}
GM.ZombieDataslow = 7
GM.ZombieDatafast = 1

function GM:SpawningZombies()
	if GetGlobalString("Mode") == "On" then
		for j,h in pairs(ents.FindByClass("ent_zombie_spawn")) do
			if !h.Disabled then
				if #ents.FindByClass("snpc_shambler3") < (#player.GetAll() * 2)+20 then
					local Blocked = false
					for k,v in pairs(ents.FindInSphere(h:GetPos(),100)) do
						if v:GetClass() == "snpc_shambler3" || v:GetClass() == "snpc_zombie_dog" || v:GetClass() == "snpc_zombie_nemesis" || v:GetClass() == "snpc_shamblerb2" then
							Blocked = true
						end
					end
					local Chance = math.random(0,300/GAMEMODE.ZombieData[GetGlobalString("RE2_Difficulty")].Modifier)
					if !Blocked && NumZombies <= GAMEMODE.Config.MaxZombies then
						if Chance <= 10 then
							local Zombie = "snpc_zombie_dog"
							local ent = ents.Create(Zombie)
							ent:SetPos(h:GetPos())
							ent:Spawn()
							ent:SetHealth(math.random(20*GAMEMODE.ZombieData[GetGlobalString("RE2_Difficulty")].Modifier, 50*GAMEMODE.ZombieData[GetGlobalString("RE2_Difficulty")].Modifier))
							NumZombies = NumZombies + 1
						end
					end
					if !Blocked && NumZombies <= GAMEMODE.Config.MaxZombies then
						if Chance == 11 then
							local Zombie = "snpc_zombie_nemesis"
							local ent = ents.Create(Zombie)
							ent:SetPos(h:GetPos())
							ent:Spawn()
							ent:SetHealth(math.random(400*GAMEMODE.ZombieData[GetGlobalString("RE2_Difficulty")].Modifier, 800*GAMEMODE.ZombieData[GetGlobalString("RE2_Difficulty")].Modifier))
							NumZombies = NumZombies + 1
						end
					end
					
						if !Blocked && NumZombies <= GAMEMODE.Config.MaxZombies then
						if Chance >= 13 then
						local ent = ents.Create("snpc_shambler3") --GAMEMODE.ZombieData.Zombies[math.random(1,#GAMEMODE.ZombieData.Zombies)])
						local min = GAMEMODE.ZombieData[GetGlobalString("RE2_Difficulty")].ZombieHealth[GAMEMODE.int_DifficultyLevel]
						local max = GAMEMODE.ZombieData[GetGlobalString("RE2_Difficulty")].ZombieMaxHealth[GAMEMODE.int_DifficultyLevel]
						ent:SetHealth(math.random(min, max))
						ent:SetPos(h:GetPos())
						ent:Spawn()
						NumZombies = NumZombies + 1
						ent:setAttackSpeed(GAMEMODE.ZombieData[GetGlobalString("RE2_Difficulty")].ZombieAttackSpeed[GAMEMODE.int_DifficultyLevel])
						if (math.random(0, GAMEMODE.ZombieDataslow + GAMEMODE.ZombieDatafast) > GAMEMODE.ZombieDataslow) then
							ent:setRunning(true)
							ent:setRunSpeed(ent:getRunSpeed() * math.random(GAMEMODE.ZombieData[GetGlobalString("RE2_Difficulty")].ZombieMinSpeed, GAMEMODE.ZombieData[GetGlobalString("RE2_Difficulty")].ZombieMaxSpeed))
						else
							ent:setWalkSpeed(ent:getWalkSpeed() * math.random(GAMEMODE.ZombieData[GetGlobalString("RE2_Difficulty")].ZombieMinSpeed, GAMEMODE.ZombieData[GetGlobalString("RE2_Difficulty")].ZombieMaxSpeed))
						end
						end
						end
				end
			end
		end
	end
end

function GM:DoInfection(ply)
	if ply:GetNWBool("Infected") && ply:Alive() && ply:GetNWInt("InfectedPercent") < 100 then
		local add = math.random(1,5)
		ply:SetNWInt("InfectedPercent",ply:GetNWInt("InfectedPercent") + add)
		timer.Simple(10,function() GAMEMODE:DoInfection(ply) end)
		if ply:GetNWInt("InfectedPercent") >= 100 then
			ply:Kill()
		end
	end
end

function GM:ScaleNPCDamage(npc,hitgroup,dmginfo)
   if hitgroup == 1 then
		dmginfo:ScaleDamage(10)
	elseif hitgroup == 2 then
		dmginfo:ScaleDamage(2)
	elseif hitgroup == 3 then
		dmginfo:ScaleDamage(1.5)
   end
end