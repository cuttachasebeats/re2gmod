RPG.Panels = RPG.Panels or { }
RPG.Generics = { }

local black = Color( 0, 0, 0, 189 )
local solidblack = color_black
local change_white = Color( 255, 255, 255, 255 )
local change_black = Color( 0, 0, 0, 255 )
local green = Color( 223, 255, 0, 100 )
local white = Color( 255, 255, 255, 189 )
local blue = Color( 30, 144, 200, 220 )

function RPG.Generics.Paint1( this, w, h )
	draw.RoundedBoxEx( 2, 0, 0, w, h, black, true, true, false, false )
end
function RPG.Generics.Paint2( this, w, h )
	draw.RoundedBox( 2, 0, 0, w, h, black )
end
function RPG.Generics.Gradient( this, w, h )
	RPG.Generics.Paint2( this, w, h )
	
	if not this.f or this.f == 0 then
		return	
	end
	
	this.LastF = math.Approach( this.LastF or 0, this.f, RealFrameTime( ) )
	
	surface.SetDrawColor( RPG.CurrentColorScheme.HighlightColor.r, RPG.CurrentColorScheme.HighlightColor.g, RPG.CurrentColorScheme.HighlightColor.b, RPG.CurrentColorScheme.HighlightColor.a / 4 )
	surface.DrawRect( 0, 0, w * this.f, h )
end
function RPG.Generics.Slider( this, w, h )
	surface.SetDrawColor( color_white )
	surface.DrawLine( 0, h - 5, w, h - 5 )
	
	local i
	
	for i = 1, 7 do
		if i % 2 == 0 then
			surface.DrawLine( w * ( i / 8 ) - 1, h - 2, w * ( i / 8 ) - 1, h - 8 )
		else
			surface.DrawLine( w * ( i / 8 ) - 1, h - 4, w * ( i / 8 ) - 1, h - 6 )
		end
		
		surface.DrawLine( 0, h - 2, 0, h - 8 )
		surface.DrawLine( w - 1, h - 2, w - 1, h - 8 )
	end
end

include( "cl_scheme.lua" )
include( "vgui/cl_progress_bar.lua" )
include( "vgui/cl_label.lua" )
include( "vgui/cl_property_sheet.lua" )
include( "vgui/cl_skill_row.lua" )
include( "vgui/cl_cookie_button.lua" )
include( "vgui/cl_divider.lua" )

surface.CreateFont( "RpgFont", {
	size = 16,
	weight = 600,
	antialias = true,
	shadow = false,
	font = "Verdana",
	} )
surface.CreateFont( "RpgFontSmall", {
	size = 12,
	weight = 500,
	antialias = true,
	shadow = false,
	font = "Verdana",
	} )
surface.CreateFont( "RpgFontSmallBlur", {
	size = 12,
	weight = 500,
	antialias = true,
	shadow = false,
	font = "Verdana",
	scanlines = 4,
	blursize = 2,
	} )
surface.CreateFont( "RpgFontBold", {
	size = 20,
	weight = 500,
	antialias = true,
	shadow = false,
	font = "Verdana Bold",
	} )
surface.CreateFont( "RpgFontBlur", {
	size = 16,
	weight = 600,
	antialias = true,
	shadow = false,
	font = "Verdana",
	scanlines = 4,
	blursize = 3,
	} )
surface.CreateFont( "RpgWebdings", {
	size = 24,
	weight = 600,
	antialias = true,
	shadow = false,
	symbol = true,
	font = "Webdings",
	} )
surface.CreateFont( "RpgFontMed", {
	size = 22,
	weight = 600,
	antialias = true,
	shadow = false,
	font = "Verdana",
	} )
surface.CreateFont( "RpgFontMedBlur", {
	size = 22,
	weight = 600,
	antialias = true,
	shadow = false,
	font = "Verdana",
	scanlines = 4,
	blursize = 3,
	} )
surface.CreateFont( "RpgFontTiny", {
	size = 8,
	weight = 500,
	antialias = true,
	shadow = false,
	font = "Verdana",
	} )
surface.CreateFont( "RpgFontTinyBlur", {
	size = 8,
	weight = 600,
	antialias = true,
	shadow = false,
	font = "Verdana",
	scanlines = 4,
	blursize = 3,
	} )

function RPG:ShadowedText( font, blurfont, text, x, y, distance, fore, align, bg )
	if not text or text == "" then
		return
	end
	
	align = align or TEXT_ALIGN_LEFT
	
	if blurfont and blurfont ~= "" then
		draw.DrawText( text, blurfont, x - distance	, y - distance	, bg or color_black, align )
		draw.DrawText( text, blurfont, x - distance	, y				, bg or color_black, align )
		draw.DrawText( text, blurfont, x - distance	, y + distance	, bg or color_black, align )
		draw.DrawText( text, blurfont, x			, y - distance	, bg or color_black, align )
		draw.DrawText( text, blurfont, x			, y + distance	, bg or color_black, align )
		draw.DrawText( text, blurfont, x + distance, y + distance	, bg or color_black, align )
		draw.DrawText( text, blurfont, x + distance, y				, bg or color_black, align )
		draw.DrawText( text, blurfont, x + distance, y - distance	, bg or color_black, align )
			
		draw.DrawText( text, blurfont, x, y, fore, align )
	end
	draw.DrawText( text, font, x, y, fore, align )
end
function RPG:Image( m, p )
	local p = vgui.Create( "Panel", p )
	
	if not m then
		print( "Returning since no material" )
		return p
	end
	
	if m:IsError( ) then
		m = Material( "editor/obsolete", "unlit smooth" )
	end
	
	m:SetInt( "$vertexcolor", 1 )
	
	p.On = true
	
	local color_grey = Color( 10, 10, 10, 255 )
	
	p.Paint = function( this, w, h )
		render.PushFilterMin( TEXFILTER.ANISOTROPIC )
		render.PushFilterMag( TEXFILTER.ANISOTROPIC )
			surface.SetMaterial( m )
			surface.SetDrawColor( this.On and color_white or color_grey )
			surface.DrawTexturedRect( 0, 0, w, h )
		render.PopFilterMin( )
		render.PopFilterMag( )
	end
	
	return p
end
function RPG:MakeLabel( text, parent, font, x )
	local l = vgui.Create( "rpg_label", parent ) --Label( text, parent )
	l:SetMFont( font )
	l:SetText( text, x )
	
	l:SizeToContents( )
	
	return l
