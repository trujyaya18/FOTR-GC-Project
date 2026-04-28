return {
	Ship_Crew_Requirement = 50,
	Fighters = {
		["GENERIC_Z95_HEADHUNTER_SQUADRON_DOUBLE"] = {
			WARLORDS = {Initial = 1, Reserve = 4}
		},
		["VULTURE_BROWN_SQUADRON_DOUBLE"] = {
			BANKING_CLAN = {Initial = 6, Reserve = 24},
			COMMERCE_GUILD = {Initial = 6, Reserve = 24},
			EMPIRE = {Initial = 6, Reserve = 24},
			HOSTILE = {Initial = 6, Reserve = 24},
			REBEL = {Initial = 6, Reserve = 24, TechLevel = EqualTo(1)},
			SECTOR_FORCES = {Initial = 6, Reserve = 24},
			TECHNO_UNION = {Initial = 6, Reserve = 24},
			TRADE_FEDERATION = {Initial = 6, Reserve = 24},
			WARLORDS = {Initial = 6, Reserve = 24}
		},
		["VULTURE_SQUADRON_DOUBLE"] = {
			REBEL = {Initial = 6, Reserve = 24, TechLevel = GreaterOrEqualTo(2)}
		},
		["EARLY_SKIPRAY_SQUADRON_DOUBLE"] = {
			WARLORDS = {Initial = 1, Reserve = 4}
		},
		["NANTEX_SQUADRON_DOUBLE"] = {
			BANKING_CLAN = {Initial = 2, Reserve = 8},
			COMMERCE_GUILD = {Initial = 2, Reserve = 8}
		},
		["SCARAB_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 2, Reserve = 8, TechLevel = LessOrEqualTo(2)},
			HOSTILE = {Initial = 2, Reserve = 8},
			REBEL = {Initial = 2, Reserve = 8, TechLevel = LessOrEqualTo(2)},
			SECTOR_FORCES = {Initial = 2, Reserve = 8, TechLevel = LessOrEqualTo(2)},
			TECHNO_UNION = {Initial = 2, Reserve = 8, TechLevel = LessOrEqualTo(2)},
			TRADE_FEDERATION = {Initial = 2, Reserve = 8, TechLevel = LessOrEqualTo(2)}
		},
		["TRIFIGHTER_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 2, Reserve = 8, TechLevel = GreaterThan(2)},
			REBEL = {Initial = 2, Reserve = 8, TechLevel = GreaterThan(2)},
			SECTOR_FORCES = {Initial = 2, Reserve = 8, TechLevel = GreaterThan(2)},
			TECHNO_UNION = {Initial = 2, Reserve = 8, TechLevel = GreaterThan(2)},
			TRADE_FEDERATION = {Initial = 2, Reserve = 8, TechLevel = GreaterThan(2)}
		},
		["HYENA_SQUADRON_DOUBLE"] = {
			BANKING_CLAN = {Initial = 2, Reserve = 8},
			COMMERCE_GUILD = {Initial = 2, Reserve = 8},
			EMPIRE = {Initial = 2, Reserve = 8},
			HOSTILE = {Initial = 2, Reserve = 8},
			REBEL = {Initial = 2, Reserve = 8},
			SECTOR_FORCES = {Initial = 2, Reserve = 8},
			TECHNO_UNION = {Initial = 2, Reserve = 8},
			TRADE_FEDERATION = {Initial = 2, Reserve = 8},
			WARLORDS = {Initial = 2, Reserve = 8}
		},
		["ADVANCED_ESTAP_BROWN_SQUADRON_DOUBLE"] = {
			BANKING_CLAN = {Initial = 2, Reserve = 8},
			COMMERCE_GUILD = {Initial = 2, Reserve = 8},
			EMPIRE = {Initial = 2, Reserve = 8},
			HOSTILE = {Initial = 2, Reserve = 8},
			REBEL = {Initial = 2, Reserve = 8, TechLevel = EqualTo(1)},
			SECTOR_FORCES = {Initial = 2, Reserve = 8},
			TECHNO_UNION = {Initial = 2, Reserve = 8},
			TRADE_FEDERATION = {Initial = 2, Reserve = 8},
			WARLORDS = {Initial = 2, Reserve = 8}
		},
		["ADVANCED_ESTAP_SQUADRON_DOUBLE"] = {
			REBEL = {Initial = 2, Reserve = 8, TechLevel = GreaterOrEqualTo(2)}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}