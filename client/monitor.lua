CreateThread(function()
    while true do
        Wait(1000)

        -- Monitoraggio dei processi sospetti
        local ped = PlayerPedId()
        if IsEntityInAir(ped) and not IsPedInAnyVehicle(ped, false) then
            TriggerServerEvent('qb-anticheat:logViolation', "Comportamento sospetto: volo")
        end
    end
end)
