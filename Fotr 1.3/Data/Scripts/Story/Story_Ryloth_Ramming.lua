
--*****************************************************--
--************** Rimward: Ryloth Ramming **************--
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
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_neutral = Find_Player("Neutral")

	ahsoka_ywing_list = {
	"BTLB_Y-Wing_Squadron",
	"BTLB_Y-Wing_Squadron",
	"BTLB_Y-Wing_Squadron",
	"BTLB_Y-Wing_Squadron",
	"BTLB_Y-Wing_Squadron",
	"BTLB_Y-Wing_Squadron",
	"BTLB_Y-Wing_Squadron",
	"BTLB_Y-Wing_Squadron",
	"BTLB_Y-Wing_Squadron",
	}

	cinematic_one = false
	cinematic_two = false

	cinematic_one_skipped = false
	cinematic_two_skipped = false

	act_1_active = false
	act_2_active = false

	defender_reached = false
	tuuk_destroyed = false

	wp_distance = 200

	current_cinematic_thread_id = nil

	defender_arrived_ryloth = false
	defender_arrived_tuuk = false

	defender_reached_position_2 = false
	defender_reached_position_3 = false
	defender_reached_position_4 = false
	defender_reached_position_5 = false
	defender_reached_position_6 = false

	camera_offset = 125
	mission_started = false

end

function Begin_Battle(message)
	if message == OnEnter then
		intro_1_tuuk_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-tuuk")
		intro_1_yularen_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-yularen")

		intro_1_defender_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-defender")
		intro_1_1_defender_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-1-defender")
		intro_2_defender_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-defender")
		intro_3_defender_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-3-defender")
		intro_4_defender_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-4-defender")
		intro_5_defender_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-5-defender")
		intro_6_defender_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-6-defender")

		intro_1_muni_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-muni-1")
		intro_1_muni_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-muni-2")
		intro_1_muni_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-muni-3")
		intro_1_muni_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-muni-4")
		intro_1_muni_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-muni-5")
		intro_1_muni_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-muni-6")

		intro_2_muni_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-muni-1")
		intro_2_muni_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-muni-2")
		intro_2_muni_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-muni-3")
		intro_2_muni_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-muni-4")
		intro_2_muni_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-muni-5")
		intro_2_muni_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-muni-6")

		intro_1_explosion_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-explosion-1")
		intro_1_explosion_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-explosion-2")
		intro_1_explosion_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-explosion-3")
		intro_1_explosion_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-explosion-4")

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-4")
		introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-5")
		introcam_6_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-6-1")
		introcam_6_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-6-2")
		introcam_7_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-7-1")
		introcam_7_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-7-2")
		introcam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-8")
		introcam_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-9")

		introcam_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-10")
		introcam_11_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-11")
		introcam_12_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-12")
		introcam_13_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-13")
		introcam_14_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-14")
		introcam_15_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-15")
		introcam_16_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-16")
		introcam_17_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-17")
		introcam_18_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-18")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")
		introcam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")
		introcam_target_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-4")
		introcam_target_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-5")

		player_defender = Find_First_Object("VENATOR_DEFENDER")

		player_yularen = Find_First_Object("YULAREN_RESOLUTE")
		if TestValid(player_yularen) then
			player_yularen.Hyperspace_Away(false)
		end

		player_tuuk = Find_Hint("TUUK_PROCURER_STORY", "tuuk")
		player_munificent_1 = Find_Hint("MUNIFICENT", "muni-1")
		player_munificent_2 = Find_Hint("MUNIFICENT", "muni-2")
		player_munificent_3 = Find_Hint("MUNIFICENT", "muni-3")
		player_munificent_4 = Find_Hint("MUNIFICENT", "muni-4")
		player_munificent_5 = Find_Hint("MUNIFICENT", "muni-5")
		player_munificent_6 = Find_Hint("MUNIFICENT", "muni-6")

		if p_republic.Is_Human() then
			mission_started = true
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
		elseif p_cis.Is_Human() then
			mission_started = true
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
		end
	end
end


