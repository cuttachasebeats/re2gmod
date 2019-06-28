util.AddNetworkString("TyrantRagdoll")
util.AddNetworkString("TyrantCloth")

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

ENT.IsAlive = true
ENT.Animation = ""
ENT.PlayingAnimation = false
ENT.PlayingGesture = false
ENT.NextSoundCanPlayTime = 0
ENT.LastPlayedSound = ""
ENT.NextTryingFindEnemy = CurTime()+1
ENT.AttackIndex = 0

ENT.AttackGestureIndex = nil

ENT.RegEnemy = nil
ENT.SNPCClass = "C_MONSTER_LAB"

ENT.NearestEnemyFindDistance = 0

ENT.PreviousPosition = Vector(0,0,0)
ENT.CantChaseTargetTimes = 0
ENT.MustJumpTimes = 0

ENT.Hate = 1

ENT.IdleSequence = "S_Idle"

ENT.PainSoundEnabled = true
ENT.PainSound = {}
ENT.PainSound.name = "Tyrant.Pain"
ENT.PainSound.min = 1
ENT.PainSound.max = 7

ENT.DieSoundEnabled = true
ENT.DieSound = {}
ENT.DieSound.name = "Tyrant.Die"
ENT.DieSound.min = 1
ENT.DieSound.max = 5

ENT.MeleeSoundEnabled = true
ENT.MeleeSound = {}
ENT.MeleeSound.name = "Tyrant.Attack"
ENT.MeleeSound.min = 1
ENT.MeleeSound.max = 6


ENT.MeleeFlySpeed = 200

ENT.MeleeAttackSequence = {}
ENT.MeleeAttackGesture = {}
ENT.MeleeMissSound = {}
ENT.MeleeHitSound = {}
ENT.MeleeDamageRadius = {}
ENT.MeleeDamageCount = {}
ENT.MeleeDamageTime = {}
ENT.MeleeDamageDamage = {}
ENT.MeleeDamageType = {}
ENT.MeleeDamageDistance = {}
ENT.MeleeDamageBone = {}
ENT.MeleeDamageTime[1] = {}
ENT.MeleeDamageDamage[1] = {}
ENT.MeleeDamageType[1] = {}
ENT.MeleeDamageDistance[1] = {}
ENT.MeleeDamageBone[1] = {}
ENT.MeleeDamageRadius[1] = {}

ENT.MeleeAttackSequence[1] = ""
ENT.MeleeAttackGesture[1] = nil
ENT.MeleeDamageCount[1] = 1
ENT.MeleeDamageTime[1][1] = 0.1
ENT.MeleeDamageDamage[1][1] = 1
ENT.MeleeDamageType[1][1] = DMG_GENERIC
ENT.MeleeDamageDistance[1][1] = 1
ENT.MeleeDamageRadius[1][1] = 1
ENT.MeleeDamageBone[1][1] = ""



ENT.JumpHeight = 240


ENT.MeleeAttackDistanceMin = 7
ENT.MeleeAttackDistance = 16

ENT.DamageMultiplier = 1


ENT.CanJump = true

ENT.LLegStepped = false
ENT.RLegStepped = false

ENT.LLegStepTime = 0
ENT.RLegStepTime = 0

ENT.RLeg = "R_ashi2"
ENT.LLeg = "L_ashi2"

ENT.Phase = 1

ENT.RunningTime = 0

ENT.DMGTYPE1 = DMG_CLUB
ENT.DMGTYPE2 = bit.bor(DMG_CLUB,DMG_SLASH)

ENT.ForceNextGesture = ""
ENT.ForceNextMelee = -1

ENT.Angry = false

ENT.PhaseCycle = 2
ENT.BulletDefence = 6
ENT.Protection = 0.17
ENT.HeadProtection = 0.11

ENT.FollowPosTime = 0
ENT.LastPositionFails = 0
ENT.LastPosition = Vector(0,0,0)


include( "shared.lua" )
//include( "schedules.lua" )
include( "tasks.lua" )

ENT.m_fMaxYawSpeed = 240
ENT.m_iClass = CLASS_NONE

AccessorFunc( ENT, "m_iClass", "NPCClass", FORCE_NUMBER )
AccessorFunc( ENT, "m_fMaxYawSpeed", "MaxYawSpeed", FORCE_NUMBER )



























