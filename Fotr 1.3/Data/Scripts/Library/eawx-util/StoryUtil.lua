--******************************************************************************
--     _______ __
--    |_     _|  |--.----.---.-.--.--.--.-----.-----.
--      |   | |     |   _|  _  |  |  |  |     |__ --|
--      |___| |__|__|__| |___._|________|__|__|_____|
--     ______
--    |   __ \.-----.--.--.-----.-----.-----.-----.
--    |      <|  -__|  |  |  -__|     |  _  |  -__|
--    |___|__||_____|\___/|_____|__|__|___  |_____|
--                                    |_____|
--*   @Author:              [TR]Pox
--*   @Date:                2018-03-10T15:09:24+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            story_util.lua
--*   @Last modified by:    [TR]Pox
--*   @Last modified time:  2018-03-17T02:24:26+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************
require("deepcore/crossplot/crossplot")
CONSTANTS = ModContentLoader.get("GameConstants")

StoryUtil = {
    __important = true,
    PlayerAgnosticPlots = {
        Galactic = "Conquests\\Player_Agnostic_Plot.xml",
        Space = "Conquests\\Tactical_Raids.XML",
		Land = "Conquests\\GroundTactical\\Tactical_GroundBattles.XML"
    },
	ShowTextEventName = "Show_Screen_Text",
	ShowTextNotificationName = "SHOW_SCREEN_TEXT",
	LinkTacticalEventName = "Link_Tactical_Template",
	LinkTacticalNotificationName = "LINK_TACTICAL",
	SetTechLevelEventName = "Set_Tech_Level_Template",
	SetTechLevelNotificationName = "SET_TECH_LEVEL",
	GenericEventName = "Generic_Event_Template",
	GenericEventNotificationName = "GENERIC_EVENT",
	ChangeAIEventName = "Switch_Control_Template",
	ChangeAINotificationName = "SWITCH_CONTROL",
	MultimediaEventName = "Multimedia_Template",
	MultimediaNotificationName = "MULTIMEDIA",
	LockPlanetEventName = "Lock_Planet_Template",
	LockPlanetNotificationName = "SET_PLANET_RESTRICTED",
	DeclareVictoryEventName = "Victory_Event_Template",
	DeclareVictoryNotificationName = "DECLARE_VICTORY",
	ObjectiveCompleteEventName = "Objective_Complete_Template",
	ObjectiveCompleteNotificationName = "OBJECTIVE_COMPLETE",
	ObjectiveFailedEventName = "Objective_Failed_Template",
	ObjectiveFailedNotificationName = "OBJECTIVE_FAILED",
	ObjectiveRemoveEventName = "Objective_Remove_Template",
	ObjectiveRemoveNotificationName = "REMOVE_OBJECTIVE",
}

function StoryUtil.GetPlayerAgnosticPlot()
    local plotName = StoryUtil.PlayerAgnosticPlots[Get_Game_Mode()]
    return Get_Story_Plot(plotName)
end

function StoryUtil.ShowScreenText(textId, time, var, color, teletype)
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    if not plot then
        return
    end

    local screenTextEvent = plot.Get_Event(StoryUtil.ShowTextEventName)

    if not screenTextEvent then
        return
    end

    local colorString = ""
    if color then
        colorString = color.r .. " " .. color.g .. " " .. color.b
    end

    if not var then
        var = ""
    end

    local use_teletype = 1
    if teletype == false then
        use_teletype = 0
    end

    screenTextEvent.Set_Reward_Parameter(0, textId)
    screenTextEvent.Set_Reward_Parameter(1, tostring(time))
    screenTextEvent.Set_Reward_Parameter(2, var)
    screenTextEvent.Set_Reward_Parameter(3, "")
    screenTextEvent.Set_Reward_Parameter(4, use_teletype)
    screenTextEvent.Set_Reward_Parameter(5, colorString)
    Story_Event(StoryUtil.ShowTextNotificationName)
end

function StoryUtil.RemoveScreenText(textId)
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    if not plot then
        return
    end

    local screenTextEvent = plot.Get_Event(StoryUtil.ShowTextEventName)

    if not screenTextEvent then
        return
    end

    screenTextEvent.Set_Reward_Parameter(0, textId)
    screenTextEvent.Set_Reward_Parameter(3, "remove")
    Story_Event(StoryUtil.ShowTextNotificationName)
end

