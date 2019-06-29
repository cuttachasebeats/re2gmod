function GM:HUDShouldDraw(Name)
	if Name == "CHudHealth" or Name == "CHudBattery" or Name =="CHudSecondaryAmmo" or Name == "CHudAmmo" then
		return false
	end
	return true
end
local EkgTable = {}
EkgTable[1] = Material("re2_ekg/fine01")
EkgTable[2] = Material("re2_ekg/fine_yellow01")
EkgTable[3] = Material("re2_ekg/caution03")
EkgTable[4] = Material("re2_ekg/danger02")

local moneyIcon = vgui.Create("DImage")
moneyIcon:SetImage("icon16/money.png")
moneyIcon:SizeToContents()
moneyIcon:SetPos(4,4)
local ammoIcon = vgui.Create("DImage")
ammoIcon:SetImage("icon16/box.png")
ammoIcon:SizeToContents()
ammoIcon:SetPos(ScrW() - 45, ScrH() - 110)

surface.CreateFont( "zgTimerText", {
 font = "HUDNumber5",
 size = 24,
 weight = 300,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 underline = false,
 italic = false,
 strikeout = false,
 symbol = false,
 rotary = false,
 shadow = false,
 additive = false,
 outline = true
} )

surface.CreateFont( "BigTrebuchet", {
	font = "Trebuchet24o", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 48,
	weight = 700,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true,
} )

surface.CreateFont( "Trebuchet24o", {
	font = "Trebuchet24", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 24,
	weight = 700,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true,
} )

surface.CreateFont( "Trebuchet18o", {
	font = "Trebuchet18", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 12,
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true,
} )

local gradient = Material("gui/gradient")

function getTextSize(text, font)
	surface.SetFont(font or "Arial")
	return surface.GetTextSize(text)
end

function paintText(text, font, xPos, yPos, col, centerX, centerY)
	surface.SetTextColor(col or Color(255,255,255,255))
	surface.SetFont(font or "Arial")
	local wide, tall = surface.GetTextSize(text)
	if centerX then
		xPos = xPos - wide/2
	end
	if centerY then
		yPos = yPos - tall/2
	end
	surface.SetTextPos(xPos, yPos)
	surface.DrawText(text or "No Text Assigned")
	return wide, tall
end

