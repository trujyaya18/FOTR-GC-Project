require("PGStoryMode")
require("PGSpawnUnits")
require("PGBaseDefinitions")
require("deepcore/std/class")
require("deepcore/crossplot/crossplot")
StoryUtil = require("eawx-util/StoryUtil")

function StoryUtil.InsertDistribution(UnitTable, distribution)
    for k, PotentialUnit in pairs(UnitTable) do
        if PotentialUnit[1] ~= nil then
            distribution.Insert(PotentialUnit[1], PotentialUnit[2])
        end
    end
    return
end

function StoryUtil.SelectUnitObject(CombatPower, distribution, NoGamble, HardLimit)
	local MaxAmount = 5
    if NoGamble then
        if HardLimit == nil then
            HardLimit = 5
        end
        MaxAmount = GameRandom.Free_Random(1, HardLimit)
    end
    local SpawnUnit = distribution.Sample()
    if not SpawnUnit then
        return nil
    end
    local SpawnAmount = CombatPower / SpawnUnit.Get_Build_Cost()
    if SpawnAmount < 1 then
        SpawnAmount = 1
    end
    if SpawnAmount > MaxAmount then
        SpawnAmount = MaxAmount
    end
    return SpawnUnit, SpawnAmount
end

--mode_switch = 0: Reward ; mode_switch = 1: Build Option
function StoryUtil.SelectUnit(player, mode_switch, UnitTable, MinCombatPower)
	local MasterUnitTable = nil
	local UnitList = nil
	if type(player) == "string" then
		player = Find_Player(player)
	end
	if mode_switch == 1 then
		MasterUnitTable = require("eawx-plugins/intervention-missions/build-options/BuildOptionTables_"..player.Get_Faction_Name().."")
	end
	for k,LocalUnitTable in pairs(MasterUnitTable) do
		if LocalUnitTable.UnitListName == UnitTable then
			UnitList = LocalUnitTable.UnitOptions
		end
	end
	if table.getn(UnitList) > 0 then
		DistributionUnitTable = DiscreteDistribution.Create()
		StoryUtil.InsertDistribution(UnitList, DistributionUnitTable)

		if mode_switch == 0 then
			unit, unit_amount = StoryUtil.SelectUnitObject(MinCombatPower, DistributionUnitTable, false)
		elseif mode_switch == 1 then
			unit, unit_amount = StoryUtil.SelectUnitObject(MinCombatPower, DistributionUnitTable, true, 3)
		end
		return unit, unit_amount
	else
		return nil, 0, 0
	end
end

function StoryUtil.SelectReward(player, tag, tier)
	local UnitList = nil
	local era_tag = "Era_" .. tostring(GlobalValue.Get("CURRENT_ERA"))
	local RewardTable = {}
	local RandomEntry = 0
	if type(player) == "string" then
		player = Find_Player(player)
	end
	MasterUnitTable = require("eawx-plugins/intervention-missions/rewards/RewardTables_"..player.Get_Faction_Name())

	if tag == "ERA" then
		UnitList = MasterUnitTable[era_tag][tier]
	else
		UnitList = MasterUnitTable[tag][tier]
	end

	if table.getn(UnitList) > 0 then
		RandomEntry = GameRandom.Free_Random(1, table.getn(UnitList))
		RewardTable = UnitList[RandomEntry]
		return RewardTable[1], RewardTable[2]
	else
		return nil, 0, 0
	end
end

function StoryUtil.TravelConvoy(player, human_player, current_planet)
	if type(player) == "string" then
		player = Find_Player(player)
	end

	if type(human_player) == "string" then
		human_player = Find_Player(human_player)
	end

    local allPlanets = FindPlanet.Get_All_Planets()

    local random = 0
    local target_planet = nil
    local planet = nil

	while table.getn(allPlanets) > 0 do
		random = GameRandom.Free_Random(1, table.getn(allPlanets))
		target_planet = allPlanets[random]
		table.remove(allPlanets, random)

		if target_planet.Get_Owner() == player 
			and EvaluatePerception("Is_Connected_To_Me", human_player, target_planet) == 1
			and EvaluatePerception("Is_Important_Planet", player, target_planet) == 0 then
			if current_planet then
				convoy_path = Find_Path(player, current_planet, target_planet)
				if convoy_path then
					for _,planet in pairs(convoy_path) do
						if TestValid(planet) then
							if EvaluatePerception("Is_Owned_By_Ally", player, planet) then
								return target_planet
							else
								if table.getn(convoy_path) > 1 then
									target_planet = convoy_path[2]
									if target_planet.Get_Owner() == player then
										return target_planet
									else
										return nil
									end
								end
							end
						end
					end
				end
			end
		end
	end
end