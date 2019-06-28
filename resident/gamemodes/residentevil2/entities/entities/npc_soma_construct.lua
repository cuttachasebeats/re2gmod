--[[ Apache License --
	Copyright 2016 Wheatley
	 
	Licensed under the Apache License, Version 2.0 (the 'License'); you may not use this file except
	in compliance with the License. You may obtain a copy of the License at
	 
	http://www.apache.org/licenses/LICENSE-2.0
	 
	Unless required by applicable law or agreed to in writing, software distributed under the License
	is distributed on an 'AS IS' BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
	or implied. See the License for the specific language governing permissions and limitations under
	the License.
	 
	The right to upload this project to the Steam Workshop (which is operated by Valve Corporation)
	is reserved by the original copyright holder, regardless of any modifications made to the code,
	resources or related content. The original copyright holder is not affiliated with Valve Corporation
	in any way, nor claims to be so.
]]

AddCSLuaFile()

DEFINE_BASECLASS( "base_nextbot" )

ENT.Base 			= 'base_nextbot'
ENT.Spawnable		= false
ENT.RenderGroup 		= RENDERGROUP_BOTH

ENT.SNDLIST = {}
ENT.SNDLIST.IDLE = {}

ENT.SNDLIST.SEEPLAYER = { 'soma/npc_soma_construct/npc_construct_idle_rambling_49.wav', 'soma/npc_soma_construct/npc_construct_idle_rambling_48.wav', 'soma/npc_soma_construct/npc_construct_idle_rambling_46.wav', 'soma/npc_soma_construct/npc_construct_idle_rambling_50.wav', 'soma/npc_soma_construct/npc_construct_idle_rambling_57.wav' }

ENT.SNDLIST.PLAYERLOST = { 'soma/npc_soma_construct/npc_construct_idle_rambling_51.wav', 'soma/npc_soma_construct/npc_construct_idle_rambling_41.wav', 'soma/npc_soma_construct/npc_construct_idle_rambling_34.wav' }

ENT.SNDLIST.PAIN = { 'soma/npc_soma_construct/npc_construct_idle_rambling_12.wav', 'soma/npc_soma_construct/npc_construct_idle_rambling_17.wav', 'soma/npc_soma_construct/npc_construct_idle_rambling_23.wav', 'soma/npc_soma_construct/npc_construct_idle_rambling_25.wav' }

-- SOUNDS
	-- soma_construct_idle
	for i, v in pairs( file.Find( 'sound/soma/npc_soma_construct/npc_construct_idle_rambling_*.wav', 'GAME' ) ) do
		sound.Add( {
			name = 'soma_construct_idle' .. i,
			channel = CHAN_STATIC,
			volume = 1.0,
			level = 70,
			pitch = { 100 },
			sound = 'soma/npc_soma_construct/' .. v
		} )
		
		table.insert( ENT.SNDLIST.IDLE, 'soma_construct_idle' .. i )
	end
	
	-- soma_construct_seeplayer
	for i, v in pairs( ENT.SNDLIST.SEEPLAYER ) do
		sound.Add( {
			name = 'soma_construct_seeplayer' .. i,
			channel = CHAN_STATIC,
			volume = 1.0,
			level = 75,
			pitch = { 100 },
			sound = v
		} )
		
		ENT.SNDLIST.SEEPLAYER[i] = 'soma_construct_seeplayer' .. i
	end

	-- soma_construct_pain
	for i, v in pairs( ENT.SNDLIST.PAIN ) do
		sound.Add( {
			name = 'soma_construct_pain' .. i,
			channel = CHAN_STATIC,
			volume = 1.0,
			level = 65,
			pitch = { 100 },
			sound = v
		} )
		
		ENT.SNDLIST.PAIN[i] = 'soma_construct_pain' .. i
	end
	
	-- soma_construct_playerlost
	for i, v in pairs( ENT.SNDLIST.PLAYERLOST ) do
		sound.Add( {
			name = 'soma_construct_playerlost' .. i,
			channel = CHAN_STATIC,
			volume = 1.0,
			level = 75,
			pitch = { 100 },
			sound = v
		} )
		
		ENT.SNDLIST.PLAYERLOST[i] = 'soma_construct_playerlost' .. i
	end

	
AccessorFunc( ENT, 'iNPCState', 'NPCState', FORCE_NUMBER )
AccessorFunc( ENT, 'entEnemy', 'Enemy' )
AccessorFunc( ENT, 'iWaitTimer', 'WaitTimer', FORCE_NUMBER )

