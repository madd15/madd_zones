
-- CLIENT UTILITIES FOR ZONE MANAGEMENT

-- Register NUI callbacks
RegisterNUICallback('getPlayerCoords', function(data, cb)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    -- Send the coordinates to NUI
    SendNUIMessage({
        action = 'playerCoords',
        coords = {
            x = coords.x,
            y = coords.y,
            z = coords.z
        }
    })

    cb('ok')
end)

-- Handle getAllZones NUI callback
RegisterNUICallback('getAllZones', function(data, cb)
    -- Request all zones from the server
    TriggerServerEvent('zones:getAllZones')
    cb('ok')
end)

-- Handle createZone NUI callback
RegisterNUICallback('createZone', function(data, cb)
    -- If no coords provided, get player position
    if not data.zoneData.coords or not data.zoneData.coords.x then
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        data.zoneData.coords = {x = coords.x, y = coords.y, z = coords.z}
    end

    -- Forward to server
    TriggerServerEvent('zones:createFromNUI', data.zoneData)
    cb({success = true})
end)

-- Handle deleteZone NUI callback
RegisterNUICallback('deleteZone', function(data, cb)
    -- Forward to server
    if data.zoneId then
        TriggerServerEvent('zones:deleteFromNUI', data.zoneId)
    end
    cb({success = true})
end)

-- Handle updateZone NUI callback
RegisterNUICallback('updateZone', function(data, cb)
    -- Forward to server
    if data.zoneId and data.zoneData then
        TriggerServerEvent('zones:updateFromNUI', data.zoneId, data.zoneData)
    end
    cb({success = true})
end)

-- Handle toggleUI NUI callback
RegisterNUICallback('toggleUI', function(data, cb)
    -- Handle UI toggle locally
    local visible = data.visible

    -- Trigger event for client script
    TriggerEvent('zones:setUIVisible', visible)

    cb({success = true})
end)

-- Handle closeUI NUI callback
RegisterNUICallback('closeUI', function(data, cb)
    -- Hide UI locally
    TriggerEvent('zones:setUIVisible', false)

    cb({success = true})
end)

-- Handle nuiReady NUI callback
RegisterNUICallback('nuiReady', function(data, cb)
    -- Inform server that NUI is ready
    TriggerServerEvent('zones:nuiReady')

    cb({success = true})
end)

-- Register client event handlers
RegisterNetEvent('zones:toggleUI')
AddEventHandler('zones:toggleUI', function()
    -- Toggle UI visibility
    SendNUIMessage({
        action = 'toggleUI'
    })
end)

-- Forward zone events to NUI interface
RegisterNetEvent('zones:receiveAll')
AddEventHandler('zones:receiveAll', function(zones)
    SendNUIMessage({
        action = 'receiveAllZones',
        zones = zones
    })
end)

RegisterNetEvent('zones:created')
AddEventHandler('zones:created', function(zone)
    SendNUIMessage({
        action = 'zoneCreated',
        zone = zone
    })
end)

RegisterNetEvent('zones:updated')
AddEventHandler('zones:updated', function(zone)
    SendNUIMessage({
        action = 'zoneUpdated',
        zone = zone
    })
end)

RegisterNetEvent('zones:deleted')
AddEventHandler('zones:deleted', function(zoneId)
    SendNUIMessage({
        action = 'zoneDeleted',
        zoneId = zoneId
    })
end)

RegisterNetEvent('zones:error')
AddEventHandler('zones:error', function(message)
    SendNUIMessage({
        action = 'zoneError',
        message = message
    })
end)

-- Register zone event when added from client
RegisterNetEvent('zones:added')
AddEventHandler('zones:added', function(zone)
    SendNUIMessage({
        action = 'zoneCreated',
        zone = zone
    })
end)

-- Setup key binding to toggle zone UI (optional)
RegisterCommand('zonemanager', function()
    TriggerEvent('zones:toggleUI')
end, false)

-- Request all zones when resource starts
Citizen.CreateThread(function()
    -- Wait a moment for everything to initialize
    Citizen.Wait(2000)
    TriggerServerEvent('zones:getAllZones')
end)
