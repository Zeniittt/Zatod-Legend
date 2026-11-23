local base = ed.ui.popwindow
local timeCorridorPoolWin = newclass(base.mt)
ed.ui.timeCorridorPoolWin = timeCorridorPoolWin

function timeCorridorPoolWin.create()
  local self = base.create("timeCorridorPoolWin")
  setmetatable(self, timeCorridorPoolWin.mt)
  self:initData()
  self:initUI()
  self:registerEvents()
  self:initDraglist()
  self.refreshCliprectConfig = {
    draglist = self.draglist
  }
  self:popWindow()
  self:show()
  return self
end

function timeCorridorPoolWin:initUI()
  local layer, ui = ed.editorui(ed.uieditor.timeCorridorPoolWin)
  self.ui = ui
  self.container:addChild(layer)
  ed.layout.centerInScreen(self.ui.bg)
  self:initLabels()
end

function timeCorridorPoolWin:initLabels()
  local gl_title = ed.ui.gradientLabel.create({
    text = T("\230\166\130\231\142\135\232\175\166\230\131\133"),
    fontName = ed.fontBold,
    fontSize = 24,
    startColor = ed.toccc3(16043519),
    endColor = ed.toccc3(15661823),
    shadowColor = ed.toccc3(3804609),
    shadowOffset = ccp(0, -1),
    strokeColor = ed.toccc3(7418623),
    strokeSize = 1
  })
  ed.UITool.replaceUINew(self.ui, "label_title", gl_title.node)
end

function timeCorridorPoolWin:registerEvents()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy()
  end)
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end
  })
end

local function calcIconPosition(index)
  local oriX = -233
  local oriY = -58
  local deltaX = 90
  local deltaY = 80
  return oriX + (index - 1) % 6 * deltaX, oriY - math.floor((index - 1) / 6) * deltaY
end

local function formatProbNumber(number)
  local multiplier = 10000
  return math.floor(number * multiplier + 0.5) / multiplier
end

function timeCorridorPoolWin:createItemIcon(item)
  local icon = ed.createItemIcon({
    type = item.type,
    id = item.itemId,
    amount = item.amount
  }, nil, 0.91)
  if item.showHaveTag and ed.player:getItemMaxAmount(item.itemId) <= ed.player:getEquipAmount(item.itemId) then
    local tag = ed.createSprite("UI/alpha/1080P/timecorridor/timecorridor_got.png")
    icon:addChild(tag)
    tag:setPosition(72, 18)
  end
  return icon
end

function timeCorridorPoolWin:initDraglist()
  local dlSize = self.ui.Panel_461:getContentSize()
  local dragList = ed.UITool.createDraglist(self.ui.Panel_461, {
    bar = {
      bglen = dlSize.height,
      bgpos = ccp(dlSize.width + 20, dlSize.height * 0.5),
      barres = "UI/alpha/1080P/timecorridor/timecorridor_progress_2.png",
      bgres = "UI/alpha/1080P/timecorridor/timecorridor_progress_1.png"
    }
  })
  self.draglist = dragList
  local oriPosX = dlSize.width * 0.5
  local oriPosY = dlSize.height - 24
  local height = 8
  for i = self.minGroupId, self.maxGroupId do
    print(i)
    local v = self.prob_tbl[i]
    local container, ui = ed.editorui(ed.uieditor.timeCorridorPoolItem)
    if nil == v.ExchangeAmount or 0 == v.ExchangeAmount then
      ui.exchange_icon:setVisible(false)
      ui.label_exchange_tip:setVisible(false)
    else
      ui.exchange_num:setString("x" .. v.ExchangeAmount)
      local tokenName = ed.readequip.value(ed.timeCorridorMgr.tokenId, "Name") or T("\230\162\166\229\141\142\229\135\157\231\143\160")
      tokenName = string.gsub(tokenName, "%b()", "")
      ui.label_exchange_tip:setString(T("\233\135\141\229\164\141\232\142\183\229\190\151\230\151\182\232\189\172\229\140\150\228\184\186%s", tokenName))
    end
    ui.label_prob:setString(tostring(formatProbNumber(v.weight / self.totalWeight * 100)) .. "%")
    ed.setLabelStroke(ui.exchange_num, ed.toccc3(3614318), 1)
    dragList:addItem(container)
    ui.bg:setPosition(ccp(oriPosX, oriPosY))
    local minDelY = 0
    for ind, item in ipairs(v.group) do
      local icon = self:createItemIcon(item)
      local delX, delY = calcIconPosition(ind)
      icon:setPosition(ccp(oriPosX + delX, oriPosY + delY))
      dragList:addItem(icon)
      minDelY = math.min(minDelY, delY)
    end
    oriPosY = oriPosY + minDelY - 16 - 32 - 10
    height = height + 16 + 32 + 10 - minDelY
  end
  dragList:initListHeight(height)
end

function timeCorridorPoolWin:initData()
  local prob_tbl = ed.getDataTable("TimeCorridorPool")[ed.timeCorridorMgr.season]
  self.prob_tbl = {}
  self.totalWeight = 0
  self.minGroupId = 99999
  self.maxGroupId = 0
  for i, k in pairs(prob_tbl) do
    local id = k["Group ID"]
    self.minGroupId = math.min(self.minGroupId, id)
    self.maxGroupId = math.max(self.maxGroupId, id)
    self.prob_tbl[id] = {}
    self.prob_tbl[id].weight = k.Weight
    self.totalWeight = self.totalWeight + k.Weight
    self.prob_tbl[id].ExchangeAmount = k["Exchange Amount"]
    local group_tbl = ed.getDataTable("TimeCorridorGroup")[id]
    self.prob_tbl[id].group = {}
    if k["Display Type"] == "Item" then
    end
    local showTag = true
    for i, k in ipairs(group_tbl) do
      table.insert(self.prob_tbl[id].group, {
        itemId = k["Reward ID"],
        type = k["Reward Type"],
        amount = k["Reward Amount"],
        showHaveTag = showTag
      })
    end
  end
end
