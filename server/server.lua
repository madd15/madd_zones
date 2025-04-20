-- This handles zone data storage and management with NUI support

-- Zone storage
local zones = {}

-- Function to convert zone data for client usage and mark permanent zones as locked
local function FormatZoneForClient(zone)
    local isPermanent = zone.id and zone.id:sub(1, 5) == "perm_"
    local zoneType = zone.zoneType
    if isPermanent then
        zoneType = zone.zoneType == "red" and "danger" or (zone.zoneType == "green" and "safe" or (zone.zoneType == "yellow" and "restricted" or "neutral")),
    end
    return {
        id = zone.id,
        name = zone.name or zone.blipName,
        type = zoneType,
        description = zone.textToDisplay or "",
        isPermanent = isPermanent,
        metadata = {
            radius = zone.radius or 100,
            showBlip = zone.blip or false,
            showSprite = zone.enableSprite or false,
            blipColor = zone.zoneType,
            blipAlpha = zone.blipAlpha or 100,
            spriteId = zone.blipSprite or 1,
            disableWeapons = zone.disableFiring or false,
            speedLimitEnabled = zone.enableSpeedLimits or false,
            speedLimit = zone.setSpeedLimit or 0,
            notificationText = zone.textToDisplay or "",
            notificationLocation = zone.displayTextPosition or "top-right",
            alertPolice = false,
            invincible = zone.setInvincible or false,
            coords = zone.coords
        }
    }
end

-- Function to get a zone by ID
local function GetZoneById(zoneId)
    return zones[zoneId]
end

-- Function to create a new zone
local function CreateZone(zoneData)
    -- Generate ID if not provided
    if not zoneData.id then
        zoneData.id = "zone_" .. tostring(os.time()) .. "_" .. math.random(1000, 9999)
    end

    -- Ensure coords are present
    if not zoneData.coords or not zoneData.coords.x then
        print("WARNING: Zone created without coordinates: " .. zoneData.id)
    end

    -- Store the zone
    zones[zoneData.id] = zoneData

    -- Format zone for client
    local clientZone = FormatZoneForClient(zoneData)

    -- Notify all clients about the new zone
    TriggerClientEvent('zones:added', -1, clientZone)

    return zoneData
end

-- Function to update an existing zone
local function UpdateZone(zoneId, zoneData)
    if not zones[zoneId] then
        return false, "Zone not found"
    end

    -- Don't allow modifying permanent zones
    if string.sub(zoneId, 1, 5) == "perm_" then
        return false, "Cannot modify permanent zones"
    end

    -- Update zone data
    for k, v in pairs(zoneData) do
        zones[zoneId][k] = v
    end

    -- Format zone for client
    local clientZone = FormatZoneForClient(zones[zoneId])

    -- Notify all clients about the zone update
    TriggerClientEvent('zones:updated', -1, clientZone)

    return true
end

-- Function to delete a zone
local function DeleteZone(zoneId)
    if not zones[zoneId] then
        return false, "Zone not found"
    end

    -- Don't allow deleting permanent zones
    if string.sub(zoneId, 1, 5) == "perm_" then
        return false, "Cannot delete permanent zones"
    end

    -- Remove the zone
    zones[zoneId] = nil

    -- Notify all clients about the zone deletion
    TriggerClientEvent('zones:deleted', -1, zoneId)

    return true
end

-- Function to get all zones for client
local function GetAllZonesForClient()
    local clientZones = {}
    for id, zone in pairs(zones) do
        table.insert(clientZones, FormatZoneForClient(zone))
    end
    return clientZones
end

-- Register server events
RegisterNetEvent('zones:getAllZones')
AddEventHandler('zones:getAllZones', function()
    local source = source
    -- Send all zones to the requesting client
    TriggerClientEvent('zones:receiveAll', source, GetAllZonesForClient())
end)

