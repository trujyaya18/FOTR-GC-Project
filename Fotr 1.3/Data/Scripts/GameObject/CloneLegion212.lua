-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/interdictor.lua#3 $
--/////////////////////////////////////////////////////////////////////////////////////////////////
--
-- (C) Petroglyph Games, Inc.
--
--
--  *****           **                          *                   *
--  *   **          *                           *                   *
--  *    *          *                           *                   *
--  *    *          *     *                 *   *          *        *
--  *   *     *** ******  * **  ****      ***   * *      * *****    * ***
--  *  **    *  *   *     **   *   **   **  *   *  *    * **   **   **   *
--  ***     *****   *     *   *     *  *    *   *  *   **  *    *   *    *
--  *       *       *     *   *     *  *    *   *   *  *   *    *   *    *
--  *       *       *     *   *     *  *    *   *   * **   *   *    *    *
--  *       **       *    *   **   *   **   *   *    **    *  *     *   *
-- **        ****     **  *    ****     *****   *    **    ***      *   *
--                                          *        *     *
--                                          *        *     *
--                                          *       *      *
--                                      *  *        *      *
--                                      ****       *       *
--
--/////////////////////////////////////////////////////////////////////////////////////////////////
-- C O N F I D E N T I A L   S O U R C E   C O D E -- D O   N O T   D I S T R I B U T E
--/////////////////////////////////////////////////////////////////////////////////////////////////
--
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/interdictor.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: James_Yarrow $
--
--            $Change: 47639 $
--
--          $DateTime: 2006/06/30 09:59:28 $
--
--          $Revision: #3 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGStateMachine")


function Definitions()

	--MessageBox("script attached!")
	Define_State("State_Init", State_Init)

end

function State_Init(message)

	-- prevent this from doing anything in galactic mode
	--MessageBox("%s, mode %s", tostring(Script), Get_Game_Mode())
	if Get_Game_Mode() ~= "Land" then
		ScriptExit()
	end

		
	if message == OnEnter then
Hide_Sub_Object(Object, 1, "body_LOD0")
		Hide_Sub_Object(Object, 1, "body_LOD0")
		Hide_Sub_Object(Object, 1, "body_LOD1")
		Hide_Sub_Object(Object, 1, "helmet_LOD0")
		Hide_Sub_Object(Object, 1, "helmet_LOD1")
		Hide_Sub_Object(Object, 0, "body_212_LOD0")
		Hide_Sub_Object(Object, 0, "body_212_LOD1")
		Hide_Sub_Object(Object, 0, "helmet_212_LOD0")
		Hide_Sub_Object(Object, 0, "helmet_212_LOD1")	
		ScriptExit()
	end
end
