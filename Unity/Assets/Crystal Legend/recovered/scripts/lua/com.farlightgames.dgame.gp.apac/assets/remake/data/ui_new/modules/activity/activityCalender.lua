local base = ed.ui.popwindow
local activityCalenderWin = newclass(base.mt)
ed.ui.activityCalenderWin = activityCalenderWin
local LEFT_DAY = 7
local RIGHT_DAY = 7
local BANNER_RECT = CCRectMake(20, 11, 55, 11)
local BANNER_DEFAULT_SIZE = CCSizeMake(93.5, 34)
local DEFAULT_SHOW_INDEX = 4
ed.UITool.registViewOpenFunc("activityCalenderWin", function(param)
  ed.ActivityNetwork.activityCalenderReq()
  ListenEventOnce("scope_activity_reply", function(info)
    if info._calendar and info._calendar._acts then
      local panel = activityCalenderWin.create(param, info._calendar._acts)
      panel:popWindow()
    end
  end)
end)

function activityCalenderWin.create(param, activityOpen)
  local self = base.create("activityCalenderWin")
  setmetatable(self, activityCalenderWin.mt)
  self:init(param, activityOpen)
  return self
end

function activityCalenderWin:init(param, activityOpen)
  self.activityTB = ed.getDataTable("Activity")
  self.showActivity = {}
  self.startTimeLimit = 0
  self.endTimeLimit = 0
  self.bannerItemList = {}
  self.activityOpen = activityOpen or {}
  self.isDrag = false
  self.pressInX = nil
  self.pressInY = nil
  self:initView()
  self:addEventListener()
end

function activityCalenderWin:initView()
  local container, ui = ed.editorui(ed.uieditor.activity_calender)
  self.ui = ui
  self.container:addChild(container)
  ed.setLabelString(self.ui.label_title, T("\230\180\187\229\138\168\230\151\165\229\142\134") .. ed.getUTCLabel())
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(14513414), 1)
  ed.setLabelFontName(self.ui.label_title, ed.fontBold)
  self:initDragList()
  self:refreshView()
  self.refreshCliprectConfig = {
    draglist = self.dateDragList
  }
  self:show()
end

function activityCalenderWin:initDragList()
  self.dateDragList = ed.UITool.createDraglist(self.ui.date_list, {priority = -300, noshade = true})
end

function activityCalenderWin:refreshView()
  self.dateDragList:clearList()
  self.showActivity = self:calcShowActivity()
  local serverTime = ed.getFitServerTime()
  local posX = 0
  local gapX = -2
  for index = -LEFT_DAY, RIGHT_DAY do
    local startTime = serverTime + index * 86400
    local y, m, d = ed.time2YMD(startTime)
    local param = {
      weekday = ed.getWeekdayCnName(startTime),
      index = index,
      isToday = index == 0 and true or false,
      y = y,
      m = m,
      d = d
    }
    local container, ui = self:createDateItem(param)
    self.dateDragList:addItem(container)
    local itemSize = container:getContentSize()
    container:setPositionX(posX)
    posX = posX + itemSize.width + gapX
  end
  self.dateDragList:initListWidth(posX)
  self.bannerDragList = ed.UITool.createDraglist(self.dateDragList.listLayer, {
    cliprect = CCRectMake(0, 0, posX, self.ui.banner_list:getContentSize().height),
    noshade = true,
    priority = -300,
    doPressIn = self:getPressInHandler(),
    doClickIn = self:getClickInHandler(),
    cancelPressIn = self:getCancelPressInHandler()
  })
  table.sort(self.showActivity, function(a, b)
    return a.startTime < b.startTime
  end)
  self:refreshBannerDragList()
  self.dateDragList:setListPos(ccp(-DEFAULT_SHOW_INDEX * BANNER_DEFAULT_SIZE.width, 0))
end

function activityCalenderWin:getPressInHandler()
  local function handler(x, y)
    for _, item in pairs(self.bannerItemList or {}) do
      if ed.containsPoint(item.ui.banner, x, y) then
        self.pressInX = x
        
        self.pressInY = y
        return item
      end
    end
  end
  
  return handler
end

