AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.Base = "nz_projectile_base"

ENT.Damage = 4
ENT.DamageType = DMG_ACID
ENT.Time = 1.5

ENT.PainSound1 = Sound("player/pl_pain7.wav")
ENT.PainSound2 = Sound("player/pl_pain6.wav")
ENT.PainSound3 = Sound("player/pl_pain5.wav")

ENT.ImpactSound1 = Sound("physics/flesh/flesh_squishy_impact_hard1.wav")
ENT.ImpactSound2 = Sound("physics/flesh/flesh_squishy_impact_hard2.wav")
ENT.ImpactSound3 = Sound("physics/flesh/flesh_squishy_impact_hard3.wav")
ENT.ImpactSound4 = Sound("physics/flesh/flesh_squishy_impact_hard4.wav")

ENT.Type = "anim"
