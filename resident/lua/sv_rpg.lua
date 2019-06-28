--292198127

--Load extra npc data
if file.Exists( "rpg/extranpcs.txt", "DATA" ) then
	local strm = file.Open( "rpg/extranpcs.txt", "rb", "DATA" )
		local count = strm:ReadShort( )
		
		while count > 0 do
			RPG.SpecialTreatment[ strm:Read( strm:ReadShort( ) ) ] = strm:ReadBool( )
			count = count - 1
		end
	strm:Close( )
else
	timer.Simple( 0, function( )
		local k, v
	
		for k, v in pairs( list.Get( "NPC" ) ) do
			if RPG.SpecialTreatment[ v.Class ] then
				continue
			end
		
			if not scripted_ents.Get( v.Class ) then
				continue
			end
		
			if scripted_ents.GetMember( v.Class, "Base" ) == "base_nextbot" then
				RPG.SpecialTreatment[ v.Class ] = false
			elseif scripted_ents.GetType( v.Class ) == "ai" then
				RPG.SpecialTreatment[ v.Class ] = true
			end
		end
	end )
end
	
local NO_EXPERIENCE = 1
local BLAST_ONLY = 2
local AIRBOAT_ONLY = 3
local BLAST_OR_AIRBOAT = 4

RPG.Exempt = { }
RPG.Exempt.npc_turret_floor = NO_EXPERIENCE
RPG.Exempt.npc_combine_camera = NO_EXPERIENCE
RPG.Exempt.npc_turret_ceiling = NO_EXPERIENCE
RPG.Exempt.npc_rollermine = BLAST_ONLY
RPG.Exempt.npc_strider = BLAST_ONLY
RPG.Exempt.npc_combinegunship = BLAST_ONLY
RPG.Exempt.npc_helicopter = BLAST_OR_AIRBOAT
RPG.Exempt.npc_combinedropship = AIRBOAT_ONLY

RPG.PrimevaleTypes = { DMG_PLASMA, DMG_BURN, DMG_ACID, DMG_SHOCK, DMG_BLAST }


function RPG:AddXp( pl, amount )
	if not pl.RpgData then
		self:PreparePlayer( pl )
	end
	
	if pl.RpgData.Level == self.MaxLevel then
		pl.RpgData.XP = 0
		return
	end
	
	amount = amount * self.Settings.ExperienceScale:GetFloat( )
	
	pl.RpgData.XP = pl.RpgData.XP + amount
	
	if pl.RpgData.XP >= self:GetNextLevel( pl ) then
		SendUserMessage( "RPG_LEVEL_UP", pl )
		
		local eff = EffectData( )
			eff:SetEntity( pl )
		util.Effect( "rpg_levelup", eff )
		
		pl.RpgData.XP = pl.RpgData.XP - self:GetNextLevel( pl )
		pl.RpgData.Level = pl.RpgData.Level + 1
		pl.RpgData.SkillPoints = pl.RpgData.SkillPoints + 1
		
		self:BeamDown( pl, pl, RPG_FIELD_XP, pl.RpgData.XP, RPG_FIELD_SP, pl.RpgData.SkillPoints )
		self:BeamDown( pl, nil, RPG_FIELD_LEVEL, pl.RpgData.Level )
	else
		self:BeamDown( pl, pl, RPG_FIELD_XP, pl.RpgData.XP )
	end
