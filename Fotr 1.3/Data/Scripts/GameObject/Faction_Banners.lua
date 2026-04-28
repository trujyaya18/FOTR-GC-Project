require("PGStateMachine")
require("PGStoryMode")
require("TRCommands")

function Definitions()
	Define_State("State_Init", State_Init)
end

function State_Init(message)
	if message == OnEnter then
		if Get_Game_Mode() ~= "Land" then
			ScriptExit()
		end	

		p_republic = Find_Player("Empire")
		p_pdf = Find_Player("Sector_Forces")
		p_cis = Find_Player("Rebel")
		p_hutts = Find_Player("Hutt_Cartels")
		p_tradefed = Find_Player("Trade_Federation")
		p_techno = Find_Player("Techno_Union")
		p_commerce = Find_Player("Commerce_Guild")

		if EvaluatePerception("Is_Defender", p_republic) == 1 or EvaluatePerception("Is_Defender", p_pdf) == 1 then
			Hide_Sub_Object(Object, 1, "banners")	 --Nothing
			Hide_Sub_Object(Object, 1, "banners_01") --CIS
			Hide_Sub_Object(Object, 0, "banners_02") --Republic
			Hide_Sub_Object(Object, 1, "banners_03") --Hutts
			Hide_Sub_Object(Object, 1, "banners_04") --Trade Federation
			Hide_Sub_Object(Object, 1, "banners_05") --Techno Union
			Hide_Sub_Object(Object, 1, "banners_06") --Commerce Guild
		elseif EvaluatePerception("Is_Defender", p_cis) == 1 then
			Hide_Sub_Object(Object, 1, "banners")	 --Nothing
			Hide_Sub_Object(Object, 0, "banners_01") --CIS
			Hide_Sub_Object(Object, 1, "banners_02") --Republic
			Hide_Sub_Object(Object, 1, "banners_03") --Hutts
			Hide_Sub_Object(Object, 1, "banners_04") --Trade Federation
			Hide_Sub_Object(Object, 1, "banners_05") --Techno Union
			Hide_Sub_Object(Object, 1, "banners_06") --Commerce Guild
		elseif EvaluatePerception("Is_Defender", p_hutts) == 1 then
			Hide_Sub_Object(Object, 1, "banners")	 --Nothing
			Hide_Sub_Object(Object, 1, "banners_01") --CIS
			Hide_Sub_Object(Object, 1, "banners_02") --Republic
			Hide_Sub_Object(Object, 0, "banners_03") --Hutts
			Hide_Sub_Object(Object, 1, "banners_04") --Trade Federation
			Hide_Sub_Object(Object, 1, "banners_05") --Techno Union
			Hide_Sub_Object(Object, 1, "banners_06") --Commerce Guild
		elseif EvaluatePerception("Is_Defender", p_tradefed) == 1 then
			Hide_Sub_Object(Object, 1, "banners")	 --Nothing
			Hide_Sub_Object(Object, 1, "banners_01") --CIS
			Hide_Sub_Object(Object, 1, "banners_02") --Republic
			Hide_Sub_Object(Object, 1, "banners_03") --Hutts
			Hide_Sub_Object(Object, 0, "banners_04") --Trade Federation
			Hide_Sub_Object(Object, 1, "banners_05") --Techno Union
			Hide_Sub_Object(Object, 1, "banners_06") --Commerce Guild
		elseif EvaluatePerception("Is_Defender", p_techno) == 1 then
			Hide_Sub_Object(Object, 1, "banners")	 --Nothing
			Hide_Sub_Object(Object, 1, "banners_01") --CIS
			Hide_Sub_Object(Object, 1, "banners_02") --Republic
			Hide_Sub_Object(Object, 1, "banners_03") --Hutts
			Hide_Sub_Object(Object, 1, "banners_04") --Trade Federation
			Hide_Sub_Object(Object, 0, "banners_05") --Techno Union
			Hide_Sub_Object(Object, 1, "banners_06") --Commerce Guild
		elseif EvaluatePerception("Is_Defender", p_commerce) == 1 then
			Hide_Sub_Object(Object, 1, "banners")	 --Nothing
			Hide_Sub_Object(Object, 1, "banners_01") --CIS
			Hide_Sub_Object(Object, 1, "banners_02") --Republic
			Hide_Sub_Object(Object, 1, "banners_03") --Hutts
			Hide_Sub_Object(Object, 1, "banners_04") --Trade Federation
			Hide_Sub_Object(Object, 1, "banners_05") --Techno Union
			Hide_Sub_Object(Object, 0, "banners_06") --Commerce Guild
		else
			Hide_Sub_Object(Object, 0, "banners")	 --Nothing
			Hide_Sub_Object(Object, 1, "banners_01") --CIS
			Hide_Sub_Object(Object, 1, "banners_02") --Republic
			Hide_Sub_Object(Object, 1, "banners_03") --Hutts
			Hide_Sub_Object(Object, 1, "banners_04") --Trade Federation
			Hide_Sub_Object(Object, 1, "banners_05") --Techno Union
			Hide_Sub_Object(Object, 1, "banners_06") --Commerce Guild
		end
		ScriptExit()
	end
end
