return {
	Ship_Crew_Requirement = 1,
	Fighters = {
		["VULTURE_BROWN_SQUADRON_DOUBLE"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 1},
			COMMERCE_GUILD = {Initial = 1, Reserve = 1},
			EMPIRE = {Initial = 1, Reserve = 1},
			HOSTILE = {Initial = 1, Reserve = 1},
			REBEL = {Initial = 1, Reserve = 1, TechLevel = EqualTo(1)},
			SECTOR_FORCES = {Initial = 1, Reserve = 1},
			TECHNO_UNION = {Initial = 1, Reserve = 1},
			TRADE_FEDERATION = {Initial = 1, Reserve = 1},
			WARLORDS = {Initial = 1, Reserve = 1}
		},
		["VULTURE_SQUADRON_DOUBLE"] = {
			REBEL = {Initial = 1, Reserve = 1, TechLevel = GreaterOrEqualTo(2)}
		},
		["HYENA_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		}
	},
	Scripts = {"multilayer", "fighter-spawn", "single-unit-retreat"},
	Flags = {HANGAR = true}
}