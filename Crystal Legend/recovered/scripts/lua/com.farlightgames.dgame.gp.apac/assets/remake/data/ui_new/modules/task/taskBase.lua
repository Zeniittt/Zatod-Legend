local basetask = {}
ed.basetask = basetask

function basetask:createFastButton(task, param)
  local type = task.type
  local pid = task.progressid
  local handler
  local labelString = (param or {}).labelString
  local showForce = (param or {}).showForce
  local isNocreateButton = (param or {}).isNocreateButton
  
  local function heroTaskNormalGoBattle()
    local ht = ed.player:withHeroTask(nil)
    local heroTaskTable = ed.getDataTable("HeroTask")
    if ht then
      local eid = heroTaskTable[task.chain][task.id]
      local ids = eid["Task Progress ID"]
      for k, v in pairs(ids) do
        if v ~= 0 then
          local id = v
          local st = ed.stageType(id)
          if ed.isElementInTable(st, {"normal", "elite"}) then
            local star = ed.player:getStageStar(id) or 0
            local preStar = ed.player:getStageStar(id - 1) or 0
            if 0 < star + preStar then
              local scene = ed.ui.stageselect.createByStage(id)
              ed.pushScene(scene)
              self.isPushingScene = true
            else
              ed.showToast(T("\229\133\179\229\141\161\229\176\154\230\156\170\229\188\128\229\144\175\227\128\130"))
            end
          end
        end
      end
    end
  end
  
  local function openPackage()
    self.isPushingScene = true
    ed.pushScene(ed.ui.package.create("package"))
  end
  
  local function enterTaskProcessStage()
    local pid = ed.getDataTable("Task")[task.chain][task.id]["Task Progress ID"]
    local stageid = pid[1]
    local type = ed.stageType(stageid)
    if type == "act" then
      ed.exerciseManager:openExerciseMainScene()
    elseif type == "normal" then
      local st = ed.getDataTable("Stage")
      local progress = ed.player:getStageProgress()
      local maxchapter = st[progress]["Chapter ID"]
      maxchapter = math.min(maxchapter, ed.playerlimit.maxChapter("normal"))
      local stageTable = ed.getDataTable("Stage")
      local row = stageTable[stageid]
      local stageChapter = row["Chapter ID"]
      if maxchapter >= stageChapter then
        ed.pushScene(ed.ui.stageselect.create(stageChapter, "normal"))
        self.isPushingScene = true
      else
        ed.showToast(T("\229\133\179\229\141\161\229\176\154\230\156\170\229\188\128\229\144\175\227\128\130"))
      end
    else
      local cpl = ed.playerlimit.getAreaUnlockPrompt("Elite")
      if cpl then
        ed.showToast(cpl)
        return
      end
      local maxchapter = ed.playerlimit.maxChapter("elite")
      local stageTable = ed.getDataTable("Stage")
      local row = stageTable[stageid]
      local stageChapter = row["Chapter ID"]
      if maxchapter > stageChapter then
        local star = ed.player:getStageStar(stageid) or 0
        local preStar = ed.player:getStageStar(stageid - 1) or 0
        if 0 < star + preStar or stageid == 10001 then
          ed.pushScene(ed.ui.stageselect.create(stageChapter, "elite"))
          self.isPushingScene = true
        else
          ed.showToast(T("\229\133\179\229\141\161\229\176\154\230\156\170\229\188\128\229\144\175\227\128\130"))
        end
      else
        ed.showToast(T("\229\133\179\229\141\161\229\176\154\230\156\170\229\188\128\229\144\175\227\128\130"))
      end
    end
  end
  
  local function enterCompleteStage()
    ed.exerciseManager:openExerciseMainScene()
  end
  
  local function enterCrusade()
    local ds = ed.playerlimit.getAreaUnlockPrompt("Crusade")
    if ds then
      ed.showToast(ds)
      return
    end
    local msg = ed.upmsg.tbc()
    msg._open_panel = {}
    ed.send(msg, "tbc")
  end
  
  local function enterGuild()
    local ds = ed.playerlimit.getAreaUnlockPrompt("Guild")
    if ds then
      ed.showToast(ds)
      return
    end
    local msg = ed.upmsg.guild()
    msg._open_pannel = {}
    ed.send(msg, "guild")
  end
  
  local function enterGuildRaid()
    local ds = ed.playerlimit.getAreaUnlockPrompt("Raid")
    if ds then
      ed.showToast(ds)
      return
    end
    local scene = ed.getCurrentScene()
    if scene.identity == "GuildMainScene" then
      ed.GuildRaidNetwork:sendOpenPanel()
    else
      local ds = ed.playerlimit.getAreaUnlockPrompt("Guild")
      if ds then
        ed.showToast(ds)
        return
      end
      local msg = ed.upmsg.guild()
      msg._open_pannel = {}
      ed.send(msg, "guild")
      ListenTimer(Timer:Once(0.1), function()
        if ed.player:getGuildId() == 0 then
          return
        end
        ed.GuildRaidNetwork:sendOpenPanel()
      end)
    end
  end
  
  local function enterPvp()
    ed.UITool.openView("PVP")
  end
  
  local function enterDreamland()
    self.isPushingScene = true
    ed.dreamland.network_mgr:RequestOpenPanel()
  end
  
  local function enterStage()
    ed.pushScene(ed.ui.stageselect.create())
    self.isPushingScene = true
  end
  
  local function enterStageChallenge()
    ed.pushScene(ed.ui.stageselect.create(nil, "challenge"))
    self.isPushingScene = true
  end
  
  local function enterHeroPackage()
    local scene = ed.getCurrentScene()
    if scene.identity == "heroPackage" then
      return
    elseif scene.identity == "package" or scene.identity == "summonScene" then
      ed.replaceScene(ed.ui.Heropackage.create())
    else
      ed.pushScene(ed.ui.Heropackage.create())
    end
    self.isPushingScene = true
  end
  
  local function enterShop(type)
    return function()
      ed.UITool.openView("shopMain", {page = type})
    end
  end
  
  local fast_handler = {
    FarmElitePVEStage = function()
      local cpl = ed.playerlimit.getAreaUnlockPrompt("Elite")
      if cpl then
        ed.showToast(cpl)
        return
      end
      ed.pushScene(ed.ui.stageselect.create(nil, "elite"))
      self.isPushingScene = true
    end,
    FarmChapter = function()
      ed.UITool.openView("SkillTowerScene")
    end,
    SkillUpgradeSuccess = function()
      enterHeroPackage()
      ed.isSkillUpDailyjob = true
    end,
    AstrolabePray = enterHeroPackage,
    EnhanceLevelUp = function()
      ed.pushScene(ed.ui.equipstrengthen.create())
      self.isPushingScene = true
    end,
    MidasUse = function()
      ed.ui.midasWin.create({
        callback = function()
          ed.taskNetwork:dailyjobOpen()
        end
      })
    end,
    TavernGroupUse = function()
      ed.activityTaskTool.openSummonScene(1)
      self.isPushingScene = true
    end,
    MonthlyCardPeriod = function()
      local rechargeMgr = ed.RechargeNewMgr.getInstance()
      if true == rechargeMgr:isUseNewRechargeMedule() then
        ed.pushScene(ed.ui.recharge.create({page = "Gift"}))
      else
        local rechargeLayer = ed.ui.recharge.create()
        local currentScene = CCDirector:sharedDirector():getRunningScene()
        currentScene:addChild(rechargeLayer.mainLayer, 200)
      end
    end,
    SuperMonthlyCardPeriod = function()
      local rechargeMgr = ed.RechargeNewMgr.getInstance()
      if true == rechargeMgr:isUseNewRechargeMedule() then
        ed.pushScene(ed.ui.recharge.create({page = "Gift"}))
      else
        local rechargeLayer = ed.ui.recharge.create()
        self.mainLayer:addChild(rechargeLayer.mainLayer, 200)
      end
    end,
    EnterRaid = function()
      local ds = ed.playerlimit.getAreaUnlockPrompt("Guild")
      if ds then
        ed.showToast(ds)
        return
      end
      ed.UITool.openView("guildScene")
      ListenTimer(Timer:Once(0.1), function()
        local ds = ed.playerlimit.getAreaUnlockPrompt("Raid")
        if ds then
          ed.showToast(ds)
          return
        end
        if ed.player:getGuildId() == 0 then
          return
        end
        ed.GuildRaidNetwork:sendOpenPanel()
      end)
    end,
    EquipItem = function()
      class.lsra:report("goHeroTask")
      local heroTask = ed.player:withHeroTask(nil)
      local heroSuperTask = ed.player:withHeroSuperTask(nil)
      local heroTaskTable = ed.getDataTable("HeroTask")
      if heroTask or heroSuperTask then
        if ed.getCurrentScene().identity == "heroPackage" then
          local scene = ed.getCurrentScene()
          if scene.heroDetailLayer then
            scene.heroDetailLayer:destroy()
          end
        end
        ed.player:clearSuperTaskEquip()
        local hid = heroTaskTable[task.chain][task.id]["Hero ID"]
        local heroDetailLayer = ed.ui.herodetail.window.create(ed.ui.packageheroitem.create(hid).hero, nil, {openMode = "card", isShowUpgradeButton = true})
        local layer = CCLayerColor:create(ccc4(0, 0, 0, 150))
        heroDetailLayer.mainLayer:addChild(layer, -1)
        self.scene:addChild(heroDetailLayer.mainLayer, 120)
      end
    end,
    GetAwakePart = function()
      local heroTask = ed.player:withHeroTask(nil)
      local heroTaskTable = ed.getDataTable("HeroTask")
      if heroTask then
        local task = heroTask
        local hid = heroTaskTable[task._line][task._id]["Hero ID"]
        local heroDetailLayer = ed.ui.herodetail.window.create(ed.ui.packageheroitem.create(hid).hero, nil, {openMode = "card", isShowUpgradeButton = true})
        self.scene:addChild(heroDetailLayer.mainLayer, 120)
      end
    end,
    FarmStageWith = function()
      class.lsra:report("goHeroTask")
      local heroTaskTable = ed.getDataTable("HeroTask")
      local gw
      local eid = heroTaskTable[task.chain][task.id]
      local pid = eid["Task Progress ID"]
      local heroId = eid["Hero ID"]
      for k, v in pairs(pid) do
        if v ~= 0 then
          gw = v
          break
        end
      end
      local type = ed.ui.battleprepare.stageType(nil, gw)
      if type == "exp" or type == "gold" then
        ed.ui.exercise.reqStageEnable("em")
      elseif string.find(type, "spring") then
        ed.ui.exercise.reqStageEnable("spring")
      elseif string.find(type, "artifact") then
        ed.ui.exercise.reqStageEnable("artifact")
      else
        ed.ui.exercise.reqStageEnable("equip")
      end
      self.isPushingScene = true
    end,
    ShopUse = function()
      local ds = ed.playerlimit.getAreaUnlockPrompt("shop")
      if ds then
        ed.showToast(ds)
        return
      end
      if not ed.player:getShopData(1) then
        print("Hava not the data of shop!")
        return
      end
      ed.pushScene(ed.ui.shop.create())
      self.isPushScene = true
    end,
    ChooseShopToBuy = function()
      ed.UITool.openView("shopMain", {page = 1})
    end,
    BuyVit = function(...)
      ed.showHandyDialog("buyVitalityWithDiamond", {
        active = true,
        reply = function()
          xpcall(function()
            ed.taskNetwork:dailyjobOpen()
          end, EDDebug)
        end
      })
    end,
    ItemUse = openPackage,
    FarmStageAlone = heroTaskNormalGoBattle,
    FarmStageNoDie = heroTaskNormalGoBattle,
    FarmStageDamage = heroTaskNormalGoBattle,
    FarmStageKill = heroTaskNormalGoBattle,
    ExcavateSearch = function()
      ed.offlinequest.offline_network:sendOpenPanel()
    end,
    FarmStage = enterTaskProcessStage,
    CompleteStage = enterTaskProcessStage,
    FarmActStage = enterCompleteStage,
    FarmFancyTowerStage = function()
      ed.UITool.openView("SkillTowerScene")
    end,
    CompleteCrusadeStage = enterCrusade,
    SendMercenary = enterGuild,
    WeeklyEnterRaid = enterGuildRaid,
    PVPBattle = enterPvp,
    PVPWin = enterPvp,
    EnterDreamLand = enterDreamland,
    FarmPVEStage = enterStage,
    QuestBoardKickoff = function()
      ed.ui.rewardoffer.push()
      self.isPushingScene = true
    end,
    OfflineQuest = function()
      ed.offlinequest.offline_network:sendOpenPanel()
    end,
    FinishAnyCrusade = enterCrusade,
    ContributeReach = enterStage,
    RaidTop10 = enterGuild,
    KillSoulChest = enterCrusade,
    FinishSuperCrusade = enterCrusade,
    PvPRank = enterPvp,
    DreamRank = enterDreamland,
    AwakeHero = enterHeroPackage,
    SuperAwakeHero = enterHeroPackage,
    NewChallengeStars = enterStageChallenge,
    ConsumeLegendCoin = enterShop(2),
    ConsumeDreamlandCoin = enterShop(4),
    CosumeStargateCoin = enterShop(2),
    ActPoint100 = function()
      FireEvent("task_panel_state", "Daily")
    end,
    HaveGuild = function()
      ed.UITool.openView("guildScene")
    end,
    PlayerLevel = function()
      ed.UITool.openView("stageSelect")
    end,
    MultiHeroRank = function()
      local scene = ed.getCurrentScene()
      if scene.identity == "heroPackage" then
        return
      elseif scene.identity == "package" or scene.identity == "summonScene" then
        ed.replaceScene(ed.ui.Heropackage.create())
      else
        ed.pushScene(ed.ui.Heropackage.create())
      end
    end,
    HeroRank = function()
      local scene = ed.getCurrentScene()
      if scene.identity == "heroPackage" then
        return
      elseif scene.identity == "package" or scene.identity == "summonScene" then
        ed.replaceScene(ed.ui.Heropackage.create())
      else
        ed.pushScene(ed.ui.Heropackage.create())
      end
    end,
    SkillEvolve = function(taskSelf)
      local scene = ed.getCurrentScene()
      if scene.identity == "heroPackage" then
        if taskSelf then
          taskSelf:destroy({skipAnim = true})
        end
        return
      elseif scene.identity == "package" or scene.identity == "summonScene" then
        ed.replaceScene(ed.ui.Heropackage.create())
      else
        ed.pushScene(ed.ui.Heropackage.create())
      end
    end,
    ShardEvolve = function()
      local pid = ed.getDataTable("Task")[task.chain][task.id]["Task Progress ID"][1]
      local hero = ed.player:getHero(pid)
      if hero then
        if not ed.heroDetailManager.getHeroIsShard(pid) then
          ed.showToast(T("\232\167\137\233\134\146\230\154\130\230\156\170\229\188\128\229\144\175"))
          return
        end
        local scene = ed.ui.heroDetailScene.create({
          hero = hero,
          index = 1,
          list = {hero},
          openMode = "card",
          isShowUpgradeButton = true,
          tabIndex = 4
        })
        ed.pushScene(scene)
        scene:refreshBtnState(1)
        scene:refreshBtnState(4)
      else
        ed.pushScene(ed.ui.Heropackage.create())
        ed.showToast(T("\230\156\170\230\139\165\230\156\137\232\175\165\232\139\177\233\155\132"))
      end
    end,
    AstrolabeIsOn = function()
      local pid = ed.getDataTable("Task")[task.chain][task.id]["Task Progress ID"][1]
      local hero = ed.player:getHero(pid)
      if hero then
        if not ed.getDataTable("Astrolabe")[pid] then
          print(" Astrolabe pid nil ", pid)
          return
        end
        local info = ed.getDataTable("Astrolabe")[pid]
        if ed.getTimeByYMDHMS(info["Online Time"]) > ed.getServerTime() then
          ed.showToast(T("\230\152\159\231\155\152\230\156\170\229\188\128\229\144\175"))
          return
        end
        local scene = ed.ui.heroDetailScene.create({
          hero = hero,
          index = 1,
          list = {hero},
          openMode = "card",
          isShowUpgradeButton = true,
          tabIndex = 5
        })
        ed.pushScene(scene)
        scene:refreshBtnState(1)
        scene:refreshBtnState(5)
      else
        ed.pushScene(ed.ui.Heropackage.create())
        ed.showToast(T("\230\156\170\230\139\165\230\156\137\232\175\165\232\139\177\233\155\132"))
      end
    end,
    PeakArenaBattle = function()
      ed.UITool.openView("PeakArenaPvpScene")
    end,
    FarmDungeonStage = function()
      ed.UITool.openView("awakeDungeonScene")
    end,
    LegendEquipForgeTimes = function()
      ed.UITool.openView("fireForgeMainScene")
    end
  }
  
  local function isShow()
    if showForce then
      return true
    end
    if task.type == "MonthlyCardPeriod" or task.type == "SuperMonthlyCardPeriod" then
      local pid = task.progressid[1]
      if ed.player:isMonthCardValid(pid) then
        return false
      end
    end
    return true
  end
  
  local button, press, label, disable, disablePress, disableLabel
  handler = fast_handler[type]
  if not (handler and isShow()) or not isNocreateButton then
  end
  return {
    button = button,
    press = press,
    label = label,
    disableButton = disable,
    disablePress = disablePress,
    disableLabel = disableLabel,
    handler = fast_handler[type]
  }
end
