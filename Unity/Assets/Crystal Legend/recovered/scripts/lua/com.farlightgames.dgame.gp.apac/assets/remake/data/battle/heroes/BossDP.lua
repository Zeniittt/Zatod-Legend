module("ed.battlehero", package.seeall)
local ed = ed
BossDP = {}
BossDP.interval = 0.375

function BossDP.ult_buff_update(basefunc, self, dt)
  local buff = self
  local self = buff.owner
  buff.second_timer = buff.second_timer - dt
  if buff.second_timer > 1.5 then
    if buff then
      local timer = buff.attack_timer - dt
      while timer <= 0 do
        timer = timer + BossDP.interval
        local skill = buff.caster.skills.BossDP_ult
        local originfo = skill.info
        local origtarget = skill.target
        skill.info = ed.wraptable(originfo, {
          ["Buff ID"] = 0,
          ["Damage Type"] = "AP",
          ["Target Camp"] = -1,
          ["Affected Camp"] = -1,
          ["Target Type"] = "random"
        })
        local target = skill:selectTarget()
        if target then
          local succ, dmg = skill:takeEffectOn(target, skill.caster)
          buff.total_times = buff.total_times + 1
          if dmg then
            local coefficient = 1
            if buff.total_times > 2 then
              coefficient = 0.8
            end
            buff.total_dmg = buff.total_dmg + dmg * coefficient
            self.buff_total_dmg = buff.total_dmg
          end
        end
        skill.info = originfo
        skill.target = origtarget
      end
      buff.attack_timer = timer
      local skill = self.skills.BossDP_sawake
      if skill then
        if buff.second_timer == 8 and ed.run_with_scene then
          ed.scene:playEffectOnScene("eff_point_DP_ult_sawake.cha", {
            self.position[1],
            self.position[2] - 30
          }, {
            self.direction,
            1
          }, nil, 0)
        end
        self.is_superawake = 1
      end
      if skill and buff.second_timer == 1.625 and ed.run_with_scene then
        ed.scene:removeEffect(buff.origin_effect, -1)
      end
      if skill and math.ceil(buff.second_timer) == buff.second_timer then
        self:takeHeal(buff.total_dmg * 0.15, "hp", self)
      end
    end
  else
    local skill = self.skills.BossDP_sawake
    if not skill then
      if buff.second_timer == 1 and ed.run_with_scene then
        ed.scene:removeEffect(buff.origin_effect, -1)
      end
      basefunc(buff, dt)
      return
    end
    if buff.second_timer == 0.75 then
      local skill = self.skills.BossDP_sawake
      local index = {
        0.13,
        0.08,
        0.12,
        0.07,
        0.1
      }
      local hero_number = 0
      for unit in ed.engine:foreachAliveUnit(self.foecamp) do
        if unit.info["Unit Type"] == "Hero" then
          hero_number = hero_number + 1
        end
      end
      if skill then
        local sum = self.buff_total_dmg * 0.7 * (skill.level / 100)
        local i = 1
        local big_is_true = 0
        for unit in ed.engine:foreachAliveUnit(self.foecamp) do
          if unit.info["Unit Type"] == "Hero" then
            if unit.hp < sum * 0.6 and big_is_true == 0 then
              if unit.name == "Ony" then
                unit:setHP(0)
              else
                unit:setHP(0)
                unit:onDying()
              end
              self.battledata:addDamage(unit.hp, "AP")
              hero_number = hero_number - 1
              if ed.run_with_scene then
                local str = "-" .. math.floor(sum * 0.6 + 0.5)
                local color = skill.caster.camp == ed.emCampPlayer and "orange" or "red"
                ed.PopupCreate(str, color, unit.actor, false)
              end
              big_is_true = 1
            elseif hero_number == 1 and big_is_true == 0 then
              if unit.hp < sum * 0.6 then
                if unit.name == "Ony" then
                  unit:setHP(0)
                else
                  unit:setHP(0)
                  unit:onDying()
                end
              else
                unit:setHP(unit.hp - sum * 0.6)
              end
              hero_number = hero_number - 1
              local x = sum * 0.6
              self.battledata:addDamage(x, "AP")
              if ed.run_with_scene then
                local str = "-" .. math.floor(x + 0.5)
                local color = skill.caster.camp == ed.emCampPlayer and "orange" or "red"
                ed.PopupCreate(str, color, unit.actor, false)
              end
            else
              if unit.hp < sum * index[i] then
                if unit.name == "Ony" then
                  unit:setHP(0)
                else
                  unit:setHP(0)
                  unit:onDying()
                end
              else
                unit:setHP(unit.hp - sum * index[i])
              end
              hero_number = hero_number - 1
              local x = sum * index[i]
              i = i % 5 + 1
              self.battledata:addDamage(x, "AP")
              if ed.run_with_scene then
                local str = "-" .. math.floor(x + 0.5)
                local color = skill.caster.camp == ed.emCampPlayer and "orange" or "red"
                ed.PopupCreate(str, color, unit.actor, false)
              end
            end
          end
        end
      end
    end
  end
  basefunc(buff, dt)
