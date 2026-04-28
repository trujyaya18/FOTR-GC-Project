require("deepcore/std/class")
require("PGSpawnUnits")
StoryUtil = require("eawx-util/StoryUtil")

---@class TechHelper
TechHelper = class()

function TechHelper:new(gc)
	self.vsd_helper_fired = false
	self.bulwark_helper_fired = false
    self.is_active = false
	
	crossplot:subscribe("ERA4_BATTLESHIP_HELPER", self.Era_4, self)
	--crossplot:subscribe("VICTORY2_HELPER", self.VSD1, self)
	--crossplot:subscribe("BULWARK2_HELPER", self.BULWARK1, self)
end

function TechHelper:Era_4()
	--Logger:trace("entering TechHelper:Late_era")
	--if self.vsd_helper_fired then
		crossplot:publish("VICTORY2_RESEARCH", "empty")
	--else
		--self.vsd_helper_fired = true
	--end
	--if self.bulwark_helper_fired then
		crossplot:publish("BULWARK2_RESEARCH", "empty")
	--else
		--self.bulwark_helper_fired = true
	--end
end

function TechHelper:VSD1()
	--Logger:trace("entering TechHelper:VSD1")
	if not self.vsd_helper_fired then
		self.vsd_helper_fired = true
		if GlobalValue.Get("CURRENT_ERA") > 3 then
			crossplot:publish("VICTORY2_RESEARCH", "empty")
		end
	else
		crossplot:publish("VICTORY2_RESEARCH", "empty")
	end
end

function TechHelper:BULWARK1()
	--Logger:trace("entering TechHelper:BULWARK1")
	if not self.bulwark_helper_fired then
		self.bulwark_helper_fired = true
		if GlobalValue.Get("CURRENT_ERA") > 3 then
			crossplot:publish("BULWARK2_RESEARCH", "empty")
		end
	else
		crossplot:publish("BULWARK2_RESEARCH", "empty")
	end
end

return TechHelper
