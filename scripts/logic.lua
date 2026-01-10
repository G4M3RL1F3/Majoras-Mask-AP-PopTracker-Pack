function can_warp_out()
    return can_play_song("soaring") and (can_use_owl("owl_ct") or can_use_owl("owl_milk_road") or can_use_owl("owl_swamp") or can_use_owl("owl_ikana_canyon") or can_use_owl("owl_stone_tower"))
end

-- Rules consistent between difficulties

function can_get_magic_beans()
    return has_npc_soul("soul_bean_seller") and has_absurd_soul("soul_grottos") and has("deku") and deku_palace()
end

-- has_bombchus() unnecessary: any bombchu pickup is linked to one toggle "bombchu"

function has_explosives()
    return has("bombs") or has("bombchu_bag") or has("blast")
end

function has_hard_projectiles()
    return has("bow") or has("zora") or has("hookshot")
end

function has_projectiles()
    return (has("deku") and has("magic")) or has_hard_projectiles()
end

function can_smack_hard()
    return has("sword") or has("fiercedeity") or has("fairysword") or has("goron") or has("zora")
end

function can_smack()
    return can_smack_hard() or has("deku")
end

function has_paper()
    return has("landdeed") or has("swampdeed") or has("mountaindeed") or has("oceandeed") or has("kafeiletter") or has("express")
end

function can_get_cow_milk()
    return has_misc_soul("soul_cow") and has_absurd_soul("soul_grottos") and has("bottles", 1) and can_play_song("epona") and (has_explosives() or can_use_powder_keg() or has("hookshot") or (has_npc_soul("soul_barten") and has("romani")) or (has("gibdo") and has_npc_soul("soul_gibdos") and has("bottles", 1) and can_plant_beans() and Tracker:FindObjectForCode("@Snowhead/Twin Islands/Hot Water Grotto Chest") or can_use_light_arrows() and (Tracker:FindObjectForCode("@Snowhead/Twin Islands/Hot Water Grotto Chest") or (has("goron") and can_use_lens()) or Tracker:FindObjectForCode("@Dungeons/Beneath the Well/Invisible Chest"))))
end

function can_plant_beans()
    return can_get_magic_beans() and (has("bottles", 1) or can_play_song("storms"))
end

function can_use_powder_keg()
    return has("keg") and has("goron") and has_npc_soul("soul_keg_goron") or (has_npc_soul("soul_medigoron") and can_use_fire_arrows() and has("adultswallet"))
end

function can_use_fire_arrows()
    return has("bow") and has("magic") and has("firearrow")
end

function can_use_ice_arrows()
    return has("bow") and has("magic") and has("icearrow")
end

function can_use_light_arrows()
    return has("bow") and has("magic") and has("lightarrow")
end

function can_use_lens()
    return has("lens") and has("magic")
end

function can_bring_to_player()
    return has("hookshot") or has("zora")
end

function can_reach_seahorse()
    return great_bay() and has_npc_soul("soul_fisherman") and has_npc_soul("soul_pirate_guards") and has("zora") and has("pictobox") and (has("hookshot") or has("goron"))
end

function can_get_frog_choir_hp()
    if not has("dongero") then      -- If Don Gero Mask hasn't been obtained, then it's unobtainable.
        return false
    end
    if not clear_snowhead() then    -- If Snowhead cannot be cleared, then it's unobtainable.
        return false
    end

    if has("frogsanity") then       -- If frogsanity is on, check for frog items. Otherwise, check for vanilla locations access rules.
        return has("frog_yellow") and has("frog_white") and has("frog_cyan") and has("frog_blue") and has("frog_pink")
    else
        return Tracker:FindObjectForCode("@Dungeons/Woodfall Temple/Woodfall Temple Gekko Chest") and great_bay_temple() and can_use_ice_arrows() and can_use_fire_arrows()
    end
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
    return can_get_magic_beans() and baby_has_bottle() and can_play_song("storms")
end

function baby_can_bring_to_player()
    return has("hookshot") and has("zora")
end

function baby_can_reach_seahorse()
    return great_bay() and has("soul_fisherman") and has("zora") and has("pictobox") and (has("hookshot") or has("goron"))