function StoryUtil.TriggerScriptedBattle(planet, location, attacker, defender, is_sandbox, map, battle_plot)
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    if not battle_plot then
        return
    end

    local linkTacticalEvent = plot.Get_Event(StoryUtil.LinkTacticalEventName)

    if not linkTacticalEvent then
        return
    end

	if is_sandbox then
		is_sandbox = 1
	elseif not is_sandbox then
		is_sandbox = 0
	end

    linkTacticalEvent.Set_Reward_Parameter(0, planet)
    linkTacticalEvent.Set_Reward_Parameter(1, location)
    linkTacticalEvent.Set_Reward_Parameter(2, attacker)
    linkTacticalEvent.Set_Reward_Parameter(3, map)
    linkTacticalEvent.Set_Reward_Parameter(4, defender)
    linkTacticalEvent.Set_Reward_Parameter(6, battle_plot)
    linkTacticalEvent.Set_Reward_Parameter(7, is_sandbox)
    linkTacticalEvent.Set_Reward_Parameter(8, 0)
    linkTacticalEvent.Set_Reward_Parameter(9, 1)
    linkTacticalEvent.Set_Reward_Parameter(10, 1)
    linkTacticalEvent.Set_Reward_Parameter(11, "RETREAT_PLAYER")
    linkTacticalEvent.Set_Reward_Parameter(12, 0)
    linkTacticalEvent.Set_Reward_Parameter(13, 1)
    Story_Event(StoryUtil.LinkTacticalNotificationName)
end

function StoryUtil.SetPlanetRestricted(planet, status)
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    if not plot then
        return
    end

    local lockPlanetEvent = plot.Get_Event(StoryUtil.LockPlanetEventName)

    if not lockPlanetEvent then
        return
    end

    crossplot:publish("LOCK_PLANET", planet, status)

    -- local safe_planets = StoryUtil.GetSafePlanetTable()
    -- if safe_planets[planet] then
    --     if FindPlanet(planet).Get_Owner() == Find_Player("Neutral") then
    --         Spawn_Unit(Find_Object_Type("Empire_Star_Base_1"), FindPlanet(planet), Find_Player("Neutral"))
    --     end
    -- end

    lockPlanetEvent.Set_Reward_Parameter(0, planet)
    lockPlanetEvent.Set_Reward_Parameter(1, status)
    Story_Event(StoryUtil.LockPlanetNotificationName)
end

function StoryUtil.SetObjectiveComplete(textId)
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    if not plot then
        return
    end

    local tacticalObjectiveEvent = plot.Get_Event(StoryUtil.ObjectiveCompleteEventName)

    if not tacticalObjectiveEvent then
        return
    end

    tacticalObjectiveEvent.Set_Reward_Parameter(0, textId)
    Story_Event(StoryUtil.ObjectiveCompleteNotificationName)
end

function StoryUtil.SetObjectiveFailed(textId)
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    if not plot then
        return
    end

    local tacticalObjectiveEvent = plot.Get_Event(StoryUtil.ObjectiveFailedEventName)

    if not tacticalObjectiveEvent then
        return
    end

    tacticalObjectiveEvent.Set_Reward_Parameter(0, textId)
    Story_Event(StoryUtil.ObjectiveFailedNotificationName)
end

function StoryUtil.SetObjectiveRemove(textId)
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    if not plot then
        return
    end

    local tacticalObjectiveEvent = plot.Get_Event(StoryUtil.ObjectiveRemoveEventName)

    if not tacticalObjectiveEvent then
        return
    end

    tacticalObjectiveEvent.Set_Reward_Parameter(0, textId)
    Story_Event(StoryUtil.ObjectiveRemoveNotificationName)
end

function StoryUtil.SetTechLevel(player, level)
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    local player_name = player.Get_Faction_Name()

    if not plot then
        return
    end

    local setTechLevelEvent = plot.Get_Event(StoryUtil.SetTechLevelEventName)

    if not setTechLevelEvent then
        return
    end

    if player_name == "Rebel" then
        level = level - 1
    end

    setTechLevelEvent.Set_Reward_Parameter(0, player_name)
    setTechLevelEvent.Set_Reward_Parameter(1, level)
    Story_Event(StoryUtil.SetTechLevelNotificationName)
end

function StoryUtil.GetGenericEvent()
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    if not plot then
        return nil
    end

    return plot.Get_Event(StoryUtil.GenericEventName)
end

function StoryUtil.TriggerGenericEvent()
    Story_Event(StoryUtil.GenericEventNotificationName)
end

