ed.UITool.registViewOpenFunc("summonScene", function(param)
  ed.activityHints.network:activityPull()
  ed.summonMgr:openSummonScene()
  if ed.isOpenAsyncLoad() then
    param = param or {}
    if ed.guide.data:getRecordValue(7) == 0 then
      ed.summonMgr.page = 1
    else
      ed.summonMgr.page = param.page
    end
  end
end)
local base = ed.ui.commonscene
local SummonScene = newclass(base.mt)
ed.ui.summonScene = SummonScene
local pageConfig = {
  {
    key = "normal",
    fcaRes = "eff_UI_SummonCircle_OpenCard",
    bgRes = "UI/alpha/1080P/bg/summon_bg.jpg",
    iconRes = "UI/alpha/1080P/icon/soulchest_ticket.png"
  },
  {
    key = "destiny",
    fcaRes = "eff_UI_SummonDestiny_OpenCard",
    bgRes = "UI/alpha/1080P/bg/summon_bg1.jpg",
    iconRes = "UI/alpha/1080P/icon/destiny_ticket.png"
  },
  {
    key = "timely",
    fcaRes = "eff_UI_SummonTimely_OpenCard",
    bgRes = "UI/alpha/1080P/summontimely/timely_bg.jpg",
    iconRes = "UI/alpha/1080P/icon/summontimely_ticket.png"
  },
  {
    key = "newbie",
    fcaRes = "eff_UI_SummonBeginner_OpenCard",
    bgRes = "UI/alpha/1080P/summontimely/timely_bg.jpg",
    iconRes = "UI/alpha/1080P/icon/summontimely_ticket.png"
  },
  {
    key = "riseStar",
    fcaRes = "eff_UI_RiseStar_OpenCard",
    bgRes = "UI/alpha/1080P/summonrisestar/risestar_bg.jpg",
    iconRes = "UI/alpha/1080P/icon/soulchest_ticket.png"
  }
}
local multiLanPosConfig = {
  cn = {
    imgPos = ccp(0, 0),
    Pos = ccp(38, 0),
    pre10_imgPos = ccp(0, 0),
    pre10_Pos = ccp(-13, 0)
  },
  tw = {
    imgPos = ccp(0, 0),
    Pos = ccp(38, 0),
    pre10_imgPos = ccp(0, 0),
    pre10_Pos = ccp(-13, 0)
  },
  en = {
    imgPos = ccp(0, -18),
    Pos = ccp(234, 0),
    pre10_imgPos = ccp(0, -18),
    pre10_Pos = ccp(293, 0)
  },
  ko = {
    imgPos = ccp(40, 0),
    Pos = ccp(-50, 0),
    pre10_imgPos = ccp(0, 0),
    pre10_Pos = ccp(-45, 0)
  },
  ja = {
    imgPos = ccp(0, -13),
    Pos = ccp(-84, 0),
    pre10_imgPos = ccp(0, -10),
    pre10_Pos = ccp(-57, 0)
  },
  es = {
    imgPos = ccp(0, 10),
    Pos = ccp(155, -2),
    pre10_imgPos = ccp(0, 20),
    pre10_Pos = ccp(207, 3)
  }
}

function SummonScene:updateBtnRulePos()
  if not self.pageIndex then
    return
  end
  if self.pageIndex == 1 or self.pageIndex == 2 then
    self.ui.btn_tips:setPosition(self.btn_rule_pos)
  elseif self.pageIndex == 3 then
    local len = self.timelyTitle.node:getContentSize().width * 0.5
    ed.layout.relateLayout(self.timelyTitle.node, self.ui.btn_tips, {
      right = len + 10
    })
  elseif self.pageIndex == 4 then
    local len = self.ui.ImageView_94737:getContentSize().width * 0.5
    ed.layout.relateLayout(self.ui.ImageView_94737, self.ui.btn_tips, {right = len})
  elseif self.pageIndex == 5 then
    local len = 195
    ed.layout.relateLayout(self.ui.ImageView_94737_Rise, self.ui.btn_tips, {right = len})
  end
end

function SummonScene.create(pageIndex)
  local self = base.create("summonScene", {noBottomButton = true})
  setmetatable(self, SummonScene.mt)
  self.eventScope = {}
  self:init(pageIndex or 1)
  return self
end

function SummonScene:init(pageIndex)
  self.wishItems = {}
  self.summonMethod = "one"
  self.pageIndex = pageIndex
  self.tabName = pageConfig[pageIndex].key
  self.summonFcaList = {
    nil,
    nil,
    nil,
    nil
  }
  self:initView()
  self:addEventListener()
  self:refreshLayer()
end

function SummonScene:createTimelySummonExBg()
  local extraBG = ed.createSprite("UI/alpha/1080P/bg/summon_timely_extra.png")
  extraBG:setPosition(-140.2, -191.9)
  local size = extraBG:getContentSize()
  local extraBG1 = ed.createSprite("UI/alpha/1080P/bg/summon_timely_extra.png")
  extraBG1:setFlipX(true)
  extraBG1:setAnchorPoint(ccp(0, 0))
  extraBG1:setPosition(ccp(size.width - 2, 0))
  extraBG:addChild(extraBG1, 1)
  extraBG:setVisible(false)
  return extraBG
end

function SummonScene:getFcaByUnit()
end

function SummonScene:getFcaScaleForAdapt()
  local resRatio = 2.1666666666666665
  local scale = 1
  local winRatio = ed.display.winSize.width / ed.display.winSize.height
  local designRatio = ed.display.designSize.width / ed.display.designSize.height
  if winRatio < designRatio then
    scale = ed.display.winSize.height / ed.display.designSize.height
  elseif resRatio < winRatio then
    scale = ed.display.winSize.width / ed.display.designSize.width
  end
  return scale
end

function SummonScene:initLabels()
  local ui = self.ui
  local strokecolor = ccc3(39, 37, 36)
  local fontcolor = ccc3(255, 252, 231)
  ed.setLabelColor(ui.text_tips, fontcolor)
  ed.setLabelColor(ui.text_tips1, fontcolor)
  ed.setLabelStroke(ui.text_value, ccc3(ed.colorToStr("#3b1943")), 1)
  ed.setLabelColor(ui.text_value, ccc3(ed.colorToStr("#ed97ff")))
  ed.setLabelStroke(ui.label_timely_extra_title, ed.toccc3(12543727), 1)
  ed.setLabelStroke(ui.label_destiny_hero, ed.toccc3(13645679), 1)
  ed.setLabelStroke(ui.label_wish_list, ed.toccc3(6175764), 1)
  ed.setLabelStroke(ui.label_tab_destiny_name_choose, ed.toccc3(13264386), 1)
  ed.setLabelStroke(ui.label_tab_summon_name_choose, ed.toccc3(13264386), 1)
  ed.setLabelStroke(ui.label_tab_timely_name_choose, ed.toccc3(13264386), 1)
  ed.setLabelStroke(ui.label_tab_newbie_name_choose, ed.toccc3(13264386), 1)
  ed.setLabelStroke(ui.label_tab_destiny_name_unchoose, ed.toccc3(3153941), 1)
  ed.setLabelStroke(ui.label_tab_summon_name_unchoose, ed.toccc3(3153941), 1)
  ed.setLabelStroke(ui.label_tab_timely_name_unchoose, ed.toccc3(3153941), 1)
  ed.setLabelStroke(ui.label_tab_newbie_name_unchoose, ed.toccc3(3153941), 1)
  ed.setLabelStroke(ui.label_skip, ed.toccc3(3483679), 1)
  fontcolor = ccc3(255, 230, 154)
  ed.setLabelColor(ui.btn_summon_once_label, fontcolor)
  ed.setLabelColor(ui.btn_summon_ten_label, fontcolor)
  ed.setLabelShadow(ui.btn_summon_once_label, ccc3(0, 0, 0), ccp(1, 0))
  ed.setLabelShadow(ui.btn_summon_ten_label, ccc3(0, 0, 0), ccp(1, 0))
  ed.setLabelStroke(ui.text_detai, ed.toccc3(2565412), 1)
  ed.setLabelStroke(ui.label_newbie_extra_title, ed.toccc3(12543727), 1)
  ui.label_tab_newbie_name_choose:setHorizontalAlignment(kCCTextAlignmentCenter)
  ui.label_tab_newbie_name_choose:limitSizeByScale(120, 50)
  ui.label_tab_newbie_name_unchoose:setHorizontalAlignment(kCCTextAlignmentCenter)
  ui.label_tab_newbie_name_unchoose:limitSizeByScale(120, 50)
  ui.label_tab_timely_name_choose:setHorizontalAlignment(kCCTextAlignmentCenter)
  ui.label_tab_timely_name_choose:limitSizeByScale(120, 50)
  ui.label_tab_timely_name_unchoose:setHorizontalAlignment(kCCTextAlignmentCenter)
  ui.label_tab_timely_name_unchoose:limitSizeByScale(120, 50)
  ui.label_tab_summon_name_choose:setHorizontalAlignment(kCCTextAlignmentCenter)
  ui.label_tab_summon_name_choose:limitSizeByScale(120, 50)
  ui.label_tab_summon_name_unchoose:setHorizontalAlignment(kCCTextAlignmentCenter)
  ui.label_tab_summon_name_unchoose:limitSizeByScale(120, 50)
  ui.label_tab_destiny_name_choose:setHorizontalAlignment(kCCTextAlignmentCenter)
  ui.label_tab_destiny_name_choose:limitSizeByScale(120, 50)
  ui.label_tab_destiny_name_unchoose:setHorizontalAlignment(kCCTextAlignmentCenter)
  ui.label_tab_destiny_name_unchoose:limitSizeByScale(120, 50)
  ui.label_tab_RiseStar_name_choose:setHorizontalAlignment(kCCTextAlignmentCenter)
  ui.label_tab_RiseStar_name_choose:limitSizeByScale(120, 50)
  ui.label_tab_RiseStar_name_unchoose:setHorizontalAlignment(kCCTextAlignmentCenter)
  ui.label_tab_RiseStar_name_unchoose:limitSizeByScale(120, 50)
end

