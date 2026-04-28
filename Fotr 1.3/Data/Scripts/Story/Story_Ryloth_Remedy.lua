
--****************************************************--
--*************** Rimward: Ryloth Remedy *************--
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
		Trigger_Landing_Zone_Captured = State_Landing_Zone_Captured,
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_neutral = Find_Player("Neutral")

	PrimarySkydomeList = {"Bespin_Clouds"}
	SpaceLuaShuttleList = {"Cinematic_Ryloth_Intro"}
	Clone_Team_List = {"Clonetrooper_Phase_One_Team"}
	J1_Team_List = {"J1_Cannon_Artillery_Anim"}

	current_cinematic_thread_id = nil

	act_1_active = false
	act_2_active = false
	act_3_active = false

	cinematic_one = false
	cinematic_two = false
	cinematic_three = false

	cinematic_one_skipped = false
	cinematic_two_skipped = false
	cinematic_three_skipped = false

	first_twilek_freed = false

	camera_offset = 125
	intro_skipped = false
	mission_started = false
end

function Begin_Battle(message)
	if message == OnEnter then
		GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 0)
		landing_zone_marker = Find_Hint("REINFORCEMENT_POINT_PLUS5_CAP", "start")
		player_cis_field_base = Find_Hint("CIS_FIELD_COMMANDO_BASE", "start")

		clone_spawn_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "clone-spawn")
		obi_shuttle_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "212st-shuttle")
		shuttle_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "shuttle-1")
		shuttle_02_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "shuttle-2")
		shuttle_03_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "shuttle-3")
		shuttle_04_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "shuttle-4")

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-2")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")

		shuttlecam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "shuttlecam-1")
		shuttlecam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "shuttlecam-2")

		midtrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-1")
		midtrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-2")

		midtrocam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-target-1")

		twilek_list = Find_All_Objects_Of_Type("TWILEK_FEMALE")
		for i,twilek_unit in pairs(twilek_list) do
			Register_Prox(twilek_unit, State_Twilek_Freed, 200, p_republic)
		end

		space_cinematic_center = Find_Hint("STORY_TRIGGER_ZONE_00", "spacecinematiccenter")
		Promote_To_Space_Cinematic_Layer(space_cinematic_center)

		cinematic_lua_shuttle_pos = Find_Hint("STORY_TRIGGER_ZONE_00", "luashuttlestart")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_shuttle_pos)

		--Camera Markers
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

		Set_Cinematic_Environment(true)

		p_republic.Disable_Bombing_Run(false)
		p_republic.Disable_Orbital_Bombardment(true)

		mission_started = true

		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
	end
end

function State_Landing_Zone_Captured(message)
	if message == OnEnter then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_Rep")
	end
end


