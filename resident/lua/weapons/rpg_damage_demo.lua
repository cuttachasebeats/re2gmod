AddCSLuaFile( )

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Category = "Debug"
SWEP.PrintName = "GMXPM Damage Debug Tool"

SWEP.Slot = 0
SWEP.UseHands = true

SWEP.ViewModel = Model( "models/weapons/c_slam.mdl" )

SWEP.Primary.Ammo = "none"
SWEP.Secondary.Ammo = "none"

SWEP.Primary.Automatic = true
SWEP.Secondary.Automatic = false

SWEP.DamageSettings = {
	Damage = 10,
	DamageType = DMG_CLUB,
	DamageRadius = 0,
}

SWEP.DamageType = {
	Crush = DMG_CRUSH,
	Bullet = DMG_BULLET,
	Club = DMG_CLUB,
	Blast_Surface = DMG_BLAST_SURFACE,
	Airboat = DMG_AIRBOAT,
	Burn = DMG_BURN,
	Radiation = DMG_RADIATION,
	Plasma = DMG_PLASMA,
	Buckshot = DMG_BUCKSHOT,
	Poison = DMG_POISON,
	Slash = DMG_SLASH,
	Acid = DMG_ACID,
	Fall = DMG_FALL,
	Sonic = DMG_SONIC,
	Physgun = DMG_PHYSGUN,
	Vehicle = DMG_VEHICLE,
	Drown = DMG_DROWN,
	Slow_Burn = DMG_SLOWBURN,
	Nerve_Gas = DMG_NERVEGAS,
	Shock = DMG_SHOCK,
	Blast = DMG_BLAST,
	Energy_Beam = DMG_ENERGYBEAM,
}

function SWEP:Initialize( )
	self:SetWeaponHoldType( "slam" )
end

function SWEP:Deploy( )
	self:SendWeaponAnim( ACT_SLAM_DETONATOR_DRAW )
	return true
end

function SWEP:Reload( )
end

function SWEP:PrimaryAttack( )
	self:SendWeaponAnim( ACT_SLAM_DETONATOR_DETONATE )
	self:EmitSound( "weapons/slam/buttonclick.wav" )
	
	local tr = self.Owner:GetEyeTrace( )
	
	if tr.Hit and SERVER then
		local info = DamageInfo( )
			info:SetDamage( self.DamageSettings.Damage )
			info:SetDamageType( self.DamageSettings.DamageType )
			info:SetAttacker( self.Owner )
			info:SetInflictor( self )
			info:SetMaxDamage( self.DamageSettings.Damage )
			info:SetDamagePosition( tr.HitPos )
			info:SetDamageForce( tr.Normal * 20 )
			
			if self.DamageSettings.DamageRadius > 0 then
				util.BlastDamageInfo( info, tr.HitPos, self.DamageSettings.DamageRadius )
			elseif tr.Entity:IsValid( ) then
				tr.Entity:TakeDamageInfo( info )
			end
	end
	
	self:SetNextPrimaryFire( CurTime( ) + .1 )
end

function SWEP:SecondaryAttack( )
end