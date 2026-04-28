--***************************************************--
--*********** Main Menu Space Script ****************--
--***************************************************--

require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")

function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))

	Define_State("State_Init", State_Init)

	battle_one_active = false
	battle_two_active = false
	battle_three_active = false
	
	cinematic_cam_active = false

	-- Players
	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")

end

function State_Init(message)
	if message == OnEnter then

		if Get_Game_Mode() ~= "Space" then
			return
		end

		--Phase 1 Markers
		phase_1_cis_ship_1_marker = Find_Hint("MARKER_GENERIC_RED", "phase-1-cis-ship-1")  --Subjugator

		phase_1_rep_ship_1_marker = Find_Hint("MARKER_GENERIC_RED", "phase-1-rep-ship-1")  --Venators
		phase_1_rep_ship_2_marker = Find_Hint("MARKER_GENERIC_RED", "phase-1-rep-ship-2")
		phase_1_rep_ship_3_marker = Find_Hint("MARKER_GENERIC_RED", "phase-1-rep-ship-3")
		phase_1_rep_ship_4_marker = Find_Hint("MARKER_GENERIC_RED", "phase-1-rep-ship-4")
		phase_1_rep_ship_5_marker = Find_Hint("MARKER_GENERIC_RED", "phase-1-rep-ship-5")
		phase_1_rep_ship_6_marker = Find_Hint("MARKER_GENERIC_RED", "phase-1-rep-ship-6")
		phase_1_rep_ship_7_marker = Find_Hint("MARKER_GENERIC_RED", "phase-1-rep-ship-7")
		phase_1_rep_ship_8_marker = Find_Hint("MARKER_GENERIC_RED", "phase-1-rep-ship-8")
		phase_1_rep_ship_9_marker = Find_Hint("MARKER_GENERIC_RED", "phase-1-rep-ship-9")
		phase_1_rep_ship_10_marker = Find_Hint("MARKER_GENERIC_RED", "phase-1-rep-ship-10")
		phase_1_rep_ship_11_marker = Find_Hint("MARKER_GENERIC_RED", "phase-1-rep-ship-11")

		--Phase 2 Markers
		phase_2_cis_ship_1_marker = Find_Hint("MARKER_GENERIC_BLUE", "phase-2-cis-ship-1")  -- IGBC's
		phase_2_cis_ship_2_marker = Find_Hint("MARKER_GENERIC_BLUE", "phase-2-cis-ship-2")
		phase_2_cis_ship_3_marker = Find_Hint("MARKER_GENERIC_BLUE", "phase-2-cis-ship-3")

		phase_2_rep_ship_1_marker = Find_Hint("MARKER_GENERIC_BLUE", "phase-2-rep-ship-1")

		--Phase 3 Markers
		phase_3_cis_ship_1_marker = Find_Hint("MARKER_GENERIC_GREEN", "phase-3-cis-ship-1")
		phase_3_cis_ship_2_marker = Find_Hint("MARKER_GENERIC_GREEN", "phase-3-cis-ship-2")
		phase_3_cis_ship_3_marker = Find_Hint("MARKER_GENERIC_GREEN", "phase-3-cis-ship-3")
		phase_3_cis_ship_4_marker = Find_Hint("MARKER_GENERIC_GREEN", "phase-3-cis-ship-4")
		phase_3_cis_ship_5_marker = Find_Hint("MARKER_GENERIC_GREEN", "phase-3-cis-ship-5")
		
		phase_3_rep_ship_1_marker = Find_Hint("MARKER_GENERIC_GREEN", "phase-3-rep-ship-1")

		Create_Thread("State_List_Battle_01")
		Create_Thread("State_List_Battle_02")
		Create_Thread("State_List_Battle_03")

		battle_map_gamble = GameRandom.Free_Random(1, 3)
        if battle_map_gamble == 1 then
			Create_Thread("Battle_One_Begins")
		elseif battle_map_gamble == 2 then
			Create_Thread("Battle_Two_Begins")
		elseif battle_map_gamble == 3 then
			Create_Thread("Battle_Three_Begins")
        end
	end
end

function Battle_Cinematic_Camera()
    Start_Cinematic_Mode()
end

function State_List_Battle_01()
	phase_1_rep_spawn_list = {
		"LAC",
		"LAC",
		"LAC",
		"LAC",
		"Arquitens",
		"Arquitens",
		"Generic_Acclamator_Assault_Ship_I",
		"Generic_Acclamator_Assault_Ship_Leveler",
	}