function Prox_Position_02(prox_obj, trigger_obj)
	if trigger_obj == player_defender then
		if not defender_arrived_tuuk and not defender_reached_position_2 then
			defender_reached_position_2 = true
			player_defender.Move_To(intro_3_defender_marker)
			Register_Prox(intro_3_defender_marker, Prox_Position_03, wp_distance, p_republic)
		end
		prox_obj.Cancel_Event_Object_In_Range(Prox_Position_02)
	end
end

function Prox_Position_03(prox_obj, trigger_obj)
	if trigger_obj == player_defender then
		if not defender_arrived_tuuk and not defender_reached_position_3 then
			defender_reached_position_3 = true
			player_defender.Move_To(intro_4_defender_marker)
			Register_Prox(intro_4_defender_marker, Prox_Position_04, wp_distance, p_republic)
		end
		prox_obj.Cancel_Event_Object_In_Range(Prox_Position_03)
	end
end

function Prox_Position_04(prox_obj, trigger_obj)
	if trigger_obj == player_defender then
		if not defender_arrived_tuuk and not defender_reached_position_4 then
			defender_reached_position_4 = true
			player_defender.Move_To(intro_5_defender_marker)
			Register_Prox(intro_5_defender_marker, Prox_Position_05, wp_distance, p_republic)
		end
		prox_obj.Cancel_Event_Object_In_Range(Prox_Position_04)
	end
end

function Prox_Position_05(prox_obj, trigger_obj)
	if trigger_obj == player_defender then
		if not defender_arrived_tuuk and not defender_reached_position_5 then
			defender_reached_position_5 = true
			player_defender.Move_To(intro_6_defender_marker)
		end
		prox_obj.Cancel_Event_Object_In_Range(Prox_Position_05)
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

					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_Rep")

					cinematic_one = false
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
					Allow_Localized_SFX(true)
					SFXManager.Allow_HUD_VO(true)
					SFXManager.Allow_Ambient_VO(true)
					SFXManager.Allow_Enemy_Sighted_VO(true)
					SFXManager.Allow_Unit_Reponse_VO(true)

					if TestValid(player_defender) then
						player_defender.Despawn()
					end

					if TestValid(player_tuuk) then
						player_tuuk.Despawn()
					end

					player_yularen = Find_First_Object("Yularen_Ryloth_Ramming")

					if not TestValid(Find_First_Object("Yularen_Ryloth_Ramming")) then
						player_yularen = Spawn_Unit(Find_Object_Type("Yularen_Ryloth_Ramming"), intro_1_yularen_marker, p_republic)
						player_yularen = Find_Nearest(intro_1_yularen_marker, p_republic, true)
						player_yularen.Teleport_And_Face(intro_1_yularen_marker)
						player_yularen.Play_Animation("Deploy", false)
					end

					player_yularen.Set_Cannot_Be_Killed(true)
					player_yularen.Set_Selectable(false)

					FogOfWar.Reveal(p_republic, player_yularen, 9999)

					Ahsoka_Squadron = SpawnList(ahsoka_ywing_list, intro_1_yularen_marker, p_republic, true, false)
					Ahsoka_Squad = Ahsoka_Squadron[1]
					Ahsoka_Squad.Teleport_And_Face(intro_1_yularen_marker)
					Ahsoka_Squad.Cinematic_Hyperspace_In(1)

					player_munificent_1.Despawn()
					player_munificent_2.Despawn()
					player_munificent_3.Despawn()
					player_munificent_4.Despawn()
					player_munificent_5.Despawn()
					player_munificent_6.Despawn()

					player_munificent_1 = Spawn_Unit(Find_Object_Type("MUNIFICENT"), intro_2_muni_1_marker, p_cis)
					player_munificent_1 = Find_Nearest(intro_2_muni_1_marker, p_cis, true)
					player_munificent_1.Teleport_And_Face(intro_2_muni_1_marker)

					player_munificent_2 = Spawn_Unit(Find_Object_Type("MUNIFICENT"), intro_2_muni_2_marker, p_cis)
					player_munificent_2 = Find_Nearest(intro_2_muni_2_marker, p_cis, true)
					player_munificent_2.Teleport_And_Face(intro_2_muni_2_marker)

					player_munificent_3 = Spawn_Unit(Find_Object_Type("MUNIFICENT"), intro_2_muni_3_marker, p_cis)
					player_munificent_3 = Find_Nearest(intro_2_muni_3_marker, p_cis, true)
					player_munificent_3.Teleport_And_Face(intro_2_muni_3_marker)

					player_munificent_4 = Spawn_Unit(Find_Object_Type("MUNIFICENT"), intro_2_muni_4_marker, p_cis)
					player_munificent_4 = Find_Nearest(intro_2_muni_4_marker, p_cis, true)
					player_munificent_4.Teleport_And_Face(intro_2_muni_4_marker)

					player_munificent_5 = Spawn_Unit(Find_Object_Type("MUNIFICENT"), intro_2_muni_5_marker, p_cis)
					player_munificent_5 = Find_Nearest(intro_2_muni_5_marker, p_cis, true)
					player_munificent_5.Teleport_And_Face(intro_2_muni_5_marker)

					player_munificent_6 = Spawn_Unit(Find_Object_Type("MUNIFICENT"), intro_2_muni_6_marker, p_cis)
					player_munificent_6 = Find_Nearest(intro_2_muni_6_marker, p_cis, true)
					player_munificent_6.Teleport_And_Face(intro_2_muni_6_marker)

					Story_Event("GOAL_TRIGGER_REP_I")

					Story_Event("ALLOW_STUFF")
					Story_Event("ACTIVATE_CIS_AI")

					Point_Camera_At(player_yularen)
					Transition_To_Tactical_Camera(0.5)
					Letter_Box_Out(0.5)
					End_Cinematic_Camera()
					Lock_Controls(0)
					Suspend_AI(0)

					Fade_Screen_In(0.5)
					Sleep(0.5)

					cinematic_two = false
					act_1_active = true
				end
			end
		end
	end 
