if (CLIENT) then
	SWEP.PrintName			= "Tactical Striker-7"
	SWEP.Slot				= 4
	SWEP.SlotPos			= 0
	SWEP.DrawAmmo 			= true
	SWEP.DrawCrosshair 		= false
	SWEP.IconLetter			= "B"
 	killicon.AddFont( "weapon_striker7", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end
if (SERVER) then
	AddCSLuaFile("shared.lua")
end

SWEP.HoldType 			= "shotgun"
SWEP.Base				= "weapon_basegun_re"

SWEP.ViewModelFOV		= 62
SWEP.ViewModelFlip		= true
SWEP.ViewModel 			= "models/weapons/v_shot_strike.mdl"
SWEP.WorldModel 		= "models/weapons/w_shot_strike.mdl"


SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("weapons/stiker/m3-2.wav")
SWEP.Primary.Recoil			= 5
SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 10
SWEP.Primary.Cone			= 0.2
SWEP.Primary.ClipSize		= 8
SWEP.Primary.Delay			= 1.3
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "buckshot"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Item = "item_striker7"

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
		self.Owner:SetAnimation(PLAYER_RELOAD)
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

SWEP.IronSightsPos = Vector (3.628, -2.1104, 3.1663)
SWEP.IronSightsAng = Vector (-1.5758, 3.0083, 0.0085)
