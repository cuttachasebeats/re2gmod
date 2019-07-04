Weapons = {}

-- Weapons List
-- The upgrades tables might be in order


-- tfa guns --
Weapons["item_m16a1"] = {Weapon = "gdcw_m16a1_re"}
Weapons["item_dgal50"] = {Weapon = "gdcw_dgal50_re"}
Weapons["item_m249"] = {Weapon = "gdcw_m-249saw_re"}




------------------------------------------------------
Weapons["item_9mmhandgun"] = {Weapon = "weapon_9mm_re"}
Weapons["item_m4"] = {Weapon = "weapon_m4_re"}
Weapons["item_p90"] = {Weapon = "weapon_p90_re"}
Weapons["item_pumpshot"] = {Weapon = "weapon_pumpshot_re"}
Weapons["item_glock18"] = {Weapon = "weapon_glock18_re"}
Weapons["item_aug"] = {Weapon = "weapon_aug_re"}
Weapons["item_mp5"] = {Weapon = "weapon_mp5_re"}
Weapons["item_ragerev"] = {Weapon = "weapon_ragerevolver_re"}
--
Weapons["item_p228"] = {Weapon = "weapon_p228_re"}
Weapons["item_ak47"] = {Weapon = "weapon_ak47_re"}
Weapons["item_ump"] = {Weapon = "weapon_ump_re"}
--
Weapons["item_awp"] = {Weapon = "weapon_awp_re"}

Weapons["item_an94"] = {Weapon = "weapon_an94_re"}
Weapons["item_ballista"] = {Weapon = "weapon_ballista_re"}
Weapons["item_dsr50"] = {Weapon = "weapon_dsr50_re"}
Weapons["item_executioner"] = {Weapon = "weapon_executioner_re"}
Weapons["item_kap40"] = {Weapon = "weapon_kap40_re"}
Weapons["item_peace"] = {Weapon = "weapon_peacekeeper_re"}
Weapons["item_pdw"] = {Weapon = "weapon_pdw_re"}

UpgPrices = {}
UpgradeLevels = {}

GM.Weapons = {}
-----------------------TFA Guns
GM.Weapons["item_m16a1"] = {
	Weapon = "gdcw_m16a1_re",
	Item = "item_m16a1",
	AmmoTypes = {{item = "item_ammo_rifle",Icon = "gui 	/ammo/rifle"}},
	Position = Vector(-3, 0, 3.5),
	Angle = Angle(0, 180, 0),
	Recoil = 0.75,
	IMultiplier = 0.75,
	UpGrades = {
		Power = {{Price = 300, Level = 27},
				{Price = 1500, Level = 29},
				{Price = 2500, Level = 30},
				{Price = 4000, Level = 32},
				{Price = 12000, Level = 33},
				{Price = 18000, Level = 37},
				{Price = 26000, Level = 40},
				{Price = 32000, Level = 44},
				{Price = 42000, Level = 49},
				{Price = 52000, Level = 52},},
		Accuracy = {{Price = 600, Level = 0.08},
				{Price = 1500, Level = 0.06},
				{Price = 3000, Level = 0.05},
				{Price = 6000, Level = 0.04},},
		ClipSize = {{Price = 100, Level = 30},
				{Price = 1300, Level = 35},
				{Price = 2000, Level = 40},
				{Price = 2600, Level = 45},},
		FiringSpeed = {{Price = 400, Level = 1},
				{Price = 1400, Level = 10},
				{Price = 2200, Level = 15},
				{Price = 3100, Level = 20},
				{Price = 10100, Level = 25},
				{Price = 20100, Level = 30},
				{Price = 30100, Level = 35},},
		ReloadSpeed = {{Price = 800, Level = 5},
				{Price = 1200, Level = 4},
				{Price = 2200, Level = 3},},
	},
}

GM.Weapons["item_dgal50"] = {
	Weapon = "gdcw_dgal50_re",
	Item = "item_dgal50",
	AmmoTypes = {{item = "item_ammo_magnum",Icon = "gui/ammo/357"}},
	Position = Vector(-3, 0, 3.5),
	Angle = Angle(0, 180, 0),
	Recoil = 0.75,
	IMultiplier = 0.75,
	UpGrades = {
		Power = {{Price = 100, Level = 68},
				{Price = 1500, Level = 74},
				{Price = 2500, Level = 86},
				{Price = 4000, Level = 95},
				{Price = 8000, Level = 105},
				{Price = 20000, Level = 115},
				{Price = 25000, Level = 125},
				{Price = 30000, Level = 135},
				{Price = 35000, Level = 145},
				{Price = 40000, Level = 155},
				{Price = 45000, Level = 165},
				{Price = 50000, Level = 175},
				{Price = 55000, Level = 185},
				{Price = 65000, Level = 195},
				{Price = 75000, Level = 205},
				{Price = 85000, Level = 215},
				{Price = 95000, Level = 225},},
		Accuracy = {{Price = 100, Level = 0.04},
				{Price = 1500, Level = 0.035},
				{Price = 9500, Level = 0.025},},
		ClipSize = {{Price = 100, Level = 7},
				{Price = 1300, Level = 8},
				{Price = 2000, Level = 9},
				{Price = 2600, Level = 10},
				{Price = 4600, Level = 11},
				{Price = 6600, Level = 12},},
		FiringSpeed = {{Price = 100, Level = 1},
				{Price = 1400, Level = 10},},
		ReloadSpeed = {{Price = 400, Level = 4},
				{Price = 1000, Level = 3},
				{Price = 2000, Level = 2},
				{Price = 5000, Level = 1},},
	},
}

