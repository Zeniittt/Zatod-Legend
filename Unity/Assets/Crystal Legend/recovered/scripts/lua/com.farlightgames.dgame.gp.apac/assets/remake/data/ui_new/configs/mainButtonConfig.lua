local lsr = ed.ui.frameworklsr.create()
local ButtonType = {
  RECHARGE = 1,
  SIGN = 2,
  GIFT = 3,
  ACTIVITY = 4,
  CUPARENA = 5,
  SWEET_PARTY = 6,
  DAY_AWARDS = 7,
  TASK = 20,
  BAG = 21,
  HERO = 22,
  SUMMON = 23,
  FIRE_FORGE = 24,
  MAIL = 50,
  FRIEND = 51,
  SEVENDAY = 52,
  ACTIVITY_ADVENTURE = 53,
  GOBACK = 54,
  GUILD_CLASH = 55,
  NIAN_MONSTER_ENTER = 56,
  GUILD_MOUNT = 57,
  ENJOY_GIFT = 58,
  TIME_CORRIDOR = 59,
  DREAMLAND_GIFT = 60,
  DRAGON_BOAT = 61,
  CREVICE_DEFEND = 62,
  FEATURE_PREVIEW = 63,
  MOON_FESTIVAL = 64
}
local bgRes = "UI/alpha/1080P/main/main_icon_bg.png"
local leftBgRes = "UI/alpha/1080P/chat/chat_but_bj.png"
local redTagRes = "UI/alpha/1080P/common/digit_red_tag_bg.png"
local rightTopConfig = {
  [ButtonType.RECHARGE] = {
    name = T("\229\149\134\229\159\142"),
    type = ButtonType.RECHARGE,
    bgRes = bgRes,
    icon = "UI/alpha/1080P/main/newshop_main_menu.png",
    redTagRes = redTagRes,
    getRedPointStatus = function()
      local flag = ed.RechargeManager:canShowSecretRedTag()
      flag = flag or ed.RechargeManager:canShowTabButtonRedTag("Month")
      flag = flag or ed.RechargeManager:canShowTabButtonRedTag("Gift")
      flag = flag or ed.RechargeManager:canShowTabButtonRedTag("ActiveGift")
      flag = flag or ed.RechargeManager:canShowTabButtonRedTag("CelebrateGift")
      flag = flag or ed.RechargeManager:canShowTabButtonRedTag("AllStarGift")
      flag = flag or ed.RechargeManager:canShowTabButtonRedTag("XxxxGift")
      flag = flag or ed.RechargeManager.bNewGiftNotify
      return flag
    end,
    sort = 2,
    onClick = function()
      lsr:report("clickrmb")
      local ds = ed.playerlimit.getAreaUnlockPrompt("MallGift")
      if ds then
        ed.showToast(ds)
        return
      else
        ed.pushScene(ed.ui.RechargeScene.create({page = "Diamonds"}))
      end
    end
  },
  [ButtonType.SIGN] = {
    name = T("\231\173\190\229\136\176"),
    type = ButtonType.SIGN,
    bgRes = bgRes,
    icon = "UI/alpha/1080P/main/main_dailyreward.png",
    redTagRes = redTagRes,
    getRedPointStatus = function()
      return ed.player:getLoginRedPoint() and ed.playerlimit:moduleIsOpened("DailyLogin")
    end,
    sort = 1,
    onClick = function()
      lsr:report("clickSignIn")
      ed.UITool.openView("signIn")
    end,
    openViewIdentity = "signIn"
  },
  [ButtonType.ACTIVITY] = {
    name = T("\230\180\187\229\138\168"),
    type = ButtonType.ACTIVITY,
    bgRes = bgRes,
    icon = "UI/alpha/1080P/main/main_icon_op_act.png",
    redTagRes = redTagRes,
    getRedPointStatus = function()
      return ed.activityHints:getActivityRedShow()
    end,
    sort = 1,
    onClick = function()
      lsr:report("clickActivity")
      ed.UITool.openView("activityScene")
    end,
    openViewIdentity = "activityScene"
  },
  [ButtonType.SEVENDAY] = {
    name = T("\228\184\131\230\151\165\229\138\169\229\138\155"),
    type = ButtonType.SEVENDAY,
    bgRes = bgRes,
    icon = "UI/alpha/1080P/activity/seven_day/seven_day_icon.png",
    redTagRes = redTagRes,
    getRedPointStatus = function()
      return ed.SevenDayManager:getRedLight()
    end,
    sort = 0,
    onClick = function()
      lsr:report("clickSevenDay")
      ed.UITool.openView("SevenDayScene")
    end,
    isOpen = function()
      return ed.SevenDayManager:isOpen()
    end,
    openViewIdentity = "SevenDayScene"
  },
  [ButtonType.ACTIVITY_ADVENTURE] = {
    name = function()
      local actAdventureMgr = ed.actiAdventureMgr.getInstance()
      local name = ed.adventureDefine.getAdventureTitle(actAdventureMgr:getOpenActId())
      if name and utf8.len(name) > 4 and ed.isElementInTable(EDCurLanguage, {"cn", "tw"}) then
        return utf8.sub(name, 1, 2) .. "\n" .. utf8.sub(name, 3, utf8.len(name))
      else
        return name
      end
    end,
    nameWidth = function()
      local actAdventureMgr = ed.actiAdventureMgr.getInstance()
      local name = ed.adventureDefine.getAdventureTitle(actAdventureMgr:getOpenActId())
      if name and utf8.len(name) > 4 then
        return 45
      end
      return 30
    end,
    type = ButtonType.ACTIVITY_ADVENTURE,
    bgRes = bgRes,
    icon = function()
      local actAdventureMgr = ed.actiAdventureMgr.getInstance()
      local actId = actAdventureMgr:getOpenActId()
      return ed.adventureDefine.getMainSceneEnterIcon(actId)
    end,
    redTagRes = redTagRes,
    getRedPointStatus = function()
      return ed.redPointMgr.getInstance():getNodeValue("adventure_entry") > 0
    end,
    sort = 0,
    onClick = function()
      lsr:report("clickActivityAdventure")
      local actAdventureMgr = ed.actiAdventureMgr.getInstance()
      ed.UITool.openView("adventureStageScene", {
        actId = actAdventureMgr:getOpenActId()
      })
    end,
    isOpen = function()
      local actAdventureMgr = ed.actiAdventureMgr.getInstance()
      return actAdventureMgr:checkAdventurenOpen(actAdventureMgr:getOpenActId())
    end,
    openViewIdentity = "adventureStageScene"
  },
  [ButtonType.GOBACK] = {
    name = T("\229\155\158\229\189\146\231\164\188"),
    type = ButtonType.GOBACK,
    bgRes = bgRes,
    nameWidth = 45,
    icon = "UI/alpha/1080P/goback/goback_entrance.png",
    redTagRes = redTagRes,
    getRedPointStatus = function()
      return ed.GobackManager:getRedLight()
    end,
    sort = 0,
    onClick = function()
      if ReloadModule then
        ReloadModule("ui_new/modules/goback/GobackModuleList")
      end
      ed.UITool.openView("GobackMainScene", {})
    end,
    isOpen = function()
      return ed.GobackManager:isActiving()
    end,
    openViewIdentity = "GobackMainScene"
  },
  [ButtonType.GUILD_CLASH] = {
    name = T("\229\133\172\228\188\154\230\136\152"),
    type = ButtonType.GUILD_CLASH,
    bgRes = bgRes,
    nameWidth = 45,
    icon = "UI/alpha/1080P/guild/icon_clash.png",
    redTagRes = redTagRes,
    getRedPointStatus = function()
      return ed.redPointMgr.getInstance():getNodeValue("guild_clash_enter") > 0
    end,
    sort = 0,
    onClick = function()
      if ed.player:getGuildId() == 0 then
        ed.showToast(T("\230\154\130\230\156\170\229\138\160\229\133\165\229\133\172\228\188\154"))
        return
      end
      if not ed.GuildClashManager:isOffSeason() then
        ed.UITool.openView("GuildClashMainScene", {})
      else
        ed.showToast(T("\229\133\172\228\188\154\230\136\152\230\154\130\230\156\170\229\188\128\229\144\175"))
      end
    end,
    isOpen = function()
      return not ed.GuildClashManager:isOffSeason()
    end,
    openViewIdentity = "GuildClashMainScene"
  },
  [ButtonType.NIAN_MONSTER_ENTER] = {
    name = function()
      local mgr = ed.nianMonsterMgr.getInstance()
      local uiConfig = mgr:getActivityUIConfig()
      return uiConfig.entryCfg.entryName
    end,
    type = ButtonType.NIAN_MONSTER_ENTER,
    bgRes = bgRes,
    nameWidth = 30,
    icon = function()
      local mgr = ed.nianMonsterMgr.getInstance()
      local uiConfig = mgr:getActivityUIConfig()
      return uiConfig.entryCfg.entryIconPath
    end,
    redTagRes = redTagRes,
    getRedPointStatus = function()
      return ed.redPointMgr.getInstance():getNodeValue("nian_monster_entry") > 0
    end,
    sort = 0,
    onClick = function()
      ed.UITool.openView("nianMonsterMainScene")
    end,
    isOpen = function()
      local nianMonsterMgr = ed.nianMonsterMgr.getInstance()
      return nianMonsterMgr:getNianMonsterIsOpen()
    end,
    openViewIdentity = "nianMonsterMainScene"
  },
  [ButtonType.GUILD_MOUNT] = {
    name = T("\233\173\148\231\149\140\232\174\168\228\188\144"),
    type = ButtonType.GUILD_MOUNT,
    bgRes = bgRes,
    nameWidth = 30,
    icon = "UI/alpha/1080P/guildmount/icon_main.png",
    redTagRes = redTagRes,
    getRedPointStatus = function()
      return ed.GuildMountManager:getRedFlag()
    end,
    sort = 0,
    onClick = function()
      ReloadModule("ui_new/modules/guildMount/GuildMountModuleList")
      ed.UITool.openView("GuildMountScene")
    end,
    isOpen = function()
      return not ed.GuildMountManager:isOffSeason()
    end
  },
  [ButtonType.CUPARENA] = {
    name = T("\229\165\179\231\165\158\228\185\139\230\136\152"),
    type = ButtonType.CUPARENA,
    bgRes = bgRes,
    icon = "UI/alpha/1080P/cuparena/cuparena_enter.png",
    redTagRes = redTagRes,
    getRedPointStatus = function()
      return ed.CupArenaManager:getEntryRedFlag() or ed.CupArenaManager:getMedalRewardRedFlag() or ed.CupArenaManager:getFirstChallengeRedFlag() or ed.CupArenaManager:getTaskRedFlag() or ed.CupArenaManager:getGambleRedFlag() or ed.CupArenaManager:getChallengeRecordRedFlag()
    end,
    sort = 0,
    isOpen = function()
      if not ed.CupArenaManager:getIsCanEntry() then
        return false
      end
      local limitLv = ed.CupArenaManager:getCupArenaConfig("Open Level")
      if limitLv > ed.player:getLevel() then
        return false
      end
      return true
    end,
    onClick = function()
      local isUnlock, tipStr = ed.CupArenaManager:isUnlock()
      if isUnlock then
        ed.CupArenaNetwork:sendOpenPanel(true)
      else
        ed.showToast(tipStr)
      end
    end
  },
  [ButtonType.SWEET_PARTY] = {
    name = T("\231\148\156\229\191\131\230\180\190\229\175\185"),
    type = ButtonType.SWEET_PARTY,
    bgRes = bgRes,
    icon = "UI/alpha/1080P/activity/sweet_party/sweet_party_entrance.png",
    redTagRes = redTagRes,
    getRedPointStatus = function()
      return ed.sweetPartyManager.showRed and ed.sweetPartyManager.showRed > 0
    end,
    sort = 0,
    isOpen = function()
      return ed.sweetPartyManager.isOpen
    end,
    onClick = function()
      ed.UITool.openView("sweetPartyScene", {})
    end
  },
  [ButtonType.ENJOY_GIFT] = {
    name = T("\233\153\144\230\151\182\231\164\188\229\140\133"),
    type = ButtonType.ENJOY_GIFT,
    createUIFunc = function(mainButton)
      local container = CCSprite:create()
      container:setCascadeOpacityEnabled(true)
      local ui = {}
      local readnode = ed.readnode.create(container, ui)
      readnode:addNode(ed.uieditor.EnjoyGiftEntryBtn)
      local size = ui.root:getContentSize()
      container:setContentSize(size)
      ui.root:setPosition(ccp(0, 0))
      ed.setLabelStroke(ui.name, ed.toccc3(6234631), 1)
      ed.setLabelStroke(ui.time_txt, ed.toccc3(4727041), 1)
      ed.setLabelStroke(ui.red_num_txt, ed.toccc3(8136726), 1)
      ui.name:limitSizeByScale(65, 20)
      local bgSize = ui.name_bg:getContentSize()
      bgSize.height = math.max(18.5, ui.name:getContentSize().height * ui.name:getScaleY() + 2)
      ui.name_bg:setContentSize(bgSize)
      ui.name:setPositionY(ui.name_bg:getPositionY() - bgSize.height * 0.5)
      local boxEffect = ed.createSpine("effect/eff_UI_Main_impulsegift/eff_UI_Main_impulsegift", 0.5)
      boxEffect:setAnimation(0, "Idle", true)
      boxEffect:setPosition(size.width / 2, size.height / 2 - 10)
      ui.root:addChild(boxEffect, -1)
      return container, ui
    end,
    getRedPointNum = function()
      return ed.RechargeManager:getEnjoyGiftNum()
    end,
    sort = 0,
    onClick = function()
      ed.RechargeNetwork:sendOpenEnjoyGift(ed.RechargeManager.GiftType.Enjoy)
    end,
    isOpen = function()
      return ed.RechargeManager:getEnjoyGiftNum() > 0
    end,
    timeStrFunc = function()
      local endTime = ed.RechargeManager:getEnjoyGiftEndTime()
      local serverTime = ed.getServerTime()
      if 0 == endTime or endTime <= serverTime then
        FireEvent("RefreshRightTopButtons")
        return "00:00:00"
      else
        return ed.gethmsNString(endTime - serverTime)
      end
    end
  },
  [ButtonType.DREAMLAND_GIFT] = {
    name = T("\230\162\166\229\162\131\231\164\188\229\140\133"),
    type = ButtonType.DREAMLAND_GIFT,
    createUIFunc = function(mainButton)
      local container = CCSprite:create()
      container:setCascadeOpacityEnabled(true)
      local ui = {}
      local readnode = ed.readnode.create(container, ui)
      readnode:addNode(ed.uieditor.DreamlandGiftEntryBtn)
      local size = ui.root:getContentSize()
      container:setContentSize(size)
      ui.root:setPosition(ccp(0, 0))
      ed.setLabelStroke(ui.name, ed.toccc3(6234631), 1)
      ed.setLabelStroke(ui.time_txt, ed.toccc3(4727041), 1)
      ed.setLabelStroke(ui.red_num_txt, ed.toccc3(8136726), 1)
      ui.name:limitSizeByScale(65, 20)
      local bgSize = ui.name_bg:getContentSize()
      bgSize.height = math.max(18.5, ui.name:getContentSize().height * ui.name:getScaleY() + 2)
      ui.name_bg:setContentSize(bgSize)
      ui.name:setPositionY(ui.name_bg:getPositionY() - bgSize.height * 0.5)
      local icon = ed.createSprite("UI/alpha/1080P/impulsegift/impulsegift_dreamland/entrance.png")
      icon:setPosition(size.width / 2, size.height / 2 + 10)
      ui.root:addChild(icon, -1)
      return container, ui
    end,
    getRedPointNum = function()
      return ed.RechargeManager:getDreamlandGiftNum()
    end,
    sort = 0,
    onClick = function()
      ed.RechargeNetwork:sendOpenEnjoyGift(ed.RechargeManager.GiftType.Dreamland)
    end,
    isOpen = function()
      return ed.RechargeManager:getDreamlandGiftNum() > 0
    end,
    timeStrFunc = function()
      local endTime = ed.RechargeManager:getDreamlandGiftEndTime()
      local serverTime = ed.getServerTime()
      if 0 == endTime or endTime <= serverTime then
        FireEvent("RefreshRightTopButtons")
        return "00:00:00"
      else
        return ed.gethmsNString(endTime - serverTime)
      end
    end
  },
  [ButtonType.TIME_CORRIDOR] = {
    name = T("\230\151\182\231\169\186\229\155\158\229\187\138"),
    type = ButtonType.TIME_CORRIDOR,
    bgRes = bgRes,
    icon = "UI/alpha/1080P/timecorridor/timecorridor_entrance.png",
    redTagRes = redTagRes,
    getRedPointStatus = function()
      return ed.timeCorridorMgr:showRed()
    end,
    sort = 0,
    onClick = function()
      ed.UITool.openView("timeCorridorScene")
    end,
    isOpen = function()
      return ed.timeCorridorMgr.isOpen
    end
  },
  [ButtonType.DAY_AWARDS] = {
    name = T("\228\188\160\229\165\135\229\144\175\231\168\139"),
    type = ButtonType.DAY_AWARDS,
    bgRes = bgRes,
    icon = "UI/alpha/1080P/fireforge/DayAwards/entrance.png",
    redTagRes = redTagRes,
    getRedPointStatus = function()
      return ed.dayAwardsManager.showRed and ed.dayAwardsManager.showRed > 0
    end,
    sort = 0,
    isOpen = function()
      return ed.dayAwardsManager.isOpen
    end,
    onClick = function()
      ed.UITool.openView("dayAwardsScene", {})
    end
  },
  [ButtonType.DRAGON_BOAT] = {
    name = T("\231\178\189\230\168\170\229\155\155\230\181\183"),
    type = ButtonType.DRAGON_BOAT,
    bgRes = bgRes,
    icon = "UI/alpha/1080P/dragonboat/db_race/db_entrance_icon.png",
    redTagRes = redTagRes,
    getRedPointStatus = function()
      return ed.redPointMgr.getInstance():getNodeValue("dragon_boat_entry") > 0 and ed.dragonBoatMgr:getInstance():isInRace()
    end,
    sort = 0,
    onClick = function()
      if ed.player:getLevel() < 10 then
        ed.showToast(T("\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\17610\231\186\167\229\188\128\230\148\190"))
        return
      end
      if ed.dragonBoatMgr:getInstance():IsExpire() then
        ed.showToast(T("\230\180\187\229\138\168\229\183\178\229\133\179\233\151\173"))
        return
      end
      ed.ReloadModule("ui_new/modules/activity/dragonBoat/init")
      if ed.dragonBoatMgr:getInstance():isInRace() then
        ed.dragonBoatNet.getInstance():sendOpenPanel()
      else
        ed.UITool.openView("dragonBoatRankScene")
      end
    end,
    isOpen = function()
      return ed.dragonBoatMgr:getInstance().showActivity
    end
  },
  [ButtonType.CREVICE_DEFEND] = {
    name = T("\232\163\130\233\154\153\230\136\141\229\141\171"),
    type = ButtonType.CREVICE_DEFEND,
    bgRes = bgRes,
    icon = "UI/alpha/1080P/crevicedefend/activity_icon.png",
    redTagRes = redTagRes,
    getRedPointStatus = function()
      ed.CreviceDefendManager:getCurrentSeasonConfig()
      return ed.CreviceDefendManager:getRedFlag()
    end,
    sort = 0,
    onClick = function()
      ed.CreviceDefendNetWork:sendOpenPanel()
    end,
    isOpen = function()
      ed.CreviceDefendManager:getCurrentSeasonConfig()
      return ed.CreviceDefendManager:getState()
    end
  },
  [ButtonType.FEATURE_PREVIEW] = {
    name = T("\229\138\159\232\131\189\233\162\132\229\145\138"),
    type = ButtonType.FEATURE_PREVIEW,
    bgRes = bgRes,
    icon = "UI/alpha/1080P/featurepreview/fp_icon.png",
    redTagRes = redTagRes,
    getRedPointStatus = function()
      return ed.featurePreviewManager.red
    end,
    onClick = function()
      ed.UITool.openView("featurePreviewWindow")
    end,
    isOpen = function()
      return ed.featurePreviewManager.isOpen
    end,
    sort = 0
  },
  [ButtonType.MOON_FESTIVAL] = {
    name = T("\229\133\148\229\173\144\232\181\155\232\183\145"),
    type = ButtonType.MOON_FESTIVAL,
    bgRes = bgRes,
    icon = "UI/alpha/1080P/dragonboat/db_race/db_entrance_icon.png",
    redTagRes = redTagRes,
    getRedPointStatus = function()
      return ed.redPointMgr.getInstance():getNodeValue("moon_festival_entry") > 0 and ed.moonFestivalMgr:getInstance():isInRace()
    end,
    sort = 0,
    onClick = function()
      if ed.player:getLevel() < 10 then
        ed.showToast(T("\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\17610\231\186\167\229\188\128\230\148\190"))
        return
      end
      if ed.dragonBoatMgr:getInstance():IsExpire() and false then
        ed.showToast(T("\230\180\187\229\138\168\229\183\178\229\133\179\233\151\173"))
        return
      end
      ed.ReloadModule("ui_new/modules/activity/moonFestivalRace/init")
      ed.UITool.openView("moonFestivalMainScene")
    end,
    isOpen = function()
      return false
    end
  }
}
bgRes = "UI/alpha/1080P/main/main_butt_bg.png"
local rightBottomConfig = {
  [ButtonType.TASK] = {
    name = T("\228\187\187\229\138\161"),
    type = ButtonType.TASK,
    nameRes = T("\228\187\187\229\138\161"),
    bgRes = bgRes,
    icon = "UI/alpha/1080P/main/main_task_button.png",
    redTagRes = redTagRes,
    getRedPointStatus = function()
      return ed.taskData:getReds() > 0 or ed.GobackManager:getDailyTaskRedLight()
    end,
    sort = 1,
    onClick = function()
      lsr:report("clickTask")
      ed.UITool.openView("taskScene", {})
    end,
    openViewIdentity = ""
  },
  [ButtonType.BAG] = {
    name = T("\232\131\140\229\140\133"),
    type = ButtonType.BAG,
    nameRes = T("\232\131\140\229\140\133"),
    bgRes = bgRes,
    icon = "UI/alpha/1080P/main/main_package_button.png",
    redTagRes = redTagRes,
    getRedPointStatus = function()
      return false
    end,
    sort = 3,
    onClick = function()
      lsr:report("clickPackage")
      ed.pushScene(ed.ui.package.create("package"))
    end,
    openViewIdentity = "",
    priority = -999
  },
  [ButtonType.HERO] = {
    name = T("\232\139\177\233\155\132"),
    type = ButtonType.HERO,
    nameRes = T("\232\139\177\233\155\132"),
    bgRes = bgRes,
    icon = "UI/alpha/1080P/main/main_hero_button.png",
    redTagRes = redTagRes,
    getRedPointStatus = function()
      return ed.heroDetailManager:getAllRedLight()
    end,
    sort = 2,
    onClick = function()
      lsr:report("clickHeroPackage")
      if ReloadModule then
        ReloadModule("ui_new/modules/heropackage/HeroPackageModuleList")
      end
      ed.pushScene(ed.ui.Heropackage.create())
    end,
    openViewIdentity = "",
    priority = -999
  },
  [ButtonType.SUMMON] = {
    name = T("\229\143\172\229\148\164"),
    type = ButtonType.SUMMON,
    nameRes = T("\229\143\172\229\148\164"),
    bgRes = bgRes,
    icon = "UI/alpha/1080P/main/main_fragment_button.png",
    redTagRes = redTagRes,
    getRedPointStatus = function()
      return false
    end,
    sort = 4,
    onClick = function()
      lsr:report("clickSummon")
      ed.UITool.openView("summonScene", {page = 1})
    end,
    openViewIdentity = "summonScene"
  },
  [ButtonType.FIRE_FORGE] = not ed.isAreaOverSea() and {
    name = T("\233\148\187\233\128\160"),
    type = ButtonType.FIRE_FORGE,
    nameRes = T("\233\148\187\233\128\160"),
    bgRes = bgRes,
    icon = "UI/alpha/1080P/fireforge/icon_mainboard.png",
    redTagRes = redTagRes,
    isOpen = function()
      return ed.playerlimit:moduleIsOpened("LegendEquipForge")
    end,
    getRedPointStatus = function()
      return ed.redPointMgr.getInstance():getNodeValue("fire_forge_entry") > 0
    end,
    sort = 4,
    onClick = function()
      ed.UITool.openView("fireForgeMainScene")
    end,
    openViewIdentity = "fireForgeMainScene"
  } or nil
}
local leftUpConfig = {
  [ButtonType.MAIL] = {
    type = ButtonType.MAIL,
    bgRes = leftBgRes,
    bgTag = "UI/alpha/1080P/mail/mail_time_img.png",
    icon = "UI/alpha/1080P/chat/chat_mail.png",
    redTagRes = redTagRes,
    getRedPointStatus = function()
      return ed.player:getMailDayRedOrTag()
    end,
    sort = 1,
    onClick = function()
      lsr:report("clickMail")
      ed.UITool.openView("mailbox")
    end,
    openViewIdentity = "mailbox"
  },
  [ButtonType.FRIEND] = {
    type = ButtonType.FRIEND,
    bgRes = leftBgRes,
    icon = "UI/alpha/1080P/chat/chat_friend.png",
    redTagRes = redTagRes,
    getRedPointStatus = function()
      return ed.applyFriend.getApplyFriendCount() > 0
    end,
    sort = 2,
    openViewIdentity = "friendPanel",
    onClick = function()
      lsr:report("clickFriend")
      if not ed.playerlimit:moduleIsOpened("Friend") then
        ed.showToast(T("\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\17610\231\186\167\229\188\128\230\148\190"))
        return
      end
      ed.ui.friendMainWin.create():popWindow()
    end
  }
}
local defaultRightTopConfig = {
  mainScene = {
    {
      ButtonType.RECHARGE,
      ButtonType.SIGN,
      ButtonType.GIFT,
      ButtonType.ACTIVITY,
      ButtonType.SEVENDAY,
      ButtonType.ACTIVITY_ADVENTURE,
      ButtonType.GOBACK,
      ButtonType.NIAN_MONSTER_ENTER,
      ButtonType.GUILD_CLASH,
      ButtonType.GUILD_MOUNT,
      ButtonType.CUPARENA,
      ButtonType.SWEET_PARTY,
      ButtonType.TIME_CORRIDOR,
      ButtonType.DAY_AWARDS,
      ButtonType.DRAGON_BOAT,
      ButtonType.CREVICE_DEFEND,
      ButtonType.FEATURE_PREVIEW,
      ButtonType.MOON_FESTIVAL
    },
    {
      ButtonType.ENJOY_GIFT
    },
    {
      ButtonType.DREAMLAND_GIFT
    }
  }
}
local defaultLeftDownConfig = {
  mainScene = {
    ButtonType.MAIL,
    ButtonType.FRIEND
  }
}
return {
  ButtonType = ButtonType,
  getButtonConfig = function(buttonType)
    return rightTopConfig[buttonType] or rightBottomConfig[buttonType]
  end,
  getDefaultRightTopConfig = function(idendity)
    return defaultRightTopConfig[idendity] or {}
  end,
  getLeftDownBottomButtonConfig = function(buttonType)
    return leftUpConfig[buttonType]
  end,
  getDefaultLeftDownBottomConfig = function(idendity)
    return defaultLeftDownConfig[idendity] or {}
  end
}
