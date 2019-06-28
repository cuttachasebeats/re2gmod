concommand.Add("RE2_Menu",function() ResidentEvil2_Menu() openVote() VoteTab:SetDisabled(true) VoteTab:SetTextColor(Color(0,200,30)) end)
// Had to create a console command so that when the game ends, we can call it.
function ResidentEvil2_Menu()
  local client = LocalPlayer()
      MainPanel = vgui.Create("DFrame")
      MainPanel:SetSize(ScrW()*.5,ScrH()*.55)
      MainPanel:SetPos(ScrW()*.25,ScrH()*.25)
      MainPanel:SetTitle("")
      MainPanel:ShowCloseButton(false)
      MainPanel:MakePopup()
      MainPanel.Paint = function() draw.RoundedBox( 0, 0, 0, MainPanel:GetWide(), MainPanel:GetTall(), Color(60,60,60,255)) draw.RoundedBox( 0, 0, 0, MainPanel:GetWide(), MainPanel:GetTall()*.05, Color(30,30,30,255)) end

local CloseBtn = re2_create_Button(MainPanel, .975, 0, .025, .05,Color(0,0,0), "font large", "X")
      CloseBtn.Paint = function() draw.RoundedBox( 0, 0, 0, CloseBtn:GetWide(), CloseBtn:GetTall(), Color(200,30,30,255)) end
      CloseBtn.DoClick = function() MainPanel:Remove() end

      VoteTab = re2_create_Button(MainPanel, .01, 0, .1, .05,Color(255,255,255), "font large", "Voting")
      VoteTab.Paint = function() draw.RoundedBox( 0, 0, 0, VoteTab:GetWide(), VoteTab:GetTall(), Color(60,60,60,255)) end
      VoteTab.DoClick = function() openVote()
      VoteTab:SetTextColor(Color(0,200,30))
      StoreTab:SetTextColor(Color(255,255,255))
      UpgradesTab:SetTextColor(Color(255,255,255))
      ChestsTab:SetTextColor(Color(255,255,255))
      SkillsTab:SetTextColor(Color(255,255,255))

      VoteTab:SetDisabled(true)
      StoreTab:SetDisabled(false)
      ChestsTab:SetDisabled(false)
      UpgradesTab:SetDisabled(false)
      SkillsTab:SetDisabled(false)

      end

      StoreTab = re2_create_Button(MainPanel, .12, 0, .1, .05,Color(255,255,255), "font large", "Store")
      StoreTab.Paint = function() draw.RoundedBox( 0, 0, 0, StoreTab:GetWide(), StoreTab:GetTall(), Color(60,60,60,255)) end
      StoreTab.DoClick = function() openStore()
      StoreTab:SetTextColor(Color(0,200,30))
      VoteTab:SetTextColor(Color(255,255,255))
      UpgradesTab:SetTextColor(Color(255,255,255))
      ChestsTab:SetTextColor(Color(255,255,255))
      SkillsTab:SetTextColor(Color(255,255,255))

      StoreTab:SetDisabled(true)
      VoteTab:SetDisabled(false)
      ChestsTab:SetDisabled(false)
      UpgradesTab:SetDisabled(false)
      SkillsTab:SetDisabled(false)

     end

      ChestsTab = re2_create_Button(MainPanel, .23, 0, .1, .05,Color(255,255,255), "font large", "Chest")
      ChestsTab.Paint = function() draw.RoundedBox( 0, 0, 0, ChestsTab:GetWide(), ChestsTab:GetTall(), Color(60,60,60,255)) end
      ChestsTab.DoClick = function() openChest()
      ChestsTab:SetTextColor(Color(0,200,30))
      StoreTab:SetTextColor(Color(255,255,255))
      UpgradesTab:SetTextColor(Color(255,255,255))
      SkillsTab:SetTextColor(Color(255,255,255))
      VoteTab:SetTextColor(Color(255,255,255))

      ChestsTab:SetDisabled(true)
      VoteTab:SetDisabled(false)
      StoreTab:SetDisabled(false)
      UpgradesTab:SetDisabled(false)
      SkillsTab:SetDisabled(false)

      end

      SkillsTab = re2_create_Button(MainPanel, .34, 0, .1, .05,Color(255,255,255), "font large", "Skills")
      SkillsTab.Paint = function() draw.RoundedBox( 0, 0, 0, SkillsTab:GetWide(), SkillsTab:GetTall(), Color(60,60,60,255)) end
      SkillsTab.DoClick = function() openSkills()
      SkillsTab:SetTextColor(Color(0,200,30))
      StoreTab:SetTextColor(Color(255,255,255))
      UpgradesTab:SetTextColor(Color(255,255,255))
      ChestsTab:SetTextColor(Color(255,255,255))
      VoteTab:SetTextColor(Color(255,255,255))

      SkillsTab:SetDisabled(true)
      UpgradesTab:SetDisabled(false)
      ChestsTab:SetDisabled(false)
      VoteTab:SetDisabled(false)
      StoreTab:SetDisabled(false)
       end

      UpgradesTab = re2_create_Button(MainPanel, .45, 0, .1, .05,Color(255,255,255), "font large", "Upgrades")
      UpgradesTab.Paint = function() draw.RoundedBox( 0, 0, 0, UpgradesTab:GetWide(), UpgradesTab:GetTall(), Color(60,60,60,255)) end
      UpgradesTab.DoClick = function() openUpgrades()
      UpgradesTab:SetTextColor(Color(0,200,30))
      StoreTab:SetTextColor(Color(255,255,255))
      ChestsTab:SetTextColor(Color(255,255,255))
      SkillsTab:SetTextColor(Color(255,255,255))
      VoteTab:SetTextColor(Color(255,255,255))

      UpgradesTab:SetDisabled(true)
      ChestsTab:SetDisabled(false)
      VoteTab:SetDisabled(false)
      StoreTab:SetDisabled(false)
      SkillsTab:SetDisabled(false)
       end



if isAdmin == true then
    AdminTab = re2_create_Button(MainPanel, .86, 0, .1, .05,Color(255,255,255), "font large", "Admin")
    AdminTab.Paint = function() draw.RoundedBox( 0, 0, 0, AdminTab:GetWide(), AdminTab:GetTall(), Color(60,60,60,255)) end
    AdminTab.DoClick = function() openAdmin() end
end

if isInRound == true then
  StoreTab:Remove()
  ChestsTab:Remove()
  SkillsTab:Remove()
  UpgradesTab:Remove()
end

end

net.Receive("f4_open",function()
isAdmin = net.ReadBool(isAdmin)
isInRound = net.ReadBool(isInRound)
ResidentEvil2_Menu()
openVote()
VoteTab:SetDisabled(true)
VoteTab:SetTextColor(Color(0,200,30))
end)
