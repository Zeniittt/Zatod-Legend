module("ed.battlehero", package.seeall)
local ed = ed
TPonion = {}

function TPonion.skillatk_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local caster = skill.caster
  caster.atk = true
  caster:die(source)
end

function TPonion.setAction(basefunc, self, action_name, loop, interrupt)
  if self.atk == true and action_name == "Death" then
    action_name = "Death2"
  end
  basefunc(self, action_name, loop, interrupt)
end

function TPonion.init_hero(hero)
  hero.setAction = override(hero.setAction, TPonion.setAction)
  local skillatk = hero.skills.TPonion_atk
  if skillatk then
    skillatk.takeEffectAt = override(skillatk.takeEffectAt, TPonion.skillatk_takeEffectAt)
  end
  return hero
end

return TPonion.init_hero