sk_soma_construct_health = CreateConVar( 'sk_soma_construct_health', '160', FCVAR_ARCHIVE )
sk_soma_construct_light = CreateConVar( 'sk_soma_construct_light', '1', FCVAR_ARCHIVE )
sk_soma_construct_ignoresound = CreateConVar( 'sk_soma_construct_ignoresound', '0', FCVAR_ARCHIVE )

local NPCSTATE_CODEFAILURE	= -1
local NPCSTATE_SEARCHING 	= 0
local NPCSTATE_CHASING		= 1
local NPCSTATE_ALERT		= 2
local NPCSTATE_INVESTIGATE	= 3

local NPCBIT_DAMAGED		= 1
local NPCBIT_HEARDSOUND		= 2
local NPCBIT_INVESTIGATE	= 3

local footsteprate_walk		= 0.71
local footsteprate_run		= 0.40
local nextclawsound			= 1	

-- INITIALIZE FUNC.
function ENT:Initialize()
	self.m_iNPCBits = {}
	self:SetModel( 'models/npcs/soma/construct.mdl' )

	if SERVER then
	--	self:SetCollisionBounds( Vector( -12, -12, 0 ), Vector( 12, 12, 72 ) )
		self:SetCollisionBounds( Vector(-4,-4,0), Vector(4,4,64) )
		self:SetSolidMask( MASK_PLAYERSOLID )
		//debugoverlay.Box( self:GetPos(), Vector( -12, -12, 0 ), Vector( 12, 12, 72 ), 2, color_white )
	
		self:SetHealth( sk_soma_construct_health:GetInt() )
		self:SetBloodColor( BLOOD_COLOR_MECH )
	
		self:SetNPCState( NPCSTATE_SEARCHING )
		self:ResetSequenceInfo()
		self:SetCycle( 0 )
		self:SetPlaybackRate( 1 )

		self.iWaitTimer = 0
		self.iLastSound = CurTime()
		
		self.iLastStep = CurTime()
		self.iLastSound2 = CurTime()
		self.bIsRunning = false
		
		self.iSearchAttempts = 0
		
		self.iNextRandomDistortion = CurTime()

		self.loco:SetJumpHeight( 0 )
		self.loco:SetStepHeight( 16 )

		self.bullseye = ents.Create( 'npc_bullseye' )
		self.bullseye:SetPos( self:GetPos() + Vector( 0, 0, 45 ) + self:GetAngles():Forward() * 8 )
		self.bullseye:SetHealth( 9999999 )
		self.bullseye.soma = true
		self.bullseye:Spawn()
		self.bullseye:SetNotSolid( true )
		self:DeleteOnRemove( self.bullseye )
		
		self.sCoreSound = CreateSound( self, 'soma/npc_soma_construct/construct_engine_motor_core.wav' )
		if self.sCoreSound then
			self.sCoreSound:SetSoundLevel( 60 )
			self.sCoreSound:Play()
		end
		
		if sk_soma_construct_light:GetBool() then
			self.flashlight = ents.Create( 'env_projectedtexture' )
		
			self.flashlight:SetKeyValue( 'enableshadows', 1 )
			self.flashlight:SetKeyValue( 'farz', 1024 )
			self.flashlight:SetKeyValue( 'nearz', 12 )
			self.flashlight:SetKeyValue( 'lightfov', 65 )

			self.flashlight:SetKeyValue( 'lightcolor', '120 200 255 255' )
			self.flashlight:Spawn()
			self.flashlight:Input( 'SpotlightTexture', NULL, NULL, 'effects/flashlight/soft' )
			self:DeleteOnRemove( self.flashlight )
		end
		
		local areas = table.Count( navmesh.GetAllNavAreas() )
		if areas == 0 then
			BroadcastLua( 'chat.AddText( Color( 255, 0, 0 ), "NAV MESH FAILURE! NO NAV MESHES FOUND ON A MAP!" )' )
			self:SetNPCState( NPCSTATE_CODEFAILURE )
		end
	end
	
	if ( CLIENT ) then
		self.PixVis = util.GetPixelVisibleHandle()
	end
end

function ENT:SetNPCBit( bit, value )
	self.m_iNPCBits[ bit ] = value
end

function ENT:GetNPCBit( bit )
	return self.m_iNPCBits[ bit ]
end

