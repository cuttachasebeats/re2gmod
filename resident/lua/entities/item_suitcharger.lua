AddCSLuaFile( )
DEFINE_BASECLASS( "base_anim" )

ENT.Spawnable = false

local sk_suitcharger = GetConVar( "sk_suitcharger" )
local sk_suitcharger_citadel = GetConVar( "sk_suitcharger_citadel" )

--These don't really need to be networked
AccessorFunc( ENT, "m_flNextCharge", "NextCharge", FORCE_NUMBER )
AccessorFunc( ENT, "m_flSoundTime", "SoundTime", FORCE_NUMBER )

AccessorFunc( ENT, "m_iReactivate", "Reactivate", FORCE_NUMBER )
AccessorFunc( ENT, "m_iOn", "UseState", FORCE_NUMBER )

local CHARGE_RATE = .25
local CHARGES_PER_SECOND = 1 / CHARGE_RATE
local CITADEL_CHARGES_PER_SECOND = 10 / CHARGE_RATE
local CALLS_PER_SECOND = 7 * CHARGES_PER_SECOND

local SF_KLEINER_RECHARGER = 0x4000
local SF_CITADEL_RECHARGER = 0x2000

function ENT:SetupDataTables( )
	self:NetworkVar( "Float", 0, "RJuice" )

	self:NetworkVar( "Int", 0, "Juice" )
	self:NetworkVar( "Int", 1, "MaxJuice" )
	
	self:NetworkVar( "Bool", 0, "BlockCycle" )
end
function ENT:OnRecharge( activator, caller, data )
	self:Recharge( )
end
function ENT:OnSetCharge( activator, caller, data )
	local num = tonumber( data )
	
	self:SetJuice( num )
	self:SetMaxJuice( num )
end
function ENT:Draw( )
	if not self:GetBlockCycle( ) then
		self.TargetCycle = math.Approach( self.TargetCycle or 0, self:GetRJuice( ) / self:GetMaxJuice( ), FrameTime( ) )
		self:SetCycle( 1 - self.TargetCycle )
	else
		self:SetCycle( 1 )
	end
	self:DrawModel( )
end
function ENT:Initialize( )
	self:SetModel( "models/props_combine/suit_charger001.mdl" )
	
	if SERVER then
		self:PhysicsInit( SOLID_BBOX )
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_BBOX )
	end
	
	self:AddEffects( EF_NOSHADOW )
	self:ResetSequence( self:LookupSequence( "idle" ) )
	
	self:SetInitialCharge( )
	self:SetJuice( self:GetMaxJuice( ) )
	self:SetRJuice( self:GetMaxJuice( ) )
	self:SetNextCharge( 0 )
	self:SetSoundTime( 0 )
	self:SetReactivate( 30 )
	
	self:SetUseState( 0 )
end
function ENT:Recharge( )
	self:EmitSound( "SuitRecharge.Start" )
	self:ResetSequence( self:LookupSequence( "idle" ) )
	
	self:UpdateJuice( self:GetMaxJuice( ) )
	self:SetRJuice( self:GetMaxJuice( ) )
	
	self:SetBlockCycle( false )
end
function ENT:UpdateJuice( val )
	local reduced, half
	
	reduced = val < self:GetJuice( )
	half = self:GetMaxJuice( ) / 2
	
	if reduced then
		if val <= half and self:GetJuice( ) > half then
			self:TriggerOutput( "OnHalfEmpty", self, self )
		end
		
		if val <= 0 then
			self:TriggerOutput( "OnEmpty", self, self )
		end
	elseif val ~= self:GetJuice( ) and val == self:GetMaxJuice( ) then
		self:TriggerOutput( "OnFull", self, self )
	end

	self:SetJuice( val )
	--self:SetRJuice( val )
end
function ENT:AcceptInput( name, activator, caller, data )
	if name:lower( ) == "recharge" then
		self:OnRecharge( activator, caller, data )
		return true
	end
	
	if name:lower( ) == "setcharge" then
		self:OnSetCharge( activator, caller, data )
		return true
	end
	
	return false
end
function ENT:KeyValue( name, value )
	if name:lower( ) == "dmdelay" then
		self:SetReactivate( tonumber( value ) or 0 )
	else
		self.BaseClass.KeyValue( self, name, value )
	end
		
end
function ENT:SetInitialCharge( )
	if self:HasSpawnFlags( SF_KLEINER_RECHARGER ) then
		self:SetMaxJuice( 25 )
	elseif self:HasSpawnFlags( SF_CITADEL_RECHARGER ) then
		self:SetMaxJuice( sk_suitcharger_citadel:GetInt( ) )
	else
		self:SetMaxJuice( sk_suitcharger:GetInt( ) )
	end