GM.Weapons["item_m249"] = {
	Weapon = "gdcw_m-249saw_re",
	Item = "item_m249",
	AmmoTypes = {{item = "item_bandolier",Icon = "gui/ammo/minigun"}},
	UpGrades = {
		Power = {{Price = 0, Level = 50},
				{Price = 3500, Level = 55},
				{Price = 5500, Level = 60},
				{Price = 7000, Level = 65},
				{Price = 14000, Level = 70},
				{Price = 21000, Level = 75},
				{Price = 28000, Level = 80},
				{Price = 35000, Level = 85},},
		Accuracy = {{Price = 0, Level = 0.10},
				{Price = 2500, Level = 0.09},
				{Price = 3000, Level = 0.08},
				{Price = 4000, Level = 0.07},},
		ClipSize = {{Price = 0, Level = 150},},
		FiringSpeed = {{Price = 0, Level = 0.1},
				{Price = 1400, Level = 0.09},
				{Price = 2200, Level = 0.08},
				{Price = 10200, Level = 0.07},},
		ReloadSpeed = {{Price = 400, Level = 5},},
	},
	Size = 1,
}















------------------------Main Start Guns
GM.Weapons["item_9mmhandgun"] = {
	Weapon = "weapon_9mm_re",
	Item = "item_9mmhandgun",
	AmmoTypes = {{item = "item_ammo_pistol",Icon = "gui/ammo/handgun"}},
	Position = Vector(-3, 0, 3.5),
	Angle = Angle(0, 180, 0),
	Recoil = 0.75,
	IMultiplier = 0.75,
	UpGrades = {
		Power = {{Price = 100, Level = 17},
				{Price = 1500, Level = 20},
				{Price = 2500, Level = 23},
				{Price = 4000, Level = 25},
				{Price = 8000, Level = 28},
				{Price = 12000, Level = 31},
				{Price = 16000, Level = 34},
				{Price = 20000, Level = 37},
				{Price = 24000, Level = 40},
				{Price = 28000, Level = 43},
				{Price = 32000, Level = 46},
				{Price = 36000, Level = 49},
				{Price = 40000, Level = 52},
				{Price = 44000, Level = 55},
				{Price = 48000, Level = 58},
				{Price = 52000, Level = 61},},
		Accuracy = {{Price = 100, Level = 0.08},
				{Price = 1500, Level = 0.07},
				{Price = 3000, Level = 0.06},
				{Price = 4000, Level = 0.05},
				{Price = 12000, Level = 0.04},
				{Price = 50000, Level = 0.03},
				{Price = 100000, Level = 0.02},},
		ClipSize = {{Price = 100, Level = 15},
				{Price = 1300, Level = 20},
				{Price = 2000, Level = 25},
				{Price = 2600, Level = 30},
				{Price = 5600, Level = 35},
				{Price = 10600, Level = 40},},
		FiringSpeed = {{Price = 100, Level = 0.1},
				{Price = 1400, Level = 0.08},
				{Price = 2200, Level = 0.06},
				{Price = 3100, Level = 0.04}},
		ReloadSpeed = {{Price = 400, Level = 2.4},
				{Price = 1000, Level = 2.2},
				{Price = 2000, Level = 2.1},
				{Price = 5000, Level = 2.0},
				{Price = 10000, Level = 1.9},},
	},
}



GM.Weapons["item_p228"] = {
	Weapon = "weapon_p228_re",
	Item = "item_p228",
	AmmoTypes = {{item = "item_ammo_pistol",Icon = "gui/ammo/handgun"}},
	Position = Vector(-3, 0, 3.5),
	Angle = Angle(0, 180, 0),
	Recoil = 0.75,
	IMultiplier = 0.75,
	UpGrades = {
		Power = {{Price = 100, Level = 18},
				{Price = 1500, Level = 21},
				{Price = 2500, Level = 24},
				{Price = 4000, Level = 26},
				{Price = 8000, Level = 29},
				{Price = 12000, Level = 32},
				{Price = 16000, Level = 35},
				{Price = 20000, Level = 38},
				{Price = 24000, Level = 41},
				{Price = 28000, Level = 44},
				{Price = 32000, Level = 47},
				{Price = 36000, Level = 50},
				{Price = 40000, Level = 53},
				{Price = 44000, Level = 56},
				{Price = 48000, Level = 59},
				{Price = 52000, Level = 62},},
		Accuracy = {{Price = 100, Level = 0.08},
				{Price = 1500, Level = 0.06},
				{Price = 3000, Level = 0.05},},
		ClipSize = {{Price = 100, Level = 13},
				{Price = 1300, Level = 18},
				{Price = 2000, Level = 25},
				{Price = 2600, Level = 30}},
		FiringSpeed = {{Price = 100, Level = 0.15},
				{Price = 1400, Level = 0.13},
				{Price = 2200, Level = 0.1},},
		ReloadSpeed = {{Price = 400, Level = 2.3},
				{Price = 1000, Level = 2.1},
				{Price = 1000, Level = 2.0},
				{Price = 1000, Level = 1.9},},
	},
}

GM.Weapons["item_glock18"] = {
	Weapon = "weapon_glock18_re",
	Item = "item_glock18",
	AmmoTypes = {{item = "item_ammo_pistol",Icon = "gui/ammo/handgun"}},
	Position = Vector(-3, 0, 3.5),
	Angle = Angle(0, 180, 0),
	Recoil = 0.75,
	IMultiplier = 1.1,
	UpGrades = {
		Power = {{Price = 100, Level = 18},
				{Price = 1500, Level = 21},
				{Price = 2500, Level = 24},
				{Price = 4000, Level = 26},
				{Price = 8000, Level = 29},
				{Price = 12000, Level = 32},
				{Price = 16000, Level = 35},
				{Price = 20000, Level = 38},
				{Price = 24000, Level = 41},
				{Price = 28000, Level = 44},
				{Price = 32000, Level = 47},
				{Price = 36000, Level = 50},
				{Price = 40000, Level = 53},
				{Price = 44000, Level = 56},
				{Price = 48000, Level = 59},
				{Price = 52000, Level = 62},},
		Accuracy = {{Price = 100, Level = 0.07},
				{Price = 1500, Level = 0.06},
				{Price = 3000, Level = 0.05},
				{Price = 3000, Level = 0.04},},
		ClipSize = {{Price = 100, Level = 20},
				{Price = 1300, Level = 30},
				{Price = 2000, Level = 35},
				{Price = 2600, Level = 40}},
		FiringSpeed = {{Price = 100, Level = 0.2},
				{Price = 1400, Level = 0.18},
				{Price = 2200, Level = 0.16},
				{Price = 2200, Level = 0.15},},
		ReloadSpeed = {{Price = 400, Level = 2.5},
				{Price = 1000, Level = 2.3},
				{Price = 1000, Level = 2.2},
				{Price = 4000, Level = 2.0},},
	},
}

