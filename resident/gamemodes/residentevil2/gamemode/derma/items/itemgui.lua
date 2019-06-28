function GUI_RANDOM_ITEM(GUI_Item_Icon,ent_WorldEntity)

	if !GUI_Item_Icon:IsValid() then return end

	ent_WorldEntity:SetModel(table.Random(GAMEMODE.Items).Model)

	GUI_Item_Icon:SetModel(ent_WorldEntity:GetModel())

	local center = ent_WorldEntity:OBBCenter()
	local dist = ent_WorldEntity:BoundingRadius()*1.3

	GUI_Item_Icon:SetLookAt(center)
	GUI_Item_Icon:SetCamPos(center+Vector(dist,dist,0))

	timer.Simple(1,function() GUI_RANDOM_ITEM(GUI_Item_Icon,ent_WorldEntity) end )
end