end

function baby_can_get_cow_milk()
    return baby_has_bottle() and can_play_song("epona") and baby_has_explosives() and can_use_powder_keg() and has("hookshot") and has("gibdo") and baby_can_plant_beans() and can_use_light_arrows() and Tracker:FindObjectForCode("@Snowhead/Twin Islands/Hot Water Grotto Chest") and has("goron") and Tracker:FindObjectForCode("@Snowhead/Mountain Village/Healing Darmani") and Tracker:FindObjectForCode("@Dungeons/Beneath the Well/Invisible Chest")
end

-- This function's purpose is for counting how many bottles have been acquired.
-- Currently used to check if the player has any bottle so that it can be accounted for logic.
function bottleCount(bottles_needed)
    local current_bottle_count
    current_bottle_count = 0
    if Tracker:FindObjectForCode("milk").Active then
        current_bottle_count = current_bottle_count + 1
    end
    if Tracker:FindObjectForCode("chateau").Active then
        current_bottle_count = current_bottle_count + 1
    end
    if Tracker:FindObjectForCode("redpotion").Active then
        current_bottle_count = current_bottle_count + 1
    end
    if Tracker:FindObjectForCode("empty_bottle").AcquiredCount == 1 then
        current_bottle_count = current_bottle_count + 1
    elseif Tracker:FindObjectForCode("empty_bottle").AcquiredCount == 2 then
        current_bottle_count = current_bottle_count + 2
    elseif Tracker:FindObjectForCode("empty_bottle").AcquiredCount == 3 then
        current_bottle_count = current_bottle_count + 3
    end
    if current_bottle_count >= bottles_needed then
        return true
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


