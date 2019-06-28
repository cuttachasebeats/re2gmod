AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	local itemtype = GAMEMODE:str_SelectRandomItem()
	local item = ents.Create("item_base")
	item:SetNWString("Class", itemtype)
	item:SetPos(self.Entity:GetPos())
	item:Spawn()
	item:SetPos(self:GetPos())
	item:SetAngles(self:GetAngles())
	item:Spawn()
	self:Remove()
end
function ENT:OnTakeDamage(dmginfo)
end
function ENT:StartTouch(ent)
end
function ENT:EndTouch(ent)
end
function ENT:AcceptInput(name,activator,caller)
end
function ENT:KeyValue(key,value)
end
function ENT:OnRemove()
end
function ENT:OnRestore()
end
function ENT:PhysicsCollide(data,physobj)
end
function ENT:PhysicsSimulate(phys,deltatime)
end
function ENT:PhysicsUpdate(phys)
end
function ENT:Think()
end
function ENT:Touch(hitEnt)
end
function ENT:UpdateTransmitState(Entity)
end
function ENT:Use(activator,caller)
end
