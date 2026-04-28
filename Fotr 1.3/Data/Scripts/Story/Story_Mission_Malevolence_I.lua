
--*****************************************************--
--*** Hunt for the Malevolence: Mission Malevolence ***--
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
		Trigger_Malevolence_Escaped = State_Malevolence_Escaped,
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")

	camera_offset = 125

	act_1_active = false
	act_2_active = false

	current_cinematic_thread_id = nil

	cinematic_one = false
	cinematic_one_skipped = false

	malevolence_present = false
	malevolence_escaped = false
	generic_battle = false
end

function Begin_Battle(message)
	if message == OnEnter then
		if p_republic.Is_Human() then
			attacker_marker = Find_First_Object("Attacker Entry Position")
			defender_marker = Find_First_Object("Defending Forces Position")
			player_grievous = Find_First_Object("Grievous_Malevolence_Hunt_Campaign")

			if TestValid(player_grievous) then
				Story_Event("PLAYER_REP")
				malevolence_present = true
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
			elseif not TestValid(player_grievous) then
				malevolence_present = false
				generic_battle = true -- If the Malevolence isn't there, this ain't the battle you are looking for
			end
		end
	end
end


function State_Malevolence_Escaped(message)
	if message == OnEnter then
		Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Hyperspace_Away(false)
		Story_Event("ALLOW_STUFF")
		Sleep(3)
		Story_Event("COWARD")
		--Find_Player("Rebel").Retreat()
	end
end


function Story_Handle_Esc()
	if p_republic.Is_Human() then
		if cinematic_one then
			if not cinematic_one_skipped then
				cinematic_one_skipped = true
				-- MessageBox("Escape Key Pressed!!!")

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				Fade_Screen_Out(0)
				Stop_All_Music()
				Stop_All_Speech()
				Remove_All_Text()
				Stop_Bink_Movie()
				Allow_Localized_SFX(true)
				SFXManager.Allow_HUD_VO(true)
				SFXManager.Allow_Ambient_VO(true)
				SFXManager.Allow_Enemy_Sighted_VO(true)
				SFXManager.Allow_Unit_Reponse_VO(true)
				Resume_Mode_Based_Music()

				player_grievous.Set_Cannot_Be_Killed(true)

				GlobalValue.Set("HfM_Battle_Counter", 1)
				Add_Objective("TEXT_MISSION_MISSION_MALEVOLENCE_OBJECTIVE_REP_01", false)
				Add_Objective("TEXT_MISSION_MISSION_MALEVOLENCE_OBJECTIVE_REP_02", false)

				Story_Event("ACTIVATE_CIS_AI")
				Lock_Controls(0)
				Suspend_AI(0)
				End_Cinematic_Camera()

				cinematic_one = false
				act_1_active = true
			end
		end
	end
end

function Story_Mode_Service()
	if p_republic.Is_Human() then
		if act_1_active then
			if Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Get_Hull() <= 0.95 and not malevolence_escaped then
				malevolence_escaped = true
				Story_Event("MALEVOLENCE_ESCAPED")
			end
			cis_is_retreating = EvaluatePerception("Enemy_Retreating", p_republic)
			if (cis_is_retreating ~= 0) then
				if TestValid(Find_First_Object("Grievous_Malevolence_Hunt_Campaign")) then
					Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Hyperspace_Away(false)
					Story_Event("COWARD")
					Story_Event("ALLOW_STUFF")
				end
			end
			republic_list_01 = Find_All_Objects_Of_Type(p_republic, "SpaceHero | Corvette | Capital | Frigate | SpaceStructure | SuperCapital")
			if (table.getn(republic_list_01) == 0) then
				Story_Event("CIS_VICTORY")
			end
		end
		if generic_battle then
			if TestValid(Find_First_Object("Grievous_Malevolence_Hunt_Campaign")) and not malevolence_present then
				malevolence_present = true
				generic_battle = false
				Story_Event("PLAYER_REP")
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
			end
		end
	end
end


function Start_Cinematic_Intro_Rep()
	cinematic_one = true

	Start_Cinematic_Camera()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()
	Stop_All_Music()
	Fade_On()

	Play_Music("Galactic_Death_Star_Complete_Music_Event")
	Story_Event("SHOWDOWN")

	introcam_1_marker = Create_Position(0, 0, 0)
	Set_Cinematic_Camera_Key(attacker_marker, 3000, -500, 1000, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(attacker_marker, 0, 0, 0, 0, player_grievous, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_1_marker, 20, -300, -100, 300, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_1_marker, 20, 0, 0, 0, 0, player_grievous, 1, 0)
	Fade_Screen_In(0.5)
	Letter_Box_In(0.5)
	Sleep(6)

	Resume_Mode_Based_Music()
	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Rep")
	end
end

function End_Cinematic_Intro_Rep()
	Transition_To_Tactical_Camera(3)
	Letter_Box_Out(3)
	Fade_Screen_In(.1)
	Sleep(3.0)
	End_Cinematic_Camera()
	Suspend_AI(0)
	Lock_Controls(0)

	cinematic_one = false
	act_1_active = true

	Story_Event("ACTIVATE_CIS_AI")
	player_grievous.Set_Cannot_Be_Killed(true)

	GlobalValue.Set("HfM_Battle_Counter", 1)
	Add_Objective("TEXT_MISSION_MISSION_MALEVOLENCE_OBJECTIVE_REP_01", false)
	Add_Objective("TEXT_MISSION_MISSION_MALEVOLENCE_OBJECTIVE_REP_02", false)
end