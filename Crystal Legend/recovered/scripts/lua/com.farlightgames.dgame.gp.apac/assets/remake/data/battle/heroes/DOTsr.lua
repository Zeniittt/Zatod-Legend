module("ed.battlehero", package.seeall)
local ed = ed
DOTsr = {}

function DOTsr.buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local time = buff.timer
  if buff.owner.actor then
    if 2.3 < time then
      buff.owner.actor.zSpeed = 280
    else
      buff.owner.actor.zSpeed = 80 * math.sin(math.rad(time * 360)) + 100
    end
  end
end

function DOTsr.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, DOTsr.buff_update)
  return buff
end

function DOTsr.init_hero(hero)
  local skillatk2 = hero.skills.DOTsr_atk2
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, DOTsr.skillatk2_createBuff)
  end
  return hero
end

return DOTsr.init_hero