function SummonScene:initView()
  local container, ui = ed.editorui(ed.uieditor.summonScene, self.ui)
  self.ui = ui
  self.btn_rule_pos = ccp(ui.btn_tips:getPositionX(), ui.btn_tips:getPositionY())
  self.container = container
  self.mainLayer:addChild(container)
  ui.btn_skip:removeFromParentAndCleanup(false)
  self.mainLayer:addChild(ui.btn_skip, 1)
  self.ui.btn_skip:setVisible(false)
  self:setBackground(pageConfig[self.pageIndex].bgRes)
  self:setBackButton(function()
    ed.playEffect(ed.sound.common.back)
  end)
  self:initLabels()
  if not ed.isElementInTable(EDCurLanguage, {"ko", "ja"}) then
    self.ui.btn_pdf_detail:setVisible(false)
  else
    self.ui.btn_pdf_detail:setScale(0.8)
    ed.layout.layoutWithMagin(self.ui.btn_pdf_detail, {left = 25, bottom = 0})
    local str = EDCurLanguage == "ko" and "\237\153\149\235\165\160 \236\149\136\235\130\180" or "\229\143\172\229\150\154\232\169\179\231\180\176"
    self.ui.label_pdf_detail:setString(str)
  end
  ed.layout.layoutWithMagin(ui.btn_hero_detail, {left = 50, bottom = 50})
  ed.layout.layoutWithMagin(ui.btn_skip, {top = 0, right = 0})
  ed.layout.layoutWithMagin(ui.btn_record, {left = 50, bottom = 130})
  ed.setLabelStroke(ui.label_record, ed.toccc3(2565412), 1)
  local summonCount = ed.summonMgr:getNormalSummonCount() or 0
  local pre10Flag = not ed.summonMgr:isHad3StarHero() and summonCount <= 10
  local posConf = multiLanPosConfig[ed.getCurArea()] or multiLanPosConfig.cn
  ed.UITool.setPositionBy(self.ui.desc_text_2, posConf.imgPos)
  ed.UITool.setPositionBy(self.ui.desc_text_1, posConf.pre10_imgPos)
  ed.UITool.setPositionBy(self.ui.desc_value_root, posConf[(pre10Flag and "pre10_" or "") .. "Pos"])
  self:initNormalLayer()
  self:initDestinyLayer()
  self:initTimelyLayer()
  self:initNewbieLayer()
  self:initRiseStarLayer()
  local fca = ed.createFcaNode(pageConfig[self.pageIndex].fcaRes)
  if self.tabName == "timely" then
    self:createFcaNodeByUnitID(fca, self.curTimelyHeroId)
    self.extraBg = self:createTimelySummonExBg()
    fca:addChild(self.extraBg, 1)
  elseif self.tabName == "newbie" and self.curNewbieHeroId then
    self:createFcaNodeByUnitID(fca, self.curNewbieHeroId)
    self.extraNewbieBg = self:createTimelySummonExBg()
    fca:addChild(self.extraNewbieBg, 1)
  elseif self.tabName == "riseStar" and self.curRiseStarHeroId then
    self:createFcaNodeByUnitID(fca, self.curRiseStarHeroId)
    self.extraRiseStarBg = self:createTimelySummonExBg()
    fca:addChild(self.extraRiseStarBg, 1)
  end
  self.mainFcaScale = self:getFcaScaleForAdapt()
  fca:setScale(self.mainFcaScale)
  self.fcaPos = self.mainLayer:convertToNodeSpace(ed.display.center)
  fca:setPosition(self.fcaPos)
  self.mainLayer:addChild(fca, -1)
  self:addFca(fca)
  fca:setAction("Start")
  self.summonFcaList[self.pageIndex] = fca
  self.curScreenFca = fca
  ui.btn_hero_detail:setVisible(true)
  self:adaptRightBtn()
  self:refreshDestinyRedLight()
end

