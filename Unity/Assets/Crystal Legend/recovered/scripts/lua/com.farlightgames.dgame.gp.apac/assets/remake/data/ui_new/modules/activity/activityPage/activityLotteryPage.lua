local activityLotteryPage = {consumeId = 20115}
ed.ui.activityLotteryPage = activityLotteryPage
activityLotteryPage.uiCfg = {
  newyear = {
    deleUiName = {
      "Label_time",
      "ImageView_2968"
    },
    updateRes = {
      ImageView_2969 = "UI/alpha/1080P/lottery/lottery_title_bg_newyear.png",
      ImageView_2968 = "UI/alpha/1080P/lottery/lottery_time_newyear.png",
      ImageView_right = "UI/alpha/1080P/lottery/lottery_reward_bg_newyear.png",
      ImageView_bg = "UI/alpha/1080P/lottery/lottery_bg_newyear.png"
    },
    addUiCfg = {
      {
        t = "Sprite",
        base = {
          parent = "page_lay",
          name = "snowNewyear",
          z = 996,
          res = "UI/alpha/1080P/lottery/lottery_snow_newyear.png"
        },
        layout = {
          position = ccp(480, 82)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "time_bj",
          res = "UI/alpha/1080P/lottery/lottery_time_bj_newyear.png"
        },
        layout = {
          position = ccp(310, 70)
        }
      },
      {
        t = "Sprite",
        base = {
          parent = "time_bj",
          name = "ImageView_2968",
          res = "UI/alpha/1080P/lottery/lottery_time_newyear.png"
        },
        layout = {
          position = ccp(84, 20)
        }
      },
      {
        t = "Label",
        config = {
          color = ed.toccc3(16776423)
        },
        base = {
          parent = "time_bj",
          name = "Label_time",
          text = "",
          size = 21
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(160, 20)
        }
      }
    },
    updateFca = {
      eff_UI_lottery_Blue = "eff_UI_lottery_Blue_newyear",
      eff_UI_lottery_rope = "eff_UI_lottery_rope_newyear"
    },
    addFca = {
      {
        name = "cloth_newyear",
        info = {
          "eff_UI_lottery_cloth_newyear",
          "ImageView_right",
          ccp(22, 295),
          -1,
          "",
          true
        }
      }
    },
    deleFca = {eff_UI_lottery_cloth = 1},
    init = function(self)
      local size = self.ui.ImageView_bg:getContentSize()
      local Pastre = CCParticleSnow:create()
      Pastre:setPosition(ccp(size.width / 2, size.height))
      Pastre:setLife(6)
      Pastre:setSpeed(60)
      self.ui.ImageView_bg:addChild(Pastre)
      Pastre = CCParticleSnow:create()
      Pastre:setPosition(ccp(size.width / 2, size.height))
      Pastre:setLife(6)
      Pastre:setSpeed(60)
      self.ui.ImageView_bg:addChild(Pastre)
      ed.setLabelStroke(self.ui.Label_time, ed.toccc3(10961965), 1)
      self.ui.ImageView_2969:setPositionY(self.ui.ImageView_2969:getPositionY() + 12)
    end
  }
}

