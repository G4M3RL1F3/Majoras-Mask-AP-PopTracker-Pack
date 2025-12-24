ScriptHost:AddWatchForCode("Small Key Sanity Off", "small_key_sanity", small_key_sanity_off)
function small_key_sanity_off()
    return (1 - Tracker:ProviderCountForCode("small_key_sanity") > 0)
end

ScriptHost:AddWatchForCode("Boss Key Sanity Off", "boss_key_sanity", boss_key_sanity_off)
function boss_key_sanity_off()
    return (1 - Tracker:ProviderCountForCode("boss_key_sanity") > 0)
end