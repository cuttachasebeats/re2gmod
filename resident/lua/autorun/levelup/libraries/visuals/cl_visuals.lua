/*---------------------------------------------------------------------------
	Functionality
---------------------------------------------------------------------------*/
visuals = {}
function visuals.drawRect( x, y, w, h, color )
	surface.SetDrawColor( color )
	surface.DrawRect( x, y, w, h )
end

function visuals.drawFilledRect( x, y, w, h, color, fill )
	surface.SetDrawColor( color )
	surface.DrawRect( x, y, w * fill, h )
end

function visuals.drawFloatingText( text, x, y, speed, peak, color, xAlign, yAlign )
	draw.SimpleText( text, "Default", x, y + math.sin( RealTime() * speed ) * peak, color, xAlign, yAlign )
end

function visuals.drawLine( startPos, endPos, color )
	surface.SetDrawColor( color )
	surface.DrawLine( startPos[1], startPos[2], endPos[1], endPos[2] )
end

function visuals.drawRectOutline( x, y, w, h, color )
	surface.SetDrawColor( color )
	surface.DrawOutlinedRect( x, y, w, h )
end

function visuals.drawTexturedRect( x, y, w, h, material )
	surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
	surface.SetMaterial( material )
	surface.DrawTexturedRect( x, y, w, h )
end

local blur = Material( "pp/blurscreen" )
function visuals.drawBlur( x, y, w, h, layers, density, alpha )
	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	for i = 1, layers do
		blur:SetFloat( "$blur", ( i / layers ) * density )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		render.SetScissorRect( x, y, x + w, y + h, true )
			surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
		render.SetScissorRect( 0, 0, 0, 0, false )
	end
end

function visuals.drawPanelBlur( panel, layers, density, alpha )
	local x, y = panel:LocalToScreen(0, 0)

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	for i = 1, 3 do
		blur:SetFloat( "$blur", ( i / layers ) * density )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
	end
end

function visuals.drawPoly( color, structure )
	surface.SetDrawColor( color )
	surface.DrawPoly( structure )
end

local shape = {}
local sliceAng = 0
function visuals.drawCircle( x, y, color, radius, width, slices, fill )
	--Fix position
	radius = radius / 2
	x = x + radius
	y = y + radius

	shape = {}
	sliceAng = math.rad( 360/slices )

	if width then
		for i = -slices * fill - ( slices * 0.25 ), -1 - ( slices * 0.25 ) do
			shape[ 1 ] = 
			{ 
				x = x + radius * math.cos( sliceAng * i ),
				y = y + radius * math.sin( sliceAng * i ),
			}
			shape[ 2 ] = 
			{ 
				x = x + ( radius - width ) * math.cos( sliceAng * i ),
				y = y + ( radius - width ) * math.sin( sliceAng * i ),
			}
			shape[ 3 ] =
			{
				x = x + ( radius - width ) * math.cos( sliceAng * ( i + 1) ),
				y = y + ( radius - width ) * math.sin( sliceAng * ( i + 1) ),
			}
			shape[ 4 ] =
			{
				x = x + radius * math.cos( sliceAng * ( i + 1) ),
				y = y + radius * math.sin( sliceAng * ( i + 1) ),
			}
			visuals.drawPoly( color, shape )
		end
	else
		for i = -slices * fill - ( slices * 0.25 ), -1 - ( slices * 0.25 ) do
			shape[ 1 ] = 
			{ 
				x = x + radius * math.cos( sliceAng * i ),
				y = y + radius * math.sin( sliceAng * i ),
			}
			shape[ 2 ] =
			{
				x = x + radius * math.cos( sliceAng * ( i + 1) ),
				y = y + radius * math.sin( sliceAng * ( i + 1) ),
			}
			shape[ 3 ] =
			{
				x = x - radius,
				y = y - radius,
			}
			visuals.drawPoly( color, shape )
		end
	end
end