function SummonScene:adaptRightBtn()
  local centerHeight = ed.display.winSize.height / 2 - 30
  local perHeight = 80
  local btnList = {}
  local sortIndex = {
    2,
    1,
    3,
    4,
    5
  }
  for k, v in ipairs(sortIndex) do
    if self.ui["btn" .. v]:isVisible() then
      table.insert(btnList, self.ui["btn" .. v])
    end
  end
  for k, v in ipairs(btnList) do
    local offsetY = (k - (#btnList + 1) / 2) * perHeight
    ed.layout.layoutWithMagin(v, {
      top = centerHeight - offsetY,
      right = 80
    }, true)
  end
end

function SummonScene:getTimelyDesc()
  if not self.isTimelySummonOpen then
    return ""
  end
  if not self.hadGetTimelyReward then
    if self.timelyProgress < self.timelyMaxProgress then
      return string.format(T("<lable color=ccc3(112,255,84) strokeColor=ccc3(23,49,31) strokeSize=1>\230\138\189\229\143\150%d</lable>") .. T("<lable color=ccc3(255,252,231)>/%d\229\144\142\232\142\183\229\190\151</lable>"), self.timelyProgress, self.timelyMaxProgress)
    else
      return string.format(T("<lable color=ccc3(112,255,84) strokeColor=ccc3(23,49,31) strokeSize=1>\229\143\175\233\162\134\229\143\150</lable>"))
    end
  else
    return string.format(T("<lable color=ccc3(112,255,84) strokeColor=ccc3(23,49,31) strokeSize=1>\229\183\178\233\162\134\229\143\150</lable>"))
  end
end

function SummonScene:getNewbieDesc()
  if not self.isNewbieSummonOpen then
    return ""
  end
  if not self.hadGetNewbieReward then
    if self.newbieProgress < self.newbieMaxProgress then
      return string.format(T("<lable color=ccc3(112,255,84) strokeColor=ccc3(23,49,31) strokeSize=1>\230\138\189\229\143\150%d</lable>") .. T("<lable color=ccc3(255,252,231)>/%d\229\144\142\232\142\183\229\190\151</lable>"), self.newbieProgress, self.newbieMaxProgress)
    else
      ed.summonMgr:setCircleRed(1)
      local BuilddingType = ed.ui.configs.mainSceneMap.builddingType
      FireEvent("MainBuildRedTagChange", BuilddingType.Summon)
      return string.format(T("<lable color=ccc3(112,255,84) strokeColor=ccc3(23,49,31) strokeSize=1>\229\143\175\233\162\134\229\143\150</lable>"))
    end
  else
    return string.format(T("<lable color=ccc3(112,255,84) strokeColor=ccc3(23,49,31) strokeSize=1>\229\183\178\233\162\134\229\143\150</lable>"))
  end
end

function SummonScene:refreshNewbieRedLight(isShow)
  local BuilddingType = ed.ui.configs.mainSceneMap.builddingType
  FireEvent("MainBuildRedTagChange", BuilddingType.Summon)
  if self.ui.newbieRedLight then
    self.ui.newbieRedLight:setVisible(isShow)
    self.ui.newbieBtnRedLight:setVisible(isShow)
    return
  end
  if isShow then
    local redLight = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
    redLight:setPosition(ccp(70, 68))
    self.ui.newbie_icon:addChild(redLight)
    self.ui.newbieRedLight = redLight
    local eff = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
    eff:setPosition(-26, -25)
    eff:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
    redLight:addChild(eff, 9)
    local btnRedLight = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
    btnRedLight:setPosition(ccp(80, 27))
    self.ui.btn4:addChild(btnRedLight, 3)
    self.ui.newbieBtnRedLight = btnRedLight
  end
end

function SummonScene:refreshDestinyRedLight()
  local summonCount = ed.summonMgr:getNormalSummonCount() or 0
  summonCount = summonCount + ed.summonMgr.timelySummonCount + ed.summonMgr.newbieSummonCount
  if 200 <= summonCount and not ed.storage.getBool(ed.getRoleKey("Summon_Destiny_Red")) then
    if self.ui.destinyRedLight then
      self.ui.destinyRedLight:setVisible(true)
      return
    end
    local btnRedLight = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
    btnRedLight:setPosition(ccp(62, 57))
    self.ui.btn2:addChild(btnRedLight, 3)
    self.ui.destinyRedLight = btnRedLight
  elseif self.ui.destinyRedLight then
    self.ui.destinyRedLight:removeFromParentAndCleanup(true)
    self.ui.destinyRedLight = nil
  end
end

function SummonScene:refreshTimelyRedLight(isShow)
  local BuilddingType = ed.ui.configs.mainSceneMap.builddingType
  FireEvent("MainBuildRedTagChange", BuilddingType.Summon)
  if self.ui.timelyRedLight then
    self.ui.timelyRedLight:setVisible(isShow)
    self.ui.timelyBtnRedLight:setVisible(isShow)
    return
  end
  if isShow then
    local redLight = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
    redLight:setPosition(ccp(70, 68))
    self.ui.timely_icon:addChild(redLight)
    self.ui.timelyRedLight = redLight
    local eff = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
    eff:setPosition(-26, -25)
    eff:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
    redLight:addChild(eff, 9)
    local btnRedLight = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
    btnRedLight:setPosition(ccp(80, 27))
    self.ui.btn3:addChild(btnRedLight, 3)
    self.ui.timelyBtnRedLight = btnRedLight
  end
end

function SummonScene:initNewbieLayer()
  self.isNewbieSummonOpen = ed.getServerTime() < ed.summonMgr.newbieEndTime
  self.ui.btn4:setVisible(self.isNewbieSummonOpen)
  self.curNewbieHeroId = ed.summonMgr.newbieHeroId
  self.hadGetNewbieReward = ed.summonMgr.newbieRewardFlag == 1
  self.newbieEndTime = ed.time2dhmsV2(ed.summonMgr.newbieEndTime - ed.getServerTime())
  self.newbieMaxProgress = 80
  self.newbieProgress = ed.summonMgr.newbieSummonCount
  self.ui.label_newbie_time:setString(self.newbieEndTime)
  if not self.newbieLabel then
    local newbieLabel = ed.ui.gradientLabel.create({
      text = T("\232\135\170\233\128\137\232\139\177\233\155\132"),
      fontSize = 36,
      fontName = ed.fontBold,
      startColor = ed.toccc3(16776677),
      endColor = ed.toccc3(16768914),
      strokeSize = 2,
      strokeColor = ed.toccc3(13728007),
      shadowColor = ed.toccc3(9191464),
      shadowOffset = ccp(0, -1.7)
    })
    newbieLabel.node:setPosition(ccp(247.5, 75.75))
    self.ui.bg_newbie_info:addChild(newbieLabel.node)
    self.newbieLabel = newbieLabel
  end
  ed.layout.horizontalSortNode({
    self.newbieLabel.node,
    self.ui.newbie_info4
  }, {10, 0}, self.ui.bg_newbie_info:getContentSize().width * 0.5)
  if self.curNewbieHeroId then
    self.ui.icon_newbie:setVisible(false)
    self.ui.newbie_info1:setVisible(true)
    self.ui.newbie_info2:setVisible(true)
    self.ui.newbie_info3:setVisible(true)
    self.newbieLabel.node:setVisible(false)
    self.ui.bg_newbie_reward:setVisible(true)
    local heroName = ed.getDataTable("Unit")[self.curNewbieHeroId]["Display Name"]
    local newbieHeroName = ed.ui.gradientLabel.create({
      text = heroName,
      fontSize = 42.5,
      fontName = ed.fontBold,
      startColor = ed.toccc3(16776677),
      endColor = ed.toccc3(16768914),
      strokeSize = 3,
      strokeColor = ed.toccc3(13728007),
      shadowColor = ed.toccc3(9191464),
      shadowOffset = ccp(0, -1.7)
    })
    local width = (newbieHeroName:getContentSize().width - self.ui.newbie_info3:getContentSize().width) / 2
    ed.UITool.replaceUINew(self.ui, "newbie_info3", newbieHeroName.node)
    ed.layout.horizontalSortNode({
      self.ui.newbie_info1,
      self.ui.newbie_info2,
      self.ui.newbie_info3,
      self.ui.newbie_info4
    }, {
      2,
      2,
      2,
      0
    }, self.ui.bg_newbie_info:getContentSize().width * 0.5)
    local icon = ed.readhero.createIcon({
      id = self.curNewbieHeroId,
      stars = 3,
      rank = 1
    }).icon
    self.ui.newbie_icon = icon
    self.ui.bg_newbie_reward:addChild(icon)
    ed.layout.centerInParent(icon)
    if not self.hadGetNewbieReward then
      local str = self:getNewbieDesc()
      local autoText = ed.ui.autoText.new()
      autoText:initParam({fontSize = 15, context = str})
      local width, height = autoText:getCurContentSize()
      ed.UITool.replaceUI(self.ui, "ImageView_19131", "Label_19141", autoText.node)
      local scale = 1
      if 130 < width then
        scale = 130 / width
        autoText.node:setScale(scale)
      end
      autoText.node:setPositionX(67.5 - width / 2 * scale)
      if self.newbieProgress >= self.newbieMaxProgress then
        self:refreshNewbieRedLight(true)
      end
    else
      local mask = CCLayerColor:create(ccc4(0, 0, 0, 150))
      mask:setContentSize(CCSizeMake(76, 76))
      mask:setPosition(ccp(-3, -3.5))
      local selectIcon = ed.createSprite("UI/alpha/1080P/package/selected.png")
      selectIcon:setPosition(ccp(38, 38))
      mask:addChild(selectIcon)
      mask:setZOrder(1)
      icon:addChild(mask)
    end
  else
    self.ui.bg_newbie_reward:setVisible(false)
    if not self.newbieExtraFca then
      self.newbieExtraFca = ed.createFcaNode("eff_UI_SummonBeginner_StarCircle")
      self.ui.icon_newbie:addChild(self.newbieExtraFca, -1)
      ed.layout.centerInParent(self.newbieExtraFca)
      self:addFca(self.newbieExtraFca)
    end
  end
end

function SummonScene:checkNewbieRecommend()
  if self.tabName ~= "newbie" or self.curNewbieHeroId then
    return
  end
  if 0 == #ed.summonMgr.newbieHotHeroes then
    return
  end
  local lastTime = ed.summonMgr:getLastNewbieRecommendTime()
  local curTime = ed.getServerTime()
  local checkTime
  if curTime - lastTime < 86400 then
    local h, m, s = ed.time2HMS(curTime)
    checkTime = curTime - (h * 3600 + m * 60 + s) + 18000
    if curTime < checkTime then
      checkTime = checkTime - 86400
    end
  else
    checkTime = curTime
  end
  if lastTime >= checkTime then
    return
  end
  ed.summonMgr:updateLastNewbieRecommendTime()
  ListenTimer(Timer:Once(0.01), function()
    ed.ui.summonNewbieRecommendWin.create()
  end, self.eventScope)
end

function SummonScene:initTimelyLayer()
  local activityData = ed.activityHints.activityData or {}
  self.isTimelySummonOpen = false
  for k, v in ipairs(activityData) do
    if v._type == "timely_summon" and v._start_time < ed.getServerTime() and ed.getServerTime() < v._end_time then
      self.isTimelySummonOpen = true
      self.timelyStartTime = v._start_time
      self.timelyEndTime = ed.time2dhmsV2(v._end_time - ed.getServerTime())
      local task = v._tasks[1]
      self.timelyProgress = task._progress
      self.timelyMaxProgress = task._cond_target
      self.hadGetTimelyReward = task._last_rewards_time and task._last_rewards_time > 0
      self.timelyTitleRes = ed.getDataTable("Activity")[v._cfg_id]["Title Picture"]
      self.timelyHeroNameRes = ed.getDataTable("Activity")[v._cfg_id].Banner
      self.timelyActName = ed.getDataTable("Activity")[v._cfg_id]["Activity Name"]
      self.curTimelyHeroId = task._rewards[1]._id
      self.timelyActId = v._id
      self.taskId = task._id
      break
    end
  end
  self.ui.btn3:setVisible(self.isTimelySummonOpen)
  if self.isTimelySummonOpen then
    self:initTimelyDesc()
    ed.layout.horizontalSortNode({
      self.ui.timely_info1,
      self.ui.timely_info2,
      self.timelyHeroName.node,
      self.ui.timely_info4
    }, {
      5,
      5,
      5,
      0
    }, self.ui.bg_timely_info:getContentSize().width * 0.5)
    local icon = ed.readhero.createIcon({
      id = self.curTimelyHeroId,
      stars = 3,
      rank = 1
    }).icon
    self.ui.timely_icon = icon
    self.ui.bg_timely_reward:addChild(icon)
    ed.layout.centerInParent(icon)
    self.ui.label_timely_time:setString(self.timelyEndTime)
    local tipSize = ed.isAreaZh() and 11 or 14
    local labelTip = ed.createLabelTTF(T("\232\191\155\229\186\166\229\176\134\229\156\168\230\156\172\230\177\160\231\187\147\230\157\159\229\144\142\230\184\133\233\155\182"), tipSize)
    ed.setLabelColor(labelTip, ed.toccc3(16774047))
    ed.setLabelStroke(labelTip, ed.toccc3(4404526), 1)
    labelTip:setPosition(ccp(67, 0))
    labelTip:limitSizeByScale(165, 35)
    labelTip:setAnchorPoint(ccp(0.5, 1))
    self.ui.ImageView_1913:addChild(labelTip)
    if not self.hadGetTimelyReward then
      local str = self:getTimelyDesc()
      local autoText = ed.ui.autoText.new()
      autoText:initParam({fontSize = 15, context = str})
      local width, height = autoText:getCurContentSize()
      ed.UITool.replaceUI(self.ui, "ImageView_1913", "Label_1914", autoText.node)
      local scale = 1
      if 130 < width then
        scale = 130 / width
        autoText.node:setScale(scale)
      end
      autoText.node:setPositionX(67.5 - width * 0.5 * scale)
      if self.timelyProgress >= self.timelyMaxProgress then
        self:refreshTimelyRedLight(true)
      end
    else
      local mask = CCLayerColor:create(ccc4(0, 0, 0, 150))
      mask:setContentSize(CCSizeMake(76, 76))
      mask:setPosition(ccp(-3, -3.5))
      local selectIcon = ed.createSprite("UI/alpha/1080P/package/selected.png")
      selectIcon:setPosition(ccp(38, 38))
      mask:addChild(selectIcon)
      mask:setZOrder(1)
      icon:addChild(mask)
    end
    ed.UITool.registerBtn(self, "timely_icon", function()
      if not self.hadGetTimelyReward and self.timelyProgress >= self.timelyMaxProgress then
        ed.ActivityNetwork:activitySubmit(self.timelyActId, self.taskId)
      end
    end)
  end
end

function SummonScene:initTimelyDesc()
  if self.timelyHeroName and not tolua.isnull(self.timelyHeroName.node) then
    self.timelyHeroName.node:removeFromParentAndCleanup(true)
  end
  local heroName = ed.getDataTable("Unit")[self.curTimelyHeroId]["Display Name"]
  local timelyHeroName = ed.ui.gradientLabel.create({
    text = heroName,
    fontSize = 42.5,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16776677),
    endColor = ed.toccc3(16768914),
    strokeSize = 3,
    strokeColor = ed.toccc3(13728007),
    shadowColor = ed.toccc3(9191464),
    shadowOffset = ccp(0, -1.7)
  })
  self.ui.bg_timely_info:addChild(timelyHeroName.node)
  timelyHeroName.node:setPosition(ccp(317, 75))
  local nameWid = timelyHeroName.node:getContentSize().width
  if 230 < nameWid then
    timelyHeroName.node:setScale(230 / nameWid)
  end
  self.timelyHeroName = timelyHeroName
  if self.timelyTitle and not tolua.isnull(self.timelyTitle.node) then
    self.timelyTitle.node:removeFromParentAndCleanup(true)
  end
  local timelyTitle = ed.ui.gradientLabel.create({
    text = self.timelyActName,
    fontSize = 42.5,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16776677),
    endColor = ed.toccc3(16768914),
    strokeSize = 3,
    strokeColor = ed.toccc3(13728007),
    shadowColor = ed.toccc3(9191464),
    shadowOffset = ccp(0, -1.7)
  })
  self.ui.bg_timely_title:addChild(timelyTitle.node)
  ed.layout.centerInParent(timelyTitle.node)
  self.timelyTitle = timelyTitle
end

