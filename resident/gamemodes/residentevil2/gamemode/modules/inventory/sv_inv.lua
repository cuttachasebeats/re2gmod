function inv_AddToInventory(ply,item)
	local Inv = ply.RE2Data["Inventory"]
	for k,v in pairs(Inv) do
		if v.Item == "none"  then
			for a,b in pairs(GAMEMODE.Weapons) do
				if v.Item == a then
					Inv[k].Item = item
					Inv[k].Amount = Inv[k].Amount + 1
					GAMEMODE:inv_UpdateSlot(ply,item,slot,Inv[slot].Amount)
					return
				end
			end
			Inv[k].Item = item
			Inv[k].Amount =  1
			GAMEMODE:inv_UpdateSlot(ply,item,k,Inv[k].Amount)
			return
		elseif v.Item == item && v.Amount >= GAMEMODE.Items[v.Item].Max then
			print(fail)
		elseif v.Item == item && v.Amount < GAMEMODE.Items[v.Item].Max then
				Inv[k].Item = item
				Inv[k].Amount = Inv[k].Amount + 1
				GAMEMODE:inv_UpdateSlot(ply,item,k,Inv[k].Amount)
				return
		end
	end
end

function inv_RemoveItem(ply,slot)
	local Inv = ply.RE2Data["Inventory"]
	Inv[math.Round(slot)] = {Item = "none",Amount = 0}
	GAMEMODE:inv_UpdateSlot(ply,"none",slot,0)
end

function inv_GiveItem(ply,command,args)
	local item = args[1]
	local slot = tonumber(math.Round(args[2]))
	local id = math.Round(args[3])
	local rply = player.GetByID(id)
	local Inv = ply.RE2Data["Inventory"]
	local rInv = rply.RE2Data["Inventory"]
	if !inv_HasItem(ply,item,slot) then return end
	if ply:GetPos():Distance(rply:GetPos()) > 300 then return end
	if inv_HasRoom(rply,item) then
		inv_AddToInventory(rply,item)
		rply:PrintMessage(HUD_PRINTTALK,ply:Nick().." gave you a "..GAMEMODE.Items[item].Name)
		if Inv[math.Round(args[2])].Amount <=  1 then
			inv_RemoveItem(ply,math.Round(args[2]))
		else
			Inv[math.Round(args[2])].Amount = Inv[math.Round(args[2])].Amount - 1
			GAMEMODE:inv_UpdateSlot(ply,item,slot,Inv[slot].Amount)
		end
		for k,v in pairs(GAMEMODE.Weapons) do
			if item == k then
				ply:EmitSound("items/ammo_pickup.wav",110,100)
				if v.Weapon != nil then
					ply:StripWeapon(v.Weapon)
					rply:Give(v.Weapon)
					rply:SelectWeapon(v.Weapon)
				end
				rply.RE2Data["Upgrades"][item] = ply.RE2Data["Upgrades"][item]
				ply.RE2Data["Upgrades"][item] = {pwrlvl = 1,acclvl = 1, clplvl = 1,fislvl = 1,reslvl = 1}
				inv_RemoveItem(ply,math.Round(args[2]))
				rply:GetActiveWeapon():Update()
				break
			end
		end
	else
		GAMEMODE:inv_UpdateSlot(ply,item,slot,Inv[slot].Amount)
		ply:PrintMessage(HUD_PRINTTALK,rply:Nick().." can't carry that item.")
	end

end
concommand.Add("inv_GiveItem",inv_GiveItem)

function inv_UseItemOnPly(ply,command,args)
	local item = args[1]
	local slot = tonumber(math.Round(args[2]))
	local id = math.Round(args[3])
	local rply = player.GetByID(id)
	local Inv = ply.RE2Data["Inventory"]
	local rInv = rply.RE2Data["Inventory"]
	if !inv_HasItem(ply,item,slot) then return end
	if ply:GetPos():Distance(rply:GetPos()) > 300 then return end
		if GAMEMODE.Items[item].Condition != nil then
			if GAMEMODE.Items[item].Condition(rply,item) then
				GAMEMODE.Items[item].Function(rply,item)
			else
				GAMEMODE:inv_UpdateSlot(ply,item,slot,Inv[slot].Amount)
				return
			end
		rply:PrintMessage(HUD_PRINTTALK,ply:Nick().." used a "..GAMEMODE.Items[item].Name.." on you.")
		end
		if Inv[math.Round(args[2])].Amount <=  1 then
			inv_RemoveItem(ply,math.Round(args[2]))
		else
			Inv[math.Round(args[2])].Amount = Inv[math.Round(args[2])].Amount - 1
			GAMEMODE:inv_UpdateSlot(ply,item,slot,Inv[slot].Amount)
		end
	if item == "item_spray" then
		ply:AddStat("TeammatesSprayed", 1)
	elseif item == "item_tcure" then
		ply:AddStat("TeammatesCured", 1)
	else
		ply:AddStat("TeammatesSupplied", 1)
	end