function activityCalenderWin:getClickInHandler()
  local function handler(x, y, item)
    if not item then
      return
    end
    if not ed.containsPoint(self.ui.date_list, x, y) then
      return
    end
    if self.isDrag then
      self.isDrag = false
      return
    end
    local param = {
      title = item.title,
      rules = item.rules,
      startTime = item.startTime,
      endTime = item.endTime
    }
    ed.UITool.openView("activityCalenderTips", param)
  end
  
  return handler
end

function activityCalenderWin:getCancelPressInHandler()
  local function handler(x, y, item)
    if self.pressInX and self.pressInY then
      local distance = (self.pressInX - x) ^ 2 + (self.pressInY - y)
      
      if 25 < distance then
        self.isDrag = true
      else
        self.isDrag = false
      end
    end
  end
  
  return handler
end

function activityCalenderWin:refreshBannerDragList()
  if not self.bannerDragList then
    return
  end
  self.bannerItemList = {}
  self.bannerDragList:clearList()
  local bannerPosY = 0
  local bannerGapY = 4
  local rowToEndPos = {}
  local row = 1
  local bgSize = self.ui.banner_list:getContentSize()
  for _, activityData in ipairs(self.showActivity or {}) do
    local container, ui = self:createActivityBanner(activityData)
    if container then
      local actiCfgId = activityData.actiCfgId
      local startIndex = math.floor((activityData.startTime - self.startTimeLimit) / 86400)
      startIndex = math.max(0, startIndex)
      self.bannerDragList:addItem(container)
      local bannerSize = container:getContentSize()
      local x = startIndex * BANNER_DEFAULT_SIZE.width
      table.insert(self.bannerItemList, {
        ui = ui,
        title = activityData.title,
        rules = activityData.rules,
        startTime = activityData.startTime,
        endTime = activityData.endTime
      })
      local y, findRow
      for row, endPos in pairs(rowToEndPos) do
        if x >= endPos.x then
          findRow = row
          break
        end
      end
      if findRow then
        y = rowToEndPos[findRow].y
        rowToEndPos[findRow].x = x + bannerSize.width
      else
        y = bgSize.height - (bannerPosY + bannerSize.height + bannerGapY)
        rowToEndPos[row] = ccp(x + bannerSize.width, y)
        bannerPosY = bannerPosY + bannerSize.height + bannerGapY
        row = row + 1
      end
      container:setPosition(ccp(x, y))
    end
  end
  self.bannerDragList:initListHeight(bannerPosY)
end

function activityCalenderWin:calcShowActivity()
  local serverTime = ed.getFitServerTime()
  local y, m, d = ed.time2YMD(serverTime)
  local serverTime = os.time({
    day = d,
    month = m,
    year = y,
    hour = 5,
    minute = 0,
    second = 0
  })
  local startTimeLimit = serverTime - LEFT_DAY * 86400
  local endTimeLimit = serverTime + (RIGHT_DAY + 1) * 86400
  self.startTimeLimit = startTimeLimit
  self.endTimeLimit = endTimeLimit
  local showActivity = {}
  for _, actData in ipairs(self.activityOpen) do
    local dayTimestamp = actData._day_timestamp
    local actIdList = actData._act_ids
    local year, month, day = ed.time2YMD(ed.time2Server(dayTimestamp))
    for _, actiCfgId in ipairs(actIdList or {}) do
      local actiCfg = self.activityTB[actiCfgId]
      local startMomentStr = actiCfg["Start Moment"]
      local hour, minute, second = string.match(startMomentStr, "(%d+):(%d+):(%d+)")
      local isShow = actiCfg["Calendar Show"]
      local durationHour = actiCfg["Duration Hour"]
      local startTime = os.time({
        day = day,
        month = month,
        year = year,
        hour = hour,
        minute = minute,
        second = second
      })
      local endTime = startTime + durationHour * 3600
      if endTimeLimit > startTime and startTimeLimit < endTime and isShow then
        table.insert(showActivity, {
          actiCfgId = actiCfgId,
          startTime = startTime,
          endTime = endTime,
          durationHour = durationHour,
          rules = actiCfg.Rules or "",
          title = actiCfg["Activity Name"] or ""
        })
      end
    end
  end
  return showActivity
end

