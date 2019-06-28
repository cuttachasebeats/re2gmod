--Resident Evil: 2 Garry's Mod
---derma------------------------------




--------------------------------------

function GM:inv_UpdateSlot(ply,str_Item,int_Slot,int_Amount)
	net.Start("RE2_UpdateSlot")
	net.WriteInt(int_Slot,16)
	net.WriteString(str_Item)
	net.WriteInt(int_Amount,16)
	net.Send( ply )
end