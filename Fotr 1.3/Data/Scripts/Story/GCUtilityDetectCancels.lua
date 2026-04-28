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
--*   @Author:              Jorritkarwehr
--*   @Date:                2017-10-01T19:08:32+02:00
--*   @Project:             Imperial Civil War
--*   @Filename:            GCDeltaSource.lua
--*   @Last modified by:    Jorritkarwehr
--*   @Last modified time:  2017-12-21T12:39:33+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************

require("PGBase")
require("PGStateMachine")
require("PGStoryMode")
require("deepcore/crossplot/crossplot")


function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))

    ServiceRate = 0.005

	crossplot:subscribe("UPDATED_AVAILABILITY", Enable_Buttons)

	StoryModeEvents = {Launch_Controller = Begin_GC,
	Click_Create_00 = Reset_Buttons,
	Click_Create_01 = Reset_Buttons,
	Click_Create_02 = Reset_Buttons,
	Click_Create_03 = Reset_Buttons,
	Click_Create_04 = Reset_Buttons,
	Click_Create_05 = Reset_Buttons,
	Click_Create_06 = Reset_Buttons,
	Click_Create_07 = Reset_Buttons,
	Click_Create_08 = Reset_Buttons,
	Click_Create_09 = Reset_Buttons,
	Click_Create_10 = Reset_Buttons,
	Click_Create_11 = Reset_Buttons,
	Click_Create_12 = Reset_Buttons,
	Click_Create_13 = Reset_Buttons,
	Click_Create_14 = Reset_Buttons,
	Click_Create_15 = Reset_Buttons,
	Click_Create_16 = Reset_Buttons,
	Click_Create_17 = Reset_Buttons,
	Click_Create_18 = Reset_Buttons,
	Click_Create_19 = Reset_Buttons,
	Click_Create_20 = Reset_Buttons,
	Click_Create_21 = Reset_Buttons,
	Click_Create_22 = Reset_Buttons,
	Click_Create_23 = Reset_Buttons,
	Click_Create_24 = Reset_Buttons,
	Click_Create_25 = Reset_Buttons,
	Click_Create_26 = Reset_Buttons,
	Click_Create_27 = Reset_Buttons,
	Click_Create_28 = Reset_Buttons,
	Click_Create_29 = Reset_Buttons,
	Click_Create_30 = Reset_Buttons
	}
end

function Begin_GC(message)
  if message == OnEnter then

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_hutts = Find_Player("Hutt_Cartels")
	p_early_imperial = Find_Player("Early_Imperial")
	p_trade_federation = Find_Player("Trade_Federation")
	p_techno_union = Find_Player("Techno_Union")
	p_banking_clan = Find_Player("Banking_Clan")
	p_commerce_guild = Find_Player("Commerce_Guild")
	p_sector_forces = Find_Player("Sector_Forces")



	if p_cis.Is_Human() then
		player = p_cis
	elseif p_republic.Is_Human() then
		player = p_republic
	elseif p_hutts.Is_Human() then
		player = p_hutts
	elseif p_trade_federation.Is_Human() then
		player = p_trade_federation
	elseif p_techno_union.Is_Human() then
		player = p_techno_union
	elseif p_banking_clan.Is_Human() then
		player = p_banking_clan
	elseif p_commerce_guild.Is_Human() then
		player = p_commerce_guild
	elseif p_sector_forces.Is_Human() then
		player = p_sector_forces
	elseif p_early_imperial.Is_Human() then
		player = p_early_imperial
	end

	credits = player.Get_Credits()
	updated = false

  elseif message == OnUpdate then
	crossplot:update()

	oldCredits = credits
	credits = player.Get_Credits()

	if oldCredits ~= credits then
		Story_Event("CANCELED_OBJECT")
		crossplot:publish("UPDATE_AVAILABILITY", "empty")
	end

  end
end

function Enable_Buttons()
	Story_Event("RESTORE_BUTTONS")
end

function Reset_Buttons(message)
	Story_Event("CANCELED_OBJECT")
	Story_Event("RESTORE_BUTTONS")
	Begin_GC(message)
end
