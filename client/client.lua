
-- CLIENT.LUA ZONE DETECTION
-- This handles detecting when players enter or exit zones using ox_lib points

-- Local zone storage
local zoneCache = {}
local playerInZones = {}
local debugMode = false
local zonePoints = {}
local zoneBlips = {}
local zoneSprites = {}
local isUIVisible = false -- Track UI visibility

-- Function to apply zone effects when player is in a zone
local function ApplyZoneEffects(zone)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)

    -- Handle invincibility
    if zone.metadata and zone.metadata.invincible then
        SetEntityInvincible(ped, true)
    end

    -- Handle weapon disabling
    if zone.metadata and zone.metadata.disableWeapons then
        DisablePlayerFiring(ped, true)

        -- Also remove weapons if needed
        local currentWeapon = GetSelectedPedWeapon(ped)
        if currentWeapon ~= GetHashKey("WEAPON_UNARMED") then
            SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
        end
    end

    -- Handle speed limits
    if zone.metadata and zone.metadata.speedLimitEnabled and zone.metadata.speedLimit > 0 and vehicle ~= 0 then
        local speedLimit = zone.metadata.speedLimit * 0.27778 -- Convert KPH to m/s
        SetVehicleMaxSpeed(vehicle, speedLimit)
    end

    -- Send zone data to NUI
    SendNUIMessage({
        action = "setZone",
        zoneData = zone
    })
end

-- Function to remove zone effects
local function RemoveZoneEffects()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)

    -- Remove invincibility
    SetEntityInvincible(ped, false)

    -- Re-enable firing
    DisablePlayerFiring(ped, false)

    -- Remove speed limit
    if vehicle ~= 0 then
        SetVehicleMaxSpeed(vehicle, 0.0) -- 0.0 means no limit
    end

    -- Hide zone UI
    SendNUIMessage({
        action = "exitZone"
    })
end

-- Function to create an ox_lib point for a zone
local function CreateZonePoint(zone)
    if not zone or not zone.metadata or not zone.metadata.coords or not zone.id then
        if debugMode then
            print('Invalid zone data for zone point creation')
        end
        return
    end

    -- Remove existing point if it exists
    if zonePoints[zone.id] then
        zonePoints[zone.id]:remove()
        zonePoints[zone.id] = nil
    end

    local zoneCoords = vector3(zone.metadata.coords.x, zone.metadata.coords.y, zone.metadata.coords.z)
    local zoneRadius = zone.metadata and zone.metadata.radius or 100

    -- Create the point with the zone's coordinates and radius
    zonePoints[zone.id] = lib.points.new({
        coords = zoneCoords,
        distance = zoneRadius,
        onEnter = function(self)
            if debugMode then
                print('Entered zone: ' .. zone.name)
            end

            -- Add to active zones
            playerInZones[zone.id] = true
            TriggerEvent('zones:playerEntered', zone)
            ApplyZoneEffects(zone)
        end,
        onExit = function(self)
            if debugMode then
                print('Exited zone: ' .. zone.name)
            end

            -- Remove from active zones
            playerInZones[zone.id] = nil
            TriggerEvent('zones:playerExited', zone.id)

            -- Check if player is still in any zone
            if next(playerInZones) == nil then
                RemoveZoneEffects()
            end
        end
    })
end

local blipColors = {
    ['red'] = 1,
    ['green'] = 2,
    ['neutral'] = 3,
    ['restricted'] = 5,
}

