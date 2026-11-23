local base = ed.ui.popwindow
local summonDestinyWindow = newclass(base.mt)
ed.ui.summonDestinyWindow = summonDestinyWindow
local summonDestinyWindowScope = {}

function summonDestinyWindow.create(param)
  local self = base.create("summonDestinyWindow")
  setmetatable(self, summonDestinyWindow.mt)
  self:init(param)
  return self
end

function summonDestinyWindow:init(param)
  param = param or {}
  self.callback = param.callback
  self:initData()
  self:initView()
  self:addEventListener()
end

function summonDestinyWindow:initData()
  self.selectTid = ed.summonMgr.destinyTid
  self.rowTid = ed.summonMgr.destinyTid
  self.heroList = self:getCurHeroList()
end

function summonDestinyWindow:getCurHeroList()
  local tb = ed.getDataTable("HotHero")
  local items = {}
  for k, v in pairs(tb) do
    if type(k) == "number" then
      local item = {
        batchId = k,
        startTime = ed.getTimeByYMDHMS(v["Start Time"]),
        hero1List = v["Hero 1 List"],
        hero2List = v["Hero 2 List"],
        hero3List = v["Hero 3 List"]
      }
      table.insert(items, item)
    end
  end
  table.sort(items, function(a, b)
    return a.startTime > b.startTime
  end)
  for k, v in ipairs(items) do
    if v.startTime < ed.getFitServerTime() then
      self.selectBatchId = v.batchId
      if 1 < k then
        local time = items[k - 1].startTime - ed.getFitServerTime()
        time = ed.time2dhm(time)
        self.nextTimeStr = string.format(T("%s\229\144\142\230\155\180\230\150\176"), time)
      end
      return v
    end
  end
end

function summonDestinyWindow:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      if ed.containsPoint(v.ui, x, y) then
        return v
      end
    end
    return nil
  end
  
  return handler
end

function summonDestinyWindow:createHeroIcon(tid, scale)
  local stars = ed.readhero.getHeroInitStars(tid)
  local state
  if ed.player.heroes[tid] then
    stars = ed.player.heroes[tid]._stars
  else
    state = "noOwn"
  end
  local icon = ed.readhero.getIcon({
    id = tid,
    stars = stars,
    state = state
  })
  icon:setScale(scale or 1)
  return icon
end

function summonDestinyWindow:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    if ed.containsPoint(v.ui, x, y) then
      if v.tid == self.selectTid then
        return
      else
        self.selectTid = v.tid
        self.mask:setVisible(true)
        local x, y = v.ui:getPosition()
        self.mask:setPosition(ccp(x - 39, y - 40))
        local icon = self:createHeroIcon(self.selectTid)
        ed.UITool.replaceUI(self.ui, "wish_heros_root", "ImageView_844_Copy0", icon)
        self.ui.bg_stone:setVisible(true)
        ed.setString(self.ui.label_name, ed.getDataTable("Unit")[self.selectTid]["Display Name"])
        local amount = ed.readhero.getStoneAmount(self.selectTid) or 0
        local need = ed.readhero.getStoneNeed(self.selectTid)
        if not need then
          ed.setString(self.ui.Label_1802, T("\229\183\178\230\187\161\230\152\159"))
          ed.right2(self.ui.Label_1802, self.ui.icon_stone, 1)
        else
          ed.setString(self.ui.Label_1802, string.format("%d/%s", amount, need))
        end
      end
    end
  end
  
  return handler
end

function summonDestinyWindow:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
  end
  
  return handler
end

function summonDestinyWindow:createDraglist()
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList()
  })
end

