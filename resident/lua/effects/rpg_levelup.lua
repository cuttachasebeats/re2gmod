function EFFECT:Init( data )
	self.Player = { data:GetEntity( ) }
	self.DieTime = CurTime( ) + 3
	self.Color = Color( math.random( 255 ), math.random( 255 ), math.random( 255 ), 255 )
	
	if data:GetEntity( ) == LocalPlayer( ) or RPG.Cookies.LevelUpEffect:Is( 0 )  then
		self.DieTime = -1
		return
	end
	
	self.Emitter = ParticleEmitter( data:GetEntity( ):GetPos( ), true )
	self.Emitter:SetParticleCullRadius( 32 )
	
	hook.Add( "PreDrawHalos", self, function( )
		self.Color = HSVToColor( ( CurTime( ) * 4 ) % 360, math.cos( CurTime( ) * 8 ) * .25 + .75, .8 )
		halo.Add( self.Player, self.Color, 3, 3, 2 )
	end )
end

function EFFECT:Think( )
	if self.DieTime > 0 and self.Player[ 1 ]:IsValid( ) then
	
		local i, p
		
		for i = 1, 16 do
			p = self.Emitter:Add( "sprites/physg_glow2", self.Player[ 1 ]:LocalToWorld( self.Player[ 1 ]:OBBCenter( ) ) )
				p:SetAngles( VectorRand( ):Angle( ) )
				p:SetVelocity( VectorRand( ) * 30 )
				p:SetColor( self.Color.r, self.Color.g, self.Color.b )
				p:SetLifeTime( 0 )
				p:SetDieTime( 2 )
				p:SetStartAlpha( 255 )
				p:SetEndAlpha( 0 )
				p:SetStartSize( 1.6 )
				p:SetStartLength( 1 )
				p:SetEndSize( 1.2 )
				p:SetEndLength( .6 )
		end
	
		if self.DieTime <= CurTime( ) then
			self.Emitter:Finish( )
		end
	end
	
	return self.DieTime > CurTime( )
end

function EFFECT:Render( )
	return false
end