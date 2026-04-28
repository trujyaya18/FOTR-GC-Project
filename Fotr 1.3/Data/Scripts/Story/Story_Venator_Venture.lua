
--*****************************************************--
--************* Rimward: Venator Venture **************--
--*****************************************************--

require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	StoryModeEvents =
	{
		Battle_Start = Begin_Battle,
		Trigger_Venator_Conquered = State_Venator_Conquered
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")
	p_neutral = Find_Player("Neutral")

	Clone_Team_List = {"CLONETROOPER_PHASE_ONE_TEAM"}
	Navy_Team_List = {"REPUBLIC_NAVY_TROOPER_SQUAD"}
	Jumpies_Team_List = {"CLONE_JUMPTROOPER_PHASE_ONE_SQUAD"}
	LAAT_Team_List = {"REPUBLIC_LAAT_GROUP"}
	ATRT_Team_List = {"REPUBLIC_AT_RT_COMPANY"}
	ATTE_Team_List = {"Republic_AT_TE_Walker_Company"}
	AV7_Team_List = {"REPUBLIC_AV7_COMPANY"}

	B2_Jetpack_Team_List = {"B2_RP_Droid_Company"}
	B2_Team_List = {"B2_DROID_SQUAD"}

	explosion_list = {"HUGE_EXPLOSION_LAND"}

	act_1_active = false

	cinematic_one = false
	cinematic_two = false

	cinematic_one_skipped = false
	cinematic_two_skipped = false

	camera_offset = 125
	intro_skipped = false
	mission_started = false
end

function Begin_Battle(message)
	if message == OnEnter then
		attacker_marker = Find_Hint("ATTACKER ENTRY POSITION")

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-4")
		introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-5")
		introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-6")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")

		outrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-1")
		outrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-2")
		outrocam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-3")

		outrocam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-1")
		outrocam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-2")

		defender_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-1")
		defender_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-2")
		defender_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-3")
		defender_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-4")
		defender_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-5")
		defender_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-6")
		defender_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-7")

		p_generator = Find_Hint("GENERIC_POWER_GENERATOR", "generator")

		p_cis.Remove_Orbital_Bombardment(true)
		p_republic.Remove_Orbital_Bombardment(true)

		fog_id = FogOfWar.Reveal(p_cis, attacker_marker.Get_Position(), 20000, 20000)

		mission_started = true
		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
		end
	end
end


function State_Venator_Conquered(message)
	if message == OnEnter then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")
	end
end


function Story_Handle_Esc()
	if p_cis.Is_Human() then
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
				SFXManager.Allow_Localized_SFXEvents(true)
				SFXManager.Allow_Unit_Reponse_VO(true)
				SFXManager.Allow_Enemy_Sighted_VO(true)

				SpawnList(B2_Jetpack_Team_List, attacker_marker, p_cis, true, true)
				SpawnList(B2_Jetpack_Team_List, attacker_marker, p_cis, true, true)
				SpawnList(B2_Jetpack_Team_List, attacker_marker, p_cis, true, true)
				SpawnList(B2_Jetpack_Team_List, attacker_marker, p_cis, true, true)
				SpawnList(B2_Jetpack_Team_List, attacker_marker, p_cis, true, true)

				SpawnList(B2_Team_List, attacker_marker, p_cis, true, true)
				SpawnList(B2_Team_List, attacker_marker, p_cis, true, true)
				SpawnList(B2_Team_List, attacker_marker, p_cis, true, true)

				Letter_Box_Out(0)
				Point_Camera_At(attacker_marker)
				Story_Event("GOAL_TRIGGER_CIS_I")
				Story_Event("ACTIVATE_REP_AI")
				Lock_Controls(0)
				Suspend_AI(0)
				End_Cinematic_Camera()
				Resume_Mode_Based_Music()

				cinematic_one = false
				act_1_active = true

				Fade_Screen_In(0.5)
				Sleep(0.5)
			end
		end
		if cinematic_two then
			if not cinematic_two_skipped then
				cinematic_two_skipped = true
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
				SFXManager.Allow_Localized_SFXEvents(true)
				SFXManager.Allow_Unit_Reponse_VO(true)
				SFXManager.Allow_Enemy_Sighted_VO(true)
				Resume_Mode_Based_Music()

				Story_Event("CIS_VICTORY")
			end
		end
	end
