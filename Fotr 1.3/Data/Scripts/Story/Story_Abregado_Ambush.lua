
--*****************************************************--
--***** Hunt for the Malevolence: Abregado Ambush *****--
--*****************************************************--

require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")
require("PGCommands")
require("TRCommands")
require("eawx-util/StoryUtil")
require("deepcore/std/class")

function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))

	StoryModeEvents =
	{
		Battle_Start = Begin_Battle,
		They_Fly_Now_Start_01 = They_Fly_Now_01,
		They_Fly_Now_Start_02 = They_Fly_Now_02,
		They_Fly_Now_Start_03 = They_Fly_Now_03,
		They_Fly_Now_Start_04 = They_Fly_Now_04,
		Trigger_Phase_One = State_Phase_One,
		Trigger_Phase_Two = State_Phase_Two,
		Trigger_Phase_Three = State_Phase_Three,
		Trigger_Plo_Death = State_Plo_Death,
		Trigger_Pods_Death = State_Pods_Death,
		Trigger_Escape_Reached = State_Escape_Reached,
	}

	venator_list = {
		"Generic_Venator"
	}

	twilight_list = {
		"Twilight"
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")
	p_neutral = Find_Player("Neutral")

	camera_offset = 125
	mission_started = false

	player_plo = nil
	venator_1 = nil
	venator_2 = nil

	act_1_active = false
	act_2_active = false
	act_3_active = false

	cinematic_crawl = false
	cinematic_one = false
	cinematic_two = false
	cinematic_three = false
	cinematic_four = false

	cinematic_crawl_skipped = false
	cinematic_one_skipped = false
	cinematic_two_skipped = false
	cinematic_three_skipped = false
	cinematic_four_skipped = false

	current_cinematic_thread_id = nil

	playing_hard = false

	pods_rescued = 0
	pods_killed = 0

	pod_plo_spawned = false
	pod_plo_rescued = false

	pod_1_killed = false
	pod_2_killed = false
	pod_3_killed = false
	pod_4_killed = false
	pod_5_killed = false
	pod_plo_killed = false

	last_scene = false

	notice_range = 600

end

function Begin_Battle(message)
	if message == OnEnter then

		GlobalValue.Set("HfM_Plo_Rescued", 0)
		GlobalValue.Set("Saved_Escape_Pods_Counter", 0)
		intro_malevolence_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intromalevolence")

		venator_plo_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "venatorplo")
		venator_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "venator1")
		venator_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "venator2")

		player_plo = Find_Hint("GENERIC_VENATOR", "venatorplo")
		venator_1 = Find_Hint("GENERIC_VENATOR", "venator1")
		venator_2 = Find_Hint("GENERIC_VENATOR", "venator2")

		player_plo_intro = Find_Hint("SKIRMISH_VENATOR", "venatorplointro")
		venator_1_intro = Find_Hint("SKIRMISH_VENATOR", "venator1intro")
		venator_2_intro = Find_Hint("SKIRMISH_VENATOR", "venator2intro")

		player_intro_malevolence = Find_Hint("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN", "malevolence")

		twilight_move_to = Find_Hint("STORY_TRIGGER_ZONE_00", "twilightmoveto")
		venator_plo_move_to = Find_Hint("STORY_TRIGGER_ZONE_00", "venatorplomoveto")
		venator_1_move_to = Find_Hint("STORY_TRIGGER_ZONE_00", "venator1moveto")
		venator_2_move_to = Find_Hint("STORY_TRIGGER_ZONE_00", "venator2moveto")
		malevolence_move_to = Find_Hint("STORY_TRIGGER_ZONE_00", "malevolencemoveto")

		introcam_target_malevolence_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtargetmalevolence")
		introcam_target_venator_plo_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtargetvenatorplo")
		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget1")

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam4")
		introcam_4a_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam4a")
		introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam5")
		introcam_5a_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam5a")
		introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam6")
		introcam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam7")
		introcam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam8")

		twilight_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "twilight")
		midtro_1_malevolence_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtromalevolence1")
		midtro_2_malevolence_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtromalevolence2")
		midtrocam_target_malevolence_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocamtargetmalevolence")

		midtrocam_target_twilight_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocamtargettwilight")

		midtrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam1")
		midtrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam2")
		midtrocam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam3")
		midtrocam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam4")
		midtrocam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam5")
		midtrocam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam6")

		pod_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "pod1")
		pod_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "pod2")
		pod_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "pod3")
		pod_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "pod4")
		pod_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "pod5")
		pod_plo_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "podplo")

		hunter_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "hunter1")
		hunter_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "hunter2")
		hunter_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "hunter3")

		droch_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "droch")
		drochcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "drochcam1")
		drochcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "drochcam2")
		drochcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "drochcam3")
		drochcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "drochcam4")

		droch_twilight_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "drochtwilight")
		droch_twilight_move_to_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "drochtwilightmoveto")

		escape_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "escape")
		outro_twilight_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrotwilight")
		outro_malevolence_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outromalevolence")

		outrocam_target_malevolence_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocamtargetmalevolence")

		outrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam1")
		outrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam2")
		outrocam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam3")

		p_republic.Make_Ally(p_cis)
		p_cis.Make_Ally(p_republic)

		plo_hide_table = Find_All_Objects_Of_Type("GENERIC_VENATOR")
		for y,plohiding in pairs(plo_hide_table) do
			if TestValid(plohiding) then
				Hide_Object(plohiding, 1)
			end	
		end

		junk_list_01 = Find_All_Objects_Of_Type("SPACE_JUNK_LARGE")
		for h,junks1 in pairs(junk_list_01) do
			if TestValid(junks1) then
				Hide_Object(junks1, 1)
			end	
		end

		junk_list_02 = Find_All_Objects_Of_Type("SPACE_JUNK_HUGE")
		for i,junks2 in pairs(junk_list_02) do
			if TestValid(junks2) then
				Hide_Object(junks2, 1)
			end	
		end

		if p_republic.Is_Human() then
			mission_started = true
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Crawl_Rep")
		elseif p_cis.Is_Human() then
			mission_started = true
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Crawl_CIS")
		end

	end
end


function State_Phase_One(message)
	if message == OnEnter then
		if mission_started then
			pod_1 = Spawn_Unit(Find_Object_Type("Republic_Escape_Pod"), pod_1_marker, p_republic)
			pod_1 = Find_Nearest(pod_1_marker, p_republic, true)
			pod_1.Teleport_And_Face(pod_1_marker)
			pod_1.Highlight(true)
			Add_Radar_Blip(pod_1, "pod_1_blip")
			Register_Prox(pod_1, Prox_Pod_1_Found, 300)

			pod_2 = Spawn_Unit(Find_Object_Type("Republic_Escape_Pod"), pod_2_marker, p_republic)
			pod_2 = Find_Nearest(pod_2_marker, p_republic, true)
			pod_2.Teleport_And_Face(pod_2_marker)
			pod_2.Highlight(true)
			Add_Radar_Blip(pod_2, "pod_2_blip")
			Register_Prox(pod_2, Prox_Pod_2_Found, 300)

			pod_3 = Spawn_Unit(Find_Object_Type("Republic_Escape_Pod"), pod_3_marker, p_republic)
			pod_3 = Find_Nearest(pod_3_marker, p_republic, true)
			pod_3.Teleport_And_Face(pod_3_marker)
			pod_3.Highlight(true)
			Add_Radar_Blip(pod_3, "pod_3_blip")
			Register_Prox(pod_3, Prox_Pod_3_Found, 300)

			pod_4 = Spawn_Unit(Find_Object_Type("Republic_Escape_Pod"), pod_4_marker, p_republic)
			pod_4 = Find_Nearest(pod_4_marker, p_republic, true)
			pod_4.Teleport_And_Face(pod_4_marker)
			pod_4.Highlight(true)
			Add_Radar_Blip(pod_4, "pod_4_blip")
			Register_Prox(pod_4, Prox_Pod_4_Found, 300)

			pod_5 = Spawn_Unit(Find_Object_Type("Republic_Escape_Pod"), pod_5_marker, p_republic)
			pod_5 = Find_Nearest(pod_5_marker, p_republic, true)
			pod_5.Teleport_And_Face(pod_5_marker)
			pod_5.Highlight(true)
			Add_Radar_Blip(pod_5, "pod_5_blip")
			Register_Prox(pod_5, Prox_Pod_5_Found, 300)
		end
	end
end

