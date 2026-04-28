require("deepcore/std/class")
require("StandardFighterLibrary")

---@class FighterSpawn
FighterSpawn = class()

function FighterSpawn:new(unit_entry)
    self.is_active = true

    ---@private
    self.unit_entry = unit_entry

    ---@private
    self.object_name = Object.Get_Type().Get_Name()

    ---@private
    self.fighter_data = unit_entry.Fighters

    ---@private
    ---@type PlayerObject
    self.original_owner = Object.Get_Owner()

    ---@private
    self.restoreTable = {}

    ---@private
    self.spawned_fighers = self:get_initial_fighters(self.fighter_data) or {}

    ---@private
    self.fighters_docking = false
end

function FighterSpawn:update()
    if not self.is_active then
        return
    end

    if not self:has_hangar() then
        self.is_active = false
        Cancel_Timer(self.spawn)
        return
    end

    if self.fighters_docking then
        self:despawn_squadrons_in_range()
    end

    self:check_fighters()
end

function FighterSpawn:has_hangar()
    local hasHangarFlag = false
    if self.unit_entry.Flags then
        hasHangarFlag = self.unit_entry.Flags.HANGAR
    end
    return hasHangarFlag or EvaluatePerception("Has_Hangar", Object.Get_Owner(), Object) == 1
end

function FighterSpawn:all_fighters_docked()
    return table.getn(self.spawned_fighers) == 0
end

function FighterSpawn:dock_fighters()
    for i, squadronTable in pairs(self.spawned_fighers) do
        if TestValid(squadronTable.Squadron) then
            squadronTable.Squadron.Set_Selectable(false)
            squadronTable.Squadron.Move_To(Object)
        end
    end

    self.fighters_docking = true
end

function FighterSpawn:release_fighters()
    local fighterTable = self.fighter_data
    self.fighters_docking = false
    self:make_fighters_selectable()
    for squadronTable, amount in pairs(self.restoreTable) do
        local fighterEntry
		local tab = fighterTable[squadronTable.RefString]
		local owner = Object.Get_Owner().Get_Faction_Name()
		local gameConstants = ModContentLoader.get("GameConstants")
		local alias = gameConstants.ALIASES[owner]
		if tab[owner] then
			fighterEntry = tab[owner]
		elseif tab[alias] then
			fighterEntry = tab[alias]
		else
			fighterEntry = tab["DEFAULT"]
		end
        fighterEntry.Reserve = fighterEntry.Reserve + amount
        table.insert(self.spawned_fighers, squadronTable)
        self.restoreTable[squadronTable] = nil
    end
end

---@private
function FighterSpawn:despawn_squadrons_in_range()
    for i, squadronTable in pairs(self.spawned_fighers) do
        if TestValid(squadronTable.Squadron) then
            local distanceFactor = self:get_distance_factor()
            if squadronTable.Squadron.Get_Distance(Object) <= (400 * distanceFactor) then
                self:store_squadron(squadronTable)
                squadronTable.Squadron.Despawn()
                table.remove(self.spawned_fighers, i)
            end
        end
    end

    if table.getn(self.spawned_fighers) == 0 then
        self.fighters_docking = false
    end
end

function FighterSpawn:despawn_all_squadrons()
    for i, squadronTable in pairs(self.spawned_fighers) do
        if TestValid(squadronTable.Squadron) then
            squadronTable.Squadron.Despawn()
        end
    end
end

---@private
function FighterSpawn:store_squadron(squadronTable)
    if not self.restoreTable[squadronTable] then
        self.restoreTable[squadronTable] = 0
    end
    self.restoreTable[squadronTable] = self.restoreTable[squadronTable] + 1
end

---@private
function FighterSpawn:make_fighters_selectable()
    for i, squadronTable in pairs(self.spawned_fighers) do
        if TestValid(squadronTable.Squadron) then
            squadronTable.Squadron.Set_Selectable(true)
        end
    end
end

---@private
function FighterSpawn:check_fighters()
    for i, data in pairs(self.spawned_fighers) do
        if not data.Squadron or not TestValid(data.Squadron) then
            local delay = 15
            if self.unit_entry.Flags then
                if self.unit_entry.Flags.RAPIDDEPLOY then
                     delay = 1
                end
            end
            Register_Timer(self.spawn, delay, {self, data})
            table.remove(self.spawned_fighers, i)
        end
    end
end

---@private
function FighterSpawn:get_initial_fighters(fighter_data)
    local initial_fighters = {}
	local heroes = GlobalValue.Get("HERO_FIGHTERS")
	local hosts = GlobalValue.Get("HERO_FIGHTER_HOSTS")
	if heroes ~= nil then
		for index, obj in pairs(hosts) do
			if obj == self.object_name then
				fighter_data[heroes[index]] = {["DEFAULT"] = {Initial = 1, Reserve = 0}}
			end
		end
	end
		
    for type_string, tab in pairs(fighter_data) do
        local entry = self:get_fighter_entry(tab)
        if entry then
			local type_string_new = type_string
			if entry.HeroOverride then
				for i, hero in pairs(entry.HeroOverride[1]) do
					local checkHero = Find_First_Object(hero)
					if TestValid(checkHero) then
						type_string_new = entry.HeroOverride[2][i]
						break
					end
				end
			end
			local type_string_new = self:evaluate_standard_fighters(type_string_new)
            local squadronType = Find_Object_Type(type_string_new)
            entry.Reserve = entry.Reserve + entry.Initial
            for i = 1, entry.Initial do
                table.insert(initial_fighters, {Squadron = nil, ObjectType = squadronType, TypeString = type_string_new, RefString = type_string})
            end
        end
    end

    return initial_fighters
