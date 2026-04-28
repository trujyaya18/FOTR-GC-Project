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
--*   @Author:              [TR]Pox
--*   @Date:                2017-10-04T10:29:33+02:00
--*   @Project:             Imperial Civil War
--*   @Filename:            Prison.lua
--*   @Last modified by:    [TR]Pox
--*   @Last modified time:  2017-12-21T12:33:42+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************



require("PGStateMachine")

function Definitions()

    Define_State("State_Init", State_Init);
    Prisons = {}
end

function State_Init(message)

    if message == OnEnter then
        if Get_Game_Mode() ~= "Land" then
            ScriptExit()
        end

        local prisonTypes = {
            "Imperial_Prison_Facility",
            "Imperial_Prison_AetenII",
            "Imperial_Prison_Dathomir",
            "Imperial_Prison_Dathomir_Singing_Mountain",
            "Imperial_Prison_Dathomir_Frenzied_River",
            "Imperial_Prison_Dathomir_Misty_Falls",
            "Imperial_Prison_Kashyyyk"
        }

        for _, prisonType in pairs(prisonTypes) do
            local tempPrisons = Find_All_Objects_Of_Type(prisonType)
            if table.getn(tempPrisons) > 0  then
                for _, prisonObject in pairs(tempPrisons) do
                    if prisonObject.Get_Hull() > 0 then
                        table.insert(Prisons, prisonObject)
                    end
                end
            end
        end

        if table.getn(Prisons) == 0 then
            ScriptExit()
        else
            Object.Set_Garrison_Spawn(false)
        end

    elseif message == OnUpdate then

        for k, obj in pairs(Prisons) do
            if obj.Get_Hull() == 0 then
                table.remove(Prisons, k)
            end
        end

        if table.getn(Prisons) == 0 then
            Object.Set_Garrison_Spawn(true)
            ScriptExit()
        end
    end
end
