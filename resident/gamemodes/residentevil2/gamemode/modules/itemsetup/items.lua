GM.Items = {}

-------------------------------------------------------------
---Items------------------------
-------------------------------------------------------------
GM.Items["item_spray"] = {
	Name = translate.Get("spray"),-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display
	Desc = translate.Get("spray_desc"),-- The description
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
	Name = translate.Get("green_herb"),-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display
	Desc = translate.Get("green_herb_desk"),-- The description
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
	Name = translate.Get("red_herb"),
	Desc = translate.Get("red_herb_desk"),
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
			ply:PrintTranslatedMessage(HUD_PRINTTALK, "infection_lowered")
			ply:EmitSound("items/smallmedkit1.wav",110,100)

			ply:AddStat("CuresUsed", 1)

		end,
	Price = 250,
	Max = 2,
	Num = 2,
}

GM.Items["item_tcure"] = {
	Name = translate.Get("tvirus_cure"),
	Desc = translate.Get("tvirus_cure_desk"),
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
			ply:PrintTranslatedMessage(HUD_PRINTTALK, "infection_cured")
			ply:EmitSound("HL1/fvox/antidote_shot.wav",110,100)

			ply:AddStat("CuresUsed", 1)

		end,
	Price = 500,
	Max = 1,
	Num = 2,
}

GM.Items["item_ammo_pistol"] = {
	Name = translate.Get("pistol_ammo"),
	Desc = translate.Get("pistol_ammo_desk"),
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
	Name = translate.Get("shotgun_ammo"),
	Desc = translate.Get("shotgun_ammo_desk"),
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
	Name = translate.Get("auto_ammo"),
	Desc = translate.Get("auto_ammo_desk"),
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
	Name = translate.Get("rifle_ammo"),
	Desc = translate.Get("rifle_ammo_desk"),
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
	Name = translate.Get("magnum_ammo"),
	Desc = translate.Get("magnum_ammo_desk"),
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
	Name = translate.Get("sniper_ammo"),
	Desc = translate.Get("sniper_ammo_desk"),
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
	Name = translate.Get("rocket_round"),
	Desc = translate.Get("rocket_round_desk"),
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
	Name = translate.Get("explosive_rounds"),
	Desc = translate.Get("explosive_rounds_desk"),
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
	Name = translate.Get("flame_rounds"),
	Desc = translate.Get("flame_rounds_desk"),
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
	Name = translate.Get("freeze_rounds"),
	Desc = translate.Get("freeze_rounds_desk"),
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
	Name = translate.Get("pistol_9mm"),
	Desc = translate.Get("pistol_ammo_use"),
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
	Name = translate.Get("m4a1"),
	Desc = translate.Get("rifle_ammo_use"),
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
	Name = translate.Get("p90"),
	Desc = translate.Get("automatic_ammo_use"),
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
	Name = translate.Get("pump_shotgun"),
	Desc = translate.Get("shotgun_ammo_use"),
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
	Name = translate.Get("glock18"),
	Desc = translate.Get("pistol_ammo_use"),
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
	Name = translate.Get("aug"),
	Desc = translate.Get("rifle_ammo_use"),
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
	Name = translate.Get("mp5"),
	Desc = translate.Get("automatic_ammo_use"),
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
	Name = translate.Get("ragerev"),
	Desc = translate.Get("magnum_ammo_use"),
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
	Name = translate.Get("ump"),
	Desc = translate.Get("automatic_ammo_use"),
	Model = "models/weapons/w_smg_ump45.mdl",
	Function =
		function(ply)
			ply:SelectWeapon("weapon_ump_re")
		end,
	Price = 1450,
	Max = 1,
	Num = 18,
}
GM.Items["item_deagle"] =
{
	Name = translate.Get("deagle"),
	Desc = translate.Get("magnum_ammo_use"),
	Model = "models/weapons/w_pist_deagre.mdl",
	Function =
		function(ply)
			ply:SelectWeapon("weapon_deagle_re")
		end,
	Price = 3750,
	Max = 1,
	Num = 19,
}
GM.Items["item_p228"] =
{
	Name = translate.Get("p228"),
	Desc = translate.Get("pistol_ammo_use"),
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
	Name = translate.Get("ak47"),
	Desc = translate.Get("rifle_ammo_use"),
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
	Name = translate.Get("striker7"),
	Desc = translate.Get("shotgun_ammo_use"),
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
	Name = translate.Get("spas12"),
	Desc = translate.Get("shotgun_ammo_use"),
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
	Name = translate.Get("m29"),
	Desc = translate.Get("magnum_ammo_use"),
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
	Name = translate.Get("gravgun"),
	Desc = translate.Get("gravgun_desk"),
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
	Name = translate.Get("awp"),
	Desc = translate.Get("sniper_ammo_use"),
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
	Name = translate.Get("scout"),
	Desc = translate.Get("sniper_ammo_use"),
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
	Name = translate.Get("m79"),
	Desc = translate.Get("m79_desk"),
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
	Name = translate.Get("quadrpg"),
	Desc = translate.Get("quadrpg_desk"),
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
	Name = translate.Get("minigun"),
	Desc = translate.Get("minigun_desk"),
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
	Name = translate.Get("bandolier"),
	Desc = translate.Get("bandolier_desk"),
	Model = "models/HMG_AmmoBox.mdl",
	Function =
		function(ply)
		ply:SelectWeapon("weapon_minigun_re")
		end,
	Price = 30000,
	Max = 1,
	Num = 23,
}

-------------------------------------------------------------
---Special Items (explosives and stuff)------------------------
-------------------------------------------------------------
GM.Items["item_expbarrel"] = {
	Name = translate.Get("expbarrel"),
	Desc = translate.Get("expbarrel_desk"),
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
	Name = translate.Get("c4"),
	Desc = translate.Get("c4_desk"),
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
	Name = translate.Get("proximity_mine"),
	Desc = translate.Get("proximity_mine_desk"),
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
	Name = translate.Get("an94"),
	Desc = translate.Get("rifle_ammo_use"),
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
	Name = translate.Get("ballista"),
	Desc = translate.Get("sniper_ammo_use"),
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
	Name = translate.Get("dsr50"),
	Desc = translate.Get("sniper_ammo_use"),
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
	Name = translate.Get("executioner"),
	Desc = translate.Get("pistol_ammo_use"),
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
	Name = translate.Get("kap40"),
	Desc = translate.Get("pistol_ammo_use"),
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
	Name = translate.Get("peace"),
	Desc = translate.Get("automatic_ammo_use"),
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
	Name = translate.Get("pdw"),
	Desc = translate.Get("automatic_ammo_use"),
	Model = "models/weapons/w_rif_famas.mdl",
	Function =
		function(ply)
			ply:SelectWeapon("weapon_pdw_re")
		end,
	Price = 200000,
	Max = 1,
	Num = 47,
}
