DeriveGamemode( "base" )

GM.Name = "Resident Evil 2: Garry's Mod"
GM.Author = "Cutta Chase Beats"
GM.Email = ""
GM.Website = ""
GM.TeamBased 	= true

function GM:CreateTeams()
	TEAM_SPECTATOR = 0
	team.SetUp(TEAM_SPECTATOR,"The Unfortunate",Color(90,155,90,120))
	team.SetSpawnPoint(TEAM_SPECTATOR,"info_player_start")

	TEAM_HUNK = 1
	team.SetUp(TEAM_HUNK,"Survivors",Color(155,155,155,120))
	team.SetSpawnPoint(TEAM_HUNK,"info_player_start")
end









-------------------------Music---------------------------------

GM.Music = {
	Safe = {
				{Sound = "/reg/madexperiment.mp3", Length = 121},
				{Sound = "/reg/saveroomcvx.mp3", Length = 115},
				{Sound = "/reg/RE1saveroom.mp3", Length = 165},
				{Sound = "/reg/freefromfear.mp3", Length = 153},
				{Sound = "/reg/the_underground_laboratory.mp3", Length = 150},
				{Sound = "/reg/suspended_doll.mp3", Length = 120},
				{Sound = "/reg/Serenity.mp3", Length = 90},
				{Sound = "/reg/infiltration.mp3", Length = 170},
				{Sound = "/reg/feel_the_tense.mp3", Length = 94},
			},
	Battle = {
				{Sound = "/reg/BattleGame.mp3", Length = 132},
				{Sound = "/reg/RE4merc.mp3", Length = 208},
				{Sound = "/reg/RE5merc.mp3", Length = 202},
				{Sound = "/reg/Malf.mp3", Length = 96},
				{Sound = "/reg/Alexia.mp3", Length = 275},
				{Sound = "/reg/Tofu_01.mp3", Length = 272},
				{Sound = "/reg/RE4hunk.mp3", Length = 160},
				{Sound = "/reg/hellish_agony.mp3", Length = 180},
				{Sound = "/reg/doomed_city.mp3", Length = 145},
			},
	End = {
			{Sound = "/reg/Results_01.mp3", Length = 120},
			{Sound = "/reg/Results_02.mp3", Length = 94},
			{Sound = "/reg/ree_theme.mp3", Length = 125},
			},
	}

GM.MerchantSounds = {
	MerchantWelcome = {
		"/08_whatayabuyin.mp3",
		"/06_goodthingsonsale.mp3",
		"/18_welcome.mp3",
		"/03_rarethingsonsale.mp3",
	},

	MerchantBuy = {
		"/04_isthatall.mp3",
		"/01_thankyou.mp3",
		"/10_ChicagoTypewriter.mp3",
		"/11_MineThrower.mp3",
		"/13_Punisher.mp3",
		"/14_Red9.mp3",
		"/15_BrokenButterfly.mp3",
	},

	MerchantLeave = {
		"/16_comebackanytime.mp3",
	},
	
	MerchantNoCash = {
		"/05_notenoughcash.mp3",
	},

}


---------------------------------------------------------------------














------------------Ammo Maxes------------------------------

GM.AmmoMax = {}
GM.AmmoMax["pistol"] = {number = 150,icon = "gui/ammo/handgun"}
GM.AmmoMax["pistol2"] = {number = 110,icon = "gui/ammo/handgun"}
GM.AmmoMax["ar2"] = {number = 135,icon = "gui/ammo/rifle"}
GM.AmmoMax["357"] = {number = 72,icon = "gui/ammo/357"}
GM.AmmoMax["smg1"] = {number = 200,icon = "gui/ammo/machinegun"}
GM.AmmoMax["none"] = {number = 0,icon = ""}
GM.AmmoMax["buckshot"] = {number = 35,icon = "gui/ammo/buckshot"}
GM.AmmoMax["CombineCannon"] = {number = 7,icon = "gui/ammo/explosive"}
GM.AmmoMax["GaussEnergy"] = {number = 7,icon = "gui/ammo/flame"}
GM.AmmoMax["Battery"] = {number = 7,icon = "gui/ammo/ice"}
GM.AmmoMax["RPG_Round"] = {number = 5,icon = "gui/ammo/rocket"}
GM.AmmoMax["StriderMinigun"] = {number = 400,icon = "gui/ammo/minigun"}

GM.AmmoMax["XBowBolt"] = {number = 70,icon = "gui/ammo/sniper"}

