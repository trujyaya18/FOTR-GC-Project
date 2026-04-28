return {
	Fighters = {
		["GENERIC_Z95_HEADHUNTER_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(3)},
			HOSTILE = {Initial = 1, Reserve = 1},
			SECTOR_FORCES = {Initial = 1, Reserve = 1},
			WARLORDS = {Initial = 1, Reserve = 1}
		},
		["TWIN_ION_ENGINE_STARFIGHTER_SQUADRON"] = {
			EMPIRE = {Reserve = 1, Initial = 1, TechLevel = GreaterThan(3)}
		},
		["NANTEX_SQUADRON"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 1},
			COMMERCE_GUILD = {Initial = 1, Reserve = 1},
			REBEL = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(3)}
		},
		["MANKVIM_SQUADRON"] = {
			REBEL = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(3)}
		},
		["SCARAB_SQUADRON"] = {
			TECHNO_UNION = {Initial = 1, Reserve = 1},
			TRADE_FEDERATION = {Initial = 1, Reserve = 1}
		},
		["ADVANCED_ESTAP_BROWN_SQUADRON"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(1)},
			COMMERCE_GUILD = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(1)},
			REBEL = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(1)},
			TECHNO_UNION = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(1)},
			TRADE_FEDERATION = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(1)}
		},
		["BELBULLAB24_SQUADRON"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 1, TechLevel = GreaterOrEqualTo(2)},
			COMMERCE_GUILD = {Initial = 1, Reserve = 1, TechLevel = GreaterOrEqualTo(2)},
			REBEL = {Initial = 1, Reserve = 1, TechLevel = GreaterOrEqualTo(2)},
			TECHNO_UNION = {Initial = 1, Reserve = 1, TechLevel = GreaterOrEqualTo(2)},
			TRADE_FEDERATION = {Initial = 1, Reserve = 1, TechLevel = GreaterOrEqualTo(2)}
		},
		["2_WARPOD_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 1, ResearchType = "RepublicWarpods"},
		},
		["BTLB_Y-WING_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 1, ResearchType = "~RepublicWarpods"},
			HOSTILE = {Initial = 1, Reserve = 1},
			SECTOR_FORCES = {Initial = 1, Reserve = 1},
			WARLORDS = {Initial = 1, Reserve = 1}
		},
		["SKIRMISH_CR90"] = {
			EMPIRE = {Initial = 1, Reserve = 1},
			HOSTILE = {Initial = 1, Reserve = 1},
			SECTOR_FORCES = {Initial = 1, Reserve = 1},
			WARLORDS = {Initial = 1, Reserve = 1}
		},
		["SKIRMISH_DIAMOND_FRIGATE"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 1},
			COMMERCE_GUILD = {Initial = 1, Reserve = 1},
			REBEL = {Initial = 1, Reserve = 1},
			TECHNO_UNION = {Initial = 1, Reserve = 1},
			TRADE_FEDERATION = {Initial = 1, Reserve = 1}
		}
	},
	Scripts = {"turn-station", "fighter-spawn"}
}