function GM:HUDPaint()
	--if 1 == 1 then return end
	local SW = ScrW()
	local SH = ScrH()
	local client = LocalPlayer()
	local Money = client:GetNWInt("Money")

	if client:GetActiveWeapon():IsValid() then
		if client:Alive() then
			if client:Team() == TEAM_HUNK then
			local intAmmoInMag = client:GetActiveWeapon():Clip1()
			local intAmmoOutMag = client:GetAmmoCount(client:GetActiveWeapon():GetPrimaryAmmoType())
			local secondary_ammo = client:GetAmmoCount(client:GetActiveWeapon():GetSecondaryAmmoType())
			local MHp = client:GetMaxHealth()
			local Hp = client:Health()
			local str_status = translate.Get("fine")
			local Col_Hp = Color(0,255,0,155)
			local ekg = 1
			if Hp >= 75 then
				str_status = translate.Get("fine")
				Col_Hp = Color(0,155,0,155)
				ekg = 1
				elseif Hp >= 51 and Hp <= 74 then
				str_status = translate.Get("fine")
				ekg = 2
				Col_Hp = Color(155,155,0,155)
				elseif Hp >= 20 and Hp <= 50 then
				str_status = translate.Get("caution")
				ekg = 3
				Col_Hp = Color(155,100,0,155)
				elseif Hp <= 19 then
				str_status = translate.Get("danger")
				ekg = 4
				Col_Hp = Color(155,0,0,155)
				else
				str_status = translate.Get("dead")
				Col_Hp = Color(0,0,0,155)
			end


			local offset = 20
			local offsetY = SH/8 + 20
			surface.SetDrawColor( Col_Hp )

			--- infection
			surface.DrawRect(offset,SH - offsetY, SW/6,SH/8)
			if client:GetNWBool(translate.Get("infected")) then
				surface.SetDrawColor( 111, 152, 49, 100 )
				surface.DrawRect(offset, SH - offsetY, SW/6 * (client:GetNWInt("InfectedPercent")/100), SH/8 )
				draw.SimpleText(client:GetNWInt("InfectedPercent").."%","Trebuchet18o",offset + SW/6 * (client:GetNWInt("InfectedPercent")/100),SH - offsetY/2,Color(255,255,255),1,1)
			end

			surface.SetDrawColor( Color(0,0,0,155))
			surface.DrawLine(offset,SH - offsetY + SH/8 * (1/4),offset + SW/6,SH - offsetY + SH/8 * (1/4))
			surface.DrawLine(offset,SH - offsetY + SH/8 * (2/4),offset + SW/6,SH - offsetY + SH/8 * (2/4))
			surface.DrawLine(offset,SH - offsetY + SH/8 * (3/4),offset + SW/6,SH - offsetY + SH/8 * (3/4))
			surface.DrawOutlinedRect( offset,SH - offsetY, SW/6,SH/8)

			surface.SetDrawColor( Color(0,155,0,155) )
			surface.SetMaterial( EkgTable[ekg] )
			surface.DrawTexturedRect( offset,SH - offsetY, SW/6,SH/8)

	----------------Ammo
			if client:GetActiveWeapon():IsValid() && client:GetActiveWeapon():Clip1() != -1 then
				surface.SetFont("BigTrebuchet")
				surface.SetTextColor(200,200,200,200)
				local x, y = surface.GetTextSize(intAmmoInMag)
				surface.SetTextPos(SW - 124, SH - 110 - (y / 2))
				if client:GetActiveWeapon():GetClass() != "weapon_m79_re" then
					surface.DrawText(intAmmoInMag)
				end

				if client:GetActiveWeapon():GetClass() != "weapon_physgun" && client:GetActiveWeapon():GetClass() != "weapon_physcannon"  then
					if client:GetActiveWeapon().Primary.Ammo != "buckshot" || client:GetActiveWeapon().Primary.Ammo != "smg1" || client:GetActiveWeapon().Primary.Ammo != "ar2" || client:GetActiveWeapon().Primary.Ammo != "357" || client:GetActiveWeapon().Primary.Ammo != "pistol" then
						surface.SetFont("Trebuchet24o")
						surface.SetTextColor(200,200,200,200)
						local x, y = surface.GetTextSize(tostring(intAmmoOutMag.."/"..GAMEMODE.AmmoMax[client:GetActiveWeapon().Primary.Ammo].number))
						surface.SetTextPos(SW - x - 5, SH - 14 - (y / 2))
						surface.DrawText(intAmmoOutMag.."/"..GAMEMODE.AmmoMax[client:GetActiveWeapon().Primary.Ammo].number)
						ammoIcon:SetPos(SW - 5 - x - ammoIcon:GetWide() - 5, SH - 14 - (y / 2))
						ammoIcon:SetVisible(true)
						if GAMEMODE.AmmoMax[client:GetActiveWeapon().Primary.Ammo].icon != "" then
							if client:GetActiveWeapon():GetClass() != "weapon_m79_re" then
								DrawIcon(surface.GetTextureID(GAMEMODE.AmmoMax[client:GetActiveWeapon().Primary.Ammo].icon),SW -128+16, SH -128+16,96,96)
							else
								DrawIcon(surface.GetTextureID(GAMEMODE.AmmoMax[client:GetNWString("RE2_DisplayAmmoType")].icon),SW -128+16, SH -128+16,96,96)
							end
						end
					else
						surface.SetFont("Trebuchet24o")
						surface.SetTextColor(200,200,200,200)
						local x, y = surface.GetTextSize(intAmmoOutMag)
						surface.SetTextPos(SW - 64 - (x/2), SH - 18 - (y / 2))
						surface.DrawText(intAmmoOutMag)
						ammoIcon:SetVisible(false)
					end
				end
			else
				ammoIcon:SetVisible(false)
			end
			--..
			paintText(translate.Get("kills")..": "..client:GetNWInt("killcount"),"Trebuchet18o",5,72,Color(200,200,200,255),false,false)
			paintText("$"..string.Comma(Money), "Trebuchet24o", 20, 0, Color(0,255,0,255), false, false)

			--if GetGlobalBool("Re2_Classic") then
				--draw.SimpleText("Classic","Default",58,SH-60,Color(155,0,0,255),0,0)
			--end
			
			if GAMEMODE.Gamemode[GetGlobalString("RE2_Game")].Name != nil then
				paintText(translate.Get("game").." : "..GAMEMODE.Gamemode[GetGlobalString("RE2_Game")].Name,"Trebuchet18o",5,56,Color(255,255,255,255),false,false)
			else
				paintText(translate.Get("game").." : "..GetGlobalString("RE2_Game"),"Trebuchet18o",5,56,Color(200,200,200,255),false,false)
			end
				paintText(translate.Get("difficulty")..": "..GetGlobalString("RE2_Difficulty"),"Trebuchet18o",5,40,Color(200,200,200,255),false,false)
				local xPos, yPos = ScrW()/2, 0
				local text = ""
				if GetGlobalString("Mode") == "Merchant" || GetGlobalString("Mode") == "prep" then
					text = translate.Get("starting_in").." : "..string.ToMinutesSeconds(GetGlobalInt("Re2_CountDown"))
				elseif GetGlobalString("Mode") == "On" && GetGlobalString("RE2_Game") != "Mercenaries" && GetGlobalString("RE2_Game") != "VIP" && GetGlobalString("RE2_Game") != "Team_VIP" && GetGlobalString("RE2_Game") != "Boss" then
					text = translate.Get("time_alive").." : "..string.ToMinutesSeconds(client:GetNWInt("Time"))
					//draw.SimpleText("Time Alive : "..string.ToMinutesSeconds(client:GetNWInt("Time")),"Trebuchet18o",5,SH-25.6,Color(255,255,255,255),0,0)
				elseif GetGlobalString("Mode") == "On" && GetGlobalString("RE2_Game") == "Mercenaries" || GetGlobalString("RE2_Game") == "VIP" ||  GetGlobalString("RE2_Game") == "Team_VIP" ||  GetGlobalString("RE2_Game") == "Boss"  then
					text = translate.Get("time_alive").." : "..string.ToMinutesSeconds(GetGlobalInt("Re2_CountDown"))
					//draw.SimpleText(translate.Get("time_left").." : "..string.ToMinutesSeconds(GetGlobalInt("Re2_CountDown")),"Trebuchet18o",5,SH-25.6,Color(255,255,255,255),0,0)
				end
				local width, height = getTextSize(text, "zgTimerText")
				height = height + 5
				width = ScrW() * (1/3)

				surface.SetDrawColor(0,0,0,255)

				surface.SetMaterial( gradient )
				surface.DrawTexturedRectRotated( xPos - width/2, yPos + height/2, width, height - 1, 180)

				surface.SetMaterial( gradient )
				surface.DrawTexturedRectRotated( xPos + width/2 - 1, yPos + height/2, width, height, 0)

				paintText(text, "zgTimerText", xPos, yPos + height/2, Color(255,255,255,155), true, true)

				if GetGlobalString("RE2_Game") == "Survivor" then
					paintText(translate.Get("dead_zombies").." : " .. GetGlobalInt("RE2_DeadZombies").."/"..GetGlobalInt("DeadZombieKillNumber"),"Trebuchet18o",5,24,Color(200,10,10,255),false,false)
				else
					paintText(translate.Get("dead_zombies").." : " .. GetGlobalInt("RE2_DeadZombies"),"Trebuchet18o",5,24,Color(200,10,10,255),false,false)
				end
				paintText(translate.Get("condition")..": "..str_status,"Trebuchet24o",offset,SH - SH/6,Color(255,255,255,255),false,true)
			end
		end
	end
		--Spectators
	if client:Team() == TEAM_SPECTATOR then
			surface.SetDrawColor( Color(90,90,90,155))
			surface.DrawRect(0,SH - 158 ,128,158)

			surface.SetDrawColor( Color(0,0,0,200))
			surface.DrawOutlinedRect(0,SH -158,129,159)

			draw.SimpleText(translate.Get("difficulty")..": "..GetGlobalString("RE2_Difficulty"),"Trebuchet18o",5,SH-144,Color(255,255,255,255),0,0)
			draw.SimpleText(translate.Get("your_kills")..": "..client:GetNWInt("killcount"),"Trebuchet18o",5,SH-100,Color(200,200,200,255),0,0)
			draw.SimpleText(translate.Get("money").." $"..Money,"Trebuchet18o",5,SH-80,Color(50,200,50,255),0,0)
			if GAMEMODE.Gamemode[GetGlobalString("RE2_Game")].Name != nil then
				draw.SimpleText(translate.Get("game").." : "..GAMEMODE.Gamemode[GetGlobalString("RE2_Game")].Name,"Trebuchet18o",5,SH-60,Color(255,255,255,255),0,0)
			else
				draw.SimpleText(translate.Get("game").." : "..GetGlobalString("RE2_Game"),"Trebuchet18o",5,SH-60,Color(255,255,255,255),0,0)
			end
			draw.SimpleText(translate.Get("your_time").." : "..string.ToMinutesSeconds(client:GetNWInt("Time")),"Trebuchet18o",5,SH-40,Color(255,255,255,255),0,0)

				if GetGlobalString("Mode") == "Merchant" || GetGlobalString("Mode") == "prep" then
					draw.SimpleText(translate.Get("starting_in").." : "..string.ToMinutesSeconds(GetGlobalInt("Re2_CountDown")),"Trebuchet18o",5,SH-20,Color(255,255,255),0,0)
				elseif GetGlobalString("Mode") == "On" && GetGlobalString("RE2_Game") != "Mercenaries" && GetGlobalString("RE2_Game") != "VIP" && GetGlobalString("RE2_Game") != "Team_VIP" && GetGlobalString("RE2_Game") != "Boss"  then
					draw.SimpleText(translate.Get("gametime").." : "..string.ToMinutesSeconds(GetGlobalInt("Re2_GameTime")),"Trebuchet18o",5,SH-20,Color(255,255,255,255),0,0)
				elseif GetGlobalString("Mode") == "On" && GetGlobalString("RE2_Game") == "Mercenaries" || GetGlobalString("RE2_Game") == "VIP" ||  GetGlobalString("RE2_Game") == "Team_VIP" ||  GetGlobalString("RE2_Game") == "Boss" then
					draw.SimpleText(translate.Get("time_left").." : "..string.ToMinutesSeconds(GetGlobalInt("Re2_CountDown")),"Trebuchet18o",5,SH-20,Color(255,255,255,255),0,0)
				end
				if GetGlobalString("RE2_Game") == "Survivor" then
					draw.SimpleText(translate.Get("dead_zombies").." : ","Trebuchet18o",5,SH-124,Color(200,10,10),0,0)
					draw.SimpleText(GetGlobalInt("RE2_DeadZombies").."/"..GetGlobalInt("DeadZombieKillNumber"),"Trebuchet18o", 64 ,SH-112,Color(200,10,10),1,0)
				else
					draw.SimpleText(translate.Get("dead_zombies").." : ","Trebuchet18o", 5,SH-124,Color(200,10,10),0,0)
					draw.SimpleText(GetGlobalInt("RE2_DeadZombies"),"Trebuchet18o", 64,SH-112,Color(200,10,10),1,0)
				end
			moneyIcon:SetVisible(false)
			ammoIcon:SetVisible(false)
	end
	GAMEMODE:HUDDrawTargetID()

	if GAMEMODE.Gamemode[GetGlobalString("RE2_Game")] != nil then
		if GAMEMODE.Gamemode[GetGlobalString("RE2_Game")].HudFunction != nil then
			GAMEMODE.Gamemode[GetGlobalString("RE2_Game")].HudFunction(client)
		end
	end
