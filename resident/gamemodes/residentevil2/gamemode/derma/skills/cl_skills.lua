function openSkills()
    
  SkillsBase = re2_create_Frame(MainPanel, 0, .05, 1, .95)
  SkillsBase.Paint = function() draw.RoundedBox( 0, 0, 0, MainPanel:GetWide(), MainPanel:GetTall(), Color(60,60,60,255)) end

  if GetGlobalString("Mode") != "Merchant" && LocalPlayer():Team() == TEAM_HUNK  then return end
  local client = LocalPlayer()
  local SW,SH = ScrW(),ScrH()
  local s = CreateSound(client, table.Random(GAMEMODE.MerchantSounds.MerchantWelcome))
  s:Play()
  s:ChangeVolume(0.2)

  local GUI_Property_Sheet = vgui.Create("DPropertySheet")
  GUI_Property_Sheet:SetParent(SkillsBase)
  GUI_Property_Sheet:SetPos(SkillsBase:GetWide()*.01,SkillsBase:GetTall()*.01)
  GUI_Property_Sheet:SetSize(SkillsBase:GetWide()*.98,SkillsBase:GetTall()*.98 )
  GUI_Property_Sheet.Paint = function()
                  surface.SetDrawColor(0,0,0,200)
                  surface.DrawOutlinedRect(0,0,GUI_Property_Sheet:GetWide(),GUI_Property_Sheet:GetTall())
                  surface.SetDrawColor(60,40,30,155)
                  surface.DrawRect(0,0,GUI_Property_Sheet:GetWide(),GUI_Property_Sheet:GetTall())
                end




  local GUI_Skills_Panel = vgui.Create("DPanelList")
  GUI_Skills_Panel:SetParent(GUI_Property_Sheet)
  GUI_Skills_Panel:SetSize(GUI_Property_Sheet:GetWide(),GUI_Property_Sheet:GetTall() - 48)
  GUI_Skills_Panel:SetSpacing(5)
  GUI_Skills_Panel:SetPos(0,48)
  GUI_Skills_Panel.Paint = function() end -- dont draw
  GUI_Skills_Panel:EnableVerticalScrollbar( true )


  GUI_LoadSkills(GUI_Skills_Panel)

  GUI_Property_Sheet:AddSheet( translate.Get("perks"), GUI_Skills_Panel, "icon16/box.png", true, true, translate.Get("perks_msg") )


end
  concommand.Add("RE2_MerchantMenu",openSkills)

