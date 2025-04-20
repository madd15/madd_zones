Config = {}

Config.EnableNotifications = true -- Do you want notifications when a player enters and exits the preconfigured greenzones (The Config.GreenZones)?
Config.ZonesCommand = 'setzone' -- The command to run in-game to start creating a temporary greenzone
Config.ZonesClearCommand = 'clearzone' -- The command to run in-game to clear an existing temporary greenzone

Config.PermZones = { -- These are persistent greenzones that exist constantly, at all times - you can create as many as you want here
    ['hospital'] = {
        name = 'hospital',
        zoneType = 'green',
        coords = vec3(316.92, -591.24, 43.28), -- The center-most location of the greenzone
        radius = 37.0, -- The radius (how large or small) the greenzone is (note: this must include the .0 on the end of the number to work)
        disablePlayerVehicleCollision = false, -- Do you want to disable players & their vehicles collisions between each other? (true if yes, false if no)
        enableSpeedLimits = true, -- Do you want to enforce a speed limit in this zone? (true if yes, false if no)
        setSpeedLimit = 25, -- The speed limit (in MPH) that will be enforced in this zone if enableSpeedLimits is true
        removeWeapons = false, -- Do you want to remove weapons completely from players hands while in this zone? (true if yes, false if no)
        disableFiring = false, -- Do you want to disable everyone from firing weapons/punching/etc in this zone? (true if yes, false if no)
        setInvincible = false, -- Do you want everyone to be invincible in this zone? (true if yes, false if no)
        displayTextUI = true, -- Do you want textUI to display on everyones screen while in this zone? (true if yes, false if no)
        textToDisplay = 'Green Zone', -- The text to display on everyones screen if displayTextUI is true for this zone
        backgroundColorTextUI = '#4BB543', -- The color of the textUI background to display if displayTextUI is true for this zone
        textColor = '#FFFFFF', -- The color of the text & icon itself on the textUI if displayTextUI is true for this zone
        displayTextPosition = 'right-center', -- The position of the textUI if displayTextUI is true for this zone
        displayTextIcon = 'hospital', -- The icon to be displayed on the TextUI in this zone if displayTextUI is true
        blip = true, -- Do you want a blip to display on the map here? True for yes, false for no
        enableSprite = false, -- Do you want a sprite at the center of the radius blip? (If blipType = 'normal', this don't matter, it will display a sprite)
        blipSprite = 621, -- Blip sprite (https://docs.fivem.net/docs/game-references/blips/) (only used if enableSprite = true, otherwise can be ignored)
        blipColor = 2, -- Blip color (https://docs.fivem.net/docs/game-references/blips/#blip-colors)
        blipScale = 0.7, -- Blip size (0.01 to 1.0) (only used if enableSprite = true, otherwise can be ignored)
        blipAlpha = 100, -- The transparency of the radius blip if blipType = 'radius', otherwise not used/can be ignored
        blipName = 'Green Zone' -- Blip name on the map (if enableSprite = true, otherwise can be ignored)
    },
    ['cayo'] = {
        name = 'cayo',
        zoneType = 'red',
        coords = vec3(4689.06, -5215.89, 4.0), -- The center-most location of the greenzone
        radius = 1250.0, -- The radius (how large or small) the greenzone is (note: this must include the .0 on the end of the number to work)
        disablePlayerVehicleCollision = false, -- Do you want to disable players & their vehicles collisions between each other? (true if yes, false if no)
        enableSpeedLimits = false, -- Do you want to enforce a speed limit in this zone? (true if yes, false if no)
        setSpeedLimit = 25, -- The speed limit (in MPH) that will be enforced in this zone if enableSpeedLimits is true
        removeWeapons = false, -- Do you want to remove weapons completely from players hands while in this zone? (true if yes, false if no)
        disableFiring = false, -- Do you want to disable everyone from firing weapons/punching/etc in this zone? (true if yes, false if no)
        setInvincible = false, -- Do you want everyone to be invincible in this zone? (true if yes, false if no)
        displayTextUI = true, -- Do you want textUI to display on everyones screen while in this zone? (true if yes, false if no)
        textToDisplay = 'Red Zone', -- The text to display on everyones screen if displayTextUI is true for this zone
        backgroundColorTextUI = '#8a1515', -- The color of the textUI background to display if displayTextUI is true for this zone
        textColor = '#FFFFFF', -- The color of the text & icon itself on the textUI if displayTextUI is true for this zone
        displayTextPosition = 'right-center', -- The position of the textUI if displayTextUI is true for this zone
        displayTextIcon = 'skull', -- The icon to be displayed on the TextUI in this zone if displayTextUI is true
        blip = true, -- Do you want a blip to display on the map here? True for yes, false for no
        blipType = 'radius', -- Type can be 'radius' or 'normal'
        enableSprite = false, -- Do you want a sprite at the center of the radius blip? (If blipType = 'normal', this don't matter, it will display a sprite)
        blipSprite = 621, -- Blip sprite (https://docs.fivem.net/docs/game-references/blips/) (only used if enableSprite = true, otherwise can be ignored)
        blipColor = 1, -- Blip color (https://docs.fivem.net/docs/game-references/blips/#blip-colors)
        blipScale = 0.7, -- Blip size (0.01 to 1.0) (only used if enableSprite = true, otherwise can be ignored)
        blipAlpha = 100, -- The transparency of the radius blip if blipType = 'radius', otherwise not used/can be ignored
        blipName = 'Red Zone' -- Blip name on the map (if enableSprite = true, otherwise can be ignored)
    },
    ['smelter'] = {
        name = 'smelter',
        zoneType = 'green',
        coords = vec3(1061.82, -1971.50, 31.01), -- The center-most location of the greenzone
        radius = 85.0, -- The radius (how large or small) the greenzone is (note: this must include the .0 on the end of the number to work)
        disablePlayerVehicleCollision = false, -- Do you want to disable players & their vehicles collisions between each other? (true if yes, false if no)
        enableSpeedLimits = false, -- Do you want to enforce a speed limit in this zone? (true if yes, false if no)
        setSpeedLimit = 25, -- The speed limit (in MPH) that will be enforced in this zone if enableSpeedLimits is true
        removeWeapons = false, -- Do you want to remove weapons completely from players hands while in this zone? (true if yes, false if no)
        disableFiring = false, -- Do you want to disable everyone from firing weapons/punching/etc in this zone? (true if yes, false if no)
        setInvincible = false, -- Do you want everyone to be invincible in this zone? (true if yes, false if no)
        displayTextUI = true, -- Do you want textUI to display on everyones screen while in this zone? (true if yes, false if no)
        textToDisplay = 'Green Zone', -- The text to display on everyones screen if displayTextUI is true for this zone
        backgroundColorTextUI = '#4BB543', -- The color of the textUI background to display if displayTextUI is true for this zone
        textColor = '#FFFFFF', -- The color of the text & icon itself on the textUI if displayTextUI is true for this zone
        displayTextPosition = 'left-center', -- The position of the textUI if displayTextUI is true for this zone
        displayTextIcon = 'user-shield', -- The icon to be displayed on the TextUI in this zone if displayTextUI is true
        blip = true, -- Do you want a blip to display on the map here? True for yes, false for no
        blipType = 'radius', -- Type can be 'radius' or 'normal'
        enableSprite = false, -- Do you want a sprite at the center of the radius blip? (If blipType = 'normal', this don't matter, it will display a sprite)
        blipSprite = 621, -- Blip sprite (https://docs.fivem.net/docs/game-references/blips/) (only used if enableSprite = true, otherwise can be ignored)
        blipColor = 2, -- Blip color (https://docs.fivem.net/docs/game-references/blips/#blip-colors)
        blipScale = 0.7, -- Blip size (0.01 to 1.0) (only used if enableSprite = true, otherwise can be ignored)
        blipAlpha = 100, -- The transparency of the radius blip if blipType = 'radius', otherwise not used/can be ignored
        blipName = 'Green Zone' -- Blip name on the map (if enableSprite = true, otherwise can be ignored)
    },
    ['zancudo_base'] = {
        name = 'zancudo_base',
        zoneType = 'red',
        coords = vec3(-2053.386, 3153.212, 5.0), -- The center-most location of the greenzone
        radius = 350.0, -- The radius (how large or small) the greenzone is (note: this must include the .0 on the end of the number to work)
        disablePlayerVehicleCollision = false, -- Do you want to disable players & their vehicles collisions between each other? (true if yes, false if no)
        enableSpeedLimits = false, -- Do you want to enforce a speed limit in this zone? (true if yes, false if no)
        setSpeedLimit = 25, -- The speed limit (in MPH) that will be enforced in this zone if enableSpeedLimits is true
        removeWeapons = false, -- Do you want to remove weapons completely from players hands while in this zone? (true if yes, false if no)
        disableFiring = false, -- Do you want to disable everyone from firing weapons/punching/etc in this zone? (true if yes, false if no)
        setInvincible = false, -- Do you want everyone to be invincible in this zone? (true if yes, false if no)
        displayTextUI = true, -- Do you want textUI to display on everyones screen while in this zone? (true if yes, false if no)
        textToDisplay = 'Red Zone', -- The text to display on everyones screen if displayTextUI is true for this zone
        backgroundColorTextUI = '#8a1515', -- The color of the textUI background to display if displayTextUI is true for this zone
        textColor = '#FFFFFF', -- The color of the text & icon itself on the textUI if displayTextUI is true for this zone
        displayTextPosition = 'right-center', -- The position of the textUI if displayTextUI is true for this zone
        displayTextIcon = 'skull', -- The icon to be displayed on the TextUI in this zone if displayTextUI is true
        blip = false, -- Do you want a blip to display on the map here? True for yes, false for no
        blipType = 'radius', -- Type can be 'radius' or 'normal'
        enableSprite = false, -- Do you want a sprite at the center of the radius blip? (If blipType = 'normal', this don't matter, it will display a sprite)
        blipSprite = 621, -- Blip sprite (https://docs.fivem.net/docs/game-references/blips/) (only used if enableSprite = true, otherwise can be ignored)
        blipColor = 1, -- Blip color (https://docs.fivem.net/docs/game-references/blips/#blip-colors)
        blipScale = 0.7, -- Blip size (0.01 to 1.0) (only used if enableSprite = true, otherwise can be ignored)
        blipAlpha = 100, -- The transparency of the radius blip if blipType = 'radius', otherwise not used/can be ignored
        blipName = 'Red Zone' -- Blip name on the map (if enableSprite = true, otherwise can be ignored)
    },
    ['StFiacre'] = {
        name = 'StFiacre',
        zoneType = 'green',
        coords = vector3(1154.26, -1547.44, 35.03), -- The center-most location of the greenzone
        radius = 37.0, -- The radius (how large or small) the greenzone is (note: this must include the .0 on the end of the number to work)
        disablePlayerVehicleCollision = false, -- Do you want to disable players & their vehicles collisions between each other? (true if yes, false if no)
        enableSpeedLimits = true, -- Do you want to enforce a speed limit in this zone? (true if yes, false if no)
        setSpeedLimit = 25, -- The speed limit (in MPH) that will be enforced in this zone if enableSpeedLimits is true
        removeWeapons = false, -- Do you want to remove weapons completely from players hands while in this zone? (true if yes, false if no)
        disableFiring = false, -- Do you want to disable everyone from firing weapons/punching/etc in this zone? (true if yes, false if no)
        setInvincible = false, -- Do you want everyone to be invincible in this zone? (true if yes, false if no)
        displayTextUI = true, -- Do you want textUI to display on everyones screen while in this zone? (true if yes, false if no)
        textToDisplay = 'Green Zone', -- The text to display on everyones screen if displayTextUI is true for this zone
        backgroundColorTextUI = '#4BB543', -- The color of the textUI background to display if displayTextUI is true for this zone
        textColor = '#FFFFFF', -- The color of the text & icon itself on the textUI if displayTextUI is true for this zone
        displayTextPosition = 'right-center', -- The position of the textUI if displayTextUI is true for this zone
        displayTextIcon = 'hospital', -- The icon to be displayed on the TextUI in this zone if displayTextUI is true
        blip = true, -- Do you want a blip to display on the map here? True for yes, false for no
        blipType = 'radius', -- Type can be 'radius' or 'normal'
        enableSprite = false, -- Do you want a sprite at the center of the radius blip? (If blipType = 'normal', this don't matter, it will display a sprite)
        blipSprite = 621, -- Blip sprite (https://docs.fivem.net/docs/game-references/blips/) (only used if enableSprite = true, otherwise can be ignored)
        blipColor = 2, -- Blip color (https://docs.fivem.net/docs/game-references/blips/#blip-colors)
        blipScale = 0.7, -- Blip size (0.01 to 1.0) (only used if enableSprite = true, otherwise can be ignored)
        blipAlpha = 100, -- The transparency of the radius blip if blipType = 'radius', otherwise not used/can be ignored
        blipName = 'Green Zone' -- Blip name on the map (if enableSprite = true, otherwise can be ignored)
    },
}

Notifications = {
    position = 'top-right', -- The position for all notifications
    ['green'] = {
        Enter = {
            title = 'Entered Green Zone',
            description = 'No hostility is permitted!  \n  \n Vehicle speeds maybe reduced in this area', -- Description when entering a greenzone
        },
        Exit = {
            title = 'Exited Green Zone',
            description = 'Normal RP rules resume!', -- Description when exiting a greenzone
        }
    },
    ['red'] = {
        Enter = {
            title = 'Entered Red Zone',
            description = 'Kill on sight is in affect!', -- Description when entering a greenzone
        },
        Exit = {
            title = 'Exited Red Zone',
            description = 'Kill on sight no longer applies!', -- Description when exiting a greenzone
        }
    }
}