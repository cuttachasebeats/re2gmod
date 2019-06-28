if (CLIENT) then
	SWEP.PrintName			= "Tactical Spas-12"
	SWEP.Slot				= 4
	SWEP.SlotPos			= 0
	SWEP.DrawAmmo 			= true
	SWEP.DrawCrosshair 		= false
	SWEP.IconLetter			= "B"
 	killicon.AddFont( "weapon_striker12", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end
if (SERVER) then
	AddCSLuaFile("shared.lua")
end
SWEP.HoldType 			= "shotgun"
SWEP.Base				= "weapon_basegun_re"

SWEP.ViewModelFOV		= 62
SWEP.ViewModelFlip		= true
SWEP.ViewModel 			= "models/weapons/v_shot_spas12.mdl"
SWEP.WorldModel 		= "models/weapons/w_shotgun.mdl"


SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("weapons/spas12/XM1014-2.wav")
SWEP.Primary.Recoil			= 5
SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 6
SWEP.Primary.Cone			= 0.2
SWEP.Primary.ClipSize		= 12
SWEP.Primary.Delay			= 1.3
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "buckshot"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Item = "item_spas12"

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
			self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
			self.Weapon:SetClip1(self.Weapon:Clip1() + 1)

			self.Owner:RemoveAmmo(1, self.Primary.Ammo,false)
			if self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 && self.Weapon:GetVar("reloadtimer",0) < CurTime() then
				self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
				self.Weapon:SetVar("reloadtimer",CurTime() + self.ReloadSpeed * 2)
				self:EmitSound('weapons/spas12/xm1014_cock.wav');
			else
				self:EmitSound('weapons/spas12/xm1014_insertshell.wav')
			end

		end
	end
end

function SWEP:PrimaryAttack()
	if (!self:CanPrimaryAttack()) then return end
		local sounds = {"weapons/spas12/XM1014-1.wav","weapons/spas12/XM1014-2.wav",}
		self.Weapon:EmitSound(sounds[math.random(1,#sounds)],100, 100)
	if SERVER then
		self.Weapon:TossWeaponSound();
	end
	self:ResidentEvilBullet(self.Primary.Damage,self.Primary.Recoil,self.Primary.NumShots,self.Primary.Cone)
	self.Owner:ViewPunch(Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil,math.Rand(-0.1,0.1) *self.Primary.Recoil,0))
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:TakePrimaryAmmo(1)
 	if (game.SinglePlayer() && SERVER) || CLIENT then
 		self.Weapon:SetNetworkedFloat("LastShootTime",CurTime())
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


SWEP.IronSightsPos = Vector (2.1826, -0.2859, 0.9807)
SWEP.IronSightsAng = Vector (0, 0, 0)
