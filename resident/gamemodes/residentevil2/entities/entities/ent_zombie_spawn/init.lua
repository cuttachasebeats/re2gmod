AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	timer.Simple(5,function() if self:IsValid() then self:StrikeOutZombies() end end)
end


function ENT:StrikeOutZombies()
	for _,class in pairs({"snpc_shambler"}) do
		for _,zombie in pairs(ents.FindByClass(class)) do
			if self:GetPos():Distance(zombie:GetPos()) <= 120 && !zombie.Frozen then
				if (zombie.StrikeOuts == nil) then
					zombie.StrikeOuts = 1
				else
					zombie.StrikeOuts = zombie.StrikeOuts + 1
				end
				if zombie.StrikeOuts >= 5 then
					GAMEMODE.int_NumZombies = GAMEMODE.int_NumZombies - 1
					zombie:Remove()
				end
			end
		end
	end
	timer.Simple(5,function() if self:IsValid() then self:StrikeOutZombies() end end)
end

function ENT:OnTakeDamage(dmginfo)
end
function ENT:StartTouch(ent)
end
function ENT:EndTouch(ent)
end
function ENT:AcceptInput(name,activator,caller)
	if Name == "Enable" || Name == "enable" then
		self.Disabled = false
	elseif Name == "Disable" || Name == "Disable" then
		self.Disabled = true
	end
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
function ENT:KeyValue( key, value )
	if key == "Disabled" || key == "disabled" then
		self.Disabled = true
	end
end
