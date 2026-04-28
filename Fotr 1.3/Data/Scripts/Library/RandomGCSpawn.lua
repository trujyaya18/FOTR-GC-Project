require("eawx-util/PopulatePlanetUtilities")
require("UnitSpawnerTables")

-- Spawns units at all neutral or hostile planets in a GC
function Spawn_At_All_Planets()
 
	local hostile = Find_Player("Warlords")
	local neutral = Find_Player("Neutral")
	local planet = nil
	local planet_settings = {}
	
	-- Possible spawning units
	-- Arranged as Unit_Table = {{Find_Object_Type("Unit_Name), weight}}
	Unit_Table = {{--Imperial Remnant focus
					{Find_Object_Type("Generic_Venator"), 3, "Space"}
					,{Find_Object_Type("Lancer_Frigate"), 5, "Space"}
					,{Find_Object_Type("Escort_Carrier"), 5, "Space"}
					,{Find_Object_Type("Carrack_Cruiser"), 5, "Space"}
					,{Find_Object_Type("Strike_Cruiser"), 4, "Space"}
					,{Find_Object_Type("Vindicator_Cruiser"), 4, "Space"}
					,{Find_Object_Type("Escort_Carrier"), 4, "Space"}
					,{Find_Object_Type("Dreadnaught_Empire"), 4, "Space"}
					,{Find_Object_Type("Generic_Acclamator_Assault_Ship_II"), 3, "Space"}
					,{Find_Object_Type("Generic_Victory_Destroyer"), 3, "Space"}
					,{Find_Object_Type("Generic_Victory_Destroyer_Two"), 3, "Space"}
					,{Find_Object_Type("Generic_Procursator"), 3, "Space"}
					,{Find_Object_Type("Generic_Star_Destroyer_Two"), 1, "Space"}
					,{Find_Object_Type("Generic_Star_Destroyer"), 1, "Space"}
					,{Find_Object_Type("Generic_Dominator"), 1, "Space"}
					,{Find_Object_Type("Generic_Executor"), 0.05, "Space"}
					,{Find_Object_Type("Imperial_Stormtrooper_Squad"), 5, "Land"}
					,{Find_Object_Type("Imperial_74Z_Bike_Company"), 2, "Land"}				
					,{Find_Object_Type("Imperial_S_1_Firehawke_Company"), 2, "Land"}
					,{Find_Object_Type("Imperial_Chariot_LAV_Company"), 2, "Land"}
					,{Find_Object_Type("Imperial_PX4_Company"), 2, "Land"}					
					,{Find_Object_Type("Imperial_AT_ST_Company"), 3, "Land"}
					,{Find_Object_Type("Imperial_AT_AT_Company"), 1, "Land"}
					,{Find_Object_Type("Imperial_SPMAG_Company"), 1, "Land"}					
					,{Find_Object_Type("Imperial_IDT_Group"), 1, "Land"}					
				}
				
				,{--Early NR focus
					{Find_Object_Type("Calamari_Cruiser"), 2, "Space"}
					,{Find_Object_Type("Quasar"), 5, "Space"}
					,{Find_Object_Type("Nebulon_B_Frigate"), 5, "Space"}
					,{Find_Object_Type("Alliance_Assault_Frigate"), 4, "Space"}
					,{Find_Object_Type("MC30a"), 4, "Space"}
					,{Find_Object_Type("Corellian_Corvette"), 5, "Space"}
					,{Find_Object_Type("Corellian_Gunboat"), 5, "Space"}
					,{Find_Object_Type("Marauder_Missile_Cruiser"), 5, "Space"}
					,{Find_Object_Type("Dauntless"), 2, "Space"}
					,{Find_Object_Type("Republic_SD"), 1, "Space"}					
					,{Find_Object_Type("MC80B"), 1, "Space"}
					,{Find_Object_Type("MC40a"), 3, "Space"}
					,{Find_Object_Type("MC30c"), 3, "Space"}
					,{Find_Object_Type("Liberator_Cruiser"), 3, "Space"}
					,{Find_Object_Type("Rebel_Infantry_Squad"), 4, "Land"}
					,{Find_Object_Type("Rebel_T1B_Company"), 3, "Land"}
					,{Find_Object_Type("Rebel_T3B_Company"), 1, "Land"}
					,{Find_Object_Type("Rebel_Freerunner_Company"), 2, "Land"}
					,{Find_Object_Type("Rebel_AA5_Company"), 2, "Land"}
					,{Find_Object_Type("Rebel_Gallofree_HTT_Company"), 1, "Land"}
					,{Find_Object_Type("Rebel_Snowspeeder_Wing"), 1, "Land"}					
					}
					
				,{--Late NR focus
					{Find_Object_Type("Corona"), 5, "Space"}
					,{Find_Object_Type("Sacheen"), 5, "Space"}
					,{Find_Object_Type("Defender_Carrier"), 4, "Space"}
					,{Find_Object_Type("BAC"), 2, "Space"}
					,{Find_Object_Type("Endurance"), 1, "Space"}
					,{Find_Object_Type("Corellian_Corvette"), 5, "Space"}
					,{Find_Object_Type("Nebula"), 1, "Space"}
					,{Find_Object_Type("Majestic"), 2, "Space"}
					,{Find_Object_Type("Viscount"), 0.05, "Space"}
					,{Find_Object_Type("MC90"), 1, "Space"}
					,{Find_Object_Type("MC40a"), 3, "Space"}
					,{Find_Object_Type("MC30c"), 3, "Space"}
					,{Find_Object_Type("Mothma_Star_Destroyer"), 1, "Space"}
					,{Find_Object_Type("Mini_Viscount"), 0.1, "Space"}					
					,{Find_Object_Type("Defense_Trooper_Squad"), 3, "Land"}
					,{Find_Object_Type("Rebel_T2B_Company"), 3, "Land"}
					,{Find_Object_Type("Rebel_T4B_Company"), 3, "Land"}
					,{Find_Object_Type("Rebel_AAC_2_Company"), 3, "Land"}				
					,{Find_Object_Type("Rebel_Tracker_Company"), 2, "Land"}
					,{Find_Object_Type("Rebel_MPTL_Company"), 1, "Land"}					
					,{Find_Object_Type("Rebel_Vwing_Group"), 1, "Land"}					
					}
					
				,{--Hapan focus
					{Find_Object_Type("BattleDragon"), 3, "Space"}
					,{Find_Object_Type("Nova_Cruiser"), 4, "Space"}
					,{Find_Object_Type("Beta_Cruiser"), 4, "Space"}
					,{Find_Object_Type("Stella"), 4, "Space"}
					,{Find_Object_Type("Baidam"), 4, "Space"}			
					,{Find_Object_Type("Hapan_Infantry_Squad"), 3, "Land"}
					,{Find_Object_Type("HRG_Commando_Squad"), 1, "Land"}
					,{Find_Object_Type("Hapan_LightTank_Company"), 3, "Land"}
					,{Find_Object_Type("Hapan_Transport_Company"), 2, "Land"}
					,{Find_Object_Type("Hapan_HeavyTank_Company"), 2, "Land"}				
					}
					
				,{--EotH focus
					{Find_Object_Type("Chaf_Destroyer"), 3, "Space"}
					,{Find_Object_Type("Fruoro"), 5, "Space"}
					,{Find_Object_Type("Syndic_Destroyer"), 5, "Space"}
					,{Find_Object_Type("Phalanx_Destroyer"), 2, "Space"}
					,{Find_Object_Type("Peltast"), 2, "Space"}
					,{Find_Object_Type("Ormos"), 4, "Space"}
					,{Find_Object_Type("Muqaraea"), 5, "Space"}
					,{Find_Object_Type("Rohkea"), 4, "Space"}
					,{Find_Object_Type("Kuuro"), 5, "Space"}
					,{Find_Object_Type("Phalanx_Trooper_Squad"), 5, "Land"}
					,{Find_Object_Type("EotH_Kirov_Brigade"), 2, "Land"}
					,{Find_Object_Type("MMT_Brigade"), 3, "Land"}
					,{Find_Object_Type("Flame_Tank_Company"), 1, "Land"}
					,{Find_Object_Type("RFT_Brigade"), 2, "Land"}
					,{Find_Object_Type("EotH_Scout_Brigade"), 3, "Land"}
					,{Find_Object_Type("Gilzean_Brigade"), 1, "Land"}
					}
					
				,{--Imperial EA focus
					{Find_Object_Type("IPV1_System_Patrol_Craft"), 5, "Space"}
					,{Find_Object_Type("Eidolon"), 3, "Space"}
					,{Find_Object_Type("Generic_Gladiator"), 4, "Space"}
					,{Find_Object_Type("Generic_Imperial_I_Frigate"), 4, "Space"}
					,{Find_Object_Type("Generic_Victory_Destroyer"), 3, "Space"}
					,{Find_Object_Type("Generic_Star_Destroyer_Two"), 1, "Space"}
					,{Find_Object_Type("Generic_Star_Destroyer"), 1, "Space"}
					,{Find_Object_Type("Imperial_AT_AT_Company"), 1, "Land"}
					,{Find_Object_Type("Army_Trooper_Squad"), 5, "Land"}
					,{Find_Object_Type("Army_Special_Missions_Squad"), 2, "Land"}					
					,{Find_Object_Type("Imperial_AT_MP_Company"), 3, "Land"}					
					,{Find_Object_Type("Imperial_TRMB_Company"), 1, "Land"}
					,{Find_Object_Type("Imperial_1L_Tank_Company"), 2, "Land"}
					,{Find_Object_Type("Imperial_1M_Tank_Company"), 2, "Land"}					
					,{Find_Object_Type("Imperial_1H_Tank_Company"), 2, "Land"}
					,{Find_Object_Type("Imperial_Lancet_Group"), 1, "Land"}
					,{Find_Object_Type("Imperial_Flashblind_Group"), 1, "Land"}					
					}
					
				,{--Imperial GM focus
					{Find_Object_Type("Tartan_Patrol_Cruiser"), 5, "Space"}
					,{Find_Object_Type("Carrack_Cruiser"), 3, "Space"}
					,{Find_Object_Type("Vigil"), 4, "Space"}
					,{Find_Object_Type("Generic_Imperial_II_Frigate"), 4, "Space"}
					,{Find_Object_Type("Broadside_Cruiser"), 3, "Space"}					
					,{Find_Object_Type("Generic_Pursuit"), 3, "Space"}					
					,{Find_Object_Type("Strike_Cruiser_Gorath"), 3, "Space"}					
					,{Find_Object_Type("Generic_Victory_Destroyer"), 3, "Space"}
					,{Find_Object_Type("Crimson_Victory"), 3, "Space"}
					,{Find_Object_Type("Generic_Star_Destroyer"), 1, "Space"}
					,{Find_Object_Type("Generic_Dominator"), 1, "Land"}
					,{Find_Object_Type("Army_Trooper_Squad"), 5, "Land"}
					,{Find_Object_Type("Imperial_Navy_Commando_Squad"), 2, "Land"}					
					,{Find_Object_Type("Imperial_INT4_Group"), 2, "Land"}					
					,{Find_Object_Type("Imperial_AT_RT_Company"), 3, "Land"}					
					,{Find_Object_Type("Imperial_RTT_Company"), 1, "Land"}
					,{Find_Object_Type("Imperial_ISP_Company"), 2, "Land"}
					,{Find_Object_Type("Imperial_2M_Company"), 2, "Land"}					
					,{Find_Object_Type("Imperial_SA5_Company"), 2, "Land"}
					,{Find_Object_Type("Imperial_A5_Juggernaut_Company"), 1, "Land"}
					,{Find_Object_Type("Imperial_Heavy_Recovery_Vehicle_Company"), 1, "Land"}					
					,{Find_Object_Type("Imperial_MAAT_Group"), 1, "Land"}					
					}					
					
				,{--Imperial PA focus
					{Find_Object_Type("Raider_Corvette"), 3, "Space"}
					,{Find_Object_Type("Trenchant"), 3, "Space"}					
					,{Find_Object_Type("Victory_II_Frigate"), 4, "Space"}
					,{Find_Object_Type("Dreadnaught_Empire"), 4, "Space"}
					,{Find_Object_Type("Enforcer"), 4, "Space"}
					,{Find_Object_Type("Generic_Acclamator_Assault_Ship_Leveler"), 3, "Space"}
					,{Find_Object_Type("Generic_Venator"), 3, "Space"}
					,{Find_Object_Type("Generic_Procursator"), 3, "Space"}
					,{Find_Object_Type("Generic_Secutor"), 1, "Space"}
					,{Find_Object_Type("Generic_Tector"), 1, "Space"}
					,{Find_Object_Type("Enforcer_Trooper_Squad"), 5, "Land"}
					,{Find_Object_Type("Pentastar_Army_Trooper_Squad"), 2, "Land"}					
					,{Find_Object_Type("Imperial_AT_DP_Company"), 2, "Land"}
					,{Find_Object_Type("Imperial_TIE_Mauler_Company"), 3, "Land"}
					,{Find_Object_Type("Imperial_Century_Tank_Company"), 2, "Land"}			
					,{Find_Object_Type("Imperial_AT_PT_Company"), 4, "Land"}
					,{Find_Object_Type("Imperial_Gaba18_Group"), 2, "Land"}					
					,{Find_Object_Type("Imperial_C10_Siege_Tower_Company"), 1, "Land"}
					,{Find_Object_Type("Imperial_B5_Juggernaut_Company"), 1, "Land"}					
					,{Find_Object_Type("Imperial_Nemesis_Gunship_Group"), 1, "Land"}					
					}

				,{--Imperial ZE focus
					{Find_Object_Type("CR90_Zsinj"), 3, "Space"}
					,{Find_Object_Type("Victory_II_Frigate"), 4, "Space"}				
					,{Find_Object_Type("Surveyor_Frigate"), 4, "Space"}
					,{Find_Object_Type("Nebulon_B_Zsinj"), 4, "Space"}
					,{Find_Object_Type("Neutron_Star"), 2, "Space"}
					,{Find_Object_Type("Vengeance_Frigate"), 3, "Space"}
					,{Find_Object_Type("Action_VI_Support"), 3, "Space"}
					,{Find_Object_Type("Interceptor_Frigate"), 3, "Space"}
					,{Find_Object_Type("Generic_Victory_Destroyer_Two"), 3, "Space"}					
					,{Find_Object_Type("Generic_Star_Destroyer"), 1, "Space"}
					,{Find_Object_Type("Generic_Star_Destroyer_Two"), 1, "Space"}
					,{Find_Object_Type("Zsinj_Raptor_Squad"), 4, "Land"}
					,{Find_Object_Type("Army_Trooper_Squad"), 2, "Land"}
					,{Find_Object_Type("EVO_Trooper_Platoon"), 1, "Land"}					
					,{Find_Object_Type("Zsinj_74Z_Bike_Company"), 2, "Land"}					
					,{Find_Object_Type("Imperial_Repulsor_Scout_Company"), 2, "Land"}
					,{Find_Object_Type("Imperial_PX10_Company"), 4, "Land"}
					,{Find_Object_Type("Imperial_ULAV_Company"), 3, "Land"}	
					,{Find_Object_Type("Imperial_AT_AP_Walker_Company"), 1, "Land"}
					,{Find_Object_Type("Imperial_SPMAT_Company"), 1, "Land"}
					,{Find_Object_Type("Imperial_APC_Company"), 1, "Land"}					
					,{Find_Object_Type("Imperial_A9_Fortress_Company"), 1, "Land"}
					}	

				,{--PDF focus
					{Find_Object_Type("Active_Frigate"), 5, "Space"}
					,{Find_Object_Type("Victory_I_Frigate"), 3, "Space"}
					,{Find_Object_Type("Marauder_Missile_Cruiser"), 4, "Space"}
					,{Find_Object_Type("IPV1_System_Patrol_Craft"), 5, "Space"}
					,{Find_Object_Type("Generic_Acclamator_Assault_Ship_I"), 2, "Space"}
					,{Find_Object_Type("Generic_Acclamator_Assault_Ship_Leveler"), 2, "Space"}
					,{Find_Object_Type("Arquitens"), 3, "Space"}
					,{Find_Object_Type("Pelta_Support"), 3, "Space"}
					,{Find_Object_Type("Invincible_Cruiser"), 1, "Space"}
					,{Find_Object_Type("PDF_Soldier_Team"), 5, "Land"}
					,{Find_Object_Type("Police_Responder_Team"), 3, "Land"}
					,{Find_Object_Type("Light_Mercenary_Team"), 1, "Land"}						
					,{Find_Object_Type("Espo_Walker_Early_Squad"), 3, "Land"}
					,{Find_Object_Type("ULAV_Early_Company"), 3, "Land"}
					,{Find_Object_Type("AAC_1_Company"), 3, "Land"}				
					,{Find_Object_Type("AA70_Company"), 1, "Land"}
					,{Find_Object_Type("Freerunner_Early_Company"), 1, "Land"}
					,{Find_Object_Type("T1A_Company"), 3, "Land"}
					,{Find_Object_Type("T3A_Company"), 3, "Land"}
					,{Find_Object_Type("Teklos_Company"), 2, "Land"}
					,{Find_Object_Type("Imperial_TX130_Company"), 2, "Land"}					
					,{Find_Object_Type("Skyhopper_Group"), 1, "Land"}
					,{Find_Object_Type("Imperial_LAAT_Group"), 1, "Land"}					
					}		

				,{--PDF Alternate focus
					{Find_Object_Type("Home_One_Type_Liner"), 0.5, "Space"}
					,{Find_Object_Type("Calamari_Cruiser_Liner"), 0.5, "Space"}
					,{Find_Object_Type("Corellian_Gunboat"), 5, "Space"}
					,{Find_Object_Type("Carrack_Cruiser"), 5, "Space"}
					,{Find_Object_Type("Dreadnaught_Carrier"), 2, "Space"}
					,{Find_Object_Type("Neutron_Star"), 2, "Space"}
					,{Find_Object_Type("Recusant"), 1, "Space"}
					,{Find_Object_Type("Corellian_Corvette"), 5, "Space"}
					,{Find_Object_Type("Captor"), 2, "Space"}
					,{Find_Object_Type("Generic_Providence"), 1, "Space"}
					,{Find_Object_Type("Munificent"), 3, "Space"}
					,{Find_Object_Type("Dreadnaught_Empire"), 3, "Space"}
					,{Find_Object_Type("Bulwark_II"), 1, "Space"}
					,{Find_Object_Type("Military_Soldier_Team"), 5, "Land"}
					,{Find_Object_Type("Security_Trooper_Team"), 3, "Land"}		
					,{Find_Object_Type("Mercenary_Team"), 1, "Land"}	
					,{Find_Object_Type("T2A_Company"), 3, "Land"}
					,{Find_Object_Type("T4A_Company"), 3, "Land"}
					,{Find_Object_Type("Teklos_Company"), 2, "Land"}
					,{Find_Object_Type("Arrow_23_Company"), 3, "Land"}
					,{Find_Object_Type("Freerunner_Assault_Company"), 3, "Land"}
					,{Find_Object_Type("SA5_Company_Early_Company"), 3, "Land"}					
					,{Find_Object_Type("Freerunner_AA_Company"), 2, "Land"}
					,{Find_Object_Type("Aratech_Battle_Platform_Company"), 1, "Land"}	
					,{Find_Object_Type("Imperial_A6_Juggernaut_Company"), 1, "Land"}					
					,{Find_Object_Type("Storm_Cloud_Car_Group"), 1, "Land"}					
					}	

				,{--Scum focus
					{Find_Object_Type("Template_Crusader_Gunship"), 5, "Space"}
					,{Find_Object_Type("Template_Namana_Cruiser"), 2, "Space"}
					,{Find_Object_Type("Skandrei_Gunship"), 2, "Space"}
					,{Find_Object_Type("Vengeance_Frigate"), 2, "Space"}
					,{Find_Object_Type("Action_VI_Support"), 1, "Space"}
					,{Find_Object_Type("Interceptor_Frigate"), 5, "Space"}
					,{Find_Object_Type("Space_ARC_Cruiser"), 2, "Space"}
					,{Find_Object_Type("Bakura_Destroyer"), 2, "Space"}
					,{Find_Object_Type("Generic_Gladiator_Two"), 2, "Space"}					
					,{Find_Object_Type("Template_Keldabe"), 1, "Space"}
					,{Find_Object_Type("Elite_Mercenary_Team"), 1, "Land"}
					,{Find_Object_Type("Scavenger_Team"), 3, "Land"}
					,{Find_Object_Type("Heavy_Scavenger_Team"), 3, "Land"}
					,{Find_Object_Type("X34_Technical_Company"), 3, "Land"}
					,{Find_Object_Type("Skyhopper_Antivehicle_Group"), 1, "Land"}
					,{Find_Object_Type("Hutt_Skiff_Group"), 3, "Land"}					
					,{Find_Object_Type("JX30_Group"), 1, "Land"}					
					,{Find_Object_Type("MZ8_Tank_Company"), 2, "Land"}
					,{Find_Object_Type("A4_Juggernaut_Company"), 1, "Land"}
					,{Find_Object_Type("Imperial_AT_TE_Walker_Company"), 1, "Land"}					
					,{Find_Object_Type("Canderous_Assault_Tank_Company"), 1, "Land"}					
					}						
					
				,{--CSA focus
					{Find_Object_Type("Citadel_Cruiser_Squadron"), 4, "Space"}
					,{Find_Object_Type("Gozanti_Cruiser_Squadron"), 5, "Space"}
					,{Find_Object_Type("Marauder_Missile_Cruiser"), 5, "Space"}
					,{Find_Object_Type("Etti_Lighter"), 4, "Space"}
					,{Find_Object_Type("Recusant"), 4, "Space"}
					,{Find_Object_Type("Neutron_Star"), 4, "Space"}
					,{Find_Object_Type("Generic_Gladiator"), 2, "Space"}					
					,{Find_Object_Type("Generic_Victory_Destroyer"), 3, "Space"}
					,{Find_Object_Type("Bulwark_I"), 3, "Space"}
					,{Find_Object_Type("Invincible_Cruiser"), 1, "Space"}
					,{Find_Object_Type("Espo_Squad"), 4, "Land"}
					,{Find_Object_Type("Class_I_Company"), 2, "Land"}
					,{Find_Object_Type("Strikebreaker_Group"), 5, "Land"}
					,{Find_Object_Type("GX12_Company"), 2, "Land"}					
					,{Find_Object_Type("JX40_Group"), 2, "Land"}
					,{Find_Object_Type("SX20_Company"), 4, "Land"}
					,{Find_Object_Type("X10_Group"), 1, "Land"}
					,{Find_Object_Type("Espo_Walker_Squad"), 3, "Land"}
					,{Find_Object_Type("K222_Group"), 1, "Land"}					
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
					Find_Object_Type("R_Ground_Barracks"),
					Find_Object_Type("R_Ground_Light_Vehicle_Factory"),
					Find_Object_Type("R_Ground_Heavy_Vehicle_Factory"),
					}
				,{
					Find_Object_Type("HC_Ground_Barracks"),
					Find_Object_Type("HC_Ground_Light_Vehicle_Factory"),
					Find_Object_Type("HC_Ground_Heavy_Vehicle_Factory"),
					}
				,{
					Find_Object_Type("U_Ground_Barracks"),
					Find_Object_Type("U_Ground_Light_Vehicle_Factory"),
					Find_Object_Type("U_Ground_Vehicle_Factory"),
					}
					
				,{
					Find_Object_Type("A_Ground_Barracks"),
					Find_Object_Type("A_Ground_Light_Vehicle_Factory"),
					Find_Object_Type("A_Ground_Heavy_Vehicle_Factory"),
					}

				,{
					Find_Object_Type("T_Ground_Barracks"),
					Find_Object_Type("T_Ground_Light_Vehicle_Factory"),
					Find_Object_Type("T_Ground_Heavy_Vehicle_Factory"),
					}				

				,{
					Find_Object_Type("P_Ground_Barracks"),
					Find_Object_Type("P_Ground_Light_Vehicle_Factory"),
					Find_Object_Type("P_Ground_Heavy_Vehicle_Factory"),
					}

				,{
					Find_Object_Type("Z_Ground_Barracks"),
					Find_Object_Type("Z_Ground_Light_Vehicle_Factory"),
					Find_Object_Type("Z_Ground_Heavy_Vehicle_Factory"),
					}					

				,{
					Find_Object_Type("Revolt_Rural_PDF_Barracks"),
					Find_Object_Type("Revolt_Walker_Light_Factory"),
					Find_Object_Type("Revolt_OldRep_Heavy_Factory"),
					}
					
				,{
					Find_Object_Type("Revolt_Rural_Barracks"),
					Find_Object_Type("Revolt_YT_Light_Factory"),
					Find_Object_Type("Revolt_YT_Heavy_Factory"),
					}

				,{
					Find_Object_Type("Revolt_Scavenger_Outpost"),
					Find_Object_Type("Revolt_Scavenger_Base"),
					Find_Object_Type("Revolt_Illegal_Heavy_Factory"),
					}					
										
				,{
					Find_Object_Type("C_Ground_Barracks"),
					Find_Object_Type("C_Ground_Light_Vehicle_Factory"),
					Find_Object_Type("C_Ground_Heavy_Vehicle_Factory"),
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
		
			Starbase_Table = DefineStarBaseTable(hostile)
			Shipyard_Table = DefineShipyardTable(hostile)
		
			-- Scaled combat power based on planet value, reduced by if connected to a player, then increased or decreased by difficulty level
			scaled_combat_power = 7500 * EvaluatePerception("GenericPlanetValue", hostile, planet) * (1.5 - EvaluatePerception("Is_Connected_To_Player", hostile, planet)) * Difficulty_Modifier
			-- pick a random unit selection table
			random_table_index = GameRandom.Free_Random(1, table.getn(Unit_Table))
			
			DebugMessage("%s -- Attempting to spawn units at %s, from table number %s, combat power %s, difficulty modifier %s", tostring(Script), tostring(planet), tostring(random_table_index), tostring(scaled_combat_power), tostring(Difficulty_Modifier))
			-- Spawns random units at the planet for the given faction and combat power per planet
			Spawn_Random_Units(Unit_Table[random_table_index], Groundbase_Table[random_table_index], Starbase_Table, Shipyard_Table, nil, planet, hostile, scaled_combat_power, true)
		end
	end
end