function maskCount()
    local masks_count = Tracker:FindObjectForCode("masks_count")
    masks_count.AcquiredCount = masks_count.MinCount
    if Tracker:FindObjectForCode("captain").Active then
        if (masks_count.AcquiredCount + masks_count.Increment) >= masks_count.MaxCount then
            masks_count.AcquiredCount = masks_count.MaxCount
        else
            masks_count.AcquiredCount = masks_count.AcquiredCount + masks_count.Increment
        end
    end
    if Tracker:FindObjectForCode("allnight").Active then
        if (masks_count.AcquiredCount + masks_count.Increment) >= masks_count.MaxCount then
            masks_count.AcquiredCount = masks_count.MaxCount
        else
            masks_count.AcquiredCount = masks_count.AcquiredCount + masks_count.Increment
        end
    end
    if Tracker:FindObjectForCode("bunnyhood").Active then
        if (masks_count.AcquiredCount + masks_count.Increment) >= masks_count.MaxCount then
            masks_count.AcquiredCount = masks_count.MaxCount
        else
            masks_count.AcquiredCount = masks_count.AcquiredCount + masks_count.Increment
        end
    end
    if Tracker:FindObjectForCode("keaton").Active then
        if (masks_count.AcquiredCount + masks_count.Increment) >= masks_count.MaxCount then
            masks_count.AcquiredCount = masks_count.MaxCount
        else
            masks_count.AcquiredCount = masks_count.AcquiredCount + masks_count.Increment
        end
    end
    if Tracker:FindObjectForCode("garo").Active then
        if (masks_count.AcquiredCount + masks_count.Increment) >= masks_count.MaxCount then
            masks_count.AcquiredCount = masks_count.MaxCount
        else
            masks_count.AcquiredCount = masks_count.AcquiredCount + masks_count.Increment
        end
    end
    if Tracker:FindObjectForCode("romani").Active then
        if (masks_count.AcquiredCount + masks_count.Increment) >= masks_count.MaxCount then
            masks_count.AcquiredCount = masks_count.MaxCount
        else
            masks_count.AcquiredCount = masks_count.AcquiredCount + masks_count.Increment
        end
    end
    if Tracker:FindObjectForCode("circus").Active then
        if (masks_count.AcquiredCount + masks_count.Increment) >= masks_count.MaxCount then
            masks_count.AcquiredCount = masks_count.MaxCount
        else
            masks_count.AcquiredCount = masks_count.AcquiredCount + masks_count.Increment
        end
    end
    if Tracker:FindObjectForCode("postman").Active then
        if (masks_count.AcquiredCount + masks_count.Increment) >= masks_count.MaxCount then
            masks_count.AcquiredCount = masks_count.MaxCount
        else
            masks_count.AcquiredCount = masks_count.AcquiredCount + masks_count.Increment
        end
    end
    if Tracker:FindObjectForCode("couple").Active then
        if (masks_count.AcquiredCount + masks_count.Increment) >= masks_count.MaxCount then
            masks_count.AcquiredCount = masks_count.MaxCount
        else
            masks_count.AcquiredCount = masks_count.AcquiredCount + masks_count.Increment
        end
    end
    if Tracker:FindObjectForCode("fairymask").Active then
        if (masks_count.AcquiredCount + masks_count.Increment) >= masks_count.MaxCount then
            masks_count.AcquiredCount = masks_count.MaxCount
        else
            masks_count.AcquiredCount = masks_count.AcquiredCount + masks_count.Increment
        end
    end
    if Tracker:FindObjectForCode("gibdo").Active then
        if (masks_count.AcquiredCount + masks_count.Increment) >= masks_count.MaxCount then
            masks_count.AcquiredCount = masks_count.MaxCount
        else
            masks_count.AcquiredCount = masks_count.AcquiredCount + masks_count.Increment
        end
    end
    if Tracker:FindObjectForCode("dongero").Active then
        if (masks_count.AcquiredCount + masks_count.Increment) >= masks_count.MaxCount then
            masks_count.AcquiredCount = masks_count.MaxCount
        else
            masks_count.AcquiredCount = masks_count.AcquiredCount + masks_count.Increment
        end
    end
    if Tracker:FindObjectForCode("kamaro").Active then
        if (masks_count.AcquiredCount + masks_count.Increment) >= masks_count.MaxCount then
            masks_count.AcquiredCount = masks_count.MaxCount
        else
            masks_count.AcquiredCount = masks_count.AcquiredCount + masks_count.Increment
        end
    end
    if Tracker:FindObjectForCode("truth").Active then
        if (masks_count.AcquiredCount + masks_count.Increment) >= masks_count.MaxCount then
            masks_count.AcquiredCount = masks_count.MaxCount
        else
            masks_count.AcquiredCount = masks_count.AcquiredCount + masks_count.Increment
        end
    end
    if Tracker:FindObjectForCode("stone").Active then
        if (masks_count.AcquiredCount + masks_count.Increment) >= masks_count.MaxCount then
            masks_count.AcquiredCount = masks_count.MaxCount
        else
            masks_count.AcquiredCount = masks_count.AcquiredCount + masks_count.Increment
        end
    end
    if Tracker:FindObjectForCode("breman").Active then
        if (masks_count.AcquiredCount + masks_count.Increment) >= masks_count.MaxCount then
            masks_count.AcquiredCount = masks_count.MaxCount
        else
            masks_count.AcquiredCount = masks_count.AcquiredCount + masks_count.Increment
        end
    end
    if Tracker:FindObjectForCode("blast").Active then
        if (masks_count.AcquiredCount + masks_count.Increment) >= masks_count.MaxCount then
            masks_count.AcquiredCount = masks_count.MaxCount
        else
            masks_count.AcquiredCount = masks_count.AcquiredCount + masks_count.Increment
        end
    end
    if Tracker:FindObjectForCode("scents").Active then
        if (masks_count.AcquiredCount + masks_count.Increment) >= masks_count.MaxCount then
            masks_count.AcquiredCount = masks_count.MaxCount
        else
            masks_count.AcquiredCount = masks_count.AcquiredCount + masks_count.Increment
        end
    end
    if Tracker:FindObjectForCode("kafei").Active then
        if (masks_count.AcquiredCount + masks_count.Increment) >= masks_count.MaxCount then
            masks_count.AcquiredCount = masks_count.MaxCount
        else
            masks_count.AcquiredCount = masks_count.AcquiredCount + masks_count.Increment
        end
    end
    if Tracker:FindObjectForCode("giant").Active then
        if (masks_count.AcquiredCount + masks_count.Increment) >= masks_count.MaxCount then
            masks_count.AcquiredCount = masks_count.MaxCount
        else
            masks_count.AcquiredCount = masks_count.AcquiredCount + masks_count.Increment
        end
    end
    if Tracker:FindObjectForCode("deku").Active then
        if (masks_count.AcquiredCount + masks_count.Increment) >= masks_count.MaxCount then
            masks_count.AcquiredCount = masks_count.MaxCount
        else
            masks_count.AcquiredCount = masks_count.AcquiredCount + masks_count.Increment
        end
    end
    if Tracker:FindObjectForCode("goron").Active then
        if (masks_count.AcquiredCount + masks_count.Increment) >= masks_count.MaxCount then
            masks_count.AcquiredCount = masks_count.MaxCount
        else
            masks_count.AcquiredCount = masks_count.AcquiredCount + masks_count.Increment
        end
    end
    if Tracker:FindObjectForCode("zora").Active then
        if (masks_count.AcquiredCount + masks_count.Increment) >= masks_count.MaxCount then
            masks_count.AcquiredCount = masks_count.MaxCount
        else
            masks_count.AcquiredCount = masks_count.AcquiredCount + masks_count.Increment
        end
    end
    if Tracker:FindObjectForCode("fiercedeitymask").Active then
        if (masks_count.AcquiredCount + masks_count.Increment) >= masks_count.MaxCount then
            masks_count.AcquiredCount = masks_count.MaxCount
        else
            masks_count.AcquiredCount = masks_count.AcquiredCount + masks_count.Increment
        end
    end
    if masks_count.AcquiredCount >= Tracker:FindObjectForCode("masks_required").AcquiredCount then
        Tracker:FindObjectForCode("masks_moon").Active = true
    else
        Tracker:FindObjectForCode("masks_moon").Active = false
    end
