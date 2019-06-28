
local PERK = {}

PERK.ClassName = "perk_immunity" 
PERK.Name = "Immunity"
PERK.Desc = "Can not be infected when damaged"
PERK.Category = "Donor Perks"
PERK.Model = "models/props_lab/jar01a.mdl"
PERK.Price = 1000000

PERK.Restrictions = {
	["superadmin"] = true,
	["admin"] = true,
	["vip"] = true,
}

function PERK:ServerInitialize( ply )
	

end

function PERK:ClientInitialize( ply )

end


function PERK:OnEquip( ply )
	ply:SetNWInt("Immunity", 400 )
end

function PERK:OnRemove( ply )
	ply:SetNWInt("Immunity", 25 )
end

function PERK:Think( ply )

end

perky.Register( PERK )