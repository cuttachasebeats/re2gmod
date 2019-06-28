hook.Add("ShouldCollide","COLLID",function(ent,a)
	
	if( ent:IsPlayer() && a:IsPlayer()  ) then
		return false
	end
	
	
end)

hook.Add("ShowTeam","DisableTeams",function(ent,a)
	
	return false
	
	
end)

local onlyonce = false

hook.Add("PlayerSay","GotStuck",function(ply, text, team)

	if string.sub(text,1,6) == "!stuck" then
	
	
	for _,spawnpoint in pairs(ents.FindByClass("Re2_player_round_start")) do
		if GetGlobalString("Mode") == "On" then
					if !spawnpoint.Taken && onlyonce == false then
						ply:SetPos(spawnpoint:GetPos())
						spawnpoint.Taken = true
						onlyonce = true
						timer.Simple(15, function() onlyonce = false  end)
						break
					end
		end

	end
			
		ply:ChatPrint("Can Only Do Once")
		
		
	end

end)

-------------------PVP Hook--------------------------
hook.Add("PlayerShouldTakeDamage","KillPlayers", function(ply,a)
	
	if (GetGlobalString("RE2_Game") == "PVP") && GetGlobalString( "Mode", "On" ) && ply:IsPlayer() && a:IsPlayer() && ply:Team() == a:Team() then
		return true
	end

end)


---------------------Players do not collide---------------------		
hook.Add("PlayerSpawn", "CollisionCheck.PlayerSpawn", function(ply)
	ply:SetCustomCollisionCheck(true)
end)

--------Makes sure players cannot pick up nemesis minigun------------------
hook.Add( "PlayerCanPickupWeapon", "NoNPCPickups", function( ply, wep )
	if ( wep.IsNPCWeapon ) then return false end
end )

-----------a zombie spawns in the dead players place when they die--------------------
hook.Add("PlayerDeath","TurnPlayerZombie",function(ply,a,b)
	if(a:GetClass() == "snpc_shambler3" || b:GetClass() == "snpc_shambler3") then
		local ent = ents.Create("snpc_shambler3")
		ent:SetPos(ply:GetPos())
		ent:Spawn()
		NumZombies = NumZombies + 1
	end
end)



--------------------------Health Bars--------------------------------



function HoveringNames()
	
	
	
	for _, target in pairs(player.GetAll()) do
		if target:Alive() and target != LocalPlayer() then
		
			local targetPos = target:GetPos() + Vector(0,0,84)
			local tt = target:GetPos() + Vector(0,0,100)
			local targetDistance = math.floor((LocalPlayer():GetPos():Distance( targetPos ))/40)
			local targetScreenpos = targetPos:ToScreen()
			local ttscreen = tt:ToScreen()
			draw.SimpleText(target:Nick(), "Trebuchet18", tonumber(targetScreenpos.x), tonumber(targetScreenpos.y), Color(200,25,25,200), TEXT_ALIGN_CENTER)
			draw.SimpleText(target:Health(), "Trebuchet18", tonumber(targetScreenpos.x), tonumber(ttscreen.y), Color(200,25,25,200), TEXT_ALIGN_CENTER)
			
		end
		if not target:Alive() then end
	end

	for k, v in pairs (ents.GetAll()) do 
		if v:GetClass() == "snpc_zombie_nemesis" then 
			local targetPos = v:GetPos() + Vector(0,0,84)
			local tt = v:GetPos() + Vector(0,0,100)
			local targetDistance = math.floor((LocalPlayer():GetPos():Distance( targetPos ))/40)
			local targetScreenpos = targetPos:ToScreen()
			local ttscreen = tt:ToScreen()
			draw.SimpleText(v:Health(), "Trebuchet18", tonumber(targetScreenpos.x), tonumber(ttscreen.y), Color(255,255,120,100), TEXT_ALIGN_CENTER)
			
		end 
	end 
	
	for k, v in pairs (ents.GetAll()) do 
		if v:GetClass() == "snpc_zombie_jeff" then 
			local targetPos = v:GetPos() + Vector(0,0,84)
			local tt = v:GetPos() + Vector(0,0,100)
			local targetDistance = math.floor((LocalPlayer():GetPos():Distance( targetPos ))/40)
			local targetScreenpos = targetPos:ToScreen()
			local ttscreen = tt:ToScreen()
			draw.SimpleText(v:Health(), "Trebuchet18", tonumber(targetScreenpos.x), tonumber(ttscreen.y), Color(255,255,25,100), TEXT_ALIGN_CENTER)
			
		end 
	end 
	
	for k, v in pairs (ents.GetAll()) do 
		if v:GetClass() == "snpc_zombie_king" then 
			local targetPos = v:GetPos() + Vector(0,0,84)
			local tt = v:GetPos() + Vector(0,0,100)
			local targetDistance = math.floor((LocalPlayer():GetPos():Distance( targetPos ))/40)
			local targetScreenpos = targetPos:ToScreen()
			local ttscreen = tt:ToScreen()
			draw.SimpleText(v:Health(), "Trebuchet18", tonumber(targetScreenpos.x), tonumber(ttscreen.y), Color(255,255,25,100), TEXT_ALIGN_CENTER)
			
		end 
	end 
	for k, v in pairs (ents.GetAll()) do 
		if v:GetClass() == "snpc_wesker" then 
			local targetPos = v:GetPos() + Vector(0,0,84)
			local tt = v:GetPos() + Vector(0,0,100)
			local targetDistance = math.floor((LocalPlayer():GetPos():Distance( targetPos ))/40)
			local targetScreenpos = targetPos:ToScreen()
			local ttscreen = tt:ToScreen()
			draw.SimpleText(v:Health(), "Trebuchet18", tonumber(targetScreenpos.x), tonumber(ttscreen.y), Color(255,255,25,100), TEXT_ALIGN_CENTER)
			
		end 
	end 
	for k, v in pairs (ents.GetAll()) do 
		if v:GetClass() == "npc_re_tyrant2" then 
			local targetPos = v:GetPos() + Vector(0,0,84)
			local tt = v:GetPos() + Vector(0,0,100)
			local targetDistance = math.floor((LocalPlayer():GetPos():Distance( targetPos ))/40)
			local targetScreenpos = targetPos:ToScreen()
			local ttscreen = tt:ToScreen()
			draw.SimpleText(v:Health(), "Trebuchet18", tonumber(targetScreenpos.x), tonumber(ttscreen.y), Color(255,255,25,100), TEXT_ALIGN_CENTER)
			
		end 
	end 
