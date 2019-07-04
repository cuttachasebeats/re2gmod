GM.Items = {}

-------------------------------------------------------------
---Items------------------------
-------------------------------------------------------------
GM.Items["item_spray"] = {
	Name = "Spray",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display
	Desc = "Heals all wounds",-- The description
	Model = "models/firstaidspray.mdl",-- The model
	-- what it does don't touch it.
	Condition = function(ply,item)
				local hp = ply:Health()
				if hp >= ply:GetNWInt("MaxHP") then
					return false
				end
				return true
			end,
	Function =
		function(ply,item)
			local hp = ply:Health()
			if hp < ply:GetNWInt("MaxHP") then
				ply:SetHealth(ply:GetNWInt("MaxHP"))
				if SERVER then
					ply:SetNWInt("Speed",165)
					GAMEMODE:SetPlayerSpeed(ply,ply:GetNWInt("Speed"),ply:GetNWInt("Speed"))
				end
			end
			ply:EmitSound("items/smallmedkit1.wav",110,100)
			ply:AddStat("SpraysUsed", 1)
		end,
	Price = 300,--Price
	Max = 2,-- Total Number of items able to be carried.
	Num = 1,-- Useless value ignore
	}

GM.Items["item_herb"] = {
	Name = "Green Herb",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display
	Desc = "Heals Some wounds",-- The description
	Model = "models/resident evil/item_herbgre.mdl",-- The model
	-- what it does don't touch it.
	Condition = function(ply,item)
				local hp = ply:Health()
				if hp >= ply:GetNWInt("MaxHP") then
					return false
				end
				return true
			end,
	Function =
		function(ply,item)
			local hp = ply:Health()
			if hp < ply:GetNWInt("MaxHP") then
				ply:SetHealth(ply:Health() + 30)
				if SERVER then
					ply:SetNWInt("Speed",165)
					GAMEMODE:SetPlayerSpeed(ply,ply:GetNWInt("Speed"),ply:GetNWInt("Speed"))
				end
			end
			ply:EmitSound("items/smallmedkit1.wav",110,100)
			ply:AddStat("SpraysUsed", 1)
		end,
	Price = 100,--Price
	Max = 4,-- Total Number of items able to be carried.
	Num = 555,-- Useless value ignore
	}

GM.Items["item_rherb"] = {
	Name = "Red Herb",
	Desc = "Chance To Cure Infection",
	Model = "models/resident evil/item_herbred.mdl",
	Condition = function(ply,item)
				if !ply:GetNWBool("Infected") then
					return false
				end
				return true
			end,
	Function =
		function(ply,item)
			ply:SetNWBool("Infected", true)
			ply:SetNWInt("InfectedPercent", 10)
			ply:SetNWInt("Immunity", ply:GetNWInt("Immunity") + 10 )
			ply:PrintMessage(HUD_PRINTTALK,"Infection Lowered")
			ply:EmitSound("items/smallmedkit1.wav",110,100)

		end,
	Price = 250,
	Max = 2,
	Num = 2,
}

GM.Items["item_bherb"] = {
	Name = "Blue Herb",
	Desc = "Little Of Both",
	Model = "models/resident evil/item_herbblue.mdl",
	Condition = function(ply,item)
				if !ply:GetNWBool("Infected") then
					return false
				end
				return true
			end,
	Function =
		function(ply,item)
			ply:SetNWBool("Infected", true)
			ply:SetNWInt("InfectedPercent", 10)
			ply:SetNWInt("Immunity", ply:GetNWInt("Immunity") + 10 )
			ply:PrintMessage(HUD_PRINTTALK,"Infection Lowered")
			ply:EmitSound("items/smallmedkit1.wav",110,100)
			local hp = ply:Health()
			if hp < ply:GetNWInt("MaxHP") then
				ply:SetHealth(ply:Health() + 7)
				if SERVER then
					ply:SetNWInt("Speed",165)
					GAMEMODE:SetPlayerSpeed(ply,ply:GetNWInt("Speed"),ply:GetNWInt("Speed"))
				end
			end
		end,
	Price = 250,
	Max = 2,
	Num = 2,
}

