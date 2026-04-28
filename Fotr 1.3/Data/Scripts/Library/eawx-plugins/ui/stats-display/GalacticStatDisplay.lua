require("deepcore/std/class")
require("eawx-util/StoryUtil")
CONSTANTS = ModContentLoader.get("GameConstants")

---@class GalacticStatDisplay
GalacticStatDisplay = class()

---@param galactic_conquest GalacticConquest
function GalacticStatDisplay:new(galactic_conquest)
    self.galactic_conquest = galactic_conquest
    self.persistent_units = require("hardpoint-lists/PersistentLibrary")
    self.id = string.lower(GlobalValue.Get("MOD_ID"))
    self.DevastatorTable = {}

    local plot_name = StoryUtil.PlayerAgnosticPlots.Galactic
    local plot = Get_Story_Plot(plot_name)
    DebugMessage("GalacticStatDisplay::new -- story plot is %s", tostring(plot))

    local stat_display_click_event = plot.Get_Event("Stat_Display_Clicked")
    stat_display_click_event.Set_Reward_Parameter(1, self.galactic_conquest.HumanPlayer.Get_Faction_Name())

    ---@private
    self.stat_display_event = plot.Get_Event("Show_Stat_Display")
    DebugMessage("GalacticStatDisplay::new -- stat display event is %s", tostring(self.stat_display_event))
end

function GalacticStatDisplay:update()
    DebugMessage("GalacticStatDisplay::update -- update started")
    self.stat_display_event.Clear_Dialog_Text()

    self.stat_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    self.stat_display_event.Add_Dialog_Text("Economic Structures:")
    self.stat_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
	
	self.stat_display_event.Add_Dialog_Text(
        "STAT_TAX_COUNT",
        EvaluatePerception("Tax_Count", self.galactic_conquest.HumanPlayer)
    )
	
    self.stat_display_event.Add_Dialog_Text(
        "STAT_MINES_COUNT",
        EvaluatePerception("Mines_Count", self.galactic_conquest.HumanPlayer)
    )

    self.stat_display_event.Add_Dialog_Text(
        "STAT_TRADESTATION_COUNT",
        EvaluatePerception("Tradestation_Count", self.galactic_conquest.HumanPlayer)
    )
	
	self.stat_display_event.Add_Dialog_Text("TEXT_NONE")
	
    if self.id ~= "rev" then
        self.stat_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        self.stat_display_event.Add_Dialog_Text("Persistent Damage for Super Star Destroyers:")
        self.stat_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        for unit, specs in pairs(self.persistent_units[1]) do
            local objects = Find_All_Objects_Of_Type(unit)
            if table.getn(objects) > 0 then
                for _,object in pairs(objects) do
                    local player = object.Get_Owner()
                    if player.Is_Human() then
                        local id = unit.."_"..tostring(object.Get_Owner().Get_Faction_Name())
                        local current_damage = GlobalValue.Get(id)
                        if current_damage then
                            self.stat_display_event.Add_Dialog_Text(specs[3].." - "..Dirty_Floor(current_damage * 100).."%%")
                        end
                    end
                end
            end
        end
    end

    if self.id == "icw" and Find_Player("Empire").Is_Human() then
        self.DevastatorTable ={
            {"KLEV_FRIGATE_DEVASTATOR", "KLEV_CAPITAL_DEVASTATOR", "KLEV_BATTLECRUISER_DEVASTATOR"},
            {"WORLD_DEVASTATOR_FRIGATE", "WORLD_DEVASTATOR_CAPITAL", "WORLD_DEVASTATOR_BATTLECRUISER"}
        }
        for _, devastator_table in pairs(self.DevastatorTable) do
            for i, devastator in pairs(devastator_table) do
                if GlobalValue.Get(devastator) > 0 and i < 3 then
                    self.stat_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
                    self.stat_display_event.Add_Dialog_Text("Active World Devastator Material Collected: " .. tostring(GlobalValue.Get(devastator)))
                    self.stat_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
 
                end
            end
        end

    end
    
	self.stat_display_event.Add_Dialog_Text("TEXT_NONE")
	self.stat_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")

    self.stat_display_event.Add_Dialog_Text("STAT_FACTIONS")

    local number_of_planets_per_faction = self.galactic_conquest.Number_Of_Owned_Planets_By_Faction

    for faction_name, number_of_owned_planets in pairs(number_of_planets_per_faction) do
        if number_of_owned_planets ~= 0 then
            local faction = Find_Player(faction_name)

            if not faction then
                DebugMessage("GalacticStatDisplay::update -- could not find faction %s", tostring(faction_name))
            end

            self.stat_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
            self.stat_display_event.Add_Dialog_Text(CONSTANTS.ALL_FACTION_TEXTS[faction_name])
            self.stat_display_event.Add_Dialog_Text("STAT_PLANET_COUNT", number_of_owned_planets)

            local force_percentage = self:evaluate_or_zero_for_neutral("Percent_Forces", faction)
            local income = self:evaluate_or_zero_for_neutral("Current_Income", faction)
            local upkeep = tonumber(Dirty_Floor(self:evaluate_or_zero_for_neutral("Total_Maintenance", faction)))
            local credits = faction.Get_Credits()

            self.stat_display_event.Add_Dialog_Text("STAT_FORCE_PERCENT", force_percentage)
            self.stat_display_event.Add_Dialog_Text("STAT_INCOME", income)
            self.stat_display_event.Add_Dialog_Text("STAT_UPKEEP", upkeep)
            self.stat_display_event.Add_Dialog_Text("STAT_CREDITS", credits)

            DebugMessage(
                "GalacticStatDisplay::update -- Faction %s, planets: %s, forces: %s, income %s, upkeep %s",
                faction_name,
                tostring(number_of_owned_planets),
                tostring(force_percentage),
                tostring(income),
                tostring(upkeep)
            )
        end
    end

    Story_Event("SHOW_STAT_DISPLAY")
end

---@private
---@param perception string
---@param faction PlayerObject
function GalacticStatDisplay:evaluate_or_zero_for_neutral(perception, faction)
    if faction == Find_Player("Neutral") then
        return 0
    end

    return EvaluatePerception(perception, faction)
end
