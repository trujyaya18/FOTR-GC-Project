function DefineUnitTable(faction)

    if faction == Find_Player("Empire") then
	    Unit_Table = {
            {Find_Object_Type("Invincible_Cruiser"), 1, "Space"}
            ,{Find_Object_Type("Dreadnaught"), 4, "Space"}
            ,{Find_Object_Type("Dreadnaught_Lasers"), 4, "Space"}			
            ,{Find_Object_Type("Carrack_Cruiser_Lasers"), 5, "Space"}
            ,{Find_Object_Type("Generic_Acclamator_Assault_Ship_I"), 4, "Space"}
            ,{Find_Object_Type("Generic_Acclamator_Assault_Ship_Leveler"), 4, "Space"}
            ,{Find_Object_Type("Arquitens"), 3, "Space"}
            ,{Find_Object_Type("Pelta_Assault"), 3, "Space"}
            ,{Find_Object_Type("Pelta_Support"), 3, "Space"}
            ,{Find_Object_Type("LAC"), 5, "Space"}
            ,{Find_Object_Type("Corellian_Corvette"), 5, "Space"}
            ,{Find_Object_Type("Corellian_Gunboat"), 5, "Space"}
            ,{Find_Object_Type("Republic_Trooper_Team"), 5, "Land"}
            ,{Find_Object_Type("Republic_Navy_Trooper_Squad"), 3, "Land"}			
            ,{Find_Object_Type("Clonetrooper_Phase_One_Team"), 5, "Land"}
            ,{Find_Object_Type("Clone_Galactic_Marine_Platoon"), 1, "Land"}
            ,{Find_Object_Type("Republic_SD_6_Droid_Company"), 1, "Land"}			
			,{Find_Object_Type("Republic_AT_PT_Company"), 2, "Land"}
            ,{Find_Object_Type("Republic_AT_RT_Company"), 2, "Land"}
            ,{Find_Object_Type("Republic_74Z_Bike_Company"), 2, "Land"}
            ,{Find_Object_Type("Republic_TX130_Company"), 2, "Land"}
            ,{Find_Object_Type("Republic_AV7_Company"), 2, "Land"}
			,{Find_Object_Type("Republic_UT_AA_Company"), 1, "Land"}			
            ,{Find_Object_Type("Republic_LAAT_Group"), 1, "Land"}
            ,{Find_Object_Type("Republic_VAAT_Group"), 0.5, "Land"}
            ,{Find_Object_Type("Republic_Gaba18_Group"), 1, "Land"}			
            ,{Find_Object_Type("Republic_A5_Juggernaut_Company"), 1, "Land"}
			,{Find_Object_Type("Republic_UT_AT_Speeder_Company"), 1, "Land"}
            ,{Find_Object_Type("Republic_AT_TE_Walker_Company"), 1, "Land"}
        }
    elseif faction == Find_Player("Rebel") or faction == Find_Player("Techno_Union") or faction == Find_Player("Commerce_Guild") or faction == Find_Player("Banking_Clan") or faction == Find_Player("Trade_Federation") then  
        Unit_Table = {
            {Find_Object_Type("Generic_Providence"), 3, "Space"}
			,{Find_Object_Type("Lucrehulk_Core_Destroyer"), 1, "Space"}
			,{Find_Object_Type("Captor"), 4, "Space"}
			,{Find_Object_Type("Auxilia"), 4, "Space"}
            ,{Find_Object_Type("Recusant"), 4, "Space"}
			,{Find_Object_Type("C9979_Carrier"), 5, "Space"}
			,{Find_Object_Type("Hardcell"), 5, "Space"}
			,{Find_Object_Type("Hardcell_Tender"), 2, "Space"}
			,{Find_Object_Type("Munificent"), 4, "Space"}
            ,{Find_Object_Type("Munifex"), 5, "Space"}
            ,{Find_Object_Type("Diamond_Frigate"), 5, "Space"}
			,{Find_Object_Type("Lupus_Missile_Frigate"), 5, "Space"}
            ,{Find_Object_Type("Geonosian_Cruiser"), 1, "Space"}
            ,{Find_Object_Type("CIS_Dreadnaught_Lasers"), 1, "Space"}			
            ,{Find_Object_Type("Gozanti_Cruiser_Squadron"), 5, "Space"}
            ,{Find_Object_Type("Supply_Ship"), 2, "Space"}
			,{Find_Object_Type("B1_Droid_Squad"), 3, "Land"}
            ,{Find_Object_Type("B2_Droid_Squad"), 3, "Land"}
			,{Find_Object_Type("Destroyer_Droid_Company"), 2, "Land"}
            ,{Find_Object_Type("Crab_Droid_Company"), 2, "Land"}
            ,{Find_Object_Type("Dwarf_Spider_Droid_Company"), 2, "Land"}			
			,{Find_Object_Type("STAP_Squad"), 2, "Land"}
			,{Find_Object_Type("AAT_Company"), 1, "Land"}
			,{Find_Object_Type("HAG_Company"), 1, "Land"}
			,{Find_Object_Type("HAML_Company"), 1, "Land"}			
			,{Find_Object_Type("MTT_Company"), 1, "Land"}
            ,{Find_Object_Type("OG9_Company"), 1, "Land"}
            ,{Find_Object_Type("Magna_Company"), 1, "Land"}
            ,{Find_Object_Type("Persuader_Company"), 1, "Land"}
            ,{Find_Object_Type("Hailfire_Company"), 2, "Land"}
			,{Find_Object_Type("J1_Artillery_Corp"), 1, "Land"}
			,{Find_Object_Type("CA_Artillery_Company"), 1, "Land"}
			,{Find_Object_Type("PAC_Company"), 1, "Land"}			
			,{Find_Object_Type("MAF_Group"), 1, "Land"}
            }
    elseif faction == Find_Player("Sector_Forces") then       
        Unit_Table = {
            {Find_Object_Type("Invincible_Cruiser"), 3, "Space"}
            ,{Find_Object_Type("Generic_Tagge_Battlecruiser"), 0.1, "Space"}			
            ,{Find_Object_Type("Dreadnaught_Lasers"), 4, "Space"}
            ,{Find_Object_Type("Dreadnaught"), 3, "Space"}
            ,{Find_Object_Type("Dreadnaught_Carrier"), 2, "Space"}				
            ,{Find_Object_Type("Carrack_Cruiser_Lasers"), 5, "Space"}		
            ,{Find_Object_Type("Generic_Acclamator_Assault_Ship_I"), 4, "Space"}
            ,{Find_Object_Type("Generic_Acclamator_Assault_Ship_Leveler"), 4, "Space"}
            ,{Find_Object_Type("Generic_Praetor"), 0.1, "Space"}
            ,{Find_Object_Type("Citadel_Cruiser_Squadron"), 3, "Space"}
            ,{Find_Object_Type("Galleon"), 3, "Space"}
			,{Find_Object_Type("Class_C_Frigate"), 3, "Space"}
			,{Find_Object_Type("Class_C_Support"), 3, "Space"}
            ,{Find_Object_Type("Corellian_Corvette"), 5, "Space"}
            ,{Find_Object_Type("Corellian_Gunboat"), 5, "Space"}
			,{Find_Object_Type("Customs_Corvette"), 5, "Space"}
            ,{Find_Object_Type("IPV1_System_Patrol_Craft"), 5, "Space"}			
            ,{Find_Object_Type("Republic_Trooper_Team"), 5, "Land"}
            ,{Find_Object_Type("Republic_Navy_Trooper_Squad"), 3, "Land"}		
            ,{Find_Object_Type("Republic_AT_PT_Company"), 2, "Land"}
            ,{Find_Object_Type("Republic_Overracer_Speeder_Bike_Company"), 2, "Land"}
            ,{Find_Object_Type("Republic_ULAV_Company"), 2, "Land"}
            ,{Find_Object_Type("Republic_VAAT_Group"), 1, "Land"}
            ,{Find_Object_Type("Republic_Gaba18_Group"), 1, "Land"}			
            ,{Find_Object_Type("Republic_A5_Juggernaut_Company"), 1, "Land"}
            ,{Find_Object_Type("Republic_A4_Juggernaut_Company"), 1, "Land"}			
        }
    elseif faction == Find_Player("Hutt_Cartels") then       
        Unit_Table = {
            {Find_Object_Type("Invincible_Cruiser"), 1, "Space"}			
            ,{Find_Object_Type("Dreadnaught_Lasers"), 3, "Space"}
            ,{Find_Object_Type("Dreadnaught"), 3, "Space"}
            ,{Find_Object_Type("Marauder_Missile_Cruiser"), 2, "Space"}			
            ,{Find_Object_Type("Corellian_Gunboat"), 2, "Space"}			
            ,{Find_Object_Type("Corellian_Corvette"), 2, "Space"}
            ,{Find_Object_Type("IPV1_System_Patrol_Craft"), 2, "Space"}
            ,{Find_Object_Type("Komrk_Gunship_Squadron"), 1, "Space"}
            ,{Find_Object_Type("Gozanti_Cruiser_Squadron"), 2, "Space"}			
            ,{Find_Object_Type("Kaloth_Battlecruiser"), 3, "Space"}
            ,{Find_Object_Type("Kossak_Frigate"), 5, "Space"}		
            ,{Find_Object_Type("Barabbula_Frigate"), 5, "Space"}
            ,{Find_Object_Type("Juvard_Frigate"), 5, "Space"}			
            ,{Find_Object_Type("Heavy_Minstrel_Yacht"), 5, "Space"}
			,{Find_Object_Type("Light_Minstrel_Yacht"), 5, "Space"}
            ,{Find_Object_Type("Light_Mercenary_Team"), 5, "Land"}
            ,{Find_Object_Type("Mercenary_Team"), 4, "Land"}			
            ,{Find_Object_Type("Elite_Mercenary_Team"), 3, "Land"}	
            ,{Find_Object_Type("Republic_AT_PT_Company"), 2, "Land"}
            ,{Find_Object_Type("Hutt_Skiff_Group"), 4, "Land"}
            ,{Find_Object_Type("WLO5_Tank_Company"), 4, "Land"}
            ,{Find_Object_Type("Hutt_VAAT_Group"), 2, "Land"}		
        }		
    else
        Unit_Table = {
			{Find_Object_Type("Home_One_Type_Liner"), 0.2, "Space"}
			,{Find_Object_Type("Calamari_Cruiser_Liner"), 0.5, "Space"}
            ,{Find_Object_Type("Invincible_Cruiser"), 1, "Space"}
            ,{Find_Object_Type("Generic_Tagge_Battlecruiser"), 0.1, "Space"}
			,{Find_Object_Type("Generic_Praetor"), 0.2, "Space"}			
			,{Find_Object_Type("Space_ARC_Cruiser"), 1, "Space"}
			,{Find_Object_Type("Auxiliary_Lucrehulk"), 0.5, "Space"}			
            ,{Find_Object_Type("Dreadnaught_Lasers"), 4, "Space"}
			,{Find_Object_Type("Captor"), 4, "Space"}
			,{Find_Object_Type("Auxilia"), 4, "Space"}
			,{Find_Object_Type("Munifex"), 5, "Space"}
			,{Find_Object_Type("Lupus_Missile_Frigate"), 5, "Space"}
            ,{Find_Object_Type("Carrack_Cruiser_Lasers"), 5, "Space"}
            ,{Find_Object_Type("Galleon"), 3, "Space"}
			,{Find_Object_Type("Class_C_Frigate"), 3, "Space"}
			,{Find_Object_Type("Class_C_Support"), 3, "Space"}
            ,{Find_Object_Type("Dreadnaught_Carrier"), 1, "Space"}
            ,{Find_Object_Type("Light_Minstrel_Yacht"), 1, "Space"}
            ,{Find_Object_Type("Heavy_Minstrel_Yacht"), 1, "Space"}			
            ,{Find_Object_Type("Kaloth_Battlecruiser"), 2, "Space"}
            ,{Find_Object_Type("Corellian_Corvette"), 4, "Space"}
            ,{Find_Object_Type("Corellian_Gunboat"), 4, "Space"}
			,{Find_Object_Type("Customs_Corvette"), 5, "Space"}
            ,{Find_Object_Type("IPV1_System_Patrol_Craft"), 5, "Space"}
            ,{Find_Object_Type("Marauder_Missile_Cruiser"), 5, "Space"}
            ,{Find_Object_Type("Interceptor_Frigate"), 3, "Space"}
            ,{Find_Object_Type("Action_VI_Support"), 3, "Space"}
			,{Find_Object_Type("Super_Transport_VI"), 2, "Space"}
			,{Find_Object_Type("Super_Transport_VII"), 2, "Space"}
			,{Find_Object_Type("Super_Transport_XI"), 1, "Space"}		
			,{Find_Object_Type("Super_Transport_XI_Modified"), 1, "Space"}
			,{Find_Object_Type("Gozanti_Cruiser_Raider_Squadron"), 3, "Space"}			
            ,{Find_Object_Type("Gozanti_Cruiser_Squadron"), 4, "Space"}
            ,{Find_Object_Type("Citadel_Cruiser_Squadron"), 3, "Space"}
            ,{Find_Object_Type("Police_Responder_Team"), 2, "Land"}
            ,{Find_Object_Type("Security_Trooper_Team"), 2, "Land"}
            ,{Find_Object_Type("Military_Soldier_Team"), 3, "Land"}
            ,{Find_Object_Type("PDF_Soldier_Team"), 3, "Land"}
            ,{Find_Object_Type("Light_Mercenary_Team"), 3, "Land"} 
            ,{Find_Object_Type("Mercenary_Team"), 3, "Land"}    
            ,{Find_Object_Type("Elite_Mercenary_Team"), 3, "Land"}  
            ,{Find_Object_Type("Scavenger_Team"), 2, "Land"}
            ,{Find_Object_Type("Heavy_Scavenger_Team"), 1, "Land"}
			,{Find_Object_Type("B1_Droid_Squad"), 2, "Land"}
            ,{Find_Object_Type("SD_5_Hulk_Infantry_Droid_Company"), 1, "Land"}			
            ,{Find_Object_Type("Republic_AT_PT_Company"), 2, "Land"}
			,{Find_Object_Type("Espo_Walker_Early_Squad"), 2, "Land"}
			,{Find_Object_Type("Overracer_Speeder_Bike_Company"), 2, "Land"}
			,{Find_Object_Type("STAP_Squad"), 2, "Land"}
            ,{Find_Object_Type("Republic_SD_6_Droid_Company"), 2, "Land"}
            ,{Find_Object_Type("LR_57_Droid_Company"), 1, "Land"}
			,{Find_Object_Type("Destroyer_Droid_Company"), 2, "Land"}
			,{Find_Object_Type("Arrow_23_Company"), 2, "Land"}
            ,{Find_Object_Type("ULAV_Company"), 2, "Land"}
            ,{Find_Object_Type("AAT_Company"), 1, "Land"}
			,{Find_Object_Type("PDF_AAT_Company"), 1, "Land"}
            ,{Find_Object_Type("Riot_Hailfire_Company"), 1, "Land"}
            ,{Find_Object_Type("Riot_Persuader_Company"), 1, "Land"}
            ,{Find_Object_Type("MZ8_Tank_Company"), 1, "Land"}
            ,{Find_Object_Type("Republic_A5_Juggernaut_Company"), 1, "Land"}
			,{Find_Object_Type("Republic_A4_Juggernaut_Company"), 2, "Land"}
			,{Find_Object_Type("Hutt_Skiff_Group"), 2, "Land"}		
			,{Find_Object_Type("WLO5_Tank_Company"), 1, "Land"}			
			,{Find_Object_Type("Storm_Cloud_Car_Group"), 1, "Land"}
			,{Find_Object_Type("Skyhopper_Group"), 1, "Land"}
			,{Find_Object_Type("Skyhopper_Antivehicle_Group"), 1, "Land"}
			,{Find_Object_Type("Skyhopper_Primitive_Group"), 1, "Land"}
			,{Find_Object_Type("Skyhopper_Security_Group"), 1, "Land"}
			,{Find_Object_Type("Republic_Gaba18_Group"), 1, "Land"}
			,{Find_Object_Type("CA_Artillery_Company"), 1, "Land"}
			,{Find_Object_Type("VAAT_Group"), 1, "Land"}				
			,{Find_Object_Type("JX30_Group"), 1, "Land"}
        }
    end

	return Unit_Table