end
function RPG:EntityTakeDamage( ent, info )
	if info:GetAttacker( ):IsNPC( ) then
		if info:GetAttacker( ).DamageMul then
			info:ScaleDamage( 1 / info:GetAttacker( ).DamageMul )
		end
	end
	
	if info:GetInflictor( ):IsNPC( ) then
		if info:GetInflictor( ).DamageMul then
			info:ScaleDamage( 1 / info:GetInflictor( ).DamageMul )
		end
	end

	if self.SpecialTreatment[ ent:GetClass( ) ] == false then
		return
	end
	
	local iscrit
	
	if ( ent:IsNPC( ) or ent:GetClass() == "snpc_shambler3" or ent:GetClass() == "snpc_wesker" or ent:GetClass() == "snpc_zombie_dog" or ent:GetClass() == "snpc_shambler" or ent:GetClass() == "snpc_zombie_nemesis" or ent:GetClass() == "snpc_zombie_king" or ent:GetClass() == "snpc_zombie_jeff" or self.SpecialTreatment[ ent:GetClass( ) ] ) and ent:Health( ) > 0 then
		if ent.DefenseMul then
			info:ScaleDamage( 1 / ent.DefenseMul )
		end
	
		local amount = info:GetDamage( )
		
		--Make is so we don't do more damage than their current health
		--This means that levels that increase the strength of npcs or they 
		--have been given more health and are more likely to be a threat can give
		--more experience.
		
		if amount > ent:Health( ) then
			amount = ent:Health( )
		end
		
		local class = ent:GetClass( ):lower( )
		
		if RPG.Exempt[ class ] then
			if RPG.Exempt[ class ] == NO_EXPERIENCE then
				amount = 0
			end
			
			if RPG.Exempt[ class ] == BLAST_ONLY and not info:IsDamageType( DMG_BLAST ) then
				amount = 0
			end
			
			if RPG.Exempt[ class ] == AIRBOAT_ONLY and not info:IsDamageType( DMG_AIRBOAT ) then
				amount = 0
			end
			
			if RPG.Exempt[ class ] == BLAST_OR_AIRBOAT and not ( info:IsDamageType( DMG_AIRBOAT ) or info:IsDamageType( DMG_BLAST ) ) then
				amount = 0
			end
		end

		if amount <= 0 then
			return
		end
	
		if info:GetInflictor( ):IsPlayer( ) then			
			RPG:AddXp( info:GetInflictor( ), amount )
			info:ScaleDamage( 1 + ( .03 * RPG:GetSkill( info:GetInflictor( ), self.XSkills.DAMAGEBOOSTER ) ) )
			
			if info:GetDamage( ) >= ent:Health( ) then
				RPG:AddXp( info:GetInflictor( ), math.floor( ent:GetMaxHealth( ) / 2 ) )
				ent:SetHealth( 0 )
			end
			
			local alt = RPG:GetSkill( info:GetInflictor( ), self.XSkills.HIGHEXPLOSIVEAMMO )
			
			if math.random( ) <= alt * .02 and info:IsBulletDamage( ) then
				util.BlastDamage( info:GetInflictor( ), info:GetAttacker( ), info:GetDamagePosition( ), 32, 8 * alt )
				
				--local e = EffectData( )
				--	e:SetOrigin( info:GetDamagePosition( ) )
				--	e:SetRadius( 16 )
				--util.Effect( "Explosion", e )
			end
			
			alt = RPG:GetSkill( info:GetInflictor( ), self.XSkills.CRITICALHIT )
			
			if math.random( ) < .05 + ( .0125 * alt ) then
				info:ScaleDamage( 2 + .075 * RPG:GetSkill( info:GetInflictor( ), RPG.XSkills.CRITICALDAMAGE ) )
				sound.Play( table.Random( RPG.CritSounds ), info:GetDamagePosition( ) )
				iscrit = true
			end
			
			alt = RPG:GetSkill( info:GetInflictor( ), RPG.XSkills.PRIMEVALSTAR )
			
			if not info:IsDamageType( DMG_DIRECT ) and math.random( ) < .02 * alt  then
				local i2 = DamageInfo( )
					i2:SetDamage( 3 + alt )
					i2:SetDamageType( table.Random( self.PrimevaleTypes ) + DMG_DIRECT )
					i2:SetAttacker( info:GetInflictor( ) )
					i2:SetDamagePosition( info:GetDamagePosition( ) )
				ent:TakeDamageInfo( i2 )
			end
			
			alt = RPG:GetSkill( info:GetInflictor( ), self.XSkills.FACECARD )
			
			if math.random( ) < .05 + ( .0125 * alt ) then
				info:ScaleDamage( 2 + .075 * RPG:GetSkill( info:GetInflictor( ), RPG.XSkills.CRITICALDAMAGE ) )
				sound.Play( table.Random( RPG.CritSounds ), info:GetDamagePosition( ) )
				iscrit = true
			end
		end
		
		if info:GetAttacker( ) ~= info:GetInflictor( ) and info:GetAttacker( ):IsPlayer( ) then
			RPG:AddXp( info:GetAttacker( ), amount )
			info:ScaleDamage( 1 + ( .03 * RPG:GetSkill( info:GetAttacker( ), self.XSkills.DAMAGEBOOSTER ) ) )
			
			if info:GetDamage( ) >= ent:Health( ) then
				RPG:AddXp( info:GetAttacker( ), math.floor( ent:GetMaxHealth( ) / 2 ) )
				ent:SetHealth( 0 )
			end
			
			local alt = RPG:GetSkill( info:GetAttacker( ), self.XSkills.HIGHEXPLOSIVEAMMO )
			
			if math.random( ) <= alt * .2 and info:IsBulletDamage( ) then
				util.BlastDamage( info:GetAttacker( ), info:GetInflictor( ), info:GetDamagePosition( ), 32, 8 * alt )
				
				--local e = EffectData( )
				--	e:SetOrigin( info:GetDamagePosition( ) )
				--	e:SetRadius( 16 )
				--util.Effect( "Explosion", e )
			end
			
			alt = RPG:GetSkill( info:GetAttacker( ), self.XSkills.CRITICALHIT )
			
			if math.random( ) < .05 + ( .0125 * alt ) then
				info:ScaleDamage( 2 + .075 * RPG:GetSkill( info:GetAttacker( ), RPG.XSkills.CRITICALDAMAGE ) )
				sound.Play( table.Random( RPG.CritSounds ), info:GetDamagePosition( ) )
				iscrit = true
			end
			
			alt = RPG:GetSkill( info:GetAttacker( ), RPG.XSkills.PRIMEVALSTAR )
			
			if not info:IsDamageType( DMG_DIRECT ) and math.random( ) < .02 * alt  then
				local i2 = DamageInfo( )
					i2:SetDamage( 3 + alt )
					i2:SetDamageType( table.Random( self.PrimevaleTypes ) + DMG_DIRECT )
					i2:SetAttacker( info:GetAttacker( ) )
					i2:SetDamagePosition( info:GetDamagePosition( ) )
				ent:TakeDamageInfo( i2 )
			end
			
			alt = RPG:GetSkill( info:GetAttacker( ), self.XSkills.FACECARD )
			
			if math.random( ) < .05 + ( .0125 * alt ) then
				info:ScaleDamage( 2 + .075 * RPG:GetSkill( info:GetInflictor( ), RPG.XSkills.CRITICALDAMAGE ) )
				sound.Play( table.Random( RPG.CritSounds ), info:GetDamagePosition( ) )
				iscrit = true
			end
		end
		
		--No damage actually is dealt, but they seem to deal a lot of damage to others, making an excessive amount of them appear in a small space
		if ent:GetClass( ) == "npc_antlionguard" then
			if info:GetAttacker( ):IsValid( ) and info:GetAttacker( ):GetClass( ) == ent:GetClass( ) then
				amount = 0
			end
			
			if info:GetInflictor( ):IsValid( ) and info:GetInflictor( ):GetClass( ) == ent:GetClass( ) then
				amount = 0
			end
		end
		
		if amount > 0 and ( info:GetAttacker( ):IsPlayer( ) or info:GetInflictor( ):IsPlayer( ) ) then
			local e = EffectData( )
			
			local pos = info:GetDamagePosition( )
			
			if pos == vector_origin then
				pos = ent:LocalToWorld( vector_up * math.random( ent:OBBMins( ).z, ent:OBBMaxs( ).z ) )
			else
				pos = ent:NearestPoint( info:GetDamagePosition( ) )
			end
		
			if info:GetAttacker( ):IsPlayer( ) then
				e:SetScale( ( pos - info:GetAttacker( ):GetShootPos( ) ):Angle( ).y )
				e:SetEntity( info:GetAttacker( ) )
			elseif info:GetInflictor( ):IsPlayer( ) then
				e:SetScale( ( pos - info:GetInflictor( ):GetShootPos( ) ):Angle( ).y )
				e:SetEntity( info:GetInflictor( ) )
			end
			
			e:SetOrigin( pos )
			e:SetDamageType( info:GetDamageType( ) )
			e:SetAttachment( iscrit and 1 or 0 )
			e:SetMagnitude( info:GetDamage( ) )
			
			util.Effect( "rpg_damagenumber", e, true, true )
		elseif amount > 0 then
			local e = EffectData( )
			
			local pos = info:GetDamagePosition( )
			
			if pos == vector_origin then
				pos = ent:LocalToWorld( vector_up * math.random( ent:OBBMins( ).z, ent:OBBMaxs( ).z ) )
			else
				pos = ent:NearestPoint( info:GetDamagePosition( ) )
			end
			
			e:SetScale( math.random( 360 ) )
			e:SetEntity( NULL )
			e:SetOrigin( pos )
			e:SetDamageType( info:GetDamageType( ) )
			e:SetAttachment( 0 )
			e:SetMagnitude( info:GetDamage( ) )
			
			util.Effect( "rpg_damagenumber", e )
		end
		
		if amount > ent:Health( ) then
			amount = ent:Health( )
			info:SetDamage( amount )
		end
	elseif ( ent:IsNPC( ) or self.SpecialTreatment[ ent:GetClass( ) ] ) and ent:Health( ) <= 0 then
		ent:SetHealth( 0 )
	end
