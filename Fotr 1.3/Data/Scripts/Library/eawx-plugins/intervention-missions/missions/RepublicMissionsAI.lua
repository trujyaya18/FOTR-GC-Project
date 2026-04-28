require("deepcore/std/class")
require("PGStoryMode")
require("PGSpawnUnits")
StoryUtil = require("eawx-util/StoryUtil")
require("MissionFunctions")

---@class RepublicMissionsAI
RepublicMissionsAI = class()

function RepublicMissionsAI:new(gc)
	self.cis = Find_Player("Rebel")
	self.republic = Find_Player("Empire")
	self.potential_targets = {}

	self.TimeSinceAssigned = 0

	self.FactionGamble = nil
	self.Reward = nil
	self.RewardCount = 0

	self.era = GlobalValue.Get("CURRENT_ERA")

	self.FactionMasterTable = {
		"REP",
		"REP",
		"REP",
		"REP",
		"PDF"
	}

	self.FactionDetailTable = {
		["REP"] = {
			DialogName = "REP",
			RewardName = "Era_"..tostring(self.era)..""
		},
		["PDF"] = {
			DialogName = "PDF",
			RewardName = "PDF"
		}
	}

	self.RewardTable = {
		"Space",
		"Space",
		"Ground"
	}

end

function RepublicMissionsAI:update()
	--Logger:trace("entering RepublicMissionsAI:Update")
	self.TimeSinceAssigned = self.TimeSinceAssigned + 1

	if self.TimeSinceAssigned >= 5 then
		self:SpawnAIReward()
	end
end

function RepublicMissionsAI:SpawnAIReward()
	--Logger:trace("entering RepublicMissionsAI:SpawnAIReward")

	self.TimeSinceAssigned = 0

	local FactionIndex = GameRandom.Free_Random(1, table.getn(self.FactionMasterTable))
	self.FactionGamble = self.FactionMasterTable[FactionIndex]

	local RewardIndex = GameRandom.Free_Random(1, table.getn(self.RewardTable))
	self.Reward, self.RewardCount = StoryUtil.SelectReward(self.republic, ""..self.FactionDetailTable[self.FactionGamble].RewardName, GameRandom.Free_Random(1, 3))

	local RewardLocation = StoryUtil.FindFriendlyPlanet(self.republic)

	for i=1,self.RewardCount do
		SpawnList({self.Reward}, RewardLocation, self.republic, true, false)
	end
end

return RepublicMissionsAI