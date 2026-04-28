
--*****************************************************--
--******* Operation Durge's Lance: Jyvus Joyride ******--
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
		Trigger_Keggle_Escaped = State_Keggle_Escaped,
		Trigger_Keggle_Captured = State_Keggle_Captured,
		Trigger_Grievous_Respawn = State_Grievous_Respawn,
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")

	b1_squad_list =	{"B1_DROID_SQUAD"}
	b1_marine_squad_list = ("B1_DROID_MARINE_SQUAD")
	b2_squad_list =	{"B2_DROID_SQUAD"}
	bx_squad_list =	{"BX_COMMANDO_TEAM"}
	crab_squad_list = {"CRAB_DROID_COMPANY"}
	dsd_squad_list = {"DWARF_SPIDER_DROID_COMPANY"}
	magna_squad_list = {"MAGNAGUARD_SQUAD"}

	duros_squad_list = {"DUROS_COMPANY"}
	army_squad_list = {"MILITARY_SOLDIER_TEAM"}
	scavenger_squad_list = {"SCAVENGER_TEAM"}
	arc_squad_list = {"ARC_PHASE_ONE_TEAM"}
	heavy_scavenger_squad_list = {"HEAVY_SCAVENGER_TEAM"}
	police_responder_squad_list = {"POLICE_RESPONDER_TEAM"}
	clone_squad_list = {"CLONETROOPER_PHASE_ONE_TEAM"}
	early_espo_squad_list = {"ESPO_WALKER_EARLY_SQUAD"}
	overracer_squad_list = {"OVERRACER_SPEEDER_BIKE_COMPANY"}
	atpt_squad_list = {"REPUBLIC_AT_PT_COMPANY"}
	atrt_squad_list = {"REPUBLIC_AT_RT_COMPANY"}

	current_cinematic_thread_id = nil

	act_1_active = false
	act_2_active = false

	cinematic_one = false
	cinematic_two = false
	cinematic_two_alt = false

	cinematic_one_skipped = false
	cinematic_two_skipped = false
	cinematic_two_alt_skipped = false

	keggle_hangar_reached = false
	keggle_captured = false
	shuttle_arrived = false
	mission_over = false

	initial_units_spawned = false

	terminal_1_destroyed = false
	terminal_2_destroyed = false
	terminal_3_destroyed = false

	num_reinforcements = 0
	allowed_reinforcements = 10
	reinforcement_delay = 90

	camera_offset = 125
	intro_skipped = false
	mission_started = false

end

function Begin_Battle(message)
	if message == OnEnter then
		GlobalValue.Set("ODL_CIS_Jyvus_Joyride_Outcome", 0)

		intro_keggle_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-keggle")
		intro_captain_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-captain")

		intro_keggle_move_to_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-keggle-move-to")

		outro_keggle_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-keggle")
		outro_grievous_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-grievous")
		outro_tactical_droid_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-tactical-droid")

		cis_squad_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-squad-1")
		cis_squad_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-squad-2")
		cis_squad_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-squad-3")
		cis_squad_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-squad-4")
		cis_squad_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-squad-5")
		cis_squad_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-squad-6")
		cis_squad_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-squad-7")
		cis_squad_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-squad-8")

		cis_reinforcements_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-reinforcements-1")
		cis_reinforcements_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-reinforcements-2")
		cis_reinforcements_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-reinforcements-3")

		defender_phase_1_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-1-1")
		defender_phase_1_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-1-2")
		defender_phase_1_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-1-3")
		defender_phase_1_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-1-4")
		defender_phase_1_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-1-5")
		defender_phase_1_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-1-6")
		defender_phase_1_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-1-7")
		defender_phase_1_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-1-8")
		defender_phase_1_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-1-9")

		defender_phase_1_arc_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-1-arc-1")
		defender_phase_1_arc_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-1-arc-2")
		defender_phase_1_arc_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-1-arc-3")

		defender_phase_2_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-2-1")
		defender_phase_2_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-2-2")
		defender_phase_2_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-2-3")
		defender_phase_2_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-2-4")
		defender_phase_2_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-2-5")

		defender_phase_2_arc_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-2-arc-1")
		defender_phase_2_arc_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-2-arc-2")

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-4")
		introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-5")
		introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-6")
		introcam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-7")
		introcam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-8")
		introcam_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-9")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")

		outrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-1")
		outrocam_1_alt_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-1-alt")
		outrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-2")
		outrocam_2_alt_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-2-alt")
		outrocam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-3")
		outrocam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-4")
		outrocam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-5")
		outrocam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-6")
		outrocam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-7")
		outrocam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-8")
		outrocam_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-9")
		outrocam_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-10")
		outrocam_11_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-11")
		outrocam_12_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-12")
		outrocam_13_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-13")
		outrocam_14_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-14")
		outrocam_15_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-15")
		outrocam_16_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-16")
		outrocam_17_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-17")
		outrocam_18_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-18")
		outrocam_19_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-19")

		outrocam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-1")
		outrocam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-2")

		rep_shuttle_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-shuttle")
		cis_shuttle_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-shuttle")

		player_keggle = Find_First_Object("HOOLIDAN_KEGGLE")
		player_captain = Find_Hint("ARC_PHASE_ONE_OFFICER_SPAWNER", "captain")

		p_terminal_1 = Find_Hint("MISSION_CONTROL_PANEL", "terminal-1")
		p_terminal_2 = Find_Hint("MISSION_CONTROL_PANEL", "terminal-2")
		p_terminal_3 = Find_Hint("MISSION_CONTROL_PANEL", "terminal-3")

		p_cis.Disable_Bombing_Run(false)
		p_republic.Disable_Bombing_Run(false)

		p_cis.Disable_Orbital_Bombardment(true)
		p_republic.Disable_Orbital_Bombardment(true)

		mission_started = true
		if p_republic.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
		elseif p_cis.Is_Human() then
			GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 0)
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
		end
	end
