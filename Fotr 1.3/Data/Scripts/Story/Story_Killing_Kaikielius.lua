
--*****************************************************--
--**** Operation Durge's Lance: Killing Kaikielius ****--
--*****************************************************--

require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")
require("PGCommands")
require("TRCommands")
require("eawx-util/StoryUtil")
require("deepcore/std/class")

function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))

	StoryModeEvents =
	{
		Battle_Start = Begin_Battle,
		Trigger_Grievous_Respawn = State_Grievous_Respawn,
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")

	camera_offset = 125
	mission_started = false

end

function Begin_Battle(message)
	if message == OnEnter then
		Story_Event("ACTIVATE_REP_AI")
	end
end

function State_Grievous_Respawn(message)
	if message == OnEnter then
		GlobalValue.Set("ODL_CIS_Grievous_Respawn", 1)
	end
end
