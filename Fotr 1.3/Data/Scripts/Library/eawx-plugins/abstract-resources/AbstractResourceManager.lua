--**************************************************************************************************
--*    _______ __                                                                                  *
--*   |_     _|  |--.----.---.-.--.--.--.-----.-----.                                              *
--*     |   | |     |   _|  _  |  |  |  |     |__ --|                                              *
--*     |___| |__|__|__| |___._|________|__|__|_____|                                              *
--*    ______                                                                                      *
--*   |   __ \.-----.--.--.-----.-----.-----.-----.                                                *
--*   |      <|  -__|  |  |  -__|     |  _  |  -__|                                                *
--*   |___|__||_____|\___/|_____|__|__|___  |_____|                                                *
--*                                   |_____|                                                      *
--*                                                                                                *
--*                                                                                                *
--*       File:              AbstractResourceManager.lua                                           *
--*       File Created:      Sunday, 23rd February 2020 08:26                                      *
--*       Author:            [TR] Corey                                                            *
--*       Last Modified:     Sunday, 23rd February 2020 10:22                                      *
--*       Modified By:       [TR] Corey                                                            *
--*       Copyright:         Thrawns Revenge Development Team                                      *
--*       License:           This code may not be used without the author's explicit permission    *
--**************************************************************************************************
require("pgevents")
require("pgbase")
require("deepcore/std/class")
require("deepcore/std/Observable")
require("eawx-std/HelperDialogue")
StoryUtil = require("eawx-util/StoryUtil")
CONSTANTS = ModContentLoader.get("GameConstants")

---@class AbstractResourceManager
AbstractResourceManager = class()

---@param gc GalacticConquest
---@param dummy_lifecycle_handler KeyDummyLifeCycleHandler
---@param resource_manager LockBasedResourceManager
function AbstractResourceManager:new(gc, dummy_lifecycle_handler, resource_manager)
    self.plot = Get_Story_Plot("Conquests\\Player_Agnostic_Plot.xml")

    GlobalValue.Set("FIGHTER_PILOTS", 100)

    self.galactic_conquest = gc
    self.human_player = gc.HumanPlayer 
    self.human_player_name = self.human_player.Get_Name()
    self.dummy_lifecycle_handler = dummy_lifecycle_handler
    self.resource_manager = resource_manager
    self.AllPlanets = FindPlanet.Get_All_Planets()
	
    self.ShipCrewIncome = 0
    self.ShipCrewIncomeDisplay = "TEXT_RESOURCE_" .. tostring(self.ShipCrewIncome)

    self.InfrastructureScore = 0
    self.InfrastructureScoreEffect = {}
    self.InfrastructureScoreEffectOld = {}

    self.extension_bonus = 10
    self.open_slots = 0
    self.total_slots = 0
    self.open_slot_percentage = 0 

    self.UpkeepCost = 0
    self.NetIncome = 0
    self.Initialized = false

    gc.Events.PlanetOwnerChanged:attach_listener(self.on_planet_owner_changed, self)
    gc.Events.GalacticProductionFinished:attach_listener(self.on_production_finished, self)
    gc.Events.TacticalBattleEnded:attach_listener(self.on_battle_end, self)

    crossplot:subscribe("UPDATE_RESOURCES", self.UpdateDisplay, self)

    self.abstract_changed_event = Observable()
    self.infrastructure_event = Observable()

end

function AbstractResourceManager:update()
    --Logger:trace("entering AbstractResourceManager:update")

    self:shipcrews()  
	self:determine_infrastructure_score()
	self:charge_upkeep()
	self:apply_infrastructure_effect()
    self:check_upkeep()
end

function AbstractResourceManager:on_planet_owner_changed(planet, new_owner_name, old_owner_name)
    --Logger:trace("entering AbstractResourceManager:on_planet_owner_changed")
    if new_owner_name ~= self.human_player_name and old_owner_name ~= self.human_player_name then
        return
    end

    self:check_upkeep()
end