end
hook.Add("HUDPaint", "HoveringNames", HoveringNames)

--collision from rockets and grenades

local function ShouldCollideTestHook( ent1, ent2 )
	if ( ent1:GetClass() == "snpc_shambler3" and ent2:GetClass() == "snpc_shambler3" ) then
		//if (ent1:getRunning() && !ent2:getRunning()) || (!ent1:getRunning() && ent2:getRunning()) then
			return false --Returning false makes the entities not collide with eachother
		//end
	elseif ent1:GetClass() == "Quad_Rocket" && ent2:IsPlayer() then
		return false
	elseif ent1:GetClass() == "m79_bomb" && ent2:IsPlayer() then
		return false
	end
	-- DO NOT RETURN TRUE HERE OR YOU WILL FORCE EVERY OTHER ENTITY TO COLLIDE
end
hook.Add( "ShouldCollide", "ShouldCollideTestHook", ShouldCollideTestHook )



--Barricades on maps to take damage from zombies---

function cadeEntityTakeDamage( ent, dmginfo )
	if IsValid(ent) then
		if ent.isCade then
			if dmginfo:GetAttacker():GetClass() == "player" then dmginfo:SetDamage(0) end
			if dmginfo:GetAttacker():GetClass() == "env_explosion" && dmginfo:GetAttacker().Owner:IsPlayer() then dmginfo:SetDamage(0) end
			ent:SetHealth(ent:Health() - dmginfo:GetDamage())
			if (dmginfo:GetAttacker():GetClass() == "snpc_shambler3") then
				dmginfo:GetAttacker().times = dmginfo:GetAttacker().times/2
			end
			if ent:Health() <= 0 then
				ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
				ent.isCade = false
				if (dmginfo:GetAttacker():GetClass() == "snpc_*") then
						dmginfo:GetAttacker():findEnemy()
				end
				ent:GetPhysicsObject():EnableMotion(true)
				ent:GetPhysicsObject():Wake()
				if ent:GetPhysicsObject():IsDragEnabled() then
					ent:GetPhysicsObject():SetDragCoefficient(0.4)
				end
				ent:GetPhysicsObject():ApplyForceCenter(dmginfo:GetDamageForce())
			end
		end
	end
end
hook.Add("EntityTakeDamage", "cadeEntityTakeDamage", cadeEntityTakeDamage)