local temperingPassPage = {}
ed.ui.temperingPassPage = temperingPassPage
local priceType = T("\229\133\131")
local titleTips = T("<lable color=ccc3(218,189,236) fontName=fontBold>\232\180\173</lable><lable color=ccc3(215,247,255) fontName=fontBold fontSize=f24 strokeColor=fundPassNumber strokeSize=1>%s</lable><lable color=ccc3(218,189,236) fontName=fontBold>\233\148\187\233\128\160\229\159\186\233\135\145 \229\133\177\229\190\151</lable><lable color=ccc3(215,247,255) fontName=fontBold fontSize=f24 strokeColor=fundPassNumber strokeSize=1>\228\187\183\229\128\188%s</lable><lable color=ccc3(218,189,236) fontName=fontBold>\231\154\132\229\165\150\229\138\177 \230\148\182\231\155\138\231\142\135\232\190\190\229\136\176</lable>")

function temperingPassPage.create(base, param, pageKey)
  local self = {}
  setmetatable(temperingPassPage, {__index = base})
  setmetatable(self, {__index = temperingPassPage})
  self:init(param, pageKey)
  return self
end

function temperingPassPage:init(param, pageKey)
  self.pageKey = pageKey or ""
  self:initView()
  self:setButtonClick()
  self:addListenEvent()
end

function temperingPassPage:initView()
  local container, ui = ed.editorui(ed.uieditor.temperingPass)
  self.container = container
  self.ui = ui
  self.simplePassId = ed.passDefine.TEMPERING_PASS
  self.rewardListCon = {}
  self:initBtnColor()
  self:initTitleText()
  self:initDragList()
  self:setGradientFont()
  self:adaptResolution()
end

function temperingPassPage:getRewardDataNum()
  local passNum = 0
  local passData = ed.passDataMgr:getPassData(self.simplePassId)
  if passData then
    local extendData = passData.extend
    passNum = extendData._pass_exp
  end
  return passNum
end

function temperingPassPage:initTitleText()
  local tipSize = self.ui.title_tips:getContentSize()
  local titleAutoText = ed.ui.autoText.new()
  local config = ed.getDataTable("SimplePass")[ed.passDefine.TEMPERING_PASS]
  local priceBase = config[string.format("R1 Price Value")]
  local priceUp
  if ed.isAreaOverSea() then
    priceUp = config[string.format("R1 Price Value")] * 35
  else
    priceUp = 2400
  end
  local titleContent = string.format(titleTips, priceBase .. priceType, priceUp .. priceType)
  local param = {
    context = titleContent,
    fontSize = 18,
    maxWidth = tipSize.width
  }
  titleAutoText:initParam(param)
  self.ui.label_title:addChild(titleAutoText.node)
  titleAutoText.node:setPositionX(-tipSize.width / 2 + 40)
  titleAutoText.node:setPositionY(tipSize.height - 35)
  self:refreshNum()
end

function temperingPassPage:refreshNum()
  local number = self:getRewardDataNum()
  ed.setLabelColor(self.ui.label_base_number, ed.toccc3(16762689))
  self.ui.label_base_number:setString(T("\229\189\147\229\137\141:" .. number .. "\230\172\161"))
end

function temperingPassPage:initBtnColor()
  ed.setLabelStroke(self.ui.label_buy, ed.toccc3(10641433), 1)
  self.ui.label_base_reward:setFontName(ed.fontBold)
  self.ui.label_advanced_reward:setFontName(ed.fontBold)
  ed.setLabelColor(self.ui.label_base_reward, ccc3(254, 255, 189))
  ed.setLabelStroke(self.ui.label_base_reward, ed.toccc3(11949363), 1)
  self.ui.label_base_reward:limitWidthByScale(85)
  self.ui.level:limitWidthByScale(90)
  self:refreshBuyBtn()
end

function temperingPassPage:adaptResolution()
  local widthWin = ed.display.winSize.width
  local heightWin = ed.display.winSize.height
  local newWid = ed.display.halfFixedWidth * 2
  local newHei = ed.display.halfFixedHeight * 2
  local lrWne = 0.25
  local leftMoPosX = (1 - lrWne) * newWid
  local ui = self.ui
  local bgFixWidth = ed.display.halfFixedWidth * 0.8
  local bgFixHeight = ed.display.halfFixedHeight * 1
  self.bgFixWidth = bgFixWidth
  self.bgFixHeight = bgFixHeight
  ed.UITool.setContentSizeBy(ui.page_lay, bgFixWidth, bgFixHeight)
  local scale = widthWin / heightWin
  local changeScale = 0.92
  if scale < 1.778 then
    ui.page_lay:setScale(changeScale)
    ui.page_lay:setPositionX(self.ui.page_lay:getPositionX() - leftMoPosX / 2 - 40)
    local size = ui.pass_list:getContentSize()
    ui.pass_list:setClipRect(CCRectMake(0, 0, size.width * changeScale, size.height))
    if scale < 1.51 then
      ui.page_lay:setPositionY(self.ui.page_lay:getPositionY() + 25)
    end
  else
    ui.page_lay:setPositionX(self.ui.page_lay:getPositionX() - leftMoPosX / 2 + 80)
  end
