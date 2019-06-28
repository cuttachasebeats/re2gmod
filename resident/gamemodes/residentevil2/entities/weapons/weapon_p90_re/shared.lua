if (CLIENT) then
	SWEP.PrintName			= "Fabrique Nationale P90"
	SWEP.Slot				= 5
	SWEP.SlotPos			= 0
	SWEP.IconLetter			= "m"
	SWEP.DrawAmmo 			= true
	SWEP.DrawCrosshair 		= false
	SWEP.CSMuzzleFlashes 	= true
	SWEP.SwayScale			= 1.0
	SWEP.BobScale			= 1.0
	killicon.AddFont("weapon_p90","CSKillIcons",SWEP.IconLetter,Color(255,80,0,255))
end
if (SERVER) then
AddCSLuaFile("shared.lua")
end

SWEP.HoldType 			= "smg"
SWEP.Base				= "weapon_basegun_re"

SWEP.ViewModelFOV		= 62
SWEP.ViewModelFlip		= true
SWEP.ViewModel			= "models/weapons/v_smg_pre.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_p90.mdl"


SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("weapons/pre/p90-01.wav")
SWEP.Primary.Recoil			= 0.4
SWEP.Primary.Delay			= 0.04
SWEP.Primary.Damage			= 12
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.1
SWEP.Primary.ClipSize		= 50
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Item = "item_p90"

function SWEP:SecondaryAttack()
	if ( self.NextSecondaryAttack > CurTime() ) then return end

	bIronsights = !self.Weapon:GetNetworkedBool( "Ironsights", false )

	if bIronsights == true then
		self.Primary.Cone = self.Primary.Cone * self.IMultiplier
		if SERVER then
			self.Owner:SetFOV( 40, 0.3 )
			GAMEMODE:SetPlayerSpeed(self:GetOwner(),self:GetOwner():GetNWInt("Speed") /2.5,self:GetOwner():GetNWInt("Speed")/2.5)
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

			surface.SetMaterial(Material("scope/scope_reddot"))
			surface.SetDrawColor(255,255,255,255)
			surface.DrawTexturedRect(ScrW()/2 - Size/2 ,ScrH()/2 - Size/2,Size,Size)

		else

			local scale = 15 * self.Primary.Cone
			if !self:GetOwner():OnGround()  then
				scale = 15 * self.Primary.Cone * 1.3
			end
			if self.Owner:Crouching() && self:GetOwner():OnGround() then
				scale = 15 * self.Primary.Cone * .6
			end
			local LastShootTime = self.Weapon:GetNetworkedFloat("LastShootTime",0)
			scale = scale * (2 - math.Clamp((CurTime() - LastShootTime) * 5,0.0,1.0))
			local gap = 30 * scale
			local length = gap + 7
			surface.SetDrawColor(0,128,0,255)
			surface.DrawLine(x-1,y,x+2,y)
			surface.DrawLine(x,y-1,x,y+2)
			surface.DrawLine(x - length,y,x - gap,y)
			surface.DrawLine(x + length,y,x + gap,y)
			surface.DrawLine(x,y - length,x,y - gap)
			surface.DrawLine(x,y + length,x,y + gap)
		end
end


function SWEP:Reload()
	if self:GetNWBool("reloading") then return false end
	if self:Clip1() >= self.Primary.ClipSize then return false end
	if self:Clip1() < self.Primary.ClipSize && self:GetOwner():GetAmmoCount(self.Primary.Ammo) > 0  then
		if self.Weapon:GetNetworkedBool( "Ironsights") == true then
			self.Primary.Cone = self.Primary.Cone / 0.75
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
		self.Owner:GetViewModel():SequenceDuration()
		self:SetNWBool("reloading", true)
		self:EmitSound("Weapon_SMG1.Reload")
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
			end
		end)
	end
end
