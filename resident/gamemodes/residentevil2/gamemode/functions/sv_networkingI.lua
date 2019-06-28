--Resident Evil: 2 Garry's Mod
---derma------------------------------


---Invtory----------------------------

--------------------------------------

function InvTransfer( ply )
	ply = ply or player.GetAll()
	net.Start( "InvTransfer" )
		net.WriteTable(ply.RE2Data["Inventory"])
		net.WriteTable(ply.RE2Data["Upgrades"])
		net.WriteTable(ply.RE2Data["Chest"])
	net.Send( ply )
end

concommand.Add("InvUpdate",
	function(ply,command,args)
	GAMEMODE:SendDataToAClient(ply)
	end)
	
function GM:SendDataToAClient(ply)

	InvTransfer(ply)
	
end