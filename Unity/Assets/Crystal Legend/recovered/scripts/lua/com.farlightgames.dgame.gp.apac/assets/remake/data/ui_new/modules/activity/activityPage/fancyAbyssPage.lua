local fancyAbyssPage = {}
ed.ui.fancyAbyssPage = fancyAbyssPage

function fancyAbyssPage.create(base, param, pageKey)
  local this = {}
  setmetatable(fancyAbyssPage, {__index = base})
  setmetatable(this, {__index = fancyAbyssPage})
  local container, ui = ed.editorui(ed.uieditor.activity_fancyabyss_page)
  this.ui = ui
  this.param = param
  this.pageKey = pageKey or ""
  this.container = container
  this.touchKey = {}
  this:initItems()
  this:initTextList()
  this:pageUpDate(param)
  this:registerTouchHandler()
  this.objWork:activityPull(param._id)
  return this
end

function fancyAbyssPage:initItems()
  local thisCon = self.ui.panel_item:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = self.ui.panel_item,
    noshade = true,
    zorder = 10,
    priority = -300,
    doPressIn = function(x, y)
      return x
    end,
    cancelPressIn = function(x, y, oldx)
      self.touch = math.abs(oldx - x) < 50
    end
  }
  self.dragList = ed.draglist.create(info)
  ed.setLabelStroke(self.ui.label_level, ed.toccc3(4792921), 1)
  ed.setLabelStroke(self.ui.label_time, ed.toccc3(4792921), 1)
  ed.setLabelStroke(self.ui.Label_52, ed.toccc3(4792921), 1)
  ed.setLabelStroke(self.ui.Label_52_Copy0, ed.toccc3(4792921), 1)
  ed.setLabelStroke(self.ui.Label_2925, ed.toccc3(10509864), 1)
  ed.setLabelStroke(self.ui.Label_952777, ed.toccc3(5184849), 1.6)
  ed.setLabelStroke(self.ui.label_countdown, ed.toccc3(11348174), 1.6)
  ed.setLabelStroke(self.ui.label_challenge, ed.toccc3(4925829), 1)
  self.ui.panel_goto:setPositionX(self.ui.panel_goto:getPositionX() + ed.display.halfFixedWidth / 2)
end

function fancyAbyssPage:initTextList()
  local thisCon = self.ui.panel_txt:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = self.ui.panel_txt,
    priority = -300,
    noshade = true,
    zorder = 10
  }
  self.textDragList = ed.draglist.create(info)
end

function fancyAbyssPage:refreshTextList(season)
  local Season = season or 1
  local thisCon = self.ui.panel_txt:getContentSize()
  local buffName = ed.getDataTable("FancyAbyssSeason")[season]["Skill Name"] or T("\230\183\177\230\184\138BUFF")
  self.ui.label_buff_name:setString(string.format(T("\230\156\172\230\156\159\230\149\136\230\158\156\239\188\154%s"), buffName))
  local firstStageId = ed.getDataTable("FancyAbyssNormal")[Season][1]["Stage ID"]
  local buffId = ed.getDataTable("FancyAbyssBattle")[firstStageId][1]["Stage Skill ID"]
  if buffId and buffId ~= 0 then
    local skillId = ed.getDataTable("StageSkill")[buffId]["Skill 1 ID"]
    local skillDesc = ed.getDataTable("Skill")[skillId][0]["Full Description"]
    local autoText = ed.ui.autoText.new()
    autoText:initParam({
      context = skillDesc,
      maxWidth = thisCon.width,
      fontSize = 14,
      strokeColor = ed.toccc3(4726093),
      strokeSize = 1.5
    })
    local _, sizeH = autoText:getContentSize()
    autoText.node:setPosition(ccp(0, thisCon.height - 12))
    self.textDragList:clearList()
    self.textDragList:addItem(autoText.node)
    self.textDragList:initListHeight(sizeH)
  end
end

