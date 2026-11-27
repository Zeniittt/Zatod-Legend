module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossRazor = {}
AwakeBossRazor.atk3selfbuff = 10038502

function AwakeBossRazor.skillatk3_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local info = skill.info
  local bid = AwakeBossRazor.atk3selfbuff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  local AD = -info.buff_info.AD
  buff:setAttribute("AD", AD)
  local skillatk = caster.skills.AwakeBossRazor_atk
  skillatk:takeEffectOn(target)
  caster:addBuff(buff, caster)
end

function AwakeBossRazor.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff:setAttribute("PIMU", -10)
  return buff
end

function AwakeBossRazor.init_hero(hero)
  local skillatk3 = hero.skills.AwakeBossRazor_atk3
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, AwakeBossRazor.skillatk3_takeEffectOn)
    skillatk3.createBuff = override(skillatk3.createBuff, AwakeBossRazor.skillatk3_createBuff)
  end
  return hero
end

return AwakeBossRazor.init_hero
