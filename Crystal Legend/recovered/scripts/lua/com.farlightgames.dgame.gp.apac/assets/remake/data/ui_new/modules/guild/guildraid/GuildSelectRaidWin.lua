local base = ed.ui.popwindow
local GuildSelectRaidWin = newclass(base.mt)
ed.ui.GuildSelectRaidWin = GuildSelectRaidWin
local GuildSelectRaidScope = {}
local strPage = T("\226\128\156\229\144\132\228\189\141\230\140\145\230\136\152\232\128\133\228\187\172\239\188\140\230\172\162\232\191\142\230\157\165\229\136\176\229\155\162\233\152\159\229\137\175\230\156\172\239\188\129\226\128\157<br/>") .. T("                                        \226\128\148\226\128\148 \229\137\175\230\156\172\229\134\155\233\156\128\229\174\152\233\152\191\229\183\168<br/>") .. T("<br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\137\175\230\156\172\229\188\128\229\144\175\230\182\136\232\128\151\228\184\128\229\174\154\229\133\172\228\188\154\230\180\187\232\183\131\229\128\188\227\128\130\231\142\169\229\174\182\231\166\187\229\188\128\229\133\172\228\188\154\230\151\182\228\188\154\230\184\133\233\155\182\230\156\170\232\162\171\230\182\136\232\128\151\231\154\132\230\180\187\232\183\131\229\128\188\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\228\188\154\233\149\191\227\128\129\233\149\191\232\128\129\229\143\175\229\188\128\229\144\175\229\155\162\233\152\159\229\137\175\230\156\172\239\188\140\230\175\143\229\145\168\230\156\1371\230\172\161\229\188\128\229\144\175\228\188\152\230\131\160\239\188\140\229\145\168\228\184\1285\231\130\185\233\135\141\231\189\174\228\188\152\230\131\160\230\172\161\230\149\176\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\133\172\228\188\154\230\136\144\229\145\152\229\143\175\228\187\165\229\144\140\230\151\182\230\140\145\230\136\152\228\184\141\229\144\140\229\137\175\230\156\172\239\188\140\230\128\170\231\137\169\232\161\128\233\135\143\228\184\141\229\155\158\229\164\141\227\128\130<br/>") .. (ed.isAreaOverSea() and "" or T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\175\143\229\164\169\229\135\140\230\153\1685\231\130\185\232\135\1798\231\130\185\230\152\175\230\128\170\231\137\169\228\187\172\231\154\132\228\188\145\230\129\175\230\151\182\233\151\180\239\188\140\230\156\159\233\151\180\230\151\160\230\179\149\232\191\155\232\161\140\229\155\162\233\152\159\229\137\175\230\156\172\231\154\132\230\136\152\230\150\151\227\128\130<br/>")) .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\137\175\230\156\172\233\153\144\230\151\182\229\134\133\233\128\154\229\133\179\239\188\140\229\143\175\228\187\165\232\142\183\229\190\151\230\155\180\229\164\154\231\154\132\229\133\172\228\188\154\229\184\129\229\165\150\229\138\177\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\137\175\230\156\172\231\187\147\231\174\151\230\151\182\239\188\140\229\141\149\229\156\186\230\136\152\230\150\151\230\156\128\233\171\152\228\188\164\229\174\179\230\142\146\229\144\141\233\157\160\229\137\141\231\154\132\231\142\169\229\174\182\232\142\183\229\190\151\230\155\180\229\164\154\229\133\172\228\188\154\229\184\129\229\165\150\229\138\177\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\233\171\152\230\136\152\233\152\159\231\173\137\231\186\167\230\137\147\228\189\142\231\171\160\232\138\130\229\137\175\230\156\172\239\188\140\229\133\172\228\188\154\229\184\129\229\165\150\229\138\177\231\187\147\231\174\151\228\188\154\230\156\137\228\184\128\229\174\154\232\180\159\229\138\160\230\136\144\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\189\147\229\137\141\231\137\136\230\156\172\239\188\140\231\142\169\229\174\182\229\133\172\228\188\154\229\184\129\231\154\132\231\180\175\231\167\175\228\184\138\233\153\144\228\184\186100000\231\130\185\227\128\130<br/>")

