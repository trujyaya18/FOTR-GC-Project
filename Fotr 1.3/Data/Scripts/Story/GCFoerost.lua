
--****************************************************--
--****   Fall of the Republic: Foerost Campaign   ****--
--****************************************************--

require("PGStoryMode")
require("PGSpawnUnits")
require("eawx-util/ChangeOwnerUtilities")
StoryUtil = require("eawx-util/StoryUtil")
require("deepcore/crossplot/crossplot")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))

    StoryModeEvents = {
		-- Generic
        Determine_Faction_LUA = Find_Faction,
		Delayed_Initialize = Initialize,

		-- CIS
		Trigger_CIS_Player_Checker = State_CIS_Player_Checker,
		CIS_VSD_Destroyed = State_CIS_Target_Rendili,
		CIS_Venator_Venting_Tactical_Epilogue = State_CIS_Venator_Venting_Tactical_Epilogue,
		CIS_GC_Progression_ORS_Research = State_CIS_GC_Progression_ORS_Research,

		-- Republic
		Trigger_Rep_Player_Checker = State_Rep_Player_Checker,
		Rep_Anaxes_Annexation_Tactical_Epilogue = State_Rep_Anaxes_Annexation_Tactical_Epilogue,
		Trigger_Rep_Gladiator_Unleashed = State_Rep_Gladiator_Unleashed,
		Rep_Foerost_Gladiator_Researched = State_Rep_Foerost_Gladiator_Researched,
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")

	bulwark_fleet_list = {
		"Dua_Ningo_Unrepentant",
		"Bulwark_I",
		"Bulwark_I",
		"Bulwark_I",
		"Bulwark_I",
		"Bulwark_I",
		"Hardcell",
		"Hardcell",
		"Hardcell",
		"Hardcell",
		"Hardcell",
		"Hardcell",
	}

	clysm_fleet_list = {
		"Calli_Trilm_Bulwark",
		"Bulwark_I",
		"Bulwark_I",
		"Bulwark_I",
		"Bulwark_I",
		"Bulwark_I",
		"Bulwark_I",
		"Bulwark_I",
		"Auxilia",
		"Auxilia",
		"Auxilia",
		"Captor",
		"Captor",
		"Captor",
		"Marauder_Missile_Cruiser",
		"Marauder_Missile_Cruiser",
		"Marauder_Missile_Cruiser",
		"Marauder_Missile_Cruiser",
		"Marauder_Missile_Cruiser",
		"Hardcell",
		"Hardcell",
		"Hardcell",
		"Hardcell",
		"Hardcell",
		"Hardcell",
		"Hardcell_Tender",
		"Hardcell_Tender",
		"Hardcell_Tender",
		"Hardcell_Tender",
		"Hardcell_Tender",
	}

	potential_targets = {}

	bulwark_fleet_unit_list = nil
	clysm_fleet_unit_list = nil
	
	rampage_move_delay = 45

	gc_start = false
	act_1_active = false
	act_2_active = false
	act_3_active = false

	ningo_alive = false
	screed_alive = false
	dodonna_alive = false
	target_planets_conquered = false
	rendili_conquered = false
	carida_conquered = false
	carida_clysm_start = false

	anaxes_complete = false
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
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 1, 1)
		crossplot:publish("REPUBLIC_ADMIRAL_LOCKIN", {"Screed", "Dodonna"}, 1)

		crossplot:publish("REPUBLIC_ADMIRAL_EXIT", {"Ahsoka"}, 3)
		else
		crossplot:update()
    end
end

function Story_Mode_Service()
	if gc_start then
		if p_cis.Is_Human() then
		elseif p_republic.Is_Human() then
		end
	end
end

-- CIS

