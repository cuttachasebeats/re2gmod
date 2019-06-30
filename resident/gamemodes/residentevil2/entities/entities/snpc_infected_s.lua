AddCSLuaFile()

--Kill Feed
if CLIENT then
	language.Add("nb_infected_citizen_slow", "Infected Citizen Slow")
end

--Convars--
local nb_targetmethod = GetConVar("nb_targetmethod")
local ai_disabled = GetConVar("ai_disabled")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")

local nb_death_animations = GetConVar("nb_death_animations")
local nb_allow_backingup = GetConVar("nb_allow_backingup")

--Spawnmenu--
list.Set( "sean_nextbots", "nb_infected_citizen_slow", 	
{	Name = "Slow Infected", 
	Class = "nb_infected_citizen_slow",
	Category = "Zombies"	
})

ENT.Base = "nb_zombie_base2"
ENT.Type = "nextbot"
ENT.Spawnable = true

--Stats--
ENT.CollisionHeight = 66
ENT.CollisionSide = 11

ENT.HealthAmount = 100

ENT.Speed = 30
ENT.SprintingSpeed = 55
ENT.FlinchWalkSpeed = 15
ENT.CrouchSpeed = 20

ENT.AccelerationAmount = 400
ENT.DecelerationAmount = 400

ENT.JumpHeight = 58
ENT.StepHeight = 24
ENT.MaxDropHeight = 200

ENT.MeleeDelay = 2

ENT.ShootRange = 30
ENT.MeleeRange = 50
ENT.StopRange = 20

ENT.MeleeDamage = 5
ENT.MeleeDamageType = DMG_SLASH

ENT.MeleeDamageForce = Vector( math.random( ENT.MeleeDamage, ENT.MeleeDamage, ENT.MeleeDamage ) )

--Model--
ENT.Models = {"models/bloocobalt/infected_citizens/male_01.mdl",
"models/bloocobalt/infected_citizens/male_02.mdl",
"models/bloocobalt/infected_citizens/male_03.mdl",
"models/bloocobalt/infected_citizens/male_04.mdl",
"models/bloocobalt/infected_citizens/male_05.mdl",
"models/bloocobalt/infected_citizens/male_06.mdl",
"models/bloocobalt/infected_citizens/male_07.mdl",
"models/bloocobalt/infected_citizens/male_08.mdl",
"models/bloocobalt/infected_citizens/male_09.mdl",
"models/bloocobalt/infected_citizens/male_10.mdl",
"models/bloocobalt/infected_citizens/female_01.mdl",
"models/bloocobalt/infected_citizens/female_02.mdl",
"models/bloocobalt/infected_citizens/female_03.mdl",
"models/bloocobalt/infected_citizens/female_04.mdl",
"models/bloocobalt/infected_citizens/female_06.mdl",
"models/bloocobalt/infected_citizens/female_07.mdl",
"models/bloocobalt/infected_citizens/female_02_b.mdl",
"models/bloocobalt/infected_citizens/female_03_b.mdl",
"models/bloocobalt/infected_citizens/female_04_b.mdl",
"models/bloocobalt/infected_citizens/female_06_b.mdl",
"models/bloocobalt/infected_citizens/female_07_b.mdl"}

ENT.IdleAnim = ACT_IDLE 
ENT.WalkAnim = ACT_WALK
ENT.SprintingAnim = ACT_HL2MP_RUN_ZOMBIE
ENT.FlinchWalkAnim = ACT_WALK 
ENT.CrouchAnim = ACT_HL2MP_CROUCH_ZOMBIE 
ENT.JumpAnim = ACT_HL2MP_JUMP_ZOMBIE 

ENT.MeleeAnim1 = "attackA"
ENT.MeleeAnim2 = "attackB"
ENT.MeleeAnim3 = "attackC"

--Sounds--
ENT.AttackSounds = {""}

ENT.PainSounds = {""}

ENT.AlertSounds = {""}

ENT.DeathSounds = {""}

ENT.IdleSounds = {""}

ENT.PropHitSound = Sound("npc/zombie/zombie_pound_door.wav")
ENT.HitSounds = {"Flesh.ImpactHard"}
ENT.MissSounds = {"npc/zombie/claw_miss1.wav"}

function ENT:CustomInitialize()

	self.Enraged = false

	if !self.Risen then
		
		for k,v in pairs( self.Models ) do
			util.PrecacheModel( v )
		end
		
		local model = table.Random( self.Models )
		if model == "" or nil then
			self:SetModel( "models/player/charple.mdl" )
		else
			--util.PrecacheModel( table.ToString( self.Models ) )
			self:SetModel( model )
		end

		
	
	end
	
	self.FindRadius = 768

	local SpawnTime = CurTime()
	
	self.Leader = self
	self.TargetPos = self:GetPos()
	
	self.CreateTime = SpawnTime
	
	self.NextSearch = SpawnTime
	
	if math.random(1,2) == 1 then
		self.Follower = true
	end
		
	self:SetSkin( math.random(0,11) )
	self:SetBodygroup( 1, math.random(0,11) )
	self:SetBodygroup( 2, math.random(0,7) )
	self:SetBodygroup( 3, math.random(0,2) )
	self:SetBodygroup( 4, math.random(0,2) )

	
