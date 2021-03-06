// Variables that are used on both client and server
SWEP.Category				= "Nikolai's Sweps"
SWEP.Author				= "Nikolai MacPootislavski"
SWEP.Contact				= "Nikolai MacPootislavski"
SWEP.Purpose				= "Create Destruction"
SWEP.Instructions			= "Use your index finger to shoot and your middle finger to aim."
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment		= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.DrawCrosshair			= false	

SWEP.ViewModelFOV			= 60
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_rif_gar.mdl"
SWEP.WorldModel				= "models/weapons/w_rif_gar.mdl"
SWEP.Base 				= "gdcw_base_nik2"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.Icon				= "entities/gdcw_m1gar"

SWEP.Primary.Sound			= Sound("weapons/gar/gar1.wav")
SWEP.Primary.Round			= ("gdcwa_5.56x45_ball")
SWEP.Primary.RPM			= 200						// This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 8						// Size of a clip
SWEP.Primary.DefaultClip		= 8
SWEP.Primary.ConeSpray			= 2.0					// Hip fire accuracy
SWEP.Primary.ConeIncrement		= .7					// Rate of innacuracy
SWEP.Primary.ConeMax			= 3.0					// Maximum Innacuracy
SWEP.Primary.ConeDecrement		= 1.1					// Rate of accuracy
SWEP.Primary.KickUp			= 1					// Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0					// Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.1					// Maximum up recoil (stock)
SWEP.Primary.Automatic			= false						// Automatic/Semi Auto
SWEP.Primary.Ammo			= "XBowBolt"

SWEP.Secondary.ClipSize			= 0						// Size of a clip
SWEP.Secondary.DefaultClip		= 0						// Default number of bullets in a clip
SWEP.Secondary.Automatic		= false						// Automatic/Semi Auto
SWEP.Secondary.Ammo			= ""
SWEP.Secondary.IronFOV			= 65						// How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}						// The starting firemode
SWEP.data.ironsights			= 1

SWEP.SightsPos = Vector(-3.887, 0, 1.76)
SWEP.SightsAng = Vector(0, 3.06, 0)
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-5.299, 20.017, -5.953)

SWEP.Offset = {
Pos = {
Up = -1.1,
Right = 1.0,
Forward = -3.0,
},
Ang = {
Up = 0,
Right = 1.5,
Forward = 0,
}
}

function SWEP:DrawWorldModel( )
local hand, offset, rotate

if not IsValid( self.Owner ) then
self:DrawModel( )
return
end

if not self.Hand then
self.Hand = self.Owner:LookupAttachment( "anim_attachment_rh" )
end

hand = self.Owner:GetAttachment( self.Hand )

if not hand then
self:DrawModel( )
return
end

offset = hand.Ang:Right( ) * self.Offset.Pos.Right + hand.Ang:Forward( ) * self.Offset.Pos.Forward + hand.Ang:Up( ) * self.Offset.Pos.Up

hand.Ang:RotateAroundAxis( hand.Ang:Right( ), self.Offset.Ang.Right )
hand.Ang:RotateAroundAxis( hand.Ang:Forward( ), self.Offset.Ang.Forward )
hand.Ang:RotateAroundAxis( hand.Ang:Up( ), self.Offset.Ang.Up )

self:SetRenderOrigin( hand.Pos + offset )
self:SetRenderAngles( hand.Ang )

self:DrawModel( )
end