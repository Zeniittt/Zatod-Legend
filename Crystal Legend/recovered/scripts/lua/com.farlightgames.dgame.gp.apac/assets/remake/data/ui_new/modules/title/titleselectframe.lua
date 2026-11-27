TitleSelectFrame = {
  mt = {}
}
TitleSelectFrame.mt.__index = TitleSelectFrame
ed.ui.titleselectframe = TitleSelectFrame
local titleMgr = ed.TitleMgr.getInstance()

function TitleSelectFrame:onDestroy(eventName)
  self:destroy({skipAnim = true})
  if eventName == nil then
    eventName = "closeTitleFrame"
  end
  FireEvent(eventName)
end

function TitleSelectFrame.create(info)
  local base = ed.ui.popwindow
  setmetatable(TitleSelectFrame, base.mt)
  local self = base.create("titleselectframe", {isShade = true})
  setmetatable(self, TitleSelectFrame.mt)
  self:initData(info)
  self:initUI()
  self:show({skipAnim = true})
  self:createTitleDraglist()
  self:registerTouchHandler()
  self:sendMedalOpenPanel()
  return self
end

function TitleSelectFrame:initData(info)
  self.callBack = info.callBack
  self.ui = nil
  self.container = nil
  self.titleDraglist = nil
  self.titleUI = {}
  self.selectUI = info.selectUI
  self.sContainer = info.sContainer
end

function TitleSelectFrame:sendMedalOpenPanel()
  ed.netreply.medalOpenPanel = self:updateFrame()
  local msg = ed.upmsg.medal()
  msg._medal_open_panel = ed.upmsg.medal_open_panel()
  ed.send(msg, "medal")
end

function TitleSelectFrame:updateFrame()
  local function handler()
    if self.isDestroyed then
      return
    end
    titleMgr:setShowDealTag(false)
    self.selectUI.dealTag:setVisible(false)
    self.lockTitleList = titleMgr:getNotHideLockTitleList()
    self.unLockTitleList = titleMgr:getUnLockTitleList()
    self:initTitleList()
    self:registerTouchHandler()
  end
  
  return handler
end

function TitleSelectFrame:initUI()
  self.mainLayer:addChild(self.sContainer)
  local container, ui = ed.editorui(ed.uieditor.titleselectframe)
  self.container = container
  self.ui = ui
  self.mainLayer:addChild(container)
  self.ui.bg:setPosition(ccp(355, 240))
  self.ui.bg:setContentSize(CCSizeMake(530, 375))
  local px, py = self.selectUI.bg:getPosition()
  self.selectUI.bg:setPosition(ccp(px - 40, py))
  local pxx, pyy = self.selectUI.bgS:getPosition()
  self.selectUI.bgS:setPosition(ccp(px - 40, pyy))
end

function TitleSelectFrame:registerTouchHandler()
  self:btRegisterHandler({
    handler = self.titleDraglist:getListLayerTouchHandler()
  })
  self:btRegisterOutClick({
    area = {
      self.ui.bg,
      self.selectUI.bg,
      self.selectUI.bgS
    },
    clickHandler = function()
      self:onDestroy()
    end,
    priority = 1
  })
  self:btRegisterButtonClick({
    button = self.selectUI.bgS,
    press = self.selectUI.bgS_press,
    key = "spanBtn",
    force = true,
    mcpMode = true,
    clickHandler = function()
      self:onDestroy("openSpanServerSet")
    end
  })
  for idx, oneTitleUI in pairs(self.titleUI) do
    self:btRegisterButtonClick({
      button = oneTitleUI.titleButton,
      press = oneTitleUI.titleButton_press,
      key = "titleButton" .. idx,
      force = true,
      mcpMode = true,
      clickHandler = function()
        self:titleTouchHandler(idx)
      end
    })
  end
  local selectBtnCfg = titleMgr:getSelectBtnCfg() or {}
  for _, oneCfg in pairs(selectBtnCfg) do
    if oneCfg.name ~= "titleBtn" then
      self:btRegisterButtonClick({
        button = self.selectUI[oneCfg.name],
        key = oneCfg.name,
        pressHandler = oneCfg.press,
        cancelPressHandler = oneCfg.cancle,
        clickHandler = function()
          self:onDestroy(oneCfg.eventName)
        end,
        force = true,
        mcpMode = true
      })
    end
  end
