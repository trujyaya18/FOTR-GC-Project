require("deepcore/crossplot/crossplot")
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
        Government_Setup = Government_Display_Setup
    }

    setup_complete = false
    human_faction = nil
end

function Government_Display_Setup(message)
    if message == OnEnter then
        plot = Get_Story_Plot("GCGovernmentDisplay.xml")

        DebugMessage("%s -- plot is %s", tostring(Script), tostring(plot))

        government_display_event = plot.Get_Event("Government_Display")
        crossplot:galactic()
        local human = Find_Player("local")
        if human == Find_Player("Empire") then
            crossplot:subscribe("empire-government-updated", update_empire_display)
        elseif human == Find_Player("Rebel") then
            crossplot:subscribe("rebel-government-updated", update_rebel_display)
        end

        DebugMessage("%s -- event is %s", tostring(Script), tostring(government_display_event))

        setup_complete = true
    elseif message == OnUpdate then
        crossplot:update()
    end
end

function update_empire_display(legitimacy_table)
    DebugMessage("%s -- Updating imperial government display", tostring(Script))
    government_display_event.Clear_Dialog_Text()

    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE")
    for faction_name, legitimacy_value in pairs(legitimacy_table) do
        government_display_event.Add_Dialog_Text(
            "TEXT_GOVERNMENT_LEGITIMACY",
            CONSTANTS.ALL_FACTION_TEXTS[string.upper(faction_name)],
            legitimacy_value
        )
    end
end

function update_rebel_display()
    DebugMessage("%s -- Updating New Republic government display", tostring(Script))
    government_display_event.Clear_Dialog_Text()

    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_NEW_REPUBLIC")
    government_display_event.Add_Dialog_Text(
        "TEXT_GOVERNMENT_CURRENT_COS",
        Find_Object_Type(GlobalValue.Get("ChiefOfState"))
    )
    government_display_event.Add_Dialog_Text(
        "TEXT_GOVERNMENT_SUPPORTED_COS",
        Find_Object_Type(GlobalValue.Get("ChiefOfStatePreference"))
    )
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_NEW_REPUBLIC_CANDIDATES")
    government_display_event.Add_Dialog_Text("TEXT_TOOLTIP_NONE")
    -- Always options
    government_display_event.Add_Dialog_Text("TEXT_HERO_LEIA")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REQUIREMENTS_NONE")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_LEIA_EFFECT")
    government_display_event.Add_Dialog_Text("TEXT_TOOLTIP_NONE")
    government_display_event.Add_Dialog_Text("TEXT_HERO_MON_MOTHMA")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REQUIREMENTS_NONE")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_MOTHMA_EFFECT")
    government_display_event.Add_Dialog_Text("TEXT_HERO_BORSK")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REQUIREMENTS_NONE")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_FEYLYA_EFFECT")
    --government_display_event.Add_Dialog_Text("TEXT_HERO_GAVRISOM")
    --government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REQUIREMENTS_NONE")
    --government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_GAVRISOM_EFFECT")
    -- Not always options
    --government_display_event.Add_Dialog_Text("TEXT_HERO_SHESH")
    --government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REQUIREMENTS_KUAT")
    --government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_SHESH_EFFECT")
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_NEW_REPUBLIC_OVERVIEW")
end