function State_Phase_Two(message)
	if message == OnEnter then
		if mission_started then
			if p_republic.Is_Human() then
				player_hunter_11 = Spawn_Unit(Find_Object_Type("Droch_Boarding_Ship"), hunter_1_marker, p_cis)
				player_hunter_11 = Find_Nearest(hunter_1_marker, p_cis, true)
				player_hunter_11.Teleport_And_Face(hunter_1_marker)
				player_hunter_11.Override_Max_Speed(5)

				player_hunter_12 = Spawn_Unit(Find_Object_Type("Droch_Boarding_Ship"), hunter_1_marker, p_cis)
				player_hunter_12 = Find_Nearest(hunter_1_marker, p_cis, true)
				player_hunter_12.Teleport_And_Face(hunter_1_marker)
				player_hunter_12.Override_Max_Speed(5)

				player_hunter_13 = Spawn_Unit(Find_Object_Type("Droch_Boarding_Ship"), hunter_1_marker, p_cis)
				player_hunter_13 = Find_Nearest(hunter_1_marker, p_cis, true)
				player_hunter_13.Teleport_And_Face(hunter_1_marker)
				player_hunter_13.Override_Max_Speed(5)

				player_hunter_14 = Spawn_Unit(Find_Object_Type("Droch_Boarding_Ship"), hunter_1_marker, p_cis)
				player_hunter_14 = Find_Nearest(hunter_1_marker, p_cis, true)
				player_hunter_14.Teleport_And_Face(hunter_1_marker)
				player_hunter_14.Override_Max_Speed(5)

				player_hunter_2 = Spawn_Unit(Find_Object_Type("Droch_Boarding_Ship"), hunter_2_marker, p_cis)
				player_hunter_2 = Find_Nearest(hunter_2_marker, p_cis, true)
				player_hunter_2.Teleport_And_Face(hunter_2_marker)
				player_hunter_2.Override_Max_Speed(5)

				player_hunter_3 = Spawn_Unit(Find_Object_Type("Droch_Boarding_Ship"), hunter_3_marker, p_cis)
				player_hunter_3 = Find_Nearest(hunter_3_marker, p_cis, true)
				player_hunter_3.Teleport_And_Face(hunter_3_marker)
				player_hunter_3.Override_Max_Speed(5)
			elseif p_cis.Is_Human() then
				player_hunter_11 = Spawn_Unit(Find_Object_Type("Droch_Boarding_Ship"), hunter_1_marker, p_cis)
				player_hunter_11 = Find_Nearest(hunter_1_marker, p_cis, true)
				player_hunter_11.Teleport_And_Face(hunter_1_marker)
				player_hunter_11.Override_Max_Speed(7)

				player_hunter_12 = Spawn_Unit(Find_Object_Type("Droch_Boarding_Ship"), hunter_1_marker, p_cis)
				player_hunter_12 = Find_Nearest(hunter_1_marker, p_cis, true)
				player_hunter_12.Teleport_And_Face(hunter_1_marker)
				player_hunter_12.Override_Max_Speed(7)

				player_hunter_13 = Spawn_Unit(Find_Object_Type("Droch_Boarding_Ship"), hunter_1_marker, p_cis)
				player_hunter_13 = Find_Nearest(hunter_1_marker, p_cis, true)
				player_hunter_13.Teleport_And_Face(hunter_1_marker)
				player_hunter_13.Override_Max_Speed(7)

				player_hunter_14 = Spawn_Unit(Find_Object_Type("Droch_Boarding_Ship"), hunter_1_marker, p_cis)
				player_hunter_14 = Find_Nearest(hunter_1_marker, p_cis, true)
				player_hunter_14.Teleport_And_Face(hunter_1_marker)
				player_hunter_14.Override_Max_Speed(7)

				player_hunter_2 = Spawn_Unit(Find_Object_Type("Droch_Boarding_Ship"), hunter_1_marker, p_cis)
				player_hunter_2 = Find_Nearest(hunter_1_marker, p_cis, true)
				player_hunter_2.Teleport_And_Face(hunter_1_marker)
				player_hunter_2.Override_Max_Speed(7)

				player_hunter_3 = Spawn_Unit(Find_Object_Type("Droch_Boarding_Ship"), hunter_1_marker, p_cis)
				player_hunter_3 = Find_Nearest(hunter_1_marker, p_cis, true)
				player_hunter_3.Teleport_And_Face(hunter_1_marker)
				player_hunter_3.Override_Max_Speed(7)
			end
		end
	end
end

function State_Phase_Three(message)
	if message == OnEnter then
		if mission_started then
			player_midtro_malevolence = Spawn_Unit(Find_Object_Type("Grievous_Malevolence_Hunt_Campaign"), midtro_2_malevolence_marker, p_cis)
			player_midtro_malevolence = Find_Nearest(midtro_2_malevolence_marker, p_cis, true)
			player_midtro_malevolence.Teleport_And_Face(midtro_2_malevolence_marker)
			player_midtro_malevolence.Cinematic_Hyperspace_In(50)
			player_midtro_malevolence.Attack_Move(player_twilight)
		end
	end
end


function State_Plo_Death(message)
	if message == OnEnter then
		if p_republic.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_Rep")
		elseif p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_CIS")
		end
	end
end

