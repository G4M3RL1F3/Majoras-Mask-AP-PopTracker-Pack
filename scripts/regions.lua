-- "remains_moon" is its own toggle that triggers when the required amount of Remains to access the moon is met.
function moon()
    return has("ocarina") and has("oath") and has("remains_moon")
end

--- SWAMP REGION ---
-- Southern Swamp -> Southern Swamp (Deku Palace)
function baby_south_swamp()
    return has("redpotion") and baby_has_hard_projectiles() and has("deku") and has("pictobox")
end
function south_swamp()
    return has("bottles", 1) or (has_hard_projectiles() and has("deku")) or (has("pictobox") and has("deku"))
end

-- Southern Swamp (Deku Palace) -> Swamp Spider House
function baby_swamp_skull_house()
    return baby_south_swamp() and has("deku") and can_use_fire_arrows()
end
function swamp_skull_house()
    return south_swamp() and has("deku")
end

-- Southern Swamp (Deku Palace) -> Deku Palace
function baby_deku_palace()
    return baby_south_swamp() and has("deku")
end
function deku_palace()
    return south_swamp() and has("deku")
end

-- Southern Swamp (Deku Palace) -> Woodfall
function baby_woodfall()
    return baby_south_swamp() and has("deku")
end
function woodfall()
    return south_swamp() and has("deku")
end

-- Woodfall -> Woodfall Temple
function baby_woodfall_temple()
    return baby_woodfall() and can_play_sonata() and has("bosskey_wf") and has("smallkey_wf")
end
function woodfall_temple()
    return woodfall() and can_play_sonata()
end

-- What's needed to defeat Odolwa
function baby_clear_woodfall()
    return baby_woodfall_temple() and has("bow") and baby_can_smack_hard() and has("bosskey_wf") and has("odolwa")
end
function clear_woodfall()
    return woodfall_temple() and has("bow") and (can_smack() or has("fiercedeity")) and (has("bosskey_wf") or (has("odolwa") and has("boss_warps_with_remains")))
end


--- MOUNTAIN REGION ---
-- Termina Field -> Path to Mountain Village
function path_mountain()
    return has("bow")
end

-- Path to Mountain Village -> Mountain Village
function baby_mountain_village()
    return path_mountain() and has("goron") and baby_has_explosives() and can_use_fire_arrows()
end
function mountain_village()
    return path_mountain() and (has("goron") or has_explosives() or can_use_fire_arrows())
end

-- Twin Islands -> Goron Village
function goron_village()
    return mountain_village()
end

-- Goron Village -> Goron Shrine
function goron_shrine()
    return goron_village() and has("goron")
end

-- Twin Islands -> Goron Racetrack
function goron_racetrack()
    return mountain_village() and (has("goron") and (has("powderkeg") or can_use_fire_arrows()))
end

-- Path to Snowhead -> Snowhead
function baby_snowhead()
    return baby_mountain_village() and has("goron") and can_play_lullaby() and has("magic") and has("bosskey_sh") and has("smallkey_sh", 3)
end
function snowhead()
    return mountain_village() and has("goron") and can_play_lullaby() and has("magic")
end

-- Snowhead -> Snowhead Temple
function baby_snowhead_temple()
    return baby_snowhead() and has("goron") and can_play_lullaby() and has("magic") and has("bosskey_sh") and has("smallkey_sh", 3)
end
function snowhead_temple()
    return snowhead() and has("goron") and can_play_lullaby() and has("magic")
end

-- What's needed to defeat Goht
function baby_clear_snowhead()
    return baby_snowhead_temple() and can_use_fire_arrows() and baby_has_explosives()
end
function clear_snowhead()
    return snowhead_temple() and can_use_fire_arrows() and ((has("smallkey_sh", 1) and has("bosskey_sh")) or (has("goht") and has("boss_warps_with_remains")))
end


--- GREAT BAY REGION ---
-- Termina Field -> Great Bay
function great_bay()
    return can_play_eponas()
end

-- Great Bay -> Ocean Spider House
function baby_ocean_spider_house()
    return great_bay() and baby_has_explosives() and has("hookshot")
end
function ocean_spider_house()
    return great_bay()
