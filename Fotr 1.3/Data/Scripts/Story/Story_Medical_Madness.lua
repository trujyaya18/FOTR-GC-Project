--*****************************************************--
--***** Hunt for the Malevolence: Medical Madness *****--
--*****************************************************--

require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")
require("eawx-util/StoryUtil")
require("SetFighterResearch")

function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))

	StoryModeEvents =
	{
		Battle_Start = Begin_Battle,
		Trigger_Malevolence_Defeated = State_Malevolence_Defeated,
	}

	yularen_fleet_list = {
		"YULAREN_RESOLUTE",
		"GENERIC_VENATOR",
		"GENERIC_VENATOR",
		"GENERIC_ACCLAMATOR_ASSAULT_SHIP_I",
		"GENERIC_ACCLAMATOR_ASSAULT_SHIP_I",
		"PELTA_SUPPORT",
		"PELTA_SUPPORT",
		"PELTA_SUPPORT",
		"ARQUITENS",
		"ARQUITENS",
		"ARQUITENS",
		"ARQUITENS"
	}

	luminara_fleet_medium_list = {
		"GENERIC_VENATOR",
		"GENERIC_VENATOR",
		"GENERIC_VENATOR",
		"GENERIC_ACCLAMATOR_ASSAULT_SHIP_I",
		"PELTA_SUPPORT",
		"PELTA_SUPPORT",
		"PELTA_SUPPORT",
		"ARQUITENS",
		"ARQUITENS",
		"ARQUITENS",
		"ARQUITENS",
	}

	luminara_fleet_hard_list = {
		"GENERIC_VENATOR",
		"GENERIC_VENATOR",
		"GENERIC_VENATOR",
		"GENERIC_VENATOR",
		"GENERIC_ACCLAMATOR_ASSAULT_SHIP_I",
		"GENERIC_ACCLAMATOR_ASSAULT_SHIP_I",
		"GENERIC_ACCLAMATOR_ASSAULT_SHIP_I",
		"PELTA_SUPPORT",
		"PELTA_SUPPORT",
		"PELTA_SUPPORT",
		"ARQUITENS",
		"ARQUITENS",
		"ARQUITENS",
		"ARQUITENS",
	}

	outro_fleet_list = {
		"GENERIC_VENATOR",
		"GENERIC_VENATOR",
		"GENERIC_VENATOR",
		"GENERIC_VENATOR",
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")

	act_1_active = false
	act_2_active = false

	current_cinematic_thread_id = nil

	cinematic_one = false
	cinematic_two = false
	cinematic_three = false

	cinematic_one_skipped = false
	cinematic_two_skipped = false
	cinematic_three_skipped = false

	canon_storyline = false
	au_storyline = false

	yularen_protected = false
	yularen_dead = false
	kaliida_dead = false
	kaliida_damaged = false
	luminara_arrived = false
	malevolence_disabled = false

	cis_fleet_dead = false
	rep_fleet_dead = false

	camera_offset = 125
	mission_started = false
end

function Begin_Battle(message)
	if message == OnEnter then
		Clear_Fighter_Hero("SHADOW_SQUADRON")

		player_kaliida_shoals = Find_First_Object("KALIIDA_SHOALS_MEDCENTER")

		intro_1_malevolence_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-malevolence")
		intro_2_malevolence_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-malevolence")

		intro_1_shadow_squadron_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-shadow")

		republic_fleet_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "republic-fleet-1")
		republic_fleet_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "republic-fleet-2")
		republic_fleet_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "republic-fleet-3")

		outro_1_twilight_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-1-twilight")

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-4")
		introcam_4_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-4-1")
		introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-5")
		introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-6")
		introcam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-7")
		introcam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-8")
		introcam_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-9")
		introcam_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-10")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")
		introcam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")
		introcam_target_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-4")

		player_malevolence = Find_First_Object("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN")

		p_cis.Make_Ally(p_invaders)
		p_invaders.Make_Ally(p_cis)

		p_republic.Make_Ally(p_invaders)
		p_invaders.Make_Ally(p_republic)

		canon_storyline = true
		mission_started = true
		
		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
		elseif p_republic.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
		end
	end
