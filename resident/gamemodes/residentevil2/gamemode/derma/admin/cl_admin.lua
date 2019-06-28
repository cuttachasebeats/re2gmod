function openAdmin()
  ply = LocalPlayer()
  if isAdmin == true then
    adminBase = re2_create_Frame(MainPanel, 0, .05, 1, .95)
    adminBase.Paint = function() draw.RoundedBox( 0, 0, 0, MainPanel:GetWide(), MainPanel:GetTall(), Color(60,60,60,255)) end

    local adminBackground = re2_create_Frame(adminBase, .01, .02, .98, .965)
    adminBackground.Paint = function()
                    surface.SetDrawColor(0,0,0,200)
                    surface.DrawOutlinedRect(0,0,adminBackground:GetWide(),adminBackground:GetTall())
                    surface.SetDrawColor(60,40,30,155)
                    surface.DrawRect(0,0,adminBackground:GetWide(),adminBackground:GetTall())
                  end


local PauseTimer = re2_create_Button(adminBackground, .01, .02, .15, .075,Color(255,255,255), "font large", "Pause Timer")
      PauseTimer:SizeToContents()
      PauseTimer.Paint = function() draw.RoundedBox( 0, 0, 0, PauseTimer:GetWide(), PauseTimer:GetTall(), Color(60,60,60,255)) end
      PauseTimer.DoClick = function()
                 net.Start("PauseTimer")
                 net.SendToServer()
               end

local UnPauseTimer = re2_create_Button(adminBackground, .01, .1, .15, .075,Color(255,255,255), "font large", "UnPause Timer")
      UnPauseTimer:SizeToContents()
      UnPauseTimer.Paint = function() draw.RoundedBox( 0, 0, 0, UnPauseTimer:GetWide(), UnPauseTimer:GetTall(), Color(60,60,60,255)) end
      UnPauseTimer.DoClick = function()
                   net.Start("UnPauseTimer")
                   net.SendToServer()
                 end

local SetMoneyBtn = re2_create_Button(adminBackground, .01, .18, .15, .075,Color(255,255,255), "font large", "Set Money")
      SetMoneyBtn:SizeToContents()
      SetMoneyBtn.Paint = function() draw.RoundedBox( 0, 0, 0, SetMoneyBtn:GetWide(), SetMoneyBtn:GetTall(), Color(60,60,60,255)) end
            SetMoneyBtn.DoClick = function()
              local DComboBox = vgui.Create( "DComboBox", adminBackground )
                    DComboBox:SetPos( adminBackground:GetWide()*.01, adminBackground:GetTall()*.18 )
                    DComboBox:SetSize( adminBackground:GetWide()*.15, adminBackground:GetTall()*.05 )
                    DComboBox:SetValue( "Select Player" )
                    playerstable = player:GetAll()
                    for k, v in pairs( playerstable ) do
	                   DComboBox:AddChoice( v:Name().." : "..v:GetNWInt("Money") )

                    DComboBox.OnSelect = function( self, index, value )
                      SIDSelected = playerstable[DComboBox:GetSelectedID()]:SteamID()
                      plymoneySelected = playerstable[DComboBox:GetSelectedID()]:GetNWInt("Money")
                      plynameSelected = playerstable[DComboBox:GetSelectedID()]:Name()
                      local TextEntry = vgui.Create( "DTextEntry", adminBackground )
                            TextEntry:SetPos( adminBackground:GetWide()*.01, adminBackground:GetTall()*.18 )
                            TextEntry:SetSize( adminBackground:GetWide()*.15, adminBackground:GetTall()*.05 )
                            TextEntry:SetNumeric( true )
                            TextEntry:SetText( plymoneySelected )
                            TextEntry.OnEnter = function( self )
                              money = self:GetValue()
                              chat.AddText("Set "..plynameSelected.." money to "..money)
                              net.Start("SetMoney")
                              net.WriteString(SIDSelected)
                              net.WriteString(money)
                              net.SendToServer()
                              DComboBox:Remove()
                              TextEntry:Remove()
                            end
                          end
					              end
                      end

