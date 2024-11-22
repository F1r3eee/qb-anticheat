local Config = require('config/config')
local json = require('json')

-- Controllo iniziale e aggiornamento regole
CreateThread(function()
    while true do
        Wait(Config.serverCheckInterval)

        -- Controlla aggiornamenti delle regole da URL configurato
        PerformHttpRequest(Config.updateUrl, function(statusCode, response, headers)
            if statusCode == 200 then
                local rules = json.decode(response)
                if rules then
                    UpdateRules(rules)
                end
            else
                print("^1[Anti-Cheat] Errore aggiornamento regole. Status Code: " .. statusCode .. "^0")
            end
        end)
    end
end)

-- Funzione per aggiornare le regole del server
function UpdateRules(rules)
    Config.regole = rules
    print("^2[Anti-Cheat] Regole aggiornate con successo!^0")
end

-- Controllo periodico dei giocatori
RegisterServerEvent('qb-anticheat:checkPlayer')
AddEventHandler('qb-anticheat:checkPlayer', function()
    local src = source
    local playerName = GetPlayerName(src)

    -- Controllo delle armi vietate
    local weapons = GetPlayerWeapons(src)
    for _, weapon in ipairs(weapons) do
        if Config.armiVietate[weapon] then
            TriggerClientEvent('qb-anticheat:removeWeapon', src, weapon)
            LogViolation(src, playerName, "Uso di arma vietata: " .. weapon)
        end
    end

    -- Controllo flood eventi (esempio)
    if IsFloodingEvents(src) then
        LogViolation(src, playerName, "Flood eventi sospetto rilevato")
        DropPlayer(src, "Anti-Cheat: Flood di eventi rilevato")
    end

    -- Aggiungi ulteriori controlli qui (esempio: oggetti spawnati)
    -- ...
end)

-- Funzione per loggare violazioni su Discord o in locale
function LogViolation(playerId, playerName, reason)
    -- Log su Discord via webhook
    if Config.logWebhook then
        PerformHttpRequest(Config.logWebhook, function() end, 'POST', json.encode({
            username = "QBCore Anti-Cheat",
            embeds = {{
                title = "Violazione rilevata",
                description = ("Giocatore: %s\nID: %s\nMotivo: %s"):format(playerName, playerId, reason),
                color = 16711680
            }}
        }), {['Content-Type'] = 'application/json'})
    end

    -- Log locale
    SaveLocalLog(playerId, playerName, reason)
end

-- Salva log localmente
function SaveLocalLog(playerId, playerName, reason)
    local logFile = "logs/logs.json"
    local logData = LoadResourceFile(GetCurrentResourceName(), logFile) or "[]"
    local logs = json.decode(logData)

    table.insert(logs, {
        time = os.date('%Y-%m-%d %H:%M:%S'),
        playerId = playerId,
        playerName = playerName,
        reason = reason
    })

    SaveResourceFile(GetCurrentResourceName(), logFile, json.encode(logs, { indent = true }), -1)
end

-- Funzione per rilevare flood eventi (esempio semplice)
function IsFloodingEvents(playerId)
    -- Implementazione basata su un contatore semplice o eventi monitorati
    -- Esempio: controlla quante volte l'evento è stato chiamato in X secondi
    return false -- Deve essere implementato secondo le tue esigenze
end