function State_Pods_Death(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_02_CIS")
		end
	end
end

function Prox_Pod_1_Found(prox_obj, trigger_obj)
	if trigger_obj == player_twilight then
		prox_obj.Cancel_Event_Object_In_Range(Prox_Pod_1_Found)
		Create_Thread("Handle_Pods_Rescue_Thread", prox_obj)
	elseif trigger_obj.Get_Owner() == p_cis then
		prox_obj.Cancel_Event_Object_In_Range(Prox_Pod_1_Found)
		pod_1_killed = true
		Create_Thread("Handle_Pods_Destruction_Thread", prox_obj)
	end
end

function Prox_Pod_2_Found(prox_obj, trigger_obj)
	if trigger_obj == player_twilight then
		prox_obj.Cancel_Event_Object_In_Range(Prox_Pod_2_Found)
		Create_Thread("Handle_Pods_Rescue_Thread", prox_obj)
	elseif trigger_obj.Get_Owner() == p_cis then
		prox_obj.Cancel_Event_Object_In_Range(Prox_Pod_2_Found)
		pod_2_killed = true
		Create_Thread("Handle_Pods_Destruction_Thread", prox_obj)
	end
end

function Prox_Pod_3_Found(prox_obj, trigger_obj)
	if trigger_obj == player_twilight then
		prox_obj.Cancel_Event_Object_In_Range(Prox_Pod_3_Found)
		Create_Thread("Handle_Pods_Rescue_Thread", prox_obj)
	elseif trigger_obj.Get_Owner() == p_cis then
		prox_obj.Cancel_Event_Object_In_Range(Prox_Pod_3_Found)
		pod_3_killed = true
		Create_Thread("Handle_Pods_Destruction_Thread", prox_obj)
	end
end

function Prox_Pod_4_Found(prox_obj, trigger_obj)
	if trigger_obj == player_twilight then
		prox_obj.Cancel_Event_Object_In_Range(Prox_Pod_4_Found)
		Create_Thread("Handle_Pods_Rescue_Thread", prox_obj)
	elseif trigger_obj.Get_Owner() == p_cis then
		prox_obj.Cancel_Event_Object_In_Range(Prox_Pod_4_Found)
		pod_4_killed = true
		Create_Thread("Handle_Pods_Destruction_Thread", prox_obj)
	end
end

function Prox_Pod_5_Found(prox_obj, trigger_obj)
	if trigger_obj == player_twilight then
		prox_obj.Cancel_Event_Object_In_Range(Prox_Pod_5_Found)
		Create_Thread("Handle_Pods_Rescue_Thread", prox_obj)
	elseif trigger_obj.Get_Owner() == p_cis then
		prox_obj.Cancel_Event_Object_In_Range(Prox_Pod_5_Found)
		pod_5_killed = true
		Create_Thread("Handle_Pods_Destruction_Thread", prox_obj)
	end
end

function Handle_Pods_Rescue_Thread(pod_obj)

	pods_rescued = pods_rescued + 1	

	if pods_rescued == 1 then
		Story_Event("1_POD_RESCUED")
		GlobalValue.Set("Saved_Escape_Pods_Counter", 2)
	elseif pods_rescued == 2 then
		Story_Event("2_POD_RESCUED")
		GlobalValue.Set("Saved_Escape_Pods_Counter", 4)
	elseif pods_rescued == 3 then
		Story_Event("3_POD_RESCUED")
		GlobalValue.Set("Saved_Escape_Pods_Counter", 6)
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_02_Rep")
	elseif pods_rescued == 4 then
		Story_Event("4_POD_RESCUED")
		GlobalValue.Set("Saved_Escape_Pods_Counter", 8)
	elseif pods_rescued == 5 then
		Story_Event("5_POD_RESCUED")
		GlobalValue.Set("Saved_Escape_Pods_Counter", 10)
	end

	pod_obj.Highlight(false)
	pod_obj.Make_Invulnerable(true)
	pod_obj.Prevent_AI_Usage(true)
	pod_obj.Prevent_All_Fire(true)

	pod_obj.Attach_Particle_Effect("Rescue_Effect")
	Sleep(1)

	pod_obj.Despawn()

end

function Handle_Pods_Destruction_Thread(pod_obj)

	pods_killed = pods_killed + 1	

	if pods_killed == 1 then
		Story_Event("1_POD_KILLED")
	elseif pods_killed == 2 then
		Story_Event("2_POD_KILLED")
	elseif pods_killed == 3 then
		Story_Event("3_POD_KILLED")
	elseif pods_killed == 4 then
		Story_Event("4_POD_KILLED")
	elseif pods_killed == 5 then
		Story_Event("5_POD_KILLED") 
	end

	pod_obj.Highlight(false)
	pod_obj.Make_Invulnerable(true)
	pod_obj.Prevent_AI_Usage(true)
	pod_obj.Prevent_All_Fire(true)

	pod_obj.Attach_Particle_Effect("Small_Explosion_Space")
	Sleep(1)

	pod_obj.Despawn()

end

function State_Escape_Reached(message)
	if message == OnEnter then
		if p_republic.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
		elseif p_cis.Is_Human() then
			if TestValid(player_twilight) then
				player_twilight.Unlock_Current_Orders()
			end
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")
		end
	end
end

function f_Prox_Escape(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj == player_twilight then
			prox_obj.Cancel_Event_Object_In_Range(f_Prox_Escape)

			if TestValid(player_twilight) then
				player_twilight.Unlock_Current_Orders()
			end
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")
		end
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

					if TestValid(player_plo_intro) then
						player_plo_intro.Despawn()
					end

					if TestValid(venator_1_intro) then
						venator_1_intro.Despawn()
					end

					if TestValid(venator_2_intro) then
						venator_2_intro.Despawn()
					end

					if not TestValid(player_plo) then
						p_republic = Find_Player("Empire")
						player_plo = Spawn_Unit(Find_Object_Type("Generic_Venator"), venator_plo_move_to, p_republic)
						player_plo = Find_Nearest(venator_plo_move_to, p_republic, true)
						player_plo.Teleport_And_Face(venator_plo_move_to)
					else
						player_plo.Despawn()
						player_plo = Spawn_Unit(Find_Object_Type("Generic_Venator"), venator_plo_move_to, p_republic)
						player_plo = Find_Nearest(venator_plo_move_to, p_republic, true)
						player_plo.Teleport_And_Face(venator_plo_move_to)
						player_plo.Cinematic_Hyperspace_In(1)
					end

					if not TestValid(venator_1) then
						p_republic = Find_Player("Empire")
						venator_1 = Spawn_Unit(Find_Object_Type("Generic_Venator"), venator_1_move_to, p_republic)
						venator_1 = Find_Nearest(venator_1_move_to, p_republic, true)
						venator_1.Teleport_And_Face(venator_1_move_to)
					else
						venator_1.Despawn()
						venator_1 = Spawn_Unit(Find_Object_Type("Generic_Venator"), venator_1_move_to, p_republic)
						venator_1 = Find_Nearest(venator_1_move_to, p_republic, true)
						venator_1.Teleport_And_Face(venator_1_move_to)
						venator_1.Cinematic_Hyperspace_In(1)
					end

					if not TestValid(venator_2) then
						p_republic = Find_Player("Empire")
						venator_2 = Spawn_Unit(Find_Object_Type("Generic_Venator"), venator_2_move_to, p_republic)
						venator_2 = Find_Nearest(venator_2_move_to, p_republic, true)
						venator_2.Teleport_And_Face(venator_2_move_to)
					else
						venator_2.Despawn()
						venator_2 = Spawn_Unit(Find_Object_Type("Generic_Venator"), venator_2_move_to, p_republic)
						venator_2 = Find_Nearest(venator_2_move_to, p_republic, true)
						venator_2.Teleport_And_Face(venator_2_move_to)
						venator_2.Cinematic_Hyperspace_In(1)
					end

					if not TestValid(player_intro_malevolence) then
						p_cis = Find_Player("Rebel")
						player_intro_malevolence = Spawn_Unit(Find_Object_Type("Grievous_Malevolence_Hunt_Campaign"), intro_malevolence_marker, p_cis)
						player_intro_malevolence = Find_Nearest(intro_malevolence_marker, "Grievous_Malevolence_Hunt_Campaign", true)
						player_intro_malevolence.Teleport_And_Face(intro_malevolence_marker)
					end

					rep_fighters = Find_All_Objects_Of_Type(p_republic, "Fighter | Bomber")
					for _,repfighters in pairs(rep_fighters) do
						if TestValid(repfighters) then
							repfighters.Despawn()
						end
					end

					Allow_Localized_SFX(true)
					SFXManager.Allow_HUD_VO(true)
					SFXManager.Allow_Ambient_VO(true)
					SFXManager.Allow_Enemy_Sighted_VO(true)
					SFXManager.Allow_Unit_Reponse_VO(true)
					Resume_Mode_Based_Music()

					Letter_Box_Out(0)
					Point_Camera_At(venator_plo_move_to)
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

					junk_list_05 = Find_All_Objects_Of_Type("SPACE_JUNK_LARGE")
					for x,junks5 in pairs(junk_list_05) do
						if TestValid(junks5) then
							Hide_Object(junks5, 0)
						end
					end

					junk_list_06 = Find_All_Objects_Of_Type("SPACE_JUNK_HUGE")
					for s,junks6 in pairs(junk_list_06) do
						if TestValid(junks6) then
							Hide_Object(junks6, 0)
						end
					end

					republic_unit_list_skip = Find_All_Objects_Of_Type(p_republic)
					for g,repunitsskip in pairs(republic_unit_list_skip) do
						if TestValid(repunitsskip) then
							repunitsskip.Despawn()
						end
					end

					cis_unit_list_skip = Find_All_Objects_Of_Type(p_cis)
					for u,skippies in pairs(cis_unit_list_skip) do
						if TestValid(skippies) then
							skippies.Despawn()
						end
					end

					if not TestValid(player_twilight) then
						player_twilight = Spawn_Unit(Find_Object_Type("Twilight"), twilight_marker, p_republic)
						player_twilight = Find_Nearest(twilight_marker, p_republic, true)
						player_twilight.Teleport_And_Face(twilight_marker)
						player_twilight.Override_Max_Speed(8)
						FogOfWar.Reveal(p_republic, player_twilight, 99999)
					end

					Allow_Localized_SFX(true)
					SFXManager.Allow_HUD_VO(true)
					SFXManager.Allow_Ambient_VO(true)
					SFXManager.Allow_Enemy_Sighted_VO(true)
					SFXManager.Allow_Unit_Reponse_VO(true)
					Resume_Mode_Based_Music()

					if not TestValid(pod_1) then
						pod_1 = Spawn_Unit(Find_Object_Type("Republic_Escape_Pod"), pod_1_marker, p_republic)
						pod_1 = Find_Nearest(pod_1_marker, p_republic, true)
						pod_1.Teleport_And_Face(pod_1_marker)
						pod_1.Highlight(true)
						Add_Radar_Blip(pod_1, "pod_1_blip")
						Register_Prox(pod_1, Prox_Pod_1_Found, 150)
					end

					if not TestValid(pod_2) then
						pod_2 = Spawn_Unit(Find_Object_Type("Republic_Escape_Pod"), pod_2_marker, p_republic)
						pod_2 = Find_Nearest(pod_2_marker, p_republic, true)
						pod_2.Teleport_And_Face(pod_2_marker)
						pod_2.Highlight(true)
						Add_Radar_Blip(pod_2, "pod_2_blip")
						Register_Prox(pod_2, Prox_Pod_2_Found, 150)
					end

					if not TestValid(pod_3) then
						pod_3 = Spawn_Unit(Find_Object_Type("Republic_Escape_Pod"), pod_3_marker, p_republic)
						pod_3 = Find_Nearest(pod_3_marker, p_republic, true)
						pod_3.Teleport_And_Face(pod_3_marker)
						pod_3.Highlight(true)
						Add_Radar_Blip(pod_3, "pod_3_blip")
						Register_Prox(pod_3, Prox_Pod_3_Found, 150)
					end

					if not TestValid(pod_4) then
						pod_4 = Spawn_Unit(Find_Object_Type("Republic_Escape_Pod"), pod_4_marker, p_republic)
						pod_4 = Find_Nearest(pod_4_marker, p_republic, true)
						pod_4.Teleport_And_Face(pod_4_marker)
						pod_4.Highlight(true)
						Add_Radar_Blip(pod_4, "pod_4_blip")
						Register_Prox(pod_4, Prox_Pod_4_Found, 150)
					end

					if not TestValid(pod_5) then
						pod_5 = Spawn_Unit(Find_Object_Type("Republic_Escape_Pod"), pod_5_marker, p_republic)
						pod_5 = Find_Nearest(pod_5_marker, p_republic, true)
						pod_5.Teleport_And_Face(pod_5_marker)
						pod_5.Highlight(true)
						Add_Radar_Blip(pod_5, "pod_5_blip")
						Register_Prox(pod_5, Prox_Pod_5_Found, 150)
					end


					if not TestValid(player_hunter_11) then
						player_hunter_11 = Spawn_Unit(Find_Object_Type("Droch_Boarding_Ship"), hunter_1_marker, p_cis)
						player_hunter_11 = Find_Nearest(hunter_1_marker, p_cis, true)
						player_hunter_11.Teleport_And_Face(hunter_1_marker)
						player_hunter_11.Override_Max_Speed(5)
					end

					if not TestValid(player_hunter_12) then
						player_hunter_12 = Spawn_Unit(Find_Object_Type("Droch_Boarding_Ship"), hunter_1_marker, p_cis)
						player_hunter_12 = Find_Nearest(hunter_1_marker, p_cis, true)
						player_hunter_12.Teleport_And_Face(hunter_1_marker)
						player_hunter_12.Override_Max_Speed(5)
					end

					if not TestValid(player_hunter_13) then
						player_hunter_13 = Spawn_Unit(Find_Object_Type("Droch_Boarding_Ship"), hunter_1_marker, p_cis)
						player_hunter_13 = Find_Nearest(hunter_1_marker, p_cis, true)
						player_hunter_13.Teleport_And_Face(hunter_1_marker)
						player_hunter_13.Override_Max_Speed(5)
					end

					if not TestValid(player_hunter_14) then
						player_hunter_14 = Spawn_Unit(Find_Object_Type("Droch_Boarding_Ship"), hunter_1_marker, p_cis)
						player_hunter_14 = Find_Nearest(hunter_1_marker, p_cis, true)
						player_hunter_14.Teleport_And_Face(hunter_1_marker)
						player_hunter_14.Override_Max_Speed(5)
					end

					if not TestValid(player_hunter_2) then
						player_hunter_2 = Spawn_Unit(Find_Object_Type("Droch_Boarding_Ship"), hunter_1_marker, p_cis)
						player_hunter_2 = Find_Nearest(hunter_1_marker, p_cis, true)
						player_hunter_2.Teleport_And_Face(hunter_1_marker)
						player_hunter_2.Override_Max_Speed(5)
					end

					if not TestValid(player_hunter_3) then
						player_hunter_3 = Spawn_Unit(Find_Object_Type("Droch_Boarding_Ship"), hunter_1_marker, p_cis)
						player_hunter_3 = Find_Nearest(hunter_1_marker, p_cis, true)
						player_hunter_3.Teleport_And_Face(hunter_1_marker)
						player_hunter_3.Override_Max_Speed(5)
					end

					Letter_Box_Out(0)
					Point_Camera_At(twilight_marker)
					Story_Event("GOAL_TRIGGER_REP_II")
					Lock_Controls(0)
					Suspend_AI(0)
					End_Cinematic_Camera()

					Fade_Screen_In(0.5)
					Sleep(0.5)

					cinematic_two = false
					act_1_active = false
					act_2_active = true

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

					Allow_Localized_SFX(true)
					SFXManager.Allow_HUD_VO(true)
					SFXManager.Allow_Ambient_VO(true)
					SFXManager.Allow_Enemy_Sighted_VO(true)
					SFXManager.Allow_Unit_Reponse_VO(true)
					Resume_Mode_Based_Music()

					Add_Radar_Blip(escape_marker, "escape_blip")
					escape_marker.Highlight(true)

					if TestValid(player_droch) then
						player_droch.Despawn()
					end

					if TestValid(pod_plo[1]) then
						pod_plo[1].Despawn()
						pod_plo[1].Attach_Particle_Effect("Rescue_Effect")
					elseif TestValid(pod_plo) then
						pod_plo.Despawn()
						pod_plo.Attach_Particle_Effect("Rescue_Effect")
					end

					if not TestValid(player_midtro_malevolence) then
						player_midtro_malevolence = Spawn_Unit(Find_Object_Type("Grievous_Malevolence_Hunt_Campaign"), midtro_2_malevolence_marker, p_cis)
						player_midtro_malevolence = Find_Nearest(midtro_2_malevolence_marker, p_cis, true)
						player_midtro_malevolence.Teleport_And_Face(midtro_2_malevolence_marker)
						player_midtro_malevolence.Cinematic_Hyperspace_In(1)
						player_midtro_malevolence.Attack_Move(player_twilight)
					end

					if TestValid(pod_1) then
						pod_1.Despawn()
					end

					if TestValid(pod_2) then
						pod_2.Despawn()
					end

					if TestValid(pod_3) then
						pod_3.Despawn()
					end

					if TestValid(pod_4) then
						pod_4.Despawn()
					end

					if TestValid(pod_5) then
						pod_5.Despawn()
					end

					Letter_Box_Out(0)
					Point_Camera_At(player_twilight)
					Story_Event("GOAL_TRIGGER_REP_III")
					Lock_Controls(0)
					Suspend_AI(0)
					End_Cinematic_Camera()

					player_twilight.Teleport_And_Face(current_twilight_position)
					player_twilight.Suspend_Locomotor(false)
					FogOfWar.Reveal(p_republic, player_twilight, 99999)

					pod_plo_rescued = true
					cinematic_three = false
					act_2_active = false
					act_3_active = true

					Fade_Screen_In(0.5)
					Sleep(0.5)
				end
			end
			if cinematic_four then
				if not cinematic_four_skipped then
					cinematic_four_skipped = true
					-- MessageBox("Escape Key Pressed!!!")

					act_3_active = false

					if current_cinematic_thread_id ~= nil then
						Thread.Kill(current_cinematic_thread_id)
						current_cinematic_thread_id = nil
					end

					Allow_Localized_SFX(true)
					SFXManager.Allow_HUD_VO(true)
					SFXManager.Allow_Ambient_VO(true)
					SFXManager.Allow_Enemy_Sighted_VO(true)
					SFXManager.Allow_Unit_Reponse_VO(true)

					if pod_plo_rescued then
						GlobalValue.Set("HfM_Plo_Rescued", 1)
					end

				--crossplot:tactical()
				--crossplot:publish("CREW_GAIN", pods_rescued)
				--crossplot:update()

					Story_Event("CIS_VICTORY")
				end
			end
		elseif p_cis.Is_Human() then
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
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
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

					if TestValid(player_plo_intro) then
						player_plo_intro.Despawn()
					end

					if TestValid(venator_1_intro) then
						venator_1_intro.Despawn()
					end

					if TestValid(venator_2_intro) then
						venator_2_intro.Despawn()
					end

					if not TestValid(player_plo) then
						p_republic = Find_Player("Empire")
						player_plo = Spawn_Unit(Find_Object_Type("Generic_Venator"), venator_plo_move_to, p_republic)
						player_plo = Find_Nearest(venator_plo_move_to, p_republic, true)
						player_plo.Teleport_And_Face(venator_plo_move_to)
					else
						player_plo.Despawn()
						player_plo = Spawn_Unit(Find_Object_Type("Generic_Venator"), venator_plo_move_to, p_republic)
						player_plo = Find_Nearest(venator_plo_move_to, p_republic, true)
						player_plo.Teleport_And_Face(venator_plo_move_to)
						player_plo.Cinematic_Hyperspace_In(1)
					end

					if not TestValid(venator_1) then
						p_republic = Find_Player("Empire")
						venator_1 = Spawn_Unit(Find_Object_Type("Generic_Venator"), venator_1_move_to, p_republic)
						venator_1 = Find_Nearest(venator_1_move_to, p_republic, true)
						venator_1.Teleport_And_Face(venator_1_move_to)
					else
						venator_1.Despawn()
						venator_1 = Spawn_Unit(Find_Object_Type("Generic_Venator"), venator_1_move_to, p_republic)
						venator_1 = Find_Nearest(venator_1_move_to, p_republic, true)
						venator_1.Teleport_And_Face(venator_1_move_to)
						venator_1.Cinematic_Hyperspace_In(1)
					end

					if not TestValid(venator_2) then
						p_republic = Find_Player("Empire")
						venator_2 = Spawn_Unit(Find_Object_Type("Generic_Venator"), venator_2_move_to, p_republic)
						venator_2 = Find_Nearest(venator_2_move_to, p_republic, true)
						venator_2.Teleport_And_Face(venator_2_move_to)
					else
						venator_2.Despawn()
						venator_2 = Spawn_Unit(Find_Object_Type("Generic_Venator"), venator_2_move_to, p_republic)
						venator_2 = Find_Nearest(venator_2_move_to, p_republic, true)
						venator_2.Teleport_And_Face(venator_2_move_to)
						venator_2.Cinematic_Hyperspace_In(1)
					end

					if not TestValid(player_intro_malevolence) then
						p_cis = Find_Player("Rebel")
						player_intro_malevolence = Spawn_Unit(Find_Object_Type("Grievous_Malevolence_Hunt_Campaign"), intro_malevolence_marker, p_cis)
						player_intro_malevolence = Find_Nearest(intro_malevolence_marker, "Grievous_Malevolence_Hunt_Campaign", true)
						player_intro_malevolence.Teleport_And_Face(intro_malevolence_marker)
					end

					rep_fighters = Find_All_Objects_Of_Type(p_republic, "Fighter | Bomber")
					for _,repfighters in pairs(rep_fighters) do
						if TestValid(repfighters) then
							repfighters.Despawn()
						end
					end

					Allow_Localized_SFX(true)
					SFXManager.Allow_HUD_VO(true)
					SFXManager.Allow_Ambient_VO(true)
					SFXManager.Allow_Enemy_Sighted_VO(true)
					SFXManager.Allow_Unit_Reponse_VO(true)
					Resume_Mode_Based_Music()

					Letter_Box_Out(0)
					Point_Camera_At(venator_plo_move_to)
					Story_Event("GOAL_TRIGGER_CIS_I")
					Story_Event("ACTIVATE_REP_AI")
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

					junk_list_05 = Find_All_Objects_Of_Type("SPACE_JUNK_LARGE")
					for x,junks5 in pairs(junk_list_05) do
						if TestValid(junks5) then
							Hide_Object(junks5, 0)
						end
					end

					junk_list_06 = Find_All_Objects_Of_Type("SPACE_JUNK_HUGE")
					for s,junks6 in pairs(junk_list_06) do
						if TestValid(junks6) then
							Hide_Object(junks6, 0)
						end
					end

					republic_unit_list_skip = Find_All_Objects_Of_Type(p_republic)
					for g,repunitsskip in pairs(republic_unit_list_skip) do
						if TestValid(repunitsskip) then
							repunitsskip.Despawn()
						end
					end

					cis_unit_list_skip = Find_All_Objects_Of_Type(p_cis)
					for u,skippies in pairs(cis_unit_list_skip) do
						if TestValid(skippies) then
							skippies.Despawn()
						end
					end

					Allow_Localized_SFX(true)
					SFXManager.Allow_HUD_VO(true)
					SFXManager.Allow_Ambient_VO(true)
					SFXManager.Allow_Enemy_Sighted_VO(true)
					SFXManager.Allow_Unit_Reponse_VO(true)
					Resume_Mode_Based_Music()

					if not TestValid(pod_1) then
						pod_1 = Spawn_Unit(Find_Object_Type("Republic_Escape_Pod"), pod_1_marker, p_republic)
						pod_1 = Find_Nearest(pod_1_marker, p_republic, true)
						pod_1.Teleport_And_Face(pod_1_marker)
						pod_1.Highlight(true)
						Add_Radar_Blip(pod_1, "pod_1_blip")
						Register_Prox(pod_1, Prox_Pod_1_Found, 150)
					end

					if not TestValid(pod_2) then
						pod_2 = Spawn_Unit(Find_Object_Type("Republic_Escape_Pod"), pod_2_marker, p_republic)
						pod_2 = Find_Nearest(pod_2_marker, p_republic, true)
						pod_2.Teleport_And_Face(pod_2_marker)
						pod_2.Highlight(true)
						Add_Radar_Blip(pod_2, "pod_2_blip")
						Register_Prox(pod_2, Prox_Pod_2_Found, 150)
					end

					if not TestValid(pod_3) then
						pod_3 = Spawn_Unit(Find_Object_Type("Republic_Escape_Pod"), pod_3_marker, p_republic)
						pod_3 = Find_Nearest(pod_3_marker, p_republic, true)
						pod_3.Teleport_And_Face(pod_3_marker)
						pod_3.Highlight(true)
						Add_Radar_Blip(pod_3, "pod_3_blip")
						Register_Prox(pod_3, Prox_Pod_3_Found, 150)
					end

					if not TestValid(pod_4) then
						pod_4 = Spawn_Unit(Find_Object_Type("Republic_Escape_Pod"), pod_4_marker, p_republic)
						pod_4 = Find_Nearest(pod_4_marker, p_republic, true)
						pod_4.Teleport_And_Face(pod_4_marker)
						pod_4.Highlight(true)
						Add_Radar_Blip(pod_4, "pod_4_blip")
						Register_Prox(pod_4, Prox_Pod_4_Found, 150)
					end

					if not TestValid(pod_5) then
						pod_5 = Spawn_Unit(Find_Object_Type("Republic_Escape_Pod"), pod_5_marker, p_republic)
						pod_5 = Find_Nearest(pod_5_marker, p_republic, true)
						pod_5.Teleport_And_Face(pod_5_marker)
						pod_5.Highlight(true)
						Add_Radar_Blip(pod_5, "pod_5_blip")
						Register_Prox(pod_5, Prox_Pod_5_Found, 150)
					end


					if not TestValid(player_hunter_11) then
						player_hunter_11 = Spawn_Unit(Find_Object_Type("Droch_Boarding_Ship"), hunter_1_marker, p_cis)
						player_hunter_11 = Find_Nearest(hunter_1_marker, p_cis, true)
						player_hunter_11.Teleport_And_Face(hunter_1_marker)
						player_hunter_11.Override_Max_Speed(7)
					end

					if not TestValid(player_hunter_12) then
						player_hunter_12 = Spawn_Unit(Find_Object_Type("Droch_Boarding_Ship"), hunter_1_marker, p_cis)
						player_hunter_12 = Find_Nearest(hunter_1_marker, p_cis, true)
						player_hunter_12.Teleport_And_Face(hunter_1_marker)
						player_hunter_12.Override_Max_Speed(7)
					end

					if not TestValid(player_hunter_13) then
						player_hunter_13 = Spawn_Unit(Find_Object_Type("Droch_Boarding_Ship"), hunter_1_marker, p_cis)
						player_hunter_13 = Find_Nearest(hunter_1_marker, p_cis, true)
						player_hunter_13.Teleport_And_Face(hunter_1_marker)
						player_hunter_13.Override_Max_Speed(7)
					end

					if not TestValid(player_hunter_14) then
						player_hunter_14 = Spawn_Unit(Find_Object_Type("Droch_Boarding_Ship"), hunter_1_marker, p_cis)
						player_hunter_14 = Find_Nearest(hunter_1_marker, p_cis, true)
						player_hunter_14.Teleport_And_Face(hunter_1_marker)
						player_hunter_14.Override_Max_Speed(7)
					end


					if not TestValid(player_hunter_2) then
						player_hunter_2 = Spawn_Unit(Find_Object_Type("Droch_Boarding_Ship"), hunter_2_marker, p_cis)
						player_hunter_2 = Find_Nearest(hunter_2_marker, p_cis, true)
						player_hunter_2.Teleport_And_Face(hunter_2_marker)
						player_hunter_2.Override_Max_Speed(7)
					end

					if not TestValid(player_hunter_3) then
						player_hunter_3 = Spawn_Unit(Find_Object_Type("Droch_Boarding_Ship"), hunter_3_marker, p_cis)
						player_hunter_3 = Find_Nearest(hunter_3_marker, p_cis, true)
						player_hunter_3.Teleport_And_Face(hunter_3_marker)
						player_hunter_3.Override_Max_Speed(7)
					end

					Letter_Box_Out(0)
					Point_Camera_At(hunter_1_marker)
					Story_Event("GOAL_TRIGGER_CIS_II")
					Lock_Controls(0)
					Suspend_AI(0)
					End_Cinematic_Camera()

					Fade_Screen_In(0.5)
					Sleep(0.5)

					cinematic_two = false
					act_1_active = false
					act_2_active = true

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

					Allow_Localized_SFX(true)
					SFXManager.Allow_HUD_VO(true)
					SFXManager.Allow_Ambient_VO(true)
					SFXManager.Allow_Enemy_Sighted_VO(true)
					SFXManager.Allow_Unit_Reponse_VO(true)
					Resume_Mode_Based_Music()

					if not TestValid(player_midtro_malevolence) then
						player_midtro_malevolence = Spawn_Unit(Find_Object_Type("Grievous_Malevolence_Hunt_Campaign"), midtro_2_malevolence_marker, p_cis)
						player_midtro_malevolence = Find_Nearest(midtro_2_malevolence_marker, p_cis, true)
						player_midtro_malevolence.Teleport_And_Face(midtro_2_malevolence_marker)
					end

					if not TestValid(player_twilight) then
						player_twilight = Spawn_Unit(Find_Object_Type("Twilight"), droch_twilight_marker, p_republic)
						player_twilight = Find_Nearest(droch_twilight_marker, p_republic, true)
						player_twilight.Teleport_And_Face(droch_twilight_marker)
						player_twilight.Cinematic_Hyperspace_In(1)
						player_twilight.Override_Max_Speed(8)
					else
						player_twilight.Despawn()
						player_twilight = Spawn_Unit(Find_Object_Type("Twilight"), droch_twilight_marker, p_republic)
						player_twilight = Find_Nearest(droch_twilight_marker, p_republic, true)
						player_twilight.Teleport_And_Face(droch_twilight_marker)
						player_twilight.Cinematic_Hyperspace_In(1)
						player_twilight.Override_Max_Speed(8)
					end

					if TestValid(player_droch) then
						player_droch.Despawn()
					end

					if TestValid(pod_plo[1]) then
						pod_plo[1].Despawn()
					elseif TestValid(pod_plo) then
						pod_plo.Despawn()
					end

					Register_Prox(escape_marker, f_Prox_Escape, notice_range, p_republic)

					Remove_Radar_Blip("pod_plo_blip")
					Add_Radar_Blip(escape_marker, "escape_blip")
					Add_Radar_Blip(player_twilight, "twilight_blip")
					escape_marker.Highlight(true)
					player_twilight.Highlight(true)

					Letter_Box_Out(0)
					Point_Camera_At(player_twilight)
					Story_Event("GOAL_TRIGGER_CIS_III")
					Lock_Controls(0)
					Suspend_AI(0)
					End_Cinematic_Camera()

					cinematic_three = false
					act_2_active = false
					act_3_active = true

					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")

					Fade_Screen_In(0.5)
					Sleep(0.5)
				end
			end
			if cinematic_four then
				if not cinematic_four_skipped then
					cinematic_four_skipped = true
					-- MessageBox("Escape Key Pressed!!!")

					act_3_active = false

					if current_cinematic_thread_id ~= nil then
						Thread.Kill(current_cinematic_thread_id)
						current_cinematic_thread_id = nil
					end

					Allow_Localized_SFX(true)
					SFXManager.Allow_HUD_VO(true)
					SFXManager.Allow_Ambient_VO(true)
					SFXManager.Allow_Enemy_Sighted_VO(true)
					SFXManager.Allow_Unit_Reponse_VO(true)

					Story_Event("CIS_VICTORY")
				end
			end
		end
	end
end

function Story_Mode_Service()
	if p_republic.Is_Human() then
		if act_1_active then
			if TestValid(player_plo) then
				if player_plo.Get_Hull() <= 0.10 then
					player_plo.Set_Cannot_Be_Killed(true)
					Story_Event("PLO_DEATH")
				end
			end
		end
		if act_2_active then
			if not TestValid(pod_1) then
				Remove_Radar_Blip("pod_1_blip")
			end
			if not TestValid(pod_2) then
				Remove_Radar_Blip("pod_2_blip")
			end
			if not TestValid(pod_3) then
				Remove_Radar_Blip("pod_3_blip")
			end
			if not TestValid(pod_4) then
				Remove_Radar_Blip("pod_4_blip")
			end
			if not TestValid(pod_5) then
				Remove_Radar_Blip("pod_5_blip")
			end
		end
		if act_3_active then
			if not TestValid(player_twilight) and not last_scene then
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
				pod_plo_rescued = false
				last_scene = true
			end
		end
	elseif p_cis.Is_Human() then
		if act_1_active then
			if TestValid(player_plo) then
				if player_plo.Get_Hull() <= 0.10 then
					player_plo.Set_Cannot_Be_Killed(true)
					Story_Event("PLO_DEATH")
				end
			end
		end
		if act_2_active then
			if not TestValid(pod_1) then
				Remove_Radar_Blip("pod_1_blip")
			end
			if not TestValid(pod_2) then
				Remove_Radar_Blip("pod_2_blip")
			end
			if not TestValid(pod_3) then
				Remove_Radar_Blip("pod_3_blip")
			end
			if not TestValid(pod_4) then
				Remove_Radar_Blip("pod_4_blip")
			end
			if not TestValid(pod_5) then
				Remove_Radar_Blip("pod_5_blip")
			end
			if pod_1_killed and pod_2_killed and pod_3_killed and pod_4_killed and pod_5_killed then
				Story_Event("PODS_DEATH")
			end
		end
		if act_3_active then
			if TestValid(player_twilight) then
				player_twilight.Move_To(escape_marker)
				player_twilight.Lock_Current_Orders()
			end
			if not TestValid(player_twilight) and not last_scene then
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")
				pod_plo_rescued = false
				last_scene = true
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
	BlockOnCommand(Play_Bink_Movie("Hunt_for_Malevolence_Campaign_Intro"))

	if not cinematic_crawl_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
	end

end

function Start_Cinematic_Intro_Rep()

	cinematic_crawl = false
	cinematic_one = true

	Transition_Cinematic_Camera_Key(introcam_2_marker, 8.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 8.0, 0, 0, 0, 0, introcam_target_venator_plo_marker, 1, 0)

	Letter_Box_In(1.0)
	Play_Music("Abregado_Ambush_01")
	Sleep(1.5)

	Story_Event("CINEMATIC_INTRO")

	player_plo_intro.Teleport_And_Face(venator_plo_marker)
	player_plo_intro.Cinematic_Hyperspace_In(65)

	venator_1_intro.Teleport_And_Face(venator_1_marker)
	venator_1_intro.Cinematic_Hyperspace_In(65)

	venator_2_intro.Teleport_And_Face(venator_2_marker)
	venator_2_intro.Cinematic_Hyperspace_In(65)

	Sleep(6.0)

	Transition_Cinematic_Camera_Key(introcam_3_marker, 11, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_3_marker, 11, 0, 0, 0, 0, introcam_target_venator_plo_marker, 1, 0)
	Sleep(11.0)

	Fade_Screen_In(0.01)

	Set_Cinematic_Camera_Key(introcam_4_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_4_marker, 0, 0, 0, 0, introcam_target_malevolence_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_5_marker, 14.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_5_marker, 14.0, 0, 0, 0, 0, introcam_target_malevolence_marker, 1, 0)
	Sleep(1.0)

	player_plo_intro.Despawn()
	venator_1_intro.Despawn()
	venator_2_intro.Despawn()
	Sleep(1.0)

	player_plo.Teleport_And_Face(venator_plo_marker)
	venator_1.Teleport_And_Face(venator_1_marker)
	venator_2.Teleport_And_Face(venator_2_marker)
	Sleep(1.0)

	player_plo.Move_To(venator_plo_move_to)
	venator_1.Move_To(venator_1_move_to)
	venator_2.Move_To(venator_2_move_to)
	Sleep(4.0)

	Transition_Cinematic_Camera_Key(introcam_5_marker, 7.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_5_marker, 7.0, 0, 0, 0, 0, player_plo, 1, 0)
	Sleep(7.0)

	Set_Cinematic_Camera_Key(introcam_6_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_6_marker, 0, 0, 0, 0, player_plo, 1, 0)
	Transition_Cinematic_Camera_Key(pod_plo_marker, 22, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(pod_plo_marker, 22, 0, 0, 0, 0, player_plo, 1, 0)
	Sleep(11.0)

	Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, introcam_target_malevolence_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_8_marker, 11.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_8_marker, 11.5, 0, 0, 0, 0, player_intro_malevolence, 1, 0)
	Sleep(2)

	Story_Event("FLYING_NOW_01")

	Sleep(8)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Rep")
	end

end

function End_Cinematic_Intro_Rep()

	Point_Camera_At(player_plo)
	Transition_To_Tactical_Camera(4)
	Letter_Box_Out(4)
	Sleep(4.0)
	Suspend_AI(0)
	Lock_Controls(0)
	End_Cinematic_Camera()

	current_cinematic_thread_id = nil
	Sleep(1.0)

	p_republic.Make_Enemy(p_cis)
	p_cis.Make_Enemy(p_republic)
	Story_Event("ACTIVATE_CIS_AI")
	Sleep(1.0)

	Story_Event("GOAL_TRIGGER_REP_I")

	Allow_Localized_SFX(true)
	SFXManager.Allow_HUD_VO(true)
	SFXManager.Allow_Ambient_VO(true)
	SFXManager.Allow_Enemy_Sighted_VO(true)
	SFXManager.Allow_Unit_Reponse_VO(true)

	Sleep(4.0)
	Resume_Mode_Based_Music()

	cinematic_one = false
	act_1_active = true

end

function Start_Cinematic_Midtro_Rep()

	cinematic_two = true
	Allow_Localized_SFX(false)
	SFXManager.Allow_HUD_VO(false)
	SFXManager.Allow_Ambient_VO(false)
	SFXManager.Allow_Enemy_Sighted_VO(false)
	SFXManager.Allow_Unit_Reponse_VO(false)
	Stop_All_Music()

	Start_Cinematic_Camera()
	Lock_Controls(1)
	Letter_Box_In(1)
	Cancel_Fast_Forward()
	Fade_On()
	Sleep(0.5)

	Play_Music("Abregado_Ambush_02")
	Fade_Screen_In(2)

	Set_Cinematic_Camera_Key(introcam_8_marker, -500, 300, -90, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_8_marker, -60, 0, -10, 0, player_plo, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_7_marker, 20, 500, -300, -210, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_7_marker, 20, -60, 0, -10, 0, player_plo, 1, 0)
	Sleep(5)

	if TestValid(venator_1) then
		venator_1.Take_Damage(999999)
	end

	Sleep(4)

	if TestValid(venator_2) then
		venator_2.Take_Damage(999999)
	end

	Sleep(6)

	player_plo.Set_Cannot_Be_Killed(false)
	if TestValid(player_plo) then
		player_plo.Take_Damage(999999)
	end

	Sleep(2)

	Fade_Screen_Out(3)
	Sleep(3)

	junk_list_03 = Find_All_Objects_Of_Type("SPACE_JUNK_LARGE")
	for k,junks3 in pairs(junk_list_03) do
		if TestValid(junks3) then
			Hide_Object(junks3, 0)
		end
	end

	junk_list_04 = Find_All_Objects_Of_Type("SPACE_JUNK_HUGE")
	for l,junks4 in pairs(junk_list_04) do
		if TestValid(junks4) then
			Hide_Object(junks4, 0)
		end
	end

	Sleep(1)

	republic_unit_list = Find_All_Objects_Of_Type(p_republic)
	for k,repunits in pairs(republic_unit_list) do
		if TestValid(repunits) then
			repunits.Despawn()
		end
	end

	player_intro_malevolence.Teleport_And_Face(midtro_1_malevolence_marker)
	player_intro_malevolence.Suspend_Locomotor(true)

	Set_Cinematic_Camera_Key(midtrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_1_marker, 0, 0, 0, 0, midtrocam_target_malevolence_marker, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_2_marker, 14, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_2_marker, 14, 0, 0, 0, 0, midtrocam_target_malevolence_marker, 1, 0)

	Fade_Screen_In(3)
	Sleep(11)

	Fade_Screen_Out(2)
	Sleep(2.0)

	cis_unit_list = Find_All_Objects_Of_Type(p_cis)
	for z,seppies in pairs(cis_unit_list) do
		if TestValid(seppies) then
			seppies.Despawn()
		end
	end

	player_twilight = Spawn_Unit(Find_Object_Type("Twilight"), twilight_marker, p_republic)
	player_twilight = Find_Nearest(twilight_marker, p_republic, true)
	player_twilight.Teleport_And_Face(twilight_marker)
	player_twilight.Cinematic_Hyperspace_In(150)
	player_twilight.Override_Max_Speed(8)

	Set_Cinematic_Camera_Key(midtrocam_3_marker, 500, -200, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_3_marker, 0, 0, 0, 0, twilight_marker, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_3_marker, 5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_3_marker, 5, 0, 0, 0, 0, twilight_marker, 1, 0)
	Sleep(1)

	Fade_Screen_In(2)
	Sleep(4)

	Transition_Cinematic_Camera_Key(midtrocam_4_marker, 10, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_4_marker, 10, 0, 0, 0, 0, player_twilight, 1, 0)
	Sleep(3)

	Story_Event("FLYING_NOW_02")
	Sleep(2)

	if TestValid(player_twilight) then
		player_twilight.Move_To(twilight_move_to)
	end

	Sleep(8)

	Story_Event("PHASE_ONE")

	Set_Cinematic_Camera_Key(player_twilight, -100, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(player_twilight, 0, 0, 0, 0, player_twilight, 1, 0)
	Sleep(4)

	Set_Cinematic_Camera_Key(player_twilight, 350, 0, -350, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(player_twilight, 0, 0, 0, 0, player_twilight, 1, 0)
	Sleep(2)

	Story_Event("FLYING_NOW_03")
	Sleep(2)

	if not cinematic_two_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Midtro_Rep")
	end

end

function End_Cinematic_Midtro_Rep()

	Story_Event("GOAL_TRIGGER_REP_II")

	--I don't want the Twilight to die while testing 
	--player_twilight.Set_Cannot_Be_Killed(true)

	Point_Camera_At(player_twilight)
	Transition_To_Tactical_Camera(4)
	Letter_Box_Out(3)
	Sleep(4.0)
	End_Cinematic_Camera()
	Lock_Controls(0)
	Sleep(2.0)
	Suspend_AI(0)

	Story_Event("PHASE_TWO")

	Sleep(4)

	act_1_active = false
	act_2_active = true

	--Game_Message("TEXT_MISSION_ABREGADO_AMBUSH_HINT_REP_01")

	Sleep(18)

	Resume_Mode_Based_Music()
	Allow_Localized_SFX(true)
	SFXManager.Allow_HUD_VO(true)
	SFXManager.Allow_Ambient_VO(true)
	SFXManager.Allow_Enemy_Sighted_VO(true)
	SFXManager.Allow_Unit_Reponse_VO(true)
	cinematic_two = false

end

function Start_Cinematic_Midtro_02_Rep()

	current_twilight_position = Find_First_Object("Twilight")

	act_2_active = false
	cinematic_three = true
	Allow_Localized_SFX(false)
	SFXManager.Allow_HUD_VO(false)
	SFXManager.Allow_Ambient_VO(false)
	SFXManager.Allow_Enemy_Sighted_VO(false)
	SFXManager.Allow_Unit_Reponse_VO(false)

	Start_Cinematic_Camera()
	Lock_Controls(1)
	Suspend_AI(1)
	Cancel_Fast_Forward()
	Letter_Box_In(0.25)
	Remove_All_Text()
	Fade_Screen_Out(0.25)
	Sleep(0.25)

	Stop_All_Music()
	Play_Music("Abregado_Ambush_03")

	if TestValid(pod_1) then
		pod_1.Highlight(false)
	end
	if TestValid(pod_2) then
		pod_2.Highlight(false)
	end
	if TestValid(pod_3) then
		pod_3.Highlight(false)
	end
	if TestValid(pod_4) then
		pod_4.Highlight(false)
	end
	if TestValid(pod_5) then
		pod_5.Highlight(false)
	end

	pod_plo = Spawn_Unit(Find_Object_Type("Republic_Escape_Pod"), pod_plo_marker, p_republic)
	pod_plo[1].Teleport_And_Face(pod_plo_marker)
	pod_plo[1].Suspend_Locomotor(true)

	player_droch = Spawn_Unit(Find_Object_Type("Droch_Boarding_Ship"), droch_marker, p_cis)
	player_droch = Find_Nearest(droch_marker, p_cis, true)
	player_droch.Teleport_And_Face(droch_marker)
	player_droch.Suspend_Locomotor(true)
	player_droch.Prevent_AI_Usage(true)

	player_twilight.Teleport_And_Face(droch_twilight_marker)
	player_twilight.Suspend_Locomotor(true)

	Fade_Screen_In(0.25)
	Set_Cinematic_Camera_Key(drochcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(drochcam_1_marker, 0, 0, 0, 0, pod_plo_marker, 1, 0)
	Transition_Cinematic_Camera_Key(drochcam_2_marker, 5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(drochcam_2_marker, 5, 0, 0, 0, 0, pod_plo_marker, 1, 0)
	Sleep(4.0)

	player_twilight.Suspend_Locomotor(false)
	player_twilight.Move_To(droch_twilight_move_to_marker)
	player_droch.Play_Animation("Undeploy", false)
	Sleep(1.0)

	Set_Cinematic_Camera_Key(drochcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(drochcam_3_marker, 0, 0, 0, 0, pod_plo_marker, 1, 0)
	Transition_Cinematic_Camera_Key(drochcam_4_marker, 10, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(drochcam_4_marker, 10, 0, 0, 0, 0, pod_plo_marker, 1, 0)
	Sleep(0.5)

	if TestValid(pod_plo[1]) then
		player_droch.Take_Damage(10000)
		Sleep(0.25)
		pod_plo[1].Attach_Particle_Effect("Rescue_Effect")
		Sleep(0.25)
		pod_plo[1].Despawn()
	elseif TestValid(pod_plo) then
		player_droch.Take_Damage(10000)
		Sleep(0.25)
		pod_plo.Attach_Particle_Effect("Rescue_Effect")
		Sleep(0.25)
		pod_plo.Despawn()
	end

	if TestValid(pod_plo[1]) then

	end

	Sleep(2.0)

	Suspend_AI(0)
	Fade_Screen_Out(0.5)
	Sleep(1.5)

	Story_Event("PHASE_THREE")

	Fade_Screen_In(2)

	Set_Cinematic_Camera_Key(midtrocam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_5_marker, 0, 0, -200, 0, midtro_2_malevolence_marker, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_6_marker, 9, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_6_marker, 9, 0, 0, -200, 0, midtro_2_malevolence_marker, 1, 0)
	Sleep(9)

	if TestValid(player_twilight) then
	--player_twilight.Play_Animation("Undeploy", false)
		player_twilight.Move_To(escape_marker)
	end
	
	Set_Cinematic_Camera_Key(player_twilight, -100, -200, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(player_twilight, 0, 0, 0, 0, player_twilight, 1, 0)
	Sleep(3)

	Story_Event("FLYING_NOW_04")

	if not cinematic_three_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Midtro_02_Rep")
	end

end

function End_Cinematic_Midtro_02_Rep()

	player_twilight.Teleport_And_Face(current_twilight_position)
	Fade_Screen_In(0.1)
	Point_Camera_At(player_twilight)
	Transition_To_Tactical_Camera(3)
	Letter_Box_Out(3)
	Sleep(3.0)
	End_Cinematic_Camera()
	Lock_Controls(0)
	Sleep(1.0)
	Suspend_AI(0)

	act_3_active = true
	cinematic_three = false
	pod_plo_rescued = true
	Story_Event("GOAL_TRIGGER_REP_III")

	if TestValid(pod_1) then
		pod_1.Despawn()
	end
	if TestValid(pod_2) then
		pod_2.Despawn()
	end
	if TestValid(pod_3) then
		pod_3.Despawn()
	end
	if TestValid(pod_4) then
		pod_4.Despawn()
	end
	if TestValid(pod_5) then
		pod_5.Despawn()
	end

	Add_Radar_Blip(escape_marker, "escape_blip")
	escape_marker.Highlight(true)

	cis_fleet = Find_All_Objects_Of_Type(p_cis)
	for _,cisships in pairs(cis_fleet) do
		if TestValid(cisships) then
			cisships.Attack_Move(player_twilight)
		end
	end

	Sleep(34.0)

	twilight_position = Find_First_Object("Twilight")

	player_hunter_4 = Spawn_Unit(Find_Object_Type("Vulture_Squadron_Half"), twilight_position, p_cis)
	player_hunter_4 = Find_Nearest(twilight_position, p_cis, true)
	player_hunter_4.Teleport_And_Face(twilight_position)
	player_hunter_4.Attack_Move(player_twilight)
	player_hunter_4.Override_Max_Speed(15)

	Sleep(1.0)
	if not act_3_active then
		Resume_Mode_Based_Music()
		Allow_Localized_SFX(true)
		SFXManager.Allow_HUD_VO(true)
		SFXManager.Allow_Ambient_VO(true)
		SFXManager.Allow_Enemy_Sighted_VO(true)
		SFXManager.Allow_Unit_Reponse_VO(true)
	end
end

function Start_Cinematic_Outro_Rep()

	act_3_active = false
	cinematic_four = true
	Start_Cinematic_Camera()
	Lock_Controls(1)
	Cancel_Fast_Forward()
	Letter_Box_In(0.5)
	Remove_All_Text()
	Point_Camera_At(player_twilight)

	if pod_plo_rescued then
		GlobalValue.Set("HfM_Plo_Rescued", 1)
	end

	if TestValid(pod_1) then
		pod_1.Highlight(false)
	end
	if TestValid(pod_2) then
		pod_2.Highlight(false)
	end
	if TestValid(pod_3) then
		pod_3.Highlight(false)
	end
	if TestValid(pod_4) then
		pod_4.Highlight(false)
	end
	if TestValid(pod_5) then
		pod_5.Highlight(false)
	end

	Fade_Screen_Out(0.5)
	Sleep(0.5)

	player_twilight.Teleport_And_Face(outro_twilight_marker)

	player_midtro_malevolence.Teleport_And_Face(outro_malevolence_marker)
	player_midtro_malevolence.Suspend_Locomotor(true)
	player_midtro_malevolence.Prevent_AI_Usage(true)

	Remove_Radar_Blip("escape_blip")
	escape_marker.Highlight(false)

	Set_Cinematic_Camera_Key(outrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_1_marker, 0, 0, 0, 0, player_twilight, 1, 0)
	Transition_Cinematic_Camera_Key(outrocam_2_marker, 50, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_2_marker, 50, 0, 0, 0, 0, player_twilight, 1, 0)

	Stop_All_Music()
	Allow_Localized_SFX(false)
	SFXManager.Allow_HUD_VO(false)
	SFXManager.Allow_Ambient_VO(false)
	SFXManager.Allow_Enemy_Sighted_VO(false)
	SFXManager.Allow_Unit_Reponse_VO(false)
	Play_Music("Abregado_Ambush_04")

	Fade_Screen_In(0.5)
	Sleep(0.25)

	if TestValid(player_twilight) then
	--player_twilight.Play_Animation("Deploy", false)
	end

	Sleep(1.25)

	if TestValid(player_twilight) then
		player_twilight.Hyperspace_Away(true)
	end

	Sleep(3.0)

	Transition_Cinematic_Camera_Key(outrocam_2_marker, 8, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_2_marker, 8, 0, 0, 0, 0, outrocam_target_malevolence_marker, 1, 0)
	Sleep(8)

	Transition_Cinematic_Camera_Key(outrocam_3_marker, 22, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_3_marker, 22, 0, 0, 0, 0, outrocam_target_malevolence_marker, 1, 0)
	Sleep(18)

	Fade_Screen_Out(3)
	Sleep(3)

	Allow_Localized_SFX(true)
	SFXManager.Allow_HUD_VO(true)
	SFXManager.Allow_Ambient_VO(true)
	SFXManager.Allow_Enemy_Sighted_VO(true)
	SFXManager.Allow_Unit_Reponse_VO(true)

	--crossplot:tactical()
	--crossplot:publish("CREW_GAIN", pods_rescued)
	--crossplot:update()

	Story_Event("CIS_VICTORY")
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

	Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)

	Fade_Screen_In(1)

	cinematic_crawl = true
	BlockOnCommand(Play_Bink_Movie("A_Long_Time_Ago_Campaign_Intro"))

	-- MessageBox("Bink Movie done")
	Play_Music("Clone_Wars_Crawl_Theme")

	-- MessageBox("Starting Bink Movie!!!")
	BlockOnCommand(Play_Bink_Movie("Hunt_for_Malevolence_Campaign_Intro"))

	if not cinematic_crawl_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
	end

end

function Start_Cinematic_Intro_CIS()

	cinematic_crawl = false
	cinematic_one = true

	Transition_Cinematic_Camera_Key(introcam_2_marker, 8.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 8.0, 0, 0, 0, 0, introcam_target_venator_plo_marker, 1, 0)

	Letter_Box_In(1.0)
	Play_Music("Abregado_Ambush_01")
	Sleep(1.5)

	Story_Event("CINEMATIC_INTRO")

	player_plo_intro.Teleport_And_Face(venator_plo_marker)
	player_plo_intro.Cinematic_Hyperspace_In(65)

	venator_1_intro.Teleport_And_Face(venator_1_marker)
	venator_1_intro.Cinematic_Hyperspace_In(65)

	venator_2_intro.Teleport_And_Face(venator_2_marker)
	venator_2_intro.Cinematic_Hyperspace_In(65)

	Sleep(6.0)

	Transition_Cinematic_Camera_Key(introcam_3_marker, 11, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_3_marker, 11, 0, 0, 0, 0, introcam_target_venator_plo_marker, 1, 0)
	Sleep(11.0)

	Fade_Screen_In(0.01)

	Set_Cinematic_Camera_Key(introcam_4_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_4_marker, 0, 0, 0, 0, introcam_target_malevolence_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_5_marker, 14.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_5_marker, 14.0, 0, 0, 0, 0, introcam_target_malevolence_marker, 1, 0)
	Sleep(1.0)

	player_plo_intro.Despawn()
	venator_1_intro.Despawn()
	venator_2_intro.Despawn()
	Sleep(1.0)

	player_plo.Teleport_And_Face(venator_plo_marker)
	venator_1.Teleport_And_Face(venator_1_marker)
	venator_2.Teleport_And_Face(venator_2_marker)
	Sleep(1.0)

	player_plo.Move_To(venator_plo_move_to)
	venator_1.Move_To(venator_1_move_to)
	venator_2.Move_To(venator_2_move_to)
	Sleep(4.0)

	Transition_Cinematic_Camera_Key(introcam_5_marker, 7.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_5_marker, 7.0, 0, 0, 0, 0, player_plo, 1, 0)
	Sleep(7.0)

	Set_Cinematic_Camera_Key(introcam_6_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_6_marker, 0, 0, 0, 0, player_plo, 1, 0)
	Transition_Cinematic_Camera_Key(pod_plo_marker, 22, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(pod_plo_marker, 22, 0, 0, 0, 0, player_plo, 1, 0)
	Sleep(11.0)

	Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, introcam_target_malevolence_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_8_marker, 11.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_8_marker, 11.5, 0, 0, 0, 0, player_intro_malevolence, 1, 0)
	Sleep(2)

	Story_Event("FLYING_NOW_01")

	Sleep(8)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end

end

function End_Cinematic_Intro_CIS()

	Point_Camera_At(player_intro_malevolence)
	Transition_To_Tactical_Camera(4)
	Letter_Box_Out(4)
	Sleep(4.0)
	Suspend_AI(0)
	Lock_Controls(0)
	End_Cinematic_Camera()

	current_cinematic_thread_id = nil
	Sleep(1.0)

	p_republic.Make_Enemy(p_cis)
	p_cis.Make_Enemy(p_republic)
	Story_Event("ACTIVATE_REP_AI")
	Sleep(1.0)

	Story_Event("GOAL_TRIGGER_CIS_I")

	Allow_Localized_SFX(true)
	SFXManager.Allow_HUD_VO(true)
	SFXManager.Allow_Ambient_VO(true)
	SFXManager.Allow_Enemy_Sighted_VO(true)
	SFXManager.Allow_Unit_Reponse_VO(true)

	Sleep(4.0)
	Resume_Mode_Based_Music()

	cinematic_one = false
	act_1_active = true

end

function Start_Cinematic_Midtro_CIS()

	cinematic_two = true
	Allow_Localized_SFX(false)
	SFXManager.Allow_HUD_VO(false)
	SFXManager.Allow_Ambient_VO(false)
	SFXManager.Allow_Enemy_Sighted_VO(false)
	SFXManager.Allow_Unit_Reponse_VO(false)
	Stop_All_Music()

	Start_Cinematic_Camera()
	Lock_Controls(1)
	Letter_Box_In(1)
	Cancel_Fast_Forward()
	Fade_On()
	Sleep(0.5)

	Play_Music("Abregado_Ambush_02")
	Fade_Screen_In(2)

	Set_Cinematic_Camera_Key(introcam_8_marker, -500, 300, -90, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_8_marker, -60, 0, -10, 0, player_plo, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_7_marker, 20, 500, -300, -210, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_7_marker, 20, -60, 0, -10, 0, player_plo, 1, 0)
	Sleep(5)

	if TestValid(venator_1) then
		venator_1.Take_Damage(999999)
	end

	Sleep(4)

	if TestValid(venator_2) then
		venator_2.Take_Damage(999999)
	end

	Sleep(6)

	player_plo.Set_Cannot_Be_Killed(false)
	if TestValid(player_plo) then
		player_plo.Take_Damage(999999)
	end

	Sleep(2)

	Fade_Screen_Out(3)
	Sleep(3)

	junk_list_03 = Find_All_Objects_Of_Type("SPACE_JUNK_LARGE")
	for k,junks3 in pairs(junk_list_03) do
		if TestValid(junks3) then
			Hide_Object(junks3, 0)
		end
	end

	junk_list_04 = Find_All_Objects_Of_Type("SPACE_JUNK_HUGE")
	for l,junks4 in pairs(junk_list_04) do
		if TestValid(junks4) then
			Hide_Object(junks4, 0)
		end
	end

	Sleep(1)

	republic_unit_list = Find_All_Objects_Of_Type(p_republic)
	for k,repunits in pairs(republic_unit_list) do
		if TestValid(repunits) then
			repunits.Despawn()
		end
	end

	player_intro_malevolence.Teleport_And_Face(midtro_1_malevolence_marker)
	player_intro_malevolence.Suspend_Locomotor(true)

	Set_Cinematic_Camera_Key(midtrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_1_marker, 0, 0, 0, 0, midtrocam_target_malevolence_marker, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_2_marker, 14, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_2_marker, 14, 0, 0, 0, 0, midtrocam_target_malevolence_marker, 1, 0)

	Fade_Screen_In(3)
	Sleep(11)

	Fade_Screen_Out(2)
	Sleep(2.0)

	cis_unit_list = Find_All_Objects_Of_Type(p_cis)
	for z,seppies in pairs(cis_unit_list) do
		if TestValid(seppies) then
			seppies.Despawn()
		end
	end

	Stop_All_Music()
	Resume_Mode_Based_Music()
	Allow_Localized_SFX(true)
	SFXManager.Allow_HUD_VO(true)
	SFXManager.Allow_Ambient_VO(true)
	SFXManager.Allow_Enemy_Sighted_VO(true)
	SFXManager.Allow_Unit_Reponse_VO(true)

	Story_Event("PHASE_ONE")

	Sleep(1)

	Story_Event("PHASE_TWO")

	Fade_Screen_In(2)

	if not cinematic_two_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Midtro_CIS")
	end

end

function End_Cinematic_Midtro_CIS()

	Story_Event("GOAL_TRIGGER_CIS_II")
	Point_Camera_At(hunter_1_marker)
	Transition_To_Tactical_Camera(4)
	Letter_Box_Out(3)
	Sleep(4.0)
	End_Cinematic_Camera()
	Lock_Controls(0)
	Sleep(2.0)
	Suspend_AI(0)

	Sleep(1)

	act_1_active = false
	act_2_active = true

	Resume_Mode_Based_Music()
	Allow_Localized_SFX(true)
	SFXManager.Allow_HUD_VO(true)
	SFXManager.Allow_Ambient_VO(true)
	SFXManager.Allow_Enemy_Sighted_VO(true)
	SFXManager.Allow_Unit_Reponse_VO(true)
	cinematic_two = false

end

function Start_Cinematic_Midtro_02_CIS()
	cinematic_three = true
	Allow_Localized_SFX(false)
	SFXManager.Allow_HUD_VO(false)
	SFXManager.Allow_Ambient_VO(false)
	SFXManager.Allow_Enemy_Sighted_VO(false)
	SFXManager.Allow_Unit_Reponse_VO(false)

	Start_Cinematic_Camera()
	Lock_Controls(1)
	Suspend_AI(1)
	Cancel_Fast_Forward()
	Letter_Box_In(0.25)
	Remove_All_Text()
	Fade_Screen_Out(0.25)
	Sleep(0.25)

	Stop_All_Music()
	Play_Music("Abregado_Ambush_03")

	pod_plo = Spawn_Unit(Find_Object_Type("Republic_Escape_Pod"), pod_plo_marker, p_republic)
	pod_plo[1].Teleport_And_Face(pod_plo_marker)
	pod_plo[1].Suspend_Locomotor(true)

	player_droch = Spawn_Unit(Find_Object_Type("Droch_Boarding_Ship"), droch_marker, p_cis)
	player_droch = Find_Nearest(droch_marker, p_cis, true)
	player_droch.Teleport_And_Face(droch_marker)
	player_droch.Suspend_Locomotor(true)
	player_droch.Prevent_AI_Usage(true)

	player_twilight = Spawn_Unit(Find_Object_Type("Twilight"), droch_twilight_marker, p_republic)
	player_twilight = Find_Nearest(droch_twilight_marker, p_republic, true)
	player_twilight.Teleport_And_Face(droch_twilight_marker)
	player_twilight.Suspend_Locomotor(true)
	player_twilight.Override_Max_Speed(8)

	Fade_Screen_In(0.25)
	Set_Cinematic_Camera_Key(drochcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(drochcam_1_marker, 0, 0, 0, 0, pod_plo_marker, 1, 0)
	Transition_Cinematic_Camera_Key(drochcam_2_marker, 5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(drochcam_2_marker, 5, 0, 0, 0, 0, pod_plo_marker, 1, 0)
	Sleep(4.0)

	player_twilight.Suspend_Locomotor(false)
	player_twilight.Move_To(droch_twilight_move_to_marker)
	player_droch.Play_Animation("Undeploy", false)
	Sleep(1.0)

	Set_Cinematic_Camera_Key(drochcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(drochcam_3_marker, 0, 0, 0, 0, pod_plo_marker, 1, 0)
	Transition_Cinematic_Camera_Key(drochcam_4_marker, 10, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(drochcam_4_marker, 10, 0, 0, 0, 0, pod_plo_marker, 1, 0)
	Sleep(0.5)

	if TestValid(pod_plo[1]) then
		player_droch.Take_Damage(10000)
		Sleep(0.25)
		pod_plo[1].Attach_Particle_Effect("Rescue_Effect")
		Sleep(0.25)
		pod_plo[1].Despawn()
	end

	Sleep(2.0)

	Suspend_AI(0)
	Fade_Screen_Out(0.5)
	Sleep(1.5)

	Story_Event("PHASE_THREE")

	Fade_Screen_In(2)

	Set_Cinematic_Camera_Key(midtrocam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_5_marker, 0, 0, -200, 0, midtro_2_malevolence_marker, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_6_marker, 9, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_6_marker, 9, 0, 0, -200, 0, midtro_2_malevolence_marker, 1, 0)
	Sleep(9)

	if TestValid(player_twilight) then
	--player_twilight.Play_Animation("Undeploy", false)
		player_twilight.Move_To(escape_marker)
		player_twilight.Lock_Current_Orders()
	end

	Set_Cinematic_Camera_Key(player_twilight, -100, -200, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(player_twilight, 0, 0, 0, 0, player_twilight, 1, 0)
	Sleep(3)

	Story_Event("FLYING_NOW_04")

	if not cinematic_three_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")
	end
end

function End_Cinematic_Midtro_02_CIS()
	Point_Camera_At(player_midtro_malevolence)
	Transition_To_Tactical_Camera(3)
	Letter_Box_Out(3)
	Sleep(3.0)
	End_Cinematic_Camera()
	Lock_Controls(0)
	Sleep(1.0)
	Suspend_AI(0)

	Register_Prox(escape_marker, f_Prox_Escape, notice_range, p_republic)

	act_2_active = false
	act_3_active = true
	cinematic_three = false
	Story_Event("GOAL_TRIGGER_CIS_III")

	Add_Radar_Blip(escape_marker, "escape_blip")
	escape_marker.Highlight(true)

	Sleep(34.0)

	twilight_position = Find_First_Object("Twilight")

	player_hunter_4 = Spawn_Unit(Find_Object_Type("Vulture_Squadron_Half"), twilight_position, p_cis)
	player_hunter_4 = Find_Nearest(twilight_position, p_cis, true)
	player_hunter_4.Teleport_And_Face(twilight_position)
	player_hunter_4.Attack_Move(player_twilight)
	player_hunter_4.Override_Max_Speed(15)

	Sleep(1.0)

	if not act_3_active then
		Resume_Mode_Based_Music()
		Allow_Localized_SFX(true)
		SFXManager.Allow_HUD_VO(true)
		SFXManager.Allow_Ambient_VO(true)
		SFXManager.Allow_Enemy_Sighted_VO(true)
		SFXManager.Allow_Unit_Reponse_VO(true)
	end
end

function Start_Cinematic_Outro_CIS()
	cinematic_three = false
	act_3_active = false
	cinematic_four = true
	Start_Cinematic_Camera()
	Lock_Controls(1)
	Cancel_Fast_Forward()
	Letter_Box_In(0.5)
	Remove_All_Text()
	Point_Camera_At(player_twilight)

	if pod_plo_rescued then
		GlobalValue.Set("HfM_Plo_Rescued", 1)
	end

	Fade_Screen_Out(0.5)
	Sleep(0.5)

	player_twilight.Teleport_And_Face(outro_twilight_marker)

	player_midtro_malevolence.Teleport_And_Face(outro_malevolence_marker)
	player_midtro_malevolence.Suspend_Locomotor(true)

	Remove_Radar_Blip("escape_blip")
	escape_marker.Highlight(false)

	Set_Cinematic_Camera_Key(outrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_1_marker, 0, 0, 0, 0, player_twilight, 1, 0)
	Transition_Cinematic_Camera_Key(outrocam_2_marker, 50, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_2_marker, 50, 0, 0, 0, 0, player_twilight, 1, 0)

	Stop_All_Music()
	Allow_Localized_SFX(false)
	SFXManager.Allow_HUD_VO(false)
	SFXManager.Allow_Ambient_VO(false)
	SFXManager.Allow_Enemy_Sighted_VO(false)
	SFXManager.Allow_Unit_Reponse_VO(false)
	Play_Music("Abregado_Ambush_04")

	Fade_Screen_In(0.5)
	Sleep(0.25)

	if TestValid(player_twilight) then
	--player_twilight.Play_Animation("Deploy", false)
	end

	Sleep(1.25)

	if TestValid(player_twilight) then
		player_twilight.Hyperspace_Away(true)
	end

	Sleep(3.0)

	Transition_Cinematic_Camera_Key(outrocam_2_marker, 8, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_2_marker, 8, 0, 0, 0, 0, outrocam_target_malevolence_marker, 1, 0)
	Sleep(8)

	Transition_Cinematic_Camera_Key(outrocam_3_marker, 22, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_3_marker, 22, 0, 0, 0, 0, outrocam_target_malevolence_marker, 1, 0)
	Sleep(18)

	Fade_Screen_Out(3)
	Sleep(3)

	Allow_Localized_SFX(true)
	SFXManager.Allow_HUD_VO(true)
	SFXManager.Allow_Ambient_VO(true)
	SFXManager.Allow_Enemy_Sighted_VO(true)
	SFXManager.Allow_Unit_Reponse_VO(true)

	Story_Event("CIS_VICTORY")

end


function They_Fly_Now_01(message)
	if message == OnEnter then

		if TestValid(player_intro_malevolence) then
			player_intro_malevolence.Attack_Move(venator_1)

			rep_fighters = Find_All_Objects_Of_Type(p_republic, "Fighter | Bomber")
			for _,repfighters in pairs(rep_fighters) do
				if TestValid(repfighters) then
					repfighters.Despawn()
				end
			end
		end
	end
end

function They_Fly_Now_02(message)
	if message == OnEnter then
		if TestValid(player_twilight) then
			player_twilight.Move_To(twilight_move_to)
		end
	end
end

function They_Fly_Now_03(message)
	if message == OnEnter then
		if TestValid(player_twilight) then
			player_twilight.Move_To(venator_2_move_to)
		end
	end
end

function They_Fly_Now_04(message)
	if message == OnEnter then
		if TestValid(player_twilight) then
			player_twilight.Move_To(escape_marker)
		end
	end
end
