//These ranks can access the admin panel in the f4.
CAN_ACCESS_ADMINF4 = {
"owner",
"developer",
"superadmin"
}

module("configs", package.seeall)
GM.Config = {}

--Chest Upgrades--
GM.Config.MaxStorageSlots = 30
GM.Config.InitialStorageSlots = 5
GM.Config.StorageSlotPrice = 20000

--Sell Percentage--
GM.Config.SalePercent = 0.5



--Starting Money--
GM.Config.StartingMoney = 500

--Mode Reward Configs--

GM.Config.SurviorRewardMoney = 50
GM.Config.VIPRewardMoney = 200
GM.Config.TEAMVIPRewardMoney = 200
GM.Config.BossRewardMoney = 500
GM.Config.EscapeRewardMoney = 300

--Inventory Upgrades--
GM.Config.InventorySlotPrice = 10000
GM.Config.MaxUpgrades = 10
GM.Config.MaxInventorySlots = 8
GM.Config.InitialInventorySlots = 6

--Death Reward--
GM.Config.DeathReward = 400

--Auto Save--
GM.Config.SaveFrequency = 60

--Zombies--
GM.Config.MaxZombies = 12

--Merchant Timer--
GM.Config.MerchantTime = 120

GM.Config.MerchantOpen = {
	"reg/merchant/welcome.wav",
	"reg/merchant/whatayabuyin.wav",
}

GM.Config.MerchantClose = {
"reg/merchant/comebackanytime.wav",
}

GM.Config.MerchantBuy = {
	"reg/merchant/isthatall.wav",
	"reg/merchant/thankyou.wav",
}

-- Money values for zombie kills
GM.Config.KillValues = {

	[ "snpc_shambler3" ] = 1,

}
