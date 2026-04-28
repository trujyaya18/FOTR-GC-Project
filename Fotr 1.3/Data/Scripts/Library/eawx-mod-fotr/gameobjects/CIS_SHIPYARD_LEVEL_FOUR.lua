return {
	Fighters = {
		["VULTURE_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 3, Reserve = 99}
		},
		["SCARAB_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 2, TechLevel = LessThan(3)}
		},
		["TRIFIGHTER_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 2, TechLevel = GreaterOrEqualTo(3)}
		},
		["HYENA_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 4, Reserve = 8}
		},
		["SKIRMISH_DIAMOND_FRIGATE"] = {
			DEFAULT = {Initial = 2, Reserve = 3}
		},
		["SKIRMISH_MUNIFEX"] = {
			DEFAULT = {Initial = 2, Reserve = 0}
		},
		["SKIRMISH_MUNIFICENT"] = {
			DEFAULT = {Initial = 2, Reserve = 0}
		},
		["SKIRMISH_CAPTOR"] = {
			DEFAULT = {Initial = 2, Reserve = 0}
		},
		["SKIRMISH_AUXILIARY_LUCREHULK"] = {
			DEFAULT = {Initial = 1, Reserve = 0, TechLevel = LessThan(2)}
		},
		["SKIRMISH_PROVIDENCE"] = {
			DEFAULT = {Initial = 1, Reserve = 0, TechLevel = GreaterOrEqualTo(2)}
		}
	},
	Scripts = {"fighter-spawn"},
	Flags = {SHIPYARD = true, HANGAR = true}
}