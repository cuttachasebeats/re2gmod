print("Inventory derma loaded")
--------Inventory Slots---------
net.Receive("RE2_UpdateSlot", function()

	local slot = net.ReadInt(16)
	local item = net.ReadString()
	local amount = net.ReadInt(16)
	Inventory[slot].Item = tostring(item)
	Inventory[slot].Amount = amount
	if GlobalBuyGUIs != nil then
		--GUI_LoadInventory(GUI_Inventory_Panel)
		GlobalBuyGUIs = nil
	end
	if Invframe == nil then return end
	if Invframe:IsValid() then
		ReLoadInvList()
		bool_CanClose = true
	end


end)


-----Weapon Stats---------------
net.Receive("RE2_UpdateWeaponStat", function()

	local weapon = net.ReadString()
	local stat = net.ReadString()
	local level = net.ReadInt(16)
	local Upg = Upgrades[weapon]
	Upg[stat] = level
	if GlobalGUIs != nil then
		GUI_Inventory_Update_Weapon_Stats(GlobalGUIs[1],GlobalGUIs[2],GlobalGUIs[3])
		GlobalGUIs = nil
	end

end)



----------Chest Slots-------
net.Receive("RE2_UpdateChestSlot", function()

	local weapon = net.ReadString()
	local slot = net.ReadInt(16)
	local pwrlvl = net.ReadTable()
	local acclvl = net.ReadTable()
	local clplvl = net.ReadTable()
	local fislvl = net.ReadTable()
	local reslvl = net.ReadTable()

	Chest[slot].Weapon = weapon
	Chest[slot]["Upgrades"].pwrlvl = tonumber(pwrlvl)
	Chest[slot]["Upgrades"].acclvl = tonumber(acclvl)
	Chest[slot]["Upgrades"].clplvl = tonumber(clplvl)
	Chest[slot]["Upgrades"].fislvl = tonumber(fislvl)
	Chest[slot]["Upgrades"].reslvl = tonumber(reslvl)

	if bool_IsUpging then
		UpgUpdate()
	end

end)

function GM:OnSpawnMenuOpen()
	if bool_Chating then return end
	if NeedsToClose then return end
	LocalPlayer():EmitSound("residentevil/select_re.mp3",100,100)
	NeedsToClose = false
	InvMenu()
end

function GM:Think()
	if Inventory == nil then return end
	if Invframe == nil then return end
	if Invframe:IsValid() && bool_CanClose && NeedsToClose then
		Invframe:Remove()
		NeedsToClose = false
		if bool_IconOptions then
			Itembool_IconOptions:Remove()
			bool_IconOptions = false
		end
		if bool_IsUpging then
			gui_Upgframe:Remove()
			bool_IsUpging = false
		end
		if LookingforClick != nil then
			LookingforClick = nil
		end
		return
	end
end

function GM:OnSpawnMenuClose()
	RememberCursorPosition()
	if Invframe:IsValid() then
		Invframe:SetMouseInputEnabled( false )
		Invframe:SetKeyboardInputEnabled( false )
	end
	LocalPlayer():EmitSound("residentevil/cancel_re.mp3",100,100)
	NeedsToClose = true
end


function InvMenu()
	local SW = ScrW()
	local SH = ScrH()
	bool_itemDisplay = false
	local client = LocalPlayer()
	local NumberSlots = table.Count(Inventory) || 6
	local WidthSize = (SW - 256)/NumberSlots
	if WidthSize > 128 then
		WidthSize = 128
	end
	local HieghtSize = (SH - 256)/NumberSlots
	if HieghtSize > 128 then
		HieghtSize = 128
	end
	Invframe = vgui.Create("DFrame")
	Invframe:SetTitle("")
	Invframe:SetSize(WidthSize * NumberSlots ,128)
	Invframe:SetPos(SW*.7 - Invframe:GetWide(),SH*.85)
	--end
	Invframe:SetDraggable(false)
	Invframe:ShowCloseButton(false)
	Invframe:SetVisible(true)
	Invframe.Paint = function(panel)
		surface.SetDrawColor(0,0,0,200)
		surface.DrawOutlinedRect(0,0,Invframe:GetWide(),Invframe:GetTall())
		surface.SetDrawColor(184,0,20,155)
		surface.DrawRect(0,0,Invframe:GetWide(),Invframe:GetTall())
		end
	Invframe:MakePopup()
		ReLoadInvList()
	Invframe:SetMouseInputEnabled( true )
	Invframe:SetKeyboardInputEnabled( true )
	RestoreCursorPosition()
