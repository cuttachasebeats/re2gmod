RPG_FIELD_XP, RPG_FIELD_SP, RPG_FIELD_LEVEL, RPG_FIELD_SK = 1, 2, 3, 4
local FIELD_XP, FIELD_SP, FIELD_LEVEL, FIELD_SK = RPG_FIELD_XP, RPG_FIELD_SP, RPG_FIELD_LEVEL, RPG_FIELD_SK

local function WritePair( a, b )
	net.WriteInt( a, 8 )
	net.WriteInt( b, 32 )
end
local function ReadShort( )
	return net.ReadInt( 16 ) 
end
local function ReadInt( )
	return net.ReadInt( 32 )
end
local function ReadByte( )
	return net.ReadInt( 8 )
end
local function WriteTri( a, b, c )
	net.WriteInt( a, 8 )
	net.WriteInt( b, 16 )
	net.WriteInt( c, 16 )
end


if SERVER then
	umsg.PoolString( "RPG_OPEN_MENU" )
	umsg.PoolString( "RPG_LEVEL_UP" )
	
	util.AddNetworkString( "RPG_BEAM_FILTER" )
	util.AddNetworkString( "RPG_BEAM_DOWN" )
	util.AddNetworkString( "RPG_UPDATE_SKILL" )
	
	function RPG:BeamDown( pl, filter, ... )
		local k, v, args, i, skip

		skip = 0

		args = { ... }
		net.Start( "RPG_BEAM_DOWN" )
			net.WriteEntity( pl )
			net.WriteInt( #args, 32 )

			i = 1

			while i < #args do
				if args[ i ] == FIELD_SK then
					WriteTri( args[ i ], args[ i + 1 ], args[ i + 2 ] )
					i = i + 3
				else
					WritePair( args[ i ], args[ i + 1 ] )
					i = i + 2
				end
			end
		net.Send( filter or player.GetAll( ) )
	end
	
	function RPG:BeamEntireFrame( pl, filter )
		net.Start( "RPG_BEAM_DOWN" )
			net.WriteEntity( pl )
			net.WriteInt( 6 + table.Count( pl.RpgData.Skills ) * 3, 32 )

			WritePair( FIELD_XP, pl.RpgData.XP )
			WritePair( FIELD_SP, pl.RpgData.SkillPoints )
			WritePair( FIELD_LEVEL, pl.RpgData.Level )

			for k, v in pairs( pl.RpgData.Skills ) do
				WriteTri( FIELD_SK, k, v )
			end
		net.Send( filter or player.GetAll( ) )
	end
	
	function RPG:UpdateAllSkills( filter )
		net.Start( "RPG_UPDATE_SKILL" )
			net.WriteInt( table.Count( self.Skills ), 16 )
			
			local k, v
			
			for k, v in pairs( self.Skills ) do
				net.WriteInt( k, 16 )
				net.WriteInt( v:GetMaximum( ), 16 )
				net.WriteInt( v:GetEnabled( ) and 1 or 0, 2 )
			end
		net.Send( filter or player.GetAll( ) )
	end
	
	function RPG:UpdateSkill( sk, max, enabled )
		net.Start( "RPG_UPDATE_SKILL" )
			net.WriteInt( 1, 16 )
			net.WriteInt( sk, 16 )
			net.WriteInt( max, 16 )
			net.WriteInt( enabled and 1 or 0, 2 )
		net.Send( player.GetAll( ) )
	end
else
	usermessage.Hook( "RPG_OPEN_MENU", function( um ) RPG:ShowMenu( um:ReadString( ) ) end )
	usermessage.Hook( "RPG_LEVEL_UP", function( ) RPG.Panels.HUD.LevelBit.TimeLeft = 2 surface.PlaySound( "items/suitchargeok1.wav" ) end )

	net.Receive( "RPG_BEAM_FILTER", function( len )
		local count = net.ReadInt( 32 )

		while count > 0 do
			local class, b = net.ReadString( ), net.ReadInt( 2 )

			RPG.SpecialTreatment[ class ] = b == 1
			count = count - 1
		end
		RPG:RebuildUI( )
	end )
	
	net.Receive( "RPG_BEAM_DOWN", function( len )
		local pl, count, data, a, b, c, z, q
		
		pl = net.ReadEntity( )
		
		count = ReadInt( )
		
		if not pl.RpgData then	RPG:PreparePlayer( pl )	end
		
		pl.RpgData = pl.RpgData or { Skills = { }, PickedSwag = { } }
		
		data = pl.RpgData
		
		if not data then
			return
		end
		
		z = 0
		
		q = count
		
		while count > 0 do
			a = ReadByte( )

			if a == RPG_FIELD_XP then			data.XP = ReadInt( ); count = count - 2;
			elseif a == RPG_FIELD_SP then		data.SkillPoints = ReadInt( ); count = count - 2;
			elseif a == RPG_FIELD_LEVEL then	data.Level = ReadInt( ); count = count - 2;
			elseif a == RPG_FIELD_SK then		data.Skills[ ReadShort( ) ] = ReadShort( ); count = count - 3
			end
			
			z = z + 1
			
			assert( z < q, "Network stream malformed!" )
		end
		
		if pl == LocalPlayer( ) then
			RPG:RebuildUI( )
		end
	end )
	
	net.Receive( "RPG_UPDATE_SKILL", function( len )
		local i, sk
		
		for i = 1, ReadShort( ) do
			sk = RPG.Skills[ ReadShort( ) ]
			sk:SetAdjustedMaximum( ReadShort( ) )
			sk:SetEnabled( net.ReadInt( 2 ) == 1 )
		end
		
		RPG:RebuildUI( )
	end )
end