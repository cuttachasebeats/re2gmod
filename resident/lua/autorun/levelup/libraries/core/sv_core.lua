function levelup.applyPassivePerks( ply )
	timer.Simple( 5, function()
		for i, perk in pairs( levelup.getAvailablePerks( ply ) ) do
			if perk.passive and perk.restriction( ply ) then
				perk.passive( ply )
			end
		end
	end )
end
--TTT hooking
if engine.ActiveGamemode() == "terrortown" then
	hook.Add( "TTTBeginRound", "levelup_applyPassivePerks", function()
		for _, p in pairs( player.GetAll() ) do
			levelup.applyPassivePerks( p )
		end
	end )
end

hook.Add("OnNPCKilled","AddExperience",function(npc,ply)
		ply.levelup = levelup.database.fetch( ply )

		local bonus = 0
		bonus = levelup.config.bonusExpGroups[ ply:GetNWString( "usergroup" ) ] or 0
		levelup.increaseExperience( ply, levelup.config.expPerKill ) 
end)

function levelup.useActivePerk( ply, perk )
	local perk = levelup.getAvailablePerks( ply )[ perk ]
	if levelup.hasEnoughExperience( ply, perk.useCost ) and perk.restriction( ply ) then
		perk.active( ply )
		levelup.decreaseExperience( ply, perk.useCost )
	end
	levelup.database.save( ply )
	levelup.sendData( ply )
	levelup.hud.addNote( ply, "[ ] used!" .. perk.useCost .. " EXP consumed in the process!", Color( 205, 255, 0 ) )
end

function levelup.useEventPerks( ply )
	for i, perk in pairs( levelup.getAvailablePerks( ply ) ) do
		levelup.hud.addNote( ply, "New perk gained! [" .. perk.name .. "]", Color( 205, 255, 0 ) )
		if perk.level == levelup.getLevel( ply ) and perk.event then
			perk.event( ply )
		end
	end
end

function levelup.increaseExperience( ply, amount )
	if not ply.levelup then return end
	ply.levelup.experience = ply.levelup.experience + amount
	levelup.hud.addNote( ply, "Experience awarded! +" .. amount .. " EXP", Color( 205, 255, 0 ) )
	if levelup.hasEnoughExperience( ply, levelup.config.expPerLevel * ( levelup.getLevel( ply ) + 1 ) ) then
		ply.levelup.level = ply.levelup.level + 1
		ply.levelup.experience = 0
		levelup.useEventPerks( ply )
		levelup.hud.addNote( ply, "Level up! You are now on level: " .. ply.levelup.level, Color( 205, 255, 0 ) )
	end
	levelup.database.save( ply )
	levelup.sendData( ply )
end
concommand.Add( "levelup_giveexperience", function( ply, cmd, args )
	if not ply:IsSuperAdmin() then return end
	for _, p in pairs( player.GetAll() ) do
		if p:SteamID() == args[ 1 ] and args[ 2 ] then
			MsgC( Color( 205, 255, 0 ), "[LevelUp] Experience given to " .. p:Nick() .. " in amount of " .. args[ 2 ] .. "\n" )
			levelup.increaseExperience( p, args[ 2 ] )
		else
			MsgC( Color( 255, 95, 115 ), "[LevelUp] Experience not given! No player found or no amount specified\n" )
		end
	end
end )

function levelup.decreaseExperience( ply, amount )
	ply.levelup.experience = ply.levelup.experience - amount
	levelup.database.save( ply )
	levelup.sendData( ply )
end

function levelup.sendData( ply )
	net.Start( "levelup_data" )
		net.WriteEntity( ply )
		net.WriteTable( ply.levelup )
	net.Broadcast()
end

function levelup.initPlayer( ply )
	ply.levelup = {}
	ply.levelup.level = 0
	ply.levelup.experience = 0
	timer.Simple( 5, function()
		if levelup.database.fetch( ply ) then
			ply.levelup = levelup.database.fetch( ply )
			ply.levelup.level = tonumber( ply.levelup.level )
			ply.levelup.experience = tonumber( ply.levelup.experience )
			levelup.sendData( ply )
		else
			levelup.database.add( ply )
			ply.levelup = levelup.database.fetch( ply )
			ply.levelup.level = tonumber( ply.levelup.level )
			ply.levelup.experience = tonumber( ply.levelup.experience )
			levelup.sendData( ply )
		end
	end )
	levelup.sendData( ply )
end

function levelup.usePerk( len, ply )
	local perk = levelup.getAllPerks( ply )[ net.ReadInt( 8 ) ]
	if levelup.hasEnoughExperience( ply, perk.useCost ) and levelup.getLevel( ply ) >= perk.level then
		levelup.decreaseExperience( ply, perk.useCost )
		perk.active( ply )
	else
		levelup.hud.addNote( ply, "Not enough EXP to use this perk!", Color( 255, 95, 115 ) )
	end
end

function levelup.openMenu( ply )
	net.Start( "levelup_openmenu" )
	net.Send( ply )
end
/*---------------------------------------------------------------------------
	Net messages
---------------------------------------------------------------------------*/
util.AddNetworkString( "levelup_data" )
util.AddNetworkString( "levelup_openmenu" )
util.AddNetworkString( "levelup_useperk" )
net.Receive( "levelup_useperk", levelup.usePerk )
/*---------------------------------------------------------------------------
	Hooks
---------------------------------------------------------------------------*/
hook.Add( "PlayerInitialSpawn", "levelup_initplayer", levelup.initPlayer )
hook.Add( "PlayerSpawn", "levelup_applypassiveperks", levelup.applyPassivePerks )
timer.Create( "levelup_timer", levelup.config.expRewardDelay, 0, function() 
	for _, ply in pairs( player.GetAll() ) do 
		ply.levelup = levelup.database.fetch( ply )

		local bonus = 0
		bonus = levelup.config.bonusExpGroups[ ply:GetNWString( "usergroup" ) ] or 0
		levelup.increaseExperience( ply, levelup.config.expPerDelay + bonus ) 
	end 
end )