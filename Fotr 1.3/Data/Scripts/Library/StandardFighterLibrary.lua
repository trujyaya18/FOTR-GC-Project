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
--*   @Author:              [TR]Jorritkarwehr
--*   @Date:                2021-03-20T01:27:01+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            StandardFighterLibrary.lua
--*   @Last modified by:    [TR]Jorritkarwehr
--*   @Last modified time:  2021-03-26T09:58:14+02:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************

require("SetFighterResearch")

function Get_Standard_Entry(fighterType, player, era, region, influence)
	local gameConstants = ModContentLoader.get("GameConstants")
    local alias = gameConstants.ALIASES[player]

	if fighterType == "STANDARD_VULTURE_SQUADRON" then
		if player == "REBEL" and era >= 2 then
			return "VULTURE_SQUADRON"
		else
			return "VULTURE_BROWN_SQUADRON"
		end
	elseif fighterType == "STANDARD_GARRISON_FIGHTER" then
		Universal_Regional_Table = {
			[1] = "TWIN_ION_ENGINE_STARFIGHTER_SQUADRON",
			[12] = "MANKVIM_SQUADRON",
		}
		if Universal_Regional_Table[region] then
			return Universal_Regional_Table[region]
		end
		if region == 2 then
			if era >= 4 and player == "EMPIRE" then
				return "V-WING_SQUADRON"
			else
				return "CLOAKSHAPE_SQUADRON"
			end
		elseif region == 4 then
			if era >= 3 and alias == "REPUBLIC" then
				return "REPUBLIC_Z95_HEADHUNTER_SQUADRON"
			else
				return "Z95_HEADHUNTER_SQUADRON"
			end
		elseif region == 13 then
			if alias == "REPUBLIC" then
				return "TORRENT_SQUADRON"
			end
		elseif region == 16 then
			if alias ~= "REPUBLIC" then
				return "NANTEX_SQUADRON"
			end
		elseif region == 17 then
			if alias ~= "REPUBLIC" then
				return "SCARAB_SQUADRON"
			end
		elseif region == 18 then
			if alias == "REPUBLIC" then
				return "N1_SQUADRON"
			end
		elseif region == 19 then
			if era >= 3 and alias ~= "REPUBLIC" then
				return "TRIFIGHTER_SQUADRON"
			end
		end
		--Default load if no regional pick was made
		if player == "REBEL" or player == "BANKING_CLAN" or player == "COMMERCE_GUILD" then
			return "NANTEX_SQUADRON"
		elseif player == "EMPIRE" then
			if era >= 4 and player == "EMPIRE" then
				return "TWIN_ION_ENGINE_STARFIGHTER_SQUADRON"
			else
				return "GENERIC_Z95_HEADHUNTER_SQUADRON"
			end
		elseif player == "TRADE_FEDERATION" or player == "TECHNO_UNION" then
			return "SCARAB_SQUADRON"
		else
			return "Z95_HEADHUNTER_SQUADRON"
		end
	elseif fighterType == "STANDARD_CIVILIAN_FIGHTER" then
		local civvies = {"Z95_HEADHUNTER_SQUADRON", "CLOAKSHAPE_SQUADRON", "CLOAKSHAPE_STOCK_SQUADRON", "DELTA6_SQUADRON", "VULTURE_BROWN_SQUADRON"}
		return civvies[GameRandom(1, table.getn(civvies))]
	elseif fighterType == "STANDARD_PIRATE_FIGHTER" then
		local civvies = {"MorningStar_B_Squadron", "MorningStar_A_Squadron", "AGGRESSOR_ASSAULT_FIGHTER_SQUADRON", "SABAOTH_FIGHTER_SQUADRON", "SABAOTH_DEFENDER_SQUADRON", "N1_SQUADRON"}
		return civvies[GameRandom(1, table.getn(civvies))]
	elseif fighterType == "STANDARD_CIVILIAN_BOMBER" then
		local civvies = {"MorningStar_C_Squadron", "2_WARPOD_SQUADRON", "H60_Tempest_SQUADRON", "GENERIC_Z95_BOMBER_SQUADRON"}
		return civvies[GameRandom(1, table.getn(civvies))]	
	end
	
	return fighterType
end