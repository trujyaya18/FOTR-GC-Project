--//////////////////////////////////////////////////////////////////////////////////////
-- Add Units to the reinforcement pool// This script is part of the Survival Mode
-- � Pox
--//////////////////////////////////////////////////////////////////////////////////////

require("IA_Spawn_Generic")

function Definitions()
	
	DebugMessage("%s -- In Definitions", tostring(Script))

	-- possible units to spawn
	unit_table = {
		"KOMRK_GUNSHIP_SQUADRON",
		"LIGHT_MINSTREL_YACHT",
		"HEAVY_MINSTREL_YACHT",
		"KALOTH_BATTLECRUISER",
		"GEONOSIAN_CRUISER",
		"SUPER_TRANSPORT_VII",
		"SUPER_TRANSPORT_VI",
		"JUVARD_FRIGATE",
		"BARABBULA_FRIGATE",
		"KOSSAK_FRIGATE",
		"CALAMARI_CRUISER_LINER",
		"SPACE_ARC_CRUISER",
		"SUPER_TRANSPORT_XI",
		"HOME_ONE_TYPE_LINER",
		"GENERIC_TAGGE_BATTLECRUISER"
	}

	Define_State("State_Init", State_Init);


end


function State_Init(message)
	if message == OnEnter then
		IA_Spawn(Object.Get_Type().Get_Name(), "INSTANTACTION_MARKER_CSA", "Sector_Forces", unit_table)
		ScriptExit()
		
	end
end