end

function can_afford(location)
    local price = 0
    for key, value in ipairs(RANDOMIZED_PRICES) do
        if location == value[1] then
            price = value[2]
            break
        end
    end
    if price > 200 then
        return has("giantswallet")
    elseif price > 99 then
        return has("adultswallet")
    elseif price <= 99 then
        return true
    end
end

function clear_wft()
    if Tracker:FindObjectForCode("boss_odolwa_hosted").Active then
        Tracker:FindObjectForCode("wftreward").Active = true
    end
    if Tracker:FindObjectForCode("boss_odolwa_hosted").Active == false then
        Tracker:FindObjectForCode("wftreward").Active = false
    end
end

function clear_sht()
    if Tracker:FindObjectForCode("boss_goht_hosted").Active then
        Tracker:FindObjectForCode("shtreward").Active = true
    end
    if Tracker:FindObjectForCode("boss_goht_hosted").Active == false then
        Tracker:FindObjectForCode("shtreward").Active = false
    end
end

function clock_town_map_purchased_1()
    if Tracker:FindObjectForCode("clock_town_map_purchase_1").Active == true then
        Tracker:FindObjectForCode("clock_town_map_purchase_2").Active = true
    elseif Tracker:FindObjectForCode("clock_town_map_purchase_1").Active == false then
        Tracker:FindObjectForCode("clock_town_map_purchase_2").Active = false
    end
end
function clock_town_map_purchased_2()
    if Tracker:FindObjectForCode("clock_town_map_purchase_2").Active == true then
        Tracker:FindObjectForCode("clock_town_map_purchase_1").Active = true
    elseif Tracker:FindObjectForCode("clock_town_map_purchase_2").Active == false then
        Tracker:FindObjectForCode("clock_town_map_purchase_1").Active = false
    end
end

function snowhead_map_purchased_1()
    if Tracker:FindObjectForCode("snowhead_map_purchase_1").Active == true then
        Tracker:FindObjectForCode("snowhead_map_purchase_2").Active = true
    elseif Tracker:FindObjectForCode("snowhead_map_purchase_1").Active == false then
        Tracker:FindObjectForCode("snowhead_map_purchase_2").Active = false
    end