function activityLotteryPage.create(base, param, pageKey)
  local this = {}
  setmetatable(activityLotteryPage, {__index = base})
  setmetatable(this, {__index = activityLotteryPage})
  local uiConfig = ed.uieditor.activity_lottery_page
  this.categoryUiCfg = {}
  if param._extend and param._extend._tag and this.uiCfg[param._extend._tag] then
    local categoryUiCfg = this.uiCfg[param._extend._tag]
    local deleIdx = {}
    uiConfig = ed.copyProto(uiConfig)
    for i, v in ipairs(uiConfig) do
      if ed.isElementInTable(v.base.name, categoryUiCfg.deleUiName) then
        table.insert(deleIdx, i)
      elseif categoryUiCfg.updateRes[v.base.name] then
        v.base.res = categoryUiCfg.updateRes[v.base.name]
      end
    end
    for i, v in ipairs(deleIdx) do
      table.remove(uiConfig, v - (i - 1))
    end
    for i, v in ipairs(categoryUiCfg.addUiCfg) do
      table.insert(uiConfig, v)
    end
    this.resTag = param._extend._tag
    this.categoryUiCfg = categoryUiCfg
  end
  local container, ui = ed.editorui(uiConfig)
  this.ui = ui
  this.param = param
  this.pageKey = pageKey or ""
  this.container = container
  this.isTouch = true
  this.consumeId = ed.taskData.lotteryInfo[2]
  this.maximum = ed.getDataTable("LotteryConfig")["Tray Maximum"].Value or 0
  
  function this:setTouchTime(s)
    self.isTouch = false
    this.mainLayer:stopAllActions()
    this.mainLayer:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(s or 0.1), CCCallFunc:create(function()
      self.isTouch = true
    end))))
  end
  
  ed.layout.layoutHalfFixedMagin(ui.ImageView_2982, {right = true, top = true})
  ed.setLabelStroke(ui.Label_refresh_btn, ed.toccc3(9392902), 1)
  ed.setLabelStroke(ui.Label_count_item, ed.toccc3(3876637), 1)
  ed.setLabelStroke(ui.Label_newlayer, ed.toccc3(5395026), 1)
  ed.setLabelStroke(ui.Label_time, ed.toccc3(3956881), 1)
  ed.setLabelStroke(ui.Label_2972, ed.toccc3(3956881), 1)
  ed.setLabelStroke(ui.Label_open, ed.toccc3(3956881), 1)
  ui.panel_crad_lay:setClipRect(CCRectMake(0, 0, 320, 239))
  local floorStr = T("\231\172\172%d\229\177\130")
  local floorParamStartIndex, floorParamEndIndex = string.find(floorStr, "%%d")
  ed.setLabelString(ui.Label_newlayer_des1, string.sub(floorStr, 1, floorParamStartIndex - 1))
  ed.setLabelString(ui.Label_newlayer_des2, string.sub(floorStr, floorParamEndIndex + 1))
  ui.Label_newlayer:setString("1")
  ed.layout.horizontalSortNode({
    ui.Label_newlayer_des1,
    ui.Label_newlayer,
    ui.Label_newlayer_des2
  }, {
    2.7,
    2.7,
    0
  }, ui.ImageView_2970:getContentSize().width * 0.5)
  ed.layout.horizontalSortNode({
    ui.Image_what_btn,
    ui.Label_2966
  }, {0, 0}, ui.ImageView_2965:getContentSize().width * 0.5)
  local consumeStr = T("\231\130\185\229\135\187\230\182\136\232\128\151%d\229\188\128\229\167\139\231\191\187\231\137\140")
  local consumeParamStartIndex, consumeParamEndIndex = string.find(consumeStr, "%%d")
  ed.setLabelString(ui.Label_consume_des1, string.sub(consumeStr, 1, consumeParamStartIndex - 1))
  ed.setLabelString(ui.Label_consume_des2, string.sub(consumeStr, consumeParamEndIndex + 1))
  ed.layout.horizontalSortNode({
    ui.Label_consume_des1,
    ui.icon_img,
    ui.Label_consume_des2
  }, {
    0,
    0,
    0
  }, ui.Panel_tag:getContentSize().width * 0.5)
  this:pageUpDate(param)
  this:talkLayerTouchShow()
  this:registerTouchHandler()
  this.objWork:sendLotteryReq("_open_panel")
  this:listenEvent("activity_lottery_reply", function(info)
    this:pageRefresh(info)
  end)
  this:listenEvent("ResourceNumChange", function(resType, id)
    if resType == "item" and this.consumeId == id then
      this.ui.Label_coins:setString(ed.player.equip_qunty[this.consumeId] or 0)
    end
  end)
  this:addPageFca()
  local lotteryUidKey = ed.getRoleKey("lottery")
  if not ed.storage.getBool(lotteryUidKey) then
    ed.storage.setValue(lotteryUidKey, true)
    ed.activityHints:updateReds({
      _act_id = param._id
    })
    FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.ACTIVITY)
  end
  if this.categoryUiCfg and this.categoryUiCfg.init then
    this.categoryUiCfg.init(this)
  end
  return this
end

function activityLotteryPage:addPageFca()
  local function addFca(fcaName, node, pos, z, act, vis)
    if self.categoryUiCfg.deleFca and self.categoryUiCfg.deleFca[fcaName] then
      return
    end
    if self.categoryUiCfg.updateFca then
      if not fcaName then
        fcaName = self.categoryUiCfg.updateFca[fcaName] or fcaName
      end
    end
    local sprite = ed.createFcaNode(fcaName)
    sprite:setPosition(pos)
    node:addChild(sprite, z or 1)
    sprite:setVisible(vis)
    sprite.actName = act
    self:addFca(sprite)
    return sprite
  end
  
  self.fcaKeys = {
    boomStar = addFca("eff_UI_lottery_reward_high_opened_1", self.ui.ImageView_right, ccp(0, 0), 999, "Start2", false),
    light_bg = addFca("eff_UI_pvp_light", self.ui.ImageView_bg, ccp(840, 480), 1, "Loop", true),
    rope = addFca("eff_UI_lottery_rope", self.ui.ImageView_right, ccp(455, 91), -1, "Start2", true),
    light_1 = addFca("eff_UI_lottery_light_1", self.ui.ImageView_right, ccp(241, 266), 1, "Start", false),
    light_2 = addFca("eff_UI_lottery_light_2", self.ui.ImageView_2969, ccp(135, 53), 1, "Start2", true),
    cloth = addFca("eff_UI_lottery_cloth", self.ui.ImageView_right, ccp(240, 250), -1, "", true),
    Blue = addFca("eff_UI_lottery_Blue", self.ui.ImageView_lift, ccp(367, 220), -1, "Start", true),
    high = addFca("eff_UI_lottery_reward_high", self.ui.ImageView_right, ccp(0, 0), 998, "", false),
    spiral = addFca("eff_UI_lottery_spiral", self.ui.ImageView_right, ccp(0, 0), 998, "", false)
  }
  for _, v in ipairs(self.categoryUiCfg.addFca or {}) do
    self.fcaKeys[v.name] = addFca(v.info[1], self.ui[v.info[2]], v.info[3], v.info[4], v.info[5], v.info[6])
  end
  self.fcaKeys.light_bg:setScale(1.35)
  local sprite = ed.createSprite("UI/alpha/1080P/lottery/lottery_reward_high.png")
  sprite:setPosition(0, 35)
  self.fcaKeys.high:addChild(sprite)
  local label_prize = ed.ui.gradientLabel.create({
    text = T("\229\164\167\229\165\150"),
    fontName = ed.fontBold,
    fontSize = 19,
    startColor = ed.toccc3(15843127),
    endColor = ed.toccc3(16776674),
    strokeColor = ed.toccc3(12738560),
    strokeSize = 1.5
  })
  sprite:addChild(label_prize.node)
  ed.layout.centerInParent(label_prize.node)
end

local function addGuideFca(self)
  local sprite = ed.createFcaNode("eff_UI_lottery_guide")
  self.ui.ImageView_right:addChild(sprite, 1)
  sprite:setVisible(false)
  sprite.actName = "Start"
  self:addFca(sprite)
  self.guideFca = sprite
