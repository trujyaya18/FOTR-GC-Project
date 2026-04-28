
--*****************************************************--
--******* Operation Durge's Lance: Duro Defence *******--
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
		Trigger_Commence_Boarding = State_Commence_Boarding,
		Trigger_Commence_Defence = State_Commence_Defence,
	}

	republic_defender_list = {
		"Generic_Acclamator_Assault_Ship_I",
		"Generic_Acclamator_Assault_Ship_I",
		"Generic_Acclamator_Assault_Ship_I",
		"Generic_Acclamator_Assault_Ship_Leveler",
		"Generic_Acclamator_Assault_Ship_Leveler",
		"Generic_Acclamator_Assault_Ship_Leveler",
		"Generic_Acclamator_Assault_Ship_Leveler",
		"Dreadnaught_Lasers",
		"Dreadnaught_Lasers",
		"Dreadnaught_Lasers",
	}

	republic_avenger_medium_list = {
		"Generic_Venator",
		"Generic_Venator",
		"Captor",
		"Captor",
		"Dreadnaught_Lasers",
		"Dreadnaught_Lasers",
		"LAC",
		"LAC",
		"Corellian_Corvette",
		"Corellian_Corvette",
		"Arquitens",
		"Arquitens",
	}

	republic_avenger_hard_list = {
		"Generic_Venator",
		"Generic_Victory_Destroyer",
		"Generic_Victory_Destroyer",
		"Captor",
		"Captor",
		"Captor",
		"Dreadnaught_Lasers",
		"Dreadnaught_Lasers",
		"LAC",
		"LAC",
		"LAC",
		"LAC",
		"Corellian_Corvette",
		"Corellian_Corvette",
		"Arquitens",
		"Arquitens",
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")

	cinematic_one = false
	cinematic_two = false

	cinematic_one_skipped = false
	cinematic_two_skipped = false

	act_1_active = false
	act_2_active = false

	grievous_soulless_one_active = false
	grievous_renitor_active = false
	grievous_munificent_active = false
	grievous_invisible_hand_active = false
	grievous_malevolence_active = false

	honest_news_report = false
	interview_news_report = false
	propaganda_news_report = false

	station_jivv_disabled = false
	station_jyvus_disabled = false
	station_orr_om_disabled = false
	station_bburru_disabled = false
	station_urrdorf_disabled = false
	station_rrudobar_disabled = false
	station_kri_larun_disabled = false
	station_new_tayana_disabled = false

	defence_fleet_killed = false
	avenger_fleet_arrived = false

	conquered_station_amount = 0

	current_cinematic_thread_id = nil

	camera_offset = 125
	mission_started = false

end

function Begin_Battle(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-1")
			rep_fleet_02_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-2")
			rep_fleet_03_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-3")
			rep_fleet_04_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-4")
			rep_fleet_05_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-5")

			intro_cis_ship_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cis-ship-1")
			intro_cis_ship_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cis-ship-2")

			invisible_hand_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "ih")
			introcam_target_invisible_hand_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget-invisible-hand")
			munificent_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "munificent")
			introcam_target_munificent_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget-munificent")
			renitor_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "renitor")
			introcam_target_renitor_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget-renitor")

			introcam_target_victory_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget-victory")
			introcam_target_station_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget-station")

			introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam1")
			introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam2")
			introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam3")
			introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam4")
			introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam5a")
			introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam6")
			introcam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam7")
			introcam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam8")
			introcam_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam9")
			introcam_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam10")
			introcam_11_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam11")
			introcam_12_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam12")
			introcam_13_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam13")
			introcam_14_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam14")

			introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget1")

			outro_cis_ship_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cis-ship-1")
			outro_cis_ship_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cis-ship-2")
			outro_cis_ship_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cis-ship-3")
			outro_cis_ship_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cis-ship-4")
			outro_cis_ship_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cis-ship-5")

			outro_cis_ships_move_to_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cis-ships-move-to")

			outrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam1")
			outrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam2")

			station_kri_larun = Find_First_Object("KRI_LARUN")
			station_kri_larun.Set_Cannot_Be_Killed(true)

			station_urrdorf_city = Find_First_Object("URRDORF_CITY")
			station_urrdorf_city.Set_Cannot_Be_Killed(true)

			station_rrudobar = Find_First_Object("RRUDOBAR")
			station_rrudobar.Set_Cannot_Be_Killed(true)

			station_jyvus_space_city = Find_First_Object("JYVUS_SPACE_CITY")
			station_jyvus_space_city.Set_Cannot_Be_Killed(true)

			station_bburru_station = Find_First_Object("BBURRU_STATION")
			station_bburru_station.Set_Cannot_Be_Killed(true)

			station_jivv_space_city = Find_First_Object("JIVV_SPACE_CITY")
			station_jivv_space_city.Set_Cannot_Be_Killed(true)

			station_new_tayana = Find_First_Object("NEW_TAYANA")
			station_new_tayana.Set_Cannot_Be_Killed(true)

			station_orr_om = Find_First_Object("ORR_OM")
			station_orr_om.Set_Cannot_Be_Killed(true)

			player_victory = Find_Hint("GENERIC_VICTORY_DESTROYER", "victory")

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

			p_invaders.Make_Ally(p_republic)
			p_republic.Make_Ally(p_invaders)

			p_cis.Make_Ally(p_republic)
			p_republic.Make_Ally(p_cis)

			p_invaders.Make_Ally(p_cis)
			p_cis.Make_Ally(p_invaders)

			mission_started = true
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
		elseif p_republic.Is_Human() then
			rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "ai-rep-fleet")

			intro_cis_ship_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cis-ship-1")
			intro_cis_ship_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cis-ship-2")

			invisible_hand_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "ih")
			introcam_target_invisible_hand_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget-invisible-hand")
			munificent_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "munificent")
			introcam_target_munificent_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget-munificent")
			renitor_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "renitor")
			introcam_target_renitor_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget-renitor")

			introcam_target_victory_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget-victory")
			introcam_target_station_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget-station")

			introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam1")
			introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam2")
			introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam3")
			introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam4")
			introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam5a")
			introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam6")
			introcam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam7")
			introcam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam8")
			introcam_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam9")
			introcam_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam10")
			introcam_11_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam11")
			introcam_12_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam12")
			introcam_13_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam13")
			introcam_14_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam14")

			introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget1")

			outro_cis_ship_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cis-ship-1")
			outro_cis_ship_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cis-ship-2")
			outro_cis_ship_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cis-ship-3")
			outro_cis_ship_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cis-ship-4")
			outro_cis_ship_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cis-ship-5")

			outro_cis_ships_move_to_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cis-ships-move-to")

			outrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam1")
			outrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam2")

			station_kri_larun = Find_First_Object("KRI_LARUN")
			station_kri_larun.Set_Cannot_Be_Killed(true)

			station_urrdorf_city = Find_First_Object("URRDORF_CITY")
			station_urrdorf_city.Set_Cannot_Be_Killed(true)

			station_rrudobar = Find_First_Object("RRUDOBAR")
			station_rrudobar.Set_Cannot_Be_Killed(true)

			station_jyvus_space_city = Find_First_Object("JYVUS_SPACE_CITY")
			station_jyvus_space_city.Set_Cannot_Be_Killed(true)

			station_bburru_station = Find_First_Object("BBURRU_STATION")
			station_bburru_station.Set_Cannot_Be_Killed(true)

			station_jivv_space_city = Find_First_Object("JIVV_SPACE_CITY")
			station_jivv_space_city.Set_Cannot_Be_Killed(true)

			station_new_tayana = Find_First_Object("NEW_TAYANA")
			station_new_tayana.Set_Cannot_Be_Killed(true)

			station_orr_om = Find_First_Object("ORR_OM")
			station_orr_om.Set_Cannot_Be_Killed(true)

			player_victory = Find_Hint("GENERIC_VICTORY_DESTROYER", "victory")

			p_invaders.Make_Ally(p_republic)
			p_republic.Make_Ally(p_invaders)

			p_cis.Make_Ally(p_republic)
			p_republic.Make_Ally(p_cis)

			p_invaders.Make_Ally(p_cis)
			p_cis.Make_Ally(p_invaders)

			mission_started = true
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
		end
	end