end

-- Great Bay -> Pirates' Fortress
function pirates_fortress()
    return great_bay() and has("zora")
end

-- Pirates' Fortress -> Pirates' Fortress (Interior)
function baby_pirates_fortress_interior()
    return pirates_fortress() and has("goron") and has("hookshot")
end
function pirates_fortress_interior()
    return (pirates_fortress() and has("hookshot")) or (pirates_fortress_sewers() and has("zora"))
end

-- Pirates' Fortress -> Pirates' Fortress Sewers
function pirates_fortress_sewers()
    return pirates_fortress() and has("goron")
end

-- Great Bay -> Zora Cape
function zora_cape()
    return great_bay()
return

-- Zora Cape -> Zora Hall
function zora_hall()
    return zora_cape() and has("zora")
end

-- Zora Cape -> Great Bay Temple
function baby_great_bay_temple()
    return zora_cape() and can_play_bossa_nova() and has("hookshot") and has("zora") and has("bosskey_gb") and has("smallkey_gb")
end
function great_bay_temple()
    return zora_cape() and can_play_bossa_nova() and has("hookshot") and has("zora")
end

-- What's needed to defeat Gyorg
function baby_clear_greatbay()
    return baby_great_bay_temple() and has("zora") and can_use_ice_arrows() and can_use_fire_arrows() and has("bow")
end

function clear_greatbay()
    return great_bay_temple() and has("hookshot") and ((can_use_ice_arrows() and can_use_fire_arrows() and has("bosskey_gb")) or (has("gyorg") and has("boss_warps_with_remains")))
end


--- IKANA REGION ---
-- Road to Ikana -> Ikana Graveyard
function graveyard()
    return can_play_eponas()
end

-- Road to Ikana -> Lower Ikana Canyon
function baby_ikana_canyon()
    return can_play_eponas() and has("hookshot") and has("garo") and has("gibdo")
end
function lower_ikana_canyon()
    return can_play_eponas() and has("hookshot") and (has("garo") or has("gibdo"))
end

-- Lower Ikana Canyon -> Secret Shrine
function baby_secret_shrine()
    return baby_ikana_canyon() and can_use_light_arrows()
end
function secret_shrine()
    return lower_ikana_canyon()
end

-- Lower Ikana Canyon -> Upper Ikana Canyon
function upper_ikana_canyon()
    return lower_ikana_canyon() and can_use_ice_arrows() and has("hookshot")
end

-- Upper Ikana Canyon -> Beneath the Well
function baby_well()
    return baby_ikana_canyon() and can_use_ice_arrows() and has("gibdo") and baby_has_bottle()
end
function well()
    return (upper_ikana_canyon() has("gibdo") and has("bottles", 1)) or (ikana_castle() and can_use_light_arrows())
end

-- Upper Ikana Canyon -> Ikana Castle
function baby_ikana_castle()
    return baby_ikana_canyon() and can_use_ice_arrows() and can_use_light_arrows() and has("garo") and has("gibdo") and has("captainhat") and has("mirrorshield") and baby_has_bottle() and has("hookshot")
end
function ikana_castle()
    return (upper_ikana_canyon() and (can_use_light_arrows() or has("mirrorshield"))) or (well() and has("gibdo") and has("bottles", 1) and can_plant_beans() and has("bow") and (has("bombs") or has("captainhat")) and (can_use_light_arrows() or has("mirrorshield")))
end

-- Stone Tower -> Stone Tower Temple
function baby_stone_tower_temple()
    return baby_ikana_canyon() and can_use_ice_arrows() and can_play_elegy() and has("goron") and has("zora") and has("smallkey_st", 4) and has("bosskey_st")
end
function stone_tower_temple()
    return upper_ikana_canyon() and can_play_elegy() and has("hookshot") and has("goron") and has("zora")
end

-- Stone Tower -> Stone Tower (Inverted)
function baby_inverted_stone_tower()
    return baby_stone_tower_temple() and can_use_light_arrows() and can_play_elegy() and has("smallkey_st", 4) and has("bosskey_st")
end
function inverted_stone_tower()
    return stone_tower_temple() and can_use_light_arrows()
end