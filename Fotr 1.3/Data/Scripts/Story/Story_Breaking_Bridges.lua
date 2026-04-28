
--*****************************************************--
--************* Rimward: Breaking Bridges ************--
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
		Trigger_Landing_Zone_Captured = State_Landing_Zone_Captured,
		Wat_Tambor_Destroyed = State_Tambor_Captured,
		--Mace_Windu_Destroyed = State_Republic_Lost,
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_neutral = Find_Player("Neutral")
	p_hostile = Find_Player("Hostile")

	Clone_Team_List = {"Clonetrooper_Phase_One_Team"}
	Clone_Small_Team_List = {"Clonetrooper_Phase_One_Assault_Team_Deployed"}
	ATTR_Team_List = {"Republic_AT_RT_Company"}
	ATTE_Team_List = {"Republic_AT_TE_Walker"}
	LAAT_Team_List = {"Republic_LAAT_Group"}
	AAT_Team_List = {"AAT"}
	mtt_Team_List = {"CIS_MTT_COMPANY"}
	b2_Team_List = {"B2_DROID_SQUAD"}
	tri_Team_List = {"MAGNA_COMPANY"}
	j1_Team_List = {"J1_ARTILLERY_CORP"}

	current_cinematic_thread_id = nil

	act_1_active = false
	act_2_active = false
	act_3_active = false

	cinematic_one = false
	cinematic_two = false
	cinematic_three = false
	cinematic_four = false

	cinematic_one_skipped = false
	cinematic_two_skipped = false
	cinematic_three_skipped = false
	cinematic_four_skipped = false

	camera_offset = 125
	intro_skipped = false
	mission_started = false
	defence_position = false
end

function Begin_Battle(message)
	if message == OnEnter then
		GlobalValue.Set("Rimward_Breaking_Bridges_Outcome", 0) -- 0 = CIS Victory; 1 = Republic Victory

		clone_spawn_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "clone-spawn")
		shuttle_spawn_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "shuttle-spawn")
		atte_move_to_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "atte-move-to")
		mtt_move_to_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "mtt-move-to")

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-4")
		introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-5")
		introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-6")
		introcam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-7")
		introcam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-8")
		introcam_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-9")
		introcam_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-10")
		introcam_11_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-11")
		introcam_12_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-12")

		introcam_target_0_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-0")
		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")
		introcam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")

		midtrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-1")
		midtrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-2")
		midtrocam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-3")
		midtrocam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-4")
		midtrocam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-5")
		midtrocam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-6")
		midtrocam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-7")
		midtrocam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-8")
		midtrocam_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-9")
		midtrocam_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-10")
		midtrocam_11_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-11")
		midtrocam_12_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-12")
		midtrocam_13_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-13")
		midtrocam_14_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-14")

		midtrocam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-target-1")
		midtrocam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-target-2")
		midtrocam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-target-3")
		midtrocam_target_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-target-4")

		outrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-1")
		outrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-2")
		outrocam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-3")
		outrocam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-4")
		outrocam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-5")
		outrocam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-6")

		outrocam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-1")
		outrocam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-2")

		midtro_b1_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-b1-1")
		midtro_b1_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-b1-2")

		midtro_ponds_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-ponds")

		midtro_mace_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-mace")
		midtro_cham_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-cham")

		outro_mace_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-mace")
		outro_cham_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cham")

		tambor_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "tambor")

		mtt_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "mtt-1")
		mtt_02_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "mtt-2")

		shuttle_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "shuttle-1")
		shuttle_02_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "shuttle-2")
		shuttle_03_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "shuttle-3")
		shuttle_04_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "shuttle-4")
		shuttle_05_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "shuttle-5")
		shuttle_06_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "shuttle-6")

		player_tactical_droid = Find_Hint("GENERAL_KALANI", "cine-tactical")
		holo_list = Find_All_Objects_With_Hint("cine-holo")
		player_holo_dooku = holo_list[1]
		player_oom = Find_Hint("B1_DROID", "cine-b1")
		player_tambor = Find_Hint("WAT_TAMBOR", "tambor")

		p_republic.Disable_Orbital_Bombardment(true)

		mission_started = true
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
	end
end


function State_Republic_Lost(message)
	if message == OnEnter then
		if act_1_active or act_3_active then
			Story_Event("CIS_VICTORY")
		else
			return
		end
	end
end

function State_Landing_Zone_Captured(message)
	if message == OnEnter then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_01_Rep")
	end
end

function State_Tambor_Captured(message)
	if message == OnEnter then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
	end
end

function State_Defence_Position()
	aat_phase_1_list = Find_All_Objects_With_Hint("aat-phase-1")
	for i,phase_1_aat in pairs(aat_phase_1_list) do
		phase_1_aat.Suspend_Locomotor(false)
	end
end

