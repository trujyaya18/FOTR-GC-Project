
--*****************************************************--
--******* Outer Rim Sieges: Breaking Belderone ********--
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
		Trigger_Allow_Retreat = State_Allow_Retreat,
	}

	convoy_list = {
		"SUPER_TRANSPORT_XI_CONVOY",
		"SUPER_TRANSPORT_XI_CONVOY",
		"SUPER_TRANSPORT_XI_CONVOY",
		"SUPER_TRANSPORT_XI_CONVOY",
		"SUPER_TRANSPORT_XI_CONVOY",
		"SUPER_TRANSPORT_XI_CONVOY",
	}

	republic_fleet_01_list = {
		"Generic_Victory_Destroyer",
		"Dreadnaught_Lasers",
		"Customs_Corvette",
		"Corellian_Corvette",
		"Corellian_Gunboat",
		"Corellian_Gunboat",
		"Arquitens",
	}

	republic_fleet_02_list = {
		"Generic_Venator",
		"Dreadnaught_Lasers",
		"Dreadnaught_Lasers",
		"Customs_Corvette",
		"Corellian_Corvette",
		"Corellian_Gunboat",
		"Arquitens",
	}

	republic_fleet_03_list = {
		"Generic_Victory_Destroyer",
		"Dreadnaught_Lasers",
		"Customs_Corvette",
		"Corellian_Corvette",
		"Corellian_Gunboat",
		"Arquitens",
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")

	cinematic_one = false

	cinematic_one_skipped = false

	act_1_active = false

	grievous_soulless_one_active = false
	grievous_renitor_active = false
	grievous_munificent_active = false
	grievous_invisible_hand_active = false
	grievous_malevolence_active = false

	current_convoy_amount = 6
	max_amount_destroyed = false

	current_cinematic_thread_id = nil

	mission_started = false
end

function Begin_Battle(message)
	if message == OnEnter then
		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-4")
		introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-5")
		introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-6")
		introcam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-7")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")
		introcam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")
		introcam_target_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-4")

		rep_fleet_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-1")
		rep_fleet_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-2")
		rep_fleet_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-3")

		convoy_entry_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "convoy-entry")
		extraction_point_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "extraction-point")
		grievous_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "grievous")
		hero_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "hero")

		cis_fleet_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-fleet-1")
		cis_fleet_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-fleet-2")
		cis_fleet_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-fleet-3")
		cis_fleet_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-fleet-4")
		cis_fleet_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-fleet-5")
		cis_fleet_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-fleet-6")
		cis_fleet_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-fleet-7")
		cis_fleet_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-fleet-8")

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

		cis_heroes = Find_All_Objects_Of_Type(p_cis, "SpaceHero")
		for _,cis_hero in pairs(cis_heroes) do
			if TestValid(cis_hero) then
				cis_hero.Teleport_And_Face(hero_marker)
			end
		end

		mission_started = true
		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
		end
	end
end


function State_Allow_Retreat(message)
	if message == OnEnter then
		Story_Event("TRAPPED_05")
		Story_Event("COMMENCE_RETREAT")
	end
end


