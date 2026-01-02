ScriptHost:AddWatchForCode("Small Key Sanity Off", "small_key_sanity", small_key_sanity_off)
function small_key_sanity_off()
    return (1 - Tracker:ProviderCountForCode("small_key_sanity") > 0)
end

ScriptHost:AddWatchForCode("Boss Key Sanity Off", "boss_key_sanity", boss_key_sanity_off)
function boss_key_sanity_off()
    return (1 - Tracker:ProviderCountForCode("boss_key_sanity") > 0)
end

ScriptHost:AddWatchForCode("Boss Souls Off", "boss_souls", boss_souls_off)
function boss_souls_off()
    return (1 - Tracker:ProviderCountForCode("boss_souls") > 0)
end

ScriptHost:AddWatchForCode("Absurd Souls Off", "absurd_souls", absurd_souls_off)
function absurd_souls_off()
    return (1 - Tracker:ProviderCountForCode("absurd_souls") > 0)
end

ScriptHost:AddWatchForCode("Misc. Souls Off", "misc_souls", misc_souls_off)
function misc_souls_off()
    return (1 - Tracker:ProviderCountForCode("misc_souls") > 0)
end

ScriptHost:AddWatchForCode("NPC Souls Off", "npc_souls", npc_souls_off)
function npc_souls_off()
    return (1 - Tracker:ProviderCountForCode("npc_souls") > 0)
end