function ENT:Think()
	if SERVER then
		local bone = self:LookupBone( 'Neck_01_jnt' )
		if bone and IsValid( self.flashlight ) then
			local pos, ang = self:GetBonePosition( bone )
			ang.p = ang.p + 45
			self.flashlight:SetPos( pos )
			self.flashlight:SetAngles( ang ) 	
		end
		
		if self.iNextRandomDistortion < CurTime() then
			if self:GetNPCState() == NPCSTATE_SEARCHING then
				self.iNextRandomDistortion = CurTime() + math.random( 0.5, 1.5 )
				self:SendDistortions( math.random( 0, 1 ) + 0.1 )
			elseif self:GetNPCState() == NPCSTATE_CHASING then
				self.iNextRandomDistortion = CurTime() + math.random( 0.3, 0.65 )
				self:SendDistortions( 2.1 )
			end
		end
	end
end

function ENT:OnRemove()
	if self.sCoreSound != nil and SERVER then
		self.sCoreSound:Stop()
		self.sCoreSound = nil
	end
end

function ENT:OnKilled( data )
	if self.sCoreSound != nil and SERVER then
		self.sCoreSound:Stop()
		self.sCoreSound = nil
	end

	self:StopAllSounds()
	
	if IsValid( self.flashlight ) then
		self.flashlight:Remove()
	end
	
	BaseClass.OnKilled( self, data )
end

local function FindSuitablePosition( pos, range )
	range = range or Vector( 1000, 1000, 350 )
	local valid = false
	local npos = Vector()
	
	while( !valid ) do -- very unsafe, but I kinda trust this guy...
		npos = pos + Vector( math.random( -range.x, range.x ), math.random( -range.y, range.y ), math.random( -range.z, range.z ) )
		if !util.IsInWorld( npos ) then continue end
		valid = true
	end
	return npos
end

-- AI CORE
function ENT:RunBehaviour()
	while ( true ) do
		if self:GetWaitTimer() > CurTime() and !IsValid( self:GetEnemy() ) or GetConVarNumber( 'ai_disabled' ) == 1 then
			self:FindEnemy()
			coroutine.yield()
			continue
		end

		if self:GetNPCState() == NPCSTATE_SEARCHING then -- roam around : long walk distances : no advanced logic
			local pos = FindSuitablePosition( self:GetPos() )
			local result = self:MoveTo( pos )
			
			if result == 'investigated' then -- he was walking but heard something - alert
				self:PlaySequenceNoWait( 'hearplayer' )
				self:SetWaitTimer( CurTime() + 3 )
				self:SetNPCState( NPCSTATE_ALERT )
				self.iSearchAttempts = math.random( 6, 24 )
			elseif result == 'enemylost' then -- he just lost player - alert : extra search count
				self:PlaySequenceNoWait( 'hearplayer' )
				self:SetWaitTimer( CurTime() + 3 )
				self:SetNPCState( NPCSTATE_ALERT )
				self.iSearchAttempts = math.random( 10, 32 )
				
				self:SetNPCBit( NPCBIT_HEARDSOUND, false ) -- reset tracked object
				self.eSoundEntity = NULL
			elseif result == 'enemyhit' || result == 'playerhit' then
				if game.SinglePlayer() and result == 'playerhit' then -- if in singleplayer : teleport him somewhere
					local pos = FindSuitablePosition( self:GetPos(), Vector( 1000, 1000, 15 ) )
					self:SetPos( pos )
				else -- if in multiplayer : run away ignoring world
					local pos = FindSuitablePosition( self:GetPos(), Vector( 1000, 1000, 15 ) )
					self:MoveTo( pos, true, true )
					self:StartActivity( ACT_IDLE )
					coroutine.wait( 1 )
				end
				self:SetNPCState( NPCSTATE_SEARCHING )
			end
		elseif self:GetNPCState() == NPCSTATE_ALERT then -- roam around : small walk distances : reacts to sound with very small delay
			local pos = FindSuitablePosition( self:GetPos(), Vector( 350, 350, 350 ) )
			local result = self:MoveTo( pos )
			
			if result == 'enemylost' then -- already alert and lost player : add extra searches
				self.iSearchAttempts = self.iSearchAttempts + math.random( 4, 6 )
				
				self:SetNPCBit( NPCBIT_HEARDSOUND, false ) -- reset tracked object
				self.eSoundEntity = NULL
			elseif result == 'enemyhit' || result == 'playerhit' then -- finnaly chased player down
				if game.SinglePlayer() and result == 'playerhit' then -- if in singleplayer : teleport him somewhere
					local pos = FindSuitablePosition( self:GetPos(), Vector( 1000, 1000, 15 ) )
					self:SetPos( pos )
				else -- if in multiplayer : run away ignoring world
					local pos = FindSuitablePosition( self:GetPos(), Vector( 1000, 1000, 15 ) )
					self:MoveTo( pos, true, true )
					self:StartActivity( ACT_IDLE )
					coroutine.wait( 1 )
				end
				self:SetNPCState( NPCSTATE_SEARCHING )
			elseif result == 'investigated' then -- again heard something : add extra searches
				self.iSearchAttempts = self.iSearchAttempts + math.random( 2, 3 )
				self:SetNPCState( NPCSTATE_ALERT )
			end
			
			self.iSearchAttempts = self.iSearchAttempts - 1
			if self.iSearchAttempts == 0 then
				self:SetNPCState( NPCSTATE_SEARCHING ) -- tried to find noise source but failed : return to normal behavior
			end
			
			self:PlaySequenceNoWait( 'hearplayer' )
			self:SetWaitTimer( CurTime() + 3 )
		elseif self:GetNPCState() == NPCSTATE_CHASING then -- chasing something / post chase but still the same NPC State
			-- should be more advanced logic on what to do next, but at this moment we
			-- simply don't have much info on what lead construct to this branch of the
			-- code :: this should not happen normaly!!!
			
			if IsValid( self:GetEnemy() ) then
				local pos = self:GetEnemy():GetPos()
				local result = self:MoveTo( pos, true )
				
				if result == 'investigated' then -- ??? :: should not happen, but who knows...
					self:PlaySequenceNoWait( 'hearplayer' )
					self:SetWaitTimer( CurTime() + 3 )
					self:SetNPCState( NPCSTATE_ALERT )
					self.iSearchAttempts = math.random( 6, 24 )
				elseif result == 'enemylost' then -- lost player - alert : extra search count
					self:PlaySequenceNoWait( 'hearplayer' )
					self:SetWaitTimer( CurTime() + 3 )
					self:SetNPCState( NPCSTATE_ALERT )
					self.iSearchAttempts = math.random( 10, 32 )
					
					self:SetNPCBit( NPCBIT_HEARDSOUND, false ) -- reset tracked object
					self.eSoundEntity = NULL
				elseif result == 'enemyhit' || result == 'playerhit' then
					if game.SinglePlayer() and result == 'playerhit' then -- if in singleplayer : teleport him somewhere
						local pos = FindSuitablePosition( self:GetPos(), Vector( 1000, 1000, 15 ) )
						self:SetPos( pos )
					else -- if in multiplayer : run away ignoring world
						local pos = FindSuitablePosition( self:GetPos(), Vector( 1000, 1000, 15 ) )
						self:MoveTo( pos, true, true )
						coroutine.wait( 1 )
					end
					self:SetNPCState( NPCSTATE_SEARCHING )
				end
			else
				self:SetNPCState( NPCSTATE_SEARCHING )
				self.iSearchAttempts = 0
			end
		end
		
		coroutine.yield()
	end
