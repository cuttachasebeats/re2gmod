VoteOption = {}

local RandomMapNames = {}
	for k,v in pairs(GM.MapListTable) do
		table.insert(RandomMapNames,k)
	end
local randommapchoice = table.Random(RandomMapNames)

if GM.MapListTable[randommapchoice].Escape != nil then randommapchoice = "re2_arena" end

if GM.MapListTable[randommapchoice].Boss != nil then randommapchoice = "re2_arena" end

if GM.MapListTable[randommapchoice].PVP != nil then randommapchoice = "re2_arena" end

VoteOption["Map"] = randommapchoice

VoteOption["Game"] = "Survivor"

VoteOption["Difficulty"] = "Normal"

function openVote()
      VoteBase = re2_create_Frame(MainPanel, 0, .05, 1, .95)
      VoteBase.Paint = function() draw.RoundedBox( 0, 0, 0, MainPanel:GetWide(), MainPanel:GetTall(), Color(60,60,60,255)) end
			local VoteBackground = re2_create_Frame(VoteBase, .01, .02, .98, .965)
			VoteBackground.Paint = function()
											surface.SetDrawColor(0,0,0,200)
											surface.DrawOutlinedRect(0,0,VoteBackground:GetWide(),VoteBackground:GetTall())
											surface.SetDrawColor(60,40,30,155)
											surface.DrawRect(0,0,VoteBackground:GetWide(),VoteBackground:GetTall())
										end

      local Iconent = ents.CreateClientProp("prop_physics")
    	Iconent:SetPos(Vector(0,0,0))
    	Iconent:Spawn()
    	Iconent:Activate()

    			local GUI_Map_List_Menu = vgui.Create("DListView")
    			GUI_Map_List_Menu:SetParent(VoteBackground)
    			GUI_Map_List_Menu:SetSize(VoteBackground:GetWide()*.2,VoteBackground:GetTall()*.96)
    			GUI_Map_List_Menu:SetPos(VoteBackground:GetWide()*.01,VoteBackground:GetTall()*.02)
    			GUI_Map_List_Menu:SetMultiSelect(false)
    			GUI_Map_List_Menu:AddColumn(translate.Get("select_map"))

    			for k,v in pairs(GAMEMODE.MapListTable) do
    				if v.Escape == nil then
    					GUI_Map_List_Menu:AddLine(k)
    				end
    			end

    			GUI_Map_List_Menu:SelectFirstItem()

    			GUI_Map_List_Menu.OnRowSelected = function(GUI_Map_List_Menu)

    				VoteOption["Map"] = GUI_Map_List_Menu:GetSelected()[1]:GetValue(1)
    				--GUI_Map_List_Menu_Icon:SetImage("maps/"..VoteOption["Map"], "vgui/avatar_default")

    			end

    			local GUI_Difficulty_Label = vgui.Create("DLabel")
          GUI_Difficulty_Label:SetFont("font large")
    			GUI_Difficulty_Label:SetText(translate.Get("difficulty_vote"))
    			GUI_Difficulty_Label:SizeToContents()
    			GUI_Difficulty_Label:SetPos(VoteBackground:GetWide()*.725,VoteBackground:GetTall()*.01)
    			GUI_Difficulty_Label:SetParent(VoteBackground)


    			local GUI_Difficulty = vgui.Create( "DListView" )
    			GUI_Difficulty:AddColumn(translate.Get("difficulty_vote"))
    			GUI_Difficulty:SetParent(VoteBackground)
    			GUI_Difficulty:SetMultiSelect( false )

    			local easy = GUI_Difficulty:AddLine( translate.Get("easy") ) -- Add our options
    			local norm = GUI_Difficulty:AddLine( translate.Get("normal") )
    			local diff = GUI_Difficulty:AddLine( translate.Get("difficult") )
    			local exp = GUI_Difficulty:AddLine( translate.Get("expert") )
    			local suc = GUI_Difficulty:AddLine( translate.Get("suicidal") )
    			local dth = GUI_Difficulty:AddLine( translate.Get("death") )
    			local rcc = GUI_Difficulty:AddLine( translate.Get("racooncity") )

    			GUI_Difficulty:SetSize(VoteBackground:GetWide()*.15,VoteBackground:GetTall()*.25)
    			GUI_Difficulty:SetPos(VoteBackground:GetWide()*.7,VoteBackground:GetTall()*.05)
    			GUI_Difficulty:SelectItem(norm)

    			function GUI_Difficulty:Think()
    				if GUI_Difficulty:GetSelectedLine() == 1 then
    					VoteOption["Difficulty"] = "Easy"
    				elseif GUI_Difficulty:GetSelectedLine() == 2 then
    						VoteOption["Difficulty"] = "Normal"
    				elseif GUI_Difficulty:GetSelectedLine() == 3 then
    						VoteOption["Difficulty"] = "Difficult"
    				elseif GUI_Difficulty:GetSelectedLine() == 4 then
    						VoteOption["Difficulty"] = "Expert"
    				elseif GUI_Difficulty:GetSelectedLine() == 5 then
    						VoteOption["Difficulty"] = "Suicidal"
    				elseif GUI_Difficulty:GetSelectedLine() == 6 then
    						VoteOption["Difficulty"] = "Death"
    				elseif GUI_Difficulty:GetSelectedLine() == 7 then
    						VoteOption["Difficulty"] = "RacoonCity"
    				end
    			end

    			local GUI_Gamemode_Label = vgui.Create("DLabel")
          GUI_Gamemode_Label:SetFont("font large")
    			GUI_Gamemode_Label:SetText(translate.Get("gamemode"))
    			GUI_Gamemode_Label:SizeToContents()
    			GUI_Gamemode_Label:SetPos(VoteBackground:GetWide()*.4,VoteBackground:GetTall()*.01)
    			GUI_Gamemode_Label:SetParent(VoteBackground)

    			local GUI_Gamemode_Selection = vgui.Create("DComboBox")
    			GUI_Gamemode_Selection:SetParent(VoteBackground)
    			GUI_Gamemode_Selection:SetPos(VoteBackground:GetWide()*.35,VoteBackground:GetTall()*.05)
    			GUI_Gamemode_Selection:SetSize( VoteBackground:GetWide()*.2,VoteBackground:GetTall()*.04 )
    				for h,j in pairs(GAMEMODE.Gamemode) do
    					if j.Name != nil then
    						GUI_Gamemode_Selection:AddChoice(tostring(j.Name))
    					else
    						GUI_Gamemode_Selection:AddChoice(tostring(h))
    					end
    				end
    			GUI_Gamemode_Selection:ChooseOption( "Survivor" )


    ------------------Choosing Escape Shows Another Map Selection---------------------
    			function GUI_Gamemode_Selection:OnSelect(index,value,data)
    				if value == "Escape" then
    					local bool = false
    					for k,v in pairs(GAMEMODE.MapListTable) do
    						if v.Escape != nil then
    							if (!bool) then
    								GUI_Map_List_Menu:Clear()
    							end
    							GUI_Map_List_Menu:AddLine(k)
    							bool = true
    						end
    					end
    					if (bool) then
    						GUI_Map_List_Menu:SelectFirstItem()
    						VoteOption["Game"] = value
    						VoteOption["Map"] = GUI_Map_List_Menu:GetSelected()[1]:GetValue(1)
    					else
    						GUI_Gamemode_Selection:ChooseOption( "Survivor" )
    						LocalPlayer():ChatPrint("No maps available for ".. value)
    					end

    				elseif value != "Escape" && VoteOption["Game"] == "Escape" then

    					local bool = false
    					for k,v in pairs(GAMEMODE.MapListTable) do
    						if v.Escape == nil then
    							if (!bool) then
    								GUI_Map_List_Menu:Clear()
    							end
    							GUI_Map_List_Menu:AddLine(k)
    							bool = true
    						end
    					end
    					if bool then
    						VoteOption["Game"] = value

    						GUI_Map_List_Menu:SelectFirstItem()

    						VoteOption["Map"] = GUI_Map_List_Menu:GetSelected()[1]:GetValue(1)
    					else
    						LocalPlayer():ChatPrint("No maps available for ".. value)
    					end
    				else
    					VoteOption["Game"] = value
    				end
    			end


    		local GUI_Vote_Confirmation_Panel = vgui.Create("DPanelList")
    		GUI_Vote_Confirmation_Panel:SetSize(280  ,170)
    		GUI_Vote_Confirmation_Panel:SetPos(VoteBase:GetWide()*.35,VoteBase:GetTall()*.4)
    		GUI_Vote_Confirmation_Panel:SetParent(VoteBase)

    			local GUI_Difficulty_Vote_Label = vgui.Create("DLabel")

    			function GUI_Difficulty_Vote_Label:Think()
    				GUI_Difficulty_Vote_Label:SetText(translate.Get("you_selected").." "..VoteOption["Difficulty"].." "..translate.Get("for_next_dificulty"))
    			end

    			GUI_Difficulty_Vote_Label:SetSize( 260,20 )
    			GUI_Difficulty_Vote_Label:SetPos(20,10)
    			GUI_Difficulty_Vote_Label:SetParent(GUI_Vote_Confirmation_Panel)

    			local GUI_Map_Vote_Label = vgui.Create("DLabel")

    			function GUI_Map_Vote_Label:Think()
    				GUI_Map_Vote_Label:SetText(translate.Get("you_selected").." "..VoteOption["Map"].." "..translate.Get("for_next_map"))
    			end

    			GUI_Map_Vote_Label:SetSize( 260,20 )
    			GUI_Map_Vote_Label:SetPos(20,35)
    			GUI_Map_Vote_Label:SetParent(GUI_Vote_Confirmation_Panel)

    			local GUI_Gamemode_Vote_Label = vgui.Create("DLabel")

    			function GUI_Gamemode_Vote_Label:Think()
    				GUI_Gamemode_Vote_Label:SetText(translate.Get("you_selected").." "..VoteOption["Game"].." "..translate.Get("for_next_gamemode"))
    			end

    			GUI_Gamemode_Vote_Label:SetSize( 240,20 )
    			GUI_Gamemode_Vote_Label:SetPos(20,60)
    			GUI_Gamemode_Vote_Label:SetParent(GUI_Vote_Confirmation_Panel)

    			local GUI_Crows_Vote_Label = vgui.Create("DLabel")

    			function GUI_Crows_Vote_Label:Think()
    				if VoteOption["Crows"] then
    					GUI_Crows_Vote_Label:SetText(translate.Get("you_want_crows"))
    				else
    					GUI_Crows_Vote_Label:SetText(translate.Get("you_wont_crows"))
    				end
    			end

    			GUI_Crows_Vote_Label:SetSize( 260,20 )
    			GUI_Crows_Vote_Label:SetPos(20,85)
    			GUI_Crows_Vote_Label:SetParent(GUI_Vote_Confirmation_Panel)

    			local GUI_Classic_Vote_Label = vgui.Create("DLabel")

    			function GUI_Classic_Vote_Label:Think()
    				if VoteOption["Classic"] then
    					GUI_Classic_Vote_Label:SetText(translate.Get("you_want_classic"))
    				else
    					GUI_Classic_Vote_Label:SetText(translate.Get("you_wont_classic"))
    				end
    			end

    			GUI_Classic_Vote_Label:SetSize( 260,20 )
    			GUI_Classic_Vote_Label:SetPos(20,110)
    			GUI_Classic_Vote_Label:SetParent(GUI_Vote_Confirmation_Panel)

    			local GUI_Submit_Vote = vgui.Create("DButton")
    			GUI_Submit_Vote:SetParent( GUI_Vote_Confirmation_Panel )
    			GUI_Submit_Vote:SetText( translate.Get("submit_vote") )

    			local x,y = GUI_Vote_Confirmation_Panel:GetSize()

    			GUI_Submit_Vote:SetPos(20, 140)
    			GUI_Submit_Vote:SetSize( x - 40,20 )
    			GUI_Submit_Vote.DoClick = function ( btn )
    				if GUI_Difficulty:GetSelectedLine() == easy then
    					VoteOption["Difficulty"] = translate.Get("easy")
    				elseif GUI_Difficulty:GetSelectedLine() == norm then
    						VoteOption["Difficulty"] = translate.Get("normal")
    				elseif GUI_Difficulty:GetSelectedLine() == diff then
    						VoteOption["Difficulty"] = translate.Get("difficult")
    				elseif GUI_Difficulty:GetSelectedLine() == exp then
    						VoteOption["Difficulty"] = translate.Get("expert")
    				elseif GUI_Difficulty:GetSelectedLine() == suc then
    						VoteOption["Difficulty"] = translate.Get("suicidal")
    				elseif GUI_Difficulty:GetSelectedLine() == dth then
    						VoteOption["Difficulty"] = translate.Get("death")
    				elseif GUI_Difficulty:GetSelectedLine() == rcc then
    						VoteOption["Difficulty"] = translate.Get("racooncity")
    				end
    				GUI_Submit_Vote:SetText(translate.Get("change_vote"))
    				net.Start("VoteTransfer")
    				net.WriteString(VoteOption["Map"])
    				net.WriteString(VoteOption["Game"])
    				net.WriteString(VoteOption["Difficulty"])
    				net.SendToServer()
    			end
    end
    concommand.Add("Re2_VoteMenu_vote",function(ply,cmd,args) ResidentEvil2_Menu(true) end)
