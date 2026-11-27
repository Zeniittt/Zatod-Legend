module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossES = {}
AwakeBossES.pasvARM = 10037004
AwakeBossES.pasvMR = 10037005
AwakeBossES.SkillEvoPointEffect = "eff_point_ES_awake.cha"

function AwakeBossES.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local lost = basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local dt = damage_type or struct_table.damage_type
  local s = source or struct_table.source
  if lost and 0 < lost then
    if dt == "AD" then
      local bid1 = AwakeBossES.pasvARM
      local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
      local buff1 = ed.BuffCreate(binfo1, self, self)
      self:addBuff(buff1, self)
    end
    if dt == "AP" then
      local bid2 = AwakeBossES.pasvMR
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      local buff2 = ed.BuffCreate(binfo2, self, self)
      self:addBuff(buff2, self)
    end
  end
  return lost
end

function AwakeBossES.init_hero(hero)
  local skillult = hero.skills.AwakeBossES_ult
  local skillatk2 = hero.skills.AwakeBossES_atk2
  local skillatk3 = hero.skills.AwakeBossES_atk3
  local skillpasv = hero.passive_skill_list[1]
  local skillevo = hero.skills.AwakeBossES_evo
  hero.takeDamage = override(hero.takeDamage, AwakeBossES.hero_takeDamage)
  return hero
end

return AwakeBossES.init_hero