end

function DrawIcon( TextureId, Left, Top, Width, Height)
	surface.SetTexture( TextureId )
	surface.SetDrawColor(255,255,255,255)
	surface.DrawTexturedRect( Left, Top, Width, Height )
end

function GM:HUDDrawTargetID()
	local tr = util.GetPlayerTrace(LocalPlayer(),LocalPlayer():GetAimVector())
 	local trace = util.TraceLine(tr)
 	if !trace.Hit then return end
 	if !trace.HitNonWorld then return end
 	local text = "ERROR"
	if trace.Entity:GetClass() == "item_base"  then
		local min,max,cen = trace.Entity:LocalToWorld(trace.Entity:OBBMins()), trace.Entity:LocalToWorld(trace.Entity:OBBMaxs()), trace.Entity:LocalToWorld(trace.Entity:OBBCenter())
		local minl,maxl,cenp = min:Distance(cen), max:Distance(cen), cen:ToScreen()
		local minp = (cen + (LocalPlayer():GetRight() * (-1 * minl)) + (LocalPlayer():GetUp() * (-1 * minl))):ToScreen()
		local maxp = (cen + (LocalPlayer():GetRight() * maxl) + (LocalPlayer():GetUp() * maxl)):ToScreen()
		if not cenp.visible then
			DrawTime = nil
			trace.Entity = nil
		return end
		surface.SetDrawColor(250,20,0,250)
		surface.DrawLine(minp.x,maxp.y,maxp.x,maxp.y)
		surface.DrawLine(minp.x,maxp.y,minp.x,minp.y)
		surface.DrawLine(minp.x,minp.y,maxp.x,minp.y)
		surface.DrawLine(maxp.x,maxp.y,maxp.x,minp.y)
		surface.SetDrawColor(255,255,255,155)
		surface.SetTextPos(minp.x+2,maxp.y-15)
		if trace.Entity:GetClass() == "item_item_crate" then
			text = "Crate"
		elseif trace.Entity:GetNWString("Class") == "" then
			text = "Loading..."
		elseif trace.Entity:GetNWString("Class") != nil then
			if GAMEMODE.Items[trace.Entity:GetNWString("Class")].Name != nil then
				text = GAMEMODE.Items[trace.Entity:GetNWString("Class")].Name
			else
				text = "Loading..."
			end
		end
		surface.SetFont("TargetIDSmall")
		surface.DrawText(text)
		surface.SetDrawColor(0,0,0,255)
		surface.SetTextPos(minp.x+2,maxp.y-15)
		surface.SetFont("TargetIDSmall")
		surface.DrawText(text)
	end
	if trace.Entity:GetClass() == "player" then
		local Hpcolor = Color(0,155,0,120)
		if trace.Entity:Health() >= 75 then
				Hpcolor = Color(0,155,0,120)
			elseif trace.Entity:Health() >= 51 and trace.Entity:Health() <= 74 then
				Hpcolor = Color(155,155,0,120)
			elseif trace.Entity:Health() >= 20 and trace.Entity:Health() <= 50 then
				Hpcolor = Color(155,100,0,120)
			elseif trace.Entity:Health() <= 19 then
				Hpcolor = Color(155,0,0,120)
			end
		surface.SetDrawColor(Hpcolor)
		surface.DrawRect(ScrW()/2-50,ScrH()/2 + 300,100,10)
		surface.SetDrawColor(50,50,50,255)
		surface.DrawOutlinedRect(ScrW()/2-50,ScrH()/2 + 300,100,10)
		if trace.Entity:GetNWBool("Infected") then
			surface.SetDrawColor(50,50,50,100)
			surface.DrawRect(ScrW()/2-50,ScrH()/2 + 310,100,10)
			surface.SetDrawColor( 111, 152, 49, 100 )
			surface.DrawRect(ScrW()/2-50,ScrH()/2 + 310,trace.Entity:GetNWInt("InfectedPercent"),10)
			surface.SetDrawColor(0,0,0,255)
			surface.SetFont("Default")
			local x1,y1 = surface.GetTextSize(trace.Entity:GetNWInt("InfectedPercent").." %")
			surface.SetTextPos(ScrW()/2-x1/2,ScrH()/2 + 310)
			surface.DrawText(trace.Entity:GetNWInt("InfectedPercent").." %")
		end
		surface.SetDrawColor(255,25,255,255)
		surface.SetFont("Default")
		local x,y = surface.GetTextSize(trace.Entity:Nick())
		surface.SetTextPos(ScrW()/2-x/2,ScrH()/2 + 300)
		surface.DrawText(trace.Entity:Nick())
	end
end

function StartChat(TeamSay)
	bool_Chating = true
end
hook.Add("StartChat", "OpenChatBox", StartChat)

function EndChat(TeamSay)
	bool_Chating = false
end
hook.Add("FinishChat", "OpenChatBox", EndChat)
