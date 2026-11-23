local base = ed.ui.popwindow
local NewItemMultipleChoice = newclass(base.mt)
ed.ui.NewItemMultipleChoice = NewItemMultipleChoice

function NewItemMultipleChoice:refreshDraglist()
  local function getPos(i)
    local ox, oy = -30, 305
    
    local dx, dy = 82, 100
    local x, y
    local row = math.floor((i - 1) / 4)
    local col = i - row * 4
    x = ox + dx * col
    y = oy - dy * row
    return x, y
  end
  
  local uiList = {}
  for k, id in ipairs(self.itemIDArray) do
    local container, ui
    if ed.itemType(id) == "equip" then
      container, ui = self:createEquipItem(id)
    elseif ed.itemType(id) == "hero" then
      container, ui = self:createHeroItem(id)
    end
    ui.id = id
    ui.index = k
    self.draglist:addItem(container)
    table.insert(uiList, ui)
    local ox, oy = getPos(k)
    container:setPosition(ccp(ox, oy))
  end
  self.uiList = uiList
  self.selectIndex = 1
  self.uiList[self.selectIndex].frame:setVisible(true)
  self.draglist:initListHeight(math.floor((#self.itemIDArray + 3) / 4) * 100 + 5)
end

function NewItemMultipleChoice:createHeroItem(id)
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  local icon = ed.readhero.createIconByID(id, {state = "idle"})
  icon:setAnchorPoint(ccp(0, 0))
  container:addChild(icon)
  ui.bg = icon
  local selectFrame = ed.createSprite("UI/alpha/1080P/package/hero_selected.png")
  selectFrame:setAnchorPoint(ccp(0, 0))
  selectFrame:setPosition(ccp(-4.5, -5.5))
  selectFrame:setVisible(false)
  ui.frame = selectFrame
  icon:addChild(selectFrame)
end

function NewItemMultipleChoice:createEquipItem(id)
  local IsStone = ed.readequip.value(id, "Category") == T("\231\129\181\233\173\130\231\159\179")
  local container, ui
  if IsStone then
    container, ui = ed.editorui(ed.uieditor.package_stone)
    ui.bg_precent = ui.bg_percent
  else
    container, ui = ed.editorui(ed.uieditor.package_fragment)
  end
  ui.percent:setVisible(false)
  ui.label_percent:setVisible(false)
  local bg = ed.readequip.createIcon(id)
  bg:setPositionY(10)
  ui.bg = bg
  container:addChild(bg)
  ed.below2(ui.bg_precent, bg, -2)
  ui.bg_precent:setPositionX(-37)
  local amount
  for i = 1, #self.itemIDArray do
    if self.itemIDArray[i] == id then
      amount = self.itemCountArray[i]
    end
  end
  if 1 < amount then
    local amountLabel = ed.getNumberNode({
      text = amount,
      folder = "prop_amount",
      padding = -1
    }).node
    amountLabel:setAnchorPoint(ccp(1, 0))
    local center = ed.getCenterPos(bg)
    local size = bg:getContentSize()
    amountLabel:setScale(1.5)
    amountLabel:setPosition(ccpAdd(center, ccp(35, -35)))
    bg:addChild(amountLabel)
  end
  if not IsStone then
    ui.percent:setVisible(false)
    ui.label_percent:setVisible(false)
    amount = ed.player:getEquipAmount(id) or 0
    local autoStr = string.format(T("<lable color=defaultColor>\229\183\178\230\139\165\230\156\137:</lable><lable color=headlineYellow>%d</lable>"), amount)
    local autoText = ed.ui.autoText.new()
    autoText:initParam({context = autoStr, fontSize = 12})
    autoText:limitWidthByScale(ui.bg_precent:getContentSize().width)
    local posX, posY = ui.label_percent:getPosition()
    autoText.node:setPosition(ccp(posX - autoText:getCurContentSize() / 2, posY))
    ui.bg_precent:addChild(autoText.node)
  else
    local heroId = self.stoneMakeIds[id] or 1
    local stoneAmount = ed.readhero.getStoneAmount(heroId)
    local stoneNeed = ed.readhero.getStoneNeed(heroId) or 9999999
    ui.percent:setVisible(true)
    ui.label_percent:setVisible(true)
    local scale = stoneAmount / stoneNeed
    if 1 < scale then
      scale = 1
    end
    ui.percent:setScaleX(scale)
    if stoneNeed == 9999999 then
      ui.percent:setVisible(false)
      ui.label_percent:setVisible(false)
      local autoStr = string.format(T("<lable color=defaultColor>\229\183\178\230\139\165\230\156\137:</lable><lable color=headlineYellow>%d</lable>"), stoneAmount)
      local autoText = ed.ui.autoText.new()
      autoText:initParam({context = autoStr, fontSize = 12})
      autoText:limitWidthByScale(ui.bg_precent:getContentSize().width)
      local posX, posY = ui.label_percent:getPosition()
      autoText.node:setPosition(ccp(posX - autoText:getCurContentSize() / 2, posY))
      ui.bg_precent:addChild(autoText.node)
      ui.icon_stone:setVisible(false)
      local size = ui.bg:getContentSize()
      local flag = ed.createSprite("UI/alpha/1080P/summon/summon_hero_star_max.png")
      flag:setPosition(size.width / 2, size.height / 2 - 25)
      local starTip = ed.createLabelTTF(T("\229\183\178\230\187\161\230\152\159"), 15, ed.fontBold)
      ed.setLabelColor(starTip, ed.toccc3(16775796))
      ed.setLabelStroke(starTip, ed.toccc3(9978880), 1)
      flag:addChild(starTip)
      ui.bg:addChild(flag)
      ed.layout.centerInParent(starTip)
    else
      ed.setString(ui.label_percent, string.format(T("%d/%d"), stoneAmount, stoneNeed))
    end
  end
  local selectFrame
  local category = ed.readequip.value(id, "Category")
  if category == T("\231\162\142\231\137\135") or category == T("\231\129\181\233\173\130\231\159\179") then
    selectFrame = ed.createSprite("UI/alpha/1080P/package/fragment_selected.png")
  else
    selectFrame = ed.createSprite("UI/alpha/1080P/package/icon_selected.png")
  end
  selectFrame:setAnchorPoint(ccp(0, 0))
  selectFrame:setPosition(ccp(-4.5, -5.5))
  selectFrame:setVisible(false)
  ui.frame = selectFrame
  bg:addChild(selectFrame)
  return container, ui
end

function NewItemMultipleChoice:initDraglist()
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:doPressInList(),
    doClickIn = self:doClickInList(),
    priority = -300
  })
  self.attrdraglist = ed.UITool.createDraglist(self.ui.layer_attr, {})
end

function NewItemMultipleChoice:registerTouchHandler()
  ed.UITool.registerBtn(self, "btn_cancle", function()
    self:doClickClose()
  end, {clickInterval = 0.5, pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_get", function()
    self:doSeleteCurItemId()
  end, {clickInterval = 0.5, pressScale = 0.9})
  ed.UITool.registerBtn(self, "bg_source", function()
    ed.ui.PackageSourceWin.create({
      id = self.itemIDArray[self.selectIndex]
    })
  end, {pressScale = 0.9})
end

function NewItemMultipleChoice:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList) do
      local bg = v.bg
      
      if ed.containsPoint(bg, x, y) then
        return v
      end
    end
    return nil
  end
  
  return handler
end

function NewItemMultipleChoice:doClickInList()
  local obj = self
  
  local function handler(x, y, v)
    if not v then
      return
    end
    local bg = v.bg
    if ed.containsPoint(bg, x, y) then
      self.uiList[self.selectIndex].frame:setVisible(false)
      self.selectIndex = v.index
      self.uiList[self.selectIndex].frame:setVisible(true)
      self:refreshLeftPanel(v.id)
    end
  end
  
  return handler
end

function NewItemMultipleChoice:handleRewards(rewards)
  ed.player:addRewards(rewards)
  local items = {}
  for k, v in ipairs(rewards) do
    table.insert(items, {
      type = v._type,
      id = v._id,
      amount = v._amount
    })
  end
  ed.ui.maillocalbox.create({type = "addItem", item = items}):popWindow()
end

function NewItemMultipleChoice:sendUseChooseBox()
  function ed.netreply.openSimpleChestReply(data)
    ed.player:consumeEquip(self.selectId, self.count)
    
    ed.record:useItemCount(self.selectId, self.count)
    self:handleRewards(data._rewards or {})
    FireEvent("PackageRefresh")
    self:destroy()
  end
  
  local itemInfo = ed.packItem(self.selectId, self.count)
  local msg = ed.upmsg.consume_item()
  msg._consume_item_extra_info = ed.upmsg.consume_item_extra_info()
  msg._consume_item_extra_info._type = 2
  msg._consume_item_extra_info._id = self.itemIDArray[self.selectIndex]
  msg._item = itemInfo
  ed.send(msg, "consume_item")
end

function NewItemMultipleChoice:doSeleteCurItemId()
  local itemId = self.itemIDArray[self.selectIndex]
  local selectItemAmount = ed.player:getEquipAmount(itemId)
  if selectItemAmount + self.count > ed.player:getItemMaxAmount(itemId) then
    local info = {
      autoText = T("\233\128\137\230\139\169\231\154\132\231\137\169\229\147\129\233\162\134\229\143\150\229\144\142\229\176\134\228\188\154\232\182\133\232\191\135\230\140\129\230\156\137\228\184\138\233\153\144\239\188\140\232\182\133\228\184\138\233\153\144\231\137\169\229\147\129\229\176\134\232\162\171<lable color=red>\230\184\133\233\153\164</lable>\239\188\140\230\152\175\229\144\166\231\187\167\231\187\173\233\128\137\230\139\169\239\188\159"),
      leftText = T("\231\161\174\229\174\154"),
      rightText = T("\229\143\150\230\182\136"),
      leftHandler = function()
        self:sendUseChooseBox()
        base.destroy(self)
      end
    }
    ed.showConfirmDialog(info)
  else
    self:sendUseChooseBox()
    base.destroy(self)
  end
end

function NewItemMultipleChoice:doClickClose()
  self:destroy()
end

function NewItemMultipleChoice:refreshLeftPanel(id)
  local icon, equip = ed.readequip.createIcon(id)
  local category = ed.readequip.value(id, "Category")
  icon:setPosition(ccp(self.ui.icon_item:getPosition()))
  self.ui.icon_item:setVisible(false)
  self.ui.icon_item = icon
  self.ui.bg_main_attr:addChild(icon)
  self.ui.label_desc:setDimensions(CCSizeMake(205, 100))
  local str = ed.readequip.value(id, "Description") or ed.readequip.value(id, "Comment")
  if str then
    self.ui.label_desc:setVisible(true)
    self.ui.label_desc:setString(str)
  else
    self.ui.label_desc:setVisible(false)
  end
  self.ui.label_name:setColor(ccc3(255, 252, 231))
  ed.setLabelStroke(self.ui.label_name, ccc3(39, 37, 36), 2)
  self.ui.label_name:setString(ed.readequip.value(id, "Name") or "")
  ed.adaptLabel(self.ui.label_name, {maxWidth = 220, minScale = 0.8})
  self.ui.label_name:setHorizontalAlignment(kCCTextAlignmentCenter)
  self.ui.label_amount:setString(ed.player:getEquipAmount(id) or 0)
  local desc, add, suffix = ed.readequip.getDescription(id)
  self.attrdraglist:clearList()
  for i = 1, #desc do
    local container = CCNode:create()
    local ui = {}
    ui.container = container
    local readnode = ed.readnode.create(container, ui)
    readnode:addNode(ed.uieditor.attr_item)
    ed.setString(ui.label_attr, desc[i])
    ui.label_num:setVisible(false)
    local oriHeight = self.ui.layer_attr:getContentSize().height + ui.bg:getContentSize().height * 0.5
    container:setPosition(ccp(10, oriHeight - ui.bg:getContentSize().height * i - 6))
    self.attrdraglist:addItem(container)
  end
  self.attrdraglist:initListHeight(26 * #desc + 6)
  self.ui.label_desc:setPosition(ccp(10, 90 - math.min(self.ui.layer_attr:getContentSize().height, 26 * #desc + 6)))
end

function NewItemMultipleChoice:initData(params)
  self.itemIDArray = params.info["Item Set"]
  self.itemCountArray = params.info["Item Set Count"]
  self.selectId = params.id
  self.count = params.count
  self.parentLogic = params.parentLogic
  self:initStoneMakeId()
end

function NewItemMultipleChoice:initUI()
  local container, ui = ed.editorui(ed.uieditor.package_select_box)
  self.ui = ui
  self.container:addChild(container)
  ed.setLabelShadow(ui.btn_cancle_label, ed.toccc3(0), ccp(1, 0))
  ed.setLabelShadow(ui.btn_get_label, ed.toccc3(0), ccp(1, 0))
  self:initDraglist()
  self:refreshDraglist()
  self:refreshLeftPanel(self.itemIDArray[1])
end

function NewItemMultipleChoice.create(params)
  local self = base.create("ItemMultipleChoice")
  setmetatable(self, NewItemMultipleChoice.mt)
  self:initData(params)
  self:initUI()
  self:registerTouchHandler()
  self:show()
  return self
end

function NewItemMultipleChoice:initStoneMakeId()
  local itemId = self.itemIDArray[1]
  if itemId and ed.readequip.value(itemId, "Category") == T("\231\129\181\233\173\130\231\159\179") then
    self.stoneMakeIds = {}
    local fragmentTbl = ed.getDataTable("fragment")
    for id, val in pairs(fragmentTbl) do
      local fragmentId = val["Fragment ID"]
      if ed.isElementInTable(fragmentId, self.itemIDArray) then
        self.stoneMakeIds[fragmentId] = id
      end
    end
  end
end