function StoryUtil.ResetGenericEvent()
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    if not plot then
        return
    end

    local genericEvent = plot.Get_Event(StoryUtil.GenericEventName)

    if not genericEvent then
        return
    end

    genericEvent.Set_Reward_Type("")
    genericEvent.Set_Reward_Parameter(0, "")
    genericEvent.Set_Reward_Parameter(1, "")
    genericEvent.Set_Reward_Parameter(2, "")
    genericEvent.Set_Reward_Parameter(3, "")
    genericEvent.Set_Reward_Parameter(4, "")
    genericEvent.Set_Reward_Parameter(5, "")
    genericEvent.Set_Reward_Parameter(6, "")
    genericEvent.Set_Reward_Parameter(7, "")
    genericEvent.Set_Reward_Parameter(8, "")
    genericEvent.Set_Reward_Parameter(9, "")
    genericEvent.Set_Reward_Parameter(10, "")
    genericEvent.Set_Reward_Parameter(11, "")
    genericEvent.Set_Reward_Parameter(12, "")
end

function StoryUtil.ValidGlobalValue(val)
    return val and val ~= ""
end

function StoryUtil.FindFriendlyPlanet(player)
    if type(player) == "string" then
        player = Find_Player(player)
    end

    local allPlanets = FindPlanet.Get_All_Planets()

    local random = 0
    local planet = nil

    while table.getn(allPlanets) > 0 do
        random = GameRandom.Free_Random(1, table.getn(allPlanets))
        planet = allPlanets[random]
        table.remove(allPlanets, random)

        if planet.Get_Owner() == player and EvaluatePerception("Enemy_Present", player, planet) == 0 then
            return planet
        end
    end

    return nil
end

function StoryUtil.CheckFriendlyPlanet(planet, player)
	if planet.Get_Owner() == player and EvaluatePerception("Enemy_Present", player, planet) == 0 then
		return true
	else
		return false
    end
end

function StoryUtil.FindEnemyPlanet(player)
    if type(player) == "string" then
        player = Find_Player(player)
    end

    local allPlanets = FindPlanet.Get_All_Planets()

    local random = 0
    local planet = nil

    while table.getn(allPlanets) > 0 do
        random = GameRandom.Free_Random(1, table.getn(allPlanets))
        planet = allPlanets[random]
        table.remove(allPlanets, random)

        if planet.Get_Owner() ~= player and EvaluatePerception("Enemy_Present", planet.Get_Owner(), planet) == 0 then
            return planet
        end
    end

    return nil
end

