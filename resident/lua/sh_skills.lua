RPG.Skills = { }
RPG.XSkills = { }

local function PickPlayer( a, b )
	if IsValid( a ) and a:IsPlayer( ) then
		return a
	elseif IsValid( b ) and b:IsPlayer( ) then
		return b
	else
		return NULL
	end
end

local sk = { }
sk.__index = sk

AccessorFunc( sk, "m_sName", "Name" )
AccessorFunc( sk, "m_sDesc", "ShortDesc" )
AccessorFunc( sk, "m_lDesc", "LongDesc" )
AccessorFunc( sk, "m_hMat", "Icon" )
AccessorFunc( sk, "m_iID", "SkillID" )
AccessorFunc( sk, "m_iID", "ID" )
AccessorFunc( sk, "m_bEnableD", "Enabled" )
AccessorFunc( sk, "m_iAdjMax", "AdjustedMaximum" )
AccessorFunc( sk, "m_bInterval", "IsInterval" )

function sk:SetMaximum( v )
	self.m_iMax = v
end

function sk:GetInterval( level )
	return 1
end

function sk:GetMaximum( )
	return self:GetAdjustedMaximum( ) or self.m_iMax
end

function sk:AddHook( name, f )
	--We can either do it through AddHook for consistency or declare it manually
	if name == "OnApply" then
		self[ name ] = f
	else
		self.Hooks[ name ] = f
	end
end

local nextid = 0

function RPG:Skill( specialid )
	if not specialid then	nextid = nextid + 1; specialid = nextid	end
	
	assert( specialid < 32767, "Skill id must be below 32767" )
	
	local skill = setmetatable( { m_iID = specialid, Hooks = { } }, sk )
	
	skill:SetEnabled( true )
	
	function skill.Finish( this )
		self.Skills[ this:GetID( ) ] = this
	end
	
	return skill, skill:GetSkillID( )
end

local s

s, RPG.XSkills.STRENGTH = RPG:Skill( )
	s:SetName( "Strength" )
	s:SetShortDesc( "Increases starting health" )
	s:SetLongDesc( "Gives you an additional ^3%d^ hitpoint(s)." )
	s:SetMaximum( 450 )
	s:SetIcon( Material( "rpg/strong.png", "smooth mips" ) )
	s.UpdateLongDesc = function( this, desc, level )
		return desc:format( level )
	end
	s:AddHook( "OnApply", function( this, pl )
		pl:SetMaxHealth( 100 + RPG:GetSkill( pl, this:GetID( ) ) )
		
		pl:SetHealth( pl:Health( ) + 1 )
	end )
	s:AddHook( "PlayerSpawn", function( this, pl )
		timer.Simple( 0, function( )
			pl:SetMaxHealth( 100 + RPG:GetSkill( pl, this:GetID( ) ) )
			pl:SetHealth( pl:GetMaxHealth( ) )
		end )
	end )
s:Finish( )

s, RPG.XSkills.SUPERIORARMOR = RPG:Skill( )
	s:SetName( "Superior Armor" )
	s:SetShortDesc( "Increases starting armor" )
	s:SetLongDesc( "Spawn with ^3%d^ armor. When over ^3100^, also gives you ^31^ armor." )
	s:SetMaximum( 450 )
	s:SetIcon( Material( "rpg/kevlar.png", "smooth mips" ) )
	s.UpdateLongDesc = function( this, desc, level )
		return desc:format( level )
	end
	s:AddHook( "OnApply", function( this, pl )
		if RPG:GetSkill( pl, this:GetID( ) ) > 100 then
			pl:SetArmor( pl:Armor( ) + 1 )
		end
	end )
	s:AddHook( "PlayerSpawn", function( this, pl )
		pl:SetArmor( RPG:GetSkill( pl, this:GetID( ) ) )
	end )
s:Finish( )

