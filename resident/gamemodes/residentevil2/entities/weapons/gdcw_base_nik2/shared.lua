// Variables that are used on both client and server
SWEP.Category				= "Generic Default's Weapons"
SWEP.Author				= "Generic Default"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions			= ""
SWEP.MuzzleAttachment			= "1" 		// Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment		= "2" 		// Should be "2" for CSS models or "1" for hl2 models
SWEP.DrawCrosshair			= false		// Hell no, crosshairs r 4 nubz!
SWEP.ViewModelFOV			= 65		// How big the gun will look
SWEP.ViewModelFlip			= true		// True for CSS models, False for HL2 models


SWEP.Spawnable				= false
SWEP.AdminSpawnable			= false

SWEP.Primary.Sound 			= Sound("")				// Sound of the gun
SWEP.Primary.Round 			= ("")					// What kind of bullet?
SWEP.Primary.Cone			= 0.0					// This is the variable
SWEP.Primary.ConeSpray			= 2.0					// Hip fire accuracy
SWEP.Primary.ConeIncrement		= 1.0					// Rate of innacuracy
SWEP.Primary.ConeMax			= 4.0					// Maximum Innacuracy
SWEP.Primary.ConeDecrement		= 0.1					// Rate of accuracy
SWEP.Primary.RPM			= 0					// This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 0					// Size of a clip
SWEP.Primary.DefaultClip		= 0					// Default number of bullets in a clip
SWEP.Primary.KickUp			= 0					// Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0					// Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0					// Maximum side recoil (koolaid)
SWEP.Primary.Automatic			= true					// Automatic/Semi Auto
SWEP.Primary.Ammo			= "none"				// What kind of ammo

SWEP.Secondary.ClipSize			= 0					// Size of a clip
SWEP.Secondary.DefaultClip		= 0					// Default number of bullets in a clip
SWEP.Secondary.Automatic		= false					// Automatic/Semi Auto
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.IronFOV			= 0					// How much you 'zoom' in. Less is more! 

SWEP.data 				= {}					-- The starting firemode
SWEP.data.ironsights			= 1

SWEP.Single				= nil
SWEP.IronSightsPos = Vector (2.4537, 1.0923, 0.2696)
SWEP.IronSightsAng = Vector (0.0186, -0.0547, 0)

function SWEP:Initialize()

	util.PrecacheSound(self.Primary.Sound)
	self.Reloadaftershoot = 0 				-- Can't reload when firing
	if !self.Owner:IsNPC() then
		self:SetWeaponHoldType("ar2")                          	-- Hold type style ("ar2" "pistol" "shotgun" "rpg" "normal" "melee" "grenade" "smg")
	end
	if SERVER and self.Owner:IsNPC() then
		self:SetWeaponHoldType("ar2")                          	-- Hold type style ("ar2" "pistol" "shotgun" "rpg" "normal" "melee" "grenade" "smg")
		self:SetNPCMinBurst(3)			
		self:SetNPCMaxBurst(10)			// None of this really matters but you need it here anyway
		self:SetNPCFireRate(1/(self.Primary.RPM/60))	
		self:SetCurrentWeaponProficiency( WEAPON_PROFICIENCY_VERY_GOOD )
	end
end

function SWEP:Deploy()

if game.SinglePlayer() then self.Single=true
else
self.Single=false
end
	self:SetWeaponHoldType("ar2")                          	// Hold type styles; ar2 pistol shotgun rpg normal melee grenade smg slam fist melee2 passive knife
	self:SetIronsights(false, self.Owner)					// Set the ironsight false
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	if !self.Owner:IsNPC() then self.ResetSights = CurTime() + self.Owner:GetViewModel():SequenceDuration() end
	return true
	end


function SWEP:Precache()
	util.PrecacheSound(self.Primary.Sound)
	util.PrecacheSound("Buttons.snd14")
end