GM.Weapons["item_ragerev"] = {
	Weapon = "weapon_ragerev_re",
	Item = "item_ragerev",
	AmmoTypes = {{item = "item_ammo_magnum",Icon = "gui/ammo/357"}},
	Position = Vector(-3, 0, 3.5),
	Angle = Angle(0, 180, 0),
	Recoil = 0.75,
	IMultiplier = 0.75,
	UpGrades = {
		Power = {{Price = 100, Level = 75},
				{Price = 1500, Level = 81},
				{Price = 2500, Level = 90},
				{Price = 4000, Level = 105},
				{Price = 8000, Level = 120},
				{Price = 20000, Level = 130},
				{Price = 25000, Level = 140},
				{Price = 30000, Level = 150},
				{Price = 35000, Level = 160},
				{Price = 40000, Level = 170},
				{Price = 45000, Level = 180},
				{Price = 50000, Level = 190},
				{Price = 55000, Level = 200},
				{Price = 65000, Level = 210},
				{Price = 75000, Level = 220},
				{Price = 85000, Level = 230},
				{Price = 95000, Level = 240},},
		Accuracy = {{Price = 100, Level = 0.04},
				{Price = 1500, Level = 0.03},},
		ClipSize = {{Price = 100, Level = 6},},
		FiringSpeed = {{Price = 100, Level = 0.4},
				{Price = 1400, Level = 0.3},
				{Price = 1400, Level = 0.2},
				{Price = 1400, Level = 0.1},},
		ReloadSpeed = {{Price = 400, Level = 2.3},
				{Price = 1000, Level = 2.1},
				{Price = 1000, Level = 2.0},
				{Price = 1000, Level = 1.9},},
	},
}

GM.Weapons["item_m29"] = {
	Weapon = "weapon_m29_re",
	Item = "item_m29",
	AmmoTypes = {{item = "item_ammo_magnum",Icon = "gui/ammo/357"}},
	Position = Vector(-3, 0, 3.5),
	Angle = Angle(0, 180, 0),
	Recoil = 0.75,
	IMultiplier = 0.75,
	UpGrades = {
		Power = {{Price = 100, Level = 90},
				{Price = 1500, Level = 105},
				{Price = 2500, Level = 115},
				{Price = 4000, Level = 120},
				{Price = 8000, Level = 130},
				{Price = 14000, Level = 140},
				{Price = 20000, Level = 150},
				{Price = 28000, Level = 160},
				{Price = 34000, Level = 170},
				{Price = 40000, Level = 180},
				{Price = 48000, Level = 190},
				{Price = 55000, Level = 200},
				{Price = 60000, Level = 210},
				{Price = 65000, Level = 220},
				{Price = 70000, Level = 230},
				{Price = 75000, Level = 240},
				{Price = 80000, Level = 250},},
		Accuracy = {{Price = 100, Level = 0.04},
				{Price = 1500, Level = 0.03},
				{Price = 1500, Level = 0.02},},
		ClipSize = {{Price = 100, Level = 6},},
		FiringSpeed = {{Price = 100, Level = 0.8},
				{Price = 1400, Level = 0.7},
				{Price = 1400, Level = 0.6},
				{Price = 1400, Level = 0.5},},
		ReloadSpeed = {{Price = 400, Level = 2.5},
				{Price = 1000, Level = 2.3},},
	},
}

----- SMGS

GM.Weapons["item_p90"] = {
	Weapon = "weapon_p90_re",
	Item = "item_p90",
	AmmoTypes = {{item = "item_ammo_smg",Icon = "gui/ammo/machinegun"}},
	Position = Vector(-3, 0, 3.5),
	Angle = Angle(0, 180, 0),
	Recoil = 0.75,
	IMultiplier = 0.7,
	UpGrades = {
		Power = {{Price = 300, Level = 14},
				{Price = 1500, Level = 17},
				{Price = 2500, Level = 19},
				{Price = 4000, Level = 21},
				{Price = 10000, Level = 24},
				{Price = 14000, Level = 26},
				{Price = 18000, Level = 28},
				{Price = 22000, Level = 30},
				{Price = 26000, Level = 32},
				{Price = 30000, Level = 34},
				{Price = 34000, Level = 36},
				{Price = 38000, Level = 38},
				{Price = 42000, Level = 40},
				{Price = 46000, Level = 42},
				{Price = 50000, Level = 44},
				{Price = 54000, Level = 46},
				{Price = 58000, Level = 48},
				{Price = 62000, Level = 50},
				{Price = 68000, Level = 52},},
		Accuracy = {{Price = 600, Level = 0.11},
				{Price = 1500, Level = 0.095},
				{Price = 3000, Level = 0.08},
				{Price = 9000, Level = 0.07},
				{Price = 18000, Level = 0.06},},
		ClipSize = {{Price = 100, Level = 50},
				{Price = 1300, Level = 55},
				{Price = 4000, Level = 65},
				{Price = 8600, Level = 70}},
		FiringSpeed = {{Price = 400, Level = 0.13},
				{Price = 1400, Level = 0.11},
				{Price = 2200, Level = 0.09},
				{Price = 3100, Level = 0.07},},
		ReloadSpeed = {{Price = 400, Level = 4.0},
				{Price = 400, Level = 3.8},
				{Price = 800, Level = 3.6},
				{Price = 1200, Level = 3.4},},
	},
}