end

-- CHECK LINE OF SIGHT
function ENT:ComputeLOS( vec1, vec2, ignoreList )
	ignoreList = ignoreList or {}
	table.insert( ignoreList, self )
	
	local line = util.TraceLine( { start = vec1, endpos = vec2, filter = ignoreList, mask = MASK_SOLID } )
	-- if trace didn't hit anything - we can see the target
	return !line.Hit
end

-- CHECK ANGLES
function ENT:ComputeAngles( ent, range )
	if !IsValid( ent ) then return false end
	range = range or math.pi / 8
	
	local dir = self:GetAngles():Forward()
	local diff = ent:GetPos() - self:GetPos()
	local dot = dir:Dot( diff ) / diff:Length()

	return dot > ( 1 - range )
end

function ENT:FindEnemy()
	if IsValid( self:GetEnemy() ) then return end
	local pos, ang = self:GetPos() + Vector( 0, 0, 56 ), self:GetAngles()
	local viewSphere = ents.FindInSphere( self:GetPos(), 2048 )
	local senseSphere = ents.FindInSphere( self:GetPos(), 36 )
	
	for i, v in pairs( senseSphere ) do
		if self.bullseye == v then continue end
		if !IsValid( v ) or ( !v:IsPlayer() and !v:IsNPC() ) then continue end
		if !self:ComputeLOS( v:GetPos() + Vector( 0, 0, 45 ), self:GetPos() + Vector( 0, 0, 45 ), { v } ) then continue end
		if GetConVarNumber( 'ai_ignoreplayers' ) == 1 and v:IsPlayer() then continue end
		if v:GetClass() == 'npc_bullseye' and v.soma or v:GetClass() == 'npc_soma_construct' then continue end
		if v.m_iRecovering and v.m_iRecovering >= CurTime() then continue end

		self.InstantAttack = true
		self:SetEnemy( v )
		return v
	end

	for i, v in pairs( viewSphere ) do
		if self.bullseye == v then continue end
		if !IsValid( v ) or ( !v:IsPlayer() and !v:IsNPC() ) then continue end
		if !self:ComputeLOS( v:GetPos() + Vector( 0, 0, 45 ), self:GetPos() + Vector( 0, 0, 45 ), { v } ) then continue end
		if !self:ComputeAngles( v, math.pi / 4 ) then continue end
		if GetConVarNumber( 'ai_ignoreplayers' ) == 1 and v:IsPlayer() then continue end
		if v:GetClass() == 'npc_bullseye' and v.soma or v:GetClass() == 'npc_soma_construct' then continue end
		if v.m_iRecovering and v.m_iRecovering >= CurTime() then continue end

		if v:IsPlayer() and v:Team() == "TEAM_HUNK" and _WSM and self:GetPos():Distance( v:GetPos() ) > 300 then
			local vis = _WSM:GetVisibilityForPlayer( v )
			if vis < 0.005 then
				continue
			end
		elseif v:IsPlayer() and v:Team() == "TEAM_HUNK" and self:GetPos():Distance( v:GetPos() ) <= 300 and self:ComputeAngles( v ) then
			self:SetEnemy( v )
			return v
		end

		self:SetEnemy( v )
		return v
	end