end

local sk_battery = GetConVar( "sk_battery" )

--This is extremely dirty and I am sorry

local meta = FindMetaTable( "Player" )

meta.rpg_oldsetammo = meta.rpg_oldsetammo or meta.SetAmmo
meta.rpg_oldgiveammo = meta.rpg_oldgiveammo or meta.GiveAmmo

function meta:SetAmmo( amt, kind )
	if type( kind ) == "number" then
		if kind == -1 then
			return
		end
	
		kind = game.GetAmmoName( kind )
	end
	
	kind = kind:lower( )
	local max = RPG:MaxAmmo( self, kind )
	
	amt = math.min( max, amt )
	
	self:rpg_oldsetammo( amt, kind )	
end
function meta:GiveAmmo( amt, kind, hide )
	if type( kind ) == "number" then
		if kind == -1 then
			return
		end
		
		kind = game.GetAmmoName( kind )
	end
	
	kind = kind:lower( )
	local max = RPG:MaxAmmo( self, kind )
	local cur = self:GetAmmoCount( kind )
	
	if RPG:GetSkill( self, RPG.XSkills.ITSLIKECHRISTMAS ) > 0 then
		amt = amt * ( 1 + RPG:GetSkill( self, RPG.XSkills.ITSLIKECHRISTMAS ) * .1 )
	end
	
	if ( cur + amt ) > max then
		amt = ( max - cur )
	end
	
	if amt > 0 then
		self:rpg_oldgiveammo( amt, kind, hide )
	end
