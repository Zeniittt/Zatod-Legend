local ed = ed

local function monsterAddSkill(casterId, slot, level)
  return function(engine)
    for monster in engine:foreachAliveUnit(ed.emCampEnemy) do
      monster:addSkill(casterId, slot, level)
    end
  end
end

ed.monsterAddSkill = monsterAddSkill

local function playerAddBuff(bid)
  return function(engine)
    local info = ed.getDataTable("Buff")[bid]
    for player in engine:foreachAliveUnit(ed.emCampPlayer) do
      player:addBuff(info, player)
    end
  end
end

ed.playerAddBuff = playerAddBuff

local function earthAndWorldCrusherAddBuff(bid)
  return function(engine)
    if not engine:withBattleHero(10001) then
      return
    end
    local info = ed.getDataTable("Buff")[bid]
    local stars = 0
    for player in engine:foreachAliveUnit(ed.emCampPlayer) do
      if player.name ~= "Earth" then
        player:addBuff(info, player)
      else
        stars = player.stars
      end
    end
    for player in engine:foreachAliveUnit(ed.emCampEnemy) do
      if player.name == "WorldCrusher" and ed.isElementInTable(stars, {
        2,
        3,
        4,
        5
      }) then
        local id = 443 + stars
        player:addBuff(ed.getDataTable("Buff")[id], player)
      end
    end
  end
end

ed.earthAndWorldCrusherAddBuff = earthAndWorldCrusherAddBuff

local function monsterAddBuff(bid)
  return function(engine)
    local info = ed.getDataTable("Buff")[bid]
    for monster in engine:foreachAliveUnit(ed.emCampEnemy) do
      monster:addBuff(info, monster)
    end
  end
end

ed.monsterAddBuff = monsterAddBuff

local function monsterBossAddSkill(casterId, slot, level)
  return function(engine)
    local monsterBoss = engine:findBoss()
    if monsterBoss then
      monsterBoss:addSkill(casterId, slot, level)
    end
  end
end

ed.monsterBossAddSkill = monsterBossAddSkill

local function monsterBossAddBuff(bid)
  return function(engine)
    local monsterBoss = engine:findBoss()
    if monsterBoss then
      local info = ed.getDataTable("Buff")[bid]
      monsterBoss:addBuff(info, monsterBoss)
    end
  end
end

ed.monsterBossAddBuff = monsterBossAddBuff

local function monsterAddBufftable(bid_list)
  return function(engine)
    for i, bid in ipairs(bid_list) do
      local info = ed.getDataTable("Buff")[bid]
      for monster in engine:foreachAliveUnit(ed.emCampEnemy) do
        monster:addBuff(info, monster)
      end
    end
  end
end

ed.monsterAddBufftable = monsterAddBufftable

local function playerAddBufftable(bid_list)
  return function(engine)
    for i, bid in ipairs(bid_list) do
      local info = ed.getDataTable("Buff")[bid]
      for player in engine:foreachAliveUnit(ed.emCampPlayer) do
        player:addBuff(info, player)
      end
    end
  end
end

ed.playerAddBufftable = playerAddBufftable

local function ChaosAddCampBufftable(left_bid_list, right_bid_list)
  return function(engine)
    local bid_list_by_camp = {
      [1] = left_bid_list,
      [-1] = right_bid_list
    }
    for camp, bid_list in pairs(bid_list_by_camp) do
      for i, bid in ipairs(bid_list) do
        local info = ed.getDataTable("Buff")[bid]
        for unit in engine:foreachAliveUnit(camp) do
          local buff = ed.BuffCreate(info, unit, unit)
          buff:setPercentAttribs()
          unit:addBuff(buff, unit)
        end
      end
    end
  end
end

ed.ChaosAddCampBufftable = ChaosAddCampBufftable

