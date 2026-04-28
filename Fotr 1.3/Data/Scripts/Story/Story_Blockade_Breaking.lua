
--*****************************************************--
--******** Foerost Campaign: Blockade Breaking ********--
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
		Trigger_Blockade_Breached_Full = State_Blockade_Breached,
		Trigger_Blockade_Survived = State_Blockade_Survived,
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")

	cis_bulwark_fleet = {
		"Skirmish_Diamond_Frigate",
		"Skirmish_Diamond_Frigate",
		"Skirmish_Diamond_Frigate",
		"Skirmish_Geonosian_Cruiser",
		"Skirmish_Geonosian_Cruiser",
		"Skirmish_Geonosian_Cruiser",
		"Skirmish_Bulwark_I",
		"Skirmish_Bulwark_I",
		"Skirmish_Bulwark_I",
		"Skirmish_Hardcell",
		"Skirmish_Hardcell",
		"Skirmish_Hardcell",
		"Skirmish_Hardcell",
	}

	cis_ai_bulwark_fleet = {
		"Diamond_Frigate",
		"Diamond_Frigate",
		"Diamond_Frigate",
		"Geonosian_Cruiser",
		"Geonosian_Cruiser",
		"Geonosian_Cruiser",
		"Bulwark_I",
		"Bulwark_I",
		"Bulwark_I",
		"Hardcell",
		"Hardcell",
		"Hardcell",
		"Hardcell",
	}

	republic_avenger_list = {
		"Skirmish_Venator",
		"Skirmish_Venator",
		"Skirmish_Acclamator_Assault_Ship_I",
		"Skirmish_Acclamator_Assault_Ship_I",
		"Skirmish_Carrack_Cruiser_Lasers",
		"Skirmish_Carrack_Cruiser_Lasers",
		"Skirmish_Carrack_Cruiser_Lasers",
		"Skirmish_Carrack_Cruiser_Lasers",
		"Skirmish_CR90",
		"Skirmish_CR90",
		"Skirmish_DP20",
		"Skirmish_DP20",
		"Skirmish_LAC",
		"Skirmish_LAC",
	}

	republic_defender_list = {
		"Skirmish_Venator",
		"Skirmish_Acclamator_Assault_Ship_I",
		"Skirmish_Carrack_Cruiser_Lasers",
		"Skirmish_Carrack_Cruiser_Lasers",
		"Skirmish_CR90",
		"Skirmish_DP20",
		"Skirmish_LAC",
	}

	camera_offset = 125
	mission_started = false

	cinematic_crawl = false
	act_1_active = false
	act_2_active = false

	cinematic_one = false
	cinematic_two_alt_01 = false
	cinematic_two_alt_02 = false

	cinematic_crawl_skipped = false
	cinematic_one_skipped = false
	cinematic_two_alt_01_skipped = false
	cinematic_two_alt_02_skipped = false

	surveillance_station_dead = false
	cis_fleet_dead = false

	current_cinematic_thread_id = nil
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
		introcam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-8")
		introcam_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-9")
		introcam_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-10")
		introcam_11_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-11")
		introcam_12_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-12")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")
		introcam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")
		introcam_target_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-4")

		intro_1_bw_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-bw-1")
		intro_1_bw_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-bw-2")
		intro_1_bw_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-bw-3")
		intro_1_bw_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-bw-4")
		intro_1_bw_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-bw-5")
		intro_1_bw_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-bw-6")
		intro_1_bw_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-bw-7")
		intro_1_bw_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-bw-8")
		intro_1_bw_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-bw-9")

		intro_1_wolf_squadron_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-wolf")
		intro_2_wolf_squadron_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-wolf")

		outro_1_pod_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-1-pod")

		outro_1_ningo_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-1-ningo")
		outro_1_bw_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-1-bw-1")
		outro_1_bw_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-1-bw-2")

		outrocam_1_alt_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-1-alt-1")
		outrocam_2_alt_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-2-alt-1")
		outrocam_3_alt_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-3-alt-1")
		outrocam_4_alt_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-4-alt-1")

		outrocam_1_alt_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-1-alt-2")
		outrocam_2_alt_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-2-alt-2")

		rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-1")
		rep_fleet_02_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-2")
		rep_fleet_03_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-3")
		rep_fleet_04_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-4")
		rep_fleet_05_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-5")
		rep_fleet_06_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-6")
		rep_fleet_07_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-7")
		rep_fleet_08_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-8")
		rep_fleet_09_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-9")

		cis_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-fleet-1")

		player_station = Find_Hint("SURVEILLANCE_STATION_VALOR", "station")

		p_republic.Make_Ally(p_cis)
		p_cis.Make_Ally(p_republic)

		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Crawl_CIS")
		elseif p_republic.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
		end
	end
end


