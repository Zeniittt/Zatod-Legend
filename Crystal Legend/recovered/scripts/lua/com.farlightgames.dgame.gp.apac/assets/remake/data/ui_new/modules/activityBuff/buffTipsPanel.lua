local buffTipsPanel = {}
ed.buffTipsPanel = buffTipsPanel

function buffTipsPanel.create(param)
  local self = {}
  setmetatable(self, {__index = buffTipsPanel})
  self:init(param)
  return self
end

function buffTipsPanel:init(param)
  self.buffIdList = param.buffIdList or {}
  self.extraTypeList = param.extraTypeList or {}
  self.column = param.column or 5
  self.tipsDirection = param.tipsDirection
  self.tipsPanel = nil
  self.eventScope = {}
  self:initView()
  self:addEventListener()
end

function buffTipsPanel:initView()
  self.container = CCLayer:create()
  self.buffIcon = {}
  self.extraBuffIcon = {}
  self:createAllBuffIcon()
  self.container:setTouchEnabled(true)
  self.container:registerScriptTouchHandler(self:doMainLayerTouch(), false, -300, false)
end

function buffTipsPanel:refreshPanel(param)
  if param then
    self.buffIdList = param.buffIdList
    self.extraTypeList = param.extraTypeList
    self.column = param.column or 5
  end
  self.buffIcon = {}
  self.extraBuffIcon = {}
  if not tolua.isnull(self.container) then
    self.container:removeAllChildrenWithCleanup(true)
    self:createAllBuffIcon()
  end
end

function buffTipsPanel:createAllBuffIcon()
  local size = CCSizeMake(0, 0)
  local activityBuffMgr = ed.activityBuffMgr.getInstance()
  local amount = 0
  for index, buffId in ipairs(self.buffIdList) do
    local buffData = activityBuffMgr:getBuff(buffId)
    local show = activityBuffMgr:getBuffIconShow(buffId)
    if buffData and show then
      local icon = self:createBuffIcon(buffId)
      self.container:addChild(icon)
      size = icon:getContentSize()
      local x = amount % self.column * size.width
      local y = math.floor(amount / self.column) * -size.height
      icon:setPosition(ccp(x, y))
      self.buffIcon[buffId] = icon
      amount = amount + 1
    end
  end
  local extraBuffInfoList = {}
  if self.extraTypeList == "all" then
    extraBuffInfoList = activityBuffMgr:getAllExtraBuff()
  elseif type(self.extraTypeList) == "table" then
    for index, type in ipairs(self.extraTypeList) do
      table.insert(extraBuffInfoList, activityBuffMgr:getExtraBuff(type))
    end
  end
  for index, extraBuffInfo in pairs(extraBuffInfoList) do
    if extraBuffInfo then
      local icon = self:createExtraBuffIcon(extraBuffInfo)
      local type = extraBuffInfo.type
      self.container:addChild(icon)
      size = icon:getContentSize()
      local x = amount % self.column * size.width
      local y = math.floor(amount / self.column) * -size.height
      icon:setPosition(ccp(x, y))
      self.extraBuffIcon[type] = icon
      amount = amount + 1
    end
  end
  self.container:setContentSize(CCSizeMake(size.width * self.column, size.height * math.floor(#self.buffIdList / self.column)))
end

function buffTipsPanel:createBuffIcon(buffId)
  local buffConfig = ed.getDataTable("Activity")[buffId]
  local iconId = buffConfig.Icon
  local res = ed.getDataTable("ActivityIcon")[iconId].Picture .. ".png"
  local icon = CCSprite:create(res)
  return icon
end

function buffTipsPanel:createExtraBuffIcon(extraBuffInfo)
  local iconPath = extraBuffInfo.icon
  local icon = CCSprite:create(iconPath)
  return icon
end

function buffTipsPanel:doMainLayerTouch()
  local function handler(event, x, y)
    xpcall(function()
      self:iconTouch(event, x, y)
    end, EDDebug)
    return true
  end
  
  return handler
end

function buffTipsPanel:iconTouch(event, x, y)
  if event == "began" then
    for buffId, icon in pairs(self.buffIcon) do
      if ed.containsPoint(icon, x, y) then
        local buffConfig = ed.getDataTable("Activity")[buffId]
        local tips = buffConfig.Rules
        local buffData = ed.activityBuffMgr.getInstance():getBuff(buffId)
        local endTime = buffData and buffData.endTime
        if not self.tipsPanel and tips then
          local param = {
            parent = icon,
            text = tips,
            endTime = endTime,
            direction = self.tipsDirection
          }
          self.tipsPanel = ed.showHintTextWithParent(param)
        end
      end
    end
    for type, icon in pairs(self.extraBuffIcon) do
      if ed.containsPoint(icon, x, y) then
        local buffInfo = ed.activityBuffMgr.getInstance():getExtraBuff(type)
        local tips = buffInfo.content
        local endTime = buffInfo.endTime
        if not self.tipsPanel and tips then
          local param = {
            parent = icon,
            text = tips,
            endTime = endTime,
            direction = self.tipsDirection
          }
          self.tipsPanel = ed.showHintTextWithParent(param)
        end
      end
    end
  elseif event == "ended" and self.tipsPanel then
    local rootLayer = self.tipsPanel:getRootLayer()
    if rootLayer and not tolua.isnull(rootLayer) then
      self.tipsPanel:getRootLayer():removeFromParentAndCleanup(true)
    end
    self.tipsPanel = nil
  end
end

function buffTipsPanel:CloseScope()
  CloseScope(self.eventScope)
  self.eventScope = {}
end

function buffTipsPanel:checkIsRefresh(buffId, extraBuffType)
  if ed.isElementInTable(buffId, self.buffIdList) then
    return true
  end
  if extraBuffType and self.extraTypeList == "all" or ed.isElementInTable(extraBuffType, self.extraTypeList) then
    return true
  end
  return false
end

function buffTipsPanel:addEventListener()
  ListenEvent("addBuff", function(buffId, extraBuffType)
    if self:checkIsRefresh(buffId, extraBuffType) then
      self:refreshPanel()
    end
  end, self.eventScope)
  ListenEvent("updateBuff", function(buffId, extraBuffType)
    if self:checkIsRefresh(buffId, extraBuffType) then
      self:refreshPanel()
    end
  end, self.eventScope)
  ListenEvent("deleteBuff", function(buffId, extraBuffType)
    if self:checkIsRefresh(buffId, extraBuffType) then
      self:refreshPanel()
    end
  end, self.eventScope)
  ListenEvent("PlayerLevelUp", function(level)
    self:refreshPanel()
  end, self.eventScope)
end