local function checkHeroGender(gender)
  return function(engine)
    for hero in engine:foreachAliveUnit(ed.emCampPlayer) do
      if hero.info.Gender ~= gender then
        if ed.run_with_scene then
          EDDebug("Hero gender not allowed!")
        else
          engine:exitStage(0)
        end
      end
    end
  end
end

local function monsterResetPosAndBuff(name, posX, posY)
  return function(engine)
    for monster in engine:foreachAliveUnit(ed.emCampEnemy) do
      local binfo = ed.lookupDataTable("Buff", nil, 96)
      monster:addBuff(binfo, monster)
      if monster.tid == name then
        monster.position = {
          ed.engine.stage_rect.maxX - posX,
          posY
        }
        local binfo = ed.lookupDataTable("Buff", nil, 94)
        monster:addBuff(binfo, monster)
      end
    end
  end
end

ed.monsterResetPosAndBuff = monsterResetPosAndBuff
local scripts = {
  [1] = {
    [2] = function(engine)
      local dr = engine:findHero("DR")
      if dr then
        dr:setMP(dr.mp + 150)
      end
    end,
    [3] = function(engine)
      engine:findBoss().ai.will_cast_manual_skill = false
    end
  },
  [2] = {
    [2] = function(engine)
      local dr = engine:findHero("DR")
      if dr then
        dr:setMP(dr.mp + 150)
      end
    end
  },
  [3] = {
    [2] = function(engine)
      local dr = engine:findHero("DR")
      if dr then
        dr:setMP(dr.mp + 150)
      end
    end
  },
  [6] = {
    [3] = function(engine)
      engine:findBoss().mp = 800
    end
  },
  [7] = {
    [3] = function(engine)
      engine:findBoss().mp = 950
    end
  },
  [23] = {
    [3] = function(engine)
      engine:findBoss().mp = 800
    end
  },
  [20003] = {
    [1] = monsterAddBuff(57),
    [2] = monsterAddBuff(57),
    [3] = monsterAddBuff(57)
  },
  [21003] = {
    [1] = monsterAddBuff(57),
    [2] = monsterAddBuff(57),
    [3] = monsterAddBuff(57)
  },
  [22003] = {
    [1] = monsterAddBuff(57),
    [2] = monsterAddBuff(57),
    [3] = monsterAddBuff(57)
  },
  [23003] = {
    [1] = monsterAddBuff(57),
    [2] = monsterAddBuff(57),
    [3] = monsterAddBuff(57)
  },
  [24003] = {
    [1] = monsterAddBuff(57),
    [2] = monsterAddBuff(57),
    [3] = monsterAddBuff(57)
  },
  [25003] = {
    [1] = monsterAddBuff(57),
    [2] = monsterAddBuff(57),
    [3] = monsterAddBuff(57)
  },
  [26003] = {
    [1] = monsterAddBuff(57),
    [2] = monsterAddBuff(57),
    [3] = monsterAddBuff(57)
  },
  [27003] = {
    [1] = monsterAddBuff(57),
    [2] = monsterAddBuff(57),
    [3] = monsterAddBuff(57)
  },
  [28003] = {
    [1] = monsterAddBuff(57),
    [2] = monsterAddBuff(57),
    [3] = monsterAddBuff(57)
  },
  [29003] = {
    [1] = monsterAddBuff(57),
    [2] = monsterAddBuff(57),
    [3] = monsterAddBuff(57)
  },
  [29103] = {
    [1] = monsterAddBuff(57),
    [2] = monsterAddBuff(57),
    [3] = monsterAddBuff(57)
  },
  [29203] = {
    [1] = monsterAddBuff(57),
    [2] = monsterAddBuff(57),
    [3] = monsterAddBuff(57)
  },
  [29303] = {
    [1] = monsterAddBuff(57),
    [2] = monsterAddBuff(57),
    [3] = monsterAddBuff(57)
  },
  [29403] = {
    [1] = monsterAddBuff(57),
    [2] = monsterAddBuff(57),
    [3] = monsterAddBuff(57)
  },
  [29503] = {
    [1] = monsterAddBuff(57),
    [2] = monsterAddBuff(57),
    [3] = monsterAddBuff(57)
  },
  [29603] = {
    [1] = monsterAddBuff(57),
    [2] = monsterAddBuff(57),
    [3] = monsterAddBuff(57)
  },
  [29703] = {
    [1] = monsterAddBuff(57),
    [2] = monsterAddBuff(57),
    [3] = monsterAddBuff(57)
  },
  [29803] = {
    [1] = monsterAddBuff(57),
    [2] = monsterAddBuff(57),
    [3] = monsterAddBuff(57)
  },
  [20004] = {
    [1] = monsterAddBuff(58),
    [2] = monsterAddBuff(58),
    [3] = monsterAddBuff(58)
  },
  [21004] = {
    [1] = monsterAddBuff(58),
    [2] = monsterAddBuff(58),
    [3] = monsterAddBuff(58)
  },
  [22004] = {
    [1] = monsterAddBuff(58),
    [2] = monsterAddBuff(58),
    [3] = monsterAddBuff(58)
  },
  [23004] = {
    [1] = monsterAddBuff(58),
    [2] = monsterAddBuff(58),
    [3] = monsterAddBuff(58)
  },
  [24004] = {
    [1] = monsterAddBuff(58),
    [2] = monsterAddBuff(58),
    [3] = monsterAddBuff(58)
  },
  [25004] = {
    [1] = monsterAddBuff(58),
    [2] = monsterAddBuff(58),
    [3] = monsterAddBuff(58)
  },
  [26004] = {
    [1] = monsterAddBuff(58),
    [2] = monsterAddBuff(58),
    [3] = monsterAddBuff(58)
  },
  [27004] = {
    [1] = monsterAddBuff(58),
    [2] = monsterAddBuff(58),
    [3] = monsterAddBuff(58)
  },
  [28004] = {
    [1] = monsterAddBuff(58),
    [2] = monsterAddBuff(58),
    [3] = monsterAddBuff(58)
  },
  [29004] = {
    [1] = monsterAddBuff(58),
    [2] = monsterAddBuff(58),
    [3] = monsterAddBuff(58)
  },
  [29104] = {
    [1] = monsterAddBuff(58),
    [2] = monsterAddBuff(58),
    [3] = monsterAddBuff(58)
  },
  [29204] = {
    [1] = monsterAddBuff(58),
    [2] = monsterAddBuff(58),
    [3] = monsterAddBuff(58)
  },
  [29304] = {
    [1] = monsterAddBuff(58),
    [2] = monsterAddBuff(58),
    [3] = monsterAddBuff(58)
  },
  [29404] = {
    [1] = monsterAddBuff(58),
    [2] = monsterAddBuff(58),
    [3] = monsterAddBuff(58)
  },
  [29504] = {
    [1] = monsterAddBuff(58),
    [2] = monsterAddBuff(58),
    [3] = monsterAddBuff(58)
  },
  [29604] = {
    [1] = monsterAddBuff(58),
    [2] = monsterAddBuff(58),
    [3] = monsterAddBuff(58)
  },
  [29704] = {
    [1] = monsterAddBuff(58),
    [2] = monsterAddBuff(58),
    [3] = monsterAddBuff(58)
  },
  [29804] = {
    [1] = monsterAddBuff(58),
    [2] = monsterAddBuff(58),
    [3] = monsterAddBuff(58)
  },
  [12001] = {
    [1] = monsterAddBufftable({307}),
    [2] = monsterAddBufftable({307}),
    [3] = monsterAddBufftable({307})
  },
  [11002] = {
    [1] = monsterAddBufftable({307}),
    [2] = monsterAddBufftable({307}),
    [3] = monsterAddBufftable({307, 308})
  },
  [13005] = {
    [1] = monsterAddBufftable({307}),
    [2] = monsterAddBufftable({307, 308}),
    [3] = monsterAddBufftable({307, 308})
  },
  [12006] = {
    [1] = monsterAddBufftable({307, 308}),
    [2] = monsterAddBufftable({307, 308}),
    [3] = monsterAddBufftable({307, 307})
  },
  [13001] = {
    [1] = monsterBossAddSkill(1001, 101, 90),
    [2] = monsterBossAddSkill(1001, 101, 90),
    [3] = monsterBossAddSkill(1001, 101, 90)
  },
  [12002] = {
    [1] = monsterBossAddSkill(1001, 101, 90),
    [2] = monsterBossAddSkill(1001, 101, 90),
    [3] = monsterBossAddSkill(1001, 101, 90)
  },
  [11003] = {
    [1] = monsterBossAddSkill(1001, 101, 90),
    [2] = monsterBossAddSkill(1001, 101, 90),
    [3] = monsterBossAddSkill(1001, 101, 90)
  },
  [13006] = {
    [1] = monsterBossAddSkill(1001, 101, 90),
    [2] = monsterBossAddSkill(1001, 101, 90),
    [3] = monsterBossAddSkill(1001, 101, 90)
  },
  [12007] = {
    [1] = monsterAddBufftable({307}),
    [2] = monsterAddBufftable({307}),
    [3] = monsterAddBufftable({307, 308})
  },
  [11010] = {
    [1] = monsterAddBufftable({307}),
    [2] = monsterAddBufftable({307, 308}),
    [3] = monsterAddBufftable({307, 308})
  },
  [13011] = {
    [1] = monsterAddBufftable({307, 308}),
    [2] = monsterAddBufftable({307, 308}),
    [3] = monsterAddBufftable({307, 307})
  },
  [11009] = {
    [1] = monsterBossAddSkill(1001, 101, 90),
    [2] = monsterBossAddSkill(1001, 101, 90),
    [3] = monsterBossAddSkill(1001, 101, 90)
  },
  [13010] = {
    [1] = monsterBossAddSkill(1001, 101, 90),
    [2] = monsterBossAddSkill(1001, 101, 90),
    [3] = monsterBossAddSkill(1001, 101, 90)
  },
  [12013] = {
    [1] = monsterBossAddSkill(1001, 101, 90),
    [2] = monsterBossAddSkill(1001, 101, 90),
    [3] = monsterBossAddSkill(1001, 101, 90)
  },
  [11008] = {
    [1] = playerAddBuff(807),
    [2] = playerAddBuff(807),
    [3] = playerAddBuff(807)
  },
  [13009] = {
    [1] = playerAddBuff(807),
    [2] = playerAddBuff(807),
    [3] = playerAddBuff(807)
  },
  [12012] = {
    [1] = playerAddBuff(808),
    [2] = playerAddBuff(808),
    [3] = playerAddBuff(808)
  },
  [13007] = {
    [1] = monsterAddBuff(810),
    [2] = monsterAddBuff(810),
    [3] = monsterAddBuff(810)
  },
  [12010] = {
    [1] = monsterAddBuff(810),
    [2] = monsterAddBuff(810),
    [3] = monsterAddBuff(810)
  },
  [11013] = {
    [1] = monsterAddBuff(810),
    [2] = monsterAddBuff(810),
    [3] = monsterAddBuff(810)
  },
  [12014] = {
    [1] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(57)(parameter)
    end,
    [2] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(57)(parameter)
    end,
    [3] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(57)(parameter)
    end
  },
  [11015] = {
    [1] = monsterAddBufftable({307, 57}),
    [2] = monsterAddBufftable({307, 57}),
    [3] = monsterAddBufftable({
      307,
      308,
      57
    })
  },
  [11016] = {
    [1] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(57)(parameter)
    end,
    [2] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(57)(parameter)
    end,
    [3] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(57)(parameter)
    end
  },
  [12016] = {
    [1] = monsterAddBufftable({810, 58}),
    [2] = monsterAddBufftable({810, 58}),
    [3] = monsterAddBufftable({810, 58})
  },
  [13016] = {
    [1] = monsterAddBufftable({307, 58}),
    [2] = monsterAddBufftable({
      307,
      308,
      58
    }),
    [3] = monsterAddBufftable({
      307,
      308,
      58
    })
  },
  [11017] = {
    [1] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(58)(parameter)
    end,
    [2] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(58)(parameter)
    end,
    [3] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(58)(parameter)
    end
  },
  [13017] = {
    [1] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(58)(parameter)
    end,
    [2] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(58)(parameter)
    end,
    [3] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(58)(parameter)
    end
  },
  [13018] = {
    [1] = playerAddBuff(807),
    [2] = playerAddBuff(807),
    [3] = playerAddBuff(807)
  },
  [11019] = {
    [1] = monsterAddBufftable({810, 57}),
    [2] = monsterAddBufftable({810, 57}),
    [3] = monsterAddBufftable({810, 57})
  },
  [12019] = {
    [1] = monsterAddBufftable({307, 308}),
    [2] = monsterAddBufftable({307, 308}),
    [3] = monsterAddBufftable({307, 307})
  },
  [13019] = {
    [1] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(427)(parameter)
      monsterBossAddBuff(426)(parameter)
    end,
    [2] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(427)(parameter)
      monsterBossAddBuff(426)(parameter)
    end,
    [3] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(427)(parameter)
      monsterBossAddBuff(426)(parameter)
    end
  },
  [20105] = {
    [1] = earthAndWorldCrusherAddBuff(436)
  },
  [12020] = {
    [1] = monsterAddBufftable({307}),
    [2] = monsterAddBufftable({307}),
    [3] = monsterAddBufftable({307, 308})
  },
  [11023] = {
    [1] = monsterAddBufftable({307}),
    [2] = monsterAddBufftable({307, 308}),
    [3] = monsterAddBufftable({307, 308})
  },
  [13024] = {
    [1] = monsterAddBufftable({307, 308}),
    [2] = monsterAddBufftable({307, 308}),
    [3] = monsterAddBufftable({307, 307})
  },
  [11022] = {
    [1] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(57)(parameter)
    end,
    [2] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(57)(parameter)
    end,
    [3] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(57)(parameter)
    end
  },
  [13023] = {
    [1] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(58)(parameter)
    end,
    [2] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(58)(parameter)
    end,
    [3] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(58)(parameter)
    end
  },
  [12026] = {
    [1] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(58)(parameter)
    end,
    [2] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(58)(parameter)
    end,
    [3] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(58)(parameter)
    end
  },
  [11021] = {
    [1] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(57)(parameter)
    end,
    [2] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(57)(parameter)
    end,
    [3] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(57)(parameter)
    end
  },
  [13022] = {
    [1] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(58)(parameter)
    end,
    [2] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(58)(parameter)
    end,
    [3] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(58)(parameter)
    end
  },
  [12025] = {
    [1] = playerAddBuff(808),
    [2] = playerAddBuff(808),
    [3] = playerAddBuff(808)
  },
  [13020] = {
    [1] = monsterAddBuff(810),
    [2] = monsterAddBuff(810),
    [3] = monsterAddBuff(810)
  },
  [12023] = {
    [1] = monsterAddBuff(810),
    [2] = monsterAddBuff(810),
    [3] = monsterAddBuff(810)
  },
  [11026] = {
    [1] = monsterAddBuff(810),
    [2] = monsterAddBuff(810),
    [3] = monsterAddBuff(810)
  },
  [13031] = {
    [1] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(57)(parameter)
    end,
    [2] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(57)(parameter)
    end,
    [3] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(57)(parameter)
    end
  },
  [11030] = {
    [1] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(58)(parameter)
    end,
    [2] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(58)(parameter)
    end,
    [3] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(58)(parameter)
    end
  },
  [12027] = {
    [1] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(58)(parameter)
    end,
    [2] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(58)(parameter)
    end,
    [3] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(58)(parameter)
    end
  },
  [13032] = {
    [1] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(57)(parameter)
    end,
    [2] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(57)(parameter)
    end,
    [3] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(57)(parameter)
    end
  },
  [11031] = {
    [1] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(58)(parameter)
    end,
    [2] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(58)(parameter)
    end,
    [3] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(58)(parameter)
    end
  },
  [12028] = {
    [1] = playerAddBuff(808),
    [2] = playerAddBuff(808),
    [3] = playerAddBuff(808)
  },
  [13027] = {
    [1] = monsterAddBuff(810),
    [2] = monsterAddBuff(810),
    [3] = monsterAddBuff(810)
  },
  [12030] = {
    [1] = monsterAddBuff(810),
    [2] = monsterAddBuff(810),
    [3] = monsterAddBuff(810)
  },
  [11033] = {
    [1] = monsterAddBuff(810),
    [2] = monsterAddBuff(810),
    [3] = monsterAddBuff(810)
  },
  [13034] = {
    [1] = monsterAddBuff(810),
    [2] = monsterAddBuff(810),
    [3] = monsterAddBuff(810)
  },
  [12037] = {
    [1] = monsterAddBuff(810),
    [2] = monsterAddBuff(810),
    [3] = monsterAddBuff(810)
  },
  [11041] = {
    [1] = monsterAddBuff(810),
    [2] = monsterAddBuff(810),
    [3] = monsterAddBuff(810)
  },
  [12034] = {
    [1] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(58)(parameter)
    end,
    [2] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(58)(parameter)
    end,
    [3] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(58)(parameter)
    end
  },
  [11037] = {
    [1] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(57)(parameter)
    end,
    [2] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(57)(parameter)
    end,
    [3] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(57)(parameter)
    end
  },
  [13038] = {
    [1] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(57)(parameter)
    end,
    [2] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(57)(parameter)
    end,
    [3] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(57)(parameter)
    end
  },
  [12035] = {
    [1] = playerAddBuff(808),
    [2] = playerAddBuff(808),
    [3] = playerAddBuff(808)
  },
  [13039] = {
    [1] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(57)(parameter)
    end,
    [2] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(57)(parameter)
    end,
    [3] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(57)(parameter)
    end
  },
  [11038] = {
    [1] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(58)(parameter)
    end,
    [2] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(58)(parameter)
    end,
    [3] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(58)(parameter)
    end
  },
  [12040] = {
    [1] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(57)(parameter)
    end,
    [2] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(57)(parameter)
    end,
    [3] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(57)(parameter)
    end
  },
  [11036] = {
    [1] = monsterAddBufftable({307}),
    [2] = monsterAddBufftable({307}),
    [3] = monsterAddBufftable({307, 308})
  },
  [13037] = {
    [1] = monsterAddBufftable({307}),
    [2] = monsterAddBufftable({307, 308}),
    [3] = monsterAddBufftable({307, 308})
  },
  [13040] = {
    [1] = monsterAddBufftable({307, 308}),
    [2] = monsterAddBufftable({307, 308}),
    [3] = monsterAddBufftable({307, 307})
  },
  [12041] = {
    [1] = monsterAddBufftable({307, 308}),
    [2] = monsterAddBufftable({307, 308}),
    [3] = monsterAddBufftable({307, 307})
  },
  [13042] = {
    [1] = monsterAddBuff(810),
    [2] = monsterAddBuff(810),
    [3] = monsterAddBuff(810)
  },
  [12045] = {
    [1] = monsterAddBuff(810),
    [2] = monsterAddBuff(810),
    [3] = monsterAddBuff(810)
  },
  [12042] = {
    [1] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(58)(parameter)
    end,
    [2] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(58)(parameter)
    end,
    [3] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(58)(parameter)
    end
  },
  [11045] = {
    [1] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(57)(parameter)
    end,
    [2] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(57)(parameter)
    end,
    [3] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(57)(parameter)
    end
  },
  [13046] = {
    [1] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(57)(parameter)
    end,
    [2] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(57)(parameter)
    end,
    [3] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(57)(parameter)
    end
  },
  [12043] = {
    [1] = playerAddBuff(808),
    [2] = playerAddBuff(808),
    [3] = playerAddBuff(808)
  },
  [13047] = {
    [1] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(57)(parameter)
    end,
    [2] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(57)(parameter)
    end,
    [3] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(57)(parameter)
    end
  },
  [11046] = {
    [1] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(58)(parameter)
    end,
    [2] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(58)(parameter)
    end,
    [3] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(58)(parameter)
    end
  },
  [12048] = {
    [1] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(57)(parameter)
    end,
    [2] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(57)(parameter)
    end,
    [3] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(57)(parameter)
    end
  },
  [11044] = {
    [1] = monsterAddBufftable({307}),
    [2] = monsterAddBufftable({307}),
    [3] = monsterAddBufftable({307, 308})
  },
  [13045] = {
    [1] = monsterAddBufftable({307}),
    [2] = monsterAddBufftable({307, 308}),
    [3] = monsterAddBufftable({307, 308})
  },
  [13048] = {
    [1] = monsterAddBufftable({307, 308}),
    [2] = monsterAddBufftable({307, 308}),
    [3] = monsterAddBufftable({307, 307})
  },
  [13049] = {
    [1] = monsterAddBuff(810),
    [2] = monsterAddBuff(810),
    [3] = monsterAddBuff(810)
  },
  [12052] = {
    [1] = monsterAddBuff(810),
    [2] = monsterAddBuff(810),
    [3] = monsterAddBuff(810)
  },
  [12049] = {
    [1] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(58)(parameter)
    end,
    [2] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(58)(parameter)
    end,
    [3] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(58)(parameter)
    end
  },
  [11052] = {
    [1] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(57)(parameter)
    end,
    [2] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(57)(parameter)
    end,
    [3] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(57)(parameter)
    end
  },
  [13053] = {
    [1] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(57)(parameter)
    end,
    [2] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(57)(parameter)
    end,
    [3] = function(parameter)
      monsterBossAddSkill(1001, 101, 90)(parameter)
      monsterBossAddBuff(57)(parameter)
    end
  },
  [12050] = {
    [1] = playerAddBuff(808),
    [2] = playerAddBuff(808),
    [3] = playerAddBuff(808)
  },
  [13054] = {
    [1] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(57)(parameter)
    end,
    [2] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(57)(parameter)
    end,
    [3] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(57)(parameter)
    end
  },
  [11053] = {
    [1] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(58)(parameter)
    end,
    [2] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(58)(parameter)
    end,
    [3] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(58)(parameter)
    end
  },
  [12055] = {
    [1] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(57)(parameter)
    end,
    [2] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(57)(parameter)
    end,
    [3] = function(parameter)
      playerAddBuff(808)(parameter)
      monsterAddBuff(57)(parameter)
    end
  },
  [11051] = {
    [1] = monsterAddBufftable({307}),
    [2] = monsterAddBufftable({307}),
    [3] = monsterAddBufftable({307, 308})
  },
  [13052] = {
    [1] = monsterAddBufftable({307}),
    [2] = monsterAddBufftable({307, 308}),
    [3] = monsterAddBufftable({307, 308})
  },
  [13055] = {
    [1] = monsterAddBufftable({307, 308}),
    [2] = monsterAddBufftable({307, 308}),
    [3] = monsterAddBufftable({307, 307})
  },
  [40021] = {
    [3] = monsterResetPosAndBuff(135, 95, -70)
  },
  [40049] = {
    [3] = monsterResetPosAndBuff(141, 169, -50)
  },
  [40055] = {
    [3] = monsterResetPosAndBuff(142, 70, -40)
  },
  [20007] = {
    [1] = monsterResetPosAndBuff(148, 70, -40)
  },
  [21007] = {
    [1] = monsterResetPosAndBuff(148, 70, -40)
  },
  [22007] = {
    [1] = monsterResetPosAndBuff(148, 70, -40)
  },
  [23007] = {
    [1] = monsterResetPosAndBuff(148, 70, -40)
  },
  [24007] = {
    [1] = monsterResetPosAndBuff(148, 70, -40)
  },
  [25007] = {
    [1] = monsterResetPosAndBuff(148, 70, -40)
  },
  [26007] = {
    [1] = monsterResetPosAndBuff(148, 70, -40)
  },
  [27007] = {
    [1] = monsterResetPosAndBuff(148, 70, -40)
  },
  [28007] = {
    [1] = monsterResetPosAndBuff(148, 70, -40)
  },
  [20103] = {
    [1] = function(engine)
      engine:findBoss().position = {750, 0}
    end
  }
}
ed.stageScripts = scripts
for stageid = 40056, 40068 do
  if stageid ~= 40062 and stageid ~= 40068 then
    if scripts[stageid] == nil then
      scripts[stageid] = {}
    end
    scripts[stageid][1] = monsterAddBuff(191)
    scripts[stageid][2] = monsterAddBuff(191)
    scripts[stageid][3] = monsterAddBuff(191)
  end
