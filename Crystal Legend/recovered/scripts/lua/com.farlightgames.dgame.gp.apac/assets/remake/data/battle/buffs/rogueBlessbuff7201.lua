local function rogueBless7201onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  
  local owner = buff.owner
  if 0 < damage and not transferred and source.camp ~= owner.camp and field and field == "hp" and ed.engine.rogueSkillMgr:getBless(7201) then
    local bless7201 = ed.engine.rogueSkillMgr.rogueBlessList[7201]
    local bless7201p = (bless7201.isReinforced and bless7201.info["Script Arg5"] or bless7201.info["Script Arg1"]) / 100
    local totalshield = 0
    for i, tbuff in ipairs(owner.buff_list) do
      if tbuff.shield and 0 < tbuff.shield then
        totalshield = totalshield + tbuff.shield
      end
    end
    if owner.revelation7buff then
      totalshield = totalshield + owner.revelation7buffshield
    end
    local bless7201dmg = totalshield * bless7201p
    if 0 < bless7201dmg then
      if ed.engine.rogueSkillMgr:getBless(7202) then
        local bless7202 = ed.engine.rogueSkillMgr.rogueBlessList[7202]
        if bless7202.isReinforced then
          local bless7202ratio = bless7202.info["Script Arg5"]
          bless7201dmg = bless7201dmg * bless7202ratio
        end
      end
      if ed.engine.rogueSkillMgr:getBless(7401) then
        local bless7401 = ed.engine.rogueSkillMgr.rogueBlessList[7401]
        local bless7401ratio = bless7401.info["Script Arg1"] / 100
        bless7201dmg = bless7201dmg + bless7401ratio * owner.attribs.HP
      end
      source:takeDamage(bless7201dmg, buff.bless7201dmgtype, "hp", owner, 1, 1, true)
    end
  end
  return damage
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  local ad = owner.attribs.AD
  local ap = owner.attribs.AP
  if ad >= ap then
    buff.bless7201dmgtype = "AD"
  else
    buff.bless7201dmgtype = "AP"
  end
  if ed.engine.rogueSkillMgr:getBless(7202) then
    buff.bless7201dmgtype = "Holy"
  end
  buff.onDamaged = override(buff.onDamaged, rogueBless7201onDamaged)
  return buff
end

return initBuff
