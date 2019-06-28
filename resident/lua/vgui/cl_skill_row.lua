local p = { }

local m = Material( "rpg/medical-pack-alt.png", "smooth" )
local grey = Color( 100, 100, 100, 255 )

function p:SetSkill( sk )
	if self.Icon:IsValid( ) then
		self.Icon:Remove( )
		self.Icon = nil
	end
	
	self.Icon = RPG:Image( sk:GetIcon( ), self )
	self.Icon:SetSize( 80, 80 )
	
	self.Name:SetText( "$RpgFontBold$" .. sk:GetName( ) .. "$" )
	
	self.Buy.Skill = sk
end

function p:Init( )
	self.OwnLine = true

	self.Name = RPG:MakeLabel( "$RpgFontBold$" .. "????" .. "$", self, "ChatFont" )
	self.Desc = RPG:MakeLabel( "Description", self, "ChatFont" )
	self.Level = RPG:MakeLabel( "0/0", self, "ChatFont" )
	
	self.Icon = RPG:Image( Material( "editor/obsolete", "unlit smooth" ), self )
	
	self.Buy = vgui.Create( "DImage", self )
	self.Buy:SetMouseInputEnabled( true )
	self.Buy:SetMaterial( m )
	self.Buy:SetSize( 24, 24 )
	
	function self.Buy.OnMousePressed( this )
		local cost, i
		cost = 1

		if input.IsKeyDown( KEY_LCONTROL ) or input.IsKeyDown( KEY_RCONTROL ) then
			cost = 5
		elseif input.IsKeyDown( KEY_LSHIFT ) or input.IsKeyDown( KEY_RSHIFT ) then
			cost = 10
		end

		if LocalPlayer( ).RpgData.SkillPoints >= cost and this.Skill:GetEnabled( ) then
			surface.PlaySound( "ui/buttonclick.wav" )

			for i = 1, cost do
				RunConsoleCommand( "rpg_purchase_skill", this.Skill:GetID( ) )
			end
		end
	end
	
	self.Buy.Think = function( this )
		local last, pl
		
		last = this.On
		pl = LocalPlayer( )
		
		if not pl.RpgData then
			return
		end
		
		this.On = pl.RpgData.SkillPoints > 0
							
		if last ~= this.On then
			this:SetImageColor( this.On and color_white or grey )
		end
	end
	
	self:SetCursor( "arrow" )
	self.Buy:SetCursor( "hand" )
end

function p:PerformLayout( w, h )
	self.Icon:SetPos( 4, 8 )
	self.Buy:SetPos( w - self.Buy:GetWide( ) * 2 - 4, h - self.Buy:GetTall( ) - 4 )
	
	self.Name:SetPos( 4, 2 )
	self.Name:MoveRightOf( self.Icon, 16 )
	
	self.Desc:SetForceW( w - 100 )
	self.Desc:SetPos( 4, 2 )
	self.Desc:MoveRightOf( self.Icon, 16 )
	self.Desc:MoveBelow( self.Name, 2 )
	
	self.Level:MoveRightOf( self.Icon, 16 )
	self.Level:MoveBelow( self.Desc, 20 )
	
	if h < math.max( 90, self.Level.Y + self.Level:GetTall( ) ) then
		self:SetTall( math.max( 90, self.Level.Y + self.Level:GetTall( ) + 2 ) )
	end
end

function p:Think( )
	if self:GetWide( ) ~= self:GetParent( ):GetWide( ) then
		self:SetWide( self:GetParent( ):GetWide( ) )
	end
end

p.Paint = RPG.Generics.Gradient

vgui.Register( "rpg_skill_row", p )