return {
	Ship_Crew_Requirement = 10,
	Fighters = {
		["GENERIC_ARC_170_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 0}
		},
		["2_WARPOD_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 1, ResearchType = "RepublicWarpods"}
		},
		["BTLB_Y-WING_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 1, ResearchType = "~RepublicWarpods"}
		}
	},
	Scripts = {"multilayer", "fighter-spawn", "single-unit-retreat"}
}