end

function ReLoadInvList()
	local SW = ScrW()
	local SH = ScrH()
	local NumberSlots = table.Count(Inventory) || 6
	local WidthSize = (SW - 256)/NumberSlots
	if WidthSize > 128 then
		WidthSize = 128
	end
	if bool_itemDisplay then
		Panel:Remove()
	end
	bool_itemDisplay = true
	local numb = 0
	Panel = vgui.Create("DPanelList", Invframe)
	Panel:SetParent(Invframe)
	Panel:SetPos(0,0)
	Panel:SetSize((SW - 256) ,128)
	Panel.Paint = function() end
	for i = 1, #Inventory do
		local UmbPanel = vgui.Create("DPanel")
		UmbPanel:SetPos( numb, 0 )
		UmbPanel:SetParent(Panel)
		UmbPanel:SetSize( WidthSize,128 )
		UmbPanel.Paint = function()
							surface.SetDrawColor( 50, 50, 50, 200 )
							surface.DrawOutlinedRect(  2, 2, UmbPanel:GetWide()-4, UmbPanel:GetTall()-4 )
						end
		numb = numb + WidthSize
	end

	numb = 0
	local Iconent = ents.CreateClientProp("prop_physics")

	Iconent:SetPos(Vector(0,0,0))
	Iconent:Spawn()
	Iconent:Activate()
	for k,v in pairs(Inventory) do
		ItemIcon = vgui.Create("DModelPanel")
		ItemIcon:SetParent(Panel)
		ItemIcon:SetPos(numb,0)
		ItemIcon:SetSize(WidthSize,WidthSize)
		if v.Item != "none" then
			ItemIcon:SetModel(GAMEMODE.Items[v.Item].Model)
			Iconent:SetModel(GAMEMODE.Items[v.Item].Model)


			local ItemLabel = vgui.Create("DLabel")
			ItemLabel:SetParent(Panel)
			ItemLabel:SetText(GAMEMODE.Items[v.Item].Name)
			ItemLabel:SizeToContents()
			ItemLabel:SetPos(numb+10,2)
			ItemLabel:SetFont("Default")

			local ItemLabel1 = vgui.Create("DLabel")
			ItemLabel1:SetParent(Panel)
			ItemLabel1:SetText(GAMEMODE.Items[v.Item].Desc)
			ItemLabel1:SetPos(numb+10,110)
			ItemLabel1:SizeToContents()
			ItemLabel1:SetFont("Default")
				if v.Amount != 1 then
					local ItemLabel2 = vgui.Create("DLabel")
					ItemLabel2:SetParent(Panel)
					ItemLabel2:SetText("x"..v.Amount)
					ItemLabel2:SetPos(numb+50,12)
					ItemLabel2:SizeToContents()
					ItemLabel2:SetFont("Default")
				end

				local center = Iconent:OBBCenter()
				local dist = Iconent:BoundingRadius()*1.6
				ItemIcon:SetLookAt(center)
				ItemIcon:SetCamPos(center+Vector(dist,dist,0))
				ItemIcon.DoClick = function(ItemIcon1)
									if LocalPlayer():Team() != TEAM_HUNK then return end
										bool_IconOptions = false
										bool_CanClose = false
											for u,p in pairs(GAMEMODE.Ammoref) do
												if v.Item == u then
													if LocalPlayer():GetAmmoCount(p) < GAMEMODE.AmmoMax[p].number then
														bool_CanClose = false
													else
														bool_CanClose = true
														return
													end
												end
											end
											for d,g in pairs(GAMEMODE.Weapons) do
												if v.Item == d then
													bool_CanClose = true
													break
												end
											end
										RunConsoleCommand("inv_UseItem", v.Item, k)
									end

				ItemIcon.DoRightClick = function(ItemIcon)
											Itembool_IconOptions = DermaMenu() -- Creates the menu
											bool_IconOptions = true
											if LocalPlayer():Team() == TEAM_HUNK then
												Itembool_IconOptions:AddOption("Use", function()
																						if LocalPlayer():Team() != TEAM_HUNK then return end
																							bool_IconOptions = false
																							bool_CanClose = false
																								for u,p in pairs(GAMEMODE.Ammoref) do
																									if v.Item == u then
																										if LocalPlayer():GetAmmoCount(p) < GAMEMODE.AmmoMax[p].number then
																											bool_CanClose = false
																										else
																											bool_CanClose = true
																											return
																										end
																									end
																								end
																								for d,g in pairs(GAMEMODE.Weapons) do
																									if v.Item == d then
																										bool_CanClose = true
																										break
																									end
																								end
																							RunConsoleCommand("inv_UseItem", v.Item, k)
																						end)

												local Sub_Menu_Give = Itembool_IconOptions:AddSubMenu("Give")
																							for _,ply in pairs(team.GetPlayers(TEAM_HUNK)) do
																								if ply:GetPos():Distance(LocalPlayer():GetPos()) <= 300 && ply != LocalPlayer() then
																									Sub_Menu_Give:AddOption(ply:Nick(),function()
																																bool_IconOptions = false
																																bool_CanClose = false
																																RunConsoleCommand("inv_GiveItem", v.Item, k,ply:EntIndex())
																																end)
																								end
																							end



													if v.Item != "item_expbarrel" || "item_barricade" then

														Itembool_IconOptions:AddOption("Drop", function()
																									bool_IconOptions = false
																									bool_CanClose = false
																									RunConsoleCommand("inv_DropItem", v.Item, k,0)
																								end
																								)
													end
													local useable = true
													for weapon,data in pairs(GAMEMODE.Weapons) do
														if v.Item == weapon then
															useable = false
															break
														elseif v.Item == "item_expbarrel" || v.Item ==  "item_barricade" || v.Item ==  "item_c4" || v.Item ==  "item_landmine" then
															useable = false
															break
														end
													end
													if useable then
													local Sub_Menu_UseOn = Itembool_IconOptions:AddSubMenu("Use On ...")
																					for _,ply in pairs(team.GetPlayers(TEAM_HUNK)) do
																						if ply:GetPos():Distance(LocalPlayer():GetPos()) <= 300 && ply != LocalPlayer() then
																							Sub_Menu_UseOn:AddOption(ply:Nick(),function()
																																bool_IconOptions = false
																																bool_CanClose = false
																																RunConsoleCommand("inv_UseItemOnPly", v.Item, k,ply:EntIndex())
																																end)
																							end
																						end
																					end


												Itembool_IconOptions:Open()
											end
										end

			numb = numb + WidthSize
		end
	end
	Iconent:Remove()
