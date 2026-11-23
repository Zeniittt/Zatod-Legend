module("ed.battlehero", package.seeall)
local ed = ed
XE = {}
XE.skillatk4_frozenBid = 4391
XE.XEatk4_CritBid = 4392

function XE.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  if attack_counter == 1 then
    local skillatk2s = caster.skills.XE_atk2s
    if caster and skillatk2s then
      skillatk2s:takeEffectAt(caster.position, caster)
    end
  end
end

function XE.skillatk2s_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = buff.owner
  local skillatk2 = caster.skills.XE_atk2
  local skillatk2s = caster.skills.XE_atk2s
  local ARMP_XE = math.min(owner.attribs.ARMP * 0.1, caster.attribs.ARMP * 0.1)
  if caster and caster:isAlive() and skillatk2 and skillatk2s and (owner.name == "TitanLFH" or owner.name == "LFH" or owner.name == "TitanXL" or owner.name == "XL" or owner.name == "TitanLE" or owner.name == "LE" or owner.name == "TitanLMX" or owner.name == "LMX" or owner.name == "XE" or owner.name == "XE") and owner.camp == caster.camp then
    buff:setAttribute("ARMP", ARMP_XE)
  end
  return buff
end

function XE.DOP_in_battlefield(caster, radius, camp)
  local position = {400, 0}
  local count = 0
  local maxcount = 0
  local distance = 0
  local mindistance = 9999
  for x = 0, 800, 25 do
    for y = -100, 100, 25 do
      for unit in ed.engine:foreachAliveUnit(camp) do
        local unitdistance = ed.edpDistanceSQ({x, y}, unit.position)
        if unit.buffManager.invisible and unit.camp ~= caster.camp then
        elseif unitdistance <= radius * radius then
          count = count + 1
          distance = distance + unitdistance
        end
      end
      if maxcount < count then
        maxcount = count
        mindistance = distance
        position = {x, y}
      end
      if count == maxcount and distance < mindistance then
        mindistance = distance
        position = {x, y}
      end
      count = 0
      distance = 0
    end
  end
  if 0 < maxcount then
    return position
  else
    return caster.position
  end
end

function XE.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk3 = caster.skills.XE_atk3
  local XEenchanted_position = XE.DOP_in_battlefield(caster, 175, caster.foecamp)
  if skillatk3 and caster:isAlive() then
    skillatk3:takeEffectAt(XEenchanted_position)
  end
  skill.attack_counter = skill.attack_counter + 1
end

function XE.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = skill.owner
  local skillatk3 = caster.skills.XE_atk3
  if caster:isAlive() and not caster.config.is_summoned and skillatk3 then
    if caster.XE_hasArcana and caster.XE_hasArcana >= 2 then
      buff:setAttribute("PIMU", -15)
    end
    if (target.name == "TitanLFH" or target.name == "LFH" or target.name == "TitanXL" or target.name == "XL" or target.name == "TitanLE" or target.name == "LE" or target.name == "TitanLMX" or target.name == "LMX" or target.name == "TitanXE" or target.name == "XE") and target.camp == caster.camp then
      buff.timer = buff.timer * 1.5
    end
  end
  return buff
end

function XE.skillatk4_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk4 = caster.skills.XE_atk4
  local skill_counter = skill.attack_counter
  caster.atk4_counter = skill_counter
  if skillatk4 then
    if skill_counter < 3 then
      basefunc(skill)
    elseif skill_counter == 3 then
      local bid = XE.XEatk4_CritBid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      if caster.XE_hasArcana and 3 <= caster.XE_hasArcana then
        buff:setAttribute("CSD", 15)
      end
      buff.onRemoved = override(buff.onRemoved, XE.skillatk4_buff_onRemoved)
      caster:addBuff(buff, caster)
      caster.XEatk4_CritCounter = 0
      if not caster.XE_canCrit then
        caster.XE_canCrit = true
      end
      skill.attack_counter = skill.attack_counter + 1
    elseif skill_counter == 4 then
      basefunc(skill)
      caster.atk4_counter = caster.atk4_counter + 1
    end
  end
end

function XE.skillatk4_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  if caster then
    caster.XE_canCrit = false
  end
end