GM.Weapons["item_mp5"] = {
	Weapon = "weapon_mp5_re",
	Item = "item_mp5",
	AmmoTypes = {{item = "item_ammo_smg",Icon = "gui/ammo/machinegun"}},
	Position = Vector(-3, 0, 3.5),
	Angle = Angle(0, 180, 0),
	Recoil = 0.75,
	IMultiplier = 0.75,
	UpGrades = {
		Power = {{Price = 300, Level = 19},
				{Price = 1500, Level = 22},
				{Price = 2500, Level = 24},
				{Price = 4000, Level = 27},
				{Price = 8000, Level = 29},
				{Price = 12000, Level = 31},
				{Price = 16000, Level = 33},
				{Price = 20000, Level = 35},
				{Price = 24000, Level = 37},
				{Price = 28000, Level = 39},},
		Accuracy = {{Price = 600, Level = 0.10},
				{Price = 1500, Level = 0.09},
				{Price = 3000, Level = 0.08},
				{Price = 3000, Level = 0.07},},
		ClipSize = {{Price = 100, Level = 30},
				{Price = 1300, Level = 35},
				{Price = 2000, Level = 40},
				{Price = 2600, Level = 45}},
		FiringSpeed = {{Price = 400, Level = 0.15},
				{Price = 1400, Level = 0.12},
				{Price = 2200, Level = 0.1},
				{Price = 3100, Level = 0.09}},
		ReloadSpeed = {{Price = 400, Level = 3.8},
				{Price = 400, Level = 3.6},},
	},
}

GM.Weapons["item_ump"] = {
	Weapon = "weapon_ump_re",
	Item = "item_ump",
	AmmoTypes = {{item = "item_ammo_smg",Icon = "gui/ammo/machinegun"}},
	Position = Vector(-3, 0, 3.5),
	Angle = Angle(0, 180, 0),
	Recoil = 0.75,
	IMultiplier = 0.75,
	UpGrades = {
		Power = {{Price = 300, Level = 20},
				{Price = 1500, Level = 23},
				{Price = 2500, Level = 25},
				{Price = 4000, Level = 28},
				{Price = 8000, Level = 30},
				{Price = 12000, Level = 31},
				{Price = 16000, Level = 32},
				{Price = 20000, Level = 36},
				{Price = 28000, Level = 40},},
		Accuracy = {{Price = 600, Level = 0.11},
				{Price = 1500, Level = 0.09},
				{Price = 3000, Level = 0.07},},
		ClipSize = {{Price = 100, Level = 25},
				{Price = 1300, Level = 30},
				{Price = 2000, Level = 35},
				{Price = 2600, Level = 40},
				{Price = 2600, Level = 45},
				{Price = 2600, Level = 50},},
		FiringSpeed = {{Price = 400, Level = 0.2},
				{Price = 1400, Level = 0.18},
				{Price = 2200, Level = 0.15},
				{Price = 3100, Level = 0.11},},
		ReloadSpeed = {{Price = 400, Level = 3.9},
				{Price = 400, Level = 3.8},
				{Price = 800, Level = 3.6},
				{Price = 1200, Level = 3.4},},
	},
}

------- Assualt Rifles
GM.Weapons["item_m4"] = {
	Weapon = "weapon_m4_re",
	Item = "item_m4",
	AmmoTypes = {{item = "item_ammo_rifle",Icon = "gui 	/ammo/rifle"}},
	Position = Vector(-3, 0, 3.5),
	Angle = Angle(0, 180, 0),
	Recoil = 0.75,
	IMultiplier = 0.75,
	UpGrades = {
		Power = {{Price = 300, Level = 27},
				{Price = 1500, Level = 29},
				{Price = 2500, Level = 30},
				{Price = 4000, Level = 32},
				{Price = 12000, Level = 33},
				{Price = 18000, Level = 37},
				{Price = 26000, Level = 40},
				{Price = 32000, Level = 44},
				{Price = 42000, Level = 49},
				{Price = 52000, Level = 52},},
		Accuracy = {{Price = 600, Level = 0.08},
				{Price = 1500, Level = 0.06},
				{Price = 3000, Level = 0.05},
				{Price = 3000, Level = 0.04},},
		ClipSize = {{Price = 100, Level = 30},
				{Price = 1300, Level = 35},
				{Price = 2000, Level = 40},
				{Price = 2600, Level = 45}},
		FiringSpeed = {{Price = 400, Level = 0.17},
				{Price = 1400, Level = 0.14},
				{Price = 2200, Level = 0.1},
				{Price = 3100, Level = 0.08},
				{Price = 10100, Level = 0.07},},
		ReloadSpeed = {{Price = 400, Level = 4.2},
				{Price = 400, Level = 4.0},
				{Price = 400, Level = 3.8},},
	},
}

GM.Weapons["item_ak47"] = {
	Weapon = "weapon_ak47_re",
	Item = "item_ak47",
	AmmoTypes = {{item = "item_ammo_rifle",Icon = "gui/ammo/rifle"}},
	Position = Vector(-3, 0, 3.5),
	Angle = Angle(0, 180, 0),
	Recoil = 0.75,
	IMultiplier = 0.75,
	UpGrades = {
		Power = {{Price = 300, Level = 30},
				{Price = 1500, Level = 34},
				{Price = 5500, Level = 36},
				{Price = 10000, Level = 38},
				{Price = 20000, Level = 53},
				{Price = 50000, Level = 61},
				{Price = 60000, Level = 73},
				{Price = 80000, Level = 80},},
		Accuracy = {{Price = 600, Level = 0.16},
				{Price = 1500, Level = 0.15},
				{Price = 3000, Level = 0.13},
				{Price = 3500, Level = 0.10},
				{Price = 4000, Level = 0.07},
				{Price = 5000, Level = 0.06},},
		ClipSize = {{Price = 100, Level = 30},
				{Price = 1300, Level = 35},},
		FiringSpeed = {{Price = 400, Level = 0.18},
				{Price = 1400, Level = 0.15},
				{Price = 2200, Level = 0.11},},
		ReloadSpeed = {{Price = 400, Level = 4.3},
				{Price = 400, Level = 4.1},
				{Price = 400, Level = 4.0},},
	},
}