//Initialize
local function Tyrant_Init(self,VEC,MTYPE,CAPS)
	if(!CAPS) then
		CAPS = {}
	end
	
	self:SetModel( self.Model )
	
	self:SetCustomCollisionCheck()
	
	self:SetHullSizeNormal()
	if(isvector(VEC)) then
		VEC = Vector(math.abs(VEC.x),math.abs(VEC.y),math.abs(VEC.z))
		
		self:SetCollisionBounds(Vector(-VEC.x,-VEC.y,0),VEC)
	elseif(istable(VEC)) then
		self:SetCollisionBounds(VEC[1],VEC[2])
	end
	
	self:SetSolid(SOLID_BBOX)
	
	self:SetCollisionGroup(COLLISION_GROUP_NPC)

	self:SetUseType(SIMPLE_USE)
	
	self:SetMoveType( MTYPE )
	self:CapabilitiesAdd( bit.bor(CAP_MOVE_GROUND, CAP_AUTO_DOORS, CAP_USE, CAP_OPEN_DOORS, CAP_SKIP_NAV_GROUND_CHECK) )
	if(#CAPS>0) then
		for C=1,#CAPS do
			self:CapabilitiesAdd( bit.bor(CAPS[C]) )
		end
	end
	
	self:SetBloodColor(BLOOD_COLOR_RED)
	
	self:AddEFlags(EFL_NO_DISSOLVE)

	if(IsValid(self:GetActiveWeapon())) then
		self:GetActiveWeapon():Remove()
	end
	
	self:SetEnemy(nil)
	
	self:DropToFloor()
	

	self:Activate()
	
	
	duplicator.RegisterEntityClass( self:GetClass(), function( ply, data )
		duplicator.GenericDuplicatorFunction( ply, data )
	end, "Data" )
end






//Sounds
local function Tyrant_PlaySound(self,CH,SND,CHAN)
	if(self.NextSoundCanPlayTime<CurTime()) then
		local TEMP_SoundChance = math.random(1,100)
	
		if(TEMP_SoundChance<CH) then
			self:EmitSound( SND )
			self.NextSoundCanPlayTime = CurTime()+SoundDuration(SND)+0.1
			self.LastPlayedSound = SND
		end
	end
end

local function Tyrant_PlaySoundRandom(self,CH,SNDNM,IMIN,IMAX,CHAN)
	if(self.NextSoundCanPlayTime<CurTime()) then
		local TEMP_SoundChance = math.random(1,100)
	
		if(TEMP_SoundChance<CH) then
			local TEMP_SND = SNDNM..math.random(IMIN,IMAX)
				
			self:EmitSound( TEMP_SND )
			self.NextSoundCanPlayTime = CurTime()+SoundDuration(TEMP_SND)+0.1
			self.LastPlayedSound = TEMP_SND
		end
	end
end

local function Tyrant_StopPreviousSound(self)
	self:StopSound(self.LastPlayedSound)
	self.LastPlayedSound = ""
	self.NextSoundCanPlayTime = -1
end






//Timers
local function Tyrant_StopAllTimers(self)
	timer.Remove("ComboCheck"..tostring(self))
	
	timer.Remove("StartAttack"..tostring(self))
	timer.Remove("PreMidAttack"..tostring(self))
	timer.Remove("MidAttack"..tostring(self))
	timer.Remove("PreAttack"..tostring(self))
	timer.Remove("Attack"..tostring(self))
	timer.Remove("EndAttack"..tostring(self))
	timer.Remove("Anim"..tostring(self))
	timer.Remove("JustPlayAnimation"..tostring(self))
	timer.Remove("JustPlayAnimation2"..tostring(self))
	timer.Remove("AllowAttack"..tostring(self))
	for i=1, 5 do
		timer.Remove("DamageAttack"..tostring(self)..i)
	end
end


//Other
local function Tyrant_SetLocalVelocity(self,VEL)
	local TEMP_Mul = 1
	
	if(!self:IsOnGround()) then
		TEMP_Mul = 0.3
	end
	
	self:SetLocalVelocity(Vector(VEL.x*TEMP_Mul,VEL.y*TEMP_Mul,VEL.z))
end




//Animations
local function Tyrant_PlayAnimation(self,ANM,IND,RESETCYCLE)
	if(string.Replace(ANM," ","")=="") then
		Tyrant_ClearAnimation(self)
		Tyrant_StopAllTimers(self)
		return
	end
	self.PlayingAnimation = true
	self.PlayingGesture = false
	self.AttackIndex = IND
	self:ClearSchedule()
	
	self.CantChaseTargetTimes = 0
	self.MustJumpTimes = 0
	
	if(RESETCYCLE==nil||RESETCYCLE==true) then
		self:ResetSequenceInfo()
		self:SetCycle(0)
	end
	
	self.Animation = ANM
	self:StopMoving()
	self:SetNPCState(NPC_STATE_NONE)

	if(self:GetSequence()!=self:LookupSequence(self.Animation)) then
		self:SetNPCState(NPC_STATE_SCRIPT)
		self:ResetSequence(self:LookupSequence(self.Animation))
	end
end

local function Tyrant_PlayGesture(self,ANM,IND,PRIOR)
	if(PRIOR==nil) then
		PRIOR = 2
	end
	
	self.PlayingAnimation = true
	self.PlayingGesture = true
	
	self.CantChaseTargetTimes = 0
	self.MustJumpTimes = 0
	
	local AIND = self:LookupSequence(ANM)
	
	local TEMP_Gesture = self:AddGestureSequence(AIND)
	self:SetLayerPriority(TEMP_Gesture,PRIOR)
	self:SetLayerPlaybackRate(TEMP_Gesture,1)
	self:SetLayerCycle(TEMP_Gesture,0)

	self.AttackGestureIndex = TEMP_Gesture
	
	self.Animation = ANM
	self.AttackIndex = IND
end

local function Tyrant_ClearAnimation(self)
	self.Animation = ""
	self.AttackIndex = 0
	
	if(self.PlayingGesture==false) then
		self:ClearSchedule()
		self:ResetSequenceInfo()
	end
	
	self:SetNPCState(NPC_STATE_COMBAT)
	self.PlayingGesture = false
	self.PlayingAnimation = false
	
	if(GetConVar("ai_disabled"):GetInt()==1) then
		self:ResetSequence(self:LookupSequence(self.IdleSequence))
	end
end

local function Tyrant_Jump(self)
	Tyrant_PlayAnimation(self,"S_Jump",0)
	self.PreviousPosition = self:GetPos()+Vector(0,0,100)
	

	timer.Create("StartAttack"..tostring(self),0.5,1,function()
		if(IsValid(self)&&self!=nil&&self!=NULL) then
			Tyrant_SetLocalVelocity(self,((self:GetForward()*900)+Vector(0,0,self.JumpHeight+140)))
			
			timer.Create("Attack"..tostring(self),0.1,10,function()
				if(IsValid(self)&&self!=nil&&self!=NULL) then
					self:SetVelocity(self:GetForward()*5)
				end
			end)
			
			timer.Create("MidAttack"..tostring(self),self:SequenceDuration(self.Animation)-0.7,1,function()
				if(IsValid(self)&&self!=nil&&self!=NULL) then
					Tyrant_PlayAnimation(self,"S_Fly",0)
				end
			end)
		end
	end)
end


//AI
local function Tyrant_Think(self)
	if(self:GetMovementActivity()==ACT_RUN) then
		self.RunningTime = math.min(self.RunningTime+1,18)
	else
		self.RunningTime = math.max(self.RunningTime-2,0)
	end

	if(IsValid(self:GetEnemy())&&self:GetEnemy()!=nil&&self:GetEnemy()!=NULL&&((self:GetEnemy():IsPlayer()&&self:GetEnemy():Alive())||(!self:GetEnemy():IsPlayer()))) then
		if(self.PlayingAnimation==true) then
			if(self:GetMovementActivity()==ACT_RUN) then
				self:SetMovementActivity(ACT_WALK_ANGRY)
			end
		else
			if(self.Angry==false) then
				if(self:GetMovementActivity()==ACT_RUN) then
					self:SetMovementActivity(ACT_WALK_ANGRY)
				end
			else
				if(self:GetMovementActivity()==ACT_WALK||self:GetMovementActivity()==ACT_WALK_ANGRY) then
					self:SetMovementActivity(ACT_RUN)
				end
			end
		end
	else
		if(self:GetMovementActivity()!=ACT_WALK) then
			self:SetMovementActivity(ACT_WALK)
		end
	end

end






//Attack
local function Tyrant_CreateMeleeTable()
	local TBL = {}
	TBL.damage = {}
	TBL.distance = {}
	TBL.radius = {}
	TBL.time = {}
	TBL.bone = {}
	TBL.damage = {}
	TBL.damagetype = {}
	TBL.distance = {}
	TBL.radius = {}
	TBL.time = {}
	TBL.bone = {}
	
	return TBL
end

local function Tyrant_RemoveMeleeTable(self,IND)
	self.MeleeDamageTime[IND] = {}
	self.MeleeDamageDamage[IND] = {}
	self.MeleeDamageType[IND] = {}
	self.MeleeDamageDistance[IND] = {}
	self.MeleeDamageBone[IND] = {}
	self.MeleeDamageRadius[IND] = {}
	
	self.MeleeHitSound[IND] = {}
	self.MeleeMissSound[IND] = {}
	
	self.MeleeAttackSequence[IND] = nil
	self.MeleeAttackGesture[IND] = nil
	self.MeleeDamageCount[IND] = nil
end

local function Tyrant_SetMeleeParams(self,NUM,SEQ,CNT,TBL,TBLH,TBLM)
	self.MeleeAttackSequence[NUM] = SEQ
	self.MeleeDamageCount[NUM] = CNT
	
	if(!self.MeleeHitSound[NUM]) then
		self.MeleeHitSound[NUM] = {}
	end
	
	if(!self.MeleeMissSound[NUM]) then
		self.MeleeMissSound[NUM] = {}
	end
	
	table.Add(self.MeleeHitSound[NUM],TBLH)
	table.Add(self.MeleeMissSound[NUM],TBLM)

	for N=1,CNT do
		if(!self.MeleeDamageTime[NUM]) then
			self.MeleeDamageTime[NUM] = {}
		end
		if(!self.MeleeDamageDamage[NUM]) then
			self.MeleeDamageDamage[NUM] = {}
		end
		if(!self.MeleeDamageType[NUM]) then
			self.MeleeDamageType[NUM] = {}
		end
		if(!self.MeleeDamageDistance[NUM]) then
			self.MeleeDamageDistance[NUM] = {}
		end
		if(!self.MeleeDamageRadius[NUM]) then
			self.MeleeDamageRadius[NUM] = {}
		end
		if(!self.MeleeDamageBone[NUM]) then
			self.MeleeDamageBone[NUM] = {}
		end
		
		self.MeleeDamageTime[NUM][N] = TBL.time[N]
		self.MeleeDamageDamage[NUM][N] = TBL.damage[N]
		self.MeleeDamageType[NUM][N] = TBL.damagetype[N]
		self.MeleeDamageDistance[NUM][N] = TBL.distance[N]
		self.MeleeDamageRadius[NUM][N] = TBL.radius[N]
		self.MeleeDamageBone[NUM][N] = TBL.bone[N]
	end
end

local function Tyrant_SetMeleeParamsGesture(self,NUM,SEQ,CNT,TBL,TBLH,TBLM)
	self.MeleeAttackSequence[NUM] = SEQ
	self.MeleeAttackGesture[NUM] = true
	self.MeleeDamageCount[NUM] = CNT
	
	if(!self.MeleeHitSound[NUM]) then
		self.MeleeHitSound[NUM] = {}
	end
	
	if(!self.MeleeMissSound[NUM]) then
		self.MeleeMissSound[NUM] = {}
	end
	
	table.Add(self.MeleeHitSound[NUM],TBLH)
	table.Add(self.MeleeMissSound[NUM],TBLM)
	
	for N=1,CNT do
		if(!self.MeleeDamageTime[NUM]) then
			self.MeleeDamageTime[NUM] = {}
		end
		if(!self.MeleeDamageDamage[NUM]) then
			self.MeleeDamageDamage[NUM] = {}
		end
		if(!self.MeleeDamageType[NUM]) then
			self.MeleeDamageType[NUM] = {}
		end
		if(!self.MeleeDamageDistance[NUM]) then
			self.MeleeDamageDistance[NUM] = {}
		end
		if(!self.MeleeDamageRadius[NUM]) then
			self.MeleeDamageRadius[NUM] = {}
		end
		if(!self.MeleeDamageBone[NUM]) then
			self.MeleeDamageBone[NUM] = {}
		end
		
		self.MeleeDamageTime[NUM][N] = TBL.time[N]
		self.MeleeDamageDamage[NUM][N] = TBL.damage[N]
		self.MeleeDamageType[NUM][N] = TBL.damagetype[N]
		self.MeleeDamageDistance[NUM][N] = TBL.distance[N]
		self.MeleeDamageRadius[NUM][N] = TBL.radius[N]
		self.MeleeDamageBone[NUM][N] = TBL.bone[N]
	end
end

local function Tyrant_IsZombie(NPC)
	if(NPC.SNPCClass=="C_ZOMBIE"||NPC.VJ_NPC_Class=="CLASS_ZOMBIE"||NPC.SNPCClass=="C_MONSTER_CAT"||
	NPC.SNPCClass=="C_MONSTER_SAVAGE"||NPC.SNPCClass=="C_MONSTER_LAB"||NPC.SNPCClass=="C_MONSTER_CONTROLLER"||
	NPC:Classify()==CLASS_ZOMBIE||NPC:Classify()==CLASS_HEADCRAB) then
		return true
	end
		
	return false
end

local function Tyrant_IsEnemyNPC(self,self2)
	if(self2:IsNPC()&&self2:GetNPCState()!=NPC_STATE_DEAD&&(!Tyrant_IsZombie(self2)||
	(self2==self:GetEnemy()||self==self2:GetEnemy()))) then
		return true
	end
	
	return false
end
	
local function Tyrant_IsEnemyPlayer(self,self2)
	if(self2:IsPlayer()&&self2:Alive()&&GetConVar("ai_ignoreplayers"):GetInt()==0) then
		return true
	end
	
	return false
end

local function Tyrant_IsWeldedDoor(self2)
	if(self2:GetClass()=="prop_door_rotating"&&self2:GetSaveTable( ).m_bLocked==true&&self2:GetNWFloat("Welded",0)>0) then
		return true
	end
	
	return false
end

local function Tyrant_IsProp(self2)
	if((IsValid(self2:GetPhysicsObject())||Tyrant_IsWeldedDoor(self2))&&!self2:IsPlayer()&&!self2:IsNPC()) then
		return true
	end
	return false
end

local function Tyrant_CanAttackThis(self,self2)
	if(Tyrant_IsEnemyNPC(self,self2)||Tyrant_IsEnemyPlayer(self,self2)||Tyrant_IsProp(self2)) then
		return true
	end
end

local function Tyrant_EnemyInMeleeRange(self,self2,DIST1,DIST2)
	if(Tyrant_IsEnemyNPC(self,self2)||Tyrant_IsEnemyPlayer(self,self2)||Tyrant_IsWeldedDoor(self2)||Tyrant_IsProp(self2)) then
		local TEMP_Point1 = self2:NearestPoint(self:GetPos()+self:OBBCenter())
		local TEMP_Point2 = self:NearestPoint(TEMP_Point1)

		local TEMP_DistanceBetween = TEMP_Point1:Distance(TEMP_Point2)

		if(TEMP_Point1.z<(self:GetPos()+self:OBBMaxs()).z&&
		TEMP_Point1.z>((self:GetPos()+self:OBBMins()).z)) then
			if(TEMP_DistanceBetween<DIST2) then
				if(TEMP_DistanceBetween>DIST1||DIST1==0) then
					return 2
				else
					return 1
				end
			end
		end
	end

	return 0
end

local function Tyrant_DoMeleeDamage(self,DMG,TYPE,DIST,RAD,BONE,HITSND,MISSSND)
	local TEMP_TargetTakeDamage = false
	local TEMP_SomeoneTakeDamage = false
	local TEMP_DamagesCount = 0

	if(DIST!=nil) then
		local TEMP_OBBSize = (Vector(math.abs(self:OBBMins().x),math.abs(self:OBBMins().y),0)+
		Vector(math.abs(self:OBBMaxs().x),math.abs(self:OBBMaxs().y),0))/2
		local TEMP_PossibleDamageTargets = ents.FindInSphere(self:GetPos(), DIST)
		local TEMP_DMGMAT = self:GetBoneMatrix(self:LookupBone(BONE))
		local TEMP_DMGPOS, TEMP_DMGANG = TEMP_DMGMAT:GetTranslation(), TEMP_DMGMAT:GetAngles()
		local TEMP_DamageApplied = false
			
		if(#TEMP_PossibleDamageTargets>0) then
			for _,v in pairs(TEMP_PossibleDamageTargets) do
				if(Tyrant_CanAttackThis(self,v)&&self:Visible(v)) then

					local TEMP_DistanceForMelee = Tyrant_EnemyInMeleeRange(self,v,0,DIST)
					
					/*local TEMP_DotVector = v:GetPos()
					local TEMP_DotDir = TEMP_DotVector - self:GetPos()
					TEMP_DotDir:Normalize()
					local TEMP_Dot = Vector(self:GetForward().x,self:GetForward().y,0):Dot(Vector(TEMP_DotDir.x,TEMP_DotDir.y,0))
					*/
					local TEMP_PosToTarg = v:GetPos()-self:GetPos()
					local TEMP_PosToTargAng = Vector(TEMP_PosToTarg.x,TEMP_PosToTarg.y,0):Angle().Yaw
					
					local TEMP_AngToEn = math.abs(math.NormalizeAngle(TEMP_PosToTargAng-self:GetAngles().Yaw))
					
					
					if(TEMP_DistanceForMelee==2&&(TEMP_AngToEn<RAD||RAD==360)) then
						TEMP_DamageApplied = true
						
						local TEMP_FMOD = 100
						local TEMP_ZMOD = 0.4
						
						local TEMP_FlySpeed = (math.abs(v:OBBMins().x)+math.abs(v:OBBMins().y)+math.abs(v:OBBMins().z)+
						math.abs(v:OBBMaxs().x)+math.abs(v:OBBMaxs().y)+math.abs(v:OBBMaxs().z))
						
						local TEMP_FlyDir = 
						(((((v:GetPos()+v:OBBCenter())-(self:GetPos()+self:OBBCenter())):GetNormalized()+Vector(0,0,TEMP_ZMOD))/
						TEMP_FlySpeed)*(100*self.MeleeFlySpeed))*(DMG/1000)
						
						local TEMP_DAMAGEPOSITION = v:NearestPoint(TEMP_DMGPOS)
						local TEMP_DAMAGEFORCE = (TEMP_DAMAGEPOSITION-TEMP_DMGPOS):GetNormalized()*TEMP_FlyDir:Length()
						
						local TEMP_TargetDamage = DamageInfo()
						
						TEMP_TargetDamage:SetDamage(DMG*self.DamageMultiplier)
						TEMP_TargetDamage:SetInflictor(self)
						TEMP_TargetDamage:SetDamageType(TYPE)
						TEMP_TargetDamage:SetAttacker(self)
						TEMP_TargetDamage:SetDamagePosition(TEMP_DAMAGEPOSITION)
						TEMP_TargetDamage:SetDamageForce(TEMP_DAMAGEFORCE)
						v:TakeDamageInfo(TEMP_TargetDamage)
						
						if(v==self:GetEnemy()) then
							TEMP_TargetTakeDamage = true
						end
						
						if(v:IsNPC()||v:IsPlayer()) then
							TEMP_SomeoneTakeDamage = true
							TEMP_DamagesCount = 1
						end
						
						if(TEMP_FlyDir.z>250||!v:IsOnGround()) then
							TEMP_FMOD = 25
						end
						
						if(v:IsPlayer()) then
							v:ViewPunch(Angle(math.random(-1,1)*TEMP_FlyDir:Length(),math.random(-1,1)*TEMP_FlyDir:Length(),math.random(-1,1)*TEMP_FlyDir:Length()))
							TEMP_ZMOD = 0.4
						end
						
						TEMP_FlyDir = TEMP_FlyDir*TEMP_FMOD
						
						v:SetVelocity(TEMP_FlyDir)
					end
				end
			end
		end
		
		if(TEMP_DamageApplied==true) then
			sound.Play( table.Random(HITSND),TEMP_DMGPOS)
		else
			sound.Play( table.Random(MISSSND),TEMP_DMGPOS)
		end
	end
	
	return TEMP_TargetTakeDamage,TEMP_SomeoneTakeDamage,TEMP_DamagesCount
end

local function Tyrant_MeleeSequenceEnd(self,ANM)
	if(self.CanJump==false&&(ANM=="S_Melee_Jump_3"||ANM=="S_Melee_Jump_3_1"||ANM=="S_Melee_Jump_RH")) then
		timer.Create("TyrantCanJump"..tostring(self),3,1,function()
			if(IsValid(self)) then
				self.CanJump = true
			end
		end)
	end
end

local function Tyrant_SelectMeleeAttack(self)
	if(self.Phase==3) then
		return math.random(1,4)
	else
		return math.random(1,2)
	end
end

local function Tyrant_MeleeAttackEvent(self) 
end


function Tyrant_MeleeAttackFrameEvent(self,IND)
	if(self.Animation=="S_Melee_Jump_3"&&IND==1) then
		if(IsValid(self:GetGroundEntity())) then
			local DMGTYPE = DMG_CLUB
			
			if(self.Phase!=1) then
				DMGTYPE = DMG_SLASH
				sound.Play("Tyrant.ClawHit3",self:GetPos())
			end
			
			local TEMP_TargetDamage = DamageInfo()
						
			TEMP_TargetDamage:SetDamage(153*self.DamageMultiplier)
			TEMP_TargetDamage:SetInflictor(self)
			TEMP_TargetDamage:SetDamageType(DMGTYPE)
			TEMP_TargetDamage:SetAttacker(self)
			TEMP_TargetDamage:SetDamagePosition(self:GetPos())
			TEMP_TargetDamage:SetDamageForce(Vector(0,0,-1000))
			self:GetGroundEntity():TakeDamageInfo(TEMP_TargetDamage)
		end
			
		sound.Play("Tyrant.JumpAttack.Land",self:GetPos())
		util.ScreenShake( self:GetPos(), 8, 6, 0.5, 500 )
		
		local TEMP_DecalTable = {}
		
		for P=1, #player.GetAll() do
			table.insert(TEMP_DecalTable,player.GetAll()[P])
		end
		
		table.insert(TEMP_DecalTable,self)
		
		util.Decal( "Tyrant.FallCrater", self:GetPos(), self:GetPos()+Vector(0,0,-100), TEMP_DecalTable )
		
		Tyrant_DoMeleeDamage(self,38,DMG_CLUB,57,360,"N_ALL",{""},{""})
	end

end

local function Tyrant_MakeMeleeAttack(self,IND)
	if( self.PlayingAnimation == true ) then
		local TEMP_MeleeAttackSequenceName = self.Animation

		local TEMP_TargetTakeDamage = false
		local TEMP_SomeoneTakeDamage = false
		local TEMP_DamagesCount = 0
		
		for i=1, self.MeleeDamageCount[IND] do
			timer.Create("DamageAttack"..tostring(self)..i,self.MeleeDamageTime[IND][i]-0.2,1,function()
				if(IsValid(self)&&self!=nil&&self!=NULL) then
					if(istable(self.MeleeDamageDamage[IND])&&isnumber(self.MeleeDamageDamage[IND][i])) then
						local TEMP_TARGETDMG, TEMP_SOMEONEDMG, TEMP_DMGCNT = Tyrant_DoMeleeDamage(self,self.MeleeDamageDamage[IND][i],
						self.MeleeDamageType[IND][i],self.MeleeDamageDistance[IND][i]+7,self.MeleeDamageRadius[IND][i],
						self.MeleeDamageBone[IND][i],self.MeleeHitSound[IND],self.MeleeMissSound[IND])
					
						Tyrant_MeleeAttackFrameEvent(self,i)
					
						if(TEMP_TARGETDMG==true) then
							TEMP_TargetTakeDamage = true
						end
						
						if(TEMP_SOMEONEDMG==true) then
							TEMP_SomeoneTakeDamage = true
						end
						
						TEMP_DamagesCount = TEMP_DamagesCount+TEMP_DMGCNT
						
					end
				end
			end )
		end
		
		TEMP_AnimDur = self:SequenceDuration(self:LookupSequence(self.Animation))
		
		if(self.PlayingGesture==true) then
			TEMP_AnimDur = (self:SequenceDuration(self:LookupSequence(self.Animation))/2)
		end
		
		timer.Create("EndAttack"..tostring(self),TEMP_AnimDur+0.1,1,function()
			if(IsValid(self)&&self!=nil&&self!=NULL) then
				Tyrant_MeleeSequenceEnd(self,self.Animation)
				Tyrant_ClearAnimation(self)
			end
		end)
		
		
	end

end

local function Tyrant_MeleePlay(self,TEMP_RandomMelee)
	if(self.MeleeSoundEnabled==true) then
		
		Tyrant_PlaySoundRandom(self,
		66,
		self.MeleeSound.name,
		self.MeleeSound.min,
		self.MeleeSound.max)
	end
	Tyrant_StopAllTimers(self)
	
	if(!isnumber(TEMP_RandomMelee)) then
		TEMP_RandomMelee = math.random(1,#self.MeleeAttackSequence)
	end

	if(!self.MeleeAttackGesture[TEMP_RandomMelee]) then
		Tyrant_PlayAnimation(self,self.MeleeAttackSequence[TEMP_RandomMelee],1)
		Tyrant_MakeMeleeAttack(self,TEMP_RandomMelee)
	else
		Tyrant_PlayGesture(self,self.MeleeAttackSequence[TEMP_RandomMelee],1)
		Tyrant_MakeMeleeAttack(self,TEMP_RandomMelee)
	end
	
	Tyrant_MeleeAttackEvent(self)
end


local function Tyrant_DistanceForMeleeTooBig(self)
	//Jump attacks
	if(self.PlayingAnimation==false) then
		if(self.CanJump==true) then
			local TEMP_JumpChance = math.random(1,4)
			
			if(TEMP_JumpChance==1) then
				local TEMP_MeleeHitTable = {}
				for S=1,3 do
					TEMP_MeleeHitTable[S] = "Tyrant.Hit"..S
				end
				
				local TEMP_MeleeMissTable = {}
				for S=1,2 do
					TEMP_MeleeMissTable[S] = "Tyrant.Miss"..S
				end
				
				if(Tyrant_EnemyInMeleeRange(self,self:GetEnemy(),70+((self.Phase-1)*130),90+((self.Phase-1)*140))==2) then
					self:SetAngles(Angle(0,(self:GetEnemy():GetPos()-self:GetPos()):Angle().Yaw,0))
					
					Tyrant_StopAllTimers(self)
					Tyrant_PlayAnimation(self,"S_Melee_Jump_1",0)

					
					if(self.Phase==1) then
						timer.Create("StartAttack"..tostring(self),self:SequenceDuration(self.Animation)-0.2,1,function()
							if(IsValid(self)&&self!=nil&&self!=NULL) then
								Tyrant_PlayAnimation(self,"S_Melee_Jump_2",0)
								
								Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*3000)+Vector(0,0,280))

							end
						end)
					elseif(self.Phase==2) then
						timer.Create("StartAttack"..tostring(self),self:SequenceDuration(self.Animation)-0.6,1,function()
							if(IsValid(self)&&self!=nil&&self!=NULL) then
								Tyrant_PlayAnimation(self,"S_Melee_Jump_2",0)
								
								Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*3500)+Vector(0,0,340))

							end
						end)
					else
						timer.Create("StartAttack"..tostring(self),self:SequenceDuration(self.Animation)-0.6,1,function()
							if(IsValid(self)&&self!=nil&&self!=NULL) then
								Tyrant_PlayAnimation(self,"S_Melee_Jump_2",0)
								
								Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*5900)+Vector(0,0,340))

							end
						end)
					end
				end
			end
		end
		//Run attacks
		if(self:IsMoving()&&self.RunningTime>8&&self.PlayingAnimation==false) then
			if(self.Phase==1||self.Phase==2) then
				local TEMP_DTA = 40
				
				if(self.Phase==1) then
					TEMP_DTA = 70
				end
				
				if(Tyrant_EnemyInMeleeRange(self,self:GetEnemy(),(-40)+TEMP_DTA,TEMP_DTA)==2) then
					self:SetAngles(Angle(0,(self:GetEnemy():GetPos()-self:GetPos()):Angle().Yaw,0))
					
					
					local TEMP_RAI = math.random(4,5)
					
					if(self.Phase==2) then
						Tyrant_MeleeAttackEvent(self)

						Tyrant_PlayAnimation(self,self.MeleeAttackSequence[TEMP_RAI],1)
						Tyrant_MakeMeleeAttack(self,TEMP_RAI)
					
						if(TEMP_RAI==5) then
							timer.Create("StartAttack"..tostring(self),0.03,1,function()
								if(IsValid(self)&&self!=nil&&self!=NULL) then
									Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*3600)+Vector(0,0,10))
										
									timer.Create("StartAttack"..tostring(self),0.2,1,function()
										if(IsValid(self)&&self!=nil&&self!=NULL) then
											Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*2100)+Vector(0,0,10))
											
											timer.Create("StartAttack"..tostring(self),0.6,1,function()
												if(IsValid(self)&&self!=nil&&self!=NULL) then
													Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*700)+Vector(0,0,10))
													
													timer.Create("StartAttack"..tostring(self),0.3,1,function()
														if(IsValid(self)&&self!=nil&&self!=NULL) then
															Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*700)+Vector(0,0,10))
														end
													end)
												end
											end)
										end
									end)
								end
							end)
						elseif(TEMP_RAI==4) then
							timer.Create("StartAttack"..tostring(self),0.03,1,function()
								if(IsValid(self)&&self!=nil&&self!=NULL) then
									Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*2300)+Vector(0,0,10))
										
									timer.Create("StartAttack"..tostring(self),0.2,1,function()
										if(IsValid(self)&&self!=nil&&self!=NULL) then
											Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*2100)+Vector(0,0,10))
											
											timer.Create("StartAttack"..tostring(self),0.4,1,function()
												if(IsValid(self)&&self!=nil&&self!=NULL) then
													Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*300)+Vector(0,0,10))
												end
											end)
										end
									end)
								end
							end)
						end
					elseif(self.Phase==1) then
						TEMP_RAI = 4
						
						Tyrant_MeleeAttackEvent(self)

						Tyrant_PlayAnimation(self,self.MeleeAttackSequence[TEMP_RAI],1)
						Tyrant_MakeMeleeAttack(self,TEMP_RAI)
						
						timer.Create("StartAttack"..tostring(self),0.03,1,function()
							if(IsValid(self)&&self!=nil&&self!=NULL) then
								Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*2300)+Vector(0,0,10))
									
								timer.Create("StartAttack"..tostring(self),0.2,1,function()
									if(IsValid(self)&&self!=nil&&self!=NULL) then
										Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*2600)+Vector(0,0,10))
										
										timer.Create("StartAttack"..tostring(self),0.4,1,function()
											if(IsValid(self)&&self!=nil&&self!=NULL) then
												Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*300)+Vector(0,0,10))
											end
										end)
									end
								end)
							end
						end)
					end
				end
			else
				if(Tyrant_EnemyInMeleeRange(self,self:GetEnemy(),140,150)==2&&self.CanJump==true) then
					self:SetAngles(Angle(0,(self:GetEnemy():GetPos()-self:GetPos()):Angle().Yaw,0))
					
					self.CanJump = false
					
					Tyrant_MeleeAttackEvent(self)

					Tyrant_PlayAnimation(self,self.MeleeAttackSequence[9],1)
					Tyrant_MakeMeleeAttack(self,9)
					
					timer.Create("StartAttack"..tostring(self),0.01,1,function()
						if(IsValid(self)&&self!=nil&&self!=NULL) then
							Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*1000)+Vector(0,0,10))
							
							timer.Create("StartAttack"..tostring(self),0.25,1,function()
								if(IsValid(self)&&self!=nil&&self!=NULL) then
									Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*3000)+Vector(0,0,250))
								end
							end)
						end
					end)
				elseif(Tyrant_EnemyInMeleeRange(self,self:GetEnemy(),40,80)==2) then
				
					TEMP_RAI = math.random(7,8)
							
					Tyrant_MeleeAttackEvent(self)

					Tyrant_PlayAnimation(self,self.MeleeAttackSequence[TEMP_RAI],1)
					Tyrant_MakeMeleeAttack(self,TEMP_RAI)
					
					timer.Create("StartAttack"..tostring(self),0.03,1,function()
						if(IsValid(self)&&self!=nil&&self!=NULL) then
							Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*3300)+Vector(0,0,10))
							
							timer.Create("StartAttack"..tostring(self),0.1,1,function()
								if(IsValid(self)&&self!=nil&&self!=NULL) then
									Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*2300)+Vector(0,0,10))
									
								end
							end)
							
						end
					end)
			
			
				end
			end
		end
		
	end