end

function ENT:HandleStuck()
	self.loco:ClearStuck()
end

function ENT:ListenToTheWorld( pos, ent, vol, name )
	if CLIENT then return end
	if sk_soma_construct_ignoresound:GetBool() then return end
	
	self.iLastSoundReaction = self.iLastSoundReaction or CurTime()
	
	if self.iLastSoundReaction > CurTime() then return end
	local dist = 1 - math.Clamp( pos:Distance( self:GetPos() ) / 750, 0, 1 )
	if ent:IsPlayer() and ent:KeyDown( IN_DUCK ) and name != 'items/flashlight1.wav' and !string.find( name, 'weapon' ) then return end
	if ent.m_iRecovering and ent.m_iRecovering > CurTime() then return end
	ent.SoundLevel = ent.SoundLevel or 0
	vol = vol * dist * 100

	if ent.SoundCooldown and ent.SoundCooldown < CurTime() then
		ent.SoundLevel = 0
	end
	
	self.iLastSoundReaction = CurTime() + 1

	ent.SoundLevel = ent.SoundLevel + vol
	ent.SoundCooldown = CurTime() + 10
	
	if ent.SoundLevel > 25 then
		self:SetNPCBit( NPCBIT_HEARDSOUND, true )
		self.eSoundEntity = ent
	end
end

-- PLAY SEQUENCE NO WAIT
-- alias of PlaySequenceAndWait but with no coroutine freezing function
function ENT:PlaySequenceNoWait( name, speed )
	speed = speed or 1
	
	local seq = self:LookupSequence( name )
	if self:GetSequence() != seq then
		self:SetSequence( name )
		
		self:ResetSequenceInfo()
		self:SetCycle( 0 )
		self:SetPlaybackRate( speed )
	end
end