function State_Nebulae_Reached_CIS()
	Story_Event("BREAKOUT_10")

	player_bw_1 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), intro_1_bw_1_marker, p_cis)
	player_bw_1 = Find_Nearest(intro_1_bw_1_marker,"Skirmish_Bulwark_I")
	player_bw_1.Teleport_And_Face(intro_1_bw_1_marker)

	player_bw_2 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), intro_1_bw_2_marker, p_cis)
	player_bw_2 = Find_Nearest(intro_1_bw_2_marker,"Skirmish_Bulwark_I")
	player_bw_2.Teleport_And_Face(intro_1_bw_2_marker)

	player_bw_3 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), intro_1_bw_3_marker, p_cis)
	player_bw_3 = Find_Nearest(intro_1_bw_3_marker,"Skirmish_Bulwark_I")
	player_bw_3.Teleport_And_Face(intro_1_bw_3_marker)

	player_bw_4 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), intro_1_bw_4_marker, p_cis)
	player_bw_4 = Find_Nearest(intro_1_bw_4_marker,"Skirmish_Bulwark_I")
	player_bw_4.Teleport_And_Face(intro_1_bw_4_marker)

	player_bw_5 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), intro_1_bw_5_marker, p_cis)
	player_bw_5 = Find_Nearest(intro_1_bw_5_marker,"Skirmish_Bulwark_I")
	player_bw_5.Teleport_And_Face(intro_1_bw_5_marker)


	player_cis_1 = Spawn_Unit(Find_Object_Type("Skirmish_Diamond_Frigate"), intro_1_bw_1_marker, p_cis)
	player_cis_1 = Find_Nearest(intro_1_bw_1_marker,"Skirmish_Diamond_Frigate")
	player_cis_1.Teleport_And_Face(intro_1_bw_1_marker)

	player_cis_2 = Spawn_Unit(Find_Object_Type("Skirmish_Diamond_Frigate"), intro_1_bw_2_marker, p_cis)
	player_cis_2 = Find_Nearest(intro_1_bw_2_marker,"Skirmish_Diamond_Frigate")
	player_cis_2.Teleport_And_Face(intro_1_bw_2_marker)

	player_cis_3 = Spawn_Unit(Find_Object_Type("Skirmish_Diamond_Frigate"), intro_1_bw_3_marker, p_cis)
	player_cis_3 = Find_Nearest(intro_1_bw_3_marker,"Skirmish_Diamond_Frigate")
	player_cis_3.Teleport_And_Face(intro_1_bw_3_marker)

	player_cis_4 = Spawn_Unit(Find_Object_Type("Skirmish_Diamond_Frigate"), intro_1_bw_4_marker, p_cis)
	player_cis_4 = Find_Nearest(intro_1_bw_4_marker,"Skirmish_Diamond_Frigate")
	player_cis_4.Teleport_And_Face(intro_1_bw_4_marker)

	player_cis_5 = Spawn_Unit(Find_Object_Type("Skirmish_Hardcell"), intro_1_bw_5_marker, p_cis)
	player_cis_5 = Find_Nearest(intro_1_bw_5_marker,"Skirmish_Hardcell")
	player_cis_5.Teleport_And_Face(intro_1_bw_5_marker)

	player_cis_6 = Spawn_Unit(Find_Object_Type("Skirmish_Hardcell"), intro_1_bw_6_marker, p_cis)
	player_cis_6 = Find_Nearest(intro_1_bw_6_marker,"Skirmish_Hardcell")
	player_cis_6.Teleport_And_Face(intro_1_bw_6_marker)

	player_cis_7 = Spawn_Unit(Find_Object_Type("Skirmish_Hardcell"), intro_1_bw_7_marker, p_cis)
	player_cis_7 = Find_Nearest(intro_1_bw_7_marker,"Skirmish_Hardcell")
	player_cis_7.Teleport_And_Face(intro_1_bw_7_marker)

	player_cis_8 = Spawn_Unit(Find_Object_Type("Skirmish_Geonosian_Cruiser"), intro_1_bw_8_marker, p_cis)
	player_cis_8 = Find_Nearest(intro_1_bw_8_marker,"Skirmish_Geonosian_Cruiser")
	player_cis_8.Teleport_And_Face(intro_1_bw_8_marker)

	player_cis_9 = Spawn_Unit(Find_Object_Type("Skirmish_Geonosian_Cruiser"), intro_1_bw_9_marker, p_cis)
	player_cis_9 = Find_Nearest(intro_1_bw_9_marker,"Skirmish_Geonosian_Cruiser")
	player_cis_9.Teleport_And_Face(intro_1_bw_9_marker)

	Sleep(10)

	if p_republic.Get_Difficulty()== "Easy" then
		player_bw_6 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), intro_1_bw_6_marker, p_cis)
		player_bw_6 = Find_Nearest(intro_1_bw_6_marker,"Skirmish_Bulwark_I")
		player_bw_6.Teleport_And_Face(intro_1_bw_6_marker)

		player_bw_7 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), intro_1_bw_7_marker, p_cis)
		player_bw_7 = Find_Nearest(intro_1_bw_7_marker,"Skirmish_Bulwark_I")
		player_bw_7.Teleport_And_Face(intro_1_bw_7_marker)

		Register_Timer(State_Avenger_Fleet_Arrives_CIS, 240)
	elseif p_republic.Get_Difficulty()== "Hard" then
		Register_Timer(State_Avenger_Fleet_Arrives_CIS, 60)
	else
		player_bw_6 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), intro_1_bw_6_marker, p_cis)
		player_bw_6 = Find_Nearest(intro_1_bw_6_marker,"Skirmish_Bulwark_I")
		player_bw_6.Teleport_And_Face(intro_1_bw_6_marker)

		Register_Timer(State_Avenger_Fleet_Arrives_CIS, 150)
	end

	Register_Timer(State_Second_Wave_Arrives_CIS, 10)

	Story_Event("BREAKOUT_11")
	act_1_active = false
	act_2_active = true
end