function State_Extraction_Reached(prox_obj, trigger_obj)
	if trigger_obj == extraction_point_marker then
		prox_obj.Hyperspace_Away(true)
		current_convoy_amount = current_convoy_amount - 1
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

					Allow_Localized_SFX(true)
					SFXManager.Allow_HUD_VO(true)
					SFXManager.Allow_Ambient_VO(true)
					SFXManager.Allow_Enemy_Sighted_VO(true)
					SFXManager.Allow_Unit_Reponse_VO(true)
					Resume_Mode_Based_Music()

					p_republic.Make_Enemy(p_cis)
					p_cis.Make_Enemy(p_republic)

					if p_republic.Get_Difficulty()== "Easy" then
						AI_Republic_01_Fleet = SpawnList(republic_fleet_01_list, rep_fleet_1_marker.Get_Position(), p_republic, true, true)
						Republic_AI_Fleet_01 = AI_Republic_01_Fleet[1]
						Republic_AI_Fleet_01.Teleport_And_Face(rep_fleet_1_marker)
					elseif p_republic.Get_Difficulty()== "Hard" then
						AI_Republic_01_Fleet = SpawnList(republic_fleet_02_list, rep_fleet_1_marker.Get_Position(), p_republic, true, true)
						Republic_AI_Fleet_01 = AI_Republic_01_Fleet[1]
						Republic_AI_Fleet_01.Teleport_And_Face(rep_fleet_1_marker)

						AI_Republic_03_Fleet = SpawnList(republic_fleet_03_list, rep_fleet_3_marker.Get_Position(), p_republic, true, true)
						Republic_AI_Fleet_03 = AI_Republic_03_Fleet[1]
						Republic_AI_Fleet_03.Teleport_And_Face(rep_fleet_3_marker)
					else
						AI_Republic_01_Fleet = SpawnList(republic_fleet_01_list, rep_fleet_1_marker.Get_Position(), p_republic, true, true)
						Republic_AI_Fleet_01 = AI_Republic_01_Fleet[1]
						Republic_AI_Fleet_01.Teleport_And_Face(rep_fleet_1_marker)

						AI_Republic_03_Fleet = SpawnList(republic_fleet_03_list, rep_fleet_3_marker.Get_Position(), p_republic, true, true)
						Republic_AI_Fleet_03 = AI_Republic_03_Fleet[1]
						Republic_AI_Fleet_03.Teleport_And_Face(rep_fleet_3_marker)
					end

					convoy_ships = Find_All_Objects_Of_Type("SUPER_TRANSPORT_XI_CONVOY")
					for _,convoy_ship in pairs(convoy_ships) do
						if TestValid(convoy_ship) then
							convoy_ship.Move_To(extraction_point_marker)
							convoy_ship.Prevent_AI_Usage(true)
							Register_Prox(convoy_ship, State_Extraction_Reached, 200, p_republic)
						end
					end

					Letter_Box_Out(0)
					Lock_Controls(0)
					Suspend_AI(0)
					End_Cinematic_Camera()

					Story_Event("ACTIVATE_REP_AI")

					Story_Event("GOAL_TRIGGER_CIS_I")
					Story_Event("TRAPPED_04")

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
			if current_convoy_amount < 6 and not max_amount_destroyed then
				local player_new_convoy = Spawn_Unit(Find_Object_Type("SUPER_TRANSPORT_XI_CONVOY"), convoy_entry_marker, p_republic)
				player_new_convoy = Find_Nearest(convoy_entry_marker, p_republic, true)
				player_new_convoy.Teleport_And_Face(convoy_entry_marker)
				player_new_convoy.Cinematic_Hyperspace_In(GameRandom.Free_Random(10, 1000))
				player_new_convoy.Move_To(extraction_point_marker)
				player_new_convoy.Prevent_AI_Usage(true)

				current_convoy_amount = current_convoy_amount + 1
			end
		end
	elseif p_republic.Is_Human() then
	end
end


