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
--*   @Date:                2017-11-24T12:43:51+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            InvadingFleet.lua
--*   @Last modified by:    svenmarcus
--*   @Last modified time:  2018-03-30T03:07:16+02:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************

require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")
require("eawx-util/StoryUtil")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))

    StoryModeEvents = {
        Battle_Start = State_Init
    }
end

function State_Init(message)
    if message == OnEnter then
		scripted_battle_marker = Find_First_Object("SCRIPTED_BATTLE_MARKER")
		if TestValid(scripted_battle_marker) then
			ScriptExit()
		end

		local p_defender = StoryUtil.Find_Defending_Player(true)
        if Find_Player("Empire").Is_Human() then
			if p_defender == Find_Player("Sector_Forces") then
				StoryUtil.ShowScreenText("TEXT_CONQUEST_EVENT_REPUBLIC_ATTACK_SECTOR", 120)
				currentSupport = GlobalValue.Get("RepublicApprovalRating")
				GlobalValue.Set("RepublicApprovalRating", currentSupport - 5)
			end
        elseif Find_Player("Rebel").Is_Human() then
			if p_defender == Find_Player("Techno_Union") then
				StoryUtil.ShowScreenText("TEXT_CONQUEST_EVENT_CIS_ATTACK_TECHNO", 120)

				currentSupport = GlobalValue.Get("TechnoApprovalRating")
				GlobalValue.Set("TechnoApprovalRating", currentSupport - 5)
			elseif p_defender == Find_Player("Banking_Clan") then
				StoryUtil.ShowScreenText("TEXT_CONQUEST_EVENT_CIS_ATTACK_IGBC", 120)

				currentSupport = GlobalValue.Get("IGBCApprovalRating")
				GlobalValue.Set("IGBCApprovalRating", currentSupport - 5)
			elseif p_defender == Find_Player("Trade_Federation") then
				StoryUtil.ShowScreenText("TEXT_CONQUEST_EVENT_CIS_ATTACK_TRADEFED", 120)

				currentSupport = GlobalValue.Get("TradeFedApprovalRating")
				GlobalValue.Set("TradeFedApprovalRating", currentSupport - 5)
			elseif p_defender == Find_Player("Commerce_Guild") then
				StoryUtil.ShowScreenText("TEXT_CONQUEST_EVENT_CIS_ATTACK_COMMERCE", 120)

				currentSupport = GlobalValue.Get("CommerceApprovalRating")
				GlobalValue.Set("CommerceApprovalRating", currentSupport - 5)
			end
        end
    end
end