levelup.database = {}

function levelup.database.query( query )
	local query = sql.Query( sql.SQLStr( query, true ) )

	if not query and sql.LastError() then
		print( "SQL Error: " ..  sql.LastError() )
	else
		if type( query ) == "table" and table.Count( query ) == 1 then
			query = query[ 1 ]
		end
	end

	return query
end

function levelup.database.init()
	if not sql.TableExists( "levelup_players" ) then
		levelup.database.query( "CREATE TABLE levelup_players ( id INTEGER, level INTEGER, experience INTEGER )" )
	end
end

function levelup.database.fetch( ply )
	if ply != nil then
	return levelup.database.query( "SELECT * FROM levelup_players WHERE id = " .. ply:UniqueID() )
	end
end

function levelup.database.add( ply )
	levelup.database.query( "INSERT INTO levelup_players ( id, level, experience ) VALUES ( " .. ply:UniqueID() .. ", 0, 0 )" )
end

function levelup.database.save( ply )
	levelup.database.query( "UPDATE levelup_players SET level = " .. ply.levelup.level .. ", experience = " .. ply.levelup.experience .. " WHERE id = " .. ply:UniqueID() )
end
/*---------------------------------------------------------------------------
	Hooks
---------------------------------------------------------------------------*/
hook.Add( "Initialize", "levelup_database_init", levelup.database.init )