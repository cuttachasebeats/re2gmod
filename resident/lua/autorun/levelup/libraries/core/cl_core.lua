surface.CreateFont( "levelup_montserrat16bold",
{
	font = "Montserrat", 
	size = 16,
	weight = 700,
	antialias = true,
} )

-- { user_id }

surface.CreateFont( "levelup_montserrat16",
{
	font = "Montserrat", 
	size = 16,
	weight = 400,
	antialias = true,
} )

surface.CreateFont( "levelup_lato16bold",
{
	font = "Lato", 
	size = 16,
	weight = 700,
	antialias = true,
} )

surface.CreateFont( "levelup_lato16",
{
	font = "Lato", 
	size = 16,
	weight = 400,
	antialias = true,
} )

surface.CreateFont( "levelup_lato14",
{
	font = "Lato", 
	size = 14,
	weight = 400,
	antialias = true,
} )

surface.CreateFont( "levelup_lato14bold",
{
	font = "Lato", 
	size = 14,
	weight = 700,
	antialias = true,
} )

surface.CreateFont( "levelup_lato12",
{
	font = "Lato", 
	size = 12,
	weight = 400,
	antialias = true,
} )
/*---------------------------------------------------------------------------
	Net messages
---------------------------------------------------------------------------*/
local w, h = 600, ScrH() - 200
local frame = nil
function levelup.openMenu()
	if frame and frame:IsValid() and frame:IsVisible() then return end

	local exp = levelup.getExperience( LocalPlayer() ) or 0
	local expreq = ( levelup.getLevel( LocalPlayer() ) + 1 ) * levelup.config.expPerLevel or 0

	frame = vgui.Create( "levelup_frame" )
	frame:SetSize( w, h )
	frame:Center()
	frame:addCloseButton()
	frame.title = "Level Up - Perks"
	frame:CenterVertical()

	local perkScroll = vgui.Create( "DScrollPanel", frame )
	perkScroll:SetSize( 565, h - 35 )
	perkScroll:SetPos( 50, 29 )

	local perkList = vgui.Create( "DIconLayout", perkScroll )
	perkList:SetSize( 545, h - 35 )
	perkList:SetPos( 0, 0 )
	perkList:SetSpaceY( 1 )

	for i, perk in pairs ( levelup.getAllPerks( ply ) ) do
		local perkPanel = vgui.Create( "levelup_panel", perkList )
		perkPanel:SetSize( 545, 40 )

		local icon = vgui.Create( "DImage", perkPanel )
		icon:SetImage( "icon16/" .. perk.icon )
		icon:SetSize( 16, 16 )
		icon:SetPos( 4, 4 )

		local name = vgui.Create( "DLabel", perkPanel )
		name:SetFont( "levelup_lato14" )
		name:SetText( perk.name )
		name:SizeToContents()
		name:SetPos( 0, 4 )
		name:CenterHorizontal()

		local desc = vgui.Create( "DLabel", perkPanel )
		desc:SetFont( "levelup_lato14" )
		desc:SetText( perk.description )
		desc:SizeToContents()
		desc:SetPos( 0, 22 )
		desc:CenterHorizontal()

		local level = vgui.Create( "DLabel", perkPanel )
		level:SetFont( "levelup_lato12" )
		level:SetText( "Lv. " .. perk.level )
		level:SizeToContents()
		level:SetPos( 4, 22 )
		level:SetTextColor( Color( 255, 95, 115 ) )
		if perk.level <= levelup.getLevel( LocalPlayer() ) then
			level:SetTextColor( Color( 205, 255, 0 ) )
		end

		if perk.active then
			local useButton = vgui.Create( "levelup_button", perkPanel )
			useButton:SetSize( 30, 15 )
			useButton:setText( "Use" )
			useButton:SetPos( perkPanel:GetWide() - 34, 4 )
			useButton.onPressed = function()
				net.Start( "levelup_useperk" )
					net.WriteInt( i, 8 )
				net.SendToServer()
				frame:Remove()
			end
			local costLabel = vgui.Create( "DLabel", perkPanel )
			costLabel:SetFont( "levelup_lato12" )
			costLabel:SetText( "Costs " .. perk.useCost .. " EXP" )
			costLabel:SizeToContents()
			costLabel:SetPos( perkPanel:GetWide() - 4 - costLabel:GetWide(), 22 )
			costLabel:SetTextColor( Color( 255, 95, 115 ) )
			if exp >= perk.useCost and levelup.getLevel( LocalPlayer() ) >= perk.level then
				costLabel:SetTextColor( Color( 205, 255, 0 ) )
			end
		end
	end

	local expbar = vgui.Create( "levelup_verticalfillbar", frame )
	expbar:SetPos( 5, 29 )
	expbar:SetSize( 40, h - 35 )
	expbar.fill = exp / expreq
end
net.Receive( "levelup_openmenu", levelup.openMenu )

hook.Add( "Think", "open", function()
	if input.IsKeyDown( levelup.config.openKey ) then
		if not LocalPlayer():IsTyping() and not gui.IsGameUIVisible() then
			levelup.openMenu()
		end
	end
end )

net.Receive( "levelup_data", function()
	local ply = net.ReadEntity()
	ply.levelup = net.ReadTable()
end )