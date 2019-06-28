--Customizable weapons / fas2 / etc support shim

if CustomizableWeaponry then
	RPG:AddAmmoType( "40MM", "sk_cw_max_40mmgrenades", 12, "cw_ammo_40mm", 1 )
	RPG:AddAmmoType( "Frag Grenades", "sk_cw_max_fraggrenades", 12, "cw_ammo_fraggrenades", 1 )
	
	--Customizable weapons Community Pack
	RPG:AddAmmoType( "4.6x30MM", "sk_cwcp_max_46x30mm", 400, false, "cw_ammo_46x30mm", 40 )
	RPG:AddAmmoType( "FN 5.7x28mm", "sk_cwcp_max_fn57x28mm", 240, false, "cw_ammo_57x28", 20 )
	
	--Unofficial Extras
	RPG:AddAmmoType( ".30 Winchester", "sk_cwx_max_30winchester", 25, false, "cw_ammo_30winchester", 5 )
	RPG:AddAmmoType( ".40 S&W", "sk_cwx_max_50sw", 144, false, "cw_ammo_40sw", 12 )
	RPG:AddAmmoType( ".338 Lapua", "sk_cwx_max_338lapua", 60, false, "cw_ammo_338lapua", 5 )
	RPG:AddAmmoType( ".357 Magnum", "sk_cwx_max_357magnum", 72, false, "cw_ammo_357magnum", 6 )
end

--A lot of shared ammo types between these addons - prefer CW values when present since
--FAS2 doesn't do any ammo limits

--Some of these are guesses for limits since I'm not greatly familiar with the weapon packs ( but they are cool! )
if CustomizableWeaponry or FAS2_Attachments then
	RPG:AddAmmoType( "12 Gauge", "sk_cw_max_12gauge", 72, false, "cw_ammo_12guage", 8 )
	RPG:AddAmmoType( "9x19MM", "sk_cw_max_9x19mm", 360, false, "cw_ammo_9x19", 30 )
	RPG:AddAmmoType( ".50 AE", "sk_cw_max_50ae", 84, false, "cw_ammo_50ae", 7 )
	RPG:AddAmmoType( ".45 ACP", "sk_cw_max_45acp", 132, false, "cw_ammo_45acp", 11 )
	RPG:AddAmmoType( "7.62x39MM", "sk_cw_max_762x39mm", 360, false, "cw_ammo_762x39", 30 )
	RPG:AddAmmoType( ".44 Magnum", "sk_cw_max_44magnum", 72, false, "cw_ammo_44magnum", 6 )
	RPG:AddAmmoType( "7.62x51MM", "sk_cw_max_762x51mm", 240, false, "cw_ammo_762x51", 20 )
	RPG:AddAmmoType( "5.56x45MM", "sk_cw_max_556x45mm", 360, false, "cw_ammo_556x45", 30 )
	RPG:AddAmmoType( "5.45x39MM", "sk_cw_max_545x39mm", 360, false, "cw_ammo_545x39", 30 )
	RPG:AddAmmoType( "9x18MM", "sk_cw_max_9x18mm", 360, false, "cw_ammo_9x18", 30 )
end

if FAS2_Attachments then
	RPG:AddAmmoType( "10x25MM", "sk_fas2_max_10x25mm", 300, false, "fas2_ammo_10x25mm", 25 )
	RPG:AddAmmoType( ".357 SIG", "sk_fas2_max_357sig", 130, false, "fas2_ammo_357sig", 13 )
	RPG:AddAmmoType( ".380 ACP", "sk_fas2_max_380acp", 320, false, "fas2_ammo_380acp", 32 )
	RPG:AddAmmoType( ".454 Casull", "sk_fas2_max_454casull", 60, false, "fas2_ammo_454casull", 5 )
	RPG:AddAmmoType( ".50 BMG", "sk_fas2_max_50bmg", 50, false, "fas2_ammo_50bmg", 5 )
	RPG:AddAmmoType( "23x75MMR", "sk_fas2_max_23x75mmr", 40, false, "fas2_ammo_23x75mmr", 4 )
	
	RPG:AddAmmoType( "40MM HE", "sk_fas2_max_40mmhe", 8, false, "fas2_ammo_40mmhe", 1 )
	RPG:AddAmmoType( "40MM Smoke", "sk_fas2_max_40mmsmoke", 8, false, "fas2_ammo_40mmsmoke", 1 )
	RPG:AddAmmoType( "M67 Grenades", "sk_fas2_max_m67grenades", 12, false, "fas2_ammo_m67grenades", 1 )
	
	RPG:AddAmmoType( "Bandages", "sk_fas2_max_bandages", 10, false, "fas2_ammo_bandages", 1 )
	RPG:AddAmmoType( "Quickclots", "sk_fas2_max_quickclots", 10, false, "fas2_ammo_quickclots", 1 )
	RPG:AddAmmoType( "Hemostats", "sk_fas2_max_hemostats", 10, false, "fas2_ammo_hemostats", 1 )
	RPG:AddAmmoType( "Ammoboxes", "sk_fas2_max_ammoboxes", 10, false, "fas2_ammo_ammoboxes", 1 )
	
	--The IFAK doesn't give the correct ammo type for quickclots
	RPG:AliasAmmoType( "Quickclots", "Quikclots" )
end