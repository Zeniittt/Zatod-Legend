local class = newclass("g")
ed.rogueBless7103 = class

function class.revelationstart(basefunc, self)
  basefunc(self)
  for unit in ed.engine:foreachAliveUnit(ed.emCampEnemy) do
    local list = unit.buff_list
    local shieldbuff_list = {}
    for i = 1, #list do
      local buff = list[i]
      if buff and (not buff.caster or buff.caster.camp ~= 1) and buff.shield and buff.shield > 0 then
        shieldbuff_list[#shieldbuff_list + 1] = buff
      end
    end
    for i = 1, #shieldbuff_list do
      unit:removeBuff(shieldbuff_list[i])
    end
  end
end

function class.initBless(bless)
  local rogueRevelation = bless.rogueRevelation
  rogueRevelation.start = override(rogueRevelation.start, class.revelationstart)
  return bless
end

return class.initBless
