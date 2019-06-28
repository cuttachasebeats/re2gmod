SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_357.mdl"
SWEP.AnimPrefix		= "python"

SWEP.HoldType 			= "pistol"

SWEP.Primary.Sound			= Sound("Weapon_MP5Navy.Single")

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.ClipSize		= 8					// Size of a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "Pistol"
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Cone = .22

SWEP.Secondary.ClipSize		= 0					// Size of a clip
SWEP.Secondary.DefaultClip	= 0				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo			= "none"
SWEP.ReloadSpeed = 1
SWEP.Primary.Recoil = 0.2

SWEP.Item = "item_9mmhandgun"
SWEP.reloadinfo = 1

if GAMEMODE.Weapons[SWEP.Item].IMultiplier != nil then
	SWEP.IMultiplier = GAMEMODE.Weapons[SWEP.Item].IMultiplier
else
	SWEP.IMultiplier = 0.75
end

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	if self:GetOwner():IsValid() then
		self:Update()
	end
end

function SWEP:Precache()
end

function SWEP:PrimaryAttack()
	if (!self:CanPrimaryAttack()) then return end

	self.Weapon:EmitSound(self.Primary.Sound,100, 100)

	self:ResidentEvilBullet(self.Primary.Damage,self.Primary.Recoil,self.Primary.NumShots,self.Primary.Cone)
	self.Owner:ViewPunch(Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil,math.Rand(-0.1,0.1) *self.Primary.Recoil,0))
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:TakePrimaryAmmo(1)
 	if (game.SinglePlayer() && SERVER) || CLIENT then
 		self.Weapon:SetNetworkedFloat("LastShootTime",CurTime())
 	end
end

function SWEP:SetIronsights( b )
	self.Weapon:SetNetworkedBool( "Ironsights", b )
end

SWEP.NextSecondaryAttack = 0

function SWEP:SecondaryAttack()
	if ( !self.IronSightsPos ) then return end
	if ( self.NextSecondaryAttack > CurTime() ) then return end

	bIronsights = !self.Weapon:GetNetworkedBool( "Ironsights", false )

	if bIronsights == true then
		self.Primary.Cone = self.Primary.Cone * self.IMultiplier
		if SERVER then
			GAMEMODE:SetPlayerSpeed(self:GetOwner(),self.Owner.Speeds.Run /3,self.Owner.Speeds.Sprint/3)
		end

	else
		self.Primary.Cone = self.Primary.Cone / self.IMultiplier
		if SERVER then
			GAMEMODE:SetPlayerSpeed(self:GetOwner(),self:GetOwner():GetNWInt("Speed"),self:GetOwner():GetNWInt("Speed"))
		end
	end
	self:SetIronsights( bIronsights )

	self.NextSecondaryAttack = CurTime() + 0.3
end

function SWEP:OnRestore()

	self.NextSecondaryAttack = 0
	self:SetIronsights( false )

end

function SWEP:CheckReload()
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

		if self.Weapon.reloadinfo == nil then
			for i=0, 100 do
				if string.find(self.Weapon:GetAnimInfo(i).label, "reload") then
					self.Weapon.reloadinfo = self.Weapon:GetAnimInfo(i)
					break
				end
			end
		end
		self.Owner:GetViewModel():SequenceDuration()
		--self.Owner:GetViewModel():SetPlaybackRate((self.Weapon.reloadinfo.numframes/self.Weapon.reloadinfo.fps)/self.ReloadSpeed)
		self:SetNWBool("reloading", true)
		self.Owner:SetAnimation(PLAYER_RELOAD)
		self:SetNextPrimaryFire(CurTime() + self.ReloadSpeed)
		self:SetNextSecondaryFire(CurTime() + self.ReloadSpeed)
		timer.Simple(self.ReloadSpeed, function()
			if self:IsValid() && !self.Switched then
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
			else
				self:SetNWBool("reloading", false)
				self.Switched = false
			end
		if self:IsValid() then
		self.Owner:GetViewModel():SetPlaybackRate(1.0)
		end
		end)
	end
end

function SWEP:Think()
end

function SWEP:Holster(wep)
	if self.Weapon:GetNetworkedBool( "Ironsights") == true then
		self.Primary.Cone = self.Primary.Cone / self.IMultiplier
		if SERVER then
			GAMEMODE:SetPlayerSpeed(self:GetOwner(),self:GetOwner():GetNWInt("Speed"),self:GetOwner():GetNWInt("Speed"))
		end
	end
	self:SetIronsights( false )
	if self:GetNWBool("reloading") then
		self.Switched = true
	end
	return true
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
		self.Primary.Delay = GAMEMODE.Weapons[self.Item].UpGrades.FiringSpeed[speed].Level
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
			self.Primary.Delay = GAMEMODE.Weapons[self.Item].UpGrades.FiringSpeed[speed].Level
			self.ReloadSpeed = GAMEMODE.Weapons[self.Item].UpGrades.ReloadSpeed[res].Level
		end
	end


	return true
end

function SWEP:Deploy()
	self:SetIronsights( false )
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	self:Update()
	self:SetWeaponHoldType(self.HoldType)
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	
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

function SWEP:TakePrimaryAmmo(num)
	if self.Weapon:Clip1() <= 0 then
	if self:Ammo1() <= 0 then return end
		self.Owner:RemoveAmmo(num,self.Weapon:GetPrimaryAmmoType())
	return end
	self.Weapon:SetClip1(self.Weapon:Clip1() - num)
end
function SWEP:TakeSecondaryAmmo(num)
	if self.Weapon:Clip2() <= 0 then
	if self:Ammo2() <= 0 then return end
		self.Owner:RemoveAmmo(num,self.Weapon:GetSecondaryAmmoType())
	return end
	self.Weapon:SetClip2(self.Weapon:Clip2() - num)
end

function SWEP:CanPrimaryAttack()
	if self.Weapon:Clip1() <= 0 then
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.2)
		self:Reload()
		return false
	end
	if GetGlobalBool("Re2_Classic") && !self.Weapon:GetNetworkedBool( "Ironsights") then
		return false
	end
	return true
end

function SWEP:CanSecondaryAttack()
	if self.Weapon:GetNetworkedBool("reloading") then return end

	return true
end

function SWEP:ContextScreenClick(aimvec,mousecode,pressed,ply)
end
function SWEP:OnRemove()
end
function SWEP:OwnerChanged()
end
function SWEP:Ammo1()
	return self.Owner:GetAmmoCount(self.Weapon:GetPrimaryAmmoType())
end
function SWEP:Ammo2()
	return self.Owner:GetAmmoCount(self.Weapon:GetSecondaryAmmoType())
end
function SWEP:SetDeploySpeed(speed)
	self.m_WeaponDeploySpeed = tonumber(speed)
end
