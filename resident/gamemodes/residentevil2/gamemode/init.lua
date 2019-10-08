

resource.AddWorkshop("536391334") -- Resident Evil Garrysmod 2 : Content
resource.AddWorkshop("401749452") -- ZombieDogAddon
resource.AddWorkshop("710135237") -- ResidentEvil2 FX
resource.AddWorkshop("531432505") -- remapscustom
resource.AddWorkshop("548706398") -- Nemesis Playermodel FIXED
resource.AddWorkshop("458351576") -- RE6 Lepotitsa Mod
resource.AddWorkshop("407279258") -- RE4 Regenerator and Iron Maiden Mod
resource.AddWorkshop("626604673") -- Automatic Workshop Download
resource.AddWorkshop("150332042") -- Resident Evil REmake weapons
resource.AddWorkshop("1477916884") -- RE2 Alleys
resource.AddWorkshop("1502859898") -- RE2_ThePark
resource.AddWorkshop("299164995") -- [OLD] Call Of Duty: Black Ops II Weapons Pack
resource.AddWorkshop("1575698656") -- Infected Citizens (Nextbot 3.0)
resource.AddWorkshop("1551750003") -- NEXTBOTS 3.0: Zombies, Humans, SWEPs
resource.AddWorkshop("415143062") -- TFA Base [ Reduxed ]
resource.AddWorkshop("757604550") -- [wOS] Animation Extension - Base
resource.AddWorkshop("1788282418") -- RE4 Merchant SFX

function GM:Initialize()
	SetGlobalString( "Mode", "Merchant" )
	isInRound = false
	timer.Simple(5, function() GAMEMODE:UpdateMap() end)

	GAMEMODE.int_DifficultyLevel = 1
	GAMEMODE.int_NumZombies = 0
	GAMEMODE.TEMP_DeadPlayers = {}
	NumZombies = 0
	GAMEMODE.VotingMaps = {}
	GAMEMODE.VotingGamemodes = {}
	GAMEMODE.VotingCrows = {Votes = 0,Value = 0}
	GAMEMODE.VotingClassic = {Votes = 0,Value = 0}
	GAMEMODE.VotingDifficulty = {}
	GAMEMODE.VotingMerchantTime = {}
	GAMEMODE.VotingMerchantTime[180] = 0
	GAMEMODE.VotingMerchantTime[120] = 0
	GAMEMODE.VotingMerchantTime[60] = 0

	for k,v in pairs(GAMEMODE.Gamemode) do
		GAMEMODE.VotingGamemodes[tostring(k)] = 0
	end
	for k,v in pairs(GAMEMODE.MapListTable) do
		GAMEMODE.VotingMaps[k] = 0
	end
	for k,v in pairs(GAMEMODE.ZombieData) do
		GAMEMODE.VotingDifficulty[k] = 0
	end

	GAMEMODE.Int_Ragdolls = 0
	GAMEMODE.Int_SpawnCounter = 0

	SetGlobalString( "Music", "/reg/BattleGame.mp3")

	timer.Create("Re2_DifficultyTimer",60,0,function() GAMEMODE:GamemodeDifficulty() end )

	GAMEMODE:BasePrep()

	SetGlobalInt("RE2_GameTime", 0)
	SetGlobalInt("RE2_DeadZombies", 0)
end

if SERVER then
	util.AddNetworkString( "InvTransfer" )
	util.AddNetworkString( "VoteTransfer" )
	util.AddNetworkString( "RE2_UpdateSlot" )
	util.AddNetworkString( "RE2_UpdateWeaponStat" )
	util.AddNetworkString( "RE2_UpdateChestSlot" )
	util.AddNetworkString( "PerkTransfer" )
end

--Core
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("config.lua")
include("shared.lua")
include("config.lua")

--Multi-language
AddCSLuaFile( "translate.lua" )


--Derma
--AddCSLuaFile("derma/cl_chests.lua")
AddCSLuaFile("derma/cl_hud.lua")
--AddCSLuaFile("derma/cl_inventory.lua")
--AddCSLuaFile("derma/cl_shop.lua")
--AddCSLuaFile("derma/cl_voting.lua")
AddCSLuaFile("derma/scoreboard/cl_scoreboard.lua")
--AddCSLuaFile("derma/items/itemgui.lua")

AddCSLuaFile("includes/derma_include.lua")
AddCSLuaFile("derma/admin/cl_admin.lua")
AddCSLuaFile("derma/chests/cl_chests.lua")
AddCSLuaFile("derma/inventory/cl_inventory.lua")
AddCSLuaFile("derma/items/cl_items.lua")
AddCSLuaFile("derma/main/derma_main.lua")
AddCSLuaFile("derma/scoreboard/cl_scoreboard.lua")
AddCSLuaFile("derma/skills/cl_skills.lua")
AddCSLuaFile("derma/store/cl_store.lua")
AddCSLuaFile("derma/voting/cl_voting.lua")
AddCSLuaFile("derma/upgrades/cl_upgrades.lua")

--Functions
AddCSLuaFile("functions/cl_networking.lua")
include("functions/sv_networking.lua")
include("functions/sv_networkingS.lua")
include("functions/sv_networkingW.lua")
include("functions/sv_networkingC.lua")
include("functions/sv_networkingI.lua")
include("functions/sv_networkingP.lua")
include("functions/derma_functions.lua")
include("functions/admin/sv_admin.lua")

--Hooks
include("functions/hooks/hooks.lua")

--Includes
include("includes/functions_include.lua")
include("includes/derma_include.lua")
include("includes/modules_include.lua")

--Libraries
AddCSLuaFile("libraries/derma/derma_lib.lua")
AddCSLuaFile("libraries/derma/fonts.lua")

--Modules
AddCSLuaFile("modules/music/cl_music.lua")
AddCSLuaFile("modules/modes/gamemodes.lua")
AddCSLuaFile("modules/itemsetup/items.lua")
AddCSLuaFile("modules/weaponsetup/weapons.lua")
include("modules/chest/sv_chests.lua")
include("modules/crows/crows.lua")
include("modules/inventory/sv_inv.lua")
include("modules/item_spawner/itemspawn.lua")
include("modules/itemsetup/items.lua")
include("modules/modes/gamemodes.lua")
include("modules/music/music.lua")
include("modules/npc_spawner/zombiespawn.lua")
include("modules/npc_spawner/zombiedata.lua")
include("modules/perksetup/perk_module.lua")
include("modules/player/sv_player.lua")
include("modules/player/sv_player_ext.lua")
include("modules/player/sv_playeranimations.lua")
include("modules/rounds/round_system.lua")
include("modules/voting/voting.lua")
include("modules/weaponsetup/weapons.lua")
