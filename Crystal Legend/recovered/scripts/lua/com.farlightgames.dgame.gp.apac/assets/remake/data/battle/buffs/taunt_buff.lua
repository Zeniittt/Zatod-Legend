local function onBuffRemove(baseFunc, buff)
  baseFunc(buff)
  
  if buff.owner then
    buff.owner.taunter = nil
  end
end

local function onBuffAdderServer(basefunc, buff)
  basefunc(buff)
  if buff.owner then
    local owner = buff.owner
    owner.taunter = buff.caster
    local skill = owner.current_skill
    if skill and skill.target ~= buff.caster then
      skill:interrupt()
    end
  end
end

local function isContainTauntEffect(info)
  for i, effect in ipairs(info["Control Effects"]) do
    if effect == "taunt" then
      return true
    end
  end
  return false
end

local function buffPretreatment(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  local tempList = owner.buff_list
  owner.buff_list = {}
  for _, buff in pairs(tempList) do
    if isContainTauntEffect(buff.info) then
      buff:onRemoved()
    else
      table.insert(owner.buff_list, buff)
    end
  end
end

local function buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  if not buff.caster:isAlive() then
    buff.owner:removeBuff(buff)
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, buffUpdate)
  buff.onRemoved = override(buff.onRemoved, onBuffRemove)
  buff.onAddedServer = override(buff.onAddedServer, onBuffAdderServer)
  buff.pretreatment = override(buff.pretreatment, buffPretreatment)
  return buff
end

return initBuff