end

function DefineGroundBaseTable(faction)
    if faction == Find_Player("Empire") then
        Groundbase_Table = {
            Find_Object_Type("E_Ground_Barracks"),
            Find_Object_Type("E_Ground_Barracks"),
            Find_Object_Type("E_Ground_Light_Vehicle_Factory"),					
            Find_Object_Type("E_Ground_Heavy_Vehicle_Factory"),
			Find_Object_Type("E_Ground_Advanced_Vehicle_Factory"),					
        }
	elseif faction == Find_Player("Sector_Forces") then         
        Groundbase_Table = {
                Find_Object_Type("SF_Ground_Barracks"),
                Find_Object_Type("SF_Ground_Barracks"),
                Find_Object_Type("SF_Ground_Light_Vehicle_Factory"),
                Find_Object_Type("SF_Ground_Advanced_Vehicle_Factory"),
                }
	elseif faction == Find_Player("Hutt_Cartels") then         
        Groundbase_Table = {
                Find_Object_Type("Revolt_Light_Merc_Barracks"),
                Find_Object_Type("Revolt_Merc_Barracks"),
                Find_Object_Type("Revolt_Elite_Merc_Barracks"),
                Find_Object_Type("Revolt_UI_Light_Factory"),
                }				
    elseif faction == Find_Player("Rebel") or faction == Find_Player("Techno_Union") or faction == Find_Player("Commerce_Guild") or faction == Find_Player("Banking_Clan") or faction == Find_Player("Trade_Federation") then         
        Groundbase_Table = {
            Find_Object_Type("R_Ground_Barracks"),
            Find_Object_Type("R_Ground_Barracks"),
            Find_Object_Type("R_Ground_Light_Vehicle_Factory"),
            Find_Object_Type("R_Ground_Heavy_Vehicle_Factory"),
            }
    else
        Groundbase_Table = {
                Find_Object_Type("Revolt_Rural_PDF_Barracks"),
                Find_Object_Type("Revolt_Urban_PDF_Barracks"),
                Find_Object_Type("Revolt_Rural_Barracks"),
                Find_Object_Type("Revolt_Urban_Barracks"),
                Find_Object_Type("Revolt_Light_Merc_Barracks"),
                Find_Object_Type("Revolt_Merc_Barracks"),
                Find_Object_Type("Revolt_Elite_Merc_Barracks"),
                Find_Object_Type("Revolt_Precinct_House"),
                Find_Object_Type("Revolt_Scavenger_Outpost"),
                Find_Object_Type("Revolt_Underground_Market"),				
                Find_Object_Type("Revolt_Trade_Post"),	
                Find_Object_Type("Revolt_TDF_Deserter_Base"),
                Find_Object_Type("Revolt_Security_Droid_Factory"),	
                Find_Object_Type("Revolt_OldRep_Light_Factory"),
                Find_Object_Type("Revolt_Walker_Light_Factory"),	
                Find_Object_Type("Revolt_UI_Light_Factory"),
                Find_Object_Type("Revolt_AT_Light_Factory"),
                Find_Object_Type("Revolt_Illegal_Heavy_Factory"),	
                Find_Object_Type("Revolt_Chop_Shop"),
                Find_Object_Type("Revolt_OldRep_Advanced_Factory"),					
            }
    end

    return Groundbase_Table