GM.Items["item_tcure"] = {
	Name = "T-Virus Cure",
	Desc = "Cures Infection",
	Model = "models/items/healthkit.mdl",
	Condition = function(ply,item)
				if !ply:GetNWBool("Infected") then
					return false
				end
				return true
			end,
	Function =
		function(ply,item)
			ply:SetNWBool("Infected", false)
			ply:SetNWInt("InfectedPercent", 0)
			ply:SetNWInt("Immunity", ply:GetNWInt("Immunity") + 10 )
			ply:PrintMessage(HUD_PRINTTALK,"Infection Cured")
			ply:EmitSound("HL1/fvox/antidote_shot.wav",110,100)

			ply:AddStat("CuresUsed", 1)

		end,
	Price = 500,
	Max = 1,
	Num = 2,
}

GM.Items["item_ammo_pistol"] = {
	Name = "Pistol Ammo",
	Desc = "40 rounds",
	Model = "models/re_magazine.mdl",
	Condition =
		function(ply,item)
			for u,p in pairs(GAMEMODE.Ammoref) do
				if item == u then
					if ply:GetAmmoCount(p) > GAMEMODE.AmmoMax[p].number then
						return false
					end
				end
			end
			return true
		end,
	Function =
		function(ply,item)
			if ply:GetAmmoCount(GAMEMODE.Ammoref[item]) <= GAMEMODE.AmmoMax[GAMEMODE.Ammoref[item]].number - 20 then
				ply:GiveAmmo(40,GAMEMODE.Ammoref[item],true)
			else
				ply:GiveAmmo(tonumber(GAMEMODE.AmmoMax[GAMEMODE.Ammoref[item]].number) - ply:GetAmmoCount(GAMEMODE.Ammoref[item]),GAMEMODE.Ammoref[item])
			end
		ply:EmitSound("items/ammo_pickup.wav",110,100)
		end,
	Price = 40,
	Max = 4,
	Num = 3,
}

GM.Items["item_ammo_buckshot"] = {
	Name = "Shotgun Ammo",
	Desc = "36 rounds",
	Model = "models/items/boxbuckshot.mdl",
	Condition =
		function(ply,item)
			for u,p in pairs(GAMEMODE.Ammoref) do
				if item == u then
					if ply:GetAmmoCount(p) >= GAMEMODE.AmmoMax[p].number then
						return false
					end
				end
			end
			return true
		end,
	Function =
		function(ply,item)
			if ply:GetAmmoCount(GAMEMODE.Ammoref[item]) <= GAMEMODE.AmmoMax[GAMEMODE.Ammoref[item]].number - 8 then
				ply:GiveAmmo(36,GAMEMODE.Ammoref[item],true)
			else
				ply:GiveAmmo(tonumber(GAMEMODE.AmmoMax[GAMEMODE.Ammoref[item]].number) - ply:GetAmmoCount(GAMEMODE.Ammoref[item]),GAMEMODE.Ammoref[item])
			end
		ply:EmitSound("items/ammo_pickup.wav",110,100)
		end,
	Price = 100,
	Max = 4,
	Num = 4,
}

GM.Items["item_ammo_smg"] = {
	Name = "Automatic Ammo",
	Desc = "45 rounds",
	Model = "models/items/boxmrounds.mdl",
	Condition =
		function(ply,item)
			for u,p in pairs(GAMEMODE.Ammoref) do
				if item == u then
					if ply:GetAmmoCount(p) >= GAMEMODE.AmmoMax[p].number then
						return false
					end
				end
			end
			return true
		end,
	Function =
		function(ply,item)
			if ply:GetAmmoCount(GAMEMODE.Ammoref[item]) <= GAMEMODE.AmmoMax[GAMEMODE.Ammoref[item]].number - 45 then
				ply:GiveAmmo(45,GAMEMODE.Ammoref[item],true)
			else
				ply:GiveAmmo(tonumber(GAMEMODE.AmmoMax[GAMEMODE.Ammoref[item]].number) - ply:GetAmmoCount(GAMEMODE.Ammoref[item]),GAMEMODE.Ammoref[item])
			end
		ply:EmitSound("items/ammo_pickup.wav",110,100)
		end,
	Price = 90,
	Max = 4,
	Num = 5,
}