function GuildSelectRaidWin.create(param)
  local self = base.create("GuildSelectRaidWin")
  setmetatable(self, GuildSelectRaidWin.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:registerOnEnterHandler("enterGuildRaidRefresh", function()
    self:refreshUI()
    self:refreshDraglist(self.notFirstEnter)
    self.notFirstEnter = true
  end)
  self:popWindow()
  return self
end

function GuildSelectRaidWin:initData(param)
  self.callback = param.callback
  self.mgr = ed.GuildManager
  self.raidMgr = ed.GuildRaidManager
end

function GuildSelectRaidWin:initLabels()
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(6242324), 1)
  ed.setLabelFontName(self.ui.label_title, ed.fontBold)
  local title_wid = self.ui.label_title:getContentSize().width
  if 190 < title_wid then
    self.ui.label_title:setScale(190 / title_wid)
  end
  self.ui.btn_rule:setPositionX(math.max(self.ui.btn_rule:getPositionX(), self.ui.label_title:getPositionX() + 0.5 * title_wid * self.ui.label_title:getScale() + 16))
end

function GuildSelectRaidWin:createProcessBar(res, parentUI)
  local size = parentUI:getContentSize()
  local clippingNode = ed.createClippingNodeOnly(res, 0.5)
  clippingNode:setPosition(ccp(0.5, size.height / 2))
  local stencil = clippingNode:getStencil()
  stencil:setAnchorPoint(ccp(0, 0.5))
  local barScale = size.width / stencil:getContentSize().width
  stencil:setScaleX(barScale)
  local bar = ed.createSprite(res)
  bar:setContentSize(size)
  bar:setPositionY(1)
  bar:setAnchorPoint(ccp(0, 0.5))
  clippingNode:addChild(bar)
  parentUI:addChild(clippingNode)
  return stencil
end

function GuildSelectRaidWin:getFastPassedStrByTime(time)
  local passTime = time - ed.getServerTime()
  local h, m, s = ed.second2hms(math.max(0, passTime))
  local d = math.floor(h / 24)
  h = h % 24
  local hintInfo = ""
  if 0 < d then
    hintInfo = string.format(T("%d\229\164\169"), d)
  elseif 0 < h then
    hintInfo = string.format(T("%d\230\151\182"), h)
  elseif 0 < m then
    hintInfo = string.format(T("%d\229\136\134"), m)
  end
  return hintInfo
end