end
	
function RPG:PlayerCanPickupItem( pl, item )
	if item:GetClass( ) == "item_battery" and pl:Armor( ) + sk_battery:GetInt( ) > 100 then
		local max = 100 + math.max( 0, self:GetSkill( pl, RPG.XSkills.SUPERIORARMOR ) - 100 )
		
		if pl:Armor( ) >= max then
			return false
		end
	
		pl:SetArmor( math.min( max, pl:Armor( ) + sk_battery:GetInt( ) ) )
		pl:EmitSound( "items/battery_pickup.wav" )
		item:Remove( )
		return false
	elseif RPG.Pickups[ item:GetClass( ) ] then
		local data, amt, max
		
		data = RPG.Pickups[ item:GetClass( ) ]
		
		amt = pl:GetAmmoCount( data.T )
		max = RPG:MaxAmmo( pl, data.T )
		
		if amt < max then
			--Fake it
			pl:EmitSound( "items/ammo_pickup.wav" )
			pl:GiveAmmo( math.min( data.A, max - amt ), data.T )
			item:Remove( )
		end
		
		return false
	end
end
function RPG:PlayerCanPickupWeapon( pl, wep )
	if pl:HasWeapon( wep:GetClass( ) ) and not self.Settings.IgnoreAmmoLimits:GetBool( ) then
		return false
	end
