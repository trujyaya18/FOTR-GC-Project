return {
	Ship_Crew_Requirement = 35,
	Fighters = {
		["BELBULLAB22_SQUADRON"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 1},
			COMMERCE_GUILD = {Initial = 1, Reserve = 1},
			EMPIRE = {Initial = 1, Reserve = 1},
			HOSTILE = {Initial = 1, Reserve = 1},
			REBEL = {Initial = 1, Reserve = 1},
			SECTOR_FORCES = {Initial = 1, Reserve = 1},
			TECHNO_UNION = {Initial = 1, Reserve = 1},
			TRADE_FEDERATION = {Initial = 1, Reserve = 1},
			WARLORDS = {Initial = 1, Reserve = 1}
		},
		["NANTEX_SQUADRON"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 2},
			COMMERCE_GUILD = {Initial = 1, Reserve = 2},
			EMPIRE = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(3)},
			HOSTILE = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(3)},
			REBEL = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(3)},
			SECTOR_FORCES = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(3)},
			TECHNO_UNION = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(3)},
			TRADE_FEDERATION = {Initial = 1, Reserve = 2},
			WARLORDS = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(3)}
		},
		["MANKVIM_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(3)},
			HOSTILE = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(3)},
			REBEL = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(3)},
			SECTOR_FORCES = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(3)},
			TECHNO_UNION = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(3)},
			WARLORDS = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(3)}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}