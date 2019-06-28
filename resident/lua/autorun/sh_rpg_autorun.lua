RPG = RPG or { }
RPG.SpecialTreatment = { }
RPG.AmmoTypes = RPG.AmmoTypes or { }
RPG.Defaults = { }

--This is so I can do hook.Add( "", RPG, RPG.SomeFunc ) and get the rpg passed as the first argument
function RPG:IsValid( )
	return true
end

RPG.Settings = {
	IgnoreAmmoLimits = CreateConVar( "rpg_cfg_noammolimit", "0", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY ),
	StaticAmmoRegen = CreateConVar( "rpg_cfg_staticammoregen", "0", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY ),
	StaticAmmoRegenAmount = CreateConVar( "rpg_cfg_staticamt", "30", FCVAR_REPLICATED + FCVAR_ARCHIVE ),
	ExperienceScale = CreateConVar( "rpg_cfg_xpscale", 2, FCVAR_ARCHIVE + FCVAR_REPLICATED ),
	Champions = CreateConVar( "rpg_cfg_champions", 1, FCVAR_ARCHIVE + FCVAR_REPLICATED + FCVAR_NOTIFY ),
	ChampionChance = CreateConVar( "rpg_cfg_championchance", 1, FCVAR_ARCHIVE + FCVAR_REPLICATED ),
	NpcLevels = CreateConVar( "rpg_cfg_npclevels", 1, FCVAR_ARCHIVE + FCVAR_REPLICATED + FCVAR_NOTIFY ),
	RandomSizes = CreateConVar( "rpg_cfg_randomizesizes", 1, FCVAR_ARCHIVE + FCVAR_REPLICATED + FCVAR_NOTIFY ),
	DirtyFixShotgun = CreateConVar( "rpg_dirty_shotgunfix", 0, FCVAR_ARCHIVE + FCVAR_REPLICATED ),
}

RPG.LetterModels = { Model( "models/letters/0.mdl" ),
Model( "models/letters/1.mdl" ),
Model( "models/letters/2.mdl" ),
Model( "models/letters/3.mdl" ),
Model( "models/letters/4.mdl" ),
Model( "models/letters/5.mdl" ),
Model( "models/letters/6.mdl" ),
Model( "models/letters/7.mdl" ),
Model( "models/letters/8.mdl" ),
Model( "models/letters/9.mdl" ),
Model( "models/letters/emark.mdl" ),
}

RPG.DisableSettings = false
RPG.DisableSwag = true

