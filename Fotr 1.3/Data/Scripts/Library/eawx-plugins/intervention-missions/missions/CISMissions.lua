require("deepcore/std/class")
require("PGStoryMode")
require("PGSpawnUnits")
StoryUtil = require("eawx-util/StoryUtil")
require("MissionFunctions")

---@class CISMissions
CISMissions = class()

function CISMissions:new(gc)
	self.cis = Find_Player("Rebel")
	self.republic = Find_Player("Empire")
	self.potential_targets = {}

	self.CurrentTime = 0
	self.ActiveMissions = 0
	self.TimeSinceAssigned = 0

	self.FactionMasterTable = {
		"COMMERCE_GUILD",
		"BANKING_CLAN",
		"TRADE_FEDERATION",
		"TECHNO_UNION",
		"CIS",
		"PDF"
	}

	self.FactionDetailTable = {
		["COMMERCE_GUILD"] = {
			DialogName = "CIS_CG",
			RewardName = "COMMERCE_GUILD",
		},
		["BANKING_CLAN"] = {
			DialogName = "CIS_IGBC",
			RewardName = "IGBC",
		},
		["TRADE_FEDERATION"] = {
			DialogName = "CIS_TF",
			RewardName = "TRADE_FEDERATION",
		},
		["TECHNO_UNION"] = {
			DialogName = "CIS_TU",
			RewardName = "TECHNO_UNION",
		},
		["CIS"] = {
			DialogName = "CIS",
			RewardName = "CIS",
		},
		["PDF"] = {
			DialogName = "PDF",
			RewardName = "PDF",
		}
	}

	self.AccumulateActive = false
	self.FactionGambleAccumulate = nil
	self.AccumulateDialog = nil
	self.AccumulateTimerStart = nil
	self.AccumulateTimer = nil
	self.AccumulateTimerEnd = nil
	self.AccumulateReward = nil
	self.AccumulateRewardCount = 0
	self.TargetBalance = nil

	self.CISConquerPlanetActive = false
	self.FactionGambleConquer = nil
	self.ConquerDialog = nil
	self.ConquerTimerStart = nil
	self.ConquerTimer = nil
	self.ConquerTimerEnd = nil
	self.ConquerReward = nil
	self.ConquerRewardCount = 0
	self.ConquerTarget = nil

	self.CISConstructStructureActive = false
	self.FactionGambleConstruct = nil
	self.ConstructDialog = nil
	self.ConstructCountCurrent = 0
	self.ConstructCountTarget = nil
	self.ConstructTimerStart = nil
	self.ConstructTimer = nil
	self.ConstructTimerEnd = nil
	self.ConstructReward = nil
	self.ConstructRewardCount = nil
	self.Construct = nil

	self.CISUpgradeStructureActive = false
	self.FactionGambleUpgrade = nil
	self.UpgradeDialog = nil
	self.UpgradeCountCurrent = 0
	self.UpgradeCountTarget = nil
	self.UpgradeTimerStart = nil
	self.UpgradeTimer = nil
	self.UpgradeTimerEnd = nil
	self.UpgradeReward = nil
	self.UpgradeRewardCount = nil
	self.Upgrade = nil

	self.CISReconPlanetActive = false
	self.FactionGambleRecon = nil
	self.ReconDialog = nil
	self.ReconTimerStart = nil
	self.ReconTimer = nil
	self.ReconTimerEnd = nil
	self.ReconTarget01 = nil
	self.ReconTarget02 = nil
	self.Recon01Complete = false
	self.Recon02Complete = false
	self.ReconReward = nil
	self.ReconRewardCount = nil
	self.ValidReconTarget02 = true

	self.CISConvoyActive = false
	self.FactionGambleConvoy = nil
	self.ConvoyDialog = nil
	self.ConvoyTimerStart = nil
	self.ConvoyTimer = nil
	self.ConvoyTimerEnd = nil
	self.ConvoyReward = nil
	self.ConvoyRewardCount = nil
	self.ConvoyUnit = nil
	self.ConvoyCountCurrent = nil
	self.ConvoyLocationCurrent = nil
	self.ConvoyFleet = nil

	self.CISLiberatePlanetActive = false
	self.FactionGambleLiberate = nil
	self.LiberateDialog = nil
	self.LiberateTimerStart = nil
	self.LiberateTimer = nil
	self.LiberateTimerEnd = nil
	self.LiberateReward = nil
	self.LiberateRewardCount = 0
	self.LiberateTarget = nil

	self.CISUnitHuntActive = false
	self.FactionGambleUnitHunt = nil
	self.UnitHuntDialog = nil
	self.UnitHuntTimerStart = nil
	self.UnitHuntTimer = nil
	self.UnitHuntTimerEnd = nil
	self.UnitHuntReward = nil
	self.UnitHuntRewardCount = nil
	self.UnitHuntUnit = nil
	self.UnitHuntCountCurrent = nil
	self.UnitHuntCountTarget = nil
	self.UnitHuntLocationCurrent = nil

	self.production_finished_event = gc.Events.GalacticProductionFinished
	self.production_finished_event:attach_listener(self.on_construction_finished, self)

	self.planet_owner_changed_event = gc.Events.PlanetOwnerChanged
	self.planet_owner_changed_event:attach_listener(self.on_planet_conquered, self)

    self.galactic_hero_killed_event = gc.Events.GalacticHeroKilled
    self.galactic_hero_killed_event:attach_listener(self.on_galactic_hero_killed, self)
end

function CISMissions:update()
	--Logger:trace("entering CISMissions:Update")
	self.TimeSinceAssigned = self.TimeSinceAssigned + 1
	self.CurrentTime = self.CurrentTime + 1
	local RewardGamble = 0

	if self.TimeSinceAssigned >= 4 then
		if self.ActiveMissions <= 3 and EvaluatePerception("Planet_Ownership", self.republic) >= 4 then
			RewardGamble = GameRandom.Free_Random(1, 91)
			if RewardGamble >= 1 and RewardGamble < 10 then
				self:BeginAccumulate()
			elseif RewardGamble >= 10 and RewardGamble < 30 then
				self:BeginConstruct()
			elseif RewardGamble >= 30 and RewardGamble < 45 then
				self:BeginUpgrade()
			elseif RewardGamble >= 45 and RewardGamble < 65 then
				self:BeginRecon()
			elseif RewardGamble >= 65 and RewardGamble < 75 then
				self:BeginConvoy()
			elseif RewardGamble >= 75 and RewardGamble < 85 then
				self:BeginLiberate()
			elseif RewardGamble >= 85 and RewardGamble < 92 then
				self:BeginConquer()
			elseif RewardGamble >= 92 and RewardGamble <= 100 then
				self:BeginUnitHunt()
			end
		end
	end

	if self.AccumulateActive == true then
		if self.cis.Get_Credits() >= self.TargetBalance then
			self:FulfilAccumulate()
		end
		if self.AccumulateTimer ~= nil then
			self.AccumulateTimer = self.AccumulateTimer - 1
			if self.AccumulateTimer == 0 then
				self:FailedAccumulate()
			end
		end
	end
	if self.CISConquerPlanetActive == true then
		if self.ConquerTimer ~= nil and self.ConquerTarget ~= nil then
			self.ConquerTimer = self.ConquerTimer - 1
			if self.ConquerTimer == 0 then
				self:FailedConquer()
			end
		end
	end
	if self.CISConstructStructureActive == true then
		if self.ConstructTimer ~= nil and self.Construct ~= nil then
			self.ConstructTimer = self.ConstructTimer - 1
			if self.ConstructTimer == 0 then
				self:FailedConstruct()
			end
		end
	end
	if self.CISUpgradeStructureActive == true then
		if self.UpgradeTimer ~= nil and self.Upgrade ~= nil then
			self.UpgradeTimer = self.UpgradeTimer - 1
			if self.UpgradeTimer == 0 then
				self:FailedUpgrade()
			end
		end
	end
	if self.CISReconPlanetActive == true then
		if Check_Story_Flag(Find_Player("Rebel"), "RECON_I_FULFILLED", nil, true) then
			self.Recon01Complete = true
		end
		if Check_Story_Flag(Find_Player("Rebel"), "RECON_II_FULFILLED", nil, true) then
			self.Recon02Complete = true
		end
		self:FulfilRecon()
		if self.ReconTimer ~= nil then
			self.ReconTimer = self.ReconTimer - 1
			if self.ReconTimer == 0 then
				self:FailedRecon()
			end
		end
	end
	if self.CISConvoyActive == true then
		self:LoopConvoy()
		if self.ConvoyTimer ~= nil then
			self.ConvoyTimer = self.ConvoyTimer - 1
			if self.ConvoyTimer == 0 then
				self:FailedConvoy()
			end
		end
	end
	if self.CISLiberatePlanetActive == true then
		if self.LiberateTimer ~= nil and self.LiberateTarget ~= nil then
			self.LiberateTimer = self.LiberateTimer - 1
			if self.LiberateTimer == 0 then
				self:FailedLiberate()
			end
		end
	end
	if self.CISUnitHuntActive == true then
		if Check_Story_Flag(Find_Player("Rebel"), "HUNT_UNIT_STATION_FULFILLED", nil, true) then
			self:FulfilUnitHunt()
		end
		if self.UnitHuntTimer ~= nil then
			self.UnitHuntTimer = self.UnitHuntTimer - 1
			if self.UnitHuntTimer == 0 then
				self:FailedUnitHunt()
			end
		end
	end
