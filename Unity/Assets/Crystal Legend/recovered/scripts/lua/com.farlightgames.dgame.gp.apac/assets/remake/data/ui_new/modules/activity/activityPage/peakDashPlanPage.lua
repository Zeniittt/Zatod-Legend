local peakDashPlanPage = {}
ed.ui.peakDashPlanPage = peakDashPlanPage

function peakDashPlanPage.getTitleTips()
  local cost = string.format("<lable startColor=0xbdf0ff endColor=0xe7faff fontName=fontBold fontSize=f24 strokeColor=fundPassNumber strokeSize=1.5>%s</lable>", ed.RechargeManager:getCostDisplayByCNYCost(68))
  local val = string.format("<lable startColor=0xbdf0ff endColor=0xe7faff fontName=fontBold fontSize=f24 strokeColor=fundPassNumber strokeSize=1.5>%s</lable>", T("\228\187\183\229\128\18824000\233\146\187\231\159\179"))
  local ratio = string.format("<lable startColor=0xf7f650 endColor=0xfff6b9 fontName=fontBold fontSize=f38 strokeColor=0xff7e01 strokeSize=1.5>%s</lable>", "3500%")
  local titleTip = T("\232\180\173%s\229\183\133\229\179\176\229\159\186\233\135\145 \229\133\177\229\190\151%s\231\154\132\229\165\150\229\138\177 \230\148\182\231\155\138\231\142\135\232\190\190%s", cost, val, ratio)
  return titleTip
end

function peakDashPlanPage.create(base, param, pageKey)
  local self = {}
  setmetatable(peakDashPlanPage, {__index = base})
  setmetatable(self, {__index = peakDashPlanPage})
  self:init(param, pageKey)
  return self
end

function peakDashPlanPage:init(param, pageKey)
  self.pageKey = pageKey or ""
  self.simplePassId = ed.passDefine.PEAKDASH_PASS
  self.firstAvailableReward = nil
  self.firstNotReachedReward = nil
  self.rewardListCon = {}
  self:initView()
  self:setButtonClick()
  self:addListenEvent()
end

function peakDashPlanPage:getRewardDataNum()
  local passNum = 0
  local passData = ed.passDataMgr:getPassData(self.simplePassId)
  if passData then
    local extendData = passData.extend
    passNum = extendData._pass_exp
  end
  return passNum
end

function peakDashPlanPage:initView()
  local container, ui = ed.editorui(ed.uieditor.peakDashPass)
  self.container = container
  self.ui = ui
  local tipSize = self.ui.title_tips:getContentSize()
  local titleAutoText = ed.ui.autoText.new()
  local param = {
    context = peakDashPlanPage.getTitleTips(),
    fontSize = 15,
    maxWidth = 999999,
    fontName = ed.fontBold,
    color = ed.toccc3(15054939),
    align = "LEFT"
  }
  titleAutoText:initParam(param)
  self.ui.title_tips:addChild(titleAutoText.node)
  local curWidth, _ = titleAutoText:getCurContentSize()
  local minScale = math.min(1, tipSize.width / curWidth)
  titleAutoText.node:setScale(minScale)
  titleAutoText.node:setPosition((tipSize.width - minScale * curWidth) * 0.5, tipSize.height - 20)
  ed.setLabelStroke(self.ui.label_buy, ed.toccc3(10641433), 1)
  local deltaWid = 1170 - ed.display.winSize.width
  ed.UITool.setPositionBy(self.ui.ImageView_341, ccp(-deltaWid * 0.5 * 0.26, 0))
  self.ui.level:setFontName(ed.font)
  self.ui.label_base_reward:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_base_reward, ed.toccc3(8012592), 1)
  self.ui.label_base_reward:limitWidthByScale(85)
  local advance_lab = ed.ui.gradientLabel.create({
    text = T("\229\159\186\233\135\145\229\155\158\230\138\165"),
    color = ed.toccc3(13528842),
    fontSize = 18,
    startColor = ed.toccc3(16775132),
    endColor = ed.toccc3(16773996),
    strokeColor = ed.toccc3(13528842),
    strokeSize = 1,
    fontName = ed.fontBold
  })
  ed.UITool.replaceUINew(self.ui, "label_advanced_reward", advance_lab.node)
  self.ui.level:limitWidthByScale(90)
  ed.setLabelStroke(self.ui.left_time_label, ed.toccc3(12922909), 1)
  self:initDragList()
  self:refreshBuyBtn()
  self:refreshDragList(true)
end

