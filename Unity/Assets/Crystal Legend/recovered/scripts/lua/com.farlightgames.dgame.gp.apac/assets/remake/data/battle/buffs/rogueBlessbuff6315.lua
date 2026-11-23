local function rogueBless6315update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + 1
    if ed.engine.rogueSkillMgr:getBless(6315) then
      owner.rogueBless6315behprdmg = false
      local bless6315 = ed.engine.rogueSkillMgr.rogueBlessList[6315]
      local hprlimit = bless6315.isReinforced and bless6315.info["Script Arg5"] or bless6315.info["Script Arg1"]
      if owner.attribs.HPR and 0 > owner.attribs.HPR and hprlimit > owner.attribs.HPR then
        owner.rogueBless6315behprdmg = true
      end
      if owner.rogueBless6315behprdmg then
        local hprbufftime = 0
        local hprdmgbuff = 0
        local v = math.huge
        for i, tbuff in ipairs(owner.buff_list) do
          if tbuff.info.HPR and 0 > tbuff.info.HPR then
            local buff = tbuff
            hprbufftime = hprbufftime + buff.timer
            hprdmgbuff = hprdmgbuff + 1
            local info = buff.info
            local hpr = info.HPR
            if hpr then
              local x = info["HPR" .. ".x"]
              if x then
                local a = info["HPR" .. ".a"]
                hpr = hpr + (buff.caster.attribs[x] or 0) * a
              end
              local totalhpr = hpr * buff.timer
              if v > totalhpr and buff.info.Dispel == "YES" then
                v = totalhpr
                owner.bless6315maxdmghprbuff = buff
              end
            end
          end
        end
        local averagetime = 0
        if 0 < hprdmgbuff then
          averagetime = math.min(hprbufftime / hprdmgbuff, 10)
        end
        local magiccaster = ed.engine.rogueSkillMgr.magicCaster
        if owner.bless6315maxdmghprbuff then
          owner:takeDamage(-owner.attribs.HPR * averagetime, "AP", "hp", magiccaster, 1, 1, true)
          owner.bless6315maxdmghprbuff.timer = -1
          owner.bless6315maxdmghprbuff = nil
          if ed.run_with_scene then
            local effect_name = "eff_point_rogue6315.cha"
            ed.scene:playEffectOnScene(effect_name, owner.position, {
              owner.direction,
              1
            }, nil, 1)
          end
        end
      end
    end
  end
  buff.attack_timer = timer
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.attack_timer = 1
  owner.bless6315maxdmghprbuff = nil
  buff.update = override(buff.update, rogueBless6315update)
  return buff
end

return initBuff