s, RPG.XSkills.REGENERATION = RPG:Skill( )
	s:SetName( "Regeneration" )
	s:SetShortDesc( "Slowly regenerate health" )
	s:SetLongDesc( "Regenerates one hitpoint every ^3%3.1f^ second(s), with a chance every half second." )
	s:SetMaximum( 300 )
	s:SetIcon( Material( "rpg/charm.png", "smooth mips" ) )
	s.UpdateLongDesc = function( this, desc, level )
		return desc:format( math.max( .5, 150.5 - level / 2 ) )
	end
	s:AddHook( "Think", function( this )
		if CLIENT then	return	end
		
		local k, v, lvl, now
		
		for k, v in ipairs( player.GetAll( ) ) do
			now = CurTime( )
			v.LastRegen = v.LastRegen or now
			v.NextRegenChance = v.NextRegenChance or now
			
			lvl = RPG:GetSkill( v, this:GetID( ) )
			
			if lvl < 1 or not v:Alive( ) then	continue	end
			
			local d = RPG:TimeScaleMultiplier( v, math.max( .5, 150.5 - lvl / 2 ), 0 )
			
			if now >= v.LastRegen + d then
				v.LastRegen = now
				if v:Health( ) < v:GetMaxHealth( ) then
					v:SetHealth( v:Health( ) + 1 )
				end
			end
			
			if now >= v.NextRegenChance then
				v.NextRegenChance = now + RPG:TimeScaleMultiplier( v, .5, 0 )
				if v:Health( ) < v:GetMaxHealth( ) and math.random( ) <= lvl / this:GetMaximum( ) then
					v:SetHealth( v:Health( ) + 1 )
				end
			end
		end
	end )
s:Finish( )

s, RPG.XSkills.NANOARMOR = RPG:Skill( )
	s:SetName( "Nano Armor" )
	s:SetShortDesc( "Slowly regenerate armor" )
	s:SetLongDesc( "Regenerates one armor every ^3%3.1f^ second(s), with a chance every half second." )
	s:SetMaximum( 300 )
	s:SetIcon( Material( "rpg/mail-shirt.png", "smooth mips" ) )
	s.UpdateLongDesc = function( this, desc, level )
		return desc:format( math.max( .5, 150.5 - level / 2 ) )
	end
	s:AddHook( "Think", function( this )
		if CLIENT then	return	end
		
		local k, v, lvl, now
		
		for k, v in ipairs( player.GetAll( ) ) do
			now = CurTime( )
			v.LastARegen = v.LastARegen or now
			v.NextARegenChance = v.NextARegenChance or now
			
			lvl = RPG:GetSkill( v, this:GetID( ) )
			
			if lvl < 1 or not v:Alive( ) then	continue	end
			
			local d = RPG:TimeScaleMultiplier( v, math.max( .5, 150.5 - lvl / 2 ), 0 )
			
			if now >= v.LastARegen + d then
				v.LastARegen = now
				if v:Armor( ) < RPG:MaxArmor( v ) then
					v:SetArmor( v:Armor( ) + 1 )
				end
			end
			
			if now >= v.NextARegenChance then
				v.NextARegenChance = now + RPG:TimeScaleMultiplier( v, .5, 0 )
				if v:Armor( ) < RPG:MaxArmor( v ) and math.random( ) <= lvl / this:GetMaximum( ) then
					v:SetArmor( v:Armor( ) + 1 )
				end
			end
		end
	end )
