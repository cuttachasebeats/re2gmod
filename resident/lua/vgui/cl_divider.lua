local panel = { }

local black = Color( 0, 0, 0, 189 )
local white = Color( 255, 255, 255, 189 )

AccessorFunc( panel, "m_bHalf", "HalfSize" )

function panel:Init( )
	self:SetSize( 256, 22 )
end

function panel:Paint( w, h )
	surface.SetFont( "RpgFontMed" )
	
	local x, y, r, n, z
	
	r, n = surface.GetTextSize( self:GetText( ) )
	
	x = w / 2 - r / 2
	y = h / 2 - n / 2
	
	r, n = surface.GetTextSize( "─" )
	
	z = math.floor( w / r * ( self:GetHalfSize( ) and .5 or 1 ) )
	
	RPG:ShadowedText( "RpgFontMed", "RpgFontMedBlur", string.rep( "─", z ), x, y, 2, white, TEXT_ALIGN_CENTER, black )
	return false
end

vgui.Register( "rpg_divider", panel )