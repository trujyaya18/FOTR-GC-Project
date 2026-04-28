
--*****************************************************--
--********** Foerost Campaign: Bulwark Brawl **********--
--*****************************************************--

require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")
require("eawx-util/StoryUtil")

function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))

	StoryModeEvents =
	{
		Battle_Start = Begin_Battle,
		Trigger_Showdown_Screed = State_Showdown_Screed,
		Trigger_Screed_Escaped = State_Screed_Escaped,
		Trigger_Showdown_Dodonna = State_Showdown_Dodonna,
		Trigger_Dodonna_Escaped = State_Dodonna_Escaped,
		Trigger_Showdown_Ningo = State_Showdown_Ningo,
		Trigger_Ningo_Escaped = State_Ningo_Escaped,
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")

	act_1_active = false

	generic_battle = false

	screed_dead = false
	screed_present = false

	dodonna_dead = false
	dodonna_present = false

	camera_offset = 125
end

function Begin_Battle(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			scripted_battle_marker = Find_First_Object("SCRIPTED_BATTLE_MARKER")
			if TestValid(scripted_battle_marker) then
				ScriptExit()
			end

			attacker_marker = Find_First_Object("Attacker Entry Position")
			defender_marker = Find_First_Object("Defending Forces Position")
			map_middle_marker = Create_Position(0, 0, 0)

			player_screed = Find_First_Object("Screed_Arlionne")
			player_dodonna = Find_First_Object("Dodonna_Ardent")

			if TestValid(Find_First_Object("Screed_Arlionne")) then
				act_1_active = true
				screed_present = true
				Story_Event("VALID_SCREED")
			elseif not TestValid(Find_First_Object("Screed_Arlionne")) then
				screed_present = false
			end

			if TestValid(Find_First_Object("Dodonna_Ardent")) then
				act_1_active = true
				dodonna_present = true
				Story_Event("VALID_DODONNA")
			elseif not TestValid(Find_First_Object("Dodonna_Ardent")) then
				dodonna_present = false
			end

			if not screed_present and not dodonna_present then
				generic_battle = true -- If no one is here, this ain't the battle you are looking for
			end
		elseif p_republic.Is_Human() then
			scripted_battle_marker = Find_First_Object("SCRIPTED_BATTLE_MARKER")
			if TestValid(scripted_battle_marker) then
				ScriptExit()
			end

			attacker_marker = Find_First_Object("Attacker Entry Position")
			defender_marker = Find_First_Object("Defending Forces Position")
			map_middle_marker = Create_Position(0, 0, 0)

			player_ningo = Find_First_Object("Screed_Arlionne")

			if TestValid(player_ningo) then
				act_1_active = true
				ningo_present = true
				Story_Event("VALID_NINGO")
			elseif not TestValid(player_ningo) then
				ningo_present = false
			end

			if not ningo_present then
				generic_battle = true -- If no one is here, this ain't the battle you are looking for
			end

		end
	end
end


function State_Showdown_Screed(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			if TestValid(Find_First_Object("Screed_Arlionne")) then
				Find_First_Object("Screed_Arlionne").Set_Cannot_Be_Killed(true)
				Add_Objective("TEXT_MISSION_BULWARK_BRAWL_OBJECTIVE_CIS_01", false)
			end
		end
	end
end

function State_Screed_Escaped(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			Find_First_Object("Screed_Arlionne").Hyperspace_Away(true)
			Story_Event("SCREED_RETREAT")
		end
	end
end

function State_Showdown_Dodonna(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			if TestValid(Find_First_Object("Dodonna_Ardent")) then
				Find_First_Object("Dodonna_Ardent").Set_Cannot_Be_Killed(true)
				Add_Objective("TEXT_MISSION_BULWARK_BRAWL_OBJECTIVE_CIS_02", false)
			end
		end
	end
end

function State_Dodonna_Escaped(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			Find_First_Object("Dodonna_Ardent").Hyperspace_Away(true)
			Story_Event("DODONNA_RETREAT")
		end
	end
end

function State_Showdown_Ningo(message)
	if message == OnEnter then
		if p_republic.Is_Human() then
			if TestValid(Find_First_Object("Dua_Ningo_Unrepentant")) then
				Find_First_Object("Dua_Ningo_Unrepentant").Set_Cannot_Be_Killed(true)
				Add_Objective("TEXT_MISSION_BULWARK_BRAWL_OBJECTIVE_REP_01", false)
			end
		end
	end
end

function State_Ningo_Escaped(message)
	if message == OnEnter then
		if p_republic.Is_Human() then
			Find_First_Object("Dua_Ningo_Unrepentant").Hyperspace_Away(true)
			Story_Event("NINGO_RETREAT")
		end
	end
end


function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_1_active then
			if TestValid(Find_First_Object("Screed_Arlionne")) then
				if not screed_dead then
					Find_First_Object("Screed_Arlionne").Set_Cannot_Be_Killed(true)
					if Find_First_Object("Screed_Arlionne").Get_Hull() <= 0.01 then
						Story_Event("SCREED_ESCAPED")
						screed_dead = true
					end
				end
			end
			if TestValid(Find_First_Object("Dodonna_Ardent")) then
				if not dodonna_dead then
					Find_First_Object("Dodonna_Ardent").Set_Cannot_Be_Killed(true)
					if Find_First_Object("Dodonna_Ardent").Get_Hull() <= 0.01 then
						Story_Event("DODONNA_ESCAPED")
						dodonna_dead = true
					end
				end
			end
		end
		if generic_battle then
			if TestValid(Find_First_Object("Screed_Arlionne")) and not screed_present then
				act_1_active = true
				Story_Event("PLAYER_CIS")
				Story_Event("VALID_SCREED")
				generic_battle = false
				screed_present = true
			end
			if TestValid(Find_First_Object("Dodonna_Ardent")) and not dodonna_present then
				act_1_active = true
				Story_Event("PLAYER_CIS")
				Story_Event("VALID_DODONNA")
				generic_battle = false
				dodonna_present = true
			end
		end
	elseif p_republic.Is_Human() then
		if act_1_active then
			if TestValid(Find_First_Object("Dua_Ningo_Unrepentant")) then
				if not ningo_dead then
					if Find_First_Object("Dua_Ningo_Unrepentant").Get_Hull() <= 0.01 then
						Story_Event("NINGO_ESCAPED")
						ningo_dead = true
					end
				end
			end
		end
		if generic_battle then
			if TestValid(Find_First_Object("Dua_Ningo_Unrepentant")) and not ningo_present then
				act_1_active = true
				Story_Event("PLAYER_REP")
				Story_Event("VALID_NINGO")
				generic_battle = false
				ningo_present = true
			end
		end
	end
end
