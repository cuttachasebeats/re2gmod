if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.Weight				= 1
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
	SWEP.HoldType			= "slam"
	SWEP.IconLetter			= "I"
end
if (CLIENT) then
	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= true
	SWEP.ViewModelFOV		= 64
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
	SWEP.PrintName			= "C4 Plastic Explosives Detonater"
	SWEP.Author				= "Noobulator"
	SWEP.Slot				= 0
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "C"
	killicon.AddFont("weapon_c4_re","CSKillIcons",SWEP.IconLetter,Color(255,80,0,255))
end
SWEP.Author			= "Noobulator"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_c4.mdl"
SWEP.WorldModel			= "models/weapons/w_c4.mdl"

SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= -1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 1.0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= -1
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.Delay		= .5
SWEP.Secondary.NextFire 	= 0

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()
	if (SERVER) then
		self:SetWeaponHoldType(self.HoldType)
	end
end

function SWEP:Deploy()
end

function SWEP:Reload()
end

function SWEP:Think()
end

function SWEP:PrimaryAttack()
	for k,v in pairs(ents.FindByClass("item_base")) do
		if v:GetNWString("Class") == "item_c4" && v.Owner == self:GetOwner() then
			v:Asplode()
			self:SetNextPrimaryFire(CurTime() + 0.2)
		end
	end
end

function SWEP:SecondaryAttack()
	if self:CanSecondaryAttack() then
		self:SetNextSecondaryFire(CurTime() + 0.5)
		if (game.SinglePlayer() || CLIENT) then
			for slot,data in pairs(Inventory) do
				if data.Item == "item_c4" then
					RunConsoleCommand("inv_UseItem", data.Item, slot)
					return
				end
			end
		end
	end
end


function SWEP:CanSecondaryAttack()
	return self:GetNextSecondaryFire() < CurTime()
end

function SWEP:Holster()
	return true
end

function SWEP:OnRemove()
	return true
end
