ScriptHost:AddWatchForCode("Boss Souls Off", "boss_souls", boss_souls_off)
function boss_souls_off()
    return (1 - Tracker:ProviderCountForCode("boss_souls") > 0)
end