local function onBuffRemove(baseFunc, buff)
  baseFunc(buff)
  
  if buff.owner then
    buff.owner.controlledTarget = nil
    buff.caster.controlTarget = nil
    buff.owner.controlCamp = nil
    if buff.owner.oldData then
      buff.owner.ai.will_cast_manual_skill = buff.owner.oldData.will_cast_manual_skill
      buff.owner.foecamp = buff.owner.oldData.foecamp
      buff.owner.camp = buff.owner.oldData.camp
    end
    buff.owner.oldData = nil
  end
end

local function onBuffAdderServer(basefunc, buff)
  basefunc(buff)
  if buff.owner then
    buff.owner.controlledTarget = buff.caster
    buff.caster.controlTarget = buff.owner
    buff.owner.controlCamp = buff.caster.camp
    buff.owner.oldData = {}
    buff.owner.oldData.will_cast_manual_skill = buff.owner.ai.will_cast_manual_skill
    buff.owner.ai.will_cast_manual_skill = buff.caster.ai.will_cast_manual_skill
    buff.owner.oldData.foecamp = buff.owner.foecamp
    buff.owner.oldData.camp = buff.owner.camp
    buff.owner.foecamp = buff.caster.foecamp
    buff.owner.camp = buff.caster.camp
  end
end

local function initBuff(buff)
  buff.onRemoved = override(buff.onRemoved, onBuffRemove)
  buff.onAddedServer = override(buff.onAddedServer, onBuffAdderServer)
  return buff
end

return initBuff
