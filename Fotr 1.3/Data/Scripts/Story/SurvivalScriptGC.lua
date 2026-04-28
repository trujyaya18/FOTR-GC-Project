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
--*   @Author:              Kiwi
--*   @Date:                2017-08-20T21:31:11+02:00
--*   @Project:             Imperial Civil War
--*   @Filename:            SurvivalScriptGC.lua
--*   @Last modified by:    Kiwi
--*   @Last modified time:  2017-12-21T13:18:32+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************



require("PGStateMachine")
require("PGStoryMode")

function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))
	StoryModeEvents = {
		Universal_Story_Start = Begin_GC
	}
    GlobalValue.Set("CURRENT_ERA", 4)

end


function Begin_GC(message)
	if message == OnEnter then
		-- plot = Get_Story_Plot("Conquests\\Survival\\Story_Sandbox_Survival.XML")
		-- plot.Get_Event("SurvivalBattle")
		-- plot.Set_Reward_Parameter(2,Find_Player("local").Get_Faction_Name())
		Story_Event("START_SURVIVAL")
	elseif message == OnUpdate then
		Story_Event("MODE_END")
	end
end
