require("PGSpawnUnits")
require("eawx-util/PopulatePlanetUtilities")
StoryUtil = require("eawx-util/StoryUtil")
CONSTANTS = ModContentLoader.get("GameConstants")

---@class RandomSpawnManager
require("deepcore/std/class")

RandomSpawnManager = class()

function RandomSpawnManager:new(gc, generated)

    -- table to store infrastructure score per faction
    local infrastructure_table = {}
	local income_table = {}

    for _, faction in pairs(CONSTANTS.PLAYABLE_FACTIONS) do
      local faction_object = Find_Player(faction) 
      local planets_by_faction = gc.Planets_By_Faction[faction]
      local starting_infrastructure = 0
      
      if planets_by_faction then
	local income = EvaluatePerception("Current_Income", faction_object)
	income_table[faction_object] = income
			
        for _, planet in pairs(planets_by_faction) do
          starting_infrastructure = starting_infrastructure + EvaluatePerception("Infrastructure_Score", faction_object, planet:get_game_object())
        end
        
        DebugMessage("%s -- Starting infrastructure for %s is %s", tostring(Script), tostring(faction), tostring(starting_infrastructure))
        
        infrastructure_table[faction_object] = starting_infrastructure
      else
        infrastructure_table[faction_object] = 0
      end
    end

    self.isRev = Find_Object_Type("rev")
    self.is_generated = generated

    self.Active_Planets = StoryUtil.GetSafePlanetTable()
    self.starting_force_dummies = Find_All_Objects_Of_Type("Generate_Force")
    self.starting_power = 1000
    if self.isRev then
      self.starting_power = 350
    end
	
	-- spawn capital if it doesn't exist
	if self.is_generated then
      for faction_name, capital_table in pairs(CONSTANTS.ALL_FACTIONS_CAPITALS) do
        if EvaluatePerception("Planet_Ownership", Find_Player(faction_name)) > 0 then
          if capital_table.STRUCTURE and not Find_First_Object(capital_table.STRUCTURE) then
            StoryUtil.SpawnAtSafePlanet(capital_table.LOCATION, Find_Player(faction_name), self.Active_Planets, {capital_table.STRUCTURE})
          end
        end
      end
    end
	
    for _, dummy in pairs(self.starting_force_dummies) do
      if dummy.Get_Planet_Location() then
        local owner = dummy.Get_Owner()
        DebugMessage("%s -- dummy owner is %s", tostring(Script), tostring(owner.Get_Name()))
        
        if not infrastructure_table[owner] then
          ChangePlanetOwnerAndPopulate(dummy.Get_Planet_Location(), owner, self.starting_power)
        else
          local infrastructure = 0
		  local planet = dummy.Get_Planet_Location()
		  local limit_spawns = infrastructure_table[owner] > 0 
          
          -- spawn extra stuff if the infrastructure score for the faction is less than 50
          infrastructure = ChangePlanetOwnerAndPopulate(planet, owner, self.starting_power, false, limit_spawns)
		  
		  local planet_income = EvaluatePerception("PlanetBaseIncome", owner, planet)
		  local has_groundbase = EvaluatePerception("MaxGroundbaseLevel", owner, planet) > 0

		  -- if planet's income is greater than 150cr and its owner is poor, give it a tax agency
		  if planet_income > 150 and income_table[owner] < 4000 and has_groundbase then
			  Spawn_Unit(Find_Object_Type("Tax_Agency"), planet, owner)
			  infrastructure = infrastructure + 1
		  end
		  
          infrastructure_table[owner] = infrastructure_table[owner] + infrastructure
          
          DebugMessage("%s -- Added infrastructure of value %s for %s, total now %s", tostring(Script), tostring(infrastructure), tostring(owner), tostring(infrastructure_table[owner]))
        end
      end
      dummy.Despawn()
    end
end
