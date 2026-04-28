require("deepcore/std/class")
require("eawx-plugins/fotr-governments/GovernmentRepublic")
require("eawx-plugins/fotr-governments/GovernmentCIS")

---@class GovernmentManager
GovernmentManager = class()

function GovernmentManager:new(gc, id)
    self.REPGOV = GovernmentRepublic(gc, id)
    self.CISGOV = GovernmentCIS(gc)
end

function GovernmentManager:update()
    self.REPGOV:Update()
    self.CISGOV:Update()
end

return GovernmentManager
