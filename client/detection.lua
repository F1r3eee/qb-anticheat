local Config = require('config/config')

CreateThread(function()
    local lastCoords = nil
    while true do
        Wait(1000)

        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local health = GetEntityHealth(ped)
        local armor = GetPedArmour(ped)
        local speed = GetEntitySpeed(ped) * 3.6 -- Convertito in km/h

        -- Controllo della velocità
        if speed > Config.maxVelocita then
            TriggerServerEvent('qb-anticheat:logViolation', "Velocità eccessiva: " .. speed .. " km/h")
        end

        -- Controllo del danno massimo
        local lastHealth = health
        Wait(500)
        local currentHealth = GetEntityHealth(ped)
        if lastHealth - currentHealth > Config.maxDanno then
            TriggerServerEvent('qb-anticheat:logViolation', "Danno sospetto ricevuto: " .. (lastHealth - currentHealth))
        end

        -- Controllo del teletrasporto
        if lastCoords ~= nil then
            local distance = #(coords - lastCoords)
            if distance > Config.maxTeleportDistance then
                TriggerServerEvent('qb-anticheat:logViolation', "Teletrasporto sospetto: distanza " .. distance .. " metri")
            end
        end
        lastCoords = coords

        -- Controllo delle armi vietate
        local currentWeapon = GetSelectedPedWeapon(ped)
        if Config.armiVietate[currentWeapon] then
            TriggerServerEvent('qb-anticheat:logViolation', "Arma vietata rilevata: " .. currentWeapon)
        end

        -- Controllo di salute sospetta
        if health > 200 or armor > 100 then
            TriggerServerEvent('qb-anticheat:logViolation', "Valori di salute/armatura anomali: Salute=" .. health .. ", Armatura=" .. armor)
        end

        -- Controllo del volo
        if IsEntityInAir(ped) and not IsPedInAnyVehicle(ped, false) and not IsPedRagdoll(ped) then
            TriggerServerEvent('qb-anticheat:logViolation', "Comportamento sospetto: volo rilevato")
        end

        -- Controllo di invisibilità
        if not IsEntityVisible(ped) then
            TriggerServerEvent('qb-anticheat:logViolation', "Comportamento sospetto: invisibilità rilevata")
        end

        -- Controllo velocità veicolo (se in un veicolo)
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            local vehicleSpeed = GetEntitySpeed(vehicle) * 3.6
            if vehicleSpeed > Config.maxVelocita then
                TriggerServerEvent('qb-anticheat:logViolation', "Velocità eccessiva veicolo: " .. vehicleSpeed .. " km/h")
            end
        end
    end
end)
