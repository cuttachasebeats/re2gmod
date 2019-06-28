/*---------------------------------------------------------------------------
	Perks - these are unlockables you get by achieving certain levels, you can set it to unlock jobs, unlock entities,
	give a one time cash bonus, increase health and a lot more as long as you know the very basics of lua or follow
	the examples below.

	--first template
	local perk = {}
	perk.name = "[name]"
	perk.descripion = "[description]"
	perk.icon = "[icon.png]"
	perk.level = 0 --level required to use
	perk.useCost = 0 --only works for active perks, takes exp on usage
	perk.restriction = function( ply ) return true end --this gets executed before below functions are, to prevent some exploits
	perk.passive = function( ply ) end	--this function will be executed on player spawn
	perk.active = function( ply ) end	--this function will be executed on player usage of perk
	perk.event = function( ply ) end	--this function will be executed once, on level up
	levelup.config.addPerk( perk )

	--second template
	local perk = 
	{
		name = ""
		description = ""
		icon = ""
		level = 0
		perk.useCost = 0
		restriction = function( ply ) return true end
		passive = function( ply ) end
		active = function( ply ) end
		event = function( ply ) end
	}
---------------------------------------------------------------------------*/
levelup.perks = {}

local perk = {}
perk.name = "First PayCheck!"
perk.description = "Gives you 500 dollars"
perk.icon = "coins_add.png"
perk.level = 2
perk.restriction = function( ply ) return ply:Team() == TEAM_HUNK end
perk.event = function( ply ) ply:SetNWInt("Money",math.Round(ply:GetNWInt("Money")+ 500)) end
levelup.config.addPerk( perk )

local perk = {}
perk.name = "LightWeight"
perk.description = "Jump Higher!"
perk.icon = "arrow_up.png"
perk.level = 3
perk.restriction = function( ply ) return ply:Team() == TEAM_HUNK end
perk.passive = function( ply ) ply:SetJumpPower( 200 ) end
levelup.config.addPerk( perk )

local perk = {}
perk.name = "Small PayCheck"
perk.description = "Get $500 to spend"
perk.icon = "coins_add.png"
perk.level = 5
perk.restriction = function( ply ) return ply:Team() == TEAM_HUNK end
perk.event = function( ply ) ply:SetNWInt("Money",math.Round(ply:GetNWInt("Money")+ 500)) end
levelup.config.addPerk( perk )

local perk = {}
perk.name = "Income"
perk.description = "Get 20$ Each Round"
perk.icon = "money_add.png"
perk.level = 6
perk.restriction = function( ply ) return ply:Team() == TEAM_HUNK end
perk.passive = function( ply ) ply:SetNWInt("Money",math.Round(ply:GetNWInt("Money")+ 20)) end
levelup.config.addPerk( perk )

local perk = {}
perk.name = "Healthy guy"
perk.description = "Increases health by 10"
perk.icon = "heart_add.png"
perk.level = 7
perk.restriction = function( ply ) return ply:Team() == TEAM_HUNK end
perk.passive = function( ply ) ply:SetHealth( ply:Health() + 10 ) end
levelup.config.addPerk( perk )

local perk = {}
perk.name = "Who comes here unprepared?"
perk.description = "Get a free pistol every Spawn"
perk.icon = "gun.png"
perk.level = 8
perk.restriction = function(ply) return ( levelup.getLevel( ply ) <= 40 ) && ply:Team() == TEAM_HUNK end
perk.passive = function( ply ) ply:Give( "weapon_9mmHandgun_re" ) end 
levelup.config.addPerk( perk )

local perk = {}
perk.name = "Promotion"
perk.description = "Gives 250 exp"
perk.icon = "money_add.png"
perk.level = 10
perk.restriction = function( ply ) return ply:Team() == TEAM_HUNK end
perk.passive = function( ply ) levelup.increaseExperience( ply, levelup.config.expPerKill ) end
levelup.config.addPerk( perk )

local perk = {}
perk.name = "Credit on credit"
perk.description = "Exchange EXP for PointShop Points"
perk.icon = "money_add.png"
perk.level = 12
perk.useCost = 50
perk.restriction = function( ply ) return ply:Team() == TEAM_HUNK end
perk.active = function( ply ) ply:SH_AddStandardPoints( 25 ) end
levelup.config.addPerk( perk )

local perk = {}
perk.name = "Income x2"
perk.description = "Get Extra 20$ Each Round"
perk.icon = "money_add.png"
perk.level = 14
perk.restriction = function( ply ) return ply:Team() == TEAM_HUNK end
perk.passive = function( ply ) ply:SetNWInt("Money",math.Round(ply:GetNWInt("Money")+ 20)) end
levelup.config.addPerk( perk )

local perk = {}
perk.name = "Leg Muscle"
perk.description = "Increases speed by 15"
perk.icon = "heart_add.png"
perk.level = 15
perk.restriction = function( ply ) return ply:Team() == TEAM_HUNK end
perk.passive = function(ply) ply:SetNWInt("Speed", ply:GetNWInt("Speed") + 35 ) GAMEMODE:SetPlayerSpeed(ply,ply:GetNWInt("Speed"),ply:GetNWInt("Speed") )   end,
levelup.config.addPerk( perk )