function AbstractResourceManager:on_production_finished(planet, game_object_type_name)
    --Logger:trace("entering AbstractResourceManager:on_production_finished")
    if planet:get_owner() ~= self.human_player then
        return
    end
	
	self:check_upkeep()
end

function AbstractResourceManager:on_battle_end(mode)
    --Logger:trace("entering AbstractResourceManager:on_battle_end")
    self:check_upkeep()
end

function AbstractResourceManager:check_upkeep()
    --Logger:trace("entering AbstractResourceManager:check_upkeep")

    self.UpkeepCost = tonumber(Dirty_Floor(EvaluatePerception("Total_Maintenance", self.human_player)))
    self.NetIncome = tonumber(Dirty_Floor(EvaluatePerception("Current_Income", self.human_player) - self.UpkeepCost))

    self.abstract_changed_event:notify(self.UpkeepCost, self.InfrastructureScore, self.NetIncome)
end

function AbstractResourceManager:determine_infrastructure_score()
    self.extension_bonus = 10
    self.open_slots = 0
    self.total_slots = 0
	self.InfrastructureScore = 0

    for _, planet in pairs(self.AllPlanets) do
        if planet.Get_Owner() == self.human_player then

            self.extension_bonus = self.extension_bonus - 2

            self.total_slots = self.total_slots + EvaluatePerception("Total_Slots", self.human_player, planet)

            self.open_slots = self.open_slots + EvaluatePerception("Open_Slots", self.human_player, planet)
			
			self.InfrastructureScore = self.InfrastructureScore + EvaluatePerception("Infrastructure_Score", self.human_player, planet)

           
        end
    end
    self.open_slot_percentage = tonumber(Dirty_Floor(self.open_slots/self.total_slots*100))

    self.InfrastructureScore = self.InfrastructureScore + self.extension_bonus
end

function AbstractResourceManager:apply_infrastructure_effect()
	if self.InfrastructureScoreEffect ~= nil then
        self.dummy_lifecycle_handler:remove_from_dummy_set(self.human_player, self.InfrastructureScoreEffect)
    end

    local resource_effect_table = {
        {INFRASTRUCTURE_DEFICIT_SMALL = 1},
        {INFRASTRUCTURE_DEFICIT_SEVERE = 1},
        {INFRASTRUCTURE_SURPLUS = 1}
    }
    self.InfrastructureScoreEffectOld = self.InfrastructureScoreEffect
	
	if self.InfrastructureScore < 0 and self.InfrastructureScore > -30 then
        self.InfrastructureScoreEffect = resource_effect_table[1] 
        if self.InfrastructureScoreEffect ~= self.InfrastructureScoreEffectOld then
            self.infrastructure_event:notify("deficit") 
        end
    elseif self.InfrastructureScore <= -30 then
        self.InfrastructureScoreEffect = resource_effect_table[2]
        if self.InfrastructureScoreEffect ~= self.InfrastructureScoreEffectOld then
            self.infrastructure_event:notify("deficit") 
        end
    elseif self.open_slot_percentage < 0.05 then
        self.InfrastructureScoreEffect = resource_effect_table[3]
        if self.InfrastructureScoreEffect ~= self.InfrastructureScoreEffectOld then
            self.infrastructure_event:notify("surplus") 
        end
    else
        self.InfrastructureScoreEffect = {} 
    end

    if self.InfrastructureScoreEffect ~= nil then
        self.dummy_lifecycle_handler:add_to_dummy_set(self.human_player, self.InfrastructureScoreEffect) 
    end
end

function AbstractResourceManager:shipcrews()
    --Logger:trace("entering AbstractResourceManager:shipcrews")

    self.ShipCrewIncome = (10 * EvaluatePerception("NavalAcademy_Count", self.human_player)) + (30 * EvaluatePerception("CloningFacility_Count", self.human_player))

    if self.human_player == Find_Player("Rebel") then
        local chief_of_state = GlobalValue.Get("ChiefOfState")
        if chief_of_state ==  "DUMMY_CHIEFOFSTATE_MOTHMA" then
            self.ShipCrewIncome = tonumber(Dirty_Floor(self.ShipCrewIncome * 1.15))
        end
    end

    self.ShipCrewIncomeDisplay = "Ship Crews Per Cycle: " .. tostring(self.ShipCrewIncome)
    
    self.resource_manager:add_resources(self.ShipCrewIncome)
