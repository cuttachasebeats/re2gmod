AddCSLuaFile()
ENT.Base             = "nz_base2"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false
ENT.Weapon			= ""

--SpawnMenu--
list.Set( "NPC", "nz_boss_zombine", {
	Name = "Zombine SS",
	Class = "nz_boss_zombine",
	Category = "NextBot Zombies 2.0"
} )
ENT.stuckPos = Vector(0,0,0)
ENT.times = 1
ENT.nextCheck = 0
local delay = 1
--Stats--
ENT.FootAngles = 10
ENT.FootAngles2 = 10

ENT.MoveType = 2

ENT.CollisionHeight = 64
ENT.CollisionSide = 7

ENT.ModelScale = 1.2 

ENT.Speed = 65
ENT.WalkSpeedAnimation = 1
ENT.FlinchSpeed = 10

ENT.health = 500
ENT.Damage = 45
ENT.HitPerDoor = 5

ENT.PhysForce = 30000
ENT.AttackRange = 110
ENT.InitialAttackRange = 110
ENT.DoorAttackRange = 25

ENT.NextAttack = 1.5

--Model Settings--
ENT.Model = "models/regenerator/regenerator.mdl"

ENT.WalkAnim = ACT_RUN_AIM_STIMULATED
ENT.AttackAnim = ACT_GMOD_GESTURE_RANGE_ZOMBIE 
ENT.IdleAnim = ACT_HL2MP_IDLE_CROUCH_ZOMBIE 

--Sounds--
ENT.Attack1 = Sound("npc/zombine/attack1.wav")
ENT.Attack2 = Sound("npc/zombine/attack2.wav")

ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

ENT.Enrage1 = Sound("npc/zombine/enrage1.wav")
ENT.Enrage2 = Sound("npc/zombine/enrage2.wav")

ENT.Death1 = Sound("npc/zombine/death1.wav")
ENT.Death2 = Sound("npc/zombine/death2.wav")
ENT.Death3 = Sound("npc/zombine/death3.wav")

ENT.Idle1 = Sound("npc/zombine/idle1.wav")
ENT.Idle2 = Sound("npc/zombine/idle2.wav")
ENT.Idle3 = Sound("npc/zombine/idle3.wav")
ENT.Idle4 = Sound("npc/zombine/idle4.wav")

ENT.Pain1 = Sound("npc/zombine/pain1.wav")
ENT.Pain2 = Sound("npc/zombine/pain2.wav")
ENT.Pain3 = Sound("npc/zombine/pain3.wav")

ENT.HitSound = Sound("npc/zombie/claw_strike1.wav")
ENT.Miss = Sound("npc/zombie/claw_miss1.wav")

function ENT:Precache()

--Models--
util.PrecacheModel(self.Model)
	
--Sounds--	
util.PrecacheSound(self.Attack1)
util.PrecacheSound(self.Attack2)

util.PrecacheSound(self.DoorBreak)

util.PrecacheSound(self.Enrage1)
util.PrecacheSound(self.Enrage2)

util.PrecacheSound(self.Death1)
util.PrecacheSound(self.Death2)
util.PrecacheSound(self.Death3)

util.PrecacheSound(self.Idle1)
util.PrecacheSound(self.Idle2)
util.PrecacheSound(self.Idle3)
util.PrecacheSound(self.Idle4)
	
util.PrecacheSound(self.Pain1)
util.PrecacheSound(self.Pain2)
util.PrecacheSound(self.Pain3)
	
util.PrecacheSound(self.HitSound)
util.PrecacheSound(self.Miss)

end

