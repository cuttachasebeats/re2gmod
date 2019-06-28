print("Derma functions loaded.")

util.AddNetworkString("f4_open")
util.AddNetworkString("SendRoundInfo")

function openRE2Main( ply )
  isAdmin = false //default if player is not admin in config table.
  isInRound = false //defaults if the merchant timer is greater than 0
  isInPrep = false //defaults when game starts, your not in prep mode.
  isInMerchant = false //Defaults when your not in merchant mode.
  plyGroup = ply:GetUserGroup()

  for x = 1 , #CAN_ACCESS_ADMINF4 do   //checks the admin table in the config file.
    if plyGroup == CAN_ACCESS_ADMINF4[x] then
      isAdmin = true
    end
  end

  if GetGlobalString("Mode") == "prep" then
    isInPrep = true else
      isInPrep = false
  end

  if GetGlobalString("Mode") == "Merchant" then
    isInMerchant = true else
      isInMerchant = false
  end

  if GetGlobalInt("Re2_CountDown") == 0 then
    isInRound = true
  end
  if GetGlobalString("Mode") == "prep" then
    isInRound = true
  end

print("Dev prints(derma_functions.lua line 36)\n".."inMerchant?: "..tostring(isInMerchant).."\n".."inPrep?: "..tostring(isInPrep).."\n".."inRound?: "..tostring(isInRound))


    net.Start( "f4_open")
    net.WriteBool(isAdmin)
    net.WriteBool(isInRound)
    net.Send(ply)
end

hook.Add("ShowSpare2","f4_open",openRE2Main)