GM.Weapons["item_aug"] = {
	Weapon = "weapon_aug_re",
	Item = "item_aug",
	AmmoTypes = {{item = "item_ammo_rifle",Icon = "gui/ammo/rifle"}},
	Position = Vector(-3, 0, 3.5),
	Angle = Angle(0, 180, 0),
	Recoil = 0.75,
	IMultiplier = 0.6,
	UpGrades = {
		Power = {{Price = 300, Level = 28},
				{Price = 1500, Level = 30},
				{Price = 2500, Level = 32},
				{Price = 4000, Level = 34},
				{Price = 8000, Level = 36},
				{Price = 12000, Level = 38},
				{Price = 16000, Level = 40},
				{Price = 20000, Level = 41},
				{Price = 24000, Level = 42},
				{Price = 28000, Level = 43},
				{Price = 32000, Level = 44},
				{Price = 36000, Level = 45},
				{Price = 40000, Level = 46},},
		Accuracy = {{Price = 600, Level = 0.09},
				{Price = 1500, Level = 0.08},
				{Price = 3000, Level = 0.06},
				{Price = 6000, Level = 0.05},},
		ClipSize = {{Price = 100, Level = 30},
				{Price = 1300, Level = 35},
				{Price = 2000, Level = 40},
				{Price = 5000, Level = 45}},
		FiringSpeed = {{Price = 400, Level = 0.2},
				{Price = 1400, Level = 0.16},
				{Price = 2200, Level = 0.13},
				{Price = 7100, Level = 0.1}},
		ReloadSpeed = {{Price = 400, Level = 4.0},
				{Price = 400, Level = 3.9},
				{Price = 8000, Level = 3.7},
				{Price = 16000, Level = 3.5},},
	},
}

----- Shotgun(s)

GM.Weapons["item_pumpshot"] = {
	Weapon = "weapon_pumpshot_re",
	Item = "item_pumpshot",
	AmmoTypes = {{item = "item_ammo_buckshot",Icon = "gui/ammo/buckshot"}},
	Position = Vector(-3, 0, 3.5),
	Angle = Angle(0, 180, 0),
	NumShots = 8,
	Recoil = 0.75,
	IMultiplier = 0.7,
	UpGrades = {
		Power = {{Price = 300, Level = 8},
				{Price = 1500, Level = 11},
				{Price = 2500, Level = 13},
				{Price = 4000, Level = 15},
				{Price = 8000, Level = 16},
				{Price = 12000, Level = 17},
				{Price = 16000, Level = 18},
				{Price = 20000, Level = 19},
				{Price = 40000, Level = 21},
				{Price = 60000, Level = 23},
				{Price = 80000, Level = 25},},
		Accuracy = {{Price = 600, Level = 0.18},},
		ClipSize = {{Price = 100, Level = 6},
				{Price = 1300, Level = 7},
				{Price = 2000, Level = 8},
				{Price = 2600, Level = 9},
				{Price = 4600, Level = 10},
				{Price = 10600, Level = 11},},
		FiringSpeed = {{Price = 400, Level = 1},
				{Price = 1400, Level = 0.8},
				{Price = 2200, Level = 0.6},
				{Price = 5200, Level = 0.5},
				{Price = 10200, Level = 0.4},},
		ReloadSpeed = {{Price = 400, Level = .8},
				{Price = 400, Level = .7},
				{Price = 800, Level = .6},
				{Price = 1200, Level = .5},},
	},
}

GM.Weapons["item_striker7"] = {
	Weapon = "weapon_striker7_re",
	Item = "item_striker7",
	AmmoTypes = {{item = "item_ammo_buckshot",Icon = "gui/ammo/buckshot"}},
	Position = Vector(-3, 0, 3.5),
	Angle = Angle(0, 180, 0),
	NumShots = 10,
	Recoil = 0.75,
	IMultiplier = 0.7,
	UpGrades = {
		Power = {{Price = 300, Level = 9},
				{Price = 1500, Level = 10},
				{Price = 2500, Level = 11},
				{Price = 4000, Level = 12},
				{Price = 8000, Level = 13},
				{Price = 12000, Level = 14},
				{Price = 16000, Level = 15},
				{Price = 20000, Level = 16},
				{Price = 24000, Level = 17},
				{Price = 28000, Level = 18},
				{Price = 40000, Level = 20},
				{Price = 40000, Level = 23},
				{Price = 40000, Level = 26},
				{Price = 50000, Level = 30},
				{Price = 50000, Level = 50},},
		Accuracy = {{Price = 600, Level = 0.13},},
		ClipSize = {{Price = 100, Level = 8},
				{Price = 1300, Level = 9},
				{Price = 2000, Level = 10},
				{Price = 4600, Level = 11},
				{Price = 8600, Level = 12},
				{Price = 12600, Level = 13},
				{Price = 20600, Level = 14},},
		FiringSpeed = {{Price = 400, Level = 1},
				{Price = 1400, Level = 0.9},},
		ReloadSpeed = {{Price = 400, Level = 1.2},
				{Price = 400, Level = 1.1},
				{Price = 400, Level = 1.0},
				{Price = 400, Level = 0.9},
				{Price = 400, Level = 0.8},
				{Price = 10000, Level = 0.7},
				{Price = 20000, Level = 0.6},
				{Price = 30000, Level = 0.5},
				{Price = 40000, Level = 0.4},},
	},
}