function SummonScene:initDestinyLayer()
  local summonDestinyTb = ed.getDataTable("SummonDestiny")
  local items = {}
  for k, v in pairs(summonDestinyTb) do
    if type(k) == "number" then
      if v["Show Item"] and v["Show Item"] ~= 0 then
        local item = {
          id = v["Show Item"],
          weight = v.Weight,
          perc = string.format("%.1f%%", v["Show chance"] * 100),
          amount = ed.getDataTable("SummonDestinyGroup")[v["Reward Group ID"]][1]["Fixed Amount"]
        }
        table.insert(items, item)
      else
        self.destinyPercStr = string.format("%.1f%%", v["Show chance"] * 100)
      end
    end
  end
  table.sort(items, function(a, b)
    return a.weight < b.weight
  end)
  for i = 1, 6 do
    if items[i] then
      self.ui["bg_icon" .. i]:setVisible(true)
      local icon = ed.createItemIcon({
        id = tonumber(items[i].id),
        amount = tonumber(items[i].amount)
      })
      icon:setScale(0.6)
      ed.UITool.replaceUI(self.ui, "bg_icon" .. i, "icon" .. i, icon)
      ed.setString(self.ui["percent" .. i], items[i].perc)
      ed.setLabelStroke(self.ui["percent" .. i], ed.toccc3(6888572), 1)
      self:btRegisterButtonClick({
        button = icon,
        key = "tIcon" .. i,
        clickHandler = function()
          if items[i].id and items[i].id ~= 0 then
            ed.ui.packageDetailWin.create({
              id = tonumber(items[i].id)
            }):popWindow()
          end
        end,
        force = true
      })
    else
      self.ui["bg_icon" .. i]:setVisible(false)
    end
  end
  self:refreshDesHero()
end

function SummonScene:refreshDesHero()
  ed.setLabelStroke(self.ui.per_destiny, ed.toccc3(15482235), 1)
  ed.setString(self.ui.per_destiny, self.destinyPercStr)
  if ed.summonMgr.destinyTid then
    local icon = ed.readhero.getIcon({
      id = ed.summonMgr.destinyTid
    })
    ed.UITool.replaceUI(self.ui, "icon_hero", "ImageView_1277", icon)
  else
    local icon = ed.createSprite("UI/alpha/1080P/summondestiny/destiny_add.png")
    ed.UITool.replaceUI(self.ui, "icon_hero", "ImageView_1277", icon)
  end
end

function SummonScene:hideUI(isHide)
  self.container:setVisible(not isHide)
  self.back_button:setVisible(not isHide)
  self.baseui.right_top_panel:setVisible(not isHide)
  self.baseui.right_bottom_panel:setVisible(not isHide)
end

function SummonScene:updateWishList()
  if not ed.summonMgr:wishListIsOpened() then
    return
  end
  local list = ed.summonMgr:getWishList()
  if ed.tableIsNilOrEmpty(list) then
    return
  end
  for i = 1, 2 do
    local data = list[i]
    local item = self.ui["item_" .. i]
    self:clearItemAt(i)
    if data and data._hero > 0 then
      item:setVisible(false)
      local x, y = item:getPosition()
      item = ed.readhero.getIcon({
        id = data._hero,
        stars = 3,
        length = 75
      })
      item:setPosition(x, y)
      if (not data or not (0 < data._succeeded)) and ed.readhero.checkHeroMaxStar(data._hero) then
        local size = item:getContentSize()
        local flag = ed.createSprite("UI/alpha/1080P/summon/summon_hero_star_max.png")
        flag:setPosition(size.width / 2, size.height / 2 + 22)
        flag:setPosition(size.width / 2, size.height / 2 + 22)
        local label_star = ed.createttf(T("\229\183\178\230\187\161\230\152\159"), 15, ed.fontBold)
        label_star:limitWidthByScale(size.width - 5)
        ed.setLabelColor(label_star, ed.toccc3(16775796))
        ed.setLabelStroke(label_star, ed.toccc3(9978880), 1)
        flag:addChild(label_star)
        ed.layout.centerInParent(label_star)
        item:addChild(flag)
      end
      if 0 < data._succeeded then
        local flagLayer = CCLayerColor:create(ccc4(0, 0, 0, 150))
        local size = item:getContentSize()
        size.width = size.width + 5.5
        size.height = size.height + 7
        flagLayer:setContentSize(size)
        item:addChild(flagLayer)
        ed.layout.centerInParent(flagLayer)
        local x, y = flagLayer:getPosition()
        flagLayer:setPosition(x - 2.5, y - 4)
        local ttf = ed.createSprite("UI/alpha/1080P/summon/summon_hero_pass.png")
        flagLayer:addChild(ttf)
        ed.layout.centerInParent(ttf)
        local completeLabel = EDCurLanguage == "en" and "Acquired" or T("\229\183\178\232\190\190\230\136\144")
        local label_pass = ed.createttf(completeLabel, 15, ed.fontBold)
        ed.setLabelColor(label_pass, ed.toccc3(11202661))
        ed.setLabelStroke(label_pass, ed.toccc3(874533), 1)
        ttf:addChild(label_pass)
        ed.layout.centerInParent(label_pass)
      end
      self.ui.wish_heros_root:addChild(item)
      self.wishItems[i] = item
    else
      item:setVisible(true)
      ed.initSpriteWithFrame(self.ui["lock_" .. i], "UI/alpha/1080P/summon/summon_list_add.png")
      ed.setTexture(self.ui["lock_" .. i], "UI/alpha/1080P/summon/summon_list_add.png")
      if self.wishItems[i] then
        self.wishItems[i]:removeFromParentAndCleanup(true)
        self.wishItems[i] = nil
      end
    end
    self:btRegisterButtonClick({
      button = item,
      key = "wish_" .. i,
      clickHandler = function(_, x, y)
        ed.playEffect(ed.sound.deo.common_back)
        if not ed.summonMgr:wishListIsOpened() then
          ed.showToast(T("\229\134\141\229\143\172\229\148\164%d\230\172\161\229\188\128\230\148\190\239\188\129", self.ui.text_value:getString()))
          return
        end
        ed.ui.summonWishWindow:create():popWindow()
      end,
      force = true,
      clickInterval = 0.5,
      priority = -1
    })
  end
end

function SummonScene:getCurPageTicket()
  local ticketId = ed.summonMgr:getNormalCfgConstant("Use Ticket")
  if self.tabName == "destiny" then
    ticketId = ed.summonMgr:getDestinyCfgConstant("Use Ticket")
  elseif self.tabName == "timely" or self.tabName == "newbie" then
    ticketId = ed.summonMgr:getNormalCfgConstant("Timely Ticket")
  end
  local ticketNum = ed.player:getEquipAmount(ticketId)
  return ticketId, ticketNum
end

function SummonScene:updateTicketNum(num)
  local ticketId, ticketNum = self:getCurPageTicket()
  ticketNum = ticketNum + (num or 0)
  local isRed = ticketNum < 1
  self.ui.once_res_nun:setColor(ccc3(ed.colorToStr(isRed and "#FF0005" or "#FFFCE7")))
  isRed = ticketNum < 10
  self.ui.ten_res_nun:setColor(ccc3(ed.colorToStr(isRed and "#FF0005" or "#FFFCE7")))
end

function SummonScene:initNormalLayer()
  local summonCount = ed.summonMgr:getNormalSummonCount() or 0
  local pre10Flag = not ed.summonMgr:isHad3StarHero() and summonCount <= 10
  self.ui.desc_text_1:setVisible(pre10Flag)
  self.ui.desc_text_2:setVisible(not pre10Flag)
  self:updateTicketNum()
  self.ui.desc_value_root:removeAllChildrenWithCleanup(true)
  local luckpoint = tostring(ed.summonMgr:getLuckyPoint())
  local luckNumber = ed.getNumberNode({
    text = pre10Flag and "10" or luckpoint,
    folder = "recharge_gift",
    padding = -14
  }).node
  luckNumber:setPosition(32, -4)
  self.ui.desc_value_root:addChild(luckNumber)
  local posConf = multiLanPosConfig[ed.getCurArea()] or multiLanPosConfig.cn
  self.ui.desc_value_root:setPositionX(-155)
  ed.UITool.setPositionBy(self.ui.desc_value_root, posConf[(pre10Flag and "pre10_" or "") .. "Pos"])
  local visible = not ed.summonMgr:wishListIsOpened()
  self.ui.text_tips_bg:setVisible(visible)
  self.ui.btn_change_img_up:setVisible(visible)
  if EDCurLanguage == "ja" then
    self.ui.label_wish_list:setString("\227\130\166\227\130\163\227\131\131\227\130\183\227\131\165\n\227\131\170\227\130\185\227\131\136")
    self.ui.label_wish_list:setHorizontalAlignment(kCCTextAlignmentCenter)
  end
  self.ui.label_wish_list:limitWidthByScale(80)
  local needcount = ed.summonMgr:getNormalCfgConstant("Wish List UnLock Times") - summonCount
  if visible and 0 < needcount then
    self.ui.text_value:setString(needcount)
    local totalWidth = ed.layout.horizontalSortNode({
      self.ui.text_tips,
      self.ui.text_value,
      self.ui.text_tips1
    }, {
      2,
      2,
      0
    }, self.ui.text_tips_bg:getContentSize().width * 0.5)
    if 145 < totalWidth then
      local scale = 145 / totalWidth
      self.ui.text_tips:setScale(scale)
      self.ui.text_value:setScale(scale)
      self.ui.text_tips1:setScale(scale)
      ed.layout.horizontalSortNode({
        self.ui.text_tips,
        self.ui.text_value,
        self.ui.text_tips1
      }, {
        2,
        2,
        0
      }, self.ui.text_tips_bg:getContentSize().width * 0.5)
    end
  end
  self:updateWishList()
  if needcount <= 0 then
    FireEvent(ed.guide.eventNames.FUNCTION_OPEN, "WishList")
  end
end

local getResType = ed.ui.configs.resType.getResType