function GuildSelectRaidWin:createRaid(info)
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.RaidItem)
  local state = "opened"
  if not info.isPassed and not info.isOpen then
    if self.raidMgr:isRaidOpened(info.raidId) then
      state = "canOpen"
    else
      state = "locked"
    end
  end
  ui.layer_opened:setVisible(state == "opened")
  ui.layer_canopen:setVisible(state == "canOpen")
  ui.layer_lock:setVisible(state == "locked")
  ed.setLabelStroke(ui.label_title, ed.toccc3(2565412), 1.5)
  ed.setLabelStroke(ui.label_bar, ed.toccc3(2565412), 1)
  ed.setLabelStroke(ui.label_cost1, ed.toccc3(2565412), 1)
  ed.setLabelStroke(ui.label_time, ed.toccc3(2565412), 1)
  ed.setLabelStroke(ui.label_bar, ed.toccc3(2565412), 1)
  ed.setLabelShadow(ui.label_ok, ed.toccc3(2565412), ccp(1, 0))
  ed.setLabelShadow(ui.label_go, ed.toccc3(2565412), ccp(1, 0))
  ed.setLabelShadow(ui.label_reset, ed.toccc3(2565412), ccp(1, 0))
  ed.setString(ui.label_title, info.name)
  ed.setTexture(ui.icon, info.icon, ".png", ".jpg")
  ui.label_reset:setDimensions(CCSizeMake(32, 0))
  if state == "opened" then
    if info.progress == ed.GuildRaidConfig.MaxStageProgress then
      ed.setLabelColor(ui.label_bar, ed.toccc3(7405396))
      ed.setString(ui.label_bar, T("\229\183\178\229\174\140\230\136\144"))
    else
      ed.setString(ui.label_bar, info.progress / 100 .. "%")
    end
    local bg_title = ed.createSprite("UI/alpha/1080P/raid/title_blue_1.png")
    ed.UITool.replaceUI(ui, "bg", "bg_title", bg_title)
    self.bar = self:createProcessBar("UI/alpha/1080P/raid/progressbar_1.png", ui.bg_bar, ui.bar)
    self.bar:setScaleX(info.progress / ed.GuildRaidConfig.MaxStageProgress)
    if info.progress ~= 10000 then
      local hintInfo = T("\229\189\147\229\137\141\229\183\178\232\182\133\230\151\182")
      if 0 < info.fastDeadline - ed.getServerTime() then
        hintInfo = ed.time2dhms(info.fastDeadline - ed.getServerTime())
      end
      local strs = string.format(T("<lable color=ccc3(67,59,56)>\233\153\144\230\151\182\233\128\154\229\133\179\229\165\150\229\138\177\229\137\169\228\189\153:</lable>") .. "<lable color=ccc3(255,165,49) strokeColor=strokeColor1 strokeSize=1>%s</lable>", hintInfo)
      local labelTimeReward = ed.ui.autoText.new()
      labelTimeReward:initParam({
        context = strs,
        fontSize = 14,
        maxWidth = 200,
        maxHeight = 30,
        lineSpacing = 0
      })
      labelTimeReward:setVerticalCenter()
      ed.UITool.replaceUI(ui, "layer_opened", "label_time", labelTimeReward.node)
    end
    if ed.player:getGuildJob() == "member" then
      ui.btn_reset:setVisible(false)
      ui.btn_go:setPositionY(-3)
    end
    ui.btn_ok:setVisible(false)
  elseif state == "canOpen" then
    local cost = info.cost
    if self.raidMgr.curDiscountTimes < self.raidMgr.maxDiscountTimes then
      cost = info.discountCost
    else
    end
    ed.setString(ui.label_cost1, cost)
    if cost > self.mgr.vitality then
      ed.setLabelColor(ui.label_cost1, ccc3(255, 114, 45))
    end
    ui.btn_go:setVisible(false)
    ed.setString(ui.label_bar, T("\229\176\154\230\156\170\229\188\128\229\144\175"))
    if ed.player:getGuildJob() == "member" then
      ui.label_cost1:setVisible(false)
      ui.btn_ok:setVisible(false)
      ui.icon_cost:setVisible(false)
    end
  else
    ui.btn_ok:setVisible(false)
    ui.btn_go:setVisible(false)
    ui.btn_reset:setVisible(false)
    ed.setString(ui.label_bar, T("\229\176\154\230\156\170\229\188\128\229\144\175"))
  end
  ui.label_ok:setHorizontalAlignment(kCCTextAlignmentCenter)
  ed.adaptLabel(ui.label_ok, {maxWidth = 85, minScale = 0.9})
  return container, ui
end

