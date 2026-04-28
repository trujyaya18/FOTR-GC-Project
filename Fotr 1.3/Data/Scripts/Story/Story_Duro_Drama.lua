
--*****************************************************--
--******** Operation Durge's Lance: Duro Drama ********--
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
		Trigger_Keggle_Captured = State_Keggle_Captured,
		Trigger_CIS_Forces_Killed = State_CIS_Forces_Killed,
		Trigger_Republic_Forces_Killed = State_Republic_Forces_Killed,
		Trigger_Grievous_Respawn = State_Grievous_Respawn,
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")
	p_neutral = Find_Player("Neutral")

	bx_squad_list = {"BX_COMMANDO_TEAM_DEPLOYED"}

	current_cinematic_thread_id = nil

	act_1_active = false
	act_2_active = false

	cinematic_one = false
	cinematic_two = false
	cinematic_two_alt = false

	cinematic_one_skipped = false
	cinematic_two_skipped = false
	cinematic_two_alt_skipped = false

	mission_over = false
	keggle_captured = false
	cis_forces_killed = false
	republic_forces_killed = false

	initial_units_spawned = false

	num_reinforcements = 0
	allowed_reinforcements = 10
	reinforcement_delay = 90

	camera_offset = 125
	intro_skipped = false
	mission_started = false

end

function Begin_Battle(message)
	if message == OnEnter then
		outro_keggle_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-keggle")
		outro_grievous_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-grievous")
		outro_tactical_droid_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-tactical-droid")

		outro_squad_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-squad")

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam4")
		introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam5")
		introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam6")
		introcam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam7")
		introcam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam8")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget1")

		outrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam1")
		outrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam2")
		outrocam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam3")
		outrocam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam4")

		outrocam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocamtarget1")

		intro_keggle_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-keggle")

		attacker_marker = Find_First_Object("ATTACKER ENTRY POSITION")
		player_keggle = Find_First_Object("HOOLIDAN_KEGGLE")

		p_invaders.Make_Ally(p_cis)
		p_cis.Make_Ally(p_invaders)

		mission_started = true
		if p_republic.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
		elseif p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
		end
	end
end


function State_Keggle_Captured(message)
	if message == OnEnter then
		keggle_captured = true
	end
end

