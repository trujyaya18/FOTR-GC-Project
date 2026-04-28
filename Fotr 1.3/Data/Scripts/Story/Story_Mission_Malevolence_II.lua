
--*****************************************************--
--*** Hunt for the Malevolence: Mission Malevolence ***--
--*****************************************************--

require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")
require("eawx-util/StoryUtil")

function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))

	StoryModeEvents =
	{
		Battle_Start = Begin_Battle,
		Trigger_Showdown_Malevolence = State_Showdown_Malevolence,
		Trigger_Malevolence_Escaped = State_Malevolence_Escaped,
		Trigger_Malevolence_Defeated = State_Malevolence_Defeated,
		Trigger_Escort_Fleet_Defeated = State_Escort_Fleet_Defeated,
		Trigger_Malevolence_Died = State_Malevolence_Died,
		Trigger_Act_II_Active = State_Act_II_Active,
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")
	p_pdf = Find_Player("Sector_Forces")

	camera_offset = 125

	act_1_active = false
	act_2_active = false

	current_cinematic_thread_id = nil

	cinematic_two = false
	cinematic_three = false

	cinematic_two_skipped = false
	cinematic_three_skipped = false

	coward_gamble = false
	malevolence_disabled = false

	malevolence_present = false
	malevolence_escaped = false
	generic_battle = false

	escape_chance = 15

	p_cis.Make_Ally(p_invaders)
	p_invaders.Make_Ally(p_cis)

	p_republic.Make_Ally(p_invaders)
	p_invaders.Make_Ally(p_republic)

end

function Begin_Battle(message)
	if message == OnEnter then
		if p_republic.Is_Human() then
			attacker_marker = Find_First_Object("Attacker Entry Position")
			defender_marker = Find_First_Object("Defending Forces Position")
			player_grievous = Find_First_Object("Grievous_Malevolence_Hunt_Campaign")

			if TestValid(player_grievous) then
				act_1_active = true
				malevolence_present = true
				Story_Event("PLAYER_REP")
				Story_Event("VALID_GRIEVOUS")
			elseif not TestValid(player_grievous) then
				malevolence_present = false
				generic_battle = true -- If the Malevolence isn't there, this ain't the battle you are looking for
			end
		end
	end
end


function State_Showdown_Malevolence(message)
	if message == OnEnter then
		if p_republic.Is_Human() then
			player_grievous.Set_Cannot_Be_Killed(true)
			Add_Objective("TEXT_MISSION_MISSION_MALEVOLENCE_OBJECTIVE_REP_01", false)
			Add_Objective("TEXT_MISSION_MISSION_MALEVOLENCE_OBJECTIVE_REP_02", false)
			if (GlobalValue.Get("HfM_Battle_Counter") == 1) then
				escape_chance = 99
				GlobalValue.Set("HfM_Battle_Counter", 2)
			elseif (GlobalValue.Get("HfM_Battle_Counter") == 2) then
				escape_chance = 50
				GlobalValue.Set("HfM_Battle_Counter", 3)
			elseif (GlobalValue.Get("HfM_Battle_Counter") == 3) then
				escape_chance = 33
				GlobalValue.Set("HfM_Battle_Counter", 4)
			elseif (GlobalValue.Get("HfM_Battle_Counter") == 4) then
				escape_chance = 25
				GlobalValue.Set("HfM_Battle_Counter", 5)
			elseif (GlobalValue.Get("HfM_Battle_Counter") == 5) then
				escape_chance = 0
			end
		end
	end
end

function State_Malevolence_Escaped(message)
	if message == OnEnter then
		Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Hyperspace_Away(false)
		Story_Event("ALLOW_STUFF")
		Sleep(3)
		Story_Event("COWARD")
		--Find_Player("Rebel").Retreat()
	end
end

function State_Malevolence_Defeated(message)
	if message == OnEnter then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_Rep")
	end
end

function State_Escort_Fleet_Defeated(message)
	if message == OnEnter then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
	end
end

function State_Malevolence_Died(message)
	if message == OnEnter then
		malevolence_marker = Create_Position(0, 0, 0)
		player_grievous = Spawn_Unit(Find_Object_Type("Grievous_Malevolence_Hunt_Campaign"), malevolence_marker, p_cis)
		player_grievous = Find_Nearest(malevolence_marker, p_cis, true)
		player_grievous.Take_Damage(26000)
	end
end

function State_Act_II_Active(message)
	if message == OnEnter then
		act_2_active = true
	end
end


function Story_Handle_Esc()
	if p_republic.Is_Human() then
		if cinematic_two then
			if not cinematic_two_skipped then
				cinematic_two_skipped = true
				-- MessageBox("Escape Key Pressed!!!")

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				Fade_Screen_Out(0)
				Stop_All_Music()
				Stop_All_Speech()
				Remove_All_Text()
				Stop_Bink_Movie()

				Allow_Localized_SFX(true)
				SFXManager.Allow_HUD_VO(true)
				SFXManager.Allow_Ambient_VO(true)
				SFXManager.Allow_Enemy_Sighted_VO(true)
				SFXManager.Allow_Unit_Reponse_VO(true)
				Resume_Mode_Based_Music()

				Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Change_Owner(p_invaders)
				Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Suspend_Locomotor(true)
				Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Prevent_All_Fire(true)

				p_republic.Make_Enemy(p_cis)
				p_cis.Make_Enemy(p_republic)

				Letter_Box_Out(0)
				if TestValid(Find_First_Object("Yularen_Resolute")) then
					Point_Camera_At(Find_First_Object("Yularen_Resolute"))
				end
				Story_Event("ACTIVATE_CIS_AI")
				Lock_Controls(0)
				Suspend_AI(0)
				End_Cinematic_Camera()

				cinematic_two = false

				Story_Event("CLEAN_UP")
				Add_Objective("TEXT_MISSION_MISSION_MALEVOLENCE_OBJECTIVE_REP_03", false)

				Fade_Screen_In(0.5)
				Sleep(0.5)
			end
		end
		if cinematic_three then
			if not cinematic_three_skipped then
				cinematic_three_skipped = true
				-- MessageBox("Escape Key Pressed!!!")

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				Allow_Localized_SFX(true)
				SFXManager.Allow_HUD_VO(true)
				SFXManager.Allow_Ambient_VO(true)
				SFXManager.Allow_Enemy_Sighted_VO(true)
				SFXManager.Allow_Unit_Reponse_VO(true)
				Resume_Mode_Based_Music()

				act_2_active = false
				player_grievous.Set_Cannot_Be_Killed(false)
				player_grievous.Take_Damage(100000)
				Story_Event("SUBJUGATOR_SABOTAGE")
				Story_Event("REPUBLIC_VICTORY")
			end
		end
	end
end

function Story_Mode_Service()
	if p_republic.Is_Human() then
		if act_1_active then
			if not coward_gamble then
				if Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Get_Hull() <= 0.85 then
					coward_gamble = true
					retreat_chance = GameRandom.Free_Random(1, 100)
					if retreat_chance <= escape_chance then
						Story_Event("MALEVOLENCE_ESCAPED")
					end
				end
			end
			if not malevolence_disabled then
				if Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Get_Hull() <= 0.10 then
					Story_Event("MALEVOLENCE_DEFEATED")
					malevolence_disabled = true
				end
			end
			if not malevolence_died and not coward_gamble then
				if not TestValid(Find_First_Object("Grievous_Malevolence_Hunt_Campaign")) then
					malevolence_died = true
					Story_Event("MALEVOLENCE_DIED")
				end
			end
			cis_is_retreating = EvaluatePerception("Enemy_Retreating", p_republic)
			if (cis_is_retreating ~= 0) then
				if TestValid(Find_First_Object("Grievous_Malevolence_Hunt_Campaign")) then
					Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Hyperspace_Away(false)
					Sleep(1)
					Story_Event("COWARD")
				end
			end
			republic_list_01 = Find_All_Objects_Of_Type(p_republic, "SpaceHero | Corvette | Capital | Frigate | SpaceStructure | SuperCapital")
			if (table.getn(republic_list_01) == 0) then
				Story_Event("CIS_VICTORY")
			end
		end
		if act_2_active then
			cis_list = Find_All_Objects_Of_Type(p_cis, "SpaceHero | Capital | Frigate | SpaceStructure | SuperCapital")
			if (table.getn(cis_list) == 0) then
				Story_Event("ESCORT_FLEET_DEFEATED")
			end
			republic_list_02 = Find_All_Objects_Of_Type(p_republic, "SpaceHero | Corvette | Capital | Frigate | SpaceStructure | SuperCapital")
			if (table.getn(republic_list_02) == 0) then
				Story_Event("CIS_VICTORY")
			end
		end
		if generic_battle then
			if TestValid(Find_First_Object("Grievous_Malevolence_Hunt_Campaign")) and not malevolence_present then
				act_1_active = true
				Story_Event("PLAYER_REP")
				Story_Event("VALID_GRIEVOUS")
				generic_battle = false
				malevolence_present = true
			end
		end
	end
end


function Start_Cinematic_Midtro_Rep()
	act_1_active = false
	cinematic_two = true

	Start_Cinematic_Camera()
	Stop_All_Music()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()

	Allow_Localized_SFX(false)
	SFXManager.Allow_HUD_VO(false)
	SFXManager.Allow_Ambient_VO(false)
	SFXManager.Allow_Enemy_Sighted_VO(false)
	SFXManager.Allow_Unit_Reponse_VO(false)
	SFXManager.Allow_Localized_SFXEvents(false)

	hero_list_01 = Find_All_Objects_Of_Type("SpaceHero")
	for h, hero01 in pairs(hero_list_01) do
		if TestValid(hero01) then
			hero01.Make_Invulnerable(true)
		end
	end

	Fade_On()
	Play_Music("Mission_Malevolence_01")
	Sleep(1)

	Letter_Box_In(1)
	Fade_Screen_In(2)

	Set_Cinematic_Camera_Key(player_grievous, 2800, 200, 155, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(player_grievous, 0, 0, 0, 0, 0, 0, 0)
	Transition_Cinematic_Camera_Key(attacker_marker, 20, 350, 12, 45, 1, 0, 1, 0)
	Sleep(15)

	p_cis.Make_Ally(p_republic)
	p_republic.Make_Ally(p_cis)

	Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Change_Owner(p_invaders)
	Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Suspend_Locomotor(true)
	Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Prevent_All_Fire(true)
	Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Prevent_Opportunity_Fire(true)

	Set_Cinematic_Camera_Key(player_grievous, 3000, -5000, -5000, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(player_grievous, 0, 0, 0, 0, player_grievous, 1, 0)
	Transition_Cinematic_Camera_Key(player_grievous, 20, -3000, -1000, 300, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(player_grievous, 20, 0, 0, 0, 0, player_grievous, 1, 0)
	Sleep(15)

	Set_Cinematic_Camera_Key(attacker_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(attacker_marker, 0, 0, 0, 0, player_grievous, 1, 0)
	Transition_Cinematic_Camera_Key(player_grievous, 20, -2500, 500, 500, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(player_grievous, 20, 0, 0, 0, 0, player_grievous, 1, 0)
	Sleep(20)

	if not cinematic_two_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Midtro_Rep")
	end
end

function End_Cinematic_Midtro_Rep()
	if TestValid(Find_First_Object("Yularen_Resolute")) then
		Point_Camera_At(Find_First_Object("Yularen_Resolute"))
	end
	Add_Objective("TEXT_MISSION_MISSION_MALEVOLENCE_OBJECTIVE_REP_03", false)

	Transition_To_Tactical_Camera(3)
	Letter_Box_Out(3)
	Fade_Screen_In(.1)
	Sleep(3.0)
	End_Cinematic_Camera()
	Suspend_AI(0)
	Lock_Controls(0)

	hero_list_02 = Find_All_Objects_Of_Type("SpaceHero")
	for h, hero02 in pairs(hero_list_02) do
		if TestValid(hero02) then
			hero02.Make_Invulnerable(false)
		end
	end

	p_republic.Make_Enemy(p_cis)
	p_cis.Make_Enemy(p_republic)

	Sleep(10.0)

	Resume_Mode_Based_Music()
	Allow_Localized_SFX(true)
	SFXManager.Allow_HUD_VO(true)
	SFXManager.Allow_Ambient_VO(true)
	SFXManager.Allow_Unit_Reponse_VO(true)
	SFXManager.Allow_Enemy_Sighted_VO(true)
	SFXManager.Allow_Localized_SFXEvents(true)

	cinematic_two = false

	Story_Event("CLEAN_UP")
end

function Start_Cinematic_Outro_Rep()
	Story_Event("SUBJUGATOR_SABOTAGE")

	act_2_active = false
	cinematic_three = true

	Start_Cinematic_Camera()
	Stop_All_Music()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()

	Allow_Localized_SFX(false)
	SFXManager.Allow_HUD_VO(false)
	SFXManager.Allow_Ambient_VO(false)
	SFXManager.Allow_Enemy_Sighted_VO(false)
	SFXManager.Allow_Unit_Reponse_VO(false)
	SFXManager.Allow_Localized_SFXEvents(false)

	player_anakin = Spawn_Unit(Find_Object_Type("Twilight"), attacker_marker, p_republic)
	player_anakin = Find_Nearest(attacker_marker, p_republic, true)
	player_anakin.Teleport_And_Face(attacker_marker)
	player_anakin.Move_To(player_grievous)

	Fade_On()
	Play_Music("Mission_Malevolence_02")
	Sleep(1)

	player_anakin.Play_Animation("Undeploy", false)

	Set_Cinematic_Camera_Key(attacker_marker, 800, 200, 155, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(attacker_marker, 0, 0, 0, 0, player_anakin, 1, 0)
	Transition_Cinematic_Camera_Key(attacker_marker, 10, 100, 100, -100, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(attacker_marker, 10, 0, 0, 0, 0, player_grievous, 1, 0)

	Letter_Box_In(1)
	Fade_Screen_In(2)
	Sleep(7)

	player_anakin.Play_Animation("Deploy", false)

	Set_Cinematic_Camera_Key(player_anakin, 0, -50, -700, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(player_anakin, 0, 0, 0, 0, player_anakin, 1, 0)
	Sleep(6)

	Fade_Screen_Out(4)
	Sleep(5)
	player_grievous.Set_Cannot_Be_Killed(false)
	player_grievous.Take_Damage(100000)
	Story_Event("REPUBLIC_VICTORY")

	Resume_Mode_Based_Music()
	Allow_Localized_SFX(true)
	SFXManager.Allow_HUD_VO(true)
	SFXManager.Allow_Ambient_VO(true)
	SFXManager.Allow_Unit_Reponse_VO(true)
	SFXManager.Allow_Enemy_Sighted_VO(true)
	SFXManager.Allow_Localized_SFXEvents(true)
end
