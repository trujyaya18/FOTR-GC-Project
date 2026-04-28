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
--*   @Date:                2017-12-22T10:19:56+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            DisplayManager.lua
--*   @Last modified by:    [TR]Pox
--*   @Last modified time:  2018-03-17T02:25:08+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************

require("deepcore/std/class")
require("eawx-util/StoryUtil")
require("eawx-plugins/ui/galactic-display/DisplayStructuresUtilities")

---@class PlanetInformationDisplayComponent
PlanetInformationDisplayComponent = class()

function PlanetInformationDisplayComponent:new(influence_service, selectedPlanetChangedEvent, productionFinishedEvent)
    ---@private
    ---@type string[]
    self.current_text = {}

    ---@private
    ---@type Planet
    self.selected_planet = nil

    ---@private
    self.__needs_update = false

    ---@type InfluenceService
    self.influence_service = influence_service

    selectedPlanetChangedEvent:attach_listener(self.on_selected_planet_changed, self)
    productionFinishedEvent:attach_listener(self.on_production_finished, self)
end

function PlanetInformationDisplayComponent:needs_update()
    return self.__needs_update
end

---@private
---@param planet Planet
function PlanetInformationDisplayComponent:on_production_finished(planet)
    if planet ~= self.selected_planet or not planet:get_owner().Is_Human() then
        return
    end

    self.__needs_update = true
end

---@private
---@param planet Planet
function PlanetInformationDisplayComponent:on_selected_planet_changed(planet)
    self.selected_planet = planet
    self.__needs_update = true
end

function PlanetInformationDisplayComponent:render()
    self.__needs_update = false

    if not self.selected_planet then
        return
    end

    local owner = self.selected_planet:get_owner()
    local owner_name = owner.Get_Faction_Name()
    local color = CONSTANTS.FACTION_COLORS[owner_name]

    self:clear()
    self:render_basic_planet_information(owner_name, color)
    self:render_influence_information(color)
    
    if not self.selected_planet:get_owner().Is_Human() then
        return
    end

    self:render_structure_information(color)
    
end

---@private
function PlanetInformationDisplayComponent:render_basic_planet_information(owner_name, color)
    local owner_text = CONSTANTS.ALL_FACTION_TEXTS[owner_name]
	StoryUtil.ShowScreenText("=============   PLANET   INFORMATION   =============", -1, nil, {r = 160, g = 160, b = 164}, false)
    StoryUtil.ShowScreenText("TEXT_SELECTED_PLANET", -1, self.selected_planet:get_game_object(), color)
	StoryUtil.ShowScreenText(owner_text, -1, nil, color)
    self.current_text = {"TEXT_SELECTED_PLANET", owner_text}
end

---@private
function PlanetInformationDisplayComponent:render_structure_information(color)
    local structures_on_planet = self.selected_planet:get_orbital_structure_information()

    for structure_text, amount in pairs(structures_on_planet) do
        table.insert(self.current_text, structure_text)
        local number = GameObjectNumber(amount)
        if number then
            StoryUtil.ShowScreenText(structure_text, -1, number, color)
        end
    end
end

---@private
function PlanetInformationDisplayComponent:render_influence_information(color)
    local influence_on_planet = self.influence_service:get_influence_for_planet(self.selected_planet)
    local unrest_on_planet = self.influence_service:get_unrest_for_planet(self.selected_planet)
    local taxation_level = self.influence_service:get_tax_for_planet(self.selected_planet)
    local influence_level = GameObjectNumber(influence_on_planet)

    if influence_level then
        StoryUtil.ShowScreenText("TEXT_INFLUENCE_AMOUNT", -1, influence_level, color)
        if unrest_on_planet > 0 then
            local unrest_level = GameObjectNumber(unrest_on_planet)
            StoryUtil.ShowScreenText("TEXT_UNREST_AMOUNT", -1, unrest_level, color)
            table.insert(self.current_text, "TEXT_UNREST_AMOUNT")
        end 
        StoryUtil.ShowScreenText("Taxation Level: "..tostring(taxation_level).." ( -"..tostring(2*taxation_level).." influence)", -1, nil, color)
        table.insert(self.current_text, "Taxation Level: "..tostring(taxation_level).." ( -"..tostring(2*taxation_level).." influence)")
    end

    table.insert(self.current_text, "TEXT_INFLUENCE_AMOUNT")
end

---@private
function PlanetInformationDisplayComponent:clear()
    for _, text in pairs(self.current_text) do
        StoryUtil.RemoveScreenText(text)
    end
end

return PlanetInformationDisplayComponent
