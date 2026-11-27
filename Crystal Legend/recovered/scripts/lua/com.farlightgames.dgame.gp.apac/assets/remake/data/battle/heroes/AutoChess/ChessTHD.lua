module("ed.battlehero", package.seeall)
local ed = ed
ChessTHD = {}
ChessTHD.ult2 = 7007

function ChessTHD.buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  if ed.engine.freeze_level > 0 then
    buff.timer = buff.timer + dt
  end
  if buff.timer == 0 and not ed.engine.beingEnd then
    local bid = ChessTHD.ult2
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff2 = ed.BuffCreate(binfo, owner, caster)
    buff2.update = override(buff2.update, ChessTHD.buff2_update)
    local buffInfo2 = buff2.info
    local attribName = buffInfo2.Tenacity
    local TEN_final = 0
    if owner.camp ~= caster.camp and attribName and owner.attribs[attribName] then
      local CON = caster.attribs.CON
      TEN_final = owner.attribs[attribName] - CON
    end
    local skill = caster.skills.THD_ult
    owner:addBuff(buff2, caster)
  end
end

function ChessTHD.buff2_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner:isHasUncontrolBufEffect() then
    buff.timer = -1
  end
end

function ChessTHD.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = buff.owner
  buff.update = override(buff.update, ChessTHD.buff_update)
  return buff
end

function ChessTHD.init_hero(hero)
  local skillult = hero.skills.THD_ult
  if skillult then
    skillult.createBuff = override(skillult.createBuff, ChessTHD.skillult_createBuff)
  end
  return hero
end

return ChessTHD.init_hero