local createWeapon = re2_create_Button(adminBackground, .01, .26, .15, .075,Color(255,255,255), "font large", "Create Weapon")
      createWeapon:SizeToContents()
      createWeapon.Paint = function() draw.RoundedBox( 0, 0, 0, createWeapon:GetWide(), createWeapon:GetTall(), Color(60,60,60,255)) end
      createWeapon.DoClick = function()
        local DComboBoxWeapons = vgui.Create( "DComboBox", adminBackground )
              DComboBoxWeapons:SetPos( adminBackground:GetWide()*.01, adminBackground:GetTall()*.26 )
              DComboBoxWeapons:SetSize( adminBackground:GetWide()*.17, adminBackground:GetTall()*.05 )
              DComboBoxWeapons:SetValue( "Weapons" )
              weapontable = GAMEMODE.Weapons
              --PrintTable(weapontable)
              for weapon,data in pairs(weapontable) do
	               DComboBoxWeapons:AddChoice( data["Item"] )
               end

              DComboBoxWeapons.OnSelect = function( self, index, value )
                wname = DComboBoxWeapons:GetSelected()
                print(wname)
                playerPos = LocalPlayer():GetPos()
                chat.AddText("Weapon spawned.")
	               net.Start("CreateWeapon")
                 net.WriteString(wname)
                 net.WriteVector(playerPos)
                 net.SendToServer()
                 DComboBoxWeapons:Remove()
               end
      end

local createItem = re2_create_Button(adminBackground, .01, .34, .15, .075,Color(255,255,255), "font large", "Create Item")
      createItem:SizeToContents()
      createItem.Paint = function() draw.RoundedBox( 0, 0, 0, createItem:GetWide(), createItem:GetTall(), Color(60,60,60,255)) end
      createItem.DoClick = function()
        local DComboBoxItems = vgui.Create( "DComboBox", adminBackground )
              DComboBoxItems:SetPos( adminBackground:GetWide()*.01, adminBackground:GetTall()*.34 )
              DComboBoxItems:SetSize( adminBackground:GetWide()*.17, adminBackground:GetTall()*.05 )
              DComboBoxItems:SetValue( "Items" )
              itemtable = GAMEMODE.Items
              --PrintTable(itemtable)
              for item,data in pairs(GAMEMODE.Items) do
                if GAMEMODE.Weapons[item] == nil then
      	            DComboBoxItems:AddChoice(item)
                  end
                end

              DComboBoxItems.OnSelect = function( self, index, value )
                iname = DComboBoxItems:GetSelected()
                playerPos = LocalPlayer():GetPos() + Vector(0,0,8)
                itemCount = math.Round(ItemSlider:GetValue())
                chat.AddText("Created "..itemCount.." "..iname)
      	          net.Start("CreateItem")
                  net.WriteString(iname)
                  net.WriteVector(playerPos)
                  net.WriteString(itemCount)
                  net.SendToServer()
                  DComboBoxItems:Remove()
                  ItemSlider:Remove()
                end

      ItemSlider = vgui.Create( "DNumSlider", adminBackground )
      ItemSlider:SetPos( adminBackground:GetWide()*.01, adminBackground:GetTall()*.30 )
      ItemSlider:SetSize( adminBackground:GetWide()*.2, adminBackground:GetTall()*.05 )
      ItemSlider:SetText( "Item Count" )
      ItemSlider:SetValue(1)
      ItemSlider:SetMin( 1 )
      ItemSlider:SetMax( 15 )
      ItemSlider:SetDecimals( 0 )
      end

