require("eawx-util/PopulatePlanetUtilities")

-- Spawns units at all neutral or hostile planets in a GC
function Spawn_At_All_Planets_CW()

	local hostile = Find_Player("Warlords")
	local neutral = Find_Player("Neutral")
	local planet = nil
	local planet_settings = {}
	
	-- Possible spawning units
	-- Arranged as Unit_Table = {{Find_Object_Type("Unit_Name), weight}}
	Unit_Table = {{--Republic GAR focus
					{Find_Object_Type("Generic_Venator"), 3, "Space"}
					,{Find_Object_Type("Generic_Victory_Destroyer"), 3, "Space"}
					,{Find_Object_Type("Generic_Victory_Destroyer_Two"), 1, "Space"}					
					,{Find_Object_Type("Dreadnaught"), 4, "Space"}
					,{Find_Object_Type("Carrack_Cruiser_Lasers"), 5, "Space"}
					,{Find_Object_Type("Generic_Acclamator_Assault_Ship_I"), 4, "Space"}
					,{Find_Object_Type("Generic_Acclamator_Assault_Ship_Leveler"), 4, "Space"}
					,{Find_Object_Type("Generic_Acclamator_Assault_Ship_II"), 4, "Space"}
					,{Find_Object_Type("Generic_Gladiator"), 1, "Space"}					
					,{Find_Object_Type("Generic_Imperial_I_Frigate"), 1, "Space"}					
					,{Find_Object_Type("Victory_I_Frigate"), 1, "Space"}					
					,{Find_Object_Type("Arquitens"), 3, "Space"}
					,{Find_Object_Type("Pelta_Assault"), 3, "Space"}
					,{Find_Object_Type("Pelta_Support"), 3, "Space"}
					,{Find_Object_Type("LAC"), 5, "Space"}
					,{Find_Object_Type("Clonetrooper_Phase_Two_Team_Skirmish"), 4, "Land"}
					,{Find_Object_Type("Clonetrooper_Phase_One_Team_Skirmish"), 3, "Land"}					
					,{Find_Object_Type("Clone_Commando_Team"), 1, "Land"}
					,{Find_Object_Type("ARC_Phase_Two_Team"), 1, "Land"}
					,{Find_Object_Type("ARC_Phase_One_Team"), 0.5, "Land"}		
					,{Find_Object_Type("Clone_Special_Ops_Platoon"), 1, "Land"}					
					,{Find_Object_Type("Republic_AT_RT_Company"), 2, "Land"}
					,{Find_Object_Type("Republic_BARC_Company"), 2, "Land"}
					,{Find_Object_Type("Republic_ISP_Company"), 2, "Land"}
					,{Find_Object_Type("Republic_AT_XT_Company"), 2, "Land"}
					,{Find_Object_Type("Republic_AV7_Company"), 1, "Land"}					
					,{Find_Object_Type("Republic_LAAT_Group"), 1, "Land"}
					,{Find_Object_Type("Republic_HAET_Group"), 1, "Land"}					
					,{Find_Object_Type("Republic_UT_AT_Speeder_Company"), 1, "Land"}
					,{Find_Object_Type("Republic_AT_AP_Walker_Company"), 1, "Land"}
					,{Find_Object_Type("Republic_AT_OT_Walker_Company"), 1, "Land"}					
					,{Find_Object_Type("Republic_AT_TE_Walker_Company"), 1, "Land"}
				}
				
				,{--CIS TF focus
					{Find_Object_Type("Generic_Lucrehulk"), 1, "Space"}
					,{Find_Object_Type("Captor"), 4, "Space"}
					,{Find_Object_Type("Auxilia"), 4, "Space"}
					,{Find_Object_Type("C9979_Carrier"), 5, "Space"}
					,{Find_Object_Type("Hardcell"), 5, "Space"}
					,{Find_Object_Type("Hardcell_Tender"), 2, "Space"}
					,{Find_Object_Type("Lupus_Missile_Frigate"), 5, "Space"}
					,{Find_Object_Type("Munificent"), 4, "Space"}
					,{Find_Object_Type("Lucrehulk_Core_Destroyer"), 2, "Space"}					
					,{Find_Object_Type("Auxiliary_Lucrehulk"), 1, "Space"}
					,{Find_Object_Type("Battleship_Lucrehulk"), 1, "Space"}
					,{Find_Object_Type("B1_Droid_Squad"), 3, "Land"}			
					,{Find_Object_Type("Destroyer_Droid_Company"), 2, "Land"}
					,{Find_Object_Type("STAP_Squad"), 2, "Land"}					
					,{Find_Object_Type("LR_57_Combat_Droid_Company"), 2, "Land"}
					,{Find_Object_Type("Destroyer_Droid_II_Company"), 1, "Land"}					
					,{Find_Object_Type("AAT_Company"), 1, "Land"}
					,{Find_Object_Type("PDF_AAT_Company"), 1, "Land"}					
					,{Find_Object_Type("MTT_Company"), 1, "Land"}
					,{Find_Object_Type("J1_Artillery_Corp"), 2, "Land"}
					,{Find_Object_Type("HAG_Company"), 1, "Land"}
					,{Find_Object_Type("PAC_Company"), 1, "Land"}
					,{Find_Object_Type("HAML_Company"), 1, "Land"}					
					,{Find_Object_Type("GAT_Group"), 1, "Land"}
					,{Find_Object_Type("MAF_Group"), 1, "Land"}
					}

				,{--Republic PDF focus
					{Find_Object_Type("Invincible_Cruiser"), 3, "Space"}
					,{Find_Object_Type("Dreadnaught"), 4, "Space"}
					,{Find_Object_Type("Dreadnaught_Lasers"), 4, "Space"}
					,{Find_Object_Type("Dreadnaught_Carrier"), 2, "Space"}					
					,{Find_Object_Type("Neutron_Star"), 4, "Space"}
					,{Find_Object_Type("Carrack_Cruiser_Lasers"), 5, "Space"}
					,{Find_Object_Type("Generic_Acclamator_Assault_Ship_I"), 2, "Space"}
					,{Find_Object_Type("Generic_Acclamator_Assault_Ship_Leveler"), 3, "Space"}
					,{Find_Object_Type("Generic_Praetor"), 1, "Space"}
					,{Find_Object_Type("Class_C_Frigate"), 3, "Space"}
					,{Find_Object_Type("Class_C_Support"), 2, "Space"}
					,{Find_Object_Type("Corellian_Corvette"), 5, "Space"}
					,{Find_Object_Type("Corellian_Gunboat"), 5, "Space"}
					,{Find_Object_Type("Citadel_Cruiser_Squadron"), 3, "Space"}					
					,{Find_Object_Type("Republic_Trooper_Team"), 5, "Land"}
					,{Find_Object_Type("Republic_Navy_Trooper_Squad"), 3, "Land"}					
					,{Find_Object_Type("Security_Trooper_Team"), 1, "Land"}	
					,{Find_Object_Type("Senate_Commando_Platoon"), 1, "Land"}					
					,{Find_Object_Type("Republic_AT_PT_Company"), 2, "Land"}
					,{Find_Object_Type("Republic_74Z_Bike_Company"), 2, "Land"}
					,{Find_Object_Type("Republic_TX130_Company"), 2, "Land"}
					,{Find_Object_Type("Republic_ULAV_Company"), 2, "Land"}
					,{Find_Object_Type("Republic_UT_AA_Company"), 1, "Land"}					
					,{Find_Object_Type("Republic_A5_Juggernaut_Company"), 1, "Land"}
					,{Find_Object_Type("Republic_A6_Juggernaut_Company"), 1, "Land"}		
					,{Find_Object_Type("Republic_Gaba18_Group"), 1, "Land"}	
					,{Find_Object_Type("Republic_Flashblind_Group"), 1, "Land"}	
					,{Find_Object_Type("Republic_VAAT_Group"), 1, "Land"}						
					}
					
				,{--CIS not TF focus
					{Find_Object_Type("Generic_Providence"), 3, "Space"}
					,{Find_Object_Type("Bulwark_I"), 3, "Space"}
					,{Find_Object_Type("Bulwark_II"), 1, "Space"}
					,{Find_Object_Type("Recusant"), 4, "Space"}
					,{Find_Object_Type("Recusant_Dreadnought"), 2, "Space"}
					,{Find_Object_Type("Munificent"), 4, "Space"}
					,{Find_Object_Type("Providence_Dreadnought"), 1, "Space"}
					,{Find_Object_Type("Diamond_Frigate"), 5, "Space"}
					,{Find_Object_Type("Lupus_Missile_Frigate"), 5, "Space"}
					,{Find_Object_Type("Geonosian_Cruiser"), 5, "Space"}
					,{Find_Object_Type("Gozanti_Cruiser_Squadron"), 5, "Space"}
					,{Find_Object_Type("Supply_Ship"), 4, "Space"}
					,{Find_Object_Type("Subjugator"), 0.5, "Space"}					
					,{Find_Object_Type("B2_Droid_Squad"), 3, "Land"}
					,{Find_Object_Type("Dwarf_Spider_Droid_Company"), 2, "Land"}					
					,{Find_Object_Type("Crab_Droid_Company"), 2, "Land"}
					,{Find_Object_Type("OG9_Company"), 1, "Land"}
					,{Find_Object_Type("Magna_Company"), 1, "Land"}
					,{Find_Object_Type("Persuader_Company"), 1, "Land"}
					,{Find_Object_Type("Riot_Persuader_Company"), 1, "Land"}					
					,{Find_Object_Type("Hailfire_Company"), 2, "Land"}
					,{Find_Object_Type("Riot_Hailfire_Company"), 1, "Land"}					
					,{Find_Object_Type("CA_Artillery_Company"), 1, "Land"}
					,{Find_Object_Type("CIS_MAF_Group"), 1, "Land"}
					,{Find_Object_Type("HMP_Group"), 1, "Land"}					
					}
					
				,{--Fringe focus
					{Find_Object_Type("Home_One_Type_Liner"), 1, "Space"}
					,{Find_Object_Type("Calamari_Cruiser_Liner"), 1, "Space"}
					,{Find_Object_Type("Invincible_Cruiser"), 3, "Space"}
					,{Find_Object_Type("Generic_Tagge_Battlecruiser"), 1, "Space"}
					,{Find_Object_Type("Space_ARC_Cruiser"), 3, "Space"}
					,{Find_Object_Type("Neutron_Star"), 2, "Space"}
					,{Find_Object_Type("Carrack_Cruiser"), 2, "Space"}				
					,{Find_Object_Type("Interceptor_Frigate"), 4, "Space"}
					,{Find_Object_Type("Action_VI_Support"), 3, "Space"}
					,{Find_Object_Type("Lupus_Missile_Frigate"), 5, "Space"}
					,{Find_Object_Type("Marauder_Missile_Cruiser"), 4, "Space"}
					,{Find_Object_Type("Gozanti_Cruiser_Raider_Squadron"), 5, "Space"}
					,{Find_Object_Type("Auxiliary_Lucrehulk"), 1, "Space"}
					,{Find_Object_Type("Super_Transport_VI"), 1, "Space"}
					,{Find_Object_Type("Super_Transport_VII"), 1, "Space"}
					,{Find_Object_Type("Super_Transport_XI"), 1, "Space"}		
					,{Find_Object_Type("Super_Transport_XI_Modified"), 1, "Space"}	
					,{Find_Object_Type("Galleon"), 2, "Space"}
					,{Find_Object_Type("IPV1_System_Patrol_Craft"), 5, "Space"}
					,{Find_Object_Type("Customs_Corvette"), 5, "Space"}
					,{Find_Object_Type("Military_Soldier_Team"), 4, "Land"}
					,{Find_Object_Type("Overracer_Speeder_Bike_Company"), 2, "Land"}
					,{Find_Object_Type("SD_5_Hulk_Infantry_Droid_Company"), 1, "Land"}					
					,{Find_Object_Type("PDF_Soldier_Team"), 4, "Land"}
					,{Find_Object_Type("Police_Responder_Team"), 3, "Land"}					
					,{Find_Object_Type("Espo_Walker_Early_Squad"), 2, "Land"}
					,{Find_Object_Type("X34_Technical_Company"), 2, "Land"}
					,{Find_Object_Type("Arrow_23_Company"), 2, "Land"}
					,{Find_Object_Type("Hutt_Skiff_Group"), 2, "Land"}					
					,{Find_Object_Type("MZ8_Tank_Company"), 1, "Land"}
					,{Find_Object_Type("Republic_A4_Juggernaut_Company"), 1, "Land"}
					,{Find_Object_Type("Skyhopper_Group"), 1, "Land"}
					,{Find_Object_Type("Storm_Cloud_Car_Group"), 1, "Land"}
					,{Find_Object_Type("JX30_Group"), 1, "Land"}					
					}					
	}
	
	Groundbase_Table = {{
					Find_Object_Type("E_Ground_Barracks"),
					Find_Object_Type("E_Ground_Light_Vehicle_Factory"),					
					Find_Object_Type("E_Ground_Heavy_Vehicle_Factory"),					
				}
				
				,{
					Find_Object_Type("R_Ground_Barracks"),
					Find_Object_Type("R_Ground_Light_Vehicle_Factory"),
					Find_Object_Type("R_Ground_Heavy_Vehicle_Factory"),
					}

				,{
					Find_Object_Type("E_Ground_Barracks"),
					Find_Object_Type("E_Ground_Light_Vehicle_Factory"),
					Find_Object_Type("E_Ground_Heavy_Vehicle_Factory"),
					}
					
				,{
					Find_Object_Type("R_Ground_Barracks"),
					Find_Object_Type("R_Ground_Light_Vehicle_Factory"),
					Find_Object_Type("R_Ground_Heavy_Vehicle_Factory"),
					}
					
				,{
					Find_Object_Type("Revolt_Rural_PDF_Barracks"),
					Find_Object_Type("Revolt_Walker_Light_Factory"),
					Find_Object_Type("Revolt_UI_Light_Factory"),
					}					
					
				}
						
	
	DebugMessage("%s -- Initializing spawning", tostring(Script))
	if hostile.Get_Difficulty() == "Easy" then
		Difficulty_Modifier = 0.75
	elseif hostile.Get_Difficulty() == "Hard" then
		Difficulty_Modifier = 1.5
	else
		Difficulty_Modifier = 1.0
	end
		
	-- Loop through	all planets once, spawning units
	for _, planet in pairs(FindPlanet.Get_All_Planets()) do
		-- Hostile unit spawns
		if planet.Get_Owner() == (neutral or hostile) then	
		
			-- Scaled combat power based on planet value, reduced by if connected to a player, then increased or decreased by difficulty level
			scaled_combat_power = 7500 * EvaluatePerception("GenericPlanetValue", hostile, planet) * (1.5 - EvaluatePerception("Is_Connected_To_Player", hostile, planet)) * Difficulty_Modifier
			-- pick a random unit selection table
			random_table_index = GameRandom.Free_Random(1, table.getn(Unit_Table))
			
			DebugMessage("%s -- Attempting to spawn units at %s, from table number %s, combat power %s, difficulty modifier %s", tostring(Script), tostring(planet), tostring(random_table_index), tostring(scaled_combat_power), tostring(Difficulty_Modifier))
			-- Spawns random units at the planet for the given faction and combat power per planet
			Spawn_Random_Units(Unit_Table[random_table_index], planet, hostile, scaled_combat_power, true)
		end
	end
end