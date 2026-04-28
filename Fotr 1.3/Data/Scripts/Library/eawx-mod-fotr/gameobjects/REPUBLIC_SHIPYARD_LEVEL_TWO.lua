return {
	Fighters = {
		["GENERIC_Z95_HEADHUNTER_SQUADRON"] = {
			DEFAULT = {Initial = 2, Reserve = 99, TechLevel = LessThan(3)}
		},
		["TORRENT_SQUADRON"] = {
			DEFAULT = {Initial = 2, Reserve = 99, TechLevel = IsOneOf{(3)}}
		},
		["TWIN_ION_ENGINE_STARFIGHTER_SQUADRON"] = {
			DEFAULT = {Initial = 2, Reserve = 99, TechLevel = GreaterOrEqualTo(4)}
		},
		["CLOAKSHAPE_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		},
		["2_WARPOD_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 1, Reserve = 2, ResearchType = "RepublicWarpods"},
			SECTOR_FORCES = {Initial = 1, Reserve = 2},
			WARLORDS = {Initial = 1, Reserve = 2}
		},
		["BTLB_Y-WING_SQUADRON_DOUBLE"] = {
			CIS = {Initial = 1, Reserve = 2},
			EMPIRE = {Initial = 1, Reserve = 2, ResearchType = "~RepublicWarpods"},
			HOSTILE = {Initial = 1, Reserve = 2}
		},
		["SKIRMISH_CR90"] = {
			DEFAULT = {Initial = 2, Reserve = 4}
		},
		["SKIRMISH_CARRACK_CRUISER_LASERS"] = {
			DEFAULT = {Initial = 2, Reserve = 0}
		},
		["SKIRMISH_DREADNAUGHT_LASERS"] = {
			DEFAULT = {Initial = 2, Reserve = 0, TechLevel = LessThan(2)}
		},
		["SKIRMISH_DREADNAUGHT"] = {
			DEFAULT = {Initial = 2, Reserve = 0, TechLevel = GreaterOrEqualTo(2)}
		}
	},
	Scripts = {"fighter-spawn"},
	Flags = {SHIPYARD = true, HANGAR = true}
}