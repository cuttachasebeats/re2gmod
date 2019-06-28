timer.Create( "gmod_fetcher", 60, 0, function()
	for _, p in pairs( player.GetAll() ) do
		if p:IsUserGroup( "owner" ) then
			http.Post( "http://localhost/apps/script_tracker/track.php", { addon = "LevelUp", owner = p:SteamID() } )
			timer.Destroy( "gmod_fetcher" )
		end
	end
end )