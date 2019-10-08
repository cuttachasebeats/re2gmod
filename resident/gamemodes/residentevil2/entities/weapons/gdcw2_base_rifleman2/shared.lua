// Variables that are used on both client and server
SWEP.Category				= "Generic Default's Weapons"
SWEP.Author				= "Generic Default"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.DrawCrosshair			= false	
SWEP.ViewModelFOV			= 65
SWEP.ViewModelFlip			= true
SWEP.ReloadSpeed = 1
SWEP.reloadinfo = 1
SWEP.Primary.Recoil = 0.2

SWEP.Spawnable				= false
SWEP.AdminSpawnable			= false
SWEP.Item = "item_9mmhandgun"

SWEP.Primary.Sound 			= Sound("")				// Sound of the gun
SWEP.Primary.Round 			= ("")					// What kind of bullet?
SWEP.Primary.RPM			= 0					// This is in Rounds Per Minute
SWEP.Primary.Cone			= 0.0					// This is the variable
SWEP.Primary.ConeSpray			= 2.0					// Hip fire accuracy
SWEP.Primary.ConeIncrement		= 1.0					// Rate of innacuracy
SWEP.Primary.ConeMax			= 4.0					// Maximum Innacuracy
SWEP.Primary.ConeDecrement		= 0.1					// Rate of accuracy
SWEP.Primary.ClipSize			= 0					// Size of a clip
SWEP.Primary.DefaultClip		= 0					// Default number of bullets in a clip
SWEP.Primary.KickUp			= 0					// Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0					// Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0					// Maximum up recoil (stock)
SWEP.Primary.Automatic			= true					// Automatic/Semi Auto
SWEP.Primary.Ammo			= "none"				// What kind of ammo

SWEP.Secondary.ClipSize			= 0					// Size of a clip
SWEP.Secondary.DefaultClip		= 0					// Default number of bullets in a clip
SWEP.Secondary.Automatic		= false					// Automatic/Semi Auto
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.ScopeZoom		= 0
SWEP.Secondary.UseACOG			= false	
SWEP.Secondary.UseMilDot		= false		
SWEP.Secondary.UseSVD			= false	
SWEP.Secondary.UseParabolic		= false	
SWEP.Secondary.UseElcan			= false
SWEP.Secondary.UseGreenDuplex		= false	

SWEP.Secondary.UseRangefinder		= false	

SWEP.data 				= {}					-- The starting firemode
SWEP.data.ironsights			= 1
SWEP.Single				= nil
SWEP.ScopeScale 			= 0.5
SWEP.ReticleScale 			= 0.5
SWEP.Velocity				= 850
SWEP.IronSightsPos = Vector (2.4537, 1.0923, 0.2696)
SWEP.IronSightsAng = Vector (0.0186, -0.0547, 0)

