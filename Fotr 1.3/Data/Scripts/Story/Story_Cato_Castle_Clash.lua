
--****************************************************--
--******* Outer Rim Sieges: Cato Castle Clash ********--
--****************************************************--

require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")

function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))

	StoryModeEvents =
	{
		Battle_Start = Begin_Battle,
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_neutral = Find_Player("Neutral")
	p_hostile = Find_Player("Hostile")

	PrimarySkydomeList_Phase_01 = {"Space_Stars"}
	SpaceLuaShuttleList_02 = {"CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT"}

	PrimarySkydomeList_Phase_02 = {"Bespin_Clouds"}
	SpaceLuaShuttleList_02 = {"CINEMATIC_CATO_NEIMOIDIA_INTRO"}

	Clone_Trooper_List = {"CLONETROOPER_PHASE_TWO_TEAM"}
	Clone_Jumptrooper_List = {"CLONE_JUMPTROOPER_PHASE_TWO_SQUAD"}
	Galactic_Marines_List = {"CLONE_GALACTIC_MARINE_PLATOON"}
	ATTE_List = {"REPUBLIC_AT_TE_WALKER_COMPANY"}
	LAAT_List = {"REPUBLIC_LAAT_GROUP"}
	HAET_List = {"REPUBLIC_HAET_GROUP"}
	AV7_List = {"REPUBLIC_AV7_COMPANY"}
	UTAT_List = {"REPUBLIC_UT_AT_SPEEDER_COMPANY"}

	B1_Droid_List = {"B1_DROID_SQUAD"}
	B2_Droid_List = {"B2_DROID_SQUAD"}
	Crab_Droid_List = {"CRAB_DROID_COMPANY"}
	Magna_TriDroid_List = {"MAGNA_COMPANY"}
	Persuader_List = {"PERSUADER_COMPANY"}
	Vulture_List = {"VULTURE_LAND_GROUP"}
	HMP_List = {"HMP_GROUP"}
	HAG_List = {"HAG_COMPANY"}

	current_cinematic_thread_id = nil

	act_1_active = false
	act_2_active = false
	act_3_active = false
	act_4_active = false

	cinematic_crawl = false
	cinematic_one = false
	cinematic_two = false

	cinematic_crawl_skipped = false
	cinematic_one_skipped = false
	cinematic_two_skipped = false

	camera_offset = 125
	intro_skipped = false
	mission_started = false
end

function Begin_Battle(message)
	if message == OnEnter then
		GlobalValue.Set("CIS_Cato_Castle_Clashed", 0)

		p_cis.Make_Ally(p_republic)
		p_republic.Make_Ally(p_cis)

		space_cinematic_centre_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "space-cinematic-centre")
		Promote_To_Space_Cinematic_Layer(space_cinematic_centre_marker)

		cinematic_lua_venator_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-venator-start")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_venator_marker)

		cinematic_lua_acclamator_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-acclamator-start")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_acclamator_marker)

		cinematic_lua_cam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-1")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_1_marker)

		cinematic_lua_cam_1_target_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-1-target")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_1_target_marker)

		cinematic_lua_cam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-2")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_2_marker)

		cinematic_lua_cam_2_target_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-2-target")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_2_target_marker)

		cinematic_lua_cam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-3")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_3_marker)

		cinematic_lua_cam_3_target_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-3-target")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_3_target_marker)

		cinematic_lua_cam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-4")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_4_marker)

		cinematic_lua_cam_4_target_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-4-target")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_4_target_marker)

		crawl_cam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawl-cam-1")
		Promote_To_Space_Cinematic_Layer(crawl_cam_1_marker)

		crawl_cam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawl-cam-2")
		Promote_To_Space_Cinematic_Layer(crawl_cam_2_marker)

		crawl_cam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawl-cam-target-1")
		Promote_To_Space_Cinematic_Layer(crawl_cam_target_1_marker)

		crawl_cam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawl-cam-target-2")
		Promote_To_Space_Cinematic_Layer(crawl_cam_target_2_marker)
		
		cam_look_at_fleet1 = Find_Hint("STORY_TRIGGER_ZONE_00", "cam-target-fleet1")
		Promote_To_Space_Cinematic_Layer(cam_look_at_fleet1)
		
		cam_look_at_fleet2 = Find_Hint("STORY_TRIGGER_ZONE_00", "cam-target-fleet2")
		Promote_To_Space_Cinematic_Layer(cam_look_at_fleet2)

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-4")
		introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-5")
		introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-6")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")
		introcam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")
		introcam_target_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-4")
		introcam_target_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-5")

		rep_intro_utat_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-intro-utat-1")
		rep_intro_clone_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-intro-clone-1")

		rep_phase_1_laat_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-phase-1-laat-1")
		rep_phase_1_laat_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-phase-1-laat-2")
		rep_phase_1_laat_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-phase-1-laat-3")

		rep_phase_1_atte_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-phase-1-atte-1")

		rep_phase_2_laat_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-phase-2-laat-1")
		rep_phase_2_laat_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-phase-2-laat-2")
		rep_phase_2_laat_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-phase-2-laat-3")
		rep_phase_2_laat_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-phase-2-laat-4")

		rep_phase_3_laat_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-phase-3-laat-1")
		rep_phase_3_laat_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-phase-3-laat-2")
		rep_phase_3_laat_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-phase-3-laat-3")

		rep_phase_4_laat_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-phase-4-laat-1")
		rep_phase_4_laat_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-phase-4-laat-2")
		rep_phase_4_laat_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-phase-4-laat-3")


		cis_intro_b1_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-intro-b1-1")
		cis_intro_magna_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-intro-magna-1")

		cis_phase_1_b1_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-phase-1-b1-1")
		cis_phase_1_b2_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-phase-1-b2-1")
		cis_phase_1_b2_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-phase-1-b2-2")
		cis_phase_1_hmp_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-phase-1-hmp-1")
		cis_phase_1_magna_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-phase-1-magna-1")
		cis_phase_1_magna_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-phase-1-magna-2")

		cis_phase_2_persuader_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-phase-1-persuader-1")
		cis_phase_2_persuader_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-phase-1-persuader-2")

		phase_3_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-3-1")
		phase_3_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-3-2")
		phase_3_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-3-3")
		phase_3_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-3-4")
		phase_3_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-3-5")

		phase_4_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-4-1")
		phase_4_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-4-2")
		phase_4_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-4-3")
		phase_4_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-4-4")
		phase_4_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-4-5")

		phase_5_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-5-1")
		phase_5_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-5-2")
		phase_5_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-5-3")

		phase_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-1")
		Register_Prox(phase_1_marker, State_Phase_01, 150, p_republic)

		phase_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-2")
		Register_Prox(phase_2_marker, State_Phase_02, 150, p_republic)

		phase_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-3")
		Register_Prox(phase_3_marker, State_Phase_03, 150, p_republic)

		phase_4_marker_list = Find_All_Objects_With_Hint("phase-4")
		for i,phase_4_marker in pairs(phase_4_marker_list) do
			Register_Prox(phase_4_marker, State_Phase_04, 150, p_republic)
		end

		phase_5_marker_list = Find_All_Objects_With_Hint("phase-5")
		for i,phase_5_marker in pairs(phase_5_marker_list) do
			Register_Prox(phase_5_marker, State_Phase_05, 150, p_republic)
		end

		Set_Cinematic_Environment(true)

		p_republic.Disable_Bombing_Run(false)
		p_republic.Disable_Orbital_Bombardment(true)

		mission_started = true

		if p_cis.Is_Human() then
			mission_started = true
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Crawl_CIS")
		elseif p_republic.Is_Human() then
			mission_started = true
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Crawl_Rep")
		end
	end
