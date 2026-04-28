require("eawx-util/UnitUtil")
require("PGStoryMode")
require("PGSpawnUnits")

return {
    on_enter = function(self, state_context)

        self.entry_time = GetCurrentTime()

        if self.entry_time <= 5 then

            UnitUtil.SetLockList("EMPIRE", {
                "Pelta_Assault",
                "Pelta_Support",
                "Arquitens",
                "Generic_Acclamator_Assault_Ship_I",
                "Generic_Acclamator_Assault_Ship_II",
                "Generic_Acclamator_Assault_Ship_Leveler",
                "Republic_74Z_Bike_Company",
                "Republic_AT_RT_Company",
                "Republic_AT_XT_Company",
                "Republic_TX130_Company",
                "Republic_AV7_Company",
                "Republic_LAAT_Group",
                "Republic_UT_AT_Speeder_Company",
                "Republic_AT_TE_Walker_Company",
                "Republic_A5_Juggernaut_Company",
                "Clone_Commando_Team",
                "Clonetrooper_Phase_One_Team",
                "ARC_Phase_One_Team",
				"Republic_74Z_Bike_Company",
                "Republic_BARC_Company",
                "Republic_ISP_Company",
                "Republic_Flashblind_Group",
                "Clonetrooper_Phase_Two_Team",
                "ARC_Phase_Two_Team",
                "Republic_HAET_Group",
                "Republic_AT_AP_Walker_Company",
                "Republic_AT_OT_Walker_Company"
            }, false)
			
			UnitUtil.SetLockList("EMPIRE", {
                "Republic_Overracer_Speeder_Bike_Company",
				"Republic_VAAT_Group",
				"Class_C_Frigate"
            })
			
            UnitUtil.SetLockList("REBEL", {
                "Recusant",
                "Generic_Providence",
                "Generic_Lucrehulk",
                "Battleship_Lucrehulk",
                "Subjugator",
				"Hardcell_Tender",
				"Lucrehulk_Core_Destroyer",
                "CIS_GAT_Group",
                "MAF_Group",
                "Magna_Company",
                "B2_Droid_Squad",
                "BX_Commando_Squad",
                "Crab_Droid_Company",
				"CA_Artillery_Company",
                "HMP_Group",
                "Destroyer_Droid_II_Company",
				"B1_Geo_Droid_Squad",
				"B1_RC_Droid_Squad"
            }, false)
			
			 UnitUtil.SetLockList("REBEL", {

            })

        end
  

    end,
    on_update = function(self, state_context)   
    end,
    on_exit = function(self, state_context)
    end
}