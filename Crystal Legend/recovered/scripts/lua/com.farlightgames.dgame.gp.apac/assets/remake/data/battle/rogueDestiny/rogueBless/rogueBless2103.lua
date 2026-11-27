local class = newclass("g")
ed.rogueBless2103 = class

function class.revelationonFinish(basefunc, self)
  basefunc(self)
  for unit in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
    local buffInfo = ed.getDataTable("Buff")[60002103]
    local buff = ed.BuffCreate(buffInfo, unit, unit)
    local bless2103 = ed.engine.rogueSkillMgr.rogueBlessList[2103]
    buff.timer = bless2103.info["Script Arg2"]
    buff:setAttribute("AP", bless2103.info["Script Arg1"] / 100 * unit.attribs.AP)
    unit:addBuff(buff, unit)
  end
end

function class.initBless(bless)
  local rogueRevelation = bless.rogueRevelation
  rogueRevelation.onFinish = override(rogueRevelation.onFinish, class.revelationonFinish)
  return bless
end

return class.initBless