end

function State_List_Battle_02()
	phase_2_rep_spawn_list = {
		"Generic_Acclamator_Assault_Ship_I",
		"Generic_Acclamator_Assault_Ship_I",
		"Generic_Acclamator_Assault_Ship_I",
		"Generic_Acclamator_Assault_Ship_I",
		"Generic_Acclamator_Assault_Ship_I",
		"Generic_Acclamator_Assault_Ship_I",
		"Generic_Acclamator_Assault_Ship_I",
		"Generic_Acclamator_Assault_Ship_I",
		"Generic_Acclamator_Assault_Ship_I",
		"Generic_Acclamator_Assault_Ship_I",
		"Generic_Acclamator_Assault_Ship_I",
		"Generic_Acclamator_Assault_Ship_I",
		"Generic_Acclamator_Assault_Ship_I",
		"Generic_Acclamator_Assault_Ship_I",
		"Generic_Acclamator_Assault_Ship_I",
		"Generic_Acclamator_Assault_Ship_I",
	}
end

function State_List_Battle_03()
	phase_3_rep_spawn_list = {
		"Secondary_Golan_One",
		"Secondary_Golan_One",
		"Secondary_Golan_One",
		"Secondary_Golan_One",
		"Generic_Acclamator_Assault_Ship_I",
		"Generic_Acclamator_Assault_Ship_I",
		"Generic_Acclamator_Assault_Ship_I",
		"Generic_Acclamator_Assault_Ship_I",
		"Generic_Acclamator_Assault_Ship_I",
		"Generic_Acclamator_Assault_Ship_I",
		"Generic_Acclamator_Assault_Ship_I",
		"Dreadnaught",
		"Dreadnaught",
		"Generic_Victory_Destroyer",
	}
	phase_3_cis_spawn_list = {
		"Generic_Lucrehulk",
		"Munificent",
		"Munificent",
		"Munificent",
		"Munificent",
		"Munificent",
		"Geonosian_Cruiser",
		"Geonosian_Cruiser",
		"Geonosian_Cruiser",
		"Geonosian_Cruiser",
		"Hardcell",
		"Hardcell",
		"Hardcell",
		"Hardcell",
		"Hardcell",
		"Recusant",
		"Recusant",
		"Recusant",
	}
end