function State_CIS_Player_Checker(message)
	if message == OnEnter then
		if p_cis.Is_Human() then

			GlobalValue.Set("Foerost_CIS_GC_Version", 0) -- 1 = AU Version; 0 = Canonical Version
			GlobalValue.Set("Foerost_CIS_Renown_Conquered", 0) -- 1 = AU Version; 0 = Canonical Version

			if TestValid(Find_First_Object("GC_AU_Dummy")) then
				GlobalValue.Set("Foerost_CIS_GC_Version", 1) -- 1 = AU Version; 0 = Canonical Version
				Find_First_Object("GC_AU_Dummy").Despawn()
			end

			Story_Event("CIS_STORY_START")

			p_carida = FindPlanet("Carida")
			p_rendili = FindPlanet("Rendili")
			p_alsakan = FindPlanet("Alsakan")
			p_anaxes = FindPlanet("Anaxes")
			p_ixtlar = FindPlanet("Ixtlar")
			p_basilisk = FindPlanet("Basilisk")

			p_foerost = FindPlanet("Foerost")
			p_kaikielius = FindPlanet("Kaikielius")
			p_empress_teta = FindPlanet("Empress_Teta")

			gc_start = true

			Sleep(1.0)

			p_cis.Lock_Tech(Find_Object_Type("Random_Mercenary"))

			StoryUtil.SetPlanetRestricted("ANAXES", 1)
			StoryUtil.SetPlanetRestricted("RENDILI", 1)

			lockdown_list = {"Invincible_Cruiser", "Invincible_Cruiser", "Invincible_Cruiser"}
			LockdownSpawn = SpawnList(lockdown_list, p_alsakan, p_republic, false, false)

			lockdown_list = {"Dua_Ningo_Unrepentant"}
			LockdownSpawn = SpawnList(lockdown_list, p_empress_teta, p_cis, true, false)

			p_republic.Unlock_Tech(Find_Object_Type("Generic_Gladiator"))

			target_planet_list = {
				FindPlanet("Alsakan"),
				FindPlanet("Basilisk"),
				FindPlanet("Ixtlar"),
				}

			plot = Get_Story_Plot("Conquests\\CloneWarsFoerost\\Story_Sandbox_Foerost_CIS.XML")

			event_act_1 = plot.Get_Event("CIS_Foerost_Campaign_Act_I_Dialog")
			event_act_1.Set_Dialog("DIALOG_FOEROST_CAMPAIGN_CIS")
			event_act_1.Clear_Dialog_Text()
			for _,p_planet in pairs(target_planet_list) do
				if p_planet.Get_Owner() ~= p_cis then
					event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_planet)
				else
					event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_planet)
				end
			end

			event_act_2 = plot.Get_Event("CIS_Foerost_Campaign_Act_II_Dialog")
			event_act_2.Set_Dialog("DIALOG_FOEROST_CAMPAIGN_CIS")
			event_act_2.Clear_Dialog_Text()
			if p_rendili.Get_Owner() ~= p_cis then
				event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_rendili)
			else
				event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_rendili)
				rendili_conquered = true
			end

			event_act_3 = plot.Get_Event("CIS_Foerost_Campaign_Act_III_Dialog")
			event_act_3.Set_Dialog("DIALOG_FOEROST_CAMPAIGN_CIS")
			event_act_3.Clear_Dialog_Text()
			if p_anaxes.Get_Owner() ~= p_cis then
				event_act_3.Add_Dialog_Text("TEXT_STORY_FOEROST_CAMPIGN_CIS_LOCATION_ANAXES", p_anaxes)
			else
				event_act_3.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_anaxes)
			end

			Create_Thread("State_CIS_Act_I_Planet_Checker")
			Create_Thread("State_CIS_Act_II_Planet_Checker")
		end
    end
end

function State_CIS_Act_I_Planet_Checker()
	event_act_1 = plot.Get_Event("CIS_Foerost_Campaign_Act_I_Dialog")
	event_act_1.Set_Dialog("DIALOG_FOEROST_CAMPAIGN_CIS")
	event_act_1.Clear_Dialog_Text()
	for _,p_planet in pairs(target_planet_list) do
		if p_planet.Get_Owner() ~= p_cis then
			event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_planet)
		else
			event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_planet)
		end
	end
	if FindPlanet("Alsakan").Get_Owner() == p_cis and FindPlanet("Basilisk").Get_Owner() == p_cis and FindPlanet("Ixtlar").Get_Owner() == p_cis then
		target_planets_conquered = true
		Story_Event("CIS_TARGET_PLANETS_CONQUERED")
	end
	Sleep(5.0)
	if not target_planets_conquered then
		Create_Thread("State_CIS_Act_I_Planet_Checker")
	end
end

function State_CIS_Act_II_Planet_Checker()
	event_act_2 = plot.Get_Event("CIS_Foerost_Campaign_Act_II_Dialog")
	event_act_2.Set_Dialog("DIALOG_FOEROST_CAMPAIGN_CIS")
	event_act_2.Clear_Dialog_Text()
	if p_rendili.Get_Owner() ~= p_cis then
		event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_rendili)
	else
		event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_rendili)
		rendili_conquered = true
		Story_Event("CIS_RENDILI_CONQUERED")
		local rendili_reward_list = {"AutO_Providence", "Protodeka_Company"}
		RendiliRewardSpawn = SpawnList(rendili_reward_list, p_rendili, p_cis, true, false)
	end
	Sleep(5.0)
	if not rendili_conquered then
		Create_Thread("State_CIS_Act_II_Planet_Checker")
	end