function SWEP:PrimaryAttack()
	if self:CanPrimaryAttack() then
		self:FireRocket()
		self.Weapon:EmitSound(self.Primary.Sound)
		self.Weapon:TakePrimaryAmmo(1)
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		local fx 		= EffectData()
		fx:SetEntity(self.Weapon)
		fx:SetOrigin(self.Owner:GetShootPos())
		fx:SetNormal(self.Owner:GetAimVector())
		fx:SetAttachment(self.MuzzleAttachment)
		util.Effect("gdcw_muzzle",fx)
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		self.Owner:MuzzleFlash()
		self.Weapon:SetNextPrimaryFire(CurTime()+1/(self.Primary.RPM/60))

	end
end

function SWEP:FireRocket() 

	if (self:GetIronsights() == true) and self.Owner:KeyDown(IN_ATTACK2) then
	aim = self.Owner:GetAimVector()+(VectorRand()*self.Primary.Cone/360)
	else 
	//////aim = self.Owner:GetAimVector()+Vector(math.Rand(-0.02,0.02), math.Rand(-0.02,0.02),math.Rand(-0.02,0.02))
	aim = self.Owner:GetAimVector()+(VectorRand()*math.Rand(0,0.04))
	end

	if !self.Owner:IsNPC() then
	pos = self.Owner:GetShootPos()
	else
	pos = self.Owner:GetShootPos()+self.Owner:GetAimVector()*50
	end

	if SERVER then
		local bullet = ents.Create(self.Primary.Round)
		if !bullet:IsValid() then return false end
		bullet:SetAngles(aim:Angle()+Angle(90,0,0))
		bullet:SetPos(pos)
		bullet:SetOwner(self.Owner)
		bullet:Spawn()
		bullet:Activate()
		end

						// RECOIL FOR SINGLEPLAYER IS RIGHT BELOW THESE WORDS
		if SERVER and (self.Single) and !self.Owner:IsNPC() then
		local anglo = Angle(math.Rand(-self.Primary.KickDown,self.Primary.KickUp), math.Rand(-self.Primary.KickHorizontal,self.Primary.KickHorizontal), 0)
		self.Owner:ViewPunch(anglo)
		angle = self.Owner:EyeAngles() - anglo
		self.Owner:SetEyeAngles(angle)
		end

	if (!self.Single)  and !self.Owner:IsNPC() then		// RECOIL FOR MULTIPLAYER IS RIGHT BELOW THESE WORDS
	self.Primary.Cone = math.Clamp(self.Primary.Cone+self.Primary.ConeIncrement,0,self.Primary.ConeMax)
	local anglo = Angle(math.Rand(-self.Primary.KickDown,self.Primary.KickUp), math.Rand(-self.Primary.KickHorizontal,self.Primary.KickHorizontal), 0)
	self.Owner:ViewPunch(anglo)
	end
end


function SWEP:SecondaryAttack()
	return false
end

function SWEP:Reload()

	self.Weapon:DefaultReload(ACT_VM_RELOAD) 
	if !self.Owner:IsNPC() then
	self.ResetSights = CurTime() + self.Owner:GetViewModel():SequenceDuration() end


	if ( self.Weapon:Clip1() < self.Primary.ClipSize ) and !self.Owner:IsNPC() then
	-- When the current clip < full clip and the rest of your ammo > 0, then

		self.Owner:SetFOV( 0, 0.3 )
		-- Zoom = 0

		self:SetIronsights(false)
		-- Set the ironsight to false

end
	
end