end

function BossDP.update(basefunc, self, dt)
  if self.change_mp_index then
    self.change_mp_index = self.change_mp_index + dt
    if self.change_mp_index == 0.125 then
      local skill = self.skills.BossDP_sawake
      if skill then
        local skill_atk = self.skills.BossDP_atk
        local originfo = skill_atk.info
        skill_atk.info = ed.wraptable(originfo, {
          ["Gain MP"] = 100
        })
        local skill_atk2 = self.skills.BossDP_atk2
        local originfo = skill_atk2.info
        skill_atk2.info = ed.wraptable(originfo, {
          ["Gain MP"] = 150
        })
        local skill_atk3 = self.skills.BossDP_atk3
        local originfo = skill_atk3.info
        skill_atk3.info = ed.wraptable(originfo, {
          ["Gain MP"] = 100
        })
      end
    end
  end
  basefunc(self, dt)
end

function BossDP.onRemoved(basefunc, buff)
  if buff.owner.is_superawake == 0 then
    buff.owner:takeHeal(buff.total_dmg * 0.65, "hp", buff.owner)
  end
  if 0 < buff.second_timer and ed.run_with_scene then
    ed.scene:removeEffect(buff.origin_effect, -1)
  end
  buff.second_timer = 10
  basefunc(buff)
end

function BossDP.takeEffectOn(basefunc, self, target, source, shift)
  if target == self.caster and not self.caster.DP_ult_buff then
    local buff = self.caster:addBuff(self:createBuff(self.caster))
    if buff then
      self.caster.DP_ult_buff = buff
    end
  else
    return basefunc(self, target, source, shift)
  end
end

function BossDP.createBuff(basefunc, skill, target)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, 4114)
  local ult_buff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(ult_buff, caster)
  if ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_point_DP_ult_sawake.cha", {
      caster.position[1],
      caster.position[2] - 30
    }, {
      caster.direction,
      1
    }, nil, 0)
  end
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    unit:setMP(0)
  end
  local buff = basefunc(skill, target)
  buff.attack_timer = BossDP.interval
  buff.total_dmg = 0
  buff.total_times = 0
  buff.second_timer = 10
  if ed.run_with_scene then
    local effect_name = "eff_buff_DP_ult.cha"
    if not effect_name then
      return
    end
    local effect_z = -1
    buff.origin_effect = ed.scene:playEffectOnScene(effect_name, buff.owner.position, {
      buff.owner.direction,
      1
    }, nil, effect_z)
  end
  buff.update = override(buff.update, BossDP.ult_buff_update)
  buff.onRemoved = override(buff.onRemoved, BossDP.onRemoved)
  return buff
end

function BossDP.reset(basefunc, hero)
  basefunc(hero)
  hero.change_mp_index = 0
  hero.is_superawake = 0
  hero.DP_ultsecond = 0
  hero.buff_total_dmg = 0
end

function BossDP.skillult_finish(basefunc, skill)
  local caster = skill.caster
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    local caster = skill.caster
    local binfo = ed.lookupDataTable("Buff", nil, 4115)
    local MPR_buff = ed.BuffCreate(binfo, unit, caster)
    unit:addBuff(MPR_buff, caster)
  end
  basefunc(skill)
end

function BossDP.init_hero(hero)
  local skill = hero.skills.BossDP_ult
  hero.update = override(hero.update, BossDP.update)
  if skill then
    skill.createBuff = override(skill.createBuff, BossDP.createBuff)
    skill.takeEffectOn = override(skill.takeEffectOn, BossDP.takeEffectOn)
    hero.reset = override(hero.reset, BossDP.reset)
    skill.finish = override(skill.finish, BossDP.skillult_finish)
  end
  return hero
end

return BossDP.init_hero
