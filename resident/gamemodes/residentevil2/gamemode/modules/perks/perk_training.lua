
local PERK = {}

PERK.ClassName = "perk_training" 
PERK.Name = "Combat Training"
PERK.Desc = "Gain the ability to dash forward with your JUMP button"
PERK.Category = "Defense"
PERK.Model = "models/props_lab/binderbluelabel.mdl"
PERK.Price = 5000

PERK.Restrictions = false

function PERK:ServerInitialize( ply )

end

function PERK:ClientInitialize( ply )

end

function PERK:OnEquip( ply )
	ply.CanDash = true
end

function PERK:OnRemove( ply )
	ply.CanDash = false
end

function PERK:Think( ply )

end

perky.Register( PERK )