GM.Items["item_ammo_rifle"] = {
	Name = "Rifle Ammo",
	Desc = "60 rounds",
	Model = "models/items/boxsrounds.mdl",
	Condition =
		function(ply,item)
			for u,p in pairs(GAMEMODE.Ammoref) do
				if item == u then
					if ply:GetAmmoCount(p) >= GAMEMODE.AmmoMax[p].number then
						return false
					end
				end
			end
			return true
		end,
	Function =
		function(ply,item)
			if ply:GetAmmoCount(GAMEMODE.Ammoref[item]) <= GAMEMODE.AmmoMax[GAMEMODE.Ammoref[item]].number - 30 then
				ply:GiveAmmo(60,GAMEMODE.Ammoref[item],true)
			else
				ply:GiveAmmo(tonumber(GAMEMODE.AmmoMax[GAMEMODE.Ammoref[item]].number) - ply:GetAmmoCount(GAMEMODE.Ammoref[item]),GAMEMODE.Ammoref[item])
			end
		ply:EmitSound("items/ammo_pickup.wav",110,100)
		end,
	Price = 90,
	Max = 4,
	Num = 6,
}

GM.Items["item_ammo_magnum"] =
{
	Name = "Magnum Rounds",
	Desc = "35 rounds",
	Model = "models/items/357ammobox.mdl",
	Condition =
		function(ply,item)
			for u,p in pairs(GAMEMODE.Ammoref) do
				if item == u then
					if ply:GetAmmoCount(p) >= GAMEMODE.AmmoMax[p].number then
						return false
					end
				end
			end
			return true
		end,
	Function =
		function(ply,item)
			if ply:GetAmmoCount(GAMEMODE.Ammoref[item]) <= GAMEMODE.AmmoMax[GAMEMODE.Ammoref[item]].number - 6 then
				ply:GiveAmmo(35,GAMEMODE.Ammoref[item],true)
			else
				ply:GiveAmmo(tonumber(GAMEMODE.AmmoMax[GAMEMODE.Ammoref[item]].number) - ply:GetAmmoCount(GAMEMODE.Ammoref[item]),GAMEMODE.Ammoref[item])
			end
		ply:EmitSound("items/ammo_pickup.wav",110,100)
		end,
	Price = 120,
	Max = 4,
	Num = 17,
}

GM.Items["item_ammo_sniper"] =
{
	Name = "Sniper Rounds",
	Desc = "20 rounds",
	Model = "models/rifle_box.mdl",
	Condition =
		function(ply,item)
			for u,p in pairs(GAMEMODE.Ammoref) do
				if item == u then
					if ply:GetAmmoCount(p) >= GAMEMODE.AmmoMax[p].number then
						return false
					end
				end
			end
			return true
		end,
	Function =
		function(ply,item)
			if ply:GetAmmoCount(GAMEMODE.Ammoref[item]) <= GAMEMODE.AmmoMax[GAMEMODE.Ammoref[item]].number - 10 then
				ply:GiveAmmo(20,GAMEMODE.Ammoref[item],true)
			else
				ply:GiveAmmo(tonumber(GAMEMODE.AmmoMax[GAMEMODE.Ammoref[item]].number) - ply:GetAmmoCount(GAMEMODE.Ammoref[item]),GAMEMODE.Ammoref[item])
			end
		ply:EmitSound("items/ammo_pickup.wav",110,100)
		end,
	Price = 90,
	Max = 3,
	Num = 17,
}

GM.Items["item_ammo_rocket"] =
{
	Name = "Rocket Round",
	Desc = "4 rockets",
	Model = "models/weapons/w_missile_Closed.mdl",
	Condition =
		function(ply,item)
			for u,p in pairs(GAMEMODE.Ammoref) do
				if item == u then
					if ply:GetAmmoCount(p) >= GAMEMODE.AmmoMax[p].number then
						return false
					end
				end
			end
			return true
		end,
	Function =
		function(ply,item)
			if ply:GetAmmoCount(GAMEMODE.Ammoref[item]) <= GAMEMODE.AmmoMax[GAMEMODE.Ammoref[item]].number - 1 then
				ply:GiveAmmo(4,GAMEMODE.Ammoref[item],true)
			else
				ply:GiveAmmo(tonumber(GAMEMODE.AmmoMax[GAMEMODE.Ammoref[item]].number) - ply:GetAmmoCount(GAMEMODE.Ammoref[item]),GAMEMODE.Ammoref[item])
			end
		ply:EmitSound("items/ammo_pickup.wav",110,100)
		end,
	Price = 150,
	Max = 1,
	Num = 17,
}