end


function State_Phase_01(prox_obj, trigger_obj)
	if trigger_obj.Get_Owner() == p_republic then
		prox_obj.Cancel_Event_Object_In_Range(State_Phase_01)
		Story_Event("PHASE_01")
	end
end

function State_Phase_02(prox_obj, trigger_obj)
	if trigger_obj.Get_Owner() == p_republic then
		prox_obj.Cancel_Event_Object_In_Range(State_Phase_02)
		Story_Event("PHASE_02")
	end
end

function State_Phase_03(prox_obj, trigger_obj)
	if trigger_obj.Get_Owner() == p_republic then
		prox_obj.Cancel_Event_Object_In_Range(State_Phase_03)
		Story_Event("PHASE_03")
	end
end

function State_Phase_04(prox_obj, trigger_obj)
	if trigger_obj.Get_Owner() == p_republic then
		prox_obj.Cancel_Event_Object_In_Range(State_Phase_04)
		Story_Event("PHASE_04")
	end
end

function State_Phase_05(prox_obj, trigger_obj)
	if trigger_obj.Get_Owner() == p_republic then
		prox_obj.Cancel_Event_Object_In_Range(State_Phase_05)
		Story_Event("PHASE_05")
	end
end


function Story_Handle_Esc()
	if mission_started then
		if p_cis.Is_Human() then
			if cinematic_crawl then
				if not cinematic_crawl_skipped then
					cinematic_crawl_skipped = true
					-- MessageBox("Escape Key Pressed!!!")

					if current_cinematic_thread_id ~= nil then
						Thread.Kill(current_cinematic_thread_id)
						current_cinematic_thread_id = nil
					end

					Stop_All_Music()
					Stop_All_Speech()
					Remove_All_Text()
					Stop_Bink_Movie()

					cinematic_crawl = false
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_01_CIS")
				end
			end
			if cinematic_one then
				if not cinematic_one_skipped then
					cinematic_one_skipped = true
					-- MessageBox("Escape Key Pressed!!!")

					if current_cinematic_thread_id ~= nil then
						Thread.Kill(current_cinematic_thread_id)
						current_cinematic_thread_id = nil
					end

					Stop_All_Music()
					Stop_All_Speech()
					Remove_All_Text()
					Stop_Bink_Movie()

					Play_Music("Cato_Castle_Clash_01")

					Lua_Space_Acclamator_List = Find_All_Objects_Of_Type("CINEMATIC_CATO_NEIMOIDIA_INTRO")
					Lua_Space_Acclamator = Lua_Space_Acclamator_List[1]

					Lua_Space_Acclamator.Hide(true)
					Lua_Space_Acclamator.Teleport(cinematic_lua_acclamator_marker)
					Lua_Space_Acclamator.Face_Immediate(space_cinematic_centre_marker)
					Lua_Space_Acclamator.Play_Animation("Cinematic", false, 0)
					Lua_Space_Acclamator.Hide(false)

					cinematic_crawl = false
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_02_CIS")
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

					Stop_All_Music()
					Stop_All_Speech()
					Remove_All_Text()
					Stop_Bink_Movie()

					Play_Music("Cato_Castle_Clash_02")

					cinematic_crawl = false
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_03_CIS")
				end
			end
			if cinematic_three then
				if not cinematic_three_skipped then
					cinematic_three_skipped = true
					-- MessageBox("Escape Key Pressed!!!")

					if current_cinematic_thread_id ~= nil then
						Thread.Kill(current_cinematic_thread_id)
						current_cinematic_thread_id = nil
					end

					Set_Cinematic_Environment(false)
					Weather_Audio_Pause(false)
					Allow_Localized_SFX(true)
					Enable_Fog(true)

					Fade_Screen_Out(0)
					Stop_All_Music()
					Stop_All_Speech()
					Remove_All_Text()
					Stop_Bink_Movie()

					Letter_Box_Out(0)
					Point_Camera_At(phase_4_3_marker)
					Story_Event("GOAL_TRIGGER_CIS_I")
					Story_Event("ACTIVATE_REP_AI")
					Lock_Controls(0)
					Suspend_AI(0)
					End_Cinematic_Camera()

					p_cis.Make_Enemy(p_republic)
					p_republic.Make_Enemy(p_cis)

					if TestValid(Find_First_Object("SPACE_STARS")) then
						Find_First_Object("SPACE_STARS").Despawn()
					end
					if TestValid(Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT")) then
						Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT").Despawn()
					end
					if TestValid(Find_First_Object("BESPIN_CLOUDS")) then
						Find_First_Object("BESPIN_CLOUDS").Despawn()
					end
					if TestValid(Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_INTRO")) then
						Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_INTRO").Despawn()
					end

					intro_list = Find_All_Objects_Of_Type(p_hostile)
					for i,intro_unit in pairs(intro_list) do
						if TestValid(intro_unit) then
							intro_unit.Despawn()
						end
					end

					Clone_Spawn_List_01 = SpawnList(Clone_Trooper_List, rep_phase_1_laat_1_marker, p_republic, true, false)
					Clone_Squad_01 = Clone_Spawn_List_01[1]

					if TestValid(MOV_phase_1_rep_laat_01) then
						MOV_phase_1_rep_laat_01.Despawn()
					end

					if TestValid(MOV_phase_1_rep_laat_02) then
						MOV_phase_1_rep_laat_02.Despawn()
					end

					LAAT_Spawn_List_01 = SpawnList(LAAT_List, rep_phase_1_laat_1_marker, p_republic, true, false)
					LAAT_Squad_01 = LAAT_Spawn_List_01[1]

					LAAT_Spawn_List_02 = SpawnList(LAAT_List, rep_phase_1_laat_2_marker, p_republic, true, false)
					LAAT_Squad_02 = LAAT_Spawn_List_02[1]

					Reinforce_Unit(Find_Object_Type("REPUBLIC_AV7_COMPANY"), false, p_republic, true, false)
					Reinforce_Unit(Find_Object_Type("REPUBLIC_BARC_COMPANY"), false, p_republic, true, false)
					Reinforce_Unit(Find_Object_Type("REPUBLIC_BARC_COMPANY"), false, p_republic, true, false)
					Reinforce_Unit(Find_Object_Type("REPUBLIC_AT_RT_COMPANY"), false, p_republic, true, false)
					Reinforce_Unit(Find_Object_Type("REPUBLIC_AT_RT_COMPANY"), false, p_republic, true, false)
					Reinforce_Unit(Find_Object_Type("REPUBLIC_AT_RT_COMPANY"), false, p_republic, true, false)

					Reinforce_Unit(Find_Object_Type("REPUBLIC_AT_TE_WALKER_COMPANY"), false, p_republic, true, false)
					Reinforce_Unit(Find_Object_Type("REPUBLIC_AT_TE_WALKER_COMPANY"), false, p_republic, true, false)
					Reinforce_Unit(Find_Object_Type("REPUBLIC_HAET_GROUP"), false, p_republic, true, false)
					Reinforce_Unit(Find_Object_Type("REPUBLIC_HAET_GROUP"), false, p_republic, true, false)

					Reinforce_Unit(Find_Object_Type("CLONETROOPER_PHASE_TWO_TEAM"), false, p_republic, true, false)
					Reinforce_Unit(Find_Object_Type("CLONETROOPER_PHASE_TWO_TEAM"), false, p_republic, true, false)
					Reinforce_Unit(Find_Object_Type("CLONE_GALACTIC_MARINE_PLATOON"), false, p_republic, true, false)
					Reinforce_Unit(Find_Object_Type("CLONE_GALACTIC_MARINE_PLATOON"), false, p_republic, true, false)
					Reinforce_Unit(Find_Object_Type("CLONE_GALACTIC_MARINE_PLATOON"), false, p_republic, true, false)

					cinematic_one = false
					act_1_active = true

					Fade_Screen_In(0.5)
					Sleep(0.5)
				end
			end
		elseif p_republic.Is_Human() then
			if cinematic_crawl then
				if not cinematic_crawl_skipped then
					cinematic_crawl_skipped = true
					-- MessageBox("Escape Key Pressed!!!")

					if current_cinematic_thread_id ~= nil then
						Thread.Kill(current_cinematic_thread_id)
						current_cinematic_thread_id = nil
					end

					Stop_All_Music()
					Stop_All_Speech()
					Remove_All_Text()
					Stop_Bink_Movie()

					cinematic_crawl = false
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_01_Rep")
				end
			end
			if cinematic_one then
				if not cinematic_one_skipped then
					cinematic_one_skipped = true
					-- MessageBox("Escape Key Pressed!!!")

					if current_cinematic_thread_id ~= nil then
						Thread.Kill(current_cinematic_thread_id)
						current_cinematic_thread_id = nil
					end

					Stop_All_Music()
					Stop_All_Speech()
					Remove_All_Text()
					Stop_Bink_Movie()

					Play_Music("Cato_Castle_Clash_01")

					Lua_Space_Acclamator_List = Find_All_Objects_Of_Type("CINEMATIC_CATO_NEIMOIDIA_INTRO")
					Lua_Space_Acclamator = Lua_Space_Acclamator_List[1]

					Lua_Space_Acclamator.Hide(true)
					Lua_Space_Acclamator.Teleport(cinematic_lua_acclamator_marker)
					Lua_Space_Acclamator.Face_Immediate(space_cinematic_centre_marker)
					Lua_Space_Acclamator.Play_Animation("Cinematic", false, 0)
					Lua_Space_Acclamator.Hide(false)

					cinematic_crawl = false
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_02_Rep")
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

					Stop_All_Music()
					Stop_All_Speech()
					Remove_All_Text()
					Stop_Bink_Movie()

					Play_Music("Cato_Castle_Clash_02")

					cinematic_crawl = false
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_03_Rep")
				end
			end
			if cinematic_three then
				if not cinematic_three_skipped then
					cinematic_three_skipped = true
					-- MessageBox("Escape Key Pressed!!!")

					if current_cinematic_thread_id ~= nil then
						Thread.Kill(current_cinematic_thread_id)
						current_cinematic_thread_id = nil
					end

					Set_Cinematic_Environment(false)
					Weather_Audio_Pause(false)
					Allow_Localized_SFX(true)
					Enable_Fog(true)

					Fade_Screen_Out(0)
					Stop_All_Music()
					Stop_All_Speech()
					Remove_All_Text()
					Stop_Bink_Movie()

					Letter_Box_Out(0)
					Point_Camera_At(rep_phase_1_laat_1_marker)
					Story_Event("GOAL_TRIGGER_REP_I")
					Story_Event("ACTIVATE_CIS_AI")
					Lock_Controls(0)
					Suspend_AI(0)
					End_Cinematic_Camera()

					p_cis.Make_Enemy(p_republic)
					p_republic.Make_Enemy(p_cis)

					if TestValid(Find_First_Object("SPACE_STARS")) then
						Find_First_Object("SPACE_STARS").Despawn()
					end
					if TestValid(Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT")) then
						Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT").Despawn()
					end
					if TestValid(Find_First_Object("BESPIN_CLOUDS")) then
						Find_First_Object("BESPIN_CLOUDS").Despawn()
					end
					if TestValid(Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_INTRO")) then
						Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_INTRO").Despawn()
					end

					intro_list = Find_All_Objects_Of_Type(p_hostile)
					for i,intro_unit in pairs(intro_list) do
						if TestValid(intro_unit) then
							intro_unit.Despawn()
						end
					end

					if not TestValid(Find_First_Object("Anakin2")) then
						anakin_unit = Find_Object_Type("Anakin2")
						anakin_list = Spawn_Unit(anakin_unit, rep_phase_1_laat_1_marker, p_republic)
						player_anakin = anakin_list[1]
						player_anakin.Teleport_And_Face(rep_phase_1_laat_1_marker)
					end
					if not TestValid(Find_First_Object("Obi_Wan2")) then
						obiwan_unit = Find_Object_Type("Obi_Wan2")
						obiwan_list = Spawn_Unit(obiwan_unit, rep_phase_1_laat_1_marker, p_republic)
						player_obiwan = obiwan_list[1]
						player_obiwan.Teleport_And_Face(rep_phase_1_laat_1_marker)
					end
					if not TestValid(Find_First_Object("Cody2")) then
						cody_unit = Find_Object_Type("Cody2")
						cody_list = Spawn_Unit(cody_unit, rep_phase_1_laat_1_marker, p_republic)
						player_cody = cody_list[1]
						player_cody.Teleport_And_Face(rep_phase_1_laat_1_marker)
					end

					Clone_Spawn_List_01 = SpawnList(Clone_Trooper_List, rep_phase_1_laat_1_marker, p_republic, true, false)
					Clone_Squad_01 = Clone_Spawn_List_01[1]

					Clone_Spawn_List_02 = SpawnList(Galactic_Marines_List, rep_phase_1_laat_2_marker, p_republic, true, false)
					Clone_Squad_02 = Clone_Spawn_List_02[1]

					Clone_Spawn_List_03 = SpawnList(Clone_Jumptrooper_List, rep_phase_1_laat_3_marker, p_republic, true, false)
					Clone_Squad_03 = Clone_Spawn_List_03[1]

					Clone_Spawn_List_04 = SpawnList(Clone_Jumptrooper_List, rep_phase_1_laat_3_marker, p_republic, true, false)
					Clone_Squad_04 = Clone_Spawn_List_04[1]

					ATTE_Spawn_List_01 = SpawnList(ATTE_List, rep_phase_1_atte_1_marker, p_republic, true, false)
					ATTE_Squad_01 = ATTE_Spawn_List_01[1]

					if TestValid(MOV_phase_1_rep_laat_01) then
						MOV_phase_1_rep_laat_01.Despawn()
					end

					if TestValid(MOV_phase_1_rep_laat_02) then
						MOV_phase_1_rep_laat_02.Despawn()
					end

					LAAT_Spawn_List_01 = SpawnList(LAAT_List, rep_phase_1_laat_1_marker, p_republic, true, false)
					LAAT_Squad_01 = LAAT_Spawn_List_01[1]

					LAAT_Spawn_List_02 = SpawnList(LAAT_List, rep_phase_1_laat_2_marker, p_republic, true, false)
					LAAT_Squad_02 = LAAT_Spawn_List_02[1]


					B1_Spawn_List_01 = SpawnList(B1_Droid_List, cis_phase_1_b1_1_marker, p_cis, true, false)
					B1_Squad_01 = B1_Spawn_List_01[1]

					B2_Spawn_List_01 = SpawnList(B2_Droid_List, cis_phase_1_b2_1_marker, p_cis, true, false)
					B2_Squad_01 = B1_Spawn_List_01[1]

					B2_Spawn_List_02 = SpawnList(B2_Droid_List, cis_phase_1_b2_2_marker, p_cis, true, false)
					B2_Squad_02 = B2_Spawn_List_02[1]

					HMP_Spawn_List_01 = SpawnList(HMP_List, cis_phase_1_hmp_1_marker, p_cis, true, false)
					HMP_Squad_01 = HMP_Spawn_List_01[1]

					Magna_Spawn_List_01 = SpawnList(Magna_TriDroid_List, cis_phase_1_magna_1_marker, p_cis, true, false)
					Magna_Squad_01 = Magna_Spawn_List_01[1]

					Magna_Spawn_List_02 = SpawnList(Magna_TriDroid_List, cis_phase_1_magna_2_marker, p_cis, true, false)
					Magna_Squad_02 = Magna_Spawn_List_02[1]

					cinematic_one = false
					act_1_active = true

					Fade_Screen_In(0.5)
					Sleep(0.5)
				end
			end
		end
	end
end

function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_1_active then
			rep_list = Find_All_Objects_Of_Type(p_republic, "Infantry, LandHero, Vehicle, Air")
			if (table.getn(cis_list) == 0) then
				GlobalValue.Set("CIS_Cato_Castle_Clashed", 0)
			end
		end
	end
	if p_republic.Is_Human() then
		if act_1_active then
		end
	end
end


function Start_Cinematic_Crawl_CIS()
	Start_Cinematic_Camera()
	Stop_All_Music()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()
	Fade_On()

	Allow_Localized_SFX(false)
	SFXManager.Allow_HUD_VO(false)
	SFXManager.Allow_Ambient_VO(false)
	SFXManager.Allow_Enemy_Sighted_VO(false)
	SFXManager.Allow_Unit_Reponse_VO(false)

	primary_space_skydome_list = SpawnList(PrimarySkydomeList_Phase_01, space_cinematic_centre_marker, p_republic, false, false)
	cinematic_skydome_01 = primary_space_skydome_list[1]
	cinematic_skydome_01.Teleport_And_Face(space_cinematic_centre_marker)

	Weather_Audio_Pause(true)
	Start_Cinematic_Camera(false)
	Allow_Localized_SFX(false)
	Enable_Fog(false)

	Lua_Space_Venator_List = Find_All_Objects_Of_Type("CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT")
	Lua_Space_Venator = Lua_Space_Venator_List[1]

	Lua_Space_Venator.Hide(true)
	Lua_Space_Venator.Teleport(cinematic_lua_venator_marker)
	Lua_Space_Venator.Face_Immediate(space_cinematic_centre_marker)

	Set_Cinematic_Camera_Key(crawl_cam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(crawl_cam_1_marker, 0, 0, 0, 0, crawl_cam_target_1_marker, 1, 0)
	Fade_Screen_In(1)

	cinematic_crawl = true
	BlockOnCommand(Play_Bink_Movie("A_Long_Time_Ago_Campaign_Intro"))

	Play_Music("Clone_Wars_Crawl_Theme")
	BlockOnCommand(Play_Bink_Movie("Outer_Rim_Sieges_Campaign_Intro"))

	if not cinematic_crawl_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_01_CIS")
	end
end

function Start_Cinematic_Intro_01_CIS()
	Transition_Cinematic_Camera_Key(crawl_cam_2_marker, 11, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(crawl_cam_2_marker, 11, 0, 0, 0, 0, crawl_cam_target_2_marker, 1, 0)

	Lua_Space_Venator_List = Find_All_Objects_Of_Type("CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT")
	Lua_Space_Venator = Lua_Space_Venator_List[1]

	Lua_Space_Venator.Play_Animation("Cinematic", false, 0)
	Lua_Space_Venator.Hide(false)

	cinematic_one = true
	Play_Music("Cato_Castle_Clash_01")
	Letter_Box_In(1.0)

	Sleep(2)

	Story_Event("LIBERATION_01")
	Sleep(10)

	Transition_Cinematic_Camera_Key(cinematic_lua_venator_marker, 15, 100, -20, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cinematic_lua_venator_marker, 15, 0, 0, -40, 0, 0, 0, 0)
	Story_Event("LIBERATION_02")
	Sleep(2)
	
	Set_Cinematic_Camera_Key(cam_look_at_fleet1, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_look_at_fleet1, 0, 0, 0, 0, cinematic_lua_venator_marker, 1, 0)
	Transition_Cinematic_Camera_Key(cam_look_at_fleet2, 10, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_look_at_fleet2, 10, 0, 0, 0, 0, cinematic_lua_venator_marker, 1, 0)
	Sleep(8)

	Lua_Space_Acclamator_List = Find_All_Objects_Of_Type("CINEMATIC_CATO_NEIMOIDIA_INTRO")
	Lua_Space_Acclamator = Lua_Space_Acclamator_List[1]

	Lua_Space_Acclamator.Hide(true)
	Lua_Space_Acclamator.Play_Animation("Cinematic", false, 0)
	Lua_Space_Acclamator.Hide(false)

	Sleep(2)

	Story_Event("LIBERATION_03")
	Sleep(4)

	Fade_Screen_Out(1)
	Sleep(3)

	if not cinematic_one_skipped then
		Create_Thread("Start_Cinematic_Intro_02_CIS")
	end
end

function Start_Cinematic_Intro_02_CIS()
	if TestValid(Find_First_Object("SPACE_STARS")) then
		Find_First_Object("SPACE_STARS").Despawn()
	end
	if TestValid(Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT")) then
		Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT").Despawn()
	end
	cinematic_two = true

	Play_Music("Cato_Castle_Clash_02")

	primary_space_skydome_list = SpawnList(PrimarySkydomeList_Phase_02, space_cinematic_centre_marker, p_republic, false, false)
	cinematic_skydome_02 = primary_space_skydome_list[1]
	cinematic_skydome_02.Teleport_And_Face(space_cinematic_centre_marker)

	Weather_Audio_Pause(true)
	Start_Cinematic_Camera(false)
	Allow_Localized_SFX(false)
	Enable_Fog(false)

	Lua_Space_Acclamator_List = Find_All_Objects_Of_Type("CINEMATIC_CATO_NEIMOIDIA_INTRO")
	Lua_Space_Acclamator = Lua_Space_Acclamator_List[1]

	Lua_Space_Acclamator.Hide(true)
	Lua_Space_Acclamator.Teleport(cinematic_lua_acclamator_marker)
	Lua_Space_Acclamator.Face_Immediate(space_cinematic_centre_marker)
	Lua_Space_Acclamator.Hide(false)

	Sleep(1.0)

	Set_Cinematic_Camera_Key(cinematic_lua_cam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cinematic_lua_cam_1_target_marker, 0, 0, 0, 0, 0, 0, 0)
	Transition_Cinematic_Camera_Key(cinematic_lua_cam_1_marker, 6, 0, -200, 0, 0, 0, 0, 0)
	Story_Event("LIBERATION_04")
	Fade_Screen_In(7.0)
	Sleep(6)

	Set_Cinematic_Camera_Key(cinematic_lua_cam_2_marker, 0, -150, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cinematic_lua_cam_2_target_marker, 0, -150, 0, 0, 0, 0, 0)
	Transition_Cinematic_Camera_Key(cinematic_lua_cam_2_marker, 5, 0, 10, 0, 0, 0, 0, 0)
	Story_Event("LIBERATION_05")
	Sleep(5)

	Set_Cinematic_Camera_Key(cinematic_lua_cam_3_marker, 0, -100, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cinematic_lua_cam_2_target_marker, 0, -100, 0, 0, 0, 0, 0)
	Transition_Cinematic_Camera_Key(cinematic_lua_cam_3_marker, 12, 0, 10, 0, 0, 0, 0, 0)
	Sleep(3.5)

	Story_Event("LIBERATION_05")
	Sleep(5.5)

	Fade_Screen_Out(2)
	Sleep(2)

	Set_Cinematic_Environment(false)
	Enable_Fog(true)

	if not cinematic_two_skipped then
		Create_Thread("Start_Cinematic_Intro_03_CIS")
	end
end

function Start_Cinematic_Intro_03_CIS()
	if TestValid(Find_First_Object("SPACE_STARS")) then
		Find_First_Object("SPACE_STARS").Despawn()
	end
	if TestValid(Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT")) then
		Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT").Despawn()
	end
	if TestValid(Find_First_Object("BESPIN_CLOUDS")) then
		Find_First_Object("BESPIN_CLOUDS").Despawn()
	end
	if TestValid(Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_INTRO")) then
		Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_INTRO").Despawn()
	end
	cinematic_three = true

	p_republic.Make_Enemy(p_cis)
	p_cis.Make_Enemy(p_republic)

	Allow_Localized_SFX(true)
	SFXManager.Allow_HUD_VO(true)
	SFXManager.Allow_Ambient_VO(true)
	SFXManager.Allow_Enemy_Sighted_VO(true)
	SFXManager.Allow_Unit_Reponse_VO(true)
	Set_Cinematic_Environment(false)
	Enable_Fog(true)

	Sleep(1)

	Story_Event("CINEMATIC_CRAWL_01")
	Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 5.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 5.5, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Fade_Screen_In(2.0)
	Sleep(3)

	Story_Event("CINEMATIC_CRAWL_02")
	Sleep(2)

	Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_4_marker, 7.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_4_marker, 7.5, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
	Sleep(6.5)

	Fade_Screen_Out(0.25)
	Sleep(0.5)

	MOV_phase_1_rep_laat_01 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), rep_phase_1_laat_1_marker, 225, 1,0.25, 20, 1)
	Hide_Sub_Object(MOV_phase_1_rep_laat_01, 1, "Clones")

	MOV_phase_1_rep_laat_02 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), rep_phase_1_laat_2_marker, 225, 1,0.25, 20, 1)
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Boil")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Boil_Carbine")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Boil_Helmet")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Waxer")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Waxer_Carbine")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Waxer_Helmet")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Cody")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Cody_Carbine")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "CodyHelmet")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Obi")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Obi_Clones")

	MOV_phase_1_rep_laat_03 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), rep_phase_1_laat_3_marker, 225, 1,0.25, 20, 0)
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Boil")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Boil_Carbine")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Boil_Helmet")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Waxer")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Waxer_Carbine")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Waxer_Helmet")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Cody")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Cody_Carbine")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "CodyHelmet")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Obi")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Obi_Clones")

	Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_5_marker, 0, 0, 0, 0, introcam_target_5_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_6_marker, 5.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_6_marker, 5.5, 0, 0, 0, 0, introcam_target_5_marker, 1, 0)

	Story_Event("LIBERATION_07")
	Fade_Screen_In(2.0)
	Sleep(10)

	if not cinematic_three_skipped then
		Create_Thread("End_Cinematic_Intro_CIS")
	end
