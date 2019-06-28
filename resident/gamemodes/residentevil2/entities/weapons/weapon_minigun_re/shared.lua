if (CLIENT) then
	SWEP.PrintName			= "Minigun"
	SWEP.Slot				= 4
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "V"
	SWEP.DrawAmmo 			= true
	SWEP.DrawCrosshair 		= false
	SWEP.CSMuzzleFlashes 	= true
	SWEP.SwayScale			= 1.0
	SWEP.BobScale			= 1.0
	killicon.AddFont("weapon_minigun","CSKillIcons",SWEP.IconLetter,Color(255,80,0,255))
end
if (SERVER) then
	AddCSLuaFile("shared.lua")
end

SWEP.Base				= "weapon_basegun_re"

SWEP.ViewModelFOV		= 62
SWEP.ViewModelFlip		= false
SWEP.ViewModel = "models/weapons/v_minigun.mdl"
SWEP.WorldModel = "models/weapons/w_minigun.mdl"
SWEP.HoldType 			= "shotgun"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("weapons/minigun/mini-1.wav")
SWEP.Primary.Recoil			= 0.6
SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.ClipSize		= 13
SWEP.Primary.Delay			= 0.08
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "StriderMinigun"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Item = "item_minigun"
function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	self:Update()
	if SERVER then
		GAMEMODE:SetPlayerSpeed(self:GetOwner(),self:GetOwner():GetNWInt("Speed")/2,self:GetOwner():GetNWInt("Speed")/2)
	end
end

function SWEP:Holster(wep)
	if SERVER then
		GAMEMODE:SetPlayerSpeed(self:GetOwner(),self:GetOwner():GetNWInt("Speed"),self:GetOwner():GetNWInt("Speed"))
	end
	return true
end

function SWEP:CanPrimaryAttack()
	if self.Weapon:Clip1() <= 0 then
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.2)
		self:Reload()
		return false
	end
	return true
end
