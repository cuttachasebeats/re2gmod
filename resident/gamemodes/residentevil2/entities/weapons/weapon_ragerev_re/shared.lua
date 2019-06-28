if (CLIENT) then
	SWEP.PrintName			= "Raging Bull Revolver"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 3
	SWEP.IconLetter			= "f"
	SWEP.DrawAmmo 			= true
	SWEP.DrawCrosshair 		= false
	SWEP.CSMuzzleFlashes 	= true
	SWEP.SwayScale			= 1.0
	SWEP.BobScale			= 1.0
	killicon.AddFont("weapon_deagle","CSKillIcons",SWEP.IconLetter,Color(255,80,0,255))
end
if (SERVER) then
	AddCSLuaFile("shared.lua")
end

SWEP.Base				= "weapon_basegun_re"

SWEP.ViewModelFOV		= 70
SWEP.ViewModelFlip		= true
SWEP.ViewModel = "models/weapons/v_revl_raging.mdl"
SWEP.WorldModel = "models/weapons/w_revl_raging.mdl"
SWEP.HoldType 			= "pistol"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("weapons/ragingbull/revolver.wav")
SWEP.Primary.Recoil			= 5
SWEP.Primary.Damage			= 30
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.ClipSize		= 6
SWEP.Primary.Delay			= 0.5
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "357"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Item = "item_ragerev"

function SWEP:Reload()
	if self:GetNWBool("reloading") then return false end
	if self:Clip1() >= self.Primary.ClipSize then return false end
	if self:Clip1() < self.Primary.ClipSize && self:GetOwner():GetAmmoCount(self.Primary.Ammo) > 0  then
		self:EmitSound("weapons/ragingbull/bullreload.wav")
		if self.Weapon:GetNetworkedBool( "Ironsights") == true then
			self.Primary.Cone = self.Primary.Cone / self.IMultiplier
			if SERVER then
				GAMEMODE:SetPlayerSpeed(self:GetOwner(),self:GetOwner():GetNWInt("Speed"),self:GetOwner():GetNWInt("Speed"))
			end
		end
		self:SetIronsights( false )
		self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
		self:SetNWBool("reloading", true)
		self.Owner:SetAnimation(PLAYER_RELOAD) 
		self:SetNextPrimaryFire(CurTime() + self.ReloadSpeed)
		self:SetNextSecondaryFire(CurTime() + self.ReloadSpeed)
		timer.Simple(self.ReloadSpeed, function()
			if self:IsValid() then
				if (self:GetOwner():GetAmmoCount(self.Primary.Ammo) + self.Weapon:Clip1()) >= self.Primary.ClipSize then
					if SERVER then
						self:GetOwner():RemoveAmmo(self.Primary.ClipSize - self.Weapon:Clip1()  ,self.Primary.Ammo )
						self.Weapon:SetClip1(self.Primary.ClipSize)
					end
				else
					if SERVER then
						self.Weapon:SetClip1(self:GetOwner():GetAmmoCount(self.Primary.Ammo) + self.Weapon:Clip1())
						self:GetOwner():RemoveAmmo(self:GetOwner():GetAmmoCount(self.Primary.Ammo),self.Primary.Ammo)
					end
				end
				self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
				self:SetNWBool("reloading", false)
			end
		end)
	end
end

SWEP.IronSightsPos = Vector (2.7927, 0, 0.8432)
SWEP.IronSightsAng = Vector (0, 0, 0)