end

local function Tyrant_DistanceForMeleeTooSmall(self)
	if(self.Phase==1) then
		local TEMP_Dir = math.NormalizeAngle((self:GetPos()-self:GetEnemy():GetPos()):Angle().Yaw-self:GetAngles().Yaw)
		
			
		if(math.abs(TEMP_Dir)<40) then
			self:SetAngles(Angle(0,self:GetAngles().Yaw-179,0))
			
			
			Tyrant_MeleeAttackEvent(self)
			Tyrant_PlayAnimation(self,self.MeleeAttackSequence[9],1)
			Tyrant_MakeMeleeAttack(self,9)

			timer.Create("StartAttack"..tostring(self),0.5,1,function()
				if(IsValid(self)&&self!=nil&&self!=NULL) then
					Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*300)+Vector(0,0,10))
					
					timer.Create("StartAttack"..tostring(self),0.3,1,function()
						if(IsValid(self)&&self!=nil&&self!=NULL) then
							Tyrant_SetLocalVelocity(self,-(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*300)+Vector(0,0,10))
						end	
					end)
				end
			end)
		else

			local TEMP_Rand = math.random(5,8)

			if(TEMP_Rand==5) then
				timer.Create("StartAttack"..tostring(self),0.5,1,function()
					if(IsValid(self)&&self!=nil&&self!=NULL) then
						Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*400)+Vector(0,0,10))
						
						timer.Create("StartAttack"..tostring(self),1.2,1,function()
							if(IsValid(self)&&self!=nil&&self!=NULL) then
								Tyrant_SetLocalVelocity(self,-(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*300)+Vector(0,0,10))
							end
						end)
					end
				end)
			elseif(TEMP_Rand==6) then
				timer.Create("StartAttack"..tostring(self),0.55,1,function()
					if(IsValid(self)&&self!=nil&&self!=NULL) then
						Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*280)+Vector(0,0,15))
						
						timer.Create("StartAttack"..tostring(self),0.23,1,function()
							if(IsValid(self)&&self!=nil&&self!=NULL) then
								Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*280)+Vector(0,0,15))
								
								timer.Create("StartAttack"..tostring(self),0.13,1,function()
									if(IsValid(self)&&self!=nil&&self!=NULL) then
										Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*280)+Vector(0,0,15))
									end
								end)
							end
						end)
						
					end
				end)
			elseif(TEMP_Rand==7) then
				timer.Create("StartAttack"..tostring(self),1.2,1,function()
					if(IsValid(self)&&self!=nil&&self!=NULL) then
						Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*400)+Vector(0,0,10))
						
						timer.Create("StartAttack"..tostring(self),0.6,1,function()
							if(IsValid(self)&&self!=nil&&self!=NULL) then
								Tyrant_SetLocalVelocity(self,-(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*300)+Vector(0,0,10))
							end
						end)
						
					end
				end)
			else
				timer.Create("StartAttack"..tostring(self),0.3,1,function()
					if(IsValid(self)&&self!=nil&&self!=NULL) then
						Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*390)+Vector(0,0,10))
						
						timer.Create("StartAttack"..tostring(self),0.01,50,function()
							if(IsValid(self)&&self!=nil&&self!=NULL) then
								Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*190)+Vector(0,0,10))
							end
						end)
						
						timer.Create("StartAttack"..tostring(self),0.6,1,function()
							if(IsValid(self)&&self!=nil&&self!=NULL) then
								Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*140)+Vector(0,0,10))
							end
						end)
					end
				end)
			end
			
			Tyrant_MeleeAttackEvent(self)

			Tyrant_PlayAnimation(self,self.MeleeAttackSequence[TEMP_Rand],1)
			Tyrant_MakeMeleeAttack(self,TEMP_Rand)
		end
	elseif(self.Phase==2) then
		local TEMP_Rand = math.random(6,10)
		local TEMP_NP = self:GetEnemy():NearestPoint(self:GetPos()+self:OBBCenter()).Z
		local TEMP_SP = (self:GetPos()+self:OBBCenter()).Z
		
		if(TEMP_Rand==6) then
			timer.Create("StartAttack"..tostring(self),0.4,1,function()
				if(IsValid(self)&&self!=nil&&self!=NULL) then
					Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*300)+Vector(0,0,10))
					
					timer.Create("StartAttack"..tostring(self),1.5,1,function()
						if(IsValid(self)&&self!=nil&&self!=NULL) then
							Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*-500)+Vector(0,0,10))
						end
					end)
				end
			end)
		end
		
		Tyrant_MeleeAttackEvent(self)
		Tyrant_PlayAnimation(self,self.MeleeAttackSequence[TEMP_Rand],1)
		Tyrant_MakeMeleeAttack(self,TEMP_Rand)
	elseif(self.Phase==3) then
		local TEMP_Rand = math.random(10,13)

		if(TEMP_Rand!=13) then
			Tyrant_MeleeAttackEvent(self)
			Tyrant_PlayAnimation(self,self.MeleeAttackSequence[TEMP_Rand],1)
			Tyrant_MakeMeleeAttack(self,TEMP_Rand)
		end
		
		if(TEMP_Rand==10) then
			timer.Create("StartAttack"..tostring(self),0.4,1,function()
				if(IsValid(self)&&self!=nil&&self!=NULL) then
					Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*100)+Vector(0,0,10))
				end
			end)
		elseif(TEMP_Rand==11) then
			timer.Create("StartAttack"..tostring(self),0.3,1,function()
				if(IsValid(self)&&self!=nil&&self!=NULL) then
					Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*400)+Vector(0,0,10))
					
					timer.Create("StartAttack"..tostring(self),0.3,1,function()
						if(IsValid(self)&&self!=nil&&self!=NULL) then
							Tyrant_SetLocalVelocity(self,(Vector(self:GetForward().X,self:GetForward().Y,0):GetNormalized()*400)+Vector(0,0,10))
						end
					end)
				end
			end)
		elseif(TEMP_Rand==12) then
			timer.Create("ComboCheck"..tostring(self),1.1,1,function()
				if(IsValid(self)&&self!=NULL) then
					if(IsValid(self:GetEnemy())&&self:GetEnemy()!=NULL) then
						if(Tyrant_EnemyInMeleeRange(self,self:GetEnemy(),0,35)==2&&
						((self:GetEnemy():IsPlayer()&&self:GetEnemy():Alive())||(!self:GetEnemy():IsPlayer()))) then
							Tyrant_StopAllTimers(self)
							local TEMP_Rand = math.random(13,14)
							
							Tyrant_MeleeAttackEvent(self)
							Tyrant_PlayAnimation(self,self.MeleeAttackSequence[TEMP_Rand],1)
							Tyrant_MakeMeleeAttack(self,TEMP_Rand)
						end
					end
				end
			end)
		elseif(TEMP_Rand==13) then
			local TEMP_Ents = ents.FindInSphere(self:GetPos(),200)
			local TEMP_CanAttack = false
			
			for E=1, #TEMP_Ents do
				if((TEMP_Ents[E]:IsNPC()||(TEMP_Ents[E]:IsPlayer()&&TEMP_Ents[E]:Alive()))&&self:Visible(TEMP_Ents[E])) then
					if(Tyrant_EnemyInMeleeRange(self,TEMP_Ents[E],0,40)==2&&TEMP_Ents[E]:GetSolid()==SOLID_BBOX&&TEMP_Ents[E]:GetModel()&&TEMP_Ents[E]:Health()<300) then
						local TEMP_BoxMin, TEMP_BoxMax = TEMP_Ents[E]:OBBMins(), TEMP_Ents[E]:OBBMaxs()
						
						local TEMP_SizeX = (math.abs(TEMP_BoxMin.x)+math.abs(TEMP_BoxMax.x))/2
						local TEMP_SizeY = (math.abs(TEMP_BoxMin.y)+math.abs(TEMP_BoxMax.y))/2
						local TEMP_SizeZ = (math.abs(TEMP_BoxMin.z)+math.abs(TEMP_BoxMax.z))/2
						
						if(TEMP_SizeX<55&&TEMP_SizeY<55&&TEMP_SizeZ<55) then
							local TEMP_Ang = ((TEMP_Ents[E]:GetPos()-self:GetPos()):Angle()-self:GetAngles()).Y
							TEMP_Ang = math.NormalizeAngle(TEMP_Ang)
							TEMP_Ang = math.abs(TEMP_Ang)
							
							if(TEMP_Ang<40) then
								TEMP_CanAttack = true
							end
						end
					end
				end
			end
			
			if(TEMP_CanAttack==true) then
				Tyrant_PlayAnimation(self,"S_Fatality",1)
							
				timer.Create("ComboCheck"..tostring(self),0.6,1,function()
					if(IsValid(self)&&self!=NULL) then
						local TEMP_Ents = ents.FindInSphere(self:GetPos(),200)
						local TEMP_CanAttack = false
						local TEMP_CanAttackEnt = self
						
						for E=1, #TEMP_Ents do
							if(TEMP_CanAttackEnt==self&&(TEMP_Ents[E]:IsNPC()||(TEMP_Ents[E]:IsPlayer()&&TEMP_Ents[E]:Alive()))&&self:Visible(TEMP_Ents[E])) then
								if(Tyrant_EnemyInMeleeRange(self,TEMP_Ents[E],0,40)==2&&TEMP_Ents[E]:GetSolid()==SOLID_BBOX&&TEMP_Ents[E]:GetModel()&&TEMP_Ents[E]:Health()<300) then
									local TEMP_BoxMin, TEMP_BoxMax = TEMP_Ents[E]:OBBMins(), TEMP_Ents[E]:OBBMaxs()
						
									local TEMP_SizeX = (math.abs(TEMP_BoxMin.x)+math.abs(TEMP_BoxMax.x))/2
									local TEMP_SizeY = (math.abs(TEMP_BoxMin.y)+math.abs(TEMP_BoxMax.y))/2
									local TEMP_SizeZ = (math.abs(TEMP_BoxMin.z)+math.abs(TEMP_BoxMax.z))/2
									
									if(TEMP_SizeX<55&&TEMP_SizeY<55&&TEMP_SizeZ<55) then
										local TEMP_Ang = ((TEMP_Ents[E]:GetPos()-self:GetPos()):Angle()-self:GetAngles()).Y
										TEMP_Ang = math.NormalizeAngle(TEMP_Ang)
										TEMP_Ang = math.abs(TEMP_Ang)
										
										if(TEMP_Ang<40) then
											TEMP_CanAttack = true
											TEMP_CanAttackEnt = TEMP_Ents[E]
										end
									end
								end
							end
						end
						
						if(TEMP_CanAttack==false) then
							Tyrant_PlayAnimation(self,"S_Fatality_Fail",1)
							
							timer.Create("EndAttack"..tostring(self),0.5,1,function()
								if(IsValid(self)&&self!=NULL) then
									Tyrant_ClearAnimation(self)
								end
							end)
						else
							if(TEMP_CanAttackEnt:IsNPC()) then
								local TEMP_Doll = ents.Create("prop_ragdoll")
								TEMP_Doll:SetPos(self:GetBonePosition(self:LookupBone("_10")))
								TEMP_Doll:SetAngles(TEMP_CanAttackEnt:GetAngles())
								TEMP_Doll:SetModel(TEMP_CanAttackEnt:GetModel())
								TEMP_Doll:Spawn()
								
								if(TEMP_Doll:GetPhysicsObjectCount()>1) then
									local TEMP_BodyString = ""
						
									for G=0, self:GetNumBodyGroups() do
										TEMP_BodyString = TEMP_BodyString..TEMP_CanAttackEnt:GetBodygroup(G)
									end
									
									TEMP_Doll:SetBodyGroups(TEMP_BodyString)
									TEMP_Doll:SetSkin(TEMP_CanAttackEnt:GetSkin())
									
									
									for B=0, TEMP_Doll:GetPhysicsObjectCount()-1 do
										if(IsValid(TEMP_Doll:GetPhysicsObjectNum(B))&&isnumber(TEMP_Doll:TranslatePhysBoneToBone(B))) then
											local TEMP_BPos, TEMP_BAng = TEMP_CanAttackEnt:GetBonePosition(TEMP_Doll:TranslatePhysBoneToBone(B))
											
											TEMP_Doll:GetPhysicsObjectNum(B):SetPos(TEMP_BPos+(self:GetBonePosition(self:LookupBone("_10"))-TEMP_CanAttackEnt:GetPos()))
											TEMP_Doll:GetPhysicsObjectNum(B):SetAngles(TEMP_BAng)
										end
									end
												
									TEMP_Doll:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
									
									if(GetConVar("re_npc_grab_corpse_dietime"):GetFloat()>0) then
										timer.Simple(GetConVar("re_npc_grab_corpse_dietime"):GetFloat(),function()
											if(IsValid(TEMP_Doll)) then
												local TEMP_Dissolver = ents.Create( "env_entity_dissolver" )
												TEMP_Dissolver:SetPos( TEMP_Doll:GetPos() )
												TEMP_Dissolver:SetKeyValue( "dissolvetype", 3 )
												TEMP_Dissolver:Spawn()
												TEMP_Dissolver:Activate()
												
												local TEMP_Name = "Dissolving_Tyrant_Victim_Ragdoll"..tostring(Doll)
												TEMP_Doll:SetName( TEMP_Name )
												TEMP_Dissolver:Fire( "Dissolve", TEMP_Name, 0 )
												TEMP_Dissolver:Fire( "Kill", "", 0.1 )
											end
										end)
									end
								
								
								
									net.Start( "NPCKilledNPC" )
										net.WriteString( TEMP_CanAttackEnt:GetClass() )
										net.WriteString( self:GetClass() )
										net.WriteString( self:GetClass() )
									net.Broadcast()
									
									sound.Play("Tyrant.Fatality",self:GetBonePosition(self:LookupBone("_10")))
									
									timer.Create("DollManipulate"..tostring(self),0.01,400,function()
										if(IsValid(self)&&self!=NULL&&IsValid(TEMP_Doll)&&TEMP_Doll!=NULL&&
										TEMP_Doll:GetPos():Distance(self:GetBonePosition(self:LookupBone("_10")))<100) then
											TEMP_Doll:GetPhysicsObject():ApplyForceCenter((self:GetBonePosition(self:LookupBone("_10"))-self:GetPhysicsObject():GetPos())*(self:GetPhysicsObject():GetMass()/20))
											TEMP_Doll:GetPhysicsObject():SetPos(self:GetBonePosition(self:LookupBone("_10")))
										end
									end)
									
									timer.Create("DollManipulateEnd"..tostring(self),2.6,1,function()
										if(IsValid(self)&&self!=NULL&&IsValid(TEMP_Doll)&&TEMP_Doll!=NULL) then
											timer.Remove("DollManipulate"..tostring(self))
										
											if(TEMP_Doll:GetPos():Distance(self:GetBonePosition(self:LookupBone("_10")))<120) then
												for P=0, TEMP_Doll:GetPhysicsObjectCount()-1 do
													TEMP_Doll:GetPhysicsObjectNum(P):ApplyForceCenter(((self:GetForward()*10)+self:GetUp()*6)*TEMP_Doll:GetPhysicsObjectNum(P):GetMass()*1000)
												end
											end
										end
									end)
									
									timer.Create("EndAttack"..tostring(self),3.3,1,function()
										if(IsValid(self)&&self!=NULL) then
											Tyrant_ClearAnimation(self)
										end
									end)
									
									TEMP_CanAttackEnt:Remove()
									
									timer.Create("MidAttack"..tostring(self),2.0,1,function()
										if(IsValid(self)&&self!=NULL) then
											Tyrant_SetLocalVelocity(self,(self:GetForward()*1000)+Vector(0,0,10))
										end
									end)
								else
									TEMP_Doll:Remove()
									
									Tyrant_PlayAnimation(self,"S_Fatality_Fail",1)
							
									timer.Create("EndAttack"..tostring(self),0.5,1,function()
										if(IsValid(self)&&self!=NULL) then
											Tyrant_ClearAnimation(self)
										end
									end)
								end
							else
								local TEMP_Doll = ents.Create("prop_ragdoll")
								TEMP_Doll:SetPos(TEMP_CanAttackEnt:GetPos())
								TEMP_Doll:SetAngles(TEMP_CanAttackEnt:GetAngles())
								TEMP_Doll:SetModel(TEMP_CanAttackEnt:GetModel())
								TEMP_Doll:SetColor(TEMP_CanAttackEnt:GetColor())
								TEMP_Doll:Spawn()
								
								if(TEMP_Doll:GetPhysicsObjectCount()>1) then
									sound.Play("Tyrant.Fatality",self:GetBonePosition(self:LookupBone("_10")))
									
									net.Start( "PlayerKilled" )
										net.WriteEntity( TEMP_CanAttackEnt )
										net.WriteString( self:GetClass() )
										net.WriteString( self:GetClass() )
									net.Broadcast()
									
									TEMP_CanAttackEnt:KillSilent()
								
									local TEMP_BodyString = ""
						
									for G=0, self:GetNumBodyGroups() do
										TEMP_BodyString = TEMP_BodyString..TEMP_CanAttackEnt:GetBodygroup(G)
									end
									
									TEMP_Doll:SetBodyGroups(TEMP_BodyString)
									TEMP_Doll:SetSkin(TEMP_CanAttackEnt:GetSkin())
									
									TEMP_Doll:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
									
									for B=0, TEMP_Doll:GetPhysicsObjectCount()-1 do
										if(IsValid(TEMP_Doll:GetPhysicsObjectNum(B))&&isnumber(TEMP_Doll:TranslatePhysBoneToBone(B))) then
											local TEMP_BPos, TEMP_BAng = TEMP_CanAttackEnt:GetBonePosition(TEMP_Doll:TranslatePhysBoneToBone(B))
											
											TEMP_Doll:GetPhysicsObjectNum(B):SetPos(TEMP_BPos+(self:GetBonePosition(self:LookupBone("_10"))-TEMP_CanAttackEnt:GetPos()))
											TEMP_Doll:GetPhysicsObjectNum(B):SetAngles(TEMP_BAng)
										end
									end
									
									TEMP_Doll:SetVelocity(TEMP_CanAttackEnt:GetVelocity())

									TEMP_Doll:SetNW2Entity("RagdollOwner",TEMP_CanAttackEnt)
									TEMP_Doll:SetOwner(TEMP_CanAttackEnt)
									
									
									timer.Simple(0.1,function()
										if(IsValid(TEMP_CanAttackEnt)&&!TEMP_CanAttackEnt:Alive()&&IsValid(TEMP_Doll)) then
											TEMP_CanAttackEnt:Spectate( OBS_MODE_CHASE )
											TEMP_CanAttackEnt:SpectateEntity( TEMP_Doll )
										end
									end)
									
									if(GetConVar("re_npc_grab_corpse_dietime"):GetFloat()>0) then
										timer.Simple(GetConVar("re_npc_grab_corpse_dietime"):GetFloat(),function()
											if(IsValid(TEMP_Doll)) then
												local TEMP_Dissolver = ents.Create( "env_entity_dissolver" )
												TEMP_Dissolver:SetPos( TEMP_Doll:GetPos() )
												TEMP_Dissolver:SetKeyValue( "dissolvetype", 3 )
												TEMP_Dissolver:Spawn()
												TEMP_Dissolver:Activate()
												
												local TEMP_Name = "Dissolving_Tyrant_Victim_Ragdoll"..tostring(Doll)
												TEMP_Doll:SetName( TEMP_Name )
												TEMP_Dissolver:Fire( "Dissolve", TEMP_Name, 0 )
												TEMP_Dissolver:Fire( "Kill", "", 0.1 )
											end
										end)
									end

									TEMP_CanAttackEnt:SpectateEntity(self)
									
									timer.Create("DollManipulate"..tostring(self),0.01,400,function()
										if(IsValid(self)&&self!=NULL&&IsValid(TEMP_Doll)&&TEMP_Doll!=NULL&&
										TEMP_Doll:GetPos():Distance(self:GetBonePosition(self:LookupBone("_10")))<100) then
											TEMP_Doll:GetPhysicsObject():ApplyForceCenter((self:GetBonePosition(self:LookupBone("_10"))-self:GetPhysicsObject():GetPos())*(self:GetPhysicsObject():GetMass()/20))
											TEMP_Doll:GetPhysicsObject():SetPos(self:GetBonePosition(self:LookupBone("_10")))
										end
									end)
									
									timer.Create("DollManipulateEnd"..tostring(self),2.6,1,function()
										if(IsValid(self)&&self!=NULL&&IsValid(TEMP_Doll)&&TEMP_Doll!=NULL) then
											timer.Remove("DollManipulate"..tostring(self))
										
											if(TEMP_Doll:GetPos():Distance(self:GetBonePosition(self:LookupBone("_10")))<120) then
												for P=0, TEMP_Doll:GetPhysicsObjectCount()-1 do
													TEMP_Doll:GetPhysicsObjectNum(P):ApplyForceCenter(((self:GetForward()*10)+self:GetUp()*6)*TEMP_Doll:GetPhysicsObjectNum(P):GetMass()*1000)
												end
											end
										end
									end)
									
									timer.Create("MidAttack"..tostring(self),2.0,1,function()
										if(IsValid(self)&&self!=NULL) then
											Tyrant_SetLocalVelocity(self,(self:GetForward()*200)+Vector(0,0,10))
										end
									end)
									
									timer.Create("EndAttack"..tostring(self),3.3,1,function()
										if(IsValid(self)&&self!=NULL) then
											Tyrant_ClearAnimation(self)
										end
									end)
								else
									TEMP_Doll:Remove()
									
									Tyrant_PlayAnimation(self,"S_Fatality_Fail",1)
								
									timer.Create("EndAttack"..tostring(self),0.5,1,function()
										if(IsValid(self)&&self!=NULL) then
											Tyrant_ClearAnimation(self)
										end
									end)
								end
								
								
								
							end
						end
					end
				end)
			end
					
		end
	end
