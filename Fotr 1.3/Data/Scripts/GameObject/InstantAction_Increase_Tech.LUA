--//////////////////////////////////////////////////////////////////////////////////////
-- Add Units to the reinforcement pool// This script is part of the Survival Mode
-- © Pox
--//////////////////////////////////////////////////////////////////////////////////////

require("PGBase")
require("PGStateMachine")
require("PGStoryMode")
require("eawx-std/class")
StoryUtil = require("eawx-util/StoryUtil")

function Definitions()
	
	DebugMessage("%s -- In Definitions", tostring(Script))

	Define_State("State_Init", State_Init);


end


function State_Init(message)
	if message == OnEnter then
		if Get_Game_Mode() ~= "Space" then
			ScriptExit()
		end
		local era = GlobalValue.Get("CURRENT_ERA")
		if era == nil then
			era = 1
		end
		GlobalValue.Set("CURRENT_ERA", era+1)
		StoryUtil.ShowScreenText("Era: " .. tostring(era), 5)
		ScriptExit()
		
	end
end