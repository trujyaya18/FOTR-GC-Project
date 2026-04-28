return {
	Ship_Crew_Requirement = 10,
	Fighters = {
		["SABAOTH_FIGHTER_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 1, Reserve = 1},
			REBEL = {Initial = 1, Reserve = 1},
			WARLORDS = {Initial = 1, Reserve = 1}
		},
		["SABAOTH_DEFENDER_SQUADRON"] = {
			EMPIRE = {Reserve = 1, Initial = 1},
			REBEL = {Reserve = 1, Initial = 1},
			WARLORDS = {Reserve = 1, Initial = 1}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}