function SummonScene:doNormalSummon(times)
  local ticketId = ed.summonMgr:getNormalCfgConstant("Use Ticket")
  local ticketCost = ed.summonMgr:getNormalCfgConstant("Ticket Value")
  local ticketNum = ed.player:getEquipAmount(ticketId)
  if times > ticketNum then
    self.ui.summon:setVisible(false)
    local buyResourceBox = ed.ui.buyResourceBox.create({
      buyLimitNum = 100,
      defaultBuyNum = times - ticketNum,
      goodsResType = getResType("item"),
      goodsId = ticketId,
      costResType = getResType("diamond"),
      price = ticketCost,
      buyAction = function(num)
        if num <= 0 then
          return
        end
        ed.summonNet:send("buy_ticket", {_ticket_amount = num, _type = "normal"})
      end,
      callback = function(num)
        self.ui.summon:setVisible(true)
      end
    })
    buyResourceBox.ui.text_buy_num_limit:setVisible(false)
    buyResourceBox:popWindow()
    return
  end
  if times == 1 then
    ed.summonNet:send("summon", {_summon_times = 1, _type = "normal"})
    self.summonMethod = "one"
    ed.summonMgr:setUserNormalSummonCount(ed.summonMgr:getNormalSummonCount() + 1)
  else
    ed.summonNet:send("summon", {_summon_times = 10, _type = "normal"})
    self.summonMethod = "ten"
    ed.summonMgr:setUserNormalSummonCount(ed.summonMgr:getNormalSummonCount() + 10)
  end
end

function SummonScene:doDestinySummon(times)
  if not ed.summonMgr.destinyTid then
    ed.showToast(T("\229\176\154\230\156\170\233\128\137\230\139\169\229\145\189\229\174\154\232\139\177\233\155\132!"))
    return
  end
  local ticketNum = ed.player:getEquipAmount(ed.summonMgr.destinyItemId)
  if times > ticketNum then
    ed.showToast(T("\229\145\189\229\174\154\229\141\183\228\184\141\232\182\179\239\188\140\232\175\183\229\142\187\229\149\134\229\159\142\232\180\173\228\185\176"))
    return
  end
  if times == 1 then
    ed.summonNet:send("summon", {_summon_times = 1, _type = "destiny"})
    self.summonMethod = "one"
    ed.summonMgr.tmpDestinyTotal = ed.summonMgr.destinySummonCount + 1
  else
    ed.summonNet:send("summon", {_summon_times = 10, _type = "destiny"})
    self.summonMethod = "ten"
    ed.summonMgr.tmpDestinyTotal = ed.summonMgr.destinySummonCount + 10
  end
end

function SummonScene:doNewbieSummon(times)
  if not self.curNewbieHeroId then
    ed.showToast(T("\232\175\183\229\133\136\232\135\170\233\128\137\232\139\177\233\155\132"))
    return
  end
  local ticketNum = ed.player:getEquipAmount(ed.summonMgr.newbieItemId)
  if times > ticketNum then
    self.ui.summon:setVisible(false)
    local buyResourceBox = ed.ui.buyResourceBox.create({
      buyLimitNum = 100,
      defaultBuyNum = times - ticketNum,
      goodsResType = getResType("item"),
      goodsId = ed.summonMgr.newbieItemId,
      costResType = getResType("diamond"),
      price = ed.summonMgr.newbieItemCost,
      buyAction = function(num)
        if num <= 0 then
          return
        end
        ed.summonNet:send("buy_ticket", {_ticket_amount = num, _type = "beginner"})
      end,
      callback = function(num)
        self.ui.summon:setVisible(true)
      end
    })
    buyResourceBox.ui.text_buy_num_limit:setVisible(false)
    buyResourceBox:popWindow()
    return
  end
  if times == 1 then
    ed.summonNet:send("summon", {_summon_times = 1, _type = "beginner"})
    ed.summonMgr.tmpNewbieSummonCount = ed.summonMgr.newbieSummonCount + 1
    self.summonMethod = "one"
  else
    ed.summonNet:send("summon", {_summon_times = 10, _type = "beginner"})
    ed.summonMgr.tmpNewbieSummonCount = ed.summonMgr.newbieSummonCount + 10
    self.summonMethod = "ten"
  end
end

function SummonScene:doTimelySummon(times)
  local ticketNum = ed.player:getEquipAmount(ed.summonMgr.timelyItemId)
  if times > ticketNum then
    self.ui.summon:setVisible(false)
    local buyResourceBox = ed.ui.buyResourceBox.create({
      buyLimitNum = 100,
      defaultBuyNum = times - ticketNum,
      goodsResType = getResType("item"),
      goodsId = ed.summonMgr.timelyItemId,
      costResType = getResType("diamond"),
      price = ed.summonMgr.timelyItemCost,
      buyAction = function(num)
        if num <= 0 then
          return
        end
        ed.summonNet:send("buy_ticket", {_ticket_amount = num, _type = "timely"})
      end,
      callback = function(num)
        self.ui.summon:setVisible(true)
      end
    })
    buyResourceBox.ui.text_buy_num_limit:setVisible(false)
    buyResourceBox:popWindow()
    return
  end
  if times == 1 then
    ed.summonNet:send("summon", {_summon_times = 1, _type = "timely"})
    ed.summonMgr.tmpTimelySummonCount = ed.summonMgr.timelySummonCount + 1
    self.summonMethod = "one"
  else
    ed.summonNet:send("summon", {_summon_times = 10, _type = "timely"})
    ed.summonMgr.tmpTimelySummonCount = ed.summonMgr.timelySummonCount + 10
    self.summonMethod = "ten"
  end
end

function SummonScene:doRiseStarSummon(times)
  if not self.curRiseStarHeroId then
    ed.showToast(T("\232\175\183\229\133\136\232\135\170\233\128\137\232\139\177\233\155\132"))
    return
  end
  local ticketNum = ed.player:getEquipAmount(ed.summonMgr.riseStarItemId)
  if times > ticketNum then
    self.ui.summon:setVisible(false)
    local buyResourceBox = ed.ui.buyResourceBox.create({
      buyLimitNum = 100,
      defaultBuyNum = times - ticketNum,
      goodsResType = getResType("item"),
      goodsId = ed.summonMgr.riseStarItemId,
      costResType = getResType("diamond"),
      price = ed.summonMgr.riseStarItemCost,
      buyAction = function(num)
        if num <= 0 then
          return
        end
        ed.summonNet:send("buy_ticket", {_ticket_amount = num, _type = "rise_star"})
      end,
      callback = function(num)
        self.ui.summon:setVisible(true)
      end
    })
    buyResourceBox.ui.text_buy_num_limit:setVisible(false)
    buyResourceBox:popWindow()
    return
  end
  if times == 1 then
    ed.summonNet:send("summon", {_summon_times = 1, _type = "rise_star"})
    ed.summonMgr.tmpRiseStarSummonCount = ed.summonMgr.rise_starSummonCount + 1
    self.summonMethod = "one"
  else
    ed.summonNet:send("summon", {_summon_times = 10, _type = "rise_star"})
    ed.summonMgr.tmpRiseStarSummonCount = ed.summonMgr.rise_starSummonCount + 10
    self.summonMethod = "ten"
  end
end

function SummonScene:doSummon(times)
  if self.tabName == "normal" then
    self:doNormalSummon(times)
  elseif self.tabName == "destiny" then
    self:doDestinySummon(times)
  elseif self.tabName == "timely" then
    self:doTimelySummon(times)
  elseif self.tabName == "newbie" then
    self:doNewbieSummon(times)
  elseif self.tabName == "riseStar" then
    self:doRiseStarSummon(times)
  end
end

function SummonScene:clearItemAt(idx)
  local item = self.wishItems[idx]
  if item then
    item:removeFromParentAndCleanup(true)
    self.wishItems[idx] = nil
  end
end

local QualityColors = {
  "green",
  "blue",
  "purple",
  "gold"
}
local QualityTimes = {gold = 7.4}
SummonScene.QualityColors = QualityColors

function SummonScene:refreshLayer()
  self.curScreenFca:setVisible(false)
  for k, v in ipairs(pageConfig) do
    self.ui["layer" .. k]:setVisible(k == self.pageIndex)
    self.ui["btn" .. k .. "_selected"]:setVisible(k == self.pageIndex)
  end
  ed.setTexture(self.ui.once_res_icon, pageConfig[self.pageIndex].iconRes)
  ed.setTexture(self.ui.ten_res_icon, pageConfig[self.pageIndex].iconRes)
  self:setBackground(pageConfig[self.pageIndex].bgRes)
  self.curScreenFca = self.summonFcaList[self.pageIndex]
  self.curScreenFca:setVisible(true)
  self.riseStarFca:setVisible(self.pageIndex == 5)
  self:updateTicketNum()
  self:updateBtnRulePos()
  self:checkNewbieRecommend()
  self:checkRiseStarRecommend()
end

function SummonScene:activityReply(infos)
  local info = ed.copyProto(infos)
  if info._task_submit then
    if info._task_submit._act_id ~= self.timelyActId then
      return
    end
    local activityData = ed.activityHints.activityData or {}
    for k, v in ipairs(activityData) do
      if v._type == "timely_summon" then
        local task = v._tasks[1]
        if task then
          task._last_rewards_time = ed.getServerTime()
        end
      end
    end
    self.hadGetTimelyReward = true
    self:refreshTimelyRedLight(false)
    local mask = CCLayerColor:create(ccc4(0, 0, 0, 150))
    mask:setContentSize(CCSizeMake(76, 76))
    mask:setPosition(ccp(-1, -1.5))
    local selectIcon = ed.createSprite("UI/alpha/1080P/package/selected.png")
    selectIcon:setPosition(ccp(38, 38))
    mask:addChild(selectIcon)
    mask:setZOrder(1)
    self.ui.timely_icon:addChild(mask)
    local str = self:getTimelyDesc()
    local autoText = ed.ui.autoText.new()
    autoText:initParam({fontSize = 15, context = str})
    local width, height = autoText:getCurContentSize()
    ed.UITool.replaceUI(self.ui, "ImageView_1913", "Label_1914", autoText.node)
    local atWid, _ = autoText:getCurContentSize()
    local scale = 1
    if 130 < atWid then
      scale = 130 / atWid
      autoText.node:setScale(scale)
    end
    autoText.node:setPositionX(67.5 - atWid * 0.5 * scale)
    ed.player:addRewards(info._task_submit._rewards or {})
    local items = {}
    for i, v in ipairs(info._task_submit._rewards or {}) do
      if v._type ~= "hero" then
        table.insert(items, v)
      end
    end
    if 0 < #items then
      ed.UITool.showRewardsFromServer(items)
    elseif info._task_submit._task and info._task_submit._task._rewards then
      local items = {}
      for i, v in ipairs(info._task_submit._task._rewards) do
        if v._type ~= "hero" then
          table.insert(items, v)
        end
      end
      if 0 < #items then
        ed.UITool.showRewardsFromServer(items)
      end
    end
  end
end

