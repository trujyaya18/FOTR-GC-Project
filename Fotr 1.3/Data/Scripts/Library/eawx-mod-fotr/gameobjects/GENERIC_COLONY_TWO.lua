return {
	Fighters = {
		["CLOAKSHAPE_SQUADRON"] = {
			EMPIRE = {Initial = 2, Reserve = 7},
			HOSTILE = {Initial = 2, Reserve = 7},
			SECTOR_FORCES = {Initial = 2, Reserve = 7},
			WARLORDS = {Initial = 2, Reserve = 7}
		},
		["NANTEX_SQUADRON"] = {
			BANKING_CLAN = {Initial = 2, Reserve = 7},
			COMMERCE_GUILD = {Initial = 2, Reserve = 7},
			REBEL = {Initial = 2, Reserve = 7}
		},
		["SCARAB_SQUADRON"] = {
			TECHNO_UNION = {Initial = 2, Reserve = 7},
			TRADE_FEDERATION = {Initial = 2, Reserve = 7}
		},
		["2_WARPOD_SQUADRON"] = {
			EMPIRE = {Initial = 2, Reserve = 7, ResearchType = "RepublicWarpods"},
		},
		["BTLB_Y-WING_SQUADRON"] = {
			CIS = {Initial = 2, Reserve = 7},
			EMPIRE = {Initial = 2, Reserve = 7, ResearchType = "~RepublicWarpods"},
			SECTOR_FORCES = {Initial = 2, Reserve = 7},
			WARLORDS = {Initial = 2, Reserve = 7},
			HOSTILE = {Initial = 2, Reserve = 7}
		},
		["HYENA_SQUADRON_DOUBLE"] = {
			BANKING_CLAN = {Initial = 2, Reserve = 7},
			COMMERCE_GUILD = {Initial = 2, Reserve = 7},
			REBEL = {Initial = 2, Reserve = 7},
			TECHNO_UNION = {Initial = 2, Reserve = 7},
			TRADE_FEDERATION = {Initial = 2, Reserve = 7}
		}
	},
	Scripts = {"fighter-spawn"},
}