function ENT:Initialize()

	--Stats--
	self:SetModel(self.Model)
	self:SetHealth(self.health)	
	self:SetModelScale( self.ModelScale, 0 )
	self:SetColor( Color( 255, 205, 205, 255 ) )
	
	self.LoseTargetDist	= (self.LoseTargetDist)
	self.SearchRadius 	= (self.SearchRadius)
	
	self.IsAttacking = false
	self.HasNoEnemy = false
	self.Throwing = false
	if(#ents.FindInSphere(self:GetPos(),32) > 0) then
		self:SetPos(self:GetPos() + Vector(math.random(-64),math.random(64),0))
	end
	

	
	--Misc--
	self:Precache()
	self:SetCustomCollisionCheck( true )
	self:CollisionSetup( self.CollisionSide, self.CollisionHeight, COLLISION_GROUP_PLAYER )
end

function ENT:ShootEnemy()

end

function ENT:GiveWeapon(wep)


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
  self.loco:SetDesiredSpeed( math.random(30,185) )
end

function ENT:IdleFunction()

	if ( self.NextIdle or 0 ) < CurTime() then
		
		self:StartActivity( self.IdleAnim )
		self:IdleSound()
		
		self.NextIdle = CurTime() + 5	
	end
	
end

function ENT:CustomDeath( dmginfo )
	self:DeathAnimation( "nz_deathanim_zss", self:GetPos(), ACT_HL2MP_WALK_CROUCH_ZOMBIE_05, self.ModelScale )
	
	if dmginfo:IsExplosionDamage() then
		self:BecomeRagdoll(dmginfo)
	else
		self:DeathAnimation( "nz_deathanim_base", self:GetPos(), ACT_HL2MP_WALK_ZOMBIE_01, 1 )
	end
	
	
	local dmg = dmginfo
    local killer = dmg:GetAttacker()
  	if killer:IsPlayer() then
  		local old = killer:GetNWInt("killcount")
  		killer:SetNWInt("killcount", old + 1)
  		local oldm = killer:GetNWInt("Money")
  		killer:SetNWInt("Money", oldm + 20 * GAMEMODE.ZombieData[GetGlobalString("Re2_Difficulty")].Modifier )

  		killer:AddStat("ZombiesKilled", 1)

  		if IsValid(killer:GetActiveWeapon()) && killer:GetActiveWeapon():GetClass() == "weapon_knife_re" then
  			killer:AddStat("KnifeKills",1)
  		end

  	end
	if(IsValid(dmginfo:GetAttacker()) && dmginfo:GetAttacker():IsPlayer()) then
		dmginfo:GetAttacker():AddFrags(1)
		hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
	end
  	if self.Flame != nil then
  		if self.Flame:IsValid() then
  			self.Flame:Remove()
  		end
  	end

  	SetGlobalInt("RE2_DeadZombies", GetGlobalInt("RE2_DeadZombies") + 1)
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


end

function ENT:ThrowGrenade( velocity )
	
end

function ENT:CustomRegen()
	
end

function ENT:CustomChaseEnemy()

	
end

function ENT:CustomInjure( dmginfo )
	
	if ( dmginfo:IsBulletDamage() ) then

	local attacker = dmginfo:GetAttacker()
        // hack: get hitgroup
	local trace = {}
	trace.start = attacker:GetShootPos()
		
	trace.endpos = trace.start + ( ( dmginfo:GetDamagePosition() - trace.start ) * 2 )  
	trace.mask = MASK_SHOT
	trace.filter = attacker
		
	local tr = util.TraceLine( trace )
	hitgroup = tr.HitGroup
	
		self:EmitSound("kevlar/kevlar_hit"..math.random(2)..".wav", 65)
		
		if attacker:IsNPC() then
			dmginfo:ScaleDamage(0.75)
		else
			dmginfo:ScaleDamage(0.65)
		end
	
	end
	
	local dmg = dmginfo
  if dmg:IsExplosionDamage() then
		dmg:SetDamage(dmg:GetDamage() * 2)
		if dmg:GetAttacker():GetClass() == "env_explosion" && dmg:GetAttacker().Owner != nil then
			dmg:SetAttacker(dmg:GetAttacker().Owner)
			if dmg:GetInflictor().Class == "Ice" && !self.Frozen then
				self.Frozen = true
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

function ENT:FootSteps()
	self:EmitSound("npc/combine_soldier/gear"..math.random(6)..".wav", 65)
end

function ENT:AlertSound()
end

function ENT:PainSound()
	if math.random(1,10) == 1 then
		local sounds = {}
		sounds[1] = (self.Pain1)
		sounds[2] = (self.Pain2)
		sounds[3] = (self.Pain3)
		self:EmitSound( sounds[math.random(1,3)] )
	end
end

function ENT:EnrageSound()
	local sounds = {}
		sounds[1] = (self.Enrage1)
		sounds[2] = (self.Enrage2)
		self:EmitSound( sounds[math.random(1,2)] )
end

function ENT:DeathSound()
end

function ENT:AttackSound()
	local sounds = {}
		sounds[1] = (self.Attack1)
		sounds[2] = (self.Attack2)
		self:EmitSound( sounds[math.random(1,2)] )
end

function ENT:IdleSound()
	if math.random(1,10) == 1 then
		local sounds = {}
		sounds[1] = (self.Idle1)
		sounds[2] = (self.Idle2)
		sounds[3] = (self.Idle3)
		sounds[4] = (self.Idle4)
		self:EmitSound( sounds[math.random(1,4)] )
	end
end

function ENT:CustomDoorAttack( ent )

	if ( self.NextDoorAttackTimer or 0 ) < CurTime() then
		if IsValid(ent) && ent:GetPos():Distance( self:GetPos() ) < 100 then

            local dmginfo = DamageInfo()
            dmginfo:SetDamageType(DMG_SLASH)
            dmginfo:SetDamage(self:getAttackDamage())

            local force = 1
            local phys = ent:GetPhysicsObject()
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
            ent:TakeDamageInfo(dmginfo)
        end
		self:AttackSound()
		self:RestartGesture(self.AttackAnim)  
		
		self:AttackEffect( 0.9, ent, self.Damage, 2 )
	
		self.NextDoorAttackTimer = CurTime() + self.NextAttack
	end
	
end
	
function ENT:CustomPropAttack( ent )

	if ( self.NextPropAttackTimer or 0 ) < CurTime() then
	if IsValid(ent) && ent:GetPos():Distance( self:GetPos() ) < 100 then

            local dmginfo = DamageInfo()
            dmginfo:SetDamageType(DMG_SLASH)
            dmginfo:SetDamage(self:getAttackDamage())

            local force = 1
            local phys = ent:GetPhysicsObject()
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
            ent:TakeDamageInfo(dmginfo)
        end
		self:AttackSound()
		self:RestartGesture(self.AttackAnim)  
	
		self:AttackEffect( 0.9, ent, self.Damage, 1 )
	
		self.NextPropAttackTimer = CurTime() + self.NextAttack
		if ( self.loco:IsStuck() ) then
            self:HandleStuck()
            return "stuck"
        end
        coroutine.yield()
	end
	
end

function ENT:AttackEffect( time, ent, dmg, type )

	timer.Simple(time, function() 
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		if !self:CheckValid( ent ) then return end
		
		if self:GetRangeTo( ent ) < self.AttackRange then
			
			ent:TakeDamage( self.Damage, self )
			
			if ent:IsPlayer() or ent:IsNPC() then
				self:BleedVisual( 0.2, ent:GetPos() + Vector(0,0,50) )	
				self:EmitSound( self.HitSound, 90, math.random(80,90) )
				
				local moveAdd=Vector(0,0,350)
					if not ent:IsOnGround() then
						moveAdd=Vector(0,0,0)
					end
				ent:SetVelocity( moveAdd + ( ( self.Enemy:GetPos() - self:GetPos() ):GetNormal() * 150 ) )
			end
			
			if ent:IsPlayer() then
				ent:ViewPunch(Angle(math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage))
			end
			
			if type == 1 then
				local phys = ent:GetPhysicsObject()
				if (phys != nil && phys != NULL && phys:IsValid() ) then
					phys:ApplyForceCenter(self:GetForward():GetNormalized()*(self.PhysForce) + Vector(0, 0, 2))
					ent:EmitSound(self.DoorBreak)
				end
			elseif type == 2 then
				if ent != NULL and ent.Hitsleft != nil then
					if ent.Hitsleft > 0 then
						ent.Hitsleft = ent.Hitsleft - self.HitPerDoor	
						ent:EmitSound(self.DoorBreak)
					end
				end
			end
							
		else	
			self:EmitSound(self.Miss)
		end
		
	end)
	
	timer.Simple( time + 0.6, function()
		if !self:IsValid() then return end
		if self:Health() < 0 then return end
		self.IsAttacking = false
	end)

end

function ENT:Attack(ent)

	if ( self.NextAttackTimer or 0 ) < CurTime() then	
	
		if ( (self.Enemy:IsValid() and self.Enemy:Health() > 0 ) ) then
		local enemy = self:GetEnemy()
		
		if IsValid(ent) && ent:GetPos():Distance( self:GetPos() ) < 100 then
		
            local dmginfo = DamageInfo()
            dmginfo:SetDamageType(DMG_SLASH)
            dmginfo:SetDamage(self:getAttackDamage())

            local force = 1
            local phys = ent:GetPhysicsObject()
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
            ent:TakeDamageInfo(dmginfo)
        end
			self:AttackSound()
			self.IsAttacking = true
			self:RestartGesture(self.AttackAnim)
		
			self:AttackEffect( 0.9, self.Enemy, self.Damage, 0 )
		
		end
			
		self.NextAttackTimer = CurTime() + self.NextAttack
	end	
		
end



function ENT:IsNPC()
	return true
end