end

function End_Cinematic_Intro_CIS()

	Clone_Spawn_List_01 = SpawnList(Clone_Trooper_List, rep_phase_1_laat_1_marker, p_republic, true, false)
	Clone_Squad_01 = Clone_Spawn_List_01[1]

	if TestValid(MOV_phase_1_rep_laat_01) then
		MOV_phase_1_rep_laat_01.Despawn()
	end

	if TestValid(MOV_phase_1_rep_laat_02) then
		MOV_phase_1_rep_laat_02.Despawn()
	end

	LAAT_Spawn_List_01 = SpawnList(LAAT_List, rep_phase_1_laat_1_marker, p_republic, true, false)
	LAAT_Squad_01 = LAAT_Spawn_List_01[1]

	LAAT_Spawn_List_02 = SpawnList(LAAT_List, rep_phase_1_laat_2_marker, p_republic, true, false)
	LAAT_Squad_02 = LAAT_Spawn_List_02[1]

	Reinforce_Unit(Find_Object_Type("REPUBLIC_AV7_COMPANY"), false, p_republic, true, false)
	Reinforce_Unit(Find_Object_Type("REPUBLIC_BARC_COMPANY"), false, p_republic, true, false)
	Reinforce_Unit(Find_Object_Type("REPUBLIC_BARC_COMPANY"), false, p_republic, true, false)
	Reinforce_Unit(Find_Object_Type("REPUBLIC_AT_RT_COMPANY"), false, p_republic, true, false)
	Reinforce_Unit(Find_Object_Type("REPUBLIC_AT_RT_COMPANY"), false, p_republic, true, false)
	Reinforce_Unit(Find_Object_Type("REPUBLIC_AT_RT_COMPANY"), false, p_republic, true, false)

	Reinforce_Unit(Find_Object_Type("REPUBLIC_AT_TE_WALKER_COMPANY"), false, p_republic, true, false)
	Reinforce_Unit(Find_Object_Type("REPUBLIC_AT_TE_WALKER_COMPANY"), false, p_republic, true, false)
	Reinforce_Unit(Find_Object_Type("REPUBLIC_HAET_GROUP"), false, p_republic, true, false)
	Reinforce_Unit(Find_Object_Type("REPUBLIC_HAET_GROUP"), false, p_republic, true, false)

	Reinforce_Unit(Find_Object_Type("CLONETROOPER_PHASE_TWO_TEAM"), false, p_republic, true, false)
	Reinforce_Unit(Find_Object_Type("CLONETROOPER_PHASE_TWO_TEAM"), false, p_republic, true, false)
	Reinforce_Unit(Find_Object_Type("CLONE_GALACTIC_MARINE_PLATOON"), false, p_republic, true, false)
	Reinforce_Unit(Find_Object_Type("CLONE_GALACTIC_MARINE_PLATOON"), false, p_republic, true, false)
	Reinforce_Unit(Find_Object_Type("CLONE_GALACTIC_MARINE_PLATOON"), false, p_republic, true, false)

	Point_Camera_At(phase_4_3_marker)
	Transition_To_Tactical_Camera(1.5)
	Sleep(1.5)
	Letter_Box_Out(1.5)
	Sleep(1.5)
	End_Cinematic_Camera()
	Lock_Controls(0)
	Story_Event("GOAL_TRIGGER_CIS_I")
	Story_Event("ACTIVATE_REP_AI")
	Suspend_AI(0)
	Resume_Mode_Based_Music()

	cinematic_one = false
	act_1_active = true
