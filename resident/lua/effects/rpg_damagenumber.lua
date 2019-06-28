EFFECT.Colors = { 
	[DMG_GENERIC] = Color( 255, 255, 255 ), --white
	[DMG_BURN] = Color( 255, 127, 0, 255 ), --orange, colorwheel
	[DMG_SLOWBURN] = Color( 255, 88, 0, 255 ), --orange, pantone
	[DMG_PLASMA] = Color( 157, 144, 255, 255 ), --lilac/blue purple
	[DMG_POISON] = Color( 138, 154, 91, 255 ), --moss green
	[DMG_ACID] = Color( 11, 218, 81, 255 ), --malachite green
	[DMG_SHOCK] = Color( 0, 135, 189, 255 ), --azure / blue, ncs
	[DMG_BLAST] = Color( 255, 239, 0, 255 ), --canary yellow
	[DMG_BUCKSHOT] = Color( 240, 234, 214, 255 ), --eggshell white
	[DMG_CLUB] = Color( 227, 217, 201, 255 ), --bone white
	[DMG_SLASH] = Color( 199, 21, 133, 225 ), --red violet
	[DMG_CRUSH] = Color( 159, 129, 112, 255 ), --beaver brown
	[DMG_RADIATION] = Color( 242, 252, 255, 255 ), --metal halide
	[DMG_NERVEGAS] = Color( 255, 209, 178, 255 ), --sodium vapor
	[DMG_ENERGYBEAM] = Color( 0, 147, 175, 255 ), --blue, munsell
}

EFFECT.Models = { Model( "models/letters/0.mdl" ),
Model( "models/letters/1.mdl" ),
Model( "models/letters/2.mdl" ),
Model( "models/letters/3.mdl" ),
Model( "models/letters/4.mdl" ),
Model( "models/letters/5.mdl" ),
Model( "models/letters/6.mdl" ),
Model( "models/letters/7.mdl" ),
Model( "models/letters/8.mdl" ),
Model( "models/letters/9.mdl" ),
Model( "models/letters/emark.mdl" ),
}

EFFECT.AltMat = Material( "models/debug/debugwhite" )