/*---------------------------------------------------------
IronSight
---------------------------------------------------------*/
function SWEP:IronSight()

	if !self.Owner:IsNPC() then
	if self.ResetSights and CurTime() >= self.ResetSights then
	self.ResetSights = nil
	self:SendWeaponAnim(ACT_VM_IDLE)
	end end

	if self.Owner:KeyDown(IN_USE) and self:CanPrimaryAttack() || self.Owner:KeyDown(IN_SPEED) then		// If you hold E and you can shoot then
	self.Weapon:SetNextPrimaryFire(CurTime()+0.3)				// Make it so you can't shoot for another quarter second
	self:SetWeaponHoldType("passive")                          			// Hold type styles; ar2 pistol shotgun rpg normal melee grenade smg
	self.IronSightsPos = self.RunSightsPos					// Hold it down
	self.IronSightsAng = self.RunSightsAng					// Hold it down
	self:SetIronsights(true, self.Owner)					// Set the ironsight true
	self.Owner:SetFOV( 0, 0.3 )
	end								

	if self.Owner:KeyReleased(IN_USE) || self.Owner:KeyReleased (IN_SPEED) then	// If you release E then
	self:SetWeaponHoldType("ar2")                          				// Hold type styles; ar2 pistol shotgun rpg normal melee grenade smg slam fist melee2 passive knife
	self:SetIronsights(false, self.Owner)					// Set the ironsight true
	self.Owner:SetFOV( 0, 0.3 )
	end								// Shoulder the gun

	if self.Owner:KeyPressed(IN_WALK) then		// If you are holding ALT (walking slow) then
	self:SetWeaponHoldType("shotgun")                      	// Hold type styles; ar2 pistol shotgun rpg normal melee grenade smg slam fist melee2 passive knife
	end					// Hold it at the hip (NO RUSSIAN WOOOT!)

	if !self.Owner:KeyDown(IN_USE) and !self.Owner:KeyDown(IN_SPEED) then
	-- If the key E (Use Key) is not pressed, then

		if self.Owner:KeyPressed(IN_ATTACK2) then
				if !self.Owner:KeyDown(IN_DUCK) and !self.Owner:KeyDown(IN_WALK) then
				self:SetWeaponHoldType("rpg") else self:SetWeaponHoldType("ar2")  
				end  
			self.Owner:SetFOV( self.Secondary.IronFOV, 0.3 )
			self.IronSightsPos = self.SightsPos					// Bring it up
			self.IronSightsAng = self.SightsAng					// Bring it up
			self:SetIronsights(true, self.Owner)
			-- Set the ironsight true

			if CLIENT then return end
 		end
	end

	if self.Owner:KeyReleased(IN_ATTACK2) and !self.Owner:KeyDown(IN_USE) and !self.Owner:KeyDown(IN_SPEED) then
	-- If the right click is released, then
		self:SetWeaponHoldType("ar2")                      // Hold type styles; ar2 pistol shotgun rpg normal melee grenade smg slam fist melee2 passive knife

		self.Owner:SetFOV( 0, 0.3 )

		self:SetIronsights(false, self.Owner)
		-- Set the ironsight false

		if CLIENT then return end
	end

		if self.Owner:KeyDown(IN_ATTACK2) and !self.Owner:KeyDown(IN_USE) and !self.Owner:KeyDown(IN_SPEED) then
		self.SwayScale 	= 0.05
		self.BobScale 	= 0.05
		else
		self.SwayScale 	= 1.0
		self.BobScale 	= 1.0
		end
end

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function SWEP:Think()

self:IronSight()

	if !self.Owner:IsNPC() then
	if self.Idle and CurTime() >= self.Idle then
	self.Idle = nil
	self:SendWeaponAnim(ACT_VM_IDLE)
	end end

	if	(self.Primary.Cone>0.09)	then
	self.Primary.Cone = self.Primary.Cone - self.Primary.ConeDecrement	end

end

/*---------------------------------------------------------
GetViewModelPosition
---------------------------------------------------------*/
local IRONSIGHT_TIME = 0.3
-- Time to enter in the ironsight mod