function State_Twilek_Freed(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if not first_twilek_freed then
			first_twilek_freed = true
			Story_Event("LIBERATION_06")
		end
		prox_obj.Change_Owner(p_republic)
	end
end


function Story_Handle_Esc()
	if mission_started then
		if p_republic.Is_Human() then
			if cinematic_one then
				if not cinematic_one_skipped then
					cinematic_one_skipped = true
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
					Point_Camera_At(clone_spawn_marker)
					Story_Event("GOAL_TRIGGER_REP_I")
					Lock_Controls(0)
					Suspend_AI(0)
					End_Cinematic_Camera()

					if TestValid(cinematic_skydome) then
						cinematic_skydome.Despawn()
					end
					if TestValid(Lua_Space_Shuttle) then
						Lua_Space_Shuttle.Despawn()
					end

					phase_1_list = Find_All_Objects_With_Hint("phase-1")
					for i,phase_1_unit in pairs(phase_1_list) do
						Add_Radar_Blip(phase_1_unit, "phase_1_unit_blip")
						phase_1_unit.Highlight(true)
					end

					Clone_Spawn_List_01 = SpawnList(Clone_Team_List, clone_spawn_marker, p_republic, true, false)
					Clone_Squad_01 = Clone_Spawn_List_01[1]

					Clone_Spawn_List_02 = SpawnList(Clone_Team_List, clone_spawn_marker, p_republic, true, false)
					Clone_Squad_02 = Clone_Spawn_List_02[1]

					if not TestValid(Find_First_Object("Obi_Wan")) then
						obiwan_unit = Find_Object_Type("Obi_Wan")
						obiwan_list = Spawn_Unit(obiwan_unit, clone_spawn_marker, p_republic)
						player_obiwan = obiwan_list[1]
						player_obiwan.Teleport_And_Face(clone_spawn_marker)
					end

					if not TestValid(Find_First_Object("Cody")) then
						cody_unit = Find_Object_Type("Cody")
						cody_list = Spawn_Unit(cody_unit, clone_spawn_marker, p_republic)
						player_cody = cody_list[1]
						player_cody.Teleport_And_Face(clone_spawn_marker)
					end

					if not TestValid(Find_First_Object("Waxer")) then
						waxer_unit = Find_Object_Type("Waxer")
						waxer_list = Spawn_Unit(waxer_unit, clone_spawn_marker, p_republic)
						player_waxer = waxer_list[1]
						player_waxer.Teleport_And_Face(clone_spawn_marker)
					end

					if not TestValid(Find_First_Object("Boil")) then
						boil_unit = Find_Object_Type("Boil")
						boil_list = Spawn_Unit(boil_unit, clone_spawn_marker, p_republic)
						player_boil = boil_list[1]
						player_boil.Teleport_And_Face(clone_spawn_marker)
					end

					if not TestValid(obiwan_shuttle) then
						obiwan_shuttle = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), obi_shuttle_marker, 54, 1,0.25, 0.5, 1)
					end
					Hide_Sub_Object(obiwan_shuttle, 1, "Clones")
					Hide_Sub_Object(obiwan_shuttle, 1, "Boil")
					Hide_Sub_Object(obiwan_shuttle, 1, "Boil_Carbine")
					Hide_Sub_Object(obiwan_shuttle, 1, "Boil_Helmet")
					Hide_Sub_Object(obiwan_shuttle, 1, "Waxer")
					Hide_Sub_Object(obiwan_shuttle, 1, "Waxer_Carbine")
					Hide_Sub_Object(obiwan_shuttle, 1, "Waxer_Helmet")
					Hide_Sub_Object(obiwan_shuttle, 1, "Cody")
					Hide_Sub_Object(obiwan_shuttle, 1, "Cody_Carbine")
					Hide_Sub_Object(obiwan_shuttle, 1, "CodyHelmet")
					Hide_Sub_Object(obiwan_shuttle, 1, "Obi")
					Hide_Sub_Object(obiwan_shuttle, 1, "Obi_Clones")
					obiwan_shuttle.Set_Selectable(false)


					if not TestValid(player_shuttle_01) then
						player_shuttle_01 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), shuttle_01_marker, 54, 1,0.25, 0.5, 1)
					end
					Hide_Sub_Object(player_shuttle_01, 1, "Clones")
					Hide_Sub_Object(player_shuttle_01, 1, "Boil")
					Hide_Sub_Object(player_shuttle_01, 1, "Boil_Carbine")
					Hide_Sub_Object(player_shuttle_01, 1, "Boil_Helmet")
					Hide_Sub_Object(player_shuttle_01, 1, "Waxer")
					Hide_Sub_Object(player_shuttle_01, 1, "Waxer_Carbine")
					Hide_Sub_Object(player_shuttle_01, 1, "Waxer_Helmet")
					Hide_Sub_Object(player_shuttle_01, 1, "Cody")
					Hide_Sub_Object(player_shuttle_01, 1, "Cody_Carbine")
					Hide_Sub_Object(player_shuttle_01, 1, "CodyHelmet")
					Hide_Sub_Object(player_shuttle_01, 1, "Obi")
					Hide_Sub_Object(player_shuttle_01, 1, "Obi_Clones")
					player_shuttle_01.Set_Selectable(false)

					if not TestValid(player_shuttle_02) then
						player_shuttle_02 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), shuttle_02_marker, 54, 1,0.25, 0.5, 1)
					end
					Hide_Sub_Object(player_shuttle_02, 1, "Clones")
					Hide_Sub_Object(player_shuttle_02, 1, "Boil")
					Hide_Sub_Object(player_shuttle_02, 1, "Boil_Carbine")
					Hide_Sub_Object(player_shuttle_02, 1, "Boil_Helmet")
					Hide_Sub_Object(player_shuttle_02, 1, "Waxer")
					Hide_Sub_Object(player_shuttle_02, 1, "Waxer_Carbine")
					Hide_Sub_Object(player_shuttle_02, 1, "Waxer_Helmet")
					Hide_Sub_Object(player_shuttle_02, 1, "Cody")
					Hide_Sub_Object(player_shuttle_02, 1, "Cody_Carbine")
					Hide_Sub_Object(player_shuttle_02, 1, "CodyHelmet")
					Hide_Sub_Object(player_shuttle_02, 1, "Obi")
					Hide_Sub_Object(player_shuttle_02, 1, "Obi_Clones")
					player_shuttle_02.Set_Selectable(false)

					if not TestValid(player_shuttle_03) then
						player_shuttle_03 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), shuttle_03_marker, 54, 1,0.25, 0.5, 1)
					end
					Hide_Sub_Object(player_shuttle_03, 1, "Clones")
					Hide_Sub_Object(player_shuttle_03, 1, "Boil")
					Hide_Sub_Object(player_shuttle_03, 1, "Boil_Carbine")
					Hide_Sub_Object(player_shuttle_03, 1, "Boil_Helmet")
					Hide_Sub_Object(player_shuttle_03, 1, "Waxer")
					Hide_Sub_Object(player_shuttle_03, 1, "Waxer_Carbine")
					Hide_Sub_Object(player_shuttle_03, 1, "Waxer_Helmet")
					Hide_Sub_Object(player_shuttle_03, 1, "Cody")
					Hide_Sub_Object(player_shuttle_03, 1, "Cody_Carbine")
					Hide_Sub_Object(player_shuttle_03, 1, "CodyHelmet")
					Hide_Sub_Object(player_shuttle_03, 1, "Obi")
					Hide_Sub_Object(player_shuttle_03, 1, "Obi_Clones")
					player_shuttle_03.Set_Selectable(false)

					if not TestValid(player_shuttle_04) then
						player_shuttle_04 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), shuttle_04_marker, 54, 1,0.25, 0.5, 1)
					end
					Hide_Sub_Object(player_shuttle_04, 1, "Clones")
					Hide_Sub_Object(player_shuttle_04, 1, "Boil")
					Hide_Sub_Object(player_shuttle_04, 1, "Boil_Carbine")
					Hide_Sub_Object(player_shuttle_04, 1, "Boil_Helmet")
					Hide_Sub_Object(player_shuttle_04, 1, "Waxer")
					Hide_Sub_Object(player_shuttle_04, 1, "Waxer_Carbine")
					Hide_Sub_Object(player_shuttle_04, 1, "Waxer_Helmet")
					Hide_Sub_Object(player_shuttle_04, 1, "Cody")
					Hide_Sub_Object(player_shuttle_04, 1, "Cody_Carbine")
					Hide_Sub_Object(player_shuttle_04, 1, "CodyHelmet")
					Hide_Sub_Object(player_shuttle_04, 1, "Obi")
					Hide_Sub_Object(player_shuttle_04, 1, "Obi_Clones")
					player_shuttle_04.Set_Selectable(false)

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

					cinematic_two = false
					act_2_active = true

					Story_Event("ACTIVATE_CIS_AI")

					GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)

					p_republic.Disable_Bombing_Run(true)
					p_republic.Disable_Orbital_Bombardment(true)

					Letter_Box_Out(0)
					Point_Camera_At(landing_zone_marker)
					Story_Event("GOAL_TRIGGER_REP_II")
					Lock_Controls(0)
					Suspend_AI(0)
					End_Cinematic_Camera()

					Fade_Screen_In(0.5)
					Sleep(0.5)
				end
			end
		end
	end
