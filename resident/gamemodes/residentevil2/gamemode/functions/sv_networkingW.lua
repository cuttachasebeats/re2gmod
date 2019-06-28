--Resident Evil: 2 Garry's Mod
---derma------------------------------


---Invtory----------------------------

--------------------------------------

--Weapon Upgrades
function GM:inv_UpdateWeaponStat(ply,str_Weapon,str_Stat,int_Level)
	net.Start("RE2_UpdateWeaponStat")
	net.WriteString(str_Weapon)
	net.WriteString(str_Stat)
	net.WriteInt(int_Level,16)
	net.Send( ply )
end