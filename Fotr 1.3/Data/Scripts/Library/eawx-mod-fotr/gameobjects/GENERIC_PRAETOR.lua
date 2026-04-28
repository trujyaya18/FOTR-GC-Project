return {
	Ship_Crew_Requirement = 150,
	Fighters = {
		["GENERIC_Z95_HEADHUNTER_SQUADRON_DOUBLE"] = {
			CIS = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(3)},
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(3)},
			SECTOR_FORCES = {Initial = 1, Reserve = 4},
			HOSTILE = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(3)},
			WARLORDS = {Initial = 1, Reserve = 4}
		},
		["TWIN_ION_ENGINE_STARFIGHTER_SQUADRON_DOUBLE"] = {
			CIS = {Initial = 1, Reserve = 4, TechLevel = GreaterThan(3)},
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = GreaterThan(3)},
			HOSTILE = {Initial = 1, Reserve = 4, TechLevel = GreaterThan(3)}
		},
		["CLOAKSHAPE_SQUADRON"] = {
			CIS = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(2)},
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(2)},
			HOSTILE = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(2)},
			SECTOR_FORCES = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(2)},
			WARLORDS = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(2)}
		},
		["GENERIC_ARC_170_SQUADRON"] = {
			CIS = {Initial = 1, Reserve = 4, TechLevel = GreaterThan(2)},
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = GreaterThan(2)},
			HOSTILE = {Initial = 1, Reserve = 4, TechLevel = GreaterThan(2)},
			SECTOR_FORCES = {Initial = 1, Reserve = 4, TechLevel = GreaterThan(2)},
			WARLORDS = {Initial = 1, Reserve = 4, TechLevel = GreaterThan(2)}
		}
	},
	Scripts = {"multilayer", "fighter-spawn", "single-unit-retreat"}
}