function State_Spawn_Battle_01()
	--CIS fleet
	player_malevolence = Spawn_Unit(Find_Object_Type("Subjugator"), phase_1_cis_ship_1_marker, p_cis)
	player_malevolence = Find_Nearest(phase_1_cis_ship_1_marker, p_cis, true)
	player_malevolence.Teleport_And_Face(phase_1_cis_ship_1_marker)
	player_malevolence.Cinematic_Hyperspace_In(50)
	player_malevolence.Set_Importance(10)
	player_malevolence.Make_Invulnerable(true)

	--Republic fleet
	player_phase_1_rep_ship_1 = Spawn_Unit(Find_Object_Type("Generic_Venator"), phase_1_rep_ship_1_marker, p_republic)
	player_phase_1_rep_ship_1 = Find_Nearest(phase_1_rep_ship_1_marker, p_republic, true)
	player_phase_1_rep_ship_1.Teleport_And_Face(phase_1_rep_ship_1_marker)
	player_phase_1_rep_ship_1.Cinematic_Hyperspace_In(0.1)

	player_phase_1_rep_ship_2 = Spawn_Unit(Find_Object_Type("Generic_Venator"), phase_1_rep_ship_2_marker, p_republic)
	player_phase_1_rep_ship_2 = Find_Nearest(phase_1_rep_ship_2_marker, p_republic, true)
	player_phase_1_rep_ship_2.Teleport_And_Face(phase_1_rep_ship_2_marker)
	player_phase_1_rep_ship_2.Cinematic_Hyperspace_In(0.1)

	player_phase_1_rep_ship_3 = Spawn_Unit(Find_Object_Type("Generic_Venator"), phase_1_rep_ship_3_marker, p_republic)
	player_phase_1_rep_ship_3 = Find_Nearest(phase_1_rep_ship_3_marker, p_republic, true)
	player_phase_1_rep_ship_3.Teleport_And_Face(phase_1_rep_ship_3_marker)
	player_phase_1_rep_ship_3.Cinematic_Hyperspace_In(0.1)

	player_phase_1_rep_ship_4 = Spawn_Unit(Find_Object_Type("Generic_Venator"), phase_1_rep_ship_4_marker, p_republic)
	player_phase_1_rep_ship_4 = Find_Nearest(phase_1_rep_ship_4_marker, p_republic, true)
	player_phase_1_rep_ship_4.Teleport_And_Face(phase_1_rep_ship_4_marker)
	player_phase_1_rep_ship_4.Cinematic_Hyperspace_In(0.1)

	player_phase_1_rep_ship_5 = Spawn_Unit(Find_Object_Type("Generic_Venator"), phase_1_rep_ship_5_marker, p_republic)
	player_phase_1_rep_ship_5 = Find_Nearest(phase_1_rep_ship_5_marker, p_republic, true)
	player_phase_1_rep_ship_5.Teleport_And_Face(phase_1_rep_ship_5_marker)
	player_phase_1_rep_ship_5.Cinematic_Hyperspace_In(0.1)

	player_phase_1_rep_ship_6 = Spawn_Unit(Find_Object_Type("Generic_Venator"), phase_1_rep_ship_6_marker, p_republic)
	player_phase_1_rep_ship_6 = Find_Nearest(phase_1_rep_ship_6_marker, p_republic, true)
	player_phase_1_rep_ship_6.Teleport_And_Face(phase_1_rep_ship_6_marker)
	player_phase_1_rep_ship_6.Cinematic_Hyperspace_In(0.1)

	player_phase_1_rep_ship_7 = Spawn_Unit(Find_Object_Type("Generic_Venator"), phase_1_rep_ship_7_marker, p_republic)
	player_phase_1_rep_ship_7 = Find_Nearest(phase_1_rep_ship_7_marker, p_republic, true)
	player_phase_1_rep_ship_7.Teleport_And_Face(phase_1_rep_ship_7_marker)
	player_phase_1_rep_ship_7.Cinematic_Hyperspace_In(0.1)

	player_phase_1_rep_ship_8 = Spawn_Unit(Find_Object_Type("Generic_Venator"), phase_1_rep_ship_8_marker, p_republic)
	player_phase_1_rep_ship_8 = Find_Nearest(phase_1_rep_ship_8_marker, p_republic, true)
	player_phase_1_rep_ship_8.Teleport_And_Face(phase_1_rep_ship_8_marker)
	player_phase_1_rep_ship_8.Cinematic_Hyperspace_In(0.1)

	player_phase_1_rep_ship_9 = Spawn_Unit(Find_Object_Type("Generic_Venator"), phase_1_rep_ship_9_marker, p_republic)
	player_phase_1_rep_ship_9 = Find_Nearest(phase_1_rep_ship_9_marker, p_republic, true)
	player_phase_1_rep_ship_9.Teleport_And_Face(phase_1_rep_ship_9_marker)
	player_phase_1_rep_ship_9.Cinematic_Hyperspace_In(0.1)


	Phase_1_Republic_Fleet_01 = SpawnList(phase_1_rep_spawn_list, phase_1_rep_ship_10_marker.Get_Position(), p_republic, true, true)
	Republic_Phase_1_Fleet_01 = Phase_1_Republic_Fleet_01[1]
	Republic_Phase_1_Fleet_01.Teleport_And_Face(phase_1_rep_ship_10_marker)
	Republic_Phase_1_Fleet_01.Cinematic_Hyperspace_In(0.1)

	Phase_1_Republic_Fleet_02 = SpawnList(phase_1_rep_spawn_list, phase_1_rep_ship_11_marker.Get_Position(), p_republic, true, true)
	Republic_Phase_1_Fleet_02 = Phase_1_Republic_Fleet_02[1]
	Republic_Phase_1_Fleet_02.Teleport_And_Face(phase_1_rep_ship_11_marker)
	Republic_Phase_1_Fleet_02.Cinematic_Hyperspace_In(0.1)
end