end


function State_Terminal_1_Destroyed()
	terminal_1_destroyed = true
	SpawnList(bx_squad_list, cis_reinforcements_1_marker, p_cis, false, true)

	if terminal_1_destroyed and terminal_2_destroyed and terminal_3_destroyed then
		Create_Thread("State_Hangar_Showdown")
	end
end

function State_Terminal_2_Destroyed()
	terminal_2_destroyed = true
	SpawnList(magna_squad_list, cis_reinforcements_2_marker, p_cis, false, true)

	if terminal_1_destroyed and terminal_2_destroyed and terminal_3_destroyed then
		Create_Thread("State_Hangar_Showdown")
	end
end

function State_Terminal_3_Destroyed()
	terminal_3_destroyed = true
	SpawnList(crab_squad_list, cis_reinforcements_3_marker, p_cis, false, true)

	if terminal_1_destroyed and terminal_2_destroyed and terminal_3_destroyed then
		Create_Thread("State_Hangar_Showdown")
	end
end

function State_Hangar_Showdown()
	blast_door_list = Find_All_Objects_Of_Type("MISSION_MAGNETIC_BLAST_DOOR_BIG")
	for k, blast_doors in pairs(blast_door_list) do
		if TestValid(blast_doors) then
			blast_doors.Play_SFX_Event("SFX_UMP_EmpireKesselAlarm")
			blast_doors.Play_Animation("Cinematic", false, 1)
			Sleep(3.0)
			blast_doors.Despawn()
		end
	end
	act_1_active = false
	act_2_active = true
	Story_Event("GOAL_TRIGGER_CIS_II")
	Story_Event("HANGAR_SHOWDOWN")

	Add_Radar_Blip(player_keggle, "keggle_blip")
	player_keggle.Highlight(true)

	SpawnList(army_squad_list, defender_phase_2_1_marker, p_republic, true, true)
	SpawnList(army_squad_list, defender_phase_2_2_marker, p_republic, true, true)
	SpawnList(clone_squad_list, defender_phase_2_3_marker, p_republic, true, true)
	SpawnList(overracer_squad_list, defender_phase_2_4_marker, p_republic, true, true)
	SpawnList(atpt_squad_list, defender_phase_2_5_marker, p_republic, true, true)

	SpawnList(arc_squad_list, defender_phase_2_arc_1_marker, p_republic, false, true)
	SpawnList(arc_squad_list, defender_phase_2_arc_2_marker, p_republic, false, true)
end

function State_Keggle_Escaped(message)
	if message == OnEnter then
		if p_cis.Is_Human() and not keggle_captured then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Alt_CIS")
		elseif p_republic.Is_Human() and not keggle_captured then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Alt_Rep")
		end	
	end
end