end

function CISMissions:BeginAccumulate()
	--Logger:trace("entering CISMissions:BeginAccumulate")
	if self.AccumulateActive == true or self.cis.Get_Credits() >= 15000 then
		return
	end

	self.TimeSinceAssigned = 0

	local FactionIndex = GameRandom.Free_Random(1, table.getn(self.FactionMasterTable))
	self.FactionGambleAccumulate = self.FactionMasterTable[FactionIndex]

	self.AccumulateDialog = "DIALOG_INTERVENTION_MASTERFILE_"..self.FactionDetailTable[self.FactionGambleAccumulate].DialogName..""

	self.TargetBalance = GameRandom.Free_Random(14000, 25000)

	self.AccumulateActive = true
	self.ActiveMissions = self.ActiveMissions + 1

	self.AccumulateTimerStart = self.CurrentTime
	self.AccumulateTimer = GameRandom.Free_Random(5, 10)
	self.AccumulateTimerEnd = self.AccumulateTimerStart + self.AccumulateTimer
	self.AccumulateTimer = self.AccumulateTimer + 1

	self.AccumulateReward, self.AccumulateRewardCount = StoryUtil.SelectReward(self.cis, ""..self.FactionDetailTable[self.FactionGambleAccumulate].RewardName, 1)

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
	local event = plot.Get_Event("Accumulate_Credits_01")
	event.Set_Dialog(self.AccumulateDialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_ACCUMULATE_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_ACCUMULATE_TARGET", self.TargetBalance)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD")
	event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", Find_Object_Type(self.AccumulateReward))
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.AccumulateRewardCount)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.AccumulateTimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.AccumulateTimerEnd)

	Story_Event("ACCUMULATE_ASSIGN")
end

function CISMissions:FulfilAccumulate()
	--Logger:trace("entering CISMissions:FulfilAccumulate")
	local RewardLocation = StoryUtil.FindFriendlyPlanet(self.cis)

	for i=1,self.AccumulateRewardCount do
		SpawnList({self.AccumulateReward}, RewardLocation, self.cis, true, false)
	end

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
	local event = plot.Get_Event("Accumulate_Credits_02")
	event.Set_Dialog(self.AccumulateDialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_ACCUMULATE_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_ACCUMULATE_TARGET_COMPLETE", self.TargetBalance)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD")
	event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", Find_Object_Type(self.AccumulateReward))
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.AccumulateRewardCount)
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", RewardLocation)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.AccumulateTimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.AccumulateTimerEnd)

	if self.FactionGambleAccumulate ~= "PDF" and self.FactionGambleAccumulate ~= "CIS" then
		crossplot:publish("CIS_SUPPORT", self.FactionGambleAccumulate)
	end

	self.AccumulateActive = false
	self.FactionGambleAccumulate = nil
	self.AccumulateDialog = nil
	self.AccumulateTimerStart = nil
	self.AccumulateTimer = nil
	self.AccumulateTimerEnd = nil
	self.AccumulateReward = nil
	self.AccumulateRewardCount = 0
	self.TargetBalance = nil

	RewardCost = 0
	RewardCostFull = 0
	RewardLocation = nil

	self.ActiveMissions = self.ActiveMissions - 1

	Story_Event("ACCUMULATE_COMPLETE")
end

function CISMissions:FailedAccumulate()
	--Logger:trace("entering CISMissions:FailedAccumulate")

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
	local event = plot.Get_Event("Accumulate_Credits_04")
	event.Set_Dialog(self.AccumulateDialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_ACCUMULATE_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_ACCUMULATE_TARGET_FAILED", self.TargetBalance)
	event.Add_Dialog_Text("TEXT_INTERVENTION_ACCUMULATE_TARGET_CURRENT", self.cis.Get_Credits())
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.AccumulateTimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.AccumulateTimerEnd)

	if self.FactionGambleAccumulate ~= "PDF" and self.FactionGambleAccumulate ~= "CIS" then
		crossplot:publish("CIS_REDUCE_SUPPORT", self.FactionGambleAccumulate)
	end

	self.AccumulateActive = false
	self.FactionGambleAccumulate = nil
	self.AccumulateDialog = nil
	self.AccumulateTimerStart = nil
	self.AccumulateTimer = nil
	self.AccumulateTimerEnd = nil
	self.AccumulateReward = nil
	self.AccumulateRewardCount = 0
	self.TargetBalance = nil

	self.ActiveMissions = self.ActiveMissions - 1

	Story_Event("ACCUMULATE_FAILED")
end

function CISMissions:BeginConquer()
	--Logger:trace("entering CISMissions:BeginConquer")
	if self.CISConquerPlanetActive == true then
		return
	end

	self.TimeSinceAssigned = 0

	local FactionIndex = GameRandom.Free_Random(1, table.getn(self.FactionMasterTable))
	self.FactionGambleConquer = self.FactionMasterTable[FactionIndex]

	self.ConquerDialog = "DIALOG_INTERVENTION_MASTERFILE_"..self.FactionDetailTable[self.FactionGambleConquer].DialogName..""

	self.CISConquerPlanetActive = true
	self.ActiveMissions = self.ActiveMissions + 1

	self.ConquerTimerStart = self.CurrentTime
	self.ConquerTimer = GameRandom.Free_Random(5, 15)
	self.ConquerTimerEnd = self.ConquerTimerStart + self.ConquerTimer
	self.ConquerTimer = self.ConquerTimer + 1

	self.ConquerTarget = StoryUtil.FindTargetPlanet(self.cis, true, false, 1)
	if self.ConquerTarget == nil then
		return
	end

	self.ConquerReward, self.ConquerRewardCount = StoryUtil.SelectReward(self.cis, ""..self.FactionDetailTable[self.FactionGambleConquer].RewardName, 3)

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
	local event = plot.Get_Event("Conquer_Planet_01")
	event.Set_Dialog(self.ConquerDialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", self.ConquerTarget)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD")
	event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", Find_Object_Type(self.ConquerReward))
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.ConquerRewardCount)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.ConquerTimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.ConquerTimerEnd)

	local event = plot.Get_Event("Conquer_Planet_Flash")
	event.Set_Reward_Parameter(0, self.ConquerTarget)

	Story_Event("CONQUER_ASSIGN")
