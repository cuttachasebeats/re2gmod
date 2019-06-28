---------------------------Load Next Map Function------------------

function GM:LoadNextMap()
	game.LoadNextMap()
end


---------------------Add Time To Amount Of Players In Server For VIP---------------

function GM:AddToTime(ply)
	if ply:Team() == TEAM_HUNK then
		if ply:Alive() then
			ply:SetNWInt("Time", ply:GetNWInt("Time") + 1)
		end
	end
end

-------------------------Perk Mounting System-------------------------

-- All About the Perks
function HasRoomForPerk(ply)
	local activeperks = ply.ActivePerks
	for k,v in pairs(activeperks) do
		if ply.ActivePerks[k] == 0 then 
			return true
		end
	end
	return false
end

function HasPerk(ply,perk)
	local perks = ply.Perks
	for k,v in pairs(perks) do
		if v.Perk == perk && !v.Active then 
			return true
		end
	end
	return false
end

function UnMountPerk(ply,command,args)
	local activeperks = ply.ActivePerks
	local perks = ply.Perks
	local Perk = args[1]
	for k,v in pairs(activeperks) do
		if v == Perk then
			print(v)
			ply.ActivePerks[k] = 0
			GAMEMODE.Perks[Perk].RemoveFunction(ply)
				for a,b in pairs(perks) do
					if b.Perk == Perk && b.Active then	
						b.Active = false
						break
					end
				end
			break
		end
	end
	GAMEMODE.SendDataToAClient2(ply)
end
concommand.Add("UnMountPerk",UnMountPerk)

function MountPerk(ply,command,args)
	local activeperks = ply.ActivePerks
	local perks = ply.Perks
	local Perk = tostring(args[1])
	if HasRoomForPerk(ply) then
		for k,v in pairs (ply.ActivePerks) do
			if ply.ActivePerks[k] == 0 && HasPerk(ply,Perk) then
				print(v)
				print(Perk)
				ply.ActivePerks[k] = Perk
				for a,b in pairs(perks) do
					if b.Perk == Perk && !b.Active then	
						b.Active = true
						break
					end
				end
				GAMEMODE.Perks[Perk].AddFunction(ply)
				PrintTable(ply.ActivePerks)
				break
			end
		end	
	end
	GAMEMODE.SendDataToAClient2(ply)
end
concommand.Add("MountPerk",MountPerk)

function PurchasePerk(ply,command,args)
	local cash = tonumber(ply:GetNWInt("Money"))
	local Perk = tostring(args[1])
	local addtable = {
		Perk = tostring(Perk),
		Active = false,
		}
	print(Perk)
	if cash >= GAMEMODE.Perks[Perk].Price then
		ply:SetNWInt("Money", cash - GAMEMODE.Perks[Perk].Price)
		table.insert(ply.Perks,addtable)
		PrintTable(ply.Perks)
	end
	GAMEMODE.SendDataToAClient2(ply)
end
concommand.Add("PurchasePerk",PurchasePerk)
