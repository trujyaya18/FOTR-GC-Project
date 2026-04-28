
--*****************************************************--
--***** Operation Durge's Lance: Shipyard Showdown ****--
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
		Grievous_Malevolence_Destroyed = State_Grievous_Malevolence_Destroyed,
		Grievous_Renitor_Destroyed = State_Renitor_Destroyed,
		Invisible_Hand_Destroyed = State_Invisible_Hand_Destroyed,
	}

	republic_defender_list = {
		"Generic_Star_Destroyer",
		"Generic_Star_Destroyer",
		"Generic_Praetor",
		"Generic_Venator",
		"Generic_Venator",
		"Generic_Venator",
		"Generic_Tector",
		"Arquitens",
		"Arquitens",
		"Arquitens",
		"Arquitens",
		"Corellian_Corvette",
		"Corellian_Corvette",
		"Corellian_Corvette",
		"Corellian_Corvette",
		"Corellian_Corvette",
		"Corellian_Corvette",
		"Corellian_Corvette",
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_hostile = Find_Player("Hostile")

	cinematic_one = false
	cinematic_one_skipped = false
	act_1_active = false

	cinematic_one_ALT = false
	cinematic_one_ALT_skipped = false
	act_1_ALT_active = false

	grievous_soulless_one_active = false
	grievous_renitor_active = false
	grievous_munificent_active = false
	grievous_invisible_hand_active = false
	grievous_malevolence_active = false

	current_cinematic_thread_id = nil

	camera_offset = 125
	mission_started = false
end

function Begin_Battle(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			rep_defence_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-defender-01")
			rep_defence_02_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-defender-02")

			intro_cis_ship_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cis-ship-1")
			intro_cis_ship_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cis-ship-2")
			intro_cis_ship_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cis-ship-3")

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

			introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
			introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")

			p_republic.Make_Ally(p_cis)
			p_cis.Make_Ally(p_republic)

			player_grievous_munificent = Find_First_Object("GRIEVOUS_MUNIFICENT")
			if TestValid(player_grievous_munificent) then
				grievous_munificent_active = true
			end
			player_grievous_renitor = Find_First_Object("GRIEVOUS_RECUSANT")
			if TestValid(player_grievous_renitor) then
				grievous_renitor_active = true
			end
			player_invisible_hand = Find_First_Object("INVISIBLE_HAND")
			if TestValid(player_invisible_hand) then
				grievous_invisible_hand_active = true
			end
			player_malevolence = Find_First_Object("GRIEVOUS_MALEVOLENCE")
			if TestValid(player_malevolence) then
				grievous_malevolence_active = true
			end
			player_soulless_one = Find_First_Object("SOULLESS_ONE")
			if TestValid(player_soulless_one) then
				grievous_soulless_one_active = true
			end

			player_onara = Find_First_Object("ONARA_KUAT")

			mission_started = true
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
		end
	end
end


function State_Grievous_Malevolence_Destroyed(message)
	if message == OnEnter then
		Reinforce_Unit(Find_Object_Type("Grievous_Team_Recusant"), false, p_cis, true, false)
	end
end

function State_Renitor_Destroyed(message)
	if message == OnEnter then
		Reinforce_Unit(Find_Object_Type("Grievous_Team_Munificent"), false, p_cis, true, false)
	end
end

function State_Invisible_Hand_Destroyed(message)
	if message == OnEnter then
		Reinforce_Unit(Find_Object_Type("Grievous_Team_Munificent"), false, p_cis, true, false)
	end
end

function State_Firework_Activated()
	Story_Event("PRODUCT_PLACEMENT_12")
	container_list = Find_All_Objects_Of_Type("ORBITAL_RESOURCE_CONTAINER")
	for k,player_container in pairs(container_list) do
		if TestValid(player_container) then
			player_container.Change_Owner(p_hostile)
			player_container.Take_Damage(9999)
		end
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
				Resume_Mode_Based_Music()

				if not TestValid(player_munificent_1) then
					player_munificent_1 = Spawn_Unit(Find_Object_Type("Munificent"), intro_cis_ship_2_marker, p_cis)
					player_munificent_1 = Find_Nearest(intro_cis_ship_2_marker, p_cis, true)
					player_munificent_1.Teleport_And_Face(intro_cis_ship_2_marker)
					player_munificent_1.Cinematic_Hyperspace_In(50)
				end

				if not TestValid(player_munificent_2) then
					player_munificent_2 = Spawn_Unit(Find_Object_Type("Munificent"), intro_cis_ship_3_marker, p_cis)
					player_munificent_2 = Find_Nearest(intro_cis_ship_3_marker, p_cis, true)
					player_munificent_2.Teleport_And_Face(intro_cis_ship_3_marker)
					player_munificent_2.Cinematic_Hyperspace_In(50)
				end

				p_republic.Make_Enemy(p_cis)
				p_cis.Make_Enemy(p_republic)

				Point_Camera_At(intro_cis_ship_1_marker)
				Letter_Box_Out(0)
				Lock_Controls(0)
				Suspend_AI(0)
				End_Cinematic_Camera()

				if (GlobalValue.Get("ODL_CIS_Shipyard_Struggle_Outcome") == 0) then
					Register_Timer(State_Firework_Activated, 15)
				else
					container_list = Find_All_Objects_Of_Type("ORBITAL_RESOURCE_CONTAINER")
					for k,player_container in pairs(container_list) do
						if TestValid(player_container) then
							player_container.Despawn()
						end
					end
				end

				--Story_Event("CIS_VICTORY")

				Story_Event("ACTIVATE_REP_AI")
				Story_Event("GOAL_TRIGGER_CIS_I")

				p_republic.Make_Enemy(p_cis)
				p_cis.Make_Enemy(p_republic)

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
		end
	end
end


function Start_Cinematic_Intro_CIS()
	AI_Republic_Fleet = SpawnList(republic_defender_list, rep_defence_01_marker.Get_Position(), p_republic, true, true)
	Republic_AI_Fleet = AI_Republic_Fleet[1]
	Republic_AI_Fleet.Teleport_And_Face(rep_defence_01_marker)

	Grievous_Spawning = Find_First_Object("Invisible_Hand")
	if not TestValid(Grievous_Spawning) then
		Grievous_Spawning = Find_First_Object("Grievous_Recusant")
		if not TestValid(Grievous_Spawning) then
			Grievous_Spawning = Find_First_Object("Grievous_Munificent")
			if not TestValid(Grievous_Spawning) then
				Grievous_Spawning = Find_First_Object("Grievous_Malevolence")
				if not TestValid(Grievous_Spawning) then
					Grievous_Spawning = Find_First_Object("Soulless_One")
					if not TestValid(Grievous_Spawning) then
						Grievous_Spawning = Spawn_From_Reinforcement_Pool(Find_Object_Type("Grievous_Team"), intro_cis_ship_1_marker, p_cis)
						if Grievous_Spawning then
							Grievous_Spawning = Grievous_Spawning[1]
							player_invisible_hand = Spawn_Unit(Find_Object_Type("Invisible_Hand"), intro_cis_ship_1_marker, p_cis)
							player_invisible_hand = Find_Nearest(intro_cis_ship_1_marker, p_cis, true)
							player_invisible_hand.Teleport_And_Face(intro_cis_ship_1_marker)	
							player_invisible_hand.Cinematic_Hyperspace_In(50)
							grievous_invisible_hand_active = true
						end
					end
					if not TestValid(Grievous_Spawning) then
						Grievous_Spawning = Spawn_From_Reinforcement_Pool(Find_Object_Type("Grievous_Team_Recusant"), intro_cis_ship_1_marker, p_cis)
						if Grievous_Spawning then
							Grievous_Spawning = Grievous_Spawning[1]
							player_renitor = Spawn_Unit(Find_Object_Type("Grievous_Recusant"), intro_cis_ship_1_marker, p_cis)
							player_renitor = Find_Nearest(intro_cis_ship_1_marker, p_cis, true)
							player_renitor.Teleport_And_Face(intro_cis_ship_1_marker)	
							player_renitor.Cinematic_Hyperspace_In(50)
							grievous_renitor_active = true
						end
					end
					if not TestValid(Grievous_Spawning) then
						Grievous_Spawning = Spawn_From_Reinforcement_Pool(Find_Object_Type("Grievous_Team_Munificent"), intro_cis_ship_1_marker, p_cis)
						if Grievous_Spawning then
							Grievous_Spawning = Grievous_Spawning[1]
							player_grievous_munificent = Spawn_Unit(Find_Object_Type("Grievous_Munificent"), intro_cis_ship_1_marker, p_cis)
							player_grievous_munificent = Find_Nearest(intro_cis_ship_1_marker, p_cis, true)
							player_grievous_munificent.Teleport_And_Face(intro_cis_ship_1_marker)	
							player_grievous_munificent.Cinematic_Hyperspace_In(50)
							grievous_munificent_active = true
						end
					end
					if not TestValid(Grievous_Spawning) then
						Grievous_Spawning = Spawn_From_Reinforcement_Pool(Find_Object_Type("Grievous_Team_Malevolence"), intro_cis_ship_1_marker, p_cis)
						if Grievous_Spawning then
							Grievous_Spawning = Grievous_Spawning[1]
							player_malevolence = Spawn_Unit(Find_Object_Type("Grievous_Malevolence"), intro_cis_ship_1_marker, p_cis)
							player_malevolence = Find_Nearest(intro_cis_ship_1_marker, p_cis, true)
							player_malevolence.Teleport_And_Face(intro_cis_ship_1_marker)	
							player_malevolence.Cinematic_Hyperspace_In(50)
							grievous_malevolence_active = true
						end
					end
					if not TestValid(Grievous_Spawning) then
						Grievous_Spawning = Spawn_From_Reinforcement_Pool(Find_Object_Type("Grievous_Team_Soulless_One"), intro_cis_ship_1_marker, p_cis)
						if Grievous_Spawning then
							Grievous_Spawning = Grievous_Spawning[1]
							player_soulless_one = Spawn_Unit(Find_Object_Type("Soulless_One_Squadron"), intro_cis_ship_1_marker, p_cis)
							player_soulless_one = Find_Nearest(intro_cis_ship_1_marker, p_cis, true)
							player_soulless_one.Teleport_And_Face(intro_cis_ship_1_marker)	
							player_soulless_one.Cinematic_Hyperspace_In(50)
							grievous_soulless_one_active = true
						end
					end
				end
			end
		end
	end

	if not TestValid(player_munificent_1) then
		player_munificent_1 = Spawn_Unit(Find_Object_Type("MUNIFICENT"), intro_cis_ship_2_marker, p_cis)
		player_munificent_1 = Find_Nearest(intro_cis_ship_2_marker, p_cis, true)
		player_munificent_1.Teleport_And_Face(intro_cis_ship_2_marker)
		player_munificent_1.Cinematic_Hyperspace_In(50)
	end

	if not TestValid(player_munificent_2) then
		player_munificent_2 = Spawn_Unit(Find_Object_Type("MUNIFICENT"), intro_cis_ship_3_marker, p_cis)
		player_munificent_2 = Find_Nearest(intro_cis_ship_3_marker, p_cis, true)
		player_munificent_2.Teleport_And_Face(intro_cis_ship_3_marker)
		player_munificent_2.Cinematic_Hyperspace_In(50)
	end

	Start_Cinematic_Camera()
	Stop_All_Music()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()

	Fade_On()
	Sleep(0.5)

	cinematic_one = true

	Play_Music("Kuat_Kickoff_01")
	Fade_Screen_In(5)
	Letter_Box_In(3)

	Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 8.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 8.5, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Story_Event("PRODUCT_PLACEMENT_01")
	Sleep(6.5)

	Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_4_marker, 14.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_4_marker, 14.0, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Story_Event("PRODUCT_PLACEMENT_02")
	Story_Event("PRODUCT_PLACEMENT_03")
	Sleep(14.0)

	Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_5_marker, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_6_marker, 13.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_6_marker, 13.0, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Story_Event("PRODUCT_PLACEMENT_04")
	Story_Event("PRODUCT_PLACEMENT_05")
	Sleep(13.0)

	Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_8_marker, 13.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_8_marker, 13.0, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Story_Event("PRODUCT_PLACEMENT_06")
	Story_Event("PRODUCT_PLACEMENT_07")
	Sleep(13.0)

	Set_Cinematic_Camera_Key(introcam_9_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_9_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_10_marker, 11.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_10_marker, 11.0, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Story_Event("PRODUCT_PLACEMENT_08")
	Story_Event("PRODUCT_PLACEMENT_09")
	Sleep(11.0)

	Set_Cinematic_Camera_Key(introcam_11_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_11_marker, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_12_marker, 11.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_12_marker, 11.0, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Story_Event("PRODUCT_PLACEMENT_10")
	Story_Event("PRODUCT_PLACEMENT_11")
	Sleep(12.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end

function End_Cinematic_Intro_CIS()
	Point_Camera_At(intro_cis_ship_1_marker)
	Transition_To_Tactical_Camera(4)
	Letter_Box_Out(4)
	Sleep(4.0)
	Resume_Mode_Based_Music()
	End_Cinematic_Camera()
	Lock_Controls(0)
	Suspend_AI(0)

	cinematic_one = false
	act_1_active = true

	p_republic.Make_Enemy(p_cis)
	p_cis.Make_Enemy(p_republic)

	Story_Event("GOAL_TRIGGER_CIS_I")
	Story_Event("ACTIVATE_REP_AI")

	if (GlobalValue.Get("ODL_CIS_Shipyard_Struggle_Outcome") == 0) then
		Register_Timer(State_Firework_Activated, 15)
	else
		container_list = Find_All_Objects_Of_Type("ORBITAL_RESOURCE_CONTAINER")
		for k,player_container in pairs(container_list) do
			if TestValid(player_container) then
				player_container.Despawn()
			end
		end
	end
end