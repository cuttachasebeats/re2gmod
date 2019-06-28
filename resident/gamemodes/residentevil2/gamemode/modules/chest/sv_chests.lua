----------Chests
function inv_DepositItem(ply,command,Args)
	local Chest = ply.RE2Data["Chest"]
	local item = Args[1]
	local slot = math.Round(Args[2])
	if inv_ChestHasRoom(ply,item) then
		for k,v in pairs(Chest) do
			if v.Weapon == "none" then
				for a,b in pairs(GAMEMODE.Weapons) do
					if item == a then 
						Chest[k].Weapon = item
						Chest[k].Upgrades = ply.RE2Data["Upgrades"][v.Weapon]
						if b.Weapon != nil then
							ply:StripWeapon(b.Weapon)
						end
						ply.RE2Data["Upgrades"][v.Weapon] = {pwrlvl = 1, acclvl = 1, clplvl = 1, fislvl = 1,reslvl = 1}
						inv_RemoveItem(ply,slot)
						GAMEMODE:inv_UpdateChestSlot(ply,item,tonumber(k))
						break
					end
				end
				return
			end
		end
	end
end
concommand.Add("inv_DepositItem",inv_DepositItem)

function ServerLoadChestItem(ply,item,upgrade)
	local Chest = ply.RE2Data["Chest"]
	if inv_ChestHasRoom(ply,item) then
		for k,v in pairs(Chest) do
			if v.Weapon == "none" then
				for a,b in pairs(GAMEMODE.Weapons) do
					if item == a then 
						Chest[k].Weapon = item
						Chest[k].Upgrades = upgrade
						return
					end
				end
			end
		end
	end
end

function inv_WithdrawItem(ply,command,args)
	local weapon = args[1]
	local Chest = ply.RE2Data["Chest"]
	if inv_HasRoom(ply,weapon) then 
		for a,b in pairs(GAMEMODE.Weapons) do
			if weapon == a then
				if ply:Team() == TEAM_HUNK then
					if b.Weapon != nil then
						ply:Give(b.Weapon)
						ply:SelectWeapon(b.Weapon)
					end
				end
				inv_AddToInventory(ply,weapon)
				for k,v in pairs(Chest) do 
					if weapon == v.Weapon then
						ply.RE2Data["Upgrades"][weapon] = Chest[k].Upgrades
						print(util.TableToKeyValues(Chest[k].Upgrades))
						Chest[k] = {Weapon = "none",Upgrades = {pwrlvl = 1, acclvl = 1, clplvl = 1, fislvl = 1,reslvl = 1}}
						break
					end
				end
			end
		end
	end
	GAMEMODE:SendDataToAClient(ply)
end
concommand.Add("inv_WithdrawItem",inv_WithdrawItem)

function inv_ChestHasRoom(ply,item)
	local Chest = ply.RE2Data["Chest"]
	for k,v in pairs(Chest) do
		if v.Weapon == "none" then
			return true
		end
		for a,b in pairs(GAMEMODE.Weapons) do
			if a == item then
				if v.Weapon == item then
					return false
				end
			end
		end
	end
	return false
end