end
concommand.Add("ShowInvetoryMenu",InvMenu)

function UpgUpdate()
	PrintTable(Upgrades[string_CurUpgItem])
	local intPowerLevel = Upgrades[string_CurUpgItem].pwrlvl
	local intAccuracyLevel = Upgrades[string_CurUpgItem].acclvl
	local intClipSizeLevel = Upgrades[string_CurUpgItem].clplvl
	local intFiringSpeedLevel = Upgrades[string_CurUpgItem].fislvl
	local intReloadSpeedLevel = Upgrades[string_CurUpgItem].reslvl
	gui_PowerBar = vgui.Create("DBevel")
	gui_PowerBar:SetParent(gui_Upgframe)
	gui_PowerBar:SetSize(165,5)
	gui_PowerBar:SetPos(15,133)
	gui_PowerBar.Paint = function()
		surface.SetDrawColor(30,170,30,255)
		surface.DrawRect(0,0,165*(intPowerLevel/table.Count(GAMEMODE.Weapons[string_CurUpgItem].UpGrades.Power)),5)
	end
	gui_AccuarcyBar = vgui.Create("DBevel")
	gui_AccuarcyBar:SetParent(gui_Upgframe)
	gui_AccuarcyBar:SetSize(165,5)
	gui_AccuarcyBar:SetPos(15,163)
	gui_AccuarcyBar.Paint = function()
		surface.SetDrawColor(30,170,30,255)
		surface.DrawRect(0,0,165*(intAccuracyLevel/table.Count(GAMEMODE.Weapons[string_CurUpgItem].UpGrades.Accuracy)),5)
	end
	gui_ClipSizeBar = vgui.Create("DBevel")
	gui_ClipSizeBar:SetParent(gui_Upgframe)
	gui_ClipSizeBar:SetSize(165,5)
	gui_ClipSizeBar:SetPos(15,193)
	gui_ClipSizeBar.Paint = function()
		surface.SetDrawColor(30,170,30,255)
		surface.DrawRect(0,0,165*(intClipSizeLevel/table.Count(GAMEMODE.Weapons[string_CurUpgItem].UpGrades.ClipSize)),5)
	end
	gui_FiringSpeedBar = vgui.Create("DBevel")
	gui_FiringSpeedBar:SetParent(gui_Upgframe)
	gui_FiringSpeedBar:SetSize(165,5)
	gui_FiringSpeedBar:SetPos(15,223)
	gui_FiringSpeedBar.Paint = function()
		surface.SetDrawColor(30,170,30,255)
		surface.DrawRect(0,0,165*(intFiringSpeedLevel/table.Count(GAMEMODE.Weapons[string_CurUpgItem].UpGrades.FiringSpeed)),5)
	end
	gui_ReloadSpeedBar = vgui.Create("DBevel")
	gui_ReloadSpeedBar:SetParent(gui_Upgframe)
	gui_ReloadSpeedBar:SetSize(165,5)
	gui_ReloadSpeedBar:SetPos(15,253)
	gui_ReloadSpeedBar.Paint = function()
		surface.SetDrawColor(30,170,30,255)
		surface.DrawRect(0,0,165*(intReloadSpeedLevel/table.Count(GAMEMODE.Weapons[string_CurUpgItem].UpGrades.ReloadSpeed)),5)
	end
	if bool_IsUpging then
		if intPowerLevel == table.Count(GAMEMODE.Weapons[string_CurUpgItem].UpGrades.Power) then
			gui_UpgradePowerButton:Remove()
		elseif intAccuracyLevel == table.Count(GAMEMODE.Weapons[string_CurUpgItem].UpGrades.Accuracy) then
			gui_UpgradeAccuracyButton:Remove()
		elseif intClipSizeLevel == table.Count(GAMEMODE.Weapons[string_CurUpgItem].UpGrades.ClipSize) then
			gui_UpgradeClipSizeButton:Remove()
		elseif intFiringSpeedLevel == table.Count(GAMEMODE.Weapons[string_CurUpgItem].UpGrades.FiringSpeed) then
			gui_UpgradeFiringSpeedButton:Remove()
		elseif intReloadSpeedLevel == table.Count(GAMEMODE.Weapons[string_CurUpgItem].UpGrades.ReloadSpeed) then
			gui_UpgradeReloadSpeedButton:Remove()
		end
	end
		gui_UpgLabelPower:SetText("$"..GAMEMODE.Weapons[string_CurUpgItem].UpGrades.Power[intPowerLevel].Price)
		gui_UpgLabelAccuracy:SetText("$"..GAMEMODE.Weapons[string_CurUpgItem].UpGrades.Accuracy[intAccuracyLevel].Price)
		gui_UpgLabelClipSize:SetText("$"..GAMEMODE.Weapons[string_CurUpgItem].UpGrades.ClipSize[intClipSizeLevel].Price)
		gui_UpgLabelFiringSpeed:SetText("$"..GAMEMODE.Weapons[string_CurUpgItem].UpGrades.FiringSpeed[intFiringSpeedLevel].Price)
		gui_UpgLabelReloadSpeed:SetText("$"..GAMEMODE.Weapons[string_CurUpgItem].UpGrades.ReloadSpeed[intReloadSpeedLevel].Price)
