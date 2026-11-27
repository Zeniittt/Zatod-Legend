local function rogueBless7315update(basefunc, buff, dt)
  buff.ticks = (buff.ticks or 0) + 1
  
  local owner = buff.owner
  local caster = buff.caster
  local bless7315 = ed.engine.rogueSkillMgr.rogueBlessList[7315]
  local hplimit = owner.attribs.HP * (bless7315.isReinforced and bless7315.info["Script Arg5"] or bless7315.info["Script Arg1"]) / 100
  local bless7315shieldratio = (bless7315.isReinforced and bless7315.info["Script Arg6"] or bless7315.info["Script Arg2"]) / 100
  local bless7315shielefficiency = (bless7315.isReinforced and bless7315.info["Script Arg7"] or bless7315.info["Script Arg3"]) / 100
  if buff.ticks == 1 then
    if hplimit < owner.hp then
      owner:setHP(hplimit, "bless7315")
    end
    local ShieldIncrease = 0
    local ShieldWeak = 0
    if owner.attribs.ShieldIncrease then
      ShieldIncrease = owner.attribs.ShieldIncrease
    end
    if owner.attribs.ShieldWeak then
      ShieldWeak = owner.attribs.ShieldWeak
    end
    local shieldratio = math.max(0.01, 1 + (ShieldIncrease - ShieldWeak) / 100)
    local shieldnum = owner.attribs.HP * bless7315shieldratio * shieldratio
    local have7315buff = false
    for i, tbuff in ipairs(owner.buff_list) do
      if tbuff.info.ID == 60017000 then
        tbuff.shield = tbuff.shield + shieldnum
        have7315buff = true
      end
    end
    if not have7315buff then
      local bless7315bid = 60017000
      local bless7315binfo = ed.lookupDataTable("Buff", nil, bless7315bid)
      local bless7315buff = ed.BuffCreate(bless7315binfo, owner, owner)
      bless7315buff.shield = shieldnum
      owner:addBuff(bless7315buff, owner)
    end
  end
  if hplimit < owner.hp then
    owner.bless7315Extra_Shield = bless7315shielefficiency * (owner.hp - hplimit)
    owner:setHP(hplimit, "bless7315")
  else
    owner.bless7315Extra_Shield = 0
  end
  if 0 < owner.bless7315Extra_Shield then
    local ShieldIncrease = 0
    local ShieldWeak = 0
    if owner.attribs.ShieldIncrease then
      ShieldIncrease = owner.attribs.ShieldIncrease
    end
    if owner.attribs.ShieldWeak then
      ShieldWeak = owner.attribs.ShieldWeak
    end
    local shieldratio = math.max(0.01, 1 + (ShieldIncrease - ShieldWeak) / 100)
    local shieldnum = owner.bless7315Extra_Shield * shieldratio
    local have7315buff = false
    for i, tbuff in ipairs(owner.buff_list) do
      if tbuff.info.ID == 60017000 then
        tbuff.shield = tbuff.shield + shieldnum
        have7315buff = true
      end
    end
    if not have7315buff then
      local bless7315bid = 60017000
      local bless7315binfo = ed.lookupDataTable("Buff", nil, bless7315bid)
      local bless7315buff = ed.BuffCreate(bless7315binfo, owner, owner)
      bless7315buff.shield = shieldnum
      owner:addBuff(bless7315buff, owner)
    end
  end
  owner.bless7315haveshield = false
  for i, tbuff in ipairs(owner.buff_list) do
    if tbuff.shield and 0 < tbuff.shield then
      owner.bless7315haveshield = true
      break
    end
  end
  if owner.revelation7buff then
    owner.bless7315haveshield = true
  end
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + 1
    if ed.engine.rogueSkillMgr:getBless(7315) then
      local bless7315 = ed.engine.rogueSkillMgr.rogueBlessList[7315]
      local MPR = bless7315.isReinforced and bless7315.info["Script Arg8"] or bless7315.info["Script Arg4"]
      if owner.bless7315haveshield and not owner.bless7315havebeeffect then
        buff:setAttribute("MPR", MPR)
        owner.bless7315havebeeffect = true
        owner:rebuild()
      elseif not owner.bless7315haveshield and owner.bless7315havebeeffect then
        buff:setAttribute("MPR", 0)
        owner.bless7315havebeeffect = false
        owner:rebuild()
      end
    end
  end
  buff.attack_timer = timer
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  owner.bless7315Extra_Shield = 0
  buff.attack_timer = 1
  buff.update = override(buff.update, rogueBless7315update)
  buff.unremoveable = true
  return buff
end

return initBuff
