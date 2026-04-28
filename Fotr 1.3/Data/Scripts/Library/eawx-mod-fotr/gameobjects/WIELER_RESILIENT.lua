return {
	Fighters = {
		["TORRENT_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 2, TechLevel = LessOrEqualTo(3), Reserve = 6}
		},
		["V-WING_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 2, TechLevel = GreaterThan(3), Reserve = 6}
		},
		["ETA2_ACTIS_SQUADRON_DOUBLE"] = { --Maybe swap this for Delta in Era 2?
			DEFAULT = {Initial = 2, Reserve = 6}
		},
		["GENERIC_ARC_170_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}