// Variables that are used on both client and server
SWEP.Category				= "Haven's Sweps"
SWEP.Author				= "Haven"
SWEP.Contact				= "Haven"
SWEP.Purpose				= "Close Quarters Combat"
SWEP.Instructions			= " "
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment		= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.DrawCrosshair			= false

SWEP.ViewModelFOV			= 75
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_pist_dgal50.mdl"
SWEP.WorldModel				= "models/weapons/w_pist_dgal50.mdl"
SWEP.Base 				= "gdcw2_base_assault2"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.Item = "item_dgal50"
SWEP.Primary.Sound			= Sound("weapons/dgal50/deagle-1_steveo.wav")
SWEP.Primary.Round			= ("gdcwa_12.7×33mm_kok")
SWEP.Primary.RPM			= 250					// This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 7						// Size of a clip
SWEP.Primary.DefaultClip		= 49
SWEP.Primary.ConeSpray			= 2.2					// Hip fire accuracy
SWEP.Primary.ConeIncrement		= 1.2					// Rate of innacuracy
SWEP.Primary.ConeMax			= 8.0					// Maximum Innacuracy
SWEP.Primary.ConeDecrement		= 0.8					// Rate of accuracy
SWEP.Primary.KickUp			= 1.8				// Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0					// Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 1.6				// Maximum up recoil (stock)
SWEP.Primary.Automatic			= false						// Automatic/Semi Auto
SWEP.Primary.Ammo			= "357"

SWEP.Secondary.ClipSize			= 1						// Size of a clip
SWEP.Secondary.DefaultClip		= 1						// Default number of bullets in a clip
SWEP.Secondary.Automatic		= false						// Automatic/Semi Auto
SWEP.Secondary.Ammo			= ""
SWEP.Secondary.IronFOV			= 70						// How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}						// The starting firemode
SWEP.data.ironsights			= 1

SWEP.IronSightsPos = Vector(-3.85, -4.853, 1.679)
SWEP.IronSightsAng = Vector(0.2, 2.2, 0)
SWEP.SightsPos = Vector(-3.85, -4.853, 1.679)
SWEP.SightsAng = Vector(0.2, 2.2, 0)
SWEP.RunSightsPos = Vector(1.559, -1.757, 2.86)
SWEP.RunSightsAng = Vector(-31.143, 37.756, -10.762)
SWEP.Offset = {
Pos = {
Up = -0.6,
Right = 1.0,
Forward = -2.5,
},
Ang = {
Up = 6,
Right = 6.5,
Forward = 0,
}
}


function SWEP:Initialize()
	if self:GetOwner():IsValid() then
		self:Update()
	end
	util.PrecacheSound(self.Primary.Sound)
	self.Reloadaftershoot = 0 				-- Can't reload when firing
	if !self.Owner:IsNPC() then
		self:SetWeaponHoldType("revolver")                          	-- Hold type style ("ar2" "pistol" "shotgun" "rpg" "normal" "melee" "grenade" "smg")
	end
	if SERVER and self.Owner:IsNPC() then
		self:SetWeaponHoldType("revolver")                          	-- Hold type style ("ar2" "pistol" "shotgun" "rpg" "normal" "melee" "grenade" "smg")
		self:SetNPCMinBurst(3)			
		self:SetNPCMaxBurst(10)			// None of this really matters but you need it here anyway
		self:SetNPCFireRate(1/(self.Primary.RPM/60))	
		self:SetCurrentWeaponProficiency( WEAPON_PROFICIENCY_VERY_GOOD )
	end
end



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