function GuildSelectRaidWin:refreshDraglist(oldPos)
  local oldY = 0
  if oldPos then
    oldY = self.draglist.listLayer:getPositionY()
  end
  self.uiList = {}
  self.draglist:clearList()
  local listData = self.raidMgr.raidInfo
  
  local function getPos(i)
    local size = self.ui.layer_item:getContentSize()
    local ox = size.width / 4
    local dx = size.width / 2
    local dy = 102
    local oy = size.height - dy / 2
    local row = math.floor((i - 1) / 2)
    local col = (i - 1) % 2
    return ccp(ox + col * dx, oy - row * dy)
  end
  
  local reachLevelInd = 1
  for k, v in ipairs(listData) do
    local unlockLevel = ed.getDataTable("Raid")[v.raidId]["Unlock Level"]
    local notLocked = v.isPassed or v.isOpen or self.raidMgr:isRaidOpened(v.raidId)
    if unlockLevel <= ed.player:getLevel() and notLocked then
      reachLevelInd = k
    end
    local container, ui = self:createRaid(v)
    ui.data = v
    table.insert(self.uiList, ui)
    self.draglist:addItem(container)
    container:setScale(0.98)
    container:setPosition(getPos(k))
  end
  self.draglist:initListHeight(102 * math.ceil(#listData / 2))
  if oldPos then
    self.draglist.listLayer:setPositionY(oldY)
  else
    self.draglist:setListPos(ccp(0, 102 * math.floor((reachLevelInd - 1) / 2)), true)
  end
end

function GuildSelectRaidWin:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      if v.btn_ok:isVisible() and ed.containsPoint(v.btn_ok, x, y) then
        v.btn_ok:setScale(0.65)
        
        return v
      end
      if v.btn_go:isVisible() and ed.containsPoint(v.btn_go, x, y) then
        v.btn_go:setScale(0.95)
        return v
      end
      if v.btn_go:isVisible() and ed.containsPoint(v.btn_reset, x, y) then
        v.btn_reset:setScale(0.95)
        return v
      end
    end
    return nil
  end
  
  return handler
end

function GuildSelectRaidWin:openRaid(info)
  local canDiscount = self.raidMgr.curDiscountTimes < self.raidMgr.maxDiscountTimes
  local cost = canDiscount and info.discountCost or info.cost
  CloseEvent("GuildRaidOpenSuccess")
  ListenEventOnce("GuildRaidOpenSuccess", function(data)
    if canDiscount then
      self.raidMgr.curDiscountTimes = self.raidMgr.curDiscountTimes + 1
    end
    self:refreshUI()
    self:refreshDraglist(true)
  end, GuildSelectRaidScope)
  local unlockLevel = ed.getDataTable("Raid")[info.raidId]["Unlock Level"]
  local labelConfig1 = "color=ccc3(255,252,231) strokeColor=strokeColor1 strokeSize=1"
  local labelConfig2 = "color=ccc3(255,233,143) strokeColor=strokeColor1 strokeSize=1"
  local spriteSrc = "src=UI/alpha/1080P/icon/active.png scale=0.8"
  local str_sec = T("<lable labelConfig1>\231\161\174\229\174\154\232\138\177\232\180\185</lable>%s<lable labelConfig1>\229\188\128\229\144\175\229\155\162\233\152\159\229\137\175\230\156\172 %s?</lable><br/>", string.format("<lable labelConfig2>%d</lable><sprite spriteSrc>", cost), info.name)
  str_sec = string.gsub(str_sec, "labelConfig1", labelConfig1)
  str_sec = string.gsub(str_sec, "labelConfig2", labelConfig2)
  str_sec = string.gsub(str_sec, "spriteSrc", spriteSrc)
  local strs = string.format(T("<lable color=ccc3(255,252,231) strokeColor=strokeColor1 strokeSize=1>\229\183\178\230\156\137\229\133\172\228\188\154\230\180\187\232\183\131\229\186\166\239\188\154</lable>") .. "<lable color=ccc3(255,233,143) strokeColor=strokeColor1 strokeSize=1>%d</lable>" .. "<sprite src=UI/alpha/1080P/icon/active.png scale=0.8><br/>" .. str_sec, self.mgr.vitality)
  local str = string.format(T("<lable color=ccc3(255,252,231)>\229\143\175\230\140\145\230\136\152\231\173\137\231\186\167:</lable><lable color=ccc3(255,0,0)>%d</lable>"), unlockLevel)
  local info = {
    title = T("\229\188\128\229\144\175\229\137\175\230\156\172"),
    subTitle = T("\229\143\170\230\156\137\228\188\154\233\149\191\229\146\140\233\149\191\232\128\129\229\143\175\228\187\165\229\188\128\229\144\175\229\137\175\230\156\172"),
    autoText = strs,
    rightAddition = {
      autoText = str,
      pos = ccp(20, 60)
    },
    rightHandler = function()
      if cost > self.mgr.vitality then
        ed.showToast(T("\229\133\172\228\188\154\230\180\187\232\183\131\229\128\188\228\184\141\232\182\179"))
        return
      end
      ed.GuildRaidNetwork:sendOpenInstance(info.raidId, canDiscount)
    end
  }
  ed.showConfirmDialog1(info)
end

function GuildSelectRaidWin:enterRaid(info)
  CloseEvent("GuildRaidQueryInstance")
  ListenEventOnce("GuildRaidQueryInstance", function()
    local raidId = info.raidId
    if raidId and 0 < raidId then
      ed.pushScene(ed.ui.GuildRaidMainScene.create({
        raidId = info.raidId
      }))
    end
  end, GuildSelectRaidScope)
  ed.GuildRaidNetwork:sendQueryInstance(info.raidId)
end

function GuildSelectRaidWin:resetRaid(info)
  local canDiscount = self.raidMgr.curDiscountTimes < self.raidMgr.maxDiscountTimes
  local cost = canDiscount and info.discountCost or info.cost
  CloseEvent("GuildRaidResetSuccess")
  ListenEventOnce("GuildRaidResetSuccess", function(data)
    if canDiscount then
      self.raidMgr.curDiscountTimes = self.raidMgr.curDiscountTimes + 1
    end
    self:refreshUI()
    self:refreshDraglist(true)
  end, GuildSelectRaidScope)
  local strs = string.format("<lable color=ccc3(255,252,231) strokeColor=strokeColor1 strokeSize=1>" .. T("\232\175\165\231\171\160\232\138\130\229\174\140\230\136\144\232\191\155\229\186\166\239\188\154") .. "</lable>" .. "<lable color=ccc3(255,233,143) strokeColor=strokeColor1 strokeSize=1>%s</lable><br/>" .. "<lable color=ccc3(255,252,231) strokeColor=strokeColor1 strokeSize=1>" .. T("\229\183\178\230\156\137\229\133\172\228\188\154\230\180\187\232\183\131\229\186\166\239\188\154") .. "</lable>" .. "<lable color=ccc3(255,233,143) strokeColor=strokeColor1 strokeSize=1>%d</lable><sprite src=UI/alpha/1080P/icon/active.png scale=0.8><br/><br/>" .. T("<lable color=ccc3(255,233,143) strokeColor=strokeColor1 strokeSize=1>\233\135\141\231\189\174</lable><lable color=ccc3(255,252,231) strokeColor=strokeColor1 strokeSize=1>\229\144\142\232\175\165\231\171\160\232\138\130\230\137\128\230\156\137\229\133\179\229\141\161\229\176\134\230\129\162\229\164\141\232\135\179</lable><lable color=ccc3(255,233,143) strokeColor=strokeColor1 strokeSize=1>\229\136\157\229\167\139</lable><lable color=ccc3(255,252,231) strokeColor=strokeColor1 strokeSize=1>\231\138\182\230\128\129\239\188\140\230\152\175\229\144\166\229\188\128\229\144\175\229\155\162\233\152\159\229\137\175\230\156\172 %s?</lable>"), string.format("%.2f%%", info.progress / 100), self.mgr.vitality, info.name)
  local str = string.format("<lable color=ccc3(255,233,143) strokeColor=strokeColor1 strokeSize=1>%d</lable><sprite src=UI/alpha/1080P/icon/active.png scale=0.8>", cost)
  if cost > self.mgr.vitality then
    str = string.format("<lable color=ccc3(255,0,0) strokeColor=strokeColor1 strokeSize=1>%d</lable><sprite src=UI/alpha/1080P/icon/active.png scale=0.8>", cost)
  end
  local info = {
    title = T("\229\188\128\229\144\175\229\137\175\230\156\172"),
    subTitle = T("\229\143\170\230\156\137\228\188\154\233\149\191\229\146\140\233\149\191\232\128\129\229\143\175\228\187\165\229\188\128\229\144\175\229\137\175\230\156\172"),
    autoText = strs,
    offsetY = 10,
    rightAddition = {
      autoText = str,
      pos = ccp(40, 60)
    },
    rightHandler = function()
      if cost > self.mgr.vitality then
        ed.showToast(T("\229\133\172\228\188\154\230\180\187\232\183\131\229\128\188\228\184\141\232\182\179"))
        return
      end
      ed.GuildRaidNetwork:sendResetInstance(info.raidId, canDiscount)
    end
  }
  ed.showConfirmDialog1(info)
end

function GuildSelectRaidWin:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    if v.btn_ok:isVisible() and ed.containsPoint(v.btn_ok, x, y) then
      self:openRaid(v.data)
    end
    if v.btn_go:isVisible() and ed.containsPoint(v.btn_go, x, y) then
      self:enterRaid(v.data)
    end
    if v.btn_reset:isVisible() and ed.containsPoint(v.btn_reset, x, y) then
      self:resetRaid(v.data)
    end
  end
  
  return handler
end

function GuildSelectRaidWin:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    v.btn_ok:setScale(0.7)
    v.btn_go:setScale(1)
    v.btn_reset:setScale(1)
  end
  
  return handler
end

function GuildSelectRaidWin:initUI()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.RaidSelectWin)
  self:initLabels()
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList(),
    priority = -300
  })
  ed.layout.layoutWithMagin(ui.btn_back, {left = 0, top = 0})
  ed.layout.layoutWithMagin(ui.bg_liveness, {right = 0, top = 0})
  ed.layout.layoutWithMagin(ui.ImageView_23510, {right = 0, top = 0})