function XE.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  local hit, dmg, Crit = basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skillatk4 = caster.skills.XE_atk4
  if caster and skillatk4 and caster.atk4_counter then
    if target and not target.XE_atk4_hurtCounter then
      target.XE_atk4_hurtCounter = 0
    end
    if caster.atk4_counter < 5 then
      if hit and target and target.XE_atk4_hurtCounter then
        target.XE_atk4_hurtCounter = target.XE_atk4_hurtCounter + 1
        if target.XE_atk4_hurtCounter == 2 then
          local bid = XE.skillatk4_frozenBid
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          local buff = ed.BuffCreate(binfo, target, caster)
          target:addBuff(buff, caster)
          target.XE_atk4_hurtCounter = 0
        end
      end
    elseif target and target.XE_atk4_hurtCounter then
      target.XE_atk4_hurtCounter = 0
    end
  end
  return hit, dmg, Crit
end

function XE.skillatk1234_getDamaged(basefunc, skill, target, power, damage_type, field, source, crit_mod)
  local caster = skill.caster
  if caster.XE_canCrit then
    crit_mod = 999999
  else
    crit_mod = crit_mod or 1
  end
  local dmg = basefunc(skill, target, power, damage_type, field, source, crit_mod)
  return dmg
end

function XE.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  local skillult = caster.skills.XE_ult
  local HP_DownRatio = skillult.info["Script Arg2"]
  if caster:isAlive() and not caster.config.is_summoned and caster.XE_hasArcana and caster.XE_hasArcana >= 4 then
    local buff_OrigTime = buff.info.Time
    if buff_OrigTime then
      buff.info.Time = buff_OrigTime + 3
    end
  end
  local HP_DownMax = math.min(owner.attribs.HP * HP_DownRatio, caster.attribs.HP * 0.3)
  buff:setAttribute("HP", 0)
  buff.Paper_lockHp_amount = HP_DownMax
  buff.update = override(buff.update, XE.skillult_buffupdate)
  buff.onRemoved = override(buff.onRemoved, XE.skillult_buffonRemoved)
  XE.hpLockPerform(owner)
  if not owner.get_XE_ultBuff then
    owner.get_XE_ultBuff = true
  end
  return buff
end

function XE.hpLockPerform(unit)
  local actor = unit.actor
  local lockPercent
  if actor then
    local buff
    local level = 0
    for i, tbuff in ipairs(unit.buff_list) do
      if tbuff.info.ID == 4393 then
        buff = tbuff
        break
      end
    end
    if buff then
      lockPercent = buff.Paper_lockHp_amount / unit.attribs.HP
    end
    if not buff and unit.Paper_hpLockBar then
      unit.Paper_hpLockBar:removeFromParentAndCleanup(true)
      unit.Paper_hpLockBar = false
    elseif buff and not unit.Paper_hpLockBar then
      local barHp = unit.actor.bar_hp
      if barHp then
        local backgroundSize = barHp.background:getTextureRect().size
        local midlayerSize = barHp.midlayer:getTextureRect().size
        local offsetX = backgroundSize.width - (backgroundSize.width - midlayerSize.width) / 2
        local offsetY = backgroundSize.height / 2
        local newBar = ed.createSprite("UI/alpha/1080P/hp_gray_small.png")
        barHp.background:addChild(newBar, 0)
        newBar:setAnchorPoint(ccp(1, 0.5))
        newBar:setPosition(ccp(offsetX, offsetY))
        newBar:setScaleX(lockPercent)
        unit.Paper_hpLockBar = newBar
      end
    elseif buff and unit.Paper_hpLockBar then
      unit.Paper_hpLockBar:setScaleX(lockPercent)
    end
  end
end

function XE.skillult_buffonRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local owner = buff.owner
  owner.get_XE_ultBuff = false
end