function State_Bridge_Crossed(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj == player_mtt_02 then
			prox_obj.Cancel_Event_Object_In_Range(State_Bridge_Crossed)
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_02_Rep")
		end
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
					Resume_Mode_Based_Music()

					if TestValid(player_holo_dooku) then
						player_holo_dooku.Despawn()
					end
					if TestValid(player_tactical_droid) then
						player_tactical_droid.Despawn()
					end
					if TestValid(player_oom) then
						player_oom.Despawn()
					end

					phase_1_list = Find_All_Objects_With_Hint("phase-1")
					for i,phase_1_unit in pairs(phase_1_list) do
						Add_Radar_Blip(phase_1_unit, "phase_1_unit_blip")
						phase_1_unit.Highlight(true)
					end

					if not TestValid(Find_First_Object("Mace_Windu_AT_RT")) then
						mace_atrt_unit = Find_Object_Type("Mace_Windu_AT_RT")
						mace_atrt_list = Spawn_Unit(mace_atrt_unit, clone_spawn_marker, p_republic)
						player_mace_atrt = mace_atrt_list[1]
						player_mace_atrt.Teleport_And_Face(clone_spawn_marker)
					end

					--[[if not TestValid(Find_First_Object("Ponds")) then
						ponds_unit = Find_Object_Type("Ponds")
						ponds_list = Spawn_Unit(ponds_unit, clone_spawn_marker, p_republic)
						player_ponds = ponds_list[1]
						player_ponds.Teleport_And_Face(clone_spawn_marker)
					end]]

					Clone_Spawn_List_01 = SpawnList(Clone_Team_List, clone_spawn_marker, p_republic, false, false)
					Clone_Squad_01 = Clone_Spawn_List_01[1]

					Clone_Spawn_List_02 = SpawnList(Clone_Team_List, clone_spawn_marker, p_republic, false, false)
					Clone_Squad_02 = Clone_Spawn_List_02[1]

					Clone_Spawn_List_03 = SpawnList(ATTR_Team_List, clone_spawn_marker, p_republic, false, false)
					Clone_Squad_03 = Clone_Spawn_List_03[1]

					Clone_Spawn_List_04 = SpawnList(ATTR_Team_List, clone_spawn_marker, p_republic, false, false)
					Clone_Squad_04 = Clone_Spawn_List_03[1]

					aat_phase_1_list = Find_All_Objects_With_Hint("aat-phase-1")
					for i,phase_1_aat in pairs(aat_phase_1_list) do
						phase_1_aat.Make_Invulnerable(false)
						phase_1_aat.Change_Owner(p_cis)
						Add_Radar_Blip(phase_1_aat, "aat_blip")
						phase_1_aat.Highlight(true)	
						phase_1_aat.Suspend_Locomotor(true)
					end

					atte_phase_1_list = Find_All_Objects_With_Hint("atte-phase-1")
					for i,phase_1_atte in pairs(atte_phase_1_list) do
						phase_1_atte.Make_Invulnerable(false)
						phase_1_atte.Change_Owner(p_republic)
						phase_1_atte.Move_To(atte_move_to_marker)
					end

					Allow_Localized_SFX(true)
					SFXManager.Allow_HUD_VO(true)
					SFXManager.Allow_Ambient_VO(true)
					SFXManager.Allow_Localized_SFXEvents(true)
					SFXManager.Allow_Unit_Reponse_VO(true)
					SFXManager.Allow_Enemy_Sighted_VO(true)

					Story_Event("LIBERATION_01")
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

					if TestValid(player_holo_dooku) then
						player_holo_dooku.Despawn()
					end
					if TestValid(player_tactical_droid) then
						player_tactical_droid.Despawn()
					end
					if TestValid(player_oom) then
						player_oom.Despawn()
					end
					if TestValid(player_mace_atrt) then
						player_mace_atrt.Despawn()
					end
					if TestValid(Find_First_Object("Mace_Windu")) then
						player_mace = Find_First_Object("Mace_Windu")
						player_mace.Despawn()
					end
					--[[if TestValid(Find_First_Object("Ponds")) then
						player_ponds.Teleport_And_Face(midtro_ponds_marker)
					end]]

					if TestValid(player_cham) then
						player_cham.Despawn()
					end

					if not TestValid(player_mtt_01) then
						mtt_unit = Find_Object_Type("CIS_MTT")
						mtt1_list = Spawn_Unit(mtt_unit, Find_Hint("STORY_TRIGGER_ZONE_00", "mtt-2-spawn"), p_cis)
						player_mtt_01 = mtt1_list[1]
						player_mtt_01.Teleport_And_Face(Find_Hint("STORY_TRIGGER_ZONE_00", "mtt-2-spawn"))
						player_mtt_01.Move_To(mtt_move_to_marker)
					else
						player_mtt_01.Teleport_And_Face(Find_Hint("STORY_TRIGGER_ZONE_00", "mtt-2-spawn"))
						player_mtt_01.Move_To(mtt_move_to_marker)
					end

					mtt_unit = Find_Object_Type("CIS_MTT")
					mtt2_list = Spawn_Unit(mtt_unit, mtt_01_marker, p_cis)
					player_mtt_02 = mtt2_list[1]
					player_mtt_02.Teleport_And_Face(mtt_01_marker)
					player_mtt_02.Change_Owner(p_republic)
					player_mtt_02.Override_Max_Speed(1.5)
					mtt_move_to_marker.Highlight(true)
					Add_Radar_Blip(mtt_move_to_marker, "mtt_move_to_marker_blip")
					fog_id = FogOfWar.Reveal(p_republic, player_mtt_02.Get_Position(), 20000, 20000)

					Register_Prox(mtt_move_to_marker, State_Bridge_Crossed, 1400, p_republic)

					cinematic_two = false
					act_2_active = true

					Allow_Localized_SFX(true)
					SFXManager.Allow_HUD_VO(true)
					SFXManager.Allow_Ambient_VO(true)
					SFXManager.Allow_Localized_SFXEvents(true)
					SFXManager.Allow_Unit_Reponse_VO(true)
					SFXManager.Allow_Enemy_Sighted_VO(true)

					Letter_Box_Out(0)
					Point_Camera_At(player_mtt_02)
					Story_Event("GOAL_TRIGGER_REP_II")
					Story_Event("LIBERATION_02")
					Lock_Controls(0)
					Suspend_AI(0)
					End_Cinematic_Camera()
					Resume_Mode_Based_Music()

					Fade_Screen_In(0.5)
					Sleep(0.5)
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

					Fade_Screen_Out(0)
					Stop_All_Music()
					Stop_All_Speech()
					Remove_All_Text()
					Stop_Bink_Movie()

					Resume_Mode_Based_Music()
					player_mtt_02.Teleport_And_Face(Find_Hint("STORY_TRIGGER_ZONE_00", "cine-3"))

					mace_unit = Find_Object_Type("Mace_Windu")
					mace_list = Spawn_Unit(mace_unit, player_mtt_02.Get_Position(), p_republic)
					player_mace = mace_list[1]

					cham_unit = Find_Object_Type("Cham_Syndulla")
					cham_list = Spawn_Unit(cham_unit, player_mtt_02.Get_Position(), p_republic)
					player_cham = cham_list[1]

					republic_list = Find_All_Objects_Of_Type(p_hostile)
					for i,republic_unit in pairs(republic_list) do
						if TestValid(republic_unit) then
							republic_unit.Change_Owner(p_republic)
							republic_unit.Teleport_And_Face(mtt_02_marker)
						end
					end

					player_mtt_02.Override_Max_Speed(0.75)

					Clone_Spawn_List_01 = SpawnList(Clone_Team_List, player_mtt_02.Get_Position(), p_republic, false, false)
					Clone_Squad_01 = Clone_Spawn_List_01[1]
					Story_Event("LIBERATION_05")

					p_republic.Make_Enemy(p_cis)
					p_cis.Make_Enemy(p_republic)

					mtt_move_to_marker.Highlight(false)
					Remove_Radar_Blip("mtt_move_to_marker_blip")

					Clone_Small_Spawn_01_List = SpawnList(Clone_Team_List, shuttle_01_marker.Get_Position(), p_republic, false, false)
					Clone_Small_Squad_01 = Clone_Small_Spawn_01_List[1]

					Clone_Small_Spawn_02_List = SpawnList(Clone_Team_List, shuttle_02_marker.Get_Position(), p_republic, false, false)
					Clone_Small_Squad_02 = Clone_Small_Spawn_02_List[1]

					Clone_Small_Spawn_03_List = SpawnList(Clone_Team_List, shuttle_03_marker.Get_Position(), p_republic, false, false)
					Clone_Small_Squad_03 = Clone_Small_Spawn_03_List[1]

					Clone_Small_Spawn_04_List = SpawnList(Clone_Team_List, shuttle_04_marker.Get_Position(), p_republic, false, false)
					Clone_Small_Squad_04 = Clone_Small_Spawn_04_List[1]

					Clone_Small_Spawn_05_List = SpawnList(Clone_Team_List, shuttle_05_marker.Get_Position(), p_republic, false, false)
					Clone_Small_Squad_05= Clone_Small_Spawn_05_List[1]

					Clone_Small_Spawn_06_List = SpawnList(Clone_Team_List, shuttle_06_marker.Get_Position(), p_republic, false, false)
					Clone_Small_Squad_06 = Clone_Small_Spawn_06_List[1]

					if TestValid(player_shuttle_01) then
						player_shuttle_01.Despawn()
					end

					if TestValid(player_shuttle_02) then
						player_shuttle_02.Despawn()
					end

					if TestValid(player_shuttle_03) then
						player_shuttle_03.Despawn()
					end

					if TestValid(player_shuttle_04) then
						player_shuttle_04.Despawn()
					end

					if TestValid(player_shuttle_05) then
						player_shuttle_05.Despawn()
					end

					if TestValid(player_shuttle_06) then
						player_shuttle_06.Despawn()
					end

					LAAT_Spawn_01_List = SpawnList(ATTE_Team_List, shuttle_01_marker.Get_Position(), p_republic, false, false)
					LAAT_Squad_01 = LAAT_Spawn_01_List[1]
					LAAT_Squad_01.Teleport_And_Face(shuttle_01_marker)

					LAAT_Spawn_02_List = SpawnList(ATTE_Team_List, shuttle_02_marker.Get_Position(), p_republic, false, false)
					LAAT_Squad_02 = LAAT_Spawn_02_List[1]
					LAAT_Squad_02.Teleport_And_Face(shuttle_02_marker)

					LAAT_Spawn_03_List = SpawnList(ATTE_Team_List, shuttle_03_marker.Get_Position(), p_republic, false, false)
					LAAT_Squad_03 = LAAT_Spawn_03_List[1]
					LAAT_Squad_03.Teleport_And_Face(shuttle_03_marker)

					LAAT_Spawn_04_List = SpawnList(ATTE_Team_List, shuttle_04_marker.Get_Position(), p_republic, false, false)
					LAAT_Squad_04 = LAAT_Spawn_04_List[1]
					LAAT_Squad_04.Teleport_And_Face(shuttle_04_marker)

					LAAT_Spawn_05_List = SpawnList(LAAT_Team_List, shuttle_05_marker.Get_Position(), p_republic, false, false)
					LAAT_Squad_05 = LAAT_Spawn_05_List[1]
					LAAT_Squad_05.Teleport_And_Face(shuttle_05_marker)

					LAAT_Spawn_06_List = SpawnList(LAAT_Team_List, shuttle_06_marker.Get_Position(), p_republic, false, false)
					LAAT_Squad_06 = LAAT_Spawn_06_List[1]
					LAAT_Squad_06.Teleport_And_Face(shuttle_06_marker)

					ATTE_Spawn_01_List = SpawnList(LAAT_Team_List, mtt_02_marker.Get_Position(), p_republic, false, false)
					ATTE_Squad_01 = ATTE_Spawn_01_List[1]
					ATTE_Squad_01.Teleport_And_Face(mtt_02_marker)

					ATTE_Spawn_02_List = SpawnList(LAAT_Team_List, mtt_02_marker.Get_Position(), p_republic, false, false)
					ATTE_Squad_02 = ATTE_Spawn_02_List[1]
					ATTE_Squad_02.Teleport_And_Face(mtt_02_marker)

					wat_tambor_list = Find_All_Objects_Of_Type("Wat_Tambor")
					for i,wat_tambor_unit in pairs(wat_tambor_list) do
						if TestValid(wat_tambor_unit) then
							wat_tambor_unit.Despawn()
						end
					end

					j1_marker_list = Find_All_Objects_With_Hint("phase-2-j1")
					for i,j1_marker in pairs(j1_marker_list) do
						J1_Spawn_List = SpawnList(J1_Team_List, j1_marker, p_cis, true, true)
					end
					mtt_marker_list = Find_All_Objects_With_Hint("phase-2-mtt")
					for i,mtt_marker in pairs(mtt_marker_list) do
						mtt_Spawn_List = SpawnList(mtt_Team_List, mtt_marker, p_cis, true, true)
					end
					b2_marker_list = Find_All_Objects_With_Hint("phase-2-b2")
					for i,b2_marker in pairs(b2_marker_list) do
						b2_Spawn_List = SpawnList(b2_Team_List, b2_marker, p_cis, true, true)
					end
					tri_marker_list = Find_All_Objects_With_Hint("phase-2-tri")
					for i,tri_marker in pairs(tri_marker_list) do
						tri_Spawn_List = SpawnList(tri_Team_List, tri_marker, p_cis, true, true)
					end

					cinematic_three = false
					act_3_active = true

					Allow_Localized_SFX(true)
					SFXManager.Allow_HUD_VO(true)
					SFXManager.Allow_Ambient_VO(true)
					SFXManager.Allow_Localized_SFXEvents(true)
					SFXManager.Allow_Unit_Reponse_VO(true)
					SFXManager.Allow_Enemy_Sighted_VO(true)

					Story_Event("ACTIVATE_CIS_AI")
					Story_Event("GOAL_TRIGGER_REP_III")

					Letter_Box_Out(0)
					Point_Camera_At(player_mtt_02)
					Lock_Controls(0)
					Suspend_AI(0)
					End_Cinematic_Camera()
					Resume_Mode_Based_Music()

					Fade_Screen_In(0.5)
					Sleep(0.5)
				end
			end
			if cinematic_four then
				if not cinematic_four_skipped then
					cinematic_four_skipped = true
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
					GlobalValue.Set("Rimward_Breaking_Bridges_Outcome", 1) -- 0 = CIS Victory; 1 = Republic Victory

					Story_Event("REPUBLIC_VICTORY")
				end
			end
		end
	end
end

function Story_Mode_Service()
	if p_republic.Is_Human() then
		if act_1_active then
			local aat_phase_1_list = Find_All_Objects_With_Hint("aat-phase-1")
			local phase_1_list = Find_All_Objects_With_Hint("phase-1")
			if (table.getn(phase_1_list) == 0) and (table.getn(aat_phase_1_list) == 0) then
				Story_Event("LANDING_ZONE_CAPTURED")
			end
			if not defence_position then
				if (table.getn(phase_1_list) == 1) then
					defence_position = true
					Create_Thread("State_Defence_Position")
				end
			end
		end
		if act_3_active then
			local cis_list = Find_All_Objects_Of_Type(p_cis, "Vehicle | Air")
			if (table.getn(cis_list) == 0) then
				Story_Event("TAMBOR_CAPTURED")
			end
			local p_vp = Find_First_Object("VICTORY_POINT")
			if p_vp.Get_Owner() == p_republic then
				Story_Event("TAMBOR_CAPTURED")
			end
		end
	end
end


function Start_Cinematic_Intro_Rep()
	aat_phase_1_list = Find_All_Objects_With_Hint("aat-phase-1")
	for i,phase_1_aat in pairs(aat_phase_1_list) do
		phase_1_aat.Change_Owner(p_neutral)
		phase_1_aat.Make_Invulnerable(true)
		phase_1_aat.Suspend_Locomotor(true)
		fog_id = FogOfWar.Reveal(p_republic, phase_1_aat.Get_Position(), 500, 500)
	end
	atte_phase_1_list = Find_All_Objects_With_Hint("atte-phase-1")
	for i,phase_1_atte in pairs(atte_phase_1_list) do
		phase_1_atte.Change_Owner(p_neutral)
		phase_1_atte.Make_Invulnerable(true)
		fog_id = FogOfWar.Reveal(p_republic, phase_1_atte.Get_Position(), 500, 500)
	end
	cinematic_one = true
	Suspend_AI(1)
	Lock_Controls(1)
	Start_Cinematic_Camera()
	Letter_Box_In(0)
	Cancel_Fast_Forward()
	Stop_All_Music()
	Fade_On()

	Allow_Localized_SFX(false)
	SFXManager.Allow_HUD_VO(false)
	SFXManager.Allow_Ambient_VO(false)
	SFXManager.Allow_Localized_SFXEvents(false)
	SFXManager.Allow_Unit_Reponse_VO(false)
	SFXManager.Allow_Enemy_Sighted_VO(false)

	Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_0_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 20.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 20.0, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)

	Play_Music("Breaking_Bridges_01")
	Fade_Screen_In(7.0)
	Letter_Box_In(7.0)

	Story_Event("CINEMATIC_CRAWL_01")
	Sleep(3)

	Story_Event("CINEMATIC_CRAWL_02")
	Sleep(17)

	Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_4_marker, 7.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_4_marker, 7.0, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	player_holo_dooku.Play_Animation("Idle", true, 0)

	player_tambor.Play_Animation("Talk", false, 0)
	Sleep(3)
	player_tambor.Play_Animation("Talk", false, 1)
	Sleep(2)

	Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_4_marker, 15.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_4_marker, 15.0, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Sleep(4)

	Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_5_marker, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_6_marker, 14.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_6_marker, 14.0, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Sleep(5)

	Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_8_marker, 8.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_8_marker, 8.0, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Sleep(4)
	player_holo_dooku.Despawn()

	Set_Cinematic_Camera_Key(introcam_9_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_9_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_10_marker, 8.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_10_marker, 8.0, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	player_tambor.Play_Animation("Talk", false, 0)
	Sleep(3)
	player_tambor.Play_Animation("Talk", false, 1)
	Sleep(1)

	Fade_Screen_Out(3.0)
	Sleep(3)

	aat_phase_1_list = Find_All_Objects_With_Hint("aat-phase-1")
	for i,phase_1_aat in pairs(aat_phase_1_list) do
		phase_1_aat.Change_Owner(p_cis)
	end

	atte_phase_1_list = Find_All_Objects_With_Hint("atte-phase-1")
	for i,phase_1_atte in pairs(atte_phase_1_list) do
		phase_1_atte.Change_Owner(p_republic)
		phase_1_atte.Move_To(atte_move_to_marker)
	end

	Allow_Localized_SFX(true)
	SFXManager.Allow_HUD_VO(true)
	SFXManager.Allow_Ambient_VO(true)
	SFXManager.Allow_Localized_SFXEvents(true)
	SFXManager.Allow_Unit_Reponse_VO(true)
	SFXManager.Allow_Enemy_Sighted_VO(true)

	Play_Music("Christophsis_Clash_Theme")
	Sleep(1)

	player_tactical_droid.Despawn()
	player_oom.Despawn()

	Set_Cinematic_Camera_Key(introcam_11_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_11_marker, 0, 0, 0, 0, introcam_12_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_12_marker, 8.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_12_marker, 8.0, 0, 0, 0, 0, introcam_11_marker, 1, 0)
	Story_Event("CINEMATIC_CRAWL_03")
	Fade_Screen_In(2.0)
	Sleep(3)

	Story_Event("CINEMATIC_CRAWL_04")
	Sleep(4)

	if not cinematic_one_skipped then
		Create_Thread("End_Cinematic_Intro_Rep")
	end
end

function End_Cinematic_Intro_Rep()
	if not TestValid(Find_First_Object("Mace_Windu_AT_RT")) then
		mace_atrt_unit = Find_Object_Type("Mace_Windu_AT_RT")
		mace_atrt_list = Spawn_Unit(mace_atrt_unit, clone_spawn_marker, p_republic)
		player_mace_atrt = mace_atrt_list[1]
		player_mace_atrt.Teleport_And_Face(clone_spawn_marker)
	end

	--[[if not TestValid(Find_First_Object("Ponds")) then
		ponds_unit = Find_Object_Type("Ponds")
		ponds_list = Spawn_Unit(ponds_unit, clone_spawn_marker, p_republic)
		player_ponds = ponds_list[1]
		player_ponds.Teleport_And_Face(clone_spawn_marker)
	end]]

	Clone_Spawn_List_01 = SpawnList(Clone_Team_List, clone_spawn_marker, p_republic, false, false)
	Clone_Squad_01 = Clone_Spawn_List_01[1]

	Clone_Spawn_List_02 = SpawnList(Clone_Team_List, clone_spawn_marker, p_republic, false, false)
	Clone_Squad_02 = Clone_Spawn_List_02[1]

	Clone_Spawn_List_03 = SpawnList(ATTR_Team_List, clone_spawn_marker, p_republic, false, false)
	Clone_Squad_03 = Clone_Spawn_List_03[1]

	Clone_Spawn_List_04 = SpawnList(ATTR_Team_List, clone_spawn_marker, p_republic, false, false)
	Clone_Squad_04 = Clone_Spawn_List_03[1]

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

	Story_Event("LIBERATION_01")

	aat_phase_1_list = Find_All_Objects_With_Hint("aat-phase-1")
	for i,phase_1_aat in pairs(aat_phase_1_list) do
		phase_1_aat.Make_Invulnerable(false)
		Add_Radar_Blip(phase_1_aat, "aat_blip")
		phase_1_aat.Highlight(true)	
	end
	atte_phase_1_list = Find_All_Objects_With_Hint("atte-phase-1")
	for i,phase_1_atte in pairs(atte_phase_1_list) do
		phase_1_atte.Make_Invulnerable(false)
	end
	phase_1_list = Find_All_Objects_With_Hint("phase-1")
	for i,phase_1_unit in pairs(phase_1_list) do
		Add_Radar_Blip(phase_1_unit, "phase_1_unit_blip")
		phase_1_unit.Highlight(true)
	end
end

function Start_Cinematic_Midtro_01_Rep()
	act_1_active = false
	p_republic.Make_Ally(p_cis)
	p_cis.Make_Ally(p_republic)

	p_republic.Make_Ally(p_hostile)
	p_hostile.Make_Ally(p_republic)

	p_cis.Make_Ally(p_hostile)
	p_hostile.Make_Ally(p_cis)

	local cis_list = Find_All_Objects_Of_Type(p_cis, "Vehicle | Infantry | Air")
	for i,unit_cis in pairs(cis_list) do
		unit_cis.Despawn()
	end

	local cis_list = Find_All_Objects_Of_Type(p_cis, "CIS_FIELD_COMMANDO_BASE")
	for i,unit_cis in pairs(cis_list) do
		unit_cis.Despawn()
	end

	local republic_list = Find_All_Objects_Of_Type(p_republic, "Vehicle | Infantry | Air")
	for i,republic_unit in pairs(republic_list) do
		republic_unit.Despawn()
	end

	if TestValid(Find_First_Object("GENERAL_KALANI")) then
		Find_First_Object("GENERAL_KALANI").Despawn()
	end

	if TestValid(player_holo_dooku) then
		player_holo_dooku.Despawn()
	end

	cinematic_two = true

	Fade_Screen_Out(0.5)
	Sleep(1)
	Suspend_AI(1)
	Lock_Controls(1)
	Start_Cinematic_Camera()
	Letter_Box_In(0)
	Stop_All_Music()
	Cancel_Fast_Forward()

	if TestValid(player_mace_atrt) then
		player_mace_atrt.Despawn()
	end
	if TestValid(Find_First_Object("Mace_Windu")) then
		player_mace = Find_First_Object("Mace_Windu")
		player_mace.Teleport_And_Face(midtro_mace_marker)
		Hide_Sub_Object(player_mace, 1, "lightsaber");
	else
		mace_unit = Find_Object_Type("Mace_Windu")
		mace_list = Spawn_Unit(mace_unit, midtro_mace_marker, p_republic)
		player_mace = mace_list[1]
		player_mace.Teleport_And_Face(midtro_mace_marker)
		Hide_Sub_Object(player_mace, 1, "lightsaber");
	end
	--[[if TestValid(Find_First_Object("Ponds")) then
		player_ponds.Teleport_And_Face(midtro_ponds_marker)
	end]]

	cham_unit = Find_Object_Type("Cham_Syndulla")
	cham_list = Spawn_Unit(cham_unit, midtro_cham_marker, p_republic)
	player_cham = cham_list[1]
	player_cham.Teleport_And_Face(midtro_cham_marker)

	mtt_unit = Find_Object_Type("CIS_MTT")
	mtt1_list = Spawn_Unit(mtt_unit, mtt_01_marker, p_cis)
	player_mtt_01 = mtt1_list[1]
	player_mtt_01.Teleport_And_Face(mtt_01_marker)

	Allow_Localized_SFX(false)
	SFXManager.Allow_HUD_VO(false)
	SFXManager.Allow_Ambient_VO(false)
	SFXManager.Allow_Localized_SFXEvents(false)
	SFXManager.Allow_Unit_Reponse_VO(false)
	SFXManager.Allow_Enemy_Sighted_VO(false)

	Play_Music("Breaking_Bridges_02")
	Set_Cinematic_Camera_Key(midtrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_1_marker, 0, 0, 0, 0, midtrocam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_2_marker, 8.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_2_marker, 8.0, 0, 0, 0, 0, midtrocam_target_2_marker, 1, 0)
	Fade_Screen_In(3.0)
	Letter_Box_In(3.0)
	Sleep(8)

	Set_Cinematic_Camera_Key(midtrocam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_3_marker, 0, 0, 0, 0, midtrocam_6_marker, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_4_marker, 8.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_4_marker, 8.0, 0, 0, 0, 0, midtrocam_5_marker, 1, 0)
	Sleep(5)

	player_mtt_01.Move_To(mtt_move_to_marker)
	Sleep(3)

	Transition_Cinematic_Camera_Key(midtrocam_4_marker, 3.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_4_marker, 3.0, 0, 0, 0, 0, player_mtt_01, 1, 0)
	Sleep(6)

	player_mtt_01.Teleport_And_Face(mtt_02_marker)
	player_mtt_01.Move_To(mtt_move_to_marker)

	Set_Cinematic_Camera_Key(midtrocam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_5_marker, 0, 0, 0, 0, player_mtt_01, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_6_marker, 9.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_6_marker, 9.0, 0, 0, 0, 0, player_mtt_01, 1, 0)
	Sleep(9)

	Set_Cinematic_Camera_Key(midtrocam_7_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_7_marker, 0, 0, 0, 0, midtrocam_target_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_8_marker, 9.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_8_marker, 9.0, 0, 0, 0, 0, midtrocam_target_2_marker, 1, 0)
	player_cham.Turn_To_Face(player_mace)

	player_mace.Turn_To_Face(player_cham)
	player_mace.Play_Animation("Talk", false, 0)
	Sleep(2)

	player_cham.Play_Animation("Talk_Gesture", false, 0)
	Sleep(2)

	if not cinematic_two_skipped then
		Create_Thread("End_Cinematic_Midtro_01_Rep")
	end
end

function End_Cinematic_Midtro_01_Rep()
	mtt2_list = Spawn_Unit(mtt_unit, mtt_01_marker, p_cis)
	player_mtt_02 = mtt2_list[1]
	player_mtt_02.Teleport_And_Face(mtt_01_marker)
	player_mtt_02.Change_Owner(p_republic)
	player_mtt_02.Override_Max_Speed(1.5)
	mtt_move_to_marker.Highlight(true)
	Add_Radar_Blip(mtt_move_to_marker, "mtt_move_to_marker_blip")
	fog_id = FogOfWar.Reveal(p_republic, player_mtt_02.Get_Position(), 20000, 20000)

	Point_Camera_At(player_mtt_02)
	Transition_To_Tactical_Camera(3)
	End_Cinematic_Camera()
	Letter_Box_Out(3)
	Lock_Controls(0)
	Suspend_AI(0)
	Sleep(3.0)

	Story_Event("GOAL_TRIGGER_REP_II")
	Story_Event("LIBERATION_02")

	player_mace.Despawn()
	player_cham.Despawn()

	Register_Prox(mtt_move_to_marker, State_Bridge_Crossed, 1000, p_republic)
	Sleep(3.0)
	Resume_Mode_Based_Music()

	cinematic_two = false
	act_2_active = true
end

function Start_Cinematic_Midtro_02_Rep()
	act_2_active = false
	cinematic_three = true

	Fade_Screen_Out(0.5)
	Sleep(1)
	Suspend_AI(1)
	Lock_Controls(1)
	Start_Cinematic_Camera()
	Letter_Box_In(0)
	Stop_All_Music()
	Cancel_Fast_Forward()

	b1_unit = Find_Object_Type("B1_DROID")
	b1_1_list = Spawn_Unit(b1_unit, midtro_b1_1_marker, p_cis)
	player_b1_1 = b1_1_list[1]
	player_b1_1.Teleport_And_Face(midtro_b1_1_marker)

	b1_2_list = Spawn_Unit(b1_unit, midtro_b1_2_marker, p_cis)
	player_b1_2 = b1_2_list[1]
	player_b1_2.Teleport_And_Face(midtro_b1_2_marker)

	player_mtt_02.Move_To(mtt_move_to_marker)
	player_mtt_02.Override_Max_Speed(0.75)

	Play_Music("CIS_Tactical_Battle")
	Set_Cinematic_Camera_Key(midtrocam_11_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_11_marker, 0, 0, 0, 0, midtrocam_target_4_marker, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_12_marker, 8.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_12_marker, 8.0, 0, 0, 0, 0, midtrocam_target_4_marker, 1, 0)
	Story_Event("LIBERATION_03")
	Fade_Screen_In(1.0)
	Letter_Box_In(1.0)
	Sleep(8)

	Set_Cinematic_Camera_Key(midtrocam_13_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_13_marker, 0, 0, 0, 0, player_mtt_02, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_14_marker, 3.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_14_marker, 3.0, 0, 0, 0, 0, player_mtt_02, 1, 0)
	Story_Event("LIBERATION_04")
	Sleep(3)



	if not cinematic_three_skipped then
		Create_Thread("End_Cinematic_Midtro_02_Rep")
	end
end

function End_Cinematic_Midtro_02_Rep()
	j1_marker_list = Find_All_Objects_With_Hint("phase-2-j1")
	for i,j1_marker in pairs(j1_marker_list) do
		J1_Spawn_List = SpawnList(J1_Team_List, j1_marker, p_cis, true, true)
	end
	mtt_marker_list = Find_All_Objects_With_Hint("phase-2-mtt")
	for i,mtt_marker in pairs(mtt_marker_list) do
		mtt_Spawn_List = SpawnList(mtt_Team_List, mtt_marker, p_cis, true, true)
	end
	b2_marker_list = Find_All_Objects_With_Hint("phase-2-b2")
	for i,b2_marker in pairs(b2_marker_list) do
		b2_Spawn_List = SpawnList(b2_Team_List, b2_marker, p_cis, true, true)
	end
	tri_marker_list = Find_All_Objects_With_Hint("phase-2-tri")
	for i,tri_marker in pairs(tri_marker_list) do
		tri_Spawn_List = SpawnList(tri_Team_List, tri_marker, p_cis, true, true)
	end

	Point_Camera_At(player_mtt_02)
	Transition_To_Tactical_Camera(1.5)
	End_Cinematic_Camera()
	Letter_Box_Out(1.5)
	Lock_Controls(0)
	Suspend_AI(0)
	Sleep(1.5)

	cinematic_three = false
	act_3_active = true

	wat_tambor_list = Find_All_Objects_Of_Type("Wat_Tambor")
	for i,wat_tambor_unit in pairs(wat_tambor_list) do
		if TestValid(wat_tambor_unit) then
			wat_tambor_unit.Despawn()
		end
	end

	mace_unit = Find_Object_Type("Mace_Windu")
	mace_list = Spawn_Unit(mace_unit, player_mtt_02.Get_Position(), p_republic)
	player_mace = mace_list[1]

	cham_unit = Find_Object_Type("Cham_Syndulla")
	cham_list = Spawn_Unit(cham_unit, player_mtt_02.Get_Position(), p_republic)
	player_cham = cham_list[1]

	republic_list = Find_All_Objects_Of_Type(p_hostile)
	for i,republic_unit in pairs(republic_list) do
		if TestValid(republic_unit) then
			republic_unit.Change_Owner(p_republic)
			republic_unit.Teleport_And_Face(mtt_02_marker)
		end
	end

	player_shuttle_01 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), shuttle_01_marker, 12, 1,0.25, 4, 1)
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

	player_shuttle_02 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), shuttle_02_marker, 12, 1,0.25, 4, 1)
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

	player_shuttle_03 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), shuttle_03_marker, 12, 1,0.25, 4, 1)
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

	player_shuttle_04 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), shuttle_04_marker, 12, 1,0.25, 4, 1)
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

	player_shuttle_05 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), shuttle_05_marker, 12, 1,0.25, 4, 1)
	Hide_Sub_Object(player_shuttle_05, 1, "Boil")
	Hide_Sub_Object(player_shuttle_05, 1, "Boil_Carbine")
	Hide_Sub_Object(player_shuttle_05, 1, "Boil_Helmet")
	Hide_Sub_Object(player_shuttle_05, 1, "Waxer")
	Hide_Sub_Object(player_shuttle_05, 1, "Waxer_Carbine")
	Hide_Sub_Object(player_shuttle_05, 1, "Waxer_Helmet")
	Hide_Sub_Object(player_shuttle_05, 1, "Cody")
	Hide_Sub_Object(player_shuttle_05, 1, "Cody_Carbine")
	Hide_Sub_Object(player_shuttle_05, 1, "CodyHelmet")
	Hide_Sub_Object(player_shuttle_05, 1, "Obi")
	Hide_Sub_Object(player_shuttle_05, 1, "Obi_Clones")

	player_shuttle_06 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), shuttle_06_marker, 12, 1,0.25, 4, 1)
	Hide_Sub_Object(player_shuttle_06, 1, "Boil")
	Hide_Sub_Object(player_shuttle_06, 1, "Boil_Carbine")
	Hide_Sub_Object(player_shuttle_06, 1, "Boil_Helmet")
	Hide_Sub_Object(player_shuttle_06, 1, "Waxer")
	Hide_Sub_Object(player_shuttle_06, 1, "Waxer_Carbine")
	Hide_Sub_Object(player_shuttle_06, 1, "Waxer_Helmet")
	Hide_Sub_Object(player_shuttle_06, 1, "Cody")
	Hide_Sub_Object(player_shuttle_06, 1, "Cody_Carbine")
	Hide_Sub_Object(player_shuttle_06, 1, "CodyHelmet")
	Hide_Sub_Object(player_shuttle_06, 1, "Obi")
	Hide_Sub_Object(player_shuttle_06, 1, "Obi_Clones")

	Clone_Spawn_List_01 = SpawnList(Clone_Team_List, player_mtt_02.Get_Position(), p_republic, false, false)
	Clone_Squad_01 = Clone_Spawn_List_01[1]
	Story_Event("LIBERATION_05")

	p_republic.Make_Enemy(p_cis)
	p_cis.Make_Enemy(p_republic)

	mtt_move_to_marker.Highlight(false)
	Remove_Radar_Blip("mtt_move_to_marker_blip")

	Story_Event("ACTIVATE_CIS_AI")
	Story_Event("GOAL_TRIGGER_REP_III")
	Sleep(5.0)

	Clone_Small_Spawn_01_List = SpawnList(Clone_Team_List, shuttle_01_marker.Get_Position(), p_republic, false, false)
	Clone_Small_Squad_01 = Clone_Small_Spawn_01_List[1]

	Clone_Small_Spawn_02_List = SpawnList(Clone_Team_List, shuttle_02_marker.Get_Position(), p_republic, false, false)
	Clone_Small_Squad_02 = Clone_Small_Spawn_02_List[1]

	Clone_Small_Spawn_03_List = SpawnList(Clone_Team_List, shuttle_03_marker.Get_Position(), p_republic, false, false)
	Clone_Small_Squad_03 = Clone_Small_Spawn_03_List[1]

	Clone_Small_Spawn_04_List = SpawnList(Clone_Team_List, shuttle_04_marker.Get_Position(), p_republic, false, false)
	Clone_Small_Squad_04 = Clone_Small_Spawn_04_List[1]

	Clone_Small_Spawn_05_List = SpawnList(Clone_Team_List, shuttle_05_marker.Get_Position(), p_republic, false, false)
	Clone_Small_Squad_05 = Clone_Small_Spawn_05_List[1]

	Clone_Small_Spawn_06_List = SpawnList(Clone_Team_List, shuttle_06_marker.Get_Position(), p_republic, false, false)
	Clone_Small_Squad_06 = Clone_Small_Spawn_06_List[1]

	player_shuttle_01.Despawn()
	player_shuttle_02.Despawn()
	player_shuttle_03.Despawn()
	player_shuttle_04.Despawn()
	player_shuttle_05.Despawn()
	player_shuttle_06.Despawn()

	LAAT_Spawn_01_List = SpawnList(ATTE_Team_List, shuttle_01_marker.Get_Position(), p_republic, false, false)
	LAAT_Squad_01 = LAAT_Spawn_01_List[1]
	LAAT_Squad_01.Teleport_And_Face(shuttle_01_marker)

	LAAT_Spawn_02_List = SpawnList(ATTE_Team_List, shuttle_02_marker.Get_Position(), p_republic, false, false)
	LAAT_Squad_02 = LAAT_Spawn_02_List[1]
	LAAT_Squad_02.Teleport_And_Face(shuttle_02_marker)

	LAAT_Spawn_03_List = SpawnList(ATTE_Team_List, shuttle_03_marker.Get_Position(), p_republic, false, false)
	LAAT_Squad_03 = LAAT_Spawn_03_List[1]
	LAAT_Squad_03.Teleport_And_Face(shuttle_03_marker)

	LAAT_Spawn_04_List = SpawnList(ATTE_Team_List, shuttle_04_marker.Get_Position(), p_republic, false, false)
	LAAT_Squad_04 = LAAT_Spawn_04_List[1]
	LAAT_Squad_04.Teleport_And_Face(shuttle_04_marker)

	LAAT_Spawn_05_List = SpawnList(LAAT_Team_List, shuttle_05_marker.Get_Position(), p_republic, false, false)
	LAAT_Squad_05 = LAAT_Spawn_05_List[1]
	LAAT_Squad_05.Teleport_And_Face(shuttle_05_marker)

	LAAT_Spawn_06_List = SpawnList(LAAT_Team_List, shuttle_06_marker.Get_Position(), p_republic, false, false)
	LAAT_Squad_06 = LAAT_Spawn_06_List[1]
	LAAT_Squad_06.Teleport_And_Face(shuttle_06_marker)

	ATTE_Spawn_01_List = SpawnList(LAAT_Team_List, mtt_02_marker.Get_Position(), p_republic, false, false)
	ATTE_Squad_01 = ATTE_Spawn_01_List[1]
	ATTE_Squad_01.Teleport_And_Face(mtt_02_marker)

	ATTE_Spawn_02_List = SpawnList(LAAT_Team_List, mtt_02_marker.Get_Position(), p_republic, false, false)
	ATTE_Squad_02 = ATTE_Spawn_02_List[1]
	ATTE_Squad_02.Teleport_And_Face(mtt_02_marker)
