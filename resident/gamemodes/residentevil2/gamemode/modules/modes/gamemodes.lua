--Game mode list
GM.Gamemode = {}
	GM.Gamemode["Survivor"] = {


		PrepFunction = function()

			SetGlobalString( "Mode", "prep" )
			GAMEMODE:SelectMusic(GetGlobalString("Mode"))

			SetGlobalInt("Re2_CountDown", 60)
			timer.Create("Re2_CountDowntimer_Survivor",1,0, function()
			SetGlobalInt("Re2_CountDown", GetGlobalInt("Re2_CountDown") - 1)
				if GetGlobalInt("Re2_CountDown") <= 0 then
					GAMEMODE:BaseStart()
					timer.Destroy("Re2_CountDowntimer_Survivor")
				end
			end	)
		end,

		StartFunction = function()
							for _,ply in pairs(player.GetAll()) do
								local modifier = math.Round(math.random(20,25) * GAMEMODE.ZombieData[GetGlobalString("Re2_Difficulty")].Modifier/1.33)
								SetGlobalInt("DeadZombieKillNumber", GetGlobalInt("DeadZombieKillNumber") + modifier)
							end
					timer.Create("TimeSurvivedTimer",1,0, function()
							SetGlobalInt("RE2_GameTime", GetGlobalInt("RE2_GameTime") + 1)

							for _,ply in pairs(team.GetPlayers(TEAM_HUNK)) do
								ply:SetNWInt("Time",ply:GetNWInt("Time") + 1 )
							end

								if GetGlobalInt("RE2_DeadZombies") >= GetGlobalInt("DeadZombieKillNumber") && GetGlobalInt("Game") != "End" then
									timer.Destroy("TimeSurvivedTimer")
									GAMEMODE:BaseEndGame()
								end
							end )

						end,

		CheckFunction = function()
							if team.NumPlayers(TEAM_HUNK) <= 0 then
								GAMEMODE:BaseEndGame()
								return
							end
						end,

		EndFunction = function()
						if GetGlobalInt("RE2_DeadZombies") >= GetGlobalInt("DeadZombieKillNumber") then
							if table.Count(team.GetPlayers(TEAM_HUNK)) > 0 then
								for _,ply in pairs(player.GetAll()) do
									if ply:Team() == TEAM_HUNK then
										ply:SetNWBool("Infected", false)
										ply:SetNWInt("InfectedPercent", 0)

										ply:DeathReward()

									end
								end
							end
						end
					end,
		DifficultyFunction = function() -- Called Every 60 seconds
			if !GetGlobalBool("Re2_Classic") then
				GAMEMODE.ZombieDatafast = GAMEMODE.ZombieDatafast + 1
				//table.insert(GAMEMODE.ZombieData.Zombies,"snpc_zombie_crimzon")
			end
		end,
		RewardFunction = function()
				if GetGlobalInt("RE2_DeadZombies") >= GetGlobalInt("DeadZombieKillNumber") then
					if table.Count(team.GetPlayers(TEAM_HUNK)) > 0 then
						local reward = table.Count(team.GetPlayers(TEAM_HUNK)) * 150
						reward = reward * GAMEMODE.ZombieData[GetGlobalString("Re2_Difficulty")].Modifier
						PrintMessage( HUD_PRINTTALK, "Surviving players won $"..reward.." for staying alive. Well done!" )
						for _,ply in pairs(player.GetAll()) do
							if ply:Team() == TEAM_HUNK then

							ply:SetNWInt("Money", ply:GetNWInt("Money") + reward )

							end
						end
					end
				end
		end,
		}

	GM.Gamemode["PVP"] = {
		Name = "PVP",
		Teams = true,
		Condition = function()
			if team.NumPlayers(TEAM_HUNK) <= 30 then
				return false
			end
			return true
		end,

		JoinFunction = function(ply)
			if GetGlobalString("Mode") != "Merchant" then
				if #Re2_Teams.StarsTeam <= #Re2_Teams.UmbrellaTeam then
					ply:SetNWInt("TeamId",1)
					table.insert(Re2_Teams.StarsTeam,ply)
				elseif #Re2_Teams.UmbrellaTeam <= #Re2_Teams.StarsTeam then
					ply:SetNWInt("TeamId",2)
					table.insert(Re2_Teams.StarsTeam,ply)
				end
			end
		end,

		DisconnectFunction = function(ply)
			if GetGlobalString("Mode") != "End" then
			if ply:GetNWInt("TeamId") == 1 then
				for key,data in pairs(Re2_Teams.StarsTeam) do
					if data == ply then
						table.remove(Re2_Teams.StarsTeam,key)
						break
					end
				end
			elseif ply:GetNWInt("TeamId") == 2 then
				for key,data in pairs(Re2_Teams.UmbrellaTeam) do
					if data == ply then
						table.remove(Re2_Teams.UmbrellaTeam,key)
						break
					end
				end
			end
				if GetGlobalEntity("Team01_VIP") == ply then
					local VIP = table.Random(Re2_Teams.StarsTeam)
					SetGlobalEntity( "Team01_VIP", VIP  )
					VIP:Give("weapon_physcannon")
				elseif GetGlobalEntity("Team02_VIP") == ply then
					local VIP = table.Random(Re2_Teams.UmbrellaTeam)
					SetGlobalEntity( "Team01_VIP", VIP  )
					VIP:Give("weapon_physcannon")
				end
			end
		end,

		PrepFunction = function()

			SetGlobalString( "Mode", "prep" )
			GAMEMODE:SelectMusic(GetGlobalString("Mode"))

			SetGlobalInt("Re2_CountDown", GAMEMODE.ZombieData[GetGlobalString("Re2_Difficulty")].StartTime)

			Re2_Teams = {StarsTeam = {},UmbrellaTeam = {} }

			local SelectablePlayers = team.GetPlayers(TEAM_HUNK)

			for _,player in pairs(team.GetPlayers(TEAM_HUNK)) do
				if #Re2_Teams.UmbrellaTeam < #Re2_Teams.StarsTeam then
					local playa = table.Random(SelectablePlayers)
					playa:SetNWInt("TeamId",2)
					table.insert(Re2_Teams.UmbrellaTeam,playa)
					for key,data in pairs(SelectablePlayers) do
						if data == playa then
							table.remove(SelectablePlayers,key)
							break
						end
					end
				elseif #Re2_Teams.StarsTeam < math.Round(#team.GetPlayers(TEAM_HUNK)/2) then
					local plya = table.Random(SelectablePlayers)
					plya:SetNWInt("TeamId",1)
					table.insert(Re2_Teams.StarsTeam,plya)
					for key,data in pairs(SelectablePlayers) do
						if data == plya then
							table.remove(SelectablePlayers,key)
							break
						end
					end
				end
			end

			------------------Choose Vip
			PrintTable(Re2_Teams.StarsTeam)

			local VIP = table.Random(Re2_Teams.StarsTeam)
			SetGlobalEntity( "Team01_VIP", VIP  )
			VIP:Give("weapon_physcannon")

			PrintTable(Re2_Teams.UmbrellaTeam)

			local VIP1 = table.Random(Re2_Teams.UmbrellaTeam)
			SetGlobalEntity( "Team02_VIP", VIP1  )
			VIP1:Give("weapon_physcannon")

			timer.Create("Re2_CountDowntimer_Vip",1,0, function()
			SetGlobalInt("Re2_CountDown", GetGlobalInt("Re2_CountDown") - 1)
				if GetGlobalInt("Re2_CountDown") <= 0 then

					GAMEMODE:BaseStart()
					timer.Destroy("Re2_CountDowntimer_Vip")
				end

			end
			)
		end,

		StartFunction = function()
		SetGlobalInt("Re2_CountDown", 300 + (table.Count(team.GetPlayers(TEAM_HUNK)) * 60) )

		---------------------Set the Re2_CountDown
				timer.Create("Re2_CountDown_TEAMVIP",1,0, function()

						SetGlobalInt("RE2_GameTime", GetGlobalInt("RE2_GameTime") + 1)
						SetGlobalInt("Re2_CountDown", GetGlobalInt("Re2_CountDown") - 1)
							for _,ply in pairs(team.GetPlayers(TEAM_HUNK)) do
								ply:SetNWInt("Time",ply:GetNWInt("Time") + 1 )
							end
							if GetGlobalInt("Re2_CountDown") <= 0 then
								timer.Destroy("Re2_CountDown_TEAMVIP")
								GAMEMODE:BaseEndGame()
							end
					end)

		end,

		CheckFunction = function()
					if GetGlobalEntity("Team01_VIP"):Team() != TEAM_HUNK  || GetGlobalEntity("Team02_VIP"):Team() != TEAM_HUNK then
						GAMEMODE:BaseEndGame()
						return
					end
		end,

		EndFunction = function()
				for _,ply in pairs(player.GetAll()) do
					if ply:Team() == TEAM_HUNK then
						ply:SetNWBool("Infected", false)
						ply:SetNWInt("InfectedPercent", 0)

						ply:DeathReward()

					end
				end

				local Starskills = 0
				local Umbrellakills = 0

				if GetGlobalEntity("Team01_VIP"):Team() != TEAM_HUNK && GetGlobalEntity("Team02_VIP"):Team() == TEAM_HUNK then
					SetGlobalString("Re2_TEAMVIP_Winner","Umbrella")
				elseif GetGlobalEntity("Team02_VIP"):Team() != TEAM_HUNK && GetGlobalEntity("Team01_VIP"):Team() == TEAM_HUNK then
					SetGlobalString("Re2_TEAMVIP_Winner","S.T.A.R.S")
				elseif GetGlobalEntity("Team01_VIP"):Team() == TEAM_HUNK && GetGlobalEntity("Team02_VIP"):Team() == TEAM_HUNK && GetGlobalEntity("Team01_VIP"):Health() > GetGlobalEntity("Team02_VIP"):Health() then
					SetGlobalString("Re2_TEAMVIP_Winner","S.T.A.R.S")
				elseif GetGlobalEntity("Team02_VIP"):Team() == TEAM_HUNK && GetGlobalEntity("Team01_VIP"):Team() == TEAM_HUNK && GetGlobalEntity("Team02_VIP"):Health() >= GetGlobalEntity("Team01_VIP"):Health() then
					SetGlobalString("Re2_TEAMVIP_Winner","Umbrella")
				else
					SetGlobalString("Re2_TEAMVIP_Winner","Umbrella")
				end
			timer.Destroy("Re2_CountDowntimer")
		end,

		DifficultyFunction = function()
			if !GetGlobalBool("Re2_Classic") then
				GAMEMODE.ZombieDatafast = GAMEMODE.ZombieDatafast + 1
				//table.insert(GAMEMODE.ZombieData.Zombies,"snpc_zombie_crimzon")
			end
		end,

		RewardFunction = function()

			local reward = math.Round((GetGlobalInt("RE2_DeadZombies") + #player.GetAll() * 60 + 300)  /2)
			reward = reward * GAMEMODE.ZombieData[GetGlobalString("Re2_Difficulty")].Modifier
			for _,ply  in pairs(player.GetAll()) do
				if ply:GetNWInt("TeamId") == 1 && GetGlobalString("Re2_TEAMVIP_Winner") == "S.T.A.R.S" then
					ply:SetNWInt("Money",math.Round(ply:GetNWInt("Money")+ reward))
				elseif ply:GetNWInt("TeamId") == 2 && GetGlobalString("Re2_TEAMVIP_Winner") == "Umbrella" then
					ply:SetNWInt("Money",math.Round(ply:GetNWInt("Money")+ reward))
				end
			end
			PrintMessage( HUD_PRINTTALK, "The "..GetGlobalString("Re2_TEAMVIP_Winner").." Team Won! They are awarded $"..reward.." each. Fine Work!" )
		end,

		HudFunction = function(ply)
				if SERVER then return end
				local SW = ScrW()
				local SH = ScrH()
				local client = LocalPlayer()
				if GetGlobalString("Mode") == "Merchant" then return end

				for _,ply in pairs(team.GetPlayers(TEAM_HUNK)) do
					if ply:GetNWInt("TeamId") == 1 && LocalPlayer() != ply && ply:GetPos():Distance(LocalPlayer():GetPos()) <= 400 then
						local pos = ply:LocalToWorld(ply:OBBCenter() + Vector(0,0,40)):ToScreen()
						DrawIcon(surface.GetTextureID("re2_teams/stars"),pos.x,pos.y,48,48 )
					elseif  ply:GetNWInt("TeamId") == 2 && LocalPlayer() != ply && ply:GetPos():Distance(LocalPlayer():GetPos()) <= 400 then
						local pos = ply:LocalToWorld(ply:OBBCenter() + Vector(0,0,40)):ToScreen()
						DrawIcon(surface.GetTextureID("re2_teams/umbrella"),pos.x,pos.y,48,48 )
					end
				end

				if GetGlobalString("Mode") == "End" then
					if GetGlobalString("Re2_TEAMVIP_Winner") == "Umbrella" then
						DrawIcon(surface.GetTextureID("re2_teams/umbrella" ),SW/2 - 150, SH/2 - 150 ,300,300)
						draw.SimpleText("Umbrella Wins","Trebuchet18o",SW/2 ,SH/2 + 150 + 10,Color(255,255,255,255),1,0)
					elseif GetGlobalString("Re2_TEAMVIP_Winner") == "S.T.A.R.S" then
						DrawIcon(surface.GetTextureID("re2_teams/stars" ),SW/2 - 123, SH/2 - 144 ,246,288)
						draw.SimpleText("S.T.A.R.S Wins","Trebuchet18o",SW/2,SH/2 + 144 + 10,Color(255,255,255,255),1,0)
					end
				end

				if ply:GetNWInt("TeamId") == 1 then
					DrawIcon(surface.GetTextureID("re2_teams/stars" ),SW/2 - 16, SH - SH + 28 ,32,32)
					if ply != GetGlobalEntity("Team01_VIP") && GetGlobalEntity("Team01_VIP"):Team() == TEAM_HUNK then
						local Vipcolor = Color(0,155,0,250)
						if GetGlobalEntity("Team01_VIP"):Health() >= 75 then
								Vipcolor = Color(0,155,0,250)
							elseif GetGlobalEntity("Team01_VIP"):Health() >= 51 and GetGlobalEntity("Team01_VIP"):Health() <= 74 then
								Vipcolor = Color(155,155,0,250)
							elseif GetGlobalEntity("Team01_VIP"):Health() >= 20 and GetGlobalEntity("Team01_VIP"):Health() <= 50 then
								Vipcolor = Color(155,100,0,250)
							elseif GetGlobalEntity("Team01_VIP"):Health() <= 19 then
								Vipcolor = Color(155,0,0,250)
							end
						local min,max,cen = GetGlobalEntity("Team01_VIP"):LocalToWorld(GetGlobalEntity("Team01_VIP"):OBBMins()), GetGlobalEntity("Team01_VIP"):LocalToWorld(GetGlobalEntity("Team01_VIP"):OBBMaxs()), GetGlobalEntity("Team01_VIP"):LocalToWorld(GetGlobalEntity("Team01_VIP"):OBBCenter())
						local minl,maxl,cenp = min:Distance(cen), max:Distance(cen), cen:ToScreen()
						local minp = (cen + (ply:GetRight() * (-1 * minl)) + (ply:GetUp() * (-1 * minl))):ToScreen()
						local maxp = (cen + (ply:GetRight() * maxl) + (ply:GetUp() * maxl)):ToScreen()
						if not cenp.visible then
							DrawTime = nil
						return end
						surface.SetDrawColor(Vipcolor)
						surface.DrawLine(minp.x,maxp.y,maxp.x,maxp.y)
						surface.DrawLine(minp.x,maxp.y,minp.x,minp.y)
						surface.DrawLine(minp.x,minp.y,maxp.x,minp.y)
						surface.DrawLine(maxp.x,maxp.y,maxp.x,minp.y)
						surface.SetDrawColor(255,255,255,155)
						surface.SetTextPos(minp.x+2,maxp.y-15)
						local text = "Protect This Player"
						surface.SetFont("DefaultSmall")
						surface.DrawText(text)
						surface.SetDrawColor(255,255,255,255)
						surface.SetTextPos(minp.x+2,maxp.y-15)
						surface.SetFont("Default")
						surface.DrawText(text)
					elseif ply == GetGlobalEntity("Team01_VIP") && GetGlobalEntity("Team01_VIP"):Team() == TEAM_HUNK then
						surface.SetFont("Trebuchet18o")
						local textx,texty = surface.GetTextSize("You are the Vip")
						draw.SimpleText("You are the Vip","Trebuchet18o",SW/2 - textx/2,SH - SH + 60,Color(255,255,255,255),0,0)
					end
				elseif ply:GetNWInt("TeamId") == 2 then
					DrawIcon(surface.GetTextureID("re2_teams/umbrella" ),SW/2 - 16, SH - SH + 28 ,32,32)
					if ply != GetGlobalEntity("Team02_VIP") && GetGlobalEntity("Team02_VIP"):Team() == TEAM_HUNK then
						DrawIcon(surface.GetTextureID("re2_teams/umbrella"),SW/2 - 16, SH - SH + 28 ,32,32)
						local Vipcolor = Color(0,155,0,250)
							if GetGlobalEntity("Team02_VIP"):Health() >= 75 then
								Vipcolor = Color(0,155,0,250)
							elseif GetGlobalEntity("Team02_VIP"):Health() >= 51 and GetGlobalEntity("Team02_VIP"):Health() <= 74 then
								Vipcolor = Color(155,155,0,250)
							elseif GetGlobalEntity("Team02_VIP"):Health() >= 20 and GetGlobalEntity("Team02_VIP"):Health() <= 50 then
								Vipcolor = Color(155,100,0,250)
							elseif GetGlobalEntity("Team02_VIP"):Health() <= 19 then
								Vipcolor = Color(155,0,0,250)
							end
						local min,max,cen = GetGlobalEntity("Team02_VIP"):LocalToWorld(GetGlobalEntity("Team02_VIP"):OBBMins()), GetGlobalEntity("Team02_VIP"):LocalToWorld(GetGlobalEntity("Team02_VIP"):OBBMaxs()), GetGlobalEntity("Team02_VIP"):LocalToWorld(GetGlobalEntity("Team02_VIP"):OBBCenter())
						local minl,maxl,cenp = min:Distance(cen), max:Distance(cen), cen:ToScreen()
						local minp = (cen + (ply:GetRight() * (-1 * minl)) + (ply:GetUp() * (-1 * minl))):ToScreen()
						local maxp = (cen + (ply:GetRight() * maxl) + (ply:GetUp() * maxl)):ToScreen()
						if not cenp.visible then
							DrawTime = nil
						return end
						surface.SetDrawColor(Vipcolor)
						surface.DrawLine(minp.x,maxp.y,maxp.x,maxp.y)
						surface.DrawLine(minp.x,maxp.y,minp.x,minp.y)
						surface.DrawLine(minp.x,minp.y,maxp.x,minp.y)
						surface.DrawLine(maxp.x,maxp.y,maxp.x,minp.y)
						surface.SetDrawColor(255,255,255,155)
						surface.SetTextPos(minp.x+2,maxp.y-15)
						local text = "Protect This Player"
						surface.SetFont("DefaultSmall")
						surface.DrawText(text)
						surface.SetDrawColor(255,255,255,255)
						surface.SetTextPos(minp.x+2,maxp.y-15)
						surface.SetFont("Default")
						surface.DrawText(text)
					elseif ply == GetGlobalEntity("Team02_VIP") && GetGlobalEntity("Team02_VIP"):Team() == TEAM_HUNK then
						surface.SetFont("Trebuchet18o")
						local textx,texty = surface.GetTextSize("You are the Vip")
						draw.SimpleText("You are the Vip","Trebuchet18o",SW/2 - textx/2,SH - SH + 60,Color(255,255,255,255),0,0)
					end
				end
			end,
		}


	GM.Gamemode["VIP"] = {

		Condition = function()
			if team.NumPlayers(TEAM_HUNK) <= 1 then
				return false
			end
			return true
		end,

		DisconnectFunction = function(ply)
				if GetGlobalString("Mode") != "End" then
					if GetGlobalEntity("Thevip") == ply && team.NumPlayers(TEAM_HUNK) > 1 then
						local hunks = team.GetPlayers(TEAM_HUNK)
						local VIP = team.GetPlayers(TEAM_HUNK)[math.random(1,#hunks)]
						SetGlobalEntity( "Thevip", VIP  )
						VIP:Give("weapon_physcannon")
					elseif team.NumPlayers(TEAM_HUNK) < 1 then
						GAMEMODE:BaseEndGame()
					end
				end
			end,
		PrepFunction = function()

			SetGlobalString( "Mode", "prep" )
			GAMEMODE:SelectMusic(GetGlobalString("Mode"))

			SetGlobalInt("Re2_CountDown", GAMEMODE.ZombieData[GetGlobalString("Re2_Difficulty")].StartTime)
			------------------Choose Vip
			SetGlobalEntity( "Thevip", ""  )
			local hunks = team.GetPlayers(TEAM_HUNK)
			local VIP = team.GetPlayers(TEAM_HUNK)[math.random(1,#hunks)]
			SetGlobalEntity( "Thevip", VIP  )
			VIP:Give("weapon_physcannon")

			timer.Create("Re2_CountDowntimer_Vip",1,0, function()
			SetGlobalInt("Re2_CountDown", GetGlobalInt("Re2_CountDown") - 1)
				if GetGlobalInt("Re2_CountDown") <= 0 then
					GAMEMODE:BaseStart()
					timer.Destroy("Re2_CountDowntimer_Vip")
				end

			end
			)
		end,

		StartFunction = function()
		SetGlobalInt("Re2_CountDown", 300 + (table.Count(team.GetPlayers(TEAM_HUNK)) * 60) )

		---------------------Set the Re2_CountDown
				timer.Create("Re2_CountDownVIP",1,0, function()

						SetGlobalInt("RE2_GameTime", GetGlobalInt("RE2_GameTime") + 1)
						SetGlobalInt("Re2_CountDown", GetGlobalInt("Re2_CountDown") - 1)
							for _,ply in pairs(team.GetPlayers(TEAM_HUNK)) do
								ply:SetNWInt("Time",ply:GetNWInt("Time") + 1 )
							end
							if GetGlobalInt("Re2_CountDown") <= 0 then
								timer.Destroy("Re2_CountDownVIP")
								GAMEMODE:BaseEndGame()
							end
					end)

		end,

		CheckFunction = function()
					if GetGlobalEntity("Thevip"):Team() != TEAM_HUNK && GetGlobalEntity("Thevip") != nil then
						GAMEMODE:BaseEndGame()
						return
					elseif GetGlobalEntity("Thevip") == nil then
						GAMEMODE:BaseEndGame()
					end
		end,

		EndFunction = function()
				for _,ply in pairs(player.GetAll()) do
					if ply:Team() == TEAM_HUNK then
						ply:SetNWBool("Infected", false)
						ply:SetNWInt("InfectedPercent", 0)

						ply:DeathReward()

					end
				end
				timer.Destroy("Re2_CountDowntimer")
			end,

			DifficultyFunction = function()
				if !GetGlobalBool("Re2_Classic") then
					GAMEMODE.ZombieDatafast = GAMEMODE.ZombieDatafast + 1
					//table.insert(GAMEMODE.ZombieData.Zombies,"snpc_zombie_crimzon")
				end
			end,

		RewardFunction = function()
			local leader = player.GetAll()[1]
			if GetGlobalEntity( "Thevip", VIP  ):Team() == TEAM_HUNK then
				local reward = math.Round((GetGlobalInt("RE2_DeadZombies") * math.Round(table.Count( player.GetAll())))/ 2)
				reward = reward * 2 * GAMEMODE.ZombieData[GetGlobalString("Re2_Difficulty")].Modifier
				PrintMessage( HUD_PRINTTALK, "The Vip has survived! All players won $"..reward.." . Fine Work!" )
				for _,ply  in pairs(player.GetAll()) do
					ply:SetNWInt("Money",math.Round(ply:GetNWInt("Money")+ reward))
				end
			else
				PrintMessage( HUD_PRINTTALK, "The Vip has died, nobody is rewarded a special bonus." )
			end
		end,


		HudFunction = function(ply)
			if SERVER then return end
			local SW = ScrW()
			local SH = ScrH()
			local client = LocalPlayer()
			if GetGlobalString("RE2_Game") == "VIP" && GetGlobalString("Mode") != "Merchant" then
				if ply != GetGlobalEntity("Thevip") && GetGlobalEntity("Thevip"):Team() == TEAM_HUNK then
					local Vipcolor = Color(0,155,0,250)
					if GetGlobalEntity("Thevip"):Health() >= 75 then
							Vipcolor = Color(0,155,0,250)
						elseif GetGlobalEntity("Thevip"):Health() >= 51 and GetGlobalEntity("Thevip"):Health() <= 74 then
							Vipcolor = Color(155,155,0,250)
						elseif GetGlobalEntity("Thevip"):Health() >= 20 and GetGlobalEntity("Thevip"):Health() <= 50 then
							Vipcolor = Color(155,100,0,250)
						elseif GetGlobalEntity("Thevip"):Health() <= 19 then
							Vipcolor = Color(155,0,0,250)
						end
					local min,max,cen = GetGlobalEntity("Thevip"):LocalToWorld(GetGlobalEntity("Thevip"):OBBMins()), GetGlobalEntity("Thevip"):LocalToWorld(GetGlobalEntity("Thevip"):OBBMaxs()), GetGlobalEntity("Thevip"):LocalToWorld(GetGlobalEntity("Thevip"):OBBCenter())
					local minl,maxl,cenp = min:Distance(cen), max:Distance(cen), cen:ToScreen()
					local minp = (cen + (ply:GetRight() * (-1 * minl)) + (ply:GetUp() * (-1 * minl))):ToScreen()
					local maxp = (cen + (ply:GetRight() * maxl) + (ply:GetUp() * maxl)):ToScreen()
					if not cenp.visible then
						DrawTime = nil
					return end
					surface.SetDrawColor(Vipcolor)
					surface.DrawLine(minp.x,maxp.y,maxp.x,maxp.y)
					surface.DrawLine(minp.x,maxp.y,minp.x,minp.y)
					surface.DrawLine(minp.x,minp.y,maxp.x,minp.y)
					surface.DrawLine(maxp.x,maxp.y,maxp.x,minp.y)
					surface.SetDrawColor(255,255,255,155)
					surface.SetTextPos(minp.x+2,maxp.y-15)
					local text = "Protect This Player"
					surface.SetFont("DefaultSmall")
					surface.DrawText(text)
					surface.SetDrawColor(255,255,255,255)
					surface.SetTextPos(minp.x+2,maxp.y-15)
					surface.SetFont("Default")
					surface.DrawText(text)
				elseif ply == GetGlobalEntity("Thevip") && GetGlobalEntity("Thevip"):Team() == TEAM_HUNK then
					surface.SetFont("Trebuchet18o")
					local textx,texty = surface.GetTextSize("You are the Vip")
					draw.SimpleText("You are the Vip","Trebuchet18o",SW/2 - textx/2,SH - SH + 60,Color(255,255,255,255),0,0)
					DrawIcon(surface.GetTextureID("gui/silkicons/star" ),SW/2 - 8, SH - SH + 36 ,16,16)
				end
			end
		end,
		}

	GM.Gamemode["Mercenaries"] = {
		Condition = function()
			if team.NumPlayers(TEAM_HUNK) <= 1 then
				return false
			end
			return true
		end,

		PrepFunction = function()
			GAMEMODE:BaseStart()
		end,


		StartFunction = function()
			GAMEMODE.Zombies = {
			"snpc_zombie",
			"snpc_zombie_crimzon",
			"snpc_zombie_crimzon",
			"snpc_zombie_crimzon",
			"snpc_zombie_crimzon",
			"snpc_zombie_crimzon",
			"snpc_zombie_crimzon",
			"snpc_zombie_crimzon",
			}
			SetGlobalInt("Re2_CountDown", 180)
			timer.Create("Re2_CountDownMercenaries",1,0, function()
						SetGlobalInt("RE2_GameTime", GetGlobalInt("RE2_GameTime") + 1)
						SetGlobalInt("Re2_CountDown", GetGlobalInt("Re2_CountDown") - 1)
						if GetGlobalInt("Re2_CountDown") <= 0 then
							timer.Destroy("Re2_CountDownMercenaries")
							GAMEMODE:BaseEndGame()
							end
						end)
			end,

		CheckFunction = function()
			if team.NumPlayers(TEAM_HUNK) <= 0 then
				GAMEMODE:BaseEndGame()
				return
			end
		end,

		EndFunction = function()
			timer.Destroy("Re2_CountDownMercenaries")
		end,

		DifficultyFunction = function()
			if !GetGlobalBool("Re2_Classic") then
				GAMEMODE.ZombieDatafast = GAMEMODE.ZombieDatafast + 1
				//table.insert(GAMEMODE.ZombieData.Zombies,"snpc_zombie_crimzon")
			end
		end,

		RewardFunction = function()
			local leader = table.Random(player.GetAll())
			for _,ply in pairs(player.GetAll()) do
				if ply:GetNWInt("killcount") >= leader:GetNWInt("killcount")  && ply != leader then
					leader = ply
				end
					if ply:Team() == TEAM_HUNK then
						ply:SetNWBool("Infected", false)
						ply:SetNWInt("InfectedPercent", 0)

						ply:DeathReward()

					end
			end
			local reward = table.Count(player.GetAll())*250
			reward = reward * GAMEMODE.ZombieData[GetGlobalString("Re2_Difficulty")].Modifier
			PrintMessage( HUD_PRINTTALK, leader:Nick().." won "..reward.." for getting the most kills. Well done!" )
			leader:SetNWInt("Money", leader:GetNWInt("Money") + (math.Round(table.Count(player.GetAll())*350)))
		end,
		}

	GM.Gamemode["Boss"] = {
		Condition = function()
			if team.NumPlayers(TEAM_HUNK) <= 0 then
				return false
			end
			return true
		end,

		PrepFunction = function()
			SetGlobalString( "Mode", "prep" )
			GAMEMODE:SelectMusic(GetGlobalString("Mode"))

			SetGlobalInt("Re2_CountDown", 60)
			timer.Create("Re2_CountDowntimer_Boss",1,0, function()
			SetGlobalInt("Re2_CountDown", GetGlobalInt("Re2_CountDown") - 1)
				if GetGlobalInt("Re2_CountDown") <= 0 then
					GAMEMODE:BaseStart()
					timer.Destroy("Re2_CountDowntimer_Boss")
				end
			end	)
		end,


		StartFunction = function()
			SetGlobalInt("RE2_DeadZombies",GetGlobalInt("RE2_DeadZombies") + 1)
            PrintMessage(HUD_PRINTTALK,"Boss has appeared...KILL HIM!")
            local Zombie = {
				"snpc_zombie_nemesis",
				"snpc_zombie_king",}

            local ent = ents.Create(table.Random(Zombie))
            ent:SetPos(table.Random(ents.FindByClass("ent_zombie_spawn")):GetPos())
            ent:Spawn()
			local min = (table.Count(player.GetAll()) + GAMEMODE.ZombieData[GetGlobalString("Re2_Difficulty")].Modifier * 5.0)*1700
			local max = (table.Count(player.GetAll()) + GAMEMODE.ZombieData[GetGlobalString("Re2_Difficulty")].Modifier * 7.5)*2300
			ent:SetHealth(math.random(min, max))
			SetGlobalInt("Re2_CountDown", 600)
			timer.Create("Re2_CountDownMercenaries",1,0, function()
						SetGlobalInt("RE2_GameTime", GetGlobalInt("RE2_GameTime") + 1)
						SetGlobalInt("Re2_CountDown", GetGlobalInt("Re2_CountDown") - 1)
						if GetGlobalInt("Re2_CountDown") <= 0 then
							timer.Destroy("Re2_CountDownMercenaries")
							GAMEMODE:BaseEndGame()
						end
						if (GetGlobalString("RE2_Game") == "Boss") && GetGlobalInt("RE2_DeadZombies") >= 2 then
							timer.Destroy("Re2_CountDownMercenaries")
							GAMEMODE:BaseEndGame()
						end
						end)
			end,

		CheckFunction = function()
			if team.NumPlayers(TEAM_HUNK) <= 0 then
				GAMEMODE:BaseEndGame()
				return
			end
		end,

		EndFunction = function()
			timer.Destroy("Re2_CountDownMercenaries")
		end,

		DifficultyFunction = function()
			if !GetGlobalBool("Re2_Classic") then
				GAMEMODE.ZombieDatafast = GAMEMODE.ZombieDatafast + 1
				//table.insert(GAMEMODE.ZombieData.Zombies,"snpc_zombie_crimzon")
			end
		end,

		RewardFunction = function()
			local reward = math.Round((table.Count(player.GetAll())*GAMEMODE.ZombieData[GetGlobalString("Re2_Difficulty")].Modifier*400) / (1 + ((table.Count(player.GetAll())) / (6 + (table.Count(player.GetAll())/2) / table.Count(player.GetAll())))))
			if (GetGlobalString("RE2_Game") == "Boss") && GetGlobalInt("RE2_DeadZombies") == 2 then
				PrintMessage( HUD_PRINTTALK, "Players killed nemesis, $"..reward.." to everyone" )
				for k,v in pairs(player.GetAll()) do
					v:SetNWInt("Money",v:GetNWInt("Money",0)+reward)
				end
			else
				PrintMessage( HUD_PRINTTALK, "Players did not kill the Boss, no cash earned" )
			end
			end,
		}

	GM.Gamemode["Escape"] = {
		PrepFunction = function()
			GAMEMODE:BaseStart()
		end,

		StartFunction = function()
		timer.Create("TimeSurvivedTimer",1,0, function()
			SetGlobalInt("RE2_GameTime", GetGlobalInt("RE2_GameTime") + 1)
				for _,ply in pairs(team.GetPlayers(TEAM_HUNK)) do
					ply:SetNWInt("Time",ply:GetNWInt("Time") + 1 )
				end
			end)

		end,

		CheckFunction = function()
			if team.NumPlayers(TEAM_HUNK) <= 0 then
				GAMEMODE:BaseEndGame()
				return
			end
		end,

		EndFunction = function()

		end,
		DifficultyFunction = function()
			if !GetGlobalBool("Re2_Classic") then
				GAMEMODE.ZombieDatafast = GAMEMODE.ZombieDatafast + 1
				//table.insert(GAMEMODE.ZombieData.Zombies,"snpc_zombie_crimzon")
			end
		end,
		RewardFunction = function()
				if table.Count(team.GetPlayers(TEAM_HUNK)) > 0 then
				local reward = math.Round(GAMEMODE.MapListTable[game.GetMap()].Escape.Reward)
				if GAMEMODE.MapListTable[game.GetMap()].Escape.Split then
					reward = math.Round(GAMEMODE.MapListTable[game.GetMap()].Escape.Reward/#player.GetAll())
				end
				reward = reward * GAMEMODE.ZombieData[GetGlobalString("Re2_Difficulty")].Modifier
				PrintMessage( HUD_PRINTTALK, "You Have Escaped! Surviving players won $"..reward.." for staying alive. Well done!" )
				if team.NumPlayers(TEAM_HUNK) > 1 then
					local additionalreward = math.Round((GAMEMODE.MapListTable[game.GetMap()].Escape.Reward/#player.GetAll())/team.NumPlayers(TEAM_HUNK)) * GAMEMODE.ZombieData[GetGlobalString("Re2_Difficulty")].Modifier
					PrintMessage( HUD_PRINTTALK, team.NumPlayers(TEAM_HUNK).." out of "..#player.GetAll().." survivors survived, every survivor gets a bonus of $"..additionalreward.." for team-work!" )
				end
				for _,ply in pairs(player.GetAll()) do
					if ply:Team() == TEAM_HUNK then
						ply:SetNWBool("Infected", false)
						ply:SetNWInt("InfectedPercent", 0)

						ply:DeathReward()
						if team.NumPlayers(TEAM_HUNK) > 1 then
							additionalreward = math.Round((reward/#player.GetAll())/team.NumPlayers(TEAM_HUNK))
							ply:SetNWInt("Money",math.Round(ply:GetNWInt("Money")+ reward + additionalreward))
						else
							ply:SetNWInt("Money",math.Round(ply:GetNWInt("Money")+ reward ))
						end

					end
				end
			end
		end,
		}

	GM.Gamemode["Team_VIP"] = {
		Name = "Team VIP",
		Teams = true,
		Condition = function()
			if team.NumPlayers(TEAM_HUNK) <= 1 then
				return false
			end
			return true
		end,

		JoinFunction = function(ply)
			if GetGlobalString("Mode") != "Merchant" then
				if #Re2_Teams.StarsTeam <= #Re2_Teams.UmbrellaTeam then
					ply:SetNWInt("TeamId",1)
					table.insert(Re2_Teams.StarsTeam,ply)
				elseif #Re2_Teams.UmbrellaTeam <= #Re2_Teams.StarsTeam then
					ply:SetNWInt("TeamId",2)
					table.insert(Re2_Teams.StarsTeam,ply)
				end
			end
		end,

		DisconnectFunction = function(ply)
			if GetGlobalString("Mode") != "End" then
			if ply:GetNWInt("TeamId") == 1 then
				for key,data in pairs(Re2_Teams.StarsTeam) do
					if data == ply then
						table.remove(Re2_Teams.StarsTeam,key)
						break
					end
				end
			elseif ply:GetNWInt("TeamId") == 2 then
				for key,data in pairs(Re2_Teams.UmbrellaTeam) do
					if data == ply then
						table.remove(Re2_Teams.UmbrellaTeam,key)
						break
					end
				end
			end
				if GetGlobalEntity("Team01_VIP") == ply then
					local VIP = table.Random(Re2_Teams.StarsTeam)
					SetGlobalEntity( "Team01_VIP", VIP  )
					VIP:Give("weapon_physcannon")
				elseif GetGlobalEntity("Team02_VIP") == ply then
					local VIP = table.Random(Re2_Teams.UmbrellaTeam)
					SetGlobalEntity( "Team01_VIP", VIP  )
					VIP:Give("weapon_physcannon")
				end
			end
		end,

		PrepFunction = function()

			SetGlobalString( "Mode", "prep" )
			GAMEMODE:SelectMusic(GetGlobalString("Mode"))

			SetGlobalInt("Re2_CountDown", GAMEMODE.ZombieData[GetGlobalString("Re2_Difficulty")].StartTime)

			Re2_Teams = {StarsTeam = {},UmbrellaTeam = {} }

			local SelectablePlayers = team.GetPlayers(TEAM_HUNK)

			for _,player in pairs(team.GetPlayers(TEAM_HUNK)) do
				if #Re2_Teams.UmbrellaTeam < #Re2_Teams.StarsTeam then
					local playa = table.Random(SelectablePlayers)
					playa:SetNWInt("TeamId",2)
					table.insert(Re2_Teams.UmbrellaTeam,playa)
					for key,data in pairs(SelectablePlayers) do
						if data == playa then
							table.remove(SelectablePlayers,key)
							break
						end
					end
				elseif #Re2_Teams.StarsTeam < math.Round(#team.GetPlayers(TEAM_HUNK)/2) then
					local plya = table.Random(SelectablePlayers)
					plya:SetNWInt("TeamId",1)
					table.insert(Re2_Teams.StarsTeam,plya)
					for key,data in pairs(SelectablePlayers) do
						if data == plya then
							table.remove(SelectablePlayers,key)
							break
						end
					end
				end
			end

			------------------Choose Vip
			PrintTable(Re2_Teams.StarsTeam)

			local VIP = table.Random(Re2_Teams.StarsTeam)
			SetGlobalEntity( "Team01_VIP", VIP  )
			VIP:Give("weapon_physcannon")

			PrintTable(Re2_Teams.UmbrellaTeam)

			local VIP1 = table.Random(Re2_Teams.UmbrellaTeam)
			SetGlobalEntity( "Team02_VIP", VIP1  )
			VIP1:Give("weapon_physcannon")

			timer.Create("Re2_CountDowntimer_Vip",1,0, function()
			SetGlobalInt("Re2_CountDown", GetGlobalInt("Re2_CountDown") - 1)
				if GetGlobalInt("Re2_CountDown") <= 0 then

					GAMEMODE:BaseStart()
					timer.Destroy("Re2_CountDowntimer_Vip")
				end

			end
			)
		end,

		StartFunction = function()
		SetGlobalInt("Re2_CountDown", 300 + (table.Count(team.GetPlayers(TEAM_HUNK)) * 60) )

		---------------------Set the Re2_CountDown
				timer.Create("Re2_CountDown_TEAMVIP",1,0, function()

						SetGlobalInt("RE2_GameTime", GetGlobalInt("RE2_GameTime") + 1)
						SetGlobalInt("Re2_CountDown", GetGlobalInt("Re2_CountDown") - 1)
							for _,ply in pairs(team.GetPlayers(TEAM_HUNK)) do
								ply:SetNWInt("Time",ply:GetNWInt("Time") + 1 )
							end
							if GetGlobalInt("Re2_CountDown") <= 0 then
								timer.Destroy("Re2_CountDown_TEAMVIP")
								GAMEMODE:BaseEndGame()
							end
					end)

		end,

		CheckFunction = function()
					if GetGlobalEntity("Team01_VIP"):Team() != TEAM_HUNK  || GetGlobalEntity("Team02_VIP"):Team() != TEAM_HUNK then
						GAMEMODE:BaseEndGame()
						return
					end
		end,

		EndFunction = function()
				for _,ply in pairs(player.GetAll()) do
					if ply:Team() == TEAM_HUNK then
						ply:SetNWBool("Infected", false)
						ply:SetNWInt("InfectedPercent", 0)

						ply:DeathReward()

					end
				end

				local Starskills = 0
				local Umbrellakills = 0

				if GetGlobalEntity("Team01_VIP"):Team() != TEAM_HUNK && GetGlobalEntity("Team02_VIP"):Team() == TEAM_HUNK then
					SetGlobalString("Re2_TEAMVIP_Winner","Umbrella")
				elseif GetGlobalEntity("Team02_VIP"):Team() != TEAM_HUNK && GetGlobalEntity("Team01_VIP"):Team() == TEAM_HUNK then
					SetGlobalString("Re2_TEAMVIP_Winner","S.T.A.R.S")
				elseif GetGlobalEntity("Team01_VIP"):Team() == TEAM_HUNK && GetGlobalEntity("Team02_VIP"):Team() == TEAM_HUNK && GetGlobalEntity("Team01_VIP"):Health() > GetGlobalEntity("Team02_VIP"):Health() then
					SetGlobalString("Re2_TEAMVIP_Winner","S.T.A.R.S")
				elseif GetGlobalEntity("Team02_VIP"):Team() == TEAM_HUNK && GetGlobalEntity("Team01_VIP"):Team() == TEAM_HUNK && GetGlobalEntity("Team02_VIP"):Health() >= GetGlobalEntity("Team01_VIP"):Health() then
					SetGlobalString("Re2_TEAMVIP_Winner","Umbrella")
				else
					SetGlobalString("Re2_TEAMVIP_Winner","Umbrella")
				end
			timer.Destroy("Re2_CountDowntimer")
		end,

		DifficultyFunction = function()
			if !GetGlobalBool("Re2_Classic") then
				GAMEMODE.ZombieDatafast = GAMEMODE.ZombieDatafast + 1
				//table.insert(GAMEMODE.ZombieData.Zombies,"snpc_zombie_crimzon")
			end
		end,

		RewardFunction = function()

			local reward = math.Round((GetGlobalInt("RE2_DeadZombies") + #player.GetAll() * 60 + 300)  /2)
			reward = reward * GAMEMODE.ZombieData[GetGlobalString("Re2_Difficulty")].Modifier
			for _,ply  in pairs(player.GetAll()) do
				if ply:GetNWInt("TeamId") == 1 && GetGlobalString("Re2_TEAMVIP_Winner") == "S.T.A.R.S" then
					ply:SetNWInt("Money",math.Round(ply:GetNWInt("Money")+ reward))
				elseif ply:GetNWInt("TeamId") == 2 && GetGlobalString("Re2_TEAMVIP_Winner") == "Umbrella" then
					ply:SetNWInt("Money",math.Round(ply:GetNWInt("Money")+ reward))
				end
			end
			PrintMessage( HUD_PRINTTALK, "The "..GetGlobalString("Re2_TEAMVIP_Winner").." Team Won! They are awarded $"..reward.." each. Fine Work!" )
		end,

		HudFunction = function(ply)
				if SERVER then return end
				local SW = ScrW()
				local SH = ScrH()
				local client = LocalPlayer()
				if GetGlobalString("Mode") == "Merchant" then return end

				for _,ply in pairs(team.GetPlayers(TEAM_HUNK)) do
					if ply:GetNWInt("TeamId") == 1 && LocalPlayer() != ply && ply:GetPos():Distance(LocalPlayer():GetPos()) <= 400 then
						local pos = ply:LocalToWorld(ply:OBBCenter() + Vector(0,0,40)):ToScreen()
						DrawIcon(surface.GetTextureID("re2_teams/stars"),pos.x,pos.y,48,48 )
					elseif  ply:GetNWInt("TeamId") == 2 && LocalPlayer() != ply && ply:GetPos():Distance(LocalPlayer():GetPos()) <= 400 then
						local pos = ply:LocalToWorld(ply:OBBCenter() + Vector(0,0,40)):ToScreen()
						DrawIcon(surface.GetTextureID("re2_teams/umbrella"),pos.x,pos.y,48,48 )
					end
				end

				if GetGlobalString("Mode") == "End" then
					if GetGlobalString("Re2_TEAMVIP_Winner") == "Umbrella" then
						DrawIcon(surface.GetTextureID("re2_teams/umbrella" ),SW/2 - 150, SH/2 - 150 ,300,300)
						draw.SimpleText("Umbrella Wins","Trebuchet18o",SW/2 ,SH/2 + 150 + 10,Color(255,255,255,255),1,0)
					elseif GetGlobalString("Re2_TEAMVIP_Winner") == "S.T.A.R.S" then
						DrawIcon(surface.GetTextureID("re2_teams/stars" ),SW/2 - 123, SH/2 - 144 ,246,288)
						draw.SimpleText("S.T.A.R.S Wins","Trebuchet18o",SW/2,SH/2 + 144 + 10,Color(255,255,255,255),1,0)
					end
				end

				if ply:GetNWInt("TeamId") == 1 then
					DrawIcon(surface.GetTextureID("re2_teams/stars" ),SW/2 - 16, SH - SH + 28 ,32,32)
					if ply != GetGlobalEntity("Team01_VIP") && GetGlobalEntity("Team01_VIP"):Team() == TEAM_HUNK then
						local Vipcolor = Color(0,155,0,250)
						if GetGlobalEntity("Team01_VIP"):Health() >= 75 then
								Vipcolor = Color(0,155,0,250)
							elseif GetGlobalEntity("Team01_VIP"):Health() >= 51 and GetGlobalEntity("Team01_VIP"):Health() <= 74 then
								Vipcolor = Color(155,155,0,250)
							elseif GetGlobalEntity("Team01_VIP"):Health() >= 20 and GetGlobalEntity("Team01_VIP"):Health() <= 50 then
								Vipcolor = Color(155,100,0,250)
							elseif GetGlobalEntity("Team01_VIP"):Health() <= 19 then
								Vipcolor = Color(155,0,0,250)
							end
						local min,max,cen = GetGlobalEntity("Team01_VIP"):LocalToWorld(GetGlobalEntity("Team01_VIP"):OBBMins()), GetGlobalEntity("Team01_VIP"):LocalToWorld(GetGlobalEntity("Team01_VIP"):OBBMaxs()), GetGlobalEntity("Team01_VIP"):LocalToWorld(GetGlobalEntity("Team01_VIP"):OBBCenter())
						local minl,maxl,cenp = min:Distance(cen), max:Distance(cen), cen:ToScreen()
						local minp = (cen + (ply:GetRight() * (-1 * minl)) + (ply:GetUp() * (-1 * minl))):ToScreen()
						local maxp = (cen + (ply:GetRight() * maxl) + (ply:GetUp() * maxl)):ToScreen()
						if not cenp.visible then
							DrawTime = nil
						return end
						surface.SetDrawColor(Vipcolor)
						surface.DrawLine(minp.x,maxp.y,maxp.x,maxp.y)
						surface.DrawLine(minp.x,maxp.y,minp.x,minp.y)
						surface.DrawLine(minp.x,minp.y,maxp.x,minp.y)
						surface.DrawLine(maxp.x,maxp.y,maxp.x,minp.y)
						surface.SetDrawColor(255,255,255,155)
						surface.SetTextPos(minp.x+2,maxp.y-15)
						local text = "Protect This Player"
						surface.SetFont("DefaultSmall")
						surface.DrawText(text)
						surface.SetDrawColor(255,255,255,255)
						surface.SetTextPos(minp.x+2,maxp.y-15)
						surface.SetFont("Default")
						surface.DrawText(text)
					elseif ply == GetGlobalEntity("Team01_VIP") && GetGlobalEntity("Team01_VIP"):Team() == TEAM_HUNK then
						surface.SetFont("Trebuchet18o")
						local textx,texty = surface.GetTextSize("You are the Vip")
						draw.SimpleText("You are the Vip","Trebuchet18o",SW/2 - textx/2,SH - SH + 60,Color(255,255,255,255),0,0)
					end
				elseif ply:GetNWInt("TeamId") == 2 then
					DrawIcon(surface.GetTextureID("re2_teams/umbrella" ),SW/2 - 16, SH - SH + 28 ,32,32)
					if ply != GetGlobalEntity("Team02_VIP") && GetGlobalEntity("Team02_VIP"):Team() == TEAM_HUNK then
						DrawIcon(surface.GetTextureID("re2_teams/umbrella"),SW/2 - 16, SH - SH + 28 ,32,32)
						local Vipcolor = Color(0,155,0,250)
							if GetGlobalEntity("Team02_VIP"):Health() >= 75 then
								Vipcolor = Color(0,155,0,250)
							elseif GetGlobalEntity("Team02_VIP"):Health() >= 51 and GetGlobalEntity("Team02_VIP"):Health() <= 74 then
								Vipcolor = Color(155,155,0,250)
							elseif GetGlobalEntity("Team02_VIP"):Health() >= 20 and GetGlobalEntity("Team02_VIP"):Health() <= 50 then
								Vipcolor = Color(155,100,0,250)
							elseif GetGlobalEntity("Team02_VIP"):Health() <= 19 then
								Vipcolor = Color(155,0,0,250)
							end
						local min,max,cen = GetGlobalEntity("Team02_VIP"):LocalToWorld(GetGlobalEntity("Team02_VIP"):OBBMins()), GetGlobalEntity("Team02_VIP"):LocalToWorld(GetGlobalEntity("Team02_VIP"):OBBMaxs()), GetGlobalEntity("Team02_VIP"):LocalToWorld(GetGlobalEntity("Team02_VIP"):OBBCenter())
						local minl,maxl,cenp = min:Distance(cen), max:Distance(cen), cen:ToScreen()
						local minp = (cen + (ply:GetRight() * (-1 * minl)) + (ply:GetUp() * (-1 * minl))):ToScreen()
						local maxp = (cen + (ply:GetRight() * maxl) + (ply:GetUp() * maxl)):ToScreen()
						if not cenp.visible then
							DrawTime = nil
						return end
						surface.SetDrawColor(Vipcolor)
						surface.DrawLine(minp.x,maxp.y,maxp.x,maxp.y)
						surface.DrawLine(minp.x,maxp.y,minp.x,minp.y)
						surface.DrawLine(minp.x,minp.y,maxp.x,minp.y)
						surface.DrawLine(maxp.x,maxp.y,maxp.x,minp.y)
						surface.SetDrawColor(255,255,255,155)
						surface.SetTextPos(minp.x+2,maxp.y-15)
						local text = "Protect This Player"
						surface.SetFont("DefaultSmall")
						surface.DrawText(text)
						surface.SetDrawColor(255,255,255,255)
						surface.SetTextPos(minp.x+2,maxp.y-15)
						surface.SetFont("Default")
						surface.DrawText(text)
					elseif ply == GetGlobalEntity("Team02_VIP") && GetGlobalEntity("Team02_VIP"):Team() == TEAM_HUNK then
						surface.SetFont("Trebuchet18o")
						local textx,texty = surface.GetTextSize("You are the Vip")
						draw.SimpleText("You are the Vip","Trebuchet18o",SW/2 - textx/2,SH - SH + 60,Color(255,255,255,255),0,0)
					end
				end
			end,
		}