end

function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_1_active then
			local cis_list = Find_All_Objects_Of_Type(p_cis, "Vehicle | Infantry | Air | Structure")
			if (table.getn(cis_list) == 0) then
				p_cis.Remove_Orbital_Bombardment(false)
				p_republic.Remove_Orbital_Bombardment(false)
				Story_Event("REPUBLIC_VICTORY")
			end
			if not TestValid(p_generator) then
				Story_Event("VENATOR_CONQUERED")
			end
		end
	end
end


function Start_Cinematic_Intro_CIS()
	Start_Cinematic_Camera()
	Lock_Controls(1)
	Cancel_Fast_Forward()
	Suspend_AI(1)
	Stop_All_Music()
	Remove_All_Text()
	Fade_On()

	Reinforce_Unit(Find_Object_Type("CIS_STAP_SQUAD"), false, p_cis)
	Reinforce_Unit(Find_Object_Type("CIS_STAP_SQUAD"), false, p_cis)
	Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis)
	Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis)
	Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis)
	Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis)
	Reinforce_Unit(Find_Object_Type("B2_RP_Droid_Company"), false, p_cis)
	Reinforce_Unit(Find_Object_Type("B2_RP_Droid_Company"), false, p_cis)
	Reinforce_Unit(Find_Object_Type("B2_RP_Droid_Company"), false, p_cis)
	Reinforce_Unit(Find_Object_Type("B2_RP_Droid_Company"), false, p_cis)
	Reinforce_Unit(Find_Object_Type("B2_RP_Droid_Company"), false, p_cis)
	Reinforce_Unit(Find_Object_Type("B2_RP_Droid_Company"), false, p_cis)
	Reinforce_Unit(Find_Object_Type("B2_RP_Droid_Company"), false, p_cis)
	Reinforce_Unit(Find_Object_Type("B2_Droid_Squad"), false, p_cis)
	Reinforce_Unit(Find_Object_Type("B2_Droid_Squad"), false, p_cis)
	Reinforce_Unit(Find_Object_Type("B2_Droid_Squad"), false, p_cis)
	Reinforce_Unit(Find_Object_Type("B2_Droid_Squad"), false, p_cis)
	Reinforce_Unit(Find_Object_Type("B2_Droid_Squad"), false, p_cis)
	Reinforce_Unit(Find_Object_Type("B2_Droid_Squad"), false, p_cis)

	SpawnList(Navy_Team_List, defender_1_marker, p_republic, true, true)
	SpawnList(Jumpies_Team_List, defender_2_marker, p_republic, true, true)
	SpawnList(Jumpies_Team_List, defender_2_marker, p_republic, true, true)
	SpawnList(Jumpies_Team_List, defender_2_marker, p_republic, true, true)
	SpawnList(Jumpies_Team_List, defender_2_marker, p_republic, true, true)
	SpawnList(Jumpies_Team_List, defender_2_marker, p_republic, true, true)
	SpawnList(Jumpies_Team_List, defender_2_marker, p_republic, true, true)
	SpawnList(Jumpies_Team_List, defender_2_marker, p_republic, true, true)
	SpawnList(Jumpies_Team_List, defender_2_marker, p_republic, true, true)
	SpawnList(Jumpies_Team_List, defender_2_marker, p_republic, true, true)
	SpawnList(Jumpies_Team_List, defender_2_marker, p_republic, true, true)
	SpawnList(Jumpies_Team_List, defender_2_marker, p_republic, true, true)
	SpawnList(Jumpies_Team_List, defender_2_marker, p_republic, true, true)
	SpawnList(Jumpies_Team_List, defender_2_marker, p_republic, true, true)
	SpawnList(Jumpies_Team_List, defender_2_marker, p_republic, true, true)
	SpawnList(Jumpies_Team_List, defender_2_marker, p_republic, true, true)
	SpawnList(Jumpies_Team_List, defender_2_marker, p_republic, true, true)
	SpawnList(LAAT_Team_List, defender_3_marker, p_republic, true, true)
	SpawnList(ATRT_Team_List, defender_4_marker, p_republic, true, true)
	SpawnList(Clone_Team_List, defender_5_marker, p_republic, true, true)
	SpawnList(Clone_Team_List, defender_6_marker, p_republic, true, true)
	SpawnList(Clone_Team_List, defender_7_marker, p_republic, true, true)

	cinematic_one = true

	Play_Music("Venator_Venture_01")
	Sleep(1)
	Remove_All_Text()

	Story_Event("CINEMATIC_CRAWL_01")

	Set_Cinematic_Camera_Key(introcam_6_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_6_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_5_marker, 9, 0, 0, -800, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_5_marker, 9, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)

	Letter_Box_In(2.5)
	Fade_Screen_In(2.5)
	Sleep(3)

	Story_Event("CINEMATIC_CRAWL_02")
	Sleep(6)

	Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_4_marker, 7, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_4_marker, 7, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Sleep(7)

	Set_Cinematic_Camera_Key(introcam_2_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_2_marker, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_1_marker, 4, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_1_marker, 4, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)

	SpawnList(B2_Jetpack_Team_List, attacker_marker, p_cis, true, true)
	SpawnList(B2_Jetpack_Team_List, attacker_marker, p_cis, true, true)
	SpawnList(B2_Jetpack_Team_List, attacker_marker, p_cis, true, true)
	SpawnList(B2_Jetpack_Team_List, attacker_marker, p_cis, true, true)
	SpawnList(B2_Jetpack_Team_List, attacker_marker, p_cis, true, true)

	SpawnList(B2_Team_List, attacker_marker, p_cis, true, true)
	SpawnList(B2_Team_List, attacker_marker, p_cis, true, true)
	SpawnList(B2_Team_List, attacker_marker, p_cis, true, true)

	Sleep(4)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end

