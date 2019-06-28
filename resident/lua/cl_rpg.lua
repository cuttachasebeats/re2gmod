RPG.Cookies = { }

function RPG.CreateCookie( name, default )
	local x = cookie.GetNumber( name )
	
	cookie.Set( name, x or default )
	
	local t = { }
	
	t.__index = { }
	
	function t:Set( v )
		cookie.Set( name, v )
	end
	function t:Get( )
		return cookie.GetNumber( name )
	end
	function t:Is( v )
		return self:Get( ) == v
	end
	function t:IsNot( v )
		return self:Get( ) ~= v
	end
	function t:IsGT( v )
		return self:Get( ) > v
	end
	function t:IsLT( v )
		return self:Get( ) < v
	end
	function t:IsGTE( v )
		return self:Is( v ) or self:IsGT( v )
	end
	function t:IsLTE( v )
		return self:Is( v ) or self:IsLT( v )
	end
	function t:Flip( )
		if self:Is( 1 ) then
			self:Set( 0 )
		else
			self:Set( 1 )
		end
	end
	
	return t
end

function RPG.CreateServerCookie( cvar )
	local x = GetConVar( cvar )
	
	local t = { }
	
	t.__index = { }
	
	function t:Set( v )
		RunConsoleCommand( cvar, v )
	end
	function t:Get( )
		return x:GetInt( )
	end
	function t:Is( v )
		return self:Get( ) == v
	end
	function t:IsNot( v )
		return self:Get( ) ~= v
	end
	function t:IsGT( v )
		return self:Get( ) > v
	end
	function t:IsLT( v )
		return self:Get( ) < v
	end
	function t:IsGTE( v )
		return self:Is( v ) or self:IsGT( v )
	end
	function t:IsLTE( v )
		return self:Is( v ) or self:IsLT( v )
	end
	function t:Flip( )
		if self:Is( 1 ) then
			self:Set( 0 )
		else
			self:Set( 1 )
		end
	end
	
	return t
end

RPG.Cookies.HideUI = RPG.CreateCookie( "rpg.hideui", 0 )

RPG.Cookies.DamageNumbers = RPG.CreateCookie( "rpg.damagenumbers.enabled", 1 )
RPG.Cookies.DamageNumberMat = RPG.CreateCookie( "rpg.damagenumbers.usemat", 0 )
RPG.Cookies.DamageNumberSelf = RPG.CreateCookie( "rpg.damagenumbers.selfonly", 0 )

RPG.Cookies.HideInfoPanel = RPG.CreateCookie( "rpg.hideinfopanel", 0 )

RPG.Cookies.LevelUpEffect = RPG.CreateCookie( "rpg.levelupeffect", 1 )

RPG.Cookies.IgnoreAmmoLimit = RPG.CreateServerCookie( "rpg_cfg_noammolimit" )
RPG.Cookies.StaticAmmoRegen = RPG.CreateServerCookie( "rpg_cfg_staticammoregen" )

RPG.Cookies.Champions = RPG.CreateServerCookie( "rpg_cfg_champions" )
RPG.Cookies.NPCLevels = RPG.CreateServerCookie( "rpg_cfg_npclevels" )
RPG.Cookies.RandomSizes = RPG.CreateServerCookie( "rpg_cfg_randomizesizes" )
RPG.Cookies.DirtyFixShotgun = RPG.CreateServerCookie( "rpg_dirty_shotgunfix" )

RPG.SettingsData = {
	UI = {
		["Hide UI"] = RPG.Cookies.HideUI,
		["Enable Damage Numbers"] = RPG.Cookies.DamageNumbers,
		["Damage Numbers Alternate Material"] = RPG.Cookies.DamageNumberMat,
		["Damage Numbers for you only"] = RPG.Cookies.DamageNumberSelf,
		["Level Up Effect"] = RPG.Cookies.LevelUpEffect,
		["Hide Info Panel"] = RPG.Cookies.HideInfoPanel,
	},
	Server = {
		["Ignore Ammo Limits"] = RPG.Cookies.IgnoreAmmoLimit,
		["Use Static Ammo Regeneration"] = RPG.Cookies.StaticAmmoRegen,
		["Champion Monsters"] = RPG.Cookies.Champions,
		--["NPC Levels"] = RPG.Cookies.Champions, --Will figure out a way to do this that isn't broken steel
		["Randomize NPC Size"] = RPG.Cookies.RandomSizes,
		["Dirty fix - Multiple bullets instead of multiple shots"] = RPG.Cookies.DirtyFixShotgun,
	}
}

function RPG:CreateClientsideRagdoll( ent, ragdoll )
	ragdoll:SetLegacyTransform( true )

	ragdoll:SetColor( ent:GetColor( ) )
	ragdoll:SetModelScale( ent:GetModelScale( ), 0 )
end

hook.Add( "CreateClientsideRagdoll", RPG, RPG.CreateClientsideRagdoll )

hook.Add( "InitPostEntity", "CreateUI", function( ) timer.Simple( .1, function( ) RPG:RebuildUI( ) end ) end )

hook.Add( "HUDPaint", "RPG.TellReady", function( )
	RunConsoleCommand( "rpg_ready" )
	hook.Remove( "HUDPaint", "RPG.TellReady" )
end )	