function State_Nebulae_Reached_Rep()
	Remove_Radar_Blip("Nebula_Blip")
	Story_Event("GOAL_TRIGGER_REP_II")
	Story_Event("BREAKOUT_10")

	player_bw_1 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), intro_1_bw_1_marker, p_cis)
	player_bw_1 = Find_Nearest(intro_1_bw_1_marker,"Skirmish_Bulwark_I")
	player_bw_1.Teleport_And_Face(intro_1_bw_1_marker)

	player_bw_2 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), intro_1_bw_2_marker, p_cis)
	player_bw_2 = Find_Nearest(intro_1_bw_2_marker,"Skirmish_Bulwark_I")
	player_bw_2.Teleport_And_Face(intro_1_bw_2_marker)

	player_bw_3 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), intro_1_bw_3_marker, p_cis)
	player_bw_3 = Find_Nearest(intro_1_bw_3_marker,"Skirmish_Bulwark_I")
	player_bw_3.Teleport_And_Face(intro_1_bw_3_marker)

	player_bw_4 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), intro_1_bw_4_marker, p_cis)
	player_bw_4 = Find_Nearest(intro_1_bw_4_marker,"Skirmish_Bulwark_I")
	player_bw_4.Teleport_And_Face(intro_1_bw_4_marker)

	player_bw_5 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), intro_1_bw_5_marker, p_cis)
	player_bw_5 = Find_Nearest(intro_1_bw_5_marker,"Skirmish_Bulwark_I")
	player_bw_5.Teleport_And_Face(intro_1_bw_5_marker)


	player_cis_1 = Spawn_Unit(Find_Object_Type("Skirmish_Diamond_Frigate"), intro_1_bw_1_marker, p_cis)
	player_cis_1 = Find_Nearest(intro_1_bw_1_marker,"Skirmish_Diamond_Frigate")
	player_cis_1.Teleport_And_Face(intro_1_bw_1_marker)

	player_cis_2 = Spawn_Unit(Find_Object_Type("Skirmish_Diamond_Frigate"), intro_1_bw_2_marker, p_cis)
	player_cis_2 = Find_Nearest(intro_1_bw_2_marker,"Skirmish_Diamond_Frigate")
	player_cis_2.Teleport_And_Face(intro_1_bw_2_marker)

	player_cis_3 = Spawn_Unit(Find_Object_Type("Skirmish_Diamond_Frigate"), intro_1_bw_3_marker, p_cis)
	player_cis_3 = Find_Nearest(intro_1_bw_3_marker,"Skirmish_Diamond_Frigate")
	player_cis_3.Teleport_And_Face(intro_1_bw_3_marker)

	player_cis_4 = Spawn_Unit(Find_Object_Type("Skirmish_Diamond_Frigate"), intro_1_bw_4_marker, p_cis)
	player_cis_4 = Find_Nearest(intro_1_bw_4_marker,"Skirmish_Diamond_Frigate")
	player_cis_4.Teleport_And_Face(intro_1_bw_4_marker)

	player_cis_5 = Spawn_Unit(Find_Object_Type("Skirmish_Hardcell"), intro_1_bw_5_marker, p_cis)
	player_cis_5 = Find_Nearest(intro_1_bw_5_marker,"Skirmish_Hardcell")
	player_cis_5.Teleport_And_Face(intro_1_bw_5_marker)

	player_cis_6 = Spawn_Unit(Find_Object_Type("Skirmish_Hardcell"), intro_1_bw_6_marker, p_cis)
	player_cis_6 = Find_Nearest(intro_1_bw_6_marker,"Skirmish_Hardcell")
	player_cis_6.Teleport_And_Face(intro_1_bw_6_marker)

	player_cis_7 = Spawn_Unit(Find_Object_Type("Skirmish_Hardcell"), intro_1_bw_7_marker, p_cis)
	player_cis_7 = Find_Nearest(intro_1_bw_7_marker,"Skirmish_Hardcell")
	player_cis_7.Teleport_And_Face(intro_1_bw_7_marker)

	player_cis_8 = Spawn_Unit(Find_Object_Type("Skirmish_Geonosian_Cruiser"), intro_1_bw_8_marker, p_cis)
	player_cis_8 = Find_Nearest(intro_1_bw_8_marker,"Skirmish_Geonosian_Cruiser")
	player_cis_8.Teleport_And_Face(intro_1_bw_8_marker)

	player_cis_9 = Spawn_Unit(Find_Object_Type("Skirmish_Geonosian_Cruiser"), intro_1_bw_9_marker, p_cis)
	player_cis_9 = Find_Nearest(intro_1_bw_9_marker,"Skirmish_Geonosian_Cruiser")
	player_cis_9.Teleport_And_Face(intro_1_bw_9_marker)

	Sleep(10)

	if p_cis.Get_Difficulty()== "Easy" then
		Register_Timer(State_Second_Wave_Arrives_Rep, 240)
	elseif p_cis.Get_Difficulty()== "Hard" then
		player_bw_6 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), intro_1_bw_6_marker, p_cis)
		player_bw_6 = Find_Nearest(intro_1_bw_6_marker,"Skirmish_Bulwark_I")
		player_bw_6.Teleport_And_Face(intro_1_bw_6_marker)

		player_bw_7 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), intro_1_bw_7_marker, p_cis)
		player_bw_7 = Find_Nearest(intro_1_bw_7_marker,"Skirmish_Bulwark_I")
		player_bw_7.Teleport_And_Face(intro_1_bw_7_marker)

		player_bw_8 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), intro_1_bw_8_marker, p_cis)
		player_bw_8 = Find_Nearest(intro_1_bw_8_marker,"Skirmish_Bulwark_I")
		player_bw_8.Teleport_And_Face(intro_1_bw_8_marker)

		player_bw_9 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), intro_1_bw_9_marker, p_cis)
		player_bw_9 = Find_Nearest(intro_1_bw_9_marker,"Skirmish_Bulwark_I")
		player_bw_9.Teleport_And_Face(intro_1_bw_9_marker)

		Register_Timer(State_Second_Wave_Arrives_Rep, 90)
	else
		player_bw_6 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), intro_1_bw_6_marker, p_cis)
		player_bw_6 = Find_Nearest(intro_1_bw_6_marker,"Skirmish_Bulwark_I")
		player_bw_6.Teleport_And_Face(intro_1_bw_6_marker)

		player_bw_7 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), intro_1_bw_7_marker, p_cis)
		player_bw_7 = Find_Nearest(intro_1_bw_7_marker,"Skirmish_Bulwark_I")
		player_bw_7.Teleport_And_Face(intro_1_bw_7_marker)
		Register_Timer(State_Second_Wave_Arrives_Rep, 150)
	end

	Register_Timer(State_Avenger_Fleet_Arrives_Rep, 30)

	cis_list = Find_All_Objects_Of_Type(p_cis, "SpaceHero | Corvette | Capital | Frigate | SpaceStructure | SuperCapital")
	for k,cis_unit in pairs(cis_list) do
		if TestValid(cis_unit) then
			cis_unit.Attack_Move(Find_First_Object("SURVEILLANCE_STATION_VALOR"))
		end
	end

	Story_Event("BREAKOUT_11")
	act_1_active = false
	act_2_active = true
end

function State_Second_Wave_Arrives_CIS()
	player_bw_1 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), intro_1_bw_1_marker, p_cis)
	player_bw_1 = Find_Nearest(intro_1_bw_1_marker,"Skirmish_Bulwark_I")
	player_bw_1.Teleport_And_Face(intro_1_bw_1_marker)

	player_bw_2 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), intro_1_bw_2_marker, p_cis)
	player_bw_2 = Find_Nearest(intro_1_bw_2_marker,"Skirmish_Bulwark_I")
	player_bw_2.Teleport_And_Face(intro_1_bw_2_marker)

	player_bw_3 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), intro_1_bw_3_marker, p_cis)
	player_bw_3 = Find_Nearest(intro_1_bw_3_marker,"Skirmish_Bulwark_I")
	player_bw_3.Teleport_And_Face(intro_1_bw_3_marker)


	player_cis_1 = Spawn_Unit(Find_Object_Type("Skirmish_Diamond_Frigate"), intro_1_bw_1_marker, p_cis)
	player_cis_1 = Find_Nearest(intro_1_bw_1_marker,"Skirmish_Diamond_Frigate")
	player_cis_1.Teleport_And_Face(intro_1_bw_1_marker)

	player_cis_2 = Spawn_Unit(Find_Object_Type("Skirmish_Diamond_Frigate"), intro_1_bw_2_marker, p_cis)
	player_cis_2 = Find_Nearest(intro_1_bw_2_marker,"Skirmish_Diamond_Frigate")
	player_cis_2.Teleport_And_Face(intro_1_bw_2_marker)

	player_cis_5 = Spawn_Unit(Find_Object_Type("Skirmish_Hardcell"), intro_1_bw_5_marker, p_cis)
	player_cis_5 = Find_Nearest(intro_1_bw_5_marker,"Skirmish_Hardcell")
	player_cis_5.Teleport_And_Face(intro_1_bw_5_marker)

	player_cis_6 = Spawn_Unit(Find_Object_Type("Skirmish_Hardcell"), intro_1_bw_6_marker, p_cis)
	player_cis_6 = Find_Nearest(intro_1_bw_6_marker,"Skirmish_Hardcell")
	player_cis_6.Teleport_And_Face(intro_1_bw_6_marker)

	player_cis_7 = Spawn_Unit(Find_Object_Type("Skirmish_Hardcell"), intro_1_bw_7_marker, p_cis)
	player_cis_7 = Find_Nearest(intro_1_bw_7_marker,"Skirmish_Hardcell")
	player_cis_7.Teleport_And_Face(intro_1_bw_7_marker)

	player_cis_8 = Spawn_Unit(Find_Object_Type("Skirmish_Geonosian_Cruiser"), intro_1_bw_8_marker, p_cis)
	player_cis_8 = Find_Nearest(intro_1_bw_8_marker,"Skirmish_Geonosian_Cruiser")
	player_cis_8.Teleport_And_Face(intro_1_bw_8_marker)

	player_cis_9 = Spawn_Unit(Find_Object_Type("Skirmish_Geonosian_Cruiser"), intro_1_bw_9_marker, p_cis)
	player_cis_9 = Find_Nearest(intro_1_bw_9_marker,"Skirmish_Geonosian_Cruiser")
	player_cis_9.Teleport_And_Face(intro_1_bw_9_marker)