end
function snowhead_map_purchased_2()
    if Tracker:FindObjectForCode("snowhead_map_purchase_2").Active == true then
        Tracker:FindObjectForCode("snowhead_map_purchase_1").Active = true
    elseif Tracker:FindObjectForCode("snowhead_map_purchase_2").Active == false then
        Tracker:FindObjectForCode("snowhead_map_purchase_1").Active = false
    end
end

function romani_ranch_map_purchased_1()
    if Tracker:FindObjectForCode("romani_ranch_map_purchase_1").Active == true then
        Tracker:FindObjectForCode("romani_ranch_map_purchase_2").Active = true
    elseif Tracker:FindObjectForCode("romani_ranch_map_purchase_1").Active == false then
        Tracker:FindObjectForCode("romani_ranch_map_purchase_2").Active = false
    end
end
function romani_ranch_map_purchased_2()
    if Tracker:FindObjectForCode("romani_ranch_map_purchase_2").Active == true then
        Tracker:FindObjectForCode("romani_ranch_map_purchase_1").Active = true
    elseif Tracker:FindObjectForCode("romani_ranch_map_purchase_2").Active == false then
        Tracker:FindObjectForCode("romani_ranch_map_purchase_1").Active = false
    end
end

function great_bay_map_purchased_1()
    if Tracker:FindObjectForCode("great_bay_map_purchase_1").Active == true then
        Tracker:FindObjectForCode("great_bay_map_purchase_2").Active = true
    elseif Tracker:FindObjectForCode("great_bay_map_purchase_1").Active == false then
        Tracker:FindObjectForCode("great_bay_map_purchase_2").Active = false
    end
end
function great_bay_map_purchased_2()
    if Tracker:FindObjectForCode("great_bay_map_purchase_2").Active == true then
        Tracker:FindObjectForCode("great_bay_map_purchase_1").Active = true
    elseif Tracker:FindObjectForCode("great_bay_map_purchase_2").Active == false then
        Tracker:FindObjectForCode("great_bay_map_purchase_1").Active = false
    end
end

function stone_tower_map_purchased_1()
    if Tracker:FindObjectForCode("stone_tower_map_purchase_1").Active == true then
        Tracker:FindObjectForCode("stone_tower_map_purchase_2").Active = true
    elseif Tracker:FindObjectForCode("stone_tower_map_purchase_1").Active == false then
        Tracker:FindObjectForCode("stone_tower_map_purchase_2").Active = false
    end
end
function stone_tower_map_purchased_2()
    if Tracker:FindObjectForCode("stone_tower_map_purchase_2").Active == true then
        Tracker:FindObjectForCode("stone_tower_map_purchase_1").Active = true
    elseif Tracker:FindObjectForCode("stone_tower_map_purchase_2").Active == false then
        Tracker:FindObjectForCode("stone_tower_map_purchase_1").Active = false
    end
end

function oath_to_order_wft()
    if Tracker:FindObjectForCode("oath_wft").Active == true then
        Tracker:FindObjectForCode("oath_sht").Active = true
        Tracker:FindObjectForCode("oath_gbt").Active = true
        Tracker:FindObjectForCode("oath_stt").Active = true
    elseif Tracker:FindObjectForCode("oath_wft").Active == false then
        Tracker:FindObjectForCode("oath_sht").Active = false
        Tracker:FindObjectForCode("oath_gbt").Active = false
        Tracker:FindObjectForCode("oath_stt").Active = false
    end
end
function oath_to_order_sht()
    if Tracker:FindObjectForCode("oath_sht").Active == true then
        Tracker:FindObjectForCode("oath_wft").Active = true
        Tracker:FindObjectForCode("oath_gbt").Active = true
        Tracker:FindObjectForCode("oath_sst").Active = true
    elseif Tracker:FindObjectForCode("oath_sht").Active == false then
        Tracker:FindObjectForCode("oath_wft").Active = false
        Tracker:FindObjectForCode("oath_gbt").Active = false
        Tracker:FindObjectForCode("oath_stt").Active = false
    end
