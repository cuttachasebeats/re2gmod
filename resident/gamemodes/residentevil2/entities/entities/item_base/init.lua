AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()

	if GAMEMODE.Items[self:GetNWString("Class")].Model != nil then
		self.Entity:SetModel(GAMEMODE.Items[self:GetNWString("Class")].Model)
	end
	if GAMEMODE.Items[self:GetNWString("Class")].Material != nil then
		self.Entity:SetMaterial(GAMEMODE.Items[self:GetNWString("Class")].Material)
	end
if self:GetNWString("Class") == "item_rherb" then
	self.Entity:SetColor(255,0,0)
end

	if self:GetNWString("Class") == "item_landmine" then
		self.Flare = ents.Create("env_flare")
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)
		self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	else
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)
		self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	end
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
	if key == "Item" && value != nil  && GAMEMODE.Items[value] != nil then
		self:SetNWString("Class",value)
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
	if self:GetNWString("Class") == "item_landmine" && self.Armed && !self.AFlare then
		self.Entity:SetMoveType(MOVETYPE_NONE)
		self.Flare:SetPos(self:GetPos() + Vector(0,0,3))
		self.Flare:SetKeyValue("spawnflags","2")
		self.Flare:SetKeyValue("spawnflags","4")
		self.Flare:Spawn()
		self.Flare:Activate()
		self.AFlare = true
	end
end

function ENT:Asplode()
	local explode = ents.Create("env_explosion")
	explode:SetPos(self:GetPos())
	explode.Owner = self.Owner
	explode:Spawn()
	if self:GetNWString("Class") == "item_c4" then
		explode:SetKeyValue("iMagnitude","100")
		explode:Fire("Explode",0,0)
		explode:EmitSound("weapon_AWP.Single",500,300)
	elseif self:GetNWString("Class") == "item_landmine" then
		explode:SetKeyValue("iMagnitude","150")
		explode:Fire("Explode",0,0)
		explode:EmitSound("weapon_AWP.Single",800,500)
	end
	if self:GetNWString("Class") == "item_landmine" then
		self.Flare:Remove()
	end
	self:Remove()
end

function ENT:CheckForEnemies()
local checkinents = { "snpc_shamblerb2",}
	for a,b in pairs(checkinents) do
		for k,v in pairs(ents.FindByClass(b)) do
			if v:GetPos():Distance(self:GetPos()) <= 100 && self.Armed then
				self:Asplode()
				return
			end
		end
	end
local checkintents = { "snpc_zombie_nemesis",}
	for a,b in pairs(checkintents) do
		for k,v in pairs(ents.FindByClass(b)) do
			if v:GetPos():Distance(self:GetPos()) <= 100 && self.Armed then
				self:Asplode()
				return
			end
		end
	end
local checkinbents = { "snpc_zombie_dog",}
	for a,b in pairs(checkinbents) do
		for k,v in pairs(ents.FindByClass(b)) do
			if v:GetPos():Distance(self:GetPos()) <= 100 && self.Armed then
				self:Asplode()
				return
			end
		end
	end
local checkinbents = { "snpc_zombie_jeff",}
	for a,b in pairs(checkinbents) do
		for k,v in pairs(ents.FindByClass(b)) do
			if v:GetPos():Distance(self:GetPos()) <= 100 && self.Armed then
				self:Asplode()
				return
			end
		end
	end
local checkinbents = { "snpc_zombie_king",}
	for a,b in pairs(checkinbents) do
		for k,v in pairs(ents.FindByClass(b)) do
			if v:GetPos():Distance(self:GetPos()) <= 100 && self.Armed then
				self:Asplode()
				return
			end
		end
	end
local checkinbents = { "snpc_shambler3",}
	for a,b in pairs(checkinbents) do
		for k,v in pairs(ents.FindByClass(b)) do
			if v:GetPos():Distance(self:GetPos()) <= 100 && self.Armed then
				self:Asplode()
				return
			end
		end
	end
local checkinbents = { "snpc_zombie_croc",}
	for a,b in pairs(checkinbents) do
		for k,v in pairs(ents.FindByClass(b)) do
			if v:GetPos():Distance(self:GetPos()) <= 100 && self.Armed then
				self:Asplode()
				return
			end
		end
	end
	timer.Simple(1,function() if self:IsValid() then self:CheckForEnemies() end end)
end

function ENT:Touch(hitEnt)
end
function ENT:UpdateTransmitState(Entity)
end
function ENT:Use(activator,caller)
	if !activator:IsPlayer() then return end
	if !activator.CanUse then return end
	if activator:Team() != TEAM_HUNK then return end

	--[[if activator:GetNWBool("AutoUse")   then
		GAMEMODE.Items[self:GetNWString("Class")].Function(activator)
		activator:EmitSound("items/itempickup.wav",110,100)
		activator.CanUse = false
		timer.Simple(0.3, function() activator.CanUse = true end)
		if self:GetNWString("Class") == "item_c4" || self:GetNWString("Class") == "item_landmine" && self.Armed then
			self.Flare:Remove()
		end
		self:Remove()
		return
	end--]]

		if self:GetNWString("Class") == "item_c4" || self:GetNWString("Class") == "item_landmine" then
			if self.Owner != activator && self.Armed then
				return
			end
		end
		local isvaliditem = false
			for k,v in pairs(GAMEMODE.Items) do
				if self:GetNWString("Class") == k then
					isvaliditem = true
					break
				end
			end
		if isvaliditem && inv_HasRoom(activator,self:GetNWString("Class")) then
			for a,b in pairs(GAMEMODE.Weapons) do
				if a == self:GetNWString("Class") then
					if b.Weapon != nil then
						activator:Give(b.Weapon)
						activator:SelectWeapon(b.Weapon)
					end
					if self.hasupgrade then
						activator.RE2Data["Upgrades"][self:GetNWString("Class")] = self.Upgrades
					end
				end
			end
			activator:EmitSound("items/itempickup.wav",110,100)
			activator.CanUse = false
			timer.Simple(0.3, function() activator.CanUse = true end)
			self:Remove()
			inv_AddToInventory(activator,self:GetNWString("Class"))
			if self:GetNWString("Class") == "item_landmine" && self.Armed then
				self.Flare:Remove()
			end
		end
end