end

function ConfirmSelling(wep,slot)
	string_CurUpgItem = tostring(wep)
	local intPowerLevel = Upgrades[string_CurUpgItem].pwrlvl
	local intAccuracyLevel = Upgrades[string_CurUpgItem].acclvl
	local intClipSizeLevel = Upgrades[string_CurUpgItem].clplvl
	local intFiringSpeedLevel = Upgrades[string_CurUpgItem].fislvl
	local intReloadSpeedLevel = Upgrades[string_CurUpgItem].reslvl
	local pwraddition = GAMEMODE.Weapons[string_CurUpgItem].UpGrades.Power[intPowerLevel].Price / 2
	local accaddition = GAMEMODE.Weapons[string_CurUpgItem].UpGrades.Accuracy[intAccuracyLevel].Price / 2
	local clpaddition = GAMEMODE.Weapons[string_CurUpgItem].UpGrades.ClipSize[intClipSizeLevel].Price / 2
	local fisaddition = GAMEMODE.Weapons[string_CurUpgItem].UpGrades.FiringSpeed[intFiringSpeedLevel].Price / 2
	local resaddition = GAMEMODE.Weapons[string_CurUpgItem].UpGrades.ReloadSpeed[intReloadSpeedLevel].Price / 2
	local price = pwraddition + accaddition + clpaddition + fisaddition	 + resaddition
	local client = LocalPlayer()
	local Confirmframe = vgui.Create("DFrame")
	Confirmframe:SetSize(200,70)
	Confirmframe:SetPos(ScrW()-700,ScrH()-220)//ScrW()-700,ScrH()-711)
	Confirmframe:SetTitle("Confirm Sell")
	local ConfirmButton = vgui.Create("DButton")
	ConfirmButton:SetParent(Confirmframe)
	ConfirmButton:SetSize(180,30)
	ConfirmButton:SetPos(10,35)
	ConfirmButton:SetText("Sell "..GAMEMODE.Items[string_CurUpgItem].Name.." for $"..price..".")
	ConfirmButton.DoClick = function()
		RunConsoleCommand("inv_SellWeapon", string_CurUpgItem, slot)
		Confirmframe:Remove()
	end
