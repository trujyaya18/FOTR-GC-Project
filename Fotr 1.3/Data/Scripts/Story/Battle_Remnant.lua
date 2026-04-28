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
--*   @Date:                2017-12-14T10:54:01+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            Survival_Remnant.lua
--*   @Last modified by:    [TR]Pox
--*   @Last modified time:  2017-12-21T13:18:54+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************



require("PGBase")
require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
CONSTANTS = ModContentLoader.get("GameConstants")

------------------------------------------------------------------------------------------------


function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))

	StoryModeEvents = { Setup_Start = Begin_GC,
						Battle_Start = Begin_Battle}

	GlobalValue.Set("CURRENT_ERA", 1)

end


function Begin_GC(message)
	if message == OnEnter then

		
		for _, faction in pairs(CONSTANTS.ALL_FACTIONS_NOT_NEUTRAL) do
            local faction_object = Find_Player(faction)
            for _, second_faction in pairs(CONSTANTS.ALL_FACTIONS_NOT_NEUTRAL) do
				if faction ~= second_faction then
					local second_faction_object = Find_Player(second_faction)
					faction_object.Make_Ally(second_faction_object)
				end
            end
        end
		 
	end
end

function Begin_Battle(message)
	if message == OnEnter then
		
		for _, faction in pairs(CONSTANTS.ALL_FACTIONS_NOT_NEUTRAL) do
            local faction_object = Find_Player(faction)
            for _, second_faction in pairs(CONSTANTS.ALL_FACTIONS_NOT_NEUTRAL) do
				if faction ~= second_faction then
					local second_faction_object = Find_Player(second_faction)
					faction_object.Make_Enemy(second_faction_object)
				end
            end
        end
	end
end









