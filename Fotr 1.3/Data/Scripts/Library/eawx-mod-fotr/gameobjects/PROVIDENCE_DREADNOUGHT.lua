return {
	Ship_Crew_Requirement = 30,
	Fighters = {
		["VULTURE_BROWN_SQUADRON_DOUBLE"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 6},
			COMMERCE_GUILD = {Initial = 1, Reserve = 6},
			EMPIRE = {Initial = 1, Reserve = 6},
			HOSTILE = {Initial = 1, Reserve = 6},
			REBEL = {Initial = 1, Reserve = 6, TechLevel = EqualTo(1)},
			SECTOR_FORCES = {Initial = 1, Reserve = 6},
			TECHNO_UNION = {Initial = 1, Reserve = 6},
			TRADE_FEDERATION = {Initial = 1, Reserve = 6},
			WARLORDS = {Initial = 1, Reserve = 6}
		},
		["VULTURE_SQUADRON_DOUBLE"] = {
			REBEL = {Initial = 1, Reserve = 6, TechLevel = GreaterOrEqualTo(2)}
		},
		["NANTEX_SQUADRON_DOUBLE"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 2},
			COMMERCE_GUILD = {Initial = 1, Reserve = 2}
		},
		["SCARAB_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(2)},
			HOSTILE = {Initial = 1, Reserve = 2},
			REBEL = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(2)},
			SECTOR_FORCES = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(2)},
			TECHNO_UNION = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(2)},
			TRADE_FEDERATION = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(2)},
			WARLORDS = {Initial = 1, Reserve = 2}
		},
		["TRIFIGHTER_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(2)},
			REBEL = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(2)},
			SECTOR_FORCES = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(2)},
			TECHNO_UNION = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(2)},
			TRADE_FEDERATION = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(2)}
		},
		["HYENA_SQUADRON_DOUBLE"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 6},
			COMMERCE_GUILD = {Initial = 1, Reserve = 6},
			EMPIRE = {Initial = 1, Reserve = 6},
			HOSTILE = {Initial = 1, Reserve = 6},
			REBEL = {Initial = 1, Reserve = 6},
			SECTOR_FORCES = {Initial = 1, Reserve = 6},
			TECHNO_UNION = {Initial = 1, Reserve = 6},
			TRADE_FEDERATION = {Initial = 1, Reserve = 6},
			WARLORDS = {Initial = 1, Reserve = 6}
		},
		["ADVANCED_ESTAP_BROWN_SQUADRON_DOUBLE"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(1)},
			COMMERCE_GUILD = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(1)},
			EMPIRE = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(1)},
			HOSTILE = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(1)},
			REBEL = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(1)},
			SECTOR_FORCES = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(1)},
			TECHNO_UNION = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(1)},
			TRADE_FEDERATION = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(1)},
			WARLORDS = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(1)}
		},
		["BELBULLAB24_SQUADRON_DOUBLE"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 2, TechLevel = GreaterOrEqualTo(2)},
			COMMERCE_GUILD = {Initial = 1, Reserve = 2, TechLevel = GreaterOrEqualTo(2)},
			EMPIRE = {Initial = 1, Reserve = 2, TechLevel = GreaterOrEqualTo(2)},
			HOSTILE = {Initial = 1, Reserve = 2, TechLevel = GreaterOrEqualTo(2)},
			REBEL = {Initial = 1, Reserve = 2, TechLevel = GreaterOrEqualTo(2)},
			SECTOR_FORCES = {Initial = 1, Reserve = 2, TechLevel = GreaterOrEqualTo(2)},
			TECHNO_UNION = {Initial = 1, Reserve = 2, TechLevel = GreaterOrEqualTo(2)},
			TRADE_FEDERATION = {Initial = 1, Reserve = 2, TechLevel = GreaterOrEqualTo(2)},
			WARLORDS = {Initial = 1, Reserve = 2, TechLevel = GreaterOrEqualTo(2)}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}