end

function GuildSelectRaidWin:refreshDiscountStr()
  if self.discountAutoStr then
    self.discountAutoStr:removeFromParentAndCleanup(true)
  end
  ed.setLabelStroke(self.ui.label_discount, ed.toccc3(2565412), 1)
  local strs = string.format("<lable color=ccc3(255,114,45) strokeColor=strokeColor1 strokeSize=1>%d</lable>" .. "<lable color=ccc3(255,172,75) strokeColor=strokeColor1 strokeSize=1>/%d</lable>", self.raidMgr.maxDiscountTimes - self.raidMgr.curDiscountTimes, self.raidMgr.maxDiscountTimes)
  local labelTimes = ed.ui.autoText.new()
  labelTimes:initParam({context = strs, fontSize = 14})
  local x, y = self.ui.label_times:getPosition()
  labelTimes.node:setPosition(ccp(x, y))
  self.ui.bg_discount:addChild(labelTimes.node)
  self.discountAutoStr = labelTimes.node
end

function GuildSelectRaidWin:refreshRewardStr()
  if self.rewardAutoStr then
    self.rewardAutoStr:removeFromParentAndCleanup(true)
  end
  local strs = string.format(T("<lable color=ccc3(255,252,231) strokeColor=strokeColor1 strokeSize=1>\230\156\172\229\145\168\229\165\150\229\138\177\239\188\154</lable><lable color=ccc3(255,233,143) strokeColor=strokeColor1 strokeSize=1>%d</lable>") .. "<sprite src=UI/alpha/1080P/icon/money_guildtoken_new.png scale=0.8>" .. T("<lable color=ccc3(255,114,45) strokeColor=strokeColor1 strokeSize=1>(\228\184\138\233\153\144%d)</lable>"), self.raidMgr.curWeeklyRaidPoint, self.raidMgr.maxWeeklyRaidPoint)
  local labelRewardInfo = ed.ui.autoText.new()
  labelRewardInfo:initParam({context = strs, fontSize = 18})
  labelRewardInfo.node:setPosition(self.ui.label_numReward:getPosition())
  self.ui.bg_top:addChild(labelRewardInfo.node)
  self.rewardAutoStr = labelRewardInfo.node