end




//Think
local function Tyrant_AnimEnemyIsValid(self)
	if(self.PlayingAnimation==true&&self.AttackIndex==1&&!self:IsMoving()) then
		local TEMP_YAW = ((self:GetEnemy():GetPos()-self:GetPos()):Angle().Yaw)-self:GetAngles().Yaw
		TEMP_YAW = math.NormalizeAngle(TEMP_YAW)
		TEMP_YAW = math.Clamp(TEMP_YAW,-20,20)
		self:SetAngles(Angle(0,self:GetAngles().Yaw+TEMP_YAW,0))
	end
end

local function Tyrant_TryToFindEnemy(self)
	if(self.PlayingAnimation==false) then
		
		local TEMP_NearEnemyCount = 0
		
		
		local TEMP_NearestNpcDistance = 9999999999
		local TEMP_NearestNpc = self
		

		local TEMP_MyNearbyTargets = ents.FindInSphere(self:GetPos(),TEMP_NearestNpcDistance)
		
		if (#TEMP_MyNearbyTargets>0) then 
			for T=1, #TEMP_MyNearbyTargets do
				local TEMP_NPC = TEMP_MyNearbyTargets[T]
				
				if(IsValid(TEMP_NPC)&&TEMP_NPC!=nil&&TEMP_NPC!=NULL&&TEMP_NPC!=self) then
					if((TEMP_NPC:IsNPC()||TEMP_NPC:IsPlayer())&&TEMP_NPC:Visible(self)&&TEMP_NPC:GetClass()!="bullseye_strider_focus") then
						if((TEMP_NPC:IsNPC()&&((Tyrant_IsZombie(TEMP_NPC)&&TEMP_NPC:Disposition(self)==D_HT)||!Tyrant_IsZombie(TEMP_NPC)))||
						Tyrant_IsEnemyPlayer(self,TEMP_NPC)) then
							if(TEMP_NPC:IsNPC()&&TEMP_NPC:Disposition(self)!=D_HT&&TEMP_NPC:Disposition(self)!=D_LI) then
								self:AddEntityRelationship(TEMP_NPC,D_HT,self.Hate)
								TEMP_NPC:AddEntityRelationship(self,D_HT,self.Hate)
							end
								
							--local TEMP_Ang = (TEMP_NPC:GetPos()-self:GetPos()):Angle().Yaw-self:GetAngles().Yaw

							--if(math.abs(TEMP_Ang)<90) then
							
								if(TEMP_NPC:IsPlayer()||TEMP_NPC:Disposition(self)==D_HT) then
									if(T==1) then
										TEMP_NearestNpcDistance = self:GetPos():Distance(TEMP_NPC:GetPos())
										TEMP_NearestNpc = TEMP_NPC
									else
										if(self:GetPos():Distance(TEMP_NPC:GetPos())<TEMP_NearestNpcDistance) then
											TEMP_NearestNpcDistance = self:GetPos():Distance(TEMP_NPC:GetPos())
											TEMP_NearestNpc = TEMP_NPC
										end
									end
									
									if(self.NearestEnemyFindDistance>0) then
										if(Tyrant_EnemyInMeleeRange(TEMP_NPC,0,self.NearestEnemyFindDistance)==2) then
											TEMP_NearEnemyCount = TEMP_NearEnemyCount+1
										end
									end
								end
							--end
						end
					end
				end
			end
		end
		
		
		
		if(IsValid(TEMP_NearestNpc)&&TEMP_NearestNpc!=nil&&TEMP_NearestNpc!=NULL&&TEMP_NearestNpc!=self) then
			if(self.PlayingAnimation==false) then
				if(TEMP_NearestNpc!=self:GetEnemy()) then
					self:AddEntityRelationship( TEMP_NearestNpc, D_HT, self.Hate )
					self:SetEnemy(TEMP_NearestNpc)
					self.RegEnemy = TEMP_NearestNpc
					self:UpdateEnemyMemory(TEMP_NearestNpc,TEMP_NearestNpc:GetPos())
					
					//self:SetSchedule(SCHED_CHASE_ENEMY)
					self:SelectSchedule()
				end
			end
		end
		
		return TEMP_NearEnemyCount
	end
	
	return -1
end

local function Tyrant_TestForJump(self)
	local TEMP_JumpMinZ = 18
	local TEMP_JumpForward = self:GetForward()*2
	
	local TEMP_ForwardTracer = util.TraceHull( {
		start = self:GetPos()+Vector(0,0,TEMP_JumpMinZ),
		endpos = self:GetPos()+Vector(0,0,TEMP_JumpMinZ)+TEMP_JumpForward,
		filter = {self, self:GetEnemy()},
		mins = self:OBBMins(),
		maxs = self:OBBMaxs()-Vector(0,0,TEMP_JumpMinZ),
		mask = MASK_NPCSOLID
	} )
	
	if(TEMP_ForwardTracer.Hit) then
		if(Tyrant_IsWeldedDoor(TEMP_ForwardTracer.Entity)&&Tyrant_EnemyInMeleeRange(self,TEMP_ForwardTracer.Entity,0,self.MeleeAttackDistance)) then
			local TEMP_IND = Tyrant_SelectMeleeAttack(self)
			Tyrant_MeleePlay(self,TEMP_IND)
			return
		end
			
		if(TEMP_ForwardTracer.Entity:IsNPC()||TEMP_ForwardTracer.Entity:IsPlayer()) then
			return
		end
		
		local TEMP_UpTracer = util.TraceHull( {
			start = self:GetPos(),
			endpos = self:GetPos()+Vector(0,0,self.JumpHeight),
			filter = self,
			mins = self:OBBMins(),
			maxs = self:OBBMaxs(),
			mask = MASK_NPCSOLID
		} )
		
		if((TEMP_UpTracer.StartPos-TEMP_UpTracer.HitPos):Length()>2) then
			local TEMP_JumpUpTracer = util.TraceHull( {
				start = Vector(self:GetPos().x,self:GetPos().y,TEMP_UpTracer.HitPos.z-self:OBBMaxs().z),
				endpos = Vector(self:GetPos().x,self:GetPos().y,TEMP_UpTracer.HitPos.z-self:OBBMaxs().z)+(TEMP_JumpForward+self:GetForward()),
				filter = {self, self:GetEnemy()},
				mins = self:OBBMins(),
				maxs = self:OBBMaxs(),
				mask = MASK_NPCSOLID
			} )
			
			if(!TEMP_JumpUpTracer.Hit) then
				Tyrant_Jump(self)
			end
		end
	end
end


//Another Functions
local function Tyrant_StringAdd(STR,STR2)
	if(#STR>0&&string.sub( STR, #STR, #STR )!=",") then
		STR = STR..","
	end
	
	return STR..STR2
end



local function Tyrant_Bleed(self,INT,Pos,Ang)
	local TEMP_CEffectData = EffectData()
	TEMP_CEffectData:SetOrigin(Pos)
	TEMP_CEffectData:SetFlags(3)
	TEMP_CEffectData:SetScale(math.Clamp(INT,1,10))
	TEMP_CEffectData:SetColor(0)
	TEMP_CEffectData:SetNormal(Ang:Forward())
	TEMP_CEffectData:SetEntity(self)
	TEMP_CEffectData:SetAngles(Ang)
	util.Effect( "BloodImpact", TEMP_CEffectData, false )
end


local function Tyrant_Kill(self,dmginfo,PHYSTABLE,BoomDamage)
	
	if(self.IsAlive==true) then
		self.IsAlive = false
		
		Tyrant_StopAllTimers()
		self.Animation = ""
		self.AttackIndex = 0

		
		local TEMP_KillTime = 2
		
		if(self.DieSoundEnabled==true) then
			Tyrant_StopPreviousSound(self)
			Tyrant_PlaySoundRandom(self,100,self.DieSound.name,self.DieSound.min,self.DieSound.max)
		end

		local TEMP_ATTACKER = dmginfo:GetAttacker()
		local TEMP_INFLICTOR = dmginfo:GetInflictor()
		
		local TEMP_OWNERVEL = self:GetVelocity()
		
		
		self:SetMaterial("")
		self:ClearSchedule()
		self:SetNPCState(NPC_STATE_DEAD)
		
		if(!(IsValid(TEMP_ATTACKER)&&TEMP_ATTACKER!=nil&&TEMP_ATTACKER!=NULL&&TEMP_ATTACKER:GetClass()=="npc_barnacle")) then
			if(GetConVar("ai_serverragdolls"):GetInt()==0) then
				net.Start("TyrantRagdoll")
				net.WriteEntity(self)
				net.Broadcast()
			else
				local TEMP_Ragdoll = ents.Create("prop_ragdoll")
				TEMP_Ragdoll:SetModel(self:GetModel())
				TEMP_Ragdoll:SetPos(self:GetPos())
				TEMP_Ragdoll:SetAngles(self:GetAngles())
				TEMP_Ragdoll:Spawn()
				
				TEMP_Ragdoll:SetMaterial(self:GetMaterial())
				TEMP_Ragdoll:SetColor(self:GetColor())
				TEMP_Ragdoll:SetCollisionGroup(COLLISION_GROUP_WEAPON)
				
				for P=0, TEMP_Ragdoll:GetPhysicsObjectCount()-1 do
					local TEMP_Phys = TEMP_Ragdoll:GetPhysicsObjectNum(P)
					
					if(IsValid(TEMP_Phys)) then
						local TEMP_BoneMat = self:GetBoneMatrix(TEMP_Ragdoll:TranslatePhysBoneToBone(P))
						local TEMP_BonePos, TEMP_BoneAng = TEMP_BoneMat:GetTranslation(), TEMP_BoneMat:GetAngles()

						TEMP_Phys:SetPos(TEMP_BonePos)
						TEMP_Phys:SetAngles(TEMP_BoneAng)
					end
				end
				
				for B=0, self:GetBoneCount()-1 do
					TEMP_Ragdoll:ManipulateBoneScale(B,self:GetManipulateBoneScale(B))
					TEMP_Ragdoll:ManipulateBonePosition(B,self:GetManipulateBonePosition(B))
					TEMP_Ragdoll:ManipulateBoneAngles(B,self:GetManipulateBoneAngles(B))
				end
				timer.Simple(0.01,function()
					if(IsValid(TEMP_Ragdoll)&&TEMP_Ragdoll!=nil&&TEMP_Ragdoll!=NULL) then
						TEMP_Ragdoll:SetVelocity(TEMP_OWNERVEL)
					end
				end)
				
				TEMP_Ragdoll:TakeDamageInfo(dmginfo)

				TEMP_Ragdoll:Fire("kill","",30)
				TEMP_KillTime = 0.1
			end
		else
			TEMP_KillTime = 0.1
		end
		
		if(self:IsOnFire()) then
			self:Extinguish()
		end
		
		self:SetNoDraw(true)
		self:DrawShadow(false)
			
		Tyrant_StopAllTimers(self)
		
		self:SetCondition(67)
		self:SetNPCState(NPC_STATE_DEAD)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self:SetCollisionBounds(Vector(0,0,0),Vector(0,0,0))
		
		self:Fire("kill","",TEMP_KillTime)
		
		gamemode.Call( "OnNPCKilled",  self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
	end
end


local function Tyrant_ForcedGestureStarted(self,ANM)
	if(ANM=="S_Melee_PPush") then
		timer.Create("EndAttack"..tostring(self),(self:SequenceDuration(self.Animation)/2)+0.1,1,function()
			if(IsValid(self)&&self!=nil&&self!=NULL) then
				Tyrant_MeleeSequenceEnd(self,self.Animation)
				Tyrant_ClearAnimation(self)
			end
		end)
	end
end




























//Base functions
function ENT:OnRemove()
	Tyrant_StopAllTimers(self)
	
	
	timer.Remove("TyrantNewHull"..tostring(self))
	timer.Remove("TyrantBoneSize"..tostring(self))
end

function ENT:Use( activator, caller, type, value )
end

function ENT:StartTouch( entity )
end

function ENT:EndTouch( entity )
end

function ENT:Touch( entity )
end

function ENT:GetRelationship( entity )
end

function ENT:ExpressionFinished( strExp )
end

function ENT:Think()
	if(!self:IsOnGround()) then
		self:SetVelocity(Vector(0,0,-100))
	end
	
	
	if(GetConVar("ai_disabled"):GetInt()==0&&self.IsAlive==true) then
		Tyrant_Think(self)
		
		if(self.PlayingAnimation==false&&self.Phase!=1) then
			if(IsValid(self:GetGroundEntity())&&
			(Tyrant_IsEnemyPlayer(self,self:GetGroundEntity()))) then
				
				
				Tyrant_PlayAnimation(self,"S_Melee_Low",1)
				
				if(self.Phase==2) then
					timer.Create("StartAttack"..tostring(self),1.1,1,function()
						if(IsValid(self)&&self!=nil&&self!=NULL) then
							if(IsValid(self:GetGroundEntity())&&
							(Tyrant_IsEnemyPlayer(self,self:GetGroundEntity()))) then
								
								local TEMP_TargetDamage = DamageInfo()
						
								TEMP_TargetDamage:SetDamage(121*self.DamageMultiplier)
								TEMP_TargetDamage:SetInflictor(self)
								TEMP_TargetDamage:SetDamageType(DMG_SLASH)
								TEMP_TargetDamage:SetAttacker(self)
								TEMP_TargetDamage:SetDamagePosition(self:GetPos())
								TEMP_TargetDamage:SetDamageForce(Vector(0,0,-1000))
								self:GetGroundEntity():TakeDamageInfo(TEMP_TargetDamage)
							end
							
							timer.Create("StartAttack"..tostring(self),1.6,1,function()
								if(IsValid(self)&&self!=nil&&self!=NULL) then
									Tyrant_ClearAnimation(self)
									Tyrant_StopAllTimers(self)
								end
							end)
						end
					end)
				elseif(self.Phase==3) then
					timer.Create("StartAttack"..tostring(self),1.2,1,function()
						if(IsValid(self)&&self!=nil&&self!=NULL) then
							if(IsValid(self:GetGroundEntity())&&
							(Tyrant_IsEnemyPlayer(self,self:GetGroundEntity()))) then
								
								local TEMP_TargetDamage = DamageInfo()
						
								TEMP_TargetDamage:SetDamage(163*self.DamageMultiplier)
								TEMP_TargetDamage:SetInflictor(self)
								TEMP_TargetDamage:SetDamageType(DMG_SLASH)
								TEMP_TargetDamage:SetAttacker(self)
								TEMP_TargetDamage:SetDamagePosition(self:GetPos())
								TEMP_TargetDamage:SetDamageForce(Vector(0,0,-1000))
								self:GetGroundEntity():TakeDamageInfo(TEMP_TargetDamage)
							end
							
							timer.Create("StartAttack"..tostring(self),1.3,1,function()
								if(IsValid(self)&&self!=nil&&self!=NULL) then
									Tyrant_ClearAnimation(self)
									Tyrant_StopAllTimers(self)
								end
							end)
						end
					end)
				end
			end
		end
		
		
		if(self.NextTryingFindEnemy<CurTime()) then
			self.NextTryingFindEnemy = CurTime()+1.2
			Tyrant_TryToFindEnemy(self)
	
		end
		
		if(self.PlayingAnimation==false) then
			if(self.ForceNextMelee!=-1) then
				Tyrant_MeleePlay(self,self.ForceNextMelee)
				self.ForceNextGesture = ""
				self.ForceNextMelee = -1
			elseif(self.ForceNextGesture!="") then
				Tyrant_PlayGesture(self,self.ForceNextGesture)
				Tyrant_ForcedGestureStarted(self,self.ForceNextGesture)
				
				timer.Create("EndAttack"..tostring(self),(self:SequenceDuration(self.ForceNextGesture)/2)+0.1,1,function()
					if(IsValid(self)&&self!=nil&&self!=NULL) then
						Tyrant_ClearAnimation(self)
					end
				end)
		
				self.ForceNextGesture = ""
				self.ForceNextMelee = -1
			end
		end
		
		for k, v in ipairs( ents.FindByClass( "npc_*" ) ) do
			if ( v:IsNPC() ) then
				if ( !IsValid( v:GetEnemy() ) ) then
					local nearest_ply
					local dist = 0
						for i, j in ipairs( player.GetAll() ) do
							local dist2 = j:GetPos():Distance( v:GetPos() )
							if dist2 < dist then
								dist = dist2
								nearest_ply = j
							end
						end
					v:SetEnemy( nearest_ply )
				end
			end
		end

		if(self:GetEnemy()&&IsValid(self:GetEnemy())&&self:GetEnemy()!=nil&&self:GetEnemy()!=NULL&&
		(Tyrant_IsEnemyNPC(self,self:GetEnemy())||Tyrant_IsEnemyPlayer(self,self:GetEnemy()))) then
			if(self:IsOnGround()) then
				if(self.PlayingAnimation==false) then
					if((self:IsCurrentSchedule(SCHED_CHASE_ENEMY)||self:IsCurrentSchedule(SCHED_RUN_RANDOM)||self:IsCurrentSchedule(SCHED_FORCED_GO_RUN))) then
						local TEMP_DistToPrevPos = self:GetPos():Distance(self.PreviousPosition)
						
						if(TEMP_DistToPrevPos<3) then
							self.MustJumpTimes = math.Clamp(self.MustJumpTimes+1,0,100)
						else
							self.MustJumpTimes = math.Clamp(self.MustJumpTimes-1,0,100)
						end
							
							
						if(TEMP_DistToPrevPos<2&&self:IsCurrentSchedule(SCHED_CHASE_ENEMY)) then
							self.CantChaseTargetTimes = self.CantChaseTargetTimes+1
						end
							
						
						if(self:IsCurrentSchedule(SCHED_RUN_RANDOM)||self:IsCurrentSchedule(SCHED_FORCED_GO_RUN)) then
							self.CantChaseTargetTimes = self.CantChaseTargetTimes+2
						end
					end
					
					if(self.CantChaseTargetTimes>50) then
						self.CantChaseTargetTimes = 0
					end

					
					
					if(self:GetEnemy():Visible(self)) then
						local TEMP_MaxMeleeDistance = self.MeleeAttackDistance
						
						if(self:IsMoving()) then
							TEMP_MaxMeleeDistance = self.MeleeAttackDistance+5
						end

						local TEMP_DistanceForMelee = Tyrant_EnemyInMeleeRange(self,self:GetEnemy(),self.MeleeAttackDistanceMin,TEMP_MaxMeleeDistance)

						if(TEMP_DistanceForMelee==2) then
							if(self.PlayingAnimation==false) then
								local TEMP_IND = Tyrant_SelectMeleeAttack(self)
								Tyrant_MeleePlay(self,TEMP_IND)
							end
						elseif(TEMP_DistanceForMelee==1) then
							if(self.PlayingAnimation==false) then
								Tyrant_DistanceForMeleeTooSmall(self)
							end
						else
							if(self.PlayingAnimation==false) then
								Tyrant_DistanceForMeleeTooBig(self)
							end
						end
					end

					if(self.PlayingAnimation==false) then
						if(self:IsUnreachable(self:GetEnemy())||IsValid(self:GetGroundEntity())) then
							local TEMP_MustJump = false
							
							local TEMP_JumpForward = (self:GetForward()*50)
							
							local TEMP_JumpTracer = util.TraceHull( {
								start = self:GetPos(),
								endpos = self:GetPos()+TEMP_JumpForward,
								filter = self,
								mins = self:OBBMins()+Vector(0,0,15),
								maxs = self:OBBMaxs(),
								mask = MASK_NPCSOLID
							} )
							
							if(!TEMP_JumpTracer.Hit) then
								local TEMP_JumpDownTracer = util.TraceHull( {
									start = self:GetPos()+TEMP_JumpForward,
									endpos = self:GetPos()+TEMP_JumpForward+Vector(0,0,-999999),
									filter = self,
									mins = self:OBBMins(),
									maxs = self:OBBMaxs(),
									mask = MASK_NPCSOLID
								} )
								
								local TEMP_JumpDownDist = TEMP_JumpDownTracer.HitPos.z
								local TEMP_JumpDownselfPos = (self:GetPos()+self:OBBMins()).z
								
								if(TEMP_JumpDownDist<TEMP_JumpDownselfPos-20&&
								navmesh.GetNavArea( TEMP_JumpDownTracer.HitPos, 100)) then
									TEMP_MustJump = true
								else
									Tyrant_TestForJump(self)
								end
								
								if(TEMP_MustJump==true&&self.PlayingAnimation==false) then
									Tyrant_Jump(self)
								end
							end
						elseif(!self:IsUnreachable(self:GetEnemy())&&(!self:IsMoving()||self.MustJumpTimes>1)) then
							Tyrant_TestForJump(self)
						end
					end
				end
				
				if(self.PlayingAnimation==true) then
					if(self.Animation!="S_Jump"&&self.Animation!="S_Fly"&&self.Animation!="S_Land") then
						Tyrant_AnimEnemyIsValid(self)
					end
				end
			elseif(!self:IsOnGround()&&self.Animation=="S_Fly") then
				if(self:GetPos()==self.PreviousPosition) then
					local TEMP_TBL = { -1, 1 }
					
					self:SetVelocity(Vector(TEMP_TBL[math.random(1,2)],TEMP_TBL[math.random(1,2)],math.random(100,170)/100)*math.random(78,102))
				end
				
				self.PreviousPosition = self:GetPos()
			end
		end
	end
	
	if(self.PlayingAnimation==true&&self:IsOnGround()) then
		if(self.Animation=="S_Fly") then
			Tyrant_PlayAnimation(self,"S_Land",0)
			
			timer.Create("EndAttack"..tostring(self),self:SequenceDuration(self.Animation),1,function()
				if(IsValid(self)&&self!=nil&&self!=NULL) then
					Tyrant_ClearAnimation(self)
					Tyrant_StopAllTimers(self)
				end
			end)
		//Jump attack land
		elseif(self.Animation=="S_Melee_Jump_2") then
			self.CanJump = false
			TEMP_IND = 10
			
			if(self.Phase==2) then
				TEMP_IND = 11
			elseif(self.Phase==3) then
				TEMP_IND = 15
			end
			
			
			Tyrant_StopAllTimers(self)

			Tyrant_MeleeAttackEvent(self)
			Tyrant_PlayAnimation(self,self.MeleeAttackSequence[TEMP_IND],1)
			Tyrant_MakeMeleeAttack(self,TEMP_IND)
			
			if(self.Phase==3) then
				timer.Create("ComboCheck"..tostring(self),0.6,1,function()
					if(IsValid(self)&&self!=NULL) then
						if(IsValid(self:GetEnemy())&&self:GetEnemy()!=NULL&&
						Tyrant_EnemyInMeleeRange(self,self:GetEnemy(),0,30)&&
						((self:GetEnemy():IsPlayer()&&self:GetEnemy():Alive())||(!self:GetEnemy():IsPlayer()))) then
							Tyrant_StopAllTimers(self)
	
							Tyrant_MeleeAttackEvent(self)
							Tyrant_PlayAnimation(self,self.MeleeAttackSequence[16],1)
							Tyrant_MakeMeleeAttack(self,16)
						end
					end
				end)
			end
		end
	end
	
end



function ENT:OnTakeDamage(dmginfo)
	if(self.IsAlive==false) then return end
	
	self.Angry = true
	
	local TEMP_RealAttacker = dmginfo:GetAttacker()
	local TEMP_RealInflictor = dmginfo:GetInflictor()
	
	local TEMP_DMGMUL = 1
	
	if(self.PlayingAnimation==false&&IsValid(TEMP_RealInflictor)&&TEMP_RealInflictor:GetClass()=="prop_physics"&&IsValid(TEMP_RealInflictor:GetPhysicsObject())) then
		local TEMP_Ang = (TEMP_RealInflictor:GetPos()-self:GetPos()):Angle().Yaw-self:GetAngles().Yaw
		if(math.abs(TEMP_Ang)<90) then
			local TEMP_P = TEMP_RealInflictor:NearestPoint(self:GetPos()+self:OBBCenter())
			
			if(TEMP_P:Distance(self:GetPos()+self:OBBCenter())<50&&TEMP_RealInflictor:GetVelocity():Length()>0) then
				self.ForceNextGesture = "S_Melee_PPush"
			
				TEMP_RealInflictor:GetPhysicsObject():SetVelocity(Vector(0,0,0))
				TEMP_RealInflictor:GetPhysicsObject():ApplyForceCenter(self:GetForward()*80000)
			end
			
			dmginfo:SetDamage(math.max(TEMP_RealInflictor:GetPhysicsObject():GetMass()-100,0))
			return false
		end
	end
		
			
	if(!IsValid(TEMP_RealAttacker)&&IsValid(TEMP_RealInflictor)) then
		TEMP_RealAttacker = TEMP_RealInflictor
	end
	
	if(IsValid(TEMP_RealAttacker)&&!IsValid(TEMP_RealInflictor)) then
		TEMP_RealInflictor = TEMP_RealAttacker
	end
	
	if(IsValid(TEMP_RealAttacker)&&TEMP_RealAttacker:IsVehicle()&&IsValid(TEMP_RealAttacker:GetDriver())) then
		TEMP_RealAttacker = TEMP_RealAttacker:GetDriver()
	end

	
	if(IsValid(TEMP_RealInflictor)&&IsValid(TEMP_RealAttacker)&&TEMP_RealAttacker==TEMP_RealInflictor&&
	(TEMP_RealInflictor:IsPlayer()||TEMP_RealInflictor:IsNPC())) then
		if(IsValid(TEMP_RealInflictor:GetActiveWeapon())) then
			TEMP_RealAttacker = TEMP_RealInflictor
			TEMP_RealInflictor = TEMP_RealInflictor:GetActiveWeapon()
		end
	end
	
	if(!IsValid(TEMP_RealInflictor)&&!IsValid(TEMP_RealAttacker)) then
		TEMP_RealInflictor = self
		TEMP_RealAttacker = self
	end
	
	dmginfo:SetInflictor(TEMP_RealInflictor)
	dmginfo:SetAttacker(TEMP_RealAttacker)
	
	
	
	if(self.LastDamageHitgroup==-1||self.LastDamageHitgroup==0) then
		local TEMP_NearestPoint = self:NearestPoint(dmginfo:GetDamagePosition())
		
		local TEMP_HitTracer = util.TraceHull( {
			start = TEMP_NearestPoint,
			endpos = TEMP_NearestPoint,
			ignoreworld = true,
			mins = Vector(100,100,100),
			maxs = Vector(100,100,100),
			filter = function( ent ) if ( ent==self ) then return true end end
		} )
		
		if(TEMP_HitTracer.Hit) then
			self.LastDamageHitgroup = TEMP_HitTracer.HitGroup
		end
	end

	if(self.LastDamageHitgroup==-1||self.LastDamageHitgroup==0) then
		
		local TEMP_HitTracer = util.TraceLine( {
			start = dmginfo:GetDamagePosition(),
			endpos = dmginfo:GetDamagePosition()+(dmginfo:GetDamageForce()*100),
			ignoreworld = true,
			filter = function( ent ) if ( ent==self ) then return true end end
		} )
	
		
		if(TEMP_HitTracer.Hit) then
			self.LastDamageHitgroup = TEMP_HitTracer.HitGroup
		end
	end
	
	if(self.LastDamageHitgroup==-1||self.LastDamageHitgroup==0) then
		if(IsValid(TEMP_RealInflictor)&&isentity(TEMP_RealInflictor)&&!TEMP_RealInflictor:IsWeapon()) then
			local TEMP_InflictorHullMin, TEMP_InflictorHullMax = TEMP_RealInflictor:GetCollisionBounds()
			
			local TEMP_HitTracer = util.TraceHull( {
				start = TEMP_RealInflictor:GetPos(),
				endpos = TEMP_RealInflictor:GetPos()+(TEMP_RealInflictor:GetForward()*100),
				ignoreworld = true,
				mins = TEMP_InflictorHullMin*1.3,
				maxs = TEMP_InflictorHullMax*1.3,
				filter = function( ent ) if ( ent==self ) then return true end end
			} )
		
			if(TEMP_HitTracer.Hit) then
				self.LastDamageHitgroup = TEMP_HitTracer.HitGroup
			end
		end
	end
	
	
	local TEMP_Def = -1
	local TEMP_MinDMG = 1
	local TEMP_Formula = 0
	
	if(self.Phase==3) then
		TEMP_MinDMG = 0
	end
	
	if(self.LastDamageHitgroup==8) then
		TEMP_Def = self.HeadProtection
		TEMP_MinDMG = 1
		
		if(isnumber(TEMP_RealInflictor.KFHeadshootMultiplier)) then
			TEMP_DMGMUL = TEMP_DMGMUL*TEMP_RealInflictor.KFHeadshootMultiplier
		else
			TEMP_DMGMUL = TEMP_DMGMUL*1.25
		end
	end
	
	if(TEMP_Def==-1) then
		if(dmginfo:IsBulletDamage()) then
			TEMP_Formula = 1
			TEMP_Def = self.BulletDefence
		else
			TEMP_Def = self.Protection
		end
	end
	
	
	local TakeDmg = math.max(dmginfo:GetDamage()*(1-TEMP_Def),TEMP_MinDMG)
	
	if(TEMP_Formula==1) then
		TakeDmg = math.max((dmginfo:GetDamage()*TEMP_DMGMUL)-TEMP_Def,TEMP_MinDMG)
	end
	
	dmginfo:SetDamage(TakeDmg)

	self:SetHealth(self:Health()-dmginfo:GetDamage())
	
	if(dmginfo:GetDamagePosition():WithinAABox(self:GetPos()+self:OBBMins(),self:GetPos()+self:OBBMaxs())&&
	dmginfo:GetDamageType()!=DMG_SONIC&&dmginfo:GetDamageType()!=DMG_POISON) then
		if(dmginfo:GetDamage()>0) then
			Tyrant_Bleed(self,dmginfo:GetDamage()/5,dmginfo:GetDamagePosition(),Angle(math.random(1,360),math.random(1,360),math.random(1,360)))
		else
			local TEMP_Effect = EffectData()
			TEMP_Effect:SetOrigin(self:NearestPoint(dmginfo:GetDamagePosition()))
			TEMP_Effect:SetEntity(self)
			TEMP_Effect:SetNormal(-dmginfo:GetDamageForce()*5)
			TEMP_Effect:SetScale(5)
			util.Effect("MetalSpark", TEMP_Effect,false,true)
		end
	end
	
	if(self:Health()>0) then
		if(dmginfo:GetDamage()>0) then
			Tyrant_PlaySoundRandom(self,33,self.PainSound.name,self.PainSound.min,self.PainSound.max)
		end
	elseif(self:Health()<1&&self.IsAlive==true) then
		Tyrant_Kill(self,dmginfo,TEMP_MeatList,TEMP_BoomDamage)
	end
	
	if(self.PlayingAnimation==false) then
		if(TEMP_RealAttacker!=game.GetWorld()&&IsValid(TEMP_RealAttacker)&&TEMP_RealAttacker!=nil&&TEMP_RealAttacker!=NULL&&
		TEMP_RealAttacker!=self&&(!IsValid(self:GetEnemy())||self:GetEnemy()==nil||self:GetEnemy()==NULL||
		(self:GetEnemy():IsPlayer()&&!self:GetEnemy():Alive())||
		self:GetEnemy():GetPos():Distance(self:GetPos())>TEMP_RealAttacker:GetPos():Distance(self:GetPos()))) then
			if(TEMP_RealAttacker:IsPlayer()||(TEMP_RealAttacker:IsNPC())) then
				self:AddEntityRelationship( TEMP_RealAttacker, D_HT, self.Hate )
				self:SetEnemy(TEMP_RealAttacker)
				self.RegEnemy = TEMP_RealAttacker
				self:UpdateEnemyMemory(TEMP_RealAttacker,TEMP_RealAttacker:GetPos())
			end
		end
	end
	
	
	//Changing phase
	if(self.IsAlive==true&&self.PhaseCycle!=0&&!(self.PhaseCycle==1&&self.Phase==2)&&self:Health()<self:GetMaxHealth()/2&&
	self:IsOnGround()&&self.Phase!=3&&
	self.Animation!="S_Rage"&&self.Animation!="S_Melee_Jump_2"&&self.Animation!="S_Fly"&&
	self:GetModel()=="models/capcom/re - dc/monsters/tyrantphase"..self.Phase..".mdl") then
		Tyrant_ClearAnimation(self)
		Tyrant_StopAllTimers(self)
		
		Tyrant_PlayAnimation(self,"S_Rage",0)
		
		local TEMP_RageSoundTimer = 0.6
		
		if(self.Phase==1&&self:GetModel()=="models/capcom/re - dc/monsters/tyrantphase1.mdl") then
			if(self.PhaseCycle==1||self.PhaseCycle==3) then
				self.Phase = 2	
			elseif(self.PhaseCycle==2) then
				self.Phase = 3	
			end
			
			timer.Create("PreAttack"..tostring(self),1.9,1,function()
				if(IsValid(self)&&self!=NULL) then
					net.Start("TyrantCloth")
					net.WriteVector(self:GetPos())
					net.WriteVector(self:OBBMins())
					net.WriteVector(self:OBBMaxs())
					net.Broadcast()
				end
			end)
		end
		
		if(self.Phase==2&&self:GetModel()=="models/capcom/re - dc/monsters/tyrantphase2.mdl") then
			if(self.PhaseCycle==3) then
				self.Phase = 3
			end
		end
		
			
		timer.Create("Attack"..tostring(self),0.6,1,function()
			if(IsValid(self)&&self!=NULL) then
				Tyrant_StopPreviousSound(self)
				Tyrant_PlaySound(self,100,"Tyrant.Rage"..math.random(1,4))
			end
		end)
		
		local function T_Mut_ManipulateBones(self)
		end
		
		if(self:GetModel()=="models/capcom/re - dc/monsters/tyrantphase1.mdl"&&self.Phase==3) then
			local TEMP_SizeBuff = Vector(0.009,0.009,0.009)
			
			function T_Mut_ManipulateBones(self)
				self:ManipulateBoneScale(self:LookupBone("mune"),self:GetManipulateBoneScale(self:LookupBone("mune"))+(TEMP_SizeBuff*0.8))
				self:ManipulateBoneScale(self:LookupBone("kubi"),self:GetManipulateBoneScale(self:LookupBone("kubi"))+(TEMP_SizeBuff*0.8))

				self:ManipulateBoneScale(self:LookupBone("L_kata"),self:GetManipulateBoneScale(self:LookupBone("L_kata"))+TEMP_SizeBuff)
				self:ManipulateBoneScale(self:LookupBone("L_hiji"),self:GetManipulateBoneScale(self:LookupBone("L_hiji"))+TEMP_SizeBuff)
				self:ManipulateBoneScale(self:LookupBone("L_te"),self:GetManipulateBoneScale(self:LookupBone("L_te"))+(TEMP_SizeBuff*2))
				
				self:ManipulateBoneScale(self:LookupBone("R_kata"),self:GetManipulateBoneScale(self:LookupBone("R_kata"))+TEMP_SizeBuff)
				self:ManipulateBoneScale(self:LookupBone("R_hiji"),self:GetManipulateBoneScale(self:LookupBone("R_hiji"))+TEMP_SizeBuff)
				self:ManipulateBoneScale(self:LookupBone("R_te"),self:GetManipulateBoneScale(self:LookupBone("R_te"))+(TEMP_SizeBuff*2))
				
				self:ManipulateBonePosition(self:LookupBone("hara"),self:GetManipulateBonePosition(self:LookupBone("hara"))+Vector(0,0.1,0))
				self:ManipulateBonePosition(self:LookupBone("mune"),self:GetManipulateBonePosition(self:LookupBone("mune"))+Vector(0,0.1,0))
				
				self:ManipulateBonePosition(self:LookupBone("L_kata"),self:GetManipulateBonePosition(self:LookupBone("L_kata"))+Vector(0,0.4,0))
				self:ManipulateBonePosition(self:LookupBone("L_hiji"),self:GetManipulateBonePosition(self:LookupBone("L_hiji"))+Vector(0,0.4,0))
				
				self:ManipulateBonePosition(self:LookupBone("R_kata"),self:GetManipulateBonePosition(self:LookupBone("R_kata"))+Vector(0,0.4,0))
				self:ManipulateBonePosition(self:LookupBone("R_hiji"),self:GetManipulateBonePosition(self:LookupBone("R_hiji"))+Vector(0,0.4,0))
			end
			
		end
		
		if(self:GetModel()=="models/capcom/re - dc/monsters/tyrantphase2.mdl"&&self.Phase==3) then
			local TEMP_SizeBuff = Vector(0.009,0.009,0.009)
			
			function T_Mut_ManipulateBones(self)
				self:ManipulateBoneScale(self:LookupBone("_02_2"),self:GetManipulateBoneScale(self:LookupBone("_02_2"))+(TEMP_SizeBuff*1))
				self:ManipulateBoneScale(self:LookupBone("_02"),self:GetManipulateBoneScale(self:LookupBone("_02"))+(TEMP_SizeBuff*1))

				self:ManipulateBoneScale(self:LookupBone("_08"),self:GetManipulateBoneScale(self:LookupBone("_08"))+TEMP_SizeBuff)
				self:ManipulateBoneScale(self:LookupBone("_09"),self:GetManipulateBoneScale(self:LookupBone("_09"))+TEMP_SizeBuff)
				
				self:ManipulateBoneScale(self:LookupBone("_13"),self:GetManipulateBoneScale(self:LookupBone("_13"))+TEMP_SizeBuff)
				self:ManipulateBoneScale(self:LookupBone("_14"),self:GetManipulateBoneScale(self:LookupBone("_14"))+TEMP_SizeBuff)
				
				self:ManipulateBoneScale(self:LookupBone("_22"),self:GetManipulateBoneScale(self:LookupBone("_22"))+TEMP_SizeBuff)
				self:ManipulateBoneScale(self:LookupBone("_23"),self:GetManipulateBoneScale(self:LookupBone("_23"))+TEMP_SizeBuff)
				
				self:ManipulateBoneScale(self:LookupBone("_26"),self:GetManipulateBoneScale(self:LookupBone("_26"))+TEMP_SizeBuff)
				self:ManipulateBoneScale(self:LookupBone("_27"),self:GetManipulateBoneScale(self:LookupBone("_27"))+TEMP_SizeBuff)
				
				self:ManipulateBonePosition(self:LookupBone("_01"),self:GetManipulateBonePosition(self:LookupBone("_01"))+Vector(0,0.1,0))
				self:ManipulateBonePosition(self:LookupBone("_02"),self:GetManipulateBonePosition(self:LookupBone("_02"))+Vector(0,0.1,0))
				
				self:ManipulateBonePosition(self:LookupBone("_08"),self:GetManipulateBonePosition(self:LookupBone("_08"))+Vector(0,0.4,0))
				self:ManipulateBonePosition(self:LookupBone("_09"),self:GetManipulateBonePosition(self:LookupBone("_09"))+Vector(0,0.4,0))
				
				self:ManipulateBonePosition(self:LookupBone("_13"),self:GetManipulateBonePosition(self:LookupBone("_13"))+Vector(0,0.4,0))
				self:ManipulateBonePosition(self:LookupBone("_14"),self:GetManipulateBonePosition(self:LookupBone("_14"))+Vector(0,0.4,0))
			end
			
		end
		
		timer.Create("TyrantBoneSize"..tostring(self),0.08,20,function()
			if(IsValid(self)&&self!=NULL) then
				T_Mut_ManipulateBones(self)
				self:SetHealth(self:Health()+50)
			end
		end)
		
		timer.Create("StartAttack"..tostring(self),2,1,function()
			if(IsValid(self)&&self!=NULL) then	
			
				if(self:GetModel()=="models/capcom/re - dc/monsters/tyrantphase1.mdl") then
					local Cloth = ents.Create("prop_ragdoll")
					Cloth:SetModel("models/CAPCOM/RE - DC/Monsters/TyrantCloth_Down.mdl")
					Cloth:SetPos(self:GetPos()+Vector(0,0,50))
					Cloth:SetAngles(self:GetAngles())
					Cloth:Spawn()
					Cloth:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
					
					for P=0, Cloth:GetPhysicsObjectCount()-1 do
						Cloth:GetPhysicsObjectNum(P):ApplyForceCenter(-self:GetForward()*math.random(400,500))
					end
					
					Cloth:Fire("kill","",3)
					
					self:EmitSound("Tyrant.Cloth.Destroy")
				end
					
				
				self.RLeg = "_24"
				self.LLeg = "_28"
				
				self.Model = "models/CAPCOM/RE - DC/Monsters/TyrantPhase"..self.Phase..".mdl"
				self:SetModel("models/CAPCOM/RE - DC/Monsters/TyrantPhase"..self.Phase..".mdl")
				
				
				self:SetCustomCollisionCheck()
	
				self:SetHullSizeNormal()
				self:SetCollisionBounds(Vector(-25,-25,0),Vector(25,25,100))
				
				self:SetSolid(SOLID_BBOX)
				
				if(self.Phase==3) then
					timer.Create("TyrantNewHull"..tostring(self),0.5,0,function()
						if(IsValid(self)&&self!=NULL&&self.Phase==3) then
							local TEMP_ForwardTracer = util.TraceHull( {
								start = self:GetPos(),
								endpos = self:GetPos(),
								filter = {self},
								mins = Vector(-26,-26,0),
								maxs = Vector(26,26,105),
								mask = MASK_NPCSOLID
							} )
							
							if(!TEMP_ForwardTracer.Hit) then
								self:SetCustomCollisionCheck()
			
								self:SetHullSizeNormal()
								self:SetCollisionBounds(Vector(-26,-26,0),Vector(26,26,105))
								
								self:SetSolid(SOLID_BBOX)
								
								timer.Remove("TyrantNewHull"..tostring(self))
							end
						end
					end)
				end
					
					
					
				for B=0, self:GetBoneCount()-1 do
					self:ManipulateBoneScale(B,Vector(1,1,1))
					self:ManipulateBonePosition(B,Vector(0,0,0))
				end
					
				self.CanJump = true
					
					
				for A=1, 20 do
					Tyrant_RemoveMeleeTable(self,A)
				end
				
				Tyrant_PlayAnimation(self,"S_Rage",0)
				
				if(self.Phase==2) then
					self:SetCycle(0.4)
					
					self.BulletDefence = GetConVar("re_npc_tyrant_m1_bullet_defence"):GetInt()
					self.Protection = GetConVar("re_npc_tyrant_m1_protection"):GetFloat()
				
					local TEMP_MeleeHitTable = {}
					for S=1,3 do
						TEMP_MeleeHitTable[S] = "Tyrant.Hit"..S
					end
					
					local TEMP_MeleeMissTable = {}
					for S=1,2 do
						TEMP_MeleeMissTable[S] = "Tyrant.Miss"..S
					end
					
					local TEMP_MeleeTable = Tyrant_CreateMeleeTable()
					TEMP_MeleeTable.damage[1] = 32
					TEMP_MeleeTable.damagetype[1] = self.DMGTYPE2
					TEMP_MeleeTable.distance[1] = 30
					TEMP_MeleeTable.radius[1] = 70
					TEMP_MeleeTable.time[1] = 0.7
					TEMP_MeleeTable.bone[1] = "_15"
					Tyrant_SetMeleeParamsGesture(self,2,"S_Melee_Gesture_LH",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
					
					
					
					
					
					
					
					
					local TEMP_MeleeTable = Tyrant_CreateMeleeTable()
					TEMP_MeleeTable.damage[1] = 49
					TEMP_MeleeTable.damagetype[1] = self.DMGTYPE2
					TEMP_MeleeTable.distance[1] = 32
					TEMP_MeleeTable.radius[1] = 70
					TEMP_MeleeTable.time[1] = 0.4
					TEMP_MeleeTable.bone[1] = "_15"
					Tyrant_SetMeleeParams(self,4,"S_Melee_Run_LH",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
					
					
					
					
					
					
					
					local TEMP_MeleeTable = Tyrant_CreateMeleeTable()
					TEMP_MeleeTable.damage[1] = 42
					TEMP_MeleeTable.damagetype[1] = self.DMGTYPE2
					TEMP_MeleeTable.distance[1] = 30
					TEMP_MeleeTable.radius[1] = 50
					TEMP_MeleeTable.time[1] = 0.7
					TEMP_MeleeTable.bone[1] = "_15"
					Tyrant_SetMeleeParams(self,6,"S_Melee_LH1",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
					
					local TEMP_MeleeTable = Tyrant_CreateMeleeTable()
					TEMP_MeleeTable.damage[1] = 44
					TEMP_MeleeTable.damagetype[1] = self.DMGTYPE2
					TEMP_MeleeTable.distance[1] = 30
					TEMP_MeleeTable.radius[1] = 60
					TEMP_MeleeTable.time[1] = 0.75
					TEMP_MeleeTable.bone[1] = "_15"
					Tyrant_SetMeleeParams(self,7,"S_Melee_LH2",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					local TEMP_MeleeHitTable = {}
					for S=1,6 do
						TEMP_MeleeHitTable[S] = "Tyrant.ClawHit"..S
					end
					
					local TEMP_MeleeTable = Tyrant_CreateMeleeTable()
					TEMP_MeleeTable.damage[1] = 36
					TEMP_MeleeTable.damagetype[1] = self.DMGTYPE2
					TEMP_MeleeTable.distance[1] = 32
					TEMP_MeleeTable.radius[1] = 70
					TEMP_MeleeTable.time[1] = 0.7
					TEMP_MeleeTable.bone[1] = "_10"
					Tyrant_SetMeleeParamsGesture(self,1,"S_Melee_Gesture_RH",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)//RH
										
					local TEMP_MeleeTable = Tyrant_CreateMeleeTable()
					TEMP_MeleeTable.damage[1] = 37
					TEMP_MeleeTable.damagetype[1] = self.DMGTYPE2
					TEMP_MeleeTable.distance[1] = 34
					TEMP_MeleeTable.radius[1] = 60
					TEMP_MeleeTable.time[1] = 1.9
					TEMP_MeleeTable.bone[1] = "_10"
					Tyrant_SetMeleeParamsGesture(self,3,"S_Melee_Gesture_2H",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
					
					
					local TEMP_MeleeTable = Tyrant_CreateMeleeTable()
					TEMP_MeleeTable.damage[1] = 69
					TEMP_MeleeTable.damagetype[1] = self.DMGTYPE2
					TEMP_MeleeTable.distance[1] = 37
					TEMP_MeleeTable.radius[1] = 70
					TEMP_MeleeTable.time[1] = 0.6
					TEMP_MeleeTable.bone[1] = "_10"
					Tyrant_SetMeleeParams(self,5,"S_Melee_Run_RH",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
					
					
					local TEMP_MeleeTable = Tyrant_CreateMeleeTable()
					TEMP_MeleeTable.damage[1] = 72
					TEMP_MeleeTable.damagetype[1] =self.DMGTYPE2
					TEMP_MeleeTable.distance[1] = 35
					TEMP_MeleeTable.radius[1] = 70
					TEMP_MeleeTable.time[1] = 1.0
					TEMP_MeleeTable.bone[1] = "_10"
					Tyrant_SetMeleeParams(self,8,"S_Melee_RH1",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
					
					local TEMP_MeleeTable = Tyrant_CreateMeleeTable()
					TEMP_MeleeTable.damage[1] = 77
					TEMP_MeleeTable.damagetype[1] = self.DMGTYPE2
					TEMP_MeleeTable.distance[1] = 30
					TEMP_MeleeTable.radius[1] = 50
					TEMP_MeleeTable.time[1] = 1.25
					TEMP_MeleeTable.bone[1] = "_10"
					Tyrant_SetMeleeParams(self,9,"S_Melee_RH2",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
					
					local TEMP_MeleeTable = Tyrant_CreateMeleeTable()
					TEMP_MeleeTable.damage[1] = 98
					TEMP_MeleeTable.damagetype[1] = self.DMGTYPE2
					TEMP_MeleeTable.distance[1] = 35
					TEMP_MeleeTable.radius[1] = 30
					TEMP_MeleeTable.time[1] = 0.9
					TEMP_MeleeTable.bone[1] = "_10"
					Tyrant_SetMeleeParams(self,10,"S_Melee_RH3",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
				
					

					TEMP_MeleeTable.damage[1] = 61
					TEMP_MeleeTable.damagetype[1] =self.DMGTYPE2
					TEMP_MeleeTable.distance[1] = 37
					TEMP_MeleeTable.radius[1] = 20
					TEMP_MeleeTable.time[1] = 0.3
					TEMP_MeleeTable.bone[1] = "_10"
					TEMP_MeleeTable.damage[2] = 36
					TEMP_MeleeTable.damagetype[2] =self.DMGTYPE2
					TEMP_MeleeTable.distance[2] = 37
					TEMP_MeleeTable.radius[2] = 40
					TEMP_MeleeTable.time[2] = 1.5
					TEMP_MeleeTable.bone[2] = "_10"
					Tyrant_SetMeleeParams(self,11,"S_Melee_Jump_3",2, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
				else
					self:SetCycle(0.7)
					
					self.BulletDefence = GetConVar("re_npc_tyrant_m2_bullet_defence"):GetInt()
					self.Protection = GetConVar("re_npc_tyrant_m2_protection"):GetFloat()
				
					local TEMP_MeleeHitTable = {}
					for S=1,6 do
						TEMP_MeleeHitTable[S] = "Tyrant.ClawHit"..S
					end
					
					local TEMP_MeleeMissTable = {}
					for S=1,2 do
						TEMP_MeleeMissTable[S] = "Tyrant.Miss"..S
					end
					
					local TEMP_MeleeTable = Tyrant_CreateMeleeTable()
					TEMP_MeleeTable.damage[1] = 63
					TEMP_MeleeTable.damagetype[1] = self.DMGTYPE2
					TEMP_MeleeTable.distance[1] = 46
					TEMP_MeleeTable.radius[1] = 60
					TEMP_MeleeTable.time[1] = 0.6
					TEMP_MeleeTable.bone[1] = "_10"
					Tyrant_SetMeleeParamsGesture(self,1,"S_Melee_Gesture_RH",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)//RH
										
					local TEMP_MeleeTable = Tyrant_CreateMeleeTable()
					TEMP_MeleeTable.damage[1] = 63
					TEMP_MeleeTable.damagetype[1] = self.DMGTYPE2
					TEMP_MeleeTable.distance[1] = 48
					TEMP_MeleeTable.radius[1] = 40
					TEMP_MeleeTable.time[1] = 0.6
					TEMP_MeleeTable.bone[1] = "_15"
					Tyrant_SetMeleeParamsGesture(self,2,"S_Melee_Gesture_LH",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
					
					local TEMP_MeleeTable = Tyrant_CreateMeleeTable()
					TEMP_MeleeTable.damage[1] = 53
					TEMP_MeleeTable.damagetype[1] = self.DMGTYPE2
					TEMP_MeleeTable.distance[1] = 50
					TEMP_MeleeTable.radius[1] = 50
					TEMP_MeleeTable.time[1] = 0.6
					TEMP_MeleeTable.bone[1] = "_10"
					Tyrant_SetMeleeParamsGesture(self,3,"S_Melee_Gesture_RH2",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)//RH
										
					local TEMP_MeleeTable = Tyrant_CreateMeleeTable()
					TEMP_MeleeTable.damage[1] = 72
					TEMP_MeleeTable.damagetype[1] = self.DMGTYPE2
					TEMP_MeleeTable.distance[1] = 48
					TEMP_MeleeTable.radius[1] = 70
					TEMP_MeleeTable.time[1] = 0.6
					TEMP_MeleeTable.bone[1] = "_15"
					Tyrant_SetMeleeParamsGesture(self,4,"S_Melee_Gesture_LH2",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
					
					
					
					
					local TEMP_MeleeTable = Tyrant_CreateMeleeTable()
					TEMP_MeleeTable.damage[1] = 54
					TEMP_MeleeTable.damagetype[1] = self.DMGTYPE2
					TEMP_MeleeTable.distance[1] = 44
					TEMP_MeleeTable.radius[1] = 60
					TEMP_MeleeTable.time[1] = 1.2
					TEMP_MeleeTable.bone[1] = "_10"
					Tyrant_SetMeleeParamsGesture(self,5,"S_Melee_Block_RH",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
					
					local TEMP_MeleeTable = Tyrant_CreateMeleeTable()
					TEMP_MeleeTable.damage[1] = 54
					TEMP_MeleeTable.damagetype[1] = self.DMGTYPE2
					TEMP_MeleeTable.distance[1] = 44
					TEMP_MeleeTable.radius[1] = 60
					TEMP_MeleeTable.time[1] = 1.2
					TEMP_MeleeTable.bone[1] = "_15"
					Tyrant_SetMeleeParamsGesture(self,6,"S_Melee_Block_LH",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)

					
					
					
					
					
					local TEMP_MeleeTable = Tyrant_CreateMeleeTable()
					TEMP_MeleeTable.damage[1] = 82
					TEMP_MeleeTable.damagetype[1] = self.DMGTYPE2
					TEMP_MeleeTable.distance[1] = 50
					TEMP_MeleeTable.radius[1] = 90
					TEMP_MeleeTable.time[1] = 0.5
					TEMP_MeleeTable.bone[1] = "_10"
					Tyrant_SetMeleeParams(self,7,"S_Melee_Run_RH",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
					
					local TEMP_MeleeTable = Tyrant_CreateMeleeTable()
					TEMP_MeleeTable.damage[1] = 48
					TEMP_MeleeTable.damagetype[1] = self.DMGTYPE2
					TEMP_MeleeTable.distance[1] = 50
					TEMP_MeleeTable.radius[1] = 60
					TEMP_MeleeTable.time[1] = 0.5
					TEMP_MeleeTable.bone[1] = "_15"
					Tyrant_SetMeleeParams(self,8,"S_Melee_Run_LH",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
					
					local TEMP_MeleeTable = Tyrant_CreateMeleeTable()
					TEMP_MeleeTable.damage[1] = 78
					TEMP_MeleeTable.damagetype[1] = self.DMGTYPE2
					TEMP_MeleeTable.distance[1] = 52
					TEMP_MeleeTable.radius[1] = 80
					TEMP_MeleeTable.time[1] = 1.0
					TEMP_MeleeTable.bone[1] = "_10"
					Tyrant_SetMeleeParams(self,9,"S_Melee_Jump_RH",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
					
					
					
					
					
					local TEMP_MeleeTable = Tyrant_CreateMeleeTable()
					TEMP_MeleeTable.damage[1] = 67
					TEMP_MeleeTable.damagetype[1] = self.DMGTYPE2
					TEMP_MeleeTable.distance[1] = 51
					TEMP_MeleeTable.radius[1] = 70
					TEMP_MeleeTable.time[1] = 0.7
					TEMP_MeleeTable.bone[1] = "_15"
					TEMP_MeleeTable.damage[2] = 67
					TEMP_MeleeTable.damagetype[2] = self.DMGTYPE2
					TEMP_MeleeTable.distance[2] = 51
					TEMP_MeleeTable.radius[2] = 70
					TEMP_MeleeTable.time[2] = 0.7
					TEMP_MeleeTable.bone[2] = "_10"
					Tyrant_SetMeleeParams(self,10,"S_Melee_2H",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
					
					local TEMP_MeleeTable = Tyrant_CreateMeleeTable()
					TEMP_MeleeTable.damage[1] = 79
					TEMP_MeleeTable.damagetype[1] = self.DMGTYPE2
					TEMP_MeleeTable.distance[1] = 49
					TEMP_MeleeTable.radius[1] = 50
					TEMP_MeleeTable.time[1] = 0.6
					TEMP_MeleeTable.bone[1] = "_10"
					Tyrant_SetMeleeParams(self,11,"S_Melee_RH",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
					
					local TEMP_MeleeTable = Tyrant_CreateMeleeTable()
					TEMP_MeleeTable.damage[1] = 79
					TEMP_MeleeTable.damagetype[1] = self.DMGTYPE2
					TEMP_MeleeTable.distance[1] = 47
					TEMP_MeleeTable.radius[1] = 60
					TEMP_MeleeTable.time[1] = 0.8
					TEMP_MeleeTable.bone[1] = "_15"
					Tyrant_SetMeleeParams(self,12,"S_Melee_LH",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
					
					local TEMP_MeleeTable = Tyrant_CreateMeleeTable()
					TEMP_MeleeTable.damage[1] = 74
					TEMP_MeleeTable.damagetype[1] = self.DMGTYPE2
					TEMP_MeleeTable.distance[1] = 49
					TEMP_MeleeTable.radius[1] = 50
					TEMP_MeleeTable.time[1] = 0.4
					TEMP_MeleeTable.bone[1] = "_15"
					Tyrant_SetMeleeParams(self,13,"S_Melee_LH_1",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
					
					local TEMP_MeleeTable = Tyrant_CreateMeleeTable()
					TEMP_MeleeTable.damage[1] = 69
					TEMP_MeleeTable.damagetype[1] = self.DMGTYPE2
					TEMP_MeleeTable.distance[1] = 51
					TEMP_MeleeTable.radius[1] = 90
					TEMP_MeleeTable.time[1] = 0.45
					TEMP_MeleeTable.bone[1] = "_15"
					Tyrant_SetMeleeParams(self,14,"S_Melee_LH_2",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
					
					
					
					
					
					local TEMP_MeleeHitTable = {}
					TEMP_MeleeHitTable[1] = ""
					
					local TEMP_MeleeMissTable = {}
					TEMP_MeleeMissTable[1] = ""

					TEMP_MeleeTable.damage[1] = 61
					TEMP_MeleeTable.damagetype[1] =self.DMGTYPE2
					TEMP_MeleeTable.distance[1] = 47
					TEMP_MeleeTable.radius[1] = 20
					TEMP_MeleeTable.time[1] = 0.3
					TEMP_MeleeTable.bone[1] = "_10"
					Tyrant_SetMeleeParams(self,15,"S_Melee_Jump_3",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
					
					
					local TEMP_MeleeHitTable = {}
					for S=1,3 do
						TEMP_MeleeHitTable[S] = "Tyrant.ClawHit"..S
					end
					
					local TEMP_MeleeMissTable = {}
					for S=1,2 do
						TEMP_MeleeMissTable[S] = "Tyrant.Miss"..S
					end
					
					
					TEMP_MeleeTable.damage[1] = 61
					TEMP_MeleeTable.damagetype[1] =self.DMGTYPE2
					TEMP_MeleeTable.distance[1] = 49
					TEMP_MeleeTable.radius[1] = 20
					TEMP_MeleeTable.time[1] = 1.4
					TEMP_MeleeTable.bone[1] = "_10"
					Tyrant_SetMeleeParams(self,16,"S_Melee_Jump_3_1",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
					
				end
				
				
				timer.Create("StartAttack"..tostring(self),3,1,function()
					if(IsValid(self)&&self!=NULL) then
						Tyrant_ClearAnimation(self)
						Tyrant_StopAllTimers(self)
					end
				end)
			end
		end)
	end
	
	//Blocking
	if(self.LastDamageHitgroup==8) then
		if(!self.PlayingAnimation) then
			local TEMP_BlockChance = math.random(1,6)
			
			if(TEMP_BlockChance==1) then
				if(self.Phase!=3) then
					self.ForceNextMelee = 3
				else
					self.ForceNextMelee = math.random(5,6)
				end
			end
		end
	end
	
	self.LastDamageHitgroup = -1
end

function ENT:GetAttackSpread( Weapon, Target )
	return 0.1
end






function ENT:RunAI( strExp )
	if(self.PlayingAnimation==false||(self.PlayingAnimation==true&&self.PlayingGesture==true)) then
		if((self.PlayingAnimation==false||self.PlayingGesture==true)&&!self.CurrentSchedule) then
			self:SelectSchedule()
		end
		
		if ( self:IsRunningBehavior() ) then
			return true
		end
		
		if ( self:DoingEngineSchedule() ) then
			return true
		end
		
		if ( self.CurrentSchedule ) then
			self:DoSchedule( self.CurrentSchedule )
		end
	end
	
	self:MaintainActivity()
end

function ENT:SelectSchedule()
	if(IsValid(self:GetEnemy())) then
		if(self.LastPosition:Distance(self:GetPos())<2&&(self:IsCurrentSchedule(SCHED_CHASE_ENEMY)||self:IsCurrentSchedule(SCHED_CHASE_ENEMY_FAILED))) then
			if(self.FollowPosTime<CurTime()) then
				self.LastPositionFails = self.LastPositionFails+1
				
				if(self.LastPositionFails==20) then
					self.LastPositionFails = 0
					self.FollowPosTime = CurTime()+3
				end
			end
		else
			self.LastPositionFails = math.Clamp(self.LastPositionFails-1,0,20)
		end
	else
		self.LastPositionFails = 0
	end
	
	if(self.FollowPosTime<CurTime()+1&&self.FollowPosTime>CurTime()) then
		self.LastPositionFails = 0
		self.FollowPosTime = 0
	end

	
	if(self.PlayingAnimation==false||self.PlayingGesture==true) then
		if(IsValid(self:GetEnemy())&&self:GetEnemy()!=NULL&&self:GetEnemy()!=nil&&
		(self:GetEnemy():IsNPC()||(self:GetEnemy():IsPlayer()&&self:GetEnemy():Alive()))) then

			if(!self:IsCurrentSchedule(SCHED_CHASE_ENEMY)) then
				self.CantChaseTargetTimes = math.Clamp(self.CantChaseTargetTimes+2,0,10)
			else
				self.CantChaseTargetTimes = math.Clamp(self.CantChaseTargetTimes-1,0,10)
			end
			if(self.FollowPosTime>CurTime()) then
				local TEMP_D = (self:GetEnemy():GetPos()-self:GetPos())
				
				self:SetLastPosition(self:GetPos()+(TEMP_D:GetNormalized()*math.min(TEMP_D:Length(),99)))
				self:SetSchedule(SCHED_FORCED_GO_RUN)
			elseif(!self:IsCurrentSchedule(SCHED_CHASE_ENEMY)) then
				local TEMP_DistanceForMelee = Tyrant_EnemyInMeleeRange(self,self:GetEnemy(),0,self.MeleeAttackDistance-5)
				
				if(TEMP_DistanceForMelee==0) then
					self:SetSchedule(SCHED_CHASE_ENEMY)
				end
			end
		else
			if(!self:IsCurrentSchedule(SCHED_PATROL_WALK)) then
				self:SetSchedule(SCHED_PATROL_WALK)
				self.LastPositionFails = 0
			end
		end
		
	end
	self.LastPosition = self:GetPos()
end

function ENT:StartSchedule( schedule )
	self.CurrentSchedule 	= schedule
	self.CurrentTaskID 		= 1
	self:SetTask( schedule:GetTask( 1 ) )
end

function ENT:DoSchedule( schedule )

	if ( self.CurrentTask ) then
		self:RunTask( self.CurrentTask )
	end

	if ( self:TaskFinished() ) then
		self:NextTask( schedule )
	end

end

function ENT:ScheduleFinished()
	self.CurrentSchedule 	= nil
	self.CurrentTask 		= nil
	self.CurrentTaskID 		= nil
end

function ENT:SetTask( task )
	self.CurrentTask 	= task
	self.bTaskComplete 	= false
	self.TaskStartTime 	= CurTime()

	self:StartTask( self.CurrentTask )
end

function ENT:NextTask( schedule )
	self.CurrentTaskID = self.CurrentTaskID + 1

	if ( self.CurrentTaskID > schedule:NumTasks() ) then
		self:ScheduleFinished( schedule )
		return
	end

	self:SetTask( schedule:GetTask( self.CurrentTaskID ) )
end

function ENT:StartTask( task )
	task:Start( self.Entity )
end

function ENT:RunTask( task )
	task:Run( self.Entity )
end

function ENT:TaskTime()
	return CurTime() - self.TaskStartTime
end

function ENT:OnTaskComplete()
	self.bTaskComplete = true
end

function ENT:TaskFinished()
	return self.bTaskComplete
end

function ENT:StartEngineTask( iTaskID, TaskData )
end

function ENT:RunEngineTask( iTaskID, TaskData )
end

function ENT:StartEngineSchedule( scheduleID ) self:ScheduleFinished() self.bDoingEngineSchedule = true end
function ENT:EngineScheduleFinish() self.bDoingEngineSchedule = nil end
function ENT:DoingEngineSchedule()	return self.bDoingEngineSchedule end

function ENT:OnCondition( iCondition )
end





















































function ENT:Initialize()
	self.Model = "models/CAPCOM/RE - DC/Monsters/TyrantPhase1.mdl"
	Tyrant_Init(self,Vector(-25,-25,100),MOVETYPE_STEP)
	
	self:SetBloodColor(BLOOD_COLOR_RED)
	
	self:DropToFloor()
	
	self.CanJump = true
	
	self.Phase = 1
	
	self.LLegStepped = false
	self.RLegStepped = false
	
	self.LLegStepTime = CurTime()
	self.LLegStepTime = CurTime()
	
	self.RLeg = "R_ashi2"
	self.LLeg = "L_ashi2"
	
	
	
	
	
	
	
	
	
	
	self.MeleeAttackSequence = {}
	self.MeleeAttackGesture = {}
	self.MeleeMissSound = {}
	self.MeleeHitSound = {}
	self.MeleeDamageRadius = {}
	self.MeleeDamageCount = {}
	self.MeleeDamageTime = {}
	self.MeleeDamageDamage = {}
	self.MeleeDamageType = {}
	self.MeleeDamageDistance = {}
	self.MeleeDamageBone = {}

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	local TEMP_MeleeHitTable = {}
	for S=1,3 do
		TEMP_MeleeHitTable[S] = "Tyrant.Hit"..S
	end
	
	local TEMP_MeleeMissTable = {}
	for S=1,2 do
		TEMP_MeleeMissTable[S] = "Tyrant.Miss"..S
	end
						
	local TEMP_MeleeTable = Tyrant_CreateMeleeTable()
	TEMP_MeleeTable.damage[1] = 27
	TEMP_MeleeTable.damagetype[1] = self.DMGTYPE1
	TEMP_MeleeTable.distance[1] = 30
	TEMP_MeleeTable.radius[1] = 60
	TEMP_MeleeTable.time[1] = 0.7
	TEMP_MeleeTable.bone[1] = "L_te"
	Tyrant_SetMeleeParamsGesture(self,1,"S_Melee_Gesture_LH",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
	
	TEMP_MeleeTable.damage[1] = 27
	TEMP_MeleeTable.damagetype[1] =self.DMGTYPE1
	TEMP_MeleeTable.distance[1] = 30
	TEMP_MeleeTable.radius[1] = 60
	TEMP_MeleeTable.time[1] = 0.7
	TEMP_MeleeTable.bone[1] = "R_te"
	Tyrant_SetMeleeParamsGesture(self,2,"S_Melee_Gesture_RH",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
	
	TEMP_MeleeTable.damage[1] = 17
	TEMP_MeleeTable.damagetype[1] =self.DMGTYPE1
	TEMP_MeleeTable.distance[1] = 27
	TEMP_MeleeTable.radius[1] = 50
	TEMP_MeleeTable.time[1] = 1.65
	TEMP_MeleeTable.bone[1] = "R_te"
	TEMP_MeleeTable.damage[2] = 17
	TEMP_MeleeTable.damagetype[2] =self.DMGTYPE1
	TEMP_MeleeTable.distance[2] = 27
	TEMP_MeleeTable.radius[2] = 50
	TEMP_MeleeTable.time[2] = 1.65
	TEMP_MeleeTable.bone[2] = "R_te"
	Tyrant_SetMeleeParamsGesture(self,3,"S_Melee_Gesture_2H",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
	
	TEMP_MeleeTable.damage[1] = 40
	TEMP_MeleeTable.damagetype[1] =self.DMGTYPE1
	TEMP_MeleeTable.distance[1] = 33
	TEMP_MeleeTable.radius[1] = 30
	TEMP_MeleeTable.time[1] = 0.7
	TEMP_MeleeTable.bone[1] = "R_kata"
	Tyrant_SetMeleeParams(self,4,"S_Melee_Run",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
	
	
	
	TEMP_MeleeTable.damage[1] = 45
	TEMP_MeleeTable.damagetype[1] =self.DMGTYPE1
	TEMP_MeleeTable.distance[1] = 30
	TEMP_MeleeTable.radius[1] = 40
	TEMP_MeleeTable.time[1] = 1.0
	TEMP_MeleeTable.bone[1] = "L_te"
	Tyrant_SetMeleeParams(self,5,"S_Melee_LH",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)

	
	TEMP_MeleeTable.damage[1] = 45
	TEMP_MeleeTable.damagetype[1] =self.DMGTYPE1
	TEMP_MeleeTable.distance[1] = 30
	TEMP_MeleeTable.radius[1] = 40
	TEMP_MeleeTable.time[1] = 1.15
	TEMP_MeleeTable.bone[1] = "R_te"
	Tyrant_SetMeleeParams(self,6,"S_Melee_RH",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
	
	
	TEMP_MeleeTable.damage[1] = 44
	TEMP_MeleeTable.damagetype[1] =self.DMGTYPE1
	TEMP_MeleeTable.distance[1] = 25
	TEMP_MeleeTable.radius[1] = 40
	TEMP_MeleeTable.time[1] = 1.6
	TEMP_MeleeTable.bone[1] = "R_te"
	TEMP_MeleeTable.damage[2] = 44
	TEMP_MeleeTable.damagetype[2] =self.DMGTYPE1
	TEMP_MeleeTable.distance[2] = 25
	TEMP_MeleeTable.radius[2] = 40
	TEMP_MeleeTable.time[2] = 1.6
	TEMP_MeleeTable.bone[2] = "L_te"
	Tyrant_SetMeleeParams(self,7,"S_Melee_2H",2, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
				
	
	
	
	
	TEMP_MeleeTable.damage[1] = 60
	TEMP_MeleeTable.damagetype[1] =self.DMGTYPE1
	TEMP_MeleeTable.distance[1] = 35
	TEMP_MeleeTable.radius[1] = 30
	TEMP_MeleeTable.time[1] = 0.9
	TEMP_MeleeTable.bone[1] = "R_ashi"
	Tyrant_SetMeleeParams(self,8,"S_Melee_Walk_RL",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)

	

	TEMP_MeleeTable.damage[1] = 47
	TEMP_MeleeTable.damagetype[1] =self.DMGTYPE1
	TEMP_MeleeTable.distance[1] = 30
	TEMP_MeleeTable.radius[1] = 40
	TEMP_MeleeTable.time[1] = 1.1
	TEMP_MeleeTable.bone[1] = "L_te"
	Tyrant_SetMeleeParams(self,9,"S_Melee_Back",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
	
	
	TEMP_MeleeTable.damage[1] = 54
	TEMP_MeleeTable.damagetype[1] =self.DMGTYPE1
	TEMP_MeleeTable.distance[1] = 35
	TEMP_MeleeTable.radius[1] = 80
	TEMP_MeleeTable.time[1] = 0.3
	TEMP_MeleeTable.bone[1] = "R_te"
	Tyrant_SetMeleeParams(self,10,"S_Melee_Jump_3",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)

	
	local TEMP_Health = 5000 * GAMEMODE.ZombieData[GetGlobalString("Re2_Difficulty")].Modifier
	
	self:SetHealth(TEMP_Health)
	
	self:SetMaxHealth(self:Health())
	self.ForceNextGesture = ""
	self.ForceNextMelee = -1
	
	self.Angry = false

	self.PhaseCycle = GetConVar("re_npc_tyrant_mutation"):GetInt()
	self.BulletDefence = GetConVar("re_npc_tyrant_bullet_defence"):GetInt()
	self.Protection = GetConVar("re_npc_tyrant_protection"):GetFloat()
	self.HeadProtection = GetConVar("re_npc_tyrant_protection_head"):GetFloat()
	self.DamageMultiplier = GetConVar("re_npc_tyrant_damage_multiplier"):GetFloat()
	
	self.FollowPosTime = 0
	self.LastPositionFails = 0
	self.LastPosition = self:GetPos()
end