end
function RPG:CheapLabel( text, parent, font )
	local l = vgui.Create( "Panel", parent )
	local f, g
	
	f = font or "RpgFont"
	g = f .. "Blur"
	
	if ScrW( ) < 1280 and f == "RpgFont" then
		f = "RpgFontSmall"
	end
	
	l.Text = text
	
	l.SetText = function( this, txt )
		this.Text = txt
		this:SizeToContents( )
	end
	
	l.SizeToContents = function( this )
		surface.SetFont( f )
		local w, h = surface.GetTextSize( this.Text )
		
		this:SetSize( w + 2, h + 2 )
	end
	
	l.Paint = function( this, w, h )
		RPG:ShadowedText( f, g, this.Text, 1, 1, 2,  white, TEXT_ALIGN_LEFT, black )
	end
	
	return l
end
function RPG:MakeButton( text, parent, font )
	local l = vgui.Create( "Panel", parent )
	
	l.Hover = false
	
	l.Init = function( this )
		this:SetCursor( "hand" )
	end
	
	l.OnCursorEntered = function( this )
		this.Hover = true
	end
	l.OnCursorExited = function( this )
		this.Hover = false
	end
	l.SizeToContents = function( this )
		surface.SetFont( font or "RpgFont" )
		local w, h = surface.GetTextSize( text )
		
		this:SetSize( w + 20, h + 20 )
	end
	
	l.GetActive = function( this ) return this.Hover end
	
	l.Paint = function( this, w, h )
		local x, y, r, n, f, g
		
		f = font or "RpgFont" 
		g = f .. "Blur"
	
		surface.SetFont( f )
		
		r, n = surface.GetTextSize( text )
		
		x = w / 2 - r / 2
		y = h / 2 - n / 2
		
		surface.SetFont( "RpgFontSmall" )
		
		r, n = surface.GetTextSize( "┌" )
		
		RPG:ShadowedText( "RpgFontSmall", "RpgFontSmallBlur", "┌", 0, 0, 2, this:GetActive( ) and blue or white, TEXT_ALIGN_LEFT, black )
		RPG:ShadowedText( "RpgFontSmall", "RpgFontSmallBlur", "└", 0, h - n, 2, this:GetActive( ) and blue or white, TEXT_ALIGN_LEFT, black )
		RPG:ShadowedText( "RpgFontSmall", "RpgFontSmallBlur", "┐", w - r, 0, 2, this:GetActive( ) and blue or white, TEXT_ALIGN_LEFT, black )
		RPG:ShadowedText( "RpgFontSmall", "RpgFontSmallBlur", "┘", w - r, h - n, 2, this:GetActive( ) and blue or white, TEXT_ALIGN_LEFT, black )
	
		RPG:ShadowedText( f, g, text, x, y, 2, this:GetActive( ) and blue or white, TEXT_ALIGN_LEFT, black )
	end
	
	return l
end

local function UpdateLabel( lbl, text )
	lbl:SetText( text )
	
	if not lbl.Wrap then
		lbl:SizeToContents( )
	end
	
	return lbl:GetWide( ), lbl:GetTall( )
end
local function UpdateItem( row, index, pl )
	local a, b = RPG:GetSkill( pl, index )

	if RPG.Skills[ index ].UpdateLongDesc then
		UpdateLabel( row.Desc, RPG.Skills[ index ]:UpdateLongDesc( RPG.Skills[ index ]:GetLongDesc( ), a or 0 ) )
	else
		UpdateLabel( row.Desc, RPG.Skills[ index ]:GetLongDesc( ) )
	end
	
	
	
	row.f = b / RPG.Skills[ index ]:GetMaximum( )
	
	if a ~= b then
		UpdateLabel( row.Level, string.format( "^5%3d^/^5%3d^ (^6+%.1f^)", a, RPG.Skills[ index ]:GetMaximum( ), a - b ) )
	else
		UpdateLabel( row.Level, string.format( "^5%3d^/^5%3d^", a, RPG.Skills[ index ]:GetMaximum( ) ) )
	end
	
	if not RPG.Skills[ index ]:GetEnabled( ) then
		row:SetAlpha( 90 )
	end
end

local function void( this )
	if this.bAnimated then
		this:RunAnimation( )
	end
	
	if not this.once then
		local t = PositionSpawnIcon( this.Entity, this.Entity:GetPos( ) )
	
		this:SetCamPos( t.origin )
		this:SetLookAng( t.angles )
		this:SetFOV( t.fov )
		
		this.once = true
	end
end
local function void2( this )
	if this.bAnimated then
		this:RunAnimation( )
	end
	
	if not this.once then
		local t = PositionSpawnIcon( this.Entity, this.Entity:GetPos( ) )
		
		this:SetCamPos( this.Entity:GetForward( ) * 10 + vector_up )
		this:SetLookAng( ( -this.Entity:GetForward( ) ):Angle( ) )
		this:SetFOV( 70 )
		--this:SetFOV( t.fov )
		--this:SetCamPos( t.origin )		
		--this:SetLookAng( t.angles )
		
		this.once = true
	end
end
local function nothing( )
end
local function CallMulti( func, items, ... )
	local k, v
	
	for k, v in pairs( items ) do
		v[ func ]( v, ... )
	end
end

local function Hide( p )
	if p:IsVisible( ) then
		p:SetVisible( false )
	end
end
local function Show( p )
	if not p:IsVisible( ) then
		p:SetVisible( true )
	end
end

