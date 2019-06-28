

if (SERVER) then
	AddCSLuaFile("shared.lua")
end


-- Variables that are used on both client and server
SWEP.Category				= "Call Of Duty: Black Ops II"
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "AN-94"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 1				-- Slot in the weapon selection menu
SWEP.SlotPos				= 3			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= false		-- set false if you want no crosshair
SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.HoldType 				= "ar2"		-- how others view you carrying the weapon
SWEP.SwayScale			= 1.0
SWEP.BobScale			= 1.0
SWEP.IconLetter			= "b"
SWEP.CSMuzzleFlashes 	= true
SWEP.ViewModelFOV		= 62
SWEP.ViewModelFlip		= false
SWEP.ViewModel				= "models/weapons/v_bo2_an94.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_rif_ak47.mdl"	-- Weapon world model
SWEP.Base				= "weapon_basegun_re"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.Primary.Sound			= Sound("weapons/an94/fire.wav")		-- Script that calls the primary fire sound
SWEP.Primary.Recoil			= 0.8
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.07
SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip		= 0
SWEP.Primary.Delay			= 0.1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.reloadinfo = 1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Secondary.IronFOV			= 65		-- How much you 'zoom' in. Less is more! 	

SWEP.Item = "item_an94"

-- Enter iron sight info and bone mod info below

	SWEP.IronSightsPos = Vector(-7.24, -12.12, 0.839)
	SWEP.IronSightsAng = Vector(0, 0, 0)
	SWEP.SightsPos = Vector(-7.24, -12.12, 0.839)
	SWEP.SightsAng = Vector(0, 0, 0)
	SWEP.RunSightsPos = Vector(-2.401, -4.401, 4.199)
	SWEP.RunSightsAng = Vector(-25.3, 30.799, -10.9)