local setDifficulty = re2_create_Button(adminBackground, .01, .42, .15, .075,Color(255,255,255), "font large", "Set Difficulty")
      setDifficulty:SizeToContents()
      setDifficulty.Paint = function() draw.RoundedBox( 0, 0, 0, setDifficulty:GetWide(), setDifficulty:GetTall(), Color(60,60,60,255)) end
      setDifficulty.DoClick = function()
        local DifficultyComboBox = vgui.Create( "DComboBox", adminBackground )
              DifficultyComboBox:SetPos( adminBackground:GetWide()*.01, adminBackground:GetTall()*.42 )
              DifficultyComboBox:SetSize( adminBackground:GetWide()*.17, adminBackground:GetTall()*.05 )
              DifficultyComboBox:SetValue( "Difficulty" )
              local easy = DifficultyComboBox:AddChoice( "Easy" ) -- Add our options
        			local norm = DifficultyComboBox:AddChoice( "Normal" )
        			local diff = DifficultyComboBox:AddChoice( "Difficult" )
        			local exp = DifficultyComboBox:AddChoice( "Expert" )
        			local suc = DifficultyComboBox:AddChoice( "Suicidal" )
        			local dth = DifficultyComboBox:AddChoice( "Death" )
        			local rcc = DifficultyComboBox:AddChoice( "RacoonCity" )

              DifficultyComboBox.OnSelect = function( self, index, value )
                if DifficultyComboBox:GetSelected() == "Easy" then
                  VoteOption["Difficulty"] = "Easy"
                elseif DifficultyComboBox:GetSelected() == "Normal" then
                    VoteOption["Difficulty"] = "Normal"
                elseif DifficultyComboBox:GetSelected() == "Difficult" then
                    VoteOption["Difficulty"] = "Difficult"
                elseif DifficultyComboBox:GetSelected() == "Expert" then
                    VoteOption["Difficulty"] = "Expert"
                elseif DifficultyComboBox:GetSelected() == "Suicidal" then
                    VoteOption["Difficulty"] = "Suicidal"
                elseif DifficultyComboBox:GetSelected() == "Death" then
                    VoteOption["Difficulty"] = "Death"
                elseif DifficultyComboBox:GetSelected() == "RacoonCity" then
                    VoteOption["Difficulty"] = "RacoonCity"
                end
                net.Start("SetDifficulty")
                net.WriteString(VoteOption["Difficulty"])
                net.SendToServer()
                DifficultyComboBox:Remove()
               end
      end
      // This statment happens if the round is active, mode = on
      // setDifficulty must be disabled, if you change difficulty mid game, it will split this dimention into 3 parallel holes.
      if isInRound == true then
        PauseTimer:SetDisabled(true)
        PauseTimer:SetTextColor(Color(80,80,80))
        PauseTimer.Paint = function() draw.RoundedBox( 0, 0, 0, PauseTimer:GetWide(), PauseTimer:GetTall(), Color(0,0,0,255)) end

        UnPauseTimer:SetDisabled(true)
        UnPauseTimer:SetTextColor(Color(80,80,80))
        UnPauseTimer.Paint = function() draw.RoundedBox( 0, 0, 0, UnPauseTimer:GetWide(), UnPauseTimer:GetTall(), Color(0,0,0,255)) end

        setDifficulty:SetDisabled(true)
        setDifficulty:SetTextColor(Color(80,80,80))
        setDifficulty.Paint = function() draw.RoundedBox( 0, 0, 0, setDifficulty:GetWide(), setDifficulty:GetTall(), Color(0,0,0,255)) end
      end

local healAndcure = re2_create_Button(adminBackground, .01, .50, .15, .075,Color(255,255,255), "font large", "Heal & Cure Player")
      healAndcure:SizeToContents()
      healAndcure.Paint = function() draw.RoundedBox( 0, 0, 0, healAndcure:GetWide(), healAndcure:GetTall(), Color(60,60,60,255)) end
      healAndcure.DoClick = function()

        local comboBoxHeal = vgui.Create( "DComboBox", adminBackground )
              comboBoxHeal:SetPos( adminBackground:GetWide()*.01, adminBackground:GetTall()*.50 )
              comboBoxHeal:SetSize( adminBackground:GetWide()*.2, adminBackground:GetTall()*.05 )
              comboBoxHeal:SetValue( "Players" )
              playerstable2 = player.GetAll()
              for k, v in pairs( playerstable2 ) do
                comboBoxHeal:AddChoice( v:Name() )
              end

              comboBoxHeal.OnSelect = function( _, _, value )
                SIDSelected2 = playerstable2[comboBoxHeal:GetSelectedID()]:SteamID()
                plynameSelected2 = playerstable2[comboBoxHeal:GetSelectedID()]:Name()
                ply:ChatPrint("You have healed: "..plynameSelected2)
                net.Start("fixPlayer")
                net.WriteString(SIDSelected2)
                net.SendToServer()
                comboBoxHeal:Remove()
              end
               end

else return end
end
