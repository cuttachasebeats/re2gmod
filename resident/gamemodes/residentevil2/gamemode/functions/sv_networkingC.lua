--Resident Evil: 2 Garry's Mod
---derma------------------------------


---Invtory----------------------------

--------------------------------------

--Chest Slots
function GM:inv_UpdateChestSlot(ply,str_Item,int_slot)
	net.Start("RE2_UpdateChestSlot")
	net.WriteString(str_Item)
	net.WriteInt(int_slot, 16)
	net.WriteString(tostring(ply.RE2Data["Chest"][int_slot].Upgrades.pwrlvl))
	net.WriteString(tostring(ply.RE2Data["Chest"][int_slot].Upgrades.acclvl))
	net.WriteString(tostring(ply.RE2Data["Chest"][int_slot].Upgrades.clplvl))
	net.WriteString(tostring(ply.RE2Data["Chest"][int_slot].Upgrades.fislvl))
	net.WriteString(tostring(ply.RE2Data["Chest"][int_slot].Upgrades.reslvl))
	net.Send( ply )
end