function EFFECT:Init( data )
	local i = data:GetDamageType( )
	
	i = bit.band( i, bit.bnot( DMG_DIRECT ) )
	i = bit.band( i, bit.bnot( DMG_NEVERGIB ) )
	i = bit.band( i, bit.bnot( DMG_DISSOLVE ) )
	i = bit.band( i, bit.bnot( DMG_REMOVENORAGDOLL ) )
	i = bit.band( i, bit.bnot( DMG_DROWNRECOVER ) )
	i = bit.band( i, bit.bnot( DMG_ALWAYSGIB ) )
	i = bit.band( i, bit.bnot( DMG_PREVENT_PHYSICS_FORCE ) )
	i = bit.band( i, bit.bnot( DMG_PARALYZE ) )
	i = bit.band( i, bit.bnot( DMG_VEHICLE ) )

	self.Origin = data:GetOrigin( )
	self.Color = self.Colors[ i ] or color_white
	self.IsCrit = data:GetAttachment( ) == 1
	self.Dir = data:GetScale( )
	self.Amount = math.Round( data:GetMagnitude( ) )
	
	local p, f
	
	p = self.Origin
	
	self.Letters = { }
	
	if RPG.Cookies.DamageNumbers:IsNot( 1 ) or ( RPG.Cookies.DamageNumberSelf:Is( 1 ) and data:GetEntity( ) ~= LocalPlayer( ) ) then
		self.DieTime = 0
		return
	end
	
	self.DieTime = CurTime( ) + 8
	
	while self.Amount > 0 do
		local n = self.Amount % 10
		
		self.Amount = math.floor( self.Amount / 10 )
		
		local e = ents.CreateClientProp( )
		e:SetNoDraw( true )
		e:SetModel( self.Models[ n + 1 ] )
		e:SetAngles( Angle( 0, self.Dir + 90, 0 ) )
		e:SetPos( p )
		e:SetRenderMode( RENDERMODE_TRANSALPHA )
		
		if not IsValid( f ) then
			f = e
		end
		
		e:SetModelScale( .2, 0 )
		
		e:SetColor( self.Color )
		e:Spawn( )
		
		timer.Simple( .8 + math.Rand( -.1, .1 ), function( )
			e:Activate( )
			e:PhysicsInit( SOLID_VPHYSICS )
			e:SetSolid( SOLID_VPHYSICS )
			e:SetMoveType( MOVETYPE_VPHYSICS )
			e:SetCollisionGroup( COLLISION_GROUP_DEBRIS )

			local o = e:GetPhysicsObject( )
			
			if o:IsValid( ) then
				o:Wake( )
				o:EnableGravity( false )
				o:SetMaterial( "gmod_silent" )
				o:SetVelocity( VectorRand( ) * math.Rand( -1, 1 ) * o:GetMass( ) )
			end
			
			timer.Simple( math.Rand( .1, .3 ), function( )
				if IsValid( o ) then
					o:EnableGravity( true )
				end
			end )
		end )
		
		SafeRemoveEntityDelayed( e, 8 )
		
		p = p + e:GetAngles( ):Forward( ) * 3
		
		table.insert( self.Letters, e )
	end
	
	if self.IsCrit then
		local e = ents.CreateClientProp( )
		e:SetNoDraw( true )
		e:SetModel( self.Models[ 11 ] )
		e:SetAngles( Angle( 0, self.Dir + 90, 0 ) )
		e:SetPos( self.Origin + e:GetAngles( ):Forward( ) * -3 )
		e:SetRenderMode( RENDERMODE_TRANSALPHA )
		e.Crit = true
		
		e:SetModelScale( .2, 0 )
		e:SetColor( Color( 255, 0, 150, 255 ) )
		
		e:Spawn( )
		
		timer.Simple( .8 + math.Rand( -.1, .1 ), function( )
			e:Activate( )
			e:PhysicsInit( SOLID_VPHYSICS )
			e:SetSolid( SOLID_VPHYSICS )
			e:SetMoveType( MOVETYPE_VPHYSICS )
			e:SetCollisionGroup( COLLISION_GROUP_DEBRIS )

			local o = e:GetPhysicsObject( )
			
			if o:IsValid( ) then
				o:Wake( )
				o:EnableGravity( false )
				o:SetMaterial( "gmod_silent" )
				o:SetVelocity( VectorRand( ) * math.Rand( -1, 1 ) * o:GetMass( ) )
			end
			
			timer.Simple( math.Rand( .1, .3 ), function( )
				if IsValid( o ) then
					o:EnableGravity( true )
				end
			end )
		end )
		
		SafeRemoveEntityDelayed( e, 8 )
		
		table.insert( self.Letters, e )		
	end
end

function EFFECT:Think( )
	local f, k, v

	return self.DieTime > CurTime( )
end

EFFECT.ToneScale = Vector( .75, .75, .75 )

function EFFECT:Render( )
	local k, v, r, z
	
	z = render.GetToneMappingScaleLinear( )
	
	render.SetToneMappingScaleLinear( self.ToneScale )
	
	render.SuppressEngineLighting( true )
	cam.IgnoreZ( true )
	
	if RPG.Cookies.DamageNumberMat:Is( 1 ) then
		render.MaterialOverride( self.AltMat )
	end
	
	if self.DieTime - CurTime( ) <= 4 then
		render.SetBlend( math.max( 0, self.DieTime - CurTime( ) ) / 4 )
	end
	
	
	
	render.SetBlend( 1 )
	
	if RPG.Cookies.DamageNumberMat:Is( 1 ) then
		render.MaterialOverride( )
	end
	
	render.SuppressEngineLighting( false )
	cam.IgnoreZ( false )
	
	render.SetToneMappingScaleLinear( z )
	
	return false
end