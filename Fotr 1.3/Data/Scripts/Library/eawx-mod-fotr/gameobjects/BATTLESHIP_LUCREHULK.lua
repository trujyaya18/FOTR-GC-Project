return {
	Ship_Crew_Requirement = 50,
	Fighters = {
		["VULTURE_BROWN_SQUADRON_DOUBLE"] = {
			BANKING_CLAN = {Initial = 2, Reserve = 6},
			COMMERCE_GUILD = {Initial = 2, Reserve = 6},
			EMPIRE = {Initial = 2, Reserve = 6},
			HOSTILE = {Initial = 2, Reserve = 6},
			REBEL = {Initial = 2, Reserve = 6, TechLevel = EqualTo(1)},
			SECTOR_FORCES = {Initial = 2, Reserve = 6},
			TECHNO_UNION = {Initial = 2, Reserve = 6},
			TRADE_FEDERATION = {Initial = 2, Reserve = 6},
			WARLORDS = {Initial = 2, Reserve = 6}
		},
		["VULTURE_SQUADRON_DOUBLE"] = {
			REBEL = {Initial = 2, Reserve = 6, TechLevel = GreaterOrEqualTo(2)}
		},
		["EARLY_SKIPRAY_SQUADRON"] = {
			WARLORDS = {Initial = 1, Reserve = 4}
		},
		["NANTEX_SQUADRON"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 4},
			COMMERCE_GUILD = {Initial = 1, Reserve = 4}
		},
		["SCARAB_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(2)},
			HOSTILE = {Initial = 1, Reserve = 4},
			REBEL = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(2)},
			SECTOR_FORCES = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(2)},
			TECHNO_UNION = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(2)},
			TRADE_FEDERATION = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(2)}
		},
		["TRIFIGHTER_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = GreaterThan(2)},
			REBEL = {Initial = 1, Reserve = 4, TechLevel = GreaterThan(2)},
			SECTOR_FORCES = {Initial = 1, Reserve = 4, TechLevel = GreaterThan(2)},
			TECHNO_UNION = {Initial = 1, Reserve = 4, TechLevel = GreaterThan(2)},
			TRADE_FEDERATION = {Initial = 1, Reserve = 4, TechLevel = GreaterThan(2)}
		},
		["HYENA_SQUADRON_DOUBLE"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 4},
			COMMERCE_GUILD = {Initial = 1, Reserve = 4},
			EMPIRE = {Initial = 1, Reserve = 4},
			HOSTILE = {Initial = 1, Reserve = 4},
			REBEL = {Initial = 1, Reserve = 4},
			SECTOR_FORCES = {Initial = 1, Reserve = 4},
			TECHNO_UNION = {Initial = 1, Reserve = 4},
			TRADE_FEDERATION = {Initial = 1, Reserve = 4},
			WARLORDS = {Initial = 1, Reserve = 4}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}