end


function Start_Cinematic_Crawl_Rep()
	Start_Cinematic_Camera()
	Stop_All_Music()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()
	Fade_On()

	Allow_Localized_SFX(false)
	SFXManager.Allow_HUD_VO(false)
	SFXManager.Allow_Ambient_VO(false)
	SFXManager.Allow_Enemy_Sighted_VO(false)
	SFXManager.Allow_Unit_Reponse_VO(false)

	primary_space_skydome_list = SpawnList(PrimarySkydomeList_Phase_01, space_cinematic_centre_marker, p_republic, false, false)
	cinematic_skydome_01 = primary_space_skydome_list[1]
	cinematic_skydome_01.Teleport_And_Face(space_cinematic_centre_marker)

	Weather_Audio_Pause(true)
	Start_Cinematic_Camera(false)
	Allow_Localized_SFX(false)
	Enable_Fog(false)

	Lua_Space_Venator_List = Find_All_Objects_Of_Type("CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT")
	Lua_Space_Venator = Lua_Space_Venator_List[1]

	Lua_Space_Venator.Hide(true)
	Lua_Space_Venator.Teleport(cinematic_lua_venator_marker)
	Lua_Space_Venator.Face_Immediate(space_cinematic_centre_marker)

	Set_Cinematic_Camera_Key(crawl_cam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(crawl_cam_1_marker, 0, 0, 0, 0, crawl_cam_target_1_marker, 1, 0)
	Fade_Screen_In(1)

	cinematic_crawl = true
	BlockOnCommand(Play_Bink_Movie("A_Long_Time_Ago_Campaign_Intro"))

	Play_Music("Clone_Wars_Crawl_Theme")
	BlockOnCommand(Play_Bink_Movie("Outer_Rim_Sieges_Campaign_Intro"))

	if not cinematic_crawl_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_01_Rep")
	end
end

function Start_Cinematic_Intro_01_Rep()
	Transition_Cinematic_Camera_Key(crawl_cam_2_marker, 11, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(crawl_cam_2_marker, 11, 0, 0, 0, 0, crawl_cam_target_2_marker, 1, 0)

	Lua_Space_Venator_List = Find_All_Objects_Of_Type("CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT")
	Lua_Space_Venator = Lua_Space_Venator_List[1]

	Lua_Space_Venator.Play_Animation("Cinematic", false, 0)
	Lua_Space_Venator.Hide(false)

	cinematic_one = true
	Play_Music("Cato_Castle_Clash_01")
	Letter_Box_In(1.0)

	Sleep(2)

	Story_Event("LIBERATION_01")
	Sleep(10)

	Transition_Cinematic_Camera_Key(cinematic_lua_venator_marker, 15, 100, -20, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cinematic_lua_venator_marker, 15, 0, 0, -40, 0, 0, 0, 0)
	Story_Event("LIBERATION_02")
	Sleep(2)
	
	Set_Cinematic_Camera_Key(cam_look_at_fleet1, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_look_at_fleet1, 0, 0, 0, 0, cinematic_lua_venator_marker, 1, 0)
	Transition_Cinematic_Camera_Key(cam_look_at_fleet2, 10, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_look_at_fleet2, 10, 0, 0, 0, 0, cinematic_lua_venator_marker, 1, 0)
	Sleep(8)

	Lua_Space_Acclamator_List = Find_All_Objects_Of_Type("CINEMATIC_CATO_NEIMOIDIA_INTRO")
	Lua_Space_Acclamator = Lua_Space_Acclamator_List[1]

	Lua_Space_Acclamator.Hide(true)
	Lua_Space_Acclamator.Play_Animation("Cinematic", false, 0)
	Lua_Space_Acclamator.Hide(false)

	Sleep(2)

	Story_Event("LIBERATION_03")
	Sleep(4)

	Fade_Screen_Out(1)
	Sleep(3)

	if not cinematic_one_skipped then
		Create_Thread("Start_Cinematic_Intro_02_Rep")
	end
end

function Start_Cinematic_Intro_02_Rep()
	if TestValid(Find_First_Object("SPACE_STARS")) then
		Find_First_Object("SPACE_STARS").Despawn()
	end
	if TestValid(Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT")) then
		Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT").Despawn()
	end
	cinematic_two = true

	Play_Music("Cato_Castle_Clash_02")

	primary_space_skydome_list = SpawnList(PrimarySkydomeList_Phase_02, space_cinematic_centre_marker, p_republic, false, false)
	cinematic_skydome_02 = primary_space_skydome_list[1]
	cinematic_skydome_02.Teleport_And_Face(space_cinematic_centre_marker)

	Weather_Audio_Pause(true)
	Start_Cinematic_Camera(false)
	Allow_Localized_SFX(false)
	Enable_Fog(false)

	Lua_Space_Acclamator_List = Find_All_Objects_Of_Type("CINEMATIC_CATO_NEIMOIDIA_INTRO")
	Lua_Space_Acclamator = Lua_Space_Acclamator_List[1]

	Lua_Space_Acclamator.Hide(true)
	Lua_Space_Acclamator.Teleport(cinematic_lua_acclamator_marker)
	Lua_Space_Acclamator.Face_Immediate(space_cinematic_centre_marker)
	Lua_Space_Acclamator.Hide(false)

	Sleep(1.0)

	Set_Cinematic_Camera_Key(cinematic_lua_cam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cinematic_lua_cam_1_target_marker, 0, 0, 0, 0, 0, 0, 0)
	Transition_Cinematic_Camera_Key(cinematic_lua_cam_1_marker, 6, 0, -200, 0, 0, 0, 0, 0)
	Story_Event("LIBERATION_04")
	Fade_Screen_In(7.0)
	Sleep(6)

	Set_Cinematic_Camera_Key(cinematic_lua_cam_2_marker, 0, -150, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cinematic_lua_cam_2_target_marker, 0, -150, 0, 0, 0, 0, 0)
	Transition_Cinematic_Camera_Key(cinematic_lua_cam_2_marker, 5, 0, 10, 0, 0, 0, 0, 0)
	Story_Event("LIBERATION_05")
	Sleep(5)

	Set_Cinematic_Camera_Key(cinematic_lua_cam_3_marker, 0, -100, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cinematic_lua_cam_2_target_marker, 0, -100, 0, 0, 0, 0, 0)
	Transition_Cinematic_Camera_Key(cinematic_lua_cam_3_marker, 12, 0, 10, 0, 0, 0, 0, 0)
	Sleep(3.5)

	Story_Event("LIBERATION_05")
	Sleep(5.5)

	Fade_Screen_Out(2)
	Sleep(2)

	Set_Cinematic_Environment(false)
	Enable_Fog(true)

	if not cinematic_two_skipped then
		Create_Thread("Start_Cinematic_Intro_03_Rep")
	end
end

function Start_Cinematic_Intro_03_Rep()
	if TestValid(Find_First_Object("SPACE_STARS")) then
		Find_First_Object("SPACE_STARS").Despawn()
	end
	if TestValid(Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT")) then
		Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT").Despawn()
	end
	if TestValid(Find_First_Object("BESPIN_CLOUDS")) then
		Find_First_Object("BESPIN_CLOUDS").Despawn()
	end
	if TestValid(Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_INTRO")) then
		Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_INTRO").Despawn()
	end
	cinematic_three = true

	p_republic.Make_Enemy(p_cis)
	p_cis.Make_Enemy(p_republic)

	Allow_Localized_SFX(true)
	SFXManager.Allow_HUD_VO(true)
	SFXManager.Allow_Ambient_VO(true)
	SFXManager.Allow_Enemy_Sighted_VO(true)
	SFXManager.Allow_Unit_Reponse_VO(true)
	Set_Cinematic_Environment(false)
	Enable_Fog(true)

	Sleep(1)

	Story_Event("CINEMATIC_CRAWL_01")
	Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 5.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 5.5, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Fade_Screen_In(2.0)
	Sleep(3)

	Story_Event("CINEMATIC_CRAWL_02")
	Sleep(2)

	Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_4_marker, 7.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_4_marker, 7.5, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
	Sleep(6.5)

	Fade_Screen_Out(0.25)
	Sleep(0.5)

	MOV_phase_1_rep_laat_01 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), rep_phase_1_laat_1_marker, 225, 1,0.25, 20, 1)
	Hide_Sub_Object(MOV_phase_1_rep_laat_01, 1, "Clones")

	MOV_phase_1_rep_laat_02 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), rep_phase_1_laat_2_marker, 225, 1,0.25, 20, 1)
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Boil")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Boil_Carbine")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Boil_Helmet")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Waxer")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Waxer_Carbine")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Waxer_Helmet")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Cody")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Cody_Carbine")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "CodyHelmet")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Obi")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Obi_Clones")

	MOV_phase_1_rep_laat_03 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), rep_phase_1_laat_3_marker, 225, 1,0.25, 20, 0)
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Boil")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Boil_Carbine")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Boil_Helmet")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Waxer")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Waxer_Carbine")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Waxer_Helmet")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Cody")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Cody_Carbine")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "CodyHelmet")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Obi")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Obi_Clones")

	Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_5_marker, 0, 0, 0, 0, introcam_target_5_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_6_marker, 5.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_6_marker, 5.5, 0, 0, 0, 0, introcam_target_5_marker, 1, 0)

	Story_Event("LIBERATION_07")
	Fade_Screen_In(2.0)
	Sleep(10)

	if not cinematic_three_skipped then
		Create_Thread("End_Cinematic_Intro_Rep")
	end
