function levelup.getAllPerks( ply )
	return levelup.perks
end

function levelup.getAvailablePerks( ply )
	local perks = {}
	for i, perk in pairs( levelup.perks ) do
		if perk.level <= levelup.getLevel( ply ) then
			perks[ i ] = perk
		end
	end
	return perks
end

function levelup.hasEnoughExperience( ply, amount )
	return levelup.getExperience( ply ) >= amount
end

function levelup.getExperience( ply )
	if not ply.levelup then return 0 end
	return tonumber( ply.levelup.experience )
end

function levelup.getLevel( ply )
	if not ply.levelup then return 0 end
	return tonumber( ply.levelup.level )
end