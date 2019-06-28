
local PLY = FindMetaTable("Player")

function PLY:AddStat(StatName,Amount)
	if GetGlobalString("Mode") != "On" then return end
	if self:GetNWInt("KnifeKills") == nil then
		self:SetNWInt(StatName,Amount)
	else
		self:SetNWInt(StatName,self:GetNWInt(StatName) + (Amount))
	end
end

function PLY:SetStat(StatName,Amount)
	local StatsTable = self.RE2Data["Stats"]
	self:SetNWInt(StatName,Amount)
end

function PLY:DeathReward()
	if self.CanEarn then
		local reward = math.Round((self:GetNWInt("Time")/60) * self:GetNWInt("killcount") + self:GetNWInt("killcount"))
		self:SetNWInt("Money",math.Round(self:GetNWInt("Money") + reward * GAMEMODE.ZombieData[GetGlobalString("Re2_Difficulty")].Modifier ))
		self.CanEarn = false
		self:PrintMessage(HUD_PRINTTALK,"You earned $"..reward)
	end
end




