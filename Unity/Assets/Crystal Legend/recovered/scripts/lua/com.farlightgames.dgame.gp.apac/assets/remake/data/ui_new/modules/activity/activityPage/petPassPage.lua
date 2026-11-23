local petPassPage = {}
ed.ui.activityPetPassPage = petPassPage
local titleTips = T("<lable color=ccc3(199,149,229) fontName=fontBold>\232\180\173</lable>") .. T("<lable color=ccc3(215,247,255) fontName=fontBold fontSize=f24 strokeColor=fundPassNumber strokeSize=1>68\229\133\131</lable>") .. T("<lable color=ccc3(199,149,229) fontName=fontBold>\229\159\185\232\130\178\229\159\186\233\135\145 \229\133\177\229\190\151</lable>") .. T("<lable color=ccc3(215,247,255) fontName=fontBold fontSize=f24 strokeColor=fundPassNumber strokeSize=1>\228\187\183\229\128\1882400\229\133\131</lable>") .. T("<lable color=ccc3(199,149,229) fontName=fontBold>\231\154\132\229\165\150\229\138\177 \230\148\182\231\155\138\231\142\135\232\190\190\229\136\176</lable>")

function petPassPage.create(base, param, pageKey)
  local self = {}
  setmetatable(petPassPage, {__index = base})
  setmetatable(self, {__index = petPassPage})
  self:init(param, pageKey)
  return self
end

function petPassPage:init(param, pageKey)
  self.pageKey = pageKey or ""
  self.simplePassId = ed.passDefine.PET_PASS
  self.firstAvailableReward = nil
  self.firstNotReachedReward = nil
  self:initView()
  self:setButtonClick()
  self:addListenEvent()
end

function petPassPage:initView()
  local container, ui = ed.editorui(ed.uieditor.activity_pet_fund)
  self.container = container
  self.ui = ui
  local tipSize = self.ui.title_tips:getContentSize()
  local titleAutoText = ed.ui.autoText.new()
  local param = {
    context = titleTips,
    fontSize = 17,
    maxWidth = tipSize.width
  }
  titleAutoText:initParam(param)
  self.ui.title_tips:addChild(titleAutoText.node)
  titleAutoText.node:setPosition(10, tipSize.height * 0.5)
  local rateLabel = ed.ui.gradientLabel.create({
    text = "3500%",
    fontSize = 36,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16764053),
    endColor = ed.toccc3(16777215),
    strokeColor = ed.toccc3(15432721),
    strokeSize = 1
  })
  self.ui.title_tips:addChild(rateLabel.node)
  rateLabel.node:setPosition(tipSize.width, tipSize.height * 0.5)
  ed.setLabelStroke(self.ui.label_buy, ed.toccc3(10641433), 1)
  self.ui.level:setFontName(ed.font)
  self.ui.label_base_reward:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_base_reward, ed.toccc3(8008630), 1)
  ed.setLabelStroke(self.ui.label_advanced_reward, ed.toccc3(13447067), 1.5)
  self.ui.label_base_reward:setFontName(ed.fontBold)
  self.ui.label_advanced_reward:setFontName(ed.fontBold)
  self:initDragList()
  self:refreshBuyBtn()
  self:refreshDragList(true)
end

function petPassPage:initDragList()
  local size = self.ui.pass_list:getContentSize()
  local param = {
    cliprect = CCRectMake(0, 0, size.width, size.height),
    noshade = true,
    container = self.ui.pass_list,
    priority = 300,
    zorder = 99,
    mcpMode = true
  }
  self.rewardList = ed.draglist.create(param)
end

function petPassPage:refreshDragList(beResetPos)
  local rewardDataList = ed.passDataMgr:getPassRewardList(self.simplePassId)
  local cx, cy = self.rewardList:getListPos()
  self.rewardList:clearList()
  local posX = 0
  local gapX = 1
  local itemSize
  for requireLevel, rewardData in pairs(rewardDataList) do
    local rewardItem = self:createRewardItem(requireLevel, rewardData)
    itemSize = rewardItem:getContentSize()
    rewardItem:setPosition(ccp(posX + gapX, -10))
    self.rewardList:addItem(rewardItem)
    posX = posX + itemSize.width + gapX
  end
  self.rewardList:initListWidth(posX)
  if beResetPos and (self.firstAvailableReward or self.firstNotReachedReward) then
    local index = 1
    if self.firstAvailableReward then
      index = self.firstAvailableReward
    else
      index = self.firstNotReachedReward
    end
    cx = -(index - 1) * (gapX + itemSize.width)
    self.rewardList:setListPos(ccp(cx, cy))
  else
    self.rewardList:setListPos(ccp(cx, cy))
  end
end

function petPassPage:refreshBuyBtn()
  if ed.passDataMgr:getPassRank(self.simplePassId) >= 1 then
    self.ui.btn_buy:setVisible(false)
  else
    self.ui.btn_buy:setVisible(true)
  end
end

function petPassPage:createRewardItem(requireLevel, data)
  local baseRewardData = data[1]
  local advanceRewardData = data[2]
  local container, ui = ed.editorui(ed.uieditor.activity_fund_pass_item)
  container:setContentSize(ui.bg:getContentSize())
  local titleLevel = ed.getDataTable("SimplePass")[self.simplePassId]["Level" .. requireLevel]
  ui.title:setString(titleLevel .. "\228\184\170")
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
    ui.title:setColor(ccc3(255, 251, 201))
    if not self.firstAvailableReward then
      self.firstAvailableReward = requireLevel
    end
  else
    ui.bg:setVisible(false)
    ui.title:setColor(ccc3(255, 251, 201))
  end
  if (baseRewardData.rewardState == ed.passDefine.REWARD_STATE_NOT_REACHED or advanceRewardData.rewardState == ed.passDefine.REWARD_STATE_NOT_REACHED) and not self.firstNotReachedReward then
    self.firstNotReachedReward = requireLevel
  end
  self:btRegisterButtonClick({
    button = baseRewardIcon,
    key = "baseReward" .. baseRewardData.rewardPos .. baseRewardData.rewardIndex,
    force = true,
    clickHandler = function()
      self:clickReward(baseRewardData, false)
    end
  })
  self:btRegisterButtonClick({
    button = advancedRewardIcon,
    key = "advancedReward" .. baseRewardData.rewardPos .. baseRewardData.rewardIndex,
    force = true,
    clickHandler = function()
      self:clickReward(advanceRewardData, false)
    end
  })
  return container
end

function petPassPage:createRewardIcon(rewardData)
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
    local imageLock = ed.createSprite("UI/alpha/1080P/common/pvp_battle_lock.png")
    icon:addChild(imageLock)
    imageLock:setPosition(ccp(75, 75))
  end
  return icon
end

function petPassPage:clickReward(rewardData, isAllReward)
  if rewardData.rewardState == ed.passDefine.REWARD_STATE_AVAILABLE then
    local param = {
      passId = self.simplePassId,
      isAllReward = isAllReward,
      rewardPos = rewardData.rewardPos,
      rewardIndex = rewardData.rewardIndex
    }
    ed.passNetWork:simplePassReq(param)
  else
    ed.UITool.openView("packageDetail", {
      id = rewardData.rewardId,
      type = rewardData.rewardType
    })
  end
end

function petPassPage:setButtonClick()
  ed.passNetWork:simplePassOpenPanel(self.simplePassId)
end

function petPassPage:addListenEvent()
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

function petPassPage:close()
end
