local class = newclass("g")
ed.rogueBless7102 = class

function class.revelationonFinish(basefunc, self)
  basefunc(self)
  local max = -math.huge
  local chosen
  for target in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
    local v = -target.hp
    if max < v then
      max = v
      chosen = target
    end
  end
  local bless = ed.engine.rogueSkillMgr.rogueBlessList[7102]
  local ShieldIncrease = 0
  local ShieldWeak = 0
  if chosen.attribs.ShieldIncrease then
    ShieldIncrease = chosen.attribs.ShieldIncrease
  end
  if chosen.attribs.ShieldWeak then
    ShieldWeak = chosen.attribs.ShieldWeak
  end
  local shieldratio = math.max(0.01, 1 + (ShieldIncrease - ShieldWeak) / 100)
  local shieldnum = bless.info["Script Arg1"] / 100 * chosen.attribs.HP * shieldratio
  local have7102buff = false
  for i, tbuff in ipairs(chosen.buff_list) do
    if tbuff.info.ID == 60017000 then
      tbuff.shield = tbuff.shield + shieldnum
      have7102buff = true
    end
  end
  if not have7102buff then
    local bless7102bid = 60017000
    local bless7102binfo = ed.lookupDataTable("Buff", nil, bless7102bid)
    local bless7102buff = ed.BuffCreate(bless7102binfo, chosen, chosen)
    bless7102buff.shield = shieldnum
    chosen:addBuff(bless7102buff, chosen)
  end
end

function class.initBless(bless)
  local rogueRevelation = bless.rogueRevelation
  rogueRevelation.onFinish = override(rogueRevelation.onFinish, class.revelationonFinish)
  return bless
end

return class.initBless
