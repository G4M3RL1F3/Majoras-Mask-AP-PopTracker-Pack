ScriptHost:LoadScript("scripts/autotracking/hints_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/tables.lua")

CUR_INDEX = -1
SLOT_DATA = nil
LOCAL_ITEMS = {}
GLOBAL_ITEMS = {}

function onClear(slot_data)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onClear, slot_data:\n%s", dump_table(slot_data)))
    end
    SLOT_DATA = slot_data
    CUR_INDEX = -1
    -- reset locations
    for _, location_array in pairs(LOCATION_MAPPING) do
        for _, location in pairs(location_array) do
            if location then
                local obj = Tracker:FindObjectForCode(location)
                if obj then
                    if location:sub(1, 1) == "@" then
                        obj.AvailableChestCount = obj.ChestCount
                    else
                        obj.Active = false
                    end
                end
            end
        end
    end
    -- reset items
    for _, v in pairs(ITEM_MAPPING) do
        if v[1] and v[2] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: clearing item %s of type %s", v[1], v[2]))
            end
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[2] == "toggle" then
                    obj.Active = false
                elseif v[2] == "progressive" then
                    obj.CurrentStage = 0
                    obj.Active = false
                elseif v[2] == "consumable" then
                    obj.AcquiredCount = 0
                elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                    print(string.format("onClear: unknown item type %s for code %s", v[2], v[1]))
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: could not find object for code %s", v[1]))
            end
        end
    end
    Tracker:FindObjectForCode("remains_moon").Active = false
    Tracker:FindObjectForCode("bottles").CurrentStage = 0

	PLAYER_NUMBER = Archipelago.PlayerNumber or -1
	TEAM_NUMBER = Archipelago.TeamNumber or 0

    LOCAL_ITEMS = {}
    GLOBAL_ITEMS = {}


    if Archipelago.PlayerNumber > -1 then
        HINTS_ID = "_read_hints_"..TEAM_NUMBER.."_"..PLAYER_NUMBER
        Archipelago:SetNotify({HINTS_ID})
        Archipelago:Get({HINTS_ID})
    end

    -- read YAML options
    local function setFromSlotData(slot_data_key, item_code)
        local v = slot_data[slot_data_key]
        if not v then
            print(string.format("Could not find key '%s' in slot data", slot_data_key))
            return nil
        end

        local obj = Tracker:FindObjectForCode(item_code)
        if not obj then
            print(string.format("Could not find item for code '%s'", item_code))
            return nil
        end

        if obj.Type == 'toggle' then
            local active = v ~= 0
            obj.Active = active
            return v
        elseif obj.Type == 'progressive' then
            obj.CurrentStage = v
            return v
        elseif obj.Type == 'consumable' then
            obj.AcquiredCount = v
            return v
        else
            print(string.format("Unsupported item type '%s' for item '%s'", tostring(obj.Type), item_code))
            return nil
        end
    end

    setFromSlotData("logic_difficulty","logic_difficulty")
    setFromSlotData("majora_remains_required","majora_remains_required")
    setFromSlotData("moon_remains_required","moon_remains_required")
    setFromSlotData("remains_allow_boss_warps","remains_allow_boss_warps")
    setFromSlotData("camc","camc")
    setFromSlotData("swordless","swordless")
    setFromSlotData("shieldless","shieldless")
    setFromSlotData("start_with_soaring","start_with_soaring")
    setFromSlotData("starting_hearts","starting_hearts")
    setFromSlotData("starting_hearts_are_containers_or_pieces","starting_hearts_are_containers_or_pieces")
    setFromSlotData("shuffle_regional_maps","shuffle_regional_maps")
    setFromSlotData("shuffle_boss_remains","shuffle_boss_remains")
    setFromSlotData("shuffle_spiderhouse_reward","shuffle_spiderhouse_reward")
    setFromSlotData("skullsanity","skullsanity")
    setFromSlotData("shopsanity","shopsanity")
    setFromSlotData("scrubsanity","scrubsanity")
    setFromSlotData("cowsanity","cowsanity")
    setFromSlotData("shuffle_great_fairy_rewards","shuffle_great_fairy_rewards")
    setFromSlotData("fairysanity","fairysanity")
    setFromSlotData("start_with_consumables","start_with_consumables")
    setFromSlotData("permanent_chateau_romani","permanent_chateau_romani")
    setFromSlotData("start_with_inverted_time","start_with_inverted_time")
    setFromSlotData("receive_filled_wallets","receive_filled_wallets")
    setFromSlotData("damage_multiplier","damage_multiplier")
    setFromSlotData("death_behavior","death_behavior")
    setFromSlotData("death_link","death_link")
