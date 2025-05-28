ENABLE_DEBUG_LOG = true -- Disable before any releases

local variant = Tracker.ActiveVariantUID
IS_STANDARD = variant:find("standard")
IS_ITEMS_ONLY = variant:find("itemsonly")
IS_MAPS_ONLY = variant:find("mapsonly")

if ENABLE_DEBUG_LOG then
    print("Debug logging is enabled!")
end

ScriptHost:LoadScript("scripts/utils.lua")
ScriptHost:LoadScript("scripts/logic.lua")
ScriptHost:LoadScript("scripts/regions.lua")
ScriptHost:LoadScript("scripts/broadcast.lua")
ScriptHost:LoadScript("scripts/items.lua")

if IS_STANDARD then
    Tracker:AddMaps("maps/maps.json")
    Tracker:AddLayouts("layouts/tabs.jsonc")
    ScriptHost:LoadScript("scripts/locations.lua")
    ScriptHost:LoadScript("scripts/layouts.lua")
end

if IS_ITEMS_ONLY then
    ScriptHost:LoadScript("scripts/layouts.lua")
end

if IS_MAPS_ONLY then
    Tracker:AddMaps("maps/maps.json")
    Tracker:AddLayouts("layouts/tabs.jsonc")
    ScriptHost:LoadScript("scripts/locations.lua")
    Tracker:AddLayouts("layouts/settings_popup.jsonc")
    Tracker:AddLayouts("layouts/settings.jsonc")
    Tracker:AddLayouts("var_z_maps_only/layouts/tracker.jsonc")
end

if PopVersion and PopVersion >= "0.18.0" then
    ScriptHost:LoadScript("scripts/autotracking.lua")
end

initialize_watch_items()