function summonDestinyWindow:refreshDraglist()
  local size = self.ui.layer_item:getContentSize()
  local mask = CCLayerColor:create(ccc4(0, 0, 0, 150))
  mask:setContentSize(CCSizeMake(78, 78))
  local selectIcon = ed.createSprite("UI/alpha/1080P/package/selected.png")
  selectIcon:setPosition(ccp(39, 40))
  mask:setVisible(false)
  mask:addChild(selectIcon)
  mask:setZOrder(1)
  self.mask = mask
  self.draglist:addItem(mask)
  local oy = size.height
  self.uiList = {}
  local ox = -18
  if self.heroList.hero3List then
    local title3 = ed.createSprite("UI/alpha/1080P/summondestiny/destiny_herolist_1.png")
    local labelStar = ed.createttf(T("3\230\152\159"), 18)
    ed.setLabelColor(labelStar, ed.toccc3(16640503))
    ed.setLabelStroke(labelStar, ed.toccc3(15482235), 1)
    labelStar:setPosition(ccp(225, 112))
    title3:addChild(labelStar)
    local height = title3:getContentSize().height
    title3:setPosition(ccp(size.width / 2, oy - height / 2))
    oy = oy - height + 55
    self.draglist:addItem(title3)
    for k, v in ipairs(self.heroList.hero3List) do
      local icon = self:createHeroIcon(v)
      local col = (k - 1) % 4 + 1
      icon:setPosition(ccp(ox + col * 88, oy))
      self.draglist:addItem(icon)
      table.insert(self.uiList, {ui = icon, tid = v})
      if k % 4 == 0 then
        oy = oy - 88
      end
    end
    if #self.heroList.hero3List % 4 == 0 then
      oy = oy + 50
    else
      oy = oy - 40
    end
  end
  if self.heroList.hero2List then
    local title2 = ed.createSprite("UI/alpha/1080P/summondestiny/destiny_herolist_2.png")
    local labelStar = ed.createttf(T("2\230\152\159"), 18)
    ed.setLabelColor(labelStar, ed.toccc3(16702975))
    ed.setLabelStroke(labelStar, ed.toccc3(6888572), 1)
    labelStar:setPosition(ccp(225, 112))
    title2:addChild(labelStar)
    local height = title2:getContentSize().height
    title2:setPosition(ccp(size.width / 2, oy - height / 2))
    oy = oy - 57
    self.draglist:addItem(title2)
    local tip = ed.createttf(T("\230\138\189\229\135\186\230\151\182\232\142\183\229\190\151\230\149\180\229\141\161*3"), 13)
    ed.setLabelColor(tip, ed.toccc3(11833065))
    ed.setLabelStroke(tip, ed.toccc3(4858233), 1)
    tip:setPosition(ccp(size.width / 2, oy))
    self.draglist:addItem(tip)
    oy = oy - height + 93
    for k, v in ipairs(self.heroList.hero2List) do
      local icon = self:createHeroIcon(v)
      local col = (k - 1) % 4 + 1
      icon:setPosition(ccp(ox + col * 88, oy))
      self.draglist:addItem(icon)
      table.insert(self.uiList, {ui = icon, tid = v})
      if k % 4 == 0 then
        oy = oy - 88
      end
    end
    if #self.heroList.hero2List % 4 == 0 then
      oy = oy + 50
    else
      oy = oy - 40
    end
  end
  if self.heroList.hero1List then
    local title1 = ed.createSprite("UI/alpha/1080P/summondestiny/destiny_herolist_2.png")
    local labelStar = ed.createttf(T("1\230\152\159"), 18)
    ed.setLabelColor(labelStar, ed.toccc3(16702975))
    ed.setLabelStroke(labelStar, ed.toccc3(6888572), 1)
    labelStar:setPosition(ccp(225, 112))
    title1:addChild(labelStar)
    local height = title1:getContentSize().height
    title1:setPosition(ccp(size.width / 2, oy - height / 2))
    oy = oy - 57
    self.draglist:addItem(title1)
    local tip = ed.createttf(T("\230\138\189\229\135\186\230\151\182\232\142\183\229\190\151\230\149\180\229\141\161*9"), 13)
    ed.setLabelColor(tip, ed.toccc3(11833065))
    ed.setLabelStroke(tip, ed.toccc3(4858233), 1)
    tip:setPosition(ccp(size.width / 2, oy))
    self.draglist:addItem(tip)
    oy = oy - height + 93
    for k, v in ipairs(self.heroList.hero1List) do
      local icon = self:createHeroIcon(v)
      local col = (k - 1) % 4 + 1
      icon:setPosition(ccp(ox + col * 88, oy))
      self.draglist:addItem(icon)
      table.insert(self.uiList, {ui = icon, tid = v})
      if k % 4 == 0 then
        oy = oy - 88
      end
    end
    oy = oy - 40
  end
  local selectTid = self.selectTid
  for k, v in ipairs(self.uiList) do
    if v.tid == selectTid then
      self.mask:setVisible(true)
      local x, y = v.ui:getPosition()
      self.mask:setPosition(ccp(x - 39, y - 40))
    end
  end
  self.draglist:initListHeight(size.height - oy)