end


function State_Avenger_Fleet_Arrives()
	if not avenger_fleet_arrived then
		avenger_fleet_arrived = true
		if p_republic.Get_Difficulty()== "Easy" then

		elseif p_republic.Get_Difficulty()== "Hard" then
			local entry_gamble = GameRandom.Free_Random(1, 5)
			if entry_gamble == 1 then
				rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-1")
			elseif entry_gamble == 2 then
				rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-2")
			elseif entry_gamble == 3 then
				rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-3")
			elseif entry_gamble == 4 then
				rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-4")
			elseif entry_gamble == 5 then
				rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-5")
			end

			AI_Republic_Fleet = SpawnList(republic_avenger_hard_list, rep_fleet_01_marker.Get_Position(), p_republic, true, true)
			Republic_AI_Fleet = AI_Republic_Fleet[1]
			Republic_AI_Fleet.Teleport_And_Face(rep_fleet_01_marker)
			Republic_AI_Fleet.Cinematic_Hyperspace_In(150)

		else
			AI_Republic_Fleet = SpawnList(republic_avenger_medium_list, rep_fleet_01_marker.Get_Position(), p_republic, true, true)
			Republic_AI_Fleet = AI_Republic_Fleet[1]
			Republic_AI_Fleet.Teleport_And_Face(rep_fleet_01_marker)
			Republic_AI_Fleet.Cinematic_Hyperspace_In(150)
		end
		Story_Event("NOT_GIVING_UP_02")
	end
end

