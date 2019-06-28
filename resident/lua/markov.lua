Markov = { }

Markov.N = 2
Markov.Null = "\n"
Markov.State = { }

function Markov:Prefix( a, b )
	return a .. b
end

function Markov:Insert( i, v )
	self.State[ i ] = self.State[ i ] or { }
	self.State[ i ][ #self.State[ i ] + 1 ] = v
end

function Markov:Seed( data )
	local a, b, i, j, k, v
	a, b = self.Null, self.Null
	
	for k, v in ipairs( data ) do
		v = v:gsub( "^(%U)(%U+)", function( a, b ) return a:lower( ) .. b:lower( ) end )
	
		self:Insert( self:Prefix( a, b ), v )
		a, b = b, v
	end
	
	self:Insert( self:Prefix( a, b ), self.Null )
end

function Markov:Next( c )
	local skip, i, result, r, nextw, a, b, k, j
	
	a, b = self.Null, self.Null
	
	result = ""
	
	for j = 1, ( c or self.N ) do
		skip = math.random( 16 )
		
		for i = 1, skip do
			nextw = ""
			k = self.State[ self:Prefix( a, b ) ] or { }
			
			if not k then
				break
			end
			
			r = math.random( #k )
			nextw = k[ r ] or ""
			
			if nextw == self.NULL then
				break
			end
			
			a, b = b, nextw
		end
		
		result = result == "" and nextw or ( result .. ( math.random( ) > .6 and " " or "" ) .. nextw )
	end
	
	result = result:lower( )
	result = result:gsub( "^(%U)", function( a ) return a:upper( ) end )
	result = result:gsub( "%s(%U)", function( a ) return a:upper( ) end )
	
	return result
end

local blob = [[The Frost snake Taint fang Spite figure Glow mouth Thin Deformity Needy Mongrel Corrupt Howler Blind World Bull Crazed Hunting Dragon Black Striped Nightmare Dog Gut fiend Gas wraith Phaseling Horror figure Haunting Woman Twin Mutt Ancient Howler Greater World Leviathan Golden Venom Behemoth Howling Butcher Sheep Coffin teeth Stench mouth Fog thing Grieve thing Big Bad Babbler Quiet Mutant Black Fiend Obsidian Mocking Lynx Ravaging Venom Bison Blood Eyed Skeleton Alligator
]]

Markov:Seed( string.Explode( " ", blob ) )