function Start_Cinematic_Intro_CIS()
	AI_Republic_02_Fleet = SpawnList(republic_fleet_02_list, rep_fleet_2_marker.Get_Position(), p_republic, true, true)
	Republic_AI_Fleet_02 = AI_Republic_02_Fleet[1]
	Republic_AI_Fleet_02.Teleport_And_Face(rep_fleet_2_marker)

	Convoy_Fleet = SpawnList(convoy_list, convoy_entry_marker.Get_Position(), p_republic, false, false)
	Republic_Convoy_Fleet = Convoy_Fleet[1]
	Republic_Convoy_Fleet.Teleport_And_Face(convoy_entry_marker)

	Spawn_From_Reinforcement_Pool(Find_Object_Type("Munificent"), cis_fleet_1_marker, p_cis)
	Spawn_From_Reinforcement_Pool(Find_Object_Type("Munificent"), cis_fleet_2_marker, p_cis)
	Spawn_From_Reinforcement_Pool(Find_Object_Type("Munificent"), cis_fleet_3_marker, p_cis)
	Spawn_From_Reinforcement_Pool(Find_Object_Type("Munificent"), cis_fleet_4_marker, p_cis)
	Spawn_From_Reinforcement_Pool(Find_Object_Type("Munificent"), cis_fleet_5_marker, p_cis)

	Spawn_From_Reinforcement_Pool(Find_Object_Type("Lucrehulk_Core_Destroyer"), cis_fleet_4_marker, p_cis)
	Spawn_From_Reinforcement_Pool(Find_Object_Type("Lucrehulk_Core_Destroyer"), cis_fleet_5_marker, p_cis)

	Spawn_From_Reinforcement_Pool(Find_Object_Type("Recusant"), cis_fleet_8_marker, p_cis)
	Spawn_From_Reinforcement_Pool(Find_Object_Type("Recusant"), cis_fleet_7_marker, p_cis)
	Spawn_From_Reinforcement_Pool(Find_Object_Type("Recusant"), cis_fleet_6_marker, p_cis)
	Spawn_From_Reinforcement_Pool(Find_Object_Type("Recusant"), cis_fleet_5_marker, p_cis)
	Spawn_From_Reinforcement_Pool(Find_Object_Type("Recusant"), cis_fleet_4_marker, p_cis)

	Start_Cinematic_Camera()
	Stop_All_Music()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()

	Fade_On()
	Sleep(1.0)

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
						Grievous_Spawning = Spawn_From_Reinforcement_Pool(Find_Object_Type("Grievous_Team"), grievous_marker, p_cis)
						if Grievous_Spawning then
							Grievous_Spawning = Grievous_Spawning[1]
							player_invisible_hand = Spawn_Unit(Find_Object_Type("Invisible_Hand"), grievous_marker, p_cis)
							player_invisible_hand = Find_Nearest(grievous_marker, p_cis, true)
							player_invisible_hand.Teleport_And_Face(grievous_marker)	
							player_invisible_hand.Cinematic_Hyperspace_In(50)
							grievous_invisible_hand_active = true
						end
					end
					if not TestValid(Grievous_Spawning) then
						Grievous_Spawning = Spawn_From_Reinforcement_Pool(Find_Object_Type("Grievous_Team_Recusant"), grievous_marker, p_cis)
						if Grievous_Spawning then
							Grievous_Spawning = Grievous_Spawning[1]
							player_renitor = Spawn_Unit(Find_Object_Type("Grievous_Recusant"), grievous_marker, p_cis)
							player_renitor = Find_Nearest(grievous_marker, p_cis, true)
							player_renitor.Teleport_And_Face(grievous_marker)	
							player_renitor.Cinematic_Hyperspace_In(50)
							grievous_renitor_active = true
						end
					end
					if not TestValid(Grievous_Spawning) then
						Grievous_Spawning = Spawn_From_Reinforcement_Pool(Find_Object_Type("Grievous_Team_Munificent"), grievous_marker, p_cis)
						if Grievous_Spawning then
							Grievous_Spawning = Grievous_Spawning[1]
							player_grievous_munificent = Spawn_Unit(Find_Object_Type("Grievous_Munificent"), grievous_marker, p_cis)
							player_grievous_munificent = Find_Nearest(grievous_marker, p_cis, true)
							player_grievous_munificent.Teleport_And_Face(grievous_marker)	
							player_grievous_munificent.Cinematic_Hyperspace_In(50)
							grievous_munificent_active = true
						end
					end
					if not TestValid(Grievous_Spawning) then
						Grievous_Spawning = Spawn_From_Reinforcement_Pool(Find_Object_Type("Grievous_Team_Malevolence"), grievous_marker, p_cis)
						if Grievous_Spawning then
							Grievous_Spawning = Grievous_Spawning[1]
							player_malevolence = Spawn_Unit(Find_Object_Type("Grievous_Malevolence"), grievous_marker, p_cis)
							player_malevolence = Find_Nearest(grievous_marker, p_cis, true)
							player_malevolence.Teleport_And_Face(grievous_marker)	
							player_malevolence.Cinematic_Hyperspace_In(50)
							grievous_malevolence_active = true
						end
					end
					if not TestValid(Grievous_Spawning) then
						Grievous_Spawning = Spawn_From_Reinforcement_Pool(Find_Object_Type("Grievous_Team_Soulless_One"), grievous_marker, p_cis)
						if Grievous_Spawning then
							Grievous_Spawning = Grievous_Spawning[1]
							player_soulless_one = Spawn_Unit(Find_Object_Type("Soulless_One_Squadron"), grievous_marker, p_cis)
							player_soulless_one = Find_Nearest(grievous_marker, p_cis, true)
							player_soulless_one.Teleport_And_Face(grievous_marker)	
							player_soulless_one.Cinematic_Hyperspace_In(50)
							grievous_soulless_one_active = true
						end
					end
				end
			end
		end
	end

	cinematic_one = true
	Play_Music("Breaking_Belderone_01")
	Sleep(1.5)

	Fade_Screen_In(6)
	Letter_Box_In(6)

	Story_Event("TRAPPED_01")
	Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 9.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 9.5, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Sleep(10.0)

	convoy_ships = Find_All_Objects_Of_Type("SUPER_TRANSPORT_XI_CONVOY")
	for _,convoy_ship in pairs(convoy_ships) do
		if TestValid(convoy_ship) then
			convoy_ship.Move_To(extraction_point_marker)
			convoy_ship.Prevent_AI_Usage(true)
			Register_Prox(convoy_ship, State_Extraction_Reached, 200, p_republic)
		end
	end

	Story_Event("TRAPPED_02")
	Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, convoy_entry_marker, 1, 0)
	Cinematic_Zoom(4.5, 0.4)
	Sleep(4.5)

	Set_Cinematic_Camera_Key(introcam_4_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_4_marker, 0, 0, 0, 0, convoy_entry_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_5_marker, 7.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_5_marker, 7.5, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Sleep(5.0)

	Story_Event("TRAPPED_03")
	Sleep(2.5)

	Set_Cinematic_Camera_Key(introcam_6_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_6_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_7_marker, 7, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_7_marker, 7, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
	Sleep(7.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end

function End_Cinematic_Intro_CIS()
	Point_Camera_At(grievous_marker)
	Transition_To_Tactical_Camera(3)
	Letter_Box_Out(3)
	Sleep(3.0)
	End_Cinematic_Camera()
	Lock_Controls(0)
	Suspend_AI(0)

	Story_Event("TRAPPED_04")

	if p_republic.Get_Difficulty()== "Easy" then
		AI_Republic_01_Fleet = SpawnList(republic_fleet_01_list, rep_fleet_1_marker.Get_Position(), p_republic, true, true)
		Republic_AI_Fleet_01 = AI_Republic_01_Fleet[1]
		Republic_AI_Fleet_01.Teleport_And_Face(rep_fleet_1_marker)
	elseif p_republic.Get_Difficulty()== "Hard" then
		AI_Republic_01_Fleet = SpawnList(republic_fleet_02_list, rep_fleet_1_marker.Get_Position(), p_republic, true, true)
		Republic_AI_Fleet_01 = AI_Republic_01_Fleet[1]
		Republic_AI_Fleet_01.Teleport_And_Face(rep_fleet_1_marker)

		AI_Republic_03_Fleet = SpawnList(republic_fleet_03_list, rep_fleet_3_marker.Get_Position(), p_republic, true, true)
		Republic_AI_Fleet_03 = AI_Republic_03_Fleet[1]
		Republic_AI_Fleet_03.Teleport_And_Face(rep_fleet_3_marker)
	else
		AI_Republic_01_Fleet = SpawnList(republic_fleet_01_list, rep_fleet_1_marker.Get_Position(), p_republic, true, true)
		Republic_AI_Fleet_01 = AI_Republic_01_Fleet[1]
		Republic_AI_Fleet_01.Teleport_And_Face(rep_fleet_1_marker)

		AI_Republic_03_Fleet = SpawnList(republic_fleet_03_list, rep_fleet_3_marker.Get_Position(), p_republic, true, true)
		Republic_AI_Fleet_03 = AI_Republic_03_Fleet[1]
		Republic_AI_Fleet_03.Teleport_And_Face(rep_fleet_3_marker)
	end

	p_cis.Make_Enemy(p_republic)
	p_republic.Make_Enemy(p_cis)

	Story_Event("GOAL_TRIGGER_CIS_I")
	Story_Event("ACTIVATE_REP_AI")

	cinematic_one = false
	act_1_active = true

	Resume_Mode_Based_Music()
end
