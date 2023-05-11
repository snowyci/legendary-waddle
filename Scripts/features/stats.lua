local Helpers = require("../utils/helpers")
local Options = require("../options")
local json = require("../utils/json")

function Run()
	local LocalPlayer = FindFirstOf("LocalPlayer")
	if not LocalPlayer:IsValid() then return Helpers.Logf("La dirección de memoria de 'LocalPlayer' no es válida.") end

	local PlayerController = LocalPlayer.PlayerController
	if not PlayerController:IsValid() then return Helpers.Logf("La dirección de memoria de 'PlayerController' no es válida.") end

	local GameState = PlayerController.MP_GameState
	if not GameState:IsValid() then return Helpers.Logf("La dirección de memoria de 'MP_GameState' no es válida.") end

	local PlayerStates = GameState.MP_PlayerStates
	if PlayerStates:GetArrayNum() == 0 then return Helpers.Logf("No encuentro ningún jugador, ¿estás en una partida?") end

	local players = {}

	PlayerStates:ForEach(function(Index, Element)
		local Player = Element:get()

		players[#players + 1] = {
			name = Player.PlayerNameBasis:ToString(),
			steamId = Player.SteamID:ToString(),
			host = tonumber(Player.IsHost),
			captain = tonumber(Player.IsCaptain),
			team = Player.Team,
			position = Player.Position,
			score = Player.Stats_Score,
			passes = Player.Stats_Passes,
			assists = Player.Stats_Assists,
			tkls = Player.Stats_TKLs,
			ints = Player.Stats_INTs,
			shots = Player.Stats_Shots,
			goals = Player.Stats_Goals,
			saves = Player.Stats_Saves,
			catches = Player.Stats_Catches,
			yellowCards = Player.Stats_YellowCards,
			redCards = Player.Stats_RedCards,
		}
	end)

	local time = os.time()
	Helpers.SaveToFile(string.format("apa-match-%s.json", tostring(time)), json.encode({ timestamp = time, players = players}))
end

function InnerRun()
	local success, result = pcall(Run)

	if not success then
		print("ERROR: Ocurrió un error fatal, por favor, revisá el archivo de registros para más información.\n")
		Helpers.Logf(result, false)
	end
end

RegisterKeyBind(Key.NUM_ONE, { ModifierKey.CONTROL }, function()
	Helpers.Logf("Presionaste la tecla de guardado. Guardando información...")
	InnerRun()
end)

if Options.AutoDumpSummary then
	RegisterHook("/Game/GameModes/Multiplayer/Widgets/MP_MatchSummary.MP_MatchSummary_C:GetMatchSummaryInfo", function(self)
		Helpers.Logf("El partido finalizó. Guardando información...")
		InnerRun()
	end)
end