GM.Weapons["item_spas12"] = {
	Weapon = "weapon_spas12_re",
	Item = "item_spas12",
	AmmoTypes = {{item = "item_ammo_buckshot",Icon = "gui/ammo/buckshot"}},
	Position = Vector(-3, 0, 3.5),
	Angle = Angle(0, 180, 0),
	NumShots = 6,
	UpGrades = {
		Power = {{Price = 300, Level = 14},
				{Price = 1500, Level = 16},
				{Price = 2500, Level = 18},
				{Price = 4500, Level = 20},
				{Price = 10500, Level = 22},
				{Price = 15500, Level = 24},
				{Price = 20500, Level = 26},
				{Price = 25000, Level = 28},
				{Price = 30000, Level = 30},
				{Price = 55000, Level = 32},},
		Accuracy = {{Price = 600, Level = 0.22},},
		ClipSize = {{Price = 100, Level = 12},
				{Price = 1300, Level = 13},
				{Price = 2000, Level = 14},},
		FiringSpeed = {{Price = 400, Level = .6},
				{Price = 1400, Level = 0.5},
				{Price = 2200, Level = 0.4},},
		ReloadSpeed = {{Price = 400, Level = 1.0},
				{Price = 400, Level = .9},
				{Price = 400, Level = .8},
				{Price = 800, Level = .7},
				{Price = 1200, Level = .6},},
	},
}

----------- Snipers

GM.Weapons["item_awp"] = {
	Weapon = "weapon_awp_re",
	Item = "item_awp",
	AmmoTypes = {{item = "item_ammo_sniper",Icon = "gui/ammo/sniper"}},
	Position = Vector(-3, 0, 3.5),
	Angle = Angle(0, 180, 0),
	Recoil = .6,
	IMultiplier = 0.004,
	UpGrades = {
		Power = {{Price = 100, Level = 100},
				{Price = 1500, Level = 125},
				{Price = 2500, Level = 135},
				{Price = 6000, Level = 145},
				{Price = 12000, Level = 155},
				{Price = 18000, Level = 165},
				{Price = 24000, Level = 175},
				{Price = 30000, Level = 185},
				{Price = 50000, Level = 200},
				{Price = 70000, Level = 230},
				{Price = 100000, Level = 300},},
		Accuracy = {{Price = 100, Level = 0.001},},
		ClipSize = {{Price = 100, Level = 6},
				{Price = 1300, Level = 7},
				{Price = 2000, Level = 8},
				{Price = 2600, Level = 9},},
		FiringSpeed = {{Price = 100, Level = 1.0},
				{Price = 1400, Level = 0.9},
				{Price = 2000, Level = 0.8},
				{Price = 3000, Level = 0.7},},
		ReloadSpeed = {{Price = 400, Level = 2.3},
				{Price = 1000, Level = 2.2},
				{Price = 2000, Level = 2.1}},
	},
}

GM.Weapons["item_scout"] = {
	Weapon = "weapon_scout_re",
	Item = "item_scout",
	AmmoTypes = {{item = "item_ammo_sniper",Icon = "gui/ammo/sniper"}},
	Position = Vector(-3, 0, 3.5),
	Angle = Angle(0, 180, 0),
	Recoil = .4,
	IMultiplier = 0.008,
	UpGrades = {
		Power = {{Price = 100, Level = 85},
				{Price = 1500, Level = 95},
				{Price = 2500, Level = 105},
				{Price = 6000, Level = 115},
				{Price = 12000, Level = 125},
				{Price = 18000, Level = 135},
				{Price = 24000, Level = 145},
				{Price = 30000, Level = 155},
				{Price = 50000, Level = 175},
				{Price = 70000, Level = 195},
				{Price = 100000, Level = 240},},
		Accuracy = {{Price = 100, Level = 0.002},},
		ClipSize = {{Price = 100, Level = 11},
				{Price = 1300, Level = 12},
				{Price = 2000, Level = 13},
				{Price = 2600, Level = 14},
				{Price = 3600, Level = 15},},
		FiringSpeed = {{Price = 100, Level = .8},
				{Price = 1400, Level = 0.7},
				{Price = 2000, Level = 0.6},
				{Price = 3000, Level = 0.5},
				{Price = 3000, Level = 0.4},},
		ReloadSpeed = {{Price = 400, Level = 2.2},
				{Price = 1000, Level = 2.1},
				{Price = 2000, Level = 2.0},
				{Price = 3000, Level = 1.9},},
	},
}

----------- Power Weapons

GM.Weapons["item_m79"] = {
	Weapon = "weapon_m79_re",
	Item = "item_m79",
	AmmoTypes = {{item = "item_ammo_gl_explosive",Icon = "gui/ammo/explosive"},{item = "item_ammo_gl_flame",Icon = "gui/ammo/flame"},{item = "item_ammo_gl_freeze",Icon = "gui/ammo/ice"},},
	Position = Vector(-3, 0, 3.5),
	Angle = Angle(0, 180, 0),
	UpGrades = {
		Power = {{Price = 0, Level = 75},},
		Accuracy = {{Price = 0, Level = 0.10},},
		ClipSize = {{Price = 0, Level = 1},},
		FiringSpeed = {{Price = 0, Level = 1},},
		ReloadSpeed = {{Price = 400, Level = 1.5},},
	},
	Size = 2,
}

