
	SWEP.PrintName			= "Heckler & Koch .45ACP"
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "y"
	SWEP.DrawAmmo 			= true
	SWEP.DrawCrosshair 		= false	
	SWEP.CSMuzzleFlashes 	= true
	SWEP.SwayScale			= 1.0
	SWEP.BobScale			= 1.0


	AddCSLuaFile("shared.lua")


SWEP.Base				= "weapon_basegun_re"
SWEP.Gun = ("weapon_9mm_re")	
SWEP.ViewModelFOV		= 62
SWEP.ViewModelFlip		= true
SWEP.ViewModel = "models/weapons/v_pist_9mm.mdl"
SWEP.WorldModel = "models/weapons/w_pist_usp.mdl"
SWEP.HoldType 			= "pistol"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("weapons/tac45/fire.wav")
SWEP.Primary.Recoil			= 0.8
SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.ClipSize		= 15
SWEP.Primary.Delay			= 0.08
SWEP.Primary.Automatic		= false 
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Item = "item_9mmhandgun"

SWEP.IronSightsPos = Vector (2.0692, -1.999, 0.8999)
SWEP.IronSightsAng = Vector (0.9684, 0.0098, 0)
