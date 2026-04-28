
require("deepcore/std/class")
require("eawx-plugins/intervention-missions/missions/CISMissions")
require("eawx-plugins/intervention-missions/missions/RepublicMissions")
require("eawx-plugins/intervention-missions/missions/CISMissionsAI")
require("eawx-plugins/intervention-missions/missions/RepublicMissionsAI")

---@class MissionManager
MissionManager = class()

function MissionManager:new(gc)
    self.cis = Find_Player("Rebel")
    self.republic = Find_Player("Empire")

    --Factional Missions
    if self.republic.Is_Human() then
        self.CISMissionsAI = CISMissionsAI(gc)
        self.RepublicMissions = RepublicMissions(gc)
    elseif self.cis.Is_Human() then
        self.CISMissions = CISMissions(gc)
        self.RepublicMissionsAI = RepublicMissionsAI(gc)
    end
end

function MissionManager:update()
    --Logger:trace("entering MissionManager:Update")
    if self.republic.Is_Human() then
        self.CISMissionsAI:update()
        self.RepublicMissions:update()
    elseif self.cis.Is_Human() then
        self.CISMissions:update()
        self.RepublicMissionsAI:update()
	end
end

return MissionManager