end

function CISMissions:FulfilConquer()
	--Logger:trace("entering CISMissions:FulfilConquer")
	for i=1,self.ConquerRewardCount do
		SpawnList({self.ConquerReward}, self.ConquerTarget, self.cis, true, false)
	end

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
	local event = plot.Get_Event("Conquer_Planet_02")
	event.Set_Dialog(self.ConquerDialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", self.ConquerTarget)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD")
	event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", Find_Object_Type(self.ConquerReward))
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.ConquerRewardCount)
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", self.ConquerTarget)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.ConquerTimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.ConquerTimerEnd)

	if self.FactionGambleConquer ~= "PDF" and self.FactionGambleConquer ~= "CIS" then
		crossplot:publish("CIS_SUPPORT", self.FactionGambleConquer)
	end

	self.CISConquerPlanetActive = false
	self.FactionGambleConquer = nil
	self.ConquerDialog = nil
	self.ConquerTimerStart = nil
	self.ConquerTimer = nil
	self.ConquerTimerEnd = nil
	self.ConquerReward = nil
	self.ConquerRewardCount = 0
	self.ConquerTarget = nil

	self.ActiveMissions = self.ActiveMissions - 1

	Story_Event("CONQUER_COMPLETE")
end

function CISMissions:FailedConquer()
	--Logger:trace("entering CISMissions:FailedConquer")

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
	local event = plot.Get_Event("Conquer_Planet_04")
	event.Set_Dialog(self.ConquerDialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_FAILED", self.ConquerTarget)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.ConquerTimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.ConquerTimerEnd)

	if self.FactionGambleConquer ~= "PDF" and self.FactionGambleConquer ~= "CIS" then
		crossplot:publish("CIS_REDUCE_SUPPORT", self.FactionGambleConquer)
	end

	self.CISConquerPlanetActive = false
	self.FactionGambleConquer = nil
	self.ConquerDialog = nil
	self.ConquerTimerStart = nil
	self.ConquerTimer = nil
	self.ConquerTimerEnd = nil
	self.ConquerReward = nil
	self.ConquerRewardCount = 0
	self.ConquerTarget = nil

	self.ActiveMissions = self.ActiveMissions - 1

	Story_Event("CONQUER_FAILED")
end

function CISMissions:BeginConstruct()
	--Logger:trace("entering CISMissions:BeginConstruct")
	if self.CISConstructStructureActive == true then
		return
	end

	self.TimeSinceAssigned = 0

	local FactionIndex = GameRandom.Free_Random(1, table.getn(self.FactionMasterTable))
	self.FactionGambleConstruct = self.FactionMasterTable[FactionIndex]

	self.ConstructDialog = "DIALOG_INTERVENTION_MASTERFILE_"..self.FactionDetailTable[self.FactionGambleConstruct].DialogName..""

	self.CISConstructStructureActive = true
	self.ActiveMissions = self.ActiveMissions + 1

	self.ConstructTimerStart = self.CurrentTime
	self.ConstructTimer = GameRandom.Free_Random(5, 12)
	self.ConstructTimerEnd = self.ConstructTimerStart + self.ConstructTimer
	self.ConstructTimer = self.ConstructTimer + 1

	self.ConstructReward, self.ConstructRewardCount = StoryUtil.SelectReward(self.cis, ""..self.FactionDetailTable[self.FactionGambleConstruct].RewardName, GameRandom.Free_Random(1, 2))

	self.Construct, self.ConstructCountTarget = StoryUtil.SelectUnit(self.cis, 1, "Ground_Structure_List", GameRandom.Free_Random(2, 8) * 1000 + 1000)

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
	local event = plot.Get_Event("Construct_Structure_01")
	event.Set_Dialog(self.ConstructDialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_CONSTRUCT_STRUCTURE_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_STRUCTURE", self.Construct)
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_TARGET", self.ConstructCountTarget)
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_CURRENT", self.ConstructCountCurrent)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD")
	event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", Find_Object_Type(self.ConstructReward))
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.ConstructRewardCount)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.ConstructTimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.ConstructTimerEnd)

	Story_Event("CONSTRUCT_ASSIGN")
end

function CISMissions:FulfilConstruct()
	--Logger:trace("entering CISMissions:FulfilConstruct")
	self.ConstructCountCurrent = self.ConstructCountCurrent + 1

	if self.ConstructCountCurrent < self.ConstructCountTarget then
		local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
		local event = plot.Get_Event("Construct_Structure_01")
		event.Set_Dialog(self.ConstructDialog)
		event.Clear_Dialog_Text()

		event.Add_Dialog_Text("TEXT_INTERVENTION_CONSTRUCT_STRUCTURE_OBJECTIVE")
		event.Add_Dialog_Text("TEXT_INTERVENTION_STRUCTURE", self.Construct)
		event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_TARGET", self.ConstructCountTarget)
		event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_CURRENT", self.ConstructCountCurrent)
		event.Add_Dialog_Text("TEXT_NONE")

		event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD")
		event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", Find_Object_Type(self.ConstructReward))
		event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.ConstructRewardCount)
		event.Add_Dialog_Text("TEXT_NONE")

		event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.ConstructTimerStart)
		event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.ConstructTimerEnd)

	elseif self.ConstructCountCurrent >= self.ConstructCountTarget then
		local RewardLocation = StoryUtil.FindFriendlyPlanet(self.cis)

		for i=1,self.ConstructRewardCount do
			SpawnList({self.ConstructReward}, RewardLocation, self.cis, true, false)
		end

		local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
		local event = plot.Get_Event("Construct_Structure_02")
		event.Set_Dialog(self.ConstructDialog)
		event.Clear_Dialog_Text()

		event.Add_Dialog_Text("TEXT_INTERVENTION_CONSTRUCT_STRUCTURE_OBJECTIVE")
		event.Add_Dialog_Text("TEXT_INTERVENTION_STRUCTURE_COMPLETE", self.Construct)
		event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_TARGET", self.ConstructCountTarget)
		event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_CURRENT", self.ConstructCountCurrent)
		event.Add_Dialog_Text("TEXT_NONE")

		event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD")
		event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", Find_Object_Type(self.ConstructReward))
		event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.ConstructRewardCount)
		event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", RewardLocation)
		event.Add_Dialog_Text("TEXT_NONE")

		event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.ConstructTimerStart)
		event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.ConstructTimerEnd)

		if self.FactionGambleConstruct ~= "PDF" and self.FactionGambleConstruct ~= "CIS" then
			crossplot:publish("CIS_SUPPORT", self.FactionGambleConstruct)
		end

		self.CISConstructStructureActive = false
		self.FactionGambleConstruct = nil
		self.ConstructDialog = nil
		self.ConstructCountCurrent = 0
		self.ConstructCountTarget = nil
		self.ConstructTimerStart = nil
		self.ConstructTimer = nil
		self.ConstructTimerEnd = nil
		self.ConstructReward = nil
		self.ConstructRewardCount = nil
		self.Construct = nil

		RewardLocation = nil

		self.ActiveMissions = self.ActiveMissions - 1

		Story_Event("CONSTRUCT_COMPLETE")
	end