function State_Commence_Boarding(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")
		end
	end
end

function State_Commence_Defence(message)
	if message == OnEnter then
		if p_republic.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
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

				Allow_Localized_SFX(true)
				SFXManager.Allow_HUD_VO(true)
				SFXManager.Allow_Ambient_VO(true)
				SFXManager.Allow_Enemy_Sighted_VO(true)
				SFXManager.Allow_Unit_Reponse_VO(true)
				Resume_Mode_Based_Music()

				if not TestValid(player_munificent_1) then
					player_munificent_1 = Spawn_Unit(Find_Object_Type("Munificent"), intro_cis_ship_1_marker, p_cis)
					player_munificent_1 = Find_Nearest(intro_cis_ship_1_marker, p_cis, true)
					player_munificent_1.Teleport_And_Face(intro_cis_ship_1_marker)
					player_munificent_1.Cinematic_Hyperspace_In(50)
				end

				if not TestValid(player_munificent_2) then
					player_munificent_2 = Spawn_Unit(Find_Object_Type("Munificent"), intro_cis_ship_2_marker, p_cis)
					player_munificent_2 = Find_Nearest(intro_cis_ship_2_marker, p_cis, true)
					player_munificent_2.Teleport_And_Face(intro_cis_ship_2_marker)
					player_munificent_2.Cinematic_Hyperspace_In(50)
				end

				if p_republic.Get_Difficulty()== "Easy" then
				elseif p_republic.Get_Difficulty()== "Hard" then
					Register_Timer(State_Avenger_Fleet_Arrives, 150)
				else
					Register_Timer(State_Avenger_Fleet_Arrives, 240)
				end

				p_republic.Make_Enemy(p_cis)
				p_cis.Make_Enemy(p_republic)

				Letter_Box_Out(0)
				Lock_Controls(0)
				Suspend_AI(0)
				End_Cinematic_Camera()

				Story_Event("ACTIVATE_REP_AI")

				Story_Event("GOAL_TRIGGER_CIS_I")
				Story_Event("NEWS_REPORT_13")

					--Story_Event("COMMENCE_DEFENCE")
					--Story_Event("CIS_VICTORY")

				cinematic_one = false
				act_1_active = true

				Fade_Screen_In(0.5)
				Sleep(0.5)

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

				Allow_Localized_SFX(true)
				SFXManager.Allow_HUD_VO(true)
				SFXManager.Allow_Ambient_VO(true)
				SFXManager.Allow_Enemy_Sighted_VO(true)
				SFXManager.Allow_Unit_Reponse_VO(true)
				Resume_Mode_Based_Music()

				if not TestValid(player_munificent_1) then
					player_munificent_1 = Spawn_Unit(Find_Object_Type("Munificent"), intro_cis_ship_1_marker, p_cis)
					player_munificent_1 = Find_Nearest(intro_cis_ship_1_marker, p_cis, true)
					player_munificent_1.Teleport_And_Face(intro_cis_ship_1_marker)
					player_munificent_1.Cinematic_Hyperspace_In(50)
				end

				if not TestValid(player_munificent_2) then
					player_munificent_2 = Spawn_Unit(Find_Object_Type("Munificent"), intro_cis_ship_2_marker, p_cis)
					player_munificent_2 = Find_Nearest(intro_cis_ship_2_marker, p_cis, true)
					player_munificent_2.Teleport_And_Face(intro_cis_ship_2_marker)
					player_munificent_2.Cinematic_Hyperspace_In(50)
				end

				Reinforce_Unit(Find_Object_Type("GENERIC_PROVIDENCE"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("GENERIC_PROVIDENCE"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("GENERIC_PROVIDENCE"), false, p_cis, true, false)

				Reinforce_Unit(Find_Object_Type("BATTLESHIP_LUCREHULK"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("BATTLESHIP_LUCREHULK"), false, p_cis, true, false)

				Reinforce_Unit(Find_Object_Type("AUXILIARY_LUCREHULK"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("AUXILIARY_LUCREHULK"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("AUXILIARY_LUCREHULK"), false, p_cis, true, false)

				Reinforce_Unit(Find_Object_Type("GENERIC_LUCREHULK"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("GENERIC_LUCREHULK"), false, p_cis, true, false)

				Reinforce_Unit(Find_Object_Type("CIS_DREADNAUGHT"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("CIS_DREADNAUGHT"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("CIS_DREADNAUGHT"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("CIS_DREADNAUGHT"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("CIS_DREADNAUGHT"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("CIS_DREADNAUGHT"), false, p_cis, true, false)

				Reinforce_Unit(Find_Object_Type("CAPTOR"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("CAPTOR"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("CAPTOR"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("CAPTOR"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("CAPTOR"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("CAPTOR"), false, p_cis, true, false)

				Reinforce_Unit(Find_Object_Type("DIAMOND_FRIGATE"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("DIAMOND_FRIGATE"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("DIAMOND_FRIGATE"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("DIAMOND_FRIGATE"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("DIAMOND_FRIGATE"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("DIAMOND_FRIGATE"), false, p_cis, true, false)

				Reinforce_Unit(Find_Object_Type("GEONOSIAN_CRUISER"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("GEONOSIAN_CRUISER"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("GEONOSIAN_CRUISER"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("GEONOSIAN_CRUISER"), false, p_cis, true, false)

				Reinforce_Unit(Find_Object_Type("LUCREHULK_CORE_DESTROYER"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("LUCREHULK_CORE_DESTROYER"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("LUCREHULK_CORE_DESTROYER"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("LUCREHULK_CORE_DESTROYER"), false, p_cis, true, false)

				Reinforce_Unit(Find_Object_Type("MUNIFICENT"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("MUNIFICENT"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("MUNIFICENT"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("MUNIFICENT"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("MUNIFICENT"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("MUNIFICENT"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("MUNIFICENT"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("MUNIFICENT"), false, p_cis, true, false)

				Reinforce_Unit(Find_Object_Type("RECUSANT"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("RECUSANT"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("RECUSANT"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("RECUSANT"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("RECUSANT"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("RECUSANT"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("RECUSANT"), false, p_cis, true, false)
				Reinforce_Unit(Find_Object_Type("RECUSANT"), false, p_cis, true, false)


				Reinforce_Unit(Find_Object_Type("GENERIC_ACCLAMATOR_ASSAULT_SHIP_I"), false, p_republic, true, false)
				Reinforce_Unit(Find_Object_Type("GENERIC_ACCLAMATOR_ASSAULT_SHIP_I"), false, p_republic, true, false)
				Reinforce_Unit(Find_Object_Type("GENERIC_ACCLAMATOR_ASSAULT_SHIP_I"), false, p_republic, true, false)
				Reinforce_Unit(Find_Object_Type("GENERIC_ACCLAMATOR_ASSAULT_SHIP_I"), false, p_republic, true, false)

				Reinforce_Unit(Find_Object_Type("GENERIC_ACCLAMATOR_ASSAULT_SHIP_LEVELER"), false, p_republic, true, false)
				Reinforce_Unit(Find_Object_Type("GENERIC_ACCLAMATOR_ASSAULT_SHIP_LEVELER"), false, p_republic, true, false)
				Reinforce_Unit(Find_Object_Type("GENERIC_ACCLAMATOR_ASSAULT_SHIP_LEVELER"), false, p_republic, true, false)

				Reinforce_Unit(Find_Object_Type("DREADNAUGHT_LASERS"), false, p_republic, true, false)
				Reinforce_Unit(Find_Object_Type("DREADNAUGHT_LASERS"), false, p_republic, true, false)
				Reinforce_Unit(Find_Object_Type("DREADNAUGHT_LASERS"), false, p_republic, true, false)


				p_republic.Make_Enemy(p_cis)
				p_cis.Make_Enemy(p_republic)

				Letter_Box_Out(0)
				Lock_Controls(0)
				Suspend_AI(0)
				End_Cinematic_Camera()

				Story_Event("ACTIVATE_CIS_AI")

				Story_Event("GOAL_TRIGGER_REP_I")
				Story_Event("NEWS_REPORT_13_ALT")

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
			if not station_jyvus_disabled then
				if Find_First_Object("JYVUS_SPACE_CITY").Get_Hull() <= 0.10 then
					station_jyvus_disabled = true
					Find_First_Object("JYVUS_SPACE_CITY").Change_Owner(p_invaders)
					conquered_station_amount = conquered_station_amount + 1
					if not defence_fleet_killed then
						Story_Event("CLEAN_UP_01")
					end
				end
			end
			if not station_jivv_disabled then
				if Find_First_Object("JIVV_SPACE_CITY").Get_Hull() <= 0.10 then
					station_jivv_disabled = true
					Find_First_Object("JIVV_SPACE_CITY").Change_Owner(p_cis)
					conquered_station_amount = conquered_station_amount + 1
				end
			end
			if not station_rrudobar_disabled then
				if Find_First_Object("RRUDOBAR").Get_Hull() <= 0.10 then
					station_rrudobar_disabled = true
					Find_First_Object("RRUDOBAR").Change_Owner(p_cis)
					conquered_station_amount = conquered_station_amount + 1
				end
			end
			if not station_urrdorf_disabled then
				if Find_First_Object("URRDORF_CITY").Get_Hull() <= 0.10 then
					station_urrdorf_disabled = true
					Find_First_Object("URRDORF_CITY").Change_Owner(p_cis)
					conquered_station_amount = conquered_station_amount + 1
				end
			end
			if not station_orr_om_disabled then
				if Find_First_Object("ORR_OM").Get_Hull() <= 0.10 then
					station_urrdorf_disabled = true
					Find_First_Object("ORR_OM").Change_Owner(p_cis)
					conquered_station_amount = conquered_station_amount + 1
				end
			end
			if not station_bburru_disabled then
				if Find_First_Object("BBURRU_STATION").Get_Hull() <= 0.10 then
					station_bburru_disabled = true
					Find_First_Object("BBURRU_STATION").Change_Owner(p_cis)
					conquered_station_amount = conquered_station_amount + 1
				end
			end
			if not station_kri_larun_disabled then
				if Find_First_Object("KRI_LARUN").Get_Hull() <= 0.10 then
					station_kri_larun_disabled = true
					Find_First_Object("KRI_LARUN").Change_Owner(p_cis)
					conquered_station_amount = conquered_station_amount + 1
				end
			end
			if not station_new_tayana_disabled then
				if Find_First_Object("NEW_TAYANA").Get_Hull() <= 0.10 then
					station_new_tayana_disabled = true
					Find_First_Object("NEW_TAYANA").Change_Owner(p_cis)
					conquered_station_amount = conquered_station_amount + 1
				end
			end
			if not defence_fleet_killed then
				rep_list = Find_All_Objects_Of_Type(p_republic, "SpaceHero | Corvette | Capital | Frigate | SuperCapital")
				if (table.getn(rep_list) == 0) then
					defence_fleet_killed = true
				end
			end
			if not act_2_active then
				if station_jyvus_disabled and defence_fleet_killed then
					Story_Event("COMMENCE_BOARDING")
					act_1_active = false
					act_2_active = true
				end
			end
			cis_list = Find_All_Objects_Of_Type(p_cis, "SpaceHero | Corvette | Capital | Frigate | SuperCapital")
			if (table.getn(cis_list) == 0) then
				Story_Event("REPUBLIC_VICTORY")
			end
			if (conquered_station_amount > 4) and not avenger_fleet_arrived then
				avenger_fleet_arrived = true
				if p_republic.Get_Difficulty()== "Easy" then
				elseif p_republic.Get_Difficulty()== "Hard" then

					local entry_gamble = GameRandom.Free_Random(1, 5)
					if entry_gamble == 1 then
						rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-1")
					elseif entry_gamble == 2 then
						rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-2")
					elseif entry_gamble == 3 then
						rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-3")
					elseif entry_gamble == 4 then
						rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-4")
					elseif entry_gamble == 5 then
						rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-5")
					end

					AI_Republic_Fleet = SpawnList(republic_avenger_hard_list, rep_fleet_01_marker.Get_Position(), p_republic, true, true)
					Republic_AI_Fleet = AI_Republic_Fleet[1]
					Republic_AI_Fleet.Teleport_And_Face(rep_fleet_01_marker)
					Republic_AI_Fleet.Cinematic_Hyperspace_In(150)

				else
					AI_Republic_Fleet = SpawnList(republic_avenger_medium_list, rep_fleet_01_marker.Get_Position(), p_republic, true, true)
					Republic_AI_Fleet = AI_Republic_Fleet[1]
					Republic_AI_Fleet.Teleport_And_Face(rep_fleet_01_marker)
					Republic_AI_Fleet.Cinematic_Hyperspace_In(150)
				end
				Story_Event("NOT_GIVING_UP_02")
			end
		end
	elseif p_republic.Is_Human() then
		if act_1_active then
			if not station_jyvus_disabled then
				if Find_First_Object("JYVUS_SPACE_CITY").Get_Hull() <= 0.10 then
					station_jyvus_disabled = true
					Find_First_Object("JYVUS_SPACE_CITY").Change_Owner(p_invaders)
					if not defence_fleet_killed then
						Story_Event("NOT_GIVING_UP_01")
					end
				end
			end
			if not station_jivv_disabled then
				if Find_First_Object("JIVV_SPACE_CITY").Get_Hull() <= 0.10 then
					station_jivv_disabled = true
					Find_First_Object("JIVV_SPACE_CITY").Change_Owner(p_cis)
				end
			end
			if not station_rrudobar_disabled then
				if Find_First_Object("RRUDOBAR").Get_Hull() <= 0.10 then
					station_rrudobar_disabled = true
					Find_First_Object("RRUDOBAR").Change_Owner(p_cis)
				end
			end
			if not station_urrdorf_disabled then
				if Find_First_Object("URRDORF_CITY").Get_Hull() <= 0.10 then
					station_urrdorf_disabled = true
					Find_First_Object("URRDORF_CITY").Change_Owner(p_cis)
				end
			end
			if not station_orr_om_disabled then
				if Find_First_Object("ORR_OM").Get_Hull() <= 0.10 then
					station_urrdorf_disabled = true
					Find_First_Object("ORR_OM").Change_Owner(p_cis)
				end
			end
			if not station_bburru_disabled then
				if Find_First_Object("BBURRU_STATION").Get_Hull() <= 0.10 then
					station_bburru_disabled = true
					Find_First_Object("BBURRU_STATION").Change_Owner(p_cis)
				end
			end
			if not station_kri_larun_disabled then
				if Find_First_Object("KRI_LARUN").Get_Hull() <= 0.10 then
					station_kri_larun_disabled = true
					Find_First_Object("KRI_LARUN").Change_Owner(p_cis)
				end
			end
			if not station_new_tayana_disabled then
				if Find_First_Object("NEW_TAYANA").Get_Hull() <= 0.10 then
					station_new_tayana_disabled = true
					Find_First_Object("NEW_TAYANA").Change_Owner(p_cis)
				end
			end
			if not defence_fleet_killed then
				rep_list = Find_All_Objects_Of_Type(p_republic, "SpaceHero | Corvette | Capital | Frigate | SuperCapital")
				if (table.getn(rep_list) == 0) then
					defence_fleet_killed = true
				end
			end
			if not act_2_active then
				if station_jyvus_disabled and defence_fleet_killed then
					Story_Event("COMMENCE_DEFENCE")
					act_1_active = false
				end
			end
			cis_list = Find_All_Objects_Of_Type(p_cis, "SpaceHero | Corvette | Capital | Frigate | SuperCapital")
			if (table.getn(cis_list) == 0) then
				Story_Event("REPUBLIC_VICTORY")
			end
		end
	end
end


function Start_Cinematic_Intro_CIS()
	AI_Republic_Fleet = SpawnList(republic_defender_list, rep_fleet_01_marker.Get_Position(), p_republic, true, true)
	Republic_AI_Fleet = AI_Republic_Fleet[1]
	Republic_AI_Fleet.Teleport_And_Face(rep_fleet_01_marker)

	Start_Cinematic_Camera()
	Stop_All_Music()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()

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
						Grievous_Spawning = Spawn_From_Reinforcement_Pool(Find_Object_Type("Grievous_Team"), invisible_hand_marker, p_cis)
						if Grievous_Spawning then
							Grievous_Spawning = Grievous_Spawning[1]
							player_invisible_hand = Spawn_Unit(Find_Object_Type("Invisible_Hand"), invisible_hand_marker, p_cis)
							player_invisible_hand = Find_Nearest(invisible_hand_marker, p_cis, true)
							player_invisible_hand.Teleport_And_Face(invisible_hand_marker)	
							player_invisible_hand.Cinematic_Hyperspace_In(50)
							grievous_invisible_hand_active = true
						end
					end
					if not TestValid(Grievous_Spawning) then
						Grievous_Spawning = Spawn_From_Reinforcement_Pool(Find_Object_Type("Grievous_Team_Recusant"), renitor_marker, p_cis)
						if Grievous_Spawning then
							Grievous_Spawning = Grievous_Spawning[1]
							player_renitor = Spawn_Unit(Find_Object_Type("Grievous_Recusant"), renitor_marker, p_cis)
							player_renitor = Find_Nearest(renitor_marker, p_cis, true)
							player_renitor.Teleport_And_Face(renitor_marker)	
							player_renitor.Cinematic_Hyperspace_In(50)
							grievous_renitor_active = true
						end
					end
					if not TestValid(Grievous_Spawning) then
						Grievous_Spawning = Spawn_From_Reinforcement_Pool(Find_Object_Type("Grievous_Team_Munificent"), munificent_marker, p_cis)
						if Grievous_Spawning then
							Grievous_Spawning = Grievous_Spawning[1]
							player_grievous_munificent = Spawn_Unit(Find_Object_Type("Grievous_Munificent"), munificent_marker, p_cis)
							player_grievous_munificent = Find_Nearest(munificent_marker, p_cis, true)
							player_grievous_munificent.Teleport_And_Face(munificent_marker)	
							player_grievous_munificent.Cinematic_Hyperspace_In(50)
							grievous_munificent_active = true
						end
					end
					if not TestValid(Grievous_Spawning) then
						Grievous_Spawning = Spawn_From_Reinforcement_Pool(Find_Object_Type("Grievous_Team_Malevolence"), invisible_hand_marker, p_cis)
						if Grievous_Spawning then
							Grievous_Spawning = Grievous_Spawning[1]
							player_malevolence = Spawn_Unit(Find_Object_Type("Grievous_Malevolence"), invisible_hand_marker, p_cis)
							player_malevolence = Find_Nearest(invisible_hand_marker, p_cis, true)
							player_malevolence.Teleport_And_Face(invisible_hand_marker)	
							player_malevolence.Cinematic_Hyperspace_In(50)
							grievous_malevolence_active = true
						end
					end
					if not TestValid(Grievous_Spawning) then
						Grievous_Spawning = Spawn_From_Reinforcement_Pool(Find_Object_Type("Grievous_Team_Soulless_One"), munificent_marker, p_cis)
						if Grievous_Spawning then
							Grievous_Spawning = Grievous_Spawning[1]
							player_soulless_one = Spawn_Unit(Find_Object_Type("Soulless_One_Squadron"), munificent_marker, p_cis)
							player_soulless_one = Find_Nearest(munificent_marker, p_cis, true)
							player_soulless_one.Teleport_And_Face(munificent_marker)	
							player_soulless_one.Cinematic_Hyperspace_In(50)
							grievous_soulless_one_active = true
						end
					end
				end
			end
		end
	end

	Fade_On()
	Sleep(0.5)

	cinematic_one = true

	Fade_Screen_In(5)
	Letter_Box_In(3)

	news_report_gamble = GameRandom.Free_Random(1, 3)
	if news_report_gamble == 1 then
		honest_news_report = true
	elseif news_report_gamble == 2 then
		propaganda_news_report = true
	elseif news_report_gamble == 3 then
		interview_news_report = true
	end

	if honest_news_report then
		Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_2_marker, 10.5, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_2_marker, 10.5, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Play_Music("Duro_Defence_01")
		Sleep(5.5)

		Play_Music("Duro_Defence_02")
		Sleep(0.5)

		Story_Event("NEWS_REPORT_01")
		Sleep(3.5)

		Fade_Screen_Out(2)
		Sleep(2.0)

		Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_4_marker, 16, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_4_marker, 16, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Story_Event("NEWS_REPORT_02")
		Sleep(0.5)

		Fade_Screen_In(2)
		Sleep(6.5)

		Story_Event("NEWS_REPORT_03")
		Sleep(9.0)

		Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_5_marker, 0, 0, 0, 0, introcam_target_victory_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_6_marker, 20, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_6_marker, 20, 0, 0, 0, 0, introcam_target_victory_marker, 1, 0)

		Story_Event("NEWS_REPORT_04")
		Sleep(5.0)

		Fade_Screen_Out(2)
		Sleep(2.0)

		Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, introcam_target_victory_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_8_marker, 30.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_8_marker, 30.0, 0, 0, 0, 0, introcam_target_victory_marker, 1, 0)
		Story_Event("NEWS_REPORT_05")
		Sleep(1.0)

		Fade_Screen_In(3)
		Sleep(7.5)

		Story_Event("NEWS_REPORT_06")
		Sleep(7.5)
	elseif propaganda_news_report then
		Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_2_marker, 11.5, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_2_marker, 11.5, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Play_Music("Duro_Defence_01")
		Sleep(5.5)

		Play_Music("Duro_Defence_02_Alt_01")
		Sleep(0.5)

		Story_Event("NEWS_REPORT_01_ALT_01")
		Sleep(4.5)

		Fade_Screen_Out(2)
		Sleep(2.0)

		Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_4_marker, 16, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_4_marker, 16, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Story_Event("NEWS_REPORT_02_ALT_01")
		Sleep(0.5)

		Fade_Screen_In(2)
		Sleep(6.5)

		Story_Event("NEWS_REPORT_03_ALT_01")
		Sleep(6.5)

		Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_5_marker, 0, 0, 0, 0, introcam_target_victory_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_6_marker, 20, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_6_marker, 20, 0, 0, 0, 0, introcam_target_victory_marker, 1, 0)

		Story_Event("NEWS_REPORT_04_ALT_01")
		Sleep(8.0)

		Fade_Screen_Out(2)
		Sleep(2.0)

		Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, introcam_target_victory_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_8_marker, 30.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_8_marker, 30.0, 0, 0, 0, 0, introcam_target_victory_marker, 1, 0)
		Story_Event("NEWS_REPORT_05_ALT_01")
		Sleep(1.0)

		Fade_Screen_In(3)
		Sleep(7.5)

		Story_Event("NEWS_REPORT_06_ALT_01")
		Sleep(8.5)
	elseif interview_news_report then
		Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_2_marker, 12.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_2_marker, 12.0, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Play_Music("Duro_Defence_01")
		Sleep(5.5)

		Play_Music("Duro_Defence_02_Alt_02")
		Sleep(0.5)

		Story_Event("NEWS_REPORT_01_ALT_02")
		Sleep(5.0)

		Fade_Screen_Out(2)
		Sleep(2.0)

		Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_4_marker, 16.5, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_4_marker, 16.5, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Story_Event("NEWS_REPORT_02_ALT_02")
		Sleep(0.5)

		Fade_Screen_In(2)
		Sleep(6.0)

		Story_Event("NEWS_REPORT_03_ALT_02")
		Sleep(9.0)

		Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_5_marker, 0, 0, 0, 0, introcam_target_victory_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_6_marker, 20, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_6_marker, 20, 0, 0, 0, 0, introcam_target_victory_marker, 1, 0)

		Story_Event("NEWS_REPORT_04_ALT_02")
		Sleep(7.5)

		Fade_Screen_Out(2)
		Sleep(2.0)

		Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, introcam_target_victory_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_8_marker, 30.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_8_marker, 30.0, 0, 0, 0, 0, introcam_target_victory_marker, 1, 0)
		Story_Event("NEWS_REPORT_05_ALT_02")
		Sleep(1.0)

		Fade_Screen_In(3)
		Sleep(7.5)

		Story_Event("NEWS_REPORT_06_ALT_01")
		Sleep(6.0)
	end

	Story_Event("NEWS_REPORT_07")
	Sleep(1.0)

	Fade_Screen_Out(5)
	Sleep(6.5)

	player_munificent_1 = Spawn_Unit(Find_Object_Type("Munificent"), intro_cis_ship_1_marker, p_cis)
	player_munificent_1 = Find_Nearest(intro_cis_ship_1_marker, p_cis, true)
	player_munificent_1.Teleport_And_Face(intro_cis_ship_1_marker)
	player_munificent_1.Cinematic_Hyperspace_In(50)

	player_munificent_2 = Spawn_Unit(Find_Object_Type("Munificent"), intro_cis_ship_2_marker, p_cis)
	player_munificent_2 = Find_Nearest(intro_cis_ship_2_marker, p_cis, true)
	player_munificent_2.Teleport_And_Face(intro_cis_ship_2_marker)
	player_munificent_2.Cinematic_Hyperspace_In(50)

	if TestValid(player_invisible_hand) then
		player_invisible_hand.Teleport_And_Face(invisible_hand_marker)
		player_invisible_hand.Cinematic_Hyperspace_In(150)
		grievous_invisible_hand_active = true

		Set_Cinematic_Camera_Key(introcam_9_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_9_marker, 0, 0, 0, 0, introcam_target_invisible_hand_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_10_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_10_marker, 10.0, 0, 0, 0, 0, introcam_target_invisible_hand_marker, 1, 0)
	elseif TestValid(player_renitor) then
		player_renitor.Teleport_And_Face(renitor_marker)
		player_renitor.Cinematic_Hyperspace_In(150)
		grievous_renitor_active = true

		Set_Cinematic_Camera_Key(introcam_9_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_9_marker, 0, 0, 0, 0, introcam_target_renitor_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_10_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_10_marker, 10.0, 0, 0, 0, 0, introcam_target_renitor_marker, 1, 0)
	elseif TestValid(player_grievous_munificent) then
		player_grievous_munificent.Teleport_And_Face(munificent_marker)
		player_grievous_munificent.Cinematic_Hyperspace_In(150)
		grievous_munificent_active = true

		Set_Cinematic_Camera_Key(introcam_9_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_9_marker, 0, 0, 0, 0, introcam_target_munificent_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_10_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_10_marker, 10.0, 0, 0, 0, 0, introcam_target_munificent_marker, 1, 0)
	elseif TestValid(player_malevolence) then
		player_malevolence.Teleport_And_Face(invisible_hand_marker)
		player_malevolence.Cinematic_Hyperspace_In(150)
		grievous_malevolence_active = true

		Set_Cinematic_Camera_Key(introcam_9_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_9_marker, 0, 0, 0, 0, introcam_target_invisible_hand_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_10_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_10_marker, 10.0, 0, 0, 0, 0, introcam_target_invisible_hand_marker, 1, 0)
	elseif TestValid(player_soulless_one) then
		player_soulless_one.Teleport_And_Face(munificent_marker)
		player_soulless_one.Cinematic_Hyperspace_In(150)
		grievous_soulless_one_active = true

		Set_Cinematic_Camera_Key(introcam_9_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_9_marker, 0, 0, 0, 0, introcam_target_munificent_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_10_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_10_marker, 10.0, 0, 0, 0, 0, introcam_target_munificent_marker, 1, 0)
	end

	Cinematic_Zoom(40, 40)

	Play_Music("Duro_Defence_03")

	Story_Event("NEWS_REPORT_08")
	Fade_Screen_In(3)
	Sleep(8.5)

	cis_fleet = Find_All_Objects_Of_Type(p_cis)
	for _,cis_ships in pairs(cis_fleet) do
		if TestValid(cis_ships) then
			if TestValid(station_jyvus_space_city) then
				cis_ships.Attack_Move(station_jyvus_space_city)
			end
		end
	end

	Story_Event("NEWS_REPORT_09")
	Sleep(6.5)

	Set_Cinematic_Camera_Key(introcam_11_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_11_marker, 0, 0, 0, 0, station_jivv_space_city, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_12_marker, 8.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_12_marker, 8.0, 0, 0, 0, 0, station_urrdorf_city, 1, 0)
	Story_Event("NEWS_REPORT_10")
	Sleep(8.0)

	Set_Cinematic_Camera_Key(introcam_13_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_13_marker, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_14_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_14_marker, 10.0, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
	Story_Event("NEWS_REPORT_11")
	Sleep(4.5)

	Story_Event("NEWS_REPORT_12")
	Sleep(5.5)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end

function End_Cinematic_Intro_CIS()
	Story_Event("NEWS_REPORT_13")
	Point_Camera_At(station_jyvus_space_city)
	Transition_To_Tactical_Camera(3)
	Letter_Box_Out(3)
	Sleep(3.0)
	End_Cinematic_Camera()
	Lock_Controls(0)
	Suspend_AI(0)

	p_cis.Make_Enemy(p_republic)
	p_republic.Make_Enemy(p_cis)

	Story_Event("GOAL_TRIGGER_CIS_I")
	Story_Event("ACTIVATE_REP_AI")

	cinematic_one = false
	act_1_active = true

	if p_republic.Get_Difficulty()== "Easy" then
	elseif p_republic.Get_Difficulty()== "Hard" then
		Register_Timer(State_Avenger_Fleet_Arrives, 150)
	else
		Register_Timer(State_Avenger_Fleet_Arrives, 240)
	end

	Resume_Mode_Based_Music()
end

function Start_Cinematic_Outro_CIS()
	act_1_active = false
	cinematic_two = true

	Start_Cinematic_Camera()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()
	Fade_On()

	Fade_Screen_In(0.5)
	Letter_Box_In(0.5)

	Play_Music("Duro_Defence_03")

	player_transport_1 = Spawn_Unit(Find_Object_Type("TF_Landing_Craft"), outro_cis_ship_1_marker, p_cis)
	player_transport_1 = Find_Nearest(outro_cis_ship_1_marker, p_cis, true)
	player_transport_1.Teleport_And_Face(outro_cis_ship_1_marker)
	player_transport_1.Cinematic_Hyperspace_In(50)

	player_transport_2 = Spawn_Unit(Find_Object_Type("TF_Landing_Craft"), outro_cis_ship_2_marker, p_cis)
	player_transport_2 = Find_Nearest(outro_cis_ship_2_marker, p_cis, true)
	player_transport_2.Teleport_And_Face(outro_cis_ship_2_marker)
	player_transport_2.Cinematic_Hyperspace_In(50)

	player_transport_3 = Spawn_Unit(Find_Object_Type("TF_Landing_Craft"), outro_cis_ship_3_marker, p_cis)
	player_transport_3 = Find_Nearest(outro_cis_ship_3_marker, p_cis, true)
	player_transport_3.Teleport_And_Face(outro_cis_ship_3_marker)
	player_transport_3.Cinematic_Hyperspace_In(50)

	player_transport_4 = Spawn_Unit(Find_Object_Type("TF_Landing_Craft"), outro_cis_ship_4_marker, p_cis)
	player_transport_4 = Find_Nearest(outro_cis_ship_4_marker, p_cis, true)
	player_transport_4.Teleport_And_Face(outro_cis_ship_4_marker)
	player_transport_4.Cinematic_Hyperspace_In(50)

	player_transport_5 = Spawn_Unit(Find_Object_Type("TF_Landing_Craft"), outro_cis_ship_5_marker, p_cis)
	player_transport_5 = Find_Nearest(outro_cis_ship_5_marker, p_cis, true)
	player_transport_5.Teleport_And_Face(outro_cis_ship_5_marker)
	player_transport_5.Cinematic_Hyperspace_In(50)


	Set_Cinematic_Camera_Key(outrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_1_marker, 0, 0, 0, 0, outro_cis_ship_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(outrocam_2_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_2_marker, 10.0, 0, 0, 0, 0, outro_cis_ship_1_marker, 1, 0)

	Story_Event("COMMENCE_BOARDING_01")
	Sleep(5.5)

	Fade_Screen_Out(1.5)
	Sleep(2.5)

	Resume_Mode_Based_Music()
	Story_Event("CIS_VICTORY")
end


function Start_Cinematic_Intro_Rep()
	Start_Cinematic_Camera()
	Stop_All_Music()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()

	player_invisible_hand = Spawn_Unit(Find_Object_Type("Generic_Providence"), invisible_hand_marker, p_cis)
	player_invisible_hand = Find_Nearest(invisible_hand_marker, p_cis, true)
	player_invisible_hand.Teleport_And_Face(invisible_hand_marker)	
	grievous_invisible_hand_active = true

	cinematic_one = true

	Fade_On()
	Sleep(0.5)

	Fade_Screen_In(5)
	Letter_Box_In(3)

	news_report_gamble = GameRandom.Free_Random(1, 3)
	if news_report_gamble == 1 then
		honest_news_report = true
	elseif news_report_gamble == 2 then
		propaganda_news_report = true
	elseif news_report_gamble == 3 then
		interview_news_report = true
	end

	if honest_news_report then
		Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_2_marker, 10.5, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_2_marker, 10.5, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Play_Music("Duro_Defence_01")
		Sleep(5.5)

		Play_Music("Duro_Defence_02")
		Sleep(0.5)

		Story_Event("NEWS_REPORT_01")
		Sleep(3.5)

		Fade_Screen_Out(2)
		Sleep(2.0)

		Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_4_marker, 16, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_4_marker, 16, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Story_Event("NEWS_REPORT_02")
		Sleep(0.5)

		Fade_Screen_In(2)
		Sleep(6.5)

		Story_Event("NEWS_REPORT_03")
		Sleep(9.0)

		Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_5_marker, 0, 0, 0, 0, introcam_target_victory_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_6_marker, 20, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_6_marker, 20, 0, 0, 0, 0, introcam_target_victory_marker, 1, 0)

		Story_Event("NEWS_REPORT_04")
		Sleep(5.0)

		Fade_Screen_Out(2)
		Sleep(2.0)

		Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, introcam_target_victory_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_8_marker, 30.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_8_marker, 30.0, 0, 0, 0, 0, introcam_target_victory_marker, 1, 0)
		Story_Event("NEWS_REPORT_05")
		Sleep(1.0)

		Fade_Screen_In(3)
		Sleep(7.5)

		Story_Event("NEWS_REPORT_06")
		Sleep(7.5)
	elseif propaganda_news_report then
		Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_2_marker, 11.5, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_2_marker, 11.5, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Play_Music("Duro_Defence_01")
		Sleep(5.5)

		Play_Music("Duro_Defence_02_Alt_01")
		Sleep(0.5)

		Story_Event("NEWS_REPORT_01_ALT_01")
		Sleep(4.5)

		Fade_Screen_Out(2)
		Sleep(2.0)

		Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_4_marker, 16, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_4_marker, 16, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Story_Event("NEWS_REPORT_02_ALT_01")
		Sleep(0.5)

		Fade_Screen_In(2)
		Sleep(6.5)

		Story_Event("NEWS_REPORT_03_ALT_01")
		Sleep(6.5)

		Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_5_marker, 0, 0, 0, 0, introcam_target_victory_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_6_marker, 20, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_6_marker, 20, 0, 0, 0, 0, introcam_target_victory_marker, 1, 0)

		Story_Event("NEWS_REPORT_04_ALT_01")
		Sleep(8.0)

		Fade_Screen_Out(2)
		Sleep(2.0)

		Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, introcam_target_victory_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_8_marker, 30.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_8_marker, 30.0, 0, 0, 0, 0, introcam_target_victory_marker, 1, 0)
		Story_Event("NEWS_REPORT_05_ALT_01")
		Sleep(1.0)

		Fade_Screen_In(3)
		Sleep(7.5)

		Story_Event("NEWS_REPORT_06_ALT_01")
		Sleep(8.5)
	elseif interview_news_report then
		Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_2_marker, 12.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_2_marker, 12.0, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Play_Music("Duro_Defence_01")
		Sleep(5.5)

		Play_Music("Duro_Defence_02_Alt_02")
		Sleep(0.5)

		Story_Event("NEWS_REPORT_01_ALT_02")
		Sleep(5.0)

		Fade_Screen_Out(2)
		Sleep(2.0)

		Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_4_marker, 16.5, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_4_marker, 16.5, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Story_Event("NEWS_REPORT_02_ALT_02")
		Sleep(0.5)

		Fade_Screen_In(2)
		Sleep(6.0)

		Story_Event("NEWS_REPORT_03_ALT_02")
		Sleep(9.0)

		Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_5_marker, 0, 0, 0, 0, introcam_target_victory_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_6_marker, 20, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_6_marker, 20, 0, 0, 0, 0, introcam_target_victory_marker, 1, 0)

		Story_Event("NEWS_REPORT_04_ALT_02")
		Sleep(7.5)

		Fade_Screen_Out(2)
		Sleep(2.0)

		Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, introcam_target_victory_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_8_marker, 30.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_8_marker, 30.0, 0, 0, 0, 0, introcam_target_victory_marker, 1, 0)
		Story_Event("NEWS_REPORT_05_ALT_02")
		Sleep(1.0)

		Fade_Screen_In(3)
		Sleep(7.5)

		Story_Event("NEWS_REPORT_06_ALT_01")
		Sleep(6.0)
	end

	Story_Event("NEWS_REPORT_07")
	Sleep(1.0)

	Fade_Screen_Out(5)
	Sleep(6.5)

	player_munificent_1 = Spawn_Unit(Find_Object_Type("Munificent"), intro_cis_ship_1_marker, p_cis)
	player_munificent_1 = Find_Nearest(intro_cis_ship_1_marker, p_cis, true)
	player_munificent_1.Teleport_And_Face(intro_cis_ship_1_marker)
	player_munificent_1.Cinematic_Hyperspace_In(50)

	player_munificent_2 = Spawn_Unit(Find_Object_Type("Munificent"), intro_cis_ship_2_marker, p_cis)
	player_munificent_2 = Find_Nearest(intro_cis_ship_2_marker, p_cis, true)
	player_munificent_2.Teleport_And_Face(intro_cis_ship_2_marker)
	player_munificent_2.Cinematic_Hyperspace_In(50)

	if TestValid(player_invisible_hand) then
		player_invisible_hand.Teleport_And_Face(invisible_hand_marker)
		player_invisible_hand.Cinematic_Hyperspace_In(150)

		Set_Cinematic_Camera_Key(introcam_9_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_9_marker, 0, 0, 0, 0, introcam_target_invisible_hand_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_10_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_10_marker, 10.0, 0, 0, 0, 0, introcam_target_invisible_hand_marker, 1, 0)
	elseif TestValid(player_renitor) then
		player_renitor.Teleport_And_Face(renitor_marker)
		player_renitor.Cinematic_Hyperspace_In(150)

		Set_Cinematic_Camera_Key(introcam_9_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_9_marker, 0, 0, 0, 0, introcam_target_renitor_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_10_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_10_marker, 10.0, 0, 0, 0, 0, introcam_target_renitor_marker, 1, 0)
	elseif TestValid(player_grievous_munificent) then
		player_grievous_munificent.Teleport_And_Face(munificent_marker)
		player_grievous_munificent.Cinematic_Hyperspace_In(150)

		Set_Cinematic_Camera_Key(introcam_9_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_9_marker, 0, 0, 0, 0, introcam_target_munificent_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_10_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_10_marker, 10.0, 0, 0, 0, 0, introcam_target_munificent_marker, 1, 0)
	end

	Cinematic_Zoom(40, 40)

	Play_Music("Duro_Defence_03")

	Story_Event("NEWS_REPORT_08")
	Fade_Screen_In(3)
	Sleep(8.5)

	cis_fleet = Find_All_Objects_Of_Type(p_cis)
	for _,cis_ships in pairs(cis_fleet) do
		if TestValid(cis_ships) then
			if TestValid(station_jyvus_space_city) then
				cis_ships.Attack_Move(station_jyvus_space_city)
			end
		end
	end

	Story_Event("NEWS_REPORT_09")
	Sleep(6.5)

	Set_Cinematic_Camera_Key(introcam_11_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_11_marker, 0, 0, 0, 0, station_jivv_space_city, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_12_marker, 8.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_12_marker, 8.0, 0, 0, 0, 0, station_urrdorf_city, 1, 0)
	Story_Event("NEWS_REPORT_10")
	Sleep(8.0)

	Set_Cinematic_Camera_Key(introcam_13_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_13_marker, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_14_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_14_marker, 10.0, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
	Story_Event("NEWS_REPORT_11")
	Sleep(4.5)

	Story_Event("NEWS_REPORT_12")
	Sleep(5.5)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Rep")
	end
end

function End_Cinematic_Intro_Rep()
	Story_Event("NEWS_REPORT_13_ALT")
	Point_Camera_At(station_jyvus_space_city)
	Transition_To_Tactical_Camera(3)
	Letter_Box_Out(3)
	Sleep(3.0)
	End_Cinematic_Camera()
	Lock_Controls(0)
	Suspend_AI(0)

	p_cis.Make_Enemy(p_republic)
	p_republic.Make_Enemy(p_cis)

	Story_Event("GOAL_TRIGGER_REP_I")
	Story_Event("ACTIVATE_CIS_AI")

	Reinforce_Unit(Find_Object_Type("GENERIC_PROVIDENCE"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("GENERIC_PROVIDENCE"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("GENERIC_PROVIDENCE"), false, p_cis, true, false)

	Reinforce_Unit(Find_Object_Type("BATTLESHIP_LUCREHULK"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("BATTLESHIP_LUCREHULK"), false, p_cis, true, false)

	Reinforce_Unit(Find_Object_Type("AUXILIARY_LUCREHULK"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("AUXILIARY_LUCREHULK"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("AUXILIARY_LUCREHULK"), false, p_cis, true, false)

	Reinforce_Unit(Find_Object_Type("GENERIC_LUCREHULK"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("GENERIC_LUCREHULK"), false, p_cis, true, false)

	Reinforce_Unit(Find_Object_Type("CIS_DREADNAUGHT"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("CIS_DREADNAUGHT"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("CIS_DREADNAUGHT"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("CIS_DREADNAUGHT"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("CIS_DREADNAUGHT"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("CIS_DREADNAUGHT"), false, p_cis, true, false)

	Reinforce_Unit(Find_Object_Type("CAPTOR"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("CAPTOR"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("CAPTOR"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("CAPTOR"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("CAPTOR"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("CAPTOR"), false, p_cis, true, false)

	Reinforce_Unit(Find_Object_Type("DIAMOND_FRIGATE"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("DIAMOND_FRIGATE"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("DIAMOND_FRIGATE"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("DIAMOND_FRIGATE"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("DIAMOND_FRIGATE"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("DIAMOND_FRIGATE"), false, p_cis, true, false)

	Reinforce_Unit(Find_Object_Type("GEONOSIAN_CRUISER"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("GEONOSIAN_CRUISER"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("GEONOSIAN_CRUISER"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("GEONOSIAN_CRUISER"), false, p_cis, true, false)

	Reinforce_Unit(Find_Object_Type("LUCREHULK_CORE_DESTROYER"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("LUCREHULK_CORE_DESTROYER"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("LUCREHULK_CORE_DESTROYER"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("LUCREHULK_CORE_DESTROYER"), false, p_cis, true, false)

	Reinforce_Unit(Find_Object_Type("MUNIFICENT"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("MUNIFICENT"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("MUNIFICENT"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("MUNIFICENT"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("MUNIFICENT"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("MUNIFICENT"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("MUNIFICENT"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("MUNIFICENT"), false, p_cis, true, false)

	Reinforce_Unit(Find_Object_Type("RECUSANT"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("RECUSANT"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("RECUSANT"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("RECUSANT"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("RECUSANT"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("RECUSANT"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("RECUSANT"), false, p_cis, true, false)
	Reinforce_Unit(Find_Object_Type("RECUSANT"), false, p_cis, true, false)


	Reinforce_Unit(Find_Object_Type("GENERIC_ACCLAMATOR_ASSAULT_SHIP_I"), false, p_republic, true, false)
	Reinforce_Unit(Find_Object_Type("GENERIC_ACCLAMATOR_ASSAULT_SHIP_I"), false, p_republic, true, false)
	Reinforce_Unit(Find_Object_Type("GENERIC_ACCLAMATOR_ASSAULT_SHIP_I"), false, p_republic, true, false)
	Reinforce_Unit(Find_Object_Type("GENERIC_ACCLAMATOR_ASSAULT_SHIP_I"), false, p_republic, true, false)

	Reinforce_Unit(Find_Object_Type("GENERIC_ACCLAMATOR_ASSAULT_SHIP_LEVELER"), false, p_republic, true, false)
	Reinforce_Unit(Find_Object_Type("GENERIC_ACCLAMATOR_ASSAULT_SHIP_LEVELER"), false, p_republic, true, false)
	Reinforce_Unit(Find_Object_Type("GENERIC_ACCLAMATOR_ASSAULT_SHIP_LEVELER"), false, p_republic, true, false)

	Reinforce_Unit(Find_Object_Type("DREADNAUGHT_LASERS"), false, p_republic, true, false)
	Reinforce_Unit(Find_Object_Type("DREADNAUGHT_LASERS"), false, p_republic, true, false)
	Reinforce_Unit(Find_Object_Type("DREADNAUGHT_LASERS"), false, p_republic, true, false)


	cinematic_one = false
	act_1_active = true

	Resume_Mode_Based_Music()
end

function Start_Cinematic_Outro_Rep()
	act_1_active = false
	cinematic_two = true

	Start_Cinematic_Camera()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()
	Fade_On()

	Fade_Screen_In(0.5)
	Letter_Box_In(0.5)

	Play_Music("Duro_Defence_03")

	player_transport_1 = Spawn_Unit(Find_Object_Type("TF_Landing_Craft"), outro_cis_ship_1_marker, p_cis)
	player_transport_1 = Find_Nearest(outro_cis_ship_1_marker, p_cis, true)
	player_transport_1.Teleport_And_Face(outro_cis_ship_1_marker)
	player_transport_1.Cinematic_Hyperspace_In(50)

	player_transport_2 = Spawn_Unit(Find_Object_Type("TF_Landing_Craft"), outro_cis_ship_2_marker, p_cis)
	player_transport_2 = Find_Nearest(outro_cis_ship_2_marker, p_cis, true)
	player_transport_2.Teleport_And_Face(outro_cis_ship_2_marker)
	player_transport_2.Cinematic_Hyperspace_In(50)

	player_transport_3 = Spawn_Unit(Find_Object_Type("TF_Landing_Craft"), outro_cis_ship_3_marker, p_cis)
	player_transport_3 = Find_Nearest(outro_cis_ship_3_marker, p_cis, true)
	player_transport_3.Teleport_And_Face(outro_cis_ship_3_marker)
	player_transport_3.Cinematic_Hyperspace_In(50)

	player_transport_4 = Spawn_Unit(Find_Object_Type("TF_Landing_Craft"), outro_cis_ship_4_marker, p_cis)
	player_transport_4 = Find_Nearest(outro_cis_ship_4_marker, p_cis, true)
	player_transport_4.Teleport_And_Face(outro_cis_ship_4_marker)
	player_transport_4.Cinematic_Hyperspace_In(50)

	player_transport_5 = Spawn_Unit(Find_Object_Type("TF_Landing_Craft"), outro_cis_ship_5_marker, p_cis)
	player_transport_5 = Find_Nearest(outro_cis_ship_5_marker, p_cis, true)
	player_transport_5.Teleport_And_Face(outro_cis_ship_5_marker)
	player_transport_5.Cinematic_Hyperspace_In(50)


	Set_Cinematic_Camera_Key(outrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_1_marker, 0, 0, 0, 0, outro_cis_ship_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(outrocam_2_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_2_marker, 10.0, 0, 0, 0, 0, outro_cis_ship_1_marker, 1, 0)

	Story_Event("COMMENCE_BOARDING_01")
	Sleep(5.5)

	Fade_Screen_Out(1.5)
	Sleep(2.5)

	Resume_Mode_Based_Music()
	Story_Event("CIS_VICTORY")
end