end
concommand.Add("inv_UseItemOnPly",inv_UseItemOnPly)

function inv_HasRoom(ply,item)
	local Inv = ply.RE2Data["Inventory"]
	local MaxWeapons = 3
	for k,v in pairs(Inv) do
		if GAMEMODE.Weapons[v.Item] != nil then
			if GAMEMODE.Weapons[v.Item].Size == nil then
				MaxWeapons = MaxWeapons - 1
			else
				MaxWeapons = MaxWeapons - GAMEMODE.Weapons[v.Item].Size
			end
		end
	end
	if GAMEMODE.Weapons[item] != nil then
		if GAMEMODE.Weapons[item].Size == nil then
			MaxWeapons = MaxWeapons - 1
		else
			MaxWeapons = MaxWeapons - GAMEMODE.Weapons[item].Size
		end
		if MaxWeapons < 0 then
			if ply.nextchatprint == nil || ply.nextchatprint < CurTime() then
				ply:ChatPrint("Too many weapons")
				ply.nextchatprint = CurTime() + 0.5
			end
			return false
		end
	end

	for k,v in pairs(Inv) do
		for a,b in pairs(GAMEMODE.Weapons) do
			if a == item then
				if v.Item == item then
					return false
				end
			end
		end
			if v.Item == "none" && v.Amount == 0 then
				return true
			elseif v.Item == item then
				if v.Amount < GAMEMODE.Items[v.Item].Max then
					return true
				elseif v.Amount >= GAMEMODE.Items[v.Item].Max then
					for k,v in pairs(ply.RE2Data["Inventory"]) do
						if v.Item == "none" && v.Amount == 0 then
							return true
						elseif v.Item == item then
							if v.Amount < GAMEMODE.Items[v.Item].Max then
								return true
							end
						end
					end
					return false
				end

			end
	end
	return false
end


function inv_HasItem(ply,item,slot)
	local Inv = ply.RE2Data["Inventory"]
	if slot != nil then
		for _,data in pairs(Inv) do
			if data.Item == item && slot == _ then
				return true
			end
		end
	else
		for _,data in pairs(Inv) do
			if data.Item == item then
				return true
			end
		end
	end
	return false
end


function inv_DropItem(ply,command,args)
	local item = args[1]
	local slot = math.Round(args[2])
	local Inv = ply.RE2Data["Inventory"]
	if !inv_HasItem(ply,item,slot) then return end
	for k,v in pairs(GAMEMODE.Weapons) do
		if item == k then
			if v.Weapon != nil then
				ply:StripWeapon(v.Weapon)
			end
		end
	end
	inv_MakeAndThrow(ply,item,args[3])
	if Inv[slot].Amount <=  1 then
		inv_RemoveItem(ply,slot)
	else
		Inv[slot].Amount = Inv[slot].Amount - 1
		GAMEMODE:inv_UpdateSlot(ply,item,slot,Inv[slot].Amount)
	end
end
concommand.Add("inv_DropItem",inv_DropItem)


function inv_MakeAndThrow(ply,item,force)
	local tr = ply:GetEyeTrace()
	local DropedEnt = ents.Create("item_base")
	DropedEnt:SetNWString("Class", item)
	DropedEnt:SetAngles(ply:EyeAngles())
	DropedEnt:Spawn()
	if item == "item_c4" || item == "item_landmine" then
		DropedEnt:SetPos(ply:GetPos())
	else
		DropedEnt:SetPos(ply:EyePos() + (ply:GetAimVector() * 30))
		if DropedEnt:GetPhysicsObject():IsValid() then
			DropedEnt:GetPhysicsObject():ApplyForceCenter(ply:GetAimVector() * 120)
		end
	end
	for k,v in pairs(GAMEMODE.Weapons) do
		if DropedEnt:GetNWString("Class") == k then
			DropedEnt.Upgrades = {}
			DropedEnt.Upgrades = ply.RE2Data["Upgrades"][v.Item]
			DropedEnt.hasupgrade = true
			ply.RE2Data["Upgrades"][v.Item] = {pwrlvl = 1,acclvl = 1, clplvl = 1,fislvl = 1,reslvl = 1}
		end
	end
	timer.Simple(600,function() if DropedEnt:IsValid() then DropedEnt:Remove() end end)
end