end

function CISMissions:FailedConstruct()
	--Logger:trace("entering CISMissions:FailedConstruct")

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
	local event = plot.Get_Event("Construct_Structure_04")
	event.Set_Dialog(self.ConstructDialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_CONSTRUCT_STRUCTURE_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_STRUCTURE_FAILED", self.Construct)
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_TARGET", self.ConstructCountTarget)
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_CURRENT", self.ConstructCountCurrent)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.ConstructTimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.ConstructTimerEnd)

	if self.FactionGambleConstruct ~= "PDF" and self.FactionGambleConstruct ~= "CIS" then
		crossplot:publish("CIS_REDUCE_SUPPORT", self.FactionGambleConstruct)
	end

	self.CISConstructStructureActive = false
	self.FactionGambleConstruct = nil
	self.ConstructDialog = nil
	self.ConstructCountCurrent = 0
	self.ConstructCountTarget = nil
	self.ConstructTimerStart = nil
	self.ConstructTimer = nil
	self.ConstructTimerEnd = nil
	self.ConstructReward = nil
	self.ConstructRewardCount = nil
	self.Construct = nil

	self.ActiveMissions = self.ActiveMissions - 1

	Story_Event("CONSTRUCT_FAILED")
end

function CISMissions:BeginUpgrade()
	--Logger:trace("entering CISMissions:BeginUpgrade")
	if self.CISUpgradeStructureActive == true then
		return
	end

	self.TimeSinceAssigned = 0

	local FactionIndex = GameRandom.Free_Random(1, table.getn(self.FactionMasterTable))
	self.FactionGambleUpgrade = self.FactionMasterTable[FactionIndex]

	self.UpgradeDialog = "DIALOG_INTERVENTION_MASTERFILE_"..self.FactionDetailTable[self.FactionGambleUpgrade].DialogName..""

	self.CISUpgradeStructureActive = true
	self.ActiveMissions = self.ActiveMissions + 1

	self.UpgradeTimerStart = self.CurrentTime
	self.UpgradeTimer = GameRandom.Free_Random(5, 12)
	self.UpgradeTimerEnd = self.UpgradeTimerStart + self.UpgradeTimer
	self.UpgradeTimer = self.UpgradeTimer + 1

	self.UpgradeReward, self.UpgradeRewardCount = StoryUtil.SelectReward(self.cis, ""..self.FactionDetailTable[self.FactionGambleUpgrade].RewardName, GameRandom.Free_Random(1, 2))

	self.Upgrade, self.UpgradeCountTarget = StoryUtil.SelectUnit(self.cis, 1, "Ground_Structure_List", GameRandom.Free_Random(2, 8) * 1000 + 1000)

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
	local event = plot.Get_Event("Upgrade_Structure_01")
	event.Set_Dialog(self.UpgradeDialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_CONSTRUCT_STRUCTURE_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_STRUCTURE", self.Upgrade)
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_TARGET", self.UpgradeCountTarget)
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_CURRENT", self.UpgradeCountCurrent)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD")
	event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", Find_Object_Type(self.UpgradeReward))
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.UpgradeRewardCount)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.UpgradeTimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.UpgradeTimerEnd)

	Story_Event("UPGRADE_ASSIGN")
end

function CISMissions:FulfilUpgrade()
	--Logger:trace("entering CISMissions:FulfilUpgrade")
	self.UpgradeCountCurrent = self.UpgradeCountCurrent + 1

	if self.UpgradeCountCurrent < self.UpgradeCountTarget then
		local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
		local event = plot.Get_Event("Upgrade_Structure_01")
		event.Set_Dialog(self.UpgradeDialog)
		event.Clear_Dialog_Text()

		event.Add_Dialog_Text("TEXT_INTERVENTION_CONSTRUCT_STRUCTURE_OBJECTIVE")
		event.Add_Dialog_Text("TEXT_INTERVENTION_STRUCTURE", self.Upgrade)
		event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_TARGET", self.UpgradeCountTarget)
		event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_CURRENT", self.UpgradeCountCurrent)
		event.Add_Dialog_Text("TEXT_NONE")

		event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD")
		event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", Find_Object_Type(self.UpgradeReward))
		event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.UpgradeRewardCount)
		event.Add_Dialog_Text("TEXT_NONE")

		event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.UpgradeTimerStart)
		event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.UpgradeTimerEnd)

	elseif self.UpgradeCountCurrent >= self.UpgradeCountTarget then
		local RewardLocation = StoryUtil.FindFriendlyPlanet(self.cis)

		for i=1,self.UpgradeRewardCount do
			SpawnList({self.UpgradeReward}, RewardLocation, self.cis, true, false)
		end

		local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
		local event = plot.Get_Event("Upgrade_Structure_02")
		event.Set_Dialog(self.UpgradeDialog)
		event.Clear_Dialog_Text()

		event.Add_Dialog_Text("TEXT_INTERVENTION_CONSTRUCT_STRUCTURE_OBJECTIVE")
		event.Add_Dialog_Text("TEXT_INTERVENTION_STRUCTURE_COMPLETE", self.Upgrade)
		event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_TARGET", self.UpgradeCountTarget)
		event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_CURRENT", self.UpgradeCountCurrent)
		event.Add_Dialog_Text("TEXT_NONE")

		event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD")
		event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", Find_Object_Type(self.UpgradeReward))
		event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.UpgradeRewardCount)
		event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", RewardLocation)
		event.Add_Dialog_Text("TEXT_NONE")

		event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.UpgradeTimerStart)
		event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.UpgradeTimerEnd)

		if self.FactionGambleUpgrade ~= "PDF" and self.FactionGambleUpgrade ~= "CIS" then
			crossplot:publish("CIS_SUPPORT", self.FactionGambleUpgrade)
		end

		self.CISUpgradeStructureActive = false
		self.FactionGambleUpgrade = nil
		self.UpgradeDialog = nil
		self.UpgradeCountCurrent = 0
		self.UpgradeCountTarget = nil
		self.UpgradeTimerStart = nil
		self.UpgradeTimer = nil
		self.UpgradeTimerEnd = nil
		self.UpgradeReward = nil
		self.UpgradeRewardCount = nil
		self.Upgrade = nil

		RewardLocation = nil

		self.ActiveMissions = self.ActiveMissions - 1

		Story_Event("UPGRADE_COMPLETE")
	end
end