end

function End_Cinematic_Intro_Rep()
	if not TestValid(Find_First_Object("Anakin2")) then
		anakin_unit = Find_Object_Type("Anakin2")
		anakin_list = Spawn_Unit(anakin_unit, rep_phase_1_laat_1_marker, p_republic)
		player_anakin = anakin_list[1]
		player_anakin.Teleport_And_Face(rep_phase_1_laat_1_marker)
	end
	if not TestValid(Find_First_Object("Obi_Wan2")) then
		obiwan_unit = Find_Object_Type("Obi_Wan2")
		obiwan_list = Spawn_Unit(obiwan_unit, rep_phase_1_laat_1_marker, p_republic)
		player_obiwan = obiwan_list[1]
		player_obiwan.Teleport_And_Face(rep_phase_1_laat_1_marker)
	end
	if not TestValid(Find_First_Object("Cody2")) then
		cody_unit = Find_Object_Type("Cody2")
		cody_list = Spawn_Unit(cody_unit, rep_phase_1_laat_1_marker, p_republic)
		player_cody = cody_list[1]
		player_cody.Teleport_And_Face(rep_phase_1_laat_1_marker)
	end

	Clone_Spawn_List_01 = SpawnList(Clone_Trooper_List, rep_phase_1_laat_1_marker, p_republic, true, false)
	Clone_Squad_01 = Clone_Spawn_List_01[1]

	Clone_Spawn_List_02 = SpawnList(Galactic_Marines_List, rep_phase_1_laat_2_marker, p_republic, true, false)
	Clone_Squad_02 = Clone_Spawn_List_02[1]

	Clone_Spawn_List_03 = SpawnList(Clone_Jumptrooper_List, rep_phase_1_laat_3_marker, p_republic, true, false)
	Clone_Squad_03 = Clone_Spawn_List_03[1]

	Clone_Spawn_List_04 = SpawnList(Clone_Jumptrooper_List, rep_phase_1_laat_3_marker, p_republic, true, false)
	Clone_Squad_04 = Clone_Spawn_List_04[1]

	ATTE_Spawn_List_01 = SpawnList(ATTE_List, rep_phase_1_atte_1_marker, p_republic, true, false)
	ATTE_Squad_01 = ATTE_Spawn_List_01[1]

	if TestValid(MOV_phase_1_rep_laat_01) then
		MOV_phase_1_rep_laat_01.Despawn()
	end

	if TestValid(MOV_phase_1_rep_laat_02) then
		MOV_phase_1_rep_laat_02.Despawn()
	end

	LAAT_Spawn_List_01 = SpawnList(LAAT_List, rep_phase_1_laat_1_marker, p_republic, true, false)
	LAAT_Squad_01 = LAAT_Spawn_List_01[1]

	LAAT_Spawn_List_02 = SpawnList(LAAT_List, rep_phase_1_laat_2_marker, p_republic, true, false)
	LAAT_Squad_02 = LAAT_Spawn_List_02[1]


	B1_Spawn_List_01 = SpawnList(B1_Droid_List, cis_phase_1_b1_1_marker, p_cis, true, false)
	B1_Squad_01 = B1_Spawn_List_01[1]

	B2_Spawn_List_01 = SpawnList(B2_Droid_List, cis_phase_1_b2_1_marker, p_cis, true, false)
	B2_Squad_01 = B1_Spawn_List_01[1]

	B2_Spawn_List_02 = SpawnList(B2_Droid_List, cis_phase_1_b2_2_marker, p_cis, true, false)
	B2_Squad_02 = B2_Spawn_List_02[1]

	HMP_Spawn_List_01 = SpawnList(HMP_List, cis_phase_1_hmp_1_marker, p_cis, true, false)
	HMP_Squad_01 = HMP_Spawn_List_01[1]

	Magna_Spawn_List_01 = SpawnList(Magna_TriDroid_List, cis_phase_1_magna_1_marker, p_cis, true, false)
	Magna_Squad_01 = Magna_Spawn_List_01[1]

	Magna_Spawn_List_02 = SpawnList(Magna_TriDroid_List, cis_phase_1_magna_2_marker, p_cis, true, false)
	Magna_Squad_02 = Magna_Spawn_List_02[1]

	Point_Camera_At(rep_phase_1_laat_1_marker)
	Transition_To_Tactical_Camera(1.5)
	Sleep(1.5)
	Letter_Box_Out(1.5)
	Sleep(1.5)
	End_Cinematic_Camera()
	Lock_Controls(0)
	Story_Event("GOAL_TRIGGER_REP_I")
	Story_Event("ACTIVATE_CIS_AI")
	Suspend_AI(0)
	Resume_Mode_Based_Music()

	cinematic_one = false
	act_1_active = true
end
