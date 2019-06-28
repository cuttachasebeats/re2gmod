if (CLIENT) then
	SWEP.PrintName			= "AWP"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 0
	SWEP.IconLetter			= "r"
	SWEP.DrawAmmo 			= true
	SWEP.DrawCrosshair 		= false
	SWEP.CSMuzzleFlashes 	= true
	SWEP.SwayScale			= 1.0
	SWEP.BobScale			= 1.0
	killicon.AddFont("weapon_awp","CSKillIcons",SWEP.IconLetter,Color(255,80,0,255))
end
if (SERVER) then
	AddCSLuaFile("shared.lua")
end

SWEP.HoldType 			= "ar2"
SWEP.Base				= "weapon_basegun_re"

SWEP.ViewModelFOV		= 62
SWEP.ViewModelFlip		= true
SWEP.ViewModel			= "models/weapons/v_snip_awp.mdl"
SWEP.WorldModel			= "models/weapons/w_snip_awp.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_AWP.Single")
SWEP.Primary.Recoil			= .6
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.07
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "XBowBolt"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Item = "item_awp"

SWEP.IMultiplier = GAMEMODE.Weapons[SWEP.Item].IMultiplier

function SWEP:SecondaryAttack()
	if ( self.NextSecondaryAttack > CurTime() ) then return end

	bIronsights = !self.Weapon:GetNetworkedBool( "Ironsights", false )

	if bIronsights == true then
		self.Primary.Cone = self.Primary.Cone * self.IMultiplier
		if SERVER then
			self.Owner:SetFOV( 10, 0.3 )
			GAMEMODE:SetPlayerSpeed(self:GetOwner(),50,50)
		end

	else
		self.Primary.Cone = self.Primary.Cone / self.IMultiplier

		if SERVER then
			self.Owner:SetFOV( 75, 0.3 )
			GAMEMODE:SetPlayerSpeed(self:GetOwner(),self:GetOwner():GetNWInt("Speed"),self:GetOwner():GetNWInt("Speed"))
		end
	end
	self:SetIronsights( bIronsights )

	self.NextSecondaryAttack = CurTime() + 0.3
end

function SWEP:DrawHUD()
		local x = ScrW() / 2.0
		local y = ScrH() / 2.0
		if self.Weapon:GetNetworkedBool( "Ironsights", false ) then

			local Size = 512

			surface.SetDrawColor(0,0,0,255)
			surface.DrawRect(0,0,ScrW()/2 - Size/2,ScrH())
			surface.DrawRect(ScrW()/2 + Size/2 ,0,ScrW()/2 - Size/2 ,ScrH())
			surface.DrawRect(ScrW()/2 - Size/2,0,ScrW() - Size,ScrH()/2 - Size/2)
			surface.DrawRect(ScrW()/2 - Size/2,ScrH()/2 + Size/2,ScrW() - Size,ScrH()/2 - Size/2)

			surface.SetMaterial(Material("scope/scope_normal"))
			surface.SetDrawColor(255,255,255,255)
			surface.DrawTexturedRect(ScrW()/2 - Size/2 ,ScrH()/2 - Size/2,Size,Size)

			surface.SetDrawColor(tonumber(Options["Crosshairs"]["Red"]),tonumber(Options["Crosshairs"]["Green"]),tonumber(Options["Crosshairs"]["Blue"]),255)
			surface.DrawLine(x-1,y,x+2,y)
			surface.DrawLine(x,y-1,x,y+2)
		end
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	self:Update()
	self.Primary.Cone = self.Primary.Cone / self.IMultiplier
end

function SWEP:Reload()
	if self:GetNWBool("reloading") then return false end
	if self:Clip1() >= self.Primary.ClipSize then return false end
	if self:Clip1() < self.Primary.ClipSize && self:GetOwner():GetAmmoCount(self.Primary.Ammo) > 0  then
		if self.Weapon:GetNetworkedBool( "Ironsights") == true then
			self.Primary.Cone = self.Primary.Cone / self.IMultiplier
			if SERVER then
				self.Owner:SetFOV( 75, 0.3 )
				GAMEMODE:SetPlayerSpeed(self:GetOwner(),self:GetOwner():GetNWInt("Speed"),self:GetOwner():GetNWInt("Speed"))
			end
		end
		if self.Weapon.reloadinfo == nil then
			for i=0, 100 do
				if string.find(self.Weapon:GetAnimInfo(i).label, "reload") then
					self.Weapon.reloadinfo = self.Weapon:GetAnimInfo(i)
					break
				end
			end
		end
		self:SetIronsights( false )
		self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
		self:SetNWBool("reloading", true)
		self.Owner:GetViewModel():SequenceDuration()
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
				self:SetNWBool("reloading", false)
				self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
				self.Owner:GetViewModel():SetPlaybackRate(1.0)
			end
		end)
	end
end
