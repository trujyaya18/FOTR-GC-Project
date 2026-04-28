local BuildOptionLists = {
	{ --Ground Structures
		UnitListName = "Ground_Structure_List",
		UnitOptions = {
			{Find_Object_Type("R_Ground_Barracks"), 0.2},
			{Find_Object_Type("R_Ground_Light_Vehicle_Factory"), 0.2},
			{Find_Object_Type("R_Ground_Heavy_Vehicle_Factory"), 0.2},
			{Find_Object_Type("R_Planetary_Shield"), 0.1},
			{Find_Object_Type("R_Galactic_Turbolaser_Tower_Defenses"), 0.2},
			{Find_Object_Type("Ground_Ion_Cannon"), 0.1},
		},
	},
	{ --Ground Structures
		UnitListName = "Ground_Structure_List_Short",
		UnitOptions = {
			{Find_Object_Type("R_Ground_Barracks"), 0.3},
			{Find_Object_Type("R_Ground_Light_Vehicle_Factory"), 0.3},
			{Find_Object_Type("R_Ground_Heavy_Vehicle_Factory"), 0.2},
			{Find_Object_Type("NewRep_SenatorsOffice"), 0.2},
		},
	},
	{ --Space Structures
		UnitListName = "Space_Station_List",
		UnitOptions = {
			{Find_Object_Type("CIS_Shipyard_Level_One"), 0.30},
			{Find_Object_Type("CIS_Shipyard_Level_Two"), 0.20},
			{Find_Object_Type("NewRepublic_Star_Base_1"), 0.30},
			{Find_Object_Type("NewRepublic_Star_Base_2"), 0.20},
		},
	},
}
return BuildOptionLists