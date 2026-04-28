
--*****************************************************--
--********  Campaign: Operation Durge's Lance  ********--
--*****************************************************--

require("PGStoryMode")
require("PGSpawnUnits")
require("eawx-util/ChangeOwnerUtilities")
StoryUtil = require("eawx-util/StoryUtil")
require("deepcore/crossplot/crossplot")
require("eawx-plugins/influence-service/InfluenceService")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))

    StoryModeEvents = {
		-- Generic
        Determine_Faction_LUA = Find_Faction,
		Delayed_Initialize = Initialize,

		-- CIS
		Trigger_CIS_Player_Checker = State_CIS_Player_Checker,
		CIS_Duro_Defence_Tactical_Epilogue = State_CIS_Duro_Defence_Tactical_Epilogue,
		CIS_Jyvus_Joyride_Tactical_Failed = State_CIS_Keggle_Checker,
		CIS_Duro_Drama_Tactical_Epilogue = State_CIS_Duro_Drama_Tactical_Epilogue,
		CIS_Duro_Bombing_Checker = State_CIS_Duro_Bombing_Checker,
		CIS_Mad_Clone_Checker = State_CIS_Mad_Clone_Checker,
		CIS_Kuat_Lockdown = State_CIS_Kuat_Lockdown,
		CIS_Kuat_Conquest = State_CIS_Kuat_Conquest,
		CIS_GC_Progression_Research = State_CIS_GC_Progression_Research,

		-- Republic
		Trigger_Rep_Player_Checker = State_Rep_Player_Checker,
    }

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")

	gc_start = false
	act_1_active = false
	act_2_active = false
	act_3_active = false

	duro_bombed = false
	duro_chain_complete = false
	resurection_amount = 0

	grievous_dead = false

	target_planets_conquered = false
	savety_check = 0
end

function Find_Faction(message)
    if message == OnEnter then
        spawn_location_table = {
            ["CORUSCANT"] = false,
            ["GEONOSIS"] = false,
            ["KAMINO"] = false,
            ["CARIDA"] = false,
            ["RENDILI"] = false,
            ["ERIADU"] = false,
            ["KUAT"] = false,
            ["MUUNILINST"] = false,
            ["CATO_NEIMOIDIA"] = false,
            ["CHRISTOPHSIS"] = false,
            ["QUELL"] = false
        }

        local p_cis = Find_Player("Rebel")
        local p_republic = Find_Player("Empire")

        if p_republic.Is_Human() then
			Story_Event("ENABLE_BRANCH_GAR_FLAG")
        elseif p_cis.Is_Human() then
            Story_Event("ENABLE_BRANCH_CIS_FLAG")
        end

        techLevel = p_republic.Get_Tech_Level()
        if techLevel == 2 then
            Story_Event("START_LEVEL_02")
        elseif techLevel == 3 then
            Story_Event("START_LEVEL_03")
        elseif techLevel == 4 then
            Story_Event("START_LEVEL_04")
        elseif techLevel == 5 then
            Story_Event("START_LEVEL_05")
        end
    end
end

function Initialize(message)
    if message == OnEnter then
		GlobalValue.Set("CURRENT_ERA", 3)
		crossplot:galactic()
		crossplot:publish("VENATOR_HEROES", "empty")
		crossplot:publish("VICTORY_HEROES", "empty")
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 2, 1)

		crossplot:publish("REPUBLIC_ADMIRAL_EXIT", {"Ahsoka"}, 3)
		else
		crossplot:update()
    end
end

function Story_Mode_Service()
	if gc_start then
		if p_cis.Is_Human() then
			if (GlobalValue.Get("ODL_CIS_Grievous_Respawn") == 1) then
				local Grievous_Spawns = {"Grievous_Team"}
				StoryUtil.SpawnAtSafePlanet("YAGDHUL", p_cis, StoryUtil.GetSafePlanetTable(), Grievous_Spawns)
				GlobalValue.Set("ODL_CIS_Grievous_Respawn", 0)
			end
		elseif p_republic.Is_Human() then
		end
	end