end

function State_Second_Wave_Arrives_Rep()
	player_bw_1 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), intro_1_bw_1_marker, p_cis)
	player_bw_1 = Find_Nearest(intro_1_bw_1_marker,"Skirmish_Bulwark_I")
	player_bw_1.Teleport_And_Face(intro_1_bw_1_marker)

	player_bw_2 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), intro_1_bw_2_marker, p_cis)
	player_bw_2 = Find_Nearest(intro_1_bw_2_marker,"Skirmish_Bulwark_I")
	player_bw_2.Teleport_And_Face(intro_1_bw_2_marker)

	player_bw_3 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), intro_1_bw_3_marker, p_cis)
	player_bw_3 = Find_Nearest(intro_1_bw_3_marker,"Skirmish_Bulwark_I")
	player_bw_3.Teleport_And_Face(intro_1_bw_3_marker)

	player_bw_4 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), intro_1_bw_4_marker, p_cis)
	player_bw_4 = Find_Nearest(intro_1_bw_4_marker,"Skirmish_Bulwark_I")
	player_bw_4.Teleport_And_Face(intro_1_bw_4_marker)


	player_cis_1 = Spawn_Unit(Find_Object_Type("Skirmish_Diamond_Frigate"), intro_1_bw_1_marker, p_cis)
	player_cis_1 = Find_Nearest(intro_1_bw_1_marker,"Skirmish_Diamond_Frigate")
	player_cis_1.Teleport_And_Face(intro_1_bw_1_marker)

	player_cis_2 = Spawn_Unit(Find_Object_Type("Skirmish_Diamond_Frigate"), intro_1_bw_2_marker, p_cis)
	player_cis_2 = Find_Nearest(intro_1_bw_2_marker,"Skirmish_Diamond_Frigate")
	player_cis_2.Teleport_And_Face(intro_1_bw_2_marker)

	player_cis_5 = Spawn_Unit(Find_Object_Type("Skirmish_Hardcell"), intro_1_bw_5_marker, p_cis)
	player_cis_5 = Find_Nearest(intro_1_bw_5_marker,"Skirmish_Hardcell")
	player_cis_5.Teleport_And_Face(intro_1_bw_5_marker)

	player_cis_6 = Spawn_Unit(Find_Object_Type("Skirmish_Hardcell"), intro_1_bw_6_marker, p_cis)
	player_cis_6 = Find_Nearest(intro_1_bw_6_marker,"Skirmish_Hardcell")
	player_cis_6.Teleport_And_Face(intro_1_bw_6_marker)

	player_cis_7 = Spawn_Unit(Find_Object_Type("Skirmish_Hardcell"), intro_1_bw_7_marker, p_cis)
	player_cis_7 = Find_Nearest(intro_1_bw_7_marker,"Skirmish_Hardcell")
	player_cis_7.Teleport_And_Face(intro_1_bw_7_marker)

	player_cis_8 = Spawn_Unit(Find_Object_Type("Skirmish_Geonosian_Cruiser"), intro_1_bw_8_marker, p_cis)
	player_cis_8 = Find_Nearest(intro_1_bw_8_marker,"Skirmish_Geonosian_Cruiser")
	player_cis_8.Teleport_And_Face(intro_1_bw_8_marker)

	player_cis_9 = Spawn_Unit(Find_Object_Type("Skirmish_Geonosian_Cruiser"), intro_1_bw_9_marker, p_cis)
	player_cis_9 = Find_Nearest(intro_1_bw_9_marker,"Skirmish_Geonosian_Cruiser")
	player_cis_9.Teleport_And_Face(intro_1_bw_9_marker)

	Sleep(5.0)

	cis_list = Find_All_Objects_Of_Type(p_cis, "SpaceHero | Corvette | Capital | Frigate | SpaceStructure | SuperCapital")
	for k,cis_unit in pairs(cis_list) do
		if TestValid(cis_unit) then
			cis_unit.Attack_Move(Find_First_Object("SURVEILLANCE_STATION_VALOR"))
		end
	end

	Story_Event("ACTIVATE_CIS_AI")

end

function State_Avenger_Fleet_Arrives_CIS()
	avenger_fleet_arrived = true
	player_rep_1 = Spawn_Unit(Find_Object_Type("Skirmish_Venator"), rep_fleet_01_marker, p_republic)
	player_rep_1 = Find_Nearest(rep_fleet_01_marker,"Skirmish_Venator")
	player_rep_1.Teleport_And_Face(rep_fleet_01_marker)
	player_rep_1.Cinematic_Hyperspace_In(150)

	player_rep_2 = Spawn_Unit(Find_Object_Type("Skirmish_Venator"), rep_fleet_02_marker, p_republic)
	player_rep_2 = Find_Nearest(rep_fleet_02_marker,"Skirmish_Venator")
	player_rep_2.Teleport_And_Face(rep_fleet_02_marker)
	player_rep_2.Cinematic_Hyperspace_In(150)

	player_rep_3 = Spawn_Unit(Find_Object_Type("Skirmish_Acclamator_Assault_Ship_I"), rep_fleet_03_marker, p_republic)
	player_rep_3 = Find_Nearest(rep_fleet_03_marker,"Skirmish_Acclamator_Assault_Ship_I")
	player_rep_3.Teleport_And_Face(rep_fleet_03_marker)
	player_rep_3.Cinematic_Hyperspace_In(150)

	player_rep_4 = Spawn_Unit(Find_Object_Type("Skirmish_Acclamator_Assault_Ship_I"), rep_fleet_04_marker, p_republic)
	player_rep_4 = Find_Nearest(rep_fleet_04_marker,"Skirmish_Acclamator_Assault_Ship_I")
	player_rep_4.Teleport_And_Face(rep_fleet_04_marker)
	player_rep_4.Cinematic_Hyperspace_In(150)

	player_rep_5 = Spawn_Unit(Find_Object_Type("Skirmish_Carrack_Cruiser_Lasers"), rep_fleet_05_marker, p_republic)
	player_rep_5 = Find_Nearest(rep_fleet_05_marker,"Skirmish_Carrack_Cruiser_Lasers")
	player_rep_5.Teleport_And_Face(rep_fleet_05_marker)
	player_rep_5.Cinematic_Hyperspace_In(150)

	player_rep_6 = Spawn_Unit(Find_Object_Type("Skirmish_CR90"), rep_fleet_06_marker, p_republic)
	player_rep_6 = Find_Nearest(rep_fleet_06_marker,"Skirmish_CR90")
	player_rep_6.Teleport_And_Face(rep_fleet_06_marker)
	player_rep_6.Cinematic_Hyperspace_In(150)

	player_rep_7 = Spawn_Unit(Find_Object_Type("Skirmish_CR90"), rep_fleet_07_marker, p_republic)
	player_rep_7 = Find_Nearest(rep_fleet_07_marker,"Skirmish_CR90")
	player_rep_7.Teleport_And_Face(rep_fleet_07_marker)
	player_rep_7.Cinematic_Hyperspace_In(150)

	player_rep_8 = Spawn_Unit(Find_Object_Type("Skirmish_DP20"), rep_fleet_08_marker, p_republic)
	player_rep_8 = Find_Nearest(rep_fleet_08_marker,"Skirmish_DP20")
	player_rep_8.Teleport_And_Face(rep_fleet_08_marker)
	player_rep_8.Cinematic_Hyperspace_In(150)

	player_rep_9 = Spawn_Unit(Find_Object_Type("Skirmish_DP20"), rep_fleet_09_marker, p_republic)
	player_rep_9 = Find_Nearest(rep_fleet_09_marker,"Skirmish_DP20")
	player_rep_9.Teleport_And_Face(rep_fleet_09_marker)
	player_rep_9.Cinematic_Hyperspace_In(150)

	Story_Event("BREAKOUT_12")
