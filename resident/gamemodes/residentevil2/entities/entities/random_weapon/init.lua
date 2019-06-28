AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

itemtable = {
"item_spray",
"item_pammo",
"item_bammo",
"item_mammo",
"item_rammo",
"item_c4",
"item_landmine", }

function ENT:Initialize()
	local itemnumber = math.random(1,20) 
	local entity = ents.Create("item_base")
	if (itemnumber >= 1 && itemnumber <= 2) then
		entity:SetNWString("Class", "item_9mmhandgun")
	else 
		entity:SetNWString("Class",GAMEMODE:str_SelectRandomItem())
		self:SetAngles(self:GetAngles() + Angle(0,90,0))
	end
	entity:SetPos(self:GetPos())
	entity:SetAngles(self:GetAngles())
	entity:Spawn()
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