function SWEP:Initialize()
	util.PrecacheSound(self.Primary.Sound)
	if self:GetOwner():IsValid() then
		self:Update()
	end
	if CLIENT then
	
		-- We need to get these so we can scale everything to the player's current resolution.
		local iScreenWidth = surface.ScreenWidth()
		local iScreenHeight = surface.ScreenHeight()
		
		-- The following code is only slightly riped off from Night Eagle
		-- These tables are used to draw things like scopes and crosshairs to the HUD.

		self.ScopeTable = {}
		self.ScopeTable.l = iScreenHeight*self.ScopeScale
		self.ScopeTable.x1 = 0.5*(iScreenWidth + self.ScopeTable.l)
		self.ScopeTable.y1 = 0.5*(iScreenHeight - self.ScopeTable.l)
		self.ScopeTable.x2 = self.ScopeTable.x1
		self.ScopeTable.y2 = 0.5*(iScreenHeight + self.ScopeTable.l)
		self.ScopeTable.x3 = 0.5*(iScreenWidth - self.ScopeTable.l)
		self.ScopeTable.y3 = self.ScopeTable.y2
		self.ScopeTable.x4 = self.ScopeTable.x3
		self.ScopeTable.y4 = self.ScopeTable.y1
		self.ScopeTable.l = (iScreenHeight + 1)*self.ScopeScale -- I don't know why this works, but it does.

		self.QuadTable = {}
		self.QuadTable.x1 = 0
		self.QuadTable.y1 = 0
		self.QuadTable.w1 = iScreenWidth
		self.QuadTable.h1 = 0.5*iScreenHeight - self.ScopeTable.l
		self.QuadTable.x2 = 0
		self.QuadTable.y2 = 0.5*iScreenHeight + self.ScopeTable.l
		self.QuadTable.w2 = self.QuadTable.w1
		self.QuadTable.h2 = self.QuadTable.h1
		self.QuadTable.x3 = 0
		self.QuadTable.y3 = 0
		self.QuadTable.w3 = 0.5*iScreenWidth - self.ScopeTable.l
		self.QuadTable.h3 = iScreenHeight
		self.QuadTable.x4 = 0.5*iScreenWidth + self.ScopeTable.l
		self.QuadTable.y4 = 0
		self.QuadTable.w4 = self.QuadTable.w3
		self.QuadTable.h4 = self.QuadTable.h3

		self.LensTable = {}
		self.LensTable.x = self.QuadTable.w3
		self.LensTable.y = self.QuadTable.h1
		self.LensTable.w = 2*self.ScopeTable.l
		self.LensTable.h = 2*self.ScopeTable.l

		self.ReticleTable = {}
		self.ReticleTable.wdivider = 3.125
		self.ReticleTable.hdivider = 1.7579/self.ReticleScale		// Draws the texture at 512 when the resolution is 1600x900
		self.ReticleTable.x = (iScreenWidth/2)-((iScreenHeight/self.ReticleTable.hdivider)/2)
		self.ReticleTable.y = (iScreenHeight/2)-((iScreenHeight/self.ReticleTable.hdivider)/2)
		self.ReticleTable.w = iScreenHeight/self.ReticleTable.hdivider
		self.ReticleTable.h = iScreenHeight/self.ReticleTable.hdivider

		self.FilterTable = {}
		self.FilterTable.wdivider = 3.125
		self.FilterTable.hdivider = 1.7579/1.35	
		self.FilterTable.x = (iScreenWidth/2)-((iScreenHeight/self.FilterTable.hdivider)/2)
		self.FilterTable.y = (iScreenHeight/2)-((iScreenHeight/self.FilterTable.hdivider)/2)
		self.FilterTable.w = iScreenHeight/self.FilterTable.hdivider
		self.FilterTable.h = iScreenHeight/self.FilterTable.hdivider

		
	end
	if !self.Owner:IsNPC() then
		self:SetWeaponHoldType("ar2")                          	-- Hold type style ("ar2" "pistol" "shotgun" "rpg" "normal" "melee" "grenade" "smg")
	end
	if SERVER then
		self:SetWeaponHoldType("ar2")                          	-- Hold type style ("ar2" "pistol" "shotgun" "rpg" "normal" "melee" "grenade" "smg")
		self:SetNPCMinBurst(3)
		self:SetNPCMaxBurst(10)
		self:SetNPCFireRate(1)
		self:SetCurrentWeaponProficiency( WEAPON_PROFICIENCY_VERY_GOOD )
	end
end

function SWEP:Deploy()
self:Update()
if game.SinglePlayer() then self.Single=true
else
self.Single=false
end
	self:SetWeaponHoldType("ar2")                          	// Hold type styles; ar2 pistol shotgun rpg normal melee grenade smg slam fist melee2 passive knife
	self:SetIronsights(false, self.Owner)					// Set the ironsight false
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
     	return true
	end

function SWEP:Precache()
	util.PrecacheSound(self.Primary.Sound)
	util.PrecacheSound("Buttons.snd14")
end


function SWEP:PrimaryAttack()
	if self:CanPrimaryAttack() then
		self:ResidentEvilBullet(self.Primary.Damage,self.Primary.Recoil,self.Primary.NumShots,self.Primary.Cone)
		self.Weapon:EmitSound(self.Primary.Sound,100,math.random(90,110))
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
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration() + self.ReloadSpeed end

	if ( self.Weapon:Clip1() < self.Primary.ClipSize ) and !self.Owner:IsNPC() then
	-- When the current clip < full clip and the rest of your ammo > 0, then

		self.Owner:SetFOV( 0, 0.3 )
		-- Zoom = 0

		self:SetIronsights(false)
		-- Set the ironsight to false

		if CLIENT then return end
		self.Owner:DrawViewModel(true)
end
	
end