end
function oath_to_order_gbt()
    if Tracker:FindObjectForCode("oath_gbt").Active == true then
        Tracker:FindObjectForCode("oath_wft").Active = true
        Tracker:FindObjectForCode("oath_sht").Active = true
        Tracker:FindObjectForCode("oath_stt").Active = true
    elseif Tracker:FindObjectForCode("oath_gbt").Active == false then
        Tracker:FindObjectForCode("oath_wft").Active = false
        Tracker:FindObjectForCode("oath_sht").Active = false
        Tracker:FindObjectForCode("oath_stt").Active = false
    end
end
function oath_to_order_stt()
    if Tracker:FindObjectForCode("oath_stt").Active == true then
        Tracker:FindObjectForCode("oath_wft").Active = true
        Tracker:FindObjectForCode("oath_sht").Active = true
        Tracker:FindObjectForCode("oath_gbt").Active = true
    elseif Tracker:FindObjectForCode("oath_stt").Active == false then
        Tracker:FindObjectForCode("oath_wft").Active = false
        Tracker:FindObjectForCode("oath_sht").Active = false
        Tracker:FindObjectForCode("oath_gbt").Active = false
    end
end

ScriptHost:AddWatchForCode("OdolwaDefeated", "boss_odolwa_hosted", clear_wft)
ScriptHost:AddWatchForCode("GohtDefeated", "boss_goht_hosted", clear_sht)
ScriptHost:AddWatchForCode("bottlecounter_red", "redpotion", bottleCount)
ScriptHost:AddWatchForCode("bottlecounter_milk", "milk", bottleCount)
ScriptHost:AddWatchForCode("bottlecounter_chateau", "chateau", bottleCount)
ScriptHost:AddWatchForCode("bottlecounter_gold", "gold_dust", bottleCount)
ScriptHost:AddWatchForCode("bottlecounter_empty_bottle", "empty_bottle", bottleCount)
ScriptHost:AddWatchForCode("OdolwaObtained", "odolwa", remainCount)
ScriptHost:AddWatchForCode("GohtObtained", "goht", remainCount)
ScriptHost:AddWatchForCode("GyorgObtained", "gyorg", remainCount)
ScriptHost:AddWatchForCode("TwinmoldObtained", "twinmold", remainCount)
ScriptHost:AddWatchForCode("MoonRemainsCountUpdated", "moon_remains_required", remainCount)
ScriptHost:AddWatchForCode("ClockTownMapPurchased1", "clock_town_map_purchase_1", clock_town_map_purchased_1)
ScriptHost:AddWatchForCode("ClockTownMapPurchased2", "clock_town_map_purchase_2", clock_town_map_purchased_2)
ScriptHost:AddWatchForCode("SnowheadMapPurchased1", "snowhead_map_purchase_1", snowhead_map_purchased_1)
ScriptHost:AddWatchForCode("SnowheadMapPurchased2", "snowhead_map_purchase_2", snowhead_map_purchased_2)
ScriptHost:AddWatchForCode("RomaniRanchMapPurchased1", "romani_ranch_map_purchase_1", romani_ranch_map_purchased_1)
ScriptHost:AddWatchForCode("RomaniRanchMapPurchased2", "romani_ranch_map_purchase_2", romani_ranch_map_purchased_2)
ScriptHost:AddWatchForCode("GreatBayMapPurchased1", "great_bay_map_purchase_1", great_bay_map_purchased_1)
ScriptHost:AddWatchForCode("GreatBayMapPurchased2", "great_bay_map_purchase_2", great_bay_map_purchased_2)
ScriptHost:AddWatchForCode("StoneTowerMapPurchased1", "stone_tower_map_purchase_1", stone_tower_map_purchased_1)
ScriptHost:AddWatchForCode("StoneTowerMapPurchased2", "stone_tower_map_purchase_2", stone_tower_map_purchased_2)
ScriptHost:AddWatchForCode("OathToOrderFoundInWFT", "oath_wft", oath_to_order_wft)
ScriptHost:AddWatchForCode("OathToOrderFoundInSHT", "oath_sht", oath_to_order_sht)
ScriptHost:AddWatchForCode("OathToOrderFoundInGBT", "oath_gbt", oath_to_order_gbt)
ScriptHost:AddWatchForCode("OathToOrderFoundInSTT", "oath_stt", oath_to_order_stt)