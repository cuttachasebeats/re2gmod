AddCSLuaFile()

ENT.Base             = "base_nextbot"
ENT.Spawnable        = true

function ENT:Initialize()
    if self:GetModel() == nil or self:GetModel() == "models/error.mdl" then
        self:SetModel("models/nmr_zombie/berny.mdl")
    end
	self:SetCustomCollisionCheck( true )
	self:SetPos(self:GetPos() + Vector(math.random(-32),math.random(32),32))
    self.Entity:SetCollisionGroup( COLLISION_GROUP_NPC )
    self.Entity:SetCollisionBounds( Vector(-4,-4,0), Vector(4,4,64) ) // nice fat shaming
    //self:SetSolidMask(MASK_NPCSOLID_BRUSHONLY)

end

function ENT:IsNPC()
	return true
end

ENT.enemy = nil
function ENT:SetEnemy(newEnemy)
    self.enemy = newEnemy
end

function ENT:GetEnemy()
    return self.enemy
end
ENT.AttackSounds = {"npc/zombie/zo_attack1.wav","npc/zombie/zo_attack2.wav"}

function ENT:setAttackSounds(newAttackSounds)
    self.AttackSounds = newAttackSounds
end

function ENT:getAttackSounds()
    return self.AttackSounds
end

ENT.AttackAnims = {
    "attackA",
    "attackB",
    "attackC"
}
function ENT:setAttackAnims(newAttackAnims)
    self.AttackAnims = newAttackAnims
end

function ENT:getAttackAnims()
    return self.AttackAnims
end

ENT.InfectionChance = .25
function ENT:setInfectionChance(newInfectionChance)
    self.InfectionChance = newInfectionChance
end

function ENT:getInfectionChance()
    return self.InfectionChance
end

ENT.AttackSpeed = 4
function ENT:setAttackSpeed(attackSpeed)
    self.AttackSpeed = attackSpeed
end

function ENT:getAttackSpeed()
    return self.AttackSpeed
end

ENT.AttackDamage = 10
function ENT:setAttackDamage(attackDamage)
    self.AttackDamage = attackDamage
end

function ENT:getAttackDamage()
    return self.AttackDamage
end

ENT.RunSpeed = 200
function ENT:setRunSpeed(RunSpeed)
    self.RunSpeed = RunSpeed
end

function ENT:getRunSpeed()
    return self.RunSpeed
end

ENT.WalkSpeed = 200
function ENT:setWalkSpeed(WalkSpeed)
    self.WalkSpeed = WalkSpeed
end

function ENT:getWalkSpeed()
    return self.WalkSpeed
end

ENT.Running = false
function ENT:setRunning(newBool)
    self.Running = tobool(newBool)
end

function ENT:getRunning()
    return self.Running
end

ENT.LastAttack = 0
function ENT:setLastAttack(newLastAttack)
    self.LastAttack = newLastAttack
end

function ENT:getLastAttack()
    return self.LastAttack
end

function ENT:shouldTarget(ent)
    if ent:GetCollisionGroup() == COLLISION_GROUP_DEBRIS then return false end
    if ent.dontTarget then return false end
    if ent.isCade then
        return true
    else
        local phys = ent:GetPhysicsObject()
        if IsValid(phys) then
            if phys:GetVolume() > 300 && phys:IsMotionEnabled() then
                return true
            end
        end
    end
    return false
end

function ENT:findEnemy()
    local target = nil
    for key, ply in pairs(player.GetAll()) do
        if (IsValid(ply)&&ply:Alive()&&ply:Team() != TEAM_SPECTATOR&&ply:GetMoveType() == MOVETYPE_WALK) then
            if (!IsValid(target) or ply:GetPos():Distance( self:GetPos() ) < target:GetPos():Distance(self:GetPos())) then
                target = ply
            end
        end
    end

    for key, ent in pairs(ents.FindInSphere(self:GetPos(), 65 * (self.times/2))) do
        if (IsValid(ent) && self:shouldTarget(ent)) then
           self:AttackEntity(ent)
            if self:getRunning() then
                self:StartActivity( ACT_RUN )
            else
                self:StartActivity( ACT_WALK )
            end
        end
    end
    self:SetEnemy( target )
    return target
