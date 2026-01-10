function has(item)
  return Tracker:ProviderCountForCode(item) == 1
end


function has(item, amount)
	local count = Tracker:ProviderCountForCode(item)
	amount = tonumber(amount)
	if not amount then
		return count > 0
	else
		return count >= amount
	end
end

function checkRequirements(reference, check_count)
  local reqCount = Tracker:ProviderCountForCode(reference)
  local count = Tracker:ProviderCountForCode(check_count)

  if count >= reqCount then
      return true
  else
      return false
  end
end

function toggle_item(code)
  local active = Tracker:FindObjectForCode(code).Active
  code = code.."_hosted"
  local object = Tracker:FindObjectForCode(code)
  if object then
    object.Active = active
  else
    if ENABLE_DEBUG_LOG then
      print(string.format("toggle_item: could not find object for code %s", code))
    end
  end
end

function tableContains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

function dump_table(o, depth)
	if depth == nil then
		depth = 0
	end
	if type(o) == 'table' then
		local tabs = ('\t'):rep(depth)
		local tabs2 = ('\t'):rep(depth + 1)
		local s = '{\n'
		for k, v in pairs(o) do
			if type(k) ~= 'number' then
				k = '"' .. k .. '"'
			end
			s = s .. tabs2 .. '[' .. k .. '] = ' .. dump_table(v, depth + 1) .. ',\n'
		end
		return s .. tabs .. '}'
	else
		return tostring(o)
	end
end

function toggle_hosted_item(code)
  local active = Tracker:FindObjectForCode(code).Active
  code = code:gsub("_hosted", "")
  local object = Tracker:FindObjectForCode(code)
  if object then
    object.Active = active
  else
    if ENABLE_DEBUG_LOG then
      print(string.format("toggle_hosted_item: could not find object for code %s", code))
    end
  end
end

function can_play_song(song)
  return has("ocarina") and has(song)
end

function can_use_owl(owl)
  return can_play_song("soaring") and has(owl)
end

function can_reach_scarecrow(scarecrow)
  if Tracker:FindObjectForCode("scarecrow_sanity").Active == false then
    return true
  else
    return has("soul_scarecrow") and has("ocarina") and has(scarecrow)
  end
end

function has_npc_soul(soul)
  if Tracker:FindObjectForCode("npc_souls").Active == false then
    return true
  else
    return has(soul)
  end
end

function has_absurd_soul(soul)
  if Tracker:FindObjectForCode("absurd_souls").Active == false then
    return true
  else
    return has(soul)
  end
end

function has_misc_soul(soul)
  if Tracker:FindObjectForCode("misc_souls").Active == false then
    return true
  else
    return has(soul)
  end
end

function has_enemy_soul(soul)
  if Tracker:FindObjectForCode("enemy_souls").Active == false then
    return true
  else
    return has(soul)
  end
end

function has_boss_soul(soul)
  if Tracker:FindObjectForCode("boss_souls").Active == false then
    return true
  else
    return has(soul)
  end
end