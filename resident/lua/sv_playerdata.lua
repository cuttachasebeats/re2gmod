local EXPECTED_HEADER = "RPG_SAVE"


function RPG:SavePlayer( pl )
local str_Steam2 = string.Replace(pl:SteamID(),":",";")
	local path_FilePath2 = "rpg/"..str_Steam2..".txt"
	local Savetable2 = {}
	Savetable2["level"] = {}
	Savetable2["level"] = pl.RpgData.Level
	
	Savetable2["xp"] = {}
	Savetable2["xp"] = pl.RpgData.XP
	
	Savetable2["points"] = {}
	Savetable2["points"] = pl.RpgData.SkillPoints
	
	Savetable2["skills"] = {}
	Savetable2["skills"] = pl.RpgData.Skills
	
	local StrindedItems2 = util.TableToKeyValues(Savetable2)
	if not file.IsDir( "rpg", "DATA" ) then
		file.CreateDir( "rpg", "DATA" )
	end
	file.Write(path_FilePath2,StrindedItems2)
end

local pl = FindMetaTable( "Player" )

function RPG:LoadPlayer( pl )
local str_Steam2 = string.Replace(pl:SteamID(),":",";")
	local path_FilePath2 = "rpg/"..str_Steam2..".txt"
	if not file.IsDir( "rpg", "DATA" ) then
		file.CreateDir( "rpg", "DATA" )
	end
	self:PreparePlayer( pl )
	if not file.Exists( path_FilePath2, "DATA" ) then
		print( "Path", path_FilePath2, "does not exist!" )
		return self:BeamDown( pl )
	end
		
	if file.Exists(path_FilePath2, "DATA") then
		
		
		local Savetable2 = util.KeyValuesToTable(file.Read(path_FilePath2) )
		local skills = Savetable2["skills"]
		local lvl = Savetable2["level"]
		local xp = Savetable2["xp"]
		local points = Savetable2["points"]
		pl.RpgData.Level =  lvl
		pl.RpgData.XP =  xp
		pl.RpgData.SkillPoints =  points
		if skills != nil then
			pl.RpgData.Skills = skills
		end
	else 
		pl.RpgData.Level = 0
		pl.RpgData.XP = 0
		pl.RpgData.SkillPoints = 0
		pl.RpgData.Swag = 0
		
	
		
	end
	self:BeamEntireFrame( pl )
	self:UpdateAllSkills( pl )
	
end

timer.Create( "RPG_AUTOSAVE", 30, 0, function( )
	local k, v
	
	for k, v in ipairs( player.GetAll( ) ) do
		RPG:SavePlayer( v )
	end
end )