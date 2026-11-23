local function WeakBuff3_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field)
  local lost = basefunc(buff, damage, damage_type, source, skill, transferred, field)
  
  local owner = buff.owner
  if damage_type == "Holy" then
    return lost
  end
  if lost and 0 < lost and field == "hp" then
    lost = math.max(0, lost + buff.damageAdd)
  end
  return lost
end

local function WeakBuff3_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if not buff.isInited then
    local skill = owner.basic_skill
    local target = skill:selectTarget()
    if target then
      local weakSkillCount = 0
      if owner.cards then
        for k, v in pairs(owner.cards) do
          local cardTb = ed.getDataTable("SoloCardSkill")[k]
          if cardTb and (cardTb.Tag1 == 10 or cardTb.Tag2 == 10) then
            weakSkillCount = weakSkillCount + 1
          end
        end
      end
      local weakbid = 90000024
      local binfo = ed.lookupDataTable("Buff", nil, weakbid)
      local weakbuff = ed.BuffCreate(binfo, target, owner)
      local param = ed.getDataTable("SoloCardSkill")[93]["Level Arg 1"][buff.rank] or 0
      weakbuff.damageAdd = param * weakSkillCount
      weakbuff.onDamaged = override(weakbuff.onDamaged, WeakBuff3_onDamaged)
      target:addBuff(weakbuff)
      buff.isInited = true
    end
  end
end

local function initBuff(buff)
  local owner = buff.owner
  buff.update = override(buff.update, WeakBuff3_update)
  return buff
end

return initBuff
