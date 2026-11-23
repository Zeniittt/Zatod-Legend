module("ed.battlehero", package.seeall)
local ed = ed
NPCUS = {}
NPCUS.buffID3 = "NPCUS_pasv1"
NPCUS.buffID4 = "NPCUS_pasv2"

function NPCUS.atk3_buff_onRemoved(basefunc, buff)
  buff.owner[NPCUS.buffID3] = nil
  basefunc(buff)
end

function NPCUS.skillatk3_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, NPCUS.atk3_buff_onRemoved)
  target[NPCUS.buffID3] = buff
  if target[NPCUS.buffID3] then
    caster.atk3_NPCUS = true
  end
  return buff
end

function NPCUS.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  if skill.target then
    skill.caster.skill3originlocation_US = {
      skill.target.position[1],
      skill.target.position[2]
    }
  else
    skill.caster.skill3originlocation_US = {
      skill.caster.position[1],
      skill.caster.position[2]
    }
  end
end

function NPCUS.skillatk3_onAttackFrame(basefunc, self)
  if self.caster.manually_casting then
    ed.engine:unfreeze()
    self.caster.manually_casting = false
  end
  self.attack_counter = self.attack_counter + 1
  if self.info["Target Type"] == "random" or self.target == nil or not self.target:isAlive() then
    self:selectTarget(nil)
  end
  local info = self.info
  local caster = self.caster
  if self.attack_counter == 1 then
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_US_atk3.cha", {
        self.caster.skill3originlocation_US[1],
        self.caster.skill3originlocation_US[2] + 1
      }, {
        self.caster.direction,
        1
      }, nil, 0)
    end
  else
    self:takeEffectAt(self.caster.skill3originlocation_US)
    self.caster.skill3originlocation_US = nil
    caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
  end
end

function NPCUS.atk4_buff_onRemoved(basefunc, buff)
  buff.owner[NPCUS.buffID4] = nil
  basefunc(buff)
end

function NPCUS.skillatk4_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, NPCUS.atk4_buff_onRemoved)
  target[NPCUS.buffID4] = buff
  if target[NPCUS.buffID4] then
    caster.atk4 = true
  end
  return buff
end

function NPCUS.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  skill.caster.skill3originlocation_US = {
    target.position[1],
    target.position[2]
  }
end

function NPCUS.skillatk4_onAttackFrame(basefunc, self)
  if self.caster.manually_casting then
    ed.engine:unfreeze()
    self.caster.manually_casting = false
  end
  self.attack_counter = self.attack_counter + 1
  if self.info["Target Type"] == "random" or self.target == nil or not self.target:isAlive() then
    self:selectTarget(nil)
  end
  local info = self.info
  local caster = self.caster
  if self.attack_counter == 1 then
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_US_atk3.cha", {
        self.caster.skill3originlocation_US[1],
        self.caster.skill3originlocation_US[2] + 1
      }, {
        self.caster.direction,
        1
      }, nil, 0)
    end
  else
    self:takeEffectAt(self.caster.skill3originlocation_US)
    self.caster.skill3originlocation_US = nil
    caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
  end
end

function NPCUS.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skill2 = hero.skills.NPCUS_atk2
  local skill3 = hero.skills.NPCUS_atk3
  local skill4 = hero.skills.NPCUS_atk4
  local ragehealhp = 0.1 * hero.attribs.HP
  if hero.current_skill ~= skill3 and hero.hp >= 2 * ragehealhp and not hero.atk3_NPCUS then
    skill3.cd_remaining = 0
  end
  if hero.current_skill ~= skill4 and hero.hp >= 5 * ragehealhp and not hero.atk4 then
    skill4.cd_remaining = 0
  end
  if hero.hp >= 10 * ragehealhp and not hero.atk2 then
    skill2.cd_remaining = 0
    hero.atk2 = true
  end
  local list = ed.engine.alive_units[hero.camp]
  if #list == 1 then
    hero:die()
  end
end

function NPCUS.skillatk2_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local hero = skill.caster
  for i, pbuff in ipairs(hero.buff_list) do
    if pbuff.info.ID == 258 then
      local buff = pbuff
      buff.timer = 0
      break
    end
  end
end

function NPCUS.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.hp = 10
  local binfo
  local bid = 255
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  hero:addBuff(binfo, hero)
end

function NPCUS.init_hero(hero)
  hero.reset = override(hero.reset, NPCUS.hero_reset)
  hero.update = override(hero.update, NPCUS.hero_update)
  local skillatk2 = hero.skills.NPCUS_atk2
  if skillatk2 then
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, NPCUS.skillatk2_takeEffectAt)
  end
  local skillatk3 = hero.skills.NPCUS_atk3
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, NPCUS.skillatk3_createBuff)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, NPCUS.skillatk3_onAttackFrame)
    skillatk3.start = override(skillatk3.start, NPCUS.skillatk3_start)
  end
  local skillatk4 = hero.skills.NPCUS_atk4
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, NPCUS.skillatk4_createBuff)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, NPCUS.skillatk4_onAttackFrame)
    skillatk4.start = override(skillatk4.start, NPCUS.skillatk4_start)
  end
  return hero
end

return NPCUS.init_hero
