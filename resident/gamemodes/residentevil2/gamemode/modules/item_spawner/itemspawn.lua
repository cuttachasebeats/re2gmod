function GM:UpdateMap()
	for k,v in pairs(ents.FindByClass("item_*")) do
		if v:GetClass() ==  "item_item_crate" then
			local itembase = ents.Create("reward_crate")
			itembase:Spawn()
			itembase:SetPos(v:GetPos())
			local keyvaluetable = v:GetKeyValues()
			if keyvaluetable.ItemCount != 0 then
				itembase.Amount = keyvaluetable.ItemCount
			else
				itembase.Amount = math.random(1,4)
			end
			print(keyvaluetable.ItemClass)
			if keyvaluetable.ItemClass == "item_pammo" then
				keyvaluetable.ItemClass = "item_ammo_pistol"
			elseif keyvaluetable.ItemClass == "item_mammo" then
				keyvaluetable.ItemClass = "item_ammo_smg"
			elseif keyvaluetable.ItemClass == "item_bammo" then
				keyvaluetable.ItemClass = "item_ammo_buckshot"
			elseif keyvaluetable.ItemClass == "item_rammo" then
				keyvaluetable.ItemClass = "item_ammo_rifle"
			end
			itembase.Item = tostring(keyvaluetable.ItemClass)
			v:Remove()
		end
	end
end

function GM:str_SelectRandomItem()
	local itemnumber = math.random(1,118)
	local itemtype = "item_ammo_pistol"
	if itemnumber == 1 then
		itemtype = "item_tcure"
	elseif (itemnumber >= 2 && itemnumber <= 4) then
		itemtype =  "item_spray"
	elseif (itemnumber >= 5 && itemnumber <= 20) then
		itemtype =  "item_ammo_pistol"
	elseif (itemnumber >= 21 && itemnumber <= 35) then
		itemtype =  "item_ammo_buckshot"
	elseif (itemnumber >= 36 && itemnumber <= 50) then
		itemtype =  "item_ammo_smg"
	elseif (itemnumber >= 51 && itemnumber <= 65) then
		itemtype =  "item_ammo_rifle"
	elseif (itemnumber >= 66 && itemnumber <= 75) then
		itemtype = "item_landmine"
	elseif (itemnumber >= 76 && itemnumber <= 85) then
		itemtype = "item_c4"
	elseif (itemnumber >= 86 && itemnumber <= 92) then
		itemtype = "item_ammo_magnum"
	elseif (itemnumber >= 93 && itemnumber <= 97) then
		itemtype = "item_ammo_rocket"
	elseif (itemnumber == 98 ) then
		itemtype = "item_ammo_gl_explosive"
	elseif (itemnumber == 99 ) then
		itemtype = "item_ammo_gl_flame"
	elseif (itemnumber == 100 ) then
		itemtype = "item_ammo_gl_freeze"
	elseif (itemnumber >= 101 && itemnumber <= 106 ) then
		itemtype = "item_ammo_sniper"
	elseif (itemnumber >= 107 && itemnumber <= 112 ) then
		itemtype = "item_herb"
	elseif (itemnumber >= 113 && itemnumber <= 118 ) then
		itemtype = "item_rherb"
	end
	return itemtype
end