end

function DefineStarBaseTable(faction)
	if faction == Find_Player("Empire") or faction == Find_Player("Sector_Forces") then
        Starbase_Table = {
                Find_Object_Type("Empire_Star_Base_1"),
                Find_Object_Type("Empire_Star_Base_2"),					
                Find_Object_Type("Empire_Star_Base_3"),
				Find_Object_Type("Empire_Star_Base_4"),									
				Find_Object_Type("Empire_Star_Base_5"),									
            }
    elseif faction == Find_Player("Rebel") or faction == Find_Player("Techno_Union") or faction == Find_Player("Commerce_Guild") or faction == Find_Player("Banking_Clan") or faction == Find_Player("Trade_Federation") then    
        Starbase_Table = {
                Find_Object_Type("NewRepublic_Star_Base_1"),
                Find_Object_Type("NewRepublic_Star_Base_2"),					
                Find_Object_Type("NewRepublic_Star_Base_3"),
				Find_Object_Type("NewRepublic_Star_Base_4"),									
				Find_Object_Type("NewRepublic_Star_Base_5"),
                }
    --elseif faction == Find_Player("Hutt_Cartels") then    
        --Starbase_Table = {
                --Find_Object_Type("Hutt_Pirate_Asteroid_Base"),
                --}				
    else
        Starbase_Table = {
                Find_Object_Type("Empire_Star_Base_1"),
                Find_Object_Type("Empire_Star_Base_2"),					
                Find_Object_Type("Empire_Star_Base_3"),
				Find_Object_Type("Empire_Star_Base_4"),									
				Find_Object_Type("Empire_Star_Base_5"),	
            }
    end

    return Starbase_Table
