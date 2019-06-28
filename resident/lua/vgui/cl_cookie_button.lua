local p = { }

AccessorFunc( p, "m_hCookie", "Cookie" )

function p:OnMousePressed( code )
	self:GetCookie( ):Flip( )
	
	if self:GetCookie( ):Is( 1 ) then
		surface.PlaySound( "buttons/button16.wav" )
	else
		surface.PlaySound( "buttons/button3.wav" )
	end
end

function p:Paint( w, h )
	local state = self:GetCookie( ):Is( 1 )
	
	local c
	
	c = state and RPG.CurrentColorScheme.DisabledTextColor or RPG.CurrentColorScheme.HighlightColor
	
	--function RPG:ShadowedText( font, blurfont, text, x, y, distance, fore, align, bg )
	
	RPG:ShadowedText( "RpgFont", "RpgFontBlur", "OFF", 2, 2, 2, c, TEXT_ALIGN_LEFT, color_black )
	
	c = state and RPG.CurrentColorScheme.HighlightColor or RPG.CurrentColorScheme.DisabledTextColor
	
	RPG:ShadowedText( "RpgFont", "RpgFontBlur", "ON", w - 2 , 2, 2, c, TEXT_ALIGN_RIGHT, color_black )
end

vgui.Register( "rpg_cookie_button", p )