require("deepcore/std/class")
require("PGSpawnUnits")
StoryUtil = require("eawx-util/StoryUtil")

---@class GenericConquer
GenericConquer = class()

function GenericConquer:new(gc, event_name, planet, player, spawn_list, show_holocron, movie_name, unlock_list, lock_list, chained_effect)
    --Logger:trace("entering GenericConquer:new")
    self.is_complete = false
    self.is_active = false
    self.plot = Get_Story_Plot("Conquests\\Events\\EventLogRepository.XML")

    self.Planets = gc.Planets

    self.show_holocron = show_holocron

    if movie_name then
        self.movie_name = movie_name
    else
        self.movie_name = " "
    end

    self.planet_name = planet
    self.planet_object = FindPlanet(planet)

    self.Start_Text = "TEXT_SPEECH_" .. tostring(event_name)

    if player ~= nil then
        self.ForPlayer = Find_Player(player)
    else
        self.ForPlayer = nil
    end

    self.ConqueringPlayer = nil

    self.HumanPlayer = Find_Player("local")

    self.Story_Tag = event_name

    if unlock_list ~= nil then
        self.Unlock_Types = unlock_list
    end

    if lock_list ~= nil then
        self.Lock_Types = lock_list
    end

    if spawn_list ~=nil then
        self.Spawn_Types = spawn_list
        self.Spawn_Planet = FindPlanet(planet)
    end

    self.Chained_Event = chained_effect

    crossplot:subscribe(self.Story_Tag, self.activate, self)
    crossplot:subscribe(self.Story_Tag.."_FINISHED", self.fulfil, self)
    crossplot:subscribe(self.Story_Tag.."_FAILED", self.fail, self)

    self.planet_owner_changed_event = gc.Events.PlanetOwnerChanged
    self.planet_owner_changed_event:attach_listener(self.planet_owner_changed, self)
    
end

function GenericConquer:activate()
    --Logger:trace("entering GenericConquer:activate")
    if (self.is_complete == false) and (self.is_active == false) then
        self.is_active = true

        if self.ForPlayer == self.HumanPlayer then
            if self.show_holocron == true then
                StoryUtil.Multimedia(self.Start_Text.."_STARTED", 15, nil, " ", 0)
                local plot = self.plot
                Story_Event(self.Story_Tag.."_STARTED")
            end
        end
    end
end

function GenericConquer:planet_owner_changed(planet, new_owner_name, old_owner_name)
    --Logger:trace("entering GenericConquer:planet_owner_changed")
    if self.is_active == true then
        if planet:get_name() ~= self.planet_name then
            return
        else
            if self.ForPlayer ~= nil then
                if Find_Player(new_owner_name) == self.ForPlayer then
                    self:fulfil()
                else
                    self:fail()
                end
            else
                self.ForPlayer = Find_Player(new_owner_name)
                self:fulfil()
            end
        end
    else
        return
    end
end

function GenericConquer:fulfil()
    --Logger:trace("entering GenericConquer:fulfil")
    if self.is_complete == false then
        self.is_complete = true



        if self.Unlock_Types ~= nil then
            for _, unit in pairs(self.Unlock_Types) do
                self.ForPlayer.Unlock_Tech(Find_Object_Type(unit))
            end
        end
    
        if self.Lock_Types ~= nil then
            for _, unit in pairs(self.Lock_Types) do
                self.ForPlayer.Lock_Tech(Find_Object_Type(unit))
            end
        end

        if self.Spawn_Planet ~= nil then

            if not StoryUtil.CheckFriendlyPlanet(self.Spawn_Planet,self.ForPlayer) then
                self.Spawn_Planet = StoryUtil.FindFriendlyPlanet(self.ForPlayer)
            end
            if self.Spawn_Types ~= nil then
                local spawn = SpawnList(self.Spawn_Types, self.Spawn_Planet, self.ForPlayer, true, false)
            end 
        end

        if self.is_active == true then
            if self.ForPlayer == self.HumanPlayer then
                StoryUtil.Multimedia(self.Start_Text.."_FINISHED", 15, nil, self.movie_name, 0)
                local plot = self.plot
                Story_Event(self.Story_Tag.."_COMPLETED")
            end
        end

        if self.Chained_Event ~= nil then
            for _, event in pairs(self.Chained_Event) do
                crossplot:publish(event, "empty")
            end
        end
    end
end

function GenericConquer:fail()
    --Logger:trace("entering GenericConquer:fail")

    if self.is_complete == false then
        self.is_complete = true
        
        if self.is_active == true then
            if self.ForPlayer == self.HumanPlayer then
                if self.show_holocron == true then

                    StoryUtil.Multimedia(self.Start_Text.."_FAILED", 15, nil, " ", 0)
                    local plot = self.plot
                    Story_Event(self.Story_Tag.."_COMPLETED")
                end
            end
        end

        self.planet_owner_changed_event:detach_listener(self.planet_owner_changed)

    end

end

return GenericConquer
