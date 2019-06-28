local PLY = FindMetaTable("Player")

function PLY:BecomeCrow()
		self:UnSpectate()

		if self.CrowEnt != nil then
			self.CrowEnt:SetPos(self:GetPos() )
			self.CrowEnt:SetAngles(self:GetAngles())
		else
			self.CrowEnt = ents.Create("prop_dynamic")
			self.CrowEnt:SetModel("models/error.mdl")
			self.CrowEnt:Spawn()
			self.CrowEnt:SetAngles(self:GetAngles())
			self.CrowEnt:SetMoveType(MOVETYPE_NONE)
			self.CrowEnt:SetParent(self)
			self.CrowEnt:SetPos(self:GetPos() )
			self.CrowEnt:SetRenderMode(RENDERMODE_NONE)
			self.CrowEnt:SetSolid(SOLID_NONE)
			self.CrowEnt:SetNoDraw(true)
			self:SetViewEntity(self.CrowEnt)
		end

		self:SetModel("models/crow.mdl")
		self:SetHull( Vector(-8,-8,0) ,Vector(8,8,10))
		self:SetHullDuck( Vector(-8,-8,0) ,Vector(8,8,10))
		self:SetViewOffset(Vector(0,0,5))
		self:SetViewOffsetDucked(Vector(0,0,5))
		self:SetAllowFullRotation(true)
		self:SetMoveType(MOVETYPE_FLY)
		self:Give("weapon_peck")
		self:SelectWeapon("weapon_peck")
		self:SetHealth(10)
		GAMEMODE:SetPlayerSpeed(self,self:GetNWInt("Speed")*3,self:GetNWInt("Speed")*3)
		if #ents.FindByClass("Re2_player_round_Start") != 0 then
			local randomspawnpoint = table.Random(ents.FindByClass("Re2_player_round_Start"))
			self:SetPos(randomspawnpoint:GetPos() + Vector(0,0,60))
		end

end

--------------------Bypass Player Phyics For Crows

function GM:Move( ply, mv )
	if GetGlobalBool("Re2_Crows") then
		if ply:Team() != TEAM_HUNK && ply:GetMoveType() != MOVETYPE_WALK && ply:OnGround() then
			ply:SetMoveType(MOVETYPE_WALK)
			if SERVER then
				ply:SetAllowFullRotation(false)
				GAMEMODE:SetPlayerSpeed(ply,ply:GetNWInt("Speed"),ply:GetNWInt("Speed"))
			end
		elseif ply:Team() != TEAM_HUNK && ply:GetMoveType() != MOVETYPE_FLY && !ply:OnGround() then
			ply:SetMoveType(MOVETYPE_FLY)
			if SERVER then
				ply:SetAllowFullRotation(true)
				GAMEMODE:SetPlayerSpeed(ply,ply:GetNWInt("Speed")*3,ply:GetNWInt("Speed")*3)
			end
		end
		if ply:GetMoveType() == MOVETYPE_FLY && ply:Team() != TEAM_HUNK && ply:GetMoveType() != MOVETYPE_WALK then
			ply:SetVelocity(Vector(ply:GetVelocity().x * -0.1,ply:GetVelocity().y * -0.1, ply:GetVelocity().z * -0.1))
		end
	end
end