end

function activityLotteryPage:pageUpDate(param)
  local time = param._end_time or 0
  time = time - 86400
  if 0 > time - ed.getServerTime() then
    self.ui.Label_time:setVisible(false)
    self.ui.ImageView_2968:setVisible(false)
  else
    self.ui.Label_time:setString(T("\229\137\169\228\189\153%s", self.objData.getEndTime(time)))
    ed.right2(self.ui.Label_time, self.ui.ImageView_2968, 2)
  end
end

local itemCardMod = {}

function activityLotteryPage:pageRefresh(info)
  info = ed.copyProto(info)
  if info._open_panel then
    info = info._open_panel
    self.ui.Image_refresh_btn:setVisible(info._state == 0)
    self.ui.Panel_tag:setVisible(info._state == 1)
    self.ui.Label_newlayer:setString(info._tray)
    self.ui.Label_newlayer:setColor(ed.toccc3(info._tray % 5 == 0 and 16773016 or 16777215))
    ed.setLabelStroke(self.ui.Label_newlayer, ed.toccc3(info._tray % 5 == 0 and 12145198 or 5395026), 1.2)
    self.ui.Label_newlayer:setFontSize(info._tray % 5 == 0 and 20 or 18)
    self:createCradLayer(info._rewards)
    self.progress = info._progress
    self.lineReward = info._line_reward or {}
    self:lineRewardRefresh(self.progress, self.lineReward)
    self.ui.Label_coins:setString(ed.player.equip_qunty[self.consumeId] or 0)
    self.fcaKeys.light_bg:setVisible(info._tray % 5 == 0)
    if info._tray == 1 then
      if info._state == 0 then
        self.newShowGuideAct = self:addGuideAct()
      elseif self.progress == 0 then
        self.newShowGuideTxt = self:addGuideTxt()
      end
    end
    if info._tray % 5 == 0 then
      self.fcaKeys.Blue:setLoopAction("Loop4")
      self.fcaKeys.Blue:setAction("Start4")
      self.fcaKeys.light_1:setVisible(true)
    end
  elseif info._enter_tray then
    info = info._enter_tray
    self:setTouchTime(1)
    self.newPassItem = nil
    self.ui.Image_refresh_btn:setVisible(true)
    self.ui.Panel_tag:setVisible(false)
    self.ui.Label_open:setVisible(false)
    if self.newShowGuideAct then
      self.newShowGuideAct.removeSelf()
    end
    local oldItemIconsNode = {}
    for i, v in ipairs(self.itemIcons) do
      table.insert(oldItemIconsNode, v.node)
    end
    self:createCradLayer(info._rewards, true)
    for i, v in ipairs(self.itemIcons) do
      table.insert(oldItemIconsNode, v.node)
    end
    local time = self:removeCradItemAct(oldItemIconsNode, true)
    self:setTouchTime(time)
    self:listenTimer(Timer:Once(time), function()
      for i = 1, 12 do
        oldItemIconsNode[i]:removeFromParentAndCleanup(true)
      end
    end)
    local layer = tonumber(self.ui.Label_newlayer:getString())
    self.ui.Label_newlayer:setString(layer + 1)
    local tray = layer + 1
    self.ui.Label_newlayer:setColor(ed.toccc3(tray % 5 == 0 and 16773016 or 16777215))
    ed.setLabelStroke(self.ui.Label_newlayer, ed.toccc3(tray % 5 == 0 and 12145198 or 5395026), 1.2)
    self.ui.Label_newlayer:setFontSize(tray % 5 == 0 and 20 or 18)
    if tray % 5 == 0 then
      self.ui.Label_newlayer:runAction(CCSequence:create(ccArrayMake(CCEaseBackOut:create(CCScaleTo:create(0.2, 2, 2.5)), CCScaleTo:create(0.15, 1, 1))))
      self.fcaKeys.light_1:setVisible(true)
      self.fcaKeys.light_1:setAction(self.fcaKeys.light_1.actName)
      self.fcaKeys.light_2:setVisible(true)
      self.fcaKeys.light_2:setAction(self.fcaKeys.light_2.actName)
      self.fcaKeys.Blue:setLoopAction("Loop4")
      self.fcaKeys.Blue:setAction("Start4")
    else
      if tray % 5 == 1 then
        self.fcaKeys.Blue:setLoopAction("Loop")
        self.fcaKeys.Blue:setAction("Start")
      end
      self.fcaKeys.light_1:setVisible(false)
    end
    self.fcaKeys.light_bg:setVisible(tray % 5 == 0)
    self.fcaKeys.high:setVisible(false)
    self.fcaKeys.spiral:setVisible(false)
  elseif info._open_card then
    info = info._open_card
    if self.newShowGuideTxt then
      self.newShowGuideTxt.removeSelf()
    end
    local param = ed.copyTable(self.newPassItem.param)
    param._state = true
    param._reward = info._rewards[1]
    param._is_big = info._is_lucky and info._is_lucky == 1
    local isCrit = info._is_crit and info._is_crit == 1
    self:setTouchTime(param._is_big and 1.2 or 1)
    self.newPassItem:refresh(param)
    self:listenTimer(Timer:Once(param._is_big and 1 or 0.8), function()
      local item = {}
      for k, v in pairs(info._rewards or {}) do
        table.insert(item, {
          type = v._type,
          amount = isCrit and (v._amount / 2 < 1 and 1 or v._amount / 2) or v._amount,
          id = v._id
        })
      end
      local closeTime = 0.5
      if info._is_crit and info._is_crit == 1 then
        local its = ed.copyTable(item[1])
        its.toMax = true
        table.insert(item, its)
        closeTime = 1
      end
      local pop = ed.ui.maillocalbox.create({
        type = "addItem",
        item = item,
        destroyBack = function()
          if self.newPassItem then
            self.newPassItem:doorFcaAct()
          end
        end,
        closeTime = closeTime
      })
      pop:popWindow()
      if param._is_big then
        pop.ui.outClickLay:setScaleY(1.15)
        pop.ui.outClickLay:setPositionY(278)
        pop.ui.Label_110:setPositionY(196)
        pop.ui.ImageView_109:setPositionY(415)
        local label = ed.createttf(T("\230\129\173\229\150\156\232\142\183\229\190\151\229\164\167\229\165\150\239\188\140\231\142\176\229\156\168\229\143\175\228\187\165\232\191\155\229\133\165\228\184\139\228\184\128\229\177\130\239\188\129"), 16)
        label:setPosition(ccp(232.5, -6))
        label:setColor(ed.toccc3(16773016))
        pop.ui.ImageView_109:addChild(label)
        ed.setLabelStroke(label, ed.toccc3(12145198), 1.2)
        local sprite = ed.createFcaNode("eff_UI_lottery_prize")
        pop:addFcaOnce(sprite)
        sprite:setPosition(ed.display.winSize.width / 2, ed.display.winSize.height / 2)
        pop.mainLayer:addChild(sprite, 999)
      end
      if info._is_crit and info._is_crit == 1 then
        local sprite = ed.createFcaNode("eff_UI_lottery_reward_high")
        pop:addFca(sprite)
        sprite:setPosition(ccp(45, 45))
        pop.itemAttach[#pop.itemAttach].icon:addChild(sprite)
        local double = ed.createSprite("UI/alpha/1080P/soulexchange/soulexchange_reward_double.png")
        double:setPosition(ccp(70, 78))
        local label_multi = ed.ui.gradientLabel.create({
          text = T("\229\164\154\233\135\141\230\150\189\230\179\149"),
          fontName = ed.fontBold,
          fontSize = 15,
          startColor = ed.toccc3(15843127),
          endColor = ed.toccc3(16776674),
          strokeColor = ed.toccc3(12738560),
          strokeSize = 1.5
        })
        double:addChild(label_multi.node)
        ed.layout.centerInParent(label_multi.node)
        ed.UITool.setPositionBy(label_multi.node, ccp(6, 2))
        pop.itemAttach[#pop.itemAttach].icon:addChild(double)
        pop.itemAttach[#pop.itemAttach].label:setColor(ccc3(244, 233, 204))
        pop.itemAttach[#pop.itemAttach].label:setString("")
        pop.itemAttach[#pop.itemAttach].label:setFontSize(15)
        pop.itemAttach[#pop.itemAttach].labBj:setVisible(false)
      end
    end)
    ed.player:addRewards(info._rewards)
    self.progress = self.progress + 1
    self:lineRewardRefresh(self.progress, self.lineReward)
    if self.guideFca then
      self.guideFca:setPosition(ccpAdd(ccp(self.newPassItem.node:getPosition()), ccp(78, 70)))
    end
    if param._is_big then
      self.fcaKeys.boomStar:setPosition(ccpAdd(ccp(self.newPassItem.node:getPosition()), ccp(78, 70)))
      self.fcaKeys.boomStar:setVisible(true)
      self.fcaKeys.boomStar:setAction(self.fcaKeys.boomStar.actName)
    end
    self:listenTimer(Timer:Once(0.5), function()
      self.fcaKeys.boomStar:setVisible(false)
    end)
    ed.player:consumeEquip(self.consumeId, 1)
    local fllp = true
    for i, v in pairs(self.itemIcons) do
      if not v.icon then
        fllp = false
        break
      end
    end
    local tray = tonumber(self.ui.Label_newlayer:getString())
    if tray >= self.maximum and fllp then
      local lotteryMaximumUidKey = ed.getRoleKey("lottery_" .. self.param._id)
      if not ed.storage.getBool(lotteryMaximumUidKey) then
        ed.storage.setValue(lotteryMaximumUidKey, true)
        ed.activityHints:updateReds({
          _act_id = self.param._id
        })
        FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.ACTIVITY)
      end
    end
  elseif info._line_reward then
    info = info._line_reward
    table.insert(self.lineReward, info._index)
    self:lineRewardRefresh(self.progress, self.lineReward)
    ed.UITool.openView("addItemPop", info._rewards)
    ed.player:addRewards(info._rewards or {})
  elseif info._open_tray then
    info = info._open_tray
    if info._result == "success" then
      if self.newShowGuideAct then
        self.newShowGuideAct.removeSelf()
      end
      self:updateCradPos()
      self.ui.Image_refresh_btn:setVisible(false)
      self.ui.Panel_tag:setVisible(true)
      self.fcaKeys.rope:setVisible(true)
      self.fcaKeys.rope:setAction(self.fcaKeys.rope.actName)
      self.newPassItem = nil
    end
  end
end

function activityLotteryPage:lineRewardRefresh(progress, lineReward)
  local lineRewards = self.objData:getLotteryLineReward(progress or 0, lineReward or {})
  local showItem = {}
  for i, v in ipairs(lineRewards) do
    if v.state ~= 3 or i == #lineRewards then
      showItem = v
      break
    end
  end
  if self.showlineReward and self.showlineReward.progress == showItem.progress then
    self.showlineReward:refresh(showItem.state - 1)
  else
    if self.showlineReward then
      self.showlineReward.icon:removeFromParentAndCleanup(true)
    end
    self.showlineReward = ed.taskItemModule.new(self, showItem.item, nil, -1, false, false, true)
    self.showlineReward.icon:setScale(0.9)
    self.showlineReward.icon:setPosition(ccp(180, 135))
    self.ui.ImageView_lift:addChild(self.showlineReward.icon, 98)
    self.showlineReward:refresh(showItem.state - 1)
    self.showlineReward.progress = showItem.progress
  end
  local count, str = showItem.progress - progress, T("\231\191\187\231\137\140%d\230\172\161\229\144\142\229\143\175\232\142\183\229\190\151")
  if showItem.state == 2 then
    str = T("\231\130\185\229\135\187\233\162\134\229\143\150\229\165\150\229\138\177")
    self.ui.Label_count_item:setVisible(false)
  elseif count <= 0 then
    self.ui.Label_count_item:setVisible(false)
    str = T("\229\183\178\232\142\183\229\190\151\229\133\168\233\131\168\229\144\137\229\133\134")
  else
    if self.ui.Label_count_item:isVisible() then
      self.ui.Label_count_item:runAction(CCSequence:create(ccArrayMake(CCEaseBackOut:create(CCScaleTo:create(0.2, 2, 2.5)), CCScaleTo:create(0.15, 1, 1))))
    end
    self.ui.Label_count_item:setVisible(true)
  end
  self.ui.Label_count_item:setString(count)
  local countParamStartIndex, countParamEndIndex = string.find(str, "%%d")
  if nil == countParamStartIndex then
    countParamStartIndex = string.len(str) + 1
    countParamEndIndex = countParamStartIndex
  end
  ed.setLabelString(self.ui.Label_count_item_des1, string.sub(str, 1, countParamStartIndex - 1))
  ed.setLabelString(self.ui.Label_count_item_des2, string.sub(str, countParamEndIndex + 1))
  local totalWid = self.ui.Label_count_item_des1:getContentSize().width + self.ui.Label_count_item_des2:getContentSize().width + self.ui.Label_count_item:getContentSize().width + 4
  if 180 < totalWid then
    self.ui.Label_count_item_des1:setScale(180 / totalWid)
    self.ui.Label_count_item_des2:setScale(180 / totalWid)
    self.ui.Label_count_item:setScale(180 / totalWid)
  end
  ed.layout.horizontalSortNode({
    self.ui.Label_count_item_des1,
    self.ui.Label_count_item,
    self.ui.Label_count_item_des2
  }, {
    2,
    2,
    0
  }, self.ui.ImageView_2965:getPositionX())
  self.showItem = showItem
end

local function getCradIdxPosfunc(index)
  index = index - 1
  return ccp(index % 4 * 80 + 40, math.floor(index / 4) * 80 + 40)
end

function activityLotteryPage:removeCradItemAct(itemIcons, isUpgrade)
  ed.playEffect(ed.sound.activityLottery.refresh)
  local dropOrder = {}
  local deleTime, touchTime = 0, 0
  local oripos
  for i, v in ipairs(itemIcons) do
    for w = 1, 4 do
      local idx = w == 4 and 0 or w
      if i % 4 == idx then
        v.actTime = (w - 1) * 0.1 + (12 < i and 0.1 or 0)
        v:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(v.actTime), CCEaseBackOut:create(CCMoveTo:create(1, ccp(v:getPositionX(), v:getPositionY() - 242))), CCCallFunc:create(function()
          if 12 < i and v._is_big and oripos then
            local epos = self.ui.ImageView_right:convertToNodeSpace(ccp(oripos.x, oripos.y))
            self.fcaKeys.high:setPosition(epos.x, epos.y)
            self.fcaKeys.high:setVisible(not self.fcaKeys.spiral:isVisible())
          end
        end))))
        deleTime = i <= 12 and deleTime + v.actTime or deleTime
        touchTime = touchTime + v.actTime
        if 12 < i and v._is_big then
          oripos = self.ui.panel_crad_lay:convertToWorldSpace(ccp(v:getPositionX(), v:getPositionY() - 242))
        end
        break
      end
    end
  end
  return deleTime
end

function activityLotteryPage:createCradLayer(rewards, isUpgrade)
  self.itemIcons = {}
  for i = 1, 12 do
    local item = itemCardMod.new(self, {_pos = i})
    if isUpgrade then
      item.node:setPosition(ccpAdd(getCradIdxPosfunc(i), ccp(0, 242)))
    else
      item.node:setPosition(getCradIdxPosfunc(i))
    end
    self.ui.panel_crad_lay:addChild(item.node)
    self:btRemoveMainTouchHandler({
      key = "item_card_" .. i
    })
    self:btRegisterButtonClick({
      button = item.node,
      key = "item_card_" .. i,
      param = {index = i},
      pressHandler = function(param, x, y)
        if self.itemIcons[param.index].iconTopBg:isVisible() then
          if not self.guideFca then
            addGuideFca(self)
          end
          self.guideFca:setPosition(ccpAdd(ccp(self.itemIcons[param.index].node:getPosition()), ccp(78, 70)))
          self.guideFca:setVisible(true)
          self.guideFca:setAction("Loop2")
        end
      end,
      cancelPressHandler = function()
        if self.guideFca then
          self.guideFca:setVisible(false)
        end
      end,
      clickHandler = function(param)
        if self.isTouch then
          self.newPassItem = self.itemIcons[param.index]
          if not self.newPassItem.param._state and not self.ui.Image_refresh_btn:isVisible() then
            local count = tonumber(self.ui.Label_coins:getString())
            if count <= 0 then
              return ed.showToast(T("\232\130\137\230\142\146\228\184\141\232\182\179\239\188\129"))
            end
            self.isTouch = false
            self.objWork:sendLotteryReq("_open_card", {
              _open_index = param.index
            })
            if not self.guideFca then
              addGuideFca(self)
            end
            self.guideFca:setVisible(true)
            self.guideFca:setAction(self.guideFca.actName)
            self:listenTimer(Timer:Once(0.5), function()
              self.guideFca:setVisible(false)
            end)
          elseif self.newPassItem.param._is_big and not self.ui.Image_refresh_btn:isVisible() then
            local layer = tonumber(self.ui.Label_newlayer:getString())
            if layer >= self.maximum then
              return ed.showToast(T("\229\183\178\229\136\176\232\190\190\233\161\182\229\177\130\239\188\129"))
            end
            ed.showConfirmDialog({
              text = T("\230\152\175\229\144\166\232\191\155\229\133\165\228\184\139\228\184\128\229\177\130\239\188\140\231\161\174\232\174\164\229\144\142\230\151\160\230\179\149\232\191\148\229\155\158\239\188\140\229\189\147\229\137\141\229\177\130\229\137\169\228\189\153\229\165\150\229\138\177\229\176\134\228\188\154\230\182\136\229\164\177\227\128\130"),
              rightHandler = function()
                self.isTouch = false
                self.objWork:sendLotteryReq("_enter_tray")
              end,
              rightText = T("\232\191\155\229\133\165")
            })
          else
            local _item = self.newPassItem.param._reward
            ed.UITool.openView("packageDetail", {
              id = _item._id,
              type = _item._type
            })
          end
        end
      end,
      pressScale = 0.95,
      normalScale = 1
    })
    table.insert(self.itemIcons, item)
  end
  for i, v in ipairs(rewards or {}) do
    self.itemIcons[v._pos or i]:refresh({
      _pos = v._pos or i,
      _reward = {
        _id = v._reward[1]._id,
        _amount = v._reward[1]._amount,
        _type = v._reward[1]._type or "item"
      },
      _is_big = v._is_big == 1,
      _state = true,
      onceCreate = true,
      isUpgrade = isUpgrade
    })
  end
end

function activityLotteryPage:updateCradPos()
  self:setTouchTime(1)
  ed.playEffect(ed.sound.activityLottery.shuffle)
  local runTime = 0.1
  local iconNode = {}
  for i, v in ipairs(self.itemIcons) do
    if not v.iconTopBg:isVisible() then
      local _random = v:flipAct(true)
      v.param._state = false
      runTime = runTime < _random and _random or runTime
    end
    table.insert(iconNode, {
      node = v.node,
      idx = i
    })
  end
  self.fcaKeys.high:setVisible(false)
  self.fcaKeys.spiral:setVisible(false)
  self:setTouchTime(runTime + 2.9)
  if self.progress == 0 then
    self:listenTimer(Timer:Once(runTime + 2.9), function()
      self.newShowGuideTxt = self:addGuideTxt()
    end)
  end
  self:listenTimer(Timer:Once(runTime + 0.1), function()
    for i, v in ipairs(self.itemIcons) do
      local pos = getCradIdxPosfunc(v.param._pos)
      v.node:runAction(CCSequence:create(ccArrayMake(CCEaseExponentialInOut:create(CCMoveTo:create(0.5, ccp(160, 120))), CCMoveTo:create(0.12, ccp(160 + (pos.x - 160) / 4, 120 + (pos.y - 120) / 4)), CCMoveTo:create(0.12, ccp(160, 120)), CCMoveTo:create(0.12, ccp(160 - (pos.x - 160) / 4, 120 - (pos.y - 120) / 4)), CCMoveTo:create(0.12, ccp(160, 120)), CCMoveTo:create(0.12, ccp(160 + (pos.x - 160) / 4, 120 + (pos.y - 120) / 4)), CCEaseExponentialOut:create(CCMoveTo:create(0.35, ccp(160, 120))))))
    end
    local buIdx = {
      6,
      5,
      1,
      2,
      3,
      4,
      8,
      12,
      11,
      10,
      9
    }
    
    local function actFunc(bu)
      if bu == 1 then
        iconNode[7].node:runAction(CCMoveTo:create(0.1, getCradIdxPosfunc(7)))
        table.remove(iconNode, 7)
      end
      local movePos, removeIdx = getCradIdxPosfunc(buIdx[bu]), 0
      for i, v in ipairs(iconNode) do
        v.node:stopAllActions()
        v.node:runAction(CCMoveTo:create(0.1, movePos))
        if v.idx == buIdx[bu] then
          removeIdx = i
        end
      end
      table.remove(iconNode, removeIdx)
      if buIdx[bu + 1] then
        self:listenTimer(Timer:Once(0.11), function()
          actFunc(bu + 1)
        end)
      end
    end
    
    self:listenTimer(Timer:Once(1.6), function()
      actFunc(1)
    end)
  end)
end

function activityLotteryPage:registerTouchHandler()
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.Image_refresh_btn,
    key = "btn_refresh",
    clickHandler = function()
      if self.isTouch then
        self.objWork:sendLotteryReq("_open_tray")
      end
    end,
    pressScale = 0.65,
    normalScale = 0.7
  })
  self:btRegisterButtonClick({
    button = ui.ImageView_2965,
    key = "btn_progress_reward",
    clickHandler = function()
      if self.isTouch then
        ed.UITool.openView("activityLotteryRewardPop", {
          progress = self.progress or 0,
          lineReward = self.objData:getLotteryLineReward(self.progress or 0, self.lineReward or {})
        })
      end
    end,
    pressScale = 0.95,
    normalScale = 1,
    clickInterval = 0.5
  })
  self:btRegisterButtonClick({
    button = ui.ImageView_2982,
    key = "pass_item_tip",
    clickHandler = function()
      ed.UITool.openView("packageDetail", {
        type = "item",
        id = self.consumeId,
        count = 1
      })
    end,
    pressScale = 0.95,
    normalScale = 1,
    clickInterval = 0.5
  })
  
  function self:btRegisterButtonClickToListItems(param)
    self:btRegisterButtonClick({
      button = param.button,
      key = "scene_touch_items_" .. param.index,
      param = param,
      clickInterval = 1,
      clickHandler = function(param, x, y)
        if self.showItem.state == 2 then
          self.objWork:sendLotteryReq("_line_reward", {
            _reward_index = self.showItem.progress
          })
        else
          ed.UITool.openView("packageDetail", self.showItem.item)
        end
      end,
      force = true,
      pressScale = 0.85,
      normalScale = 0.9
    })
  end