GM.Ammoref = {}
GM.Ammoref["item_ammo_pistol"] = "pistol"
GM.Ammoref["item_ammo_magnum"] = "357"
GM.Ammoref["item_ammo_rifle"] = "ar2"
GM.Ammoref["item_ammo_smg"] = "smg1"
GM.Ammoref["item_ammo_buckshot"] = "buckshot"
GM.Ammoref["item_ammo_sniper"] = "XBowBolt"
GM.Ammoref["item_ammo_gl_explosive"] = "CombineCannon"
GM.Ammoref["item_ammo_gl_flame"] = "GaussEnergy"
GM.Ammoref["item_ammo_gl_freeze"] = "Battery"
GM.Ammoref["item_ammo_rocket"] = "RPG_Round"

--------------------------------------------------------------


function HoveringNames()
	
	
	
	for _, target in pairs(player.GetAll()) do
		if target:Alive() and target != LocalPlayer() then
		
			local targetPos = target:GetPos() + Vector(0,0,84)
			local tt = target:GetPos() + Vector(0,0,100)
			local targetDistance = math.floor((LocalPlayer():GetPos():Distance( targetPos ))/40)
			local targetScreenpos = targetPos:ToScreen()
			local ttscreen = tt:ToScreen()
			draw.SimpleText(target:Nick(), "Trebuchet18", tonumber(targetScreenpos.x), tonumber(targetScreenpos.y), Color(200,25,25,200), TEXT_ALIGN_CENTER)
			draw.SimpleText(target:Health(), "Trebuchet18", tonumber(targetScreenpos.x), tonumber(ttscreen.y), Color(200,25,25,200), TEXT_ALIGN_CENTER)
			
		end
		if not target:Alive() then end
	end

	for k, v in pairs (ents.GetAll()) do 
		if v:GetClass() == "snpc_zombie_nemesis" then 
			local targetPos = v:GetPos() + Vector(0,0,84)
			local tt = v:GetPos() + Vector(0,0,100)
			local targetDistance = math.floor((LocalPlayer():GetPos():Distance( targetPos ))/40)
			local targetScreenpos = targetPos:ToScreen()
			local ttscreen = tt:ToScreen()
			draw.SimpleText(v:Health(), "Trebuchet18", tonumber(targetScreenpos.x), tonumber(ttscreen.y), Color(255,255,120,100), TEXT_ALIGN_CENTER)
			
		end 
	end 
	
	for k, v in pairs (ents.GetAll()) do 
		if v:GetClass() == "snpc_zombie_jeff" then 
			local targetPos = v:GetPos() + Vector(0,0,84)
			local tt = v:GetPos() + Vector(0,0,100)
			local targetDistance = math.floor((LocalPlayer():GetPos():Distance( targetPos ))/40)
			local targetScreenpos = targetPos:ToScreen()
			local ttscreen = tt:ToScreen()
			draw.SimpleText(v:Health(), "Trebuchet18", tonumber(targetScreenpos.x), tonumber(ttscreen.y), Color(255,255,25,100), TEXT_ALIGN_CENTER)
			
		end 
	end 
	
	for k, v in pairs (ents.GetAll()) do 
		if v:GetClass() == "snpc_zombie_king" then 
			local targetPos = v:GetPos() + Vector(0,0,84)
			local tt = v:GetPos() + Vector(0,0,100)
			local targetDistance = math.floor((LocalPlayer():GetPos():Distance( targetPos ))/40)
			local targetScreenpos = targetPos:ToScreen()
			local ttscreen = tt:ToScreen()
			draw.SimpleText(v:Health(), "Trebuchet18", tonumber(targetScreenpos.x), tonumber(ttscreen.y), Color(255,255,25,100), TEXT_ALIGN_CENTER)
			
		end 
	end 

end
hook.Add("HUDPaint", "HoveringNames", HoveringNames)





----perks-----------------------------