function SWEP:IronSight()

	if !self.Owner:IsNPC() then
	if self.ResetSights and CurTime() >= self.ResetSights then
	self.ResetSights = nil
	self:SendWeaponAnim(ACT_VM_IDLE)
	end end

	if self.Owner:KeyDown(IN_USE) and self:CanPrimaryAttack() || self.Owner:KeyDown(IN_SPEED) then		// If you hold E and you can shoot then
	self.Weapon:SetNextPrimaryFire(CurTime()+0.3)				// Make it so you can't shoot for another quarter second
	self:SetWeaponHoldType("normal")                          			// Hold type styles; ar2 pistol shotgun rpg normal melee grenade smg
	self.IronSightsPos = self.RunSightsPos					// Hold it down
	self.IronSightsAng = self.RunSightsAng					// Hold it down
	self:SetIronsights(true, self.Owner)					// Set the ironsight true
	self.Owner:SetFOV( 0, 0.3 )
	end								

	if self.Owner:KeyReleased(IN_USE) || self.Owner:KeyReleased (IN_SPEED) then	// If you release E then
	self:SetWeaponHoldType("revolver")                          				// Hold type styles; ar2 pistol shotgun rpg normal melee grenade smg slam fist melee2 passive knife
	self:SetIronsights(false, self.Owner)					// Set the ironsight true
	self.Owner:SetFOV( 0, 0.3 )
	end								// Shoulder the gun

	if self.Owner:KeyPressed(IN_WALK) then		// If you are holding ALT (walking slow) then
	self:SetWeaponHoldType("revolver")                      	// Hold type styles; ar2 pistol shotgun rpg normal melee grenade smg slam fist melee2 passive knife
	end					// Hold it at the hip (NO RUSSIAN WOOOT!)

	if !self.Owner:KeyDown(IN_USE) and !self.Owner:KeyDown(IN_SPEED) then
	-- If the key E (Use Key) is not pressed, then

		if self.Owner:KeyPressed(IN_ATTACK2) then
				if !self.Owner:KeyDown(IN_DUCK) and !self.Owner:KeyDown(IN_WALK) then
				self:SetWeaponHoldType("revolver") else self:SetWeaponHoldType("revolver")  
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
		self:SetWeaponHoldType("revolver")                      // Hold type styles; ar2 pistol shotgun rpg normal melee grenade smg slam fist melee2 passive knife

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

function SWEP:PrimaryAttack()
	if self:CanPrimaryAttack() then
		self:ResidentEvilBullet(self.Primary.Damage,self.Primary.Recoil,self.Primary.NumShots,self.Primary.Cone)
		self.Weapon:EmitSound(self.Primary.Sound,100,math.random(98,105))
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

function SWEP:Update()
	if SERVER then
		local pwr = self:GetOwner().RE2Data["Upgrades"][self.Item].pwrlvl
		local acc = self:GetOwner().RE2Data["Upgrades"][self.Item].acclvl
		local clip = self:GetOwner().RE2Data["Upgrades"][self.Item].clplvl
		local speed = self:GetOwner().RE2Data["Upgrades"][self.Item].fislvl
		local res = self:GetOwner().RE2Data["Upgrades"][self.Item].reslvl
		self.Primary.Damage = GAMEMODE.Weapons[self.Item].UpGrades.Power[pwr].Level
		self.Primary.Cone = GAMEMODE.Weapons[self.Item].UpGrades.Accuracy[acc].Level
		self.Primary.ClipSize = GAMEMODE.Weapons[self.Item].UpGrades.ClipSize[clip].Level
		self.Primary.RPM = self.Primary.RPM + GAMEMODE.Weapons[self.Item].UpGrades.FiringSpeed[speed].Level
		self.ReloadSpeed = GAMEMODE.Weapons[self.Item].UpGrades.ReloadSpeed[res].Level
	else
		if Upgrades[self.Item] != nil then
			local pwr = Upgrades[self.Item].pwrlvl
			local acc =  Upgrades[self.Item].acclvl
			local clip =  Upgrades[self.Item].clplvl
			local speed =  Upgrades[self.Item].fislvl
			local res =  Upgrades[self.Item].reslvl
			self.Primary.Damage = GAMEMODE.Weapons[self.Item].UpGrades.Power[pwr].Level
			self.Primary.Cone = GAMEMODE.Weapons[self.Item].UpGrades.Accuracy[acc].Level
			self.Primary.ClipSize = GAMEMODE.Weapons[self.Item].UpGrades.ClipSize[clip].Level
			self.Primary.RPM = self.Primary.RPM + GAMEMODE.Weapons[self.Item].UpGrades.FiringSpeed[speed].Level
			self.ReloadSpeed = GAMEMODE.Weapons[self.Item].UpGrades.ReloadSpeed[res].Level
		end
	end


	return true
end