GM.Items["item_ammo_gl_explosive"] =
{
	Name = "Explosive Rounds",
	Desc = "6 rounds",
	Model = "models/glauncherrounds.mdl",
	Material = "models/grounds/grenaderounds#00_15",
	Condition =
		function(ply,item)
			for u,p in pairs(GAMEMODE.Ammoref) do
				if item == u then
					if ply:GetAmmoCount(p) >= GAMEMODE.AmmoMax[p].number then
						return false
					end
				end
			end
			return true
		end,
	Function =
		function(ply,item)
			if ply:GetAmmoCount(GAMEMODE.Ammoref[item]) <= GAMEMODE.AmmoMax[GAMEMODE.Ammoref[item]].number - 6 then
				ply:GiveAmmo(6,GAMEMODE.Ammoref[item],true)
			else
				ply:GiveAmmo(tonumber(GAMEMODE.AmmoMax[GAMEMODE.Ammoref[item]].number) - ply:GetAmmoCount(GAMEMODE.Ammoref[item]),GAMEMODE.Ammoref[item])
			end
			for _,weapon in pairs(ply:GetWeapons()) do
				if weapon:GetClass() == "weapon_m79_re" then
					weapon.AmmoNumber = 1
					weapon.Primary.Ammo			= weapon.AmmoTypeTable[weapon.AmmoNumber]
					ply:SetNWString("RE2_DisplayAmmoType",weapon.AmmoTypeTable[weapon.AmmoNumber])
					ply:SelectWeapon("weapon_m79_re")
					break
				end
			end
		ply:EmitSound("items/ammo_pickup.wav",110,100)
		end,
	Price = 170,
	Max = 3,
	Num = 17,
}
GM.Items["item_ammo_gl_flame"] =
{
	Name = "Flame Rounds",
	Desc = "6 rounds",
	Model = "models/glauncherrounds.mdl",
	Material = "models/grounds/grenaderounds#00_16",
	Condition =
		function(ply,item)
			for u,p in pairs(GAMEMODE.Ammoref) do
				if item == u then
					if ply:GetAmmoCount(p) >= GAMEMODE.AmmoMax[p].number then
						return false
					end
				end
			end
			return true
		end,
	Function =
		function(ply,item)
			if ply:GetAmmoCount(GAMEMODE.Ammoref[item]) <= GAMEMODE.AmmoMax[GAMEMODE.Ammoref[item]].number - 6 then
				ply:GiveAmmo(6,GAMEMODE.Ammoref[item],true)
			else
				ply:GiveAmmo(tonumber(GAMEMODE.AmmoMax[GAMEMODE.Ammoref[item]].number) - ply:GetAmmoCount(GAMEMODE.Ammoref[item]),GAMEMODE.Ammoref[item])
			end
			for _,weapon in pairs(ply:GetWeapons()) do
				if weapon:GetClass() == "weapon_m79_re" then
					weapon.AmmoNumber = 2
					weapon.Primary.Ammo			= weapon.AmmoTypeTable[weapon.AmmoNumber]
					ply:SetNWString("RE2_DisplayAmmoType",weapon.AmmoTypeTable[weapon.AmmoNumber])
					ply:SelectWeapon("weapon_m79_re")
					break
				end
			end
		ply:EmitSound("items/ammo_pickup.wav",110,100)
		end,
	Price = 170,
	Max = 2,
	Num = 17,
}
GM.Items["item_ammo_gl_freeze"] =
{
	Name = "Freeze Rounds",
	Desc = "6 rounds",
	Model = "models/glauncherrounds.mdl",
	Material = "models/grounds/grenaderounds#00_17",
	Condition =
		function(ply,item)
			for u,p in pairs(GAMEMODE.Ammoref) do
				if item == u then
					if ply:GetAmmoCount(p) >= GAMEMODE.AmmoMax[p].number then
						return false
					end
				end
			end
			return true
		end,
	Function =
		function(ply,item)
			if ply:GetAmmoCount(GAMEMODE.Ammoref[item]) <= GAMEMODE.AmmoMax[GAMEMODE.Ammoref[item]].number - 6 then
				ply:GiveAmmo(6,GAMEMODE.Ammoref[item],true)
			else
				ply:GiveAmmo(tonumber(GAMEMODE.AmmoMax[GAMEMODE.Ammoref[item]].number) - ply:GetAmmoCount(GAMEMODE.Ammoref[item]),GAMEMODE.Ammoref[item])
			end
			for _,weapon in pairs(ply:GetWeapons()) do
				if weapon:GetClass() == "weapon_m79_re" then
					weapon.AmmoNumber = 3
					weapon.Primary.Ammo			= weapon.AmmoTypeTable[weapon.AmmoNumber]
					ply:SetNWString("RE2_DisplayAmmoType",weapon.AmmoTypeTable[weapon.AmmoNumber])
					ply:SelectWeapon("weapon_m79_re")
					break
				end
			end
		ply:EmitSound("items/ammo_pickup.wav",110,100)
		end,
	Price = 170,
	Max = 1,
	Num = 17,
}
-------------------------------------------------------------
---Weapons------------------------
-------------------------------------------------------------
GM.Items["item_9mmhandgun"] = {
	Name = "9mm Handgun",
	Desc = "Uses Pistol Ammo",
	Model = "models/weapons/w_pist_usp.mdl",
	Function =
		function(ply)
			ply:SelectWeapon("weapon_9mm_re")
		end,
	Price = 120,
	Max = 1,
	Num = 7,
}