end

local function creatrImgNode(res, pos, scale, parent, z)
  local sprite = ed.createSprite(res)
  sprite:setPosition(pos)
  sprite:setScale(scale or 1)
  parent:addChild(sprite, z)
  return sprite
end

local function createItemIcon(reward, node)
  local icon = ed.createItemIcon({
    id = reward._id,
    type = reward._type,
    amount = reward._amount
  })
  icon:setScale(1)
  icon:setPosition(35, 35)
  node:addChild(icon, 1)
  return icon
end

function itemCardMod.new(mainSelf, param)
  return setmetatable({mainSelf = mainSelf, param = param}, {__index = itemCardMod}):create()
end

function itemCardMod:create()
  self.node = ed.createSprite("")
  self.node:setContentSize(CCSizeMake(70, 70))
  if self.param._reward then
    self.icon = createItemIcon(self.param._reward, self.node)
  end
  self.iconTopBg = creatrImgNode(string.format("UI/alpha/1080P/lottery/lottery_card_%s.png", (math.ceil(self.param._pos / 4) + self.param._pos) % 2 + 1), ccp(35, 35), 1, self.node, 9)
  local isStone = false
  if self.param._reward then
    local category = ed.readequip.value(self.param._reward._id, "Category")
    isStone = category == T("\231\129\181\233\173\130\231\159\179") or category == T("\231\162\142\231\137\135")
  end
  local frameMask = string.format("UI/alpha/1080P/common/frame/%s.png", isStone and "fragment_stencil" or "equip_frame_mask")
  self.passImg = creatrImgNode("UI/alpha/1080P/package/selected.png", ccp(46, 43), 0.85, creatrImgNode(frameMask, ccp(35, 35), 1, self.node, 9), 9):getParent()
  if self.param._state then
    self.iconTopBg:setVisible(false)
  else
    self.passImg:setVisible(false)
  end
  return self