end

function summonDestinyWindow:initView()
  local container, ui = ed.editorui(ed.uieditor.summonDestinyWindow)
  self.ui = ui
  self.container:addChild(container)
  ed.setLabelStroke(self.ui.Label_1622, ed.toccc3(6888572), 1)
  ed.setLabelStroke(self.ui.label_name, ed.toccc3(6888572), 1)
  ed.setLabelStroke(self.ui.Label_1802, ed.toccc3(2565412), 1)
  ed.setLabelShadow(self.ui.btn_save_label, ed.toccc3(0), ccp(1, 1))
  ed.setLabelStroke(self.ui.label_img, ed.toccc3(13645679), 1)
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(13326484), 1)
  self.ui.label_title:setFontName(ed.fontBold)
  self:setBackButton()
  self:createDraglist()
  self:refreshDraglist()
  if self.selectTid then
    local icon = self:createHeroIcon(self.selectTid)
    ed.setString(self.ui.label_name, ed.getDataTable("Unit")[self.selectTid]["Display Name"])
    local amount = ed.readhero.getStoneAmount(self.selectTid) or 0
    local need = ed.readhero.getStoneNeed(self.selectTid)
    if not need then
      ed.setString(self.ui.Label_1802, T("\229\183\178\230\187\161\230\152\159"))
      self.ui.Label_1802:limitWidthByScale(65)
    else
      ed.setString(self.ui.Label_1802, string.format("%d/%s", amount, need))
    end
    ed.UITool.replaceUI(self.ui, "wish_heros_root", "ImageView_844_Copy0", icon)
  else
    self.ui.bg_stone:setVisible(false)
  end
  if self.nextTimeStr then
    ed.setString(self.ui.label_time, self.nextTimeStr)
  else
    self.ui.label_time:setVisible(false)
  end
end

function summonDestinyWindow:refreshInfoStr()
  if self.info1AutoText then
    self.info1AutoText:removeFromParentAndCleanup(true)
  end
  local str1 = string.format(T("<lable color=ccc3(255,252,231) strokeColor=strokeColor1 strokeSize=1>\233\128\137\230\139\169</lable>") .. T("<lable color=ccc3(254,211,76) strokeColor=strokeColor1 strokeSize=1>\229\136\157\229\167\1391\230\152\159\227\128\129\229\136\157\229\167\1392\230\152\159</lable>") .. T("<lable color=ccc3(255,252,231) strokeColor=strokeColor1 strokeSize=1>\229\143\175\232\142\183\229\190\151\231\129\181\233\173\130\231\159\179*60</lable>"))
  local info1 = ed.ui.autoText.new()
  info1:initParam({context = str1, fontSize = 15})
  local x, y = self.ui.label_tip:getPosition()
  info1.node:setPosition(ccp(x - 40, y))
  self.ui.left:addChild(info1.node)
  self.info1AutoText = info1.node