function State_CIS_Forces_Killed(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Alt_CIS")
		elseif p_republic.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Alt_Rep")
		end
	end
end

function State_Republic_Forces_Killed(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")
		elseif p_republic.Is_Human() then
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

					Letter_Box_Out(0)
					Point_Camera_At(attacker_marker)
					Story_Event("GOAL_TRIGGER_CIS_I")
					Lock_Controls(0)
					Suspend_AI(0)
					End_Cinematic_Camera()

					Add_Radar_Blip(player_keggle, "keggle_blip")
					player_keggle.Highlight(true)

					p_republic.Make_Enemy(p_cis)
					p_cis.Make_Enemy(p_republic)

					Story_Event("ACTIVATE_REP_AI")

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
					Resume_Mode_Based_Music()

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

					Letter_Box_Out(0)
					Point_Camera_At(player_keggle)
					Story_Event("GOAL_TRIGGER_REP_I")
					Story_Event("ACTIVATE_CIS_AI")
					Lock_Controls(0)
					Suspend_AI(0)
					End_Cinematic_Camera()

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
					Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("MTT_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("MTT_COMPANY"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("MAGNA_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("MAGNA_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("MAGNA_COMPANY"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("J1_ARTILLERY_CORP"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("J1_ARTILLERY_CORP"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("HAILFIRE_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("HAILFIRE_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("HAILFIRE_COMPANY"), false, p_cis, true, false)

					p_republic.Make_Enemy(p_cis)
					p_cis.Make_Enemy(p_republic)

					cinematic_one = false
					act_1_active = true

						--Story_Event("CIS_VICTORY")

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

					Story_Event("REPUBLIC_VICTORY")
				end
			end
		end
	end
end

function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_1_active then
			rep_list = Find_All_Objects_Of_Type(p_republic, "Infantry, LandHero, Vehicle, Air")
			if (table.getn(rep_list) == 0) and not TestValid(Find_First_Object("Republic_Shipyard_Level_One")) and not TestValid(Find_First_Object("Kaliida_Medical_Station")) then
				republic_forces_killed = true
			end
			cis_list = Find_All_Objects_Of_Type(p_cis, "Infantry, LandHero, Vehicle, Air")
			if (table.getn(cis_list) == 0) then
				cis_forces_killed = true
			end
			if republic_forces_killed and keggle_captured then
				Story_Event("REPUBLIC_FORCES_KILLED")
			end
			if cis_forces_killed and not keggle_captured then
				Story_Event("CIS_FORCES_KILLED")
			end
			if TestValid(Find_First_Object("Grievous_Soulless_One_Ground")) or TestValid(Find_First_Object("Soulless_One")) or TestValid(Find_First_Object("Grievous_Team_Soulless_One")) then
				GlobalValue.Set("ODL_Grievous", 1) -- 0 = Dead; 1 = Soulless_One; 2 = Invisible_Hand; 3 = Renitor; 4 = Munificent; 5 = Malevolence
			elseif TestValid(Find_First_Object("General_Grievous")) or TestValid(Find_First_Object("Invisible_Hand")) or TestValid(Find_First_Object("Grievous_Team")) then
				GlobalValue.Set("ODL_Grievous", 2) -- 0 = Dead; 1 = Soulless_One; 2 = Invisible_Hand; 3 = Renitor; 4 = Munificent; 5 = Malevolence
			elseif TestValid(Find_First_Object("Grievous_Recusant_Ground")) or TestValid(Find_First_Object("Grievous_Recusant")) or TestValid(Find_First_Object("Grievous_Team_Recusant")) then
				GlobalValue.Set("ODL_Grievous", 3) -- 0 = Dead; 1 = Soulless_One; 2 = Invisible_Hand; 3 = Renitor; 4 = Munificent; 5 = Malevolence
			elseif TestValid(Find_First_Object("Grievous_Munificent_Ground")) or TestValid(Find_First_Object("Grievous_Munificent")) or TestValid(Find_First_Object("Grievous_Team_Soulless_One")) then
				GlobalValue.Set("ODL_Grievous", 4) -- 0 = Dead; 1 = Soulless_One; 2 = Invisible_Hand; 3 = Renitor; 4 = Munificent; 5 = Malevolence
			elseif TestValid(Find_First_Object("Grievous_Malevolence_Ground")) or TestValid(Find_First_Object("Grievous_Malevolence")) or TestValid(Find_First_Object("Grievous_Team_Malevolence")) then
				GlobalValue.Set("ODL_Grievous", 5) -- 0 = Dead; 1 = Soulless_One; 2 = Invisible_Hand; 3 = Renitor; 4 = Munificent; 5 = Malevolence
			end
		end
	elseif p_republic.Is_Human() then
		if act_1_active then
			rep_list = Find_All_Objects_Of_Type(p_republic, "Infantry, LandHero, Vehicle, Air")
			if (table.getn(rep_list) == 0) and not TestValid(Find_First_Object("Republic_Shipyard_Level_One")) and not TestValid(Find_First_Object("Kaliida_Medical_Station")) then
				republic_forces_killed = true
			end
			cis_list = Find_All_Objects_Of_Type(p_cis, "Infantry, LandHero, Vehicle, Air")
			if (table.getn(cis_list) == 0) then
				cis_forces_killed = true
			end
			if republic_forces_killed and keggle_captured then
				Story_Event("REPUBLIC_FORCES_KILLED")
			end
			if cis_forces_killed and not keggle_captured then
				Story_Event("CIS_FORCES_KILLED")
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

	player_keggle.Teleport_And_Face(intro_keggle_marker)

	Play_Music("Jyvus_Joyride_01")
	Sleep(0.25)

	Fade_Screen_In(0.5)
	Letter_Box_In(0.5)

	Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, player_keggle, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 16.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 16.5, 0, 0, 0, 0, player_keggle, 1, 0)
	Story_Event("LAST_STAND_01")
	Sleep(8.5)

	Story_Event("LAST_STAND_02")
	Sleep(9.0)

	Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, player_keggle, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_4_marker, 8, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_4_marker, 8, 0, 0, 0, 0, player_keggle, 1, 0)
	Story_Event("LAST_STAND_03")
	Sleep(8.0)

	Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 5, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_5_marker, 0, 2, 1, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_6_marker, 5, 0, 0, 5, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_6_marker, 5, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Story_Event("LAST_STAND_04")
	Sleep(7.0)

	Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, player_keggle, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_8_marker, 8, 0, 0, 5, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_8_marker, 8, 0, 0, 0, 0, player_keggle, 1, 0)
	Story_Event("LAST_STAND_05")
	Sleep(8.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Rep")
	end
end

function End_Cinematic_Intro_Rep()
	Point_Camera_At(player_keggle)
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
	Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("B1_DROID_SQUAD"), false, p_cis, true, false)

	Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("BX_COMMANDO_SQUAD"), false, p_cis, true, false)

	Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)

	Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("MAGNAGUARD_SQUAD"), false, p_cis, true, false)

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
	keggle_list = Spawn_Unit(keggle_unit, outro_keggle_marker, p_invaders)
	player_keggle = keggle_list[1]
	player_keggle.Teleport_And_Face(outro_keggle_marker)
	player_keggle.Prevent_All_Fire(true)

	grievous_unit = Find_Object_Type("GENERAL_GRIEVOUS")
	grievous_list = Spawn_Unit(grievous_unit, outro_grievous_marker, p_cis)
	player_grievous = grievous_list[1]
	player_grievous.Set_Garrison_Spawn(false)
	player_grievous.Teleport_And_Face(outro_grievous_marker)

	tactical_droid_unit = Find_Object_Type("GENERAL_KALANI")
	tactical_droid_list = Spawn_Unit(tactical_droid_unit, outro_tactical_droid_marker, p_neutral)
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
	
	Set_Cinematic_Camera_Key(outrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_1_marker, 0, 0, 5, 0, outrocam_target_1_marker, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_2_marker, 13.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_2_marker, 13.5, 0, 0, 5, 0, outrocam_target_1_marker, 1, 0)
	
	Sleep(0.1)
	
	player_grievous.Play_Animation("Talk", false, 1)
	
	Story_Event("LAST_STAND_06")
	Fade_Screen_In(0.5)
	Sleep(8.0)

	Story_Event("LAST_STAND_07")
	Sleep(7)
	
	Set_Cinematic_Camera_Key(outrocam_2_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_2_marker, 0, 0, 5, 0, outrocam_target_1_marker, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_1_marker, 11, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_1_marker, 11, 0, 0, 1, 0, outrocam_target_1_marker, 1, 0)
	
	Story_Event("LAST_STAND_08")
	Sleep(4.0)
	
	player_grievous.Play_Animation("Talk", false, 2)
	Fade_Screen_Out(1.4)
	
	Story_Event("LAST_STAND_09")
	Sleep(1.2)
	
	player_keggle.Change_Owner(p_republic)
	player_keggle.Take_Damage(999999)
	
	Sleep(3.5)
	Fade_Screen_In(3.0)
	
	
	Set_Cinematic_Camera_Key(outrocam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_3_marker, 0, 0, 5, 0, outrocam_target_1_marker, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_4_marker, 15, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_4_marker, 15, 0, 0, 5, 0, outrocam_target_1_marker, 1, 0)
	
	player_grievous.Turn_To_Face(player_tactical_droid)
	player_tactical_droid.Turn_To_Face(player_grievous)
	
	Sleep(0.1)
	Story_Event("LAST_STAND_10")
	player_grievous.Play_Animation("Talk", true, 1)
	Sleep(3.0)
	
	Story_Event("LAST_STAND_11")
	Sleep (3.0)
	

	Fade_Screen_Out(5.0)
	Sleep(5.0)
	Story_Event("CIS_VICTORY")
	Resume_Mode_Based_Music()