end

function RPG:OnNPCKilled( npc, attacker, inflictor )
	if attacker:IsNPC( ) or ( attacker:IsValid( ) and self.SpecialTreatment[ attacker:GetClass( ) ] ) then
		attacker.Kills = ( attacker.Kills or 0 ) + 1
	end
	
	if inflictor == attacker then
		return
	end
	
	if inflictor:IsNPC( ) or ( inflictor:IsValid( ) and self.SpecialTreatment[ inflictor:GetClass( ) ] ) then
		inflictor.Kills = ( inflictor.Kills or 0 ) + 1
	end
end

function RPG:PlayerDeath( pl, inflictor, attacker )
	if attacker:IsNPC( ) or ( attacker:IsValid( ) and self.SpecialTreatment[ attacker:GetClass( ) ] ) then
		attacker.Kills = ( attacker.Kills or 0 ) + 1
	end
	
	if inflictor == attacker then
		return
	end
	
	if inflictor:IsNPC( ) or ( inflictor:IsValid( ) and self.SpecialTreatment[ inflictor:GetClass( ) ] ) then
		inflictor.Kills = ( inflictor.Kills or 0 ) + 1
	end
end

function RPG:Tick( )
	local k, v, j, n, a

	for k, v in pairs( player.GetAll( ) ) do
		a = 0

		if not v.RpgData then	continue	end

		for j, n in pairs( v.RpgData.Skills ) do
			if n > self.Skills[ j ]:GetMaximum( ) then
				a = a + ( self.Skills[ j ]:GetMaximum( ) - n )
				v.RpgData.Skills[ j ] = self.Skills[ j ]:GetMaximum( )
				self:BeamDown( v, nil, RPG_FIELD_SK, j, self.Skills[ j ]:GetMaximum( ) )
			end
		end

		if a > 0 then
			v.RpgData.SkillPoints = v.RpgData.SkillPoints + a
			self:BeamDown( v, v, RPG_FIELD_SP, v.RpgData.SkillPoints )
		end
	end
	
	for k, v in pairs( ents.GetAll( ) ) do
		if not ( v:IsNPC( ) or self.SpecialTreatment[ v:GetClass( ) ] ) then
			continue
		end
		
		v:SetNWString( "RPG.Name", v.ChampionName or ( v:GetName( ) ~= "" and v:GetName( ) or ( "#" .. v:GetClass( ) ) ) )
		v:SetNWInt( "RPG.Health", v:Health( ) )
		v:SetNWInt( "RPG.Kills", v.Kills or 0 )
	end
end