end

function summonDestinyWindow:initFontStyle()
  local strokecolor = ccc3(39, 37, 36)
  local fontcolor = ccc3(255, 230, 154)
  ed.setLabelColor(self.ui.btn_save_label, fontcolor)
  fontcolor = ccc3(255, 252, 231)
  ed.setLabelColor(self.ui.text_title, fontcolor)
  ed.setLabelStroke(self.ui.text_title, strokecolor, 1)
  for i = 1, 4 do
    local label = self.ui["btn_text_" .. i]
    ed.setLabelStroke(label, strokecolor, 2)
    ed.setLabelColor(label, fontcolor)
  end
end

function summonDestinyWindow:setBackButton()
  local ui = self.ui
  local readnode = ed.readnode.create(self.container, ui)
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "btn_back_wish",
        res = "UI/alpha/1080P/common/break_butt_bj.png"
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "back_arrow",
        res = "UI/alpha/1080P/common/break_butt.png",
        parent = "btn_back_wish"
      },
      config = {}
    }
  }
  readnode:addNode(ui_info)
  ed.layout.centerInParent(ui.back_arrow)
  ed.layout.layoutWithMagin(ui.btn_back_wish, {left = 0, top = 0})
end

function summonDestinyWindow:onClickSave()
  ed.summonNet:send("switch_wish", {
    _batch_id = self.selectBatchId,
    _hero_id = self.selectTid
  })
end

function summonDestinyWindow:addEventListener()
  self:registerBtnClick("btn_save", function()
    if self.selectTid == nil then
      ed.showToast(T("\230\156\170\233\128\137\230\139\169\229\145\189\229\174\154\232\139\177\233\155\132"))
      return
    end
    self:onClickSave()
  end)
  self:registerBtnClick("btn_back_wish", function()
    if self.selectTid ~= self.rowTid and self.selectTid ~= nil then
      local param = {
        text = T("\232\174\184\230\132\191\229\141\149\230\156\137\229\176\154\230\156\170\228\191\157\229\173\152\231\154\132\230\155\180\230\148\185\239\188\140\230\152\175\229\144\166\228\191\157\229\173\152"),
        leftText = T("\229\143\150\230\182\136"),
        rightHandler = function()
          self:onClickSave()
        end,
        leftHandler = function()
          self:destroy()
        end,
        rightText = T("\231\161\174\229\174\154")
      }
      ed.showConfirmDialog(param)
    else
      self:destroy()
    end
  end)
  ListenEvent("SummonClearWish", function()
    ed.showToast(T("\228\191\157\229\173\152\229\164\177\232\180\165\239\188\140\229\145\189\229\174\154\232\139\177\233\155\132\229\136\151\232\161\168\229\183\178\230\155\180\230\150\176\239\188\129"))
    self:destroy()
  end, summonDestinyWindowScope)
  ListenEvent("SummonSwitchWish", function(result)
    if result then
      ed.showToast(T("\228\191\157\229\173\152\230\136\144\229\138\159\239\188\129"))
      ed.summonMgr.destinyTid = self.selectTid
      self:destroy()
      if self.callback then
        self.callback()
      end
      return
    else
      ed.showToast(T("\228\191\157\229\173\152\229\164\177\232\180\165\239\188\129"))
      self:destroy()
    end
  end, summonDestinyWindowScope)
end

function summonDestinyWindow:registerBtnClick(key, func)
  local ui = self.ui
  local config = {
    button = ui[key],
    press = ui[key .. "_press"],
    key = key,
    pressScale = 0.9,
    clickHandler = function(_, x, y)
      ed.playEffect(ed.sound.deo.common_back)
      func()
    end,
    clickInterval = 0.5,
    priority = 10
  }
  self:btRegisterButtonClick(config)
end

function summonDestinyWindow:destroy()
  base.destroy(self)
  CloseScope(summonDestinyWindowScope)
end