function SummonScene:addEventListener()
  ed.UITool.registerBtn(self, "btn_tips", function()
    if self.tabName == "normal" then
      ed.ui.summonRuleTips.create({}):popWindow()
    elseif self.tabName == "destiny" then
      ed.ui.commonRulePop.create({
        title = T("\232\167\132\229\136\153\232\175\180\230\152\142"),
        txt = ed.ui.summonDestinyRule.strPage2
      }):popWindow()
    elseif self.tabName == "timely" then
      ed.ui.commonRulePop.create({
        title = T("\232\167\132\229\136\153\232\175\180\230\152\142"),
        txt = ed.ui.summonTimelyRule.strPage2
      }):popWindow()
    elseif self.tabName == "newbie" then
      ed.ui.commonRulePop.create({
        title = T("\232\167\132\229\136\153\232\175\180\230\152\142"),
        txt = ed.ui.summonNewbieRule.strPage2
      }):popWindow()
    elseif self.tabName == "riseStar" then
      ed.ui.commonRulePop.create({
        title = T("\232\167\132\229\136\153\232\175\180\230\152\142"),
        txt = ed.ui.summonRiseStarRule.strPage2
      }):popWindow()
    end
  end)
  ed.UITool.registerBtn(self, "btn_pdf_detail", function()
    ed.openURL("https://d-jp.farlightgames.com/probability/")
  end, {pressScale = 0.72, normalScale = 0.8})
  ed.UITool.registerBtn(self, "bg_newbie_reward", function()
    if not self.hadGetNewbieReward and self.newbieMaxProgress <= self.newbieProgress then
      ed.summonNet:send("take_rewards", {_type = "beginner"})
    end
  end)
  ed.UITool.registerBtn(self, "bg_riseStar_reward", function()
    if not self.hadGetRiseStarReward and self.riseStarMaxProgress <= self.riseStarProgress then
      ed.summonNet:send("take_rewards", {_type = "rise_star"})
    end
  end)
  ed.UITool.registerBtn(self, "btn_skip", function()
    ed.stopAllEffects()
    CloseTimer("animationTimer1")
    CloseTimer("animationTimer2")
    self.ui.btn_skip:setVisible(false)
    self.ui.summon:setVisible(false)
    local reward = {}
    for i, v in ipairs(self.latestData.rewards) do
      if v.type == "hero" and not self.latestData.convertIdxs[i] then
        table.insert(reward, v)
      end
    end
    if 0 < #reward then
      ed.ui.SummonRewardCardWindow.create({
        rewards = self.latestData.rewards,
        convertIdxs = self.latestData.convertIdxs,
        doSummon = function(times)
          self:doSummon(times)
        end,
        tabName = self.tabName,
        addHero = reward,
        callback = function(num)
          self.ui.summon:setVisible(true)
        end
      }):popWindow()
    else
      ed.ui.SummonRewardsWindow.create({
        rewards = self.latestData.rewards,
        convertIdxs = self.latestData.convertIdxs,
        tabName = self.tabName,
        summonAction = function(times)
          self:doSummon(times)
        end,
        callback = function(num)
          self.ui.summon:setVisible(true)
        end
      }):popWindow()
    end
    if self.tabName == "normal" then
      self:initNormalLayer()
    end
    self:hideUI(false)
    if not tolua.isnull(self.playedFca) then
      self.playedFca:removeFromParentAndCleanup(true)
    end
    self.curScreenFca:setAction("Start")
  end)
  self:registerBtnClick("btn_summon_once", function()
    self:doSummon(1)
  end, {mcp_dis = nil})
  self:registerBtnClick("btn_summon_ten", function()
    self:doSummon(10)
  end, {mcp_dis = nil})
  ed.UITool.registerBtn(self, "btn_change", function()
    if not ed.summonMgr:wishListIsOpened() then
      ed.showToast(T("\229\134\141\229\143\172\229\148\164%d\230\172\161\229\188\128\230\148\190\239\188\129", self.ui.text_value:getString()))
      return
    end
    ed.ui.summonWishWindow:create():popWindow()
  end)
  ed.UITool.registerBtn(self, "btn_change_1", function()
    ed.ui.summonDestinyWindow.create({
      callback = function()
        self:refreshDesHero()
      end
    }):popWindow()
  end)
  ed.UITool.registerBtn(self, "icon_hero", function()
    ed.ui.summonDestinyWindow.create({
      callback = function()
        self:refreshDesHero()
      end
    }):popWindow()
  end)
  self:listenEvent("SummonClearWish", function()
    self:refreshDesHero()
    self:updateWishList()
  end)
  self:listenEvent("scope_activity_reply", function(info)
    self:activityReply(info)
  end)
  self:listenEvent("TimelySummonRefresh", function(data)
    self.timelyProgress = self.timelyProgress + data
    if not self.hadGetTimelyReward then
      local str = self:getTimelyDesc()
      local autoText = ed.ui.autoText.new()
      autoText:initParam({fontSize = 15, context = str})
      local width, height = autoText:getCurContentSize()
      ed.UITool.replaceUI(self.ui, "ImageView_1913", "Label_1914", autoText.node)
      local atWid, _ = autoText:getCurContentSize()
      local scale = 1
      if 130 < atWid then
        scale = 130 / atWid
        autoText.node:setScale(scale)
      end
      autoText.node:setPositionX(67.5 - atWid * 0.5 * scale)
      if self.timelyProgress >= self.timelyMaxProgress then
        self:refreshTimelyRedLight(true)
      end
    end
  end)
  self:listenEvent("SummonNewbieGetReward", function(msg)
    self.hadGetNewbieReward = true
    local mask = CCLayerColor:create(ccc4(0, 0, 0, 150))
    mask:setContentSize(CCSizeMake(76, 76))
    mask:setPosition(ccp(-1, -1.5))
    local selectIcon = ed.createSprite("UI/alpha/1080P/package/selected.png")
    selectIcon:setPosition(ccp(38, 38))
    mask:addChild(selectIcon)
    mask:setZOrder(1)
    self.ui.newbie_icon:addChild(mask)
    ed.summonMgr:setCircleRed(0)
    self:refreshNewbieRedLight(false)
    local str = self:getNewbieDesc()
    local autoText = ed.ui.autoText.new()
    autoText:initParam({fontSize = 15, context = str})
    local width, height = autoText:getCurContentSize()
    ed.UITool.replaceUI(self.ui, "ImageView_19131", "Label_19141", autoText.node)
    local scale = 1
    if 130 < width then
      scale = 130 / width
      autoText.node:setScale(scale)
    end
    autoText.node:setPositionX(67.5 - width * 0.5 * scale)
    ed.player:addRewards(msg._reward or {})
    ed.UITool.showRewardsFromServer(msg._reward or {})
  end)
  self:listenEvent("SummonNewbieSelectSuccess", function(result)
    if result then
      self:initNewbieLayer()
      local fca = self.summonFcaList[4]
      if self.curNewbieHeroId and fca then
        self:createFcaNodeByUnitID(fca, self.curNewbieHeroId)
        self.extraNewbieBg = self:createTimelySummonExBg()
        fca:addChild(self.extraNewbieBg, 1)
      end
    end
  end)
  self:listenEvent("NewbieSummonRefresh", function(data)
    self.newbieProgress = self.newbieProgress + data
    if not self.hadGetNewbieReward then
      local str = self:getNewbieDesc()
      local autoText = ed.ui.autoText.new()
      autoText:initParam({fontSize = 15, context = str})
      local width, height = autoText:getCurContentSize()
      ed.UITool.replaceUI(self.ui, "ImageView_19131", "Label_19141", autoText.node)
      local scale = 1
      if 130 < width then
        scale = 130 / width
        autoText.node:setScale(scale)
      end
      autoText.node:setPositionX(67.5 - width * 0.5 * scale)
      if self.newbieProgress >= self.newbieMaxProgress then
        self:refreshNewbieRedLight(true)
      end
    end
  end)
  self:listenEvent("SummonRiseStarGetReward", function(msg)
    self.hadGetRiseStarReward = true
    local mask = CCLayerColor:create(ccc4(0, 0, 0, 150))
    mask:setContentSize(CCSizeMake(76, 76))
    mask:setPosition(ccp(-1, -1.5))
    local selectIcon = ed.createSprite("UI/alpha/1080P/package/selected.png")
    selectIcon:setPosition(ccp(38, 38))
    mask:addChild(selectIcon)
    mask:setZOrder(1)
    self.ui.riseStar_icon:addChild(mask)
    ed.summonMgr:setRiseCircleRed(0)
    self:refreshRiseStarRedLight(false)
    local str = self:getRiseStarDesc()
    local autoText = ed.ui.autoText.new()
    autoText:initParam({fontSize = 15, context = str})
    local width, height = autoText:getCurContentSize()
    ed.UITool.replaceUI(self.ui, "ImageView_19131_Rise", "Label_19141_Rise", autoText.node)
    local scale = 1
    if 130 < width then
      scale = 130 / width
      autoText.node:setScale(scale)
    end
    autoText.node:setPositionX(67.5 - width * 0.5 * scale)
    ed.player:addRewards(msg._reward or {})
    ed.UITool.showRewardsFromServer(msg._reward or {})
  end)
  self:listenEvent("EventSummonRiseStarSelectSuccess", function(result)
    if result then
      self:initRiseStarLayer()
      local fca = self.summonFcaList[5]
      if self.curRiseStarHeroId and fca then
        self:createFcaNodeByUnitID(fca, self.curRiseStarHeroId)
        self.extraRiseStarBg = self:createTimelySummonExBg()
        fca:addChild(self.extraRiseStarBg, 1)
      end
    end
  end)
  self:listenEvent("EventSummonRiseStarRefresh", function(data)
    self.riseStarProgress = self.riseStarProgress + data
    if not self.hadGetRiseStarReward then
      local str = self:getRiseStarDesc()
      local autoText = ed.ui.autoText.new()
      autoText:initParam({fontSize = 15, context = str})
      local width, height = autoText:getCurContentSize()
      ed.UITool.replaceUI(self.ui, "ImageView_19131_Rise", "Label_19141_Rise", autoText.node)
      local scale = 1
      if 130 < width then
        scale = 130 / width
        autoText.node:setScale(scale)
      end
      autoText.node:setPositionX(67.5 - width * 0.5 * scale)
      if self.riseStarProgress >= self.riseStarMaxProgress then
        self:refreshRiseStarRedLight(true)
      end
    end
  end)
  self:listenEvent("Summon", function(msg, smash_idxs_map)
    local rewards = {}
    local quality = 0
    for i, v in ipairs(msg._reward) do
      table.insert(rewards, {
        id = v._id,
        amount = v._amount,
        type = v._type
      })
      if v._type == "hero" then
        local star = ed.lookupDataTable("Unit", "Initial Stars", v._id) or 1
        if quality < star then
          quality = star
        end
      end
    end
    self.latestData = {rewards = rewards, convertIdxs = smash_idxs_map}
    self:preloadRewardsEffect()
    local color_str = QualityColors[quality + 1] or QualityColors[4]
    if self.tabName == "normal" then
      local fca = ed.createFcaNode("eff_UI_SummonCircle_OpenCard_" .. color_str)
      fca:setAction("Start_" .. color_str)
      fca:setPosition(self.fcaPos)
      fca:setScale(self.mainFcaScale)
      self.playedFca = fca
      self.mainLayer:addChild(fca, -1)
      self:addFcaOnce(fca)
    elseif self.tabName == "destiny" then
      if 0 < quality then
        color_str = QualityColors[3]
      end
      local fca = ed.createFcaNode("eff_UI_SummonDestiny_OpenCard_" .. color_str)
      fca:setAction("Start_" .. color_str)
      fca:setPosition(self.fcaPos)
      fca:setScale(self.mainFcaScale)
      self.playedFca = fca
      self.mainLayer:addChild(fca, -1)
      self:addFcaOnce(fca)
    elseif self.tabName == "timely" then
      self.extraBg:setVisible(true)
      ListenTimer(Timer:Once(2), function()
        self.extraBg:setVisible(false)
      end, self.eventScope)
    elseif self.tabName == "newbie" then
      self.extraNewbieBg:setVisible(true)
      ListenTimer(Timer:Once(2), function()
        self.extraNewbieBg:setVisible(false)
      end, self.eventScope)
    elseif self.tabName == "riseStar" then
      self.extraRiseStarBg:setVisible(true)
      ListenTimer(Timer:Once(2), function()
        self.extraRiseStarBg:setVisible(false)
      end, self.eventScope)
    end
    self.curScreenFca:setAction("Start_" .. color_str)
    self:hideUI(true)
    local timer = Timer:Once(QualityTimes[color_str] or 6)
    if self.tabName == "timely" then
      timer = Timer:Once(6.85)
    elseif self.tabName == "newbie" or self.tabName == "riseStar" then
      timer = Timer:Once(6.85)
    end
    timer:setName("animationTimer1")
    ListenTimer(timer, function()
      self.ui.btn_skip:setVisible(false)
      self.ui.summon:setVisible(false)
      ed.ui.SummonRewardCardWindow.create({
        rewards = rewards,
        tabName = self.tabName,
        convertIdxs = self.latestData.convertIdxs,
        doSummon = function(times)
          self:doSummon(times)
        end,
        callback = function(num)
          self.ui.summon:setVisible(true)
        end
      }):popWindow()
      self:initNormalLayer()
      self:hideUI(false)
    end, self.eventScope)
    timer = Timer:Once(1.5)
    timer:setName("animationTimer2")
    ListenTimer(timer, function()
      self.ui.btn_skip:setVisible(ed.guide.data:isCompleted(8))
    end, self.eventScope)
    self:refreshDestinyRedLight()
  end)
  ed.UITool.registerBtn(self, "btn1", function()
    if self.tabName == "normal" or not self.loadSuccess then
      return
    end
    self.pageIndex = 1
    self.tabName = pageConfig[self.pageIndex].key
    self:refreshLayer()
  end)
  ed.UITool.registerBtn(self, "btn2", function()
    local summonCount = ed.summonMgr:getNormalSummonCount() or 0
    summonCount = summonCount + ed.summonMgr.timelySummonCount + ed.summonMgr.newbieSummonCount
    if summonCount < 200 then
      ed.showToast(string.format(T("\229\156\168\232\139\177\233\155\132/\233\153\144\230\151\182/\230\150\176\230\137\139\229\143\172\229\148\164\228\184\173\231\180\175\232\174\161\229\143\172\229\148\164200\230\172\161\229\144\142\232\167\163\233\148\129\239\188\136\229\189\147\229\137\141\232\191\155\229\186\166\239\188\154%d/200)"), summonCount))
      return
    end
    ed.storage.setValue(ed.getRoleKey("Summon_Destiny_Red"), true)
    self:refreshDestinyRedLight()
    if self.tabName == "destiny" or not self.loadSuccess then
      return
    end
    self.pageIndex = 2
    self.tabName = pageConfig[self.pageIndex].key
    self:refreshLayer()
  end)
  ed.UITool.registerBtn(self, "btn3", function()
    if not (self.tabName ~= "timely" and self.isTimelySummonOpen) or not self.loadSuccess then
      return
    end
    if self.timelyStartTime > ed.getServerTime() then
      ed.showToast(string.format(T("\233\153\144\230\151\182\229\143\172\229\148\164\229\176\134\228\186\142%s\229\188\128\229\144\175"), ed.formatTime(self.timelyStartTime) .. ed.getUTCLabel()))
      return
    end
    self.pageIndex = 3
    self.tabName = pageConfig[self.pageIndex].key
    self:refreshLayer()
  end)
  ed.UITool.registerBtn(self, "btn4", function()
    if not (self.tabName ~= "newbie" and self.isNewbieSummonOpen) or not self.loadSuccess then
      return
    end
    self.pageIndex = 4
    self.tabName = pageConfig[self.pageIndex].key
    self:refreshLayer()
  end)
  ed.UITool.registerBtn(self, "btn_record", function()
    ed.ui.summonRecordWin.create({
      tabIndex = self.pageIndex,
      parent = self
    })
  end, {pressScale = 0.94})
  ed.UITool.registerBtn(self, "btn_hero_detail", function()
    ed.ui.commonHerohot.create():popWindow()
  end, {pressScale = 0.94})
  ed.UITool.registerBtn(self, "icon_newbie", function()
    if self.curNewbieHeroId then
      ed.showToast(T("\232\135\170\233\128\137\232\139\177\233\155\132\233\128\137\230\139\169\229\144\142\228\184\141\232\131\189\230\155\180\230\148\185"))
    else
      self.ui.summon:setVisible(false)
      ed.ui.summonNewbieSelectWin.create({
        destroyCallback = function()
          self.ui.summon:setVisible(true)
        end
      })
    end
  end)
  ed.UITool.registerBtn(self, "btn5", function()
    if not (self.tabName ~= "riseStar" and self.isRiseStarSummonOpen) or not self.loadSuccess then
      return
    end
    self.pageIndex = 5
    self.tabName = pageConfig[self.pageIndex].key
    self:refreshLayer()
  end)
  ed.UITool.registerBtn(self, "icon_riseStar", function()
    if self.curRiseStarHeroId then
      ed.showToast(T("\232\135\170\233\128\137\232\139\177\233\155\132\233\128\137\230\139\169\229\144\142\228\184\141\232\131\189\230\155\180\230\148\185"))
    else
      self.ui.summon:setVisible(false)
      ed.ui.summonRiseStarSelectWin.create({
        destroyCallback = function()
          self.ui.summon:setVisible(true)
        end
      })
    end
  end)
  ListenEvent("SummonSwitchWish", function(result)
    if not result then
      return
    end
    self:updateWishList()
  end, self.eventScope)
  ListenEvent("ResourceNumChange", function(result)
    self:updateTicketNum()
  end, self.eventScope)
  self:registerOnEnterHandler("SummonSceneOnEnter", function()
    if not self.loadSuccess and ed.isOpenAsyncLoad() then
      ed.asyncload.preloadFcaByName("eff_UI_SummonCircle_OpenCard")
      ed.asyncload.preloadFcaByName("eff_UI_SummonDestiny_OpenCard")
      if self.isTimelySummonOpen then
        ed.asyncload.preloadFcaByName("eff_UI_SummonTimely_OpenCard")
      end
      if self.isNewbieSummonOpen then
        ed.asyncload.preloadFcaByName("eff_UI_SummonBeginner_OpenCard")
      end
      if self.isRiseStarSummonOpen then
        ed.asyncload.preloadFcaByName("eff_UI_SummonBeginner_OpenCard")
      end
      ed.asyncload.registLoadingListener(function()
        for k, v in ipairs(pageConfig) do
          if not self.summonFcaList[k] and self:isSummonOpenByType(v.key) then
            local fca = ed.createFcaNode(v.fcaRes)
            fca:setScale(self.mainFcaScale)
            self.mainLayer:addChild(fca, -2)
            local pos = self.mainLayer:convertToNodeSpace(ed.display.center)
            fca:setPosition(pos)
            self:addFca(fca)
            fca:setAction("Start")
            self.summonFcaList[k] = fca
            fca:setVisible(false)
            if v.key == "timely" then
              self:createFcaNodeByUnitID(fca, self.curTimelyHeroId)
              self.extraBg = self:createTimelySummonExBg()
              fca:addChild(self.extraBg, 1)
            end
            if v.key == "newbie" and self.curNewbieHeroId then
              self:createFcaNodeByUnitID(fca, self.curNewbieHeroId)
              self.extraNewbieBg = self:createTimelySummonExBg()
              fca:addChild(self.extraNewbieBg, 1)
            end
            if v.key == "riseStar" and self.curRiseStarHeroId then
              self:createFcaNodeByUnitID(fca, self.curRiseStarHeroId)
              self.extraRiseStarBg = self:createTimelySummonExBg()
              fca:addChild(self.extraRiseStarBg, 1)
            end
          end
        end
        ed.asyncload.unregistLoadingListener()
        self.loadSuccess = true
      end)
    end
  end, self.eventScope)
  self:registerOnPopSceneHandler("SummonSceneOnPop", function()
    ed.asyncload.unregistLoadingListener()
    CloseScope(self.eventScope)
    self.eventScope = nil
    self:refreshMainSummonNode()
  end)