function RPG:OnEntityCreated( ent )
	timer.Simple( .1, function( )
		if not ent:IsValid( ) then
			return
		end

		if not ent:IsNPC( ) or self.SpecialTreatment[ ent:GetClass( ) ] or self.Exempt[ ent:GetClass( ) ] then
			return
		end

		if self.Settings.Champions:GetBool( ) and math.random( 1000 ) < self.Settings.ChampionChance:GetInt( ) then
			ent.ChampionName = Markov:Next( math.random( 4 ) )
			ent.DamageMul = math.Rand( .9, 1.7 )
			ent.DefenseMul = math.Rand( .9, 2.1 )
			ent:SetMaxHealth(  math.random( ent:Health( ) * .9, ent:Health( ) * 1.9 ) )
			ent:SetHealth( ent:GetMaxHealth( ) )
			ent:SetColor( Color( math.random( 255 ), math.random( 255 ), math.random( 255 ) ) )
		end

		if self.Settings.RandomSizes:GetBool( ) then
			ent:SetModelScale( math.Rand( .75, 1.25 ), 0 )
		end

		if ent:GetModelScale( ) ~= 1 then
			ent:SetMaxHealth( math.ceil( ent:GetModelScale( ) * ent:GetMaxHealth( ) ) )
			ent:SetHealth( ent:GetMaxHealth( ) )
			ent:SetNWInt( "RPG.MaxHealth", ent:GetMaxHealth( ) )
		end
	end )
end

function RPG:CreateEntityRagdoll( ent, ragdoll )
	ragdoll:SetColor( ent:GetColor( ) )
	ragdoll:SetModelScale( ent:GetModelScale( ), 0 )
end

local ammo_id_to_type = { "ar2", "ar2altfire", "pistol", "smg1", "357", "xbowbolt", "buckshot", "rpg_round", "smg1_grenade", "grenade", "slam" }

local function DropKeysByMemberIf( t, key, val )
	local out, k, v
	
	out = { }
	
	for k, v in pairs( t ) do
		if v[ key ] ~= val then
			out[ k ] = v
		end
	end
	
	return out
end
local function HighestKey( t, key )
	local max = -math.huge
	
	local k, v
	
	for k, v in pairs( t ) do
		if v[ key ] > max then
			max = v[ key ]
		end
	end
	
	return max
end

local function AmmoClamp( )
	local v, j, jj, _, __, amt, max, delta, t
	
	for _, v in ipairs( player.GetAll( ) ) do	
		delta = math.max( 5, 90 - RPG:GetSkill( v, RPG.XSkills.AMMOREGENERATION ) * 2.5 )
		
		delta = RPG:TimeScaleMultiplier( v, delta, -1 )
		
		v.NextAmmoRegen = v.NextAmmoRegen or ( CurTime( ) + delta )
			
		if v.NextAmmoRegen <= CurTime( ) and RPG:GetSkill( v, RPG.XSkills.AMMOREGENERATION ) > 0 then
			--Do a regen
			v.NextAmmoRegen = CurTime( ) + delta
			
			t = table.Copy( RPG.Pickups )
			
			for j, _ in pairs( RPG.Pickups ) do
				max = RPG:MaxAmmo( v, _.T )
				amt = v:GetAmmoCount( _.T )
				
				if amt >= max then
					t[ j ] = nil
				else
					t[ j ].Count = 0
				end
			end
			
			if table.Count( t ) == 0 then
				continue
			end
			
			for _, j in pairs( v:GetWeapons( ) ) do
				for __, jj in pairs( t ) do
					if FAS2_Attachments and j.ClassName == "fas2_ifak" then
						--This weapon doesn't actually report its ammo types as primary/secondary ( which is a shame that I have to hack it into the ammo regeneration )
						if jj.T == "bandages" then
							jj.Count = ( j == v:GetActiveWeapon( ) and 50 or 1 )
						elseif jj.T == "quickclots" then
							jj.Count = ( j == v:GetActiveWeapon( ) and 50 or 1 )
						elseif jj.T == "hemostats" then
							jj.Count = ( j == v:GetActiveWeapon( ) and 50 or 1 )
						end
					elseif j.Primary then
						if tostring( j.Primary.Ammo ):lower( ) == jj.T:lower( ) or tostring( j.Secondary.Ammo ):lower( ) == jj.T:lower( ) then
							jj.Count = jj.Count + ( j == v:GetActiveWeapon( ) and 99 or 1 )
						end
					else
						if ammo_id_to_type[ j:GetPrimaryAmmoType( ) ] == jj.T:lower( ) or ammo_id_to_type[ j:GetSecondaryAmmoType( ) ] == jj.T:lower( ) then
							jj.Count = jj.Count + ( j == v:GetActiveWeapon( ) and 99 or 1 )
						end
					end
				end
			end
				
			for _, j in SortedPairsByMemberValue( t, "Count", true ) do
				t = j
				break
			end
			
			if t.Count > 0 then
				if RPG.Settings.StaticAmmoRegen:GetBool( ) then
					v:GiveAmmo( math.max( 0, RPG.Settings.StaticAmmoRegenAmount:GetInt( ) ), t.T )
				else
					v:GiveAmmo( t.A, t.T )
				end
			end
		end
	end
	
	for j, _ in pairs( RPG.AmmoTypes ) do
		for _, v in ipairs( player.GetAll( ) ) do		
			max = RPG:MaxAmmo( v, j )
			amt = v:GetAmmoCount( j )
			
			if amt > max then
				v:SetAmmo( max, j )
			end
		end
	end