end

function temperingPassPage:setGradientFont()
  local mask1 = ed.createSprite("UI/alpha/1080P/legendequipfund/select_word.png")
  local mask2 = ed.createSprite("UI/alpha/1080P/legendequipfund/select_word.png")
  local rewardLabel = ed.ui.gradientLabel.create({
    text = T("\229\159\186\233\135\145\229\155\158\230\138\165"),
    fontSize = 18,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16777215),
    endColor = ed.toccc3(16775337),
    strokeSize = 1,
    strokeColor = ed.toccc3(13528842)
  })
  self.ui.title_tips_Copy0:addChild(mask1, 0)
  self.ui.title_tips_Copy0:addChild(rewardLabel.node, 1)
  rewardLabel:setPosition(ccp(28, 20))
  mask1:setPosition(ccp(28, 20))
  local titleLabel = ed.ui.gradientLabel.create({
    text = T("3500%"),
    fontSize = 36,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16764053),
    endColor = ed.toccc3(16777215),
    strokeSize = 1,
    strokeColor = ed.toccc3(15432721)
  })
  local tipSize = self.ui.title_tips:getContentSize()
  self.ui.label_title:addChild(titleLabel.node, 1)
  titleLabel.node:setPositionX(tipSize.width / 2 - 118)
  titleLabel.node:setPositionY(5)
end

function temperingPassPage:setButtonClick()
  ed.passNetWork:simplePassOpenPanel(self.simplePassId)
end

function temperingPassPage:addListenEvent()
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
      self:refreshNum()
    end
  end)
  self:listenEvent("passBuySuccess", function(id, rank)
    if id == self.simplePassId then
      self:refreshDragList(true)
      self:refreshBuyBtn()
      self:refreshNum()
    end
  end)
end

function temperingPassPage:initDragList()
  local size = self.ui.pass_list:getContentSize()
  local param = {
    cliprect = CCRectMake(0, 0, size.width, size.height),
    noshade = true,
    container = self.ui.pass_list,
    priority = 300,
    zorder = 99,
    doPressIn = function(x, y)
      for k, v in pairs(self.rewardListCon or {}) do
        local ui = v.ui
        if ed.containsPoint(ui.baseRewardIcon, x, y) and ui.baseRewardIcon:isVisible() then
          return v.rewardData[1]
        end
        if ed.containsPoint(ui.advancedRewardIcon, x, y) and ui.advancedRewardIcon:isVisible() then
          return v.rewardData[2]
        end
      end
    end,
    doClickIn = function(x, y, data)
      if data.rewardState == ed.passDefine.REWARD_STATE_AVAILABLE then
        local param = {
          passId = self.simplePassId,
          isAllReward = false,
          rewardPos = data.rewardPos,
          rewardIndex = data.rewardIndex
        }
        ed.passNetWork:simplePassReq(param)
      else
        ed.UITool.openView("packageDetail", {
          id = data.rewardId,
          count = data.rewardAmount,
          type = data.rewardType
        })
      end
    end
  }
  self.rewardList = ed.draglist.create(param)
  self:refreshDragList(true)
end

function temperingPassPage:getLastAvailableReward(require_num, data)
  local baseRewardData = data[1]
  local advanceRewardData = data[2]
  if baseRewardData.rewardState == ed.passDefine.REWARD_STATE_AVAILABLE or advanceRewardData.rewardState == ed.passDefine.REWARD_STATE_AVAILABLE or baseRewardData.rewardState == ed.passDefine.REWARD_STATE_COMPLETED or advanceRewardData.rewardState == ed.passDefine.REWARD_STATE_COMPLETED then
    self.lastAvailableReward = self.lastAvailableReward + 1
  end
  if (baseRewardData.rewardState == ed.passDefine.REWARD_STATE_AVAILABLE or advanceRewardData.rewardState == ed.passDefine.REWARD_STATE_AVAILABLE) and not self.firstAvailableReward then
    self.firstAvailableReward = require_num
  else
  end
  if (baseRewardData.rewardState == ed.passDefine.REWARD_STATE_NOT_REACHED or advanceRewardData.rewardState == ed.passDefine.REWARD_STATE_NOT_REACHED) and not self.firstNotReachedReward then
    self.firstNotReachedReward = require_num
  end
  self.lastNumber = self.lastNumber + 1
end

