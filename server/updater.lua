local Config = require('config/config')
local json = require('json')

CreateThread(function()
    while true do
        Wait(Config.serverCheckInterval)

        PerformHttpRequest(Config.updateUrl, function(statusCode, response, headers)
            if statusCode == 200 then
                local rules = json.decode(response)
                -- Applica le regole aggiornate
                UpdateRules(rules)
            end
        end)
    end
end)

function UpdateRules(rules)
    -- Aggiorna le regole del server
    Config.regole = rules
end
