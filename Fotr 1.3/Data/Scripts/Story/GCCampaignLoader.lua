require("PGBase")
require("PGStateMachine")
require("PGStoryMode")

function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))

	StoryModeEvents = { Universal_Story_Start = Set_Tech }
end

function Set_Tech(message)
  if message == OnEnter then

    --Match the order of the index in factions.xml
	liveFactionTable = {
      ["REBEL"] = 0,
      ["EMPIRE"] = 1,
      --"HUTT_CARTELS" 2,
      --"NEUTRAL" 3,
      --"HOSTILE" 4,
      ["EMPIREOFTHEHAND"] = 5,
      --"UNDERWORLD" 6,
      ["TRADE_FEDERATION"] = 7,
      ["TECHNO_UNION"] = 8,
      --"CHISS" 9,
      --"CORELLIA" 10,
      ["SSIRUUVI_IMPERIUM"] = 11, 
      ["HAPES_CONSORTIUM"] = 12,
      ["SECTOR_FORCES"] =13,
      ["BANKING_CLAN"] = 14,
      ["COMMERCE_GUILD"] = 15,
      --"WARLORDS"
    }

    local faction_index = 0
    local era = 2
    local faction_name = "REBEL"
    for faction, id in pairs(liveFactionTable) do
      if Find_Player(faction).Is_Human() then
              faction_index = id
              faction_name = faction
        era = Find_Player(faction).Get_Tech_Level()
        break
      end
    end
	
	if faction_name == "REBEL" then
		era = era + 1
	end

    if era <= 1 then
		era = 2
    end

  	if era == 4 then
		era = 5
	end
 

    plot = Get_Story_Plot("Conquests\\Progressive\\GCLoader.xml")

    local all_planets = FindPlanet.Get_All_Planets()

    for _, planet in ipairs(all_planets) do
        planet_name = planet.Get_Type().Get_Name()
    end

 
        loadEvent = plot.Get_Event("Load_Another_GC")

        local name = planet_name.."_Era_"..tostring(era).."_"..faction_name

        loadEvent.Set_Reward_Parameter(0, name)
        loadEvent.Set_Reward_Parameter(1, faction_index)

	
    Story_Event("LOAD_CAMPAIGN_EVENT")

  elseif message == OnUpdate then
	ScriptExit()
  end
end