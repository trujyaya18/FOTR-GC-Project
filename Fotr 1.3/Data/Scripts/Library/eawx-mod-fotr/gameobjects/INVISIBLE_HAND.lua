return {
	Fighters = {
		["VULTURE_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		},
		["SCARAB_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(2)}
		},
		["TRIFIGHTER_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 2, TechLevel = GreaterOrEqualTo(3)}
		},
		["ADVANCED_ESTAP_BROWN_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 3, TechLevel = LessOrEqualTo(1)}
		},
		["BELBULLAB24_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 3, TechLevel = GreaterOrEqualTo(2)}
		},
		["SOULLESS_ONE_SQUADRON"] = {
			DEFAULT = {Initial= 1, Reserve = 0}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}