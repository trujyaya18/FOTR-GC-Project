return {
	Ship_Crew_Requirement = 10,
	Fighters = {
		["BELBULLAB22_SQUADRON"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 2},
			COMMERCE_GUILD = {Initial = 1, Reserve = 2},
			EMPIRE = {Initial = 1, Reserve = 2},
			HOSTILE = {Initial = 1, Reserve = 2},
			REBEL = {Initial = 1, Reserve = 2},
			SECTOR_FORCES = {Initial = 1, Reserve = 2},
			TECHNO_UNION = {Initial = 1, Reserve = 2},
			TRADE_FEDERATION = {Initial = 1, Reserve = 2},
			WARLORDS = {Initial = 1, Reserve = 2}
		},
		["NANTEX_SQUADRON"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 0},
			COMMERCE_GUILD = {Initial = 1, Reserve = 0},
			EMPIRE = {Initial = 1, Reserve = 0, TechLevel = LessOrEqualTo(3)},
			HOSTILE = {Initial = 1, Reserve = 0, TechLevel = LessOrEqualTo(3)},
			REBEL = {Initial = 1, Reserve = 0, TechLevel = LessOrEqualTo(3)},
			SECTOR_FORCES = {Initial = 1, Reserve = 0, TechLevel = LessOrEqualTo(3)},
			TECHNO_UNION = {Initial = 1, Reserve = 0, TechLevel = LessOrEqualTo(3)},
			TRADE_FEDERATION = {Initial = 1, Reserve = 0},
			WARLORDS = {Initial = 1, Reserve = 0, TechLevel = LessOrEqualTo(3)}
		},
		["MANKVIM_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 0, TechLevel = GreaterThan(3)},
			HOSTILE = {Initial = 1, Reserve = 0, TechLevel = GreaterThan(3)},
			REBEL = {Initial = 1, Reserve = 0, TechLevel = GreaterThan(3)},
			SECTOR_FORCES = {Initial = 1, Reserve = 0, TechLevel = GreaterThan(3)},
			TECHNO_UNION = {Initial = 1, Reserve = 0, TechLevel = GreaterThan(3)},
			WARLORDS = {Initial = 1, Reserve = 0, TechLevel = GreaterThan(3)}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}