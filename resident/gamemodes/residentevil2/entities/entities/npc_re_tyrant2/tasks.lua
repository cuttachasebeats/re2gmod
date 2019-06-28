function ENT:TaskStart_PlaySequence( data )

	local SequenceID = data.ID

	if ( data.Name ) then SequenceID = self:LookupSequence( data.Name )	end

	self:ResetSequence( SequenceID )
	self:SetNPCState( NPC_STATE_SCRIPT )

	local Duration = self:SequenceDuration()

	if ( data.Speed && data.Speed > 0 ) then

		SequenceID = self:SetPlaybackRate( data.Speed )
		Duration = Duration / data.Speed

	end

	self.TaskSequenceEnd = CurTime() + Duration
	self.Loop = data.Loop or false

end

function ENT:Task_PlaySequence( data )

	-- Wait until sequence is finished
	if ( CurTime() < self.TaskSequenceEnd or self.Loop ) then return end

	self:TaskComplete()
	self:SetNPCState( NPC_STATE_NONE )

	-- Clean up
	self.TaskSequenceEnd = nil

end


--[[---------------------------------------------------------
	Task: FindEnemy
	Accepts:
	data.ID		- sequence id
	data.Name	- sequence name (Must provide either id or name)
	data.Wait	- Optional. Should we wait for sequence to finish
	data.Speed	- Optional. Playback speed of sequence
-----------------------------------------------------------]]
function ENT:TaskStart_FindEnemy( data )

	local pos = self:GetPos()

	local min_dist, closest_target = -1, nil

	for _, target in pairs(player.GetAll()) do
		if (IsValid(target)&&target:Alive()&&target:Team() != TEAM_SPECTATOR&&GetGlobalString("Mode") != "End"&&target:GetMoveType() == MOVETYPE_WALK) then
			local dist = target:NearestPoint(pos):Distance(pos)
			if ((dist < min_dist||min_dist==-1)) then
				closest_target = target
				min_dist = dist
				self:SetEnemy( target )
			end
		end
	end
	
	local et = ents.FindInSphere( self:GetPos(), data.Radius or 512 )
	for k, v in ipairs( et ) do

		if ( v:IsValid() && v != self && v:GetClass() == data.Class ) then

			self:SetEnemy( v, true )
			self:UpdateEnemyMemory( v, v:GetPos() )
			self:TaskComplete()
			return
		end

	end

	self:SetEnemy( NULL )
	
	
end

function ENT:Task_FindEnemy( data )
end