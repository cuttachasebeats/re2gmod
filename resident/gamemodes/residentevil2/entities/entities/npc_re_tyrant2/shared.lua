ENT.Base 			= "base_entity"
ENT.Type 			= "ai"

ENT.Author			= "ERROR"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.AutomaticFrameAdvance = false

ENT.Spawnable = false
ENT.AdminOnly = false

function ENT:OnRemove()
end


function ENT:PhysicsUpdate( physobj )
end

function ENT:PhysicsCollide( data, physobj )
end

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end