function CISMissions:FailedUpgrade()
	--Logger:trace("entering CISMissions:FailedUpgrade")

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
	local event = plot.Get_Event("Upgrade_Structure_04")
	event.Set_Dialog(self.UpgradeDialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_UPGRADE_STRUCTURE_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_STRUCTURE_FAILED", self.Upgrade)
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_TARGET", self.UpgradeCountTarget)
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_CURRENT", self.UpgradeCountCurrent)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.UpgradeTimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.UpgradeTimerEnd)

	if self.FactionGambleUpgrade ~= "PDF" and self.FactionGambleUpgrade ~= "CIS" then
		crossplot:publish("CIS_REDUCE_SUPPORT", self.FactionGambleUpgrade)
	end

	self.CISUpgradeStructureActive = false
	self.FactionGambleUpgrade = nil
	self.UpgradeDialog = nil
	self.UpgradeCountCurrent = 0
	self.UpgradeCountTarget = nil
	self.UpgradeTimerStart = nil
	self.UpgradeTimer = nil
	self.UpgradeTimerEnd = nil
	self.UpgradeReward = nil
	self.UpgradeRewardCount = nil
	self.Upgrade = nil

	self.ActiveMissions = self.ActiveMissions - 1

	Story_Event("UPGRADE_FAILED")
end

function CISMissions:BeginRecon()
	--Logger:trace("entering CISMissions:BeginRecon")
	if self.CISReconPlanetActive == true then
		return
	end

	self.TimeSinceAssigned = 0

	local FactionIndex = GameRandom.Free_Random(1, table.getn(self.FactionMasterTable))
	self.FactionGambleRecon = self.FactionMasterTable[FactionIndex]

	self.ReconDialog = "DIALOG_INTERVENTION_MASTERFILE_"..self.FactionDetailTable[self.FactionGambleRecon].DialogName..""

	self.CISReconPlanetActive = true
	self.ActiveMissions = self.ActiveMissions + 1

	self.ReconTimerStart = self.CurrentTime
	self.ReconTimer = GameRandom.Free_Random(5, 15)
	self.ReconTimerEnd = self.ReconTimerStart + self.ReconTimer
	self.ReconTimer = self.ReconTimer + 1

	self.ReconTarget01, self.ReconTarget02 = StoryUtil.FindTargetPlanet(self.cis, false, true, 2)
	if self.ReconTarget01 then
		if not TestValid(self.ReconTarget02) then
			self.ReconTarget02 = self.ReconTarget01
			self.ValidReconTarget02 = false
		else
			self.ValidReconTarget02 = true
		end

		self.ReconReward, self.ReconRewardCount = StoryUtil.SelectReward(self.cis, ""..self.FactionDetailTable[self.FactionGambleRecon].RewardName, GameRandom.Free_Random(1, 2))

		local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
		local event = plot.Get_Event("Recon_Planet_01")
		event.Set_Dialog(self.ReconDialog)
		event.Clear_Dialog_Text()

		event.Add_Dialog_Text("TEXT_INTERVENTION_RECONNAISSANCE_OBJECTIVE")
		event.Add_Dialog_Text("TEXT_INTERVENTION_RECONNAISSANCE_LOCATION", self.ReconTarget01)
		if self.ValidReconTarget02 == true then
			event.Add_Dialog_Text("TEXT_INTERVENTION_RECONNAISSANCE_LOCATION", self.ReconTarget02)
		end
		event.Add_Dialog_Text("TEXT_NONE")

		event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD")
		event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", Find_Object_Type(self.ReconReward))
		event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.ReconRewardCount)
		event.Add_Dialog_Text("TEXT_NONE")

		event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.ReconTimerStart)
		event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.ReconTimerEnd)

		local event = plot.Get_Event("Recon_Planet_I_Enter")
		event.Set_Event_Parameter(0, self.ReconTarget01)
		event.Set_Reward_Parameter(1, self.cis.Get_Faction_Name())

		local event = plot.Get_Event("Recon_Planet_I_Flash")
		event.Set_Reward_Parameter(0, self.ReconTarget01)

		local event = plot.Get_Event("Recon_Planet_II_Enter")
		event.Set_Event_Parameter(0, self.ReconTarget02)
		event.Set_Reward_Parameter(1, self.cis.Get_Faction_Name())

		local event = plot.Get_Event("Recon_Planet_II_Flash")
		event.Set_Reward_Parameter(0, self.ReconTarget02)

		Story_Event("RECON_ASSIGN")
	end
end

function CISMissions:FulfilRecon()
	--Logger:trace("entering CISMissions:FulfilRecon")

	if self.Recon01Complete == false or self.Recon02Complete == false then
		local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
		local event = plot.Get_Event("Recon_Planet_01")
		event.Set_Dialog(self.ReconDialog)
		event.Clear_Dialog_Text()

		event.Add_Dialog_Text("TEXT_INTERVENTION_RECONNAISSANCE_OBJECTIVE")
		if self.Recon01Complete == true then
			event.Add_Dialog_Text("TEXT_INTERVENTION_RECONNAISSANCE_LOCATION_COMPLETE", self.ReconTarget01)
		else
			event.Add_Dialog_Text("TEXT_INTERVENTION_RECONNAISSANCE_LOCATION", self.ReconTarget01)
		end
		if self.Recon02Complete == true and self.ValidReconTarget02 == true then
			event.Add_Dialog_Text("TEXT_INTERVENTION_RECONNAISSANCE_LOCATION_COMPLETE", self.ReconTarget02)
		else
			event.Add_Dialog_Text("TEXT_INTERVENTION_RECONNAISSANCE_LOCATION", self.ReconTarget02)
		end
		event.Add_Dialog_Text("TEXT_NONE")

		event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD")
		event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", Find_Object_Type(self.ReconReward))
		event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.ReconRewardCount)
		event.Add_Dialog_Text("TEXT_NONE")

		event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.ReconTimerStart)
		event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.ReconTimerEnd)

	elseif self.Recon01Complete == true and self.Recon02Complete == true then
		local RewardLocation = StoryUtil.FindFriendlyPlanet(self.cis)
		for i=1,self.ReconRewardCount do
			SpawnList({self.ReconReward}, RewardLocation, self.cis, true, false)
		end

		local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
		local event = plot.Get_Event("Recon_Planet_02")
		event.Set_Dialog(self.ReconDialog)
		event.Clear_Dialog_Text()

		event.Add_Dialog_Text("TEXT_INTERVENTION_RECONNAISSANCE_OBJECTIVE")
		event.Add_Dialog_Text("TEXT_INTERVENTION_RECONNAISSANCE_LOCATION_COMPLETE", self.ReconTarget01)
		if self.ValidReconTarget02 == true then
			event.Add_Dialog_Text("TEXT_INTERVENTION_RECONNAISSANCE_LOCATION_COMPLETE", self.ReconTarget02)
		end
		event.Add_Dialog_Text("TEXT_NONE")

		event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD")
		event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", Find_Object_Type(self.ReconReward))
		event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.ReconRewardCount)
		event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", RewardLocation)
		event.Add_Dialog_Text("TEXT_NONE")

		event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.ReconTimerStart)
		event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.ReconTimerEnd)

		if self.FactionGambleRecon ~= "PDF" and self.FactionGambleRecon ~= "CIS" then
			crossplot:publish("CIS_SUPPORT", self.FactionGambleRecon)
		end

		self.CISReconPlanetActive = false
		self.FactionGambleRecon = nil
		self.ReconDialog = nil
		self.ReconTimerStart = nil
		self.ReconTimer = nil
		self.ReconTimerEnd = nil
		self.ReconTarget01 = nil
		self.ReconTarget02 = nil
		self.Recon01Complete = false
		self.Recon02Complete = false
		self.ReconReward = nil
		self.ReconRewardCount = nil
		self.ValidReconTarget02 = true

		RewardLocation = nil

		self.ActiveMissions = self.ActiveMissions - 1

		Story_Event("RECON_COMPLETE")
	end
end