GM.Items["item_m4"] = {
	Name = "M4a1",
	Desc = "Uses Rifle Ammo",
	Model = "models/weapons/w_rif_m4re.mdl",
	Function =
		function(ply)
			ply:SelectWeapon("weapon_m4_re")
		end,
	Price = 4000,
	Max = 1,
	Num = 8,
}

GM.Items["item_p90"] = {
	Name = "P90",
	Desc = "Uses Automatic ammo",
	Model = "models/weapons/w_smg_p90.mdl",
	Function =
		function(ply)
			ply:SelectWeapon("weapon_p90_re")
		end,
	Price = 3600,
	Max = 1,
	Num = 9,
}

GM.Items["item_pumpshot"] = {
	Name = "Pump Shotgun",
	Desc = "Uses Shotgun ammo",
	Model = "models/weapons/w_shot_mossberg5.mdl",
	Function =
		function(ply)
			ply:SelectWeapon("weapon_pumpshot_re")
		end,
	Price = 6600,
	Max = 1,
	Num = 10,
}

GM.Items["item_glock18"] = {
	Name = "Glock-18c",
	Desc = "Uses Pistol Ammo",
	Model = "models/weapons/w_pist_glockre.mdl",
	Function =
		function(ply)
			ply:SelectWeapon("weapon_glock18_re")
		end,
	Price = 1200,
	Max = 1,
	Num = 11,
}

GM.Items["item_aug"] = {
	Name = "Aug",
	Desc = "Uses Rifle ammo",
	Model = "models/weapons/w_rif_aug.mdl",
	Function =
		function(ply)
			ply:SelectWeapon("weapon_aug_re")
		end,
	Price = 2200,
	Max = 1,
	Num = 12,
}

GM.Items["item_mp5"] = {
	Name = "Mp5",
	Desc = "Uses Automatic ammo",
	Model = "models/weapons/w_smg_mp5.mdl",
	Function =
		function(ply)
			ply:SelectWeapon("weapon_mp5_re")
		end,
	Price = 1400,
	Max = 1,
	Num = 13,
}

