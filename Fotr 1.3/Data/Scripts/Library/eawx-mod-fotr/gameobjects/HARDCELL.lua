return {
	Ship_Crew_Requirement = 1,
	Fighters = {
		["VULTURE_BROWN_SQUADRON"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 3},
			COMMERCE_GUILD = {Initial = 1, Reserve = 3},
			EMPIRE = {Initial = 1, Reserve = 3},
			HOSTILE = {Initial = 1, Reserve = 3},
			REBEL = {Initial = 1, Reserve = 3, TechLevel = EqualTo(1)},
			SECTOR_FORCES = {Initial = 1, Reserve = 3},
			TECHNO_UNION = {Initial = 1, Reserve = 3},
			TRADE_FEDERATION = {Initial = 1, Reserve = 3},
			WARLORDS = {Initial = 1, Reserve = 3}
		},
		["VULTURE_SQUADRON"] = {
			REBEL = {Initial = 1, Reserve = 3, TechLevel = GreaterOrEqualTo(2)}
		}
	},
	Scripts = {"multilayer", "fighter-spawn", "single-unit-retreat"},
	Flags = {HANGAR = true}
}