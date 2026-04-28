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
		local land_IV_list
		local land_III_list
		if Object.Get_Planet_Location() == FindPlanet("Kamino") and Find_Player("Empire").Get_Tech_Level() > 1 then
			land_IV_list = {{"Commander_Clone_P1_IV_Company", "Clone_Phase_Two_Lt_Spawner", false}, {"Commander_Clone_P2_IV_Company", "Clone_Phase_Two_Lt_Spawner"}}
			land_III_list  = {{"Commander_Clone_P1_III_Company", "Clone_Phase_Two_Lt_Spawner", false}, {"Commander_Clone_P2_III_Company", "Clone_Phase_Two_Lt_Spawner"}}
		else
			land_IV_list = {"Commander_Army_IV_Company", "Commander_TX130_IV_Company", "Commander_AT_TE_IV_Company"}
			land_III_list  = {"Commander_Army_III_Company", "Commander_TX130_III_Company", "Commander_AT_TE_III_Company"}
		end
		Register_Timer(CadetLoop, 0, {Object, true, {}, {}, {}, land_IV_list, land_III_list})
    end
end