end


function State_Luminara_Arrives()
	Story_Event("REINFORCEMENTS")
	luminara_arrived = true

	if p_republic.Get_Difficulty()== "Easy" then
	elseif p_republic.Get_Difficulty()== "Hard" then
		AI_Republic_Fleet = SpawnList(luminara_fleet_hard_list, intro_1_malevolence_marker.Get_Position(), p_republic, true, true)
		Republic_AI_Fleet = AI_Republic_Fleet[1]
		Republic_AI_Fleet.Teleport_And_Face(intro_1_malevolence_marker)
		Republic_AI_Fleet.Cinematic_Hyperspace_In(150)
	else
		AI_Republic_Fleet = SpawnList(luminara_fleet_medium_list, republic_fleet_2_marker.Get_Position(), p_republic, true, true)
		Republic_AI_Fleet = AI_Republic_Fleet[1]
		Republic_AI_Fleet.Teleport_And_Face(republic_fleet_2_marker)
		Republic_AI_Fleet.Cinematic_Hyperspace_In(150)
	end
	Find_First_Object("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN").Override_Max_Speed(1.75)
end

function State_Malevolence_Defeated(message)
	if message == OnEnter then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_01_CIS")
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

				if not TestValid(player_shadow_squadron) then
					player_shadow_squadron = Spawn_Unit(Find_Object_Type("Shadow_Squadron"), intro_1_shadow_squadron_marker, p_republic)
					player_shadow_squadron = Find_Nearest(intro_1_shadow_squadron_marker, p_republic, true)
					player_shadow_squadron.Teleport_And_Face(intro_1_shadow_squadron_marker)
				end

				if TestValid(Find_First_Object("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN")) then
					Find_First_Object("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN").Despawn()
					player_malevolence = Spawn_Unit(Find_Object_Type("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN"), intro_1_malevolence_marker, p_cis)
					player_malevolence = Find_Nearest(intro_1_malevolence_marker, p_cis, true)
					player_malevolence.Teleport_And_Face(intro_1_malevolence_marker)
					player_malevolence.Override_Max_Speed(4.0)
				end

				if p_republic.Get_Difficulty()== "Easy" then
				elseif p_republic.Get_Difficulty()== "Hard" then
					Register_Timer(State_Luminara_Arrives, 60)
				else
					Register_Timer(State_Luminara_Arrives, 120)
				end

				republic_defender_list = SpawnList(yularen_fleet_list, republic_fleet_1_marker, p_republic, true, true, false)
				republic_defender = republic_defender_list[1]
				republic_defender.Teleport_And_Face(republic_fleet_1_marker)
				republic_defender.Cinematic_Hyperspace_In(30)

				if TestValid(Find_First_Object("KALIIDA_SHOALS_MEDCENTER")) then
					Find_First_Object("KALIIDA_SHOALS_MEDCENTER").Despawn()
				end

				p_republic.Make_Enemy(p_cis)
				p_cis.Make_Enemy(p_republic)

				Letter_Box_Out(0)
				Lock_Controls(0)
				Suspend_AI(0)
				End_Cinematic_Camera()

				Story_Event("GOAL_TRIGGER_CIS_I")
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

				Fade_On()
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_02_CIS")
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

				Allow_Localized_SFX(true)
				SFXManager.Allow_HUD_VO(true)
				SFXManager.Allow_Ambient_VO(true)
				SFXManager.Allow_Enemy_Sighted_VO(true)
				SFXManager.Allow_Unit_Reponse_VO(true)
				Resume_Mode_Based_Music()

				player_malevolence.Hyperspace_Away(true)

				act_2_active = false
				Story_Event("SUBJUGATOR_SABOTAGE")
				if cis_fleet_dead then
					Story_Event("REPUBLIC_VICTORY")
				elseif rep_fleet_dead then
					Story_Event("CIS_VICTORY")
				end
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

				if TestValid(Find_First_Object("KALIIDA_SHOALS_MEDCENTER")) then
					Find_First_Object("KALIIDA_SHOALS_MEDCENTER").Despawn()
				end

				p_republic.Make_Enemy(p_cis)
				p_cis.Make_Enemy(p_republic)

				Letter_Box_Out(0)
				Lock_Controls(0)
				Suspend_AI(0)
				End_Cinematic_Camera()

				Story_Event("GOAL_TRIGGER_REP_I")

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

				Fade_On()
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_02_Rep")
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

				Allow_Localized_SFX(true)
				SFXManager.Allow_HUD_VO(true)
				SFXManager.Allow_Ambient_VO(true)
				SFXManager.Allow_Enemy_Sighted_VO(true)
				SFXManager.Allow_Unit_Reponse_VO(true)
				Resume_Mode_Based_Music()

				player_malevolence.Hyperspace_Away(true)

				act_2_active = false
				Story_Event("SUBJUGATOR_SABOTAGE")
				if cis_fleet_dead then
					Story_Event("REPUBLIC_VICTORY")
				elseif rep_fleet_dead then
					Story_Event("CIS_VICTORY")
				end
			end
		end
	end
