local class = newclass("g")
ed.rogueBless1103 = class

function class.revelationonFinish(basefunc, self)
  basefunc(self)
  for unit in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
    local buffInfo = ed.getDataTable("Buff")[60001103]
    local buff = ed.BuffCreate(buffInfo, unit, unit)
    local bless = ed.engine.rogueSkillMgr.rogueBlessList[1103]
    buff.timer = bless.info["Script Arg2"]
    buff:setAttribute("AD", bless.info["Script Arg1"] / 100 * unit.attribs.AD)
    unit:addBuff(buff, unit)
  end
end

function class.initBless(bless)
  local rogueRevelation = bless.rogueRevelation
  rogueRevelation.onFinish = override(rogueRevelation.onFinish, class.revelationonFinish)
  return bless
end

return class.initBless
