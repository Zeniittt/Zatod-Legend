module("ed.battlehero", package.seeall)
local ed = ed
ChessDP = {}
ChessDP.interval = 0.5

function ChessDP.ult_buff_update(basefunc, self, dt)
  local buff = self
  local self = buff.owner
  buff.second_timer = buff.second_timer - dt
  if buff.second_timer < 0.5 and ed.run_with_scene then
    ed.scene:removeEffect(buff.origin_effect, -1)
  end
  if buff.second_timer > 0.5 and buff then
    local timer = buff.attack_timer - dt
    while timer <= 0 do
      timer = timer + ChessDP.interval
      local skill = buff.caster.skills.DP_ult
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
  end
  basefunc(buff, dt)
end

function ChessDP.update(basefunc, self, dt)
  if self.change_mp_index then
    self.change_mp_index = self.change_mp_index + dt
  end
  basefunc(self, dt)
end

function ChessDP.onRemoved(basefunc, buff)
  if ed.run_with_scene then
    ed.scene:removeEffect(buff.origin_effect, -1)
  end
  basefunc(buff)
end

function ChessDP.takeEffectOn(basefunc, self, target, source, shift)
  if target == self.caster and not self.caster.DP_ult_buff then
    local buff = self.caster:addBuff(self:createBuff(self.caster))
    if buff then
      self.caster.DP_ult_buff = buff
    end
  else
    return basefunc(self, target, source, shift)
  end
end

function ChessDP.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.attack_timer = ChessDP.interval
  buff.total_dmg = 0
  buff.total_times = 0
  buff.second_timer = 4.5
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
  buff.update = override(buff.update, ChessDP.ult_buff_update)
  buff.onRemoved = override(buff.onRemoved, ChessDP.onRemoved)
  return buff
end

function ChessDP.reset(basefunc, hero)
  basefunc(hero)
  hero.change_mp_index = 0
  hero.is_superawake = 0
  hero.DP_ultsecond = 0
  hero.buff_total_dmg = 0
end

function ChessDP.init_hero(hero)
  local skill = hero.skills.DP_ult
  hero.update = override(hero.update, ChessDP.update)
  if skill then
    skill.createBuff = override(skill.createBuff, ChessDP.createBuff)
    skill.takeEffectOn = override(skill.takeEffectOn, ChessDP.takeEffectOn)
    hero.reset = override(hero.reset, ChessDP.reset)
  end
  return hero
end

return ChessDP.init_hero
