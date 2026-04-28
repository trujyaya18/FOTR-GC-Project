require("PGBase")
require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("eawx-util/StoryUtil")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))
    Define_State("State_Init", State_Init);
end

function State_Init(message)
    if Get_Game_Mode() ~= "Land" then
		ScriptExit()
	end

	local p_attacker = StoryUtil.Find_Attacking_Player(true)
	local p_defender = StoryUtil.Find_Defending_Player()

	if p_defender == Find_Player("Independent_Forces") or p_defender == Find_Player("Warlords") then
		Object.Change_Owner(p_defender)
		Object.Set_Garrison_Spawn(true)
		ScriptExit()
	end
	if Object.Get_Type() == Find_Object_Type("Indigenous_Dwelling_Mon_Calamari")
	or Object.Get_Type() == Find_Object_Type("Indigenous_Dwelling_Gungan")
	or Object.Get_Type() == Find_Object_Type("Indigenous_Dwelling_Wookiee")
	or Object.Get_Type() == Find_Object_Type("Indigenous_Dwelling_Twilek")
	or Object.Get_Type() == Find_Object_Type("Indigenous_Dwelling_Bothan") then
		Object.Change_Owner(Find_Player("Empire"))
		Object.Set_Garrison_Spawn(true)
	end
	if Object.Get_Type() == Find_Object_Type("Indigenous_Dwelling_Hutt") then
		Object.Change_Owner(Find_Player("Hutt_Cartels"))
		Object.Set_Garrison_Spawn(true)
	end
	if Object.Get_Type() == Find_Object_Type("Indigenous_Dwelling_Mandalorian") then
		Object.Change_Owner(Find_Player("Mandalorians"))
		Object.Set_Garrison_Spawn(true)
	end
	if Object.Get_Type() == Find_Object_Type("Indigenous_Dwelling_Chiss") then
		Object.Change_Owner(Find_Player("Chiss"))
		Object.Set_Garrison_Spawn(true)
	end
	if Object.Get_Type() == Find_Object_Type("Indigenous_Dwelling_Sullustan")
	or Object.Get_Type() == Find_Object_Type("Indigenous_Dwelling_Geonosian") then
		Object.Change_Owner(Find_Player("Rebel"))
		Object.Set_Garrison_Spawn(true)
	end
	if Object.Get_Type() == Find_Object_Type("Indigenous_Dwelling_Cultists")
	or Object.Get_Type() == Find_Object_Type("Indigenous_Dwelling_Tusken")
	or Object.Get_Type() == Find_Object_Type("Indigenous_Dwelling_Wampa")
	or Object.Get_Type() == Find_Object_Type("Indigenous_Dwelling_Terentatek")
	or Object.Get_Type() == Find_Object_Type("Indigenous_Dwelling_Rancor")
	or Object.Get_Type() == Find_Object_Type("Indigenous_Dwelling_Vornskr")
	or Object.Get_Type() == Find_Object_Type("Indigenous_Dwelling_Kath")
	or Object.Get_Type() == Find_Object_Type("Indigenous_Dwelling_Nightsister")
	or Object.Get_Type() == Find_Object_Type("Indigenous_Jawa_Sandcrawler") then
		Object.Change_Owner(Find_Player("Hostile"))
		Object.Set_Garrison_Spawn(true)
	end
	if Object.Get_Owner() == Find_Player("Neutral") then
		local unrest_target = GameRandom.Free_Random(1, 6)
		if unrest_target <= 3 then
			Object.Change_Owner(p_defender)
			Object.Set_Garrison_Spawn(true)
		end
		if unrest_target == 4 then
			Object.Change_Owner(Find_Player("Independent_Forces"))
			Object.Set_Garrison_Spawn(true)
		end
		if unrest_target >= 5 then
			Object.Change_Owner(p_attacker)
			Object.Set_Garrison_Spawn(true)
		end
	else
		Object.Set_Garrison_Spawn(true)
	end
	ScriptExit()
end