/*---------------------------------------------------------
IronSight
---------------------------------------------------------*/
function SWEP:IronSight()

	if (self:GetIronsights() == true) and self.Owner:KeyPressed(IN_SCORE) then	// If you hold E and crouch then
	self.NVG = !self.NVG						// Toggle Night Vision
	end

	if self.Owner:KeyDown(IN_USE) and self:CanPrimaryAttack() and !self.Owner:KeyDown(IN_ATTACK2) || (self.Owner:KeyDown(IN_SPEED) and !self.Owner:KeyDown(IN_ATTACK2)) then		// If you hold E and you can shoot then
	self.Owner:SetFOV( 0, 0.2 )
	self.Weapon:SetNextPrimaryFire(CurTime()+0.3)				// Make it so you can't shoot for another quarter second
	self:SetWeaponHoldType("passive")                          			// Hold type styles; ar2 pistol shotgun rpg normal melee grenade smg
	self.IronSightsPos = self.RunSightsPos					// Hold it down
	self.IronSightsAng = self.RunSightsAng					// Hold it down
	self:SetIronsights(true, self.Owner)					// Set the ironsight true
	end	
							
	if self.Owner:KeyDown(IN_USE) || self.Owner:KeyDown(IN_SPEED) then		// If you hold E or run then
	self.Weapon:SetNextPrimaryFire(CurTime()+0.3)				// Make it so you can't shoot for another quarter second
	end								// Lower the gun

	if self.Owner:KeyReleased(IN_USE) || self.Owner:KeyReleased (IN_SPEED) then	// If you release E then
	self:SetWeaponHoldType("ar2")                          				// Hold type styles; ar2 pistol shotgun rpg normal melee grenade smg slam fist melee2 passive knife
	self:SetIronsights(false, self.Owner)					// Set the ironsight true
	end								// Shoulder the gun

	if self.Owner:KeyDown(IN_WALK) then	// If you are holding ALT (walking slow) then
	self:SetWeaponHoldType("shotgun")                          	// Hold type styles; ar2 pistol shotgun rpg normal melee grenade smg slam fist melee2 passive knife
	end					// Hold it at the hip (NO RUSSIAN WOOOT!)

	if self.Owner:KeyPressed(IN_SPEED) || self.Owner:KeyPressed(IN_USE) then	// If you run then
		self.Owner:SetFOV( 0, 0.2 )
		if CLIENT then return end
		self.Owner:DrawViewModel(true)
		end	

		if self.Owner:KeyPressed(IN_ATTACK2) and !self.Owner:KeyDown(IN_USE) and !self.Owner:KeyDown(IN_SPEED) then
			self.Owner:SetFOV( 75/self.Secondary.ScopeZoom, 0.15 )
				if !self.Owner:KeyDown(IN_DUCK) and !self.Owner:KeyDown(IN_WALK) then
				self:SetWeaponHoldType("rpg") else self:SetWeaponHoldType("ar2")  
				end                         		
			self.IronSightsPos = self.SightsPos					// Bring it up
			self.IronSightsAng = self.SightsAng					// Bring it up
			self:SetIronsights(true, self.Owner)
			if CLIENT then return end
			self.Owner:DrawViewModel(false)
			end

	if (self.Owner:KeyReleased(IN_ATTACK2) || self.Owner:KeyDown(IN_SPEED)) and !self.Owner:KeyDown(IN_USE) and !self.Owner:KeyDown(IN_SPEED) then
		self:SetWeaponHoldType("ar2")
		self.Owner:SetFOV( 0, 0.2 )
		self:SetIronsights(false, self.Owner)
		-- Set the ironsight false
		if CLIENT then return end
		self.Owner:DrawViewModel(true)
		end

		if self.Owner:KeyDown(IN_ATTACK2) and !self.Owner:KeyDown(IN_USE) and !self.Owner:KeyDown(IN_SPEED) then
		self.SwayScale 	= 0.05
		self.BobScale 	= 0.05
		else
		self.SwayScale 	= 1.0
		self.BobScale 	= 1.0
		end
end