GM.Items["item_ragerev"] =
{
	Name = "Raging Revolver",
	Desc = "Uses Magnum rounds",
	Model = "models/weapons/w_revl_raging.mdl",
	Function =
		function(ply)
			ply:SelectWeapon("weapon_ragerevolver_re")
		end,
	Price = 5750,
	Max = 1,
	Num = 16,
}

GM.Items["item_ump"] =
{
	Name = "Ump 45",
	Desc = "Uses Automatic ammo",
	Model = "models/weapons/w_smg_ump45.mdl",
	Function =
		function(ply)
			ply:SelectWeapon("weapon_ump_re")
		end,
	Price = 1450,
	Max = 1,
	Num = 18,
}
GM.Items["item_p228"] =
{
	Name = "Sig P-220",
	Desc = "Uses Pistol Ammo",
	Model = "models/weapons/w_pist_p220.mdl",
	Function =
		function(ply)
		ply:SelectWeapon("weapon_p228_re")
		end,
	Price = 1300,
	Max = 1,
	Num = 20,
}
GM.Items["item_ak47"] =
{
	Name = "Ak-47",
	Desc = "Uses Rifle ammo",
	Model = "models/weapons/w_rif_akre.mdl",
	Function =
		function(ply)
		ply:SelectWeapon("weapon_ak47_re")
		end,
	Price = 4800,
	Max = 1,
	Num = 21,
}

GM.Items["item_striker7"] = {
	Name = "Striker-7",
	Desc = "Uses Shotgun ammo",
	Model = "models/weapons/w_shot_strike.mdl",
	Function =
		function(ply)
			ply:SelectWeapon("weapon_striker7_re")
		end,
	Price = 5000,
	Max = 1,
	Num = 10,
}

GM.Items["item_spas12"] = {
	Name = "Spas-12",
	Desc = "Uses Shotgun ammo",
	Model = "models/weapons/w_shotgun.mdl",
	Function =
		function(ply)
			ply:SelectWeapon("weapon_spas12_re")
		end,
	Price = 5000,
	Max = 1,
	Num = 10,
}

GM.Items["item_m29"] =
{
	Name = "M29 Satan Deux",
	Desc = "Uses Magnum rounds",
	Model = "models/weapons/w_pist_swem29.mdl",
	Function =
		function(ply)
			ply:SelectWeapon("weapon_m29_re")
		end,
	Price = 4500,
	Max = 1,
	Num = 19,
}
GM.Items["item_physcannon"] =
{
	Name = "Gravity Gun",
	Desc = "Catch!",
	Model = "models/weapons/w_physics.mdl",
	Function =
		function(ply)
			ply:SelectWeapon("weapon_physcannon")
		end,
	Price = 3000,
	Max = 1,
	Num = 20,
}

GM.Items["item_awp"] =
{
	Name = "AWP",
	Desc = "Uses Sniper Ammo",
	Model = "models/weapons/w_snip_awp.mdl",
	Function =
		function(ply)
			ply:SelectWeapon("weapon_awp_re")
		end,
	Price = 6000,
	Max = 1,
	Num = 23,
}

GM.Items["item_scout"] =
{
	Name = "Scout Sniper",
	Desc = "Uses Sniper Ammo",
	Model = "models/weapons/w_snip_scout.mdl",
	Function =
		function(ply)
			ply:SelectWeapon("weapon_scout_re")
		end,
	Price = 5000,
	Max = 1,
	Num = 23,
}
---- Power Weapons

GM.Items["item_m79"] =
{
	Name = "M79 Grenade Launcher",
	Desc = "Right Click to Change Ammo Types",
	Model = "models/weapons/w_grenlaunch_m79.mdl",
	Function =
		function(ply)
		ply:SelectWeapon("weapon_m79_re")
		end,
	Price = 65000,
	Max = 1,
	Num = 22,
}

GM.Items["item_quadrpg"] =
{
	Name = "Quad Rocket Launcher",
	Desc = "4 Rockets.",
	Model = "models/weapons/w_rpc.mdl",
	Function =
		function(ply)
		ply:SelectWeapon("weapon_Quad_re")
		end,
	Price = 55000,
	Max = 1,
	Num = 22,
}
GM.Items["item_minigun"] =
{
	Name = "Minigun",
	Desc = "200 rounds of death. Rip it up.",
	Model = "models/weapons/w_minigun.mdl",
	Function =
		function(ply)
		ply:SelectWeapon("weapon_minigun_re")
		end,
	Price = 60000,
	Max = 1,
	Num = 22,
}