function State_Spawn_Battle_02()
	--CIS fleet
	player_cis_station_1 = Spawn_Unit(Find_Object_Type("NewRepublic_Star_Base_5"), phase_2_cis_ship_1_marker, p_cis)
	player_cis_station_1 = Find_Nearest(phase_2_cis_ship_1_marker, p_cis, true)
	player_cis_station_1.Teleport_And_Face(phase_2_cis_ship_1_marker)

	player_cis_station_2 = Spawn_Unit(Find_Object_Type("NewRepublic_Star_Base_5"), phase_2_cis_ship_2_marker, p_cis)
	player_cis_station_2 = Find_Nearest(phase_2_cis_ship_2_marker, p_cis, true)
	player_cis_station_2.Teleport_And_Face(phase_2_cis_ship_2_marker)

	player_cis_station_3 = Spawn_Unit(Find_Object_Type("NewRepublic_Star_Base_5"), phase_2_cis_ship_3_marker, p_cis)
	player_cis_station_3 = Find_Nearest(phase_2_cis_ship_3_marker, p_cis, true)
	player_cis_station_3.Teleport_And_Face(phase_2_cis_ship_3_marker)

	--Republic fleet
	Phase_2_Republic_Fleet = SpawnList(phase_2_rep_spawn_list, phase_2_rep_ship_1_marker.Get_Position(), p_republic, true, true)
	Republic_Phase_2_Fleet = Phase_2_Republic_Fleet[1]
	Republic_Phase_2_Fleet.Teleport_And_Face(phase_2_rep_ship_1_marker)
	Republic_Phase_2_Fleet.Cinematic_Hyperspace_In(50)
end

function State_Spawn_Battle_03()
	--CIS fleet
	Phase_3_CIS_Fleet = SpawnList(phase_3_cis_spawn_list, phase_3_cis_ship_1_marker.Get_Position(), p_cis, true, true)
	CIS_Phase_3_Fleet = Phase_3_CIS_Fleet[1]
	CIS_Phase_3_Fleet.Teleport_And_Face(phase_3_cis_ship_1_marker)
	CIS_Phase_3_Fleet.Cinematic_Hyperspace_In(0.1)
	
	player_phase_3_cis_ship_1 = Spawn_Unit(Find_Object_Type("Generic_Providence"), phase_3_cis_ship_2_marker, p_cis)
	player_phase_3_cis_ship_1 = Find_Nearest(phase_3_cis_ship_2_marker, p_cis, true)
	player_phase_3_cis_ship_1.Teleport_And_Face(phase_3_cis_ship_2_marker)
	player_phase_3_cis_ship_1.Cinematic_Hyperspace_In(0.1)
	
	player_phase_3_cis_ship_2 = Spawn_Unit(Find_Object_Type("Generic_Providence"), phase_3_cis_ship_3_marker, p_cis)
	player_phase_3_cis_ship_2 = Find_Nearest(phase_3_cis_ship_3_marker, p_cis, true)
	player_phase_3_cis_ship_2.Teleport_And_Face(phase_3_cis_ship_3_marker)
	player_phase_3_cis_ship_2.Cinematic_Hyperspace_In(0.1)
	
	player_phase_3_cis_ship_3 = Spawn_Unit(Find_Object_Type("Generic_Providence"), phase_3_cis_ship_4_marker, p_cis)
	player_phase_3_cis_ship_3 = Find_Nearest(phase_3_cis_ship_4_marker, p_cis, true)
	player_phase_3_cis_ship_3.Teleport_And_Face(phase_3_cis_ship_4_marker)
	player_phase_3_cis_ship_3.Cinematic_Hyperspace_In(0.1)
	
--	player_phase_3_cis_ship_4 = Spawn_Unit(Find_Object_Type("Invisible_Hand"), phase_3_cis_ship_5_marker, p_cis)
--	player_phase_3_cis_ship_4 = Find_Nearest(phase_3_cis_ship_5_marker, p_cis, true)
--	player_phase_3_cis_ship_4.Teleport_And_Face(phase_3_cis_ship_5_marker)
--	player_phase_3_cis_ship_4.Cinematic_Hyperspace_In(0.1)

	--Republic fleet
	Phase_3_Republic_Fleet = SpawnList(phase_3_rep_spawn_list, phase_3_rep_ship_1_marker.Get_Position(), p_republic, true, true)
	Republic_Phase_3_Fleet = Phase_3_Republic_Fleet[1]
	Republic_Phase_3_Fleet.Teleport_And_Face(phase_3_rep_ship_1_marker)
	Republic_Phase_3_Fleet.Cinematic_Hyperspace_In(0.1)
end

