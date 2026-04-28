return {
	Ship_Crew_Requirement = 10,
	Fighters = {
		["CLOAKSHAPE_STOCK_SQUADRON"] = {
			CIS = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(3)},
			EMPIRE = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(3)},
			HOSTILE = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(3)},
			SECTOR_FORCES = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(3)},
			WARLORDS = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(3)}
		},
		["TWIN_ION_ENGINE_STARFIGHTER_SQUADRON"] = {
			CIS = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(3)},
			EMPIRE = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(3)},
			HOSTILE = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(3)},
			SECTOR_FORCES = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(3)},
			WARLORDS = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(3)}
		}
	},
	Scripts = {"multilayer", "fighter-spawn", "single-unit-retreat"},
	Flags = {HANGAR = true}
}