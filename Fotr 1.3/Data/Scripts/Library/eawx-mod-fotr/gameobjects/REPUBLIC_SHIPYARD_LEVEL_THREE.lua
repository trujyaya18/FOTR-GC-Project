return {
	Fighters = {
		["GENERIC_Z95_HEADHUNTER_SQUADRON"] = {
			DEFAULT = {Initial = 3, Reserve = 99, TechLevel = LessThan(3)}
		},
		["TORRENT_SQUADRON"] = {
			DEFAULT = {Initial = 3, Reserve = 99, TechLevel = IsOneOf{(3)}}
		},
		["V-WING_SQUADRON"] = {
			DEFAULT = {Initial = 3, Reserve = 99, TechLevel = GreaterOrEqualTo(4)}
		},
		CLOAKSHAPE_SQUADRON = {
			DEFAULT = {Initial = 1, Reserve = 2}
		},
		["2_WARPOD_SQUADRON"] = {
			EMPIRE = {Initial = 3, Reserve = 6, ResearchType = "RepublicWarpods"},
		},
		["BTLB_Y-WING_SQUADRON"] = {
			EMPIRE = {Initial = 3, Reserve = 6, ResearchType = "~RepublicWarpods"},
			HOSTILE = {Initial = 3, Reserve = 6},
			SECTOR_FORCES = {Initial = 3, Reserve = 6},
			WARLORDS = {Initial = 3, Reserve = 6}
		},
		["SKIRMISH_CR90"] = {
			DEFAULT = {Initial = 2, Reserve = 4}
		},
		["SKIRMISH_CARRACK_CRUISER_LASERS"] = {
			DEFAULT = {Initial = 2, Reserve = 0, TechLevel = LessThan(2)}
		},
		["SKIRMISH_ARQUITENS"] = {
			DEFAULT = {Initial = 2, Reserve = 0, TechLevel = GreaterOrEqualTo(2)}
		},
		["SKIRMISH_DREADNAUGHT"] = {
			DEFAULT = {Initial = 2, Reserve = 0}
		},
		["SKIRMISH_DREADNAUGHT_CARRIER"] = {
			DEFAULT = {Initial = 2, Reserve = 0, TechLevel = LessThan(2)}
		},
		["SKIRMISH_ACCLAMATOR_ASSAULT_SHIP_I"] = {
			DEFAULT = {Initial = 2, Reserve = 0, TechLevel = GreaterOrEqualTo(2)}
		}
	},
	Scripts = {"fighter-spawn"},
	Flags = {SHIPYARD = true, HANGAR = true}
}