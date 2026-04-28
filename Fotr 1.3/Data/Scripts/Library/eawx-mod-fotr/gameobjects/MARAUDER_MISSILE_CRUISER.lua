return {
	Ship_Crew_Requirement = 1,
	Fighters = {
		["GENERIC_Z95_HEADHUNTER_SQUADRON_HALF"] = {
			EMPIRE = {Initial = 1, Reserve = 1},
			HOSTILE = {Initial = 1, Reserve = 1},
			SECTOR_FORCES = {Initial = 1, Reserve = 1},
			WARLORDS = {Initial = 1, Reserve = 1}
		},
		["SCARAB_SQUADRON_HALF"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 1},
			COMMERCE_GUILD = {Initial = 1, Reserve = 1},
			REBEL = {Initial = 1, Reserve = 1},
			TECHNO_UNION = {Initial = 1, Reserve = 1},
			TRADE_FEDERATION = {Initial = 1, Reserve = 1}
		}
	},
	Scripts = {"multilayer", "fighter-spawn", "single-unit-retreat"},
	Flags = {HANGAR = true}
}