-- Variables that are used on both client and server
SWEP.Gun = ("weapon_executioner_re")					-- must be the name of your swep
SWEP.Category				= "Call Of Duty: Black Ops II"
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= "shotgun"
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "Executioner"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 1				-- Slot in the weapon selection menu
SWEP.SlotPos				= 3			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= false		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "pistol"		-- how others view you carrying the weapon

SWEP.ViewModelFOV			= 65
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_bo2_judge.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_pist_usp.mdl"	-- Weapon world model
SWEP.Base				= "weapon_basegun_re"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false
SWEP.Primary.Delay = .3

SWEP.Primary.Sound			= Sound("weapons/executioner/fire.wav")		-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 625			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 5		-- Size of a clip
SWEP.Primary.DefaultClip		= 0		-- Bullets you start with
SWEP.Primary.KickUp				= 1.9		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 1.7		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 1.7		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false	-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "357"

SWEP.Secondary.IronFOV			= 65		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1


SWEP.ShotgunFinish		= 0.8
SWEP.ShellTime		= 0.7


SWEP.Primary.NumShots	= 16		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 7	-- Base damage per bullet
SWEP.Primary.Spread		= .09	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .09 -- Ironsight accuracy, should be the same for shotguns

SWEP.CanBeSilenced		= false

SWEP.Item = "item_executioner"

function SWEP:Deploy()
	self:SetIronsights( false )
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	self:Update()
	self:EmitSound("weapons/stiker/deploy.wav",100,100)
	return true
end

function SWEP:Reload()
	if self:GetNWBool("reloading") then return false end
	if self:Clip1() >= self.Primary.ClipSize then return false end
	if self:Clip1() < self.Primary.ClipSize && self:GetOwner():GetAmmoCount(self.Primary.Ammo) > 0  then
		if self.Weapon:GetNetworkedBool( "Ironsights") == true then
			self.Primary.Cone = self.Primary.Cone / self.IMultiplier
			if SERVER then
				GAMEMODE:SetPlayerSpeed(self:GetOwner(),self:GetOwner():GetNWInt("Speed"),self:GetOwner():GetNWInt("Speed"))
			end
		end
		self:SetIronsights( false )
		self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
		self:SetNWBool("reloading", true)
		self.Weapon:SetVar("reloadtimer",CurTime() + self.ReloadSpeed)
		self.Owner:SetAnimation(ACT_HL2MP_GESTURE_RELOAD)
		self:SetNextPrimaryFire(CurTime() + self.ReloadSpeed)
		self:SetNextSecondaryFire(CurTime() + self.ReloadSpeed)
	end
end

function SWEP:Think()
	if self.Weapon:GetNetworkedBool("reloading") then
		if self.Weapon:GetVar("reloadtimer",0) < CurTime() then
			if self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
				self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
				self.Weapon:SetNetworkedBool("reloading",false)
				return
			end
			self.Weapon:SetVar("reloadtimer",CurTime() + self.ReloadSpeed)

			if self.Weapon.reloadinfo == nil then
				for i=0, 100 do
					if string.find(self.Weapon:GetAnimInfo(i).label, "reload") then
						self.Weapon.reloadinfo = self.Weapon:GetAnimInfo(i)
						break
					end
				end
			end
			self.Owner:GetViewModel():SequenceDuration()
			self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
			self.Weapon:SetClip1(self.Weapon:Clip1() + 1)
			self.Owner:RemoveAmmo(1, self.Primary.Ammo,false)

			if (self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0) && self.Weapon:GetVar("reloadtimer",0) < CurTime() then
				self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
				self.Weapon:SetVar("reloadtimer",CurTime() + self.ReloadSpeed * 2)
				self.Owner:GetViewModel():SetPlaybackRate(1.0)
			elseif self.Weapon:Clip1() < self.Primary.ClipSize then
				self:EmitSound('weapons/m3/Shotgun_insertshell.wav')
			end

		end
	end
end

function SWEP:CanPrimaryAttack()
	if self.Weapon:Clip1() <= 0 then
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.7)
		self:Reload()
		return false
	end
	if self.Weapon:GetNetworkedBool("reloading") then
		self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
		self.Weapon:SetNetworkedBool("reloading",false)
		self:SetNextPrimaryFire(CurTime() + self.ReloadSpeed)
		self:EmitSound("weapons/m3/Shotgun_pump.wav")
		timer.Simple(.5, function() self:EmitSound("weapons/m3/Shotgun_pump.wav") end)
		return false
	end
	if GetGlobalBool("Re2_IronSights") && !self.Weapon:GetNetworkedBool( "Ironsights") then
		return false
	end
	return true
end

-- Enter iron sight info and bone mod info below

	SWEP.IronSightsPos = Vector(-5.72, 0, -0.08)
	SWEP.IronSightsAng = Vector(-0.5, 0.1, 0)
	SWEP.SightsPos = Vector(-5.72, 0, -0.08)
	SWEP.SightsAng = Vector(-0.5, 0.1, 0)
	SWEP.RunSightsPos = Vector(-1.121, 0, 7.599)
	SWEP.RunSightsAng = Vector(-27.5, -0.101, 0)
