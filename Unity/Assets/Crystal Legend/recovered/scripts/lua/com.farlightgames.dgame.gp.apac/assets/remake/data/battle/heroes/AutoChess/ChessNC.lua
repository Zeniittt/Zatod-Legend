module("ed.battlehero", package.seeall)
local ed = ed
ChessNC = {}
ChessNC.self_enhance_buffID = 6076
ChessNC.enemy_reduce_buffID = 6077

function ChessNC.skillatk_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.ChessNC_attackCounter = caster.ChessNC_attackCounter + 1
  if caster and caster:isAlive() then
    local hasbuff = false
    for i, buff in ipairs(caster.buff_list) do
      if buff.info.ID == ChessNC.self_enhance_buffID then
        hasbuff = true
        buff:setAttribute("AD", skill.info["Script Arg2"] * caster.ChessNC_attackCounter)
        buff:setAttribute("HAST", math.min(200, skill.info["Script Arg3"] * caster.ChessNC_attackCounter))
        buff:setAttribute("MSPD", math.min(200, skill.info["Script Arg3"] * caster.ChessNC_attackCounter))
        caster:rebuild()
      end
    end
    if not hasbuff then
      local binfo = ed.lookupDataTable("Buff", nil, ChessNC.self_enhance_buffID)
      local buff = ed.BuffCreate(binfo, caster, caster)
      buff:setAttribute("AD", skill.info["Script Arg2"])
      buff:setAttribute("HAST", skill.info["Script Arg3"])
      buff:setAttribute("MSPD", skill.info["Script Arg3"])
      caster:addBuff(buff, caster)
    end
  end
end

function ChessNC.skillatk_takeEffectOn(basefunc, skill, target, source, shift)
  local ret, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if target and target:isAlive() then
    if not target.ChessNC_attackCounter then
      target.ChessNC_attackCounter = 0
    end
    target.ChessNC_attackCounter = target.ChessNC_attackCounter + 1
    local hasbuff = false
    for i, buff in ipairs(target.buff_list) do
      if buff.info.ID == ChessNC.enemy_reduce_buffID then
        hasbuff = true
        buff:setAttribute("AD", -1 * skill.info["Script Arg2"] * target.ChessNC_attackCounter)
        target:rebuild()
      end
    end
    if not hasbuff then
      local binfo = ed.lookupDataTable("Buff", nil, ChessNC.enemy_reduce_buffID)
      local buff = ed.BuffCreate(binfo, target, caster)
      buff:setAttribute("AD", -1 * skill.info["Script Arg2"])
      target:addBuff(buff, caster)
    end
  end
  return ret, dmg, Crit, lfs_amount
end

function ChessNC.init_hero(hero)
  local skillatk = hero.skills.NC_atk
  hero.ChessNC_attackCounter = 0
  if skillatk then
    skillatk.start = override(skillatk.start, ChessNC.skillatk_start)
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, ChessNC.skillatk_takeEffectOn)
  end
  return hero
end

return ChessNC.init_hero