GM.Items["item_bandolier"] =
{
	Name = "Minigun Bandolier",
	Desc = "Gives 200 more Rounds.",
	Model = "models/HMG_AmmoBox.mdl",
	Function =
		function(ply)
		ply:SelectWeapon("weapon_minigun_re")
		end,
	Price = 30000,
	Max = 1,
	Num = 23,
}

GM.Items["item_m16a1"] =
{
	Name = "M16A1",
	Desc = "A Nice rifle",
	Model = "models/weapons/w_rif_nam.mdl",
	Function =
		function(ply)
		ply:SelectWeapon("gdcw_m16a1_re")
		end,
	Price = 15000,
	Max = 1,
	Num = 24,
}

GM.Items["item_dgal50"] =
{
	Name = "50c Deagle",
	Desc = "A Powerful Gun",
	Model = "models/weapons/w_pist_dgal50.mdl",
	Function =
		function(ply)
		ply:SelectWeapon("gdcw_dgal50_re")
		end,
	Price = 12000,
	Max = 1,
	Num = 25,
}
GM.Items["item_m249"] =
{
	Name = "M-249",
	Desc = "150 rounds of death. Rip it up.",
	Model = "models/weapons/w_minigun.mdl",
	Function =
		function(ply)
		ply:SelectWeapon("gdcw_m-249saw_re")
		end,
	Price = 80000,
	Max = 1,
	Num = 26,
}






-----------------------TFA Guns






-------------------------------------------------------------
---Special Items (explosives and stuff)------------------------
-------------------------------------------------------------
GM.Items["item_expbarrel"] = {
	Name = "Explosive Barrel",
	Desc = "Read the name",
	Model = "models/props_c17/oildrum001_explosive.mdl",
	Function =
	function(ply)
	local vStart = ply:GetShootPos()
	local vForward = ply:GetAimVector()

	local trace = {}
	trace.start = vStart
	trace.endpos = vStart + (vForward * 160)
	trace.filter = ply

	local tr = util.TraceLine( trace )
	local DropedEnt = ents.Create("prop_physics")
	DropedEnt:SetModel("models/props_c17/oildrum001_explosive.mdl")
	DropedEnt:SetPos(ply:EyePos() + (ply:GetAimVector() * 30))
	DropedEnt:SetAngles(ply:EyeAngles())
	DropedEnt:Spawn()
	//DropedEnt:SetOwner(ply)

	if tr.HitWorld then
		local vFlushPoint = tr.HitPos - ( tr.HitNormal * 512 )	// Find a point that is definitely out of the object in the direction of the floor
		vFlushPoint = DropedEnt:NearestPoint( vFlushPoint )			// Find the nearest point inside the object to that point
		vFlushPoint = DropedEnt:GetPos() - vFlushPoint				// Get the difference
		vFlushPoint = tr.HitPos + vFlushPoint					// Add it to our target pos
		DropedEnt:SetPos( vFlushPoint )
	elseif tr.Entity:IsPlayer() then
		local vFlushPoint = tr.HitPos - ( tr.HitNormal * 512 )	// Find a point that is definitely out of the object in the direction of the floor
		vFlushPoint = DropedEnt:NearestPoint( vFlushPoint )			// Find the nearest point inside the object to that point
		vFlushPoint = DropedEnt:GetPos() - vFlushPoint				// Get the difference
		vFlushPoint = tr.HitPos + vFlushPoint					// Add it to our target pos
		DropedEnt:SetPos( vFlushPoint )
	else
		DropedEnt:SetPos( vStart + (vForward * 60) )
	end
	end,
	Price = 50,
	Max = 1,
	Num = 14,
}

