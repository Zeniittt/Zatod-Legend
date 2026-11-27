local class = newclass("g")
ed.rogueBless4103 = class

function class.revelationstart(basefunc, self)
  basefunc(self)
  for unit in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
    local list = unit.buff_list
    local debuff_list = {}
    local my_camp = unit.camp
    for i = 1, #list do
      local buff = list[i]
      if buff and (not buff.caster or buff.caster.camp ~= my_camp) and buff.info.Dispel == "YES" then
        debuff_list[#debuff_list + 1] = buff
      end
    end
    for i = 1, #debuff_list do
      unit:removeBuff(debuff_list[i])
    end
  end
end

function class.initBless(bless)
  local rogueRevelation = bless.rogueRevelation
  rogueRevelation.start = override(rogueRevelation.start, class.revelationstart)
  return bless
end

return class.initBless