end

function State_CIS_Target_Rendili(message)
    if message == OnEnter then
		if p_cis.Is_Human() then
			if p_rendili.Get_Owner() == p_republic then
				Story_Event("CIS_TARGET_RENDILI")
			end
		end
    end
end

function State_CIS_Venator_Venting_Tactical_Epilogue(message)
    if message == OnEnter then
		if p_cis.Is_Human() then
			if (GlobalValue.Get("Foerost_CIS_Renown_Conquered") == 1) then
				event_act_5 = plot.Get_Event("CIS_Foerost_Campaign_Act_V_Dialog")
				event_act_5.Set_Dialog("DIALOG_FOEROST_CAMPAIGN_CIS")
				event_act_5.Clear_Dialog_Text()
				if p_carida.Get_Owner() ~= p_cis then
						if not carida_clysm_start then 
							Story_Event("CIS_CARIDA_CLYSM_START")
							carida_clysm_start = true
						end
					event_act_5.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_carida)
				else
					event_act_5.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_carida)
					carida_conquered = true
					Story_Event("CIS_CARIDA_CONQUEST")
					local Safe_House_Planet = StoryUtil.GetSafePlanetTable()
					StoryUtil.SpawnAtSafePlanet("CARIDA", Find_Player("Rebel"), Safe_House_Planet, {"Calli_Trilm_Bulwark"})
				end
			end
			if not carida_conquered then
				Create_Thread("State_CIS_Carida_Checker")
			end
		end
    end
end

function State_CIS_Carida_Checker()
	if (GlobalValue.Get("Foerost_CIS_Renown_Conquered") == 1) then
		event_act_5 = plot.Get_Event("CIS_Foerost_Campaign_Act_V_Dialog")
		event_act_5.Set_Dialog("DIALOG_FOEROST_CAMPAIGN_CIS")
		event_act_5.Clear_Dialog_Text()
		if p_carida.Get_Owner() ~= p_cis then
				if not carida_clysm_start then 
					Story_Event("CIS_CARIDA_CLYSM_START")
					carida_clysm_start = true
				end
			event_act_5.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_carida)
		else
			event_act_5.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_carida)
			carida_conquered = true
			Story_Event("CIS_CARIDA_CONQUEST")
			local Safe_House_Planet = StoryUtil.GetSafePlanetTable()
			StoryUtil.SpawnAtSafePlanet("CARIDA", Find_Player("Rebel"), Safe_House_Planet, {"Calli_Trilm_Bulwark"})
		end
	end
	Sleep(5.0)
	if not carida_conquered then
		Create_Thread("State_CIS_Carida_Checker")
	end
end

function State_CIS_GC_Progression_ORS_Research(message)
	if message == OnEnter then
		if TestValid(Find_First_Object("Dua_Ningo_Unrepentant")) then
			Story_Event("CIS_ORS_GC_PROGRESSION_AU")
		else
			Story_Event("CIS_ORS_GC_PROGRESSION")
		end
	end
end

-- Republic

function State_Rep_Player_Checker(message)
	if message == OnEnter then
		if p_republic.Is_Human() then
			Story_Event("REP_STORY_START")

			p_rendili = FindPlanet("Rendili")
			p_alsakan = FindPlanet("Alsakan")
			p_anaxes = FindPlanet("Anaxes")
			p_basilisk = FindPlanet("Basilisk")
			p_ixtlar = FindPlanet("Ixtlar")

			p_foerost = FindPlanet("Foerost")
			p_kaikielius = FindPlanet("Kaikielius")
			p_empress_teta = FindPlanet("Empress_Teta")

			p_bulwark = "Bulwark_I"
			p_ningo = "Dua_Ningo_Unrepentant"

			gc_start = true

			Sleep(1.0)

			p_cis.Lock_Tech(Find_Object_Type("Random_Mercenary"))

			target_planet_list = {
				FindPlanet("Foerost"),
				FindPlanet("Kaikielius"),
				FindPlanet("Empress_Teta"),
				FindPlanet("Vulpter"),
			}

			plot = Get_Story_Plot("Conquests\\CloneWarsFoerost\\Story_Sandbox_Foerost_Republic.XML")

			event_act_2 = plot.Get_Event("Rep_Foerost_Campaign_Act_II_Dialog")
			event_act_2.Set_Dialog("DIALOG_FOEROST_CAMPAIGN_REP")
			event_act_2.Clear_Dialog_Text()
			for _,p_planet in pairs(target_planet_list) do
				if p_planet.Get_Owner() ~= p_republic then
					event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_planet)
				elseif p_planet.Get_Owner() == p_republic then
					event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_planet)
				end
			end

			Create_Thread("State_Rep_Planet_Checker")
			Create_Thread("State_Rep_Bulwarks_Unleashed")
			Create_Thread("State_Rep_Anaxes_Anexation_Checker")
		end
    end
