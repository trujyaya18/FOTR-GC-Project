require("deepcore/std/class")
require("PGStoryMode")
require("PGSpawnUnits")
StoryUtil = require("eawx-util/StoryUtil")
require("MissionFunctions")

---@class CISMissionsAI
CISMissionsAI = class()

function CISMissionsAI:new(gc)
	self.cis = Find_Player("Rebel")
	self.republic = Find_Player("Empire")
	self.potential_targets = {}

	self.TimeSinceAssigned = 0

	self.FactionGamble = nil
	self.Reward = nil
	self.RewardCount = 0

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

end

function CISMissionsAI:update()
	--Logger:trace("entering CISMissionsAI:Update")
	self.TimeSinceAssigned = self.TimeSinceAssigned + 1

	if self.TimeSinceAssigned >= 5 then
		self:SpawnAIReward()
	end
end

function CISMissionsAI:SpawnAIReward()
	--Logger:trace("entering CISMissionsAI:SpawnAIReward")

	self.TimeSinceAssigned = 0

	local FactionIndex = GameRandom.Free_Random(1, table.getn(self.FactionMasterTable))
	self.FactionGamble = self.FactionMasterTable[FactionIndex]

	self.Reward, self.RewardCount = StoryUtil.SelectReward(self.cis, ""..self.FactionDetailTable[self.FactionGamble].RewardName, GameRandom.Free_Random(1, 3))

	local RewardLocation = StoryUtil.FindFriendlyPlanet(self.cis)

	for i=1,self.RewardCount do
		SpawnList({self.Reward}, RewardLocation, self.cis, true, false)
	end

	if self.FactionGamble ~= "PDF" and self.FactionGamble ~= "CIS" then
		crossplot:publish("CIS_SUPPORT", self.FactionGamble)
	end
end

return CISMissionsAI