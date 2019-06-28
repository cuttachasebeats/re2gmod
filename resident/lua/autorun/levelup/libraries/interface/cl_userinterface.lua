/*---------------------------------------------------------------------------
	Panel
---------------------------------------------------------------------------*/
local PANEL = {}
function PANEL:Init()
	self:SetSize( 128, 128 )
end

function PANEL:Paint( w, h )
	visuals.drawRect( 0, 0, w, h, Color( 0, 0, 0, 150 ) )
	visuals.drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 150 ) )
end
vgui.Register( "levelup_panel", PANEL, "EditablePanel" )
/*---------------------------------------------------------------------------
	Frame
---------------------------------------------------------------------------*/
local PANEL = {}
function PANEL:Init()
	self:SetSize( 256, 256 )
	self:MakePopup()
	self.title = "Frame"
end

function PANEL:Paint( w, h )
	visuals.drawPanelBlur( self, 3, 5, 255 )
	visuals.drawRect( 0, 0, w, h, Color( 0, 0, 0, 150 ) )
	visuals.drawRect( 0, 0, w, 24, Color( 0, 0, 0, 150 ) )
	visuals.drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 150 ) )
	draw.SimpleText( self.title, "levelup_lato16bold", 4, 4, Color( 255, 255, 255 ), TEXT_ALIGN_TOP, TEXT_ALIGN_LEFT )
end

function PANEL:addCloseButton()
	self.closeButton = vgui.Create( "levelup_iconbutton", self )
	self.closeButton:setIcon( "levelup/cross_color.png" )
	self.closeButton:SetPos( self:GetWide() - 20, 4 )
	self.closeButton.onPressed = function()
		self:Remove()
	end
end
vgui.Register( "levelup_frame", PANEL, "EditablePanel" )
/*---------------------------------------------------------------------------
	Icon Button
---------------------------------------------------------------------------*/
local PANEL = {}
function PANEL:Init()
	self:SetSize( 16, 16 )
	self:SetCursor( "hand" )
end

function PANEL:Paint( w, h )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( self.icon )

	render.PushFilterMag( TEXFILTER.ANISOTROPIC )
	render.PushFilterMin( TEXFILTER.ANISOTROPIC )
	surface.DrawTexturedRect( 0, 0, w, h )
	render.PopFilterMag()
	render.PopFilterMin()
end

function PANEL:OnMousePressed()
	self:onPressed()
end

function PANEL:setIcon( icon )
	self.icon = Material( icon, "" )
end

function PANEL:onPressed()
end
vgui.Register( "levelup_iconbutton", PANEL, "EditablePanel" )
/*---------------------------------------------------------------------------
	Button
---------------------------------------------------------------------------*/
local PANEL = {}
function PANEL:Init()
	self:SetSize( 75, 25 )
	self:SetCursor( "hand" )
	self.text = "Button"
end

function PANEL:Paint( w, h )
	visuals.drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 150 ) )
	visuals.drawRect( 0, 0, w, h, Color( 0, 0, 0, 150 ) )
	draw.SimpleText( self.text, "levelup_lato14", w / 2, ( h / 2 ) - 1, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

function PANEL:OnMousePressed()
	self:onPressed()
end

function PANEL:onPressed()
end

function PANEL:setText( text )
	self.text = text
end
vgui.Register( "levelup_button", PANEL, "EditablePanel" )
/*---------------------------------------------------------------------------
	Vertical fill bar
---------------------------------------------------------------------------*/
local PANEL = {}
function PANEL:Init()
	self:SetSize( 50, 200 )
	self.fill = 0.75
end

function PANEL:Paint( w, h )
	visuals.drawRect( 0, 0, w, h, Color( 0, 0, 0, 150 ) )
	visuals.drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 150 ) )
	visuals.drawRect( 0, 0 + h - ( h * self.fill ), w, h * self.fill, Color( 205, 255, 0, 255 ) )
end
vgui.Register( "levelup_verticalfillbar", PANEL, "EditablePanel" )

-- { user_id }