end

function SummonScene:refreshMainSummonNode()
  ListenTimer(Timer:Once(0.1), function()
    local BuilddingType = ed.ui.configs.mainSceneMap.builddingType
    if BuilddingType and BuilddingType.Summon then
      FireEvent("MainBuildRedTagChange", BuilddingType.Summon)
      FireEvent("MainActivityTips")
      FireEvent("ResourceNumChange")
    end
  end)
end

function SummonScene:createFcaNodeByUnitID(parentFca, unitID)
  local actor, puppet_id = ed.readhero.getActor(unitID, "Idle")
  local row = ed.getDataTable("Puppet")[puppet_id]
  local scale = row.Scale
  local wscale = row["Window Scale"]
  if wscale ~= 0 then
    scale = row.Scale * wscale
  end
  parentFca:addNodeToComponent(actor, "Hero", 0, CCAffineTransformMake(scale, 0, 0, scale, 0, 0), true, true)
end

function SummonScene:isSummonOpenByType(type)
  if type == "normal" then
    return true
  elseif type == "destiny" then
    return true
  elseif type == "timely" then
    return self.isTimelySummonOpen
  elseif type == "newbie" then
    return self.isNewbieSummonOpen
  elseif type == "riseStar" then
    return self.isRiseStarSummonOpen
  end
