-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/Library/PGAICommands.lua#2 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/Library/PGAICommands.lua $
--
--    Original Author: Brian Hayes
--
--            $Author: James_Yarrow $
--
--            $Change: 57990 $
--
--          $DateTime: 2006/11/13 17:33:10 $
--
--          $Revision: #2 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGCommands")

function Base_Definitions()
	-- DebugMessage("%s -- In Base_Definitions", tostring(Script))

	InSpaceConflict = false
	MagicPlan = false
	
	-- Scale all counter forces by this factor
	MinContrastScale = 1.0
	MaxContrastScale = 1.2
	PerFailureContrastAdjust = 0.1
	EnemyContrastTypes = {}
	FriendlyContrastTypes = {}
	ContrastTypeScale = {}

	-- Track abilities that got cancelled (nebula or whatever) so we can turn them on later
	lib_cancelled_abilities = {}

	Common_Base_Definitions()

	-- nil out the global Taskforce variables.
	if TaskForce and type(TaskForce) == "table" then
		for idx,tfdef in pairs(TaskForce) do
         if type(tfdef) == "table" and type(tfdef[1]) == "string" then
				_G[tfdef[1]] = nil
			end
		end
	end
	
	if PlanDefinitionLoad then
		Set_Contrast_Values()
	end

	PlanDefinitionLoad = nil
	
	if Definitions then
		Definitions()
	end
end

