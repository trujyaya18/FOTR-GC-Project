return {
	Fighters = {
		["GENERIC_Z95_HEADHUNTER_SQUADRON"] = {
			DEFAULT = {Initial = 3, Reserve = 99, TechLevel = LessThan(3)}
		},
		["TORRENT_SQUADRON"] = {
			DEFAULT = {Initial = 3, Reserve = 99, TechLevel = IsOneOf{(3)}}
		},
		["TWIN_ION_ENGINE_STARFIGHTER_SQUADRON"] = {
			DEFAULT = {Initial = 3, Reserve = 99, TechLevel = GreaterOrEqualTo(4)}
		},
		["CLOAKSHAPE_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 2, TechLevel = LessThan(3)}
		},
		["GENERIC_ARC_170_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 2, TechLevel = GreaterOrEqualTo(3)}
		},
		["2_WARPOD_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 2, Reserve = 4, ResearchType = "RepublicWarpods"},
			SECTOR_FORCES = {Initial = 2, Reserve = 4},
			WARLORDS = {Initial = 2, Reserve = 2}
		},
		["BTLB_Y-WING_SQUADRON_DOUBLE"] = {
			CIS = {Initial = 2, Reserve = 4},
			EMPIRE = {Initial = 2, Reserve = 4, ResearchType = "~RepublicWarpods"},
			HOSTILE = {Initial = 2, Reserve = 4}
		},
		["SKIRMISH_CR90"] = {
			DEFAULT = {Initial = 2, Reserve = 4}
		},
		["SKIRMISH_CARRACK_CRUISER_LASERS"] = {
			DEFAULT = {Initial = 2, Reserve = 0}
		},
		["SKIRMISH_DREADNAUGHT"] = {
			DEFAULT = {Initial = 2, Reserve = 0, TechLevel = LessThan(2)}
		},
		["SKIRMISH_ARQUITENS"] = {
			DEFAULT = {Initial = 2, Reserve = 0, TechLevel = GreaterOrEqualTo(2)}
		},
		["SKIRMISH_DREADNAUGHT_CARRIER"] = {
			DEFAULT = {Initial = 2, Reserve = 0, TechLevel = LessThan(2)}
		},
		["SKIRMISH_ACCLAMATOR_ASSAULT_SHIP_I"] = {
			DEFAULT = {Initial = 2, Reserve = 0, TechLevel = GreaterOrEqualTo(2)}
		},
		["SKIRMISH_INVINCIBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 0, TechLevel = LessThan(3)}
		},
		["SKIRMISH_VENATOR"] = {
			DEFAULT = {Initial = 1, Reserve = 0, TechLevel = GreaterOrEqualTo(3)}
		}
	},
	Scripts = {"fighter-spawn"},
	Flags = {SHIPYARD = true, HANGAR = true}
}