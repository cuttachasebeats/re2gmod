function openStore()
  StoreBase = re2_create_Frame(MainPanel, 0, .05, 1, .95)
  StoreBase.Paint = function() draw.RoundedBox( 0, 0, 0, MainPanel:GetWide(), MainPanel:GetTall(), Color(60,60,60,255)) end

  if GetGlobalString("Mode") != "Merchant" && LocalPlayer():Team() == TEAM_HUNK  then return end
  local client = LocalPlayer()
  local SW,SH = ScrW(),ScrH()
  local s = CreateSound(client, table.Random(GAMEMODE.MerchantSounds.MerchantWelcome))
  s:Play()
  s:ChangeVolume(0.2)

  local GUI_Property_Sheet = vgui.Create("DPropertySheet")
  GUI_Property_Sheet:SetParent(StoreBase)
  GUI_Property_Sheet:SetPos(StoreBase:GetWide()*.01,StoreBase:GetTall()*.01)
  GUI_Property_Sheet:SetSize(StoreBase:GetWide()*.98,StoreBase:GetTall()*.98 )
  GUI_Property_Sheet.Paint = function()
                  surface.SetDrawColor(0,0,0,200)
                  surface.DrawOutlinedRect(0,0,GUI_Property_Sheet:GetWide(),GUI_Property_Sheet:GetTall())
                  surface.SetDrawColor(60,40,30,155)
                  surface.DrawRect(0,0,GUI_Property_Sheet:GetWide(),GUI_Property_Sheet:GetTall())
                end

  local GUI_Weapons_Panel = vgui.Create("DPanelList")
  GUI_Weapons_Panel:SetParent(GUI_Property_Sheet)
  GUI_Weapons_Panel:SetSize(GUI_Property_Sheet:GetWide(),GUI_Property_Sheet:GetTall() - 48)
  GUI_Weapons_Panel:SetPos(0,48)
  GUI_Weapons_Panel:SetSpacing(5)
  GUI_Weapons_Panel.Paint = function() end -- dont draw
  GUI_Weapons_Panel:EnableVerticalScrollbar( true )

  local GUI_Items_Panel = vgui.Create("DPanelList")
  GUI_Items_Panel:SetParent(GUI_Property_Sheet)
  GUI_Items_Panel:SetSize(GUI_Property_Sheet:GetWide(),GUI_Property_Sheet:GetTall() - 48)
  GUI_Items_Panel:SetPos(0,48)
  GUI_Items_Panel:SetSpacing(5)
  GUI_Items_Panel.Paint = function() end -- dont draw
  GUI_Items_Panel:EnableVerticalScrollbar( true )

  GUI_LoadWeapons(GUI_Weapons_Panel)
  GUI_LoadItems(GUI_Items_Panel)

  GUI_Property_Sheet:AddSheet( "Buy Weapons", GUI_Weapons_Panel, "icon16/money.png", true, true, "I wonder what you would buy here?" )
  GUI_Property_Sheet:AddSheet( "Buy Items", GUI_Items_Panel, "icon16/money.png", true, true, "I wonder what you would buy here?" )
  --GUI_LoadMerchantPanels(StoreBase)
  end
  concommand.Add("RE2_MerchantMenu",openStore)

  
  
  
  
  
  
  
  function GUI_LoadWeapons(GUI_Weapons_Panel)
  local client = LocalPlayer()
  local int_position_numbery = 0
  local int_position_numberx = 128
  local ent_WorldEntity = ents.CreateClientProp("prop_physics")
  ent_WorldEntity:SetAngles(Angle(0,0,0))
  ent_WorldEntity:SetPos(Vector(0,0,0))
  ent_WorldEntity:Spawn()
  ent_WorldEntity:Activate()
  for weapon,data in pairs(GAMEMODE.Weapons) do
    local GUI_Weapon_Base = vgui.Create("DCollapsibleCategory")
    GUI_Weapon_Base:SetParent(GUI_Weapons_Panel)
    GUI_Weapon_Base:SetPos( 0,int_position_numbery )
    GUI_Weapon_Base:SetSize( GUI_Weapons_Panel:GetWide(), 30 ) -- Keep the second number at 50
    GUI_Weapon_Base:SetExpanded( 0 ) -- Expanded when popped up
    GUI_Weapon_Base:SetLabel( GAMEMODE.Items[data.Item].Name )---- Cross check to find the name
    GUI_Weapon_Base.Paint = function()
                  surface.SetDrawColor(60,60,60,255)
                  surface.DrawRect(0,0,GUI_Weapon_Base:GetWide()-1,22-1)
                  surface.SetDrawColor(0,0,0,255)
                  surface.DrawOutlinedRect(0,0,GUI_Weapon_Base:GetWide(),22)
                end
      local GUI_Weapon_Background = vgui.Create("DPanel")
      GUI_Weapon_Background:SetParent(GUI_Weapon_Base)
      GUI_Weapon_Background:SetSize(GUI_Weapon_Base:GetWide(),170)
      GUI_Weapon_Background.Paint = function()
                      surface.SetDrawColor(0,0,0,255)
                      surface.DrawOutlinedRect(0,0,GUI_Weapon_Background:GetWide(),GUI_Weapon_Background:GetTall())
                      surface.SetDrawColor(100,100,100,255)
                      surface.DrawRect(1,0,GUI_Weapon_Background:GetWide()-2,GUI_Weapon_Background:GetTall()-1)
                      surface.SetDrawColor(0,0,0,255)
                      surface.DrawOutlinedRect(0,0,128,128)
                      for i = 1, #data.AmmoTypes do
                        surface.DrawOutlinedRect(int_position_numberx - i ,0,128,128)
                        int_position_numberx = int_position_numberx + 128
                      end
                      int_position_numberx = 128
                    end


    local GUI_Weapon_BuyItem_Button = vgui.Create("DButton")
    GUI_Weapon_BuyItem_Button:SetParent(GUI_Weapon_Base)
    GUI_Weapon_BuyItem_Button:SetSize(100,20)
    GUI_Weapon_BuyItem_Button:SetPos(14,160)
    GUI_Weapon_BuyItem_Button:SetText("Buy for $"..GAMEMODE.Items[data.Item].Price)
    GUI_Weapon_BuyItem_Button.DoClick = function(GUI_Weapon_BuyItem_Button)
                        if client:GetNWInt("Money") >= tonumber(GAMEMODE.Items[data.Item].Price) then
                          RunConsoleCommand("inv_BuyItem",weapon)
                          local s = CreateSound(client, table.Random(GAMEMODE.MerchantSounds.MerchantBuy))
                          s:Play()
                          s:ChangeVolume(0.2)
                          GlobalBuyGUIs = {GUI_Inventory_Panel}
                        else
                          local s = CreateSound(client, "reg/merchant/notenoughcash.wav")
                          s:Play()
                          s:ChangeVolume(0.2)
                        end
                      end


    ent_WorldEntity:SetModel(GAMEMODE.Items[weapon].Model)

    local GUI_Weapon_Item_Icon = vgui.Create("DModelPanel")
    GUI_Weapon_Item_Icon:SetParent(GUI_Weapon_Base)
    GUI_Weapon_Item_Icon:SetSize(128,128)
    GUI_Weapon_Item_Icon:SetPos(0,30)
    GUI_Weapon_Item_Icon:SetModel(GAMEMODE.Items[weapon].Model)

    local center = ent_WorldEntity:OBBCenter()
    local dist = ent_WorldEntity:BoundingRadius()*.8

    GUI_Weapon_Item_Icon:SetLookAt(center)
    GUI_Weapon_Item_Icon:SetCamPos(center+Vector(dist,dist,0))

    int_position_numberx = 128

    for numb,AmmoType in pairs(data.AmmoTypes) do
      if AmmoType.item != nil then
        local GUI_Weapon_BuyAmmo_Button = vgui.Create("DButton")
        GUI_Weapon_BuyAmmo_Button:SetParent(GUI_Weapon_Base)
        GUI_Weapon_BuyAmmo_Button:SetSize(100,20)
        GUI_Weapon_BuyAmmo_Button:SetPos(numb * 128 + 14 - numb,160)
        GUI_Weapon_BuyAmmo_Button:SetText("Buy for $"..GAMEMODE.Items[AmmoType.item].Price)
        GUI_Weapon_BuyAmmo_Button.DoClick = function(GUI_Weapon_BuyAmmo_Button)
                            if client:GetNWInt("Money") >= tonumber(GAMEMODE.Items[AmmoType.item].Price) then
                              RunConsoleCommand("inv_BuyItem",AmmoType.item)
                              local s = CreateSound(client, table.Random(GAMEMODE.MerchantSounds.MerchantBuy))
                              s:Play()
                              s:ChangeVolume(0.2)
                            else
                              local s = CreateSound(client, "reg/merchant/notenoughcash.wav")
                              s:Play()
                              s:ChangeVolume(0.2)
                            end
                          end

        local GUI_Weapon_Item_Ammo_Icon = vgui.Create("DModelPanel")
        GUI_Weapon_Item_Ammo_Icon:SetParent(GUI_Weapon_Base)
        GUI_Weapon_Item_Ammo_Icon:SetSize(128,128)
        GUI_Weapon_Item_Ammo_Icon:SetPos(numb * 128 + 14 - numb,23)

        ent_WorldEntity:SetModel(GAMEMODE.Items[AmmoType.item].Model)

        center = ent_WorldEntity:OBBCenter()
        dist = ent_WorldEntity:BoundingRadius()*1.7

        GUI_Weapon_Item_Ammo_Icon:SetModel(GAMEMODE.Items[AmmoType.item].Model)

        if GAMEMODE.Items[AmmoType.item].Material != nil then
          ent_WorldEntity:SetMaterial(GAMEMODE.Items[AmmoType.item].Material)
          GUI_Weapon_Item_Ammo_Icon:GetEntity():SetMaterial(GAMEMODE.Items[AmmoType.item].Material)
        end
        if AmmoType.Icon != nil then
          GUI_Weapon_Item_Ammo_Icon:SetLookAt(center)
          GUI_Weapon_Item_Ammo_Icon:SetCamPos(center+Vector(dist,dist,0))

          local GUI_Weapon_Ammo_Icon = vgui.Create("DImage")
          GUI_Weapon_Ammo_Icon:SetParent(GUI_Weapon_Base)
          GUI_Weapon_Ammo_Icon:SetSize(64,64)
          GUI_Weapon_Ammo_Icon:SetPos(int_position_numberx-numb,23)
          GUI_Weapon_Ammo_Icon:SetImage(AmmoType.Icon)
        end
      else
        if AmmoType.Icon != nil then
          local GUI_Weapon_Ammo_Icon = vgui.Create("DImage")
          GUI_Weapon_Ammo_Icon:SetParent(GUI_Weapon_Base)
          GUI_Weapon_Ammo_Icon:SetSize(128,128)
          GUI_Weapon_Ammo_Icon:SetPos(int_position_numberx-numb,30)
          GUI_Weapon_Ammo_Icon:SetImage(AmmoType.Icon)
        end

        local GUI_NoAmmo_Label = vgui.Create("DLabel")
        GUI_NoAmmo_Label:SetParent(GUI_Weapon_Base)
        GUI_NoAmmo_Label:SetPos(numb * 128 + 14 - numb,160)
        GUI_NoAmmo_Label:SetText("No Ammo is available.")
        GUI_NoAmmo_Label:SizeToContents()
        GUI_NoAmmo_Label:SetFont("Default")
        GUI_NoAmmo_Label:SetColor(Color(200,0,0,255))
      end

      int_position_numberx = int_position_numberx + 128
    end


    local GUI_Desc_Label = vgui.Create("DLabel")
    GUI_Desc_Label:SetParent(GUI_Weapon_Base)
    GUI_Desc_Label:SetPos(4,128)
    GUI_Desc_Label:SetText(GAMEMODE.Items[weapon].Desc)
    GUI_Desc_Label:SetWidth(120)
    GUI_Desc_Label:SetFont("Default")
    GUI_Desc_Label:SetColor(Color(255,255,255,255))

    local intPowerLevel = 1
    local intAccuracyLevel = 1
    local intClipSizeLevel = 1
    local intFiringSpeedLevel = 1
    local intReloadSpeedLevel = 1
    GUI_PowerBar = vgui.Create("DPanel")
    GUI_PowerBar:SetParent(GUI_Weapon_Background)
    GUI_PowerBar:SetSize(GUI_Weapon_Base:GetWide() - (128 * #data.AmmoTypes + 128) - 56 ,7)
    GUI_PowerBar:SetPos((128 * #data.AmmoTypes + 128) + 28,50 )
    GUI_PowerBar.Paint = function()
      surface.SetDrawColor(0,0,0,155)
      surface.DrawRect(0,0,GUI_PowerBar:GetWide(),7)
      surface.SetDrawColor(30,170,30,255)
      surface.DrawRect(0,1,GUI_PowerBar:GetWide()*(intPowerLevel/table.Count(GAMEMODE.Weapons[data.Item].UpGrades.Power)),5)
    end

    local GUI_PowerBar_Label = vgui.Create("DLabel")
    GUI_PowerBar_Label:SetParent(GUI_Weapon_Base)
    GUI_PowerBar_Label:SetPos((128 * #data.AmmoTypes + 128) + 28,58)
    GUI_PowerBar_Label:SetText("Maximum Power Level: "..#data.UpGrades.Power )
    GUI_PowerBar_Label:SetFont("Default")
    GUI_PowerBar_Label:SizeToContents()
    GUI_PowerBar_Label:SetColor(Color(255,255,255,255))

    local GUI_PowerStat_Label = vgui.Create("DLabel")
    GUI_PowerStat_Label:SetParent(GUI_Weapon_Base)
    GUI_PowerStat_Label:SetText("Damage: "..tostring(GAMEMODE.Weapons[data.Item].UpGrades.Power[intPowerLevel].Level))
    GUI_PowerStat_Label:SetFont("Default")
    GUI_PowerStat_Label:SizeToContents()
    GUI_PowerStat_Label:SetPos(((128 * #data.AmmoTypes + 128) + 28) + (GUI_Weapon_Base:GetWide() - (128 * #data.AmmoTypes + 128) - 56 - GUI_PowerStat_Label:GetWide()),58)
    GUI_PowerStat_Label:SetColor(Color(255,255,255,255))

    if GAMEMODE.Weapons[weapon].NumShots != nil then
      local GUI_PowerStat_Label_NumShots = vgui.Create("DLabel")
      GUI_PowerStat_Label_NumShots:SetParent(GUI_Weapon_Base)
      GUI_PowerStat_Label_NumShots:SetText("x "..tostring(GAMEMODE.Weapons[weapon].NumShots))
      GUI_PowerStat_Label_NumShots:SetFont("Default")
      GUI_PowerStat_Label_NumShots:SizeToContents()
      GUI_PowerStat_Label_NumShots:SetPos((128 * #data.AmmoTypes + 128) + 28 + (GUI_Weapon_Base:GetWide() - (128 * #data.AmmoTypes + 128) - 56 - GUI_PowerStat_Label:GetWide()/4 ) ,48)
      GUI_PowerStat_Label_NumShots:SetColor(Color(255,255,255,255))
    end

    GUI_AccuracyBar = vgui.Create("DPanel")
    GUI_AccuracyBar:SetParent(GUI_Weapon_Background)
    GUI_AccuracyBar:SetSize(GUI_Weapon_Base:GetWide() - (128 * #data.AmmoTypes + 128) - 56,7)
    GUI_AccuracyBar:SetPos((128 * #data.AmmoTypes + 128) + 28,70)
    GUI_AccuracyBar.Paint = function()
      surface.SetDrawColor(0,0,0,155)
      surface.DrawRect(0,0,GUI_AccuracyBar:GetWide(),7)
      surface.SetDrawColor(30,170,30,255)
      surface.DrawRect(0,1,GUI_AccuracyBar:GetWide()*(intAccuracyLevel/table.Count(GAMEMODE.Weapons[data.Item].UpGrades.Accuracy)),5)
    end

    local GUI_AccuracyBar_Label = vgui.Create("DLabel")
    GUI_AccuracyBar_Label:SetParent(GUI_Weapon_Base)
    GUI_AccuracyBar_Label:SetPos((128 * #data.AmmoTypes + 128) + 28,78)
    GUI_AccuracyBar_Label:SetText("Maximum Accuracy Level: "..#data.UpGrades.Accuracy )
    GUI_AccuracyBar_Label:SetFont("Default")
    GUI_AccuracyBar_Label:SizeToContents()
    GUI_AccuracyBar_Label:SetColor(Color(255,255,255,255))

    local GUI_AccuracyStat_Label = vgui.Create("DLabel")
    GUI_AccuracyStat_Label:SetParent(GUI_Weapon_Base)
    GUI_AccuracyStat_Label:SetText("Accuracy: "..tostring(GAMEMODE.Weapons[data.Item].UpGrades.Accuracy[intAccuracyLevel].Level))
    GUI_AccuracyStat_Label:SetFont("Default")
    GUI_AccuracyStat_Label:SizeToContents()
    GUI_AccuracyStat_Label:SetPos(((128 * #data.AmmoTypes + 128) + 28) + (GUI_Weapon_Base:GetWide() - (128 * #data.AmmoTypes + 128) - 56 - GUI_AccuracyStat_Label:GetWide()),78)
    GUI_AccuracyStat_Label:SetColor(Color(255,255,255,255))

    GUI_ClipSizeBar = vgui.Create("DPanel")
    GUI_ClipSizeBar:SetParent(GUI_Weapon_Background)
    GUI_ClipSizeBar:SetSize(GUI_Weapon_Base:GetWide() - (128 * #data.AmmoTypes + 128) - 56,7)
    GUI_ClipSizeBar:SetPos((128 * #data.AmmoTypes + 128) + 28,90)
    GUI_ClipSizeBar.Paint = function()
      surface.SetDrawColor(0,0,0,155)
      surface.DrawRect(0,0,GUI_ClipSizeBar:GetWide(),7)
      surface.SetDrawColor(30,170,30,255)
      surface.DrawRect(0,1,GUI_ClipSizeBar:GetWide()*(intClipSizeLevel/table.Count(GAMEMODE.Weapons[data.Item].UpGrades.ClipSize)),5)
    end

    local GUI_ClipSizeBar_Label = vgui.Create("DLabel")
    GUI_ClipSizeBar_Label:SetParent(GUI_Weapon_Base)
    GUI_ClipSizeBar_Label:SetPos((128 * #data.AmmoTypes + 128) + 28,98)
    GUI_ClipSizeBar_Label:SetText("Maximum Clip Size Level: "..#data.UpGrades.ClipSize )
    GUI_ClipSizeBar_Label:SetFont("Default")
    GUI_ClipSizeBar_Label:SizeToContents()
    GUI_ClipSizeBar_Label:SetColor(Color(255,255,255,255))

    local GUI_ClipSizeStat_Label = vgui.Create("DLabel")
    GUI_ClipSizeStat_Label:SetParent(GUI_Weapon_Base)
    GUI_ClipSizeStat_Label:SetText("Clip Size: "..tostring(GAMEMODE.Weapons[data.Item].UpGrades.ClipSize[intClipSizeLevel].Level))
    GUI_ClipSizeStat_Label:SetFont("Default")
    GUI_ClipSizeStat_Label:SizeToContents()
    GUI_ClipSizeStat_Label:SetColor(Color(255,255,255,255))
    GUI_ClipSizeStat_Label:SetPos(((128 * #data.AmmoTypes + 128) + 28) + (GUI_Weapon_Base:GetWide() - (128 * #data.AmmoTypes + 128) - 56 - GUI_ClipSizeStat_Label:GetWide()),98)

    GUI_FiringSpeedBar = vgui.Create("DPanel")
    GUI_FiringSpeedBar:SetParent(GUI_Weapon_Background)
    GUI_FiringSpeedBar:SetSize(GUI_Weapon_Base:GetWide() - (128 * #data.AmmoTypes + 128) - 56,7)
    GUI_FiringSpeedBar:SetPos((128 * #data.AmmoTypes + 128) + 28,110)
    GUI_FiringSpeedBar.Paint = function()
                  surface.SetDrawColor(0,0,0,155)
                  surface.DrawRect(0,0,GUI_FiringSpeedBar:GetWide(),7)
                  surface.SetDrawColor(30,170,30,255)
                  surface.DrawRect(0,1,GUI_FiringSpeedBar:GetWide()*(intFiringSpeedLevel/table.Count(GAMEMODE.Weapons[data.Item].UpGrades.FiringSpeed)),5)
                end

    local GUI_FiringSpeedBar_Label = vgui.Create("DLabel")
    GUI_FiringSpeedBar_Label:SetParent(GUI_Weapon_Base)
    GUI_FiringSpeedBar_Label:SetPos((128 * #data.AmmoTypes + 128) + 28,118)
    GUI_FiringSpeedBar_Label:SetText("Maximum Firing Speed Level: "..#data.UpGrades.FiringSpeed )
    GUI_FiringSpeedBar_Label:SetFont("Default")
    GUI_FiringSpeedBar_Label:SizeToContents()
    GUI_FiringSpeedBar_Label:SetColor(Color(255,255,255,255))

    local GUI_FiringSpeedStat_Label = vgui.Create("DLabel")
    GUI_FiringSpeedStat_Label:SetParent(GUI_Weapon_Base)
    GUI_FiringSpeedStat_Label:SetText("Firing Speed: "..tostring(GAMEMODE.Weapons[data.Item].UpGrades.FiringSpeed[intFiringSpeedLevel].Level))
    GUI_FiringSpeedStat_Label:SetFont("Default")
    GUI_FiringSpeedStat_Label:SizeToContents()
    GUI_FiringSpeedStat_Label:SetPos(((128 * #data.AmmoTypes + 128) + 28) + (GUI_Weapon_Base:GetWide() - (128 * #data.AmmoTypes + 128) - 56 - GUI_FiringSpeedStat_Label:GetWide()),118)
    GUI_FiringSpeedStat_Label:SetColor(Color(255,255,255,255))

    GUI_ReloadSpeedBar = vgui.Create("DPanel")
    GUI_ReloadSpeedBar:SetParent(GUI_Weapon_Background)
    GUI_ReloadSpeedBar:SetSize(GUI_Weapon_Base:GetWide() - (128 * #data.AmmoTypes + 128) - 56,7)
    GUI_ReloadSpeedBar:SetPos((128 * #data.AmmoTypes + 128) + 28,130)
    GUI_ReloadSpeedBar.Paint = function()
      surface.SetDrawColor(0,0,0,155)
      surface.DrawRect(0,0,GUI_ReloadSpeedBar:GetWide(),7)
      surface.SetDrawColor(30,170,30,255)
      surface.DrawRect(0,1,GUI_ReloadSpeedBar:GetWide()*(intReloadSpeedLevel/table.Count(GAMEMODE.Weapons[data.Item].UpGrades.ReloadSpeed)),5)
    end

    local GUI_ReloadSpeedBar_Label = vgui.Create("DLabel")
    GUI_ReloadSpeedBar_Label:SetParent(GUI_Weapon_Base)
    GUI_ReloadSpeedBar_Label:SetPos((128 * #data.AmmoTypes + 128) + 28,138)
    GUI_ReloadSpeedBar_Label:SetText("Maximum Reload Speed Level: "..#data.UpGrades.ReloadSpeed )
    GUI_ReloadSpeedBar_Label:SetFont("Default")
    GUI_ReloadSpeedBar_Label:SizeToContents()
    GUI_ReloadSpeedBar_Label:SetColor(Color(255,255,255,255))

    local GUI_ReloadSpeedStat_Label = vgui.Create("DLabel")
    GUI_ReloadSpeedStat_Label:SetParent(GUI_Weapon_Base)
    GUI_ReloadSpeedStat_Label:SetText("Reload Speed: "..tostring(GAMEMODE.Weapons[data.Item].UpGrades.ReloadSpeed[intReloadSpeedLevel].Level))
    GUI_ReloadSpeedStat_Label:SetFont("Default")
    GUI_ReloadSpeedStat_Label:SizeToContents()
    GUI_ReloadSpeedStat_Label:SetPos(((128 * #data.AmmoTypes + 128) + 28) + (GUI_Weapon_Base:GetWide() - (128 * #data.AmmoTypes + 128) - 56 - GUI_ReloadSpeedStat_Label:GetWide()),138)
    GUI_ReloadSpeedStat_Label:SetColor(Color(255,255,255,255))

    GUI_Weapon_Base:SetContents(GUI_Weapon_Background)

    GUI_Weapons_Panel:AddItem(GUI_Weapon_Base)
    int_position_numbery = int_position_numbery + 200
  end
  ent_WorldEntity:Remove()
  end

  function GUI_LoadItems(GUI_Items_Panel)
  local client = LocalPlayer()
  local int_position_numbery = 0
  local int_position_numberx = 128
  local ent_WorldEntity = ents.CreateClientProp("prop_physics")
  ent_WorldEntity:SetAngles(Angle(0,0,0))
  ent_WorldEntity:SetPos(Vector(0,0,0))
  ent_WorldEntity:Spawn()
  ent_WorldEntity:Activate()
  for item,data in pairs(GAMEMODE.Items) do
    if GAMEMODE.Weapons[item] == nil then
      local GUI_Item_Base = vgui.Create("DCollapsibleCategory")
      GUI_Item_Base:SetParent(GUI_Items_Panel)
      GUI_Item_Base:SetPos( 0,int_position_numbery )
      GUI_Item_Base:SetSize( GUI_Items_Panel:GetWide(), 30 ) -- Keep the second number at 50
      GUI_Item_Base:SetExpanded( 0 ) -- Expanded when popped up
      GUI_Item_Base:SetLabel( GAMEMODE.Items[item].Name )---- Cross check to find the name
      GUI_Item_Base.Paint = function()
                  surface.SetDrawColor(60,60,60,255)
                  surface.DrawRect(0,0,GUI_Item_Base:GetWide()-1,22-1)
                  surface.SetDrawColor(0,0,0,255)
                  surface.DrawOutlinedRect(0,0,GUI_Item_Base:GetWide(),22)
                end
        local GUI_Item_Background = vgui.Create("DPanel")
        GUI_Item_Background:SetParent(GUI_Item_Base)
        GUI_Item_Background:SetSize(GUI_Item_Base:GetWide(),170)
        GUI_Item_Background.Paint = function()
                        surface.SetDrawColor(0,0,0,255)
                        surface.DrawOutlinedRect(0,0,GUI_Item_Background:GetWide(),GUI_Item_Background:GetTall())
                        surface.SetDrawColor(100,100,100,255)
                        surface.DrawRect(1,0,GUI_Item_Background:GetWide()-2,GUI_Item_Background:GetTall()-1)
                        surface.SetDrawColor(0,0,0,255)
                        surface.DrawOutlinedRect(0,0,128,128)
                      end
      local GUI_Item_BuyItem_Button = vgui.Create("DButton")
      GUI_Item_BuyItem_Button:SetParent(GUI_Item_Base)
      GUI_Item_BuyItem_Button:SetSize(100,20)
      GUI_Item_BuyItem_Button:SetPos(14,160)
      GUI_Item_BuyItem_Button:SetText("Buy for $"..GAMEMODE.Items[item].Price)
      GUI_Item_BuyItem_Button.DoClick = function(GUI_Item_BuyItem_Button)
                        if client:GetNWInt("Money") >= tonumber(GAMEMODE.Items[item].Price) then
                          RunConsoleCommand("inv_BuyItem",item)
                          local s = CreateSound(client, table.Random(GAMEMODE.MerchantSounds.MerchantBuy))
                          s:Play()
                          s:ChangeVolume(0.2)
                        else
                          local s = CreateSound(client, "reg/merchant/notenoughcash.wav")
                          s:Play()
                          s:ChangeVolume(0.2)
                        end
                      end


      ent_WorldEntity:SetModel(GAMEMODE.Items[item].Model)

      local GUI_Item_Icon = vgui.Create("DModelPanel")
      GUI_Item_Icon:SetParent(GUI_Item_Base)
      GUI_Item_Icon:SetSize(128,128)
      GUI_Item_Icon:SetPos(0,30)
      GUI_Item_Icon:SetModel(GAMEMODE.Items[item].Model)

      if GAMEMODE.Items[item].Material != nil then
        ent_WorldEntity:SetMaterial(GAMEMODE.Items[item].Material)
        GUI_Item_Icon:GetEntity():SetMaterial(GAMEMODE.Items[item].Material)
      end

      local center = ent_WorldEntity:OBBCenter()
      local dist = ent_WorldEntity:BoundingRadius()*1.7

      GUI_Item_Icon:SetLookAt(center)
      GUI_Item_Icon:SetCamPos(center+Vector(dist,dist,0))

      local GUI_Desc_Label = vgui.Create("DLabel")
      GUI_Desc_Label:SetParent(GUI_Item_Base)
      GUI_Desc_Label:SetPos(132,132)
      GUI_Desc_Label:SetText(GAMEMODE.Items[item].Desc)
      GUI_Desc_Label:SetFont("Default")
      GUI_Desc_Label:SizeToContents()
      GUI_Desc_Label:SetColor(Color(255,255,255,255))

      int_position_numberx = 128

      GUI_Item_Base:SetContents(GUI_Item_Background)

      GUI_Items_Panel:AddItem(GUI_Item_Base)

      int_position_numbery = int_position_numbery + 200
    end
  end
  ent_WorldEntity:Remove()
  end