end
function ENT:Use( pl )
	if not IsValid( pl ) or not pl:IsPlayer( ) then
		return
	end
	
	self:SetUseType( CONTINUOUS_USE )
	
	local a, b
	
	if self:GetUseState( ) > 0 then
		a = CHARGES_PER_SECOND
		b = CALLS_PER_SECOND
		
		if self:HasSpawnFlags( SF_CITADEL_RECHARGER ) then
			a = CITADEL_CHARGES_PER_SECOND
		end
		
		self:SetRJuice( self:GetRJuice( ) - a / b )
	end
	
	if not pl:IsSuitEquipped( ) then
		if self:GetSoundTime( ) <= CurTime( ) then
			self:SetSoundTime( CurTime( ) + .62 )
			self:EmitSound( "SuitRecharge.Deny" )
		end
		
		return
	end
	
	if self:GetJuice( ) <= 0 then
		self:ResetSequence( self:LookupSequence( "emptyclick" ) )
		self:SetBlockCycle( true )
		self:Think( )
		
		if self:GetSoundTime( ) <= CurTime( ) then
			self:SetSoundTime( CurTime( ) + .62 )
			self:EmitSound( "SuitRecharge.Deny" )
		end
		
		return
	end
	
	local increment = 1
	local max = 100 + math.max( 0, RPG:GetSkill( pl, RPG.XSkills.SUPERIORARMOR ) - 100 )
	
	if self:HasSpawnFlags( SF_CITADEL_RECHARGER ) then
		increment = 10	
		
		max = max + 100
		
		if pl:Health( ) < pl:GetMaxHealth( ) and self:GetNextCharge( ) <= CurTime( ) then
			pl:SetHealth( math.min( pl:GetMaxHealth( ), pl:Health( ) + 5 ) )
		end
	end
	
	if pl:Armor( ) >= max then
		if not self:HasSpawnFlags( SF_CITADEL_RECHARGER  ) or ( self:HasSpawnFlags( SF_CITADEL_RECHARGER ) and pl:Health( ) >= pl:GetMaxHealth( ) ) then
			pl:ConCommand( "-use\n" )
			self:SetUseType( SIMPLE_USE )
			self:EmitSound( "SuitRecharge.Deny" )
			return
		end
	end
	
	self:NextThink( CurTime( ) + CHARGE_RATE )
	
	if self:GetUseState( ) == 0 then
		self:SetUseState( 1 )
		
		self:EmitSound( "SuitRecharge.Start" )
		self:SetSoundTime( CurTime( ) + .56 )
		
		self:TriggerOutput( "OnPlayerUse", pl, self )
	end
	
	if self:GetNextCharge( ) > CurTime( ) then
		return
	end
	
	if self:GetUseState( ) == 1 and self:GetSoundTime( ) <= CurTime( ) then
		self:SetUseState( 2 )
		self:EmitSound( "SuitRecharge.ChargingLoop" )
	end
	
	if pl:Armor( ) < max then
		local d = math.min( increment, max - pl:Armor( ) )
		
		self:UpdateJuice( self:GetJuice( ) - d )
		pl:SetArmor( pl:Armor( ) + d )
	end
	
	self:TriggerOutput( "OutRemainingCharge", pl, self, self:GetJuice( ) / self:GetMaxJuice( ) )
	
	self:SetNextCharge( CurTime( ) + .1 )
end
function ENT:Think( )
	if self:GetUseState( ) > 1 then
		self:StopSound( "SuitRecharge.ChargingLoop" )
	end
	
	if CLIENT then
		return
	end
	
	self.Last = self.Last or CurTime( )
	
	local delta = CurTime( ) - self.Last
	
	self.Last = CurTime( )
	
	self:SetUseState( 0 )
	
	self:SetJuice( math.max( 0, self:GetJuice( ) ) )
	
	if self:GetJuice( ) == 0 and self:GetReactivate( ) > 0 then
		self:SetReactivate( math.max( 0, self:GetReactivate( ) - delta ) )
	end
	
	if self:GetReactivate( ) == 0 and self:GetJuice( ) == 0 then
		if self:HasSpawnFlags( SF_CITADEL_RECHARGER ) then
			self:SetReactivate( 60 )
		else
			self:SetReactivate( 30 )
		end
		
		self:Recharge( )
	else
	end
end