function State_Keggle_Captured(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			Remove_Radar_Blip("hangar_blip")
			rep_shuttle_marker.Highlight(false)
			keggle_captured = true
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")
		elseif p_republic.Is_Human() then
			keggle_captured = true
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
		end
	end
end

function State_Grievous_Respawn(message)
	if message == OnEnter then
		GlobalValue.Set("ODL_CIS_Grievous_Respawn", 1)
	end
end


function Story_Handle_Esc()
	if mission_started then
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
					Resume_Mode_Based_Music()

					player_keggle = Find_First_Object("HOOLIDAN_KEGGLE")
					player_keggle.Prevent_AI_Usage(true)
					player_keggle.Teleport_And_Face(intro_keggle_move_to_marker)

					player_captain = Find_Hint("ARC_PHASE_TWO_OFFICER_SPAWNER", "captain")

					if p_republic.Get_Difficulty() == "Easy" then
						Story_Event("GOAL_TRIGGER_CIS_I_EASY")

						Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)

						Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
						
						Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)

						Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)

						Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)

						Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)

						Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)


						SpawnList(army_squad_list, defender_phase_1_1_marker, p_republic, true, true)
						SpawnList(army_squad_list, defender_phase_1_2_marker, p_republic, true, true)
						SpawnList(police_responder_squad_list, defender_phase_1_3_marker, p_republic, true, true)
						SpawnList(police_responder_squad_list, defender_phase_1_4_marker, p_republic, true, true)
						SpawnList(clone_squad_list, defender_phase_1_5_marker, p_republic, true, true)
						SpawnList(clone_squad_list, defender_phase_1_6_marker, p_republic, true, true)
						SpawnList(clone_squad_list, defender_phase_1_7_marker, p_republic, true, true)
						SpawnList(clone_squad_list, defender_phase_1_7_marker, p_republic, true, true)

						SpawnList(atrt_squad_list, defender_phase_1_7_marker, p_republic, false, true)
						SpawnList(early_espo_squad_list, defender_phase_1_8_marker, p_republic, false, true)
					elseif p_republic.Get_Difficulty() == "Hard" then
						Story_Event("GOAL_TRIGGER_CIS_I_HARD")

						Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)

						Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
						
						Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)

						--Reinforce_Unit(Find_Object_Type("ESPO_WALKER_EARLY_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("ESPO_WALKER_EARLY_SQUAD"), false, p_cis, true, false)

						Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)

						Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)

						Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)


						SpawnList(army_squad_list, defender_phase_1_1_marker, p_republic, true, true)
						SpawnList(army_squad_list, defender_phase_1_2_marker, p_republic, true, true)
						SpawnList(clone_squad_list, defender_phase_1_3_marker, p_republic, true, true)
						SpawnList(clone_squad_list, defender_phase_1_4_marker, p_republic, true, true)
						SpawnList(clone_squad_list, defender_phase_1_5_marker, p_republic, true, true)

						SpawnList(overracer_squad_list, defender_phase_1_7_marker, p_republic, true, true)

						SpawnList(early_espo_squad_list, defender_phase_1_7_marker, p_republic, false, true)
						SpawnList(atrt_squad_list, defender_phase_1_8_marker, p_republic, false, true)
						SpawnList(atrt_squad_list, defender_phase_1_8_marker, p_republic, false, true)

						SpawnList(arc_squad_list, defender_phase_1_arc_2_marker, p_republic, false, true)
						SpawnList(atpt_squad_list, defender_phase_1_arc_3_marker, p_republic, false, true)
					else
						Story_Event("GOAL_TRIGGER_CIS_I_MEDIUM")

						Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)

						Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
						
						Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)

						Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)

						Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)

						Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)
						Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)


						SpawnList(army_squad_list, defender_phase_1_1_marker, p_republic, true, true)
						SpawnList(army_squad_list, defender_phase_1_2_marker, p_republic, true, true)
						SpawnList(police_responder_squad_list, defender_phase_1_3_marker, p_republic, true, true)
						SpawnList(police_responder_squad_list, defender_phase_1_4_marker, p_republic, true, true)
						SpawnList(clone_squad_list, defender_phase_1_5_marker, p_republic, true, true)
						SpawnList(clone_squad_list, defender_phase_1_7_marker, p_republic, true, true)

						SpawnList(early_espo_squad_list, defender_phase_1_7_marker, p_republic, false, true)
						SpawnList(atrt_squad_list, defender_phase_1_8_marker, p_republic, false, true)
						SpawnList(atrt_squad_list, defender_phase_1_8_marker, p_republic, false, true)

						SpawnList(arc_squad_list, defender_phase_1_arc_2_marker, p_republic, false, true)
						SpawnList(atpt_squad_list, defender_phase_1_arc_3_marker, p_republic, false, true)
					end

					Letter_Box_Out(0)
					Point_Camera_At(cis_shuttle_marker)
					Lock_Controls(0)
					Suspend_AI(0)
					End_Cinematic_Camera()

					Add_Radar_Blip(p_terminal_1, "terminal_1_blip")
					p_terminal_1.Highlight(true)

					Add_Radar_Blip(p_terminal_2, "terminal_2_blip")
					p_terminal_2.Highlight(true)

					Add_Radar_Blip(p_terminal_3, "terminal_3_blip")
					p_terminal_3.Highlight(true)

					Register_Death_Event(p_terminal_1, State_Terminal_1_Destroyed)
					Register_Death_Event(p_terminal_2, State_Terminal_2_Destroyed)
					Register_Death_Event(p_terminal_3, State_Terminal_3_Destroyed)

					cinematic_one = false
					act_1_active = true

						--GlobalValue.Set("ODL_CIS_Jyvus_Joyride_Outcome", 1)

						--Story_Event("REPUBLIC_VICTORY")

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
					Resume_Mode_Based_Music()
					GlobalValue.Set("ODL_CIS_Jyvus_Joyride_Outcome", 0)
					GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)

					Story_Event("CIS_VICTORY")
				end
			end
			if cinematic_two_alt then
				if not cinematic_two_alt_skipped then
					cinematic_two_alt_skipped = true
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
					Resume_Mode_Based_Music()
					GlobalValue.Set("ODL_CIS_Jyvus_Joyride_Outcome", 1)
					GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)

					Story_Event("REPUBLIC_VICTORY")
				end
			end
		elseif p_republic.Is_Human() then
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

					Resume_Mode_Based_Music()

					player_keggle = Find_First_Object("HOOLIDAN_KEGGLE")
					player_captain = Find_Hint("ARC_PHASE_TWO_OFFICER_SPAWNER", "captain")
					player_captain.Despawn()

					Letter_Box_Out(0)
					Point_Camera_At(rep_shuttle_marker)
					Story_Event("GOAL_TRIGGER_REP_I")
					Story_Event("ACTIVATE_CIS_AI")
					Lock_Controls(0)
					Suspend_AI(0)
					End_Cinematic_Camera()

					player_keggle.Prevent_AI_Usage(true)
					player_keggle.Teleport_And_Face(intro_keggle_move_to_marker)

					cinematic_one = false
					act_1_active = true

					Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
					
					Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)

					SpawnList(duros_squad_list, defender_phase_1_1_marker, p_republic, true, true)
					SpawnList(scavenger_squad_list, defender_phase_1_2_marker, p_republic, true, true)
					SpawnList(heavy_scavenger_squad_list, defender_phase_1_3_marker, p_republic, true, true)
					SpawnList(police_responder_squad_list, defender_phase_1_4_marker, p_republic, true, true)
					SpawnList(clone_squad_list, defender_phase_1_5_marker, p_republic, true, true)
					SpawnList(clone_squad_list, defender_phase_1_6_marker, p_republic, true, true)
					SpawnList(clone_squad_list, defender_phase_1_7_marker, p_republic, true, true)
					--SpawnList(duros_squad_list, defender_phase_1_8_marker, p_republic, true, true)
					--SpawnList(duros_squad_list, defender_phase_1_9_marker, p_republic, true, true)

					--SpawnList(arc_squad_list, defender_phase_1_arc_1_marker, p_republic, false, true)
					SpawnList(arc_squad_list, defender_phase_1_arc_2_marker, p_republic, false, true)
					SpawnList(arc_squad_list, defender_phase_1_arc_3_marker, p_republic, false, true)

					SpawnList(b1_squad_list, cis_squad_1_marker, p_cis, false, true)
					--SpawnList(b1_squad_list, cis_squad_2_marker, p_cis, false, true)
					SpawnList(b2_squad_list, cis_squad_3_marker, p_cis, false, true)
					--SpawnList(b2_squad_list, cis_squad_4_marker, p_cis, false, true)
					SpawnList(bx_squad_list, cis_squad_5_marker, p_cis, false, true)
					SpawnList(bx_squad_list, cis_squad_6_marker, p_cis, false, true)
					SpawnList(magna_squad_list, cis_squad_7_marker, p_cis, false, true)
					SpawnList(crab_squad_list, cis_squad_8_marker, p_cis, false, true)

					Add_Radar_Blip(p_terminal_1, "terminal_1_blip")
					p_terminal_1.Highlight(true)

					Add_Radar_Blip(p_terminal_2, "terminal_2_blip")
					p_terminal_2.Highlight(true)

					Add_Radar_Blip(p_terminal_3, "terminal_3_blip")
					p_terminal_3.Highlight(true)

					Register_Death_Event(p_terminal_1, State_Terminal_1_Destroyed)
					Register_Death_Event(p_terminal_2, State_Terminal_2_Destroyed)
					Register_Death_Event(p_terminal_3, State_Terminal_3_Destroyed)

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
					Resume_Mode_Based_Music()
					GlobalValue.Set("ODL_CIS_Jyvus_Joyride_Outcome", 0)
					GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)

					Story_Event("REPUBLIC_VICTORY")
				end
			end
			if cinematic_two_alt then
				if not cinematic_two_alt_skipped then
					cinematic_two_alt_skipped = true
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
					Resume_Mode_Based_Music()
					GlobalValue.Set("ODL_CIS_Jyvus_Joyride_Outcome", 1)
					GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)

					Story_Event("REPUBLIC_VICTORY")
				end
			end
		end
	end
