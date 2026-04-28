--******************************************************************************
--     _______ __
--    |_     _|  |--.----.---.-.--.--.--.-----.-----.
--      |   | |     |   _|  _  |  |  |  |     |__ --|
--      |___| |__|__|__| |___._|________|__|__|_____|
--     ______
--    |   __ \.-----.--.--.-----.-----.-----.-----.
--    |      <|  -__|  |  |  -__|     |  _  |  -__|
--    |___|__||_____|\___/|_____|__|__|___  |_____|
--                                    |_____|
--*   @Author:              [TR]Pox
--*   @Date:                2018-03-20T01:27:01+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            Deconstruction.lua
--*   @Last modified by:    [TR]Pox
--*   @Last modified time:  2018-03-26T09:58:14+02:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************

require("MinorHeroSpawner")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))

    Define_State("State_Init", State_Init);
end


function State_Init(message)
    if message == OnEnter then
		space_V_list = {{"Commander_Providence_V", 2}, "Commander_Lucrehulk_V"}
		space_IV_list = {{"Commander_Recusant_IV", 2}, "Commander_Auxilia_IV", "Commander_Lucrehulk_Core_Destroyer_IV"}
		space_III_list = {"Commander_Munificent_III"}
		land_IV_list = {"OOM_Commander_IV_Company", {"Tactical_Droid_Commander_IV_Company", 2}, "Commander_Persuader_IV_Company", "Commander_AAT_IV_Company"}
		land_III_list  = {"OOM_Commander_III_Company", {"Tactical_Droid_Commander_III_Company", 2}, "Commander_Persuader_III_Company", "Commander_AAT_III_Company"}
		Register_Timer(CadetLoop, 0, {Object, true, space_V_list, space_IV_list, space_III_list, land_IV_list, land_III_list})
    end
end