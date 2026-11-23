module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossTHD = {}
AwakeBossTHD.ult2 = 12005703

function AwakeBossTHD.buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  if ed.engine.freeze_level > 0 then
    buff.timer = buff.timer + dt
  end
  if buff.timer == 0 and not ed.engine.beingEnd then
    local bid = AwakeBossTHD.ult2
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff2 = ed.BuffCreate(binfo, owner, caster)
    buff2.update = override(buff2.update, AwakeBossTHD.buff2_update)
    local buffInfo2 = buff2.info
    local attribName = buffInfo2.Tenacity
    local TEN_final = 0
    if owner.camp ~= caster.camp and attribName and owner.attribs[attribName] then
      local CON = caster.attribs.CON
      TEN_final = owner.attribs[attribName] - CON
    end
    local skill = caster.skills.AwakeBossTHD_ult
    if skill.evo_rank and skill.evo_rank >= 1 then
      buff2.timer = skill.evo_rank1["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
    end
    if skill.evo_rank and skill.evo_rank >= 2 then
      buff2.timer = skill.evo_rank2["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
    end
    if skill.evo_rank and skill.evo_rank >= 3 then
      buff2.timer = skill.evo_rank3["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
    end
    owner:addBuff(buff2, caster)
  end
end

function AwakeBossTHD.buff2_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner:isHasUncontrolBufEffect() then
    buff.timer = -1
  end
end

function AwakeBossTHD.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = buff.owner
  buff.update = override(buff.update, AwakeBossTHD.buff_update)
  return buff
end

function AwakeBossTHD.init_hero(hero)
  local skillult = hero.skills.AwakeBossTHD_ult
  local skillatk2 = hero.skills.AwakeBossTHD_atk2
  local skillatk3 = hero.skills.AwakeBossTHD_atk3
  local skillatk4 = hero.skills.AwakeBossTHD_atk4
  if skillult then
    skillult.createBuff = override(skillult.createBuff, AwakeBossTHD.skillult_createBuff)
  end
  if skillatk2 then
    if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillatk3 then
    if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Damage Type"] = "Holy"
      })
    end
  end
  if skillatk4 then
    if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Plus Ratio"] = skillatk4.evo_rank1["Script Arg1"]
      })
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Plus Ratio"] = skillatk4.evo_rank2["Script Arg1"]
      })
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 3 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Plus Ratio"] = skillatk4.evo_rank3["Script Arg1"]
      })
    end
  end
  return hero
end

return AwakeBossTHD.init_hero