end

function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_1_active then
			if shuttle_arrived and keggle_hangar_reached then
				if not mission_over then
					Remove_Radar_Blip("hangar_blip")
					Remove_Radar_Blip("keggle_blip")
					rep_shuttle_marker.Highlight(false)
					player_keggle.Highlight(false)

					Story_Event("KEGGLE_ESCAPED")
					mission_over = true
				end
			end
		end
		if act_2_active then
			if shuttle_arrived and keggle_hangar_reached then
				if not mission_over then
					Remove_Radar_Blip("hangar_blip")
					Remove_Radar_Blip("keggle_blip")
					rep_shuttle_marker.Highlight(false)
					player_keggle.Highlight(false)

					Story_Event("KEGGLE_ESCAPED")
					mission_over = true
				end
			end
		end
	elseif p_republic.Is_Human() then
		if act_1_active then
			if shuttle_arrived and keggle_hangar_reached then
				if not mission_over then
					Remove_Radar_Blip("hangar_blip")
					Remove_Radar_Blip("keggle_blip")
					rep_shuttle_marker.Highlight(false)
					player_keggle.Highlight(false)

					Story_Event("KEGGLE_ESCAPED")
					mission_over = true
				end
			end
		end
	end
end


function Start_Cinematic_Intro_CIS()
	cinematic_one = true
	Start_Cinematic_Camera()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()
	Stop_All_Music()
	Fade_On()

	player_keggle.Teleport_And_Face(intro_keggle_marker)
	player_captain.Teleport_And_Face(intro_captain_marker)

	Play_Music("Jyvus_Joyride_01")
	Sleep(0.25)

	Fade_Screen_In(0.5)
	Letter_Box_In(0.5)

	Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 13.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 13.5, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Story_Event("EVACUATION_01")
	Sleep(5.5)

	Story_Event("EVACUATION_02")
	Sleep(8.0)

	Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_4_marker, 6, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_4_marker, 6, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Story_Event("EVACUATION_03")
	Sleep(5.5)

	Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 5, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_5_marker, 0, 2, 1, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_6_marker, 8, 0, 0, 5, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_6_marker, 8, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Story_Event("EVACUATION_04")
	Sleep(8.0)

	Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Cinematic_Zoom(20, 5)

	Story_Event("EVACUATION_05")
	Sleep(4.5)

	Fade_Screen_Out(3.0)
	Sleep(3.5)

	player_cis_shuttle = Create_Cinematic_Transport("CIS_Hero_Landing_Craft_Landing", p_cis.Get_ID(), cis_shuttle_marker, 90, 1, 0, 9, 0)
	Sleep(1.0)

	player_keggle.Move_To(defender_phase_1_4_marker)

	Set_Cinematic_Camera_Key(introcam_8_marker, 0, 0, 5, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_8_marker, 0, 2, 1, 0, introcam_target_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_9_marker, 5, 0, 0, 5, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_9_marker, 5, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)

	Story_Event("EVACUATION_06")
	Fade_Screen_In(0.5)
	Sleep(4.5)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end

