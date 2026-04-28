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
--*   @Date:                2017-12-18T14:01:25+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            ChangeOwnerUtilities.lua
--*   @Last modified by:    Mord
--*   @Last modified time:  2022-08-29T01:36:27-05:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************

require("PGBase")
require("PGStateMachine")
CONSTANTS = ModContentLoader.get("GameConstants")

---Changes the owner of a given list of planets or a single planet. All units from these planets are transfered to an allied planet
---@param planets PlanetObject|PlanetObject[]
---@param newOwner PlayerObject
function ChangePlanetOwnerAndRetreat(planets, newOwner)
    DebugMessage("ChangePlanetOwnerAndRetreat STARTED")
    if type(planets) ~= "table" then
        planets = {planets}
    end

    ---@type GameObject[]
    local unitTypes = {}

    ---@type PlayerObject[]
    local unitOwners = {}
    set_hero_death_enabled(false)

    ---@type table<PlayerObject, GameObject[]>
    local allUnitsPerOwner = {}

    for i, planet in pairs(planets) do
        local owner = planet.Get_Owner()
		
		if owner ~= Find_Player("Neutral") then
			insert_all_enemy_units_on_planet(allUnitsPerOwner, owner, planet)

			if not allUnitsPerOwner[owner] then
				allUnitsPerOwner[owner] = get_friendly_units_on_planet(owner, planet)
			end

			-- local allUnitsOfCurrentOwner = allUnitsPerOwner[owner]
			for player, units in pairs(allUnitsPerOwner) do
				insert_into_spawn_tables(unitTypes, unitOwners, units, planet)
			end
		end

        planet.Change_Owner(newOwner)
    end

    spawn_units_on_friendly_location(unitTypes, unitOwners)
    set_hero_death_enabled(true)
end

function insert_all_enemy_units_on_planet(allUnitsPerOwner, planet_owner, planet)
	for _, enemy_faction in pairs(CONSTANTS.ALL_FACTIONS) do
		local enemy_faction_obj = Find_Player(enemy_faction)
		if enemy_faction_obj ~= planet_owner then
			local friendly_units_on_planet = get_friendly_units_on_planet(enemy_faction_obj, planet)

			if table.getn(friendly_units_on_planet) > 0 then
			    allUnitsPerOwner[enemy_faction_obj] = friendly_units_on_planet
            end
        end
    end
end

---Changes the owner of a given list of planets or a single planet. All units from these planets are replaced with the same units set to the new owner
---@param planets PlanetObject|PlanetObject[]
---@param newOwner PlayerObject
function ChangePlanetOwnerAndReplace(planets, newOwner)
    DebugMessage("ChangePlanetOwnerAndReplace STARTED")
    if type(planets) ~= "table" then
        planets = {planets}
    end

    ---@type GameObject[]
    local friendlyUnitTypes = {}

    ---@type PlayerObject[]
    local friendlyUnitOwners = {}

    ---@type GameObject[]
    local unitTypes = {}

    ---@type PlayerObject[]
    local unitOwners = {}
    set_hero_death_enabled(false)

    ---@type table<PlayerObject, GameObject[]>
    local allUnitsPerOwner = {}

    for i, planet in pairs(planets) do
        local owner = planet.Get_Owner()
		
		if owner ~= Find_Player("Neutral") then
			if not allUnitsPerOwner[owner] then
				allUnitsPerOwner[owner] = Find_All_Objects_Of_Type(owner)
			end

			insert_all_enemy_units_on_planet(allUnitsPerOwner, owner, planet)

			local allUnitsOfCurrentOwner = allUnitsPerOwner[owner]
			insert_into_spawn_tables(friendlyUnitTypes, friendlyUnitOwners, allUnitsOfCurrentOwner, planet)

			allUnitsPerOwner[owner] = nil
			for player, units in pairs(allUnitsPerOwner) do
				insert_into_spawn_tables(unitTypes, unitOwners, units, planet)
			end
		end

        planet.Change_Owner(newOwner)

        spawn_units_on_target_location(friendlyUnitTypes, planet, newOwner)
        spawn_units_on_friendly_location(unitTypes, unitOwners)
    end

    set_hero_death_enabled(true)
end

---@param player PlayerObject
---@param planet PlanetObject
function get_friendly_units_on_planet(player, planet)
    local all_units_of_player = Find_All_Objects_Of_Type(player) or {}
    local friendly_units_on_planet = {}
    for _, unit in pairs(all_units_of_player) do
        if should_insert_into_spawn_table(unit, planet) then
            local relevant_object = get_relevant_object(unit)
            table.insert(friendly_units_on_planet, relevant_object)
        end
    end

    return friendly_units_on_planet
end

