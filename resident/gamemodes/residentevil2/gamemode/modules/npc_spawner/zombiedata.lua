GM.ZombieData = {}


--[[GM.ZombieData["Easy"] = {
	ItemChance = {1,2,3,4,5,6,7,8,9,10},  Levels
	ZombieHealth = {1,2,3,4,5,6,7,8,9,10}, Levels
	ZombieMaxHealth = {1,2,3,4,5,6,7,8,9,10}, Levels
	ZombieAttackSpeed = {1,2,3,4,5,6,7,8,9,10}, Levels
}]]--

--[[	ItemChance = {32,34,36,38,40,50,60,75,80,90},
	ZombieHealth = {55,65,80,90,110,140,150,160,180,230},
	ZombieMaxHealth = {70,80,90,105,120,150,160,170,200,250},
	ZombieAttackSpeed = {2.5,2.5,2.5,2.5,3,3,3,4,5,5},
	ZombieMaxSpeed = 500,
	ZombieMinSpeed = 100,
	ZombieSpawnRate = {5,5,4,4,4,3,3,3,2,2},]]--
GM.ZombieData["Easy"] = {
	ItemChance = {36,40,48,65,80,100,110,125,140,150},
	ZombieHealth = {25,35,50,60,80,100,110,120,140,175},
	ZombieMaxHealth = {100,175,190,205,220,250,260,270,300,400},
	ZombieAttackSpeed = {2.5,2.5,2.5,2.5,3,3,3,4,5,5},
	ZombieMaxSpeed = 1,
	ZombieMinSpeed = 1,
	ZombieSpawnRate = {5,5,4,4,4,3,3,3,2,2},
	Modifier = 1, --- used for rewards and stuff.
	StartTime = 120,
}
GM.ZombieData["Normal"] = {
	ItemChance = {43,45,53,69,84,109,123,133,145,190},
	ZombieHealth = {65,75,85,95,120,150,160,170,190,240},
	ZombieMaxHealth = {200,285,295,310,335,365,380,390,410,500},
	ZombieAttackSpeed = {2.5,2.6,2.7,2.8,3,3.3,3.6,4.8,5.7},
	ZombieMaxSpeed = 2, -- these are divided by 100, making it 1.00. I use this for random speeds, It doesnt actually work, so don't worry about it
	ZombieMinSpeed = 1,
	ZombieSpawnRate = {5,4,4,4,3,3,2,2,2,1},
	Modifier = 2,
	StartTime = 90,
}
GM.ZombieData["Difficult"] = {
	ItemChance = {50,60,70,80,90,105,120,135,180,210},
	ZombieHealth = {85,95,115,125,140,155,175,190,215,270},
	ZombieMaxHealth = {300,305,315,330,350,365,390,410,430,600},
	ZombieAttackSpeed = {2.8,2.9,3,3.2,3.5,3.8,4.3,4.7,5.6},
	ZombieMaxSpeed = 2, --- the lower this is the faster they can be. It doesnt actually work, so don't worry about it
	ZombieMinSpeed = 1,
	ZombieSpawnRate = {4,4,4,3,3,3,2,2,1,1},
	Modifier = 3,
	StartTime = 60,
}
GM.ZombieData["Expert"] = {
	ItemChance = {50,63,76,90,140,160,170,210,280},
	ZombieHealth = {95,115,140,155,175,190,215,270,300,330},
	ZombieMaxHealth = {400,415,425,450,460,475,500,530,560,700},
	ZombieAttackSpeed = {3,3.4,3.7,4,4.5,4.8,5,5.4,6},
	ZombieMaxSpeed = 3,
	ZombieMinSpeed = 2,
	ZombieSpawnRate = {4,4,3,3,3,2,2,1,1,1},
	Modifier = 4,
	StartTime = 45,
}
GM.ZombieData["Suicidal"] = {
	ItemChance = {50,60,70,80,90,105,120,135,180,300},
	ZombieHealth = {300,310,320,330,340,350,360,370,380,390},
	ZombieMaxHealth = {500,540,565,590,610,635,650,670,710,800},
	ZombieAttackSpeed = {4,4.4,2,4.4,4.5,4.8,5,5.3,5.7,6,7},
	ZombieMaxSpeed = 4,
	ZombieMinSpeed = 3,
	ZombieSpawnRate = {3,3,2,2,1,1,1,1,1,1},
	Modifier = 5,
	StartTime = 30,
}
GM.ZombieData["Death"] = {
	ItemChance = {70,90,110,130,150,180,200,235,280,360},
	ZombieHealth = {330,340,350,360,370,380,390,400,410,420},
	ZombieMaxHealth = {600,670,690,730,760,790,820,850,880,900},
	ZombieAttackSpeed = {4,4.4,2,4.4,4.5,4.8,5,5.3,5.7,6,7},
	ZombieMaxSpeed = 5,
	ZombieMinSpeed = 4,
	ZombieSpawnRate = {1,1,1,1,1,1,1,1,1,1},
	Modifier = 6,
	StartTime = 10,
}
GM.ZombieData["RacoonCity"] = {
	ItemChance = {200,220,250,270,300,350,435,460,480,560},
	ZombieHealth = {430,440,450,460,470,480,590,600,610,620},
	ZombieMaxHealth = {700,770,790,830,860,890,920,950,980,1000},
	ZombieAttackSpeed = {4,4.4,2,4.4,4.5,4.8,5,5.3,5.7,6,7},
	ZombieMaxSpeed = 7,
	ZombieMinSpeed = 6,
	ZombieSpawnRate = {0.8,0.8,0.8,0.8,0.8,0.8,0.8,0.8,0.8,0.8},
	Modifier = 7,
	StartTime = 7,
}