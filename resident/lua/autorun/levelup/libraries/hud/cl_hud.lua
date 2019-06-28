levelup.hud = {}

local w, h = 150, 35
local x = ScrW() / 13 - w / 2
local y = 100
local exp, expreq = 0, 0
function levelup.hud.drawHUD()
	exp = levelup.getExperience( LocalPlayer() ) or 0
	expreq = ( levelup.getLevel( LocalPlayer() ) + 1 ) * levelup.config.expPerLevel or 0

	visuals.drawBlur( x, y, w, h, 3, 5, 255 )
	visuals.drawRect( x, y, w, h, Color( 0, 0, 0, 150 ) )
	visuals.drawRectOutline( x, y, w, h, Color( 0, 0, 0, 150 ) )
	visuals.drawRectOutline( x + 2, y + h - 6, w - 4, 4, Color( 0, 0, 0, 150 ) )
	visuals.drawFilledRect( x + 3, y + h - 5, w - 6, 2, Color( 205, 250, 0 ), exp / expreq )
	draw.SimpleText( "Level: " .. levelup.getLevel( LocalPlayer() ) or 0, "levelup_lato16", x + w / 2, y + 16, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
	draw.SimpleText( "Exp: ", "levelup_lato16", x + 2, y + h - 22, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
	draw.SimpleText( exp .. "/" .. expreq, "levelup_lato16", x + w - 2, y + h - 22, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
end

local notes = {}
local allNotesInvisible = false
function levelup.hud.drawFloatingNotes( text, color )
	allNotesInvisible = true
	for i, note in pairs( notes ) do
		visuals.drawFloatingText( note.text, x + w / 2, y + h + 50 + i * 15, 1.5, 40, note.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		if note.fadeTime < os.time() then
			note.color.a = Lerp( 0.025, note.color.a, 0 )
		end
		if math.floor( note.color.a ) > 0 then
			allNotesInvisible = false
		end
	end
	if allNotesInvisible then
		notes = {}
	end
end
/*---------------------------------------------------------------------------
	Net messages
---------------------------------------------------------------------------*/
net.Receive( "levelup_note", function() 
	local note = {}
	note.text = net.ReadString()
	note.color = net.ReadTable()
	note.color = Color( note.color.r, note.color.g, note.color.b, note.color.a )

	note.fadeTime = os.time() + 5
	table.insert( notes, note )
end )
/*---------------------------------------------------------------------------
	Hooks
---------------------------------------------------------------------------*/
hook.Add( "HUDPaint", "levelup_hud_drawhud", levelup.hud.drawHUD )
hook.Add( "HUDPaint", "levelup_hud_drawfloatingnotes", levelup.hud.drawFloatingNotes )