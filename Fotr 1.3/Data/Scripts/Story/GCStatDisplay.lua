require("PGStoryMode")
require("PGBase")

CONSTANTS = ModContentLoader.get("GameConstants")
require("TRCommands")

--
-- Definitions -- This function is called once when the script is first created.
--
function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))

    ServiceRate = 5

    StoryModeEvents = {
        Stat_Setup = Stat_Display_Setup
    }

    setup_complete = false
    human_faction = nil
end

function Stat_Display_Setup(message)
    if message == OnEnter then
        DebugMessage("Stat_Display_Setup Started")
        plot = Get_Story_Plot("GCStatDisplay.xml")

        DebugMessage("%s -- plot is %s", tostring(Script), tostring(plot))

        stat_display_event = plot.Get_Event("Stat_Display")

        DebugMessage("%s -- event is %s", tostring(Script), tostring(stat_display_event))

        liveFactionTable = CreateFactionTable(CONSTANTS.ALL_FACTIONS_NOT_NEUTRAL)

        for _, faction in pairs(liveFactionTable) do
            if faction.Is_Human() then
                human_faction = faction
                break
            end
        end

        setup_complete = true
        DebugMessage("Stat_Display_Setup Finished")
    end
end

function Story_Mode_Service()
    DebugMessage("%s -- Servicing script", tostring(Script))
    DebugMessage("Story_Mode_Service GCStatDisplay Started")
    if setup_complete == true then
        DebugMessage("%s -- Refreshing perceptions", tostring(Script))
        stat_display_event.Clear_Dialog_Text()
        liveFactionTable = CreateFactionTable(CONSTANTS.ALL_FACTIONS_NOT_NEUTRAL)

        stat_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        stat_display_event.Add_Dialog_Text("STAT_ECONOMIC_STRUCTURE_COUNT")
        stat_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        stat_display_event.Add_Dialog_Text("STAT_MINES_COUNT", EvaluatePerception("Mines_Count", human_faction))
        stat_display_event.Add_Dialog_Text(
            "STAT_TRADESTATION_COUNT",
            EvaluatePerception("Tradestation_Count", human_faction)
        )

        for _, faction in pairs(liveFactionTable) do
            stat_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
            stat_display_event.Add_Dialog_Text(CONSTANTS.ALL_FACTION_TEXTS[faction.Get_Faction_Name()])
            stat_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
            stat_display_event.Add_Dialog_Text("STAT_PLANET_COUNT", EvaluatePerception("Planet_Ownership", faction))
            stat_display_event.Add_Dialog_Text("STAT_FORCE_PERCENT", EvaluatePerception("Percent_Forces", faction))
            stat_display_event.Add_Dialog_Text("STAT_INCOME", EvaluatePerception("Current_Income", faction))
            DebugMessage(
                "%s -- Faction %s, planets: %s, forces: %s, income %s",
                tostring(Script),
                faction.Get_Faction_Name(),
                tostring(EvaluatePerception("Planet_Ownership", faction)),
                tostring(EvaluatePerception("Percent_Forces", faction)),
                tostring(EvaluatePerception("Current_Income", faction))
            )
        end
    end
    DebugMessage("Story_Mode_Service GCStatDisplay Finished")
end