function peakDashPlanPage:initDragList()
  local size = self.ui.pass_list:getContentSize()
  local param = {
    cliprect = CCRectMake(0, 0, size.width, size.height),
    noshade = true,
    container = self.ui.pass_list,
    priority = 300,
    zorder = 99,
    mcpMode = true,
    doPressIn = function(x, y)
      for k, v in pairs(self.rewardListCon or {}) do
        local ui = v.ui
        if ed.containsPoint(ui.base_reward_icon, x, y) and ui.base_reward_icon:isVisible() then
          return v.baseRewardData
        end
        if ed.containsPoint(ui.advanced_reward_icon, x, y) and ui.advanced_reward_icon:isVisible() then
          return v.advanceRewardData
        end
      end
    end,
    doClickIn = function(x, y, data)
      self:clickReward(data, false)
    end
  }
  self.rewardList = ed.draglist.create(param)
  self.frontGap = 10
  self.itemWid = 90
end

function peakDashPlanPage:addProgressBar(progress)
  local rewardDataList = ed.passDataMgr:getPassRewardList(self.simplePassId)
  local rewardNum = #rewardDataList
  local bar_bg = ed.createScale9Sprite("UI/alpha/1080P/fundpeak/line1.png", CCRectMake(50, 3, 400, 1))
  local ori_size = bar_bg:getContentSize()
  bar_bg:setContentSize(CCSizeMake(self.frontGap + self.itemWid * (rewardNum - 0.5), ori_size.height))
  bar_bg:setAnchorPoint(ccp(0, 0.5))
  bar_bg:setPosition(ccp(-self.frontGap, 199))
  local bar_progress = ed.createScale9Sprite("UI/alpha/1080P/fundpeak/line.png", CCRectMake(3, 1, 174, 1))
  local ori_size1 = bar_progress:getContentSize()
  bar_progress:setAnchorPoint(ccp(0, 0.5))
  bar_bg:addChild(bar_progress)
  bar_progress:setPositionY(ori_size.height * 0.5)
  local first = true
  local bar_len = self.frontGap
  local lastLevel = 0
  for requireLevel, rewardData in pairs(rewardDataList) do
    local titleLevel = ed.getDataTable("SimplePass")[self.simplePassId]["Level" .. requireLevel]
    local wid = self.itemWid
    if first then
      wid = wid * 0.5
      first = nil
    end
    if progress <= titleLevel then
      bar_len = bar_len + wid * (progress - lastLevel) / (titleLevel - lastLevel)
      break
    else
      bar_len = bar_len + wid
      lastLevel = titleLevel
    end
  end
  bar_progress:setContentSize(CCSizeMake(bar_len, ori_size1.height))
  for i = 1, rewardNum do
    local rewardLine = ed.createSprite("UI/alpha/1080P/fundpeak/point.png")
    bar_bg:addChild(rewardLine, 1)
    rewardLine:setPositionX(self.frontGap + self.itemWid * (i - 0.5))
    rewardLine:setPositionY(ori_size.height * 0.5)
  end
  self.rewardList:addItem(bar_bg)
end

function peakDashPlanPage:refreshDragList(beResetPos)
  local cur_exp = self:getRewardDataNum()
  ed.setLabelString(self.ui.cur_level_label, cur_exp)
  local cx, cy = self.rewardList:getListPos()
  self.rewardList:clearList()
  local rewardDataList = ed.passDataMgr:getPassRewardList(self.simplePassId)
  local rewardNum = #rewardDataList
  self.rewardList:initListWidth(self.frontGap + rewardNum * self.itemWid)
  local posX = 0
  local gapX = 1
  local itemSize
  for requireLevel, rewardData in pairs(rewardDataList) do
    local rewardItem = self:createRewardItem(requireLevel, rewardData)
    itemSize = rewardItem:getContentSize()
    rewardItem:setPositionX(posX)
    self.rewardList:addItem(rewardItem)
    posX = posX + self.itemWid
  end
  if beResetPos and (self.firstAvailableReward or self.firstNotReachedReward) then
    local index = 1
    if self.firstAvailableReward then
      index = self.firstAvailableReward
    else
      index = self.firstNotReachedReward
    end
    cx = -(index - 2) * self.itemWid
    self.rewardList:setListPos(ccp(cx, cy), true)
  else
    self.rewardList:setListPos(ccp(cx, cy))
  end
  self:addProgressBar(cur_exp)
end

function peakDashPlanPage:refreshBuyBtn()
  if ed.passDataMgr:getPassRank(self.simplePassId) >= 1 then
    self.ui.btn_buy:setVisible(false)
    self.ui.left_time_bg:setVisible(false)
  else
    local function freshLeftTime()
      if not self.endTime then
        return
      end
      ed.setLabelString(self.ui.left_time_label, T("\229\137\169\228\189\153%s", ed.time2dhmsV2(self.endTime - ed.getServerTime())))
      ed.layout.horizontalSortNode({
        self.ui.left_time_icon,
        self.ui.left_time_label
      }, {5, 0}, self.ui.left_time_bg:getContentSize().width * 0.5)
    end
    
    self.ui.btn_buy:setVisible(true)
    self.ui.left_time_bg:setVisible(true)
    if not self.endTime then
      self.endTime = ed.passDataMgr:getPassData(self.simplePassId).endTime
      freshLeftTime()
      self:listenTimer(Timer:Always(1), freshLeftTime())
    end
  end