end

function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_1_active then
			if not yularen_protected then
				if Find_First_Object("YULAREN_RESOLUTE").Get_Hull() <= 0.99 then
					Find_First_Object("YULAREN_RESOLUTE").Set_Cannot_Be_Killed(true)
					yularen_protected = true
				end
			end
			if not yularen_dead then
				if Find_First_Object("YULAREN_RESOLUTE").Get_Hull() <= 0.01 then
					Find_First_Object("YULAREN_RESOLUTE").Hyperspace_Away(true)
					yularen_dead = true
				end
			end
			if not kaliida_damaged then
				if Find_First_Object("GENERIC_HAVEN_STARBASE").Get_Hull() <= 0.99 then --Replace GENERIC_HAVEN_STARBASE with KALIIDA_SHOALS_MEDCENTER when the collision mesh gets made
					Story_Event("KALIIDA_ATTACKED")
					kaliida_damaged = true
				end
			end
			if not malevolence_disabled then
				if Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Get_Hull() <= 0.01 then
					Story_Event("MALEVOLENCE_DEFEATED")
					GlobalValue.Set("HfM_Malevolence_Alive", 0)
					malevolence_disabled = true
					cis_fleet_dead = true
				end
				republic_list = Find_All_Objects_Of_Type(p_republic, "SpaceHero | Corvette | Capital | Frigate | SpaceStructure | SuperCapital")
				if (table.getn(republic_list) == 0) then
					GlobalValue.Set("HfM_Malevolence_Alive", 1)
					Story_Event("CIS_VICTORY")
					malevolence_disabled = true
					rep_fleet_dead = true
				end
			end
		end
	end
end