local perk = {}
perk.name = "Do you even lift, bro?"
perk.description = "Increases health by 15"
perk.icon = "heart_add.png"
perk.level = 16
perk.restriction = function( ply ) return ply:Team() == TEAM_HUNK end
perk.passive = function( ply ) ply:SetHealth( ply:Health() + 15 ) end
levelup.config.addPerk( perk )

local perk = {}
perk.name = "Loads Of Money!"
perk.description = "Get 10000 Dollars"
perk.icon = "coins_add.png"
perk.level = 20
perk.restriction = function( ply ) return ply:Team() == TEAM_HUNK end
perk.event = function( ply ) ply:SetNWInt("Money",math.Round(ply:GetNWInt("Money")+ 10000)) end
levelup.config.addPerk( perk )

local perk = {}
perk.name = "SuperHuman"
perk.description = "Increases health by 25"
perk.icon = "heart_add.png"
perk.level = 21
perk.restriction = function( ply ) return ply:Team() == TEAM_HUNK end
perk.passive = function( ply ) ply:SetHealth( ply:Health() + 25 ) end
levelup.config.addPerk( perk )

local perk = {}
perk.name = "SuperHumanPro"
perk.description = "Increases health by 25"
perk.icon = "heart_add.png"
perk.level = 24
perk.restriction = function( ply ) return ply:Team() == TEAM_HUNK end
perk.passive = function( ply ) ply:SetHealth( ply:Health() + 25 ) end
levelup.config.addPerk( perk )

local perk = {}
perk.name = "Income x3"
perk.description = "Get Extra 50$ Each Round"
perk.icon = "money_add.png"
perk.level = 29
perk.restriction = function( ply ) return ply:Team() == TEAM_HUNK end
perk.passive = function( ply ) ply:SetNWInt("Money",math.Round(ply:GetNWInt("Money")+ 50)) end
levelup.config.addPerk( perk )

local perk = {}
perk.name = "Income x4"
perk.description = "Get Extra 100$ Each Round"
perk.icon = "money_add.png"
perk.level = 32
perk.restriction = function( ply ) return ply:Team() == TEAM_HUNK end
perk.passive = function( ply ) ply:SetNWInt("Money",math.Round(ply:GetNWInt("Money")+ 100)) end
levelup.config.addPerk( perk )

local perk = {}
perk.name = "Income x5"
perk.description = "Get Extra 200$ Each Round"
perk.icon = "money_add.png"
perk.level = 35
perk.restriction = function( ply ) return ply:Team() == TEAM_HUNK end
perk.passive = function( ply ) ply:SetNWInt("Money",math.Round(ply:GetNWInt("Money")+ 200)) end
levelup.config.addPerk( perk )

local perk = {}
perk.name = "SuperHumanGod"
perk.description = "Increases health by 35"
perk.icon = "heart_add.png"
perk.level = 38
perk.restriction = function( ply ) return ply:Team() == TEAM_HUNK end
perk.passive = function( ply ) ply:SetHealth( ply:Health() + 35 ) end
levelup.config.addPerk( perk )

local perk = {}
perk.name = "Time For An Upgrade"
perk.description = "Unlimited Ammo With Pistol"
perk.icon = "gun.png"
perk.level = 41
perk.restriction = function( ply ) return ( levelup.getLevel( ply ) >= 41 ) && ( levelup.getLevel( ply ) <= 52 ) && ply:Team() == TEAM_HUNK end
perk.passive = function( ply ) ply:Give( "weapon_9mmHandgun_unlimited" ) end
levelup.config.addPerk( perk )

local perk = {}
perk.name = "Credit on credit ULTRA"
perk.description = "Exchange EXP for PointShop Points"
perk.icon = "money_add.png"
perk.level = 43
perk.useCost = 500
perk.restriction = function( ply ) return ply:Team() == TEAM_HUNK end
perk.active = function( ply ) ply:SH_AddStandardPoints( 250 ) end
levelup.config.addPerk( perk )

local perk = {}
perk.name = "Better UPgrade!"
perk.description = "Instead of a pistol, you get an mp5"
perk.icon = "gun.png"
perk.level = 52
perk.restriction = function( ply ) return ply:Team() == TEAM_HUNK end
perk.passive = function( ply ) ply:Give( "weapon_mp5_unlimited" ) end
levelup.config.addPerk( perk )

local perk = {}
perk.name = "Income x5"
perk.description = "Get Extra 200$ Each Round"
perk.icon = "money_add.png"
perk.level = 55
perk.restriction = function( ply ) return ply:Team() == TEAM_HUNK end
perk.passive = function( ply ) ply:SetNWInt("Money",math.Round(ply:GetNWInt("Money")+ 200)) end
levelup.config.addPerk( perk )

