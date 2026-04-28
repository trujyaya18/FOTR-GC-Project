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
StoryUtil = require("eawx-util/StoryUtil")

UnitUtil = {
    __important = true,
    PlayerAgnosticPlots = {
        Galactic = "Conquests\\Player_Agnostic_Plot.xml",
        Space = "Conquests\\Tactical_Raids.XML",
		Land = "Conquests\\GroundTactical\\Tactical_GroundBattles.XML"
    }
}

function UnitUtil.GetPlayerAgnosticPlot()
    local plotName = UnitUtil.PlayerAgnosticPlots[Get_Game_Mode()]
    return Get_Story_Plot(plotName)
end


function UnitUtil.SetLockList(faction, lock_list, state)

    local player = Find_Player(faction)

    for _, unit in pairs(lock_list) do
        if TestValid(Find_Object_Type(unit)) then
            DebugMessage("Locking %s for %s", tostring(unit), tostring(player))
            if state == false then
                player.Lock_Tech(Find_Object_Type(unit))
            else
                player.Unlock_Tech(Find_Object_Type(unit))
            end
        end
    end

    return
end

function UnitUtil.ReplaceAtLocation(original, upgrade)
    local checkObject = Find_First_Object(original)
    if TestValid(checkObject) then
        local planet = checkObject.Get_Planet_Location()
        local objectOwner = checkObject.Get_Owner()
        checkObject.Despawn()
        if not planet then
            planet = StoryUtil.FindFriendlyPlanet(objectOwner)
        end
        local spawnList = {upgrade}
        SpawnList(spawnList, planet, objectOwner, true, false)
    end
end

function UnitUtil.SpawnAtObjectLocation(target, object)
    local checkObject = Find_First_Object(target)
    if TestValid(checkObject) then
        local planet = checkObject.Get_Planet_Location()
        local objectOwner = checkObject.Get_Owner()
        if not planet then
            planet = StoryUtil.FindFriendlyPlanet(objectOwner)
        end
        local spawnList = {object}
        SpawnList(spawnList, planet, objectOwner, true, false)
    end
end

function UnitUtil.DespawnList(despawn_list)
    for _, object in pairs(despawn_list) do
        checkObject = Find_First_Object(object)
        if TestValid(checkObject) then
            checkObject.Despawn()
        end
    end
end

function UnitUtil.SetBuildable(player, unitType, state)
    local player_name = string.upper(player.Get_Faction_Name())

    local plot = Get_Story_Plot("Conquests\\Factional_Buildable_"..player_name..".xml")

    if not plot then
        return
    end

    local buildableUnitEvent = plot.Get_Event("ENABLE_BUILDABLE_"..player_name)
    local tag = "ENABLE_BUILDABLE_"..player_name
    
    if state == false then
        buildableUnitEvent = plot.Get_Event("DISABLE_BUILDABLE_"..player_name)
        tag = "DISABLE_BUILDABLE_"..player_name
    end

    if not buildableUnitEvent then
        return
    end

    buildableUnitEvent.Set_Reward_Parameter(0, unitType)
    Story_Event(tag)
    

end

return UnitUtil