function Start_Cinematic_Intro_CIS()
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

	Grievous_Spawning = Find_First_Object("Grievous_Malevolence_Hunt_Campaign")
	if TestValid(Grievous_Spawning) then
		--[[Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Hyperspace_Away(false)

		player_malevolence = Spawn_Unit(Find_Object_Type("Grievous_Malevolence_Hunt_Campaign"), intro_1_malevolence_marker, p_cis)
		player_malevolence = Find_Nearest(intro_1_malevolence_marker, p_cis, true)
		player_malevolence.Teleport_And_Face(intro_1_malevolence_marker)	
		player_malevolence.Cinematic_Hyperspace_In(50)]]
	elseif not TestValid(Grievous_Spawning) then
		Grievous_Spawning = Spawn_From_Reinforcement_Pool(Find_Object_Type("Grievous_Malevolence_Hunt_Campaign"), intro_1_malevolence_marker, p_cis)
		if Grievous_Spawning then
			Grievous_Spawning = Grievous_Spawning[1]
		end
		if not Grievous_Spawning then
			player_malevolence = Spawn_Unit(Find_Object_Type("Grievous_Malevolence_Hunt_Campaign"), intro_1_malevolence_marker, p_cis)
			player_malevolence = Find_Nearest(intro_1_malevolence_marker, p_cis, true)
			player_malevolence.Teleport_And_Face(intro_1_malevolence_marker)	
			player_malevolence.Cinematic_Hyperspace_In(50)
		end
	end

	player_malevolence = Find_First_Object("Grievous_Malevolence_Hunt_Campaign")
	player_malevolence.Teleport_And_Face(intro_1_malevolence_marker)
	player_malevolence.Turn_To_Face(intro_2_malevolence_marker)
	Sleep(0.5)

	cinematic_one = true

	Fade_Screen_In(5)
	Letter_Box_In(3)

	Play_Music("Medical_Madness_01")
	Story_Event("CINEMATIC_CRAWL_01")

	Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 18.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 18.0, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Sleep(3.0)

	Story_Event("CINEMATIC_CRAWL_02")
	Sleep(14.0)

	Transition_Cinematic_Camera_Key(introcam_3_marker, 11.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_3_marker, 11.0, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Sleep(4.0)

	player_malevolence.Move_To(intro_2_malevolence_marker)
	Sleep(7.0)

	Fade_Screen_In(6.0)
	Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_5_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_6_marker, 11.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_6_marker, 11.0, 0, 0, 0, 0, player_malevolence, 1, 0)
	Sleep(9.0)

	player_malevolence.Override_Max_Speed(4.0)

	player_shadow_squadron = Spawn_Unit(Find_Object_Type("Shadow_Squadron"), intro_1_shadow_squadron_marker, p_republic)
	player_shadow_squadron = Find_Nearest(intro_1_shadow_squadron_marker, p_republic, true)
	player_shadow_squadron.Teleport_And_Face(intro_1_shadow_squadron_marker)
	BlockOnCommand(player_shadow_squadron.Cinematic_Hyperspace_In(50))
	player_shadow_squadron.Attack_Move(player_malevolence)
	Sleep(2.0)

	if TestValid(Find_First_Object("BTLB_Y-WING_BROADSIDE")) then
		Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, Find_First_Object("BTLB_Y-WING_BROADSIDE"), 1, 0)
		Transition_Cinematic_Camera_Key(introcam_8_marker, 7.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_8_marker, 7.0, 0, 0, 0, 0, Find_First_Object("BTLB_Y-WING_BROADSIDE"), 1, 0)
	else
		Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_8_marker, 7.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_8_marker, 7.0, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
	end
	Sleep(5)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end

function End_Cinematic_Intro_CIS()
	republic_defender_list = SpawnList(yularen_fleet_list, republic_fleet_1_marker, p_republic, true, true, false)
	republic_defender = republic_defender_list[1]
	republic_defender.Teleport_And_Face(republic_fleet_1_marker)
	republic_defender.Cinematic_Hyperspace_In(30)

	Allow_Localized_SFX(true)
	SFXManager.Allow_HUD_VO(true)
	SFXManager.Allow_Ambient_VO(true)
	SFXManager.Allow_Enemy_Sighted_VO(true)
	SFXManager.Allow_Unit_Reponse_VO(true)

	Find_First_Object("KALIIDA_SHOALS_MEDCENTER").Despawn()

	Point_Camera_At(player_malevolence)
	Transition_To_Tactical_Camera(3)
	Letter_Box_Out(3)
	Sleep(3.0)
	End_Cinematic_Camera()
	Lock_Controls(0)
	Suspend_AI(0)

	if TestValid(Find_First_Object("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN")) then
		malevolence_dummy = Find_First_Object("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN")
		player_malevolence = Spawn_Unit(Find_Object_Type("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN"), malevolence_dummy, p_cis)
		player_malevolence = Find_Nearest(malevolence_dummy, p_cis, true)
		player_malevolence.Teleport_And_Face(malevolence_dummy)
		player_malevolence.Override_Max_Speed(4.0)
		malevolence_dummy.Despawn()
	end

	Story_Event("GOAL_TRIGGER_CIS_I")
	Story_Event("ACTIVATE_REP_AI")

	if p_republic.Get_Difficulty()== "Easy" then
	elseif p_republic.Get_Difficulty()== "Hard" then
		Register_Timer(State_Luminara_Arrives, 60)
	else
		Register_Timer(State_Luminara_Arrives, 120)
	end

	cinematic_one = false
	act_1_active = true
	Sleep(13.0)

	Resume_Mode_Based_Music()
