return {
	Ship_Crew_Requirement = 10,
	Fighters = {
		["TORRENT_SQUADRON"] = {
			CIS = {Initial = 1, Reserve = 4},
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(3)},
			HOSTILE = {Initial = 1, Reserve = 4},
			SECTOR_FORCES = {Initial = 1, Reserve = 4},
			WARLORDS = {Initial = 1, Reserve = 4}
		},
		["V-WING_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = GreaterThan(3)}
		},
		["GENERIC_ARC_170_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		},
		["2_WARPOD_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 4, ResearchType = "RepublicWarpods"}
		},
		["BTLB_Y-WING_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 4, ResearchType = "~RepublicWarpods"}
		},
		["NTB_630_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}