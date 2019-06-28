levelup.hud = {}

function levelup.hud.addNote( ply, text, color )
	net.Start( "levelup_note" )
		net.WriteString( text )
		net.WriteTable( { r = color.r, g = color.g, b = color.b, a = 255 } )
	net.Send( ply )
end
/*---------------------------------------------------------------------------
	Net messages
---------------------------------------------------------------------------*/
util.AddNetworkString( "levelup_note" )