end

local titleHeight = 40
local cellHeight = 63

function TitleSelectFrame:initTitleList()
  self:createTitleItem()
  local totHeight = cellHeight * (#self.unLockTitleList.items + #self.lockTitleList.items) + titleHeight * 2
  self.titleDraglist:initListHeight(totHeight)
end

function TitleSelectFrame:createTitleDraglist()
  local info = {
    container = self.ui.bg,
    cliprect = CCRectMake(5, 10, 525, 350),
    noshade = true,
    zorder = 5
  }
  local draglist = ed.draglist.create(info)
  self.titleDraglist = draglist
end

function TitleSelectFrame:createTitleItem()
  local totIndex = 1
  local section = 1
  self:createOneTitleTitle(self.unLockTitleList.title, section)
  for _, oneTitle in pairs(self.unLockTitleList.items) do
    self:createOneTitleItem(oneTitle, totIndex, section)
    totIndex = totIndex + 1
  end
  section = 2
  self:createOneTitleTitle(self.lockTitleList.title, section)
  for _, oneTitle in pairs(self.lockTitleList.items) do
    self:createOneTitleItem(oneTitle, totIndex, section)
    totIndex = totIndex + 1
  end
end

function TitleSelectFrame:createOneTitleTitle(title, section)
  local titleSprite = ed.createSprite(title.image)
  local label = ed.createttf(title.name, 18)
  ed.setLabelColor(label, ccc3(255, 236, 22))
  local posY = 350
  if section == 2 then
    posY = posY - (cellHeight * #self.unLockTitleList.items + titleHeight + 2)
  end
  titleSprite:setPosition(ccp(250, posY))
  label:setPosition(ccp(250, posY))
  self.titleDraglist:addItem(titleSprite)
  self.titleDraglist:addItem(label)
end

function TitleSelectFrame:createOneTitleItem(oneTitle, totIndex, section)
  local container, ui = ed.editorui(ed.uieditor.titleselectitem)
  self.titleDraglist:addItem(container)
  self:setOneTitle(oneTitle, ui, section, container)
  container:setPosition(ccp(-105, 135 - cellHeight * totIndex - titleHeight * section))
  self.titleUI[totIndex] = ui
end

function TitleSelectFrame:createMedalOnFlag(oneTitle, ui, container)
  if self.onImg then
    return
  end
  if oneTitle.key == titleMgr:getPlayerTitle().key then
    local onImg = ed.createSprite("UI/alpha/HVGA/medal/medal_on.png")
    local px, py = ui.clockImage:getPosition()
    onImg:setPosition(ccp(px + 100, py))
    container:addChild(onImg)
    self.onImg = onImg
  end
end

function TitleSelectFrame:updateMedalOnFlag()
  if self.onImg then
    self.onImg:removeFromParentAndCleanup(true)
    self.onImg = nil
  end
end

function TitleSelectFrame:setOneTitle(oneTitle, ui, section, container)
  self:createMedalOnFlag(oneTitle, ui, container)
  ed.setString(ui.titleDes, oneTitle.description)
  ui.titleImage:setVisible(false)
  ui.titleName:setVisible(false)
  ui.titleGetTime:setVisible(section == 1)
  ui.clockImage:setVisible(false)
  ui.titleTime:setVisible(section == 1)
  local titleImage = ed.createSprite(oneTitle.image)
  titleImage:setPosition(ccp(ui.titleImage:getPosition()))
  container:addChild(titleImage)
  local nameLabel = ed.createLabelTTF(oneTitle.name, 18)
  nameLabel:setPosition(ccp(ui.titleName:getPosition()))
  nameLabel:setAnchorPoint(ccp(0, 0.5))
  container:addChild(nameLabel)
  local timeLabel = ed.createLabelTTF(T(""), 16)
  timeLabel:setPosition(ccp(ui.titleTime:getPosition()))
  timeLabel:setAnchorPoint(ccp(0, 0.5))
  container:addChild(timeLabel)
  if section == 1 then
    local getTime = T(ed.getYMDTime(oneTitle.getTime) .. " \232\142\183\229\143\150")
    ed.setString(ui.titleGetTime, getTime)
    local dalayTime = T("\230\176\184\228\185\133")
    local timeColor = ccc3(119, 255, 92)
    local lifeTimeDay = oneTitle.expireTime - ed.getFitServerTime()
    if oneTitle.expireTime ~= 0 then
      if 0 < lifeTimeDay then
        ui.clockImage:setVisible(true)
        dalayTime = string.format("%s", ed.time2dhm(lifeTimeDay))
      else
        timeColor = ccc3(185, 65, 21)
      end
    end
    if oneTitle.lifeTimeDay == -1 then
      dalayTime = T("\229\183\178\230\191\128\230\180\187")
    end
    ed.setLabelColor(ui.titleTime, timeColor)
    ed.setString(ui.titleTime, dalayTime)
  else
    local progressStr = oneTitle.progress
    if progressStr == 0 then
      progressStr = T("-/-")
    end
    ed.setString(timeLabel, progressStr)
    ed.setLabelColor(timeLabel, ccc3(173, 156, 131))
    ed.setSpriteGray(titleImage)
    local nameStr = oneTitle.name
    if oneTitle.lifeTimeDay == 0 then
      nameStr = string.format("%s(\230\176\184\228\185\133)", nameStr)
    elseif oneTitle.lifeTimeDay == -1 then
      nameStr = string.format("%s(\230\156\170\230\191\128\230\180\187)", nameStr)
    else
      nameStr = string.format("%s(\230\151\182\230\149\136:%d\229\164\169)", nameStr, oneTitle.lifeTimeDay)
    end
    ed.setString(nameLabel, nameStr)
    ed.setLabelColor(nameLabel, ccc3(173, 156, 131))
    ed.setLabelColor(ui.titleDes, ccc3(173, 156, 131))
  end
end

function TitleSelectFrame:titleTouchHandler(index)
  if index > #self.unLockTitleList.items then
    ed.showToast(T("\230\130\168\232\191\152\230\156\170\232\142\183\229\190\151\230\173\164\229\190\189\231\171\160\239\188\129"))
    return
  end
  local id = self.unLockTitleList.items[index].key
  if id == titleMgr:getPlayerTitle().key then
    self:sendUnmountMedal()
    return
  end
  self:onDestroy()
  self:sendSetMedal(id)
end

function TitleSelectFrame:sendUnmountMedal()
  ed.netreply.unmountMedal = self:doUnmountMedalReply()
  local msg = ed.upmsg.medal()
  msg._unmount_medal = ed.upmsg.unmount_medal()
  ed.send(msg, "medal")
end

function TitleSelectFrame:doUnmountMedalReply()
  local function handler(result)
    if not result then
      ed.showToast(T("\229\141\184\228\184\139\229\190\189\231\171\160\229\164\177\232\180\165"))
    else
      ed.showToast(T("\229\141\184\228\184\139\229\190\189\231\171\160\230\136\144\229\138\159"))
      self:updateMedalOnFlag()
      titleMgr:setPlayerTitle(nil)
      if self.callBack then
        self.callBack()
      end
    end
  end
  
  return handler
end

function TitleSelectFrame:sendSetMedal(id)
  ed.netdata.setMedal = {id = id}
  ed.netreply.setMedal = self:doSetMedalReply(id)
  local msg = ed.upmsg.medal()
  msg._set_medal = ed.upmsg.set_medal()
  msg._set_medal._set_medal_id = id
  ed.send(msg, "medal")
end

function TitleSelectFrame:doSetMedalReply(id)
  local function handler(result)
    if not result then
      ed.showToast(T("\232\174\190\231\189\174\229\190\189\231\171\160\229\164\177\232\180\165"))
    else
      titleMgr:setPlayerTitle(id)
      if self.callBack then
        self.callBack()
      end
      self:onDestroy()
    end
  end
  
  return handler
end
