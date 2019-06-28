function openUpgrades()
  UpgradesBase = re2_create_Frame(MainPanel, 0, .05, 1, .95)
  UpgradesBase.Paint = function() draw.RoundedBox( 0, 0, 0, MainPanel:GetWide(), MainPanel:GetTall(), Color(60,60,60,255)) end
  
  if GetGlobalString("Mode") != "Merchant" && LocalPlayer():Team() == TEAM_HUNK  then return end
  local client = LocalPlayer()
  local SW,SH = ScrW(),ScrH()
  local s = CreateSound(client, table.Random(GAMEMODE.MerchantSounds.MerchantWelcome))
  s:Play()
  s:ChangeVolume(0.2)

  local GUI_Property_Sheet = vgui.Create("DPropertySheet")
  GUI_Property_Sheet:SetParent(UpgradesBase)
  GUI_Property_Sheet:SetPos(UpgradesBase:GetWide()*.01,UpgradesBase:GetTall()*.01)
  GUI_Property_Sheet:SetSize(UpgradesBase:GetWide()*.98,UpgradesBase:GetTall()*.98 )
  GUI_Property_Sheet.Paint = function()
                  surface.SetDrawColor(0,0,0,200)
                  surface.DrawOutlinedRect(0,0,GUI_Property_Sheet:GetWide(),GUI_Property_Sheet:GetTall())
                  surface.SetDrawColor(60,40,30,155)
                  surface.DrawRect(0,0,GUI_Property_Sheet:GetWide(),GUI_Property_Sheet:GetTall())
                end
  
  
  
  
  local GUI_Inventory_Panel = vgui.Create("DPanelList")
  GUI_Inventory_Panel:SetParent(GUI_Property_Sheet)
  GUI_Inventory_Panel:SetSize(GUI_Property_Sheet:GetWide(),GUI_Property_Sheet:GetTall() - 48)
  GUI_Inventory_Panel:SetSpacing(5)
  GUI_Inventory_Panel:SetPos(0,48)
  GUI_Inventory_Panel.Paint = function() end -- dont draw
  GUI_Inventory_Panel:EnableVerticalScrollbar( true )
  
  GUI_LoadInventory(GUI_Inventory_Panel)
  
  GUI_Property_Sheet:AddSheet( "Upgrade Weapons", GUI_Inventory_Panel, "icon16/box.png", true, true, "I wonder what you would buy here?" )
  
  
  
  
  