-- Function to create blip for a zone
local function CreateZoneBlip(zone)
    print(json.encode(zone, { indent = true }))
    if not zone or not zone.metadata or not zone.metadata.coords or not zone.id then
        if debugMode then
            print('Invalid zone data for blip creation')
        end
        return
    end

    if debugMode then
        print('Creating blip for zone: ' .. zone.name)
    end

    -- Remove existing blips for this zone
    if zoneBlips[zone.id] then
        RemoveBlip(zoneBlips[zone.id])
        zoneBlips[zone.id] = nil
    end

    if zoneSprites[zone.id] then
        RemoveBlip(zoneSprites[zone.id])
        zoneSprites[zone.id] = nil
    end

    -- Only create blips if showBlip is true
    if zone.metadata.showBlip then
        if debugMode then
            print('Creating radius blip for zone: ' .. zone.name)
        end
        -- Create radius blip
        zoneBlips[zone.id] = AddBlipForRadius(
            zone.metadata.coords.x,
            zone.metadata.coords.y,
            zone.metadata.coords.z,
            zone.metadata.radius
        )

        SetBlipAlpha(zoneBlips[zone.id], zone.metadata.blipAlpha or 100)
        SetBlipColour(zoneBlips[zone.id], blipColors[zone.metadata.blipColor] or 0)

        -- Create sprite blip if needed
        if zone.metadata.showSprite then
            if debugMode then
                print('Creating sprite blip for zone: ' .. zone.name)
            end
            zoneSprites[zone.id] = AddBlipForCoord(
                zone.metadata.coords.x,
                zone.metadata.coords.y,
                zone.metadata.coords.z
            )

            SetBlipSprite(zoneSprites[zone.id], zone.metadata.spriteId)
            SetBlipColour(zoneSprites[zone.id], blipColors[zone.metadata.blipColor] or 0)
            SetBlipDisplay(zoneSprites[zone.id], 4)
            SetBlipScale(zoneSprites[zone.id], 1.0)
            SetBlipAsShortRange(zoneSprites[zone.id], true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(zone.name)
            EndTextCommandSetBlipName(zoneSprites[zone.id])
        end
    end
end

-- Function to create points and blips for all zones
local function CreateZonePoints()
    for _, zone in pairs(zoneCache) do
        CreateZonePoint(zone)
        CreateZoneBlip(zone)
    end

    if debugMode then
        print('Created zone points for ' .. #zoneCache .. ' zones')
    end
end

-- Function to toggle UI visibility
function ToggleZoneUI(visible)
    isUIVisible = visible

    SendNUIMessage({
        action = "setUIVisible",
        visible = visible
    })

    -- Set focus when UI is visible
    SetNuiFocus(visible, visible)
end

RegisterNetEvent('zones:toggleUI', function ()
    isUIVisible = not isUIVisible
    ToggleZoneUI(isUIVisible)
end)

RegisterNetEvent('zones:setUIVisible', function(visible)
    isUIVisible = visible
    ToggleZoneUI(visible)
end)

-- Function to request all zones from the server
function RequestAllZones()
    TriggerServerEvent('zones:getAllZones')
end

-- Event handler for receiving all zones
RegisterNetEvent('zones:receiveAll')
AddEventHandler('zones:receiveAll', function(zones)
    zoneCache = {}

    -- Process received zones
    for _, zone in ipairs(zones) do
        zoneCache[zone.id] = zone
    end

    -- Create zone points and blips
    CreateZonePoints()

    if debugMode then
        print('Received ' .. #zones .. ' zones from server')
    end
end)

-- Event handlers for zone data from server
RegisterNetEvent('zones:added')
AddEventHandler('zones:added', function(zone)
    zoneCache[zone.id] = zone
    CreateZonePoint(zone)
    CreateZoneBlip(zone)

    if debugMode then
        print('Added zone: ' .. zone.name)
    end
end)

RegisterNetEvent('zones:updated')
AddEventHandler('zones:updated', function(zone)
    zoneCache[zone.id] = zone
    CreateZonePoint(zone)
    CreateZoneBlip(zone)

    if debugMode then
        print('Updated zone: ' .. zone.name)
    end
end)

RegisterNetEvent('zones:deleted')
AddEventHandler('zones:deleted', function(zoneId)
    if playerInZones[zoneId] then
        TriggerEvent('zones:playerExited', zoneId)
        playerInZones[zoneId] = nil

        -- Check if player is still in any zone
        if next(playerInZones) == nil then
            RemoveZoneEffects()
        end
    end

    -- Remove zone point
    if zonePoints[zoneId] then
        zonePoints[zoneId]:remove()
        zonePoints[zoneId] = nil
    end

    -- Remove blips
    if zoneBlips[zoneId] then
        RemoveBlip(zoneBlips[zoneId])
        zoneBlips[zoneId] = nil
    end

    if zoneSprites[zoneId] then
        RemoveBlip(zoneSprites[zoneId])
        zoneSprites[zoneId] = nil
    end

    zoneCache[zoneId] = nil

    if debugMode then
        print('Deleted zone: ' .. zoneId)
    end
end)

-- Register commands for debugging
RegisterCommand('zonedebug', function(source, args)
    debugMode = not debugMode
    print('Zone debug mode: ' .. tostring(debugMode))

    if debugMode then
        local count = 0
        for _ in pairs(zoneCache) do count = count + 1 end
        print('Current zones in cache: ' .. count)

        local inCount = 0
        for _ in pairs(playerInZones) do inCount = inCount + 1 end
        print('Zones player is in: ' .. inCount)
    end
end, false)

-- Initialize
Citizen.CreateThread(function()
    Wait(1000) -- Wait for resource to initialize
    RequestAllZones()

    -- Ensure UI is hidden by default
    isUIVisible = false
    ToggleZoneUI(false)
end)
