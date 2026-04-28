return {
	Ship_Crew_Requirement = 10,
	Fighters = {
		["GENERIC_Z95_HEADHUNTER_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 2}
		},
		["VULTURE_BROWN_SQUADRON_DOUBLE"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 3},
			COMMERCE_GUILD = {Initial = 1, Reserve = 3},
			HOSTILE = {Initial = 1, Reserve = 3},
			REBEL = {Initial = 1, Reserve = 3, TechLevel = EqualTo(1)},
			SECTOR_FORCES = {Initial = 1, Reserve = 3},
			TECHNO_UNION = {Initial = 1, Reserve = 3},
			TRADE_FEDERATION = {Initial = 1, Reserve = 3},
			WARLORDS = {Initial = 1, Reserve = 3}
		},
		["VULTURE_SQUADRON_DOUBLE"] = {
			REBEL = {Initial = 1, Reserve = 3, TechLevel = GreaterOrEqualTo(2)}
		},
		["CLOAKSHAPE_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 2}
		},
		["NANTEX_SQUADRON"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 2},
			COMMERCE_GUILD = {Initial = 1, Reserve = 2}
		},
		["SCARAB_SQUADRON"] = {
			HOSTILE = {Initial = 1, Reserve = 2},
			REBEL = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(2)},
			SECTOR_FORCES = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(2)},
			TECHNO_UNION = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(2)},
			TRADE_FEDERATION = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(2)}
		},
		["TRIFIGHTER_SQUADRON"] = {
			REBEL = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(2)},
			SECTOR_FORCES = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(2)},
			TECHNO_UNION = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(2)},
			TRADE_FEDERATION = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(2)}
		},
		["2_WARPOD_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 1, Reserve = 2}
		},
		["ADVANCED_ESTAP_BROWN_SQUADRON_DOUBLE"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 3},
			COMMERCE_GUILD = {Initial = 1, Reserve = 3},
			HOSTILE = {Initial = 1, Reserve = 3},
			REBEL = {Initial = 1, Reserve = 3, TechLevel = EqualTo(1)},
			SECTOR_FORCES = {Initial = 1, Reserve = 3},
			TECHNO_UNION = {Initial = 1, Reserve = 3},
			TRADE_FEDERATION = {Initial = 1, Reserve = 3},
			WARLORDS = {Initial = 1, Reserve = 3}
		},
		["ADVANCED_ESTAP_SQUADRON_DOUBLE"] = {
			REBEL = {Initial = 1, Reserve = 3, TechLevel = GreaterOrEqualTo(2)}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}