function End_Cinematic_Intro_CIS()
	Point_Camera_At(cis_shuttle_marker)
	Transition_To_Tactical_Camera(1.5)
	Sleep(1.5)
	Letter_Box_Out(1.5)
	Sleep(1.5)
	End_Cinematic_Camera()
	Lock_Controls(0)
	Suspend_AI(0)
	Resume_Mode_Based_Music()

	player_keggle.Prevent_AI_Usage(true)
	player_keggle.Teleport_And_Face(intro_keggle_move_to_marker)

	if p_republic.Get_Difficulty() == "Easy" then
		Story_Event("GOAL_TRIGGER_CIS_I_EASY")

		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
		
		Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)


		SpawnList(army_squad_list, defender_phase_1_1_marker, p_republic, true, true)
		SpawnList(army_squad_list, defender_phase_1_2_marker, p_republic, true, true)
		SpawnList(police_responder_squad_list, defender_phase_1_3_marker, p_republic, true, true)
		SpawnList(police_responder_squad_list, defender_phase_1_4_marker, p_republic, true, true)
		SpawnList(clone_squad_list, defender_phase_1_5_marker, p_republic, true, true)
		SpawnList(clone_squad_list, defender_phase_1_6_marker, p_republic, true, true)
		SpawnList(clone_squad_list, defender_phase_1_7_marker, p_republic, true, true)
		SpawnList(clone_squad_list, defender_phase_1_7_marker, p_republic, true, true)

		SpawnList(atrt_squad_list, defender_phase_1_7_marker, p_republic, false, true)
		SpawnList(early_espo_squad_list, defender_phase_1_8_marker, p_republic, false, true)
	elseif p_republic.Get_Difficulty() == "Hard" then
		Story_Event("GOAL_TRIGGER_CIS_I_HARD")

		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
		
		Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)

		--Reinforce_Unit(Find_Object_Type("ESPO_WALKER_EARLY_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("ESPO_WALKER_EARLY_SQUAD"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)


		SpawnList(army_squad_list, defender_phase_1_1_marker, p_republic, true, true)
		SpawnList(army_squad_list, defender_phase_1_2_marker, p_republic, true, true)
		SpawnList(clone_squad_list, defender_phase_1_3_marker, p_republic, true, true)
		SpawnList(clone_squad_list, defender_phase_1_4_marker, p_republic, true, true)
		SpawnList(clone_squad_list, defender_phase_1_5_marker, p_republic, true, true)

		SpawnList(overracer_squad_list, defender_phase_1_7_marker, p_republic, true, true)

		SpawnList(early_espo_squad_list, defender_phase_1_7_marker, p_republic, false, true)
		SpawnList(atrt_squad_list, defender_phase_1_8_marker, p_republic, false, true)
		SpawnList(atrt_squad_list, defender_phase_1_8_marker, p_republic, false, true)

		SpawnList(arc_squad_list, defender_phase_1_arc_2_marker, p_republic, false, true)
		SpawnList(atpt_squad_list, defender_phase_1_arc_3_marker, p_republic, false, true)
	else
		Story_Event("GOAL_TRIGGER_CIS_I_MEDIUM")

		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
		
		Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)


		SpawnList(army_squad_list, defender_phase_1_1_marker, p_republic, true, true)
		SpawnList(army_squad_list, defender_phase_1_2_marker, p_republic, true, true)
		SpawnList(police_responder_squad_list, defender_phase_1_3_marker, p_republic, true, true)
		SpawnList(police_responder_squad_list, defender_phase_1_4_marker, p_republic, true, true)
		SpawnList(clone_squad_list, defender_phase_1_5_marker, p_republic, true, true)
		SpawnList(clone_squad_list, defender_phase_1_7_marker, p_republic, true, true)

		SpawnList(early_espo_squad_list, defender_phase_1_7_marker, p_republic, false, true)
		SpawnList(atrt_squad_list, defender_phase_1_8_marker, p_republic, false, true)
		SpawnList(atrt_squad_list, defender_phase_1_8_marker, p_republic, false, true)

		SpawnList(arc_squad_list, defender_phase_1_arc_2_marker, p_republic, false, true)
		SpawnList(atpt_squad_list, defender_phase_1_arc_3_marker, p_republic, false, true)
	end

	Add_Radar_Blip(p_terminal_1, "terminal_1_blip")
	p_terminal_1.Highlight(true)

	Add_Radar_Blip(p_terminal_2, "terminal_2_blip")
	p_terminal_2.Highlight(true)

	Add_Radar_Blip(p_terminal_3, "terminal_3_blip")
	p_terminal_3.Highlight(true)

	Register_Death_Event(p_terminal_1, State_Terminal_1_Destroyed)
	Register_Death_Event(p_terminal_2, State_Terminal_2_Destroyed)
	Register_Death_Event(p_terminal_3, State_Terminal_3_Destroyed)

	cinematic_one = false
	act_1_active = true

end

function Start_Cinematic_Outro_CIS()
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

	republic_unit_list = Find_All_Objects_Of_Type(p_republic)
	for k,repunits in pairs(republic_unit_list) do
		if TestValid(repunits) then
			repunits.Despawn()
		end
	end

	Play_Music("Jyvus_Joyride_02")

	keggle_unit = Find_Object_Type("HOOLIDAN_KEGGLE")
	keggle_list = Spawn_Unit(keggle_unit, outro_keggle_marker, p_cis)
	player_keggle = keggle_list[1]
	player_keggle.Teleport_And_Face(outro_keggle_marker)
	player_keggle.Prevent_All_Fire(true)

	grievous_unit = Find_Object_Type("GENERAL_GRIEVOUS")
	grievous_list = Spawn_Unit(grievous_unit, outro_grievous_marker, p_cis)
	player_grievous = grievous_list[1]
	player_grievous.Set_Garrison_Spawn(false)
	player_grievous.Teleport_And_Face(outro_grievous_marker)

	tactical_droid_unit = Find_Object_Type("GENERAL_KALANI")
	tactical_droid_list = Spawn_Unit(tactical_droid_unit, outro_tactical_droid_marker, p_cis)
	player_tactical_droid = tactical_droid_list[1]
	player_tactical_droid.Set_Garrison_Spawn(false)
	player_tactical_droid.Teleport_And_Face(outro_tactical_droid_marker)

	player_keggle.Turn_To_Face(player_grievous)
	player_grievous.Turn_To_Face(player_keggle)
	player_tactical_droid.Turn_To_Face(player_keggle)

	Hide_Sub_Object(player_grievous, 1, "Box01")
	Hide_Sub_Object(player_grievous, 1, "Box02")
	Hide_Sub_Object(player_grievous, 1, "Box03")
	Hide_Sub_Object(player_grievous, 1, "Box04")
	Hide_Sub_Object(player_grievous, 1, "Box05")
	Hide_Sub_Object(player_grievous, 1, "Box06")
	Hide_Sub_Object(player_grievous, 1, "Saber_BR")
	Hide_Sub_Object(player_grievous, 1, "Saber_BR01")
	Hide_Sub_Object(player_grievous, 1, "Saber_TR")
	Hide_Sub_Object(player_grievous, 1, "Saber_TR01")
	Hide_Sub_Object(player_grievous, 1, "Saberglow_BR")
	Hide_Sub_Object(player_grievous, 1, "Wooshglow_TR")

	--new_squad = SpawnList(bx_squad_list, outro_squad_marker, p_cis, true, true)

	Set_Cinematic_Camera_Key(outrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_1_marker, 0, 0, 5, 0, outrocam_target_1_marker, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_2_marker, 18.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_2_marker, 18.0, 0, 0, 5, 0, outrocam_target_1_marker, 1, 0)
	Story_Event("EVACUATION_09")
	
	Fade_Screen_In(0.5)
	Sleep(4.0)
	
	player_grievous.Play_Animation("Talk", false, 1)
	
	Story_Event("EVACUATION_10")
	Sleep(7.0)

	Set_Cinematic_Camera_Key(outrocam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_3_marker, 0, 0, 1, 0, outrocam_target_2_marker, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_4_marker, 9.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_4_marker, 9.5, 0, 0, 1, 0, outrocam_target_2_marker, 1, 0)
	Story_Event("EVACUATION_11")
	Sleep(7.5)

	Set_Cinematic_Camera_Key(outrocam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_5_marker, 0, 0, 1, 0, outrocam_target_1_marker, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_6_marker, 9.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_6_marker, 9.5, 0, 0, 1, 0, outrocam_target_1_marker, 1, 0)
	Story_Event("EVACUATION_12")
	Sleep(5.5)

	Set_Cinematic_Camera_Key(outrocam_7_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_7_marker, 0, 0, 1, 0, outrocam_target_1_marker, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_8_marker, 9.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_8_marker, 9.5, 0, 0, 1, 0, outrocam_target_1_marker, 1, 0)
	
	player_grievous.Play_Animation("Talk", false, 1)
	
	Story_Event("EVACUATION_13")
	
	player_grievous.Play_Animation("Talk", false, 0)
	
	Sleep(8.0)

	Set_Cinematic_Camera_Key(outrocam_9_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_9_marker, 0, 0, 1, 0, outrocam_target_1_marker, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_10_marker, 7.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_10_marker, 7.5, 0, 0, 1, 0, outrocam_target_1_marker, 1, 0)
	
	player_grievous.Play_Animation("Talk", true, 0)
	
	Story_Event("EVACUATION_14")
	Sleep(6.5)

	Transition_Cinematic_Camera_Key(outrocam_10_marker, 7.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_10_marker, 7.0, 0, 0, 1, 0, outrocam_target_2_marker, 1, 0)
	Sleep(2.0)
	Story_Event("EVACUATION_15")
	Sleep(3.5)

	Set_Cinematic_Camera_Key(outrocam_12_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_12_marker, 0, 0, 1, 0, outrocam_target_1_marker, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_17_marker, 9.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_17_marker, 9.0, 0, 0, 1, 0, outrocam_target_1_marker, 1, 0)
	
	player_grievous.Play_Animation("Talk", false, 1)
	
	Story_Event("EVACUATION_16")
	Sleep(2.5)

	player_grievous.Play_Animation("Talk", false, 0)

	Story_Event("EVACUATION_17")
	Sleep(8.3)

	Set_Cinematic_Camera_Key(outrocam_17_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_17_marker, 0, 0, 1, 0, outrocam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(outrocam_12_marker, 9.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_12_marker, 9.0, 0, 0, 1, 0, outrocam_target_2_marker, 1, 0)	
	Story_Event("EVACUATION_18")
	Sleep(7.5)

	Set_Cinematic_Camera_Key(outrocam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_5_marker, 0, 0, 1, 0, outrocam_target_1_marker, 1, 0)		
	Transition_Cinematic_Camera_Key(outrocam_16_marker, 9.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_16_marker, 9.5, 0, 0, 1, 0, outrocam_target_1_marker, 1, 0)
	
	player_grievous.Play_Animation("Talk", false, 1)
	
	Story_Event("EVACUATION_19")
	Sleep(8.0)

	Set_Cinematic_Camera_Key(outrocam_10_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_10_marker, 0, 0, 1, 0, outrocam_target_2_marker, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_17_marker, 9.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_17_marker, 9.5, 0, 0, 1, 0, outrocam_target_2_marker, 1, 0)
	Story_Event("EVACUATION_20")
	Sleep(7.5)

	Set_Cinematic_Camera_Key(outrocam_16_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_16_marker, 0, 0, 1, 0, outrocam_target_1_marker, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_19_marker, 20.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_19_marker, 20.0, 0, 0, 1, 0, outrocam_target_1_marker, 1, 0)
	
	player_grievous.Play_Animation("Talk", false, 0)
	
	Story_Event("EVACUATION_21")
	Sleep(6.0)

	Story_Event("EVACUATION_22")
	Sleep(2.5)

	Fade_Screen_Out(6.0)
	Sleep(2.5)

	Story_Event("EVACUATION_23")
	Sleep(6.0)

	GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)

	GlobalValue.Set("ODL_CIS_Jyvus_Joyride_Outcome", 0)

	Story_Event("CIS_VICTORY")
	Resume_Mode_Based_Music()
end

function Start_Cinematic_Outro_Alt_CIS()
	act_1_active = false
	cinematic_two_alt = true
	Fade_Screen_Out(0.5)
	Sleep(1)
	Suspend_AI(1)
	Lock_Controls(1)
	Start_Cinematic_Camera()
	Letter_Box_In(0)
	Stop_All_Music()
	Cancel_Fast_Forward()

	Story_Event("DISABLE_KEGGLE_DEATH")

	Do_End_Cinematic_Cleanup()

	player_escape_shuttle = Create_Cinematic_Transport("Gallofree_Transport_Landing", p_republic.Get_ID(), rep_shuttle_marker, 90, 0, 1.0, 3.5, 0)

	Set_Cinematic_Camera_Key(outrocam_1_alt_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_1_alt_marker, 0, 0, 5, 0, player_escape_shuttle, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_2_alt_marker, 8.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_2_alt_marker, 8.5, 0, 0, 5, 0, player_escape_shuttle, 1, 0)

	Play_Music("Jyvus_Joyride_02_Alt_01")
	Story_Event("EVACUATION_08")
	Fade_Screen_In(0.5)
	Sleep(6.5)

	Fade_Screen_Out(1.0)
	Sleep(2)

	GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)

	GlobalValue.Set("ODL_CIS_Jyvus_Joyride_Outcome", 1)

	Story_Event("REPUBLIC_VICTORY")
	Resume_Mode_Based_Music()
