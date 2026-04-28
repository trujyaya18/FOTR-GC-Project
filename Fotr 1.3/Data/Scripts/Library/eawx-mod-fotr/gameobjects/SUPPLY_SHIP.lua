return {
	Ship_Crew_Requirement = 10,
	Fighters = {
		["VULTURE_BROWN_SQUADRON_DOUBLE"] = {
			BANKING_CLAN = {Initial = 2, Reserve = 2},
			COMMERCE_GUILD = {Initial = 2, Reserve = 2},
			EMPIRE = {Initial = 2, Reserve = 2},
			HOSTILE = {Initial = 2, Reserve = 2},
			REBEL = {Initial = 2, Reserve = 2, TechLevel = EqualTo(1)},
			SECTOR_FORCES = {Initial = 2, Reserve = 2},
			TECHNO_UNION = {Initial = 2, Reserve = 2},
			TRADE_FEDERATION = {Initial = 2, Reserve = 2},
			WARLORDS = {Initial = 2, Reserve = 2}
		},
		["VULTURE_SQUADRON_DOUBLE"] = {
			REBEL = {Initial = 2, Reserve = 2, TechLevel = GreaterOrEqualTo(2)}
		},
		["SCARAB_SQUADRON_HALF"] = {
			DEFAULT = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(2)}
		},
		["TRIFIGHTER_SQUADRON_HALF"] = {
			DEFAULT = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(2)}
		},
		["HYENA_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 2, Reserve = 2}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}