function CISMissions:FailedRecon()
	--Logger:trace("entering CISMissions:FailedRecon")

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
	local event = plot.Get_Event("Recon_Planet_04")
	event.Set_Dialog(self.ReconDialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_RECONNAISSANCE_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_RECONNAISSANCE_LOCATION_FAILED", self.ReconTarget01)
	if self.ValidReconTarget02 == true then
		event.Add_Dialog_Text("TEXT_INTERVENTION_RECONNAISSANCE_LOCATION_FAILED", self.ReconTarget02)
	end
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.ReconTimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.ReconTimerEnd)

	if self.FactionGambleRecon ~= "PDF" and self.FactionGambleRecon ~= "CIS" then
		crossplot:publish("CIS_REDUCE_SUPPORT", self.FactionGambleRecon)
	end

	self.CISReconPlanetActive = false
	self.FactionGambleRecon = nil
	self.ReconDialog = nil
	self.ReconTimerStart = nil
	self.ReconTimer = nil
	self.ReconTimerEnd = nil
	self.ReconTarget01 = nil
	self.ReconTarget02 = nil
	self.Recon01Complete = false
	self.Recon02Complete = false
	self.ReconReward = nil
	self.ReconRewardCount = nil
	self.ValidReconTarget02 = true

	self.ActiveMissions = self.ActiveMissions - 1

	Story_Event("RECON_FAILED")
end

function CISMissions:BeginConvoy()
	--Logger:trace("entering CISMissions:BeginConvoy")
	if self.CISConvoyActive == true then
		return
	end

	self.TimeSinceAssigned = 0

	local FactionIndex = GameRandom.Free_Random(1, table.getn(self.FactionMasterTable))
	self.FactionGambleConvoy = self.FactionMasterTable[FactionIndex]

	self.ConvoyDialog = "DIALOG_INTERVENTION_MASTERFILE_"..self.FactionDetailTable[self.FactionGambleConvoy].DialogName..""

	self.CISConvoyActive = true
	self.ActiveMissions = self.ActiveMissions + 1

	self.ConvoyTimerStart = self.CurrentTime
	self.ConvoyTimer = GameRandom.Free_Random(10, 25)
	self.ConvoyTimerEnd = self.ConvoyTimerStart + self.ConvoyTimer
	self.ConvoyTimer = self.ConvoyTimer + 1

	self.ConvoyUnit = Find_Object_Type("SUPER_TRANSPORT_XI_CONVOY")
	self.ConvoyCountCurrent = 2
	self.ConvoyLocationCurrent = StoryUtil.FindTargetPlanet(self.cis, true, false, 1)
	if self.ConvoyLocationCurrent.Get_Owner() ~= self.republic then
		self.ConvoyLocationCurrent = StoryUtil.FindTargetPlanet(self.cis, true, false, 1)
		if self.ConvoyLocationCurrent.Get_Owner() ~= self.republic then
			self.ConvoyLocationCurrent = StoryUtil.FindTargetPlanet(self.cis, true, false, 1)
		end
	end

	local convoy_list = {"SUPER_TRANSPORT_XI_CONVOY", "SUPER_TRANSPORT_XI_CONVOY"}
	local convoy_unit_list = SpawnList(convoy_list, self.ConvoyLocationCurrent, self.ConvoyLocationCurrent.Get_Owner(), false, false)
	self.ConvoyFleet = Assemble_Fleet(convoy_unit_list)

	self.ConvoyReward, self.ConvoyRewardCount = StoryUtil.SelectReward(self.cis, ""..self.FactionDetailTable[self.FactionGambleConvoy].RewardName, 3)

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
	local event = plot.Get_Event("Hunt_Convoy_01")
	event.Set_Dialog(self.ConvoyDialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_CONVOY_HUNT_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_HUNT", self.ConvoyUnit)
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.ConvoyCountCurrent)
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", self.ConvoyLocationCurrent)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD")
	event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", Find_Object_Type(self.ConvoyReward))
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.ConvoyRewardCount)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.ConvoyTimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.ConvoyTimerEnd)

	local event = plot.Get_Event("Hunt_Convoy_Flash")
	event.Set_Reward_Parameter(0, self.ConvoyLocationCurrent)

	Story_Event("CONVOY_ASSIGN")
end

function CISMissions:FulfilConvoy()
	--Logger:trace("entering CISMissions:FulfilConvoy")

	if self.ConvoyCountCurrent > 0 then
		while not TestValid(self.ConvoyLocationCurrent) do
			self.ConvoyLocationCurrent = self.ConvoyFleet.Get_Parent_Object()
			local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
			local event = plot.Get_Event("Hunt_Convoy_01")
			event.Set_Dialog(self.ConvoyDialog)
			event.Clear_Dialog_Text()

			event.Add_Dialog_Text("TEXT_INTERVENTION_CONVOY_HUNT_OBJECTIVE")
			event.Add_Dialog_Text("TEXT_INTERVENTION_HUNT", self.ConvoyUnit)
			event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.ConvoyCountCurrent)
			event.Add_Dialog_Text("TEXT_INTERVENTION_CONVOY_HUNT_TRANSIT")
			event.Add_Dialog_Text("TEXT_NONE")

			event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD")
			event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", Find_Object_Type(self.ConvoyReward))
			event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.ConvoyRewardCount)
			event.Add_Dialog_Text("TEXT_NONE")

			event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.ConvoyTimerStart)
			event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.ConvoyTimerEnd)
		end

		self.ConvoyLocationCurrent = self.ConvoyFleet.Get_Parent_Object()
		local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
		local event = plot.Get_Event("Hunt_Convoy_01")
		event.Set_Dialog(self.ConvoyDialog)
		event.Clear_Dialog_Text()

		event.Add_Dialog_Text("TEXT_INTERVENTION_CONVOY_HUNT_OBJECTIVE")
		event.Add_Dialog_Text("TEXT_INTERVENTION_HUNT", self.ConvoyUnit)
		event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.ConvoyCountCurrent)
		if TestValid(self.ConvoyLocationCurrent) then
			event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", self.ConvoyLocationCurrent)
		end
		event.Add_Dialog_Text("TEXT_NONE")

		event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD")
		event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", Find_Object_Type(self.ConvoyReward))
		event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.ConvoyRewardCount)
		event.Add_Dialog_Text("TEXT_NONE")

		event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.ConvoyTimerStart)
		event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.ConvoyTimerEnd)
	elseif self.ConvoyCountCurrent == 0 then
		local RewardLocation = StoryUtil.FindFriendlyPlanet(self.cis)
		for i=1,self.ConvoyRewardCount do
			SpawnList({self.ConvoyReward}, RewardLocation, self.cis, true, false)
		end

		local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
		local event = plot.Get_Event("Hunt_Convoy_02")
		event.Set_Dialog(self.ConvoyDialog)
		event.Clear_Dialog_Text()

		event.Add_Dialog_Text("TEXT_INTERVENTION_CONVOY_HUNT_OBJECTIVE")
		event.Add_Dialog_Text("TEXT_INTERVENTION_HUNT_COMPLETE", self.ConvoyUnit)
		event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.ConvoyCountCurrent)
		event.Add_Dialog_Text("TEXT_NONE")

		event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD")
		event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", Find_Object_Type(self.ConvoyReward))
		event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.ConvoyRewardCount)
		event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", RewardLocation)
		event.Add_Dialog_Text("TEXT_NONE")

		event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.ConvoyTimerStart)
		event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.ConvoyTimerEnd)

		if self.FactionGambleConvoy ~= "PDF" and self.FactionGambleConvoy ~= "CIS" then
			crossplot:publish("CIS_SUPPORT", self.FactionGambleConvoy)
		end

		self.CISConvoyActive = false
		self.FactionGambleConvoy = nil
		self.ConvoyDialog = nil
		self.ConvoyTimerStart = nil
		self.ConvoyTimer = nil
		self.ConvoyTimerEnd = nil
		self.ConvoyReward = nil
		self.ConvoyRewardCount = nil
		self.ConvoyUnit = nil
		self.ConvoyCountCurrent = nil
		self.ConvoyLocationCurrent = nil

		RewardLocation = nil

		self.ActiveMissions = self.ActiveMissions - 1

		Story_Event("CONVOY_COMPLETE")
	end
