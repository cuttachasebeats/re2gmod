levelup = {}

if SERVER then
	local files, directories = file.Find( "autorun/levelup/libraries/*", "LUA" )
	for i, folder in pairs( directories ) do
		local files, directories = file.Find( "autorun/levelup/libraries/" .. folder .. "/*", "LUA" )
		for i, f in pairs( files ) do
			if string.StartWith( f, "sh_" ) then
				include( "autorun/levelup/libraries/" .. folder .. "/" .. f )
				AddCSLuaFile( "autorun/levelup/libraries/" .. folder .. "/" .. f )
			elseif string.StartWith( f, "sv_" ) then
				include( "autorun/levelup/libraries/" .. folder .. "/" .. f )
			elseif string.StartWith( f, "cl_" ) then
				AddCSLuaFile( "autorun/levelup/libraries/" .. folder .. "/" .. f )
			end
		end
	end
end

if CLIENT then
	local files, directories = file.Find( "autorun/levelup/libraries/*", "LUA" )
	for i, folder in pairs( directories ) do
		local files, directories = file.Find( "autorun/levelup/libraries/" .. folder .. "/*", "LUA" )
		for i, f in pairs( files ) do
			if string.StartWith( f, "sh_" ) then
				include( "autorun/levelup/libraries/" .. folder .. "/" .. f )
			elseif string.StartWith( f, "cl_" ) then
				include( "autorun/levelup/libraries/" .. folder .. "/" .. f )
			end
		end
	end
end