s:Finish( )
--Ammo regen hook is handled in sv_rpg.lua under AmmoClamp ( which doesn't actually clamp ammo at all anymore... )
s, RPG.XSkills.AMMOREGENERATION = RPG:Skill( )
	s:SetName( "Ammo Regeneration" )
	s:SetShortDesc( "Slowly regenerate ammo" )
	s:SetLongDesc( "Regenerates ammo of the current weapon every ^3%3.1f^ seconds. If the current weapon is full, regenerate the most used ammo type or a random type when tied." )
	s:SetMaximum( 10 )
	s:SetIcon( Material( "rpg/bullets.png", "smooth mips" ) )
	s.UpdateLongDesc = function( this, desc, level )
		return desc:format( 90 - level * 2.5 )
	end
s:Finish( )

s, RPG.XSkills.STOCKPILE = RPG:Skill( )
	s:SetName( "Stockpile" )
	s:SetShortDesc( "Increases maximum ammo" )
	s:SetLongDesc( "Increases your maximum ammo by ^3%3.1f%%^." )
	s:SetMaximum( 30 )
	s:SetIcon( Material( "rpg/ammo-box.png", "smooth mips" ) )
	s.UpdateLongDesc = function( this, desc, level )
		return desc:format( 1.5 * level )
	end
s:Finish( )

s, RPG.XSkills.ANTIGRAVITYDEVICE = RPG:Skill( )
	s:SetName( "Anti-Gravity Device" )
	s:SetShortDesc( "Lowers your personal gravity" )
	s:SetLongDesc( "Lowers your gravity by ^3%3.1f%%^." )
	s:SetMaximum( 30 )
	s:SetIcon( Material( "rpg/fall-down.png", "smooth mips" ) )
	s.UpdateLongDesc = function( this, desc, level )
		return desc:format( 1.5 * level )
	end
	s:AddHook( "OnApply", function( this, pl )
		pl:SetGravity( 1 - ( RPG:GetSkill( pl, this:GetID( ) ) / this:GetMaximum( ) ) * .2 )
	end )
	s:AddHook( "PlayerSpawn", function( this, pl )
		pl:SetGravity( 1 - ( RPG:GetSkill( pl, this:GetID( ) ) / this:GetMaximum( ) ) * .2 )
	end )
s:Finish( )
--Awareness only compes into play when calculating skill levels
s, RPG.XSkills.AWARENESS = RPG:Skill( )
	s:SetName( "Awareness" )
	s:SetShortDesc( "Slightly improves other skills" )
	s:SetLongDesc( "Boosts your skills that are above zero by ^3%d%%^, and allows above the maximum by ^3%d^." )
	s:SetMaximum( 10 )
	s:SetIcon( Material( "rpg/aura.png", "smooth mips" ) )
	s.UpdateLongDesc = function( this, desc, level )
		return desc:format( level, level / 2 )
	end
s:Finish( )
	
s, RPG.XSkills.TEAMPOWER = RPG:Skill( )
	s:SetName( "Team Power" )
	s:SetShortDesc( "Supports the health and armor of other players near you." )
	s:SetLongDesc( "Boosts Health Regeneration, Nano Armor, and Ammo Regeneration of nearby players." )
	s:SetMaximum( 60 )
	s:SetIcon( Material( "rpg/backup.png", "smooth mips" ) )
	s:AddHook( "Think", function( this )
		local k, v, j, n, z
		
		for k, v in ipairs( player.GetAll( ) ) do
			if not v.RpgData then
				continue
			end
		
			v.RpgData.TeamPower = 0
			
			for j, n in ipairs( player.GetAll( ) ) do
				if not n:IsValid( ) or not n:Alive( ) then	continue	end
				if not n.RpgData then	RPG:PreparePlayer( n )	end
				if v == n then	continue	end
				
				if v:GetPos( ):Distance( n:GetPos( ) ) <= ( 20 * 16 ) then
					v.RpgData.TeamPower = v.RpgData.TeamPower + RPG:GetSkill( n, this:GetID( ) )
				end
			end
		end
	end )
s:Finish( )

s, RPG.XSkills.BLOCKATTACK = RPG:Skill( )
	s:SetName( "Block Attack" )
	s:SetShortDesc( "Gives you a chance to ignore an attack." )
	s:SetLongDesc( "Gives you a ^3%3.2f%%^ chance to block an attack entirely." )
	s:SetMaximum( 90 )
	s:SetIcon( Material( "rpg/shield-reflect.png", "smooth mips" ) )
	s.UpdateLongDesc = function( this, desc, level )
		return desc:format( level / 3 )
	end
	s:AddHook( "EntityTakeDamage", function( this, pl, info )
		if not pl:IsPlayer( ) then	return	end
		if RPG:GetSkill( pl, this:GetID( ) ) < 1 then	return	end
		if math.random( ) < ( RPG:GetSkill( pl, this:GetID( ) ) / this:GetMaximum( ) ) / 3 then
			info:SetDamage( 0 )
			info:SetDamageType( DMG_GENERIC )
			sound.Play( "weapons/fx/rics/ric" .. math.random( 5 ) .. ".wav", info:GetDamagePosition( ) )
		end
	end )
s:Finish( )

s, RPG.XSkills.ACCURACY = RPG:Skill( )
	s:SetName( "Accuracy" )
	s:SetShortDesc( "Makes weapons more accurate" )
	s:SetLongDesc( "Weapons are ^3%d%%^ more accurate. ^2Doesn't affect shotguns when the multiple bullet dirty fix is enabled^." )
	s:SetMaximum( 10 )
	s:SetIcon( Material( "rpg/reticule.png", "smooth mips" ) )
	s.UpdateLongDesc = function( this, desc, level )
		return desc:format( 4 * level )
	end
	s:AddHook( "RPG_EntityFireBullets", function( this, ent, bullet )
		if not ent:IsPlayer( ) then
			--Some weapons use wep:FireBullet
			if ent:IsWeapon( ) and ent:GetOwner( ):IsPlayer( ) then
				ent = ent:GetOwner( )
			else
				return
			end
		end
		
		local z = RPG:GetSkill( ent, this:GetID( ) )
		
		if amount > 0 then
			bullet.Changed = true
			bullet.Spread = bullet.Spread * ( 1 - .04 * z )
		end
	end )
s:Finish( )

s, RPG.XSkills.CRITICALDAMAGE = RPG:Skill( )
	s:SetName( "Critical Damage" )
	s:SetShortDesc( "Increases damage of critical hits" )
	s:SetLongDesc( "Critical hit damage increased by ^3%3.1f%%^." )
	s:SetMaximum( 20 )
	s:SetIcon( Material( "rpg/grim-reaper.png", "smooth mips" ) )
	s.UpdateLongDesc = function( this, desc, level )
		return desc:format( 200 + 7.5 * level )
	end
s:Finish( )

s, RPG.XSkills.CRITICALHIT = RPG:Skill( )
	s:SetName( "Critical Hit" )
	s:SetShortDesc( "Increases critical hit chance" )
	s:SetLongDesc( "Critical hits happen ^3%3.2f%%^ of the time." )
	s:SetMaximum( 10 )
	s:SetIcon( Material( "rpg/pierced-body.png", "smooth mips" ) )
	s.UpdateLongDesc = function( this, desc, level )
		return desc:format( 5 + 1.25 * level )
	end
s:Finish( )

s, RPG.XSkills.DAMAGEBOOSTER = RPG:Skill( )
	s:SetName( "Damage Booster" )
	s:SetShortDesc( "Increases damage" )
	s:SetLongDesc( "Damage is increased by ^3%d%%^ after awarding experience." )
	s:SetMaximum( 5 )
	s:SetIcon( Material( "rpg/punch.png", "smooth mips" ) )
	s.UpdateLongDesc = function( this, desc, level )
		return desc:format( 3 * level )
	end
s:Finish( )

s, RPG.XSkills.HIGHEXPLOSIVEAMMO = RPG:Skill( )
	s:SetName( "High Explosive Ammo" )
	s:SetShortDesc( "Adds a chance to have bullets to explode." )
	s:SetLongDesc( "Your bullets have a ^3%d%%^ chance to explode when you hurt something, dealing ^3%d^ damage in a small radius." )
	s:SetMaximum( 10 )
	s:SetIcon( Material( "rpg/sparky-bomb.png", "smooth mips" ) )
	s.UpdateLongDesc = function( this, desc, level )
		return desc:format( 2 * level, 8 * level )
	end
s:Finish( )

s, RPG.XSkills.FACECARD = RPG:Skill( )
	s:SetName( "Face Card" )
	s:SetShortDesc( "Small chance of Doing Super Damage." )
	s:SetLongDesc( "You have a ^3%3.1f%%^ chance to instantly hurt things you hurt." )
	s.LongDesc2 = "You have a ^3%3.1f%%^ ( ^3%d:%d^ ) chance to instantly hurt things you hurt."
	s:SetMaximum( 5 )
	s:SetIcon( Material( "rpg/poker-hand.png", "smooth mips" ) )
	s.UpdateLongDesc = function( this, desc, level )
		local a, b, c, d, e
		
		a, b = level * 15, 1000
		c, d = a, b
		
		while d > 0 do
			e = c % d
			c = d
			d = e
		end
		
		a = a / c
		b = b / c
		
		return ( level > 0 and s.LongDesc2 or desc ):format( .15 * level, a, b )
	end
s:Finish( )

s, RPG.XSkills.GUNDALF = RPG:Skill( )
	s:SetName( "Gundalf" )
	s:SetShortDesc( "Chance to not use ammo" )
	s:SetLongDesc( "You have a ^3%d%%^ chance to not consume ammo. ^2Does not affect all weapons^." )
	s:SetMaximum( 5 )
	s:SetIcon( Material( "rpg/wizard-staff.png", "smooth mips" ) )
	s.UpdateLongDesc = function( this, desc, level )
		return desc:format( level * 4 )
	end
	s:AddHook( "Initialize", function( this )
		local wep = weapons.GetStored( "weapon_base" )

		wep.rpg_oldtakeprimary = wep.rpg_oldtakeprimary or wep.TakePrimaryAmmo
		wep.rpg_oldtakesecondary = wep.rpg_oldtakesecondary or wep.TakeSecondaryAmmo
	
		function wep:TakePrimaryAmmo( num )
			if not self.Owner:IsPlayer( ) then
				return self:rpg_oldtakeprimary( num )
			end
	
			if math.random( ) > .04 * RPG:GetSkill( self.Owner, this:GetID( ) ) then
				return self:rpg_oldtakeprimary( num )
			end
		end
	
		function wep:TakeSecondaryAmmo( num )
			if not self.Owner:IsPlayer( ) then
				return self:rpg_oldtakesecondary( num )
			end
	
			if math.random( ) > .04 * RPG:GetSkill( self.Owner, this:GetID( ) ) then
				return self:rpg_oldtakesecondary( num )
			end
		end
	end )
s:Finish( )

s, RPG.XSkills.MOREDAKKA = RPG:Skill( )
	s:SetName( "More Dakka" )
	s:SetShortDesc( "Faster firing speed" )
	s:SetLongDesc( "Weapons fire ^3%d%%^ faster. ^2Does not affect all weapons^." )
	s:SetMaximum( 10 )
	s:SetIcon( Material( "rpg/whip.png", "smooth mips" ) )
	s.UpdateLongDesc = function( this, desc, level )
		return desc:format( 5 * level )
	end
	s:AddHook( "Think", function( this )
		local k, v, wep, pl, prim, sec, save, mul

		for k, v in ipairs( player.GetAll( ) ) do
			if not v:Alive( ) then	continue	end

			wep = v:GetActiveWeapon( )

			if not wep:IsValid( ) then	continue	end

			mul = math.max( .1, 1 - ( RPG:GetSkill( v, this:GetID( ) ) * .02 ) )
			
			mul = RPG:TimeScaleMultiplier( v, mul, 0 )

			save = wep:GetSaveTable( )

			prim = save.m_flNextPrimaryAttack
			sec = save.m_flNextSecondaryAttack

			wep.RPG_LastPrimaryDelay = wep.RPG_LastPrimaryDelay or 0
			wep.RPG_LastSecondaryDelay = wep.RPG_LastSecondaryDelay or 0

			if not ( prim and sec ) then	continue	end

			if prim > wep.RPG_LastPrimaryDelay then
				prim = math.max( prim > .065 and .065 or .01, prim * mul )
				wep:SetSaveValue( "m_flNextPrimaryAttack", prim )
			end

			if sec > wep.RPG_LastSecondaryDelay then
				sec = math.max( sec > .065 and .065 or .01, sec * mul )
				wep:SetSaveValue( "m_flNextSecondaryAttack", sec )
			end

			wep.RPG_LastPrimaryDelay = prim
			wep.RPG_LastSecondaryDelay = sec
		end
	end )
s:Finish( )

s, RPG.XSkills.ORGANIZEDGUNS = RPG:Skill( )
	s:SetName( "Organized Guns Are Happy Guns" )
	s:SetShortDesc( "More ammo in each magazine" )
	s:SetLongDesc( "Weapons have ^3%d%%^ more ammo in each magazine. ^2Does not affect all weapons^." )
	s:SetMaximum( 20 )
	s:SetIcon( Material( "rpg/bullets-and-plus.png", "smooth mips" ) )
	s.UpdateLongDesc = function( this, desc, level )
		return desc:format( 5 * level )
	end
	s:AddHook( "PlayerSwitchWeapon", function( this, pl, old, new )
		local base, mul

		base = weapons.GetStored( new:GetClass( ) )

		if not base or RPG:GetSkill( pl, this:GetID( ) ) < 1 then
			return
		end

		mul = 1 + RPG:GetSkill( pl, this:GetID( ) ) * .05

		if base.Primary.ClipSize and base.Primary.ClipSize >= 1 then
			new.Primary.ClipSize = math.Round( base.Primary.ClipSize * mul )
		end

		if base.Secondary.ClipSize and base.Secondary.ClipSize >= 1 then
			new.Secondary.ClipSize = math.Round( base.Secondary.ClipSize * mul )
		end
	end )
s:Finish( )

s, RPG.XSkills.ASFASTASYOUCAN = RPG:Skill( )
	s:SetName( "As Fast As You Can" )
	s:SetShortDesc( "Run faster" )
	s:SetLongDesc( "You move up to ^3%d%%^ faster." )
	s:SetMaximum( 10 )
	s:SetIcon( Material( "rpg/run.png", "smooth mips" ) )
	s.UpdateLongDesc = function( this, desc, level )
		return desc:format( 4 * level )
	end
	s:AddHook( "Move", function( this, pl, data )		
		local f, s, u, m, m2
	
		m = 1 + .04 * RPG:GetSkill( pl, this:GetID( ) )
		
		m = RPG:TimeScaleMultiplier( pl, m )
		
		data:SetMaxClientSpeed( data:GetMaxClientSpeed( ) * m )
	end )
s:Finish( )

s, RPG.XSkills.TEMPORALMOMENTUM = RPG:Skill( )
	s:SetName( "Temporal Momentum" )
	s:SetShortDesc( "Reduces the effects of time slowing." )
	s:SetLongDesc( "You are ^3%d%%^ less affected by time slowing. Does not affect projectile speed." )
	s:SetMaximum( 5 )
	s:SetIcon( Material( "rpg/sands-of-time.png", "smooth mips" ) )
	s.UpdateLongDesc = function( this, desc, level )
		return desc:format( 5 * level )
	end
s:Finish( )

s, RPG.XSkills.LIKEANINJA = RPG:Skill( )
	s:SetName( "Like A Ninja" )
	s:SetShortDesc( "You can jump off walls" )
	s:SetLongDesc( "You can jump off walls ^3%d^ times in a row. Hold the move key in the direction desired and jump. Also, take ^3%d^ less fall damage." )
	s:SetMaximum( 3 )
	s:SetIcon( Material( "rpg/sprint.png", "smooth mips" ) )
	s.UpdateLongDesc = function( this, desc, level )
		return desc:format( math.floor( level ), math.floor( level * 10 ) )
	end
	s:AddHook( "SetupMove", function( this, pl, data )
		local s = math.floor( RPG:GetSkill( pl, this:GetID( ) ) )
		
		if s < 1 then
			return
		end
		
		if pl:OnGround( ) then
			pl.RPG_WallJumps = 0
			pl.RPG_NextWallJump = 0
			return
		end
		
		if pl.RPG_WallJumps < s and pl.RPG_NextWallJump <= CurTime( ) then
			pl.RPG_NextWallJump = CurTime( ) + .2
			
			local tr, hitl, hitr, hitf, hitb, vf, vr, vel, m
			
			vel = vector_origin * 0
			m = 1 + .04 * RPG:GetSkill( pl, RPG.XSkills.ASFASTASYOUCAN ) * .4
			
			tr = { }
			tr.start = pl:GetPos( )
			tr.filter = pl
			
			vf = pl:GetForward( ):GetNormalized( )
			vr = pl:GetRight( ):GetNormalized( )
			
			tr.endpos = tr.start - vr * 24
			hitl = util.TraceLine( tr ).Fraction < 1
			
			tr.endpos = tr.start + vr * 24
			hitr = util.TraceLine( tr ).Fraction < 1
			
			tr.endpos = tr.start + vf * 24
			hitf = util.TraceLine( tr ).Fraction < 1
			
			tr.endpos = tr.start - vf * 24
			hitb = util.TraceLine( tr ).Fraction < 1
		
			if pl:KeyDown( IN_JUMP ) then
				vel.z = RPG:TimeScaleMultiplier( pl, 60 * m )
				if pl:KeyDown( IN_MOVERIGHT ) and hitl then
					vel = vel + RPG:TimeScaleMultiplier( pl, vr * 165 * m )	
				end
				if pl:KeyDown( IN_MOVELEFT ) and hitr then
					vel = vel - RPG:TimeScaleMultiplier( pl, vr * 165 * m )
				end
				if pl:KeyDown( IN_FORWARD ) and hitb then
					vel = vel + RPG:TimeScaleMultiplier( pl, vf * 165 * m )
				end
				if pl:KeyDown( IN_BACK ) and hitf then
					vel = vel - RPG:TimeScaleMultiplier( pl, vf * 165 * m )
				end
				
				if vel.x ~= 0 or vel.y ~= 0 then
					data:SetVelocity( data:GetVelocity( ) + vel )
					sound.Play( "physics/cardboard/cardboard_box_impact_soft" .. math.random( 7 ) .. ".wav", pl:GetPos( ) )
					pl.RPG_WallJumps = pl.RPG_WallJumps + 1
					debugoverlay.Axis( pl:GetPos( ), data:GetVelocity( ):GetNormalized( ):Angle( ), 3, 5, true )
					debugoverlay.Text( pl:GetPos( ), pl.RPG_WallJumps, 5 )
				end
			end
		end
	end )
	s:AddHook( "EntityTakeDamage", function( this, ent, info )
		if ent:IsPlayer( ) and info:IsFallDamage( ) then
			if RPG:GetSkill( ent, this:GetID( ) ) > 0 then
				info:SetDamage( math.max( 0, info:GetDamage( ) - math.floor( RPG:GetSkill( ent, this:GetID( ) ) * 10 ) ) )
			end
		end
	end )
s:Finish( )

s, RPG.XSkills.ITSLIKECHRISTMAS = RPG:Skill( )
	s:SetName( "It's Like Christmas!" )
	s:SetShortDesc( "Ammo pickups have more ammo" )
	s:SetLongDesc( "Ammo pickups ( including regeneration ) have ^3%d%%^ more ammo. ^2Does not affect all sources.^" )
	s:SetMaximum( 5 )
	s:SetIcon( Material( "rpg/present.png", "smooth mips" ) )
	s.UpdateLongDesc = function( this, desc, level )
		return desc:format( math.floor( level ) * 10 )
	end
s:Finish( )

s, RPG.XSkills.LESSERSHIELD = RPG:Skill( )
	s:SetName( "Lesser Shield" )
	s:SetShortDesc( "Reduces incoming damage by a static amount" )
	s:SetLongDesc( "Incoming damage is reduced by ^3%d^. ^2Most shotguns don't trigger damage on each pellet^." )
	s:SetMaximum( 3 )
	s:SetIcon( Material( "rpg/riot-shield.png", "smooth mips" ) )
	s.UpdateLongDesc = function( this, desc, level )
		return desc:format( level )
	end
	s:AddHook( "EntityTakeDamage", function( this, ent, info )
		if ent:IsPlayer( ) and RPG:GetSkill( ent, this:GetID( ) ) > 0 then
			info:SetDamage( info:GetDamage( ) - RPG:GetSkill( ent, this:GetID( ) ) )
		end
	end )
s:Finish( )

s, RPG.XSkills.PRIMEVALSTAR = RPG:Skill( )
	s:SetName( "Primeval Star" )
		s:SetShortDesc( "Adds elemental damage randomly" )
		s:SetLongDesc( "^3%d%%^ chance to deal up to ^3%d^ extra ^2Plasma^, ^2Burn^, ^2Acid^, ^2Shock^, or^2 Blast^ damage. ^2Does not chain^." )
		s:SetMaximum( 5 )
		s:SetIcon( Material( "rpg/cursed-star.png", "smooth mips" ) )
		s.UpdateLongDesc = function( this, desc, level )
			return desc:format( level * 2, level + 3 )
		end
s:Finish( )