function temperingPassPage:createRewardItem(require_num, data)
  local baseRewardData = data[1]
  local advanceRewardData = data[2]
  local container, ui = ed.editorui(ed.uieditor.temperingPass_item)
  container:setContentSize(ui.bg:getContentSize())
  local num = ed.getDataTable("SimplePass")[self.simplePassId]["Level" .. require_num]
  ui.title:setString(T("%d\230\172\161", num))
  local baseRewardIcon = self:createRewardIcon(baseRewardData)
  local advancedRewardIcon = self:createRewardIcon(advanceRewardData)
  baseRewardIcon:setScale(0.8)
  advancedRewardIcon:setScale(0.8)
  ui.light_bg:setScaleY(1)
  ui.light_bg:setScaleX(0.95)
  ui.base_reward_icon:addChild(baseRewardIcon)
  ui.baseRewardIcon = baseRewardIcon
  ed.layout.centerInParent(baseRewardIcon)
  ui.advanced_reward_icon:addChild(advancedRewardIcon)
  ui.advancedRewardIcon = advancedRewardIcon
  ed.layout.centerInParent(advancedRewardIcon)
  ui.light_bg:setVisible(require_num == self.lastAvailableReward)
  ui.line:setVisible(require_num ~= self.lastNumber)
  if baseRewardData.rewardState == ed.passDefine.REWARD_STATE_AVAILABLE or advanceRewardData.rewardState == ed.passDefine.REWARD_STATE_AVAILABLE then
    ed.setLabelColor(ui.title, ed.toccc3(16776137))
    if not self.firstAvailableReward then
      self.firstAvailableReward = require_num
    end
  else
    ed.setLabelColor(ui.title, ed.toccc3(16765563))
  end
  if (baseRewardData.rewardState == ed.passDefine.REWARD_STATE_NOT_REACHED or advanceRewardData.rewardState == ed.passDefine.REWARD_STATE_NOT_REACHED) and not self.firstNotReachedReward then
    self.firstNotReachedReward = require_num
  end
  if self.bigRewardNum == require_num then
    local lightParent = ed.createSprite()
    local light = ed.createFcaNode("eff_UI_legendequip_Get_light2_1")
    self:addFca(light)
    lightParent:addChild(light)
    advancedRewardIcon:addChild(lightParent, 2)
    ed.layout.centerInParent(lightParent)
    lightParent:setScale(0.7)
    light:setPosition(0, 9)
  end
  table.insert(self.rewardListCon, {
    container = container,
    rewardData = data,
    ui = ui
  })
  return container
end

function temperingPassPage:createRewardIcon(rewardData)
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

function temperingPassPage:refreshDragList(beResetPos)
  local rewardDataList = ed.passDataMgr:getPassRewardList(self.simplePassId)
  local cx, cy = self.rewardList:getListPos()
  self.rewardList:clearList()
  local posX = 0
  local gapX = 1
  local itemSize
  self.lastNumber = 0
  self.lastAvailableReward = 0
  self.bigRewardNum = #rewardDataList
  local widthScale = 0.78
  for requireLevel, rewardData in pairs(rewardDataList) do
    self:getLastAvailableReward(requireLevel, rewardData)
  end
  for requireLevel, rewardData in pairs(rewardDataList) do
    local rewardItem = self:createRewardItem(requireLevel, rewardData)
    itemSize = rewardItem:getContentSize()
    rewardItem:setPositionX(posX + gapX)
    self.rewardList:addItem(rewardItem)
    posX = posX + itemSize.width * widthScale + gapX
  end
  self.rewardList:initListWidth(posX)
  if beResetPos and (self.firstAvailableReward or self.firstNotReachedReward) then
    local index = 1
    if self.firstAvailableReward then
      index = self.firstAvailableReward
    else
      index = self.lastAvailableReward
    end
    cx = -(index - 1) * (gapX + itemSize.width * widthScale)
    self.rewardList:setListPos(ccp(cx, cy))
  else
    self.rewardList:setListPos(ccp(cx, cy))
  end
  if not self.firstAvailableReward and self.firstNotReachedReward == 1 then
    self.rewardList:setListPos(ccp(0, cy))
  end
end

function temperingPassPage:clickReward(rewardData, isAllReward)
  if rewardData.rewardState == ed.passDefine.REWARD_STATE_AVAILABLE then
    local param = {
      passId = self.simplePassId,
      isAllReward = isAllReward,
      rewardPos = rewardData.rewardPos,
      rewardIndex = rewardData.rewardIndex
    }
    ed.passNetWork:simplePassReq(param)
  end
end

function temperingPassPage:refreshBuyBtn()
  if ed.passDataMgr:getPassRank(self.simplePassId) >= 1 then
    self.ui.btn_buy:setVisible(false)
  else
    self.ui.btn_buy:setVisible(true)
  end
end

function temperingPassPage:close()
end