end

function AbstractResourceManager:charge_upkeep()
	if self.UpkeepCost > EvaluatePerception("Current_Credits", self.human_player) then
		self.InfrastructureScore = self.InfrastructureScore - 50
	end
	if self.Initialized == true then
	    self.human_player.Give_Money(-1.0 * self.UpkeepCost)
        local cruel_on = GlobalValue.Get("CRUEL_ON")

        for _, faction in pairs(CONSTANTS.PLAYABLE_FACTIONS) do
                local faction_object = Find_Player(faction)
                local difficulty = faction_object.Get_Difficulty()
                local Difficulty_Modifier = 1

                if difficulty == "Easy" then
                    Difficulty_Modifier = 0.6
                end

                if faction_object ~= Find_Player("local") then
                    local faction_upkeep = tonumber(Dirty_Floor(EvaluatePerception("Total_Maintenance", faction_object)))
                    local faction_income = Difficulty_Modifier * EvaluatePerception("Current_Income", faction_object)
                    local net_credits = faction_income - faction_upkeep 
                    if EvaluatePerception("Current_Credits", faction_object) > 10000 and faction_income > ( 2 * faction_upkeep) then
                        faction_object.Give_Money(-1.0 * faction_upkeep)
                        if difficulty == "Easy" and cruel_on == 0 then
                            if net_credits > ( 1.5 * self.NetIncome) then
                                faction_object.Give_Money(-1 * (net_credits - (1.5 * self.NetIncome)))
                            end
                        end
                    else
                        faction_object.Give_Money(-0.5 * faction_income)
                    end
                end
        end
    end
    self.Initialized = true

end

function AbstractResourceManager:UpdateDisplay()
    --Logger:trace("entering AbstractResourceManager:UpdateDisplay")
   
    local resource_display_event = self.plot.Get_Event("Resource_Display")

    resource_display_event.Clear_Dialog_Text()
    resource_display_event.Add_Dialog_Text("TEXT_NONE")
    resource_display_event.Add_Dialog_Text("TEXT_RESOURCES_OVERVIEW")
    resource_display_event.Add_Dialog_Text("TEXT_NONE")
	resource_display_event.Add_Dialog_Text("TEXT_RESOURCES_PREVIOUS")
    resource_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    
    resource_display_event.Add_Dialog_Text("STAT_SHIPCREWS_NAME")
	resource_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_SEPARATOR_MEDIUM")
    resource_display_event.Add_Dialog_Text("STAT_SHIPCREWS_DESCRIPTION") 
    resource_display_event.Add_Dialog_Text(self.ShipCrewIncomeDisplay)

    resource_display_event.Add_Dialog_Text("TEXT_NONE")
	
    resource_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")

    resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_NAME")
	resource_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_SEPARATOR_MEDIUM")
    resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_DESCRIPTION") 
    resource_display_event.Add_Dialog_Text("TEXT_NONE") 
	resource_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
	resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_SCORE", self.InfrastructureScore,  self.open_slot_percentage)
    resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_EXTENSION", self.extension_bonus)
	resource_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    resource_display_event.Add_Dialog_Text("TEXT_NONE")
    resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_FACTORS")
	resource_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_BASE")
    resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_CONTROL")
    resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_EMPTY_SLOTS")
    resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_FILLED_SLOTS")
    resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_STRUCTURE")
	resource_display_event.Add_Dialog_Text("TEXT_NONE")
    resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_EFFECTS")
	resource_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_NEGATIVE_1")
	resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_NEGATIVE_2")
	resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_POSITIVE")

    Story_Event("RESOURCE_DISPLAY")
end

return AbstractResourceManager