end

function UpgradeMenu(wep)
	string_CurUpgItem = tostring(wep)
	local intPowerLevel = Upgrades[string_CurUpgItem].pwrlvl
	local intAccuracyLevel = Upgrades[string_CurUpgItem].acclvl
	local intClipSizeLevel = Upgrades[string_CurUpgItem].clplvl
	local intFiringSpeedLevel = Upgrades[string_CurUpgItem].fislvl
	local intReloadSpeedLevel = Upgrades[string_CurUpgItem].reslvl
	local client = LocalPlayer()
	gui_Upgframe = vgui.Create("DPanel")
	gui_Upgframe:SetSize(200,260)
	gui_Upgframe:SetPos(ScrW()-700,ScrH()-530)//ScrW()-700,ScrH()-711)
	gui_Upgframe.Paint = function(gui_Upgframe)
				local x,y = gui_Upgframe:GetPos()
				surface.SetDrawColor(90,90,90,235)
				surface.DrawRect(0,0,gui_Upgframe:GetWide(),gui_Upgframe:GetTall())
				surface.SetDrawColor(20,20,20,120)
				surface.DrawOutlinedRect(0,0,gui_Upgframe:GetWide(),gui_Upgframe:GetTall())
				surface.DrawOutlinedRect(0,0,gui_Upgframe:GetWide(),gui_Upgframe:GetTall()-240)
				surface.DrawOutlinedRect(0,0,gui_Upgframe:GetWide(),gui_Upgframe:GetTall()-119)
				surface.DrawOutlinedRect(0,140,gui_Upgframe:GetWide(),gui_Upgframe:GetTall()-199)
				surface.DrawOutlinedRect(0,170,gui_Upgframe:GetWide(),gui_Upgframe:GetTall()-199)
				surface.DrawOutlinedRect(0,200,gui_Upgframe:GetWide(),gui_Upgframe:GetTall()-199)
				surface.SetDrawColor(30,30,0,100)
				surface.DrawRect(15,133,165,5)
				surface.DrawRect(15,163,165,5)
				surface.DrawRect(15,193,165,5)
				surface.DrawRect(15,223,165,5)
				surface.DrawRect(15,253,165,5)
				surface.SetFont("Trebuchet18")
				surface.SetTextColor(255,255,255,155)
				surface.SetTextPos(5,112)
				surface.DrawText("Power")
				local x,y = surface.GetTextSize(GAMEMODE.Items[string_CurUpgItem].Name)
				surface.SetTextPos(100-(x/2),0)
				surface.DrawText(GAMEMODE.Items[string_CurUpgItem].Name)
				surface.SetTextPos(5,142)
				surface.DrawText("Accuracy")
				surface.SetTextPos(5,172)
				surface.DrawText("Clip Size")
				surface.SetTextPos(5,202)
				surface.DrawText("Firing Speed")
				surface.SetTextPos(5,232)
				surface.DrawText("Reload Speed")
			end
		UpgCloseButton = vgui.Create("DSysButton", gui_Upgframe)
		UpgCloseButton:SetSize(20,20)
		UpgCloseButton:SetPos(180,0)
		UpgCloseButton:SetType( "close" )
		UpgCloseButton.DoClick = function()
		gui_Upgframe:Remove() 	bool_IsUpging = false
		end
		local upItemPict = vgui.Create("DModelPanel")
		upItemPict:SetParent(gui_Upgframe)
		upItemPict:SetPos(0,20)
		upItemPict:SetSize(200,80)
		local upent = ents.CreateClientProp("prop_physics")
		upent:SetAngles(Angle(0,0,0))
		upent:SetPos(Vector(0,0,0))
		upent:SetModel(GAMEMODE.Items[string_CurUpgItem].Model)
		local center = upent:OBBCenter()
		local dist = upent:BoundingRadius()*.5
		upItemPict:SetLookAt(center)
		upItemPict:SetCamPos(center+Vector(dist,dist,0))
		upItemPict:SetModel(GAMEMODE.Items[string_CurUpgItem].Model)
		upent:Spawn()
		upent:Activate()
		upent:PhysicsInit(SOLID_VPHYSICS)
		upent:Remove()
		gui_UpgLabelPower = vgui.Create("DLabel")
		gui_UpgLabelAccuracy = vgui.Create("DLabel")
		gui_UpgLabelClipSize = vgui.Create("DLabel")
		gui_UpgLabelFiringSpeed = vgui.Create("DLabel")
		gui_UpgLabelReloadSpeed = vgui.Create("DLabel")
		---- Lables
		gui_UpgLabelPower:SetParent(gui_Upgframe)
		gui_UpgLabelAccuracy:SetParent(gui_Upgframe)
		gui_UpgLabelClipSize:SetParent(gui_Upgframe)
		gui_UpgLabelFiringSpeed:SetParent(gui_Upgframe)
		gui_UpgLabelReloadSpeed:SetParent(gui_Upgframe)
		gui_UpgLabelPower:SetPos(110,110)
		gui_UpgLabelAccuracy:SetPos(110,140)
		gui_UpgLabelClipSize:SetPos(110,170)
		gui_UpgLabelFiringSpeed:SetPos(110,200)
		gui_UpgLabelReloadSpeed:SetPos(110,230)
		--------
		gui_UpgLabelPower:SetFont("Trebuchet18")
		gui_UpgLabelAccuracy:SetFont("Trebuchet18")
		gui_UpgLabelClipSize:SetFont("Trebuchet18")
		gui_UpgLabelFiringSpeed:SetFont("Trebuchet18")
		gui_UpgLabelReloadSpeed:SetFont("Trebuchet18")
		UpgUpdate(string_CurUpgItem)
		gui_UpgradePowerButton = vgui.Create("DButton")
		gui_UpgradePowerButton:SetParent(gui_Upgframe)
		gui_UpgradePowerButton:SetPos(150,112)
		gui_UpgradePowerButton:SetSize(50,17)
		gui_UpgradePowerButton:SetText("Upgrade")
		gui_UpgradePowerButton.DoClick = function(gui_UpgradePowerButton)
			if intPowerLevel < table.Count(GAMEMODE.Weapons[string_CurUpgItem].UpGrades.Power) then
				RunConsoleCommand("inv_UpgradeWeapon",string_CurUpgItem,"Power")
				UpgUpdate(string_CurUpgItem)
			end
		end
		gui_UpgradeAccuracyButton = vgui.Create("DButton")
		gui_UpgradeAccuracyButton:SetParent(gui_Upgframe)
		gui_UpgradeAccuracyButton:SetPos(150,142)
		gui_UpgradeAccuracyButton:SetSize(50,17)
		gui_UpgradeAccuracyButton:SetText("Upgrade")
		gui_UpgradeAccuracyButton.DoClick = function(gui_UpgradeAccuracyButton)
		if intAccuracyLevel < table.Count(GAMEMODE.Weapons[string_CurUpgItem].UpGrades.Accuracy) then
				RunConsoleCommand("inv_UpgradeWeapon",string_CurUpgItem,"Accuracy")
				UpgUpdate(string_CurUpgItem)
			end
		end
		gui_UpgradeClipSizeButton = vgui.Create("DButton")
		gui_UpgradeClipSizeButton:SetParent(gui_Upgframe)
		gui_UpgradeClipSizeButton:SetPos(150,172)
		gui_UpgradeClipSizeButton:SetSize(50,17)
		gui_UpgradeClipSizeButton:SetText("Upgrade")
		gui_UpgradeClipSizeButton.DoClick = function(gui_UpgradeClipSizeButton)
			if intClipSizeLevel < table.Count(GAMEMODE.Weapons[string_CurUpgItem].UpGrades.ClipSize) then
				RunConsoleCommand("inv_UpgradeWeapon",string_CurUpgItem,"ClipSize")
				UpgUpdate(string_CurUpgItem)
			end
		end
		gui_UpgradeFiringSpeedButton = vgui.Create("DButton")
		gui_UpgradeFiringSpeedButton:SetParent(gui_Upgframe)
		gui_UpgradeFiringSpeedButton:SetPos(150,202)
		gui_UpgradeFiringSpeedButton:SetSize(50,17)
		gui_UpgradeFiringSpeedButton:SetText("Upgrade")
		gui_UpgradeFiringSpeedButton.DoClick = function(gui_UpgradeFiringSpeedButton)
			if intFiringSpeedLevel < table.Count(GAMEMODE.Weapons[string_CurUpgItem].UpGrades.FiringSpeed) then
				RunConsoleCommand("inv_UpgradeWeapon",string_CurUpgItem,"FiringSpeed")
				UpgUpdate(string_CurUpgItem)
			end
		end
		gui_UpgradeFiringSpeedButton = vgui.Create("DButton")
		gui_UpgradeFiringSpeedButton:SetParent(gui_Upgframe)
		gui_UpgradeFiringSpeedButton:SetPos(150,202)
		gui_UpgradeFiringSpeedButton:SetSize(50,17)
		gui_UpgradeFiringSpeedButton:SetText("Upgrade")
		gui_UpgradeFiringSpeedButton.DoClick = function(gui_UpgradeFiringSpeedButton)
			if intFiringSpeedLevel < table.Count(GAMEMODE.Weapons[string_CurUpgItem].UpGrades.FiringSpeed) then
				RunConsoleCommand("inv_UpgradeWeapon",string_CurUpgItem,"FiringSpeed")
				UpgUpdate(string_CurUpgItem)
			end
		end
		gui_UpgradeReloadSpeedButton = vgui.Create("DButton")
		gui_UpgradeReloadSpeedButton:SetParent(gui_Upgframe)
		gui_UpgradeReloadSpeedButton:SetPos(150,202)
		gui_UpgradeReloadSpeedButton:SetSize(50,17)
		gui_UpgradeReloadSpeedButton:SetText("Upgrade")
		gui_UpgradeReloadSpeedButton.DoClick = function(gui_UpgradeReloadSpeedButton)
			if intReloadSpeedLevel < table.Count(GAMEMODE.Weapons[string_CurUpgItem].UpGrades.ReloadSpeed) then
				RunConsoleCommand("UpgradeWeapon",string_CurUpgItem,"ReloadSpeed")
				UpgUpdate(string_CurUpgItem)
			end
		end
		bool_IsUpging = true
end

function openInventory()
  InventoryBase = re2_create_Frame(MainPanel, 0, .05, 1, .95)
  InventoryBase.Paint = function() draw.RoundedBox( 0, 0, 0, MainPanel:GetWide(), MainPanel:GetTall(), Color(60,60,60,255)) end

end