end

function Start_Cinematic_Outro_01_CIS()
	AI_Republic_Fleet = SpawnList(outro_fleet_list, republic_fleet_3_marker.Get_Position(), p_republic, true, true)
	Republic_AI_Fleet = AI_Republic_Fleet[1]
	Republic_AI_Fleet.Teleport_And_Face(republic_fleet_3_marker)
	Republic_AI_Fleet.Cinematic_Hyperspace_In(150)

	act_1_active = false
	cinematic_two = true

	Start_Cinematic_Camera()
	Stop_All_Music()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()

	Allow_Localized_SFX(false)
	SFXManager.Allow_HUD_VO(false)
	SFXManager.Allow_Ambient_VO(false)
	SFXManager.Allow_Enemy_Sighted_VO(false)
	SFXManager.Allow_Unit_Reponse_VO(false)
	SFXManager.Allow_Localized_SFXEvents(false)

	hero_list_01 = Find_All_Objects_Of_Type("SpaceHero")
	for h, hero01 in pairs(hero_list_01) do
		if TestValid(hero01) then
			hero01.Make_Invulnerable(true)
		end
	end

	Fade_On()
	Play_Music("Mission_Malevolence_01")
	Sleep(1)

	Letter_Box_In(1)
	Fade_Screen_In(2)

	Set_Cinematic_Camera_Key(player_malevolence, 2800, -200, 155, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(player_malevolence, 0, 0, -200, 0, 0, 0, 0)
	Transition_Cinematic_Target_Key(player_malevolence, 20, 0, -1000, -200, 0, player_malevolence, 1, 0)
	Transition_Cinematic_Target_Key(player_malevolence, 20, 0, -1000, -200, 0, player_malevolence, 1, 0)
	Sleep(15)

	p_cis.Make_Ally(p_republic)
	p_republic.Make_Ally(p_cis)

	Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Change_Owner(p_invaders)
	Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Suspend_Locomotor(true)
	Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Prevent_All_Fire(true)
	Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Prevent_Opportunity_Fire(true)

	Set_Cinematic_Camera_Key(republic_fleet_2_marker, 0, 0, -200, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(republic_fleet_2_marker, 0, 0, -200, 0, player_malevolence, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 20, 0, 0, -200, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 20, 0, 0, -200, 0, player_malevolence, 1, 0)
	Sleep(15)

	Set_Cinematic_Camera_Key(intro_1_malevolence_marker, 0, 0, -200, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(intro_1_malevolence_marker, 0, 0, -200, 0, player_malevolence, 1, 0)
	Transition_Cinematic_Camera_Key(intro_1_shadow_squadron_marker, 18, 0, 0, -200, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(intro_1_shadow_squadron_marker, 18, 0, 0, -200, 0, player_malevolence, 1, 0)
	Sleep(18)

	Set_Cinematic_Camera_Key(republic_fleet_3_marker, 0, 0, -200, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(republic_fleet_3_marker, 0, 0, -200, 0, player_malevolence, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_target_3_marker, 15, 0, 0, -200, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_target_3_marker, 15, 0, 0, -200, 0, player_malevolence, 1, 0)
	Sleep(10)

	Fade_Screen_Out(3.0)
	Sleep(5.0)

	if not cinematic_two_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_02_CIS")
	end
end

function Start_Cinematic_Outro_02_CIS()
	Story_Event("SUBJUGATOR_SABOTAGE")

	cinematic_two = false
	cinematic_three = true

	player_anakin = Spawn_Unit(Find_Object_Type("Twilight"), outro_1_twilight_marker, p_republic)
	player_anakin = Find_Nearest(outro_1_twilight_marker, p_republic, true)
	player_anakin.Teleport_And_Face(outro_1_twilight_marker)
	player_anakin.Move_To(player_malevolence)

	Play_Music("Mission_Malevolence_02")
	player_anakin.Play_Animation("Undeploy", false)

	Set_Cinematic_Camera_Key(outro_1_twilight_marker, 800, 200, 155, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outro_1_twilight_marker, 0, 0, 0, 0, player_anakin, 1, 0)
	Transition_Cinematic_Camera_Key(outro_1_twilight_marker, 10, 100, 100, -100, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outro_1_twilight_marker, 10, 0, 0, 0, 0, player_malevolence, 1, 0)
	Fade_Screen_In(0.5)
	Letter_Box_In(0.5)
	Sleep(8)

	player_anakin.Play_Animation("Deploy", false)

	Set_Cinematic_Camera_Key(player_anakin, 0, -50, -700, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(player_anakin, 0, 0, 0, 0, player_anakin, 1, 0)
	Sleep(6)

	Fade_Screen_Out(4)
	Sleep(5)

	Resume_Mode_Based_Music()
	Allow_Localized_SFX(true)
	SFXManager.Allow_HUD_VO(true)
	SFXManager.Allow_Ambient_VO(true)
	SFXManager.Allow_Unit_Reponse_VO(true)
	SFXManager.Allow_Enemy_Sighted_VO(true)
	SFXManager.Allow_Localized_SFXEvents(true)

	player_malevolence.Hyperspace_Away(true)

	if cis_fleet_dead then
		Story_Event("REPUBLIC_VICTORY")
	elseif rep_fleet_dead then
		Story_Event("CIS_VICTORY")
	end
end


function Start_Cinematic_Intro_Rep()
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

	Grievous_Spawning = Find_First_Object("Grievous_Malevolence_Hunt_Campaign")
	if TestValid(Grievous_Spawning) then
		--[[Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Hyperspace_Away(false)

		player_malevolence = Spawn_Unit(Find_Object_Type("Grievous_Malevolence_Hunt_Campaign"), intro_1_malevolence_marker, p_cis)
		player_malevolence = Find_Nearest(intro_1_malevolence_marker, p_cis, true)
		player_malevolence.Teleport_And_Face(intro_1_malevolence_marker)	
		player_malevolence.Cinematic_Hyperspace_In(50)]]
	elseif not TestValid(Grievous_Spawning) then
		Grievous_Spawning = Spawn_From_Reinforcement_Pool(Find_Object_Type("Grievous_Malevolence_Hunt_Campaign"), intro_1_malevolence_marker, p_cis)
		if Grievous_Spawning then
			Grievous_Spawning = Grievous_Spawning[1]
		end
		if not Grievous_Spawning then
			player_malevolence = Spawn_Unit(Find_Object_Type("Grievous_Malevolence_Hunt_Campaign"), intro_1_malevolence_marker, p_cis)
			player_malevolence = Find_Nearest(intro_1_malevolence_marker, p_cis, true)
			player_malevolence.Teleport_And_Face(intro_1_malevolence_marker)	
			player_malevolence.Cinematic_Hyperspace_In(50)
		end
	end

	player_malevolence = Find_First_Object("Grievous_Malevolence_Hunt_Campaign")
	player_malevolence.Teleport_And_Face(intro_1_malevolence_marker)
	player_malevolence.Turn_To_Face(intro_2_malevolence_marker)
	Sleep(0.5)

	cinematic_one = true

	Fade_Screen_In(5)
	Letter_Box_In(3)

	Play_Music("Medical_Madness_01")
	Story_Event("CINEMATIC_CRAWL_01")

	Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 18.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 18.0, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Sleep(3.0)

	Story_Event("CINEMATIC_CRAWL_02")
	Sleep(14.0)

	Transition_Cinematic_Camera_Key(introcam_3_marker, 11.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_3_marker, 11.0, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Sleep(4.0)

	player_malevolence.Move_To(intro_2_malevolence_marker)
	Sleep(7.0)

	Fade_Screen_In(6.0)
	Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_5_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_6_marker, 11.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_6_marker, 11.0, 0, 0, 0, 0, player_malevolence, 1, 0)
	Sleep(9.0)

	player_malevolence.Override_Max_Speed(4.0)

	player_shadow_squadron = Spawn_Unit(Find_Object_Type("Shadow_Squadron"), intro_1_shadow_squadron_marker, p_republic)
	player_shadow_squadron = Find_Nearest(intro_1_shadow_squadron_marker, p_republic, true)
	player_shadow_squadron.Teleport_And_Face(intro_1_shadow_squadron_marker)
	BlockOnCommand(player_shadow_squadron.Cinematic_Hyperspace_In(50))
	player_shadow_squadron.Attack_Move(player_malevolence)
	Sleep(2.0)

	if TestValid(Find_First_Object("BTLB_Y-WING_BROADSIDE")) then
		Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, Find_First_Object("BTLB_Y-WING_BROADSIDE"), 1, 0)
		Transition_Cinematic_Camera_Key(introcam_8_marker, 7.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_8_marker, 7.0, 0, 0, 0, 0, Find_First_Object("BTLB_Y-WING_BROADSIDE"), 1, 0)
	else
		Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_8_marker, 7.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_8_marker, 7.0, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
	end
	Sleep(5)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Rep")
	end
end

function End_Cinematic_Intro_Rep()
	Allow_Localized_SFX(true)
	SFXManager.Allow_HUD_VO(true)
	SFXManager.Allow_Ambient_VO(true)
	SFXManager.Allow_Enemy_Sighted_VO(true)
	SFXManager.Allow_Unit_Reponse_VO(true)

	Find_First_Object("KALIIDA_SHOALS_MEDCENTER").Despawn()

	Point_Camera_At(player_malevolence)
	Transition_To_Tactical_Camera(3)
	Letter_Box_Out(3)
	Sleep(3.0)
	End_Cinematic_Camera()
	Lock_Controls(0)
	Suspend_AI(0)

	Story_Event("GOAL_TRIGGER_REP_I")

	cinematic_one = false
	act_1_active = true
	Sleep(13.0)

	Resume_Mode_Based_Music()
end

function Start_Cinematic_Outro_01_Rep()
	act_1_active = false
	cinematic_two = true

	Start_Cinematic_Camera()
	Stop_All_Music()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()

	Allow_Localized_SFX(false)
	SFXManager.Allow_HUD_VO(false)
	SFXManager.Allow_Ambient_VO(false)
	SFXManager.Allow_Enemy_Sighted_VO(false)
	SFXManager.Allow_Unit_Reponse_VO(false)
	SFXManager.Allow_Localized_SFXEvents(false)

	hero_list_01 = Find_All_Objects_Of_Type("SpaceHero")
	for h, hero01 in pairs(hero_list_01) do
		if TestValid(hero01) then
			hero01.Make_Invulnerable(true)
		end
	end

	Fade_On()
	Play_Music("Mission_Malevolence_01")
	Sleep(1)

	Letter_Box_In(1)
	Fade_Screen_In(2)

	Set_Cinematic_Camera_Key(player_malevolence, 2800, -200, 155, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(player_malevolence, 0, 0, -200, 0, 0, 0, 0)
	Transition_Cinematic_Target_Key(player_malevolence, 20, 0, -1000, -200, 0, player_malevolence, 1, 0)
	Transition_Cinematic_Target_Key(player_malevolence, 20, 0, -1000, -200, 0, player_malevolence, 1, 0)
	Sleep(15)

	p_cis.Make_Ally(p_republic)
	p_republic.Make_Ally(p_cis)

	Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Change_Owner(p_invaders)
	Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Suspend_Locomotor(true)
	Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Prevent_All_Fire(true)
	Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Prevent_Opportunity_Fire(true)

	Set_Cinematic_Camera_Key(republic_fleet_2_marker, 0, 0, -200, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(republic_fleet_2_marker, 0, 0, -200, 0, player_malevolence, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 20, 0, 0, -200, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 20, 0, 0, -200, 0, player_malevolence, 1, 0)
	Sleep(15)

	Set_Cinematic_Camera_Key(intro_1_malevolence_marker, 0, 0, -200, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(intro_1_malevolence_marker, 0, 0, -200, 0, player_malevolence, 1, 0)
	Transition_Cinematic_Camera_Key(intro_1_shadow_squadron_marker, 18, 0, 0, -200, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(intro_1_shadow_squadron_marker, 18, 0, 0, -200, 0, player_malevolence, 1, 0)
	Sleep(18)

	Set_Cinematic_Camera_Key(republic_fleet_3_marker, 0, 0, -200, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(republic_fleet_3_marker, 0, 0, -200, 0, player_malevolence, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_target_3_marker, 15, 0, 0, -200, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_target_3_marker, 15, 0, 0, -200, 0, player_malevolence, 1, 0)
	Sleep(10)

	Fade_Screen_Out(3.0)
	Sleep(5.0)

	if not cinematic_two_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_02_Rep")
	end
end

function Start_Cinematic_Outro_02_Rep()
	Story_Event("SUBJUGATOR_SABOTAGE")

	cinematic_two = false
	cinematic_three = true

	player_anakin = Spawn_Unit(Find_Object_Type("Twilight"), outro_1_twilight_marker, p_republic)
	player_anakin = Find_Nearest(outro_1_twilight_marker, p_republic, true)
	player_anakin.Teleport_And_Face(outro_1_twilight_marker)
	player_anakin.Move_To(player_malevolence)

	Play_Music("Mission_Malevolence_02")
	player_anakin.Play_Animation("Undeploy", false)

	Set_Cinematic_Camera_Key(outro_1_twilight_marker, 800, 200, 155, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outro_1_twilight_marker, 0, 0, 0, 0, player_anakin, 1, 0)
	Transition_Cinematic_Camera_Key(outro_1_twilight_marker, 10, 100, 100, -100, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outro_1_twilight_marker, 10, 0, 0, 0, 0, player_malevolence, 1, 0)
	Fade_Screen_In(0.5)
	Letter_Box_In(0.5)
	Sleep(8)

	player_anakin.Play_Animation("Deploy", false)

	Set_Cinematic_Camera_Key(player_anakin, 0, -50, -700, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(player_anakin, 0, 0, 0, 0, player_anakin, 1, 0)
	Sleep(6)

	Fade_Screen_Out(4)
	Sleep(5)

	Resume_Mode_Based_Music()
	Allow_Localized_SFX(true)
	SFXManager.Allow_HUD_VO(true)
	SFXManager.Allow_Ambient_VO(true)
	SFXManager.Allow_Unit_Reponse_VO(true)
	SFXManager.Allow_Enemy_Sighted_VO(true)
	SFXManager.Allow_Localized_SFXEvents(true)

	player_malevolence.Hyperspace_Away(true)

	if cis_fleet_dead then
		Story_Event("REPUBLIC_VICTORY")
	elseif rep_fleet_dead then
		Story_Event("CIS_VICTORY")
	end
end
