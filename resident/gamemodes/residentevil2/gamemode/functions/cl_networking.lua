function SendDataToServer()
	net.Start("VoteTransfer")
		net.WriteTable{ VoteOption["Map"], VoteOption["Game"],VoteOption["Difficulty"]  }
	net.SendToServer()
end
concommand.Add("VoteUpdate",SendDataToServer)

net.Receive( "InvTransfer", function(len)
	-- Oh god... my code is so gross. Oh well
	Inventory = net.ReadTable()
	Upgrades = net.ReadTable()
	Chest = net.ReadTable()
	if bool_InvOpen then
        ReLoadInvList()
		bool_CanClose = true
		if bool_IsUpging then
				UpgUpdate()
	    end
		if IsChesting then
			ReloadChest()
		end
	end
end)

net.Receive("PerkTransfer", function()

	Perks = net.ReadTable()
		if IsPerking then
			ReloadPerks()
		end
end)