local class = newclass("g")
ed.rogueBless4201 = class

function class.initBless(bless)
  local totalhp = 0
  for unit in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
    local hp = unit.attribs.HP
    totalhp = totalhp + hp
  end
  ed.engine.rogueSkillMgr.magicCaster.bless4201charge = totalhp * (bless.isReinforced and bless.info["Script Arg5"] or bless.info["Script Arg1"]) / 100
  ed.engine.rogueSkillMgr.magicCaster.bless4201chargechange = 0
  if ed.engine.rogueSkillMgr:getBless(4202) then
    local bless4202 = ed.engine.rogueSkillMgr.rogueBlessList[4202]
    ed.engine.rogueSkillMgr.magicCaster.bless4201chargechange = (bless4202.isReinforced and bless4202.info["Script Arg5"] or bless4202.info["Script Arg1"]) / 100 * ed.engine.rogueSkillMgr.magicCaster.bless4201charge
  end
  return bless
end

return class.initBless