function activityCalenderWin:createDateItem(dateData)
  local container, ui = ed.editorui(ed.uieditor.activity_calender_item)
  local isToday = dateData.isToday
  if isToday then
    ui.image_selected:setVisible(true)
    ed.setLabelColor(ui.label_week, ed.toccc3(16776423))
    ed.setLabelStroke(ui.label_week, ed.toccc3(5847040), 1)
    ed.setLabelColor(ui.label_date, ed.toccc3(16776423))
    ed.setLabelStroke(ui.label_date, ed.toccc3(5847040), 1)
  else
    ui.image_selected:setVisible(false)
    ed.setLabelColor(ui.label_week, ed.toccc3(4469022))
    ed.setLabelColor(ui.label_date, ed.toccc3(4469022))
  end
  ed.setLabelString(ui.label_week, dateData.weekday)
  ed.setLabelString(ui.label_date, string.format(T("%s\230\156\136%s\230\151\165"), dateData.m, dateData.d))
  container:setContentSize(ui.image_bg:getContentSize())
  return container, ui
end

function activityCalenderWin:createActivityBanner(activityData)
  local actiCfgId = activityData.actiCfgId
  local actiCfg = self.activityTB[actiCfgId]
  local calendarIconPath = actiCfg["Calendar Icon"]
  local calendarBannerPath = actiCfg["Calendar Banner"]
  local iconBgPath = string.match(calendarBannerPath, "(.*).png$") .. "1.png"
  local name = actiCfg["Activity Name"]
  local startTime = activityData.startTime
  local endTime = activityData.endTime
  local durationTime = math.min(endTime, self.endTimeLimit) - math.max(startTime, self.startTimeLimit)
  local durationDay = math.ceil(durationTime / 86400)
  if not (calendarIconPath and iconBgPath and calendarBannerPath) or durationDay == 0 then
    return nil
  end
  local container = CCLayer:create()
  local banner = ed.createScale9Sprite(calendarBannerPath, BANNER_RECT)
  banner:setAnchorPoint(ccp(0, 0))
  banner:setContentSize(CCSizeMake(BANNER_DEFAULT_SIZE.width * durationDay, BANNER_DEFAULT_SIZE.height))
  local iconBg = ed.createSprite(iconBgPath)
  local icon = ed.createSprite(calendarIconPath)
  iconBg:setAnchorPoint(ccp(0, 0))
  iconBg:addChild(icon)
  ed.layout.centerInParent(icon)
  local fontSize = 18
  local name = self:calcBannerNameLabel(name, fontSize, banner:getContentSize().width - iconBg:getContentSize().width)
  local nameLabel = ed.createLabelTTF(name, fontSize)
  ed.setLabelColor(nameLabel, ed.toccc3(16777215))
  ed.setLabelStroke(nameLabel, ed.toccc3(1973263), 1)
  local layerIcon = CCLayer:create()
  layerIcon:addChild(iconBg)
  layerIcon:addChild(nameLabel)
  layerIcon:setContentSize(CCSizeMake(iconBg:getContentSize().width + nameLabel:getContentSize().width, iconBg:getContentSize().height))
  nameLabel:setPosition(ccp(iconBg:getContentSize().width + nameLabel:getContentSize().width / 2, layerIcon:getContentSize().height / 2))
  banner:addChild(layerIcon)
  ed.layout.centerInParent(layerIcon)
  container:addChild(banner)
  local height = math.max(layerIcon:getContentSize().height, banner:getContentSize().height)
  container:setContentSize(CCSizeMake(banner:getContentSize().width, height))
  ed.layout.centerInParent(banner)
  return container, {banner = banner}
end

function activityCalenderWin:calcBannerNameLabel(name, fontSize, maxLength)
  local startIndex = 1
  local endIndex = utf8.len(name)
  while startIndex < endIndex do
    local cutString = utf8.sub(name, startIndex, endIndex)
    local label = ed.createLabelTTF(cutString, fontSize)
    if maxLength < label:getContentSize().width then
      endIndex = endIndex - 1
    else
      break
    end
  end
  if endIndex < utf8.len(name) then
    endIndex = math.max(endIndex, 1)
    local newName = utf8.sub(name, startIndex, endIndex - 1)
    newName = newName .. "..."
    return newName
  end
  return name
end

function activityCalenderWin:addEventListener()
  ed.UITool.registerBtn(self, "close_btn", function()
    self:close()
  end)
end

function activityCalenderWin:close()
  self:destroy({skipAnim = false})
end