end

function State_Avenger_Fleet_Arrives_Rep()
	avenger_fleet_arrived = true
	player_rep_1 = Spawn_Unit(Find_Object_Type("Skirmish_Venator"), rep_fleet_01_marker, p_republic)
	player_rep_1 = Find_Nearest(rep_fleet_01_marker,"Skirmish_Venator")
	player_rep_1.Teleport_And_Face(rep_fleet_01_marker)
	player_rep_1.Cinematic_Hyperspace_In(150)

	player_rep_2 = Spawn_Unit(Find_Object_Type("Skirmish_Venator"), rep_fleet_02_marker, p_republic)
	player_rep_2 = Find_Nearest(rep_fleet_02_marker,"Skirmish_Venator")
	player_rep_2.Teleport_And_Face(rep_fleet_02_marker)
	player_rep_2.Cinematic_Hyperspace_In(150)

	player_rep_3 = Spawn_Unit(Find_Object_Type("Skirmish_Acclamator_Assault_Ship_I"), rep_fleet_03_marker, p_republic)
	player_rep_3 = Find_Nearest(rep_fleet_03_marker,"Skirmish_Acclamator_Assault_Ship_I")
	player_rep_3.Teleport_And_Face(rep_fleet_03_marker)
	player_rep_3.Cinematic_Hyperspace_In(150)

	player_rep_4 = Spawn_Unit(Find_Object_Type("Skirmish_Acclamator_Assault_Ship_I"), rep_fleet_04_marker, p_republic)
	player_rep_4 = Find_Nearest(rep_fleet_04_marker,"Skirmish_Acclamator_Assault_Ship_I")
	player_rep_4.Teleport_And_Face(rep_fleet_04_marker)
	player_rep_4.Cinematic_Hyperspace_In(150)

	player_rep_5 = Spawn_Unit(Find_Object_Type("Skirmish_Carrack_Cruiser_Lasers"), rep_fleet_05_marker, p_republic)
	player_rep_5 = Find_Nearest(rep_fleet_05_marker,"Skirmish_Carrack_Cruiser_Lasers")
	player_rep_5.Teleport_And_Face(rep_fleet_05_marker)
	player_rep_5.Cinematic_Hyperspace_In(150)

	player_rep_6 = Spawn_Unit(Find_Object_Type("Skirmish_CR90"), rep_fleet_06_marker, p_republic)
	player_rep_6 = Find_Nearest(rep_fleet_06_marker,"Skirmish_CR90")
	player_rep_6.Teleport_And_Face(rep_fleet_06_marker)
	player_rep_6.Cinematic_Hyperspace_In(150)

	player_rep_7 = Spawn_Unit(Find_Object_Type("Skirmish_CR90"), rep_fleet_07_marker, p_republic)
	player_rep_7 = Find_Nearest(rep_fleet_07_marker,"Skirmish_CR90")
	player_rep_7.Teleport_And_Face(rep_fleet_07_marker)
	player_rep_7.Cinematic_Hyperspace_In(150)

	player_rep_8 = Spawn_Unit(Find_Object_Type("Skirmish_DP20"), rep_fleet_08_marker, p_republic)
	player_rep_8 = Find_Nearest(rep_fleet_08_marker,"Skirmish_DP20")
	player_rep_8.Teleport_And_Face(rep_fleet_08_marker)
	player_rep_8.Cinematic_Hyperspace_In(150)

	player_rep_9 = Spawn_Unit(Find_Object_Type("Skirmish_DP20"), rep_fleet_09_marker, p_republic)
	player_rep_9 = Find_Nearest(rep_fleet_09_marker,"Skirmish_DP20")
	player_rep_9.Teleport_And_Face(rep_fleet_09_marker)
	player_rep_9.Cinematic_Hyperspace_In(150)

	Story_Event("BREAKOUT_12")
end

function State_Station_Destroyed()
	surveillance_station_dead = true
	act_2_active = false
	Sleep(3.0)
	Story_Event("BLOCKADE_BREACHED")
end