end

function ENT:MoveToEnemy( options )
    local options = options or {}

    local path = Path( "Chase" )
    path:SetMinLookAheadDistance( options.lookahead or 300 )
    path:SetGoalTolerance( options.tolerance or 20 )

    local enemy = self:findEnemy()
    path:Compute( self, enemy:GetPos() )

    if ( !path:IsValid() ) then return "failed" end

    while ( path:IsValid() && !self:CanAttack( self:GetEnemy() ) ) do

        path:Update( self )

        -- Draw the path (only visible on listen servers or single player)
        if ( options.draw ) then
            path:Draw()
        end

        -- If we're stuck then call the HandleStuck function and abandon
        if ( self.loco:IsStuck() ) then
            self:HandleStuck()
            return "stuck"
        end

        if ( options.maxage ) then
            if ( path:GetAge() > options.maxage ) then return "timeout" end
        end

        if ( options.repath ) then
            if ( path:GetAge() > options.repath ) then
                local updatedEnemy = self:findEnemy()
                if IsValid(updatedEnemy) then
                    path:Compute( self, updatedEnemy:GetPos() )
                else
                    return "failed"
                end
            end
        end
        coroutine.yield()
    end
    return "ok"
end

function ENT:CanAttack( entity )
    if IsValid(entity) && entity:GetPos():Distance(self:GetPos()) < 65 + (65 * (self.times/2)) then
        if entity:IsPlayer() && entity:Alive()  then
            return true
        elseif self:shouldTarget(entity) then
            return true
        end
    end
    return false
end

function ENT:AttackEntity( entity, options )
    while ( self:CanAttack( entity ) ) do
        self.loco:FaceTowards(entity:GetPos())
        local soundPath = table.Random(self:getAttackSounds())

        sound.Play(soundPath, self:GetPos() + Vector(0,0,50), 75, 100, 1 )

        self:PlaySequenceAndWait( table.Random(self:getAttackAnims()), self:getAttackSpeed() )
        self:setLastAttack(CurTime())
        if IsValid(entity) && entity:GetPos():Distance( self:GetPos() ) < 100 then

            local dmginfo = DamageInfo()
            dmginfo:SetDamageType(DMG_SLASH)
            dmginfo:SetDamage(self:getAttackDamage())

            local force = 1
            local phys = entity:GetPhysicsObject()
            if IsValid(phys) then
                force = phys:GetVolume()/phys:GetMass() * 10
            end

            if IsValid(self:GetEnemy()) then
                local dir = (self:GetEnemy():GetPos() - self:GetPos()):Angle()
                dmginfo:SetDamageForce( dir:Forward() * self:getAttackDamage() * force + dir:Up() * force )
            else
                dmginfo:SetDamageForce( self:GetAngles():Forward() * self:getAttackDamage() * force  )
            end
            dmginfo:SetAttacker(self)

            --[[if math.random(1, 1/self:getInfectionChance()) == 1 then
                entity
            end]]--
            entity:TakeDamageInfo(dmginfo)
        end

        if ( self.loco:IsStuck() ) then
            self:HandleStuck()
            return "stuck"
        end
        coroutine.yield()
    end
    return "ok"
end

function ENT:AttackEnemy( options )
    self:AttackEntity(self:GetEnemy(), options)
end

