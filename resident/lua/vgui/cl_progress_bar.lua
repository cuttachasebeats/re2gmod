local p = { }

AccessorFunc( p, "m_fValue", "Value" )
AccessorFunc( p, "m_sLeftText", "LeftText" )
AccessorFunc( p, "m_sMiddleText", "MiddleText" )
AccessorFunc( p, "m_sRightText", "RightText" )
AccessorFunc( p, "m_bNoText", "NoText" )

function p:Paint( w, h )
	draw.RoundedBox( 1, 0, 0, w, h, RPG.CurrentColorScheme.HighlightColor, true, true )
	
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect( 2, 2, w - 4, h - 4 )
	
	self.OldW = math.Approach( self.OldW or 0, math.min( 1, self:GetValue( ) or 0 ), RealFrameTime( ) )
	
	surface.SetDrawColor( RPG.CurrentColorScheme.HighlightColor )
	surface.DrawRect( 3, 3, ( w - 6 ) * self.OldW, h - 6 )
	
	if self:GetNoText( ) then 
		return
	end
	
	local a, b, r, n
	
	if ScrW( ) < 1280 then
		a, b = "RpgFontSmall", "RpgFontSmallBlur"
	else
		a, b = "RpgFont", "RpgFontBlur"
	end
	
	surface.SetFont( a )
	
	r, n = surface.GetTextSize( "Q" )
	
	if self:GetLeftText( ) then
		RPG:ShadowedText( a, b, self:GetLeftText( ), 6, h / 2 - n / 2, 2, RPG.CurrentColorScheme.TextColor )
	end
	
	if self:GetMiddleText( ) then
		RPG:ShadowedText( a, b, self:GetMiddleText( ), w / 2, h / 2 - n / 2, 2, RPG.CurrentColorScheme.TextColor, TEXT_ALIGN_CENTER )
	end
	
	if self:GetRightText( ) then
		RPG:ShadowedText( a, b, self:GetRightText( ), w  - 6, h / 2 - n / 2, 2, RPG.CurrentColorScheme.TextColor, TEXT_ALIGN_RIGHT )
	end
end

vgui.Register( "rpg_progress_bar", p )