function StoryUtil.FindTargetPlanet(player, must_be_connected_to_player, allow_fortress_worlds, amount)
	if type(player) == "string" then
		player = Find_Player(player)
	end

	local target_planet_list = {}
	local allPlanets = FindPlanet.Get_All_Planets()

	for _,planet in pairs(allPlanets) do
		local owner = planet.Get_Owner().Get_Faction_Name()
		if owner ~= player.Get_Faction_Name() and owner ~= "NEUTRAL" and EvaluatePerception("Priority_Target", player, planet) == 0 and EvaluatePerception("Is_Owned_By_Enemy", player, planet) == 1 then
			if must_be_connected_to_player then
				if EvaluatePerception("Is_Connected_To_Me", player, planet) == 1 then
					if allow_fortress_worlds then
						table.insert(target_planet_list, planet)
					end
					if not allow_fortress_worlds then
						if EvaluatePerception("Is_Important_Planet", player, planet) == 0 then
							table.insert(target_planet_list, planet)
						end
					end
				end
			end
			if not must_be_connected_to_player then
				if allow_fortress_worlds then
					table.insert(target_planet_list, planet)
				end
				if not allow_fortress_worlds then
					if EvaluatePerception("Is_Important_Planet", player, planet) == 0 then
						table.insert(target_planet_list, planet)
					end
				end
			end
		end
	end
	if table.getn(target_planet_list) == 0 then
		for _,planet in pairs(allPlanets) do
			local owner = planet.Get_Owner().Get_Faction_Name()
			if owner ~= player.Get_Faction_Name() and owner ~= "NEUTRAL" and EvaluatePerception("Priority_Target", player, planet) == 0 and EvaluatePerception("Is_Owned_By_Enemy", player, planet) == 1 then
				table.insert(target_planet_list, planet)
			end
		end
	end

	local planet_counter = table.getn(target_planet_list)

	if amount >= 5 then
		if table.getn(target_planet_list) >= 5 then
			random = GameRandom.Free_Random(1, planet_counter)
			local target01 = target_planet_list[random]
			table.remove(target_planet_list, random)

			random = GameRandom.Free_Random(1, planet_counter)
			local target02 = target_planet_list[random]
			table.remove(target_planet_list, random)

			random = GameRandom.Free_Random(1, planet_counter)
			local target03 = target_planet_list[random]
			table.remove(target_planet_list, random)

			random = GameRandom.Free_Random(1, planet_counter)
			local target04 = target_planet_list[random]
			table.remove(target_planet_list, random)

			random = GameRandom.Free_Random(1, planet_counter)
			local target05 = target_planet_list[random]

			return target01, target02, target03, target04, target05
		end
		if table.getn(target_planet_list) < 5 then
			local amount = 4
		end
	end
	if amount == 4 then
		if table.getn(target_planet_list) >= 4 then
			random = GameRandom.Free_Random(1, planet_counter)
			local target01 = target_planet_list[random]
			table.remove(target_planet_list, random)

			random = GameRandom.Free_Random(1, planet_counter)
			local target02 = target_planet_list[random]
			table.remove(target_planet_list, random)

			random = GameRandom.Free_Random(1, planet_counter)
			local target03 = target_planet_list[random]
			table.remove(target_planet_list, random)

			random = GameRandom.Free_Random(1, planet_counter)
			local target04 = target_planet_list[random]

			return target01, target02, target03, target04
		end
		if table.getn(target_planet_list) < 4 then
			local amount = 3
		end
	end
	if amount == 3 then
		if table.getn(target_planet_list) >= 3 then
			random = GameRandom.Free_Random(1, planet_counter)
			local target01 = target_planet_list[random]
			table.remove(target_planet_list, random)

			random = GameRandom.Free_Random(1, planet_counter)
			local target02 = target_planet_list[random]
			table.remove(target_planet_list, random)

			random = GameRandom.Free_Random(1, planet_counter)
			local target03 = target_planet_list[random]

			return target01, target02, target03
		end
		if table.getn(target_planet_list) < 3 then
			local amount = 2
		end
	end
	if amount == 2 then
		if table.getn(target_planet_list) >= 2 then
			random = GameRandom.Free_Random(1, planet_counter)
			local target01 = target_planet_list[random]
			table.remove(target_planet_list, random)

			random = GameRandom.Free_Random(1, planet_counter)
			local target02 = target_planet_list[random]

			return target01, target02
		end
		if table.getn(target_planet_list) < 2 then
			local amount = 1
		end
	end
	if amount == 1 then
		if table.getn(target_planet_list) >= 1 then
			random = GameRandom.Free_Random(1, planet_counter)
			local target01 = target_planet_list[random]

			return target01
		end
		if table.getn(target_planet_list) < 1 then
			return nil
		end
	end
end

function StoryUtil.SpawnAtSafePlanet(planet_name, player, spawn_location_table, spawn_list, ai_use_set)
    local player_string = player
    if type(player) == "string" then
        player = Find_Player(player)
    end

    local capital_location = nil
    local capital = CONSTANTS.ALL_FACTIONS_CAPITALS[player_string]   
    if capital then
        capital_location = Find_First_Object(capital)
        if capital_location then
            capital_location = capital_location.Get_Planet_Location()
        end
    end        

    if spawn_location_table[planet_name] then
        local start_planet = FindPlanet(planet_name)
		local start_planet_owner = start_planet.Get_Owner()
		local neutral_player = Find_Player("Neutral")
		
        if (start_planet_owner ~= player and start_planet_owner ~= neutral_player) or EvaluatePerception("Enemy_Present", player, start_planet) > 0 then
            if player == Find_Player("Warlords") then
                return nil
            else
                if capital_location ~= nil then
                    start_planet = capital_location
                else
                    start_planet = StoryUtil.FindFriendlyPlanet(player)
                end
            end
        end
        local ai_use = true
        if ai_use_set == false then
            ai_use = false
        end

        if start_planet then
            SpawnList(spawn_list, start_planet, player, ai_use, false)
            return start_planet
        else
            DebugMessage(
                "%s -- No spawn planet could be found as alternative for %s!",
                tostring(Script),
                tostring(planet_name)
            )
            return nil
        end
    else
        start_planet = nil
        if capital_location ~= nil then
            start_planet = capital_location
        else
            start_planet = StoryUtil.FindFriendlyPlanet(player)
        end
		
		local ai_use = true
        if ai_use_set == false then
            ai_use = false
        end

        if start_planet then
            SpawnList(spawn_list, start_planet, player, ai_use, false)
            return start_planet
        else
            DebugMessage(
                "%s -- No spawn planet could be found as alternative for %s!",
                tostring(Script),
                tostring(planet_name)
            )
            return nil
        end
	
    end
