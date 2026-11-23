module("ed.battlehero", package.seeall)
local ed = ed
THTitan = {}

function THTitan.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillult = caster.skills.THTitan_ult
  if skillult then
    local atk3_arm_differ = math.abs(caster.attribs.ARM - target.attribs.ARM)
    local skillult_time = 4 + atk3_arm_differ / 100
    buff.timer = math.min(skillult_time, 10)
  end
  return buff
end

function THTitan.skillatk2_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  local skillatk2 = caster.skills.THTitan_atk2
  if caster.attribs.ARM > target.attribs.ARM and skillatk2 then
    local atk2_buff_exists = false
    local atk2_arm_differ = caster.attribs.ARM - target.attribs.ARM
    for i, atk2_buff in ipairs(target.buff_list) do
      if atk2_buff.info.ID == 4648 then
        atk2_buff_exists = true
        local tbuff = skill:createBuff(target)
        caster.atk2_value_ARM = caster.atk2_value_ARM + tbuff.info.ARM - atk2_arm_differ
        caster.atk2_value_MR = caster.atk2_value_MR + tbuff.info.MR - atk2_arm_differ
        if target.attribs.ARM > 0 then
          atk2_buff:setAttribute("ARM", caster.atk2_value_ARM)
        end
        if target.attribs.MR > 0 then
          atk2_buff:setAttribute("MR", caster.atk2_value_MR)
        end
        target:addBuff(atk2_buff, caster)
      end
    end
    if atk2_buff_exists == false then
      local buff = skill:createBuff(target)
      caster.atk2_value_ARM = buff.info.ARM - atk2_arm_differ
      caster.atk2_value_MR = buff.info.MR - atk2_arm_differ
      buff:setAttribute("ARM", caster.atk2_value_ARM)
      buff:setAttribute("MR", caster.atk2_value_MR)
      target:addBuff(buff, caster)
    end
  end
  basefunc(skill, target)
end

function THTitan.skillatk3_start(basefunc, skill, target)
  skill.info["No Dodge"] = true
  basefunc(skill, target)
end

function THTitan.skillatk3_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillatk3 = caster.skills.THTitan_atk3
  if caster.attribs.ARM > target.attribs.ARM then
    local atk3_buff_exists = false
    local atk3_arm_differ = caster.attribs.ARM - target.attribs.ARM
    for i, atk3_buff in ipairs(caster.buff_list) do
      if atk3_buff.info.ID == 4651 then
        atk3_buff_exists = true
        caster.atk3_value_ARM = skill.info["Script Arg3"] + atk3_arm_differ + caster.atk3_value_ARM
        caster.atk3_value_AD = skill.info["Script Arg4"] + atk3_arm_differ + caster.atk3_value_AD
        if caster.attribs.ARM < 4 * caster.origin_ARM then
          atk3_buff:setAttribute("ARM", caster.atk3_value_ARM)
        end
        if caster.attribs.AD < 2.5 * caster.origin_ARM then
          atk3_buff:setAttribute("AD", math.min(caster.atk3_value_AD, caster.origin_AD))
        end
        caster:addBuff(atk3_buff, caster)
      end
    end
    if atk3_buff_exists == false then
      local bid = 4651
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      caster.atk3_value_ARM = skill.info["Script Arg3"] + atk3_arm_differ
      caster.atk3_value_AD = skill.info["Script Arg4"] + atk3_arm_differ
      buff:setAttribute("ARM", caster.atk3_value_ARM)
      buff:setAttribute("AD", math.min(caster.atk3_value_AD, caster.origin_AD))
      caster:addBuff(buff, caster)
    end
  end
end

function THTitan.hero_reset(basefunc, hero)
  basefunc(hero)
  local skillatk4 = hero.skills.THTitan_atk4
  hero.threshold = 0.1
  hero.min_arm = 0
  hero.last_hp = hero.hp
  hero.origin_AD = hero.attribs.AD
  hero.origin_ARM = hero.attribs.ARM
  hero.origin_MR = hero.attribs.MR
  hero.atk4_value_MR = 0
  hero.atk4_value_ARM = 0
  hero.atk3_value_AD = 0
  hero.atk3_value_ARM = 0
  hero.atk2_value_ARM = 0
  hero.atk2_value_MR = 0
  if hero and skillatk4 then
    local start_ARM = 0.25 * hero.attribs.ARM
    local bid = 4655
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    buff:setAttribute("ARM", start_ARM)
    hero:addBuff(buff, hero)
  end
