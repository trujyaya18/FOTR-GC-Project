
--*****************************************************--
--********* Foerost Campaign: Foerost Fallen **********--
--*****************************************************--

require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")
require("PGStateMachine")

function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))

	StoryModeEvents =
	{
		Battle_Start = Begin_Battle,
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_hostile = Find_Player("Hostile")

	camera_offset = 125
	mission_started = false

	cinematic_crawl = false
	act_1_active = false

	treetor_dead = false

	cinematic_one = false
	cinematic_crawl_skipped = false
	cinematic_one_skipped = false

	current_cinematic_thread_id = nil

end

function Begin_Battle(message)
	if message == OnEnter then
		p_republic.Make_Ally(p_cis)
		p_cis.Make_Ally(p_republic)

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

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")
		introcam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")

		intro_praetor_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-praetor")
--		intro_tagge_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-tagge")
--		intro_invincible_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-invincible")

		player_treetor = Find_First_Object("TREETOR_CAPTOR")
		Find_First_Object("TREETOR_CAPTOR").Set_Cannot_Be_Killed(true)

		mission_started = true

		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Crawl_Rep")
	end
end


function Story_Handle_Esc()
	if mission_started then
		if p_republic.Is_Human() then
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
					Weather_Audio_Pause(false)
					Set_Cinematic_Environment(false)
					Allow_Localized_SFX(true)
					SFXManager.Allow_HUD_VO(true)
					SFXManager.Allow_Ambient_VO(true)
					SFXManager.Allow_Enemy_Sighted_VO(true)
					SFXManager.Allow_Unit_Reponse_VO(true)

					cinematic_crawl = false
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
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

					if not TestValid(player_praetor_01) then
						player_praetor_01 = Spawn_Unit(Find_Object_Type("Generic_Praetor"), intro_praetor_marker, p_republic)
						player_praetor_01 = Find_Nearest(intro_praetor_marker, p_republic, true)
						player_praetor_01.Teleport_And_Face(intro_praetor_marker)
					end

--					if not TestValid(player_praetor_02) then
--						player_praetor_02 = Spawn_Unit(Find_Object_Type("Generic_Tagge_Battlecruiser"), intro_tagge_marker, p_republic)
--						player_praetor_02 = Find_Nearest(intro_tagge_marker, p_republic, true)
--						player_praetor_02.Teleport_And_Face(intro_tagge_marker)
--					end

--					if not TestValid(player_praetor_03) then
--						player_praetor_03 = Spawn_Unit(Find_Object_Type("Invincible_Cruiser"), intro_invincible_marker, p_republic)
--						player_praetor_03 = Find_Nearest(intro_invincible_marker, p_republic, true)
--						player_praetor_03.Teleport_And_Face(intro_invincible_marker)
--					end

					container_list = Find_All_Objects_Of_Type("ORBITAL_RESOURCE_CONTAINER")
					for k,player_container in pairs(container_list) do
						if TestValid(player_container) then
							player_container.Change_Owner(p_hostile)
						end
					end

					Letter_Box_Out(0)
					Point_Camera_At(player_praetor_01)
					Story_Event("GOAL_TRIGGER_REP_I")
					Story_Event("ACTIVATE_CIS_AI")
					Lock_Controls(0)
					Suspend_AI(0)
					End_Cinematic_Camera()

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
end

function Story_Mode_Service()
	if p_republic.Is_Human() then
		if not treetor_dead then
			if Find_First_Object("TREETOR_CAPTOR").Get_Hull() <= 0.10 then
				Find_First_Object("TREETOR_CAPTOR").Hyperspace_Away(true)
				Story_Event("TREETOR_RETREAT")
				treetor_dead = true
			end
		end
	end
end


function Start_Cinematic_Crawl_Rep()
	Start_Cinematic_Camera()
	Stop_All_Music()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()
	Fade_On()

	Set_Cinematic_Environment(true)
	Weather_Audio_Pause(true)
	Allow_Localized_SFX(false)
	SFXManager.Allow_HUD_VO(false)
	SFXManager.Allow_Ambient_VO(false)
	SFXManager.Allow_Enemy_Sighted_VO(false)
	SFXManager.Allow_Unit_Reponse_VO(false)

	Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)

	Fade_Screen_In(1)

	cinematic_crawl = true
	BlockOnCommand(Play_Bink_Movie("A_Long_Time_Ago_Campaign_Intro"))

	-- MessageBox("Bink Movie done")
	Play_Music("Clone_Wars_Crawl_Theme")

	-- MessageBox("Starting Bink Movie!!!")
	BlockOnCommand(Play_Bink_Movie("Foerost_Campaign_Rep_Intro"))

	Weather_Audio_Pause(false)
	Set_Cinematic_Environment(false)
	Allow_Localized_SFX(true)
	SFXManager.Allow_HUD_VO(true)
	SFXManager.Allow_Ambient_VO(true)
	SFXManager.Allow_Enemy_Sighted_VO(true)
	SFXManager.Allow_Unit_Reponse_VO(true)

	if not cinematic_crawl_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
	end