function SWEP:GetViewModelPosition(pos, ang)

	if (not self.IronSightsPos) then return pos, ang end

	local bIron = self.Weapon:GetNWBool("Ironsights")

	if (bIron != self.bLastIron) then
		self.bLastIron = bIron
		self.fIronTime = CurTime()

	end

	local fIronTime = self.fIronTime or 0

	if (not bIron and fIronTime < CurTime() - IRONSIGHT_TIME) then
		return pos, ang
	end

	local Mul = 1.0

	if (fIronTime > CurTime() - IRONSIGHT_TIME) then
		Mul = math.Clamp((CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1)

		if not bIron then Mul = 1 - Mul end
	end

	local Offset	= self.IronSightsPos

	if (self.IronSightsAng) then
		ang = ang * 1
		ang:RotateAroundAxis(ang:Right(), 		self.IronSightsAng.x * Mul)
		ang:RotateAroundAxis(ang:Up(), 		self.IronSightsAng.y * Mul)
		ang:RotateAroundAxis(ang:Forward(), 	self.IronSightsAng.z * Mul)
	end

	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul

	return pos, ang
end

/*---------------------------------------------------------
SetIronsights
---------------------------------------------------------*/
function SWEP:SetIronsights(b)

	self.Weapon:SetNetworkedBool("Ironsights", b)
end

function SWEP:GetIronsights()

	return self.Weapon:GetNWBool("Ironsights")
end

---------------------------------------------------------
--------------------Firemodes------------------------
---------------------------------------------------------
SWEP.FireModes = {}

---------------------------------------
-- Firemode: Semi Automatic --
---------------------------------------
SWEP.FireModes.Semi = {}
SWEP.FireModes.Semi.FireFunction = function(self)

	self:BaseAttack()

end

SWEP.FireModes.Semi.InitFunction = function(self)

	self.Primary.Automatic = false
	self.Primary.Delay = 60/self.SemiRPM
	
	if CLIENT then
		self.FireModeDrawTable.x = 0.037*surface.ScreenWidth()
		self.FireModeDrawTable.y = 0.912*surface.ScreenHeight()
	end

end

-- We don't need to do anything for these revert functions, as self.Primary.Automatic, self.Primary.Delay, self.FireModeDrawTable.x, and self.FireModeDrawTable.y are set in every init function
SWEP.FireModes.Semi.RevertFunction = function(self)

	return

end

SWEP.FireModes.Semi.HUDDrawFunction = function(self)

	surface.SetFont("rg_firemode")
	surface.SetTextPos(self.FireModeDrawTable.x,self.FireModeDrawTable.y)
	surface.SetTextColor(255,220,0,200)
	surface.DrawText("p") -- "p" corresponds to the hl2 pistol ammo icon in this font

end

---------------------------------------
-- Firemode: Fully Automatic --
---------------------------------------
SWEP.FireModes.Auto = {}
SWEP.FireModes.Auto.FireFunction = function(self)

	self:BaseAttack()

end

SWEP.FireModes.Auto.InitFunction = function(self)

	self.Primary.Automatic = true
	self.Primary.Delay = 60/self.AutoRPM
	
	if CLIENT then
		self.FireModeDrawTable.x = 0.037*surface.ScreenWidth()
		self.FireModeDrawTable.y = 0.912*surface.ScreenHeight()
	end
	
end

SWEP.FireModes.Auto.RevertFunction = function(self)

	return

end

SWEP.FireModes.Auto.HUDDrawFunction = function(self)

	surface.SetFont("rg_firemode")
	surface.SetTextPos(self.FireModeDrawTable.x,self.FireModeDrawTable.y)
	surface.SetTextColor(255,220,0,200)
	surface.DrawText("ppppp")

end

-------------------------------------------
-- Firemode: Three-Round Burst --
-------------------------------------------
SWEP.FireModes.Burst = {}
SWEP.FireModes.Burst.FireFunction = function(self)

	local clip = self.Weapon:Clip1()
	if not self:CanFire(clip) then return end

	self:BaseAttack()
	timer.Simple(self.BurstDelay, self.BaseAttack, self)
	
	if clip > 1 then
		timer.Simple(2*self.BurstDelay, self.BaseAttack, self)
	end

end

SWEP.FireModes.Burst.InitFunction = function(self)

	self.Primary.Automatic = true
	self.Primary.Delay = 60/self.SemiRPM + 3*self.BurstDelay -- Burst delay is derived from self.BurstRPM
	
	if CLIENT then
		self.FireModeDrawTable.x = 0.037*surface.ScreenWidth()
		self.FireModeDrawTable.y = 0.912*surface.ScreenHeight()
	end

end

SWEP.FireModes.Burst.RevertFunction = function(self)

	return

end

SWEP.FireModes.Burst.HUDDrawFunction = function(self)

	surface.SetFont("rg_firemode")
	surface.SetTextPos(self.FireModeDrawTable.x,self.FireModeDrawTable.y)
	surface.SetTextColor(255,220,0,200)
	surface.DrawText("ppp")

end