end

-- called when an item gets collected
function onItem(index, item_id, item_name, player_number)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onItem: %s, %s, %s, %s, %s", index, item_id, item_name, player_number, CUR_INDEX))
    end
    if not AUTOTRACKER_ENABLE_ITEM_TRACKING then
        return
    end
    if index <= CUR_INDEX then
        return
    end
    local is_local = player_number == Archipelago.PlayerNumber
    CUR_INDEX = index;
    local v = ITEM_MAPPING[item_id]
    if not v then
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: could not find item mapping for id %s", item_id))
        end
        return
    end
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: code: %s, type %s", v[1], v[2]))
    end
    if not v[1] then
        return
    end
    local obj = Tracker:FindObjectForCode(v[1])
    if obj then
        if v[2] == "toggle" then
            obj.Active = true
        elseif v[2] == "progressive" then
            if obj.Active then
                obj.CurrentStage = obj.CurrentStage + 1
            else
                obj.Active = true
            end
        elseif v[2] == "consumable" then
            obj.AcquiredCount = obj.AcquiredCount + obj.Increment
        elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: unknown item type %s for code %s", v[2], v[1]))
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: could not find object for code %s", v[1]))
    end
end

-- called when a location gets cleared
function onLocation(location_id, location_name)
    local location_array = LOCATION_MAPPING[location_id]
    if not location_array or not location_array[1] then
        print(string.format("onLocation: could not find location mapping for id %s", location_id))
        return
    end

    for _, location in pairs(location_array) do
        local obj = Tracker:FindObjectForCode(location)
        -- print(location, obj)
        if obj then
            if location:sub(1, 1) == "@" then
                obj.AvailableChestCount = obj.AvailableChestCount - 1
            else
                obj.Active = true
            end
        else
            print(string.format("onLocation: could not find object for code %s", location))
        end
    end
end


function onNotify(key, value, old_value)

    if value ~= old_value and key == HINTS_ID then
        for _, hint in ipairs(value) do
            if hint.finding_player == Archipelago.PlayerNumber then
                if not hint.found then
                    updateHints(hint.location)
                else if hint.found then
                    updateHints(hint.location)
                    end
                end
            end
        end
    end
end

function onNotifyLaunch(key, value)
    if key == HINTS_ID then
        for _, hint in ipairs(value) do
            if hint.finding_player == Archipelago.PlayerNumber then
                if not hint.found then
                    updateHints(hint.location)
                elseif hint.found then
                    updateHints(hint.location)
                end
            end
        end
    end
end

 
function updateHints(locationID)
    local item_codes = HINTS_MAPPING[locationID]

    for _, item_code in ipairs(item_codes) do
        local obj = Tracker:FindObjectForCode(item_code)
        if obj then
            obj.Active = true
        else
            print(string.format("No object found for code: %s", item_code))
        end
    end
end
 
function updateHintsClear(locationID)
    local item_codes = HINTS_MAPPING[locationID]

    for _, item_code in ipairs(item_codes) do
        local obj = Tracker:FindObjectForCode(item_code)
        if obj then
            obj.Active = false
        else
            print(string.format("No object found for code: %s", item_code))
        end
    end
end

-- called when a locations is scouted
function onScout(location_id, location_name, item_id, item_name, item_player)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onScout: %s, %s, %s, %s, %s", location_id, location_name, item_id, item_name,
            item_player))
    end
    -- not implemented yet :(
end

-- called when a bounce message is received 
function onBounce(json)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onBounce: %s", dump_table(json)))
    end
    -- your code goes here
end

Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
Archipelago:AddSetReplyHandler("notify handler", onNotify)
Archipelago:AddRetrievedHandler("notify launch handler", onNotifyLaunch)
