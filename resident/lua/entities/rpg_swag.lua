AddCSLuaFile( )

DEFINE_BASECLASS( "base_anim" )

local GOLD_MAT = Material( "models/player/shared/gold_player" )

GOLD_MAT:SetInt( "$selfillum", 1 )

ENT.LowModel = Model( "models/props/cs_assault/dollar.mdl" )
ENT.HighModel = Model( "models/props/cs_assault/money.mdl" )

ENT.IsSwag = true

ENT.Min = Vector( -4.02, -1.844, .08 )
ENT.Max = Vector( 4.02, 1.844, .8 )

function ENT:SetupDataTables( )
	self:NetworkVar( "Entity", 0, "IntendedPlayer" )
	
	self:NetworkVar( "Float", 0, "ExclusiveTime" )
	self:NetworkVar( "Float", 1, "Life" )
	
	self:NetworkVar( "Int", 0, "Amount" )
end

function ENT:Initialize( )
	if SERVER then
		self:SetExclusiveTime( 5 )
		self:SetLife( 30 )
		self:AddEffects( EF_DIMLIGHT )
	end
	
	self:UpdateSwag( )
end

function ENT:UpdateSwag( )
	local o = self:GetModel( )
	
	if self:GetAmount( ) < 10 then
		self:SetModel( self.LowModel )
	else
		self:SetModel( self.HighModel )
	end
	
	if o ~= self:GetModel( ) and SERVER then
		if self:GetPhysicsObject( ):IsValid( ) then
			self:PhysicsDestroy( )
		end
		
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:PhysWake( )
	end
end

function ENT:Think( )
	if SERVER then
		if self:GetLife( ) == 0 then
			sound.Play( "ambient/levels/citadel/weapon_disintegrate1.wav", self:GetPos( ), 50, .5 )
			self:Remove( )
		elseif self:GetAmount( ) == 0 then
			self:Remove( )
		end
	end
end

function ENT:StartTouch( with )
	if CLIENT then
		return
	end
	
	if with:IsPlayer( ) and self:IsValid( ) then
		if with ~= self:GetIntendedPlayer( ) and self:GetExclusiveTime( ) > 0 then
			return
		end
		
		if self:GetAmount( ) < 1 then
			return
		end
		
		with.RpgData.Swag = math.min( ( with.RpgData.Swag or 0 ) + self:GetAmount( ), 32767 )
		
		with:EmitSound( "mvm/mvm_money_pickup.wav" )
		
		self:SetAmount( 0 )
		self:Remove( )
	elseif with.IsSwag and with:GetAmount( ) > 0 and self:GetAmount( ) > 0 then
		self:SetAmount( self:GetAmount( ) + with:GetAmount( ) )
		with:SetAmount( 0 )
		self:UpdateSwag( )
	end
end

function ENT:Draw( )
	if LocalPlayer( ) == self:GetIntendedPlayer( ) or self:ExclusiveTime( ) == 0 then
		render.SetBlend( .5 - math.cos( CurTime( ) * 2 % 360 ) )
		render.MaterialOverride( GOLD_MAT )
		
		self:DrawModel( )
		
		render.MaterialOverride( nil )
		render.SetBlend( .5 + math.cos( CurTime( ) * 2 % 360 ) )
		
		self:DrawModel( )
	end
end