end

function peakDashPlanPage:createRewardItem(requireLevel, data)
  local baseRewardData = data[1]
  local advanceRewardData = data[2]
  local container, ui = ed.editorui(ed.uieditor.peakDashPassItem)
  container:setContentSize(ui.bg:getContentSize())
  local titleLevel = ed.getDataTable("SimplePass")[self.simplePassId]["Level" .. requireLevel]
  ui.title:setString(titleLevel)
  local baseRewardIcon = self:createRewardIcon(baseRewardData)
  local advancedRewardIcon = self:createRewardIcon(advanceRewardData)
  baseRewardIcon:setScale(1)
  advancedRewardIcon:setScale(1)
  ui.base_reward_icon:addChild(baseRewardIcon)
  ed.layout.centerInParent(baseRewardIcon)
  ui.advanced_reward_icon:addChild(advancedRewardIcon)
  ed.layout.centerInParent(advancedRewardIcon)
  if baseRewardData.rewardState == ed.passDefine.REWARD_STATE_AVAILABLE or advanceRewardData.rewardState == ed.passDefine.REWARD_STATE_AVAILABLE then
    ui.bg:setVisible(true)
    ed.setLabelColor(ui.title, ccc3(255, 232, 160))
    if not self.firstAvailableReward then
      self.firstAvailableReward = requireLevel
    end
  elseif baseRewardData.rewardState == ed.passDefine.REWARD_STATE_NOT_REACHED then
    ui.bg:setVisible(false)
    ed.setLabelColor(ui.title, ccc3(255, 176, 22))
  else
    ui.bg:setVisible(false)
    ed.setLabelColor(ui.title, ccc3(200, 156, 72))
  end
  if (baseRewardData.rewardState == ed.passDefine.REWARD_STATE_NOT_REACHED or advanceRewardData.rewardState == ed.passDefine.REWARD_STATE_NOT_REACHED) and not self.firstNotReachedReward then
    self.firstNotReachedReward = requireLevel
  end
  table.insert(self.rewardListCon, {
    container = container,
    ui = ui,
    baseRewardData = baseRewardData,
    advanceRewardData = advanceRewardData
  })
  return container
end

function peakDashPlanPage:createRewardIcon(rewardData)
  local id = rewardData.rewardId
  local rewardType = rewardData.rewardType
  local amount = rewardData.rewardAmount
  local rewardState = rewardData.rewardState
  local icon = ed.createItemIcon({
    id = id,
    type = rewardType,
    amount = amount
  })
  if rewardState == ed.passDefine.REWARD_STATE_COMPLETED then
    local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
    local imageReceived = ed.createSprite("UI/alpha/1080P/package/selected.png")
    icon:addChild(mask, 1)
    icon:addChild(imageReceived, 2)
    imageReceived:setPosition(ccp(45, 40))
    mask:setPosition(ccp(45, 45))
  elseif rewardState == ed.passDefine.REWARD_STATE_AVAILABLE then
    local eff = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
    icon:addChild(eff)
    eff:setPosition(46, 45)
    eff:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
  elseif rewardState == ed.passDefine.REWARD_STATE_LOCK then
    local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
    local imageLock = ed.createSprite("UI/alpha/1080P/common/pvp_battle_lock.png")
    icon:addChild(mask, 1)
    icon:addChild(imageLock, 2)
    mask:setPosition(ccp(45, 45))
    imageLock:setPosition(ccp(75, 75))
  end
  return icon
end

function peakDashPlanPage:clickReward(rewardData, isAllReward)
  if rewardData.rewardState == ed.passDefine.REWARD_STATE_AVAILABLE then
    local param = {
      passId = self.simplePassId,
      isAllReward = isAllReward,
      rewardPos = rewardData.rewardPos,
      rewardIndex = rewardData.rewardIndex
    }
    ed.passNetWork:simplePassReq(param)
  else
    ed.ui.packageDetailWin.create({
      id = rewardData.rewardId
    }):popWindow()
  end
end

function peakDashPlanPage:setButtonClick()
  ed.passNetWork:simplePassOpenPanel(self.simplePassId)
end

function peakDashPlanPage:addListenEvent()
  self:btRegisterButtonClick({
    button = self.ui.btn_buy,
    key = self.ui.btn_buy_press,
    force = true,
    pressScale = 0.8,
    normalScale = 0.85,
    clickHandler = function()
      local buyRank = 1
      ed.passDataMgr:doRechargePass(self.simplePassId, buyRank)
    end
  })
  self:listenEvent("UpdatePassData", function(id)
    if id == self.simplePassId then
      self:refreshDragList(false)
      self:refreshBuyBtn()
    end
  end)
  self:listenEvent("passBuySuccess", function(id, rank)
    if id == self.simplePassId then
      self:refreshDragList(true)
      self:refreshBuyBtn()
    end
  end)
end

function peakDashPlanPage:close()
end