end

function GuildSelectRaidWin:refreshLivenessStr()
  if self.livenessAutoStr then
    self.livenessAutoStr:removeFromParentAndCleanup(true)
  end
  local strs = string.format(T("<lable color=ccc3(255,252,231) strokeColor=strokeColor1 strokeSize=1>\229\133\172\228\188\154\230\180\187\232\183\131\229\128\188\239\188\154</lable>") .. "<lable color=ccc3(255,233,143) strokeColor=strokeColor1 strokeSize=1>%d</lable><sprite src=UI/alpha/1080P/icon/active.png scale=0.8>", self.mgr.vitality)
  local livenessInfo = ed.ui.autoText.new()
  livenessInfo:initParam({context = strs, fontSize = 14})
  livenessInfo.node:setPosition(self.ui.label_liveness:getPosition())
  self.ui.bg_liveness:addChild(livenessInfo.node)
  self.livenessAutoStr = livenessInfo.node
end

function GuildSelectRaidWin:refreshUI()
  self:refreshDiscountStr()
  self:refreshRewardStr()
  self:refreshLivenessStr()
end

function GuildSelectRaidWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {normalScale = 0.8, pressScale = 0.75})
  ed.UITool.registerBtn(self, "btn_rule", function()
    ed.ui.commonRulePop.create({
      title = T("\232\167\132\229\136\153\232\175\180\230\152\142"),
      txt = strPage
    }):popWindow()
  end, {pressScale = 0.95})