end


function Start_Cinematic_Intro_Rep()
	cinematic_one = true
	Start_Cinematic_Camera()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()
	Stop_All_Music()
	Fade_On()

	player_keggle.Teleport_And_Face(intro_keggle_marker)
	player_captain.Teleport_And_Face(intro_captain_marker)

	Play_Music("Jyvus_Joyride_01")
	Sleep(0.25)

	Fade_Screen_In(0.5)
	Letter_Box_In(0.5)

	Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 13.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 13.5, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Story_Event("EVACUATION_01")
	Sleep(5.5)

	Story_Event("EVACUATION_02")
	Sleep(8.0)

	Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_4_marker, 6, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_4_marker, 6, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Story_Event("EVACUATION_03")
	Sleep(5.5)

	Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 5, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_5_marker, 0, 2, 1, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_6_marker, 8, 0, 0, 5, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_6_marker, 8, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Story_Event("EVACUATION_04")
	Sleep(8.0)

	Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Cinematic_Zoom(20, 5)

	Story_Event("EVACUATION_05")
	Sleep(5.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Rep")
	end
end

function End_Cinematic_Intro_Rep()
	Point_Camera_At(rep_shuttle_marker)
	Transition_To_Tactical_Camera(1.5)
	Sleep(1.5)
	Letter_Box_Out(1.5)
	Sleep(1.5)
	End_Cinematic_Camera()
	Lock_Controls(0)
	Story_Event("GOAL_TRIGGER_REP_I")
	Suspend_AI(0)
	Resume_Mode_Based_Music()

	Story_Event("ACTIVATE_CIS_AI")
	player_captain.Despawn()

	cinematic_one = false
	act_1_active = true

	Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("B2_DROID_SQUAD"), false, p_cis, true, false)

	Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
	
	Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_SQUAD"), false, p_cis, true, false)

	Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)

	Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)

	Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)

	Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)

	Add_Radar_Blip(player_keggle, "keggle_blip")
	Add_Radar_Blip(rep_shuttle_marker, "hangar_blip")
	player_keggle.Highlight(true)
	rep_shuttle_marker.Highlight(true)