end

-- CIS

function State_CIS_Player_Checker(message)
    if message == OnEnter then
		if p_cis.Is_Human() then

			GlobalValue.Set("ODL_CIS_GC_Version", 0) -- 1 = AU Version; 0 = Canonical Version

			if TestValid(Find_First_Object("GC_AU_Dummy")) then
				GlobalValue.Set("ODL_CIS_GC_Version", 1) -- 1 = AU Version; 0 = Canonical Version
				Find_First_Object("GC_AU_Dummy").Despawn()
			end

			Story_Event("CIS_STORY_START")

			p_kuat = FindPlanet("Kuat")
			p_duro = FindPlanet("Duro")
			p_humbarine = FindPlanet("Humbarine")
			p_kaikielius = FindPlanet("Kaikielius")
			p_yagdhul = FindPlanet("YagDhul")

			GlobalValue.Set("ODL_CIS_Shipyard_Struggle_Outcome", 0) -- 0 = CIS Victory; 1 = Republic Victory
			GlobalValue.Set("ODL_CIS_Jyvus_Joyride_Outcome", 1) -- 0 = CIS Victory; 1 = Republic Victory
			GlobalValue.Set("ODL_CIS_Grievous_Respawn", 0)

			gc_start = true
			Sleep(4.0)

			StoryUtil.SetPlanetRestricted("DURO", 1)

			p_cis.Lock_Tech(Find_Object_Type("Random_Mercenary"))

			target_planet_list = {
				--FindPlanet("Corellia"),
				--FindPlanet("Kuat"),
				FindPlanet("Duro"),
				FindPlanet("Humbarine"),
				FindPlanet("Kaikielius"),
				FindPlanet("Byss"),
			}

			if (GlobalValue.Get("ODL_CIS_GC_Version") == 0) then
				cis_list = {"Grievous_Team"}
				CISSpawn = SpawnList(cis_list, p_yagdhul, p_cis, true, false)
			elseif (GlobalValue.Get("ODL_CIS_GC_Version") == 1) then
				cis_list = {"Grievous_Team_Malevolence"}
				CISSpawn = SpawnList(cis_list, p_yagdhul, p_cis, true, false)
			end

			plot = Get_Story_Plot("Conquests\\CloneWarsDurgesLance\\Story_Sandbox_DurgesLance_CIS.XML")

			event_act_1 = plot.Get_Event("CIS_Durges_Lance_Act_I_Dialog")
			event_act_1.Set_Dialog("DIALOG_DURGES_LANCE_CIS")
			event_act_1.Clear_Dialog_Text()
			for _,p_planet in pairs(target_planet_list) do
				if p_planet.Get_Owner() ~= p_cis then
					if p_planet.Get_Planet_Location() == FindPlanet("Duro") then
						event_act_1.Add_Dialog_Text("TEXT_STORY_DURGES_LANCE_CIS_LOCATION_DURO", p_planet)
					elseif p_planet.Get_Planet_Location() == FindPlanet("Kuat") then
						event_act_1.Add_Dialog_Text("TEXT_STORY_DURGES_LANCE_CIS_LOCATION_KUAT", p_planet)
					elseif p_planet.Get_Planet_Location() == FindPlanet("Humbarine") then
						event_act_1.Add_Dialog_Text("TEXT_STORY_DURGES_LANCE_CIS_LOCATION_HUMBARINE", p_planet)
					else
						event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_planet)
					end
				else
					event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_planet)
				end
			end

			event_act_2 = plot.Get_Event("CIS_Durges_Lance_Act_II_Dialog")
			event_act_2.Set_Dialog("DIALOG_DURGES_LANCE_CIS")
			event_act_2.Clear_Dialog_Text()
			event_act_2.Add_Dialog_Text("TEXT_STORY_DURGES_LANCE_CIS_LOCATION_KUAT", p_kuat)

			event_act_3 = plot.Get_Event("CIS_Durges_Lance_Act_III_Dialog")
			event_act_3.Set_Dialog("DIALOG_DURGES_LANCE_CIS")
			event_act_3.Clear_Dialog_Text()
			event_act_3.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_yagdhul)

			if TestValid(Find_First_Object("Grievous_Soulless_One_Ground")) or TestValid(Find_First_Object("Soulless_One")) or TestValid(Find_First_Object("Grievous_Team_Soulless_One")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				savety_check = 0
			elseif TestValid(Find_First_Object("General_Grievous")) or TestValid(Find_First_Object("Invisible_Hand")) or TestValid(Find_First_Object("Grievous_Team")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				savety_check = 0
			elseif TestValid(Find_First_Object("Grievous_Recusant_Ground")) or TestValid(Find_First_Object("Grievous_Recusant")) or TestValid(Find_First_Object("Grievous_Team_Recusant")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				savety_check = 0
			elseif TestValid(Find_First_Object("Grievous_Munificent_Ground")) or TestValid(Find_First_Object("Grievous_Munificent")) or TestValid(Find_First_Object("Grievous_Team_Munificent")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				savety_check = 0
			elseif TestValid(Find_First_Object("Grievous_Malevolence_Ground")) or TestValid(Find_First_Object("Grievous_Malevolence")) or TestValid(Find_First_Object("Grievous_Team_Malevolence")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				savety_check = 0
			else
				savety_check = savety_check + 1
			end

			local holo_centre_gamble = 2
			if holo_centre_gamble == 1 then
				event_act_4_01_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_4_01_task.Set_Event_Parameter(0, FindPlanet("Byss"))

				event_act_4_02_task = plot.Get_Event("CIS_Holo_Hunt_Tactical")
				event_act_4_02_task.Set_Reward_Parameter(0, FindPlanet("Byss"))

				event_act_4_03_task = plot.Get_Event("CIS_Holo_Hunt_Tactical_Completed")
				event_act_4_03_task.Set_Event_Parameter(3, FindPlanet("Byss"))
				StoryUtil.SetPlanetRestricted("BYSS", 1)
			elseif holo_centre_gamble == 2 then
				event_act_4_01_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_4_01_task.Set_Event_Parameter(0, FindPlanet("Humbarine"))

				event_act_4_02_task = plot.Get_Event("CIS_Holo_Hunt_Tactical")
				event_act_4_02_task.Set_Reward_Parameter(0, FindPlanet("Humbarine"))

				event_act_4_03_task = plot.Get_Event("CIS_Holo_Hunt_Tactical_Completed")
				event_act_4_03_task.Set_Event_Parameter(3, FindPlanet("Humbarine"))
				StoryUtil.SetPlanetRestricted("HUMBARINE", 1)
			elseif holo_centre_gamble == 3 then
				event_act_4_01_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_4_01_task.Set_Event_Parameter(0, FindPlanet("Kaikielius"))

				event_act_4_02_task = plot.Get_Event("CIS_Holo_Hunt_Tactical")
				event_act_4_02_task.Set_Reward_Parameter(0, FindPlanet("Kaikielius"))

				event_act_4_03_task = plot.Get_Event("CIS_Holo_Hunt_Tactical_Completed")
				event_act_4_03_task.Set_Event_Parameter(3, FindPlanet("Kaikielius"))
				StoryUtil.SetPlanetRestricted("KAIKIELIUS", 1)
			end

			Create_Thread("State_CIS_Planet_Checker")
			Create_Thread("State_CIS_Grievous_Checker")
		end
    end
end

function State_CIS_Planet_Checker()
	plot = Get_Story_Plot("Conquests\\CloneWarsDurgesLance\\Story_Sandbox_DurgesLance_CIS.XML")
	event_act_1 = plot.Get_Event("CIS_Durges_Lance_Act_I_Dialog")
	event_act_1.Set_Dialog("DIALOG_DURGES_LANCE_CIS")
	event_act_1.Clear_Dialog_Text()
	for _,p_planet in pairs(target_planet_list) do
		if p_planet.Get_Owner() ~= p_cis then
			if p_planet.Get_Planet_Location() == FindPlanet("Duro") then
				event_act_1.Add_Dialog_Text("TEXT_STORY_DURGES_LANCE_CIS_LOCATION_DURO", p_planet)
			elseif p_planet.Get_Planet_Location() == FindPlanet("Kuat") then
				event_act_1.Add_Dialog_Text("TEXT_STORY_DURGES_LANCE_CIS_LOCATION_KUAT", p_planet)
			elseif p_planet.Get_Planet_Location() == FindPlanet("Humbarine") then
				event_act_1.Add_Dialog_Text("TEXT_STORY_DURGES_LANCE_CIS_LOCATION_HUMBARINE", p_planet)
			else
				event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_planet)
			end
		elseif p_planet.Get_Owner() == p_cis then
			event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_planet)
		end
	end
	if FindPlanet("Duro").Get_Owner() == p_cis and FindPlanet("Humbarine").Get_Owner() == p_cis and FindPlanet("Kaikielius").Get_Owner() == p_cis and FindPlanet("Byss").Get_Owner() == p_cis then
		Story_Event("CIS_PLANETS_CONQUERED")
		target_planets_conquered = true
	end
	Sleep(5.0)
	if not target_planets_conquered then
		Create_Thread("State_CIS_Planet_Checker")
	end
end

function State_CIS_Grievous_Checker()
	plot = Get_Story_Plot("Conquests\\CloneWarsDurgesLance\\Story_Sandbox_DurgesLance_CIS.XML")

	if TestValid(Find_First_Object("Grievous_Soulless_One_Ground")) or TestValid(Find_First_Object("Soulless_One")) or TestValid(Find_First_Object("Grievous_Team_Soulless_One")) then
		event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
		event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

		event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
		event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

		event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
		event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

		event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
		event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

		event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
		event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

		savety_check = 0
		grievous_dead = false
	elseif TestValid(Find_First_Object("General_Grievous")) or TestValid(Find_First_Object("Invisible_Hand")) or TestValid(Find_First_Object("Grievous_Team")) then
		event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
		event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

		event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
		event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

		event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
		event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

		event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
		event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

		event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
		event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

		savety_check = 0
		grievous_dead = false
	elseif TestValid(Find_First_Object("Grievous_Recusant_Ground")) or TestValid(Find_First_Object("Grievous_Recusant")) or TestValid(Find_First_Object("Grievous_Team_Recusant")) then
		event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
		event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

		event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
		event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

		event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
		event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

		event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
		event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

		event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
		event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

		savety_check = 0
		grievous_dead = false
	elseif TestValid(Find_First_Object("Grievous_Munificent_Ground")) or TestValid(Find_First_Object("Grievous_Munificent")) or TestValid(Find_First_Object("Grievous_Team_Munificent")) then
		event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
		event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

		event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
		event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

		event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
		event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

		event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
		event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

		event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
		event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

		savety_check = 0
		grievous_dead = false
	elseif TestValid(Find_First_Object("Grievous_Malevolence_Ground")) or TestValid(Find_First_Object("Grievous_Malevolence")) or TestValid(Find_First_Object("Grievous_Team_Malevolence")) then
		event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
		event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

		event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
		event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

		event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
		event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

		event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
		event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

		event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
		event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

		savety_check = 0
		grievous_dead = false
	else
		savety_check = savety_check + 1
	end
	Sleep(2.5)
	if savety_check > 2 then
		Story_Event("CIS_GRIEVOUS_DEAD")
		grievous_dead = true
	else
		Create_Thread("State_CIS_Grievous_Checker")
	end
end

function State_CIS_Duro_Defence_Tactical_Epilogue(message)
    if message == OnEnter then
		if p_cis.Is_Human() then
			plot = Get_Story_Plot("Conquests\\CloneWarsDurgesLance\\Story_Sandbox_DurgesLance_CIS.XML")

			Sleep(3.0)

			if TestValid(Find_First_Object("Grievous_Soulless_One_Ground")) or TestValid(Find_First_Object("Soulless_One")) or TestValid(Find_First_Object("Grievous_Team_Soulless_One")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				savety_check = 0
			elseif TestValid(Find_First_Object("General_Grievous")) or TestValid(Find_First_Object("Invisible_Hand")) or TestValid(Find_First_Object("Grievous_Team")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				savety_check = 0
			elseif TestValid(Find_First_Object("Grievous_Recusant_Ground")) or TestValid(Find_First_Object("Grievous_Recusant")) or TestValid(Find_First_Object("Grievous_Team_Recusant")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				savety_check = 0
			elseif TestValid(Find_First_Object("Grievous_Munificent_Ground")) or TestValid(Find_First_Object("Grievous_Munificent")) or TestValid(Find_First_Object("Grievous_Team_Munificent")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				savety_check = 0
			elseif TestValid(Find_First_Object("Grievous_Malevolence_Ground")) or TestValid(Find_First_Object("Grievous_Malevolence")) or TestValid(Find_First_Object("Grievous_Team_Malevolence")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				savety_check = 0
			else
				savety_check = savety_check + 1
			end
		end
	end
end

function State_CIS_Keggle_Checker(message)
    if message == OnEnter then
		if p_cis.Is_Human() then
			if (GlobalValue.Get("ODL_CIS_Jyvus_Joyride_Outcome") == 1) then
				Story_Event("CIS_DURO_DRAMA")
			end
		end
    end
end

function State_CIS_Duro_Drama_Tactical_Epilogue(message)
    if message == OnEnter then
		if p_cis.Is_Human() then
			plot = Get_Story_Plot("Conquests\\CloneWarsDurgesLance\\Story_Sandbox_DurgesLance_CIS.XML")

			Sleep(3.0)

			p_duro.Change_Owner(p_cis)

			if TestValid(Find_First_Object("Grievous_Soulless_One_Ground")) or TestValid(Find_First_Object("Soulless_One")) or TestValid(Find_First_Object("Grievous_Team_Soulless_One")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				savety_check = 0
			elseif TestValid(Find_First_Object("General_Grievous")) or TestValid(Find_First_Object("Invisible_Hand")) or TestValid(Find_First_Object("Grievous_Team")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				savety_check = 0
			elseif TestValid(Find_First_Object("Grievous_Recusant_Ground")) or TestValid(Find_First_Object("Grievous_Recusant")) or TestValid(Find_First_Object("Grievous_Team_Recusant")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				savety_check = 0
			elseif TestValid(Find_First_Object("Grievous_Munificent_Ground")) or TestValid(Find_First_Object("Grievous_Munificent")) or TestValid(Find_First_Object("Grievous_Team_Munificent")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				savety_check = 0
			elseif TestValid(Find_First_Object("Grievous_Malevolence_Ground")) or TestValid(Find_First_Object("Grievous_Malevolence")) or TestValid(Find_First_Object("Grievous_Team_Malevolence")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				savety_check = 0
			else
				savety_check = savety_check + 1
			end
		end
    end
end

function State_CIS_Duro_Bombing_Checker(message)
    if message == OnEnter then
		if p_cis.Is_Human() then
			if (GlobalValue.Get("ODL_CIS_Jyvus_Joyride_Outcome") == 0) then
				Story_Event("CIS_NEW_ALLY")
				keggle_list = {"Hoolidan_Keggle_Team"}
				KeggleSpawn = SpawnList(keggle_list, p_duro, p_cis, true, false)
			end
			duro_chain_complete = true
			StoryUtil.SetPlanetRestricted("DURO", 0)
			plot = Get_Story_Plot("Conquests\\CloneWarsDurgesLance\\Story_Sandbox_DurgesLance_CIS.XML")

			Sleep(3.0)

			if TestValid(Find_First_Object("Grievous_Soulless_One_Ground")) or TestValid(Find_First_Object("Soulless_One")) or TestValid(Find_First_Object("Grievous_Team_Soulless_One")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				savety_check = 0
			elseif TestValid(Find_First_Object("General_Grievous")) or TestValid(Find_First_Object("Invisible_Hand")) or TestValid(Find_First_Object("Grievous_Team")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				savety_check = 0
			elseif TestValid(Find_First_Object("Grievous_Recusant_Ground")) or TestValid(Find_First_Object("Grievous_Recusant")) or TestValid(Find_First_Object("Grievous_Team_Recusant")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				savety_check = 0
			elseif TestValid(Find_First_Object("Grievous_Munificent_Ground")) or TestValid(Find_First_Object("Grievous_Munificent")) or TestValid(Find_First_Object("Grievous_Team_Munificent")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				savety_check = 0
			elseif TestValid(Find_First_Object("Grievous_Malevolence_Ground")) or TestValid(Find_First_Object("Grievous_Malevolence")) or TestValid(Find_First_Object("Grievous_Team_Malevolence")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				savety_check = 0
			else
				savety_check = savety_check + 1
			end
		end
    end
end

function State_CIS_Mad_Clone_Checker(message)
    if message == OnEnter then
		if p_cis.Is_Human() then
			Story_Event("CIS_MAD_CLONE")
			mad_clone_list = {"Mad_Clone_Munificent"}
			p_kaikielius.Change_Owner(p_cis)
			MaddySpawn = SpawnList(mad_clone_list, p_kaikielius, p_cis, true, false)
			plot = Get_Story_Plot("Conquests\\CloneWarsDurgesLance\\Story_Sandbox_DurgesLance_CIS.XML")

			Sleep(3.0)

			if TestValid(Find_First_Object("Grievous_Soulless_One_Ground")) or TestValid(Find_First_Object("Soulless_One")) or TestValid(Find_First_Object("Grievous_Team_Soulless_One")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				savety_check = 0
			elseif TestValid(Find_First_Object("General_Grievous")) or TestValid(Find_First_Object("Invisible_Hand")) or TestValid(Find_First_Object("Grievous_Team")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				savety_check = 0
			elseif TestValid(Find_First_Object("Grievous_Recusant_Ground")) or TestValid(Find_First_Object("Grievous_Recusant")) or TestValid(Find_First_Object("Grievous_Team_Recusant")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				savety_check = 0
			elseif TestValid(Find_First_Object("Grievous_Munificent_Ground")) or TestValid(Find_First_Object("Grievous_Munificent")) or TestValid(Find_First_Object("Grievous_Team_Munificent")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				savety_check = 0
			elseif TestValid(Find_First_Object("Grievous_Malevolence_Ground")) or TestValid(Find_First_Object("Grievous_Malevolence")) or TestValid(Find_First_Object("Grievous_Team_Malevolence")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				savety_check = 0
			else
				savety_check = savety_check + 1
			end
		end
    end
end

function State_CIS_Kuat_Lockdown(message)
    if message == OnEnter then
		if p_cis.Is_Human() then
			StoryUtil.SetPlanetRestricted("KUAT", 1)
			kuat_lockdown_list = {
				"Generic_Star_Destroyer",
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
			}
			Kuat_LockdownSpawn = SpawnList(kuat_lockdown_list, p_kuat, p_republic, true, true)
		end
    end
end

function State_CIS_Kuat_Conquest(message)
    if message == OnEnter then
		if p_cis.Is_Human() then
			kuat_reward_list = {"Storm_Fleet_Destroyer", "Storm_Fleet_Destroyer", "Storm_Fleet_Destroyer"}
			Kuat_LockdownSpawn = SpawnList(kuat_reward_list, p_kuat, p_cis, true, true)
		end
    end
end

function State_CIS_GC_Progression_Research(message)
	if message == OnEnter then
		if TestValid(Find_First_Object("Grievous_Soulless_One_Ground")) or TestValid(Find_First_Object("Soulless_One")) or TestValid(Find_First_Object("Grievous_Team_Soulless_One")) then
			if p_kuat.Get_Owner() == p_cis then
				Story_Event("CIS_ORS_GC_PROGRESSION_ALT_02")
			end
			if p_kuat.Get_Owner() ~= p_cis then
				Story_Event("CIS_ORS_GC_PROGRESSION")
			end

			savety_check = 0
			grievous_dead = false
		elseif TestValid(Find_First_Object("General_Grievous")) or TestValid(Find_First_Object("Invisible_Hand")) or TestValid(Find_First_Object("Grievous_Team")) then
			if p_kuat.Get_Owner() == p_cis then
				Story_Event("CIS_ORS_GC_PROGRESSION_ALT_02")
			end
			if p_kuat.Get_Owner() ~= p_cis then
				Story_Event("CIS_ORS_GC_PROGRESSION")
			end

			savety_check = 0
			grievous_dead = false
		elseif TestValid(Find_First_Object("Grievous_Recusant_Ground")) or TestValid(Find_First_Object("Grievous_Recusant")) or TestValid(Find_First_Object("Grievous_Team_Recusant")) then
			if p_kuat.Get_Owner() == p_cis then
				Story_Event("CIS_ORS_GC_PROGRESSION_ALT_02")
			end
			if p_kuat.Get_Owner() ~= p_cis then
				Story_Event("CIS_ORS_GC_PROGRESSION")
			end

			savety_check = 0
			grievous_dead = false
		elseif TestValid(Find_First_Object("Grievous_Munificent_Ground")) or TestValid(Find_First_Object("Grievous_Munificent")) or TestValid(Find_First_Object("Grievous_Team_Munificent")) then
			if p_kuat.Get_Owner() == p_cis then
				Story_Event("CIS_ORS_GC_PROGRESSION_ALT_02")
			end
			if p_kuat.Get_Owner() ~= p_cis then
				Story_Event("CIS_ORS_GC_PROGRESSION")
			end

			savety_check = 0
			grievous_dead = false
		elseif TestValid(Find_First_Object("Grievous_Malevolence_Ground")) or TestValid(Find_First_Object("Grievous_Malevolence")) or TestValid(Find_First_Object("Grievous_Team_Malevolence")) then
			Story_Event("CIS_ORS_GC_PROGRESSION_ALT_01")

			savety_check = 0
			grievous_dead = false
		else
			grievous_dead = true
			Story_Event("CIS_FOEROST_GC_PROGRESSION")
		end
	end
end

-- Republic

function State_Rep_Player_Checker(message)
    if message == OnEnter then
		if p_republic.Is_Human() then

			GlobalValue.Set("ODL_Rep_GC_Version", 0) -- 1 = AU Version; 0 = Canonical Version

			if TestValid(Find_First_Object("GC_AU_Dummy")) then
				GlobalValue.Set("ODL_Rep_GC_Version", 1) -- 1 = AU Version; 0 = Canonical Version
				Find_First_Object("GC_AU_Dummy").Despawn()
			end

			Story_Event("REP_STORY_START")

			p_kuat = FindPlanet("Kuat")
			p_duro = FindPlanet("Duro")
			p_humbarine = FindPlanet("Humbarine")
			p_kaikielius = FindPlanet("Kaikielius")
			p_yagdhul = FindPlanet("YagDhul")
			p_fondor = FindPlanet("Fondor")
			p_thyferra = FindPlanet("Thyferra")
			p_empress_teta = FindPlanet("Empress_Teta")
			p_deko_neimoidia = FindPlanet("Deko_Neimoidia")

			gc_start = true

			Sleep(1.0)

			p_cis.Lock_Tech(Find_Object_Type("Random_Mercenary"))

			target_planet_list = {
				FindPlanet("Fondor"),
				FindPlanet("YagDhul"),
				FindPlanet("Thyferra"),
				FindPlanet("Empress_Teta"),
				FindPlanet("Deko_Neimoidia"),
			}

			cis_list = {"Grievous_Team"}
			CISSpawn = SpawnList(cis_list, p_yagdhul, p_cis, true, false)

			if (GlobalValue.Get("ODL_Rep_GC_Version") == 1) then
				Safe_House_Planet = StoryUtil.GetSafePlanetTable()
				StoryUtil.SpawnAtSafePlanet("DURO", Find_Player("Empire"), Safe_House_Planet, {"Orn_Free_Taa_Team"})
			end

			plot = Get_Story_Plot("Conquests\\CloneWarsDurgesLance\\Story_Sandbox_DurgesLance_Republic.XML")

			event_act_1 = plot.Get_Event("Rep_Durges_Lance_Act_I_Dialog")
			event_act_1.Set_Dialog("DIALOG_DURGES_LANCE_REP")
			event_act_1.Clear_Dialog_Text()
			for _,p_planet in pairs(target_planet_list) do
				if p_planet.Get_Owner() ~= p_republic then
					event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_planet)
				elseif p_planet.Get_Owner() == p_republic then
					event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_planet)
				end
			end
			Create_Thread("State_Rep_Planet_Checker")

			event_act_2 = plot.Get_Event("Rep_Durges_Lance_Act_II_Dialog")
			event_act_2.Set_Dialog("DIALOG_DURGES_LANCE_REP")
			event_act_2.Clear_Dialog_Text()
			event_act_2.Add_Dialog_Text("TEXT_TOOLTIP_COMMAND_INVISIBLE_HAND")
			Create_Thread("State_Rep_Grievous_Log_Checker")
		end
    end
end

function State_Rep_Planet_Checker()
	event_act_1 = plot.Get_Event("Rep_Durges_Lance_Act_I_Dialog")
	event_act_1.Set_Dialog("DIALOG_DURGES_LANCE_REP")
	event_act_1.Clear_Dialog_Text()
	for _,p_planet in pairs(target_planet_list) do
		if p_planet.Get_Owner() ~= p_republic then
			event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_planet)
		elseif p_planet.Get_Owner() == p_republic then
			event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_planet)
		end
	end
	if FindPlanet("Fondor").Get_Owner() == p_republic and FindPlanet("YagDhul").Get_Owner() == p_republic and FindPlanet("Thyferra").Get_Owner() == p_republic and FindPlanet("Empress_Teta").Get_Owner() == p_republic and FindPlanet("Deko_Neimoidia").Get_Owner() == p_republic then
		target_planets_conquered = true
	end
	Sleep(5.0)
	if not target_planets_conquered then
		Create_Thread("State_Rep_Planet_Checker")
	else
		Story_Event("REP_TARGET_PLANETS_CONQUERED")
	end
end

function State_Rep_Grievous_Log_Checker()
	event_act_2 = plot.Get_Event("Rep_Durges_Lance_Act_II_Dialog")
	event_act_2.Set_Dialog("DIALOG_DURGES_LANCE_REP")
	event_act_2.Clear_Dialog_Text()
	if TestValid(Find_First_Object("General_Grievous")) or TestValid(Find_First_Object("Invisible_Hand")) or TestValid(Find_First_Object("Grievous_Team")) then
		event_act_2.Add_Dialog_Text("TEXT_TOOLTIP_COMMAND_INVISIBLE_HAND")

		savety_check = 0
	elseif TestValid(Find_First_Object("Grievous_Recusant_Ground")) or TestValid(Find_First_Object("Grievous_Recusant")) or TestValid(Find_First_Object("Grievous_Team_Recusant")) then
		event_act_2.Add_Dialog_Text("TEXT_TOOLTIP_COMMAND_RENITOR")

		savety_check = 0
	elseif TestValid(Find_First_Object("Grievous_Munificent_Ground")) or TestValid(Find_First_Object("Grievous_Munificent")) or TestValid(Find_First_Object("Grievous_Team_Munificent")) then
		event_act_2.Add_Dialog_Text("TEXT_TOOLTIP_COMMAND_MUNIFICENT")

		savety_check = 0
	else
		savety_check = savety_check + 1
	end
	Sleep(2.5)
	if savety_check > 2 then
		event_act_2.Add_Dialog_Text("TEXT_TOOLTIP_NONE")
		Story_Event("REP_GRIEVOUS_DEAD")
		grievous_dead = true
	else
		Create_Thread("State_Rep_Grievous_Log_Checker")
	end

end
