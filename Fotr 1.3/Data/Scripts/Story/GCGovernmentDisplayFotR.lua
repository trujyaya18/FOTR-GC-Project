require("PGStoryMode")
require("PGBase")

CONSTANTS = ModContentLoader.get("GameConstants")
require("TRCommands")

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

        DebugMessage("%s -- event is %s", tostring(Script), tostring(government_display_event))

        setup_complete = true
    end
end

function Story_Mode_Service()
    DebugMessage("%s -- Servicing script", tostring(Script))

    if setup_complete == true then
        DebugMessage("%s -- Refreshing perceptions", tostring(Script))
        government_display_event.Clear_Dialog_Text()

        if Find_Player("Empire").Is_Human() then
            government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
            government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC")
            government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_CURRENT_APPROVAL", GlobalValue.Get("RepublicApprovalRating"))
            government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_CURRENT_CHANCELLOR", Find_Object_Type(GlobalValue.Get("ChiefOfState")))
            government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
            government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_FUNCTION")
            government_display_event.Add_Dialog_Text("TEXT_TOOLTIP_NONE")  
            government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
            government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_SECTORFORCES")

        elseif Find_Player("Rebel").Is_Human() then
            government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
            government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_CIS")
            government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_CIS_FUNCTION")
            government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
            government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_CIS_MEMBERCORPS")

            liveFactionTable = {
                Find_Player("Commerce_Guild"),
                Find_Player("Banking_Clan"),
                Find_Player("Trade_Federation"),
                Find_Player("Techno_Union")
            }

            for _, faction in pairs(liveFactionTable) do
                numPlanets = EvaluatePerception("Planet_Ownership", faction)

                government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
                government_display_event.Add_Dialog_Text(CONSTANTS.ALL_FACTION_TEXTS[faction.Get_Faction_Name()])
                government_display_event.Add_Dialog_Text("STAT_PLANET_COUNT", numPlanets)

                if faction == Find_Player("Commerce_Guild") then
                    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_CIS_APPROVAL", GlobalValue.Get("CommerceApprovalRating"))
                elseif faction == Find_Player("Trade_Federation") then
                    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_CIS_APPROVAL", GlobalValue.Get("TradeFedApprovalRating"))
                elseif faction == Find_Player("Techno_Union") then
                    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_CIS_APPROVAL", GlobalValue.Get("TechnoApprovalRating"))
                elseif faction == Find_Player("Banking_Clan") then
                    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_CIS_APPROVAL", GlobalValue.Get("IGBCApprovalRating"))
                end
            end

        elseif Find_Player("EARLY_IMPERIAL").Is_Human() then
             government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
            government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC")
            government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_CURRENT_APPROVAL", GlobalValue.Get("RepublicApprovalRating"))
            government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_CURRENT_CHANCELLOR", Find_Object_Type(GlobalValue.Get("ChiefOfState")))
            government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
            government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_FUNCTION")
            government_display_event.Add_Dialog_Text("TEXT_TOOLTIP_NONE")  
            government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
            government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_SECTORFORCES")
        end
    end
end
