module("ed.battlehero", package.seeall)
local ed = ed
ChessAxe = {}
ChessAxe.Chess_Axe_ult_buffID = 6074
ChessAxe.ChessAxe_ultself_buffID = 6075

function ChessAxe.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  if skill.attack_counter == 1 then
    local caster = skill.caster
    local binfo = ed.lookupDataTable("Buff", nil, ChessAxe.ChessAxe_ultself_buffID)
    binfo.Time = skill.info["Script Arg3"]
    local buff = ed.BuffCreate(binfo, caster, caster)
    buff:setAttribute("ARM", skill.info["Script Arg2"])
    caster:addBuff(buff, caster)
  end
end

function ChessAxe.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local basicskill = target.basic_skill
  basicskill.createProjectile = override(basicskill.createProjectile, ChessAxe.skillultenemy_createProjectile)
  return buff
end

function ChessAxe.skillultenemy_createProjectile(basefunc, skill)
  local pjct = basefunc(skill)
  for i, buff in ipairs(skill.caster.buff_list) do
    if buff.info.ID == ChessAxe.Chess_Axe_ult_buffID and skill.target and skill.target:isAlive() then
      pjct:enableTrack(skill.target)
    end
  end
  return pjct
end

function ChessAxe.init_hero(hero)
  local skillult = hero.skills.Axe_ult
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, ChessAxe.skillult_onAttackFrame)
    skillult.createBuff = override(skillult.createBuff, ChessAxe.skillult_createBuff)
  end
  return hero
end

return ChessAxe.init_hero