GM.Perks = {}
GM.Perks["perk_health"] = {
	Name = "Health Up",
	Desc = "You're max health increases by %15",
	AddFunction = function(ply) ply:SetNWInt("MaxHp", ply:GetNWInt("MaxHp") + 15) ply:SetHealth(ply:GetNWInt("MaxHp")) end,
	RemoveFunction = function(ply) ply:SetNWInt("MaxHp", ply:GetNWInt("MaxHp") - 15) ply:SetHealth(ply:GetNWInt("MaxHp")) end,
	Active = false,
	Price = 250000,
}
GM.Perks["perk_invslot"] = {
	Name = "+Inventory Slot",
	Desc = "An Extra slot to store items is added.",
	AddFunction = function(ply) table.insert(ply.RE2Data["Inventory"],{Item = 0, Amount = 0})  end,
	RemoveFunction = function(ply) table.remove(ply.RE2Data["Inventory"], ply.RE2Data["Inventory"][table.Count(ply.RE2Data["Inventory"]) + 1]) end,
	Active = false,
	Price = 250000,
}
GM.Perks["perk_speed"] = {
	Name = "Speed Up",
	Desc = "You have a %10 speed increase",
	AddFunction = function(ply) ply:SetNWInt("Speed", ply:GetNWInt("Speed") + 15 ) GAMEMODE:SetPlayerSpeed(ply,ply:GetNWInt("Speed"),ply:GetNWInt("Speed") )   end,
	RemoveFunction = function(ply) ply:SetNWInt("Speed", ply:GetNWInt("Speed") - 15 ) GAMEMODE:SetPlayerSpeed(ply,ply:GetNWInt("Speed"),ply:GetNWInt("Speed") ) end,
	Price = 250000, 
}
GM.Perks["perk_immunity"] = {
	Name = "Immunity",
	Desc = "You Can't become infected",
	AddFunction = function(ply) ply:SetNWInt("Immunity", 101 )    end,
	RemoveFunction = function(ply) ply:SetNWInt("Immunity", 101 ) end,
	Price = 100000, 
}








------------Map List---------------------------------------------
GM.MapListTable = {	}

GM.MapListTable["re2_warehouse"] = {Votable = true,}

--GM.MapListTable["re2_mainhall"] = {Votable = true,}

GM.MapListTable["re2_ambush"] = {Votable = true,}

GM.MapListTable["re2_desperation"] = {Votable = true,}

GM.MapListTable["re2_acrophobia"] = {Votable = true,}

GM.MapListTable["re2_library"] = {Votable = true,}

GM.MapListTable["re2_lab"] = {Votable = true,}

GM.MapListTable["re2_fortress"] = {Votable = true,}

GM.MapListTable["re2_subway"] = {Votable = true,}

GM.MapListTable["re2_lodge"] = {Votable = true,}

GM.MapListTable["re2_forest_outpost"] = {Votable = true,}

GM.MapListTable["re2_policestation"] = {Votable = true,}

GM.MapListTable["re2_minimall"] = {Votable = true,}

GM.MapListTable["re2_plaza"] = {Votable = true,}

GM.MapListTable["re2_arena"] = {Votable = true,}

GM.MapListTable["re2_forest"] = {Votable = true,}

GM.MapListTable["re2_parkinglot"] = {Votable = true,}

GM.MapListTable["re2_island"] = {Votable = true,}

GM.MapListTable["re2_mall"] = {Votable = true,}

--GM.MapListTable["re2_castle"] = {Votable = true,}

GM.MapListTable["re2_sewer"] = {Votable = true,}

GM.MapListTable["re2_alleys"] = {Votable = true,}

GM.MapListTable["re2_thepark"] = {Votable = true,}

--GM.MapListTable["re2_snowhaven"] = {Votable = true,}

GM.MapListTable["re2_policestation_v2"] = {Votable = true,}

GM.MapListTable["re2_facility"] = {Votable = true,}

GM.MapListTable["re2_platforms"] = {Votable = true, Escape = {Reward = 2000, Split = false},} --- if the map has an escape table then it is an escape map

GM.MapListTable["re2_subway_escape"] = {Votable = true, Escape = {Reward = 10000, Split = true},}

GM.MapListTable["re2_alleys"] = {Votable = true, Boss = {Reward = 5000, Split = true},}

GM.MapListTable["re2_fortress"] = {Votable = true, Mercenaries = {Reward = 2000, Split = false},}

GM.MapListTable["re2_temple_escape"] = {Votable = true, Escape = {Reward = 2000, Split = true},}

GM.MapListTable["re2_creek_escape"] = {Votable = true, Escape = {Reward = 7000, Split = true},}

--GM.MapListTable["re2_skyscraper_escape"] = {Votable = true, Escape = {Reward = 3000, Split = true},}

GM.MapListTable["re2_trainstop_escape"] = {Votable = true, Escape = {Reward = 2000, Split = true},}

GM.MapListTable["re2_office_escape"] = {Votable = true, Escape = {Reward = 2000, Split = true},}

GM.MapListTable["re2_mansion_escape"] = {Votable = true, Escape = {Reward = 8000, Split = true},}

GM.MapListTable["re2_village_escape"] = {Votable = true, Escape = {Reward = 2000, Split = true},}

--GM.MapListTable["re2_expo_escape"] = {Votable = true, Escape = {Reward = 6000, Split = true},}

--GM.MapListTable["re2_claustrophobic_escape"] = {Votable = true, Escape = {Reward = 1000,Split = false},}

--GM.MapListTable["re2_c17_p1_b1"] = {Votable = true, Escape = {Reward = 500,Split = false},}
