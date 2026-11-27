local storage = {}
ed.storage = storage
storage.prefix = "remake_"
storage.filterMap = {
  game_res_dir = true,
  dt_lang = true,
  swq_s = true,
  swq_s_ef = true,
  dt_definition = true,
  FrameWidth = true,
  FrameHeight = true,
  hideOneGradeAccount = true,
  sdkRightsDisplayWindow = true,
  ["current-version"] = true,
  search_pathes = true,
  _default_language_ = true,
  _default_sound_ = true
}

function storage.getKey(key)
  if storage.filterMap[key] then
    return key
  end
  return storage.prefix .. key
end

function storage.getValue(type, key)
  key = storage.getKey(key)
  local value
  if type == "int" then
    value = CCUserDefault:sharedUserDefault():getIntegerForKey(key)
  elseif type == "string" then
    value = CCUserDefault:sharedUserDefault():getStringForKey(key)
  elseif type == "bool" then
    value = CCUserDefault:sharedUserDefault():getBoolForKey(key)
  end
  return value
end

function storage.getInt(key)
  return storage.getValue("int", key)
end

function storage.getString(key)
  return storage.getValue("string", key)
end

function storage.getBool(key)
  return storage.getValue("bool", key)
end

function storage.setValue(key, value)
  key = storage.getKey(key)
  if type(value) == "number" then
    CCUserDefault:sharedUserDefault():setIntegerForKey(key, value)
  elseif type(value) == "string" then
    CCUserDefault:sharedUserDefault():setStringForKey(key, value)
  elseif type(value) == "boolean" then
    CCUserDefault:sharedUserDefault():setBoolForKey(key, value)
  end
end
