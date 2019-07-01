function openChest()
  if GetGlobalString("Mode") != "Merchant" && LocalPlayer():Team() == TEAM_HUNK then return end
  local client = LocalPlayer()
  local SW,SH = ScrW(),ScrH()

  ChestBase = re2_create_Frame(MainPanel, 0, .05, 1, .95)
  ChestBase.Paint = function() draw.RoundedBox( 0, 0, 0, MainPanel:GetWide(), MainPanel:GetTall(), Color(60,60,60,255)) end

  local ChestBackground = re2_create_Frame(ChestBase, .01, .02, .98, .965)
  ChestBackground.Paint = function()
                  surface.SetDrawColor(0,0,0,200)
                  surface.DrawOutlinedRect(0,0,ChestBackground:GetWide(),ChestBackground:GetTall())
                  surface.SetDrawColor(60,40,30,155)
                  surface.DrawRect(0,0,ChestBackground:GetWide(),ChestBackground:GetTall())
                end

  local GUI_Property_Sheet = vgui.Create("DPropertySheet")
  GUI_Property_Sheet:SetParent(ChestBase)
  GUI_Property_Sheet:SetPos(ChestBase:GetWide()*.01, ChestBase:GetTall()*.02)
  GUI_Property_Sheet:SetSize(ChestBase:GetWide()*.98, ChestBase:GetTall()*.965)
  GUI_Property_Sheet.Paint = function()
                  surface.SetDrawColor(0,0,0,200)
                  surface.DrawOutlinedRect(0,0,GUI_Property_Sheet:GetWide(),GUI_Property_Sheet:GetTall())
                  surface.SetDrawColor(40,120,40,0)
                  surface.DrawRect(0,0,GUI_Property_Sheet:GetWide(),GUI_Property_Sheet:GetTall())
                end

  local GUI_Chest_Panel = vgui.Create("DPanelList")
  GUI_Chest_Panel:SetParent(GUI_Property_Sheet)
  GUI_Chest_Panel:SetSize(GUI_Property_Sheet:GetWide(),GUI_Property_Sheet:GetTall() - 48)
  GUI_Chest_Panel:SetPos(0,48)
  GUI_Chest_Panel.Paint = function() end -- dont draw
  GUI_Chest_Panel:EnableVerticalScrollbar( true )

  local GUI_Inventory_Panel = vgui.Create("DPanelList")
  GUI_Inventory_Panel:SetParent(GUI_Property_Sheet)
  GUI_Inventory_Panel:SetSize(GUI_Property_Sheet:GetWide(),GUI_Property_Sheet:GetTall() - 48)
  GUI_Inventory_Panel:SetPos(0,48)
  GUI_Inventory_Panel.Paint = function() end -- dont draw
  GUI_Inventory_Panel:EnableVerticalScrollbar( true )

  GUI_LoadChest(GUI_Chest_Panel)

  GUI_LoadInventory(GUI_Inventory_Panel,true)

  GUI_Property_Sheet:AddSheet( translate.Get("storage"), GUI_Chest_Panel, "icon16/bomb.png", true, true, translate.Get("storage_msg") )

  GUI_Property_Sheet:AddSheet( translate.Get("inventory"), GUI_Inventory_Panel, "icon16/bomb.png", true, true, translate.Get("inventory_msg") )

  --GUI_LoadMerchantPanels(MainPanel)
  end
  concommand.Add("RE2_ChestMenu",GUI_ChestMenu)

  function GUI_LoadChest(GUI_Chest_Panel)
  local int_position_numbery = 0
  local int_position_numberx = 128
  local ent_WorldEntity = ents.CreateClientProp("prop_physics")
  ent_WorldEntity:SetAngles(Angle(0,0,0))
  ent_WorldEntity:SetPos(Vector(0,0,0))
  ent_WorldEntity:Spawn()
  ent_WorldEntity:Activate()
  for slot,data in pairs(Chest) do
    if data.Weapon != "none" then
      local GUI_Chest_Base = vgui.Create("DCollapsibleCategory")
      GUI_Chest_Base:SetParent(GUI_Chest_Panel)
      GUI_Chest_Base:SetPos( 0,int_position_numbery )
      GUI_Chest_Base:SetSize( GUI_Chest_Panel:GetWide(), 30 ) -- Keep the second number at 50
      GUI_Chest_Base:SetExpanded( 0 ) -- Expanded when popped up
      GUI_Chest_Base:SetLabel( GAMEMODE.Items[data.Weapon].Name )---- Cross check to find the name
      GUI_Chest_Base.Paint = function()
                surface.SetDrawColor(60,60,60,255)
                surface.DrawRect(0,0,GUI_Chest_Base:GetWide()-1,22-1)
                surface.SetDrawColor(0,0,0,255)
                surface.DrawOutlinedRect(0,0,GUI_Chest_Base:GetWide(),22)
              end
        local GUI_Chest_Background = vgui.Create("DPanel")
        GUI_Chest_Background:SetParent(GUI_Chest_Base)
        GUI_Chest_Background:SetSize(GUI_Chest_Base:GetWide(),170)
        GUI_Chest_Background.Paint = function()
                        surface.SetDrawColor(0,0,0,255)
                        surface.DrawOutlinedRect(0,0,GUI_Chest_Background:GetWide(),GUI_Chest_Background:GetTall())
                        surface.SetDrawColor(100,100,100,255)
                        surface.DrawRect(1,0,GUI_Chest_Background:GetWide()-2,GUI_Chest_Background:GetTall()-1)
                        surface.SetDrawColor(0,0,0,255)
                        surface.DrawOutlinedRect(0,0,128,128)
                      end


      local GUI_Weapon_Withdraw_Button = vgui.Create("DButton")
      GUI_Weapon_Withdraw_Button:SetParent(GUI_Chest_Base)
      GUI_Weapon_Withdraw_Button:SetSize(100,20)
      GUI_Weapon_Withdraw_Button:SetPos(14,160)
      GUI_Weapon_Withdraw_Button:SetText(translate.Get("deposit").." "..GAMEMODE.Items[data.Weapon].Name)
      --GUI_Weapon_Withdraw_Button.DoClick

      ent_WorldEntity:SetModel(GAMEMODE.Items[data.Weapon].Model)

      local GUI_Weapon_Item_Icon = vgui.Create("DModelPanel")
      GUI_Weapon_Item_Icon:SetParent(GUI_Chest_Base)
      GUI_Weapon_Item_Icon:SetSize(128,128)
      GUI_Weapon_Item_Icon:SetPos(0,30)
      GUI_Weapon_Item_Icon:SetModel(GAMEMODE.Items[data.Weapon].Model)

      local center = ent_WorldEntity:OBBCenter()
      local dist = ent_WorldEntity:BoundingRadius()*.8

      GUI_Weapon_Item_Icon:SetLookAt(center)
      GUI_Weapon_Item_Icon:SetCamPos(center+Vector(dist,dist,0))

      int_position_numberx = 128

      local GUI_Desc_Label = vgui.Create("DLabel")
      GUI_Desc_Label:SetParent(GUI_Chest_Base)
      GUI_Desc_Label:SetPos(4,136)
      GUI_Desc_Label:SetText(GAMEMODE.Items[data.Weapon].Desc)
      GUI_Desc_Label:SetFont("Default")
      GUI_Desc_Label:SizeToContents()
      GUI_Desc_Label:SetColor(Color(255,255,255,255))

      local GUI_Inventory_WithdrawItem_Button = vgui.Create("DButton")
      GUI_Inventory_WithdrawItem_Button:SetParent(GUI_Chest_Base)
      GUI_Inventory_WithdrawItem_Button:SetSize(100,20)
      GUI_Inventory_WithdrawItem_Button:SetPos(14,160)
      GUI_Inventory_WithdrawItem_Button:SetText(translate.Get("withdraw"))
      GUI_Inventory_WithdrawItem_Button.DoClick = function(GUI_Inventory_DepositItem_Button)
                              for b,d in pairs(Inventory) do
                                if d.Item == "none" then
                                  RunConsoleCommand("inv_WithdrawItem",data.Weapon)
                                  GUI_Chest_Base:Remove()
                                  break
                                end
                              end
                            end

        local intPowerLevel = Chest[slot]["Upgrades"].pwrlvl
        local intAccuracyLevel = Chest[slot]["Upgrades"].acclvl
        local intClipSizeLevel = Chest[slot]["Upgrades"].clplvl
        local intFiringSpeedLevel = Chest[slot]["Upgrades"].fislvl
        local intReloadSpeedLevel = Chest[slot]["Upgrades"].reslvl

        local GUI_PowerBar = vgui.Create("DPanel")
        GUI_PowerBar:SetParent(GUI_Chest_Background)
        GUI_PowerBar:SetSize(GUI_Chest_Base:GetWide() - (128) - 56 ,7)
        GUI_PowerBar:SetPos((128) + 28,50 )
        GUI_PowerBar.Paint = function()
          surface.SetDrawColor(0,0,0,155)
          surface.DrawRect(0,0,GUI_PowerBar:GetWide(),7)
          surface.SetDrawColor(30,170,30,255)
          surface.DrawRect(0,1,GUI_PowerBar:GetWide()*(intPowerLevel/table.Count(GAMEMODE.Weapons[data.Weapon].UpGrades.Power)),5)
        end

        local GUI_PowerStat_Label = vgui.Create("DLabel")
        GUI_PowerStat_Label:SetParent(GUI_Chest_Base)
        GUI_PowerStat_Label:SetText(translate.Get("damage")..": "..tostring(GAMEMODE.Weapons[data.Weapon].UpGrades.Power[intPowerLevel].Level))
        GUI_PowerStat_Label:SetFont("Default")
        GUI_PowerStat_Label:SizeToContents()
        GUI_PowerStat_Label:SetPos(128 + 28 ,58)
        GUI_PowerStat_Label:SetColor(Color(255,255,255,255))

        if GAMEMODE.Weapons[data.Weapon].NumShots != nil then
          local GUI_PowerStat_Label_NumShots = vgui.Create("DLabel")
          GUI_PowerStat_Label_NumShots:SetParent(GUI_Chest_Base)
          GUI_PowerStat_Label_NumShots:SetText("x "..tostring(GAMEMODE.Weapons[data.Weapon].NumShots))
          GUI_PowerStat_Label_NumShots:SetFont("Default")
          GUI_PowerStat_Label_NumShots:SizeToContents()
          GUI_PowerStat_Label_NumShots:SetPos(128 + 28 +GUI_PowerStat_Label:GetWide() ,58)
          GUI_PowerStat_Label_NumShots:SetColor(Color(255,255,255,255))
        end

        local GUI_AccuracyBar = vgui.Create("DPanel")
        GUI_AccuracyBar:SetParent(GUI_Chest_Background)
        GUI_AccuracyBar:SetSize(GUI_Chest_Base:GetWide() - 128 - 56,7)
        GUI_AccuracyBar:SetPos((128) + 28,70)
        GUI_AccuracyBar.Paint = function()
          surface.SetDrawColor(0,0,0,155)
          surface.DrawRect(0,0,GUI_AccuracyBar:GetWide(),7)
          surface.SetDrawColor(30,170,30,255)
          surface.DrawRect(0,1,GUI_AccuracyBar:GetWide()*(intAccuracyLevel/table.Count(GAMEMODE.Weapons[data.Weapon].UpGrades.Accuracy)),5)
        end

        local GUI_AccuracyStat_Label = vgui.Create("DLabel")
        GUI_AccuracyStat_Label:SetParent(GUI_Chest_Base)
        GUI_AccuracyStat_Label:SetText(translate.Get("accuracy")..": "..tostring(GAMEMODE.Weapons[data.Weapon].UpGrades.Accuracy[intAccuracyLevel].Level))
        GUI_AccuracyStat_Label:SetFont("Default")
        GUI_AccuracyStat_Label:SizeToContents()
        GUI_AccuracyStat_Label:SetPos(128 + 28,78)
        GUI_AccuracyStat_Label:SetColor(Color(255,255,255,255))

        local GUI_ClipSizeBar = vgui.Create("DPanel")
        GUI_ClipSizeBar:SetParent(GUI_Chest_Background)
        GUI_ClipSizeBar:SetSize(GUI_Chest_Base:GetWide() - (128) - 56,7)
        GUI_ClipSizeBar:SetPos(128 + 28,90)
        GUI_ClipSizeBar.Paint = function()
          surface.SetDrawColor(0,0,0,155)
          surface.DrawRect(0,0,GUI_ClipSizeBar:GetWide(),7)
          surface.SetDrawColor(30,170,30,255)
          surface.DrawRect(0,1,GUI_ClipSizeBar:GetWide()*(intClipSizeLevel/table.Count(GAMEMODE.Weapons[data.Weapon].UpGrades.ClipSize)),5)
        end

        local GUI_ClipSizeStat_Label = vgui.Create("DLabel")
        GUI_ClipSizeStat_Label:SetParent(GUI_Chest_Base)
        GUI_ClipSizeStat_Label:SetText(translate.Get("clip_size")..": "..tostring(GAMEMODE.Weapons[data.Weapon].UpGrades.ClipSize[intClipSizeLevel].Level))
        GUI_ClipSizeStat_Label:SetFont("Default")
        GUI_ClipSizeStat_Label:SizeToContents()
        GUI_ClipSizeStat_Label:SetPos(128 + 28 ,98)
        GUI_ClipSizeStat_Label:SetColor(Color(255,255,255,255))

        local GUI_FiringSpeedBar = vgui.Create("DPanel")
        GUI_FiringSpeedBar:SetParent(GUI_Chest_Background)
        GUI_FiringSpeedBar:SetSize(GUI_Chest_Base:GetWide() - (128) - 56,7)
        GUI_FiringSpeedBar:SetPos(128 + 28,110)
        GUI_FiringSpeedBar.Paint = function()
                      surface.SetDrawColor(0,0,0,155)
                      surface.DrawRect(0,0,GUI_FiringSpeedBar:GetWide(),7)
                      surface.SetDrawColor(30,170,30,255)
                      surface.DrawRect(0,1,GUI_FiringSpeedBar:GetWide()*(intFiringSpeedLevel/table.Count(GAMEMODE.Weapons[data.Weapon].UpGrades.FiringSpeed)),5)
                    end


        local GUI_FiringSpeedStat_Label = vgui.Create("DLabel")
        GUI_FiringSpeedStat_Label:SetParent(GUI_Chest_Base)
        GUI_FiringSpeedStat_Label:SetText(translate.Get("firing_speed")..": "..tostring(GAMEMODE.Weapons[data.Weapon].UpGrades.FiringSpeed[intFiringSpeedLevel].Level))
        GUI_FiringSpeedStat_Label:SetFont("Default")
        GUI_FiringSpeedStat_Label:SizeToContents()
        GUI_FiringSpeedStat_Label:SetPos(128 + 28,118)
        GUI_FiringSpeedStat_Label:SetColor(Color(255,255,255,255))

        local GUI_ReloadSpeedBar = vgui.Create("DPanel")
        GUI_ReloadSpeedBar:SetParent(GUI_Chest_Background)
        GUI_ReloadSpeedBar:SetSize(GUI_Chest_Base:GetWide() - (128) - 56,7)
        GUI_ReloadSpeedBar:SetPos(128 + 28,130)
        GUI_ReloadSpeedBar.Paint = function()
          surface.SetDrawColor(0,0,0,155)
          surface.DrawRect(0,0,GUI_ReloadSpeedBar:GetWide(),7)
          surface.SetDrawColor(30,170,30,255)
          surface.DrawRect(0,1,GUI_ReloadSpeedBar:GetWide()*(intReloadSpeedLevel/table.Count(GAMEMODE.Weapons[data.Weapon].UpGrades.ReloadSpeed)),5)
        end

        local GUI_ReloadSpeedStat_Label = vgui.Create("DLabel")
        GUI_ReloadSpeedStat_Label:SetParent(GUI_Chest_Base)
        GUI_ReloadSpeedStat_Label:SetText(translate.Get("reload_speed")..": "..tostring(GAMEMODE.Weapons[data.Weapon].UpGrades.ReloadSpeed[intReloadSpeedLevel].Level))
        GUI_ReloadSpeedStat_Label:SetFont("Default")
        GUI_ReloadSpeedStat_Label:SizeToContents()
        GUI_ReloadSpeedStat_Label:SetPos(128 + 28,138)
        GUI_ReloadSpeedStat_Label:SetColor(Color(255,255,255,255))

      GUI_Chest_Base:SetContents(GUI_Chest_Background)

      GUI_Chest_Panel:AddItem(GUI_Chest_Base)
      int_position_numbery = int_position_numbery + 200
    end
  end
  ent_WorldEntity:Remove()
end