RegisterNetEvent('zones:createFromNUI')
AddEventHandler('zones:createFromNUI', function(zoneData)
    local src = source

    -- If no coords provided, default to origin coordinates
    if not zoneData.coords or not zoneData.coords.x then
        zoneData.coords = {x = 0, y = 0, z = 0}
        print("Warning: Creating zone with default coordinates (0,0,0)")
    end

    -- Create the zone
    local newZone = CreateZone(zoneData)

    print("Zone created:", newZone.id, newZone.name, "by", src)
end)

RegisterNetEvent('zones:updateFromNUI')
AddEventHandler('zones:updateFromNUI', function(zoneId, zoneData)
    local src = source

    -- Don't allow modifying permanent zones
    if string.sub(zoneId, 1, 5) == "perm_" then
        TriggerClientEvent('zones:error', src, 'Cannot modify permanent zones')
        return
    end

    -- Update the zone
    local success, error = UpdateZone(zoneId, zoneData)

    if success then
        print("Zone updated:", zoneId, "by", src)
    else
        TriggerClientEvent('zones:error', src, error or 'Failed to update zone')
    end
end)

RegisterNetEvent('zones:deleteFromNUI')
AddEventHandler('zones:deleteFromNUI', function(zoneId)
    local src = source

    -- Don't allow deleting permanent zones
    if string.sub(zoneId, 1, 5) == "perm_" then
        TriggerClientEvent('zones:error', src, 'Cannot delete permanent zones')
        return
    end

    local success, errorMsg = DeleteZone(zoneId)

    if success then
        print("Zone deleted:", zoneId, "by", src)
    else
        TriggerClientEvent('zones:error', src, errorMsg or 'Zone not found')
    end
end)

RegisterNetEvent('zones:nuiReady')
AddEventHandler('zones:nuiReady', function()
    local source = source
    -- Send all zones to the client when NUI is ready
    TriggerClientEvent('zones:receiveAll', source, GetAllZonesForClient())
end)

-- Custom export for other resources to interact with zones
exports('CreateZone', CreateZone)
exports('UpdateZone', UpdateZone)
exports('DeleteZone', DeleteZone)
exports('GetZoneById', GetZoneById)
exports('GetAllZonesForClient', GetAllZonesForClient)

-- Load predefined zones from config
Citizen.CreateThread(function()
    -- Clear existing zones to avoid duplicates on script restart
    zones = {}

    if Config and Config.PermZones then
        print("Loading permanent zones from Config.PermZones")
        local count = 0

        for zoneId, zoneData in pairs(Config.PermZones) do
            local formattedZone = {
                id = "perm_" .. zoneId,
                name = zoneData.name or zoneData.blipName or zoneId,
                zoneType = zoneData.zoneType or "neutral",
                textToDisplay = zoneData.textToDisplay or "",
                coords = zoneData.coords,
                radius = zoneData.radius or 100,
                blip = zoneData.blip or false,
                enableSprite = zoneData.enableSprite or false,
                blipSprite = zoneData.blipSprite or 1,
                disableFiring = zoneData.disableFiring or false,
                enableSpeedLimits = zoneData.enableSpeedLimits or false,
                setSpeedLimit = zoneData.setSpeedLimit or 0,
                displayTextPosition = zoneData.displayTextPosition or "top-right",
                setInvincible = zoneData.setInvincible or false,
                blipAlpha = zoneData.blipAlpha or 100,
                blipColor = zoneData.blipColor or 1
            }

            CreateZone(formattedZone)
            count = count + 1
        end

        print("Loaded " .. count .. " permanent zones from config")
    else
        print("No Config.PermZones found or it's empty")
    end
end)

-- Handle player connect to sync all zones
AddEventHandler('playerJoining', function()
    local source = source
    -- Wait a bit to make sure the player is fully connected
    Citizen.Wait(2000)
    TriggerClientEvent('zones:receiveAll', source, GetAllZonesForClient())
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        print("Zone management resource started")
        Citizen.Wait(2000)
        TriggerClientEvent('zones:receiveAll', -1, GetAllZonesForClient())
    end
end)

lib.addCommand("zones:toggle", {
    description = "Toggle the zones UI",
    params = {}
}, function(source, args)
    TriggerClientEvent('zones:toggleUI', source)
end)