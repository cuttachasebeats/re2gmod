include("shared.lua")
--include("derma/cl_chests.lua")
include("derma/cl_hud.lua")
--include("derma/cl_inventory.lua")
--include("derma/cl_shop.lua")
--include("derma/cl_voting.lua")
--include("derma/items/itemgui.lua")
include("functions/cl_networking.lua")
include("libraries/derma/derma_lib.lua")
include("modules/itemsetup/items.lua")
include("modules/music/cl_music.lua")
include("modules/weaponsetup/weapons.lua")
include("modules/modes/gamemodes.lua")
include("modules/music/cl_music.lua")

include("config.lua")

include("includes/derma_include.lua")
include("derma/admin/cl_admin.lua")
include("derma/chests/cl_chests.lua")
include("derma/inventory/cl_inventory.lua")
include("derma/items/cl_items.lua")
include("derma/main/derma_main.lua")
include("derma/scoreboard/cl_scoreboard.lua")
include("derma/skills/cl_skills.lua")
include("derma/store/cl_store.lua")
include("derma/voting/cl_voting.lua")
include("derma/upgrades/cl_upgrades.lua")
include("libraries/derma/fonts.lua")

function TableRandom(tablename) return tablename[math.random(1,table.Count(tablename))] end

function GM:Initialize()

--- Variables

	bool_InvOpen = false
	bool_itemDisplay = false
	bool_IconOptions = false
	bool_IsUpging = false
	string_CurUpgItem = ""
	bool_CanClose = true
	bool_Chating = false
	
Inventory = {
	{Item = "none", Amount = 0},
	{Item = "none", Amount = 0},
	{Item = "none", Amount = 0},
	{Item = "none", Amount = 0},
	{Item = "none", Amount = 0},
	{Item = "none", Amount = 0},	}
Chest = {
	{Weapon = "none", Upgrades = {pwrlvl = 1, acclvl = 1, clplvl = 1, fislvl = 1,reslvl = 1}},
	{Weapon = "none", Upgrades = {pwrlvl = 1, acclvl = 1, clplvl = 1, fislvl = 1,reslvl = 1}},
	{Weapon = "none", Upgrades = {pwrlvl = 1, acclvl = 1, clplvl = 1, fislvl = 1,reslvl = 1}},
	{Weapon = "none", Upgrades = {pwrlvl = 1, acclvl = 1, clplvl = 1, fislvl = 1,reslvl = 1}},
	{Weapon = "none", Upgrades = {pwrlvl = 1, acclvl = 1, clplvl = 1, fislvl = 1,reslvl = 1}},}
Upgrades = {}
ActivePerks = {0,0}
Perks = {}
IsPerking = false


	local FilePath = "re2/music.txt"

	if file.Exists(FilePath, "DATA") then

	local tempcross = util.KeyValuesToTable(file.Read(FilePath))
		tempcross["Music"] = tonumber(file.Read(FilePath))

	else
	  print("Music Not Loaded ")
	end
	Invframe = nil
	justjoined = false

	timer.Simple(15,function() Sound_Create(GetGlobalString("Music")) end)
end
