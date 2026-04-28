
--*****************************************************--
--********* Foerost Campaign: Venator Venting *********--
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
		CIS_Victory = State_CIS_Victory,
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")

	b1_squad_list =	{"B1_DROID_SQUAD"}
	b1_marine_squad_list = ("B1_DROID_MARINE_SQUAD")
	b2_squad_list =	{"B2_DROID_SQUAD"}
	bx_squad_list =	{"BX_COMMANDO_TEAM"}
	crab_squad_list = {"CRAB_DROID_COMPANY"}
	dsd_squad_list = {"DWARF_SPIDER_DROID_COMPANY"}
	magna_squad_list = {"MAGNAGUARD_SQUAD"}

	arc_squad_list = {"ARC_PHASE_TWO_TEAM"}
	clone_squad_list = {"CLONETROOPER_PHASE_TWO_TEAM"}
	sd_6_squad_list = {"REPUBLIC_SD_6_DROID_COMPANY"}
	barc_squad_list = {"REPUBLIC_BARC_COMPANY"}
	atpt_squad_list = {"REPUBLIC_AT_PT_COMPANY"}
	atrt_squad_list = {"REPUBLIC_AT_RT_COMPANY"}

	act_1_active = false

	cinematic_one = false
	cinematic_one_skipped = false

	camera_offset = 125
	intro_skipped = false
	mission_started = false

end

function Begin_Battle(message)
	if message == OnEnter then
		deactivated_table = Find_All_Objects_With_Hint("deactivated")
		for i,attes in pairs(deactivated_table) do
			attes.Suspend_Locomotor(true)
		end

		attacker_marker = Find_First_Object("Attacker Entry Position")

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-2")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")

		defender_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-1")
		defender_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-2")
		defender_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-3")
		defender_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-4")
		defender_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-5")
		defender_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-6")
		defender_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-7")
		defender_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-8")
		defender_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-9")
		defender_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-10")

		terminal_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "terminal")
		terminal_marker.Highlight(true)
		Add_Radar_Blip(terminal_marker, "terminal_blip")

		p_cis.Disable_Bombing_Run(false)
		p_republic.Disable_Bombing_Run(false)

		p_cis.Disable_Orbital_Bombardment(true)
		p_republic.Disable_Orbital_Bombardment(true)

		mission_started = true
		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
		end
	end
end