end

function GuildSelectRaidWin:popWindow(zOrder)
  base.popWindow(self, zOrder)
end

function GuildSelectRaidWin:destroy()
  CloseScope(GuildSelectRaidScope)
  if self.callback then
    self.callback()
  end
  base.destroy(self, {skipAnim = true})
end

local ConfirmDialog = {}
ConfirmDialog.__index = ConfirmDialog
setmetatable(ConfirmDialog, base.mt)

function ConfirmDialog.create(param)
  local self = base.create("ConfirmDialog")
  setmetatable(self, ConfirmDialog)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

ed.showConfirmDialog1 = ConfirmDialog.create

function ConfirmDialog:initData(param)
  self.param = param
end

function ConfirmDialog:initUI()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.ConfirmWin2)
  self:refreshUI()
end

function ConfirmDialog:refreshUI()
  local ui = self.ui
  ui.label_cancle:setString(self.param.leftText or T("\229\143\150\230\182\136"))
  ui.label_ok:setString(self.param.rightText or T("\231\161\174\229\174\154"))
  ui.title:setString(self.param.title or T("\230\143\144\231\164\186"))
  ed.setLabelShadow(ui.label_cancle, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelShadow(ui.label_ok, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelShadow(self.ui.title, ccc3(0, 0, 0), ccp(2, 0))
  local confirm
  local fontSize = self.param.fontSize or 16
  local offsetY = self.param.offsetY or 0
  local color = ccc3(254, 251, 232)
  ed.setLabelStroke(self.ui.label_title, ccc3(56, 38, 34), 2)
  if self.param.subTitle then
    ui.label_sub_title:setVisible(true)
    ui.label_sub_title:setString(self.param.subTitle)
    ed.setLabelShadow(ui.label_sub_title, ccc3(0, 0, 0), ccp(2, 0))
  end
  local x, y = ui.label1:getPosition()
  if self.param.autoText then
    local confirm = ed.ui.autoText.new()
    confirm:initParam({
      color = ccc3(254, 251, 232),
      context = self.param.autoText,
      fontSize = fontSize,
      maxWidth = ui.bg:getContentSize().width * 0.8
    })
    local width, height = confirm:getCurContentSize()
    confirm.node:setPosition(ccp(x, y + offsetY))
    self.ui.bg:addChild(confirm.node)
  else
    confirm = ed.createttf(self.param.text, fontSize, nil, self.param.anchor)
    confirm:setDimensions(CCSizeMake(self.ui.bg:getContentSize().width * 0.8, 0))
    confirm:setHorizontalAlignment(kCCTextAlignmentLeft)
    confirm:setVerticalAlignment(kCCVerticalTextAlignmentCenter)
    confirm:setPosition(ccp(x, y + offsetY))
    ed.setLabelColor(confirm, ccc3(254, 251, 232))
    self.ui.bg:addChild(confirm)
  end
  if self.param.rightAddition then
    local rightAddition = ed.ui.autoText.new()
    rightAddition:initParam({
      color = ccc3(254, 251, 232),
      context = self.param.rightAddition.autoText,
      fontSize = 14
    })
    rightAddition.node:setPosition(self.param.rightAddition.pos)
    ui.btn_ok:addChild(rightAddition.node)
  end
end

function ConfirmDialog:registerTouchHandlers()
  local ui = self.ui
  ed.UITool.registerBtn(self, "btn_ok", function()
    self:destroy({
      skipAnim = self.param.skipDestroyAnim,
      callback = self.param.rightHandler
    })
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_cancle", function()
    self:destroy({
      skipAnim = self.param.skipDestroyAnim,
      callback = self.param.leftHandler
    })
  end, {pressScale = 0.9})
end
