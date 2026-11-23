local physicalPage = newclass("g")
ed.ui.activityphysicalPage = physicalPage

function physicalPage.create(base, param, pageKey)
  local this = {}
  setmetatable(physicalPage, {__index = base})
  setmetatable(this, {__index = physicalPage})
  local container, ui = ed.editorui(ed.uieditor.activity_physical_page)
  this.ui = ui
  this.param = param
  this.pageKey = pageKey or ""
  this.container = container
  this:initView(param)
  this:setButtonClick()
  return this
end

local physicalBox = {}

function physicalPage:initView(param)
  if not ed.isAreaZh() then
    ed.setLabelString(self.ui.label_title_1, T("\231\190\142\229\145\179\228\189\179\232\130\180"))
    ed.setLabelString(self.ui.label_title_2, T("\231\190\142\229\145\179\228\189\179\232\130\180"))
  end
  
  local function ClickFunc(item)
    return function()
      if self.updataTime and self.updataTime < 5 then
        return
      end
      local typeLwr = string.lower(item.param["Task Name"])
      self.objWork.Vitality = item.param.Vitality
      self.objWork.Diamond = nil
      if item.isFree then
        if ed.player._vitality._current >= ed.parameter.max_vitality_stock then
          ed.showToast(T("\228\189\160\231\154\132\228\189\147\229\138\155\229\164\170\229\164\154\229\149\166\239\188\140\229\133\136\230\182\136\232\128\151\228\184\128\228\186\155\229\144\167\227\128\130"))
          return
        end
        self.objWork:dailyVitality(typeLwr, 0)
      elseif item.isDiamond then
        if ed.player._vitality._current >= ed.parameter.max_vitality_stock then
          ed.showToast(T("\228\189\160\231\154\132\228\189\147\229\138\155\229\164\170\229\164\154\229\149\166\239\188\140\229\133\136\230\182\136\232\128\151\228\184\128\228\186\155\229\144\167\227\128\130"))
          return
        end
        if self.cardState then
          self.objWork.Diamond = false
          self.objWork:dailyVitality(typeLwr, 1)
        elseif ed.isOpenConsumeTips() then
          if ed.ui.consumeTipsWin.isEnableShowWin() then
            ed.UITool.openView("consumeTipsWin", {
              text = string.format(T("\230\152\175\229\144\166\232\138\177\232\180\185<sprite src=UI/alpha/1080P/common/rmbicon.png scale=0.7>%s\232\191\155\232\161\140\232\161\165\233\162\134\239\188\159<br/>\232\161\165\233\162\134\229\144\142\229\143\175\232\142\183\229\190\151%s\228\189\147\229\138\155"), item.param["Diamond Cost"], item.param.Vitality),
              rightHandler = function()
                self:consumeHandler(item, typeLwr)
              end
            })
          else
            self:consumeHandler(item, typeLwr)
          end
        else
          ed.ui.maillocalbox.create({
            type = "deleItem",
            tag = 3,
            clickBack = function()
              self:consumeHandler(item, typeLwr)
            end,
            title = T("\232\161\165\233\162\134"),
            str = T("<br/><br/>\230\152\175\229\144\166\232\138\177\232\180\185<sprite src=UI/alpha/1080P/common/rmbicon.png scale=0.7>%s\232\191\155\232\161\140\232\161\165\233\162\134\239\188\159<br/>\232\161\165\233\162\134\229\144\142\229\143\175\232\142\183\229\190\151:", item.param["Diamond Cost"]),
            align = "CENTER",
            item = {
              {
                type = "Vitality",
                id = nil,
                amount = item.param.Vitality
              }
            },
            itemPosX = 475,
            itemPosY = 15,
            skipAnim = true
          }):popWindow()
        end
      elseif item.param.isGeft == 1 then
        ed.showToast(T("\228\187\138\230\151\165\229\183\178\233\162\134\229\143\150"))
      else
        ed.showToast(T("\229\165\189\231\154\132\233\163\159\230\157\144\229\190\128\229\190\128\233\156\128\232\166\129\232\128\144\229\191\131\231\131\185\233\165\170..."))
      end
    end
  end
  
  local key = {"Lunch", "Dinner"}
  local task = param._tasks
  self.items = {}
  for i, v in ipairs(key) do
    local item = physicalBox.create({
      img_title = self.ui["img_title_" .. i],
      img_food = self.ui["img_food_" .. i],
      label_time = self.ui["label_time_" .. i],
      img_food_num = self.ui["img_food_num_" .. i],
      btn = self.ui["btn_" .. i],
      label_btn = self.ui["label_btn_" .. i],
      label_cost_num = self.ui["label_cost_num_" .. i],
      img_cost = self.ui["img_cost_" .. i],
      label_cost_recover = self.ui["label_cost_recover_" .. i]
    }, task[v])
    self:btRegisterButtonClick({
      button = self.ui["btn_" .. i],
      key = "physical_" .. i,
      force = true,
      mcpMode = true,
      pressScale = self.ui["btn_" .. i]:getScale() - 0.04,
      normalScale = self.ui["btn_" .. i]:getScale(),
      clickHandler = ClickFunc(item)
    })
    self.items[i] = item
  end
  self:refreshTime()
  self.param._tasks = self.param.getDataFun()
  self:pageUpDate()
  ed.setLabelStroke(self.ui.label_title_1, ed.toccc3(12782347), 1)
  self.ui.label_title_1:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_title_2, ed.toccc3(12782347), 1)
  self.ui.label_title_2:setFontName(ed.fontBold)
  
  local function func()
    if self.updataTime then
      self.updataTime = self.updataTime - 2
      if self.updataTime <= 0 then
        if self.nextTime then
          ed.player:setDailyVitality({
            _next_refresh_time = self.param._tasks.nextRefreshTime + 86400
          })
        end
        self.param._tasks = self.param.getDataFun()
        self:pageUpDate()
        self.updataTime = nil
        self.nextTime = nil
      end
    end
  end
  
  func()
  self:listenTimer(Timer:Always(2), function()
    func()
  end)