function Set_Contrast_Values()
	DebugMessage("%s -- Setting AI contrast values", tostring(Script))

	_e_cnt = 1;

	EnemyContrastTypes[_e_cnt] = "Fighter"
	FriendlyContrastTypeNames = {"AntiFighter", "Bomber", "Fighter", "Corvette", "Frigate", "Capital", "SuperCapital", "SpaceHero", "AntiBomber", "AntiCorvette", "AntiFrigate", "AntiCapital"}
	FriendlyContrastWeights =	{1.5, 0.25, 1.0, 1.25, 0.95, 0.95, 0.95, 0.95, 1.1, 0.0, 0.0, 0.0}
	FriendlyContrastTypes[_e_cnt] = WeightedTypeList.Create()
	FriendlyContrastTypes[_e_cnt].Parse(FriendlyContrastTypeNames, FriendlyContrastWeights)	
	_e_cnt = _e_cnt+1;
	
	EnemyContrastTypes[_e_cnt] = "Bomber"
	FriendlyContrastTypeNames = {"AntiBomber", "Fighter", "Bomber", "Corvette", "Frigate", "Capital", "SuperCapital", "SpaceHero", "AntiFighter", "AntiCorvette", "AntiFrigate", "AntiCapital"}
	FriendlyContrastWeights =	{1.5, 1.25, 1.0, 1.25, 0.5, 0.25, 0.25, 0.95, 1.2, 0.0, 0.0, 0.0}
	FriendlyContrastTypes[_e_cnt] = WeightedTypeList.Create()
	FriendlyContrastTypes[_e_cnt].Parse(FriendlyContrastTypeNames, FriendlyContrastWeights)	
	_e_cnt = _e_cnt+1;

	EnemyContrastTypes[_e_cnt] = "Transport"
	FriendlyContrastTypeNames = {"Fighter", "Bomber", "Corvette", "Frigate", "Capital", "SuperCapital", "SpaceHero"}
	FriendlyContrastWeights =	{2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0}
	FriendlyContrastTypes[_e_cnt] = WeightedTypeList.Create()
	FriendlyContrastTypes[_e_cnt].Parse(FriendlyContrastTypeNames, FriendlyContrastWeights)	
	_e_cnt = _e_cnt+1;

	EnemyContrastTypes[_e_cnt] = "Corvette"
	FriendlyContrastTypeNames = {"AntiCorvette", "Fighter", "Bomber", "Corvette", "Frigate", "Capital", "SuperCapital", "SpaceHero", "AntiFighter", "AntiBomber", "AntiFrigate", "AntiCapital"}
	FriendlyContrastWeights =	{1.5, 0.25, 0.25, 1.0, 1.25, 1.0, 1.0, 1.25, 0.0, 0.0, 0.2, 0.2}
	FriendlyContrastTypes[_e_cnt] = WeightedTypeList.Create()
	FriendlyContrastTypes[_e_cnt].Parse(FriendlyContrastTypeNames, FriendlyContrastWeights)	
	_e_cnt = _e_cnt+1;
	
	EnemyContrastTypes[_e_cnt] = "Frigate"
	FriendlyContrastTypeNames = {"AntiFrigate", "Corvette", "Fighter", "Bomber", "Frigate", "Capital", "SuperCapital", "SpaceHero", "AntiFighter", "AntiBomber", "AntiCorvette", "AntiCapital"}
	FriendlyContrastWeights =	{1.5, 0.5, 0.25, 1.0, 1.0, 1.25, 1.0, 1.25, 0.0, 0.0, 0.2, 0.2}
	FriendlyContrastTypes[_e_cnt] = WeightedTypeList.Create()
	FriendlyContrastTypes[_e_cnt].Parse(FriendlyContrastTypeNames, FriendlyContrastWeights)	
	_e_cnt = _e_cnt+1;

	EnemyContrastTypes[_e_cnt] = "Capital"
	FriendlyContrastTypeNames = {"AntiCapital", "Corvette", "Frigate", "Fighter", "Bomber", "Capital", "SuperCapital", "SpaceHero", "AntiFighter", "AntiBomber", "AntiCorvette", "AntiFrigate"}
	FriendlyContrastWeights =	{1.5, 0.25, 0.5, 0.25, 1.0, 1.0, 1.25, 1.25, 0.0, 0.0, 0.2, 0.2}
	FriendlyContrastTypes[_e_cnt] = WeightedTypeList.Create()
	FriendlyContrastTypes[_e_cnt].Parse(FriendlyContrastTypeNames, FriendlyContrastWeights)	
	_e_cnt = _e_cnt+1;
	
	EnemyContrastTypes[_e_cnt] = "SuperCapital"
	FriendlyContrastTypeNames = {"AntiCapital", "Corvette", "Frigate", "Fighter", "Bomber", "Capital", "SuperCapital", "SpaceHero", "AntiFighter", "AntiBomber", "AntiCorvette", "AntiFrigate"}
	FriendlyContrastWeights =	{1.25, 0.25, 0.5, 0.25, 1.25, 0.75, 0.75, 1.25, 0.0, 0.0, 0.2, 0.2}
	FriendlyContrastTypes[_e_cnt] = WeightedTypeList.Create()
	FriendlyContrastTypes[_e_cnt].Parse(FriendlyContrastTypeNames, FriendlyContrastWeights)	
	_e_cnt = _e_cnt+1;
	
	EnemyContrastTypes[_e_cnt] = "SpaceStructure"
	FriendlyContrastTypeNames = {"AntiCapital", "Corvette", "Frigate", "Fighter", "Bomber", "Capital", "SuperCapital", "SpaceHero", "AntiFighter", "AntiBomber"}
	FriendlyContrastWeights =	{3.0, 1.0, 2.0, 1.0, 2.5, 2.5, 2.5, 2.5, 0.0, 0.0}
	FriendlyContrastTypes[_e_cnt] = WeightedTypeList.Create()
	FriendlyContrastTypes[_e_cnt].Parse(FriendlyContrastTypeNames, FriendlyContrastWeights)	
	_e_cnt = _e_cnt+1;
	
	EnemyContrastTypes[_e_cnt] = "SpaceHero"
	FriendlyContrastTypeNames = {"Corvette", "Frigate", "Fighter", "Bomber", "Capital", "SuperCapital", "SpaceHero"}
	FriendlyContrastWeights =	{0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 1.0}
	FriendlyContrastTypes[_e_cnt] = WeightedTypeList.Create()
	FriendlyContrastTypes[_e_cnt].Parse(FriendlyContrastTypeNames, FriendlyContrastWeights)	
	_e_cnt = _e_cnt+1;
	
	EnemyContrastTypes[_e_cnt] = "Infantry"
	FriendlyContrastTypeNames = {"AntiInfantry", "Vehicle", "Infantry", "Air", "LandHero", "AntiVehicle", "AntiAir", "AntiStructure"}
	FriendlyContrastWeights =	{1.5, 1.0, 1.0, 0.75, 2.0, 0.5, 0.25, 0.75}
	FriendlyContrastTypes[_e_cnt] = WeightedTypeList.Create()
	FriendlyContrastTypes[_e_cnt].Parse(FriendlyContrastTypeNames, FriendlyContrastWeights)	
	_e_cnt = _e_cnt+1;
	
	EnemyContrastTypes[_e_cnt] = "Vehicle"
	FriendlyContrastTypeNames = {"AntiVehicle", "Infantry", "Vehicle", "Air", "LandHero", "AntiInfantry", "AntiAir", "AntiStructure"}
	FriendlyContrastWeights =	{1.5, 0.75, 1.0, 1.0, 2.0, 0.5, 0.25, 0.5}
	FriendlyContrastTypes[_e_cnt] = WeightedTypeList.Create()
	FriendlyContrastTypes[_e_cnt].Parse(FriendlyContrastTypeNames, FriendlyContrastWeights)	
	_e_cnt = _e_cnt+1;

	EnemyContrastTypes[_e_cnt] = "Air"
	FriendlyContrastTypeNames = {"AntiAir", "Infantry", "Vehicle", "Air", "LandHero", "AntiVehicle", "AntiInfantry", "AntiStructure"}
	FriendlyContrastWeights =	{2.0, 1.0, 1.0, 1.0, 1.0, 0.75, 0.5, 0.25}
	FriendlyContrastTypes[_e_cnt] = WeightedTypeList.Create()
	FriendlyContrastTypes[_e_cnt].Parse(FriendlyContrastTypeNames, FriendlyContrastWeights)	
	_e_cnt = _e_cnt+1;

	EnemyContrastTypes[_e_cnt] = "Structure"
	FriendlyContrastTypeNames = {"AntiStructure", "AntiVehicle", "Infantry", "Vehicle", "Air", "LandHero"}
	FriendlyContrastWeights =	{1.5, 1.25, 1.0, 1.0, 1.0, 1.0, 1.25}
	FriendlyContrastTypes[_e_cnt] = WeightedTypeList.Create()
	FriendlyContrastTypes[_e_cnt].Parse(FriendlyContrastTypeNames, FriendlyContrastWeights)	
	_e_cnt = _e_cnt+1;

	EnemyContrastTypes[_e_cnt] = "LandHero"
	FriendlyContrastTypeNames = {"AntiInfantry", "Infantry", "Vehicle", "Air", "LandHero", "AntiVehicle", "AntiAir", "AntiStructure"}
	FriendlyContrastWeights =  {1.25, 0.25, 0.25, 0.25, 1.0, 0.25, 0.25, 0.25}
	FriendlyContrastTypes[_e_cnt] = WeightedTypeList.Create()
	FriendlyContrastTypes[_e_cnt].Parse(FriendlyContrastTypeNames, FriendlyContrastWeights)
	_e_cnt = _e_cnt+1;

end


