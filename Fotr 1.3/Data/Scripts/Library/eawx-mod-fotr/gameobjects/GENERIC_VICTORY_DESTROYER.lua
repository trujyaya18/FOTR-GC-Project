return {
	Ship_Crew_Requirement = 15,
	Fighters = {
		["TORRENT_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(3)}
		},
		["V-WING_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(3)}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}