-- MOVE TO
function ENT:MoveTo( pos, run, ignoreworld )
	if isentity( pos ) then pos = pos:GetPos() end
	local path = Path( 'Follow' )
	path:Compute( self, pos )
	path:SetGoalTolerance( 32 )
	path:SetMinLookAheadDistance( 0 )
	
	self.loco:SetAcceleration( 150 )
	self.loco:SetDeceleration( 150 )

	if !run then
		self.loco:SetDesiredSpeed( 40 )
		self:StartActivity( ACT_WALK )
	else
		self.loco:SetDesiredSpeed( 150 )
		self:StartActivity( ACT_RUN )
	end
	
	local haveAnEnemy = IsValid( self:GetEnemy() )
	local lostEnemyInDark = false
	
	local timeout = CurTime() + path:GetLength() / ( run and 150 or 30 )

	self.bIsRunning = run
	
	local wasDamaged = false
	while( IsValid( path ) ) do
		if isentity( pos ) then pos = pos:GetPos() end

		if ignoreworld then
			self.eSoundEntity = nil
			self:SetNPCBit( NPCBIT_HEARDSOUND, false )
		end
		
		if IsValid( self:GetEnemy() ) and self:GetEnemy():IsPlayer() then
			local vis = _WSM:GetVisibilityForPlayer( self:GetEnemy() )
			lostEnemyInDark = vis < 0.005
		end
		
		if !IsValid( self:GetEnemy() ) and !ignoreworld then
			//print( 'searching for an enemy', CurTime() )
			self:FindEnemy()
		end
			
		if IsValid( self:GetEnemy() ) then
			if self:ComputeLOS( self:GetEnemy():GetPos() + Vector( 0, 0, 45 ), self:GetPos() + Vector( 0, 0, 45 ), { self:GetEnemy() } ) then
				if !lostEnemyInDark or ( self:ComputeAngles( self:GetEnemy(), math.pi / 14 ) and self:GetEnemy():GetPos():Distance( self:GetPos() ) <= 300 ) then
					pos = self:GetEnemy():GetPos()
					//print( 'tracking' )
				end
			end

			if !self.bIsRunning then
				self.bIsRunning = true
				self.loco:SetDesiredSpeed( 150 )
				self:StartActivity( ACT_RUN )
				self:EmitRandomSound( 'SEEPLAYER' )
			end
			
			self:SetNPCState( NPCSTATE_CHASING )
			
			haveAnEnemy = true
			
			if path:GetAge() > 0.1 then
				path:Compute( self, pos )
				timeout = CurTime() + 1
			end
		elseif IsValid( self.eSoundEntity ) and self:GetNPCBit( NPCBIT_HEARDSOUND ) and self:GetNPCState() == NPCSTATE_ALERT then
			self:SetNPCBit( NPCBIT_HEARDSOUND, false )
			pos = self.eSoundEntity:GetPos()
			self:PlaySequenceNoWait( 'hearplayer' )
			coroutine.wait( 0.3 )

			self:SendDistortions( 3.1, true )
			self:EmitRandomSound( 'SEEPLAYER' )
			
			self.loco:SetDesiredSpeed( 450 )
			self:StartActivity( ACT_RUN )
			self.bIsRunning = true
			
			self.eSoundEntity = nil
			self:SetNPCBit( NPCBIT_HEARDSOUND, false )
		elseif( IsValid( self.eSoundEntity ) and self:GetNPCBit( NPCBIT_HEARDSOUND ) ) and self:GetNPCState() != NPCSTATE_CHASING and self:GetNPCState() != NPCSTATE_INVESTIGATE then
			if IsValid( self.eSoundEntity ) then
				self:SetNPCBit( NPCBIT_HEARDSOUND, false )
				pos = self.eSoundEntity:GetPos()
				self:PlaySequenceAndWait( 'hearplayer' )
				
				self:SetNPCState( NPCSTATE_INVESTIGATE )
				
				self:SendDistortions( 3.1, true )
				
				self.loco:SetDesiredSpeed( 450 )
				self:StartActivity( ACT_RUN )
				self.bIsRunning = true
			else
				self:SetNPCBit( NPCBIT_HEARDSOUND, false )
				return 'heardsound'
			end
		elseif( IsValid( self.eSoundEntity ) and self:GetNPCBit( NPCBIT_HEARDSOUND ) ) and self:GetNPCState() == NPCSTATE_CHASING and self.eSoundEntity == self:GetEnemy() then
			pos = self.eSoundEntity:GetPos()
			self:SetNPCBit( NPCBIT_HEARDSOUND, false )
			self.eSoundEntity = nil
		elseif IsValid( self.eSoundEntity ) and self:GetNPCBit( NPCBIT_HEARDSOUND ) and self:GetNPCState() == NPCSTATE_INVESTIGATE then
			pos = self.eSoundEntity:GetPos()
			self:SetNPCBit( NPCBIT_HEARDSOUND, false )
			self.eSoundEntity = nil
		elseif self:GetNPCBit( NPCBIT_DAMAGED ) and self.vDamagePos then
			pos = self.vDamagePos
			path:Compute( self, pos )
			self.vDamagePos = nil
			self:SetNPCBit( NPCBIT_DAMAGED, false )
			
			self:SendDistortions( 2.1, true )
				
			self.loco:SetDesiredSpeed( 450 )
			self:StartActivity( ACT_RUN )
			self.bIsRunning = true
			
			wasDamaged = true
		end
		
		if self.InstantAttack then
			self:Attack()
			return 'hitplayer'
		end
		
		if path:GetAge() > 0.05 and !IsValid( self:GetEnemy() ) then
			path:Compute( self, pos )
		end
		
		if timeout < CurTime() then
			return 'timedout'
		end
		
		if self.iLastSound < CurTime() then
			self.iLastSound = CurTime() + self:EmitRandomSound( 'IDLE' )
		end
		
		if self.iLastStep < CurTime() then
			self.iLastStep = CurTime() + ( self.bIsRunning and footsteprate_run or footsteprate_walk )
			local variation = ( math.random( 1, 3 ) == 2 ) and 'bass' or 'feet'
			self:EmitSound( 'soma/npc_soma_construct/construct_' .. ( self.bIsRunning and 'run' or 'walk' ) .. '_' .. variation .. '_0' .. math.random( 1, 6 ) .. '.wav', ( self.bIsRunning and 70 or 60 ) )
		end
		
		path:Update( self )
		if GetConVarNumber( 'developer' ) > 0 then
			path:Draw()
		end

		-- push props away && open doors
		for i, v in pairs( ents.FindInSphere( self:GetPos(), 36 ) ) do
			if IsValid( v ) and ( v:GetClass() == 'prop_physics' or v:GetClass() == 'prop_physics_multiplayer' ) then
				local phy = v:GetPhysicsObject()
				if IsValid( phy ) and v:GetMoveType() == MOVETYPE_VPHYSICS and phy:IsMotionEnabled() then
					phy:SetVelocity( ( v:GetPos() - self:GetPos() ):GetNormalized() * 200 )
				end
			elseif IsValid( v ) and ( v:GetClass() == 'func_door' or v:GetClass() == 'prop_door_rotating' ) then
				v:Fire( 'Open' )
			end
		end

		if self:GetPos():Distance( pos ) < 135 then
			if IsValid( self:GetEnemy() ) then
				if self:GetEnemy():GetPos():Distance( self:GetPos() ) > 135 then
					self:SetEnemy( NULL )
					return 'enemylost'
				elseif self:GetEnemy():GetPos():Distance( self:GetPos() ) <= 135 then
					local player = self:GetEnemy():IsPlayer()
					self:Attack()
					if player then return 'playerhit' end
					return 'enemyhit'
				end
			end
			
			if wasDamaged then
				return 'enemylost'
			end
			
			if self:GetNPCState() == NPCSTATE_INVESTIGATE then
				return 'investigated'
			end
			
			return 'complete'
		end
		
		coroutine.yield()
	end
	
	self:StartActivity( ACT_IDLE )
	
	return 'complete'
