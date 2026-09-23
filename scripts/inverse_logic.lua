ScriptHost:AddWatchForCode("Small Key Sanity Off", "small_key_sanity", small_keys_vanilla)
function small_keys_vanilla()
    return (Tracker:FindObjectForCode("shuffle_small_keys").CurrentStage == 1)
end

ScriptHost:AddWatchForCode("Boss Key Sanity Off", "boss_key_sanity", boss_keys_vanilla)
function boss_keys_vanilla()
    return (Tracker:FindObjectForCode("shuffle_boss_keys").CurrentStage == 1)
end