end

function itemCardMod:flipAct(vis)
  local time = math.random(10, 50) / 100
  self.node:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(time), CCEaseBackIn:create(CCScaleTo:create(0.2, 1, 0.01)), CCCallFunc:create(function()
    self.iconTopBg:setVisible(vis)
    self.passImg:setVisible(not vis)
  end), CCEaseBackOut:create(CCScaleTo:create(0.2, 1, 1)))))
  return time + 0.2
end

function itemCardMod:doorFcaAct()
  if not self.door and self.param._is_big then
    local oripos = self.mainSelf.ui.panel_crad_lay:convertToWorldSpace(ccp(self.node:getPosition()))
    local epos = self.mainSelf.ui.ImageView_right:convertToNodeSpace(ccp(oripos.x, oripos.y))
    self.mainSelf.fcaKeys.spiral:setPosition(epos.x, epos.y)
    self.mainSelf.fcaKeys.spiral:setVisible(true)
    self.mainSelf.fcaKeys.high:setVisible(false)
    self.mainSelf.ui.Panel_tag:setVisible(false)
    self.mainSelf.ui.Label_open:setVisible(true)
  end
end

function itemCardMod:refresh(param)
  if self.param._reward ~= param._reward then
    if self.icon then
      self.icon:removeFromParentAndCleanup(true)
    end
    self.icon = createItemIcon(param._reward, self.node)
    self.passImg:removeFromParentAndCleanup(true)
    local isStone = false
    if param._reward then
      local category = ed.readequip.value(param._reward._id, "Category")
      isStone = category == T("\231\129\181\233\173\130\231\159\179") or category == T("\231\162\142\231\137\135")
    end
    local frameMask = string.format("UI/alpha/1080P/common/frame/%s.png", isStone and "fragment_stencil" or "equip_frame_mask")
    self.passImg = creatrImgNode("UI/alpha/1080P/package/selected.png", ccp(46, 43), 0.85, creatrImgNode(frameMask, ccp(35, 35), 1, self.node, 9), 9):getParent()
    self.passImg:setVisible(false)
  end
  self.param = param
  if self.iconTopBg:isVisible() and param._state then
    if param.onceCreate then
      self.iconTopBg:setVisible(false)
      self.passImg:setVisible(not self.mainSelf.ui.Image_refresh_btn:isVisible())
    else
      self:flipAct(false)
    end
  else
    self.passImg:setVisible(false)
  end
  if param._is_big then
    if not param.isUpgrade then
      local oripos = self.mainSelf.ui.panel_crad_lay:convertToWorldSpace(ccp(self.node:getPosition()))
      local epos = self.mainSelf.ui.ImageView_right:convertToNodeSpace(ccp(oripos.x, oripos.y))
      self.mainSelf.fcaKeys.high:setPosition(epos.x, epos.y)
      self.mainSelf.fcaKeys.high:setVisible(not self.mainSelf.fcaKeys.spiral:isVisible())
    end
    self.node._is_big = true
    if not self.mainSelf.ui.Image_refresh_btn:isVisible() and param.onceCreate then
      self:doorFcaAct()
    end
  end
  self.param.isUpgrade = false
  self.param.onceCreate = false