function fancyAbyssPage:pageUpDate(param)
  self.param = param
  local task = param._tasks
  local extend = param._extend or {}
  local data = extend._fancy_abyss or {}
  local floor = data._cur_max_floor or 0
  local time = data._total_time and ed.gethmsNString(data._total_time) or T("\230\151\160\232\174\176\229\189\149")
  local season = data._season_id or ed.SkillTowerManager.curAbyssSeason or 1
  local items = {}
  local config = ed.getDataTable("Activity")[param._cfg_id] or {}
  for i, v in ipairs(config["Extra AN"] or {}) do
    table.insert(items, {
      type = 101 <= v and "item" or "hero",
      id = v,
      amount = 1
    })
  end
  for i, v in ipairs(config["Extra Str"] or {}) do
    table.insert(items, 1, {type = v, amount = 1})
  end
  local maxFloor = 0
  for k, v in pairs(ed.getDataTable("FancyAbyssNormal")[season]) do
    maxFloor = maxFloor + 1
  end
  self:refreshTextList(season)
  local overTime = param._end_time - ed.getServerTime()
  if 0 < overTime then
    local m, d, H, M = ed.formatTimeStr("%m", param._end_time), ed.formatTimeStr("%d", param._end_time), ed.formatTimeStr("%H", param._end_time), ed.formatTimeStr("%M", param._end_time)
    self.ui.label_countdown:setString(T("\230\136\170\232\135\179%s\230\156\136%s\230\151\165%s:%s", m, d, H, M) .. ed.getUTCLabel())
  else
    self.ui.ImageView_2929:setPositionX(69)
    self.ui.label_countdown:setPositionX(84)
    self.ui.label_countdown:setString(T("\230\180\187\229\138\168\229\183\178\231\187\147\230\157\159"))
  end
  self.ui.label_level:setString(0 < floor and T("%s/%s", floor, maxFloor) or T("\230\156\170\233\128\154\229\133\179"))
  self.ui.label_time:setString(time)
  local listwidth = 0
  for i, v in ipairs(self.touchKey or {}) do
    self:btRemoveMainTouchHandler({key = v})
  end
  self.touchKey = {}
  self.dragList:clearList()
  for i, v in ipairs(items) do
    local icon = ed.createItemIcon({
      id = v.id,
      amount = v.amount,
      type = v.type
    }, nil, 1)
    local width = ed.layout.getScaleSize(icon).width
    icon:setPosition(ccp(listwidth + width / 2, width / 2))
    self.dragList:addItem(icon)
    listwidth = listwidth + width
    self:btRegisterButtonClick({
      button = icon,
      key = "fancyAbyssPage_icon_" .. i,
      param = v,
      clickHandler = function(v, x, y)
        if not ed.containsPoint(self.ui.panel_item, x, y) then
          return
        end
        if self.touch then
          ed.UITool.openView("packageDetail", {
            id = v.id,
            amount = v.amount,
            type = v.type
          })
        end
      end,
      pressScale = 0.95,
      normalScale = 1
    })
    table.insert(self.touchKey, "fancyAbyssPage_icon_" .. i)
  end
  self.dragList:initListWidth(listwidth)
  local posx = (self.dragList.cliprect.size.width - listwidth) / 2
  if 0 < posx then
    self.dragList.listLayer:setPositionX(posx)
  end
end

function fancyAbyssPage:registerTouchHandler()
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.btn_go,
    key = "btn_go",
    clickHandler = function()
      local cpl = ed.playerlimit.getAreaUnlockPrompt("FancyAbyss")
      if cpl then
        ed.showToast(cpl)
        return
      end
      if 0 >= (self.param._end_time or 0) - ed.getServerTime() then
        ed.showToast(T("\230\180\187\229\138\168\229\183\178\231\187\147\230\157\159"))
        return
      end
      self.objWork:setEnterHandler(self.param._id)
      ed.UITool.openView("SkillTowerScene")
    end,
    pressScale = 0.75,
    normalScale = 0.8
  })
end