end
local function ccRequestBan( pl, _, args )
	local who = tonumber( args[ 1 ] )
		
	if not who then
		--Invalid input
		return
	end
		
	if who > game.MaxPlayers( ) then
		return
	end
		
	who = Entity( who )
		
	if not who:IsPlayer( ) then
		return
	end
		
	RPG:BeamEntireFrame( who, pl )
end
local function ccPurchaseSkill( pl, _, args )
	if not pl.RpgData then
		return
	end
	
	if pl.RpgData.SkillPoints < 1 then
		return
	end
	
	local sk = tonumber( args[ 1 ] ) or -1
	
	if not RPG.Skills[ sk ] then
		return
	end
	
	sk = RPG.Skills[ sk ]
	
	if pl.RpgData.Skills[ sk:GetID( ) ] == sk:GetMaximum( ) then
		return
	end
	
	pl.RpgData.SkillPoints = pl.RpgData.SkillPoints - 1
	pl.RpgData.Skills[ sk:GetID( ) ] = ( pl.RpgData.Skills[ sk:GetID( ) ] or 0 ) + 1
	
	if sk.OnApply then
		sk.OnApply( sk, pl )
	end
	
	RPG:BeamDown( pl, nil, RPG_FIELD_SK, sk:GetID( ), pl.RpgData.Skills[ sk:GetID( ) ], RPG_FIELD_SP, pl.RpgData.SkillPoints )
end
local function ccUpdateSkill( pl, _, args )
	if not pl:IsAdmin( ) then
		return
	end
	
	local sk, b, c
	
	sk = tonumber( args[ 1 ] ) or -1
	b = tonumber( args[ 2 ] ) ~= 0
	c = tonumber( args[ 3 ] ) or 1
	
	if not RPG.Skills[ sk ] then
		return
	end
	
	sk = RPG.Skills[ sk ]
	
	sk:SetAdjustedMaximum( c )
	sk:SetEnabled( b )
	
	RPG:UpdateSkill( sk:GetID( ), c, b )
end
local function ccResetMe( pl, _, args )
	if not args[ 1 ] then
		return
	end
	
	if args[ 1 ] ~= pl.RpgData.LastResetCode then
		return
	end

	RPG:PreparePlayer( pl )
	RPG:SavePlayer( pl )
	RPG:BeamEntireFrame( pl )
end
local function ccRespec( pl )
	local k, v, n
	
	n = 0
	
	for k, v in pairs( pl.RpgData.Skills ) do
		n = n + v
		pl.RpgData.Skills[ k ] = 0
	end
	
	pl.RpgData.SkillPoints = pl.RpgData.SkillPoints + n
	RPG:SavePlayer( pl )
	RPG:BeamEntireFrame( pl )
