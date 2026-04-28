require("PGStateMachine")
require("PGStoryMode")
require("TRCommands")

function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))

	Define_State("State_Init", State_Init);
	
	AnakinObiwan_Timer = 0
	
	ServiceRate = 1
	
end

function State_Init(message)

	if Get_Game_Mode() ~= "Land" then
		ScriptExit()
	end

	if message == OnEnter then
		if not ModContentLoader then
            ModContentLoader = require("eawx-std/ModContentLoader")
		end
		
		local reinforcementPointTypes = {
            "Reinforcement_Point",
            "Reinforcement_Point_Plus1_Cap", 
            "Reinforcement_Point_Plus2_Cap", 
            "Reinforcement_Point_Plus3_Cap", 
            "Reinforcement_Point_Plus4_Cap", 
            "Reinforcement_Point_Plus5_Cap",
            "Reinforcement_Point_Plus10_Cap"
			}
			
		local p_neutral = Find_Player("Neutral")
		
        for _, point_type in pairs(reinforcementPointTypes) do
			DebugMessage("Checking for point type %s", point_type)
            local reinforcementPoints = Find_All_Objects_Of_Type(point_type)
			
			if reinforcementPoints ~= nil then
				DebugMessage("Spawning field base pads at point type %s", point_type)
				for _, point in pairs(reinforcementPoints) do
					unit = Find_Object_Type("Field_Base_Pad")
					Create_Generic_Object(unit, point.Get_Position(), p_neutral)
				end
			end
		end
		
		CONSTANTS = ModContentLoader.get("GameConstants")
		
		players = {}
		
		for _, player_name in pairs(CONSTANTS.PLAYABLE_FACTIONS) do
			player_object = Find_Player(player_name)
			
			if table.getn(Find_All_Objects_Of_Type(player_object)) > 0 then
				table.insert(players, player_object)
			end
		end
		
		--for _, player in pairs(players) do
		--	DebugMessage("Player %s is present in battle", tostring(player.Get_Name()))
		--end
		
        DebugMessage("DetermineEvents Ground Handler Finished")
	elseif message == OnUpdate then
	
	    DebugMessage("DetermineEvents Ground Handler Update Started")
		
		repeat
			DebugMessage("Checking if AI is active using %s", tostring(players[1].Get_Faction_Name()))
			Sleep(1)
			bombardment_disabled = EvaluatePerception("Disable_Bombardment", players[1])
		until (bombardment_disabled ~= nil)
		
		for _, player in pairs(players) do
			bombardment_disabled = EvaluatePerception("Disable_Bombardment", player)
			if bombardment_disabled > 0 then
				player.Disable_Orbital_Bombardment(true)
				DebugMessage("Initial bombardment disabled for %s", tostring(player.Get_Faction_Name()))
			else
				player.Disable_Orbital_Bombardment(false)
				DebugMessage("Bombardment enabled for %s", tostring(player.Get_Faction_Name()))
			end
		end
		
        DebugMessage("DetermineEvents Ground Handler Update Finished")
    end
end