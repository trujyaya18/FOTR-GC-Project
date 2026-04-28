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
require("HeroFighterLibrary")
require("SetFighterResearch")
StoryUtil = require("eawx-util/StoryUtil")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))

    Define_State("State_Init", State_Init);
end


function State_Init(message)
    if message == OnEnter then	
		if Get_Game_Mode() ~= "Galactic" then
        ScriptExit()
    end
	
	--StoryUtil.ShowScreenText("Init", 5)
	
	local hero_entry = Get_Hero_Entry(tostring(Object.Get_Type().Get_Name()))
	
	if hero_entry == nil then
		--StoryUtil.ShowScreenText("nil", 5)
		Object.Despawn()
		ScriptExit()
	end
	
	local locale = Object.Get_Planet_Location()
	
	for index, obj in pairs(hero_entry.Locations) do
		StoryUtil.ShowScreenText(obj, 5)
		checkObject = Find_First_Object(obj)
		if TestValid(checkObject) then
			if locale == checkObject.Get_Planet_Location() then
				Set_Fighter_Hero(hero_entry.Hero_Squadron, obj)
				StoryUtil.ShowScreenText("Assigned", 5)
				Object.Despawn()
				ScriptExit()
			end
		end
	end
	
	Object.Despawn()
	
    ScriptExit()
    end
end
