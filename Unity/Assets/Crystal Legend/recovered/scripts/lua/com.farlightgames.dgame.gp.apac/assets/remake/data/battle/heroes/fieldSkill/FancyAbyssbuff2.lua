module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff2 = {}

function FancyAbyssbuff2.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, FancyAbyssbuff2.update)
  buff.onDamaged = override(buff.onDamaged, FancyAbyssbuff2.Buff_onDamaged)
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff2.update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  local count = 0
  for i, tbuff in ipairs(owner.buff_list) do
    if tbuff.info.ID == 6155 and tbuff.timer > 1 or tbuff.info.ID == 6156 and tbuff.timer > 1 or tbuff.info.ID == 6157 and tbuff.timer > 1 then
      count = count + 1
    end
  end
  if count == 3 then
    owner:takeDamage(owner.attribs.HP * 0.15, "Holy", "hp", caster)
    local bid4 = 6158
    local binfo4 = ed.lookupDataTable("Buff", nil, bid4)
    local buff4 = owner:addBuff(binfo4, caster)
    for i, tbuff in ipairs(owner.buff_list) do
      if tbuff.info.ID == 6155 or tbuff.info.ID == 6156 or tbuff.info.ID == 6157 then
        tbuff.timer = 0.5
        if ed.run_with_scene then
          local effect_name = "eff_impact_TitanDR_atk3.cha"
          if effect_name then
            ed.scene:playEffectOnScene(effect_name, owner.position, nil, nil, 1)
          end
        end
      end
    end
  end
end

function FancyAbyssbuff2.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local caster = buff.caster
  local owner = buff.owner
  if damage_type == "Holy" then
    local bid1 = 6155
    local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
    local buff1 = owner:addBuff(binfo1, caster)
  end
  if damage_type == "AD" then
    local bid2 = 6156
    local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
    local buff2 = ed.BuffCreate(binfo2, owner, caster)
    buff2:setAttribute("HPR", -owner.attribs.HP * 0.0075)
    owner:addBuff(buff2, caster)
  end
  if damage_type == "AP" then
    local bid3 = 6157
    local binfo3 = ed.lookupDataTable("Buff", nil, bid3)
    local buff3 = owner:addBuff(binfo3, caster)
  end
  return dmg
end

function FancyAbyssbuff2.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff2.createBuff)
  return skill
end

return FancyAbyssbuff2.init_fieldSkill
