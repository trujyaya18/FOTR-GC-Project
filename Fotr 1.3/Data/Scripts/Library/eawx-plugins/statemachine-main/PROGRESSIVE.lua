require("deepcore/statemachine/DeepCoreState")

---@param dsl dsl
return function(dsl)
    local policy = dsl.policy
    local effect = dsl.effect
    local owned_by = dsl.conditions.owned_by

    local initialize = DeepCoreState.with_empty_policy()
    local setup = DeepCoreState(require("eawx-states/fotr-setup-state"))
    local bby_22 = DeepCoreState(require("eawx-states/fotr-progressive-era-two"))
    local bby_21 = DeepCoreState(require("eawx-states/fotr-progressive-era-three"))
    local bby_20 = DeepCoreState(require("eawx-states/fotr-progressive-era-four"))
    local bby_19 = DeepCoreState(require("eawx-states/fotr-progressive-era-five"))
	
    dsl.transition(initialize)
        :to(setup)
        :when(policy:timed(2))
        :end_()

    dsl.transition(setup)
        :to(bby_22)
        :when(policy:global_era(2))
        :end_()

    dsl.transition(setup)
        :to(bby_21)
        :when(policy:global_era(3))
        :end_()

    dsl.transition(setup)
        :to(bby_20)
        :when(policy:global_era(4))
        :end_()

    dsl.transition(setup)
        :to(bby_19)
        :when(policy:global_era(5))
        :end_()
	
	
	dsl.transition(bby_22)
        :to(bby_21)
        :when(policy:timed(480))
        :with_effects(
            effect:eawx_set_tech_level(3)
            :for_factions({"Rebel", "Empire", "Banking_Clan", "Techno_Union", "Trade_Federation", "Commerce_Guild", "EARLY_IMPERIAL"})
        ):end_()
    
    dsl.transition(bby_21)
        :to(bby_20)
        :when(policy:timed(960))
        :with_effects(
            effect:eawx_set_tech_level(4)
            :for_factions({"Rebel", "Empire", "Banking_Clan", "Techno_Union", "Trade_Federation", "Commerce_Guild", "EARLY_IMPERIAL"})
        ):end_()

    dsl.transition(bby_20)
        :to(bby_19)
        :when(policy:timed(960))
        :with_effects(
            effect:eawx_set_tech_level(5)
            :for_factions({"Rebel", "Empire", "Banking_Clan", "Techno_Union", "Trade_Federation", "Commerce_Guild", "EARLY_IMPERIAL"})
        ):end_()
        
    return initialize
end