end

function State_Rep_Planet_Checker()
	event_act_2 = plot.Get_Event("Rep_Foerost_Campaign_Act_II_Dialog")
	event_act_2.Set_Dialog("DIALOG_FOEROST_CAMPAIGN_REP")
	event_act_2.Clear_Dialog_Text()
	for _,p_planet in pairs(target_planet_list) do
		if p_planet.Get_Owner() ~= p_republic then
			event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_planet)
		elseif p_planet.Get_Owner() == p_republic then
			event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_planet)
		end
	end
	if FindPlanet("Foerost").Get_Owner() == p_republic and FindPlanet("Kaikielius").Get_Owner() == p_republic and FindPlanet("Empress_Teta").Get_Owner() == p_republic and FindPlanet("Vulpter").Get_Owner() == p_republic then
		target_planets_conquered = true
	end
	Sleep(5.0)
	if not target_planets_conquered then
		Create_Thread("State_Rep_Planet_Checker")
	else
		Story_Event("REP_TARGET_PLANETS_CONQUERED")
	end
end

function State_Rep_Bulwarks_Unleashed()
	bulwark_fleet_unit_list = SpawnList(bulwark_fleet_list, p_empress_teta, p_cis, false, false)
	player_bulwark_fleet = Assemble_Fleet(bulwark_fleet_unit_list)
	Register_Timer(State_Rep_Bulwark_Rampage, 80)
end

function State_Rep_Bulwark_Rampage()
	if TestValid(player_bulwark_fleet) then
		potential_targets = FindPlanet.Get_All_Planets()
		target_planet = nil
		attack_gambtit = nil
		local attack_gambtit = GameRandom.Free_Random(1, 4)
		if attack_gambtit == 1 then
			while not target_planet do
				local length = table.getn(potential_targets)
				if length > 0 then
					local index = GameRandom(1, table.getn(potential_targets))
					local potential_target = potential_targets[index]

					if potential_target.Get_Owner() == p_republic then
						if EvaluatePerception("Is_Neglected_By_My_Opponent_Space", p_cis, potential_target) then
							target_planet = potential_target
						end
					end
					table.remove(potential_targets, index)
				else 
					break
				end
			end
		elseif attack_gambtit >= 2 then
			while not target_planet do
				local length = table.getn(potential_targets)
				if length > 0 then
					local index = GameRandom(1, table.getn(potential_targets))
					local potential_target = potential_targets[index]

					if potential_target.Get_Owner() == p_cis then
						target_planet = potential_target
					end
					table.remove(potential_targets, index)
				else 
					break
				end
			end
		end
		current_planet = player_bulwark_fleet.Get_Parent_Object()
		if not current_planet then
			Sleep(5)
		else
			local to_grow_or_not = GameRandom.Free_Random(1, 3)
			if current_planet.Get_Owner() == p_cis then
				growing_list = {"Bulwark_I", "Bulwark_I", "Marauder_Missile_Cruiser", "Marauder_Missile_Cruiser", "Hardcell", "Hardcell", "Hardcell"}
				to_grow_or_not = 1
			end
			if to_grow_or_not == 1 then
				growing_list = {"Bulwark_I", "Munificent", "Munificent", "Munificent", "Munificent", "Hardcell", "Hardcell", "Hardcell_Tender"}
				to_grow_or_not = 1
			elseif to_grow_or_not == 2 then
				growing_list = {"Bulwark_I", "Bulwark_I", "Bulwark_I", "TU_Commander_Auxilia", "Hardcell", "Hardcell",  "Hardcell_Tender", "Hardcell_Tender"}
				to_grow_or_not = 1
			elseif to_grow_or_not == 3 then
				growing_list = {"Bulwark_I", "Bulwark_I", "Bulwark_I", "Bulwark_I", "Marauder_Missile_Cruiser", "Marauder_Missile_Cruiser", "Hardcell",  "Hardcell", "TU_Commander_Hardcell"}
				to_grow_or_not = 1
			end
				local bulwark_fleet_followers = SpawnList(growing_list, current_planet, p_cis, true, false)
			bulwark_fleet_path = Find_Path(p_cis, current_planet, target_planet)
			if bulwark_fleet_path then
				bulwark_commander = Find_First_Object("Dua_Ningo_Unrepentant")
				if TestValid(bulwark_commander) then
					player_bulwark_fleet = bulwark_commander.Get_Parent_Object()
					BlockOnCommand(player_bulwark_fleet.Move_To(target_planet))
					bulwark_commander = Find_First_Object("Dua_Ningo_Unrepentant")
					bulwark_commander.Set_Check_Contested_Space(true)
				end
			end
		end
		if ningo_alive then
			Register_Timer(State_Rep_Bulwark_Rampage, GameRandom.Free_Random(30, 60))
		end
	end