end

function Start_Cinematic_Outro_Rep()
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

	republic_unit_list = Find_All_Objects_Of_Type(p_republic)
	for k,repunits in pairs(republic_unit_list) do
		if TestValid(repunits) then
			repunits.Despawn()
		end
	end

	Play_Music("Jyvus_Joyride_02")

	keggle_unit = Find_Object_Type("HOOLIDAN_KEGGLE")
	keggle_list = Spawn_Unit(keggle_unit, outro_keggle_marker, p_cis)
	player_keggle = keggle_list[1]
	player_keggle.Teleport_And_Face(outro_keggle_marker)
	player_keggle.Prevent_All_Fire(true)

	grievous_unit = Find_Object_Type("GENERAL_GRIEVOUS")
	grievous_list = Spawn_Unit(grievous_unit, outro_grievous_marker, p_cis)
	player_grievous = grievous_list[1]
	player_grievous.Set_Garrison_Spawn(false)
	player_grievous.Teleport_And_Face(outro_grievous_marker)

	Hide_Sub_Object(player_grievous, 1, "Box01")
	Hide_Sub_Object(player_grievous, 1, "Box02")
	Hide_Sub_Object(player_grievous, 1, "Box03")
	Hide_Sub_Object(player_grievous, 1, "Box04")
	Hide_Sub_Object(player_grievous, 1, "Box05")
	Hide_Sub_Object(player_grievous, 1, "Box06")
	Hide_Sub_Object(player_grievous, 1, "Saber_BR")
	Hide_Sub_Object(player_grievous, 1, "Saber_BR01")
	Hide_Sub_Object(player_grievous, 1, "Saber_TR")
	Hide_Sub_Object(player_grievous, 1, "Saber_TR01")
	Hide_Sub_Object(player_grievous, 1, "Saberglow_BR")

	tactical_droid_unit = Find_Object_Type("GENERAL_KALANI")
	tactical_droid_list = Spawn_Unit(tactical_droid_unit, outro_tactical_droid_marker, p_cis)
	player_tactical_droid = tactical_droid_list[1]
	player_tactical_droid.Set_Garrison_Spawn(false)
	player_tactical_droid.Teleport_And_Face(outro_tactical_droid_marker)

	player_keggle.Turn_To_Face(player_grievous)
	player_grievous.Turn_To_Face(player_keggle)
	player_tactical_droid.Turn_To_Face(player_keggle)

	new_squad = SpawnList(bx_squad_list, outro_squad_marker, p_cis, true, true)

	Set_Cinematic_Camera_Key(outrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_1_marker, 0, 0, 5, 0, outrocam_target_1_marker, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_2_marker, 13.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_2_marker, 13.5, 0, 0, 5, 0, outrocam_target_1_marker, 1, 0)

	Story_Event("EVACUATION_09")
	Fade_Screen_In(0.5)
	Sleep(8.5)

	Story_Event("EVACUATION_10")
	Sleep(5)

	Set_Cinematic_Camera_Key(outrocam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_3_marker, 0, 0, 1, 0, outrocam_target_1_marker, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_4_marker, 7, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_4_marker, 7, 0, 0, 1, 0, outrocam_target_1_marker, 1, 0)

	player_keggle.Change_Owner(p_republic)

	Story_Event("EVACUATION_11")
	Sleep(2)

	player_keggle.Take_Damage(999999)
	Sleep(3)

	player_tactical_droid.Turn_To_Face(player_grievous)
	player_grievous.Turn_To_Face(player_tactical_droid)

	Story_Event("EVACUATION_12")
	Sleep(3)

	Fade_Screen_Out(2.5)
	Sleep(4)

	GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)

	Story_Event("CIS_VICTORY")
	Resume_Mode_Based_Music()