function insert_into_spawn_tables(unit_types_table, unit_owners_table, all_units_of_owner, planet)
    local owner

    for i, unit in pairs(all_units_of_owner) do
        if should_insert_into_spawn_table(unit, planet) then
            if not owner then
                owner = unit.Get_Owner()
            end

            local relevant_object = get_relevant_object(unit)
            if TestValid(relevant_object) then
                DebugMessage(
                    "Relevant object: %s Planet: %s Owner: %s",
                    relevant_object.Get_Type().Get_Name(),
                    planet.Get_Type().Get_Name(),
                    owner.Get_Faction_Name()
                )
                table.insert(unit_types_table, relevant_object.Get_Type())
                table.insert(unit_owners_table, owner)
                all_units_of_owner[i] = nil
                relevant_object.Despawn()
            else
                DebugMessage("Could not find the relevant object for unit %s", unit.Get_Type().Get_Name())
            end
        end
    end
end

---Returns true if the unit is valid, has a valid category and is located on the sepcified planet
---@param unit GameObject
---@param planet PlanetObject
function should_insert_into_spawn_table(unit, planet)
    return TestValid(unit) and unit.Get_Planet_Location() == planet and is_valid_category(unit)
end

---Returns the object necessary to spawn an instance of the unit on the GC map. If the unit is in a company it will return the company. Otherwise returns the object
---@param unit GameObject The unit
function get_relevant_object(unit)
    if is_in_company(unit) then
        return unit.Get_Parent_Object()
    end

    return unit
end

---Returns true if the unit is part of a company
---@param unit GameObject
function is_in_company(unit)
    local parent = unit.Get_Parent_Object()
    local planet = unit.Get_Planet_Location()
    return parent and parent ~= planet and parent.Get_Type() ~= Find_Object_Type("Galactic_Fleet")
end

---Enables or disables tracking of hero deaths
---@param enabled boolean
function set_hero_death_enabled(enabled)
    if enabled then
        Story_Event("ENABLE_HERO_DEATH_EVENTS")
    else
        Story_Event("DISABLE_HERO_DEATH_EVENTS")
    end
end

---Spawns units on a friendly planet if possible
---@param unitTypes GameObjectType[]
---@param unitOwners PlayerObject[]
function spawn_units_on_friendly_location(unitTypes, unitOwners)
    local owner_spawn_target = {}
    local human_location
    for unit_index, unit_type in ipairs(unitTypes) do
        local owner = unitOwners[unit_index]
        if not owner_spawn_target[owner] then
            owner_spawn_target[owner] = StoryUtil.FindFriendlyPlanet(owner)
        end

        local friendly_planet = owner_spawn_target[owner]
        if TestValid(friendly_planet) then
            if owner.Is_Human() then
                human_location = friendly_planet
            end
            DebugMessage("Spawning unit type %s on %s", unit_type.Get_Name(), friendly_planet.Get_Type().Get_Name())
            unit = Spawn_Unit(unit_type, friendly_planet, owner)
			unit[1].Prevent_AI_Usage(false)
        end
    end

    if human_location then
        StoryUtil.ShowScreenText("TEXT_SINGLE_UNIT_RETREAT_PLANET", 5, human_location, {r = 255, g = 255, b = 255})
    end
end

---Spawns units on a target planet
---@param unitTypes GameObjectType[]
---@param planet PlanetObject
---@param owner PlayerObject[]
function spawn_units_on_target_location(unitTypes, planet, owner)
    for _, unit_type in ipairs(unitTypes) do
        if TestValid(planet) then
            DebugMessage("Spawning unit type %s on %s", unit_type.Get_Name(), planet.Get_Type().Get_Name())
            unit = Spawn_Unit(unit_type, planet, owner)
			unit[1].Prevent_AI_Usage(false)
        end
    end
end

---Returns true if the unit has a category that allows moving to a different planet
---@param unit GameObject
function is_valid_category(unit)
    local validCategories = {
        "Fighter",
        "Bomber",
        -- "Transport",
        "Corvette",
        "Frigate",
        "Capital",
        "SuperCapital",
        "Infantry",
        "Vehicle",
        "Air",
        "LandHero",
        "SpaceHero",
        "NonCombatHero"
    }

    if not unit.Is_Category then
        return false
    end

    for _, category in pairs(validCategories) do
        if unit.Is_Category(category) then
            return true
        end
    end

    return false
end

function Destroy_Planet(planet)
    if type(planet) == "string" then
        planet = FindPlanet(planet)
    end

    if TestValid(planet) then
        local pk_fleet = {
            "Dummy_Planet_Killer"
        }

        local hostile_player = Find_Player("Hostile")

        local pk_unit_list = SpawnList(pk_fleet, planet, hostile_player, false, false)
        local pk_fleet = Assemble_Fleet(pk_unit_list)

        local pk_list = Find_All_Objects_Of_Type("Dummy_Planet_Killer")
        local pk = pk_list[1]

        pk.Set_Check_Contested_Space(false)
        pk.Activate_Ability("Dummy_Planet_Killer")
        pk.Set_Check_Contested_Space(true)

        local checkpk = Find_First_Object("Dummy_Planet_Killer")

        if TestValid(checkpk) then
            checkpk.Despawn()
        end
    end
end