function RPG:RebuildUI( force )
	local pl = LocalPlayer( )
	
	if force then
		local k, v
		
		for k, v in pairs( self.Panels ) do
			v:Remove( )
			self.Panels[ k ] = nil
		end
	end
	
	if not self.Panels.HUD then
		local p = vgui.Create( "Panel" )
			local bar = vgui.Create( "rpg_progress_bar", p )
			
			p.Bar = bar
			
			local levelbit = vgui.Create( "Panel" )
			
			p.LevelBit = levelbit
			
			levelbit.Mat = Material( "rpg/muscle-up.png", "smooth mips" )
			
			levelbit.Paint = function( this, w, h )
				if this.TimeLeft > 0 and RPG.Cookies.HideUI:Is( 0 ) then
					draw.RoundedBoxEx( 1, 0, 0, w, h, RPG.CurrentColorScheme.HighlightColor, true, true )
					surface.SetDrawColor( 255, 255, 255, this.A )
				
					change_white.a = this.A
					change_black.a = this.A
				
					surface.SetMaterial( this.Mat )
					surface.DrawTexturedRect( 0, 0, w, h )
					RPG:ShadowedText( "RpgFont", "RpgFontBlur", "Level Up!", w / 2, h - 18, 2, change_white, TEXT_ALIGN_CENTER, change_black )
				end
			end
			
			levelbit.Think = function( this )
				if this.TimeLeft > 0 then
					this.TimeLeft = math.Approach( this.TimeLeft, 0, RealFrameTime( ) )
					
					this.A = 127.5 + 127.5 * math.cos( ( self.Panels.HUD.LevelBit.TimeLeft % 1 ) * math.pi * 2 )
				end
				
				if not RPG.Panels.HUD or not RPG.Panels.HUD:IsValid( ) then
					this:Remove( )
				end
			end
			
			function p.Think( this )
				if RPG.Cookies.HideUI:Is( 1 ) then
					Hide( this.Bar )
					Hide( this.LevelBit )
					this.LevelBit:Think( )
				else
					Show( this.Bar )
					Show( this.LevelBit )
				end
				
				local key = ulx and "gm_showhelp" or "gm_showspare1"
				
				if not LocalPlayer( ).RpgData then
					return
				end
				
				this.Bar:SetLeftText( "Menu: " .. string.upper( input.LookupBinding( key ) or "[" .. key .. "]" ) )
				this.Bar:SetRightText( "Points: " .. LocalPlayer( ).RpgData.SkillPoints )
			end
			
			levelbit:SetSize( 80, 80 )
			levelbit.TimeLeft = 0
						
			bar.Fraction = .5
			bar:CenterHorizontal( )
			bar:Dock( FILL )
			
			p:SetWide( ScrW( ) / 3 )
			p:SetTall( 20 )
			
			p:CenterHorizontal( )
			p.Y = ScrH( ) - p:GetTall( )
			
			levelbit:CenterHorizontal( )
			levelbit:MoveAbove( p, 24 )
		self.Panels.HUD = p
	else
		local w, h, r, n, x, y
		
		if pl.RpgData then
		
			self.Panels.HUD.Bar:SetValue( math.min( pl.RpgData.XP / self:GetNextLevel( pl ), 1 ) )
			self.Panels.HUD.Bar.Level = pl.RpgData.Level
			self.Panels.HUD.Bar.Rank = self:GetRank( pl )
		
			self.Panels.HUD.Bar:SetMiddleText( "Level " .. ( pl.RpgData.Level or 0 ) .. " - " .. self:GetRank( pl ) )
		end
	
		self.Panels.HUD:CenterHorizontal( )
		self.Panels.HUD.Y = ScrH( ) - self.Panels.HUD:GetTall( )
	end
	
	local function Wrap( p, parent, l )
		local e = vgui.Create( "Panel", parent )
			e:Dock( TOP )
			p:SetParent( e )
			p:Dock( l or LEFT )
		return p
	end
	
	if not self.Panels.InfoPanel then
		--[[local p = vgui.Create( "Panel" )
		
		p:SetSize( 200, 200 )
		p:CenterVertical( )
		p.X = 2
		
		Wrap( RPG:CheapLabel( "Name" ), p, LEFT )
		p.Name = Wrap( RPG:CheapLabel( "" ), p, RIGHT )
		
		Wrap( RPG:CheapLabel( "Health" ), p, LEFT )
		p.Health = Wrap( RPG:CheapLabel( "" ), p, RIGHT )
		
		Wrap( RPG:CheapLabel( "Kills" ), p, LEFT )
		p.Kills = Wrap( RPG:CheapLabel( "" ), p, RIGHT )
		
		Wrap( RPG:CheapLabel( "Rank" ), p, LEFT )
		p.Rank = Wrap( RPG:CheapLabel( "" ), p, RIGHT )]]
		
		local p = vgui.Create( "Panel" )
		
		p:SetSize( 400, 20 )
		
		p:MoveAbove( self.Panels.HUD, 2 )
		p:CenterHorizontal( )
		
		p.Name = RPG:CheapLabel( "", p )
		
		p.Health = vgui.Create( "rpg_progress_bar", p )
		--p.Health:SetNoText( true )
		p.Health:SetSize( 100, 18 )
		
		p.Kills = RPG:CheapLabel( "", p )
		p.Rank = RPG:CheapLabel( "", p )

		function p.PerformLayout( this, w, h )
			this.Name:SizeToContents( )
			this.Kills:SizeToContents( )
			this.Rank:SizeToContents( )
			
			local targetw
			
			targetw = this.Name:GetWide( ) + this.Health:GetWide( ) + this.Kills:GetWide( ) + this.Rank:GetWide( ) + 32
			
			this.Name.X = w / 2 - targetw / 2
			
			this.Health:MoveRightOf( this.Name, 8 )
			this.Kills:MoveRightOf( this.Health, 8 )
			this.Rank:MoveRightOf( this.Kills, 8 )
			
			this.Name.Y = h / 2 - this.Name:GetTall( ) / 2
			this.Health.Y = h / 2 - this.Health:GetTall( ) / 2
			this.Kills.Y = h / 2 - this.Kills:GetTall( ) / 2
			this.Rank.Y = h / 2 - this.Rank:GetTall( ) / 2
		end


		
		self.Panels.InfoPanel = p
	end
	
	if not self.Panels.Menu then
		local p = vgui.Create( "DFrame" )
			p:SetTitle( "RPG Setup" )
			p:SetDraggable( true )
			p:ShowCloseButton( true )
			p:SetDeleteOnClose( false )
			
			local absminw, absminh, absmax, absmaxh
			
			absminw = 512
			absmaxw = ScrW( ) * .75
			
			absminh = 400
			absmaxh = ScrH( ) * .9
			
			local aw, ah
			
			aw = math.Clamp( ScrW( ), absminw, absmaxw )
			ah = math.Clamp( ScrH( ), absminh, absmaxh )
			
			p:SetSize( math.Clamp( ScrW( ), absminw, absmaxw ), math.Clamp( ScrH( ), absminh, absmaxh ) )
			p:Center( )
			
			local sheet = vgui.Create( "rpg_propertysheet", p )
			sheet:Dock( FILL )
				
			p.Sheets = { }
			
			local skills = vgui.Create( "Panel" )
			local home = vgui.Create( "Panel" )
			local npcfilter = vgui.Create( "Panel" )
			local swag = vgui.Create( "Panel" )
			local settings = vgui.Create( "Panel" )
			
			skills.Paint = GenericPaint
			home.Paint = GenericPaint
			npcfilter.Paint = GenericPaint
			swag.Paint = GenericPaint
			settings.Paint = GenericPaint
			
			p.Sheets.Skills = skills
			p.Sheets.Home = home
			p.Sheets.NpcFilter = npcfilter
			p.Sheets.Swag = swag
			p.Sheets.Settings = settings
			
			--Home stuff
			if 1 then
				home.LevelData = RPG:MakeLabel( "Level: 0/0", home, "ChatFont" )
				home.LevelData:SetPos( 4, 2 )
			
				home.Xp = RPG:MakeLabel( "Experience: 0/0", home, "ChatFont" )
				home.Xp:SetPos( 4, 2 )
				home.Xp:MoveBelow( home.LevelData, 2 )
			
				home.Rank = RPG:MakeLabel( "Rank: Loser", home, "ChatFont" )
				home.Rank:SetPos( 4, 2 )
				home.Rank:MoveBelow( home.Xp, 2 )
				
				home.Challenge = RPG:MakeLabel( "Server Level: 0", home, "ChatFont" )
				home.Challenge:SetPos( 4, 2 )
				home.Challenge:MoveBelow( home.Rank, 2 )
				
				home.Reset = vgui.Create( "Panel", home )
				home.Reset:DockMargin( 4, 0, 4, 4 )
				home.Reset.Paint = GenericPaint
				home.Reset:Dock( BOTTOM )
				home.Reset:SetTall( 200 )
				
				home.Divider = vgui.Create( "rpg_divider", home )
				home.Divider:SetTall( 40 )
				home.Divider:SetWide( p:GetWide( ) / 2 )
				home.Divider.Y = p:GetTall( ) - 320 - 40 - 2
				home.Divider.X = p:GetWide( ) / 4
				
				home.Respec = RPG:MakeButton( "Respec Skills", home )
				home.Respec:SizeToContents( )
				home.Respec:SetWide( 200 )
				home.Respec.OnMousePressed = function( )
					RunConsoleCommand( "rpg_respec_me" )
				end
				
				home.Respec.X = p:GetWide( ) / 2 - home.Respec:GetWide( ) / 2
				home.Respec:MoveAbove( home.Divider, 2 )
				
				local tip3 = RPG:MakeLabel( "Character Reset ( ^2this cannot be reversed!^ )", home, "ChatFont" )
				tip3.X = p:GetWide( ) / 2 - tip3:GetWide( ) / 2
				tip3.Y = p:GetTall( ) - 280 - tip3:GetTall( ) - 2
				
				local tip = RPG:MakeLabel( "???", home.Reset, "ChatFont" )
				tip:DockMargin( 8, 1, home.Reset:GetWide( ) / 2, 0 )
				tip:Dock( TOP )
				
				home.Reset.ResetCode = "000"
				
				home.Reset.A = vgui.Create( "DModelPanel", home.Reset )
				home.Reset.B = vgui.Create( "DModelPanel", home.Reset )
				home.Reset.C = vgui.Create( "DModelPanel", home.Reset )
				
				home.Reset.A.State = 0	home.Reset.B.State = 0	home.Reset.C.State = 0
				
				local them = { home.Reset.A, home.Reset.B, home.Reset.C } 
				
				CallMulti( "SetModel", them,  "models/props_lab/tpswitch.mdl" )
				CallMulti( "SetAnimated", them,  true )
				CallMulti( "SetAnimSpeed", them, 1 )
				CallMulti( "SetSize", them, 120, 120 )
				CallMulti( "SetPos", them, 20, 40 )
				
				home.Reset.A.LayoutEntity = void	home.Reset.B.LayoutEntity = void	home.Reset.C.LayoutEntity = void
											home.Reset.B:MoveRightOf( home.Reset.A, 4 )	home.Reset.C:MoveRightOf( home.Reset.B, 4 )
				
				local seq_idle, seq_open, seq_switch
				
				seq_idle = home.Reset.A.Entity:LookupSequence( "idle" )
				seq_open = home.Reset.A.Entity:LookupSequence( "open" )
				seq_switch = home.Reset.A.Entity:LookupSequence( "switch" )
				
				local tip2 = RPG:MakeLabel( "???", home.Reset, "ChatFont" )
				
				local green, yellow, red
				
				green = Color( 150, 255, 150, 255 )
				yellow = Color( 255, 100, 0, 255 )
				red = Color( 255, 0, 0, 255 )
				
				local function Think( this )
					this.lc = this.lc or Color( 150, 255, 150, 255 )
					
					if this.State == 0 then
						this.lc.r = math.Approach( this.lc.r, 150, FrameTime( ) * 255 )
						this.lc.g = math.Approach( this.lc.g, 255, FrameTime( ) * 255 )
						this.lc.b = math.Approach( this.lc.b, 150, FrameTime( ) * 255 )
					elseif this.State == 1 then
						this.lc.r = math.Approach( this.lc.r, 255, FrameTime( ) * 255 )
						this.lc.g = math.Approach( this.lc.g, 100, FrameTime( ) * 255 )
						this.lc.b = math.Approach( this.lc.b, 0, FrameTime( ) * 255 )
					elseif this.State == 2 then
						this.lc.r = math.Approach( this.lc.r, 255, FrameTime( ) * 255 )
						this.lc.g = math.Approach( this.lc.g, 0, FrameTime( ) * 255 )
						this.lc.b = math.Approach( this.lc.b, 0, FrameTime( ) * 255 )
					end
					
					this.rc = this.rc or Color( 255, 255, 255 )
					
					this.rc.r = ( this.lc.r + 200 ) / 2
					this.rc.g = ( this.lc.g + 200 ) / 2
					this.rc.b = ( this.lc.b + 200 ) / 2
					
					this:SetAmbientLight( this.rc )
					
					this:SetDirectionalLight( BOX_TOP, this.rc )
					this:SetDirectionalLight( BOX_FRONT, this.rc )
				end
				local function Click( this )
					this.State = this.State or 0
					this.NextInteraction = this.NextInteraction or CurTime( )
					
					if this.NextInteraction <= CurTime( ) then
						if this.State == 0 then
							this.State = 1
							this.Entity:ResetSequence( seq_open )
							surface.PlaySound( "items/ammocrate_open.wav" )
						elseif this.State == 1 then
							this.State = 2
							this.Entity:ResetSequence( seq_switch )
							surface.PlaySound( "buttons/lever7.wav" )
						end
						
						this.NextInteraction = CurTime( ) + this.Entity:SequenceDuration( ) * .75
					end
				end
				local function Reset( this )
					this.State = 0
					this.NextInteraction = CurTime( )
					this.Entity:ResetSequence( seq_idle )
				end
				
				home.Reset.A.Think = Think		home.Reset.B.Think = Think		home.Reset.C.Think = Think
				home.Reset.A.DoClick = Click	home.Reset.B.DoClick = Click	home.Reset.C.DoClick = Click
				home.Reset.A.Reset = Reset		home.Reset.B.Reset = Reset		home.Reset.C.Reset = Reset
				
				home.Reset.D = vgui.Create( "DModelPanel", home.Reset )
				home.Reset.D:SetModel( "models/props_lab/keypad.mdl" )
				
				home.Reset.D:SetAnimated( true )
				home.Reset.D:SetAnimSpeed( .5 )
				home.Reset.D:SetSize( 180, 180 )
				home.Reset.D.LayoutEntity = void2
				home.Reset.D:SetPos( 20, 10 )
				home.Reset.D:MoveRightOf( home.Reset.C, 4 )
				
				home.Reset.D.Buffer = ""
				
				local boxes = { 
					{ X = 60, Y = 105 }, 
					{ X = 82, Y = 105 },
					{ X = 104, Y = 105 },
					{ X = 60, Y = 127 },
					{ X = 82, Y = 127 },
					{ X = 104, Y = 127 },
					{ X = 60, Y = 149 },
					{ X = 82, Y = 149 },
					{ X = 104, Y = 149 },
				}
				local function Blink( this, i, sk )
					sk = sk or 2
					this.Entity:SetSkin( this.Entity:GetSkin( ) == sk and 0 or sk )
					
					if this.Entity:GetSkin( ) == 2 then
						surface.PlaySound( "buttons/button16.wav" )
					elseif this.Entity:GetSkin( ) == 1 then
						surface.PlaySound( "hl1/fvox/hiss.wav" )
						timer.Simple( SoundDuration( "hl1/fvox/hiss.wav" ), function( )
							surface.PlaySound( "hl1/fvox/deactivated.wav" )
							RunConsoleCommand( "rpg_reset_me", home.Reset.ResetCode )
							this.Blink = false
							this.Entity:SetSkin( 0 )
							p:Close( )
						end )
						
					end
					
					if ( i or 6 ) > 0 then
						timer.Simple( .17, function( )
							Blink( this, ( i or 1 ) - 1 )
						end )
					elseif i ~= -1 then
						this.Blink = false
						this.Entity:SetSkin( 0 )
					end
				end
				local function OnMousePressed( this, code )
						local x, y, k, v, w, h, i
						
						if this.Off or this.Blink then
							return
						end
						
						w = 22
						h = 22
						
						x, y = this:ScreenToLocal( gui.MousePos( ) )
						
						i = -1
						
						if #this.Buffer == 3 then
							return
						end
						
						surface.PlaySound( "ui/buttonclick.wav" )
						
						for k, v in ipairs( boxes ) do
							if v.X < x and v.X + w < x then
								continue
							end
							
							if v.Y < y and v.Y + h < y then
								continue
							end
							
							i = k
							break
						end
						
						this.Buffer = this.Buffer .. i
						
						if #this.Buffer == 3 then
							timer.Simple( .5, function( )
						
								if this.Buffer ~= home.Reset.ResetCode then
									this.Blink = true
									this.Buffer = ""
									Blink( this, 7 )
								else
									this.Blink = true
									this.Buffer = ""
									Blink( this, -1, 1 )
								end
							end )
						end
				end
				local function Reset( this )
					this.NextInteraction = CurTime( )
					this.Entity:SetSkin( 0 )
					this.Buffer = ""
				end
				local function PaintOver( this )
					--Draw buffer
					
					local x, y
						
					x, y = this:ScreenToLocal( gui.MousePos( ) )
					
					RPG:ShadowedText( "RpgFont", "RpgFontBlur", this.Buffer or "999", 90, 52, 2, color_white, TEXT_ALIGN_CENTER )
					--ShadowedText( "RpgFont", "RpgFontBlur", x, x, 0, 2, color_white, TEXT_ALIGN_CENTER )
					--ShadowedText( "RpgFont", "RpgFontBlur", y, x, 20, 2, color_white, TEXT_ALIGN_CENTER )
				end
				
				home.Reset.D.PaintOver = PaintOver
				home.Reset.D.Reset = Reset
				home.Reset.D.OnMousePressed = OnMousePressed
				
				home.Reset.Think = function( this )
					local msg = "???"
					
					if this.A.State ~= 2 then
						msg = this.A.State == 0 and "Open the first switch" or "Flip the first switch"
						tip2:SetVisible( false )
						this.D.Off = true
					elseif this.B.State ~= 2 then
						msg = this.B.State == 0 and "Open the second switch" or "Flip the second switch"
						tip2:SetVisible( false )
						this.D.Off = true
					elseif this.C.State ~= 2 then
						msg = this.C.State == 0 and "Open the third switch" or "Flip the third switch"
						tip2:SetVisible( false )
						this.D.Off = true
					else
						msg = "Confirm the reset code"
						
						tip2:SetVisible( true )
						
						this.D.Off = false
					end
					
					if tip:GetText( ) ~= msg then					
						tip:SetText( msg )
						tip:SizeToContents( )
					end
					
					if tip2:IsVisible( ) then
						msg = "Reset code: ^4" .. home.Reset.ResetCode .. "^"
						
						if tip2:GetText( ) ~= msg then
							tip2:SetText( msg )
							tip2:SizeToContents( )
							tip2.Y = tip.Y
							tip2.X = this.D.X + this.D:GetWide( ) / 2 - tip2:GetWide( ) / 2
							--tip2:MoveRightOf( this.D, 4 )
						end
					end
				end
			end
			
			--Skills stuff
			if 1 then
				local strip = vgui.Create( "Panel", skills )
				strip:Dock( TOP )
				strip:DockMargin( 4, 2, 4, 0 )
				
				skills.Points = RPG:MakeLabel( "Skill Points: 0", strip, "ChatFont" )
				skills.Points:SetPos( 4, 2 )
				skills.Points:Dock( LEFT )
				skills.Points:DockMargin( 4, 2, 4, 0 )
				
				skills.Tip1 = RPG:MakeLabel( "Hold Control to spend 5 points, Shift to spend 10", strip, "ChatFont" )
				skills.Tip1:Dock( RIGHT )
				skills.Tip1:DockMargin( 0, 2, 4, 4 )
				
				strip:SetTall( skills.Points:GetTall( ) + 8 )
				
				skills.Pod = vgui.Create( "DScrollPanel", skills )
				skills.Pod:Dock( FILL )
				skills.Pod:DockMargin( 4, 2, 1, 2 )
			
				skills.Items = vgui.Create( "DIconLayout", skills.Pod )
				skills.Items:Dock( FILL )
				skills.Items:SetLayoutDir( TOP )
				skills.Items:SetSpaceY( 2 )
				skills.Items.Rows = { }
				
				local k, v, row, m
				
				m = Material( "rpg/medical-pack-alt.png", "smooth" )
				
				for k, v in SortedPairs( self.Skills ) do
					row = skills.Items:Add( "rpg_skill_row" )
						row:SetSkill( v )
					skills.Items.Rows[ k ] = row
				end
			end
			
			--NpcFilter stuff
			if 1 then
				npcfilter.Pod = vgui.Create( "DScrollPanel", npcfilter )
				npcfilter.Pod:Dock( FILL )
				npcfilter.Pod:DockMargin( 4, 2, 1, 2 )
				
				npcfilter.Items = vgui.Create( "DIconLayout", npcfilter.Pod )
				npcfilter.Items:Dock( FILL )
				npcfilter.Items:SetSpaceY( 5 )
				npcfilter.Items:SetSpaceX( 5 )
				npcfilter.Items.Rows = { }
				
				for k, v in SortedPairsByMemberValue( list.Get( "NPC" ), "Name" ) do
					
					if not scripted_ents.Get( v.Class ) then
						continue
					end
					
					if scripted_ents.GetType( v.Class ) ~= "ai" and scripted_ents.GetMember( v.Class, "Base" ) ~= "base_nextbot" then
						continue
					end
				
					row = npcfilter.Items:Add( "Panel" )
						row:SetWide( 150 + 4 )
						row:SetTall( 132 + 16 + 4 )
						
						row.Paint = GenericPaint
						
						local m = Material( "entities/" .. v.Class )
						
						if m:IsError( ) then
							m = Material( "entities/" .. v.Class .. ".png", "smooth" )
						end
						
						if m:IsError( ) then
							m = Material( "vgui/entities/" .. v.Class )
						end
						
						if m:IsError( ) then
							m = Material( "vgui/entities/" .. v.Class .. ".png", "smooth" )
						end
						
						row.Icon = RPG:Image( m, row )
						
						if m:IsError( ) then
							row.Icon.Paint = RPG.Generics.Paint1
						end
						
						row.Desc = RPG:MakeLabel( v.Name, row, "RpgFontSmall" )
						
						row:SetCursor( "arrow" )
						
						row.Icon:SetSize( 128, 128 )
						row.Icon:SetPos( 2, 2 )
						
						row.Icon:CenterHorizontal( )
						
						row.Desc:MoveBelow( row.Icon, 2 )
						row.Desc:CenterHorizontal( )
						
						row.Adjust = vgui.Create( "Panel", row.Icon )
						row.Adjust.State = false
						row.Adjust:SetSize( 36, 36 )
						
						row.State = scripted_ents.GetMember( v.Class, "Base" ) ~= "base_nextbot"
						
						row.Adjust.OnMousePressed = function( this )
							surface.PlaySound( "ui/buttonclick.wav" )
							this.State = not this.State
							RunConsoleCommand( "rpg_equal_treatment", v.Class, this.State and 1 or 0 )
						end
						
						local green, red = Color( 000, 189, 000, 255 ), Color( 189, 000, 000, 255 )
						
						row.Adjust.Paint = function( this, w, h )
							RPG.Generics.Paint1( this, w, h )
							draw.DrawText( "c", "RpgWebdings", 1, -1, color_white, TEXT_ALIGN_LEFT )
							draw.DrawText( this.State and "a" or "r", "RpgWebdings", 1, -1, this.State and green or red, TEXT_ALIGN_LEFT )
						end
						
						row.Adjust:SetPos( row.Icon:GetWide( ) - 22, row.Icon:GetTall( ) - 22 )
						
						row.Adjust:SetCursor( "hand" )
					npcfilter.Items.Rows[ v.Class ] = row
				end
				
				npcfilter.Items:Layout( )
			end
			
			--Swag stuff
			if 1 then
				if self.DisableSwag then
					local x = RPG:MakeLabel( "Coming soon!", swag, "ChatFont" )
					
					x:Dock( FILL )
					x:SetContentAlignment( 5 )
				else
				--Swag store
					--Current swag label ( like skill points )
					--List of swag items to buy
						--Each item has an icon, an effect, a price, and if it is active
						--Only N swag items can be active at once
				end
			end
			
			--Settings stuff
			if 1 then
				if self.DisableSettings then
					local x = MakeLabel( "Coming soon!", settings, "ChatFont" )
					
					x:Dock( FILL )
					x:SetContentAlignment( 5 )
				else
					local hive = vgui.Create( "rpg_propertysheet", settings )
					hive:Dock( FILL )
					hive:DockMargin( 4, 4, 4, 4 )
					
					local warn = RPG:MakeLabel( "You will need to be an admin to change most of these", settings, "RpgFont" )
					warn:Dock( TOP )
					warn:DockMargin( 4, 2, 0, 2 )
					
					local skillc, ammoc, swagc, svc, admc, uic
					
					skillc = vgui.Create( "Panel" )
					ammoc = vgui.Create( "Panel" )
					swagc = vgui.Create( "Panel" )
					svc = vgui.Create( "Panel" )
					admc = vgui.Create( "Panel" )
					uic = vgui.Create( "Panel" )
					
					skillc.Paint = GenericPaint
					ammoc.Paint = GenericPaint
					swagc.Paint = GenericPaint
					svc.Paint = GenericPaint
					admc.Paint = GenericPaint
					uic.Paint = GenericPaint
					
					--Skill stuff
					if 1 then
						RPG:MakeLabel( "Watch this space!", skillc )
					end
					
					--Ammo stuff
					if 1 then
						local k, v, pod, items, row
						
						pod = vgui.Create( "DScrollPanel", ammoc )
						pod:Dock( FILL )
						pod:DockMargin( 1, 1, 1, 1 )
						
						items = vgui.Create( "DIconLayout", pod )
						items:Dock( FILL )
						items:SetLayoutDir( TOP )
						items:SetSpaceY( 1 )
						items:SetSpaceX( 1 )
						items.Rows = { }
						
						local silver = Color( 40, 40, 40, 255 )
						
						for k, v in SortedPairs( self.AmmoTypes ) do
							row = items:Add( "Panel" )
							row.Paint = function( this, w, h ) draw.RoundedBoxEx( 2, 0, 0, w, h, silver, true, true, false, false ) end
							row:SetWide( 500 )
							row.OwnLine = false
							row:SetCursor( "arrow" )
							
							row.Label = RPG:MakeLabel( k, row, "RpgFont", 200 )
							row.Label:DockMargin( 4, 2, 0, 0 )
							row.Label:Dock( LEFT )
							
							row.Slider = vgui.Create( "DSlider", row )
							
							row.Slider.Paint = self.Generics.Slider
							
							row.After = Label( "0", row, "RpgFont" )
							row.After:SetWide( 64 )
							
							local def = tonumber( self.Defaults[ k ] or ( v.GetDefault and v:GetDefault( ) ) ) or 1
							
							row.Slider:MoveRightOf( row.Label, 64 )
							row.After.Y = 2
							row.Slider.After = row.After
							row.Slider:SetSlideX( ( v:GetInt( ) - def ) / ( def * 3 ) )
							
							function row.Slider.Think( this )
								this.After:SetText( tostring( math.Round( def + def * 3 * this:GetSlideX( ) ) ) )
								
								this.LastX = this.LastX or this:GetSlideX( )
								
								if this.LastX ~= this:GetSlideX( ) then
									RunConsoleCommand( v:GetName( ), math.Round( def + def * 3 * this:GetSlideX( ) ) )
								end
								
								this.LastX = this:GetSlideX( )
							end
							
							--row.Slider:SetMin( def )
							--row.Slider:SetMax( def * 4 )
							--row.Slider:SetDecimals( 0 )
							--row.Slider:SetText( k )
							row.Slider:SetWide( 128 )
							row.Slider:SetTall( 20 )
							
							items.Rows[ k ] = row
						end
						
						local widest, width = nil, -1
						
						for k, v in pairs( items.Rows ) do
							if v.Label:GetWide( ) > width then
								widest = v.Label
								width = widest:GetWide( )
							end
						end
						
						for k, v in pairs( items.Rows ) do
							v:SetWide( width + 256 )
							v.Label:SetWide( width )
							v.Slider:MoveRightOf( v.Label, 4 )
							v.After:MoveRightOf( v.Slider, 8 )
						end
					end
					
					--Swag stuff
					if 1 then
					
					end
					
					--Server settings
					if 1 then
						local k, v
						
						svc.Pod = vgui.Create( "DScrollPanel", svc )
						svc.Pod:Dock( FILL )
						svc.Pod:DockMargin( 4, 2, 1, 2 )
						
						svc.Items = vgui.Create( "DIconLayout", svc.Pod )
						svc.Items:Dock( FILL )
						svc.Items:SetLayoutDir( TOP )
						svc.Items:SetSpaceY( 2 )
						svc.Items.Rows = { }
						
						for k, v in pairs( RPG.SettingsData.Server ) do
							local row
							
							row = svc.Items:Add( "Panel" )
								row.OwnLine = true
								row:SetWide( 512 )
							
								row.Label = RPG:MakeLabel( k, row )
								row.Label:Dock( LEFT )
								
								row.Button = vgui.Create( "rpg_cookie_button", row )
									row.Button:SetCookie( v )
									row.Button.X = row:GetWide( ) - row.Button:GetWide( ) - 2
									row.Button:CenterVertical( )
						end
						
						local function ConVarSlider( lbl, cvar, f, def, s, places, min )
							local k, v
							
							min = min or 0
							places = places or 0
							
							k = svc.Items:Add( "Panel" )
							k:SetSize( 240, 44 )
							--k.OwnLine = true
							
							k.Label = RPG:MakeLabel( lbl, k )
							k.Label:Dock( TOP )
							
							k.Slider = vgui.Create( "DSlider", k )
							k.Slider:SetSize( 128, 20 )
							k.Slider:SetPos( 1, 20 )
							k.Slider.Paint = self.Generics.Slider
							
							k.After = RPG:MakeLabel( "0", k )
							k.After:MoveRightOf( k.Slider, 2 )
							k.After.Y = 24
							k.Slider.After = k.After
							
							k.Slider:SetSlideX( f( cvar ) / ( def * s ) )
							k.After:SetText( tostring( math.Round( f( cvar ), places ) ) )
							
							function k.Slider.Think( this )
								this.LastX = this.LastX or this:GetSlideX( )
								this.LastV = this.LastV or f( cvar )
								
								if f( cvar ) ~= this.LastV then
									this.After:SetText( tostring( math.Round( f( cvar ), places ) ) )
									this:SetSlideX( f( cvar ) / ( def * s ) )
									this.LastX = this:GetSlideX( )
								end
								
								this.LastV = f( cvar )
								
								if this.LastX ~= this:GetSlideX( ) then
									this.After:SetText( tostring( math.Round( min + ( def * s - min ) * this:GetSlideX( ), places ) ) )
									RunConsoleCommand( cvar:GetName( ), tostring( math.Round( min + ( def * s - min ) * this:GetSlideX( ), places ) ) )
								end
							
								this.LastX = this:GetSlideX( )
							end
							
							k.Reset = RPG:MakeButton( "Reset", k )
							k.Reset:SizeToContents( )
							k.Reset:SetPos( 168, 12 )
							
							k.Reset.OnMouseReleased = function( )
								surface.PlaySound( "buttons/button3.wav" )
								RunConsoleCommand( cvar:GetName( ), def )
							end
						end
						
						k = svc.Items:Add( "rpg_divider" )
						k:SetTall( 40 )
						k:SetWide( 600 )
						k:SetHalfSize( true )
						k.OwnLine = true
						
						local v = GetConVar( "rpg_cfg_staticamt" )
						
						ConVarSlider( "Ammo Regen. Amount", v, v.GetInt, tonumber( v:GetDefault( ) ) or 30, 4, 0, 1 )
						
						local v = GetConVar( "rpg_cfg_xpscale" )
						
						ConVarSlider( "Experience Scale", v, v.GetFloat, tonumber( v:GetDefault( ) ) or 1, 8, 2, .1 )
						
						local v = GetConVar( "rpg_cfg_championchance" )
						
						ConVarSlider( "Champion Monster Rate", v, v.GetFloat, tonumber( v:GetDefault( ) ) or 1, 1000, 0, 0 )
					end
					
					--Admin stuff
					if 1 then
						RPG:MakeLabel( "Watch this space!", admc )
					end
					
					--UI settings
					if 1 then
						local k, v
						
						uic.Pod = vgui.Create( "DScrollPanel", uic )
						uic.Pod:Dock( FILL )
						uic.Pod:DockMargin( 4, 2, 1, 2 )
			
						uic.Items = vgui.Create( "DIconLayout", uic.Pod )
						uic.Items:Dock( FILL )
						uic.Items:SetLayoutDir( TOP )
						uic.Items:SetSpaceY( 2 )
						uic.Items.Rows = { }
						
						for k, v in pairs( RPG.SettingsData.UI ) do
							local row
							
							row = uic.Items:Add( "Panel" )
								row.OwnLine = true
								row:SetWide( 512 )
							
								row.Label = RPG:MakeLabel( k, row )
								row.Label:Dock( LEFT )
								
								row.Button = vgui.Create( "rpg_cookie_button", row )
									row.Button:SetCookie( v )
									row.Button.X = row:GetWide( ) - row.Button:GetWide( ) - 2
									row.Button:CenterVertical( )
								
						end
					end
					
					hive:AddSheet( "Skills", skillc )
					hive:AddSheet( "Ammo Limits", ammoc )
					
					if self.DisableSwag then
						swagc:Remove( )
					else
						hive:AddSheet( "Swag", swagc )
					end
					
					hive:AddSheet( "Server", svc )
					hive:AddSheet( "Administration", admc )
					hive:AddSheet( "UI Controls", uic )
				--Multiple tabs
					--Skill control - enabled/disabled, required level, max level, value scaler
					--Ammo control - enable/disable regeneration, regeneration scale, adjust maximum from 0 to default * 4
					--Swag control - like ammo/skill control, but for swag
					--Server settings - enable/disable swag usage, xp scale, etc
					--Admin control - adjust/view player data - award/set levels, give skill points, set skills, etc
				end
			end
			
			sheet:AddSheet( "Home", home )
			sheet:AddSheet( "Skills", skills )
			sheet:AddSheet( "Manage Extra NPCs", npcfilter )
			if self.DisableSettings then
				settings:Remove( )
			else
				sheet:AddSheet( "Settings", settings )
			end
			if self.DisableSwag then
				swag:Remove( )
			else
				sheet:AddSheet( "Swag", swag )
			end
			
			p:MakePopup( )
			p:Close( )
		self.Panels.Menu = p
	else
		--local colors = { "white", "red", "green", "blue", "yellow", "purple" }
		
		if not pl.RpgData then
			self:PreparePlayer( pl )
		end
		
		UpdateLabel( self.Panels.Menu.Sheets.Home.LevelData, string.format( "Level: ^4%d^/^4%d^", pl.RpgData.Level, self.MAX_LEVEL ) )
		UpdateLabel( self.Panels.Menu.Sheets.Home.Rank, string.format( "Rank: ^6%s^", self:GetRank( pl ) ) )
		UpdateLabel( self.Panels.Menu.Sheets.Home.Xp, string.format( "Experience: ^3%d^/^3%d^", pl.RpgData.XP, self:GetNextLevel( pl ) ) )
		UpdateLabel( self.Panels.Menu.Sheets.Home.Challenge, string.format( "Server Level: ^2%3.1f^", self:AverageLevel( ) ) )
		
		UpdateLabel( self.Panels.Menu.Sheets.Skills.Points, string.format( "Skill Points: %d", pl.RpgData.SkillPoints ) )
		
		for k, v in pairs( self.Panels.Menu.Sheets.Skills.Items.Rows ) do
			UpdateItem( v, k, pl )
		end
		
		for k, v in pairs( self.Panels.Menu.Sheets.NpcFilter.Items.Rows ) do
			v.Adjust.State = self.SpecialTreatment[ k ]
		end
		
		self.Panels.Menu.Sheets.NpcFilter.Items:Layout( )
	end
