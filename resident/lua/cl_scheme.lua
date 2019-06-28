RPG.ColorSchemes = { }

local colors = { "white", "ltred", "ltgreen", "ltblue", "yellow", "ltpurple" }

RPG.ColorSchemes.Default = {
	FormatColors = {
		"white",	//Plain text
		"ltred",	//"Does not work with all weapons"
		"ltgreen", //"+%"
		"ltblue", //Reset code
		"yellow", //level/maxlevel
		"ltpurple", //Rank
	},
	
	TextColor = Color( 255, 255, 255, 255 ),
	FillColor = Color( 000, 000, 000, 189 ),
	HighlightColor = Color( 030, 144, 200, 220 ),
	DisabledTextColor = Color( 120, 120, 120, 255 ),
}

RPG.CurrentColorScheme = RPG.ColorSchemes.Default