end

function DefineShipyardTable(faction)
	if faction == Find_Player("Empire") then

        Shipyard_Table = {
                Find_Object_Type("Republic_Shipyard_Level_One"),
                Find_Object_Type("Republic_Shipyard_Level_Two"),					
                Find_Object_Type("Republic_Shipyard_Level_Three"),
				Find_Object_Type("Republic_Shipyard_Level_Four"),																		
            }
    elseif faction == Find_Player("Rebel") or faction == Find_Player("Techno_Union") or faction == Find_Player("Commerce_Guild") or faction == Find_Player("Banking_Clan") or faction == Find_Player("Trade_Federation") then            
        Shipyard_Table = {
                Find_Object_Type("CIS_Shipyard_Level_One"),
                Find_Object_Type("CIS_Shipyard_Level_Two"),					
                Find_Object_Type("CIS_Shipyard_Level_Three"),
				Find_Object_Type("CIS_Shipyard_Level_Four"),																		
            }
    elseif faction == Find_Player("Sector_Forces") then            
        Shipyard_Table = {
                Find_Object_Type("SF_Shipyard_Level_One"),
                Find_Object_Type("SF_Shipyard_Level_Two"),					
                Find_Object_Type("SF_Shipyard_Level_Three"),
                Find_Object_Type("SF_Shipyard_Level_Four"),																		
            }
    else
        Shipyard_Table = {
                Find_Object_Type("Republic_Shipyard_Level_One"),
                Find_Object_Type("Republic_Shipyard_Level_Two"),					
                Find_Object_Type("Republic_Shipyard_Level_Three"),
                Find_Object_Type("Republic_Shipyard_Level_Four"),																		
            }
    end

    return Shipyard_Table