end

-- EMIT RANDOM SOUND
function ENT:EmitRandomSound( group, soundlevel )
	soundlevel = soundlevel or 75
	if( self.SNDLIST[ group ] ) then
		local tb = self.SNDLIST[ group ]
		local size = table.Count( tb )
		local index = math.random( 1, size )
		
		self:StopAllSounds()

		timer.Simple( 0.1, function()
			if !IsValid( self ) then return end
			self:EmitSound( tb[index], soundlevel )
		end )
		return SoundDuration( tb[index] )
	end
	
	return 0
end

-- STOP ALL SOUNDS
function ENT:StopAllSounds()
	if !IsValid( self ) then return end
	for i, _ in pairs( self.SNDLIST ) do
		for _, v in pairs( self.SNDLIST[ i ] ) do
			self:StopSound( v )
		end
	end
end

-- SEND DISTORTIONS
function ENT:SendDistortions( strength, timeglitch )
	if CLIENT then return end
	if !LifeMod then return end
	timeglitch = timeglitch or false
	
	for i, v in pairs( ents.FindInSphere( self:GetPos(), 750 ) ) do
		if IsValid( v ) and v:IsPlayer() then
			net.Start( 'LIFEDISTORTIONMODULE_ADDDISTORTION' )
				net.WriteFloat( strength )
				net.WriteBit( timeglitch )
			net.Send( v )
		end
	end
end

function ENT:Attack()
	self.InstantAttack = false
	
	local enemy = self:GetEnemy()
	self:PlaySequenceNoWait( 'attack' )
	
	if IsValid( enemy ) then
		if enemy:IsPlayer() and enemy:Alive() then
			enemy:EmitSound( 'soma/npc_soma_construct/hitplayer.wav' )
			
			if enemy:Health() <= 50 then
				enemy:SetArmor( 0 )
				if game.SinglePlayer() then
					enemy:SetNWEntity( 'SOMAKillsceneConstruct', self )
					enemy:Freeze( true )
					enemy:StripWeapons()
					enemy:ScreenFade( SCREENFADE.OUT, Color( 0, 0, 0 ), 0.04, 1 )
					coroutine.wait( 1 )
					enemy:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0 ), 0.5, 0 )
					self:PlaySequenceAndWait( 'deathstab' )
					
					if IsValid( enemy ) then
						enemy:SetNWEntity( 'SOMAKillsceneConstruct', NULL )
						enemy:Freeze( false )
							
						local info = DamageInfo()
						info:SetDamage( enemy:Health() )
						info:SetDamageType( DMG_DIRECT )
						info:SetAttacker( self )
						info:SetInflictor( self )
						enemy:TakeDamageInfo( info )
						timer.Simple( 0.1, function()
							if IsValid( enemy ) then
								enemy:SendLua( 'StartSomaDeathAnimation()' )
							end
						end )
					end
				else
					local info = DamageInfo()
					info:SetDamage( enemy:Health() )
					info:SetDamageType( DMG_DIRECT )
					info:SetAttacker( self )
					info:SetInflictor( self )
					enemy:TakeDamageInfo( info )
					timer.Simple( 0.1, function()
						if IsValid( enemy ) then
							enemy:SendLua( 'StartSomaDeathAnimation()' )
						end
					end )
				end
			else
				enemy.m_iRecovering = CurTime() + 6.5
				enemy:ScreenFade( SCREENFADE.OUT, Color( 0, 0, 0 ), 0.04, 2 )
				enemy:SetHealth( 50 )
				enemy:Freeze( true )
				self:SendDistortions( 2.2 )	
				timer.Simple( 2, function()
					if IsValid( enemy ) then
						enemy:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0 ), 1, 0 )
						enemy:Freeze( false )
					end
				end )
			end
			self:SetEnemy( NULL )
		end
		
		if enemy:IsNPC() then
			enemy:TakeDamage( enemy:Health() + 50, self, self )
			self:SetEnemy( NULL )
		end
	end
	
	self.eSoundEntity = nil
	self:SetNPCBit( NPCBIT_HEARDSOUND, false )
