RPG.Pickups = RPG.Pickups or {
	["item_ammo_357"] = { A = 6, T = "357" },
	["item_ammo_357_large"] = { A = 12, T = "357" },
	["item_ammo_ar2"] = { A = 20, T = "AR2" },
	["item_ammo_ar2_large"] = { A = 40, T = "AR2" },
	["item_ar2_altfire"] = { A = 1, T = "AR2AltFire" },
	["item_ammo_pistol"] = { A = 20, T = "Pistol" },
	["item_ammo_pistol_large"] = { A = 40, T = "Pistol" },
	["item_ammo_smg1"] = { A = 45, T = "SMG1" },
	["item_ammo_smg1_large"] = { A = 90, T = "SMG1" },
	["item_ammo_smg1_grenade"] = { A = 1, T = "SMG1_Grenade" },
	["item_box_buckshot"] = { A = 20, T = "Buckshot" },
	["item_rpg_round"] = { A = 1, T = "RPG_Round" },
	["item_ammo_crossbow"] = { A = 6, T = "XBowBolt" },
}

function RPG:AddAmmoType( name, convarname, max, fake, pickup_name, pickup_amt )
	local c
	name = name:lower( )
	
	c = GetConVar( convarname )
	
	max = max or 4
	
	if not c and not fake then	
		c = CreateConVar( convarname, max, FCVAR_ARCHIVE + FCVAR_REPLICATED )
	elseif not c and fake then
		c = { GetInt = function( ) return max end, GetName = function( ) return convarname end }
	end
	
	self.AmmoTypes[ name ] = c
	
	--ConVar:GetDefault returns nil on Lua-created convars...
	
	self.Defaults[ name ] = max
	
	if pickup_name and pickup_amt then
		self.Pickups[ pickup_name ] = { A = pickup_amt, T = name }
	end
end

function RPG:AliasAmmoType( what, to )
	self.AmmoTypes[ to:lower( ) ] = self.AmmoTypes[ what:lower( ) ]
end

function RPG:MaxAmmo( pl, type )

	if type == "" then
		return 0
	end
	
	if GetConVar( "rpg_cfg_noammolimit" ):GetBool( ) then
		return math.huge
	end

	type = type:lower( )
	
	if not RPG.AmmoTypes[ type ] then
		return math.huge
	end
	
	local base = RPG.AmmoTypes[ type ]:GetInt( )
	return math.floor( base + base * .015 * RPG:GetSkill( pl, self.XSkills.STOCKPILE ) )
end

if 1 then
	RPG:AddAmmoType( "AR2", "sk_max_ar2", 90 )
	RPG:AddAmmoType( "AlyxGun", "sk_max_alyxgun", 150 )
	RPG:AddAmmoType( "Pistol", "sk_max_pistol", 110 )
	RPG:AddAmmoType( "SMG1", "sk_max_smg1", 120 )
	RPG:AddAmmoType( "357", "sk_max_357", 60 )
	RPG:AddAmmoType( "XBowBolt", "sk_max_crossbow", 50 )
	RPG:AddAmmoType( "Buckshot", "sk_max_buckshot", 25 )
	RPG:AddAmmoType( "RPG_Round", "sk_max_rpg_round", 4 )
	RPG:AddAmmoType( "SMG1_Grenade", "sk_max_smg1_grenade", 3 )
	RPG:AddAmmoType( "SniperRound", "sk_max_sniper_round", 10 )
	RPG:AddAmmoType( "Grenade", "sk_max_grenade", 5 )
	RPG:AddAmmoType( "GaussEnergy", "sk_max_gauss_round", 6 )
	RPG:AddAmmoType( "AR2AltFire", "sk_max_ar2_altfire", 3 )

--Fakes ( supported ammo types, no convars )

	RPG:AddAmmoType( "SniperPenetratedRound", "sk_max_sniper_penetrated", 100 )
	RPG:AddAmmoType( "Thumper", "sk_max_thumper", 100 )
	RPG:AddAmmoType( "Gravity", "sk_max_gravity", 100 )
	RPG:AddAmmoType( "Battery", "sk_max_battery", 6 )
	RPG:AddAmmoType( "CombineCannon", "sk_max_combine_cannon", 6 )
	RPG:AddAmmoType( "AirboatGun", "sk_max_airboatgun", 100 )
	RPG:AddAmmoType( "StriderMinigun", "sk_max_strider_minigun", 200 )
	RPG:AddAmmoType( "HelicopterGun", "sk_max_helicoptergun", 100 )
	RPG:AddAmmoType( "Slam", "sk_max_slam", 5 )
end

function RPG:LoadExtraAmmo( )
	local k, v
	
	for k, v in pairs( file.Find( "ammo_compat/*.lua", "LUA" ) ) do
		IncludeCS( "ammo_compat/" .. v )
	end

	if CLIENT then
		RPG:RebuildUI( true )
	end
end

hook.Add( "InitPostEntity", RPG, RPG.LoadExtraAmmo )