end

















  function GUI_LoadInventory(GUI_Inventory_Panel,storage)
  local int_position_numbery = 0
  local int_position_numberx = 128
  local ent_WorldEntity = ents.CreateClientProp("prop_physics")
 
  ent_WorldEntity:SetAngles(Angle(0,0,0))
  ent_WorldEntity:SetPos(Vector(0,0,0))
  ent_WorldEntity:Spawn()
  ent_WorldEntity:Activate()
  for slot,data in pairs(Inventory) do
    for key,weapondata in pairs(GAMEMODE.Weapons) do
      if key == data.Item then
        local GUI_Inventory_Base = vgui.Create("DCollapsibleCategory")
        GUI_Inventory_Base:SetParent(GUI_Inventorys_Panel)
        GUI_Inventory_Base:SetPos( 0,int_position_numbery )
        GUI_Inventory_Base:SetSize( GUI_Inventory_Panel:GetWide(), 30 ) -- Keep the second number at 50
        GUI_Inventory_Base:SetExpanded( 0 ) -- Expanded when popped up
        GUI_Inventory_Base:SetLabel( GAMEMODE.Items[data.Item].Name )---- Cross check to find the name
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

        ent_WorldEntity:SetModel(GAMEMODE.Items[data.Item].Model)

        local GUI_Inventory_Item_Icon = vgui.Create("DModelPanel")
        GUI_Inventory_Item_Icon:SetParent(GUI_Inventory_Base)
        GUI_Inventory_Item_Icon:SetSize(128,128)
        GUI_Inventory_Item_Icon:SetPos(0,30)
        GUI_Inventory_Item_Icon:SetModel(GAMEMODE.Items[data.Item].Model)

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
                                      RunConsoleCommand("inv_DepositItem",data.Item,slot)
                                      GUI_Inventory_Base:Remove()
                                      break
                                    end
                                  end
                                end
        end

        int_position_numberx = 128

        GUI_Inventory_Update_Weapon_Stats(GUI_Inventory_Background,data.Item,GUI_Inventory_Base)

        GUI_Inventory_Base:SetContents(GUI_Inventory_Background)

        GUI_Inventory_Panel:AddItem(GUI_Inventory_Base)
        int_position_numbery = int_position_numbery + 200
      end
    end
  end
  ent_WorldEntity:Remove()
  end

  function GUI_Inventory_Update_Weapon_Stats(GUI_Inventory_Background,Item,GUI_Inventory_Base)
        local client = LocalPlayer()
  ---------------------------- Bars/Labels
        local Item = Item
        local intPowerLevel = Upgrades[Item].pwrlvl
        local intAccuracyLevel = Upgrades[Item].acclvl
        local intClipSizeLevel = Upgrades[Item].clplvl
        local intFiringSpeedLevel = Upgrades[Item].fislvl
        local intReloadSpeedLevel = Upgrades[Item].reslvl
        local GUI_PowerBar = vgui.Create("DPanel")
        GUI_PowerBar:SetParent(GUI_Inventory_Background)
        GUI_PowerBar:SetSize(GUI_Inventory_Base:GetWide() - (128) - 56 ,7)
        GUI_PowerBar:SetPos((128) + 28,50 )
        GUI_PowerBar.Paint = function()
          surface.SetDrawColor(0,0,0,155)
          surface.DrawRect(0,0,GUI_PowerBar:GetWide(),7)
          surface.SetDrawColor(30,170,30,255)
          surface.DrawRect(0,1,GUI_PowerBar:GetWide()*(intPowerLevel/table.Count(GAMEMODE.Weapons[Item].UpGrades.Power)),5)
        end

        local GUI_PowerBar_Label = vgui.Create("DLabel")
        GUI_PowerBar_Label:SetParent(GUI_Inventory_Base)
        GUI_PowerBar_Label:SetPos(128 + (GUI_Inventory_Base:GetWide() - (128) - 56 - GUI_PowerBar_Label:GetWide()) ,58)
        GUI_PowerBar_Label:SetText("$"..tostring(GAMEMODE.Weapons[Item].UpGrades.Power[intPowerLevel].Price) )
        GUI_PowerBar_Label:SetFont("Default")
        GUI_PowerBar_Label:SizeToContents()
        GUI_PowerBar_Label:SetColor(Color(255,255,255,255))

        local GUI_PowerStat_Label = vgui.Create("DLabel")
        GUI_PowerStat_Label:SetParent(GUI_Inventory_Base)
        GUI_PowerStat_Label:SetText("Damage: "..tostring(GAMEMODE.Weapons[Item].UpGrades.Power[intPowerLevel].Level))
        GUI_PowerStat_Label:SetPos(128 + 28 ,58)
        GUI_PowerStat_Label:SetFont("Default")
        GUI_PowerStat_Label:SizeToContents()
        GUI_PowerStat_Label:SetColor(Color(255,255,255,255))

        if GAMEMODE.Weapons[Item].NumShots != nil then
          local GUI_PowerStat_Label_NumShots = vgui.Create("DLabel")
          GUI_PowerStat_Label_NumShots:SetParent(GUI_Inventory_Base)
          GUI_PowerStat_Label_NumShots:SetText("x "..tostring(GAMEMODE.Weapons[Item].NumShots))
          GUI_PowerStat_Label_NumShots:SetPos(128 + 28 +GUI_PowerStat_Label:GetWide() ,58)
          GUI_PowerStat_Label_NumShots:SetFont("Default")
          GUI_PowerStat_Label_NumShots:SizeToContents()
          GUI_PowerStat_Label_NumShots:SetColor(Color(255,255,255,255))
        end

        local GUI_AccuracyBar = vgui.Create("DPanel")
        GUI_AccuracyBar:SetParent(GUI_Inventory_Background)
        GUI_AccuracyBar:SetSize(GUI_Inventory_Base:GetWide() - 128 - 56,7)
        GUI_AccuracyBar:SetPos((128) + 28,70)
        GUI_AccuracyBar.Paint = function()
          surface.SetDrawColor(0,0,0,155)
          surface.DrawRect(0,0,GUI_AccuracyBar:GetWide(),7)
          surface.SetDrawColor(30,170,30,255)
          surface.DrawRect(0,1,GUI_AccuracyBar:GetWide()*(intAccuracyLevel/table.Count(GAMEMODE.Weapons[Item].UpGrades.Accuracy)),5)
        end

        local GUI_AccuracyBar_Label = vgui.Create("DLabel")
        GUI_AccuracyBar_Label:SetParent(GUI_Inventory_Base)
        GUI_AccuracyBar_Label:SetPos(128 + (GUI_Inventory_Base:GetWide() - (128) - 56 - GUI_AccuracyBar_Label:GetWide()),78)
        GUI_AccuracyBar_Label:SetText("$"..tostring(GAMEMODE.Weapons[Item].UpGrades.Accuracy[intAccuracyLevel].Price) )
        GUI_AccuracyBar_Label:SetFont("Default")
        GUI_AccuracyBar_Label:SizeToContents()
        GUI_AccuracyBar_Label:SetColor(Color(255,255,255,255))

        local GUI_AccuracyStat_Label = vgui.Create("DLabel")
        GUI_AccuracyStat_Label:SetParent(GUI_Inventory_Base)
        GUI_AccuracyStat_Label:SetText("Accuracy: "..tostring(GAMEMODE.Weapons[Item].UpGrades.Accuracy[intAccuracyLevel].Level))
        GUI_AccuracyStat_Label:SetPos(128 + 28,78)
        GUI_AccuracyStat_Label:SetFont("Default")
        GUI_AccuracyStat_Label:SizeToContents()
        GUI_AccuracyStat_Label:SetColor(Color(255,255,255,255))

        local GUI_ClipSizeBar = vgui.Create("DPanel")
        GUI_ClipSizeBar:SetParent(GUI_Inventory_Background)
        GUI_ClipSizeBar:SetSize(GUI_Inventory_Base:GetWide() - (128) - 56,7)
        GUI_ClipSizeBar:SetPos(128 + 28,90)
        GUI_ClipSizeBar.Paint = function()
          surface.SetDrawColor(0,0,0,155)
          surface.DrawRect(0,0,GUI_ClipSizeBar:GetWide(),7)
          surface.SetDrawColor(30,170,30,255)
          surface.DrawRect(0,1,GUI_ClipSizeBar:GetWide()*(intClipSizeLevel/table.Count(GAMEMODE.Weapons[Item].UpGrades.ClipSize)),5)
        end

        local GUI_ClipSizeBar_Label = vgui.Create("DLabel")
        GUI_ClipSizeBar_Label:SetParent(GUI_Inventory_Base)
        GUI_ClipSizeBar_Label:SetPos(128 + (GUI_Inventory_Base:GetWide() - (128) - 56 - GUI_ClipSizeBar_Label:GetWide()),98)
        GUI_ClipSizeBar_Label:SetText("$"..tostring(GAMEMODE.Weapons[Item].UpGrades.ClipSize[intClipSizeLevel].Price) )
        GUI_ClipSizeBar_Label:SetFont("Default")
        GUI_ClipSizeBar_Label:SizeToContents()
        GUI_ClipSizeBar_Label:SetColor(Color(255,255,255,255))

        local GUI_ClipSizeStat_Label = vgui.Create("DLabel")
        GUI_ClipSizeStat_Label:SetParent(GUI_Inventory_Base)
        GUI_ClipSizeStat_Label:SetText("Clip Size: "..tostring(GAMEMODE.Weapons[Item].UpGrades.ClipSize[intClipSizeLevel].Level))
        GUI_ClipSizeStat_Label:SetPos(128 + 28 ,98)
        GUI_ClipSizeStat_Label:SetFont("Default")
        GUI_ClipSizeStat_Label:SizeToContents()
        GUI_ClipSizeStat_Label:SetColor(Color(255,255,255,255))

        local GUI_FiringSpeedBar = vgui.Create("DPanel")
        GUI_FiringSpeedBar:SetParent(GUI_Inventory_Background)
        GUI_FiringSpeedBar:SetSize(GUI_Inventory_Base:GetWide() - (128) - 56,7)
        GUI_FiringSpeedBar:SetPos(128 + 28,110)
        GUI_FiringSpeedBar.Paint = function()
                      surface.SetDrawColor(0,0,0,155)
                      surface.DrawRect(0,0,GUI_FiringSpeedBar:GetWide(),7)
                      surface.SetDrawColor(30,170,30,255)
                      surface.DrawRect(0,1,GUI_FiringSpeedBar:GetWide()*(intFiringSpeedLevel/table.Count(GAMEMODE.Weapons[Item].UpGrades.FiringSpeed)),5)
                    end

        local GUI_FiringSpeedBar_Label = vgui.Create("DLabel")
        GUI_FiringSpeedBar_Label:SetParent(GUI_Inventory_Base)
        GUI_FiringSpeedBar_Label:SetPos((128) + (GUI_Inventory_Base:GetWide() - (128) - 56 - GUI_FiringSpeedBar_Label:GetWide()),118)
        GUI_FiringSpeedBar_Label:SetText("$"..tostring(GAMEMODE.Weapons[Item].UpGrades.FiringSpeed[intFiringSpeedLevel].Price) )
        GUI_FiringSpeedBar_Label:SetFont("Default")
        GUI_FiringSpeedBar_Label:SizeToContents()
        GUI_FiringSpeedBar_Label:SetColor(Color(255,255,255,255))

        local GUI_FiringSpeedStat_Label = vgui.Create("DLabel")
        GUI_FiringSpeedStat_Label:SetParent(GUI_Inventory_Base)
        GUI_FiringSpeedStat_Label:SetText("Firing Speed: "..tostring(GAMEMODE.Weapons[Item].UpGrades.FiringSpeed[intFiringSpeedLevel].Level))
        GUI_FiringSpeedStat_Label:SetPos(128 + 28,118)
        GUI_FiringSpeedStat_Label:SetFont("Default")
        GUI_FiringSpeedStat_Label:SizeToContents()
        GUI_FiringSpeedStat_Label:SetColor(Color(255,255,255,255))

        local GUI_ReloadSpeedBar = vgui.Create("DPanel")
        GUI_ReloadSpeedBar:SetParent(GUI_Inventory_Background)
        GUI_ReloadSpeedBar:SetSize(GUI_Inventory_Base:GetWide() - (128) - 56,7)
        GUI_ReloadSpeedBar:SetPos(128 + 28,130)
        GUI_ReloadSpeedBar.Paint = function()
          surface.SetDrawColor(0,0,0,155)
          surface.DrawRect(0,0,GUI_ReloadSpeedBar:GetWide(),7)
          surface.SetDrawColor(30,170,30,255)
          surface.DrawRect(0,1,GUI_ReloadSpeedBar:GetWide()*(intReloadSpeedLevel/table.Count(GAMEMODE.Weapons[Item].UpGrades.ReloadSpeed)),5)
        end

        local GUI_ReloadSpeedBar_Label = vgui.Create("DLabel")
        GUI_ReloadSpeedBar_Label:SetParent(GUI_Inventory_Base)
        GUI_ReloadSpeedBar_Label:SetPos((128) + (GUI_Inventory_Base:GetWide() - (128) - 56 - GUI_ReloadSpeedBar_Label:GetWide()),138)
        GUI_ReloadSpeedBar_Label:SetText("$"..tostring(GAMEMODE.Weapons[Item].UpGrades.ReloadSpeed[intReloadSpeedLevel].Price) )
        GUI_ReloadSpeedBar_Label:SetFont("Default")
        GUI_ReloadSpeedBar_Label:SizeToContents()
        GUI_ReloadSpeedBar_Label:SetColor(Color(255,255,255,255))

        local GUI_ReloadSpeedStat_Label = vgui.Create("DLabel")
        GUI_ReloadSpeedStat_Label:SetParent(GUI_Inventory_Base)
        GUI_ReloadSpeedStat_Label:SetText("Reload Speed: "..tostring(GAMEMODE.Weapons[Item].UpGrades.ReloadSpeed[intReloadSpeedLevel].Level))
        GUI_ReloadSpeedStat_Label:SetPos(128 + 28,138)
        GUI_ReloadSpeedStat_Label:SetFont("Default")
        GUI_ReloadSpeedStat_Label:SizeToContents()
        GUI_ReloadSpeedStat_Label:SetColor(Color(255,255,255,255))

        local GUI_Power_UpgradeWeapon_Button = vgui.Create("DButton")
        GUI_Power_UpgradeWeapon_Button:SetParent(GUI_Inventory_Base)
        GUI_Power_UpgradeWeapon_Button:SetSize(50,15)
        GUI_Power_UpgradeWeapon_Button:SetPos(128  + (GUI_Inventory_Base:GetWide() - (128) - 56 - 25 ),57)
        GUI_Power_UpgradeWeapon_Button:SetText("Upgrade")


        local GUI_Accuracy_UpgradeWeapon_Button = vgui.Create("DButton")
        GUI_Accuracy_UpgradeWeapon_Button:SetParent(GUI_Inventory_Base)
        GUI_Accuracy_UpgradeWeapon_Button:SetSize(50,15)
        GUI_Accuracy_UpgradeWeapon_Button:SetPos(128  + (GUI_Inventory_Base:GetWide() - (128) - 56 - 25 ),77)
        GUI_Accuracy_UpgradeWeapon_Button:SetText("Upgrade")

        local GUI_ClipSize_UpgradeWeapon_Button = vgui.Create("DButton")
        GUI_ClipSize_UpgradeWeapon_Button:SetParent(GUI_Inventory_Base)
        GUI_ClipSize_UpgradeWeapon_Button:SetSize(50,15)
        GUI_ClipSize_UpgradeWeapon_Button:SetPos(128  + (GUI_Inventory_Base:GetWide() - (128) - 56 - 25 ),97)
        GUI_ClipSize_UpgradeWeapon_Button:SetText("Upgrade")

        local GUI_FiringSpeed_UpgradeWeapon_Button = vgui.Create("DButton")
        GUI_FiringSpeed_UpgradeWeapon_Button:SetParent(GUI_Inventory_Base)
        GUI_FiringSpeed_UpgradeWeapon_Button:SetSize(50,15)
        GUI_FiringSpeed_UpgradeWeapon_Button:SetPos(128  + (GUI_Inventory_Base:GetWide() - (128) - 56 - 25 ),117)
        GUI_FiringSpeed_UpgradeWeapon_Button:SetText("Upgrade")

        local GUI_ReloadSpeed_UpgradeWeapon_Button = vgui.Create("DButton")
        GUI_ReloadSpeed_UpgradeWeapon_Button:SetParent(GUI_Inventory_Base)
        GUI_ReloadSpeed_UpgradeWeapon_Button:SetSize(50,15)
        GUI_ReloadSpeed_UpgradeWeapon_Button:SetPos(128  + (GUI_Inventory_Base:GetWide() - (128) - 56 - 25 ),137)
        GUI_ReloadSpeed_UpgradeWeapon_Button:SetText("Upgrade")



  ---------------- Have to go below because all the derma neeeds to be defined
        GUI_Power_UpgradeWeapon_Button.DoClick = function(GUI_Power_UpgradeWeapon_Button)
                              if intPowerLevel < table.Count(GAMEMODE.Weapons[Item].UpGrades.Power) then
                                RunConsoleCommand("inv_UpgradeWeapon",Item,"Power")
                                GUI_PowerBar:Remove()
                                GUI_PowerBar_Label:Remove()
                                GUI_PowerStat_Label:Remove()
                                GUI_AccuracyBar:Remove()
                                GUI_AccuracyBar_Label:Remove()
                                GUI_AccuracyStat_Label:Remove()
                                GUI_ClipSizeBar:Remove()
                                GUI_ClipSizeBar_Label:Remove()
                                GUI_ClipSizeStat_Label:Remove()
                                GUI_FiringSpeedBar:Remove()
                                GUI_FiringSpeedBar_Label:Remove()
                                GUI_FiringSpeedStat_Label:Remove()
                                GUI_ReloadSpeedBar:Remove()
                                GUI_ReloadSpeedBar_Label:Remove()
                                GUI_ReloadSpeedStat_Label:Remove()
                                GUI_Power_UpgradeWeapon_Button:Remove()
                                GUI_Accuracy_UpgradeWeapon_Button:Remove()
                                GUI_ClipSize_UpgradeWeapon_Button:Remove()
                                GUI_FiringSpeed_UpgradeWeapon_Button:Remove()
                                GUI_ReloadSpeed_UpgradeWeapon_Button:Remove()
                                GlobalGUIs = {GUI_Inventory_Background,Item,GUI_Inventory_Base}
                              end
                            end
        GUI_Accuracy_UpgradeWeapon_Button.DoClick = function(GUI_Accuracy_UpgradeWeapon_Button)
                              if intAccuracyLevel < table.Count(GAMEMODE.Weapons[Item].UpGrades.Accuracy) then
                                RunConsoleCommand("inv_UpgradeWeapon",Item,"Accuracy")
                                GUI_PowerBar:Remove()
                                GUI_PowerBar_Label:Remove()
                                GUI_PowerStat_Label:Remove()
                                GUI_AccuracyBar:Remove()
                                GUI_AccuracyBar_Label:Remove()
                                GUI_AccuracyStat_Label:Remove()
                                GUI_ClipSizeBar:Remove()
                                GUI_ClipSizeBar_Label:Remove()
                                GUI_ClipSizeStat_Label:Remove()
                                GUI_FiringSpeedBar:Remove()
                                GUI_FiringSpeedBar_Label:Remove()
                                GUI_FiringSpeedStat_Label:Remove()
                                GUI_ReloadSpeedBar:Remove()
                                GUI_ReloadSpeedBar_Label:Remove()
                                GUI_ReloadSpeedStat_Label:Remove()
                                GUI_Power_UpgradeWeapon_Button:Remove()
                                GUI_Accuracy_UpgradeWeapon_Button:Remove()
                                GUI_ClipSize_UpgradeWeapon_Button:Remove()
                                GUI_FiringSpeed_UpgradeWeapon_Button:Remove()
                                GUI_ReloadSpeed_UpgradeWeapon_Button:Remove()
                                GlobalGUIs = {GUI_Inventory_Background,Item,GUI_Inventory_Base}
                              end
                            end
        GUI_ClipSize_UpgradeWeapon_Button.DoClick = function(GUI_ClipSize_UpgradeWeapon_Button)
                              if intClipSizeLevel < table.Count(GAMEMODE.Weapons[Item].UpGrades.ClipSize) then
                                RunConsoleCommand("inv_UpgradeWeapon",Item,"ClipSize")
                                GUI_PowerBar:Remove()
                                GUI_PowerBar_Label:Remove()
                                GUI_PowerStat_Label:Remove()
                                GUI_AccuracyBar:Remove()
                                GUI_AccuracyBar_Label:Remove()
                                GUI_AccuracyStat_Label:Remove()
                                GUI_ClipSizeBar:Remove()
                                GUI_ClipSizeBar_Label:Remove()
                                GUI_ClipSizeStat_Label:Remove()
                                GUI_FiringSpeedBar:Remove()
                                GUI_FiringSpeedBar_Label:Remove()
                                GUI_FiringSpeedStat_Label:Remove()
                                GUI_ReloadSpeedBar:Remove()
                                GUI_ReloadSpeedBar_Label:Remove()
                                GUI_ReloadSpeedStat_Label:Remove()
                                GUI_Power_UpgradeWeapon_Button:Remove()
                                GUI_Accuracy_UpgradeWeapon_Button:Remove()
                                GUI_ClipSize_UpgradeWeapon_Button:Remove()
                                GUI_FiringSpeed_UpgradeWeapon_Button:Remove()
                                GUI_ReloadSpeed_UpgradeWeapon_Button:Remove()
                                GlobalGUIs = {GUI_Inventory_Background,Item,GUI_Inventory_Base}															end
                            end
        GUI_FiringSpeed_UpgradeWeapon_Button.DoClick = function(GUI_FiringSpeed_UpgradeWeapon_Button)
                              if intFiringSpeedLevel < table.Count(GAMEMODE.Weapons[Item].UpGrades.FiringSpeed) then
                                RunConsoleCommand("inv_UpgradeWeapon",Item,"FiringSpeed")
                                GUI_PowerBar:Remove()
                                GUI_PowerBar_Label:Remove()
                                GUI_PowerStat_Label:Remove()
                                GUI_AccuracyBar:Remove()
                                GUI_AccuracyBar_Label:Remove()
                                GUI_AccuracyStat_Label:Remove()
                                GUI_ClipSizeBar:Remove()
                                GUI_ClipSizeBar_Label:Remove()
                                GUI_ClipSizeStat_Label:Remove()
                                GUI_FiringSpeedBar:Remove()
                                GUI_FiringSpeedBar_Label:Remove()
                                GUI_FiringSpeedStat_Label:Remove()
                                GUI_ReloadSpeedBar:Remove()
                                GUI_ReloadSpeedBar_Label:Remove()
                                GUI_ReloadSpeedStat_Label:Remove()
                                GUI_Power_UpgradeWeapon_Button:Remove()
                                GUI_Accuracy_UpgradeWeapon_Button:Remove()
                                GUI_ClipSize_UpgradeWeapon_Button:Remove()
                                GUI_FiringSpeed_UpgradeWeapon_Button:Remove()
                                GUI_ReloadSpeed_UpgradeWeapon_Button:Remove()
                                GlobalGUIs = {GUI_Inventory_Background,Item,GUI_Inventory_Base}
                              end
                            end
        GUI_ReloadSpeed_UpgradeWeapon_Button.DoClick = function(GUI_ReloadSpeed_UpgradeWeapon_Button)
                              if intReloadSpeedLevel < table.Count(GAMEMODE.Weapons[Item].UpGrades.ReloadSpeed) then
                                RunConsoleCommand("inv_UpgradeWeapon",Item,"ReloadSpeed")
                                GUI_PowerBar:Remove()
                                GUI_PowerBar_Label:Remove()
                                GUI_PowerStat_Label:Remove()
                                GUI_AccuracyBar:Remove()
                                GUI_AccuracyBar_Label:Remove()
                                GUI_AccuracyStat_Label:Remove()
                                GUI_ClipSizeBar:Remove()
                                GUI_ClipSizeBar_Label:Remove()
                                GUI_ClipSizeStat_Label:Remove()
                                GUI_FiringSpeedBar:Remove()
                                GUI_FiringSpeedBar_Label:Remove()
                                GUI_FiringSpeedStat_Label:Remove()
                                GUI_ReloadSpeedBar:Remove()
                                GUI_ReloadSpeedBar_Label:Remove()
                                GUI_ReloadSpeedStat_Label:Remove()
                                GUI_Power_UpgradeWeapon_Button:Remove()
                                GUI_Accuracy_UpgradeWeapon_Button:Remove()
                                GUI_ClipSize_UpgradeWeapon_Button:Remove()
                                GUI_FiringSpeed_UpgradeWeapon_Button:Remove()
                                GUI_ReloadSpeed_UpgradeWeapon_Button:Remove()
                                GlobalGUIs = {GUI_Inventory_Background,Item,GUI_Inventory_Base}
                              end
                            end


end