function GUI_LoadSkills(GUI_Skills_Panel)
  local client = LocalPlayer()
  local int_position_numbery = 0
  local int_position_numberx = 128
  local ent_WorldEntity = ents.CreateClientProp("prop_physics")

  ent_WorldEntity:SetAngles(Angle(0,0,0))
  ent_WorldEntity:SetPos(Vector(0,0,0))
  ent_WorldEntity:Spawn()
  ent_WorldEntity:Activate()
  for skils,data in pairs(GAMEMODE.Perks) do
    if GAMEMODE.Perks[skils] == nil then
        local GUI_Inventory_Base = vgui.Create("DCollapsibleCategory")
        GUI_Inventory_Base:SetParent(GUI_Skills_Panel)
        GUI_Inventory_Base:SetPos( 0,int_position_numbery )
        GUI_Inventory_Base:SetSize( GUI_Skills_Panel:GetWide(), 30 ) -- Keep the second number at 50
        GUI_Inventory_Base:SetExpanded( 0 ) -- Expanded when popped up
        GUI_Inventory_Base:SetLabel( GAMEMODE.Perks[skils].Name )---- Cross check to find the name
        GUI_Inventory_Base.Paint = function()
                        surface.SetDrawColor(60,60,60,255)
                        surface.DrawRect(0,0,GUI_Inventory_Base:GetWide()-1,22-1)
                        surface.SetDrawColor(0,0,0,255)
                        surface.DrawOutlinedRect(0,0,GUI_Inventory_Base:GetWide(),22)
                      end
          local GUI_Inventory_Background = vgui.Create("DPanel")
          GUI_Inventory_Background:SetParent(GUI_Inventory_Base)
          GUI_Inventory_Background:SetSize(GUI_Inventory_Base:GetWide(),170)
          GUI_Inventory_Background.Paint = function()
                        surface.SetDrawColor(0,0,0,255)
                        surface.DrawOutlinedRect(0,0,GUI_Inventory_Background:GetWide(),GUI_Inventory_Background:GetTall())
                        surface.SetDrawColor(100,100,100,255)
                        surface.DrawRect(1,0,GUI_Inventory_Background:GetWide()-2,GUI_Inventory_Background:GetTall()-1)
                        surface.SetDrawColor(0,0,0,255)
                        surface.DrawOutlinedRect(0,0,128,128)


                        end

		ent_WorldEntity:SetModel("models/items/healthkit.mdl")

        local GUI_Inventory_Item_Icon = vgui.Create("DModelPanel")
        GUI_Inventory_Item_Icon:SetParent(GUI_Inventory_Base)
        GUI_Inventory_Item_Icon:SetSize(128,128)
        GUI_Inventory_Item_Icon:SetPos(0,30)
        GUI_Inventory_Item_Icon:SetModel("models/items/healthkit.mdl")

        local center = ent_WorldEntity:OBBCenter()
        local dist = ent_WorldEntity:BoundingRadius()*.8

        GUI_Inventory_Item_Icon:SetLookAt(center)
        GUI_Inventory_Item_Icon:SetCamPos(center+Vector(dist,dist,0))


        if storage then
          local GUI_Inventory_DepositItem_Button = vgui.Create("DButton")
          GUI_Inventory_DepositItem_Button:SetParent(GUI_Inventory_Base)
          GUI_Inventory_DepositItem_Button:SetSize(100,20)
          GUI_Inventory_DepositItem_Button:SetPos(14,160)
          GUI_Inventory_DepositItem_Button:SetText("Deposit")
          GUI_Inventory_DepositItem_Button.DoClick = function(GUI_Inventory_DepositItem_Button)
                                  for b,d in pairs(Chest) do
                                    if d.Weapon == "none" then
                                      RunConsoleCommand("inv_DepositItem",skils,slot)
                                      GUI_Inventory_Base:Remove()
                                      break
                                    end
                                  end
                                end
		else



			PlayerIcon = vgui.Create("DModelPanel")
				PlayerIcon:SetParent(GUI_Inventory_Base)
				PlayerIcon:SetSize(100,100)
				PlayerIcon:SetPos(300,30)
				PlayerIcon:SetModel(client:GetModel())
			PlayerName = vgui.Create("DLabel")
				PlayerName:SetFont("UiBold")
				PlayerName:SetPos(300,20)
				PlayerName:SetParent(GUI_Inventory_Base)
				PlayerName:SetText(LocalPlayer():Nick())
				PlayerName:SizeToContents()
			PlayerImmunityResistance = vgui.Create("DLabel")
				PlayerImmunityResistance:SetFont("UiBold")
				PlayerImmunityResistance:SetPos(300,180)
				PlayerImmunityResistance:SetParent(GUI_Inventory_Base)
				if LocalPlayer():GetNWInt("Immunity") >= 100 then
					PlayerImmunityResistance:SetText("Immunity : 100%")
				else
					PlayerImmunityResistance:SetText("Immunity : "..(100 - LocalPlayer():GetNWInt("Immunity")).."%")
				end
				PlayerImmunityResistance:SizeToContents()
			PlayerInventorySlots = vgui.Create("DLabel")
				PlayerInventorySlots:SetFont("UiBold")
				PlayerInventorySlots:SetParent(GUI_Inventory_Base)
				PlayerInventorySlots:SetPos(300,120)
				PlayerInventorySlots:SetText("Inventory Slots: "..table.Count(Inventory))
				PlayerInventorySlots:SizeToContents()
			PlayerPerk1 = vgui.Create("DLabel")
				PlayerPerk1:SetFont("UiBold")
				PlayerPerk1:SetParent(GUI_Inventory_Base)
				PlayerPerk1:SetPos(300,140)
				if GAMEMODE.Perks.Name != nil then
				PlayerPerk1:SetText("Perk 1 : "..GAMEMODE.Perks[ActivePerks[1]].Name)
				else
				PlayerPerk1:SetText("Perk 1 : None")
				end
				PlayerPerk1:SizeToContents()
			PlayerPerk2 = vgui.Create("DLabel")
				PlayerPerk2:SetFont("UiBold")
				PlayerPerk2:SetParent(GUI_Inventory_Base)
				PlayerPerk2:SetPos(300,160)
				if GAMEMODE.Perks.Name != nil then
				PlayerPerk2:SetText("Perk 2 : "..GAMEMODE.Perks[ActivePerks[2]].Name)
				else
				PlayerPerk2:SetText("Perk 2 : None")
				end
				PlayerPerk2:SizeToContents()

			local DLabel = vgui.Create( "DLabel" )
			DLabel:SetParent(GUI_Inventory_Base)
			DLabel:SetPos( 300, 200 ) -- Set the position of the label
			DLabel:SetText( "Price : "..GAMEMODE.Perks[skils].Price ) -- Set the text of the label
			DLabel:SizeToContents() -- Size the label to fit the text in it

			local DLabel2 = vgui.Create( "DLabel" )
			DLabel2:SetParent(GUI_Inventory_Base)
			DLabel2:SetPos( 600, 200 ) -- Set the position of the label
			DLabel2:SetText( "Speed : "..client.GetNWInt("Speed") ) -- Set the text of the label
			DLabel2:SizeToContents() -- Size the label to fit the text in it

		for k,v in pairs(GAMEMODE.Perks) do
			if k != 0 then


		local GUI_Inventory_Perk_Button = vgui.Create("DButton")
          GUI_Inventory_Perk_Button:SetParent(GUI_Inventory_Base)
          GUI_Inventory_Perk_Button:SetSize(100,20)
          GUI_Inventory_Perk_Button:SetPos(14,180)
          GUI_Inventory_Perk_Button:SetText("Buy")
          GUI_Inventory_Perk_Button.DoClick = function(GUI_Inventory_Perk_Button)
									if client:GetNWInt("Money") >= tonumber(v.Price) then
										RunConsoleCommand("PurchasePerk",tostring(k))
									else
										client:EmitSound("reg/merchant/notenoughcash.wav")
									end
									end

			end
		if !v.Active then
			local MountButton = vgui.Create("DButton", GUI_Inventory_Base)
			MountButton:SetParent(GUI_Inventory_Base)
			MountButton:SetPos(14,160)
			MountButton:SetSize(100,20)
			MountButton:SetText("Mount")
			MountButton.DoClick = function(MountButton)
				RunConsoleCommand("MountPerk",v.Perk)
			end
		else
			local UnMountButton = vgui.Create("DButton", GUI_Inventory_Base)
			UnMountButton:SetParent(GUI_Inventory_Base)
			UnMountButton:SetPos(14,160)
			UnMountButton:SetSize(100,20)
			UnMountButton:SetText("UnMount")
			UnMountButton.DoClick = function(UnMountButton)
			RunConsoleCommand("UnMountPerk",v.Perk)
			end
		end

		end



        end

        int_position_numberx = 128

        GUI_Inventory_Base:SetContents(GUI_Inventory_Background)

        GUI_Skills_Panel:AddItem(GUI_Inventory_Base)
        int_position_numbery = int_position_numbery + 200
      end
  end
  ent_WorldEntity:Remove()

end



























-----------------------------------------------