end

---@private
function FighterSpawn:get_fighter_entry(tab)
    local owner = self.original_owner
    local ownerName = owner.Get_Faction_Name()
    local gameConstants = ModContentLoader.get("GameConstants")
    local alias = gameConstants.ALIASES[ownerName]

    local fighter_tab
    if tab[ownerName] then
        fighter_tab = tab[ownerName]
    elseif alias and tab[alias] then
        fighter_tab = tab[alias]
    elseif tab["DEFAULT"] then
        fighter_tab = tab["DEFAULT"]
    else
        return nil
    end

    local techLevel = GlobalValue.Get("CURRENT_ERA")
	if not techLevel then
		return
	else
		local techIsEqual = (fighter_tab.TechLevel == nil) or (fighter_tab.TechLevel:evaluate(techLevel))
		if techIsEqual then
			techIsEqual = (fighter_tab.ResearchType == nil) or self:evaluate_research(fighter_tab.ResearchType)
			if techIsEqual then
				return fighter_tab
			end
		end
	end

    return nil
end

---@private
function FighterSpawn:get_distance_factor()
    local typeFlags = self.unit_entry.Flags
    if not typeFlags then
        return 1.0
    end

    return (typeFlags.FighterDespawnFactor or 1.0)
end

---@private
function FighterSpawn.spawn(wrapper)
    local self = wrapper[1]
    local data = wrapper[2]
    local objectType = data.ObjectType
	local RefString = data.RefString
	local TypeString = data.TypeString
    local tab = self.fighter_data[data.RefString]
    local entry = self:get_fighter_entry(tab)
    local shipyard = false
    if self.unit_entry.Flags then
        if self.unit_entry.Flags.SHIPYARD then
            shipyard = true
        end
    end

    local location = Object.Get_Bone_Position("root")
    if shipyard == true then
        location = Find_First_Object("SPACE STATION POSITION")
    end

    if not entry then
        DebugMessage(
            "Could not find Fighter Entry for %s on Carrier %s",
            tostring(objectType.Get_Name()),
            tostring(self.object_name)
        )
        return
    end

    if entry.Reserve > 0 then
		local fighterType = Find_Object_Type(TypeString)
        local squadron = Spawn_Unit(fighterType, location, Object.Get_Owner(), true, false)[1]
		if not (squadron.Is_Category("Fighter") or squadron.Is_Category("Bomber")) then
			squadron.Cinematic_Hyperspace_In(1)
		end
		
        data.Squadron = squadron
        table.insert(self.spawned_fighers, data)
        entry.Reserve = entry.Reserve - 1
    end
end

function FighterSpawn:evaluate_research(rtable)
	local levels = GlobalValue.Get("FIGHTER_RESEARCH")
	if type(rtable) ~= "table" then
		rtable = {rtable}
	end
	
	for i, rtype in pairs(rtable) do
		local isNegative = false
		local truthDeferred = false
		local containCheck = string.find(rtype, "~")
		if containCheck ~= nil then
			isNegative = true
			rtype = string.gsub(rtype, "~", "")
		end
		if levels == nil then
			if not isNegative then
				return false
			end
		else
			for index, obj in pairs(levels) do
				if obj == rtype then
					if isNegative then
						return false
					else
						truthDeferred = true
						break
					end
				end
			end
		end
		if not truthDeferred and not isNegative then
			return false
		end
	end
	return true
end

function FighterSpawn:evaluate_standard_fighters(fighterType)
	local containCheck = string.find(fighterType, "STANDARD_")
	if containCheck ~= nil then
		local region
		
		repeat    
		-- The AI may not yet be initialized
		Sleep(1)
		region = Evaluate_In_Galactic_Context("Regional_Fighter_Planets", self.original_owner)
		until (region ~= nil)
		
		local influence = Evaluate_In_Galactic_Context("Planet_Influence_Value", self.original_owner)
	
		local suffix = ""
		local squadronName = fighterType
		containCheck = string.find(squadronName, "_HALF")
		if containCheck ~= nil then
			suffix = "_HALF"
			squadronName = string.gsub(squadronName, suffix, "")
		end
		containCheck = string.find(squadronName, "_DOUBLE")
		if containCheck ~= nil then
			suffix = "_DOUBLE"
			squadronName = string.gsub(squadronName, suffix, "")
		end
		containCheck = string.find(squadronName, "_TRIPLE")
		if containCheck ~= nil then
			suffix = "_TRIPLE"
			squadronName = string.gsub(squadronName, suffix, "")
		end
		
		squadronName = Get_Standard_Entry(squadronName, self.original_owner.Get_Faction_Name(), GlobalValue.Get("CURRENT_ERA"), region, influence)
		return squadronName .. suffix
	end
	return fighterType
end

return FighterSpawn