end

function CISMissions:FailedConvoy()
	--Logger:trace("entering CISMissions:FailedConvoy")

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
	local event = plot.Get_Event("Hunt_Convoy_04")
	event.Set_Dialog(self.ConvoyDialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_CONVOY_HUNT_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_HUNT_FAILED", self.ConvoyUnit)
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.ConvoyCountCurrent)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.ConvoyTimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.ConvoyTimerEnd)

	if self.FactionGambleConvoy ~= "PDF" and self.FactionGambleConvoy ~= "CIS" then
		crossplot:publish("CIS_REDUCE_SUPPORT", self.FactionGambleConvoy)
	end

	convoy_despawn_list = Find_All_Objects_Of_Type("SUPER_TRANSPORT_XI_CONVOY")
	for _,unit in pairs(convoy_despawn_list) do
		if TestValid(unit) then
			unit.Despawn()
		end
	end

	self.CISConvoyActive = false
	self.FactionGambleConvoy = nil
	self.ConvoyDialog = nil
	self.ConvoyTimerStart = nil
	self.ConvoyTimer = nil
	self.ConvoyTimerEnd = nil
	self.ConvoyReward = nil
	self.ConvoyRewardCount = nil
	self.ConvoyUnit = nil
	self.ConvoyCountCurrent = nil
	self.ConvoyLocationCurrent = nil

	self.ActiveMissions = self.ActiveMissions - 1

	Story_Event("CONVOY_FAILED")
end

function CISMissions:BeginLiberate()
	--Logger:trace("entering CISMissions:BeginLiberate")
	if self.CISLiberatePlanetActive == true then
		return
	end

	self.TimeSinceAssigned = 0

	local FactionIndex = GameRandom.Free_Random(1, table.getn(self.FactionMasterTable))
	self.FactionGambleLiberate = self.FactionMasterTable[FactionIndex]

	self.LiberateDialog = "DIALOG_INTERVENTION_MASTERFILE_"..self.FactionDetailTable[self.FactionGambleLiberate].DialogName..""

	self.CISLiberatePlanetActive = true
	self.ActiveMissions = self.ActiveMissions + 1

	self.LiberateTimerStart = self.CurrentTime
	self.LiberateTimer = GameRandom.Free_Random(5, 15)
	self.LiberateTimerEnd = self.LiberateTimerStart + self.LiberateTimer
	self.LiberateTimer = self.LiberateTimer + 1

	self.LiberateTarget = StoryUtil.FindTargetPlanet(self.cis, true, false, 1)
	if self.LiberateTarget == nil then
		return
	end

	self.LiberateReward, self.LiberateRewardCount = StoryUtil.SelectReward(self.cis, ""..self.FactionDetailTable[self.FactionGambleLiberate].RewardName, 3)

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
	local event = plot.Get_Event("Liberate_Planet_01")
	event.Set_Dialog(self.LiberateDialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", self.LiberateTarget)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD")
	event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", Find_Object_Type(self.LiberateReward))
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.LiberateRewardCount)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.LiberateTimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.LiberateTimerEnd)

	local event = plot.Get_Event("Liberate_Planet_Flash")
	event.Set_Reward_Parameter(0, self.LiberateTarget)

	Story_Event("LIBERATE_ASSIGN")
end

function CISMissions:FulfilLiberate()
	--Logger:trace("entering CISMissions:FulfilLiberate")
	for i=1,self.LiberateRewardCount do
		SpawnList({self.LiberateReward}, self.LiberateTarget, self.cis, true, false)
	end

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
	local event = plot.Get_Event("Liberate_Planet_02")
	event.Set_Dialog(self.LiberateDialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", self.LiberateTarget)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD")
	event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", Find_Object_Type(self.LiberateReward))
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.LiberateRewardCount)
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", self.LiberateTarget)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.LiberateTimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.LiberateTimerEnd)

	if self.FactionGambleLiberate ~= "PDF" and self.FactionGambleLiberate ~= "CIS" then
		crossplot:publish("CIS_SUPPORT", self.FactionGambleLiberate)
	end

	self.CISLiberatePlanetActive = false
	self.FactionGambleLiberate = nil
	self.LiberateDialog = nil
	self.LiberateTimerStart = nil
	self.LiberateTimer = nil
	self.LiberateTimerEnd = nil
	self.LiberateReward = nil
	self.LiberateRewardCount = 0
	self.LiberateTarget = nil

	self.ActiveMissions = self.ActiveMissions - 1

	Story_Event("LIBERATE_COMPLETE")
end

function CISMissions:FailedLiberate()
	--Logger:trace("entering CISMissions:FailedLiberate")

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
	local event = plot.Get_Event("Liberate_Planet_04")
	event.Set_Dialog(self.LiberateDialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_FAILED", self.LiberateTarget)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.LiberateTimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.LiberateTimerEnd)

	if self.FactionGambleLiberate ~= "PDF" and self.FactionGambleLiberate ~= "CIS" then
		crossplot:publish("CIS_REDUCE_SUPPORT", self.FactionGambleLiberate)
	end

	self.CISLiberatePlanetActive = false
	self.FactionGambleLiberate = nil
	self.LiberateDialog = nil
	self.LiberateTimerStart = nil
	self.LiberateTimer = nil
	self.LiberateTimerEnd = nil
	self.LiberateReward = nil
	self.LiberateRewardCount = 0
	self.LiberateTarget = nil

	self.ActiveMissions = self.ActiveMissions - 1

	Story_Event("LIBERATE_FAILED")
end

function CISMissions:BeginUnitHunt()
	--Logger:trace("entering CISMissions:BeginUnitHunt")
	if self.CISUnitHuntActive == true then
		return
	end

	self.TimeSinceAssigned = 0

	local FactionIndex = GameRandom.Free_Random(1, table.getn(self.FactionMasterTable))
	self.FactionGambleUnitHunt = self.FactionMasterTable[FactionIndex]

	self.UnitHuntDialog = "DIALOG_INTERVENTION_MASTERFILE_"..self.FactionDetailTable[self.FactionGambleUnitHunt].DialogName..""

	self.CISUnitHuntActive = true
	self.ActiveMissions = self.ActiveMissions + 1

	self.UnitHuntTimerStart = self.CurrentTime
	self.UnitHuntTimer = GameRandom.Free_Random(8, 18)
	self.UnitHuntTimerEnd = self.UnitHuntTimerStart + self.UnitHuntTimer
	self.UnitHuntTimer = self.UnitHuntTimer + 1

	self.UnitHuntReward, self.UnitHuntRewardCount = StoryUtil.SelectReward(self.cis, ""..self.FactionDetailTable[self.FactionGambleUnitHunt].RewardName, 2)

	self.UnitHuntUnit, self.UnitHuntCountTarget = StoryUtil.SelectUnit(self.republic, 1, "Space_Station_List", GameRandom.Free_Random(1, 5) * 1000)
	self.UnitHuntCountTarget = 1
	self.UnitHuntCountCurrent = 0

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
	local event = plot.Get_Event("Hunt_Unit_01")
	event.Set_Dialog(self.UnitHuntDialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_HUNT_STRUCTURE_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_STRUCTURE", self.UnitHuntUnit)
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_TARGET", self.UnitHuntCountTarget)
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_CURRENT", self.UnitHuntCountCurrent)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD")
	event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", Find_Object_Type(self.UnitHuntReward))
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.UnitHuntRewardCount)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.UnitHuntTimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.UnitHuntTimerEnd)

	local event = plot.Get_Event("Hunt_Unit_Kill_Counter")
	event.Set_Event_Parameter(0, self.UnitHuntUnit)
	event.Set_Event_Parameter(2, self.UnitHuntCountTarget)
	event.Set_Reward_Parameter(1, self.cis.Get_Faction_Name())

	Story_Event("HUNT_ASSIGN")