end

-- Always needs 5 levels
function DefineDefenseStarbaseTable(faction)
	if faction == Find_Player("Empire") or faction == Find_Player("Sector_Forces") then
        Defenses_Table = {
                nil,
                nil,
                nil,
				Find_Object_Type("Secondary_Haven"),				
                Find_Object_Type("Secondary_Golan_One"),
                Find_Object_Type("Secondary_Golan_Two")										
            }
    elseif faction == Find_Player("Rebel") or faction == Find_Player("Techno_Union") or faction == Find_Player("Commerce_Guild") or faction == Find_Player("Banking_Clan") or faction == Find_Player("Trade_Federation") then         
        Defenses_Table = {
                nil,
                nil,
                nil,
				Find_Object_Type("Secondary_TF_Outpost"),
                Find_Object_Type("Secondary_Golan_One"),
                Find_Object_Type("Secondary_Golan_Two")						
            }
	else         
        Defenses_Table = {
                nil,
                nil,
                nil,
				Find_Object_Type("Secondary_TF_Outpost"),
				Find_Object_Type("Secondary_Golan_One"),
                Find_Object_Type("Secondary_Golan_Two")					
            }
    end

    return Defenses_Table
end

function GetGovernmentBuilding(faction)
	if faction == Find_Player("Empire") or faction == Find_Player("Sector_Forces") then
        Government_Building = Find_Object_Type("Empire_MoffPalace")
    elseif faction == Find_Player("Rebel") or faction == Find_Player("Techno_Union") or faction == Find_Player("Commerce_Guild") or faction == Find_Player("Banking_Clan") or faction == Find_Player("Trade_Federation") then  
        Government_Building = Find_Object_Type("NewRep_SenatorsOffice")
    elseif faction == Find_Player("Warlords") or faction == Find_Player("Independent_Forces") then
		local government = GameRandom.Free_Random(1, 2)
        if government == 1 then
			Government_Building = Find_Object_Type("Revolt_PDF_HQ")
		elseif government == 2 then
			Government_Building = Find_Object_Type("Revolt_Scavenger_Base")
        end
    else
        Government_Building = nil
    end
	
	return Government_Building
end

function GetGTSBuilding(faction)
	if faction == Find_Player("Empire") or faction == Find_Player("Sector_Forces") then
        GTS_Building = Find_Object_Type("Ground_Hypervelocity_Gun")
    elseif faction == Find_Player("Rebel") or faction == Find_Player("Techno_Union") or faction == Find_Player("Commerce_Guild") or faction == Find_Player("Banking_Clan") or faction == Find_Player("Trade_Federation") then      
        GTS_Building = Find_Object_Type("Ground_Ion_Cannon")
    else
        GTS_Building = nil
    end
	
	return GTS_Building
end