end

function ENT:MovementFunction()

	if !self.Enemy then
		
		self:StartActivity( self.IdleAnim )
		self.loco:SetDesiredSpeed( 0 )
		
	else
	
		self:StartActivity( self.WalkAnim )
		self.loco:SetDesiredSpeed( self.Speed )

	end

end

function ENT:Melee( ent, type )

	if self.IsAttacking then return end
	if self.Flinching then return end

	self.IsAttacking = true 
	self.FacingTowards = ent
	
	self.MeleeAnims = {"attackA", "attackB", "attackC"}
	
	self:PlayGestureSequence( self.MeleeAnim2 )
	self.loco:SetDesiredSpeed(0)
	self:PlayAttackSound()
	
	timer.Simple( 0.4, function()
		if ( IsValid(self) and self:Health() > 0 ) and IsValid(ent) then
		
			local misssound = table.Random( self.MissSounds )
			self:EmitSound( Sound( misssound ), 90, self.MissSoundPitch or 100 )
		
			if self.Flinching then return end
			if self:GetRangeTo( ent ) > self.MeleeRange then return end
		
			if ent:Health() > 0 then
				self:DoDamage( self.MeleeDamage, self.MeleeDamageType, ent )
			end
	
			if type == nil then
				local hitsound = table.Random( self.HitSounds )
				ent:EmitSound( Sound( hitsound ), 90, self.HitSoundPitch or 100 )
			else
				ent:EmitSound( self.PropHitSound )
			end
	
			if type == 1 then --Prop
				local phys = ent:GetPhysicsObject()
				if (phys != nil && phys != NULL && phys:IsValid() ) then
					phys:ApplyForceCenter(self:GetForward():GetNormalized()*( ( self.MeleeDamage * 1000 ) ) + Vector(0, 0, 2))
				end
			elseif type == 2 then --Door
				ent.Hitsleft = ent.Hitsleft - 5
			end
	
		end
	end)
	
	timer.Simple( 0.8, function()
		if ( IsValid(self) and self:Health() > 0 ) and IsValid(ent) then
		
			local misssound = table.Random( self.MissSounds )
			self:EmitSound( Sound( misssound ), 90, self.MissSoundPitch or 100 )
		
			if self.Flinching then return end
			if self:GetRangeTo( ent ) > self.MeleeRange then return end
		
			if ent:Health() > 0 then
				self:DoDamage( self.MeleeDamage, self.MeleeDamageType, ent )
			end
	
			if type == nil then
				local hitsound = table.Random( self.HitSounds )
				ent:EmitSound( Sound( hitsound ), 90, self.HitSoundPitch or 100 )
			else
				ent:EmitSound( self.PropHitSound )
			end
	
			if type == 1 then --Prop
				local phys = ent:GetPhysicsObject()
				if (phys != nil && phys != NULL && phys:IsValid() ) then
					phys:ApplyForceCenter(self:GetForward():GetNormalized()*( ( self.MeleeDamage * 1000 ) ) + Vector(0, 0, 2))
				end
			elseif type == 2 then --Door
				ent.Hitsleft = ent.Hitsleft - 5
			end
	
		end
	end)
	
	timer.Simple( 1.5, function()
		if ( IsValid(self) and self:Health() > 0) then
			self:MovementFunction()
			self.IsAttacking = false
		end
	end)
	
end

function ENT:CustomOnContact( ent )

	if ent:IsVehicle() then
		if self.HitByVehicle then return end
		if self:Health() < 0 then return end
		--if ( math.Round(ent:GetVelocity():Length(),0) < 5 ) then return end 
		
		local phys = ent:GetPhysicsObject()
		if (phys != nil && phys != NULL && phys:IsValid() ) then
			local knockback = ent:GetVelocity():Length() * 1500
			phys:ApplyForceCenter(self:GetForward():GetNormalized()*(knockback) + Vector(0, 0, 2))
		end
		
		if ( self.NextDamageTimer or 0 ) < CurTime() then
	
			local veh = ent:GetPhysicsObject()
			local dmg = math.Round( (ent:GetVelocity():Length() / 3 + ( veh:GetMass() / 50 ) ), 0 )
		
			if ent:GetOwner():IsValid() then
				self:TakeDamage( dmg, ent:GetOwner() )
			else
				self:TakeDamage( dmg, ent )
			end
		
			self.NextDamageTimer = CurTime() + 0.1
		end
		
	end
	
	if ent != self.Enemy then
		if ( ent:IsPlayer() and !self:IsPlayerZombie( ent ) and ai_ignoreplayers:GetInt() == 0 ) or ( ent.NEXTBOT and !ent.NEXTBOTZOMBIE ) then
			if ( self.NextMeleeTimer or 0 ) < CurTime() then
				self:Melee( ent, 0, 1 )
				self:SetEnemy( ent )
				self:BehaveStart()
				self.NextMeleeTimer = CurTime() + self.MeleeDelay
			end
		end
	end
	
	self:CustomOnContact2( ent )
	
end