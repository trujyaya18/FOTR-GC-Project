return {
	Ship_Crew_Requirement = 150,
	Fighters = {
		["VULTURE_BROWN_SQUADRON_DOUBLE"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 4},
			COMMERCE_GUILD = {Initial = 1, Reserve = 4},
			EMPIRE = {Initial = 1, Reserve = 4},
			HOSTILE = {Initial = 1, Reserve = 4},
			REBEL = {Initial = 1, Reserve = 4, TechLevel = EqualTo(1)},
			SECTOR_FORCES = {Initial = 1, Reserve = 4},
			TECHNO_UNION = {Initial = 1, Reserve = 4},
			TRADE_FEDERATION = {Initial = 1, Reserve = 4},
			WARLORDS = {Initial = 1, Reserve = 4}
		},
		["VULTURE_SQUADRON_DOUBLE"] = {
			REBEL = {Initial = 1, Reserve = 4, TechLevel = GreaterOrEqualTo(2)}
		},
		["HYENA_SQUADRON_DOUBLE"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 2},
			COMMERCE_GUILD = {Initial = 1, Reserve = 2},
			EMPIRE = {Initial = 1, Reserve = 2},
			HOSTILE = {Initial = 1, Reserve = 2},
			REBEL = {Initial = 1, Reserve = 2},
			SECTOR_FORCES = {Initial = 1, Reserve = 2},
			TECHNO_UNION = {Initial = 1, Reserve = 2},
			TRADE_FEDERATION = {Initial = 1, Reserve = 2},
			WARLORDS = {Initial = 1, Reserve = 2}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}