GM.Weapons["item_quadrpg"] = {
	Weapon = "weapon_Quad_re",
	Item = "item_quadrpg",
	AmmoTypes = {{item = "item_ammo_rocket",Icon ="gui/ammo/rocket"}},
	UpGrades = {
		Power = {{Price = 5, Level = 100000},},
		Accuracy = {{Price = 5, Level = 0.10},},
		ClipSize = {{Price = 5, Level = 4 },},
		FiringSpeed = {{Price = 0, Level = 1},},
		ReloadSpeed = {{Price = 400, Level = 1.5},},
	},
	Size = 2,
}
GM.Weapons["item_minigun"] = {
	Weapon = "weapon_minigun_re",
	Item = "item_minigun",
	AmmoTypes = {{item = "item_bandolier",Icon = "gui/ammo/minigun"}},
	UpGrades = {
		Power = {{Price = 0, Level = 50},
				{Price = 3500, Level = 55},
				{Price = 5500, Level = 60},
				{Price = 7000, Level = 65},
				{Price = 14000, Level = 70},
				{Price = 21000, Level = 75},
				{Price = 28000, Level = 80},
				{Price = 35000, Level = 85},},
		Accuracy = {{Price = 0, Level = 0.10},
				{Price = 2500, Level = 0.09},
				{Price = 3000, Level = 0.08},
				{Price = 4000, Level = 0.07},},
		ClipSize = {{Price = 0, Level = 200},},
		FiringSpeed = {{Price = 0, Level = 0.1},
				{Price = 1400, Level = 0.09},
				{Price = 2200, Level = 0.08},
				{Price = 10200, Level = 0.07},},
		ReloadSpeed = {{Price = 400, Level = 5},},
	},
	Size = 1,
}

GM.Weapons["item_physcannon"] = {
	Weapon = "weapon_physcannon",
	Item = "item_physcannon",
	AmmoTypes = {{item = nil,Icon = nil}},
	UpGrades = {
		Power = {{Price = 5, Level = 100},},
		Accuracy = {{Price = 5, Level = 0.10},},
		ClipSize = {{Price = 5, Level = 4 },},
		FiringSpeed = {{Price = 0, Level = 1},},
		ReloadSpeed = {{Price = 400, Level = 1.5},},
	},
	Size = 0,
}


--- Passive Weapons ( Makes it storable)

GM.Weapons["item_bandolier"] = {
	Weapon = nil,
	Item = "item_bandolier",
	AmmoTypes = {{item = nil,Icon = nil}},
	UpGrades = {
		Power = {{Price = 0, Level = 0},},
		Accuracy = {{Price = 0, Level = 0.10},},
		ClipSize = {{Price = 0, Level = 400},},
		FiringSpeed = {{Price = 0, Level = 0.1},},
		ReloadSpeed = {{Price = 400, Level = 5},},
	},
}


-----------------DLC----------------------------

GM.Weapons["item_an94"] = {
	Weapon = "weapon_an94_re",
	Item = "item_an94",
	AmmoTypes = {{item = "item_ammo_rifle",Icon = "gui/ammo/rifle"}},
	Position = Vector(-3, 0, 3.5),
	Angle = Angle(0, 180, 0),
	Recoil = 0.75,
	IMultiplier = 0.6,
	UpGrades = {
		Power = {{Price = 20000, Level = 40},
				{Price = 40000, Level = 50},
				{Price = 60000, Level = 60},
				{Price = 80000, Level = 70},
				{Price = 100000, Level = 80},},
		Accuracy = {{Price = 10000, Level = 0.09},
				{Price = 15000, Level = 0.08},
				{Price = 30000, Level = 0.06},
				{Price = 40000, Level = 0.05},},
		ClipSize = {{Price = 7000, Level = 45},
				{Price = 13000, Level = 50},
				{Price = 20000, Level = 55},
				{Price = 26000, Level = 60}},
		FiringSpeed = {{Price = 7000, Level = 0.2},
				{Price = 14000, Level = 0.16},
				{Price = 22000, Level = 0.13},
				{Price = 31000, Level = 0.1}},
		ReloadSpeed = {{Price = 4000, Level = 4.0},
				{Price = 4000, Level = 3.9},
				{Price = 8000, Level = 3.5},},
	},
}

GM.Weapons["item_ballista"] = {
	Weapon = "weapon_ballista_re",
	Item = "item_ballista",
	AmmoTypes = {{item = "item_ammo_sniper",Icon = "gui/ammo/sniper"}},
	Position = Vector(-3, 0, 3.5),
	Angle = Angle(0, 180, 0),
	Recoil = .6,
	IMultiplier = 0.004,
	UpGrades = {
		Power = {{Price = 20000, Level = 130},
				{Price = 40000, Level = 150},
				{Price = 60000, Level = 180},},
		Accuracy = {{Price = 100, Level = 0.001},},
		ClipSize = {{Price = 100, Level = 6},
				{Price = 10300, Level = 7},
				{Price = 20000, Level = 8},
				{Price = 20600, Level = 9},},
		FiringSpeed = {{Price = 1000, Level = 1.0},
				{Price = 10400, Level = 0.9},
				{Price = 20000, Level = 0.8},
				{Price = 30000, Level = 0.7},},
		ReloadSpeed = {{Price = 4000, Level = 2.3},
				{Price = 10000, Level = 2.2},
				{Price = 20000, Level = 2.1}},
	},
}

GM.Weapons["item_dsr50"] = {
	Weapon = "weapon_dsr50_re",
	Item = "item_dsr50",
	AmmoTypes = {{item = "item_ammo_sniper",Icon = "gui/ammo/sniper"}},
	Position = Vector(-3, 0, 3.5),
	Angle = Angle(0, 180, 0),
	Recoil = .6,
	IMultiplier = 0.004,
	UpGrades = {
		Power = {{Price = 60000, Level = 250},
				{Price = 95000, Level = 350},
				{Price = 200500, Level = 400},
				{Price = 300500, Level = 500},
				{Price = 500500, Level = 600},},
		Accuracy = {{Price = 100, Level = 0.001},},
		ClipSize = {{Price = 100, Level = 6},
				{Price = 10300, Level = 7},
				{Price = 20000, Level = 8},
				{Price = 20600, Level = 9},},
		FiringSpeed = {{Price = 100, Level = 1.0},
				{Price = 10400, Level = 0.9},
				{Price = 20000, Level = 0.8},
				{Price = 30000, Level = 0.7},},
		ReloadSpeed = {{Price = 4000, Level = 2.3},
				{Price = 10000, Level = 2.2},
				{Price = 20000, Level = 2.1}},
	},
}

