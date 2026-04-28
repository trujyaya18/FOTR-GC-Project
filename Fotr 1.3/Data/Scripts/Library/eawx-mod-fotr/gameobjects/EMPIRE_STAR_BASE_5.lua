return {
	Fighters = {
		["DELTA6_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(2)},
			HOSTILE = {Initial = 1, Reserve = 4},
			SECTOR_FORCES = {Initial = 1, Reserve = 4},
			WARLORDS = {Initial = 1, Reserve = 4}
		},
		["REPUBLIC_Z95_HEADHUNTER_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = GreaterThan(2)}
		},
		["CLOAKSHAPE_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 9, TechLevel = LessOrEqualTo(2)},
			HOSTILE = {Initial = 1, Reserve = 9, TechLevel = LessOrEqualTo(2)},
			SECTOR_FORCES = {Initial = 1, Reserve = 9, TechLevel = LessOrEqualTo(2)},
			WARLORDS = {Initial = 1, Reserve = 9, TechLevel = LessOrEqualTo(2)}
		},
		["GENERIC_ARC_170_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 9, TechLevel = GreaterThan(2)},
			HOSTILE = {Initial = 1, Reserve = 9, TechLevel = GreaterThan(2)},
			SECTOR_FORCES = {Initial = 1, Reserve = 9, TechLevel = GreaterThan(2)},
			WARLORDS = {Initial = 1, Reserve = 9, TechLevel = GreaterThan(2)}
		},
		["2_WARPOD_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 9, ResearchType = "RepublicWarpods"},
		},
		["BTLB_Y-WING_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 9, ResearchType = "~RepublicWarpods"},
			SECTOR_FORCES = {Initial = 1, Reserve = 9},
			WARLORDS = {Initial = 1, Reserve = 9},
			HOSTILE = {Initial = 1, Reserve = 9}
		},
		["NTB_630_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 4},
			HOSTILE = {Initial = 1, Reserve = 4},
			SECTOR_FORCES = {Initial = 1, Reserve = 4},
			WARLORDS = {Initial = 1, Reserve = 4}
		},
		["SKIRMISH_CR90"] = {
			DEFAULT = {Initial = 3, Reserve = 3}
		}
	},
	Scripts = {"fighter-spawn"},
}