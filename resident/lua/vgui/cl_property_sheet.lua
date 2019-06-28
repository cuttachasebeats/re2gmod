local panel = { }

AccessorFunc( panel, "m_bActive", "Active" )
AccessorFunc( panel, "m_sFont", "Font" )
AccessorFunc( panel, "m_sText", "Text" )

local black = Color( 0, 0, 0, 189 )
local silver = Color( 40, 40, 40, 255 )
local white = Color( 255, 255, 255, 189 )
local blue = Color( 30, 144, 200, 220 )

function panel:Init( )
	self:SetCursor( "hand" )
	self:SetFont( "RpgFont" )
	self:SetTall( 30 )
end

function panel:SizeToContents( )
	surface.SetFont( self:GetFont( ) )
	local w, h = surface.GetTextSize( self:GetText( ) )
	
	self:SetSize( w + 30, h + 30 )
end

function panel:OnMouseReleased( )
	if self.DoClick then
		self:DoClick( )
	end
end

function panel:Paint( w, h )
	surface.SetFont( self:GetFont( ) )
	
	local x, y, r, n
	
	r, n = surface.GetTextSize( self:GetText( ) )
	
	x = w / 2 - r / 2
	y = h / 2 - n / 2
	
	surface.SetFont( "RpgFontSmall" )
	
	r, n = surface.GetTextSize( "┌" )
	
	RPG:ShadowedText( "RpgFontSmall", "RpgFontSmallBlur", "┌", 0, 0, 2, self:GetActive( ) and blue or white, TEXT_ALIGN_LEFT, black )
	RPG:ShadowedText( "RpgFontSmall", "RpgFontSmallBlur", "└", 0, h - n, 2, self:GetActive( ) and blue or white, TEXT_ALIGN_LEFT, black )
	RPG:ShadowedText( "RpgFontSmall", "RpgFontSmallBlur", "┐", w - r, 0, 2, self:GetActive( ) and blue or white, TEXT_ALIGN_LEFT, black )
	RPG:ShadowedText( "RpgFontSmall", "RpgFontSmallBlur", "┘", w - r, h - n, 2, self:GetActive( ) and blue or white, TEXT_ALIGN_LEFT, black )
	
	RPG:ShadowedText( "RpgFontMed", "RpgFontMedBlur", self:GetText( ), x, y, 2, self:GetActive( ) and blue or white, TEXT_ALIGN_LEFT, black )
	
	return false
end

vgui.Register( "rpg_property_tab", panel )

panel = { }

function panel:Init( )
	self.Container = vgui.Create( "Panel", self )
	self.Strip = vgui.Create( "Panel", self )
	
	function self.Container.Paint( this, w, h )
		draw.RoundedBoxEx( 2, 0, 0, w, h, black, true, true, false, false )
	end
	
	function self.Strip.Paint( this, w, h )
		draw.RoundedBoxEx( 2, 0, 0, w, h, silver, true, true, false, false )	
	end
	
	self.Strip:Dock( TOP )
	self.Container:Dock( FILL )
	
	self.NewestTab = nil
	self.ActiveTab = nil
	
	self.Tabs = { }
	self.Panels = { }
end

function panel:SwitchTab( tab, panel )
	self.ActiveTab = tab
	
	local k, v
	
	for k, v in ipairs( self.Panels ) do
		v:SetVisible( panel == v )
	end
	
	for k, v in ipairs( self.Tabs ) do
		v:SetActive( tab == v )
	end
end

function panel:AddSheet( text, panel )
	panel:SetParent( self.Container )
	panel:Dock( FILL )
	
	local tab = vgui.Create( "rpg_property_tab", self.Strip )
	tab:SetText( text )
	tab:DockMargin( 2, 0, 0, 0 )
	tab:SetFont( "RpgFontMedBlur" )
	tab:SizeToContents( )
	tab:SetWide( tab:GetWide( ) + 10 )
	
	tab:Dock( LEFT )
	
	function tab.DoClick( this )
		self:SwitchTab( this, panel )	
	end
	
	if #self.Tabs == 0 then
		tab.ActiveTab = tab
		tab:SetActive( true )
	else
		panel:SetVisible( false )
	end
	
	table.insert( self.Panels, panel )
	table.insert( self.Tabs, tab )
end

vgui.Register( "rpg_propertysheet", panel )