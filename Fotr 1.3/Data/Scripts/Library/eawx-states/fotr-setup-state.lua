require("deepcore/crossplot/crossplot")
require("eawx-util/StoryUtil")

return {
    on_enter = function(self, state_context)
        --Logger:trace("entering fotr-setup-state:on_enter")
        crossplot:publish("INITIALIZE_AI", "empty")

        if Find_Player("Empire").Get_Tech_Level() == 1 then
            StoryUtil.SetTechLevel(Find_Player("Empire"), 2)
            StoryUtil.SetTechLevel(Find_Player("Rebel"), 1)
        end

        if Find_Player("Empire").Get_Tech_Level() == 4 then
            StoryUtil.SetTechLevel(Find_Player("Empire"), 5)
            StoryUtil.SetTechLevel(Find_Player("Rebel"), 4)
        end
    end,
    on_update = function(self, state_context)
    end,
    on_exit = function(self, state_context)
        local placeholder_table = Find_All_Objects_Of_Type("Placement_Dummy")
        for i, unit in pairs(placeholder_table) do
            unit.Despawn()
        end
    end
}