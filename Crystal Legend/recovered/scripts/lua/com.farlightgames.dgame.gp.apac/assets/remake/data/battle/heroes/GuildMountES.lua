module("ed.battlehero", package.seeall)
local ed = ed
GuildMountES = {}
GuildMountES.pasvARM = 10037004
GuildMountES.pasvMR = 10037005
GuildMountES.SkillEvoPointEffect = "eff_point_ES_awake.cha"

function GuildMountES.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local lost = basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local dt = damage_type or struct_table.damage_type
  local s = source or struct_table.source
  if lost and 0 < lost then
    if dt == "AD" then
      local bid1 = GuildMountES.pasvARM
      local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
      local buff1 = ed.BuffCreate(binfo1, self, self)
      self:addBuff(buff1, self)
    end
    if dt == "AP" then
      local bid2 = GuildMountES.pasvMR
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      local buff2 = ed.BuffCreate(binfo2, self, self)
      self:addBuff(buff2, self)
    end
  end
  return lost
end

function GuildMountES.init_hero(hero)
  local skillult = hero.skills.GuildMountES_ult
  local skillatk2 = hero.skills.GuildMountES_atk2
  local skillatk3 = hero.skills.GuildMountES_atk3
  local skillpasv = hero.passive_skill_list[1]
  local skillevo = hero.skills.GuildMountES_evo
  if skillpasv then
    hero.takeDamage = override(hero.takeDamage, GuildMountES.hero_takeDamage)
  end
  return hero
end

return GuildMountES.init_hero