end

function physicalPage:consumeHandler(item, typeLwr)
  self.objWork.Diamond = item.param["Diamond Cost"]
  local diamondAmount = ed.player:getDiamondAmount()
  if diamondAmount < self.objWork.Diamond then
    ed.showConfirmDialog({
      text = T("\233\146\187\231\159\179\228\184\141\232\182\179\239\188\140\230\152\175\229\144\166\229\137\141\229\190\128\232\180\173\228\185\176\239\188\159"),
      rightText = T("\231\161\174\229\174\154"),
      rightHandler = function()
        ed.pushScene(ed.ui.RechargeScene.create({page = "Diamonds"}))
      end
    })
    return
  end
  self.objWork:dailyVitality(typeLwr, 1)
end

function physicalPage:pageUpDate(param)
  local state = ed.player:getPayMonthCardState() or "BUY"
  self.cardState = state ~= "BUY"
  self.param = param or self.param
  local key = {"Lunch", "Dinner"}
  local task = self.param._tasks
  for i, v in ipairs(key) do
    self.items[i]:update(task[v], self.cardState)
  end
  self:refreshTime()
end

function physicalPage:refreshTime()
  self.updataTime = nil
  self.nextTime = nil
  if self.param._tasks.nextRefreshTime then
    local time = ed.getFitServerTime()
    if time > self.param._tasks.nextRefreshTime then
      self.updataTime = 1
      return
    end
    local time = self.param._tasks.nextRefreshTime - time
    if time < 600 then
      self.updataTime = time
      self.nextTime = true
      return
    end
  end
  local key = {"Lunch", "Dinner"}
  local time = ed.getFitServerTime()
  local lunch = self.items[1]
  local dinner = self.items[2]
  local startTime2 = ed.getTimeByTodayHMSWithServer(dinner.param["Start Time"])
  if not lunch.isFree then
    local startTime1 = ed.getTimeByTodayHMSWithServer(lunch.param["Start Time"])
    if time < startTime1 then
      self.updataTime = startTime1 - time
    elseif time < startTime2 then
      self.updataTime = startTime2 - time
    end
  end
  if not dinner.isFree and not self.updataTime then
    local endDiamond = ed.getTimeByTodayHMSWithServer(dinner.param.endDiamond)
    if time > endDiamond then
      endDiamond = endDiamond + 86400
    end
    if time < startTime2 then
      self.updataTime = startTime2 - time
    elseif time < endDiamond then
      self.updataTime = endDiamond - time
      self.nextTime = true
    end
  end
  if self.updataTime and self.updataTime > 600 then
    self.updataTime = nil
  end