ENT.stuckPos = Vector(0,0,0)
ENT.times = 0
ENT.nextCheck = 0
local delay = 1
function ENT:BehaveUpdate( fInterval )

    if ( !self.BehaveThread ) then return end

    -- -- If you are not jumping yet and a player is close jump at them
    -- local ent = ents.FindInSphere( self:GetPos(), 30 )
    -- for k,v in pairs( ent ) do
    --     if v:IsPlayer() then
    --         self:SetSequence( "attackC" )
    --     end
    -- end
    if (!self.Frozen) then
      local modifier = 1
      if self:getRunning() then modifier = 2 end
      if self.nextCheck < CurTime() then
          if self.stuckPos:Distance(self:GetPos()) < 5 then
              self.times = self.times + 1
              if self.times > 10/modifier then
                  if CurTime() - self:getLastAttack() > 5 then
                      self:BecomeRagdoll( DamageInfo() )
                  else
                      if self.times > 20/modifier then
                          self:BecomeRagdoll( DamageInfo() )
                      end
                  end
              end
          else
              self.stuckPos = self:GetPos()
              self.times = 0
          end
          self.nextCheck = CurTime() + delay
      end

      local ok, message = coroutine.resume( self.BehaveThread )
      if ( ok == false ) then

          self.BehaveThread = nil
          Msg( self, "error: ", message, "\n" );

      end
    end
end

function ENT:RunBehaviour()

    while ( true ) do
        -- Find the player
        if (!self.Frozen) then
          local enemy = self:findEnemy()
          -- if the position is valid
          if ( GetGlobalString("Mode") != "End" && IsValid(enemy) ) then
              if self:getRunning() then
                  self.loco:SetDesiredSpeed( 400)
                  self:StartActivity( ACT_RUN )
              else
                  self.loco:SetDesiredSpeed( 400 )
                  self:StartActivity( ACT_WALK )
              end
                                              -- run speed
              local options = {  lookahead = 300,
                              tolerance = 20,
                              draw = false,
                              maxage = 1,
                              repath = 0.1    }
              if !self:CanAttack( self:GetEnemy() ) then
                  self:MoveToEnemy( options )
              elseif self:CanAttack( self:GetEnemy() ) then
                  self:AttackEnemy()
			  else
				  self:MoveToEnemy( options )
              end
          else
              self:StartActivity( ACT_WALK )
              self.loco:SetDesiredSpeed( self:getWalkSpeed() )
              self:MoveToPos( util.randRadius(self:GetPos(), 70, 150) ) -- walk to a random place within about 200 units (yielding)
          end
        end
        coroutine.yield()
    end

end

function ENT:OnLandOnGround()
    if self:getRunning() then
        self:StartActivity( ACT_RUN )
    else
        self:StartActivity( ACT_WALK )
    end
end

function ENT:Use( activator, caller, type, value )

end

function ENT:Think()

end

function ENT:ThawOut()
	if !self:IsValid() then return end
	self.Frozen = false
	self:SetPlaybackRate(self.PlaybackRate)
	self:EmitSound("physics/glass/glass_sheet_break1.wav",100,100)
	self:SetColor(Color(255,255,255,255))
	self:SetMaterial(self.Material)

	local vPoint = self:GetPos() + Vector(0,0,50)
	local effectdata = EffectData()
	effectdata:SetStart( vPoint )
	effectdata:SetOrigin( vPoint )
	effectdata:SetScale( 2 )
	util.Effect("GlassImpact", effectdata)
  self:setRunSpeed(self.oldRun)
  self:setWalkSpeed(self.oldWalk)
end

function ENT:OnInjured(dmginfo)
  local dmg = dmginfo
  if dmg:IsExplosionDamage() then
		dmg:SetDamage(dmg:GetDamage() * 2)
		if dmg:GetAttacker():GetClass() == "env_explosion" && dmg:GetAttacker().Owner != nil then
			dmg:SetAttacker(dmg:GetAttacker().Owner)
			if dmg:GetInflictor().Class == "Ice" && !self.Frozen then
				self.Frozen = true
        self.oldRun = self:getRunSpeed()
        self.oldWalk = self:getWalkSpeed()
				self:setRunSpeed(1)
        self:setWalkSpeed(1)
        self.PlaybackRate = self:GetPlaybackRate()
				self:SetPlaybackRate(0)
				dmg:SetDamage(dmg:GetDamage()/16)

        self.Material = self:GetMaterial()
      	self.Entity:SetMaterial("models/shiny")
      	self.Entity:SetColor(Color(230,230,255,255))

				if self.Flame != nil then
					if self.Flame:IsValid() then
						self.Flame:Remove()
					end
				end
				timer.Simple(math.random(10,50)/10,function()	if !self:IsValid() then return end  self:ThawOut() end)
			elseif dmg:GetInflictor().Class == "Flame" then
				dmg:SetDamage(dmg:GetDamage()*1.5)
				self.Flame = ents.Create("env_Fire")
				self.Flame:SetKeyValue("Health",math.random(50,150)/10)
				self.Flame:SetKeyValue("FireSize",math.random(40,60))
				self.Flame:SetPos(self:GetPos() + self:GetForward() * 5)
				self.Flame:SetParent(self)
				self.Flame:Spawn()
				self.Flame:Fire("StartFire")
			end
		end
	end