end

function Start_Cinematic_Intro_Rep()
	cinematic_crawl = false
	cinematic_one = true

	Transition_Cinematic_Camera_Key(introcam_2_marker, 22.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 22.0, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Letter_Box_In(1.0)

	Play_Music("Foerost_Fallen_01")
	Story_Event("CINEMATIC_CRAWL_01")
	Sleep(3.0)
	
	rep_tagge_list = Find_All_Objects_Of_Type(p_republic, "GENERIC_TAGGE_BATTLECRUISER")
	for k,player_tagge in pairs(rep_tagge_list) do
		if TestValid(player_tagge) then
			player_tagge.Cinematic_Hyperspace_In(1000)
		end
	end
	
	rep_acc_list = Find_All_Objects_Of_Type(p_republic, "GENERIC_ACCLAMATOR_ASSAULT_SHIP_LEVELER")
	for k,player_acc in pairs(rep_acc_list) do
		if TestValid(player_acc) then
			player_acc.Cinematic_Hyperspace_In(600)
		end
	end
	
	rep_lac_list = Find_All_Objects_Of_Type(p_republic, "LAC")
	for k,player_lac in pairs(rep_lac_list) do
		if TestValid(player_lac) then
			player_lac.Cinematic_Hyperspace_In(750)
		end
	end
	
	rep_dhc_list = Find_All_Objects_Of_Type(p_republic, "DREADNAUGHT_LASERS")
	for k,player_dhc in pairs(rep_dhc_list) do
		if TestValid(player_dhc) then
			player_dhc.Cinematic_Hyperspace_In(650)
		end
	end
	
	rep_galleon_list = Find_All_Objects_Of_Type(p_republic, "GALLEON")
	for k,player_galleon in pairs(rep_galleon_list) do
		if TestValid(player_galleon) then
			player_galleon.Cinematic_Hyperspace_In(700)
		end
	end
	
	rep_invincible_list = Find_All_Objects_Of_Type(p_republic, "INVINCIBLE_CRUISER")
	for k,player_invincible in pairs(rep_invincible_list) do
		if TestValid(player_invincible) then
			player_invincible.Cinematic_Hyperspace_In(1300)
		end
	end

	Story_Event("CINEMATIC_CRAWL_02")
	Sleep(8.0)

	Transition_Cinematic_Camera_Key(introcam_2_marker, 11.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 11.0, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	
	player_praetor_01 = Spawn_Unit(Find_Object_Type("Generic_Praetor"), intro_praetor_marker, p_republic)
	player_praetor_01 = Find_Nearest(intro_praetor_marker, p_republic, true)
	player_praetor_01.Teleport_And_Face(intro_praetor_marker)
	player_praetor_01.Cinematic_Hyperspace_In(50)

	Sleep(3.0)
	
	Story_Event("MARTIAL_LAW_01")
	Sleep(7.5)

	Story_Event("MARTIAL_LAW_02")
	Story_Event("MARTIAL_LAW_03")
	Sleep(2.0)

	Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_4_marker, 13.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_4_marker, 13.5, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Sleep(10.0)

	Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_5_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_6_marker, 16.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_6_marker, 16.5, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Story_Event("MARTIAL_LAW_04")
	Story_Event("MARTIAL_LAW_05")
	Sleep(12.5)

	Story_Event("MARTIAL_LAW_06")
	Sleep(7.5)

	Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_8_marker, 15.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_8_marker, 15.5, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Story_Event("MARTIAL_LAW_07")
	Story_Event("MARTIAL_LAW_08")
	Sleep(10.5)

	Set_Cinematic_Camera_Key(introcam_9_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_9_marker, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_10_marker, 15.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_10_marker, 15.5, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Story_Event("MARTIAL_LAW_09")
	Story_Event("MARTIAL_LAW_10")
	Sleep(10.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Rep")
	end
end

function End_Cinematic_Intro_Rep()
	Point_Camera_At(player_praetor_01)
	Resume_Mode_Based_Music()
	Transition_To_Tactical_Camera(5)
	Letter_Box_Out(5)
	Fade_Screen_In(.1)
	Sleep(5.0)
	End_Cinematic_Camera()
	Suspend_AI(0)
	Lock_Controls(0)

	Story_Event("ACTIVATE_CIS_AI")
	Story_Event("GOAL_TRIGGER_REP_I")

	p_republic.Make_Enemy(p_cis)
	p_cis.Make_Enemy(p_republic)

	cinematic_one = false
	act_1_active = true

	Sleep(10.0)
	container_list = Find_All_Objects_Of_Type("ORBITAL_RESOURCE_CONTAINER")
	for k,player_container in pairs(container_list) do
		if TestValid(player_container) then
			player_container.Change_Owner(p_hostile)
		end
	end
end
