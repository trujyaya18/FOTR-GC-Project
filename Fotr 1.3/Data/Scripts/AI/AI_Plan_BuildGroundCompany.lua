require("pgevents")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	Category = "Build_Ground_Company"
	IgnoreTarget = true
	TaskForce = {
	{
		"StructureForce",
		--Core: Aratech_HQ | Balmorran_Arms_HQ | CEC_HQ | Cloning_HQ | Damorian_HQ | Hoersch_Kessel_HQ | Incom_HQ | KDY_HQ | Mekuun_HQ | Rendili_HQ | Sorosuub_HQ | Taim_Bak_HQ | TransGalMeg_HQ | Ubrikkian_HQ | 
		--FOTR Specific: Anaxes_War_College | Baktoid_HQ | Colicoid_HQ | Commerce_Guild_HQ | Free_Dac_HQ | Geonosian_HQ | Haor_Chall_HQ | Jedi_Temple | Rothana_HQ | Retail_Caucus_HQ | Rishi_Station | Tactical_Droid_Factory | Techno_Union_HQ 
		--TR Specific: ADC_HQ | Arakyd_HQ | Bothawui_HQ | Carida_Academy | Cygnus_HQ | Galentro_HQ | KDY_Branch | Koensayr_HQ | Loronar_HQ | MCS_HQ | Merkuni_HQ | NenCarvon_HQ | Olanji_Charubah_HQ | REC_HQ | Rossum_HQ | SecuriTech_HQ | SFS_HQ | Sienar_HQ | TaggeCo_HQ | Tarkin_Estates | Telgorn_HQ | Ulban_HQ | Uulshos_HQ | Yutrane_Trackata_HQ | zZip_HQ 
		"Aratech_HQ | Balmorran_Arms_HQ | CEC_HQ | Cloning_HQ | Damorian_HQ | Hoersch_Kessel_HQ | Incom_HQ | KDY_HQ | Mekuun_HQ | Rendili_HQ | Sorosuub_HQ | Taim_Bak_HQ | TransGalMeg_HQ | Ubrikkian_HQ | Anaxes_War_College | Baktoid_HQ | Colicoid_HQ | Commerce_Guild_HQ | Free_Dac_HQ | Geonosian_HQ | Haor_Chall_HQ | Jedi_Temple | Rothana_HQ | Retail_Caucus_HQ | Rishi_Station | Tactical_Droid_Factory | Techno_Union_HQ = 1"
	}
	}

	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function StructureForce_Thread()
	DebugMessage("%s -- In StructureForce_Thread.", tostring(Script))
	
	StructureForce.Set_As_Goal_System_Removable(false)
	AssembleForce(StructureForce)
	
	StructureForce.Set_Plan_Result(true)
	--Clean out MajorItem budget
	Budget.Flush_Category("MajorItem")
	DebugMessage("%s -- StructureForce done!", tostring(Script));
	ScriptExit()
end

function StructureForce_Production_Failed(tf, failed_object_type)
	DebugMessage("%s -- Abandonning plan owing to production failure.", tostring(Script))
	ScriptExit()
end