end

function ENT:OnKilled( dmginfo )
  local dmg = dmginfo
    local killer = dmg:GetAttacker()
  	if killer:IsPlayer() then
  		local old = killer:GetNWInt("killcount")
  		killer:SetNWInt("killcount", old + 1)
  		local oldm = killer:GetNWInt("Money")
  		killer:SetNWInt("Money", oldm + 1 * GAMEMODE.ZombieData[GetGlobalString("Re2_Difficulty")].Modifier )

  		killer:AddStat("ZombiesKilled", 1)

  		if IsValid(killer:GetActiveWeapon()) && killer:GetActiveWeapon():GetClass() == "weapon_knife_re" then
  			killer:AddStat("KnifeKills",1)
  		end

  	end
	if(IsValid(dmginfo:GetAttacker()) && dmginfo:GetAttacker():IsPlayer()) then
		dmginfo:GetAttacker():AddFrags(1)
		hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
	end
	NumZombies = NumZombies - 1
  	if self.Flame != nil then
  		if self.Flame:IsValid() then
  			self.Flame:Remove()
  		end
  	end

  	SetGlobalInt("RE2_DeadZombies", GetGlobalInt("RE2_DeadZombies") + 0)
  	local itemnumber = math.random(1,GAMEMODE.ZombieData[GetGlobalString("RE2_Difficulty")].ItemChance[GAMEMODE.int_DifficultyLevel])
  	if itemnumber <= 30 then
  		local itemtype = GAMEMODE:str_SelectRandomItem()
  		local item = ents.Create("item_base")
  		item:SetNWString("Class", itemtype)
  		item:SetPos(self.Entity:GetPos() + Vector(0,0,30) )
  		item:Spawn()
  		item:Activate()
  		item:GetPhysicsObject():ApplyForceCenter(dmg:GetDamageForce() * 0.01)
  		timer.Simple(60, function() if item:IsValid() then item:Remove() end end)
  	end


    //classAIDirector.npcDeath( self, dmginfo:GetAttacker(), dmginfo:GetInflictor(), dmginfo)
    if dmginfo:IsExplosionDamage() then
        if dmginfo:GetDamage() > 70 then
            self:Gib(dmginfo)
            return
        end
        dmginfo:SetDamageForce(dmginfo:GetDamageForce() * dmginfo:GetDamage())
    end
    /*local body = ents.Create( "prop_ragdoll" )
	body:SetPos( self:GetPos() )
	body:SetModel( self:GetModel() )
	body:Spawn()

	self:Remove()

	timer.Simple( 1, function()

		body:Remove()

	end )*/
	self:BecomeRagdoll( DamageInfo() )
end

function ENT:OnStuck( )

end

function ENT:HandleStuck()

    self.loco:ClearStuck()

end

local gibmods = {
    {Model = "models/props_junk/watermelon01_chunk02a.mdl", Material = "models/flesh"},
    {Model = "models/props_junk/watermelon01_chunk01a.mdl", Material = "models/flesh"},
    {Model = "models/props/cs_italy/orangegib1.mdl", Material = "models/flesh"},
    {Model = "models/props/cs_italy/orangegib2.mdl", Material = "models/flesh"},
    {Model = "models/gibs/hgibs.mdl", Material = "models/flesh"},
    -- {Model = "models/Gibs/HGIBS_rib.mdl", },
    -- {Model = "models/Gibs/HGIBS_scapula.mdl", },
    -- {Model = "models/Gibs/HGIBS_spine.mdl", },
}