end

function activityLotteryPage:talkLayerTouchShow()
  local taskLink = {}
  for k, v in pairs(ed.getDataTable("LotteryTalk")) do
    local taskStr = {}
    for ii, vv in ipairs(v) do
      taskStr[ii] = vv["Talk Text"]
    end
    table.insert(taskLink, taskStr)
  end
  self.NTLink = math.random(1, #taskLink)
  self.NTIndex = 1
  self.NTIsRl = 0
  local ui = self.ui
  
  local function talkActFunc(node, isTxt, tis, Label)
    if isTxt then
      self.ui.ImageView_lift:stopAllActions()
      if taskLink[self.NTLink][self.NTIndex] and self.NTIsRl ~= tis then
        node:setString(taskLink[self.NTLink][self.NTIndex])
        self.NTIndex = self.NTIndex + 1
        self.NTIsRl = tis
        self.ui.ImageView_lift:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(2.7), CCCallFunc:create(function()
          self.NTLink = math.random(1, #taskLink)
          self.NTIndex = 1
          self.NTIsRl = 0
        end))))
      else
        self.NTLink = math.random(1, #taskLink)
        self.NTIndex = 1
        self.NTIsRl = 0
      end
    elseif Label then
      local size = Label:getContentSize()
      size.width = size.width < 100 and 100 or size.width
      node:setContentSize(CCSizeMake(size.width + 20, 52))
    end
    self.ui.Panel_lift_talk:setZOrder(self.NTIsRl < 2 and 9 or 1)
    self.ui.Panel_right_talk:setZOrder(self.NTIsRl < 2 and 1 or 9)
    node:stopAllActions()
    node:runAction(CCSequence:create(ccArrayMake(CCFadeTo:create(0.3, 255), CCDelayTime:create(2), CCFadeTo:create(0.5, 0))))
  end
  
  local nodeNameKey = {"lift", "right"}
  for i, v in ipairs(nodeNameKey) do
    ui["Image_" .. v .. "_talk"]:setOpacity(0)
    ui["Label_" .. v .. "_talk"]:setOpacity(0)
    local layer = CCLayer:create()
    layer:setContentSize(CCSizeMake(150, 150))
    layer:setPosition(v == "lift" and 115 or 280, 285)
    ui.ImageView_lift:addChild(layer)
    self:btRegisterButtonClick({
      button = layer,
      key = "lay_talk" .. v,
      clickHandler = function()
        talkActFunc(ui["Label_" .. v .. "_talk"], true, i)
        talkActFunc(ui["Image_" .. v .. "_talk"], nil, nil, ui["Label_" .. v .. "_talk"])
        if tonumber(self.ui.Label_newlayer:getString()) % 5 ~= 0 then
          self.fcaKeys.Blue:setAction(string.format("Start%s", math.random(2, 3)))
        end
        self.talkCount = (self.talkCount or 0) + 1
        if 5 <= self.talkCount then
          self.objWork:sendLotteryReq("_talk", {
            _count = self.talkCount
          })
          self.talkCount = nil
        end
      end
    })
  end
end

function activityLotteryPage:addGuideAct()
  if self.newShowGuideAct then
    self.newShowGuideAct.removeSelf()
  end
  local posx, posy = self.ui.Image_refresh_btn:getPosition()
  local aperture = creatrImgNode("UI/alpha/1080P/guide/tutorial_circle_big.png", ccp(posx, posy), 1, self.ui.page_lay, 999)
  local hand = creatrImgNode("UI/alpha/1080P/guide/tutorial_finger.png", ccp(posx + 30, posy - 39), 1, self.ui.page_lay, 999)
  aperture:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCScaleTo:create(0.65, 1.35), CCScaleTo:create(0.65, 1))))
  hand:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCMoveBy:create(0.65, ccp(-10, 10)), CCMoveBy:create(0.65, ccp(10, -10)))))
  local guideAct = {
    removeSelf = function()
      aperture:removeFromParentAndCleanup(true)
      hand:removeFromParentAndCleanup(true)
      self.newShowGuideAct = nil
    end
  }
  return guideAct