end

function Story_Mode_Service()
	if p_republic.Is_Human() then
		if act_1_active then
			local phase_1_list = Find_All_Objects_With_Hint("phase-1")
			j1_list = Find_All_Objects_Of_Type("J1_CANNON_ARTILLERY_ANIM")
			if (table.getn(phase_1_list) == 0) and (table.getn(j1_list) == 0) then
				Story_Event("LANDING_ZONE_CAPTURED")
			end
		end
		if act_2_active then
			local j1_list = Find_All_Objects_Of_Type("J1_CANNON_ARTILLERY_ANIM")
			local fieldbase_list = Find_All_Objects_Of_Type("CIS_FIELD_COMMANDO_BASE")
			if (table.getn(fieldbase_list) == 0) and (table.getn(j1_list) == 0) then
				Story_Event("REPUBLIC_VICTORY")
			end
		end
	end
end


function Start_Cinematic_Intro_Rep()
	Obi_Wan_Spawning = Spawn_From_Reinforcement_Pool(Find_Object_Type("Obi_Wan_Delta_Team"), clone_spawn_marker, p_republic)
	if Obi_Wan_Spawning then
		player_obiwan = Obi_Wan_Spawning[1]
		player_obiwan.Teleport_And_Face(clone_spawn_marker)
	end

	Cody_Spawning = Spawn_From_Reinforcement_Pool(Find_Object_Type("Cody_Team"), clone_spawn_marker, p_republic)
	if Cody_Spawning then
		player_cody = Cody_Spawning[1]
		player_cody.Teleport_And_Face(clone_spawn_marker)
	end

	j1_marker_list = Find_All_Objects_With_Hint("j1-phase-1")
	for i,j1_marker in pairs(j1_marker_list) do
		J1_Spawn_List = SpawnList(J1_Team_List, j1_marker, p_cis, false, false)
		for i,J1_Unit in pairs(J1_Spawn_List) do
			Add_Radar_Blip(J1_Unit, "J1_Unit_blip")
			J1_Unit.Highlight(true)
		end
	end

	cinematic_one = true

	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()
	Stop_All_Music()
	Fade_On()

	primary_space_skydome_list = SpawnList(PrimarySkydomeList, space_cinematic_center, p_republic, false, false)
	cinematic_skydome = primary_space_skydome_list[1]
	cinematic_skydome.Teleport_And_Face(space_cinematic_center)

	Weather_Audio_Pause(true)
	Start_Cinematic_Camera(false)
	Allow_Localized_SFX(false)
	Enable_Fog(false)

	Lua_Space_Shuttle_List = Find_All_Objects_Of_Type("CINEMATIC_RYLOTH_INTRO")
	Lua_Space_Shuttle = Lua_Space_Shuttle_List[1]

	Lua_Space_Shuttle.Hide(true)
	Lua_Space_Shuttle.Teleport(cinematic_lua_shuttle_pos)
	Lua_Space_Shuttle.Face_Immediate(space_cinematic_center)
	Lua_Space_Shuttle.Play_Animation("Cinematic", false, 0)
	Lua_Space_Shuttle.Hide(false)

	Sleep(1.0)

	Play_Music("Teth_Theme")
	Fade_Screen_In(7.0)
	Letter_Box_In(7.0)

	--Set_Cinematic_Camera_Key(target_pos, xoffset_dist, yoffset_pitch, zoffset_yaw, angles?, attach_object, use_object_rotation, cinematic_animation)
	Set_Cinematic_Camera_Key(cinematic_lua_cam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cinematic_lua_cam_1_target_marker, 0, 0, 0, 0, 0, 0, 0)
	Transition_Cinematic_Camera_Key(cinematic_lua_cam_1_marker, 15, 0, -200, 0, 0, 0, 0, 0)

	Story_Event("CINEMATIC_CRAWL_01")
	Sleep(3)
	Story_Event("CINEMATIC_CRAWL_02")
	Sleep(9)

	Set_Cinematic_Camera_Key(cinematic_lua_cam_2_marker, 0, -150, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cinematic_lua_cam_2_target_marker, 0, -150, 0, 0, 0, 0, 0)
	Transition_Cinematic_Camera_Key(cinematic_lua_cam_2_marker, 15, 0, 10, 0, 0, 0, 0, 0)
	Story_Event("LIBERATION_01")
	Sleep(10)

	Set_Cinematic_Camera_Key(cinematic_lua_cam_3_marker, 0, -100, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cinematic_lua_cam_3_target_marker, 0, -100, 0, 0, 0, 0, 0)
	Transition_Cinematic_Camera_Key(cinematic_lua_cam_3_marker, 15, 0, 10, 0, 0, 0, 0, 0)
	Story_Event("LIBERATION_02")
	Sleep(10.5)

	Fade_Screen_Out(2)
	Sleep(2)

	cinematic_skydome.Despawn()
	Lua_Space_Shuttle.Despawn()
	Set_Cinematic_Environment(false)
	Enable_Fog(true)

	Sleep(2)

	obiwan_shuttle = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), obi_shuttle_marker, 54, 1,0.25, 20, 1)
	Hide_Sub_Object(obiwan_shuttle, 1, "Clones")
	Story_Event("LIBERATION_03")

	player_shuttle_01 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), shuttle_01_marker, 54, 1,0.25, 20, 1)
	Hide_Sub_Object(player_shuttle_01, 1, "Boil")
	Hide_Sub_Object(player_shuttle_01, 1, "Boil_Carbine")
	Hide_Sub_Object(player_shuttle_01, 1, "Boil_Helmet")
	Hide_Sub_Object(player_shuttle_01, 1, "Waxer")
	Hide_Sub_Object(player_shuttle_01, 1, "Waxer_Carbine")
	Hide_Sub_Object(player_shuttle_01, 1, "Waxer_Helmet")
	Hide_Sub_Object(player_shuttle_01, 1, "Cody")
	Hide_Sub_Object(player_shuttle_01, 1, "Cody_Carbine")
	Hide_Sub_Object(player_shuttle_01, 1, "CodyHelmet")
	Hide_Sub_Object(player_shuttle_01, 1, "Obi")
	Hide_Sub_Object(player_shuttle_01, 1, "Obi_Clones")
	player_shuttle_01.Set_Selectable(false)

	player_shuttle_02 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), shuttle_02_marker, 54, 1,0.25, 20, 1)
	Hide_Sub_Object(player_shuttle_02, 1, "Boil")
	Hide_Sub_Object(player_shuttle_02, 1, "Boil_Carbine")
	Hide_Sub_Object(player_shuttle_02, 1, "Boil_Helmet")
	Hide_Sub_Object(player_shuttle_02, 1, "Waxer")
	Hide_Sub_Object(player_shuttle_02, 1, "Waxer_Carbine")
	Hide_Sub_Object(player_shuttle_02, 1, "Waxer_Helmet")
	Hide_Sub_Object(player_shuttle_02, 1, "Cody")
	Hide_Sub_Object(player_shuttle_02, 1, "Cody_Carbine")
	Hide_Sub_Object(player_shuttle_02, 1, "CodyHelmet")
	Hide_Sub_Object(player_shuttle_02, 1, "Obi")
	Hide_Sub_Object(player_shuttle_02, 1, "Obi_Clones")
	player_shuttle_02.Set_Selectable(false)

	player_shuttle_03 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), shuttle_03_marker, 54, 1,0.25, 20, 1)
	Hide_Sub_Object(player_shuttle_03, 1, "Boil")
	Hide_Sub_Object(player_shuttle_03, 1, "Boil_Carbine")
	Hide_Sub_Object(player_shuttle_03, 1, "Boil_Helmet")
	Hide_Sub_Object(player_shuttle_03, 1, "Waxer")
	Hide_Sub_Object(player_shuttle_03, 1, "Waxer_Carbine")
	Hide_Sub_Object(player_shuttle_03, 1, "Waxer_Helmet")
	Hide_Sub_Object(player_shuttle_03, 1, "Cody")
	Hide_Sub_Object(player_shuttle_03, 1, "Cody_Carbine")
	Hide_Sub_Object(player_shuttle_03, 1, "CodyHelmet")
	Hide_Sub_Object(player_shuttle_03, 1, "Obi")
	Hide_Sub_Object(player_shuttle_03, 1, "Obi_Clones")
	player_shuttle_03.Set_Selectable(false)

	player_shuttle_04 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), shuttle_04_marker, 54, 1,0.25, 20, 1)
	Hide_Sub_Object(player_shuttle_04, 1, "Boil")
	Hide_Sub_Object(player_shuttle_04, 1, "Boil_Carbine")
	Hide_Sub_Object(player_shuttle_04, 1, "Boil_Helmet")
	Hide_Sub_Object(player_shuttle_04, 1, "Waxer")
	Hide_Sub_Object(player_shuttle_04, 1, "Waxer_Carbine")
	Hide_Sub_Object(player_shuttle_04, 1, "Waxer_Helmet")
	Hide_Sub_Object(player_shuttle_04, 1, "Cody")
	Hide_Sub_Object(player_shuttle_04, 1, "Cody_Carbine")
	Hide_Sub_Object(player_shuttle_04, 1, "CodyHelmet")
	Hide_Sub_Object(player_shuttle_04, 1, "Obi")
	Hide_Sub_Object(player_shuttle_04, 1, "Obi_Clones")
	player_shuttle_04.Set_Selectable(false)

	Set_Cinematic_Camera_Key(obiwan_shuttle, 200, 5, 200, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(obiwan_shuttle, 0, 0, 0, 0, obiwan_shuttle, 0, 1)	
	Transition_Cinematic_Camera_Key(obiwan_shuttle, 5, 210, 4, 275, 1, 0, 0, 0)

	Weather_Audio_Pause(false)
	Allow_Localized_SFX(true)
	Fade_Screen_In(2)
	Sleep(10)

	Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 5.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 5.5, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Story_Event("LIBERATION_04")
	Sleep(5.5)

	if not cinematic_one_skipped then
		Create_Thread("End_Cinematic_Intro_Rep")
	end
end

function End_Cinematic_Intro_Rep()
	if not TestValid(Find_First_Object("Obi_Wan")) then
		obiwan_unit = Find_Object_Type("Obi_Wan")
		obiwan_list = Spawn_Unit(obiwan_unit, clone_spawn_marker, p_republic)
		player_obiwan = obiwan_list[1]
		player_obiwan.Teleport_And_Face(clone_spawn_marker)
	end
	if not TestValid(Find_First_Object("Cody")) then
		cody_unit = Find_Object_Type("Cody")
		cody_list = Spawn_Unit(cody_unit, clone_spawn_marker, p_republic)
		player_cody = cody_list[1]
		player_cody.Teleport_And_Face(clone_spawn_marker)
	end

	Clone_Spawn_List_01 = SpawnList(Clone_Team_List, clone_spawn_marker, p_republic, false, false)
	Clone_Squad_01 = Clone_Spawn_List_01[1]

	Clone_Spawn_List_02 = SpawnList(Clone_Team_List, clone_spawn_marker, p_republic, false, false)
	Clone_Squad_02 = Clone_Spawn_List_02[1]

	if not TestValid(Find_First_Object("Waxer")) then
		waxer_unit = Find_Object_Type("Waxer")
		waxer_list = Spawn_Unit(waxer_unit, clone_spawn_marker, p_republic)
		player_waxer = waxer_list[1]
		player_waxer.Teleport_And_Face(clone_spawn_marker)
	end

	if not TestValid(Find_First_Object("Boil")) then
		boil_unit = Find_Object_Type("Boil")
		boil_list = Spawn_Unit(boil_unit, clone_spawn_marker, p_republic)
		player_boil = boil_list[1]
		player_boil.Teleport_And_Face(clone_spawn_marker)
	end

	Hide_Sub_Object(obiwan_shuttle, 1, "Boil")
	Hide_Sub_Object(obiwan_shuttle, 1, "Boil_Carbine")
	Hide_Sub_Object(obiwan_shuttle, 1, "Boil_Helmet")
	Hide_Sub_Object(obiwan_shuttle, 1, "Waxer")
	Hide_Sub_Object(obiwan_shuttle, 1, "Waxer_Carbine")
	Hide_Sub_Object(obiwan_shuttle, 1, "Waxer_Helmet")
	Hide_Sub_Object(obiwan_shuttle, 1, "Cody")
	Hide_Sub_Object(obiwan_shuttle, 1, "Cody_Carbine")
	Hide_Sub_Object(obiwan_shuttle, 1, "CodyHelmet")
	Hide_Sub_Object(obiwan_shuttle, 1, "Obi")
	Hide_Sub_Object(obiwan_shuttle, 1, "Obi_Clones")

	Hide_Sub_Object(player_shuttle_01, 1, "Clones")
	Hide_Sub_Object(player_shuttle_02, 1, "Clones")
	Hide_Sub_Object(player_shuttle_03, 1, "Clones")
	Hide_Sub_Object(player_shuttle_04, 1, "Clones")

	Point_Camera_At(clone_spawn_marker)
	Transition_To_Tactical_Camera(1.5)
	Sleep(1.5)
	Letter_Box_Out(1.5)
	Sleep(1.5)
	End_Cinematic_Camera()
	Lock_Controls(0)
	Story_Event("GOAL_TRIGGER_REP_I")
	Suspend_AI(0)
	Resume_Mode_Based_Music()

	cinematic_one = false
	act_1_active = true

	phase_1_list = Find_All_Objects_With_Hint("phase-1")
	for i,phase_1_unit in pairs(phase_1_list) do
		Add_Radar_Blip(phase_1_unit, "phase_1_unit_blip")
		phase_1_unit.Highlight(true)
	end
end

function Start_Cinematic_Midtro_Rep()
	j1_marker_list = Find_All_Objects_With_Hint("j1-phase-4")
	for i,j1_marker in pairs(j1_marker_list) do
		J1_Spawn_List = SpawnList(J1_Team_List, j1_marker, p_cis, false, false)
		for i,J1_Unit in pairs(J1_Spawn_List) do
			Add_Radar_Blip(J1_Unit, "J1_Unit_blip")
			J1_Unit.Highlight(true)
		end
	end

	j1_marker_list = Find_All_Objects_With_Hint("j1-phase-3-optional")
	for i,j1_marker in pairs(j1_marker_list) do
		J1_Spawn_List = SpawnList(J1_Team_List, j1_marker, p_cis, false, false)
		J1_Unit = J1_Spawn_List[1]
	end

	j1_marker_list = Find_All_Objects_With_Hint("j1-phase-2-optional")
	for i,j1_marker in pairs(j1_marker_list) do
		J1_Spawn_List = SpawnList(J1_Team_List, j1_marker, p_cis, false, false)
		J1_Unit = J1_Spawn_List[1]
	end

	fieldbase_marker_list = Find_All_Objects_With_Hint("phase-3-optional")
	for i,fieldbase_unit in pairs(fieldbase_marker_list) do
		Add_Radar_Blip(fieldbase_unit, "Fieldbase_Unit_blip")
		fieldbase_unit.Highlight(true)
	end

	fieldbase_marker_list = Find_All_Objects_With_Hint("phase-2-optional")
	for i,fieldbase_unit in pairs(fieldbase_marker_list) do
		Add_Radar_Blip(fieldbase_unit, "Fieldbase_Unit_blip")
		fieldbase_unit.Highlight(true)
	end

	act_1_active = false
	cinematic_two = true

	Start_Cinematic_Camera()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()
	Fade_Screen_Out(1.0)
	Sleep(1)

	Set_Cinematic_Camera_Key(midtrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_1_marker, 0, 0, 0, 0, midtrocam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_2_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_2_marker, 10.0, 0, 0, 0, 0, midtrocam_target_1_marker, 1, 0)

	Letter_Box_In(1.0)
	Fade_Screen_In(1.0)
	Sleep(0.25)

	Story_Event("LIBERATION_05")
	Sleep(7)

	if not cinematic_two_skipped then
		Create_Thread("End_Cinematic_Midtro_Rep")
	end
end

function End_Cinematic_Midtro_Rep()
	Point_Camera_At(landing_zone_marker)
	Transition_To_Tactical_Camera(3)
	End_Cinematic_Camera()
	Letter_Box_Out(3)
	Lock_Controls(0)
	Suspend_AI(0)
	Sleep(3.0)

	Story_Event("GOAL_TRIGGER_REP_II")

	p_republic.Disable_Bombing_Run(true)
	p_republic.Disable_Orbital_Bombardment(true)

	cinematic_two = false
	act_2_active = true

	Story_Event("ACTIVATE_CIS_AI")

	GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)
end
