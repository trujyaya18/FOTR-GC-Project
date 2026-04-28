--******************************************************************************
--     _______ __
--    |_     _|  |--.----.---.-.--.--.--.-----.-----.
--      |   | |     |   _|  _  |  |  |  |     |__ --|
--      |___| |__|__|__| |___._|________|__|__|_____|
--     ______
--    |   __ \.-----.--.--.-----.-----.-----.-----.
--    |      <|  -__|  |  |  -__|     |  _  |  -__|
--    |___|__||_____|\___/|_____|__|__|___  |_____|
--                                    |_____|
--*   @Author:              [TR]Jorritkarwehr
--*   @Date:                2018-03-20T01:27:01+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            UnitSwitcher.lua
--*   @Last modified by:    Nojembre
--*   @Last modified time:  
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************


require("PGStateMachine")
require("PGSpawnUnits")
require("UnitSwitcherLibrary")
require("SetFighterResearch")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))

    Define_State("State_Init", State_Init);
end


function State_Init(message)
    if message == OnEnter then	
		if Get_Game_Mode() ~= "Galactic" then
			ScriptExit()
		end
		
		local swap_entry = Get_Swap_Entry(tostring(Object.Get_Type().Get_Name()))
		
		if swap_entry == nil then
			Object.Despawn()
			ScriptExit()
		end
		
		local old_unit = swap_entry[1]
		local new_unit = swap_entry[2]
		
		local locale = Object.Get_Planet_Location()
		
		if old_unit == nil then
			ReplaceSpawn = SpawnList(new_unit, locale, Object.Get_Owner(),true,false)
		else
			local checkObject
			
			if swap_entry.location_check then
				checkArray = Find_All_Objects_Of_Type(old_unit)
			
				for _, checks in pairs(checkArray) do
					if checks.Get_Planet_Location() == locale then
						checkObject = checks
						break
					end
				end
			else
				checkObject = Find_First_Object(old_unit)
			end
			
			if TestValid(checkObject) then
				checkObject.Despawn()
				spawn_list_new = { new_unit }
				ReplaceSpawn = SpawnList(spawn_list_new, locale, Object.Get_Owner(),true,false)
				Transfer_Fighter_Hero(old_unit, new_unit)
			end
		end
		
		Object.Despawn()
		
		ScriptExit()
	end
end