function XE.skillult_buffupdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local lockHp = buff.Paper_lockHp_amount
  if owner then
    local maxHp = owner.attribs.HP - lockHp
    if maxHp <= 0 then
      maxHp = 1
    end
    local currentHp = owner.hp
    if maxHp < currentHp then
      owner:setHP(maxHp)
    end
    XE.hpLockPerform(owner)
  end
  if caster.attribute_ratio ~= 1 then
    caster.XE_temp_attribute_ratio = caster.attribute_ratio
    caster.attribute_ratio = 1
  end
  local buff_attribs = {}
  for i, tbuff in ipairs(owner.buff_list) do
    local attribs = owner.attribs
    local info = tbuff.info
    if not owner.get_XE_ultBuff then
    elseif tbuff.caster and type(tbuff.caster.tid) == "number" and tbuff.caster.tid > 100000 then
    else
      for name, value in pairs(info) do
        if name == "HP" or name == "MP" or name == "HPR" or name == "MPR" or name == "PIMU" or name == "MIMU" or name == "ALLMIMU" or name == "HAST" or name == "MSPD" or name == "CDR" or name == "Time" then
          break
        end
        if attribs[name] then
          if not buff_attribs[name] then
            buff_attribs[name] = value
          else
            buff_attribs[name] = value + buff_attribs[name]
          end
        end
      end
    end
  end
  if not owner.config.is_boss then
    for name, value in pairs(buff_attribs) do
      buff:setAttribute(name, -value)
    end
  end
  owner:rebuild()
  caster.attribute_ratio = caster.XE_temp_attribute_ratio
end

function XE.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.actor and hero.actor.model.direction ~= hero.lastDirection then
    if hero.direction == -1 then
      hero.actor.puppet:setComponent("zidan_01", "zidan_01_s")
      hero.actor.puppet:setComponent("zidan_02", "zidan_02_s")
      hero.actor.puppet:setComponent("xiashen", "xiashen_s")
      hero.actor.puppet:setComponent("peidai", "peidai_s")
      hero.actor.puppet:setComponent("dao", "dao_s")
    else
      hero.actor.puppet:setComponent("zidan_01", "zidan_01")
      hero.actor.puppet:setComponent("zidan_02", "zidan_02")
      hero.actor.puppet:setComponent("xiashen", "xiashen")
      hero.actor.puppet:setComponent("peidai", "peidai")
      hero.actor.puppet:setComponent("dao", "dao")
    end
    local actionName = hero.actor:getActionName(hero.action_name)
    hero.actor.puppet:setAction(actionName)
    hero.actor.puppet:setLoop(hero.action_loop)
    hero.actor.puppet:setActionElapsed(hero.action_elapsed)
  end
  hero.lastDirection = hero.direction
end

function XE.cheer(basefunc, actor)
  local puppet = actor.puppet
  local cheerActionName = actor.model.direction == 1 and "Cheer" or "Cheer_s"
  puppet:setNextAction(cheerActionName)
  puppet:setLoop(true)
  actor.velocity = {0, 0}
  actor.node:setScaleX(actor.model.direction)
  actor.node:setScaleY(1)
  actor.offline = true
end

function XE.hero_onDying(basefunc, self, killer)
  basefunc(self, killer)
  if self.actor then
  end
end

function XE.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.cheer_action_reset = nil
end

function XE.init_hero(hero)
  local skillatk = hero.skills.XE_atk
  local skillatk2 = hero.skills.XE_atk2
  local skillatk2s = hero.skills.XE_atk2s
  local skillatk3 = hero.skills.XE_atk3
  local skillatk4 = hero.skills.XE_atk4
  local skillult = hero.skills.XE_ult
  hero.XE_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  hero.update = override(hero.update, XE.hero_update)
  hero.onDying = override(hero.onDying, XE.hero_onDying)
  hero.reset = override(hero.reset, XE.hero_reset)
  if skillatk then
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, XE.skillatk2_onAttackFrame)
  end
  if skillatk2s then
    skillatk2s.createBuff = override(skillatk2s.createBuff, XE.skillatk2s_createBuff)
  end
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, XE.skillatk3_onAttackFrame)
    skillatk3.createBuff = override(skillatk3.createBuff, XE.skillatk3_createBuff)
  end
  if skillatk4 then
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, XE.skillatk4_onAttackFrame)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, XE.skillatk4_takeEffectOn)
  end
  if skillult then
    skillult.createBuff = override(skillult.createBuff, XE.skillult_createBuff)
  end
  local skillnames = {
    "_ult",
    "_atk",
    "_atk2",
    "_atk4"
  }
  for i = 1, #skillnames do
    local skill = hero.skills["XE" .. skillnames[i]]
    if skill then
      skill.getDamage = override(skill.getDamage, XE.skillatk1234_getDamaged)
    end
  end
  return hero
end

return XE.init_hero
