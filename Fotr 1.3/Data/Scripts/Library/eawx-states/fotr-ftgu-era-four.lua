return {
    on_enter = function(self, state_context)
        --Logger:trace("entering fotr-ftgu-era-four:on_enter")

        GlobalValue.Set("CURRENT_ERA", 4)

        self.entry_time = GetCurrentTime()
        self.EventsFired = false
        
    end,
    on_update = function(self, state_context)
        local current = GetCurrentTime() - self.entry_time
        if (current >=5) and (self.EventsFired == false) then
            self.EventsFired = true
            crossplot:publish("VENATOR_RESEARCH_FINISHED", "empty")
            crossplot:publish("PHASE_TWO_RESEARCH_FINISHED", "empty")
            crossplot:publish("BULWARK_RESEARCH_FINISHED", "empty")
            crossplot:publish("VICTORY_RESEARCH_FINISHED", "empty")
            crossplot:publish("VICTORY2_RESEARCH_FINISHED", "empty")
            crossplot:publish("BULWARK2_RESEARCH_FINISHED", "empty")
        end
    end,
    on_exit = function(self, state_context)
    end
}