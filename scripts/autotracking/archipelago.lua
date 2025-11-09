--ScriptHost:LoadScript("scripts/autotracking/hints_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")
--ScriptHost:LoadScript("scripts/autotracking/mappings.lua")
ScriptHost:LoadScript("scripts/autotracking/shop.lua")
ScriptHost:LoadScript("scripts/autotracking/tables.lua")

set_default_prices()

-- used for hint tracking to quickly map hint status to a value from the Highlight enum
HINT_STATUS_MAPPING = {}
if Highlight then
	HINT_STATUS_MAPPING = {
		[20] = Highlight.Avoid,
		[40] = Highlight.None,
		[10] = Highlight.NoPriority,
		[0] = Highlight.Unspecified,
		[30] = Highlight.Priority,
	}
end

CUR_INDEX = -1
SLOT_DATA = nil
LOCAL_ITEMS = {}
GLOBAL_ITEMS = {}
RANDOMIZED_PRICES = {}

function onClear(slot_data)
    Tracker.BulkUpdate = true
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onClear, slot_data:\n%s", dump_table(slot_data)))
    end
    SLOT_DATA = slot_data
    CUR_INDEX = -1
    -- reset locations
    for _, v in pairs(LOCATION_MAPPING) do
        if v[1] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
                print(string.format("onClear: clearing location %s", v[1]))
            end
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[1]:sub(1, 1) == "@" then
                    obj.AvailableChestCount = obj.ChestCount
                    if obj.Highlight then
                        obj.Highlight = Highlight.None
                    end
                else
                    obj.Active = false
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING then
                print(string.format("onClear: could not find object for code %s", v[1]))
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

    -- reset logic tricks
    --for _, logictrick in pairs(LOGIC_TRICK_MAPPING) do
    --    Tracker:FindObjectForCode(string.lower(logictrick)).Active = false
    --end

    LOCAL_ITEMS = {}
    GLOBAL_ITEMS = {}

	-- setup data storage tracking for hint tracking
	local data_strorage_keys = {}
	if PopVersion >= "0.32.0" then
		data_strorage_keys = { getHintDataStorageKey() }
	end
	-- subscribes to the data storage keys for updates
	-- triggers callback in the SetNotify handler on update
	Archipelago:SetNotify(data_strorage_keys)
	-- gets the current value for the data storage keys
	-- triggers callback in the Retrieved handler when result is received
	Archipelago:Get(data_strorage_keys)

    -- applies shop prices from slot data on each shop item for display
    if slot_data["shopsanity"] ~= 0 then
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print("Printing shop values given from slot data:")
            for index, value in ipairs(slot_data["shop_prices_ints"]) do
                print(index, value)
            end
        end
        for k, v in pairs(SHOP_NAMES) do
            RANDOMIZED_PRICES[k] = {v[1], slot_data["shop_prices_ints"][k]}
        end
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print("Printing RANDOMIZED_PRICES table:")
        end
        for key, value in pairs(RANDOMIZED_PRICES) do
            print(key, value[1], value[2])
        end
    end
    adjust_display_cost()

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
    --setFromSlotData("swordless","swordless")
    --setFromSlotData("shieldless","shieldless")
    setFromSlotData("start_with_soaring","start_with_soaring")
    --setFromSlotData("starting_hearts","starting_hearts")
    --setFromSlotData("starting_hearts_are_containers_or_pieces","starting_hearts_are_containers_or_pieces")
    setFromSlotData("shuffle_regional_maps","shuffle_regional_maps")
    setFromSlotData("shuffle_boss_remains","shuffle_boss_remains")
    setFromSlotData("shuffle_spiderhouse_reward","shuffle_spiderhouse_reward")
    setFromSlotData("skullsanity","skullsanity")
    setFromSlotData("required_skull_tokens","required_skull_tokens")
    setFromSlotData("shopsanity","shopsanity")
    setFromSlotData("scrubsanity","scrubsanity")
    setFromSlotData("cowsanity","cowsanity")
    setFromSlotData("keysanity","small_key_sanity")
    setFromSlotData("bosskeysanity","boss_key_sanity")
    setFromSlotData("intro_checks","intro_checks")
    setFromSlotData("curiostity_shop_trades","curiosity_shop_trades") --spelling mistake in apworld
    setFromSlotData("shuffle_great_fairy_rewards","shuffle_great_fairy_rewards")
    setFromSlotData("fairysanity","fairysanity")
    setFromSlotData("required_stray_fairies","required_stray_fairies")
    setFromSlotData("start_with_consumables","start_with_consumables")
    setFromSlotData("permanent_chateau_romani","permanent_chateau_romani")
    setFromSlotData("start_with_inverted_time","start_with_inverted_time")
    setFromSlotData("receive_filled_wallets","receive_filled_wallets")
    setFromSlotData("damage_multiplier","damage_multiplier")
    setFromSlotData("death_behavior","death_behavior")
    --setFromSlotData("death_link","death_link")
    --for _, trick in ipairs(slot_data["logic_tricks"]) do
    --    Tracker:FindObjectForCode(LOGIC_TRICK_MAPPING[string.format("%s", trick)]).Active = true
    --end

	Tracker.BulkUpdate = false
end