end

function RPG:ShowMenu( rcode )
	local pl, wep
	
	pl = LocalPlayer( )
	
	if IsValid( pl ) and IsValid( pl:GetActiveWeapon( ) ) then
		wep = pl:GetActiveWeapon( )
		
		
		--Don't open the menu while someone is customizing their weapon
		if wep.CW20Weapon then	
			if wep.dt.State == CW_CUSTOMIZE then
				return
			end
		elseif wep.IsFAS2Weapon then
			if wep.dt.Status == FAS_STAT_ADS or wep.dt.Status == FAS_STAT_CUSTOMIZE then
				return
			end
		end
	end


	RPG:RebuildUI( )
	
	self.Panels.Menu.Sheets.Home.Reset.A:Reset( )
	self.Panels.Menu.Sheets.Home.Reset.B:Reset( )
	self.Panels.Menu.Sheets.Home.Reset.C:Reset( )
	self.Panels.Menu.Sheets.Home.Reset.D:Reset( )
	
	self.Panels.Menu.Sheets.Home.Reset.ResetCode = rcode
	
	self.Panels.Menu:Center( )
	self.Panels.Menu:SetVisible( true )
	self.Panels.Menu:MakePopup( )
end

local function HUDPaint( )
	local w = LocalPlayer( ):GetActiveWeapon( )
	
	if not ValidPanel( RPG.Panels.HUD ) then
		return
	end
	
	if w:IsValid( ) and w:GetClass( ) == "gmod_camera" then
		RPG.Panels.HUD:SetVisible( false )
		RPG.Panels.HUD.LevelBit:SetVisible( false )
	else
		RPG.Panels.HUD:SetVisible( true )
		RPG.Panels.HUD.LevelBit:SetVisible( true )
	end
end

local function ccRecreateUI( )
	local k, v
	
	for k, v in pairs( RPG.Panels ) do
		v:Remove( )
		RPG.Panels[ k ] = nil
	end
	
	RPG:RebuildUI( )
end

concommand.Add( "rpg_kick_me", ccRecreateUI )

hook.Add( "HUDPaint", "RPG.HideHUD", HUDPaint )