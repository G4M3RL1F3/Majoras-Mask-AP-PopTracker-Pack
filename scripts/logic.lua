---@diagnostic disable: redundant-parameter, lowercase-global, undefined-field, need-check-nil
-- Can reach specific locations (there's probably a better way to do this)
function canReachHealingInvisibleGoron()
    return can_use_lens() and can_play_healing()
end

function canReachIkanaWellInvisibleChest()
    return has("gibdo") and has("bottles", 1) and (has("adultswallet") or has("maskofscents"))
end

function canReachHotWaterGrottoChest()
    return (has_explosives() and can_use_fire_arrows()) or (canReachHealingInvisibleGoron() and has("bottles", 1) and has("goron") and has_explosives) or clear_snowhead() or (canReachIkanaWellInvisibleChest() and can_play_soaring())
end

-- Songs
function can_play_healing() -- was "play_healing"
    return has("healing") and has("ocarina")
end

function can_play_eponas()
    return has("epona") and has("ocarina")
end

function can_play_soaring()
    return has("soaring") and has("ocarina")
end

function can_play_storms()
    return has("storms") and has("ocarina")
end

function can_play_sonata() -- was "play_sonata"
    return has("sonata") and has("ocarina")
end

function can_play_lullaby()
    return has("goronlullaby") and has("ocarina")
end

function can_play_bossa_nova()
    return has("bossanova") and has("ocarina")
end

function can_play_elegy()
    return has("elegy") and has("ocarina")
end


-- Rules consistent between difficulties

function can_get_magic_beans() -- was "get_beans"
    return has("beans") and has("deku") and deku_palace()
end

-- has_bombchus() unnecessary: any bombchu pickup is linked to one toggle "bombchu"

function has_explosives() -- was "explosives"
    return has("bombs") or has("bombchu_bag") or has("blast")
end

function has_hard_projectiles() -- was "has_hard_projectiles"
    return has("bow") or has("zora") or has("hookshot")
end

function has_projectiles() -- was "projectiles"
    return (has("deku") and has("magic")) or has_hard_projectiles()
end

function can_smack_hard() -- was "smack_hard"
    return has("sword") or has("fiercedeity") or has("fairysword") or has("goron")
end

function can_smack() -- was "smack"
    return can_smack_hard() or has("deku")
end

function has_paper()
    return has("landdeed") or has("swampdeed") or has("mountaindeed") or has("oceandeed") or has("kafeiletter") or has("express")
end

function can_get_cow_milk()
    return has("bottles", 1) and can_play_eponas() and (has_explosives() or can_use_powder_keg() or has("hookshot") or (has("gibdo") and has("bottles",1) and can_plant_beans() and canReachHealingInvisibleGoron() or can_use_light_arrows() and (canReachHotWaterGrottoChest() or (has("goron") and canReachHealingInvisibleGoron()) or canReachIkanaWellInvisibleChest())))
end

function can_plant_beans() -- was "plant_beans"
    return can_get_magic_beans() and (has("bottles", 1) or can_play_storms())
end

function can_use_powder_keg() -- was "use_keg"
    return has("keg") and has("goron")
end

function can_use_fire_arrows() -- was "use_fire_arrows"
    return has("bow") and has("magic") and has("firearrow")
end

function can_use_ice_arrows() -- was "use_ice_arrows"
    return has("bow") and has("magic") and has("icearrow")
end

function can_use_light_arrows() -- was "use_light_arrows"
    return has("bow") and has("magic") and has("lightarrow")
end

function can_use_lens() -- was "use_lens"
    return has("lens") and has("magic")
end

function can_bring_to_player()
    return has("hookshot") or has("zora")
end

function can_reach_seahorse()
    return great_bay() and has("zora") and has("pictobox") and (has("hookshot") or has("goron"))
end


-- Easy difficulty rules
function baby_has_bombchus()
    return --[[has("bombchu1") and has("bombchu5") and has("bombchu10") and ]]has("bombchu_bag")
end

function baby_has_explosives()
    return has("bombs") and baby_has_bombchus() and has("blast")
end

function baby_has_hard_projectiles()
    return has("bow") and has("zora") and has("hookshot")
end

function baby_has_projectiles()
    return has("deku") and has("magic") and baby_has_hard_projectiles()
end

function baby_can_smack_hard()
    return has("sword") and has("fiercedeity") and has("fairysword") and has("goron") and has("zora")
end

function baby_can_smack()
    return has("deku") and baby_can_smack_hard()
end

function baby_has_paper()
    return has("landdeed") and has("swampdeed") and has("mountaindeed") or has("oceandeed") or has("kafeiletter") or has("express")
end

function baby_has_bottle()
    return has("empty_bottle") and has("redpotion") and has("chateau") and has("milk")
end

function baby_can_plant_beans()
    return can_get_magic_beans() and baby_has_bottle() and can_play_storms()
end

function baby_can_bring_to_player()
    return has("hookshot") and has("zora")
end

function baby_can_reach_seahorse()
    return great_bay() and has("zora") and has("hookshot") and has("goron") and has("pictobox")
end

function baby_can_get_cow_milk()
    return baby_has_bottle() and can_play_eponas() and baby_has_explosives() and can_use_powder_keg() and has("hookshot") and has("gibdo") and baby_can_plant_beans() and can_use_light_arrows() and canReachHotWaterGrottoChest() and has("goron") and canReachHealingInvisibleGoron() and canReachIkanaWellInvisibleChest()
end

-----
-- This function's purpose is for counting how many bottles have been acquired.
-- Currently used to check if the player has any bottle so that it can be accounted for logic.
function bottleCount()
    local bottle_count = Tracker:FindObjectForCode("bottles")
    bottle_count.AcquiredCount = bottle_count.MinCount
    if Tracker:FindObjectForCode("milk").Active then
        if (bottle_count.AcquiredCount + bottle_count.Increment) >= bottle_count.MaxCount then
            bottle_count.AcquiredCount = bottle_count.MaxCount
        else
        bottle_count.AcquiredCount = bottle_count.AcquiredCount + bottle_count.Increment
        end
    end
    if Tracker:FindObjectForCode("chateau").Active then
        if (bottle_count.AcquiredCount + bottle_count.Increment) >= bottle_count.MaxCount then
            bottle_count.AcquiredCount = bottle_count.MaxCount
        else
        bottle_count.AcquiredCount = bottle_count.AcquiredCount + bottle_count.Increment
        end
    end
    if Tracker:FindObjectForCode("redpotion").Active then
        if (bottle_count.AcquiredCount + bottle_count.Increment) >= bottle_count.MaxCount then
            bottle_count.AcquiredCount = bottle_count.MaxCount
        else
        bottle_count.AcquiredCount = bottle_count.AcquiredCount + bottle_count.Increment
        end
    end
    if Tracker:FindObjectForCode("gold_dust").Active then
        if (bottle_count.AcquiredCount + bottle_count.Increment) >= bottle_count.MaxCount then
            bottle_count.AcquiredCount = bottle_count.MaxCount
        else
        bottle_count.AcquiredCount = bottle_count.AcquiredCount + bottle_count.Increment
        end
    end
    if Tracker:FindObjectForCode("empty_bottle").AcquiredCount == 1 then
        if (bottle_count.AcquiredCount + bottle_count.Increment) >= bottle_count.MaxCount then
            bottle_count.AcquiredCount = bottle_count.MaxCount
        else
        bottle_count.AcquiredCount = bottle_count.AcquiredCount + bottle_count.Increment
        end
    elseif Tracker:FindObjectForCode("empty_bottle").AcquiredCount == 2 then
        if (bottle_count.AcquiredCount + bottle_count.Increment + bottle_count.Increment) >= bottle_count.MaxCount then
            bottle_count.AcquiredCount = bottle_count.MaxCount
        else
        bottle_count.AcquiredCount = bottle_count.AcquiredCount + bottle_count.Increment + bottle_count.Increment
        end
    end
end

function remainCount()
    local remains_count = Tracker:FindObjectForCode("remains_count")
    remains_count.AcquiredCount = remains_count.MinCount
    if Tracker:FindObjectForCode("odolwa").Active then
        if (remains_count.AcquiredCount + remains_count.Increment) >= remains_count.MaxCount then
            remains_count.AcquiredCount = remains_count.MaxCount
        else
            remains_count.AcquiredCount = remains_count.AcquiredCount + remains_count.Increment
        end
    end
    if Tracker:FindObjectForCode("goht").Active then
        if (remains_count.AcquiredCount + remains_count.Increment) >= remains_count.MaxCount then
            remains_count.AcquiredCount = remains_count.MaxCount
        else
            remains_count.AcquiredCount = remains_count.AcquiredCount + remains_count.Increment
        end
    end
    if Tracker:FindObjectForCode("gyorg").Active then
        if (remains_count.AcquiredCount + remains_count.Increment) >= remains_count.MaxCount then
            remains_count.AcquiredCount = remains_count.MaxCount
        else
            remains_count.AcquiredCount = remains_count.AcquiredCount + remains_count.Increment
        end
    end
    if Tracker:FindObjectForCode("twinmold").Active then
        if (remains_count.AcquiredCount + remains_count.Increment) >= remains_count.MaxCount then
            remains_count.AcquiredCount = remains_count.MaxCount
        else
            remains_count.AcquiredCount = remains_count.AcquiredCount + remains_count.Increment
        end
    end
    if remains_count.AcquiredCount >= Tracker:FindObjectForCode("moon_remains_required").AcquiredCount then
        Tracker:FindObjectForCode("remains_moon").Active = true
    else
        Tracker:FindObjectForCode("remains_moon").Active = false
    end
end

--function remainsMajora()
--    if Tracker:FindObjectForCode("remains_count").AcquiredCount >= Tracker:FindObjectForCode("majora_remains_required").AcquiredCount then
--        Tracker:FindObjectForCode("remains_majora").Active = true
--    end
--end

function clear_wft()
    if Tracker:FindObjectForCode("boss_odolwa_hosted").Active then
        Tracker:FindObjectForCode("wftreward").Active = true
    end
    if Tracker:FindObjectForCode("boss_odolwa_hosted").Active == false then
        Tracker:FindObjectForCode("wftreward").Active = false
    end
end


ScriptHost:AddWatchForCode("bottlecounter_wft", "boss_odolwa_hosted", clear_wft)
ScriptHost:AddWatchForCode("bottlecounter_red", "redpotion", bottleCount)
ScriptHost:AddWatchForCode("bottlecounter_milk", "milk", bottleCount)
ScriptHost:AddWatchForCode("bottlecounter_chateau", "chateau", bottleCount)
ScriptHost:AddWatchForCode("bottlecounter_gold", "gold_dust", bottleCount)
ScriptHost:AddWatchForCode("bottlecounter_empty_bottle", "empty_bottle", bottleCount)
ScriptHost:AddWatchForCode("OdolwaObtained", "odolwa", remainCount)
ScriptHost:AddWatchForCode("GohtObtained", "goht", remainCount)
ScriptHost:AddWatchForCode("GyorgObtained", "gyorg", remainCount)
ScriptHost:AddWatchForCode("TwinmoldObtained", "twinmold", remainCount)