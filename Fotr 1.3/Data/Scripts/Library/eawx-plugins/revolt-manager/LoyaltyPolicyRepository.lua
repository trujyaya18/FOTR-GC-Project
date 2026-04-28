LoyaltyPolicyRepository = {
    DEFAULT = function(planet)
        local preferred_owner = Find_Player("Independent_Forces")

        return preferred_owner
    end
}


---@param planet Planet
function LoyaltyPolicyRepository.kashyyyk(planet)
    local preferred_owner = Find_Player("Empire")
    if planet:get_owner() == Find_Player("Empire") then
        preferred_owner = Find_Player("Independent_Forces")
    end

    return preferred_owner
end

---@param planet Planet
function LoyaltyPolicyRepository.geonosis(planet)
    local preferred_owner = Find_Player("Rebel")
    if planet:get_owner() == Find_Player("Rebel") then
        preferred_owner = Find_Player("Independent_Forces")
    end

    return preferred_owner
end



