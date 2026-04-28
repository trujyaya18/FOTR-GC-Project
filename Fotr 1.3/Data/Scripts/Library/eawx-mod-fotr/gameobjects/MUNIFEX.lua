return {
	Ship_Crew_Requirement = 5,
	Fighters = {
		["CLOAKSHAPE_SQUADRON_HALF"] = {
			EMPIRE = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(2)},
			WARLORDS = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(2)}
		},
		["MANKVIM_SQUADRON_HALF"] = {
			WARLORDS = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(2)}
		},
		["TWIN_ION_ENGINE_STARFIGHTER_SQUADRON_HALF"] = {
			EMPIRE = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(2)}
		},
		["NANTEX_SQUADRON_HALF"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 1},
			COMMERCE_GUILD = {Initial = 1, Reserve = 1}
		},
		["SCARAB_SQUADRON_HALF"] = {
			HOSTILE = {Initial = 1, Reserve = 1},
			REBEL = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(2)},
			SECTOR_FORCES = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(2)},
			TECHNO_UNION = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(2)},
			TRADE_FEDERATION = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(2)}
		},
		["TRIFIGHTER_SQUADRON_HALF"] = {
			REBEL = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(2)},
			SECTOR_FORCES = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(2)},
			TECHNO_UNION = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(2)},
			TRADE_FEDERATION = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(2)}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"},
	Flags = {HANGAR = true}
}