end

function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_1_active then
		end
	elseif p_republic.Is_Human() then
		if act_1_active then
		end
	end
end


function Start_Cinematic_Intro_Rep()
	Start_Cinematic_Camera()
	Stop_All_Music()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()
	Fade_On()

	Yularen_Spawning = Find_First_Object("Yularen_Resolute")
	if TestValid(Yularen_Spawning) then
		Find_First_Object("Yularen_Resolute").Hyperspace_Away(false)
	end
	Yularen_Spawning = Spawn_From_Reinforcement_Pool(Find_Object_Type("Yularen_Resolute"), Find_First_Object("ATTACKER ENTRY POSITION"), p_republic)
	if TestValid(Find_First_Object("Yularen_Resolute")) then
		Find_First_Object("Yularen_Resolute").Hyperspace_Away(false)
	end

	Sleep(0.1)

	if TestValid(Find_First_Object("Yularen_Resolute")) then
		Find_First_Object("Yularen_Resolute").Hyperspace_Away(false)
	end

	player_tuuk.Teleport_And_Face(intro_1_tuuk_marker)
	player_tuuk.Suspend_Locomotor(true)

	player_munificent_1.Teleport_And_Face(intro_1_muni_1_marker)
	player_munificent_1.Suspend_Locomotor(true)
	player_munificent_1.Prevent_Opportunity_Fire(true)

	player_munificent_2.Teleport_And_Face(intro_1_muni_2_marker)
	player_munificent_2.Suspend_Locomotor(true)
	player_munificent_2.Prevent_Opportunity_Fire(true)

	player_munificent_3.Teleport_And_Face(intro_1_muni_3_marker)
	player_munificent_3.Suspend_Locomotor(true)
	player_munificent_3.Prevent_Opportunity_Fire(true)

	player_munificent_4.Teleport_And_Face(intro_1_muni_4_marker)
	player_munificent_4.Suspend_Locomotor(true)
	player_munificent_4.Prevent_Opportunity_Fire(true)

	player_munificent_5.Teleport_And_Face(intro_1_muni_5_marker)
	player_munificent_5.Suspend_Locomotor(true)
	player_munificent_5.Prevent_Opportunity_Fire(true)

	player_munificent_6.Teleport_And_Face(intro_1_muni_6_marker)
	player_munificent_6.Suspend_Locomotor(true)
	player_munificent_6.Prevent_Opportunity_Fire(true)

	Allow_Localized_SFX(false)
	SFXManager.Allow_HUD_VO(false)
	SFXManager.Allow_Ambient_VO(false)
	SFXManager.Allow_Enemy_Sighted_VO(false)
	SFXManager.Allow_Unit_Reponse_VO(false)
	Sleep(0.5)

	Play_Music("Ryloth_Ramming_01")
	Story_Event("CINEMATIC_CRAWL")
	Sleep(1.0)

	Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 30.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 30.0, 0, 0, 0, 0, player_defender, 1, 0)
	Fade_Screen_In(6.0)
	Letter_Box_In(3.0)

	player_defender.Teleport_And_Face(intro_1_defender_marker)
	player_defender.Cinematic_Hyperspace_In(100)
	player_defender.Prevent_Opportunity_Fire(true)
	player_defender.Prevent_All_Fire(true)
	player_defender.Set_Cannot_Be_Killed(true)
	player_defender.Override_Max_Speed(6.0)

	defender_arrived_ryloth = true

	cinematic_one = true

	player_defender.Move_To(intro_1_1_defender_marker)
	Sleep(2.0)

	Register_Prox(intro_2_defender_marker, Prox_Position_02, wp_distance, p_republic)
	Sleep(15.0)

	player_defender.Move_To(intro_2_defender_marker)
	Set_Cinematic_Camera_Key(introcam_2_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_2_marker, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_3_marker, 20.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_3_marker, 20.0, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Sleep(15.0)

	player_defender.Teleport_And_Face(intro_2_defender_marker)
	player_defender.Move_To(intro_3_defender_marker)

	Set_Cinematic_Camera_Key(introcam_4_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_4_marker, 0, 0, 0, 0, player_tuuk, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_5_marker, 15.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_5_marker, 15.0, 0, 0, 0, 0, player_tuuk, 1, 0)
	Sleep(15.0)

	Set_Cinematic_Camera_Key(introcam_6_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_6_1_marker, 0, 0, 0, 0, player_defender, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_6_2_marker, 20.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_6_2_marker, 20.0, 0, 0, 0, 0, player_defender, 1, 0)
	Sleep(20.0)

	Set_Cinematic_Camera_Key(introcam_7_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_7_1_marker, 0, 0, 0, 0, intro_6_defender_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_7_2_marker, 15.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_7_2_marker, 15.0, 0, 0, 0, 0, intro_6_defender_marker, 1, 0)
	Sleep(15.0)

	cinematic_one = false
	cinematic_two = true

	player_defender.Teleport_And_Face(intro_3_defender_marker)
	player_defender.Move_To(intro_4_defender_marker)
	player_defender.Override_Max_Speed(7.5)
	player_defender.Prevent_All_Fire(false)
	player_defender.Prevent_Opportunity_Fire(false)

	Set_Cinematic_Camera_Key(introcam_8_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_8_marker, 0, 0, 0, 0, player_defender, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_8_marker, 15.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_8_marker, 15.0, 0, 0, 0, 0, player_defender, 1, 0)
	Sleep(15.0)

	Set_Cinematic_Camera_Key(introcam_9_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_9_marker, 0, 0, 0, 0, player_defender, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_10_marker, 15.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_10_marker, 15.0, 0, 0, 0, 0, player_defender, 1, 0)
	Sleep(15.0)

	defender_reached_wp_4 = true
	defender_arrived_tuuk = true
	player_defender.Teleport_And_Face(intro_5_defender_marker)
	player_defender.Move_To(intro_6_defender_marker)
	player_defender.Override_Max_Speed(3.5)

	Fade_Screen_In(0.1)
	Set_Cinematic_Camera_Key(introcam_11_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_11_marker, 0, 0, 0, 0, player_defender, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_12_marker, 8.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_12_marker, 8.0, 0, 0, 0, 0, player_defender, 1, 0)
	Sleep(7.0)

	Explosion_01 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Space"), intro_1_explosion_1_marker, p_neutral)
	Sleep(0.05)
	Explosion_02 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Space"), intro_1_explosion_2_marker, p_neutral)
	Sleep(0.05)
	Explosion_03 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Space"), intro_1_explosion_3_marker, p_neutral)
	Sleep(0.1)
	Explosion_04 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Space"), intro_1_explosion_4_marker, p_neutral)

	Set_Cinematic_Camera_Key(introcam_13_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_13_marker, 0, 0, 0, 0, player_defender, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_14_marker, 8.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_14_marker, 8.0, 0, 0, 0, 0, player_defender, 1, 0)

	Explosion_05 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Space"), intro_6_defender_marker, p_neutral)
	Sleep(0.05)
	Explosion_06 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Space"), player_defender, p_neutral)
	Sleep(0.05)
	Explosion_07 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Space"), player_tuuk, p_neutral)
	Sleep(0.2)

	Explosion_08 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Space"), intro_1_explosion_1_marker, p_neutral)
	Explosion_09 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Space"), intro_1_explosion_2_marker, p_neutral)
	Explosion_10 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Space"), intro_1_explosion_3_marker, p_neutral)
	Explosion_11 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Space"), intro_1_explosion_4_marker, p_neutral)

	player_defender.Set_Cannot_Be_Killed(false)
	player_defender.Take_Damage(999999)
	Sleep(0.2)

	player_tuuk.Take_Damage(999999)
	Sleep(6.3)

	player_munificent_1.Despawn()
	player_munificent_2.Despawn()
	player_munificent_3.Despawn()
	player_munificent_4.Despawn()
	player_munificent_5.Despawn()
	player_munificent_6.Despawn()

	player_munificent_1 = Spawn_Unit(Find_Object_Type("MUNIFICENT"), intro_2_muni_1_marker, p_cis)
	player_munificent_1 = Find_Nearest(intro_2_muni_1_marker, p_cis, true)
	player_munificent_1.Teleport_And_Face(intro_2_muni_1_marker)
	player_munificent_1.Prevent_Opportunity_Fire(true)
	player_munificent_1.Suspend_Locomotor(true)

	player_munificent_2 = Spawn_Unit(Find_Object_Type("MUNIFICENT"), intro_2_muni_2_marker, p_cis)
	player_munificent_2 = Find_Nearest(intro_2_muni_2_marker, p_cis, true)
	player_munificent_2.Teleport_And_Face(intro_2_muni_2_marker)
	player_munificent_2.Prevent_Opportunity_Fire(true)
	player_munificent_2.Suspend_Locomotor(true)

	player_munificent_3 = Spawn_Unit(Find_Object_Type("MUNIFICENT"), intro_2_muni_3_marker, p_cis)
	player_munificent_3 = Find_Nearest(intro_2_muni_3_marker, p_cis, true)
	player_munificent_3.Teleport_And_Face(intro_2_muni_3_marker)
	player_munificent_3.Prevent_Opportunity_Fire(true)
	player_munificent_3.Suspend_Locomotor(true)

	player_munificent_4 = Spawn_Unit(Find_Object_Type("MUNIFICENT"), intro_2_muni_4_marker, p_cis)
	player_munificent_4 = Find_Nearest(intro_2_muni_4_marker, p_cis, true)
	player_munificent_4.Teleport_And_Face(intro_2_muni_4_marker)
	player_munificent_4.Prevent_Opportunity_Fire(true)
	player_munificent_4.Suspend_Locomotor(true)

	player_munificent_5 = Spawn_Unit(Find_Object_Type("MUNIFICENT"), intro_2_muni_5_marker, p_cis)
	player_munificent_5 = Find_Nearest(intro_2_muni_5_marker, p_cis, true)
	player_munificent_5.Teleport_And_Face(intro_2_muni_5_marker)
	player_munificent_5.Prevent_Opportunity_Fire(true)
	player_munificent_5.Suspend_Locomotor(true)

	player_munificent_6 = Spawn_Unit(Find_Object_Type("MUNIFICENT"), intro_2_muni_6_marker, p_cis)
	player_munificent_6 = Find_Nearest(intro_2_muni_6_marker, p_cis, true)
	player_munificent_6.Teleport_And_Face(intro_2_muni_6_marker)
	player_munificent_6.Prevent_Opportunity_Fire(true)
	player_munificent_6.Suspend_Locomotor(true)

	player_yularen = Spawn_Unit(Find_Object_Type("Yularen_Ryloth_Ramming"), intro_1_yularen_marker, p_republic)
	player_yularen = Find_Nearest(intro_1_yularen_marker, p_republic, true)
	player_yularen.Teleport_And_Face(intro_1_yularen_marker)
	player_yularen.Cinematic_Hyperspace_In(50)

	Set_Cinematic_Camera_Key(introcam_15_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_15_marker, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_16_marker, 12.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_16_marker, 12.0, 0, 0, 0, 0, player_yularen, 1, 0)
	Sleep(4.0)

	player_yularen.Play_Animation("Deploy", false)
	Sleep(9.0)

	Set_Cinematic_Camera_Key(introcam_17_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_17_marker, 0, 0, 0, 0, introcam_target_5_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_18_marker, 5.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_18_marker, 5.0, 0, 0, 0, 0, introcam_target_5_marker, 1, 0)
	Sleep(5.0)

	Ahsoka_Squadron = SpawnList(ahsoka_ywing_list, intro_1_yularen_marker, p_republic, true, false)
	Ahsoka_Squad = Ahsoka_Squadron[1]
	Ahsoka_Squad.Teleport_And_Face(intro_1_yularen_marker)
	Ahsoka_Squad.Cinematic_Hyperspace_In(1)

	player_yularen.Set_Cannot_Be_Killed(true)
	player_yularen.Set_Selectable(false)

	FogOfWar.Reveal(p_republic, player_yularen, 9999)

	if not cinematic_two_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Rep")
	end
end

function End_Cinematic_Intro_Rep()
	Point_Camera_At(player_yularen)
	Transition_To_Tactical_Camera(3)
	Letter_Box_Out(3)
	Sleep(3.0)
	End_Cinematic_Camera()
	Lock_Controls(0)
	Suspend_AI(0)

	cinematic_two = false
	act_1_active = true

	Story_Event("GOAL_TRIGGER_REP_I")

	player_munificent_1.Suspend_Locomotor(false)
	player_munificent_1.Prevent_Opportunity_Fire(false)

	player_munificent_2.Suspend_Locomotor(false)
	player_munificent_2.Prevent_Opportunity_Fire(false)

	player_munificent_3.Suspend_Locomotor(false)
	player_munificent_3.Prevent_Opportunity_Fire(false)

	player_munificent_4.Suspend_Locomotor(false)
	player_munificent_4.Prevent_Opportunity_Fire(false)

	player_munificent_5.Suspend_Locomotor(false)
	player_munificent_5.Prevent_Opportunity_Fire(false)

	player_munificent_6.Suspend_Locomotor(false)
	player_munificent_6.Prevent_Opportunity_Fire(false)

	Story_Event("ALLOW_STUFF")
	Story_Event("ACTIVATE_CIS_AI")

	Sleep(1.0)
	Resume_Mode_Based_Music()
	Allow_Localized_SFX(true)
	SFXManager.Allow_HUD_VO(true)
	SFXManager.Allow_Ambient_VO(true)
	SFXManager.Allow_Enemy_Sighted_VO(true)
	SFXManager.Allow_Unit_Reponse_VO(true)
end

function Start_Cinematic_Midtro_Rep()
	cinematic_one = false
	cinematic_two = true
	if TestValid(Find_First_Object("VENATOR_DEFENDER")) then
		Find_First_Object("VENATOR_DEFENDER").Despawn()
	end

	player_defender = Spawn_Unit(Find_Object_Type("VENATOR_DEFENDER"), intro_4_defender_marker, p_republic)
	player_defender = Find_Nearest(intro_4_defender_marker, p_republic, true)
	player_defender.Teleport_And_Face(intro_4_defender_marker)
	player_defender.Cinematic_Hyperspace_In(0.25)
	player_defender.Prevent_Opportunity_Fire(true)
	player_defender.Prevent_All_Fire(true)
	player_defender.Set_Cannot_Be_Killed(true)
	player_defender.Override_Max_Speed(6.0)

	Sleep(0.5)
	player_defender.Move_To(intro_5_defender_marker)
	Register_Prox(intro_5_defender_marker, Prox_Position_05, wp_distance, p_republic)

	Play_Music("Ryloth_Ramming_02")

	Fade_Screen_In(0.5)

	Set_Cinematic_Camera_Key(introcam_8_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_8_marker, 0, 0, 0, 0, player_defender, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_8_marker, 9.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_8_marker, 9.0, 0, 0, 0, 0, player_defender, 1, 0)
	Sleep(9.0)

	Set_Cinematic_Camera_Key(introcam_9_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_9_marker, 0, 0, 0, 0, player_defender, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_10_marker, 11.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_10_marker, 11.0, 0, 0, 0, 0, player_defender, 1, 0)
	Sleep(11.0)

	player_defender.Teleport_And_Face(intro_5_defender_marker)
	player_defender.Move_To(intro_6_defender_marker)

	Set_Cinematic_Camera_Key(introcam_11_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_11_marker, 0, 0, 0, 0, player_defender, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_12_marker, 8.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_12_marker, 8.0, 0, 0, 0, 0, player_defender, 1, 0)
	Sleep(6.0)

	Explosion_01 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Space"), intro_1_explosion_1_marker, p_neutral)
	Sleep(0.05)
	Explosion_02 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Space"), intro_1_explosion_2_marker, p_neutral)
	Sleep(0.05)
	Explosion_03 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Space"), intro_1_explosion_3_marker, p_neutral)
	Sleep(0.1)
	Explosion_04 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Space"), intro_1_explosion_4_marker, p_neutral)

	Set_Cinematic_Camera_Key(introcam_13_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_13_marker, 0, 0, 0, 0, player_defender, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_14_marker, 8.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_14_marker, 8.0, 0, 0, 0, 0, player_defender, 1, 0)

	Explosion_05 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Space"), intro_6_defender_marker, p_neutral)
	Sleep(0.05)
	Explosion_06 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Space"), player_defender, p_neutral)
	Sleep(0.05)
	Explosion_07 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Space"), player_tuuk, p_neutral)
	Sleep(0.2)

	Explosion_08 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Space"), intro_1_explosion_1_marker, p_neutral)
	Explosion_09 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Space"), intro_1_explosion_2_marker, p_neutral)
	Explosion_10 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Space"), intro_1_explosion_3_marker, p_neutral)
	Explosion_11 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Space"), intro_1_explosion_4_marker, p_neutral)

	player_defender.Set_Cannot_Be_Killed(false)
	player_defender.Take_Damage(999999)
	Sleep(0.2)

	player_tuuk.Take_Damage(999999)
	Sleep(6.3)

	player_munificent_1.Despawn()
	player_munificent_2.Despawn()
	player_munificent_3.Despawn()
	player_munificent_4.Despawn()
	player_munificent_5.Despawn()
	player_munificent_6.Despawn()

	player_munificent_1 = Spawn_Unit(Find_Object_Type("MUNIFICENT"), intro_2_muni_1_marker, p_cis)
	player_munificent_1 = Find_Nearest(intro_2_muni_1_marker, p_cis, true)
	player_munificent_1.Teleport_And_Face(intro_2_muni_1_marker)
	player_munificent_1.Prevent_Opportunity_Fire(true)
	player_munificent_1.Suspend_Locomotor(true)

	player_munificent_2 = Spawn_Unit(Find_Object_Type("MUNIFICENT"), intro_2_muni_2_marker, p_cis)
	player_munificent_2 = Find_Nearest(intro_2_muni_2_marker, p_cis, true)
	player_munificent_2.Teleport_And_Face(intro_2_muni_2_marker)
	player_munificent_2.Prevent_Opportunity_Fire(true)
	player_munificent_2.Suspend_Locomotor(true)

	player_munificent_3 = Spawn_Unit(Find_Object_Type("MUNIFICENT"), intro_2_muni_3_marker, p_cis)
	player_munificent_3 = Find_Nearest(intro_2_muni_3_marker, p_cis, true)
	player_munificent_3.Teleport_And_Face(intro_2_muni_3_marker)
	player_munificent_3.Prevent_Opportunity_Fire(true)
	player_munificent_3.Suspend_Locomotor(true)

	player_munificent_4 = Spawn_Unit(Find_Object_Type("MUNIFICENT"), intro_2_muni_4_marker, p_cis)
	player_munificent_4 = Find_Nearest(intro_2_muni_4_marker, p_cis, true)
	player_munificent_4.Teleport_And_Face(intro_2_muni_4_marker)
	player_munificent_4.Prevent_Opportunity_Fire(true)
	player_munificent_4.Suspend_Locomotor(true)

	player_munificent_5 = Spawn_Unit(Find_Object_Type("MUNIFICENT"), intro_2_muni_5_marker, p_cis)
	player_munificent_5 = Find_Nearest(intro_2_muni_5_marker, p_cis, true)
	player_munificent_5.Teleport_And_Face(intro_2_muni_5_marker)
	player_munificent_5.Prevent_Opportunity_Fire(true)
	player_munificent_5.Suspend_Locomotor(true)

	player_munificent_6 = Spawn_Unit(Find_Object_Type("MUNIFICENT"), intro_2_muni_6_marker, p_cis)
	player_munificent_6 = Find_Nearest(intro_2_muni_6_marker, p_cis, true)
	player_munificent_6.Teleport_And_Face(intro_2_muni_6_marker)
	player_munificent_6.Prevent_Opportunity_Fire(true)
	player_munificent_6.Suspend_Locomotor(true)

	player_yularen = Spawn_Unit(Find_Object_Type("Yularen_Ryloth_Ramming"), intro_1_yularen_marker, p_republic)
	player_yularen = Find_Nearest(intro_1_yularen_marker, p_republic, true)
	player_yularen.Teleport_And_Face(intro_1_yularen_marker)
	player_yularen.Cinematic_Hyperspace_In(50)

	Set_Cinematic_Camera_Key(introcam_15_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_15_marker, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_16_marker, 12.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_16_marker, 12.0, 0, 0, 0, 0, player_yularen, 1, 0)
	Sleep(4.0)

	player_yularen.Play_Animation("Deploy", false)
	Sleep(9.0)

	Set_Cinematic_Camera_Key(introcam_17_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_17_marker, 0, 0, 0, 0, introcam_target_5_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_18_marker, 5.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_18_marker, 5.0, 0, 0, 0, 0, introcam_target_5_marker, 1, 0)
	Sleep(5.0)

	Ahsoka_Squadron = SpawnList(ahsoka_ywing_list, intro_1_yularen_marker, p_republic, true, false)
	Ahsoka_Squad = Ahsoka_Squadron[1]
	Ahsoka_Squad.Teleport_And_Face(intro_1_yularen_marker)
	Ahsoka_Squad.Cinematic_Hyperspace_In(1)

	player_yularen.Set_Cannot_Be_Killed(true)
	player_yularen.Set_Selectable(false)

	FogOfWar.Reveal(p_republic, player_yularen, 9999)

	if not cinematic_two_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Midtro_Rep")
	end
end

function End_Cinematic_Midtro_Rep()
	Point_Camera_At(player_yularen)
	Transition_To_Tactical_Camera(3)
	Letter_Box_Out(3)
	Sleep(3.0)
	End_Cinematic_Camera()
	Lock_Controls(0)
	Suspend_AI(0)

	cinematic_two = false
	act_1_active = true

	Story_Event("GOAL_TRIGGER_REP_I")

	player_munificent_1.Suspend_Locomotor(false)
	player_munificent_1.Prevent_Opportunity_Fire(false)

	player_munificent_2.Suspend_Locomotor(false)
	player_munificent_2.Prevent_Opportunity_Fire(false)

	player_munificent_3.Suspend_Locomotor(false)
	player_munificent_3.Prevent_Opportunity_Fire(false)

	player_munificent_4.Suspend_Locomotor(false)
	player_munificent_4.Prevent_Opportunity_Fire(false)

	player_munificent_5.Suspend_Locomotor(false)
	player_munificent_5.Prevent_Opportunity_Fire(false)

	player_munificent_6.Suspend_Locomotor(false)
	player_munificent_6.Prevent_Opportunity_Fire(false)

	Story_Event("ALLOW_STUFF")
	Story_Event("ACTIVATE_CIS_AI")

	Resume_Mode_Based_Music()
	Allow_Localized_SFX(true)
	SFXManager.Allow_HUD_VO(true)
	SFXManager.Allow_Ambient_VO(true)
	SFXManager.Allow_Enemy_Sighted_VO(true)
	SFXManager.Allow_Unit_Reponse_VO(true)
end
