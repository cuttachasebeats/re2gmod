util.AddNetworkString( "RE2_MakeTrack" )
util.AddNetworkString( "RE2_MakeTrack2" )
util.AddNetworkString( "RE2_MakeTrack3" )

function GM:SelectMusic(Mode)
	if Mode == "prep" || Mode == "Merchant" then
		local music = table.Random(GAMEMODE.Music.Safe).Sound
		if SERVER then
			SetGlobalString( "Music", music)
			for _,ply in pairs(player.GetAll()) do
				net.Start("RE2_MakeTrack")
				net.WriteString(music)
				net.Send( ply )
			end
		end
	elseif Mode == "On" then
		local music = table.Random(GAMEMODE.Music.Battle).Sound
		if SERVER then
			SetGlobalString( "Music", music)
			for _,ply in pairs(player.GetAll()) do
				net.Start("RE2_MakeTrack2")
				net.WriteString(music)
				net.Send( ply )
			end
		end
	elseif Mode == "End" then
		local music = table.Random(GAMEMODE.Music.End).Sound
		if SERVER then
			for _,ply in pairs(player.GetAll()) do
				net.Start("RE2_MakeTrack3")
				net.WriteString(music)
				net.Send( ply )
			end
		end
	end
end