end

local function addBuffForGuildStage(bid)
  if ed.engine.guildInstance_mode then
    local script = monsterAddBuff(bid)
    if script then
      script(ed.engine)
    end
  end
end

ed.addBuffForGuildStage = addBuffForGuildStage

local function addChallengeState(stageId, waveId)
  local type = ed.getChallengeType(stageId)
  if type == "TimeKill" then
    ed.engine.timeLimitMode = true
    ed.engine:setTimeLimit(ed.getChallengeParam(stageId, waveId))
  end
end

ed.addChallengeState = addChallengeState

local function getSpringMode()
  local stage_type = ed.engine.stage_type
  if stage_type == "spring" then
    return true
  end
  return false
end

ed.getSpringMode = getSpringMode

local function addBuffForSpriteStage(bid)
  if getSpringMode() then
    local script = monsterBossAddBuff(bid)
    if script then
      script(ed.engine)
    end
  end
end

ed.addBuffForSpriteStage = addBuffForSpriteStage

local function addBuffForGuildStageBoss(bid)
  if ed.engine.guildInstance_mode then
    local script = monsterBossAddBuff(bid)
    if script then
      script(ed.engine)
    end
  end
end

ed.addBuffForGuildStageBoss = addBuffForGuildStageBoss

local function addBuffForDreamland(bid)
  if ed.engine.stage_type == "dreamland" then
    local script = monsterBossAddBuff(bid)
    if script then
      script(ed.engine)
    end
  end
end

ed.addBuffForDreamland = addBuffForDreamland

local function addBuffForMonsterseal(bid)
  if ed.engine.stage_type == "monsterseal" then
    local script = monsterBossAddBuff(bid)
    if script then
      script(ed.engine)
    end
  end
end

ed.addBuffForMonsterseal = addBuffForMonsterseal

local function addBuffForBookBoss(bid)
  if ed.engine.stage_type == "bookBoss" then
    local script = monsterBossAddBuff(bid)
    if script then
      script(ed.engine)
    end
  end
end

ed.addBuffForBookBoss = addBuffForBookBoss

local function getStageScript(stageid, waveid)
  addBuffForGuildStage(96)
  addBuffForDreamland(234)
  addBuffForDreamland(176)
  addBuffForMonsterseal(234)
  addBuffForMonsterseal(176)
  addBuffForBookBoss(234)
  addChallengeState(stageid, waveid)
  if scripts[stageid] then
    return scripts[stageid][waveid]
  end
end

ed.getStageScript = getStageScript
