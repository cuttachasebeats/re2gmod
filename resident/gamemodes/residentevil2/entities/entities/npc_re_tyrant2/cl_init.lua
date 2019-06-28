include( "shared.lua" )

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
	self.Entity:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end

/*
net.Receive("Tyrant_VictimRagdoll",function()
	local TEMP_Doll = net.ReadEntity()
	local TEMP_IsDoll = net.ReadBool()
	local TEMP_Id = net.ReadString()
	local TEMP_Onwer = net.ReadEntity()
	local TEMP_Color = net.ReadVector()
						
	
	if(IsValid(TEMP_Doll)) then
		TEMP_Doll.player_ragdoll = TEMP_IsDoll
		TEMP_Doll.uqid = TEMP_Id
		TEMP_Doll.PlayerOwner = TEMP_Onwer
		TEMP_Doll.PlayerColor = TEMP_Color

		TEMP_Doll:SetOwner(TEMP_Onwer)
		
		if(TEMP_Doll.SetPlayerColor) then
			TEMP_Doll:SetPlayerColor(TEMP_Onwert:GetPlayerColor())
		end
		print("Gud")
	end
end)*/


net.Receive("TyrantRagdoll",function()
	local TEMP_ENT = net.ReadEntity()
	
	if(IsValid(TEMP_ENT)&&TEMP_ENT!=nil&&TEMP_ENT!=NULL) then
		local Doll = TEMP_ENT:BecomeRagdollOnClient()

		Doll:SetMaterial("")
		Doll:SetColor(Color(255,255,255,255))
		Doll:RemoveAllDecals()
		Doll:DrawShadow(true)
	end
end)



net.Receive("TyrantCloth",function()
	local TEMP_VEC = net.ReadVector()
	local TEMP_MIN = net.ReadVector()
	local TEMP_MAX = net.ReadVector()
	local TEMP_Emitter = ParticleEmitter(TEMP_VEC, true)
	
	if(IsValid(TEMP_Emitter)) then
		
		for P=1,90 do
			local TEMP_Particle = TEMP_Emitter:Add( "particles/Tyrant_cloth/cloth"..math.random(1,7), TEMP_VEC+
			Vector(math.random(TEMP_MIN.x,TEMP_MAX.x),math.random(TEMP_MIN.y,TEMP_MAX.y),math.random(TEMP_MIN.z+20,TEMP_MAX.z)))
			local TEMP_Size = math.random(8,13)
			TEMP_Particle:SetDieTime( 3 )
			TEMP_Particle:SetStartAlpha( 255 )
			TEMP_Particle:SetEndAlpha( 255 )
			TEMP_Particle:SetStartSize( TEMP_Size )
			TEMP_Particle:SetEndSize( TEMP_Size )
			TEMP_Particle:SetColor( 255, 255, 255 )
			TEMP_Particle:SetGravity(Vector(0,0,-100))
			TEMP_Particle:SetAngles(AngleRand())
			TEMP_Particle:SetCollide(false)
			TEMP_Particle:SetVelocity((VectorRand()+Vector(0,0,0.5))*math.random(100,120))
			TEMP_Particle:SetRoll( math.Rand( 60, 120 ) )
			TEMP_Particle:SetAngleVelocity( Angle(math.Rand(-100,100),math.Rand(-100,100),math.Rand(-100,100)))
		end
		
		TEMP_Emitter:Finish()
	end
end)