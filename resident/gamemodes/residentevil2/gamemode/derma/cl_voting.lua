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

function GUI_VoteMenu(voting)

	--if GetGlobalEntity("Mode") != "End" then return end
	local Iconent = ents.CreateClientProp("prop_physics")
	Iconent:SetPos(Vector(0,0,0))
	Iconent:Spawn()
	Iconent:Activate()

	local GUI_EndGameFrame = vgui.Create("DFrame")
	GUI_EndGameFrame:SetSize(630,700)
	GUI_EndGameFrame:Center()
	GUI_EndGameFrame:SetTitle("Results")
	GUI_EndGameFrame:MakePopup()
	--GUI_EndGameFrame.Paint = function()
		--surface.DrawRect(0,0,GUI_EndGameFrame:GetWide(),GUI_EndGameFrame:GetTall())
		--surface.SetDrawColor(40,40,40,255)
	--end

	local GUI_Property_Sheet = vgui.Create("DPropertySheet")
	GUI_Property_Sheet:SetParent(GUI_EndGameFrame)
	GUI_Property_Sheet:SetPos(5,25)
	GUI_Property_Sheet:SetSize(620,650)

	GUI_Property_Sheet.Paint = function()
									surface.SetDrawColor(150,150,150,255)
									surface.DrawRect(0,22,GUI_Property_Sheet:GetWide(),GUI_Property_Sheet:GetTall() - 2 )
								end

	local GUI_Scoreboard_Background_Panel = vgui.Create("DPanelList")
	GUI_Scoreboard_Background_Panel:SetSize(600,600)
	GUI_Scoreboard_Background_Panel:SetPos(10,60)
	GUI_Scoreboard_Background_Panel:SetParent(GUI_Property_Sheet)
	GUI_Scoreboard_Background_Panel.Paint = function()
											end
	GUI_Scoreboard_Background_Panel:SetSpacing( 5 ) -- Spacing between items
	GUI_Scoreboard_Background_Panel:EnableVerticalScrollbar( true )

	local GUI_Vote_Background_Panel = vgui.Create("DPanelList")
	GUI_Vote_Background_Panel:SetSize(600,600)
	GUI_Vote_Background_Panel:SetPos(10,60)
	GUI_Vote_Background_Panel:SetParent(GUI_Property_Sheet)
	GUI_Vote_Background_Panel.Paint = function()
										end

		local GUI_Vote_Maps_Panel = vgui.Create("DPanelList")
		GUI_Vote_Maps_Panel:SetSize(280,540)
		GUI_Vote_Maps_Panel:SetPos(10,40)
		GUI_Vote_Maps_Panel:SetParent(GUI_Vote_Background_Panel)

		GUI_Map_List_Menu_Icon = vgui.Create("DImage", GUI_Vote_Maps_Panel)
		GUI_Map_List_Menu_Icon:SetSize(128,128)
		GUI_Map_List_Menu_Icon:SetPos(GUI_Vote_Maps_Panel:GetWide()/4, 10)

			local GUI_Map_List_Menu = vgui.Create("DListView")
			GUI_Map_List_Menu:SetParent(GUI_Vote_Maps_Panel)
			GUI_Map_List_Menu:SetSize(280,330)
			GUI_Map_List_Menu:SetPos(0,150)
			GUI_Map_List_Menu:SetMultiSelect(false)
			GUI_Map_List_Menu:AddColumn("Select A Map")

			for k,v in pairs(GAMEMODE.MapListTable) do
				if v.Escape == nil then
					GUI_Map_List_Menu:AddLine(k)
				end
			end

			GUI_Map_List_Menu:SelectFirstItem()

			GUI_Map_List_Menu.OnRowSelected = function(GUI_Map_List_Menu)

				VoteOption["Map"] = GUI_Map_List_Menu:GetSelected()[1]:GetValue(1)
				GUI_Map_List_Menu_Icon:SetImage("maps/"..VoteOption["Map"], "vgui/avatar_default")

			end


		local GUI_Vote_Settings_Panel = vgui.Create("DPanelList")
		GUI_Vote_Settings_Panel:SetSize(280  ,350)
		GUI_Vote_Settings_Panel:SetPos(310,40)
		GUI_Vote_Settings_Panel:SetParent(GUI_Vote_Background_Panel)

			local GUI_Difficulty_Label = vgui.Create("DLabel")
			GUI_Difficulty_Label:SetText("Difficulty")
			GUI_Difficulty_Label:SizeToContents()
			GUI_Difficulty_Label:SetPos(10,120)
			GUI_Difficulty_Label:SetParent(GUI_Vote_Settings_Panel)


			local GUI_Difficulty = vgui.Create( "DListView" )
			GUI_Difficulty:AddColumn("Difficulty")
			GUI_Difficulty:SetParent(GUI_Vote_Settings_Panel)
			GUI_Difficulty:SetMultiSelect( false )

			local easy = GUI_Difficulty:AddLine( "Easy" ) -- Add our options
			local norm = GUI_Difficulty:AddLine( "Normal" )
			local diff = GUI_Difficulty:AddLine( "Difficult" )
			local exp = GUI_Difficulty:AddLine( "Expert" )
			local suc = GUI_Difficulty:AddLine( "Suicidal" )
			local dth = GUI_Difficulty:AddLine( "Death" )
			local rcc = GUI_Difficulty:AddLine( "RacoonCity" )

			GUI_Difficulty:SetSize(100,120)
			GUI_Difficulty:SetPos(10,140)
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
			GUI_Gamemode_Label:SetText("Gamemode")
			GUI_Gamemode_Label:SizeToContents()
			GUI_Gamemode_Label:SetPos(10,10)
			GUI_Gamemode_Label:SetParent(GUI_Vote_Settings_Panel)

			local GUI_Gamemode_Selection = vgui.Create("DComboBox")
			GUI_Gamemode_Selection:SetParent(GUI_Vote_Settings_Panel)
			GUI_Gamemode_Selection:SetPos(10,25)
			GUI_Gamemode_Selection:SetSize( 220, 20 )
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
		GUI_Vote_Confirmation_Panel:SetPos(310,410)
		GUI_Vote_Confirmation_Panel:SetParent(GUI_Vote_Background_Panel)

			local GUI_Difficulty_Vote_Label = vgui.Create("DLabel")

			function GUI_Difficulty_Vote_Label:Think()
				GUI_Difficulty_Vote_Label:SetText("You selected "..VoteOption["Difficulty"].." for the next difficulty.")
			end

			GUI_Difficulty_Vote_Label:SetSize( 260,20 )
			GUI_Difficulty_Vote_Label:SetPos(20,10)
			GUI_Difficulty_Vote_Label:SetParent(GUI_Vote_Confirmation_Panel)

			local GUI_Map_Vote_Label = vgui.Create("DLabel")

			function GUI_Map_Vote_Label:Think()
				GUI_Map_Vote_Label:SetText("You selected "..VoteOption["Map"].." for the next map.")
			end

			GUI_Map_Vote_Label:SetSize( 260,20 )
			GUI_Map_Vote_Label:SetPos(20,35)
			GUI_Map_Vote_Label:SetParent(GUI_Vote_Confirmation_Panel)

			local GUI_Gamemode_Vote_Label = vgui.Create("DLabel")

			function GUI_Gamemode_Vote_Label:Think()
				GUI_Gamemode_Vote_Label:SetText("You selected "..VoteOption["Game"].." for the next gamemode.")
			end

			GUI_Gamemode_Vote_Label:SetSize( 240,20 )
			GUI_Gamemode_Vote_Label:SetPos(20,60)
			GUI_Gamemode_Vote_Label:SetParent(GUI_Vote_Confirmation_Panel)

			local GUI_Crows_Vote_Label = vgui.Create("DLabel")

			function GUI_Crows_Vote_Label:Think()
				if VoteOption["Crows"] then
					GUI_Crows_Vote_Label:SetText("You want spectators to become crows.")
				else
					GUI_Crows_Vote_Label:SetText("You don't want spectators to become crows.")
				end
			end

			GUI_Crows_Vote_Label:SetSize( 260,20 )
			GUI_Crows_Vote_Label:SetPos(20,85)
			GUI_Crows_Vote_Label:SetParent(GUI_Vote_Confirmation_Panel)

			local GUI_Classic_Vote_Label = vgui.Create("DLabel")

			function GUI_Classic_Vote_Label:Think()
				if VoteOption["Classic"] then
					GUI_Classic_Vote_Label:SetText("You want to play Classic mode.")
				else
					GUI_Classic_Vote_Label:SetText("You don't to play Classic mode.")
				end
			end

			GUI_Classic_Vote_Label:SetSize( 260,20 )
			GUI_Classic_Vote_Label:SetPos(20,110)
			GUI_Classic_Vote_Label:SetParent(GUI_Vote_Confirmation_Panel)

			local GUI_Submit_Vote = vgui.Create("DButton")
			GUI_Submit_Vote:SetParent( GUI_Vote_Confirmation_Panel )
			GUI_Submit_Vote:SetText( "Submit Your Vote" )

			local x,y = GUI_Vote_Confirmation_Panel:GetSize()

			GUI_Submit_Vote:SetPos(20, 140)
			GUI_Submit_Vote:SetSize( x - 40,20 )
			GUI_Submit_Vote.DoClick = function ( btn )
				if GUI_Difficulty:GetSelectedLine() == easy then
					VoteOption["Difficulty"] = "Easy"
				elseif GUI_Difficulty:GetSelectedLine() == norm then
						VoteOption["Difficulty"] = "Normal"
				elseif GUI_Difficulty:GetSelectedLine() == diff then
						VoteOption["Difficulty"] = "Difficult"
				elseif GUI_Difficulty:GetSelectedLine() == exp then
						VoteOption["Difficulty"] = "Expert"
				elseif GUI_Difficulty:GetSelectedLine() == suc then
						VoteOption["Difficulty"] = "Suicidal"
				elseif GUI_Difficulty:GetSelectedLine() == dth then
						VoteOption["Difficulty"] = "Death"
				elseif GUI_Difficulty:GetSelectedLine() == rcc then
						VoteOption["Difficulty"] = "RacoonCity"
				end
				GUI_Submit_Vote:SetText("Change Vote")
				net.Start("VoteTransfer")
				net.WriteString(VoteOption["Map"])
				net.WriteString(VoteOption["Game"])
				net.WriteString(VoteOption["Difficulty"])
				net.SendToServer()
			end

	GUI_Property_Sheet:AddSheet( "Vote Menu", GUI_Vote_Background_Panel, "icon16/user.png", true, true, "Vote for the next game here." )
	if (input == true) then
		GUI_Property_Sheet:SwitchToName("Vote Menu")
	end
end
concommand.Add("Re2_VoteMenu",GUI_VoteMenu)
concommand.Add("Re2_VoteMenu_vote",function(ply,cmd,args) GUI_VoteMenu(true) end)