function util.randRadius(origin, min, max)
	max = max or min
	distance = math.random(min, max)
	angle = math.random(0, 360)
	return origin + Vector(math.cos(angle) * distance, math.sin(angle) * distance, 0)
end


function ENT:Gib(dmginfo)
    local gibs = {}
    for i = 1, math.random(2,6) do
        local data = table.Random(gibmods)
        local gib = ents.Create("prop_physics")
        gib:SetModel(data.Model)
        gib:SetMaterial(data.Material or "")
        gib:SetPos(self:GetPos() + self:GetAngles():Up() * math.random(20,70))
        gib:Spawn()
        gib:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        if IsValid(gib:GetPhysicsObject()) then
          gib:GetPhysicsObject():ApplyForceCenter(dmginfo:GetDamageForce() * (math.random(1,20)/20))
        end
        table.insert(gibs,gib)
    end
    local pos = self:GetPos()

    self:Remove()

    local visual = EffectData()
    visual:SetOrigin( pos + Vector(0,0,40) )
    util.Effect("BloodImpact", visual )

    util.Decal( "Blood", pos,  pos - Vector(0,0,20))

    for i = 1, math.random(1,4) do
        local surroundPos = util.randRadius( pos, 10, 20 )
        util.Decal( "Blood", surroundPos,  surroundPos - Vector(0,0,20))

        local visual = EffectData()
        visual:SetOrigin( pos + Vector(0,0,40) )
        util.Effect("BloodImpact", visual )

    end

    timer.Simple(30,function() for _,gib in pairs(gibs) do if gib:IsValid() then gib:Remove() end end end )
end

function ENT:hitBody( hitgroup, dmginfo )

end

-- function ENT:OnTakeDamage(dmg)
--     self:SetHealth(self:Health() - dmg:GetDamage())
--     if self:Health() <= 0 then
--         self:Perish(dmg)
--     end
-- end

-- function ENT:Perish(dmg)
--     if self:Health() < -35 && dmg:IsExplosionDamage() then
--         self:Explode(dmg)
--     else
--         self:Ragdoll(dmg)
--     end
--     classAIDirector.npcDeath(self, dmg:GetAttacker(), dmg:GetInflictor())
--     self:Remove()
-- end

-- -- ONLY NEED THIS FOR A BODY
-- function ENT:Ragdoll(dmgforce)
--     local ragdoll = ents.Create("prop_ragdoll")
--     ragdoll:SetModel(self:GetModel())
--     ragdoll:SetPos(self:GetPos())
--     ragdoll:SetAngles(self:GetAngles())
--     ragdoll:SetVelocity(self:GetVelocity())
--     ragdoll:Spawn()
--     ragdoll:Activate()
--     ragdoll:SetCollisionGroup(1)
--     ragdoll:GetPhysicsObject():ApplyForceCenter(dmgforce:GetDamageForce())

--     local function FadeOut(ragdoll)
--         --Polkm: This will work better then the old one
--         local Steps = 30
--         local TimePerStep = 0.05
--         local CurentAlpha = 255
--         for i = 1, Steps do
--             timer.Simple(i * TimePerStep, function()
--                 if ragdoll:IsValid() then
--                     CurentAlpha = CurentAlpha - (255 / Steps)
--                     ragdoll:SetColor(255, 255, 255, CurentAlpha)
--                 end
--             end)
--         end
--         timer.Simple(Steps * TimePerStep, function() if ragdoll:IsValid() then ragdoll:Remove() end end)
--     end
--     timer.Simple(15, function() if ragdoll:IsValid() then FadeOut(ragdoll) end end)
-- end

-- local delay = 0
-- function ENT:Think()

-- end

-- function ENT:SelectSchedule( INPCState )

-- end