end

function physicalPage:setButtonClick()
end

function physicalBox.create(uiTab, param)
  local this = {}
  setmetatable(this, {__index = physicalBox})
  this.uiTab = uiTab
  this.param = param
  this:initUi(param)
  return this
end

function physicalBox:initUi(param)
  self.uiTab.label_time:setFontName(ed.fontBold)
  ed.setLabelStroke(self.uiTab.label_time, ed.toccc3(5909032), 1)
  ed.setLabelStroke(self.uiTab.label_btn, ed.toccc3(7039851), 1)
  ed.setLabelStroke(self.uiTab.label_cost_num, ed.toccc3(7039851), 1)
  ed.setLabelStroke(self.uiTab.label_cost_recover, ed.toccc3(7039851), 1)
  self:update(param)
end

function physicalBox:update(param, cardState)
  self.param = param
  if self.diamondImg then
    self.diamondImg:removeFromParentAndCleanup(true)
    self.diamondImg = nil
  end
  local isFree = false
  local isDiamond = false
  local startTime = ed.getTimeByTodayHMSWithServer(param["Start Time"])
  local overTime = ed.getTimeByTodayHMSWithServer(param["Over Time"])
  local time = ed.getFitServerTime()
  if param.isGeft == 0 then
    isFree = startTime <= time and overTime >= time
  end
  if not isFree and param.isGeft == 0 then
    local endDiamond = ed.getTimeByTodayHMSWithServer(param.endDiamond)
    if time > endDiamond then
      endDiamond = endDiamond + 86400
      isDiamond = time <= endDiamond and overTime <= time
    else
      isDiamond = true
    end
  end
  local btnTxt = T("\230\156\170\229\136\176\233\165\173\231\130\185")
  local showCostDiamond = false
  if isFree or isDiamond then
    if isFree then
      btnTxt = T("\228\186\171\231\148\168")
    elseif cardState then
      btnTxt = T("\229\133\141\232\180\185\232\161\165\233\162\134")
    else
      self.uiTab.label_cost_num:setString(param["Diamond Cost"])
      showCostDiamond = true
    end
  elseif param.isGeft == 1 then
    btnTxt = T("\229\183\178\233\162\134\229\143\150")
  end
  self.uiTab.label_btn:setString(T(btnTxt))
  self.uiTab.label_btn:setVisible(not showCostDiamond)
  self.uiTab.label_btn:limitWidthByScale(200)
  self.uiTab.label_cost_num:setVisible(showCostDiamond)
  self.uiTab.img_cost:setVisible(showCostDiamond)
  self.uiTab.label_cost_recover:setVisible(showCostDiamond)
  if showCostDiamond then
    ed.layout.horizontalSortNode({
      self.uiTab.label_cost_num,
      self.uiTab.img_cost,
      self.uiTab.label_cost_recover
    }, {
      0,
      0,
      0
    }, self.uiTab.btn:getContentSize().width * 0.5)
  end
  self.uiTab.label_time:setString(T("\228\190\155\229\186\148\230\151\182\233\151\180\239\188\154%s\231\130\185-%s\231\130\185", os.date("%H", startTime), os.date("%H", overTime)) .. ed.getUTCLabel())
  ed.updateSpriteGray(self.uiTab.btn, not isFree and not isDiamond)
  self.isFree = isFree
  self.isDiamond = isDiamond
end