end
local function ccAdjustEntity( pl, _, args )
	if not pl:IsAdmin( ) then
		return
	end
	
	local class, b = args[ 1 ], tonumber( args[ 2 ] ) == 1
	
	RPG.SpecialTreatment[ class ] = b
	
	net.Start( "RPG_BEAM_FILTER" )
		net.WriteInt( 1, 32 )
		net.WriteString( class )
		net.WriteInt( b and 1 or 0, 2 )
	net.Broadcast( )
	
	local strm = file.Open( "rpg/extranpcs.txt", "wb", "DATA" )
		local count = table.Count( RPG.SpecialTreatment )
		
		strm:WriteShort( count )
		
		local k, v
		
		for k, v in pairs( RPG.SpecialTreatment ) do
			strm:WriteShort( #k )
			strm:Write( k )
			strm:WriteBool( v )
		end
	strm:Close( )
end
local function SendAllTreatment( pl )
	local k, v
	net.Start( "RPG_BEAM_FILTER" )
		net.WriteInt( table.Count( RPG.SpecialTreatment ), 32 )
		
		for k, v in pairs( RPG.SpecialTreatment ) do
			net.WriteString( k )
			net.WriteInt( v and 1 or 0, 2 )
		end
	net.Send( pl )
end

local function InitPostEntity( )
	hook.Add( ulx and "ShowHelp" or "ShowSpare1", "RPG." .. ( ulx and "ShowHelp" or "ShowSpare1" ), function( pl ) pl.RpgData.LastResetCode = math.random( 9 ) .. math.random( 9 ) .. math.random( 9 ) SendUserMessage( "RPG_OPEN_MENU", pl, pl.RpgData.LastResetCode ) end )	
end

hook.Add( "InitPostEntity", "RPG.SetupMenuKey", InitPostEntity )

hook.Add( "EntityTakeDamage", RPG, RPG.EntityTakeDamage )
hook.Add( "PlayerInitialSpawn", RPG, function( this, pl ) RPG:LoadPlayer( pl )  end )
hook.Add( "PlayerSpawn", "RPG.PlayerSpawn.UpdateTreatment", function( pl ) if pl:IsAdmin( ) then timer.Simple( 2, function( ) SendAllTreatment( pl ) end ) end end )
hook.Add( "PlayerCanPickupItem", RPG, RPG.PlayerCanPickupItem )
hook.Add( "PlayerCanPickupWeapon", RPG, RPG.PlayerCanPickupWeapon )
hook.Add( "Tick", RPG, RPG.Tick )
hook.Add( "Tick", "RPG.ClampAmmo", AmmoClamp )
hook.Add( "PlayerDisconnected", RPG, RPG.SavePlayer )
hook.Add( "ShutDown", "RPG.SaveActivePlayers", function( ) local k, v for k, v in ipairs( player.GetAll( ) ) do RPG:SavePlayer( v ) end end )
hook.Add( "OnNPCKilled", RPG, RPG.OnNPCKilled )
hook.Add( "PlayerDeath", RPG, RPG.PlayerDeath )
hook.Add( "OnEntityCreated", RPG, RPG.OnEntityCreated )
hook.Add( "CreateEntityRagdoll", RPG, RPG.CreateEntityRagdoll )

timer.Create( "RPG.Autosave", 60, 0, function( )
	local k, v
	
	for k, v in ipairs( player.GetAll( ) ) do
		RPG:SavePlayer( v )
	end
end )

concommand.Add( "rpg_request_ban", ccRequestBan )
concommand.Add( "rpg_ready", function( pl ) ccRequestBan( pl, _, { pl:EntIndex( ) } ) end )
concommand.Add( "rpg_purchase_skill", ccPurchaseSkill )
concommand.Add( "rpg_reset_me", ccResetMe )
concommand.Add( "rpg_respec_me", ccRespec )
concommand.Add( "rpg_equal_treatment", ccAdjustEntity )
concommand.Add( "rpg_update_skill", ccUpdateSkill )