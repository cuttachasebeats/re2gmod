util.AddNetworkString("PauseTimer")
util.AddNetworkString("UnPauseTimer")
util.AddNetworkString("SetMoney")
util.AddNetworkString("CreateWeapon")
util.AddNetworkString("CreateItem")
util.AddNetworkString("SetDifficulty")
util.AddNetworkString("fixPlayer")

function PauseTimer()
  timer.Pause("Re2_CountDowntimer_Survivor")
  timer.Pause("Re2_CountDowntimer")
    if CLIENT then
      timer.Pause("Re2_CountDowntimer_Survivor")
      timer.Pause("Re2_CountDowntimer")
    end
end

function UnPauseTimer()
  timer.UnPause("Re2_CountDowntimer_Survivor")
  timer.UnPause("Re2_CountDowntimer")
    if CLIENT then
      timer.UnPause("Re2_CountDowntimer_Survivor")
      timer.UnPause("Re2_CountDowntimer")
    end
end

function SetPlayerMoney()
  PlayerID = net.ReadString(name)
  moneyRecieved = net.ReadString(money)
  newMoney = tonumber(moneyRecieved)

  for k, v in pairs( player.GetAll() ) do
	 foundID = v:SteamID()
   if PlayerID == foundID then
     v:SetNWInt("Money",newMoney)
       v:ChatPrint("Your money has been set to: "..newMoney)
     GAMEMODE:Save(v)
     print("Saved "..v:Name().." money.")
   end
 end
end


function CreateWeapon()
  weapon = net.ReadString(wname)
  creatorpos = net.ReadVector(playerPos)
	local item = ents.Create("item_base")
	item:SetNWString("Class", weapon)
	item:SetPos(creatorpos)
	item:Spawn()
end

function CreateItem()
  item = net.ReadString(iname)
  creatorpos = net.ReadVector(playerPos)
  AmountToSpawn = net.ReadString(itemCount)

  timer.Create("spawn item",.25,tonumber(AmountToSpawn),function()
	   local item2 = ents.Create("item_base")
	         item2:SetNWString("Class", item)
	         item2:SetPos(creatorpos)
	         item2:Spawn()
           if item2:GetPhysicsObject():IsValid() then
       			item2:GetPhysicsObject():ApplyForceCenter(Vector(0,0,10))
       		end
      end)
  timer.Simple(5,function() timer.Destroy("spawn item") end)
end

function SetDifficulty()
  reqestedDifficulty = net.ReadString(difficulty)
  SetGlobalString("RE2_Difficulty",reqestedDifficulty)
    for k,v in pairs(player.GetAll()) do
      v:ChatPrint("Gamemode Difficulty has been set to: "..reqestedDifficulty)
    end
end

function fixPlayer()
  reqestedSID = net.ReadString(SIDSelected2)

  for k, v in pairs( player.GetAll() ) do
    foundID = v:SteamID()
    if reqestedSID == foundID then
      v:SetHealth(100)
      v:SetNWBool("Infected", false)
      v:SetNWInt("InfectedPercent", 0)
      v:SetNWInt("Immunity", v:GetNWInt("Immunity") + 10 )
      v:ChatPrint("You have been healed/cured.")
    end
end

end

net.Receive("PauseTimer", function() PauseTimer() end)
net.Receive("UnPauseTimer", function() UnPauseTimer() end)
net.Receive("SetMoney",function() SetPlayerMoney() end)
net.Receive("CreateWeapon",function() CreateWeapon() end)
net.Receive("CreateItem",function() CreateItem() end)
net.Receive("SetDifficulty",function() SetDifficulty() end)
net.Receive("fixPlayer",function() fixPlayer() end)
