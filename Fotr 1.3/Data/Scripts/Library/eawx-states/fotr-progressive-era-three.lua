require("eawx-util/StoryUtil")
require("eawx-util/UnitUtil")
require("PGStoryMode")
require("PGSpawnUnits")

return {
    on_enter = function(self, state_context)
        --Logger:trace("entering fotr-progressive-era-three:on_enter")
        GlobalValue.Set("CURRENT_ERA", 3)
     
        self.Active_Planets = StoryUtil.GetSafePlanetTable()
        self.entry_time = GetCurrentTime()
        self.StaticFleets = false
        self.MandaloreFired = false


        if self.entry_time <= 5 then
            if Find_Player("local") == Find_Player("Empire") then

                StoryUtil.Multimedia("TEXT_STORY_INTRO_PROGRESSIVE_REPUBLIC_PALPATINE_ERA_3", 15, nil, "PalpatineFotR_Loop", 0)
            elseif Find_Player("local") == Find_Player("Rebel") then

                StoryUtil.Multimedia("TEXT_STORY_INTRO_PROGRESSIVE_CIS_DOOKU_ERA_3", 15, nil, "Dooku_Loop", 0)
            end

            self.StaticFleets = true
            self.Starting_Spawns = require("eawx-mod-fotr/spawn-sets/EraThreeStartSet")
            for faction, herolist in pairs(self.Starting_Spawns) do
                for planet, spawnlist in pairs(herolist) do
                    StoryUtil.SpawnAtSafePlanet(planet, Find_Player(faction), self.Active_Planets, spawnlist)  
                end
            end

            
        else
            self.Starting_Spawns = require("eawx-mod-fotr/spawn-sets/EraThreeProgressSet")
            for faction, herolist in pairs(self.Starting_Spawns) do
                for planet, spawnlist in pairs(herolist) do
                    StoryUtil.SpawnAtSafePlanet(planet, Find_Player(faction), self.Active_Planets, spawnlist)  
                end
            end
			
			UnitUtil.ReplaceAtLocation("Yoda", "Yoda_Eta_Team")
			UnitUtil.ReplaceAtLocation("Mace_Windu", "Mace_Windu_Eta_Team")
			UnitUtil.ReplaceAtLocation("Obi_Wan", "Obi_Wan_Eta_Team")
			UnitUtil.ReplaceAtLocation("Anakin", "Anakin_Eta_Team")
			UnitUtil.ReplaceAtLocation("Kit_Fisto", "Kit_Fisto_Eta_Team")
			UnitUtil.ReplaceAtLocation("Aayla_Secura", "Aayla_Secura_Eta_Team")
			UnitUtil.ReplaceAtLocation("Ki_Adi_Mundi", "Ki_Adi_Mundi_Eta_Team")
			UnitUtil.ReplaceAtLocation("Luminara_Unduli", "Luminara_Unduli_Eta_Team")
			UnitUtil.ReplaceAtLocation("Barriss_Offee", "Barriss_Offee_Eta_Team")
			UnitUtil.ReplaceAtLocation("Shaak_Ti", "Shaak_Ti_Eta_Team")
			UnitUtil.ReplaceAtLocation("Ahsoka", "Ahsoka_Eta_Team")
			
			crossplot:publish("ERA_THREE_TRANSITION", "empty")
        end
    
    end,
    on_update = function(self, state_context)
        local current = GetCurrentTime() - self.entry_time
        if (current >=5) and (self.StaticFleets == true) then
            self.StaticFleets = false
            local static_spawns = require("eawx-mod-fotr/spawn-sets/EraThreeStaticFleetSet")
            for faction, unitlist in pairs(static_spawns) do
                if (Find_Player(faction) == Find_Player("EMPIRE")) and (Find_Player("REBEL").Is_Human()) then
                    for planet, spawnlist in pairs(unitlist) do
                        if self.Active_Planets[planet] then
                            StoryUtil.SpawnAtSafePlanet(planet, Find_Player(faction), self.Active_Planets, spawnlist, false)  
                        end
                    end
                elseif (Find_Player(faction) ~= Find_Player("EMPIRE")) and (Find_Player("EMPIRE").Is_Human()) then
                    for planet, spawnlist in pairs(unitlist) do
                        if self.Active_Planets[planet] then
                            StoryUtil.SpawnAtSafePlanet(planet, Find_Player(faction), self.Active_Planets, spawnlist, false)  
                        end
                    end
                end
            end

            crossplot:publish("VENATOR_RESEARCH_FINISHED", "empty")
        end

        if self.Active_Planets["MANDALORE"] and self.MandaloreFired == false then
			if FindPlanet("Mandalore").Get_Owner() == Find_Player("REBEL") and (current >= 40) then
				crossplot:publish("CIS_MANDALORE_SUPPORT_START", "empty")
                self.MandaloreFired = true
			end
		end


    end,
    on_exit = function(self, state_context)
    end
}