GM.Weapons["item_executioner"] = {
	Weapon = "weapon_executioner_re",
	Item = "item_executioner",
	AmmoTypes = {{item = "item_ammo_pistol",Icon = "gui/ammo/handgun"}},
	Position = Vector(-3, 0, 3.5),
	Angle = Angle(0, 180, 0),
	Recoil = 0.75,
	IMultiplier = 1.1,
	UpGrades = {
		Power = {{Price = 100, Level = 5},
				{Price = 1500, Level = 6},
				{Price = 2500, Level = 7},
				{Price = 4000, Level = 8},
				{Price = 8000, Level = 9},
				{Price = 12000, Level = 10},
				{Price = 12000, Level = 11},
				{Price = 12000, Level = 12},
				{Price = 36000, Level = 16},},
		Accuracy = {{Price = 100, Level = 0.07},
				{Price = 1500, Level = 0.06},
				{Price = 3000, Level = 0.05},
				{Price = 3000, Level = 0.04},},
		ClipSize = {{Price = 100, Level = 5},
				{Price = 1300, Level = 6},
				{Price = 2000, Level = 7},
				{Price = 2600, Level = 8},
				{Price = 4600, Level = 9},
				{Price = 4600, Level = 10},},
		FiringSpeed = {{Price = 100, Level = 0.16},
				{Price = 1400, Level = 0.14},
				{Price = 2200, Level = 0.12},
				{Price = 2200, Level = 0.10},},
		ReloadSpeed = {{Price = 400, Level = 1.5},
				{Price = 1000, Level = 1.1},
				{Price = 1000, Level = 0.8},},
	},
}

GM.Weapons["item_kap40"] = {
	Weapon = "weapon_kap40_re",
	Item = "item_kap40",
	AmmoTypes = {{item = "item_ammo_pistol",Icon = "gui/ammo/handgun"}},
	Position = Vector(-3, 0, 3.5),
	Angle = Angle(0, 180, 0),
	Recoil = 0.75,
	IMultiplier = 1.1,
	UpGrades = {
		Power = {{Price = 100, Level = 17},
				{Price = 1500, Level = 19},
				{Price = 2500, Level = 21},
				{Price = 4000, Level = 23},
				{Price = 8000, Level = 25},
				{Price = 12000, Level = 27},
				{Price = 12000, Level = 29},
				{Price = 12000, Level = 31},
				{Price = 35000, Level = 40},},
		Accuracy = {{Price = 100, Level = 0.07},
				{Price = 1500, Level = 0.06},
				{Price = 3000, Level = 0.05},
				{Price = 3000, Level = 0.04},},
		ClipSize = {{Price = 100, Level = 15},
				{Price = 1300, Level = 18},
				{Price = 2000, Level = 21},
				{Price = 2600, Level = 24},
				{Price = 4600, Level = 27},
				{Price = 4600, Level = 30},},
		FiringSpeed = {{Price = 100, Level = .18},
				{Price = 1400, Level = 0.16},
				{Price = 2200, Level = 0.14},
				{Price = 2200, Level = 0.10},},
		ReloadSpeed = {{Price = 400, Level = 2.5},
				{Price = 1000, Level = 2.3},
				{Price = 1000, Level = 2.2},},
	},
}

GM.Weapons["item_peace"] = {
	Weapon = "weapon_peacekeeper_re",
	Item = "item_peace",
	AmmoTypes = {{item = "item_ammo_smg",Icon = "gui/ammo/machinegun"}},
	Position = Vector(-3, 0, 3.5),
	Angle = Angle(0, 180, 0),
	Recoil = 0.75,
	IMultiplier = 0.75,
	UpGrades = {
		Power = {{Price = 3000, Level = 53},
				{Price = 10500, Level = 56},
				{Price = 20500, Level = 59},
				{Price = 40000, Level = 62},
				{Price = 60000, Level = 65},
				{Price = 60000, Level = 67},
				{Price = 60000, Level = 70},
				{Price = 100000, Level = 105},},
		Accuracy = {{Price = 600, Level = 0.08},
				{Price = 1500, Level = 0.07},
				{Price = 3000, Level = 0.06},
				{Price = 3000, Level = 0.05},},
		ClipSize = {{Price = 100, Level = 30},
				{Price = 1300, Level = 35},
				{Price = 2000, Level = 40},
				{Price = 2600, Level = 45}},
		FiringSpeed = {{Price = 400, Level = 0.15},
				{Price = 1400, Level = 0.12},
				{Price = 2200, Level = 0.1},
				{Price = 3100, Level = 0.09}},
		ReloadSpeed = {{Price = 400, Level = 3.8},
				{Price = 400, Level = 3.6},},
	},
}

GM.Weapons["item_pdw"] = {
	Weapon = "weapon_pdw_re",
	Item = "item_pdw",
	AmmoTypes = {{item = "item_ammo_smg",Icon = "gui/ammo/machinegun"}},
	Position = Vector(-3, 0, 3.5),
	Angle = Angle(0, 180, 0),
	Recoil = 0.75,
	IMultiplier = 0.75,
	UpGrades = {
		Power = {{Price = 5000, Level = 25},
				{Price = 5000, Level = 27},
				{Price = 5000, Level = 29},
				{Price = 5000, Level = 32},
				{Price = 5000, Level = 34},
				{Price = 5000, Level = 35},
				{Price = 5000, Level = 38},
				{Price = 5000, Level = 41},
				{Price = 5000, Level = 43},},
		Accuracy = {{Price = 100, Level = .05},},
		ClipSize = {{Price = 100, Level = 50},},
		FiringSpeed = {{Price = 100, Level = 0.1},},
		ReloadSpeed = {{Price = 400, Level = 2},},
	},
}