end

function StoryUtil.GetSafePlanetTable()
    local Active_Planets = require("eawx-util/PlanetTable")
    local all_planets = FindPlanet.Get_All_Planets()

    for _, planet in pairs(all_planets) do
        local name = planet.Get_Type().Get_Name()
    
        if Active_Planets[name] ~= nil then
            Active_Planets[name] = true
        end
    end

    return Active_Planets
end

function StoryUtil.Find_Attacking_Player(land_battle, sleep)
	if land_battle then
		local attacker_marker = Find_First_Object("Attacker Entry Position")

		if not TestValid(attacker_marker) then
			return nil
		end

		Sleep(0.5)

		local p_attacker = Find_Nearest(attacker_marker, "Infantry | Vehicle | Air | LandHero")

		if TestValid(p_attacker) and p_attacker.Get_Distance(attacker_marker) < 100 then
			return p_attacker.Get_Owner()
		else
			return nil
		end
	else
		if sleep == true then
			Sleep(5)
		end

		DebugMessage("%s -- Set Attacker", tostring(Script))
		local attacker_marker_list = Find_All_Objects_Of_Type("Attacker Entry Position")

		for _,attacker_marker in pairs(attacker_marker_list) do
			local p_attacker = Find_Nearest(attacker_marker, "SpaceHero | Fighter | Bomber | Transport | Corvette | Frigate | Capital | SuperCapital")
			DebugMessage("%s -- Attacker starting unit %s", tostring(Script), tostring(p_attacker))
			if TestValid(p_attacker) then
				if attacker_marker.Get_Distance(p_attacker) < 4000 then
					DebugMessage("%s -- Set Attacker Marker", tostring(Script))
					return p_attacker.Get_Owner()
				end
			end
		end
	end
end

function StoryUtil.Find_Defending_Player()
    local defending_player = nil
	local defender_marker = Find_First_Object("Defending Forces Position")

	if not TestValid(defender_marker) then
		return nil
	end

	local defending_player = defender_marker.Get_Owner()
	if TestValid(defending_player) then
		return defending_player
	else
		return nil
	end
end

function StoryUtil.ChangeAIPlayer(player, ai_type)
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    local player_name = player

    if not plot then
        return
    end

    local aiChangeEvent = plot.Get_Event(StoryUtil.ChangeAIEventName)

    if not aiChangeEvent then
        return
    end

    aiChangeEvent.Set_Reward_Parameter(0, player_name)
    aiChangeEvent.Set_Reward_Parameter(1, ai_type)
    Story_Event(StoryUtil.ChangeAINotificationName)
end

function StoryUtil.Multimedia(textId, time, speech_name, movie_name, int, faction)
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    if not plot then
        return
    end

    if faction ~= nil then
        if Find_Player("local") ~= Find_Player(faction) then
            return
        end
    end

    local multimediaEvent = plot.Get_Event(StoryUtil.MultimediaEventName)

    if not multimediaEvent then
        return
    end

    if speech_name == nil then
        speech_name = ""
    end

    if movie_name == nil then
        movie_name = ""
    end
    
    multimediaEvent.Set_Reward_Parameter(0, textId)
    multimediaEvent.Set_Reward_Parameter(1, tostring(time))
    multimediaEvent.Set_Reward_Parameter(7, speech_name)
    multimediaEvent.Set_Reward_Parameter(8, movie_name)
    multimediaEvent.Set_Reward_Parameter(9, tostring(int))
    Story_Event(StoryUtil.MultimediaNotificationName)
end

function StoryUtil.DebugLog(text)
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    local debugStack = GlobalValue.Get("DEBUG_LOG")

    table.remove(debugStack, 1)
    table.insert(debugStack, text)

    if not plot then
        return
    end

    local debugEvent = plot.Get_Event("Show_Debug_Display")

    if not debugEvent then
        return
    end

    GlobalValue.Set("DEBUG_LOG", debugStack)

    debugEvent.Clear_Dialog_Text()
    for _, entry in pairs(debugStack) do
        debugEvent.Add_Dialog_Text(entry)
    end
end

function StoryUtil.DeclareGalacticVictory(player)
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    local player_name = player

    if not plot then
        return
    end

    local victoryEvent = plot.Get_Event(StoryUtil.DeclareVictoryEventName)

    if not victoryEvent then
        return
    end

    victoryEvent.Set_Reward_Parameter(0, player_name)
    Story_Event(StoryUtil.DeclareVictoryNotificationName)
end

return StoryUtil