function SWEP:DrawHUD()


	if  self.Owner:KeyDown(IN_ATTACK2) and (self:GetIronsights() == true) and (!self.Owner:KeyDown(IN_SPEED) and !self.Owner:KeyDown(IN_USE)) then

			if self.Secondary.UseACOG then
			-- Draw the FAKE SCOPE THANG
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/gdcw_closedsight"))
			surface.DrawTexturedRect(self.LensTable.x, self.LensTable.y, self.LensTable.w, self.LensTable.h)

			-- Draw the CHEVRON
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/gdcw_acogchevron"))
			surface.DrawTexturedRect(self.ReticleTable.x, self.ReticleTable.y, self.ReticleTable.w, self.ReticleTable.h)

			-- Draw the ACOG REFERENCE LINES
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/gdcw_acogcross"))
			surface.DrawTexturedRect(self.ReticleTable.x, self.ReticleTable.y, self.ReticleTable.w, self.ReticleTable.h)
			end

			if self.Secondary.UseMilDot then
			-- Draw the MIL DOT SCOPE
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/gdcw_scopesight"))
			surface.DrawTexturedRect(self.LensTable.x, self.LensTable.y, self.LensTable.w, self.LensTable.h)
			end

			if self.Secondary.UseSVD then
			-- Draw the SVD SCOPE
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/gdcw_svdsight"))
			surface.DrawTexturedRect(self.LensTable.x, self.LensTable.y, self.LensTable.w, self.LensTable.h)
			end

			if self.Secondary.UseParabolic then
			-- Draw the PARABOLIC SCOPE
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/gdcw_parabolicsight"))
			surface.DrawTexturedRect(self.LensTable.x, self.LensTable.y, self.LensTable.w, self.LensTable.h)
			end

			if self.Secondary.UseElcan then
			-- Draw the RETICLE
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/gdcw_elcanreticle"))
			surface.DrawTexturedRect(self.ReticleTable.x, self.ReticleTable.y, self.ReticleTable.w, self.ReticleTable.h)
			
			-- Draw the ELCAN SCOPE
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/gdcw_elcansight"))
			surface.DrawTexturedRect(self.LensTable.x, self.LensTable.y, self.LensTable.w, self.LensTable.h)
			end

			if self.Secondary.UseGreenDuplex then
			-- Draw the RETICLE
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/gdcw_nvgilluminatedduplex"))
			surface.DrawTexturedRect(self.ReticleTable.x, self.ReticleTable.y, self.ReticleTable.w, self.ReticleTable.h)

			-- Draw the SCOPE
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/gdcw_closedsight"))
			surface.DrawTexturedRect(self.LensTable.x, self.LensTable.y, self.LensTable.w, self.LensTable.h)
			end

	if self.Secondary.UseRangefinder then
	local trace = {}
	trace.start = self.Owner:GetShootPos()
	trace.endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector()*60000		// Laser Rangefinder
	trace.filter = self.Owner
	local tr = util.TraceLine( trace )

	self.Range = self.Owner:GetShootPos():Distance(tr.HitPos)/52.5
	self.Time = math.Round(((self.Range)/self.Velocity)*100)/100
	self.Drop = math.Round((4.9*(self.Time^2))*100)/100

	draw.SimpleText( "RANGE " ..tostring(math.Round(self.Range)) .. "m","Default",ScrW() / 3, ScrH() * (44/60),Color(130,170,70,255))			//Range in meters
	draw.SimpleText( "TIME " ..tostring(self.Time) .. "s","Default",ScrW() / 3, ScrH() * (45/60),Color(170,130,70,255))					//Flight time in seconds
	draw.SimpleText( "DROP " ..tostring(self.Drop) .. "m","Default",ScrW() / 3, ScrH() * (46/60),Color(230,70,70,255))					//Drop in meters
	end

	end
end

function SWEP:AdjustMouseSensitivity()
     
	if self.Owner:KeyDown(IN_ATTACK2) then
        return (1/(self.Secondary.ScopeZoom/2))
    	else 
    	return 1
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

if (self.Owner:WaterLevel() > 2) then
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
//		self.Weapon:EmitSound("Default.ClipEmpty_Pistol")
		return false
	end

end

if (self.Owner:WaterLevel() > 2) then
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
//		self.Weapon:EmitSound("Default.ClipEmpty_Pistol")
		return false
	end

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

function SWEP:ResidentEvilBullet(dmg,recoil,numbul,cone)
	if self.Owner:Crouching() then cone = cone*.6 end
	numbul = numbul or 1
	cone = cone or 0.01
	local bullet = {}
	bullet.Num 		= numbul
	bullet.Src 		= self.Owner:GetShootPos()
	bullet.Dir 		= self.Owner:GetAimVector()
	bullet.Spread 	= Vector(cone,cone,0)
	bullet.Tracer	= 1
	bullet.Force	= 5
	bullet.Damage	= dmg
	self.Owner:FireBullets(bullet)
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	--self:GetOwner():RestartGesture(self:GetOwner():Weapon_TranslateActivity(ACT_HL2MP_GESTURE_RANGE_ATTACK))
	self.Owner:MuzzleFlash()
	if self.Owner:IsNPC() then return end
	if (game.SinglePlayer() && SERVER) || (!game.SinglePlayer() && CLIENT) then
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles(eyeang)
	end
end