end

function CISMissions:FulfilUnitHunt()
	--Logger:trace("entering CISMissions:FulfilUnitHunt")
	local RewardLocation = StoryUtil.FindFriendlyPlanet(self.cis)

	for i=1,self.UnitHuntRewardCount do
		SpawnList({self.UnitHuntReward}, RewardLocation, self.cis, true, false)
	end

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
	local event = plot.Get_Event("Hunt_Unit_02")
	event.Set_Dialog(self.UnitHuntDialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_HUNT_STRUCTURE_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_STRUCTURE_COMPLETE", self.UnitHuntUnit)
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_TARGET", self.UnitHuntCountTarget)
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_CURRENT", self.UnitHuntCountCurrent)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD")
	event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", Find_Object_Type(self.UnitHuntReward))
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.UnitHuntRewardCount)
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", RewardLocation)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.UnitHuntTimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.UnitHuntTimerEnd)

	if self.FactionGambleUnitHunt ~= "PDF" and self.FactionGambleUnitHunt ~= "CIS" then
		crossplot:publish("CIS_SUPPORT", self.FactionGambleUnitHunt)
	end

	self.CISUnitHuntActive = false
	self.FactionGambleUnitHunt = nil
	self.UnitHuntDialog = nil
	self.UnitHuntTimerStart = nil
	self.UnitHuntTimer = nil
	self.UnitHuntTimerEnd = nil
	self.UnitHuntReward = nil
	self.UnitHuntRewardCount = nil
	self.UnitHuntUnit = nil
	self.UnitHuntCountCurrent = nil
	self.UnitHuntCountTarget = nil

	RewardLocation = nil

	self.ActiveMissions = self.ActiveMissions - 1

	Story_Event("HUNT_COMPLETE")
end

function CISMissions:FailedUnitHunt()
	--Logger:trace("entering CISMissions:FailedUnitHunt")

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
	local event = plot.Get_Event("Hunt_Unit_04")
	event.Set_Dialog(self.UnitHuntDialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_HUNT_STRUCTURE_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_STRUCTURE_FAILED", self.UnitHuntUnit)
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_TARGET", self.UnitHuntCountTarget)
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_CURRENT", self.UnitHuntCountCurrent)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.UnitHuntTimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.UnitHuntTimerEnd)

	if self.FactionGambleUnitHunt ~= "PDF" and self.FactionGambleUnitHunt ~= "CIS" then
		crossplot:publish("CIS_REDUCE_SUPPORT", self.FactionGambleUnitHunt)
	end

	self.CISUnitHuntActive = false
	self.FactionGambleUnitHunt = nil
	self.UnitHuntDialog = nil
	self.UnitHuntTimerStart = nil
	self.UnitHuntTimer = nil
	self.UnitHuntTimerEnd = nil
	self.UnitHuntReward = nil
	self.UnitHuntRewardCount = nil
	self.UnitHuntUnit = nil
	self.UnitHuntCountCurrent = nil
	self.UnitHuntCountTarget = nil

	self.ActiveMissions = self.ActiveMissions - 1

	Story_Event("HUNT_FAILED")
end

function CISMissions:on_construction_finished(planet, game_object_type_name)
	--Logger:trace("entering CISMissions:on_construction_finished")
	if self.CISConstructStructureActive == true and self.Construct ~= nil then
		if planet:get_owner() == self.cis and game_object_type_name == self.Construct.Get_Name() then
			self:FulfilConstruct()
		end
	end
	if self.CISUpgradeStructureActive == true and self.Upgrade ~= nil then
		if planet:get_owner() == self.cis and game_object_type_name == self.Upgrade.Get_Name() then
			self:FulfilUpgrade()
		end
	end
end

function CISMissions:on_planet_conquered(planet, new_owner_name, old_owner_name)
	if new_owner_name ~= "REBEL" then 
		return
	end
	--Logger:trace("entering CISMissions:on_planet_conquered")

	if self.CISConquerPlanetActive == true then
		if planet:get_game_object() == self.ConquerTarget then
			self:FulfilConquer()
		end
	end
	if self.CISLiberatePlanetActive == true then
		if planet:get_game_object() == self.LiberateTarget then
			self:FulfilLiberate()
		end
	end
	if self.CISReconPlanetActive == true then
		if planet:get_game_object() == self.ReconTarget01 then
			self.Recon01Complete = true
		end
		if planet:get_game_object() == self.ReconTarget02 then
			self.Recon02Complete = true
		end
		if planet:get_owner() == self.cis then
			self:FulfilRecon()
		end
	end
end

function CISMissions:on_galactic_hero_killed(hero_type_name)
	--Logger:trace("entering CISMissions:on_galactic_hero_killed")

	if self.CISConvoyActive == true then
		if hero_type_name == "SUPER_TRANSPORT_XI_CONVOY" then
			self.ConvoyCountCurrent = self.ConvoyCountCurrent - 1
			self:FulfilConvoy()
		end
	end
end

function CISMissions:LoopConvoy()
	--Logger:trace("entering CISMissions:LoopConvoy")

	if self.CISConvoyActive == true then
		while not TestValid(self.ConvoyLocationCurrent) do
			self.ConvoyLocationCurrent = self.ConvoyFleet.Get_Parent_Object()
			local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
			local event = plot.Get_Event("Hunt_Convoy_01")
			event.Set_Dialog(self.ConvoyDialog)
			event.Clear_Dialog_Text()

			event.Add_Dialog_Text("TEXT_INTERVENTION_CONVOY_HUNT_OBJECTIVE")
			event.Add_Dialog_Text("TEXT_INTERVENTION_HUNT", self.ConvoyUnit)
			event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.ConvoyCountCurrent)
			event.Add_Dialog_Text("TEXT_INTERVENTION_CONVOY_HUNT_TRANSIT")
			event.Add_Dialog_Text("TEXT_NONE")

			event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD")
			event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", Find_Object_Type(self.ConvoyReward))
			event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.ConvoyRewardCount)
			event.Add_Dialog_Text("TEXT_NONE")

			event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.ConvoyTimerStart)
			event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.ConvoyTimerEnd)
		end

		self.ConvoyLocationCurrent = self.ConvoyFleet.Get_Parent_Object()
		local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository_"..self.cis.Get_Faction_Name()..".xml")
		local event = plot.Get_Event("Hunt_Convoy_01")
		event.Set_Dialog(self.ConvoyDialog)
		event.Clear_Dialog_Text()

		event.Add_Dialog_Text("TEXT_INTERVENTION_CONVOY_HUNT_OBJECTIVE")
		event.Add_Dialog_Text("TEXT_INTERVENTION_HUNT", self.ConvoyUnit)
		event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.ConvoyCountCurrent)
		if TestValid(self.ConvoyLocationCurrent) then
			event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", self.ConvoyLocationCurrent)
		else
			event.Add_Dialog_Text("TEXT_INTERVENTION_CONVOY_HUNT_TRANSIT")
		end
		event.Add_Dialog_Text("TEXT_NONE")

		event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD")
		event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", Find_Object_Type(self.ConvoyReward))
		event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.ConvoyRewardCount)
		event.Add_Dialog_Text("TEXT_NONE")

		event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.ConvoyTimerStart)
		event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.ConvoyTimerEnd)
	end
end

return CISMissions