end

function State_Rep_Anaxes_Anexation_Checker()
	plot = Get_Story_Plot("Conquests\\CloneWarsFoerost\\Story_Sandbox_Foerost_Republic.XML")

	event_act_3 = plot.Get_Event("Rep_Foerost_Campaign_Act_III_Dialog")
	event_act_3.Set_Dialog("DIALOG_FOEROST_CAMPAIGN_REP")
	event_act_3.Clear_Dialog_Text()

	if TestValid(Find_First_Object("Screed_Arlionne")) and TestValid(Find_First_Object("Dodonna_Ardent")) then
		event_act_3.Add_Dialog_Text("TEXT_STORY_FOEROST_CAMPAIGN_REP_ACT_III_OBJECTIVE_01")
		event_act_3.Add_Dialog_Text("TEXT_NONE")
		event_act_3.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", FindPlanet("Anaxes"))

		event_act_3_01_task = plot.Get_Event("Rep_Trigger_Anaxes_Annexation")
		event_act_3_01_task.Set_Event_Parameter(2, Find_Object_Type("Dodonna_Ardent"))
	elseif not TestValid(Find_First_Object("Screed_Arlionne")) and TestValid(Find_First_Object("Dodonna_Ardent")) then
		event_act_3.Add_Dialog_Text("TEXT_STORY_FOEROST_CAMPAIGN_REP_ACT_III_OBJECTIVE_02")
		event_act_3.Add_Dialog_Text("TEXT_NONE")
		event_act_3.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", FindPlanet("Anaxes"))

		event_act_3_01_task = plot.Get_Event("Rep_Trigger_Anaxes_Annexation")
		event_act_3_01_task.Set_Event_Parameter(2, Find_Object_Type("Dodonna_Ardent"))
	elseif TestValid(Find_First_Object("Screed_Arlionne")) and not TestValid(Find_First_Object("Dodonna_Ardent")) then
		event_act_3.Add_Dialog_Text("TEXT_STORY_FOEROST_CAMPAIGN_REP_ACT_III_OBJECTIVE_03")
		event_act_3.Add_Dialog_Text("TEXT_NONE")
		event_act_3.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", FindPlanet("Anaxes"))

		event_act_3_01_task = plot.Get_Event("Rep_Trigger_Anaxes_Annexation")
		event_act_3_01_task.Set_Event_Parameter(2, Find_Object_Type("Screed_Arlionne"))
	elseif not TestValid(Find_First_Object("Screed_Arlionne")) and not TestValid(Find_First_Object("Dodonna_Ardent")) then
		event_act_3.Add_Dialog_Text("TEXT_STORY_FOEROST_CAMPAIGN_REP_ACT_III_OBJECTIVE_04")
		event_act_3.Add_Dialog_Text("TEXT_NONE")
		event_act_3.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", FindPlanet("Anaxes"))

		event_act_3_01_task = plot.Get_Event("Rep_Trigger_Anaxes_Annexation")
		event_act_3_01_task.Set_Event_Parameter(2, Find_Object_Type("Generic_Victory_Destroyer"))
	end
	if not anaxes_complete then
		Sleep(5.0)
		Create_Thread("State_Rep_Anaxes_Anexation_Checker")
	end
end

function State_Rep_Anaxes_Annexation_Tactical_Epilogue(message)
	if message == OnEnter then
		if p_republic.Is_Human() then
			anaxes_complete = true
		end
    end
end

function State_Rep_Gladiator_Unleashed(message)
	if message == OnEnter then
		if p_republic.Is_Human() then
			Story_Event("REP_GLADIATOR_UNLEASHED")
			p_republic.Unlock_Tech(Find_Object_Type("Dummy_Research_Gladiator"))
		end
    end
end

function State_Rep_Foerost_Gladiator_Researched(message)
	if message == OnEnter then
		if p_republic.Is_Human() then
			p_republic.Unlock_Tech(Find_Object_Type("Generic_Gladiator"))
		end
    end
end