function Battle_One_Begins()
	if not battle_two_active and not battle_three_active then
		battle_one_active = true
		Fade_On()

		Set_New_Environment(1)

		local unhide_battle_one_list = Find_All_Objects_With_Hint("1")
		for h,unhide01 in pairs(unhide_battle_one_list) do
			if TestValid(unhide01) then
				Hide_Object(unhide01, 0)
			end	
		end

		local hide_battle_two_list = Find_All_Objects_With_Hint("2")
		for h,hide02 in pairs(hide_battle_two_list) do
			if TestValid(hide02) then
				Hide_Object(hide02, 1)
			end	
		end
	
		local hide_battle_three_list = Find_All_Objects_With_Hint("3")
		for h,hide03 in pairs(hide_battle_three_list) do
			if TestValid(hide03) then
				Hide_Object(hide03, 1)
			end	
		end

		Create_Thread("State_Spawn_Battle_01")

		if not cinematic_cam_active then
			current_cinematic_thread_id = Create_Thread("Battle_Cinematic_Camera")
			cinematic_cam_active = true
		end

		player_medical_station = Find_First_Object("Haven_Menu_Anim")
		if TestValid(player_medical_station) then
			player_medical_station.Set_Importance(20)
		end
	
		Fade_Screen_In(10)
	
		Sleep (5)

		local republic_attack_one_list = Find_All_Objects_Of_Type(p_republic, "SpaceHero | Corvette | Capital | Frigate | SpaceStructure | SuperCapital")
		for g,repattack01 in pairs(republic_attack_one_list) do
			if TestValid(repattack01) then
				if TestValid(player_malevolence) then
					repattack01.Attack_Move(player_malevolence)
				end
			end
		end

		if TestValid(player_phase_1_rep_ship_5) then
			player_malevolence.Attack_Move(player_phase_1_rep_ship_5)
		end

		Sleep(90) --Length of battle
	
		Fade_Screen_Out(2)
	
		Sleep (3)
	
		Fade_On()
		Do_End_Cinematic_Cleanup()

		local republic_despawn_one_list = Find_All_Objects_Of_Type(p_republic, "SpaceHero | Corvette | Capital | Frigate | SpaceStructure | SuperCapital")
		for g,repdespawn01 in pairs(republic_despawn_one_list) do
			if TestValid(repdespawn01) then
				repdespawn01.Despawn()
			end
		end
	
		local republic_despawn_venatordc_list = Find_All_Objects_Of_Type(p_republic, "Venator_Death_Clone")
		for g,repvdcdespawn01 in pairs(republic_despawn_venatordc_list) do
			if TestValid(repvdcdespawn01) then
			repvdcdespawn01.Despawn()
			end
		end

		local cis_despawn_one_list = Find_All_Objects_Of_Type(p_cis, "SpaceHero | Corvette | Capital | Frigate | SpaceStructure | SuperCapital")
		for g,cisdespawn01 in pairs(cis_despawn_one_list) do
			if TestValid(cisdespawn01) then
				cisdespawn01.Despawn()
			end
		end

		battle_one_active = false

		battle_map_gamble = GameRandom.Free_Random(1, 3)
		if battle_map_gamble <= 2 then
			Create_Thread("Battle_Two_Begins")
		elseif battle_map_gamble == 3 then
			Create_Thread("Battle_Three_Begins")
		end
	end
end

function Battle_Two_Begins()
		if not battle_one_active and not battle_three_active then
			battle_two_active = true
		
		Fade_On()

		Set_New_Environment(2)

		local hide_battle_one_list = Find_All_Objects_With_Hint("1")
		for h,hide01 in pairs(hide_battle_one_list) do
			if TestValid(hide01) then
				Hide_Object(hide01, 1)
			end	
		end

		local unhide_battle_two_list = Find_All_Objects_With_Hint("2")
		for h,unhide02 in pairs(unhide_battle_two_list) do
			if TestValid(unhide02) then
				Hide_Object(unhide02, 0)
			end	
		end
		
		local hide_battle_three_list = Find_All_Objects_With_Hint("3")
		for h,hide03 in pairs(hide_battle_three_list) do
			if TestValid(hide03) then
				Hide_Object(hide03, 1)
			end	
		end

		Create_Thread("State_Spawn_Battle_02")

		if not cinematic_cam_active then
			current_cinematic_thread_id = Create_Thread("Battle_Cinematic_Camera")
			cinematic_cam_active = true
		end
		
		Sleep (5)
		
		Fade_Screen_In(10)

		local republic_attack_two_list = Find_All_Objects_Of_Type(p_republic, "SpaceHero | Corvette | Capital | Frigate | SpaceStructure | SuperCapital")
		for g,repattack02 in pairs(republic_attack_two_list) do
			if TestValid(repattack02) then
				if TestValid(player_cis_station_2) then
					repattack02.Attack_Move(player_cis_station_2)
				end
			end
		end

		Sleep(90) --Length of battle
		
		Fade_Screen_Out(2)
		
		Sleep (3)
		
		Fade_On()
		Do_End_Cinematic_Cleanup()

		local republic_despawn_two_list = Find_All_Objects_Of_Type(p_republic, "SpaceHero | Corvette | Capital | Frigate | SpaceStructure | SuperCapital")
		for g,repdespawn02 in pairs(republic_despawn_two_list) do
			if TestValid(repdespawn02) then
				repdespawn02.Despawn()
			end
		end

		local cis_despawn_two_list = Find_All_Objects_Of_Type(p_cis, "SpaceHero | Corvette | Capital | Frigate | SpaceStructure | SuperCapital")
		for g,cisdespawn02 in pairs(cis_despawn_two_list) do
			if TestValid(cisdespawn02) then
				cisdespawn02.Despawn()
			end
		end

		battle_two_active = false

		battle_map_gamble = GameRandom.Free_Random(1, 3)
		if battle_map_gamble <= 2 then
			Create_Thread("Battle_Three_Begins")
		elseif battle_map_gamble == 3 then
			Create_Thread("Battle_One_Begins")
		end
	end
