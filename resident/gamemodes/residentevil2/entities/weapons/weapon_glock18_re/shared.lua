if (CLIENT) then
	SWEP.PrintName			= "Glock 18"
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "c"
	SWEP.DrawAmmo 			= true
	SWEP.DrawCrosshair 		= false	
	SWEP.CSMuzzleFlashes 	= true
	SWEP.SwayScale			= 1.0
	SWEP.BobScale			= 1.0
	killicon.AddFont("weapon_glock18","CSKillIcons",SWEP.IconLetter,Color(255,80,0,255))
end
if (SERVER) then
	AddCSLuaFile("shared.lua")
end

SWEP.Base				= "weapon_basegun_re"

SWEP.ViewModelFOV		= 62
SWEP.ViewModelFlip		= true
SWEP.ViewModel			= "models/weapons/v_pist_glockre.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_glock18.mdl"
SWEP.HoldType 			= "pistol"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("weapons/glockre/glock18-1.wav")
SWEP.Primary.Recoil			= .5
SWEP.Primary.Damage			= 17
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.1
SWEP.Primary.ClipSize		= 20
SWEP.Primary.Delay			= 0.15
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Changing = false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Delay = 0.25
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Item = "item_glock18"


function SWEP:SecondaryAttack()
	if self.Changing then return end
	self.Changing = true
	timer.Simple(0.5, function() self.Changing = false end)
	self:EmitSound("Weapon_Pistol.Empty")
	if self.Primary.Automatic != true then
		self.Primary.Automatic = true 
		self:SetNextPrimaryFire(CurTime() + 0.7)
		self.Primary.Delay = self.Primary.Delay * .6
		self.Primary.Cone = self.Primary.Cone * self.IMultiplier
		self:GetOwner():PrintMessage(HUD_PRINTCENTER,"Switched to automatic")
	else 
		self.Primary.Automatic = false
		self:SetNextPrimaryFire(CurTime() + 0.7)
		self.Primary.Delay = self.Primary.Delay / .6
		self.Primary.Cone = self.Primary.Cone / self.IMultiplier
		self:GetOwner():PrintMessage(HUD_PRINTCENTER,"Switched to single fire")
	end

	self.Weapon:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	
end

function SWEP:CanSecondaryAttack()
if self.Changing != false then return end
	if self.Weapon:Clip2() <= 0 then
		self.Weapon:EmitSound("Weapon_Pistol.Empty")
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.2)
		return false
	end
	return true
end

function SWEP:CanPrimaryAttack()
if self.Changing != false then return false end
	if self.Weapon:Clip1() <= 0 then
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.2)
		self:Reload()
		return false
	end
	return true
end