end

function activityLotteryPage:addGuideTxt()
  if self.newShowGuideTxt then
    self.newShowGuideTxt.removeSelf()
  end
  local countColor = "white"
  local img_guide_txt = creatrImgNode("UI/alpha/1080P/lottery/lottery_guide_bg.png", ccp(240, 195), 1, self.ui.ImageView_right, 9999)
  local guide_txt = ed.ui.autoText.new()
  guide_txt:initParam({
    context = T("\231\130\185\229\135\187\228\187\187\230\132\143\231\137\140\233\157\162\239\188\140\230\182\136\232\128\151<sprite src=UI/alpha/1080P/lottery/lottery_meat_icon_s.png><lable color=%s>\195\1511</lable>\229\188\128\229\167\139\231\191\187\231\137\140", countColor),
    fontSize = 18,
    lineSpacing = 4,
    maxWidth = 350
  })
  guide_txt.node:setPosition(40, 28)
  img_guide_txt:addChild(guide_txt.node)
  img_guide_txt:setOpacity(0)
  guide_txt.node:setOpacity(0)
  img_guide_txt:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(1, 255), CCFadeTo:create(2, 155))))
  guide_txt.node:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(1, 255), CCFadeTo:create(2, 155))))
  local guideTxt = {
    removeSelf = function()
      img_guide_txt:removeFromParentAndCleanup(true)
      self.newShowGuideTxt = nil
    end
  }
  return guideTxt
end
