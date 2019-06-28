
local PERK = {}

PERK.ClassName = "perk_inventory" 
PERK.Name = "Inventory Slot"
PERK.Desc = "Increase Inventory Slot By 1"
PERK.Category = "Donor Perks"
PERK.Model = "models/props_lab/binderbluelabel.mdl"
PERK.Price = 500000

PERK.Restrictions = false

function PERK:ServerInitialize( ply )
	
	

end

function PERK:ClientInitialize( ply )

end

function PERK:OnEquip( ply )
	table.insert(ply.RE2Data["Inventory"],{Item = 0, Amount = 0})
end

function PERK:OnRemove( ply )
	table.remove(ply.RE2Data["Inventory"], ply.RE2Data["Inventory"][table.Count(ply.RE2Data["Inventory"]) + 1])
end

function PERK:Think( ply )

end

perky.Register( PERK )