if SERVER then
	AddCSLuaFile( "sh_rpg_autorun.lua" )
	AddCSLuaFile( "cl_rpg.lua" )
	AddCSLuaFile( "cl_ui.lua" )
	AddCSLuaFile( "vgui/cl_property_sheet.lua" )
	AddCSLuaFile( "vgui/cl_label.lua" )
	AddCSLuaFile( "vgui/cl_progress_bar.lua" )
	AddCSLuaFile( "vgui/cl_skill_row.lua" )
	AddCSLuaFile( "vgui/cl_cookie_button.lua" )
	AddCSLuaFile( "vgui/cl_divider.lua" )
	AddCSLuaFile( "cl_scheme.lua" )
	
	IncludeCS( "sh_skills.lua" )
	IncludeCS( "sh_ammo.lua" )
	IncludeCS( "sh_networking.lua" )
	
	include( "sv_rpg.lua" )
	include( "sv_playerdata.lua" )
	include( "markov.lua" )
	
	local k, v
	
	for k, v in ipairs( RPG.LetterModels ) do
		resource.AddFile( v )
	end
	
	--Add self to downloads to send files ( I'm lazy )
	resource.AddWorkshop( "292198127" )
else
	include( "sh_skills.lua" )
	include( "sh_ammo.lua" )
	include( "sh_networking.lua" )
	
	include( "cl_rpg.lua" )
	include( "cl_ui.lua" )
end

RPG.MAX_LEVEL = 1800
RPG.CritSounds = { "player/crit_hit.wav", "player/crit_hit2.wav", "player/crit_hit3.wav", "player/crit_hit4.wav", "player/crit_hit5.wav" }
RPG.MiniCrits = { "player/crit_hit_mini.wav", "player/crit_hit_mini2.wav", "player/crit_hit_mini3.wav", "player/crit_hit_mini4.wav", "player/crit_hit_mini5.wav" }

function RPG:PreparePlayer( pl )
	if not pl:IsValid( ) then
		return
	end
	
	pl.RpgData = pl.RpgData or {}

	pl.RpgData.Level = 0
	pl.RpgData.XP = 0
	pl.RpgData.TeamPower = 0
	pl.RpgData.SkillPoints = 0
	pl.RpgData.Swag = 0
	pl.RpgData.Skills = { }
	pl.RpgData.PickedSwag = { }
	pl.RpgData.Augments = { }
end
function RPG:GetNextLevel( pl )
	local x = pl.RpgData.Level + 1
	
	return x * 70 + x * x * 3.5 + 30
	
	--return 100 + ( 50 / 3 ) * ( x ^ 3 - ( 6 * x ^ 2 ) + 17 * x - 12 )

	--return 1000 * ( 1 + pl.RpgData.Level )
end
function RPG:AverageLevel( )
	local k, v, t, n
	
	t = 0
	n = 0
	
	for k, v in ipairs( player.GetHumans( ) ) do
		if not IsValid( v ) then
			continue
		end
		
		if v.RpgData then
			t = t + v.RpgData.Level	
		end
		
		n = n + 1
	end
	
	return t / n
end

--Returns value, base
function RPG:GetSkill( pl, id )
	local base, value, awareness
	
	if not IsValid( pl ) then
		print( "PLAYER NOT VALID (" .. tostring( pl ) .. ")" )
		debug.Trace( )
	end
	
	if not id or type( id ) ~= "number" then
		print( "SKILL IS INVALID ('" .. tostring( id ) .. "')" )
		debug.Trace( )
	end
	
	if not self.Skills[ id ] then
		print( "SKILL DOES NOT EXIST ('" .. tostring( id ) .. "')" )
		debug.Trace( )
	end

	if not pl.RpgData then
		self:PreparePlayer( pl )
	end

	if id == self.XSkills.AWARENESS then
		return pl.RpgData.Skills[ id ] or 0, pl.RpgData.Skills[ id ] or 0
	else
		base = math.Clamp( pl.RpgData.Skills[ id ] or 0, 0, RPG.Skills[ id ]:GetMaximum( ) or 1 )
		value = base

		awareness = self:GetSkill( pl, self.XSkills.AWARENESS )

		pl.RpgData.TeamPower = pl.RpgData.TeamPower or 0

		if pl.RpgData.TeamPower > 0 and ( id == self.XSkills.REGENERATION or id == self.XSkills.NANOARMOR or id == self.XSkills.AMMOREGENERATION ) then
			value = value + pl.RpgData.TeamPower
		end

		if base > 0 and awareness > 0 then
			value = math.min( value + value * awareness / 100, self.Skills[ id ]:GetMaximum( ) + awareness / 2 )
		else
			value = math.min( value, self.Skills[ id ]:GetMaximum( ) )
		end

		return value, base
	end
end
function RPG:GetRank( pl )
	local lvl
	
	lvl = pl.RpgData and pl.RpgData.Level or 0
	
	if lvl == self.MAX_LEVEL then		return "Highest Force Leader"
	elseif lvl >= 1700 then				return "Highest Force Member"
	elseif lvl >= 1600 then				return "Top 15 of Most Famous Leaders"
	elseif lvl >= 1500 then				return "Top 30 of Most Famous Leaders"
	elseif lvl >= 1400 then				return "General"
	elseif lvl >= 1300 then				return "Hidden Operations Leader"
	elseif lvl >= 1200 then				return "Hidden Operations Scheduler"
	elseif lvl >= 1100 then				return "Hidden Operations Member"
	elseif lvl>= 1000 then				return "United Forces Leader"
	elseif lvl >= 900 then				return "United Forces Member"
	elseif lvl >= 800 then				return "Special Forces Leader"
	elseif lvl >= 700 then				return "Special Forces Member"
	elseif lvl >= 600 then				return "Professional Force Leader"
	elseif lvl >= 500 then				return "Professional Force Member"
	elseif lvl >= 400 then				return "Professional Free Agent"
	elseif lvl >= 300 then				return "Free Agent"
	elseif lvl >= 200 then				return "Private First Class"
	elseif lvl >= 100 then				return "Private Second Class"
	elseif lvl >= 50 then				return "Private Third Class"
	elseif lvl >= 20 then				return "Fighter"
	elseif lvl >= 5 then				return "Civilian"
	else								return "Frightened Civilian"
	end
end

function RPG:MaxArmor( pl )
	return 100 + math.max( 0, RPG:GetSkill( pl, self.XSkills.SUPERIORARMOR ) - 100 )
end

local k, v, j, n, max

max = 0

for k, v in pairs( RPG.Skills ) do
	max = max + v:GetMaximum( )
	
	if SERVER then
		resource.AddSingleFile( "materials/" .. v:GetIcon( ):GetName( ) .. ".png" )
	end
	
	if not v.Hooks then
		continue
	end
	
	for j, n in pairs( v.Hooks ) do
		hook.Add( j, "RPG" .. "." .. v:GetName( ) .. "." .. tostring( j ), function( ... ) n( v, ... ) end )
	end
end

RPG.MAX_LEVEL = max

function RPG:TimeScaleMultiplier( pl, base, dir )
	local scale, sk
	
	dir = dir or 1
	
	sk = self:GetSkill( pl, RPG.XSkills.TEMPORALMOMENTUM )
	
	if sk < 1 then
		return base
	end
	
	if game.GetTimeScale( ) >= 1 then
		return base
	end
	
	--The value of scale is the speed you need to move at for "normal" speed - eg, .5 would yield 2
	--So, we first have to divide it by 2 to get normal values ( since 25% of 2 is .5, not .25 )
	scale = 1 / game.GetTimeScale( ) * .5
	
	scale = scale * .05 * sk
	
	--Return base number times one plus scale. This should never actually reach 2 without the server being unplayable.
	--If the third arg was passed, we want the number to go down ( delay ) instead of up
	return base * ( dir == 1 and ( 1 + scale ) or ( 1 - scale ) )
end

local meta = FindMetaTable( "Entity" )

meta.rpg_firebullets = meta.rpg_firebullets or meta.FireBullets

function meta:FireBullets( data )
	if ( data.Num or 1 ) > 1 and RPG.Settings.DirtyFixShotgun:GetBool( ) then
		local i, j, r, n
		
		j = data.Num
		
		data.Num = 1
		
		for i = 1, j do
			r = ( data.Dir * 1 ):Angle( )

			r:RotateAroundAxis( r:Right( ), math.deg( math.asin( math.Rand( -data.Spread.x, data.Spread.x ) ) ) / 2 )
			r:RotateAroundAxis( r:Up( ), math.deg( math.asin( math.Rand( -data.Spread.y, data.Spread.y ) ) ) / 2 )
			
			data.Dir = r:Forward( )
			
			self:rpg_firebullets( data )
		end
	else
		self:rpg_firebullets( data )
	end
end

--This isn't ideal, but since two hooks can't modify the same bullet, just use a single hook and let all the skills change it if needed
function RPG:EntityFireBullets( ent, bullet )
	gamemode.Call( "RPG_EntityFireBullets", ent, bullet )
	
	if bullet.Changed then
		return true
	end
end

hook.Add( "EntityFireBullets", RPG, RPG.EntityFireBullets )