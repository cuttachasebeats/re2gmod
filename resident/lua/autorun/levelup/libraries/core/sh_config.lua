levelup.config = {}

function levelup.config.addPerk( perk )
	perk.useCost = perk.useCost or false
	perk.restriction = perk.restriction or function() return true end
	table.insert( levelup.perks, perk )
end
/*---------------------------------------------------------------------------
	Config
---------------------------------------------------------------------------*/
levelup.config.expRewardDelay = 600
levelup.config.expPerDelay = 5
levelup.config.expPerKill	=	10
levelup.config.expPerLevel = 250		--with current setting it'll require 15 minutes more for each level
levelup.config.openKey = KEY_F7			--key bound to open perk menu, find all keys there http://wiki.garrysmod.com/page/Enums/KEY
levelup.config.bonusExpGroups = {}
levelup.config.bonusExpGroups[ "owner" ] = 5
levelup.config.bonusExpGroups[ "superadmin" ] = 4
levelup.config.bonusExpGroups[ "admin" ] = 3
levelup.config.bonusExpGroups[ "moderator" ] = 2
levelup.config.bonusExpGroups[ "vip" ] = 2