local class = newclass("g")
ed.rogueBless4102 = class

function class.revelationonFinish(basefunc, self)
  basefunc(self)
  for unit in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
    local buffInfo = ed.getDataTable("Buff")[60004102]
    local buff = ed.BuffCreate(buffInfo, unit, unit)
    local bless = ed.engine.rogueSkillMgr.rogueBlessList[4102]
    buff.timer = bless.info["Script Arg1"]
    buff:setAttribute("HPR", bless.info["Script Arg2"])
    unit:addBuff(buff, unit)
  end
end

function class.initBless(bless)
  local rogueRevelation = bless.rogueRevelation
  rogueRevelation.onFinish = override(rogueRevelation.onFinish, class.revelationonFinish)
  return bless
end

return class.initBless
