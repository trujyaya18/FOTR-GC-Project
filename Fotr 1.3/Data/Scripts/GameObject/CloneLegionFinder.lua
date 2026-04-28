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
		local clone_skin = GlobalValue.Get("CLONE_DEFAULT")
		
		if Find_First_Object("Obi_Wan") or Find_First_Object("Obi_Wan2")
		or Find_First_Object("Cody") or Find_First_Object("Cody2") 
		then
			clone_skin = 2
		elseif Find_First_Object("Anakin") or Find_First_Object("Anakin2") or Find_First_Object("Vader")
		or Find_First_Object("Ahsoka") or Find_First_Object("Ahsoka2")
		or Find_First_Object("Rex") or Find_First_Object("Rex2")
		or Find_First_Object("Appo") or Find_First_Object("Appo2")
		or Find_First_Object("Bow") 
		or Find_First_Object("Vill")
		or Find_First_Object("Voca")
		then
			clone_skin = 3
		elseif Find_First_Object("Plo_Koon")
		or Find_First_Object("Wolffe") or Find_First_Object("Wolffe2") 
		then
			clone_skin = 4
		elseif Find_First_Object("Aayla_Secura") or Find_First_Object("Aayla_Secura2") 
		or Find_First_Object("Bly") or Find_First_Object("Bly2")
		or Find_First_Object("Deviss") or Find_First_Object("Deviss2")
		or Find_First_Object("Faie") 
		then
			clone_skin = 5
		elseif Find_First_Object("Mace_Windu") or Find_First_Object("Mace_Windu2") or Find_First_Object("Mace_Windu_AT_RT") 
		then
			clone_skin = 6
		elseif Find_First_Object("Bacara") or Find_First_Object("Bacara2")
		or Find_First_Object("Ki_Adi_Mundi") or Find_First_Object("Ki_Adi_Mundi2")
		or Find_First_Object("Jet") or Find_First_Object("Jet2")		
		then
			clone_skin = 7
		elseif Find_First_Object("Gree") or Find_First_Object("Gree2") 
		or Find_First_Object("Luminara_Unduli") or Find_First_Object("Luminara_Unduli2")
		or Find_First_Object("Yoda") or Find_First_Object("Yoda2")
		or Find_First_Object("Barriss_Offee") or Find_First_Object("Barriss_Offee2")
		then
			clone_skin = 8
		elseif Find_First_Object("Commander_71") or Find_First_Object("Commander_71_2") 
		then
			clone_skin = 1
		end
		
		if clone_skin == 2 then
			Hide_Sub_Object(Object, 1, "body_LOD0")
			Hide_Sub_Object(Object, 1, "body_LOD1")
			Hide_Sub_Object(Object, 1, "helmet_LOD0")
			Hide_Sub_Object(Object, 1, "helmet_LOD1")
			Hide_Sub_Object(Object, 0, "body_212_LOD0")
			Hide_Sub_Object(Object, 0, "body_212_LOD1")
			Hide_Sub_Object(Object, 0, "helmet_212_LOD0")
			Hide_Sub_Object(Object, 0, "helmet_212_LOD1")	
		elseif clone_skin == 3 then
			Hide_Sub_Object(Object, 1, "body_LOD0")
			Hide_Sub_Object(Object, 1, "body_LOD1")
			Hide_Sub_Object(Object, 1, "helmet_LOD0")
			Hide_Sub_Object(Object, 1, "helmet_LOD1")
			Hide_Sub_Object(Object, 0, "body_501_LOD0")
			Hide_Sub_Object(Object, 0, "body_501_LOD1")
			Hide_Sub_Object(Object, 0, "helmet_501_LOD0")
			Hide_Sub_Object(Object, 0, "helmet_501_LOD1")
		elseif clone_skin == 4 then
			Hide_Sub_Object(Object, 1, "body_LOD0")
			Hide_Sub_Object(Object, 1, "body_LOD1")
			Hide_Sub_Object(Object, 1, "helmet_LOD0")
			Hide_Sub_Object(Object, 1, "helmet_LOD1")
			Hide_Sub_Object(Object, 0, "body_104_LOD0")
			Hide_Sub_Object(Object, 0, "body_104_LOD1")
			Hide_Sub_Object(Object, 0, "helmet_104_LOD0")
			Hide_Sub_Object(Object, 0, "helmet_104_LOD1")
		elseif clone_skin == 5 then
			Hide_Sub_Object(Object, 1, "body_LOD0")
			Hide_Sub_Object(Object, 1, "body_LOD1")
			Hide_Sub_Object(Object, 1, "helmet_LOD0")
			Hide_Sub_Object(Object, 1, "helmet_LOD1")
			Hide_Sub_Object(Object, 0, "body_327_LOD0")
			Hide_Sub_Object(Object, 0, "body_327_LOD1")
			Hide_Sub_Object(Object, 0, "helmet_327_LOD0")
			Hide_Sub_Object(Object, 0, "helmet_327_LOD1")
		elseif clone_skin == 6 then
			Hide_Sub_Object(Object, 1, "body_LOD0")
			Hide_Sub_Object(Object, 1, "body_LOD1")
			Hide_Sub_Object(Object, 1, "helmet_LOD0")
			Hide_Sub_Object(Object, 1, "helmet_LOD1")
			Hide_Sub_Object(Object, 0, "body_187_LOD0")
			Hide_Sub_Object(Object, 0, "body_187_LOD1")
			Hide_Sub_Object(Object, 0, "helmet_187_LOD0")
			Hide_Sub_Object(Object, 0, "helmet_187_LOD1")
		elseif clone_skin == 7 then
			Hide_Sub_Object(Object, 1, "body_LOD0")
			Hide_Sub_Object(Object, 1, "body_LOD1")
			Hide_Sub_Object(Object, 1, "helmet_LOD0")
			Hide_Sub_Object(Object, 1, "helmet_LOD1")
			Hide_Sub_Object(Object, 0, "body_21_LOD0")
			Hide_Sub_Object(Object, 0, "body_21_LOD1")
			Hide_Sub_Object(Object, 0, "helmet_21_LOD0")
			Hide_Sub_Object(Object, 0, "helmet_21_LOD1")
		elseif clone_skin == 8 then
			Hide_Sub_Object(Object, 1, "body_LOD0")
			Hide_Sub_Object(Object, 1, "body_LOD1")
			Hide_Sub_Object(Object, 1, "helmet_LOD0")
			Hide_Sub_Object(Object, 1, "helmet_LOD1")
			Hide_Sub_Object(Object, 0, "body_41_LOD0")
			Hide_Sub_Object(Object, 0, "body_41_LOD1")
			Hide_Sub_Object(Object, 0, "helmet_41_LOD0")
			Hide_Sub_Object(Object, 0, "helmet_41_LOD1")
		end
		ScriptExit()
		
	end
end
