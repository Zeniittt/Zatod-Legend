local class = newclass("g")
ed.rogueBless7306 = class

function class.initBless(bless)
  local amount = ed.engine.rogueSkillMgr:getBlessAmount(7)
  for chosen in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
    local ShieldIncrease = 0
    local ShieldWeak = 0
    if chosen.attribs.ShieldIncrease then
      ShieldIncrease = chosen.attribs.ShieldIncrease
    end
    if chosen.attribs.ShieldWeak then
      ShieldWeak = chosen.attribs.ShieldWeak
    end
    local shieldratio = math.max(0.01, 1 + (ShieldIncrease - ShieldWeak) / 100)
    local shieldnum = amount * (bless.isReinforced and bless.info["Script Arg5"] or bless.info["Script Arg1"]) * shieldratio
    local have7306buff = false
    for i, tbuff in ipairs(chosen.buff_list) do
      if tbuff.info.ID == 60017000 then
        tbuff.shield = tbuff.shield + shieldnum
        have7306buff = true
      end
    end
    if not have7306buff then
      local bless7306bid = 60017000
      local bless7306binfo = ed.lookupDataTable("Buff", nil, bless7306bid)
      local bless7306buff = ed.BuffCreate(bless7306binfo, chosen, chosen)
      bless7306buff.shield = shieldnum
      chosen:addBuff(bless7306buff, chosen)
    end
  end
  return bless
end

return class.initBless
