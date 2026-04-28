require("PGStoryMode")
require("RandomGCSpawnCW")
require("deepcore/crossplot/crossplot")

function Definitions()

    DebugMessage("%s -- In Definitions", tostring(Script))
    StoryModeEvents = {
		Universal_Story_Start = Spawn_Starting_Forces,
		Delayed_Initialize = Initialize
	}
	
end		

function Spawn_Starting_Forces(message)
    if message == OnEnter then		
	
		p_newrep = Find_Player("Rebel")
		p_empire = Find_Player("Empire")
		p_eoth = Find_Player("Underworld")
		p_eriadu = Find_Player("Techno_Union")
		p_pentastar = Find_Player("Banking_Clan")
		p_zsinj = Find_Player("Trade_Federation")
		p_maldrood = Find_Player("Commerce_Guild")
		p_corporate = Find_Player("Sector_Forces")

		if p_newrep.Is_Human() then
			Story_Event("ENABLE_BRANCH_NEWREP_FLAG")
		elseif p_empire.Is_Human() then
			Story_Event("ENABLE_BRANCH_EMPIRE_FLAG")
		elseif p_eoth.Is_Human() then
			Story_Event("ENABLE_BRANCH_EOTH_FLAG")
		elseif p_eriadu.Is_Human() then
			Story_Event("ENABLE_BRANCH_ERIADU_FLAG")
		elseif p_pentastar.Is_Human() then
			Story_Event("ENABLE_BRANCH_PENTASTAR_FLAG")
		elseif p_zsinj.Is_Human() then
			Story_Event("ENABLE_BRANCH_ZSINJ_FLAG")
		elseif p_maldrood.Is_Human() then
			Story_Event("ENABLE_BRANCH_TERADOC_FLAG")
		elseif p_corporate.Is_Human() then
			Story_Event("ENABLE_BRANCH_CORPORATE_SECTOR_FLAG")
		end
		
		if not p_newrep.Is_Human() then
			Story_Event("SET_CIS_TECH")
		end
		
		if not p_empire.Is_Human() then
			Story_Event("SET_REP_TECH")
		end
		
			--Randomly spawn units at all planets owned by neutral or hostile
			--Probably want some screen text to tell the player the game is loading still
		local p_independent = Find_Player("Independent_Forces")
		local p_neutral = Find_Player("Neutral")
		local planet = nil
		local scaled_combat_power = 7500
		
		for _, planet in pairs(FindPlanet.Get_All_Planets()) do	
			if planet.Get_Owner() == (p_neutral or p_independent) then	
				scaled_combat_power = 7500 * EvaluatePerception("GenericPlanetValue", p_independent, planet) * (1.5 - EvaluatePerception("Is_Connected_To_Player", p_independent, planet))
				ChangePlanetOwnerAndPopulate(planet, p_independent, scaled_combat_power, false)
			end
		end
	
	end
end