GM.Items["item_c4"] =
{
	Name = "C4 Plastic Explosive",
	Desc = "Plant and Detonate",
	Model = "models/weapons/w_c4_planted.mdl",
	Function =
		function(ply)
			if not IsValid(ply) or not ply:Alive() then return end

			local entBomb = ents.Create("item_base")
			local angle = Angle(0,ply:EyeAngles().y,0)

			local eyeTrace = ply:GetEyeTrace()

			local dist = 25
			local pos = ply:EyePos() + ply:GetAimVector() * dist

			if eyeTrace.Hit && eyeTrace.HitPos:Distance(ply:EyePos()) < 200 then
				pos = eyeTrace.HitPos
				angle = eyeTrace.HitNormal:Angle()

				angle.y = angle.y + 180
				if angle.p / 180 <= 1 then
					angle.p = angle.p - 90
				else
					angle.p = angle.p + 90
				end
			end

			entBomb:SetNWString("Class","item_c4")
			entBomb.Armed = true
			entBomb.Owner = ply
			entBomb:SetDTEntity(0, ply)
			entBomb:SetPos(pos)
			entBomb:SetAngles(angle)
			entBomb:Spawn()
			entBomb:SetDTEntity(0,ply)
		end,
	Price = 150,
	Max = 4,
	Num = 14,
}
GM.Items["item_landmine"] = {
	Name = "Proximity Mine",
	Desc = "Plants at your feet.",
	Model = "models/landmine.mdl",
	Function =
	function(ply)
		local vStart = ply:GetShootPos()
		local DropedEnt = ents.Create("item_base")
		DropedEnt:SetNWString("Class","item_landmine")
		DropedEnt.Armed = true
		DropedEnt:Spawn()
		DropedEnt.Owner = ply timer.Simple(1,function() DropedEnt:CheckForEnemies() end)
		DropedEnt:SetPos( ply:GetPos() + Vector(0,0,5) )
	end,
	Price = 100,
	Max = 3,
	Num = 14,
}

----- No Moar Items :(

GM.Items["item_an94"] = {
	Name = "AN94",
	Desc = "Uses Rifle Ammo",
	Model = "models/weapons/w_rif_ak47.mdl",
	Function =
		function(ply)
			ply:SelectWeapon("weapon_an94_re")
		end,
	Price = 250000,
	Max = 1,
	Num = 24,
}

GM.Items["item_ballista"] = {
	Name = "Ballista",
	Desc = "Uses Sniper Ammo",
	Model = "models/weapons/w_snip_scout.mdl",
	Function =
		function(ply)
			ply:SelectWeapon("weapon_ballista_re")
		end,
	Price = 250000,
	Max = 1,
	Num = 25,
}

GM.Items["item_dsr50"] = {
	Name = "DSR50",
	Desc = "Uses Sniper Ammo",
	Model = "models/weapons/w_snip_awp.mdl",
	Function =
		function(ply)
			ply:SelectWeapon("weapon_dsr50_re")
		end,
	Price = 300000,
	Max = 1,
	Num = 26,
}

GM.Items["item_executioner"] = {
	Name = "Executioner",
	Desc = "Uses Pistol Ammo",
	Model = "models/weapons/w_pist_usp.mdl",
	Function =
		function(ply)
			ply:SelectWeapon("weapon_executioner_re")
		end,
	Price = 250000,
	Max = 1,
	Num = 27,
}

GM.Items["item_kap40"] = {
	Name = "Kap40",
	Desc = "Uses Pistol Ammo",
	Model = "models/weapons/w_pist_usp.mdl",
	Function =
		function(ply)
			ply:SelectWeapon("weapon_kap40_re")
		end,
	Price = 100000,
	Max = 1,
	Num = 28,
}

GM.Items["item_peace"] = {
	Name = "PeaceKeeper",
	Desc = "Uses Automatic Ammo",
	Model = "models/weapons/w_rif_m4a1.mdl",
	Function =
		function(ply)
			ply:SelectWeapon("weapon_peacekeeper_re")
		end,
	Price = 120000,
	Max = 1,
	Num = 29,
}

GM.Items["item_pdw"] = {
	Name = "PDW",
	Desc = "Uses Automatic Ammo",
	Model = "models/weapons/w_rif_famas.mdl",
	Function =
		function(ply)
			ply:SelectWeapon("weapon_pdw_re")
		end,
	Price = 200000,
	Max = 1,
	Num = 47,
}