end

function SummonScene:preloadRewardsEffect()
  if not self.latestData or not ed.isOpenAsyncLoad() then
    return
  end
  for i, reward in ipairs(self.latestData.rewards) do
    if reward.type == "hero" then
      local puppet = ed.getUnitPuppet(reward.id)
      ed.asyncload.preloadFcaByName(puppet)
    end
  end
end

function SummonScene:registerBtnClick(key, func, addition)
  local ui = self.ui
  local config = {
    button = ui[key],
    press = ui[key .. "_press"],
    key = key,
    pressScale = 0.9,
    clickHandler = function(_, x, y)
      ed.playEffect(ed.sound.deo.common_back)
      func(x, y)
    end,
    clickInterval = 0.5,
    priority = -1
  }
  for k, v in pairs(addition or {}) do
    config[k] = v
  end
  self:btRegisterButtonClick(config)
end

function SummonScene:checkRiseStarRecommend()
  if self.tabName ~= "riseStar" or self.curRiseStarHeroId then
    return
  end
  if 0 == #ed.summonMgr.riseStarHeroList then
    return
  end
  local lastTime = ed.summonMgr:getLastRiseStarRecommendTime()
  local curTime = ed.getServerTime()
  local checkTime
  if curTime - lastTime < 86400 then
    local h, m, s = ed.time2HMS(curTime)
    checkTime = curTime - (h * 3600 + m * 60 + s) + 18000
    if curTime < checkTime then
      checkTime = checkTime - 86400
    end
  else
    checkTime = curTime
  end
  if lastTime >= checkTime then
    return
  end
  ed.summonMgr:updateLastRiseStarRecommendTime()
  ListenTimer(Timer:Once(0.01), function()
    ed.ui.summonRiseStarRecommendWin.create()
  end, self.eventScope)
end

function SummonScene:getRiseStarDesc()
  if not self.isRiseStarSummonOpen then
    return ""
  end
  if not self.hadGetRiseStarReward then
    if self.riseStarProgress < self.riseStarMaxProgress then
      return string.format(T("<lable color=ccc3(112,255,84) strokeColor=ccc3(23,49,31) strokeSize=1>\230\138\189\229\143\150%d</lable>") .. T("<lable color=ccc3(255,252,231)>/%d\229\144\142\232\142\183\229\190\151</lable>"), self.riseStarProgress, self.riseStarMaxProgress)
    else
      ed.summonMgr:setRiseCircleRed(1)
      local BuilddingType = ed.ui.configs.mainSceneMap.builddingType
      FireEvent("MainBuildRedTagChange", BuilddingType.Summon)
      return string.format(T("<lable color=ccc3(112,255,84) strokeColor=ccc3(23,49,31) strokeSize=1>\229\143\175\233\162\134\229\143\150</lable>"))
    end
  else
    return string.format(T("<lable color=ccc3(112,255,84) strokeColor=ccc3(23,49,31) strokeSize=1>\229\183\178\233\162\134\229\143\150</lable>"))
  end
end

function SummonScene:refreshRiseStarRedLight(isShow)
  local BuilddingType = ed.ui.configs.mainSceneMap.builddingType
  FireEvent("MainBuildRedTagChange", BuilddingType.Summon)
  if self.ui.RiseStarRedLight then
    self.ui.RiseStarRedLight:setVisible(isShow)
    self.ui.RiseStarBtnRedLight:setVisible(isShow)
    return
  end
  if isShow then
    local redLight = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
    redLight:setPosition(ccp(70, 68))
    self.ui.riseStar_icon:addChild(redLight)
    self.ui.RiseStarRedLight = redLight
    local eff = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
    eff:setPosition(-26, -25)
    eff:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
    redLight:addChild(eff, 9)
    local btnRedLight = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
    btnRedLight:setPosition(ccp(80, 27))
    self.ui.btn5:addChild(btnRedLight, 3)
    self.ui.RiseStarBtnRedLight = btnRedLight
  end
end

function SummonScene:initRiseStarLayer()
  self.isRiseStarSummonOpen = ed.getServerTime() < ed.summonMgr.rise_starEndTime
  self.ui.btn5:setVisible(self.isRiseStarSummonOpen)
  self.riseStarFca = ed.createFcaNode("eff_UI_RiseStar_OpenCard_Star")
  self.mainLayer:addChild(self.riseStarFca, -3)
  local pos = self.mainLayer:convertToNodeSpace(ed.display.center)
  self.riseStarFca:setPosition(pos)
  self:addFca(self.riseStarFca)
  FireEvent("MainBuildRedTagChange", ed.ui.configs.mainSceneMap.builddingType.Summon)
  self.curRiseStarHeroId = ed.summonMgr.rise_starHeroId
  self.hadGetRiseStarReward = ed.summonMgr.rise_starRewardFlag == 1
  self.riseStarEndTime = ed.time2dhmsV2(ed.summonMgr.rise_starEndTime - ed.getServerTime())
  self.riseStarMaxProgress = 80
  self.riseStarProgress = ed.summonMgr.rise_starSummonCount
  self.ui.label_riseStar_time:setString(self.riseStarEndTime)
  if not self.riseStarLabel then
    local riseStarLabel = ed.ui.gradientLabel.create({
      text = T("\232\135\170\233\128\137\232\139\177\233\155\132"),
      fontSize = 36,
      fontName = ed.fontBold,
      startColor = ed.toccc3(16776677),
      endColor = ed.toccc3(16768914),
      strokeSize = 2,
      strokeColor = ed.toccc3(13728007),
      shadowColor = ed.toccc3(9191464),
      shadowOffset = ccp(0, -1.7)
    })
    riseStarLabel.node:setPosition(ccp(247.5, 75.75))
    self.ui.bg_riseStar_info:addChild(riseStarLabel.node)
    self.riseStarLabel = riseStarLabel
  end
  ed.layout.horizontalSortNode({
    self.riseStarLabel.node,
    self.ui.riseStar_info4
  }, {10, 0}, self.ui.bg_riseStar_info:getContentSize().width * 0.5)
  if self.curRiseStarHeroId then
    self.ui.icon_riseStar:setVisible(false)
    self.ui.riseStar_info1:setVisible(true)
    self.ui.riseStar_info2:setVisible(true)
    self.ui.riseStar_info3:setVisible(true)
    self.riseStarLabel.node:setVisible(false)
    self.ui.bg_riseStar_reward:setVisible(true)
    local heroName = ed.getDataTable("Unit")[self.curRiseStarHeroId]["Display Name"]
    local riseStarHeroName = ed.ui.gradientLabel.create({
      text = heroName,
      fontSize = 42.5,
      fontName = ed.fontBold,
      startColor = ed.toccc3(16776677),
      endColor = ed.toccc3(16768914),
      strokeSize = 3,
      strokeColor = ed.toccc3(13728007),
      shadowColor = ed.toccc3(9191464),
      shadowOffset = ccp(0, -1.7)
    })
    local width = (riseStarHeroName:getContentSize().width - self.ui.newbie_info3:getContentSize().width) / 2
    ed.UITool.replaceUINew(self.ui, "riseStar_info3", riseStarHeroName.node)
    ed.layout.horizontalSortNode({
      self.ui.riseStar_info1,
      self.ui.riseStar_info2,
      self.ui.riseStar_info3,
      self.ui.riseStar_info4
    }, {
      2,
      2,
      2,
      0
    }, self.ui.bg_riseStar_info:getContentSize().width * 0.5)
    local icon = ed.readhero.createIcon({
      id = self.curRiseStarHeroId,
      stars = 3,
      rank = 1
    }).icon
    self.ui.riseStar_icon = icon
    self.ui.bg_riseStar_reward:addChild(icon)
    ed.layout.centerInParent(icon)
    if not self.hadGetRiseStarReward then
      local str = self:getRiseStarDesc()
      local autoText = ed.ui.autoText.new()
      autoText:initParam({fontSize = 15, context = str})
      local width, height = autoText:getCurContentSize()
      ed.UITool.replaceUI(self.ui, "ImageView_19131_Rise", "Label_19141_Rise", autoText.node)
      local scale = 1
      if 130 < width then
        scale = 130 / width
        autoText.node:setScale(scale)
      end
      autoText.node:setPositionX(67.5 - width / 2 * scale)
      if self.riseStarProgress >= self.riseStarMaxProgress then
        self:refreshRiseStarRedLight(true)
      end
    else
      local mask = CCLayerColor:create(ccc4(0, 0, 0, 150))
      mask:setContentSize(CCSizeMake(76, 76))
      mask:setPosition(ccp(-3, -3.5))
      local selectIcon = ed.createSprite("UI/alpha/1080P/package/selected.png")
      selectIcon:setPosition(ccp(38, 38))
      mask:addChild(selectIcon)
      mask:setZOrder(1)
      icon:addChild(mask)
    end
  else
    self.ui.bg_riseStar_reward:setVisible(false)
    if not self.riseStarExtraFca then
      self.riseStarExtraFca = ed.createFcaNode("eff_UI_SummonBeginner_StarCircle")
      self.ui.icon_riseStar:addChild(self.riseStarExtraFca, -1)
      ed.layout.centerInParent(self.riseStarExtraFca)
      self:addFca(self.riseStarExtraFca)
    end
  end
end