end

function ENT:OnInjured( data )
	if self.iLastSound2 <= CurTime() then
		self.iLastSound2 = CurTime() + self:EmitRandomSound( 'PAIN' )
	end
	if self:GetNPCState() != NPCSTATE_CHASING then
		self:SetNPCBit( NPCBIT_DAMAGED, true )
		if IsValid( data:GetAttacker() ) then
			self.vDamagePos = data:GetAttacker():GetPos()
		else
			self.vDamagePos = data:GetDamagePosition()
		end
	end
end

-- FROM GARRY'S LAMP
local matLight 			= Material( "sprites/light_ignorez" )
local matBeam			= Material( "effects/lamp_beam" )

function ENT:Draw()
	BaseClass.Draw( self )
end

function ENT:DrawTranslucent()
	BaseClass.DrawTranslucent( self )

	if sk_soma_construct_light:GetBool() then
		local bone = self:LookupBone( 'Neck_02_jnt' )
		if bone then
			local pos, ang = self:GetBonePosition( bone )
			ang.p = ang.p + 45
			
			local LightNrm = ang:Forward()
			local ViewNormal = self:GetPos() - EyePos()
			local Distance = ViewNormal:Length()
			ViewNormal:Normalize()
			local ViewDot = ViewNormal:Dot( LightNrm * -1 )
			local LightPos = pos + LightNrm * 5

			if ( ViewDot >= 0 ) then
				render.SetMaterial( matLight )
				local Visibile	= util.PixelVisible( LightPos, 16, self.PixVis )	
					
				if (!Visibile) then return end
					
				local Size = math.Clamp( Distance * Visibile * ViewDot * 2, 24, 84 )
					
				Distance = math.Clamp( Distance, 32, 800 )
				local Alpha = math.Clamp( ( 1000 - Distance ) * Visibile * ViewDot, 0, 100 )
				local Col = Color( 120, 200, 255, Alpha )
					
				render.DrawSprite( LightPos, Size, Size, Col, Visibile * ViewDot )
				render.DrawSprite( LightPos, Size * 0.4, Size * 0.4, Color( 255, 255, 255, Alpha ), Visibile * ViewDot )
			end
		end
	end
end

hook.Add( 'EntityEmitSound', 'SOMAConstruct_ReactToSound', function( snd )
	local pos, ent, volume, name = snd.Pos, snd.Entity, snd.Volume, snd.SoundName
	if !IsValid( ent ) and !ent:IsWorld() or ( !pos and !IsValid( ent ) ) then return end
	if ent:GetClass() == 'ambient_generic' or ent:GetClass() == 'npc_soma_construct' or ent:GetClass() == 'func_physbox_multiplayer' or ent:GetClass() == 'env_spark' then return end
	if !pos then pos = ent:GetPos() end
	if GetConVarNumber( 'ai_ignoreplayers' ) == 1 and ent:IsPlayer() then return end

	for i, v in pairs( ents.FindInSphere( pos, 750 ) ) do
		if IsValid( v ) and v:GetClass() == 'npc_soma_construct' and SERVER then
			v:ListenToTheWorld( pos, ent, volume, name )
		end
	end
end )

list.Set( 'NPC', 'npc_soma_construct', {
	Name = 'Infected Construct', 
	Class = 'npc_soma_construct', 
	Category = 'SOMA'
} )