end

function THTitan.skillatk4_isnegative_effect(buff)
  local negative_effects = {
    frozen = true,
    stun = true,
    immoblilize = true,
    silence = true,
    disarm = true,
    imprisonment = true,
    enchanted = true,
    fear = true,
    taunt = true,
    detaunt = true,
    polymorph = true,
    icefrozen = true
  }
  local isRet = false
  local info = buff.info
  for i, effect in ipairs(info["Control Effects"]) do
    if negative_effects[effect] then
      isRet = true
      break
    end
  end
  return isRet
end

function THTitan.hero_update(basefunc, self, dt)
  local skillatk4 = self.skills.THTitan_atk4
  local cur_hp = self.hp
  local last_hp = self.last_hp
  if cur_hp >= last_hp then
    self.last_hp = cur_hp
    last_hp = self.last_hp
  end
  local hp_max = self.attribs.HP
  if last_hp - cur_hp >= hp_max * self.threshold then
    local list = self.buff_list
    local my_camp = self.camp
    for i = 1, #list do
      local buff = list[i]
      if buff and buff.owner == self and THTitan.skillatk4_isnegative_effect(buff) and buff.timer <= 20 then
        buff.owner:removeBuff(buff)
      end
    end
    self.last_hp = cur_hp
    if skillatk4 then
      self.min_arm = self.attribs.ARM
      for unit in ed.engine:foreachAliveUnit(-my_camp) do
        if unit.attribs.ARM < self.min_arm and not unit.config.is_summoned and unit.what ~= "petUnit" then
          self.min_arm = unit.attribs.ARM
        end
      end
      local ARM_differ = self.attribs.ARM - self.min_arm
      local atk4_buff_exists = false
      for i, atk4_buff in ipairs(self.buff_list) do
        if atk4_buff.info.ID == 4647 then
          atk4_buff_exists = true
          self.atk4_value_MR = skillatk4.info["Script Arg5"] + ARM_differ + self.atk4_value_MR
          self.atk4_value_ARM = skillatk4.info["Script Arg6"] + ARM_differ + self.atk4_value_ARM
          if self.attribs.ARM < 4 * self.origin_ARM then
            atk4_buff:setAttribute("ARM", self.atk4_value_ARM)
          end
          if self.attribs.MR < 4 * self.origin_ARM then
            atk4_buff:setAttribute("MR", self.atk4_value_MR)
          end
          atk4_buff.timer = atk4_buff.info.Time
          self:addBuff(atk4_buff, self)
        end
      end
      if atk4_buff_exists == false then
        local bid = 4647
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = ed.BuffCreate(binfo, self, self)
        self.atk4_value_ARM = skillatk4.info["Script Arg6"] + ARM_differ
        self.atk4_value_MR = skillatk4.info["Script Arg5"] + ARM_differ
        buff:setAttribute("ARM", self.atk4_value_ARM)
        buff:setAttribute("MR", self.atk4_value_MR)
        self:addBuff(buff, self)
      end
    end
  end
  basefunc(self, dt)
end

function THTitan.init_hero(hero)
  local skillatk2 = hero.skills.THTitan_atk2
  local skillatk3 = hero.skills.THTitan_atk3
  local skillatk4 = hero.skills.THTitan_atk4
  local skillult = hero.skills.THTitan_ult
  hero.update = override(hero.update, THTitan.hero_update)
  hero.reset = override(hero.reset, THTitan.hero_reset)
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, THTitan.skillatk2_takeEffectOn)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, THTitan.skillatk3_start)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, THTitan.skillatk3_takeEffectOn)
  end
  if skillult then
    skillult.createBuff = override(skillult.createBuff, THTitan.skillult_createBuff)
  end
  return hero
end

return THTitan.init_hero