end

function Start_Cinematic_Outro_Rep()
	GlobalValue.Set("Rimward_Breaking_Bridges_Outcome", 1) -- 0 = CIS Victory; 1 = Republic Victory

	p_republic.Make_Ally(p_cis)
	p_cis.Make_Ally(p_republic)

	act_3_active = false
	cinematic_four = true

	Fade_Screen_Out(0.5)
	Sleep(1)
	Suspend_AI(1)
	Lock_Controls(1)
	Start_Cinematic_Camera()
	Letter_Box_In(0)
	Stop_All_Music()
	Cancel_Fast_Forward()

	Do_End_Cinematic_Cleanup()

	wat_tambor_list = Find_All_Objects_Of_Type("Wat_Tambor")
	for i,wat_tambor_unit in pairs(wat_tambor_list) do
		if TestValid(wat_tambor_unit) then
			wat_tambor_unit.Despawn()
		end
	end

	mace_unit = Find_Object_Type("Mace_Windu")
	mace_list = Spawn_Unit(mace_unit, outro_mace_marker, p_republic)
	player_mace = mace_list[1]
	player_mace.Teleport_And_Face(outro_mace_marker)
	Hide_Sub_Object(player_mace, 1, "lightsaber");

	cham_unit = Find_Object_Type("Cham_Syndulla")
	cham_list = Spawn_Unit(cham_unit, outro_cham_marker, p_republic)
	player_cham = cham_list[1]
	player_cham.Teleport_And_Face(outro_cham_marker)

	tambor_unit = Find_Object_Type("Wat_Tambor")
	tambor_list = Spawn_Unit(tambor_unit, tambor_marker, p_republic)
	player_tambor = tambor_list[1]
	player_tambor.Teleport_And_Face(tambor_marker)

	Allow_Localized_SFX(false)
	SFXManager.Allow_HUD_VO(false)
	SFXManager.Allow_Ambient_VO(false)
	SFXManager.Allow_Localized_SFXEvents(false)
	SFXManager.Allow_Unit_Reponse_VO(false)
	SFXManager.Allow_Enemy_Sighted_VO(false)

	Play_Music("Breaking_Bridges_03")
	Set_Cinematic_Camera_Key(outrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(outrocam_2_marker, 6.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_2_marker, 6.0, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Fade_Screen_In(3.0)
	Letter_Box_In(3.0)

	player_tambor.Turn_To_Face(player_cham)
	player_cham.Turn_To_Face(player_tambor)
	player_mace.Turn_To_Face(player_tambor)

	player_tambor.Play_Animation("Talk", false, 0)
	Sleep(2)
	player_tambor.Play_Animation("Talk", false, 1)
	Sleep(2)

	player_mace.Turn_To_Face(player_cham)
	Sleep(2)

	Set_Cinematic_Camera_Key(outrocam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_3_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(outrocam_4_marker, 7.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_4_marker, 7.0, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	player_tambor.Play_Animation("Talk", false, 0)
	Sleep(3)

	player_cham.Turn_To_Face(player_mace)
	player_mace.Turn_To_Face(player_cham)
	Sleep(2)

	Set_Cinematic_Camera_Key(outrocam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_5_marker, 0, 0, 0, 0, outrocam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(outrocam_6_marker, 11.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_6_marker, 11.0, 0, 0, 0, 0, outrocam_target_1_marker, 1, 0)
	player_cham.Play_Animation("Talk_Gesture", false, 0)
	Sleep(4)

	Fade_Screen_Out(5)
	Sleep(5)

	Allow_Localized_SFX(true)
	SFXManager.Allow_HUD_VO(true)
	SFXManager.Allow_Ambient_VO(true)
	SFXManager.Allow_Localized_SFXEvents(true)
	SFXManager.Allow_Unit_Reponse_VO(true)
	SFXManager.Allow_Enemy_Sighted_VO(true)
	Resume_Mode_Based_Music()

	Story_Event("REPUBLIC_VICTORY")
end