end

function Start_Cinematic_Outro_Alt_Rep()
	act_1_active = false
	cinematic_two_alt = true
	Fade_Screen_Out(0.5)
	Sleep(1)
	Suspend_AI(1)
	Lock_Controls(1)
	Start_Cinematic_Camera()
	Letter_Box_In(0)
	Stop_All_Music()
	Cancel_Fast_Forward()

	Story_Event("DISABLE_KEGGLE_DEATH")

	Do_End_Cinematic_Cleanup()

	player_escape_shuttle = Create_Cinematic_Transport("Gallofree_Transport_Landing", p_republic.Get_ID(), rep_shuttle_marker, 90, 0, 1.0, 3.5, 0)

	Set_Cinematic_Camera_Key(outrocam_1_alt_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_1_alt_marker, 0, 0, 5, 0, player_escape_shuttle, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_2_alt_marker, 8.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_2_alt_marker, 8.5, 0, 0, 5, 0, player_escape_shuttle, 1, 0)

	Play_Music("Jyvus_Joyride_02_Alt_01")
	Story_Event("EVACUATION_08")
	Fade_Screen_In(0.5)
	Sleep(6.5)

	Fade_Screen_Out(1.0)
	Sleep(2)

	GlobalValue.Set("ODL_CIS_Jyvus_Joyride_Outcome", 1)
	GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)

	Story_Event("REPUBLIC_VICTORY")
	Resume_Mode_Based_Music()
end