end

function Battle_Three_Begins()
		if not battle_one_active and not battle_two_active then
			battle_three_active = true
		
		Fade_On()

		Set_New_Environment(3)

		local hide_battle_one_list = Find_All_Objects_With_Hint("1")
		for h,hide01 in pairs(hide_battle_one_list) do
			if TestValid(hide01) then
				Hide_Object(hide01, 1)
			end	
		end

		local hide_battle_two_list = Find_All_Objects_With_Hint("2")
		for h,hide02 in pairs(hide_battle_two_list) do
			if TestValid(hide02) then
				Hide_Object(hide02, 1)
			end	
		end

		local unhide_battle_three_list = Find_All_Objects_With_Hint("3")
		for h,unhide03 in pairs(unhide_battle_three_list) do
			if TestValid(unhide03) then
				Hide_Object(unhide03, 0)
			end	
		end

		Create_Thread("State_Spawn_Battle_03")

		if not cinematic_cam_active then
			current_cinematic_thread_id = Create_Thread("Battle_Cinematic_Camera")
			cinematic_cam_active = true
		end
		
		player_generic_lucrehulk = Find_First_Object("Generic_Lucrehulk")
		if TestValid(player_generic_lucrehulk) then
			player_generic_lucrehulk.Set_Importance(20)
		end

		Fade_Screen_In(10)
		
		Sleep (5)

		local republic_attack_three_list = Find_All_Objects_Of_Type(p_republic, "SpaceHero | Corvette | Capital | Frigate | SuperCapital")
		for g,repattack03 in pairs(republic_attack_three_list) do
			if TestValid(repattack03) then
				if TestValid(Find_First_Object("Generic_Lucrehulk")) then
					repattack03.Attack_Move(Find_First_Object("Generic_Lucrehulk"))
				end
			end
		end

		local cis_attack_three_list = Find_All_Objects_Of_Type(p_cis, "SpaceHero | Corvette | Capital | Frigate | SuperCapital")
		for g,cisattack03 in pairs(cis_attack_three_list) do
			if TestValid(cisattack03) then
				if TestValid(Find_First_Object("Generic_Victory_Destroyer")) then
					cisattack03.Attack_Move(Find_First_Object("Generic_Victory_Destroyer"))
				end
			end
		end

		Sleep(90) --Length of battle
		
		Fade_Screen_Out(2)
		
		Sleep (3)
		
		Fade_On()
		Do_End_Cinematic_Cleanup()

		local republic_despawn_three_list = Find_All_Objects_Of_Type(p_republic, "SpaceHero | Corvette | Capital | Frigate | SpaceStructure | SuperCapital")
		for g,repdespawn03 in pairs(republic_despawn_three_list) do
			if TestValid(repdespawn03) then
				repdespawn03.Despawn()
			end
		end

		local cis_despawn_three_list = Find_All_Objects_Of_Type(p_cis, "SpaceHero | Corvette | Capital | Frigate | SpaceStructure | SuperCapital")
		for g,cisdespawn03 in pairs(cis_despawn_three_list) do
			if TestValid(cisdespawn03) then
				cisdespawn03.Despawn()
			end
		end

		battle_three_active = false

		battle_map_gamble = GameRandom.Free_Random(1, 3)
		if battle_map_gamble <= 2 then
			Create_Thread("Battle_One_Begins")
		elseif battle_map_gamble == 3 then
			Create_Thread("Battle_Two_Begins")
		end
	end
end