function State_CIS_Victory(message)
	if message == OnEnter then
		GlobalValue.Set("Foerost_CIS_Renown_Conquered", 1)
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

				if p_republic.Get_Difficulty() == "Easy" then
					Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
					
					Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("ELITE_MERCENARY_TEAM"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("ELITE_MERCENARY_TEAM"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("PAC_COMPANY"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)


					SpawnList(arc_squad_list, defender_1_marker, p_republic, true, true)
					SpawnList(arc_squad_list, defender_2_marker, p_republic, true, true)
					SpawnList(clone_squad_list, defender_3_marker, p_republic, true, true)
					SpawnList(clone_squad_list, defender_4_marker, p_republic, true, true)
					SpawnList(atpt_squad_list, defender_5_marker, p_republic, true, true)
					SpawnList(sd_6_squad_list, defender_6_marker, p_republic, true, true)
					SpawnList(atrt_squad_list, defender_7_marker, p_republic, true, true)
					SpawnList(barc_squad_list, defender_8_marker, p_republic, true, true)
					SpawnList(arc_squad_list, defender_9_marker, p_republic, true, true)

				elseif p_republic.Get_Difficulty() == "Hard" then
					Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
					
					Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("ELITE_MERCENARY_TEAM"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("ELITE_MERCENARY_TEAM"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)


					SpawnList(arc_squad_list, defender_1_marker, p_republic, true, true)
					SpawnList(arc_squad_list, defender_2_marker, p_republic, true, true)
					SpawnList(clone_squad_list, defender_3_marker, p_republic, true, true)
					SpawnList(clone_squad_list, defender_4_marker, p_republic, true, true)
					SpawnList(sd_6_squad_list, defender_5_marker, p_republic, true, true)
					SpawnList(sd_6_squad_list, defender_6_marker, p_republic, true, true)
					SpawnList(barc_squad_list, defender_7_marker, p_republic, true, true)
					SpawnList(barc_squad_list, defender_8_marker, p_republic, true, true)
					SpawnList(atpt_squad_list, defender_9_marker, p_republic, true, true)
					SpawnList(atrt_squad_list, defender_10_marker, p_republic, true, true)

				else
					Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)
					
					Reinforce_Unit(Find_Object_Type("ELITE_MERCENARY_TEAM"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("ELITE_MERCENARY_TEAM"), false, p_cis, true, false)
					
					Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)


					SpawnList(arc_squad_list, defender_1_marker, p_republic, true, true)
					SpawnList(arc_squad_list, defender_2_marker, p_republic, true, true)
					SpawnList(clone_squad_list, defender_3_marker, p_republic, true, true)
					SpawnList(clone_squad_list, defender_4_marker, p_republic, true, true)
					SpawnList(atpt_squad_list, defender_5_marker, p_republic, true, true)
					SpawnList(sd_6_squad_list, defender_6_marker, p_republic, true, true)
					SpawnList(atrt_squad_list, defender_7_marker, p_republic, true, true)
					SpawnList(barc_squad_list, defender_8_marker, p_republic, true, true)
					SpawnList(arc_squad_list, defender_9_marker, p_republic, true, true)
					SpawnList(arc_squad_list, defender_10_marker, p_republic, true, true)
				end

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
	end
end

function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_1_active then
			terminal_list = Find_All_Objects_Of_Type("MISSION_CONTROL_PANEL")
			if (table.getn(terminal_list) == 0) then
				GlobalValue.Set("Foerost_CIS_Renown_Conquered", 1)
				Story_Event("RENOWN_CONQUERED")
				Story_Event("REPUBLIC_VICTORY")
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

	cinematic_one = true

	Play_Music("CIS_Tactical_Battle")
	Story_Event("CINEMATIC_CRAWL_01")
	Sleep(3)

	Story_Event("CINEMATIC_CRAWL_02")
	Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 8, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 7, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 7, 0, 0, 8, 0, introcam_target_1_marker, 1, 0)
	Letter_Box_In(0.5)
	Fade_Screen_In(0.5)
	Sleep(6)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end

function End_Cinematic_Intro_CIS()
	Resume_Mode_Based_Music()
	Point_Camera_At(attacker_marker)
	Transition_To_Tactical_Camera(3)
	Lock_Controls(0)
	Suspend_AI(0)
	Sleep(1.5)
	Letter_Box_Out(1.5)
	Sleep(1.5)
	End_Cinematic_Camera()
	Story_Event("GOAL_TRIGGER_CIS_I")
	Story_Event("ACTIVATE_REP_AI")

	Story_Event("SHOWDOWN_01")

	if p_republic.Get_Difficulty() == "Easy" then
		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
					
		Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("ELITE_MERCENARY_TEAM"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("ELITE_MERCENARY_TEAM"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("PAC_COMPANY"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)


		SpawnList(arc_squad_list, defender_1_marker, p_republic, true, true)
		SpawnList(arc_squad_list, defender_2_marker, p_republic, true, true)
		SpawnList(clone_squad_list, defender_3_marker, p_republic, true, true)
		SpawnList(clone_squad_list, defender_4_marker, p_republic, true, true)
		SpawnList(atpt_squad_list, defender_5_marker, p_republic, true, true)
		SpawnList(sd_6_squad_list, defender_6_marker, p_republic, true, true)
		SpawnList(atrt_squad_list, defender_7_marker, p_republic, true, true)
		SpawnList(barc_squad_list, defender_8_marker, p_republic, true, true)
		SpawnList(arc_squad_list, defender_9_marker, p_republic, true, true)

	elseif p_republic.Get_Difficulty() == "Hard" then
		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
					
		Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("ELITE_MERCENARY_TEAM"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("ELITE_MERCENARY_TEAM"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)


		SpawnList(arc_squad_list, defender_1_marker, p_republic, true, true)
		SpawnList(arc_squad_list, defender_2_marker, p_republic, true, true)
		SpawnList(clone_squad_list, defender_3_marker, p_republic, true, true)
		SpawnList(clone_squad_list, defender_4_marker, p_republic, true, true)
		SpawnList(sd_6_squad_list, defender_5_marker, p_republic, true, true)
		SpawnList(sd_6_squad_list, defender_6_marker, p_republic, true, true)
		SpawnList(barc_squad_list, defender_7_marker, p_republic, true, true)
		SpawnList(barc_squad_list, defender_8_marker, p_republic, true, true)
		SpawnList(atpt_squad_list, defender_9_marker, p_republic, true, true)
		SpawnList(atrt_squad_list, defender_10_marker, p_republic, true, true)

	else
		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("ELITE_MERCENARY_TEAM"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("ELITE_MERCENARY_TEAM"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)


		SpawnList(arc_squad_list, defender_1_marker, p_republic, true, true)
		SpawnList(arc_squad_list, defender_2_marker, p_republic, true, true)
		SpawnList(clone_squad_list, defender_3_marker, p_republic, true, true)
		SpawnList(clone_squad_list, defender_4_marker, p_republic, true, true)
		SpawnList(atpt_squad_list, defender_5_marker, p_republic, true, true)
		SpawnList(sd_6_squad_list, defender_6_marker, p_republic, true, true)
		SpawnList(atrt_squad_list, defender_7_marker, p_republic, true, true)
		SpawnList(barc_squad_list, defender_8_marker, p_republic, true, true)
		SpawnList(arc_squad_list, defender_9_marker, p_republic, true, true)
		SpawnList(arc_squad_list, defender_10_marker, p_republic, true, true)
	end

	cinematic_one = false
	act_1_active = true
end