-- called when an item gets collected
function onItem(index, item_id, item_name, player_number)
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("called onItem: %s, %s, %s, %s, %s", index, item_id, item_name, player_number, CUR_INDEX))
	end
	if index <= CUR_INDEX then return	end
	local is_local = player_number == Archipelago.PlayerNumber
	CUR_INDEX = index
	local mapping_entry = ITEM_MAPPING[item_id]
	if not mapping_entry then
		if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("onItem: could not find item mapping for id %s", item_id))
		end
		return
	end
  if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
      print(string.format("onItem: code: %s, type %s", mapping_entry[1], mapping_entry[2]))
  end
	if not mapping_entry[1] then return	end
    local obj = Tracker:FindObjectForCode(mapping_entry[1])
    if obj then
        if mapping_entry[2] == "toggle" then
            obj.Active = true
        elseif mapping_entry[2] == "progressive" then
            if obj.Active then
                obj.CurrentStage = obj.CurrentStage + 1
            else
                obj.Active = true
            end
        elseif mapping_entry[2] == "consumable" then
            obj.AcquiredCount = obj.AcquiredCount + obj.Increment
        elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: unknown item type %s for code %s", mapping_entry[2], mapping_entry[1]))
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: could not find object for code %s", mapping_entry[1]))
    end
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("local items: %s", dump_table(LOCAL_ITEMS)))
		print(string.format("global items: %s", dump_table(GLOBAL_ITEMS)))
	end
end

-- called when a location gets cleared
function onLocation(location_id, location_name)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
        print(string.format("called onLocation: %s, %s", location_id, location_name))
    end
    local v = LOCATION_MAPPING[location_id]
    if not v and AUTOTRACKER_ENABLE_DEBUG_LOGGING then
        print(string.format("onLocation: could not find location mapping for id %s", location_id))
    end
    if not v[1] then
        return
    end
    local obj = Tracker:FindObjectForCode(v[1])
    if obj then
        if v[1]:sub(1, 1) == "@" then
            obj.AvailableChestCount = 0
        else
            obj.Active = true
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING then
        print(string.format("onLocation: could not find object for code %s", v[1]))
    end
end

-- gets the data storage key for hints for the current player
-- returns nil when not connected to AP
function getHintDataStorageKey()
    if AutoTracker:GetConnectionState("AP") ~= 3 or Archipelago.TeamNumber == nil or Archipelago.TeamNumber == -1 or Archipelago.PlayerNumber == nil or Archipelago.PlayerNumber == -1 then
        print("Tried to call getHintDataStorageKey while not connected to AP server")
        return nil
    end
    return string.format("_read_hints_%s_%s", Archipelago.TeamNumber, Archipelago.PlayerNumber)
end

-- called whenever Archipelago:Get returns data from the data storage or
-- whenever a subscribed to (via Archipelago:SetNotify) key in data storgae is updated
-- oldValue might be nil (always nil for "_read" prefixed keys and via retrieved handler (from Archipelago:Get))
function onDataStorageUpdate(key, value, oldValue)
	--if you plan to only use the hints key, you can remove this if
	if key == getHintDataStorageKey() then
		onHintsUpdate(value)
	end
end

-- called whenever the hints key in data storage updated
-- NOTE: this should correctly handle having multiple mapped locations in a section.
--       if you only map sections 1 to 1 you can simplify this. for an example see
--       https://github.com/Cyb3RGER/sm_ap_tracker/blob/main/scripts/autotracking/archipelago.lua
function onHintsUpdate(hints)
	-- Highlight is only supported since version 0.32.0
	if PopVersion < "0.32.0" or not AUTOTRACKER_ENABLE_LOCATION_TRACKING then return end
	local player_number = Archipelago.PlayerNumber
	-- get all new highlight values per section
	local sections_to_update = {}
	for _, hint in ipairs(hints) do
		-- we only care about hints in our world
		if hint.finding_player == player_number then
			updateHint(hint, sections_to_update)
		end
	end
end

-- update section highlight based on the hint
function updateHint(hint, sections_to_update)
	-- get the highlight enum value for the hint status
	local hint_status = hint.status
	local highlight_code = nil
	if hint_status then
		highlight_code = HINT_STATUS_MAPPING[hint_status]
	end
	if not highlight_code then
		if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("updateHint: unknown hint status %s for hint on location id %s", hint.status,
				hint.location))
		end
		-- try to "recover" by checking hint.found (older AP versions without hint.status)
		if hint.found == true then
			highlight_code = Highlight.None
		elseif hint.found == false then
			highlight_code = Highlight.Unspecified
		else
			return
		end
	end
	-- get the location mapping for the location id
	local mapping_entry = LOCATION_MAPPING[hint.location]
	if not mapping_entry then
		if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("updateHint: could not find location mapping for id %s", hint.location))
		end
		return
	end
  for _, location_code in pairs(mapping_entry) do
    -- skip hosted items, they don't support Highlight
    if location_code and location_code:sub(1, 1) == "@" then
      -- find the location object
      local obj = Tracker:FindObjectForCode(location_code)
      -- check if we got the location and if it supports Highlight
      if obj and obj.Highlight then
          obj.Highlight = highlight_code
      elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING then
          print(string.format("updateHint: could update section %s (obj doesn't support Highlight)", location_code))
      end
    end
  end
end

-- add AP callbacks
-- un-/comment as needed
Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
Archipelago:AddRetrievedHandler("retrieved handler", onDataStorageUpdate)
Archipelago:AddSetReplyHandler("set reply handler", onDataStorageUpdate)
-- Archipelago:AddScoutHandler("scout handler", onScout)
-- Archipelago:AddBouncedHandler("bounce handler", onBounce)