function End_Cinematic_Intro_CIS()
	Point_Camera_At(attacker_marker)
	Transition_To_Tactical_Camera(3)
	Resume_Mode_Based_Music()
	Lock_Controls(0)
	Suspend_AI(0)
	Sleep(1.5)
	Letter_Box_Out(1.5)
	Sleep(1.5)
	End_Cinematic_Camera()
	Story_Event("GOAL_TRIGGER_CIS_I")
	Story_Event("ACTIVATE_REP_AI")

	cinematic_one = false
	act_1_active = true
end

function Start_Cinematic_Outro_CIS()
	p_cis.Remove_Orbital_Bombardment(false)
	p_republic.Remove_Orbital_Bombardment(false)

	act_1_active = false
	cinematic_two = true

	Fade_Screen_Out(0.5)
	Sleep(1)
	Suspend_AI(1)
	Lock_Controls(1)
	Start_Cinematic_Camera()
	Letter_Box_In(0)
	Stop_All_Music()
	Cancel_Fast_Forward()

	Do_End_Cinematic_Cleanup()

	Allow_Localized_SFX(false)
	SFXManager.Allow_HUD_VO(false)
	SFXManager.Allow_Ambient_VO(false)
	SFXManager.Allow_Localized_SFXEvents(false)
	SFXManager.Allow_Unit_Reponse_VO(false)
	SFXManager.Allow_Enemy_Sighted_VO(false)

	Letter_Box_In(2.0)
	Fade_Screen_In(2.0)
	Play_Music("Venator_Venture_02")
	Set_Cinematic_Camera_Key(outrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_1_marker, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(outrocam_2_marker, 8.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_2_marker, 8.0, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Sleep(8)

	if TestValid(Find_First_Object("TR_SHIP_Venator_Damaged_Small")) then
		Find_First_Object("TR_SHIP_Venator_Damaged_Small").Play_Animation("Cinematic", false)
	end

	Set_Cinematic_Camera_Key(outrocam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_3_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Cinematic_Zoom(12, 6.0)
	Sleep(4)

	Allow_Localized_SFX(true)
	SFXManager.Allow_HUD_VO(true)
	SFXManager.Allow_Ambient_VO(true)
	SFXManager.Allow_Localized_SFXEvents(true)
	SFXManager.Allow_Unit_Reponse_VO(true)
	SFXManager.Allow_Enemy_Sighted_VO(true)
	Resume_Mode_Based_Music()

	Fade_Screen_Out(4)
	Sleep(5)

	Story_Event("CIS_VICTORY")
end