end

function Start_Cinematic_Outro_Alt_Rep()
	act_1_active = false
	cinematic_two_alt = true
	Fade_Screen_Out(5.0)
	Letter_Box_In(0)
	Stop_All_Music()
	Cancel_Fast_Forward()

	Story_Event("DISABLE_KEGGLE_DEATH")
	Play_Music("Jyvus_Joyride_02_Alt_01")
	Story_Event("LAST_STAND_10")
	Sleep(6.5)

	Story_Event("REPUBLIC_VICTORY")
	Resume_Mode_Based_Music()
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

	Play_Music("Jyvus_Joyride_01")
	Sleep(0.25)

	Fade_Screen_In(0.5)
	Letter_Box_In(0.5)

	Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, player_keggle, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 12.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 12.5, 0, 0, 0, 0, player_keggle, 1, 0)
	Story_Event("LAST_STAND_01")
	Sleep(5.5)

	Story_Event("LAST_STAND_02")
	Sleep(7.0)

	Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, player_keggle, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_4_marker, 8, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_4_marker, 8, 0, 0, 0, 0, player_keggle, 1, 0)
	Story_Event("LAST_STAND_03")
	Sleep(8.0)

	Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 5, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_5_marker, 0, 2, 1, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_6_marker, 5, 0, 0, 5, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_6_marker, 5, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Story_Event("LAST_STAND_04")
	Sleep(5.0)

	Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, player_keggle, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_8_marker, 8, 0, 0, 5, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_8_marker, 8, 0, 0, 0, 0, player_keggle, 1, 0)
	Story_Event("LAST_STAND_05")
	Sleep(6.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end

function End_Cinematic_Intro_CIS()
	Point_Camera_At(attacker_marker)
	Transition_To_Tactical_Camera(1.5)
	Sleep(1.5)
	Letter_Box_Out(1.5)
	Sleep(1.5)
	End_Cinematic_Camera()
	Lock_Controls(0)
	Story_Event("GOAL_TRIGGER_CIS_I")
	Suspend_AI(0)
	Resume_Mode_Based_Music()

	Story_Event("ACTIVATE_REP_AI")

	cinematic_one = false
	act_1_active = true

	Add_Radar_Blip(player_keggle, "keggle_blip")
	player_keggle.Highlight(true)
	player_keggle.Prevent_AI_Usage(true)
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
	keggle_list = Spawn_Unit(keggle_unit, outro_keggle_marker, p_invaders)
	player_keggle = keggle_list[1]
	player_keggle.Teleport_And_Face(outro_keggle_marker)
	player_keggle.Prevent_All_Fire(true)

	grievous_unit = Find_Object_Type("GENERAL_GRIEVOUS")
	grievous_list = Spawn_Unit(grievous_unit, outro_grievous_marker, p_cis)
	player_grievous = grievous_list[1]
	player_grievous.Set_Garrison_Spawn(false)
	player_grievous.Teleport_And_Face(outro_grievous_marker)

	tactical_droid_unit = Find_Object_Type("GENERAL_KALANI")
	tactical_droid_list = Spawn_Unit(tactical_droid_unit, outro_tactical_droid_marker, p_neutral)
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
	
	Set_Cinematic_Camera_Key(outrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_1_marker, 0, 0, 5, 0, outrocam_target_1_marker, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_2_marker, 13.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_2_marker, 13.5, 0, 0, 5, 0, outrocam_target_1_marker, 1, 0)
	
	Sleep(0.1)
	
	player_grievous.Play_Animation("Talk", false, 1)
	
	Story_Event("LAST_STAND_06")
	Fade_Screen_In(0.5)
	Sleep(8.0)

	Story_Event("LAST_STAND_07")
	Sleep(7)
	
	Set_Cinematic_Camera_Key(outrocam_2_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_2_marker, 0, 0, 5, 0, outrocam_target_1_marker, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_1_marker, 11, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_1_marker, 11, 0, 0, 1, 0, outrocam_target_1_marker, 1, 0)
	
	Story_Event("LAST_STAND_08")
	Sleep(4.0)
	
	player_grievous.Play_Animation("Talk", false, 2)
	Fade_Screen_Out(1.4)
	
	Story_Event("LAST_STAND_09")
	Sleep(1.2)
	
	player_keggle.Change_Owner(p_republic)
	player_keggle.Take_Damage(999999)
	
	Sleep(3.5)
	Fade_Screen_In(3.0)
	
	
	Set_Cinematic_Camera_Key(outrocam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_3_marker, 0, 0, 5, 0, outrocam_target_1_marker, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_4_marker, 15, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_4_marker, 15, 0, 0, 5, 0, outrocam_target_1_marker, 1, 0)
	
	player_grievous.Turn_To_Face(player_tactical_droid)
	player_tactical_droid.Turn_To_Face(player_grievous)
	
	Sleep(0.1)
	Story_Event("LAST_STAND_10")
	player_grievous.Play_Animation("Talk", true, 1)
	Sleep(3.0)
	
	Story_Event("LAST_STAND_11")
	Sleep (3.0)
	

	Fade_Screen_Out(5.0)
	Sleep(5.0)

	Story_Event("CIS_VICTORY")
	Resume_Mode_Based_Music()
end

function Start_Cinematic_Outro_Alt_CIS()
	act_1_active = false
	cinematic_two_alt = true
	Fade_Screen_Out(5.0)
	Letter_Box_In(0)
	Stop_All_Music()
	Cancel_Fast_Forward()

	Story_Event("DISABLE_KEGGLE_DEATH")
	Play_Music("Jyvus_Joyride_02_Alt_01")
	Story_Event("LAST_STAND_10")
	Sleep(6.5)

	Story_Event("REPUBLIC_VICTORY")
	Resume_Mode_Based_Music()
end
