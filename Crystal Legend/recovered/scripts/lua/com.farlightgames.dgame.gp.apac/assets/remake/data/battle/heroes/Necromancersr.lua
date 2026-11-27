module("ed.battlehero", package.seeall)
local ed = ed
Necromancersr = {}

function Necromancersr.selectTarget(basefunc, self, default)
  self.target = nil
  for i, unit in ipairs(ed.engine.unit_list) do
    if unit.state == ed.emUnitState_Dead and unit.hasCorpse and unit.action_elapsed < 5 then
      self.target = unit
    end
  end
  return self.target
end

function Necromancersr.onAttackFrame(basefunc, self)
  if self.target then
    self:takeEffectAt(self.target.position)
  end
end

function Necromancersr.takeEffectOn(basefunc, self, target, source)
  if not target.hasCorpse then
    return false
  end
  target.hasCorpse = false
  if target.actor and target.actor.node then
    target.actor.node:setVisible(false)
  end
  local proto = {
    _tid = 111,
    _level = target.level
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    estimate_skill = true
  }
  local caster = self.caster
  local skeleton = ed.UnitCreate(proto, caster.camp, config)
  skeleton.direction = caster.direction
  ed.engine:summonUnit(skeleton, target.position, caster)
end

function Necromancersr.init_hero(hero)
  local skill = hero.skills.Necromancersr_atk2
  if skill then
    function skill.target_selector()
      return true
    end
    
    skill.selectTarget = override(skill.selectTarget, Necromancersr.selectTarget)
    skill.onAttackFrame = override(skill.onAttackFrame, Necromancersr.onAttackFrame)
    skill.takeEffectOn = override(skill.takeEffectOn, Necromancersr.takeEffectOn)
  end
  return hero
end

return Necromancersr.init_hero
