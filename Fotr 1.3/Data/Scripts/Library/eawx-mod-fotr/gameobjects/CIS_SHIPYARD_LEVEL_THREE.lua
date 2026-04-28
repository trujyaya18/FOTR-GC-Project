return {
	Fighters = {
		["VULTURE_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 2, Reserve = 99}
		},
		["SCARAB_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 2, TechLevel = LessThan(3)}
		},
		["TRIFIGHTER_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 2, TechLevel = GreaterOrEqualTo(3)}
		},
		["HYENA_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 3, Reserve = 6}
		},
		["SKIRMISH_DIAMOND_FRIGATE"] = {
			DEFAULT = {Initial = 2, Reserve = 4}
		},
		["SKIRMISH_AUXILIA"] = {
			DEFAULT = {Initial = 2, Reserve = 0}
		},
		["SKIRMISH_MUNIFICENT"] = {
			DEFAULT = {Initial = 2, Reserve = 0}
		},
		["SKIRMISH_CAPTOR"] = {
			DEFAULT = {Initial = 1, Reserve = 0}
		}
	},
	Scripts = {"fighter-spawn"},
	Flags = {SHIPYARD = true, HANGAR = true}
}