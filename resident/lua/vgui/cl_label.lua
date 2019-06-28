local p = { }

AccessorFunc( p, "font", "MFont" )

function p:Init( )
	self.Data = nil
end

AccessorFunc( p, "m_iForceW", "ForceW" )

function p:FixText( txt )
	txt = txt:gsub( "%$(.-)%$(.-)%$", function( font, text ) 
		return "<font=" .. font or "RpgFont" .. ">" .. text .. "</font>" 
	end )
	txt = txt:gsub( "%^(.)(.-)%^", function( code, text ) 
		return "<color=" .. ( RPG.CurrentColorScheme.FormatColors[ tonumber( code ) or 1 ] or RPG.CurrentColorScheme.FormatColors[ 1 ] ) .. ">" .. text .. "</color>" 
	end )
	
	txt = "<font=" .. ( self:GetMFont( ) or "RpgFont" ) .. "><color=white>" .. txt .. "</color></font>"
	
	return txt
end
function p:SizeToContents( )
	self:SetSize( 4 + self.Data.totalWidth, 4 + self.Data.totalHeight )
end
function p:GetText( )
	return self.txt
end
function p:SetForceW( w )
	if self:GetWide( ) ~= w then
		self.m_iForceW = w
		self:SetText( self.txt, w )
		self:SetWide( w )
	end
end
function p:SetText( txt, forcew )
	self.txt = tostring( txt )

	self.Data = markup.Parse( self:FixText( tostring( txt ) or "fuk!" ), math.min( 1080, self:GetForceW( ) or 600 ) )
	
	self:SizeToContents( )
end
function p:Paint( w, h )
	if not self.Data then
		return
	end
	
	self.Data:Draw( 2, 2 )
end

vgui.Register( "rpg_label", p )