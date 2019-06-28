hook.Add( "PlayerDeath", "levelup_ttt_givekillexp", function( victim, inflictor, attacker )
	if victim:IsPlayer() and attacker:IsPlayer() then
		if victim:GetRole() ~= attacker:GetRole() then
			if attacker:GetRole() == ROLE_INNOCENT and victim:GetRole() == ROLE_TRAITOR then
				levelup.increaseExperience( attacker, 5 )
			end
			if attacker:GetRole() == ROLE_TRAITOR then
				levelup.increaseExperience( attacker, 5 )
			end
			if attacker:GetRole() == ROLE_DETECTIVE and victim:GetRole() ~= ROLE_INNOCENT then
				levelup.increaseExperience( attacker, 5 )
			end
		end
	end
end )
hook.Remove( "PlayerDeath", "levelup_ttt_givekillexp" ) -- Comment this or remove this line to make the above hook work