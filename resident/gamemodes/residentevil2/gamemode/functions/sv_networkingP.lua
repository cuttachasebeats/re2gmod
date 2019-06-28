--Resident Evil: 2 Garry's Mod
---derma------------------------------


---Invtory----------------------------

--------------------------------------

--Weapon Upgrades
function inv_PerkStat(ply)
	ply = ply or player.GetAll()
	net.Start("PerkTransfer")
	net.WriteTable( {Perks = ply.Perks, ActPs = ply.ActivePerks} )
	net.Send( ply )
end

function GM:SendDataToAClient2(ply)

	inv_PerkStat(ply)
	
end