function State_Blockade_Breached(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS_Alt_01")
		elseif p_republic.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep_Alt_01")
		end
	end
end

function State_Blockade_Breached(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS_Alt_01")
		elseif p_republic.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep_Alt_01")
		end
	end
end

function State_Blockade_Survived(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS_Alt_02")
		elseif p_republic.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep_Alt_02")
		end
	end
end


function Story_Handle_Esc()
	if p_cis.Is_Human() then
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

				Allow_Localized_SFX(true)
				SFXManager.Allow_HUD_VO(true)
				SFXManager.Allow_Ambient_VO(true)
				SFXManager.Allow_Enemy_Sighted_VO(true)
				SFXManager.Allow_Unit_Reponse_VO(true)
				Resume_Mode_Based_Music()

				Register_Timer(State_Nebulae_Reached_CIS, 1)

				Letter_Box_Out(0)
				Point_Camera_At(intro_1_bw_1_marker)
				Lock_Controls(0)
				Suspend_AI(0)
				End_Cinematic_Camera()

				Story_Event("GOAL_TRIGGER_CIS_I")
				Story_Event("ACTIVATE_REP_AI")

				p_republic.Make_Enemy(p_cis)
				p_cis.Make_Enemy(p_republic)

				cinematic_one = false
				act_1_active = true

				Fade_Screen_In(0.5)
				Sleep(0.5)
			end
		end
		if cinematic_two_alt_01 then
			if not cinematic_two_alt_01_skipped then
				cinematic_two_alt_01_skipped = true
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

				Story_Event("CIS_VICTORY")
			end
		end
		if cinematic_two_alt_02 then
			if not cinematic_two_alt_02_skipped then
				cinematic_two_alt_02_skipped = true
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

				Story_Event("REPUBLIC_VICTORY")
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

				Add_Radar_Blip(intro_2_wolf_squadron_marker, "Nebula_Blip")
				Register_Timer(State_Nebulae_Reached_Rep, 20)

				Letter_Box_Out(0)
				Point_Camera_At(intro_1_wolf_squadron_marker)
				Lock_Controls(0)
				Suspend_AI(0)
				End_Cinematic_Camera()

				Story_Event("GOAL_TRIGGER_REP_I")
				Story_Event("ACTIVATE_CIS_AI")

				p_republic.Make_Enemy(p_cis)
				p_cis.Make_Enemy(p_republic)

				cinematic_one = false
				act_1_active = true

				Fade_Screen_In(0.5)
				Sleep(0.5)
			end
		end
		if cinematic_two_alt_01 then
			if not cinematic_two_alt_01_skipped then
				cinematic_two_alt_01_skipped = true
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

				Story_Event("CIS_VICTORY")
			end
		end
		if cinematic_two_alt_02 then
			if not cinematic_two_alt_02_skipped then
				cinematic_two_alt_02_skipped = true
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

				Story_Event("REPUBLIC_VICTORY")
			end
		end
	end
end

function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_2_active then
			if not surveillance_station_dead then
				if not TestValid(Find_First_Object("SURVEILLANCE_STATION_VALOR")) then
					surveillance_station_dead = true
					act_2_active = false
					Sleep(3.0)
					Story_Event("BLOCKADE_BREACHED")
				end
			end
			cis_list = Find_All_Objects_Of_Type(p_cis, "SpaceHero | Corvette | Capital | Frigate | SpaceStructure | SuperCapital")
			if (table.getn(cis_list) == 0) then
				if not cis_fleet_dead then
					cis_fleet_dead = true
					act_2_active = false
					Story_Event("BLOCKADE_SURVIVED")
				end
			end
		end
	elseif p_republic.Is_Human() then
		if act_2_active then
			if not surveillance_station_dead then
				if not TestValid(Find_First_Object("SURVEILLANCE_STATION_VALOR")) then
					surveillance_station_dead = true
					act_2_active = false
					Sleep(3.0)
					Story_Event("BLOCKADE_BREACHED")
				end
			end
			cis1_list = Find_All_Objects_Of_Type(p_cis, "Skirmish_Bulwark_I")
			cis2_list = Find_All_Objects_Of_Type(p_cis, "Skirmish_Diamond_Frigate")
			cis3_list = Find_All_Objects_Of_Type(p_cis, "Skirmish_Hardcell")
			cis4_list = Find_All_Objects_Of_Type(p_cis, "Skirmish_Geonosian_Cruiser")
			if (table.getn(cis1_list) == 0) and (table.getn(cis2_list) == 0) and (table.getn(cis3_list) == 0) and (table.getn(cis4_list) == 0) then
				if not cis_fleet_dead then
					cis_fleet_dead = true
					act_2_active = false
					Story_Event("BLOCKADE_SURVIVED")
				end
			end
		end
	end
end


function Start_Cinematic_Crawl_CIS()
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
	BlockOnCommand(Play_Bink_Movie("Foerost_Campaign_CIS_Intro"))

	Weather_Audio_Pause(false)
	Set_Cinematic_Environment(false)
	Allow_Localized_SFX(true)
	SFXManager.Allow_HUD_VO(true)
	SFXManager.Allow_Ambient_VO(true)
	SFXManager.Allow_Enemy_Sighted_VO(true)
	SFXManager.Allow_Unit_Reponse_VO(true)

	if not cinematic_crawl_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
	end
end

function Start_Cinematic_Intro_CIS()
	cinematic_crawl = false

	Transition_Cinematic_Camera_Key(introcam_2_marker, 22.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 22.0, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Letter_Box_In(1.0)

	player_wolf_squadron = Find_First_Object("ARC_170")
	mama_wolf = player_wolf_squadron.Get_Parent_Object()
	mama_wolf.Override_Max_Speed(4.5)

	Register_Death_Event(player_station, State_Station_Destroyed)

	cinematic_one = true

	Play_Music("Foerost_Fallen_01")
	Story_Event("CINEMATIC_CRAWL_01")
	Sleep(3.0)

	Story_Event("CINEMATIC_CRAWL_02")
	Sleep(10.0)

	Story_Event("BREAKOUT_01")
	Sleep(5.5)

	Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_4_marker, 17.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_4_marker, 17.5, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Story_Event("BREAKOUT_02")
	Story_Event("BREAKOUT_03")
	Sleep(17.0)

	Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_5_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_6_marker, 15.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_6_marker, 15.5, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Story_Event("BREAKOUT_04")
	Story_Event("BREAKOUT_05")
	Sleep(15.0)

	Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_8_marker, 6.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_8_marker, 6.5, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Story_Event("BREAKOUT_06")
	Sleep(6.5)

	Set_Cinematic_Camera_Key(introcam_9_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_9_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_10_marker, 14.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_10_marker, 14.5, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
	Story_Event("BREAKOUT_07")
	Story_Event("BREAKOUT_08")
	Sleep(15.0)

	Set_Cinematic_Camera_Key(introcam_11_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_11_marker, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_12_marker, 5.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_12_marker, 6.5, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
	Story_Event("BREAKOUT_09")
	Sleep(5.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end

function End_Cinematic_Intro_CIS()
	Point_Camera_At(intro_1_bw_1_marker)
	Resume_Mode_Based_Music()
	Transition_To_Tactical_Camera(3)
	Letter_Box_Out(3)
	Fade_Screen_In(.1)
	Sleep(3.0)
	End_Cinematic_Camera()
	Suspend_AI(0)
	Lock_Controls(0)

	Story_Event("GOAL_TRIGGER_CIS_I")
	Story_Event("ACTIVATE_REP_AI")

	Register_Timer(State_Nebulae_Reached_CIS, 1)

	p_republic.Make_Enemy(p_cis)
	p_cis.Make_Enemy(p_republic)

	cinematic_one = false
	act_1_active = true
end


function Start_Cinematic_Outro_CIS_Alt_01()
	act_2_active = false
	cinematic_two_alt_01 = true

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

	Do_End_Cinematic_Cleanup()
	player_pod = Spawn_Unit(Find_Object_Type("REPUBLIC_ESCAPE_POD"), outro_1_pod_marker, p_republic)
	player_pod = Find_Nearest(outro_1_pod_marker,"REPUBLIC_ESCAPE_POD")
	player_pod.Teleport_And_Face(outro_1_pod_marker)

	Fade_On()
	Play_Music("REP_Defeat")
	Sleep(1)

	player_bw_1 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), outro_1_ningo_marker, p_cis)
	player_bw_1 = Find_Nearest(outro_1_ningo_marker,"Skirmish_Bulwark_I")
	player_bw_1.Teleport_And_Face(outro_1_ningo_marker)

	player_bw_2 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), outro_1_bw_1_marker, p_cis)
	player_bw_2 = Find_Nearest(outro_1_bw_1_marker,"Skirmish_Bulwark_I")
	player_bw_2.Teleport_And_Face(outro_1_bw_1_marker)

	player_bw_3 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), outro_1_bw_2_marker, p_cis)
	player_bw_3 = Find_Nearest(outro_1_bw_2_marker,"Skirmish_Bulwark_I")
	player_bw_3.Teleport_And_Face(outro_1_bw_2_marker)

	Letter_Box_In(1.0)
	Fade_Screen_In(2.0)
	Story_Event("BREAKOUT_13_ALT_01")
	Set_Cinematic_Camera_Key(outrocam_1_alt_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_1_alt_1_marker, 0, 0, 0, 0, player_pod, 1, 0)
	Transition_Cinematic_Camera_Key(outrocam_2_alt_1_marker, 8, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_2_alt_1_marker, 8, 0, 0, 0, 0, player_pod, 1, 0)
	Sleep(10)

	Fade_Screen_In(0.5)
	Set_Cinematic_Camera_Key(outrocam_3_alt_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_3_alt_1_marker, 0, 0, 0, 0, outro_1_ningo_marker, 1, 0)
	Transition_Cinematic_Camera_Key(outrocam_4_alt_1_marker, 8, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_4_alt_1_marker, 8, 0, 0, 0, 0, outro_1_ningo_marker, 1, 0)
	Story_Event("BREAKOUT_14_ALT_01")
	Sleep(4)

	player_bw_1.Hyperspace_Away(true)
	player_bw_2.Hyperspace_Away(true)
	player_bw_3.Hyperspace_Away(true)

	Fade_Screen_Out(2)
	Sleep(3)

	Resume_Mode_Based_Music()
	Allow_Localized_SFX(true)
	SFXManager.Allow_HUD_VO(true)
	SFXManager.Allow_Ambient_VO(true)
	SFXManager.Allow_Unit_Reponse_VO(true)
	SFXManager.Allow_Enemy_Sighted_VO(true)
	SFXManager.Allow_Localized_SFXEvents(true)

	Story_Event("CIS_VICTORY")
end

function Start_Cinematic_Outro_CIS_Alt_02()
	act_2_active = false
	cinematic_two_alt_02 = true

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

	Do_End_Cinematic_Cleanup()
	Fade_On()
	Play_Music("REP_Defeat")
	Sleep(1)

	player_bw_1 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), outro_1_ningo_marker, p_cis)
	player_bw_1 = Find_Nearest(outro_1_ningo_marker,"Skirmish_Bulwark_I")
	player_bw_1.Teleport_And_Face(outro_1_ningo_marker)

	player_bw_2 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), outro_1_bw_1_marker, p_cis)
	player_bw_2 = Find_Nearest(outro_1_bw_1_marker,"Skirmish_Bulwark_I")
	player_bw_2.Teleport_And_Face(outro_1_bw_1_marker)

	player_bw_3 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), outro_1_bw_2_marker, p_cis)
	player_bw_3 = Find_Nearest(outro_1_bw_2_marker,"Skirmish_Bulwark_I")
	player_bw_3.Teleport_And_Face(outro_1_bw_2_marker)

	Letter_Box_In(1.0)
	Fade_Screen_In(2.0)
	Story_Event("BREAKOUT_13_ALT_02")
	Story_Event("BREAKOUT_14_ALT_02")
	Set_Cinematic_Camera_Key(introcam_4_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_4_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(outrocam_2_alt_2_marker, 15, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_2_alt_2_marker, 15, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Sleep(14)

	Fade_Screen_In(0.5)
	Set_Cinematic_Camera_Key(outrocam_3_alt_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_3_alt_1_marker, 0, 0, 0, 0, outro_1_ningo_marker, 1, 0)
	Transition_Cinematic_Camera_Key(outrocam_4_alt_1_marker, 8, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_4_alt_1_marker, 8, 0, 0, 0, 0, outro_1_ningo_marker, 1, 0)
	Story_Event("BREAKOUT_14_ALT_01")
	Sleep(4)

	player_bw_1.Hyperspace_Away(true)
	player_bw_2.Hyperspace_Away(true)
	player_bw_3.Hyperspace_Away(true)

	Fade_Screen_Out(2)
	Sleep(3)

	Resume_Mode_Based_Music()
	Allow_Localized_SFX(true)
	SFXManager.Allow_HUD_VO(true)
	SFXManager.Allow_Ambient_VO(true)
	SFXManager.Allow_Unit_Reponse_VO(true)
	SFXManager.Allow_Enemy_Sighted_VO(true)
	SFXManager.Allow_Localized_SFXEvents(true)

	Story_Event("REPUBLIC_VICTORY")
end


function Start_Cinematic_Intro_Rep()
	Start_Cinematic_Camera()
	Stop_All_Music()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()
	Fade_On()

	player_wolf_squadron = Find_First_Object("ARC_170")
	mama_wolf = player_wolf_squadron.Get_Parent_Object()
	mama_wolf.Override_Max_Speed(4.5)

	Register_Death_Event(player_station, State_Station_Destroyed)

	cinematic_one = true

	Fade_Screen_In(5)
	Letter_Box_In(3)

	Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 18.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 18.5, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)

	Play_Music("Foerost_Fallen_01")
	Story_Event("CINEMATIC_CRAWL_01")
	Sleep(3.0)

	Story_Event("CINEMATIC_CRAWL_02")
	Sleep(10.0)

	Story_Event("BREAKOUT_01")
	Sleep(5.5)

	Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_4_marker, 17.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_4_marker, 17.5, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Story_Event("BREAKOUT_02")
	Story_Event("BREAKOUT_03")
	Sleep(17.0)

	Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_5_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_6_marker, 15.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_6_marker, 15.5, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Story_Event("BREAKOUT_04")
	Story_Event("BREAKOUT_05")
	Sleep(15.0)

	Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_8_marker, 6.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_8_marker, 6.5, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Story_Event("BREAKOUT_06")
	Sleep(6.5)

	Set_Cinematic_Camera_Key(introcam_9_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_9_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_10_marker, 14.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_10_marker, 14.5, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
	Story_Event("BREAKOUT_07")
	Story_Event("BREAKOUT_08")
	Sleep(15.0)

	Set_Cinematic_Camera_Key(introcam_11_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_11_marker, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_12_marker, 5.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_12_marker, 6.5, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
	Story_Event("BREAKOUT_09")
	Sleep(5.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Rep")
	end
end

function End_Cinematic_Intro_Rep()
	Point_Camera_At(intro_1_wolf_squadron_marker)
	Resume_Mode_Based_Music()
	Transition_To_Tactical_Camera(3)
	Letter_Box_Out(3)
	Fade_Screen_In(.1)
	Sleep(3.0)
	End_Cinematic_Camera()
	Suspend_AI(0)
	Lock_Controls(0)

	Story_Event("GOAL_TRIGGER_REP_I")
	Story_Event("ACTIVATE_CIS_AI")

	Add_Radar_Blip(intro_2_wolf_squadron_marker, "Nebula_Blip")

	Register_Timer(State_Nebulae_Reached_Rep, 20)

	p_republic.Make_Enemy(p_cis)
	p_cis.Make_Enemy(p_republic)

	cinematic_one = false
	act_1_active = true
end


function Start_Cinematic_Outro_Rep_Alt_01()
	act_2_active = false
	cinematic_two_alt_01 = true

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

	Do_End_Cinematic_Cleanup()
	player_pod = Spawn_Unit(Find_Object_Type("REPUBLIC_ESCAPE_POD"), outro_1_pod_marker, p_republic)
	player_pod = Find_Nearest(outro_1_pod_marker,"REPUBLIC_ESCAPE_POD")
	player_pod.Teleport_And_Face(outro_1_pod_marker)

	Fade_On()
	Play_Music("REP_Defeat")
	Sleep(1)

	player_bw_1 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), outro_1_ningo_marker, p_cis)
	player_bw_1 = Find_Nearest(outro_1_ningo_marker,"Skirmish_Bulwark_I")
	player_bw_1.Teleport_And_Face(outro_1_ningo_marker)

	player_bw_2 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), outro_1_bw_1_marker, p_cis)
	player_bw_2 = Find_Nearest(outro_1_bw_1_marker,"Skirmish_Bulwark_I")
	player_bw_2.Teleport_And_Face(outro_1_bw_1_marker)

	player_bw_3 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), outro_1_bw_2_marker, p_cis)
	player_bw_3 = Find_Nearest(outro_1_bw_2_marker,"Skirmish_Bulwark_I")
	player_bw_3.Teleport_And_Face(outro_1_bw_2_marker)

	Letter_Box_In(1.0)
	Fade_Screen_In(2.0)
	Story_Event("BREAKOUT_13_ALT_01")
	Set_Cinematic_Camera_Key(outrocam_1_alt_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_1_alt_1_marker, 0, 0, 0, 0, player_pod, 1, 0)
	Transition_Cinematic_Camera_Key(outrocam_2_alt_1_marker, 8, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_2_alt_1_marker, 8, 0, 0, 0, 0, player_pod, 1, 0)
	Sleep(10)

	Fade_Screen_In(0.5)
	Set_Cinematic_Camera_Key(outrocam_3_alt_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_3_alt_1_marker, 0, 0, 0, 0, outro_1_ningo_marker, 1, 0)
	Transition_Cinematic_Camera_Key(outrocam_4_alt_1_marker, 8, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_4_alt_1_marker, 8, 0, 0, 0, 0, outro_1_ningo_marker, 1, 0)
	Story_Event("BREAKOUT_14_ALT_01")
	Sleep(4)

	player_bw_1.Hyperspace_Away(true)
	player_bw_2.Hyperspace_Away(true)
	player_bw_3.Hyperspace_Away(true)

	Fade_Screen_Out(2)
	Sleep(3)

	Resume_Mode_Based_Music()
	Allow_Localized_SFX(true)
	SFXManager.Allow_HUD_VO(true)
	SFXManager.Allow_Ambient_VO(true)
	SFXManager.Allow_Unit_Reponse_VO(true)
	SFXManager.Allow_Enemy_Sighted_VO(true)
	SFXManager.Allow_Localized_SFXEvents(true)

	Story_Event("CIS_VICTORY")