function inv_UpgradeWeapon(ply,command,args)
	local tblUpg = ply.RE2Data["Upgrades"]
	local strWeapon = args[1]
	local strTrait = args[2]
	local cash = tonumber(ply:GetNWInt("Money"))
	local intPowerLevel = tblUpg[strWeapon].pwrlvl
	local intAccuracyLevel = tblUpg[strWeapon].acclvl
	local intClipSizeLevel = tblUpg[strWeapon].clplvl
	local intFiringSpeedLevel = tblUpg[strWeapon].fislvl
	local intReloadSpeedLevel = tblUpg[strWeapon].reslvl
	local strStat = "String"
	if strTrait == "Power" && tblUpg[strWeapon].pwrlvl < #GAMEMODE.Weapons[strWeapon].UpGrades.Power then
		local intPrice = GAMEMODE.Weapons[strWeapon].UpGrades.Power[intPowerLevel].Price
		if cash >= intPrice then
			ply:SetNWInt("Money", cash - intPrice)
			tblUpg[strWeapon].pwrlvl = tblUpg[strWeapon].pwrlvl + 1
			strStat = "pwrlvl"
		end
	elseif strTrait == "Accuracy" && tblUpg[strWeapon].acclvl < #GAMEMODE.Weapons[strWeapon].UpGrades.Accuracy  then
		local intPrice = GAMEMODE.Weapons[strWeapon].UpGrades.Accuracy[intAccuracyLevel].Price
		if  cash >= intPrice then
			ply:SetNWInt("Money", cash - intPrice)
			tblUpg[strWeapon].acclvl = tblUpg[strWeapon].acclvl + 1
			strStat = "acclvl"
		end
	elseif strTrait == "ClipSize" && tblUpg[strWeapon].clplvl < #GAMEMODE.Weapons[strWeapon].UpGrades.ClipSize then
		local intPrice = GAMEMODE.Weapons[strWeapon].UpGrades.ClipSize[intClipSizeLevel].Price
		if  cash >= intPrice then
			ply:SetNWInt("Money", cash - intPrice)
			tblUpg[strWeapon].clplvl = tblUpg[strWeapon].clplvl + 1
			strStat = "clplvl"
		end
	elseif strTrait == "FiringSpeed" && tblUpg[strWeapon].fislvl < #GAMEMODE.Weapons[strWeapon].UpGrades.FiringSpeed  then
		local intPrice = GAMEMODE.Weapons[strWeapon].UpGrades.FiringSpeed[intFiringSpeedLevel].Price
		if  cash >= intPrice then
			ply:SetNWInt("Money", cash - intPrice)
			tblUpg[strWeapon].fislvl = tblUpg[strWeapon].fislvl + 1
			strStat = "fislvl"
		end
	elseif strTrait == "ReloadSpeed" && intReloadSpeedLevel < #GAMEMODE.Weapons[strWeapon].UpGrades.ReloadSpeed then
		local intPrice = GAMEMODE.Weapons[strWeapon].UpGrades.ReloadSpeed[intReloadSpeedLevel].Price
		if cash >= intPrice then
			ply:SetNWInt("Money", cash - intPrice)
			tblUpg[strWeapon].reslvl = tblUpg[strWeapon].reslvl + 1
			strStat = "reslvl"
		end
	end
	if ply:GetActiveWeapon():GetClass() == GAMEMODE.Weapons[strWeapon].Weapon then
		ply:GetActiveWeapon():Update()
	end
	GAMEMODE:inv_UpdateWeaponStat(ply,strWeapon,strStat,tblUpg[strWeapon][strStat])
end
concommand.Add("inv_UpgradeWeapon",inv_UpgradeWeapon)

function inv_BuyItem(ply,command,args)
	local inv = ply.RE2Data["Inventory"]
	local cash = tonumber(ply:GetNWInt("Money"))
	local item = args[1]
	local price = GAMEMODE.Items[item].Price
	if inv_HasRoom(ply,item) then
		if cash >= price then
			inv_AddToInventory(ply,item)
			ply:SetNWInt("Money",cash - price)
			------------------Weapons
			for k,v in pairs(GAMEMODE.Weapons) do
				if item == k then
					if ply:Team() == TEAM_HUNK then
						if GAMEMODE.Weapons[k].Weapon != nil then
							ply:Give(GAMEMODE.Weapons[k].Weapon)
						end
						ply.RE2Data["Upgrades"][k] = {pwrlvl = 1, acclvl = 1, clplvl = 1,fislvl = 1,reslvl = 1 }
					end
				end
			end
		end
	end
end
concommand.Add("inv_BuyItem",inv_BuyItem)


function inv_UseItem(ply,command,args)
	local item = args[1]
	local slot = math.Round(args[2])
	local Inv = ply.RE2Data["Inventory"]
	if !inv_HasItem(ply,item,slot) then return end
	if Inv[slot].Item != "none" then
		if GAMEMODE.Items[item].Condition != nil then
			if GAMEMODE.Items[item].Condition(ply,item) then
				GAMEMODE.Items[item].Function(ply,item)
			else
				GAMEMODE:inv_UpdateSlot(ply,item,slot,Inv[slot].Amount)
				return
			end
		else
			GAMEMODE.Items[item].Function(ply,item)
		end
		for k,v in pairs(GAMEMODE.Weapons) do
			if item == k then
				return
			end
		end
		if Inv[slot].Amount <=  1 then
			inv_RemoveItem(ply,args[2])
		else
			Inv[slot].Amount = Inv[slot].Amount - 1
			GAMEMODE:inv_UpdateSlot(ply,item,slot,Inv[slot].Amount)
		end
	end
end
concommand.Add("inv_UseItem",inv_UseItem)