end

function Start_Cinematic_Outro_Rep_Alt_02()
	act_2_active = false
	cinematic_two_alt_02 = true

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

	Do_End_Cinematic_Cleanup()
	Fade_On()
	Play_Music("REP_Defeat")
	Sleep(1)

	player_bw_1 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), outro_1_ningo_marker, p_cis)
	player_bw_1 = Find_Nearest(outro_1_ningo_marker,"Skirmish_Bulwark_I")
	player_bw_1.Teleport_And_Face(outro_1_ningo_marker)

	player_bw_2 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), outro_1_bw_1_marker, p_cis)
	player_bw_2 = Find_Nearest(outro_1_bw_1_marker,"Skirmish_Bulwark_I")
	player_bw_2.Teleport_And_Face(outro_1_bw_1_marker)

	player_bw_3 = Spawn_Unit(Find_Object_Type("Skirmish_Bulwark_I"), outro_1_bw_2_marker, p_cis)
	player_bw_3 = Find_Nearest(outro_1_bw_2_marker,"Skirmish_Bulwark_I")
	player_bw_3.Teleport_And_Face(outro_1_bw_2_marker)

	Letter_Box_In(1.0)
	Fade_Screen_In(2.0)
	Story_Event("BREAKOUT_13_ALT_02")
	Story_Event("BREAKOUT_14_ALT_02")
	Set_Cinematic_Camera_Key(introcam_4_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_4_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(outrocam_2_alt_2_marker, 15, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_2_alt_2_marker, 15, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Sleep(14)

	Fade_Screen_In(0.5)
	Set_Cinematic_Camera_Key(outrocam_3_alt_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_3_alt_1_marker, 0, 0, 0, 0, outro_1_ningo_marker, 1, 0)
	Transition_Cinematic_Camera_Key(outrocam_4_alt_1_marker, 8, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_4_alt_1_marker, 8, 0, 0, 0, 0, outro_1_ningo_marker, 1, 0)
	Story_Event("BREAKOUT_14_ALT_01")
	Sleep(4)

	player_bw_1.Hyperspace_Away(true)
	player_bw_2.Hyperspace_Away(true)
	player_bw_3.Hyperspace_Away(true)

	Fade_Screen_Out(2)
	Sleep(3)

	Resume_Mode_Based_Music()
	Allow_Localized_SFX(true)
	SFXManager.Allow_HUD_VO(true)
	SFXManager.Allow_Ambient_VO(true)
	SFXManager.Allow_Unit_Reponse_VO(true)
	SFXManager.Allow_Enemy_Sighted_VO(true)
	SFXManager.Allow_Localized_SFXEvents(true)

	Story_Event("REPUBLIC_VICTORY")
end
