local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.maillocalbox = class
ed.UITool.registViewOpenFunc("addItemPop", function(param)
  local item = {}
  for k, v in pairs(param or {}) do
    if v._amount and v._amount > 0 then
      table.insert(item, {
        type = v._type,
        amount = v._amount,
        id = v._id
      })
    end
  end
  ed.ui.maillocalbox.create({type = "addItem", item = item}):popWindow()
end)

local function create(param)
  local self = base.create("maillocalbox", {notBlurBg = true})
  setmetatable(self, class.mt)
  if param == nil then
    return
  end
  self.datas = param
  self.ui = {}
  self.clickBack = param.clickBack
  self.clickGeft = param.clickGeft
  self.destroyBack = param.destroyBack
  local readNode = ed.readnode.create(self.container, self.ui)
  if param and type(param) == "table" then
    if param.type == "deleItem" then
      readNode:addNode(ed.uieditor.gaveItemPage)
      param.item = self.overlapping(param.item)
      self:deleItemInit()
      self.refreshCliprectConfig = {
        draglist = self.deleItemList
      }
      self:deleItemInitTouchHandler()
    elseif param.type == "addItem" then
      param.item = self.overlapping(param.item)
      for i, v in ipairs(param.item) do
        if v.type == "medal" then
          self.addMedalIds = self.addMedalIds or {}
          table.insert(self.addMedalIds, v.id)
        end
      end
      if #param.item > 5 then
        readNode:addNode(ed.uieditor.gaveItemBig)
      else
        readNode:addNode(ed.uieditor.gaveItemWin)
      end
      self:addItemInit()
      self.refreshCliprectConfig = {
        draglist = self.addItemList
      }
    elseif param.type == "chatAddItem" then
      local gaveItemUI = ed.uieditor.gaveItemWin
      if param.uiClassName and ed.uieditor[param.uiClassName] then
        gaveItemUI = ed.uieditor[param.uiClassName]
      end
      param.item = self.overlapping(param.item)
      readNode:addNode(gaveItemUI)
      self:addItemInit()
      self.refreshCliprectConfig = {
        draglist = self.addItemList
      }
    elseif param.type == "WerrWin" then
      readNode:addNode(ed.uieditor.gaveItemWerrWin)
      self:werrWinInit()
    else
      error("type is nil")
      return
    end
  end
  self.notClose = 1
  self.container:runAction(CCSequence:create(ccArrayMake(unpack({
    CCDelayTime:create(param.closeTime or 0.5),
    CCCallFunc:create(function()
      if self.notClose == 2 then
        if self.destroyBack then
          self.destroyBack()
        end
        self:destroy({skipAnim = true})
      end
      self.notClose = false
    end)
  }))))
  local newWid = ed.display.halfFixedWidth
  local newHei = ed.display.halfFixedHeight
  self.container:setPosition(ccp(newWid, newHei))
  self:registerTouchHandler()
  self:show({
    skipAnim = self.datas.skipAnim
  })
  return self
end

class.create = create
class.deleStrs = {
  T("\233\130\174\228\187\182\228\184\173\229\144\171\230\156\137\233\162\134\229\143\150\229\144\142\229\176\134\228\188\154\232\182\133\232\191\135\228\184\138\233\153\144\231\154\132\231\137\169\229\147\129,\232\182\133\228\184\138\233\153\144\231\137\169\229\147\129\229\176\134\232\162\171<lable color=mailRed>\230\184\133\233\153\164</lable>\227\128\130<br/>\232\182\133\232\191\135\228\184\138\233\153\144\231\137\169\229\147\129:"),
  T("\233\131\168\229\136\134\233\130\174\228\187\182\229\144\171\230\156\137\233\162\134\229\143\150\229\144\142\232\182\133\228\184\138\233\153\144\231\137\169\229\147\129,\229\188\186\232\161\140\233\162\134\229\143\150\229\176\134<lable color=mailRed>\230\184\133\233\153\164</lable>\232\182\133\228\184\138\233\153\144\233\131\168\229\136\134\239\188\140\229\187\186\232\174\174\228\189\191\231\148\168\229\174\137\229\133\168\233\162\134\229\143\150\232\183\179\232\191\135\232\191\153\228\186\155\233\130\174\228\187\182\227\128\130<br/>\232\182\133\232\191\135\228\184\138\233\153\144\231\137\169\229\147\129:"),
  T("          \230\152\175\229\144\166\228\184\128\233\148\174\229\136\160\233\153\164\230\137\128\230\156\137\229\183\178\232\175\187\231\154\132\233\130\174\228\187\182?")
}

local function deleItemInit(self)
  self.ui.ImageView_title:setScaleY(-1)
  self.ui.ImageView_8463:setScaleX(-1)
  self.ui.ImageView_823232:setScale(0.5)
  self.ui.Label_title:setStroke(ccc3(0, 0, 0), 1)
  if self.datas.tag == 2 then
    self.ui.Label_892:setString(self.datas.btnStr or T("\229\174\137\229\133\168\233\162\134\229\143\150"))
  end
  if self.datas.tag == 3 then
    local wid, hei = 34, 26
    local thisCon = self.ui.mail9Bj_14363:getContentSize()
    self.ui.mail9Bj_14363:setContentSize(CCSizeMake(thisCon.width - wid, thisCon.height - hei))
    local thisCon = self.ui.outClickLay:getContentSize()
    self.ui.outClickLay:setContentSize(CCSizeMake(thisCon.width - wid, thisCon.height - hei))
    self.ui.ImageView_title:setPositionY(self.ui.ImageView_title:getPositionY() - hei / 2)
    self.ui.Label_title:setPositionY(self.ui.Label_title:getPositionY() - hei / 2)
    self.ui.ImageView_close:setPosition(self.ui.ImageView_close:getPositionX() - wid / 2, self.ui.ImageView_close:getPositionY() - hei / 2)
    self.ui.Panel_up:setPositionY(self.ui.Panel_up:getPositionY() + hei / 2)
  end
  if self.datas.title then
    self.ui.Label_title:setString(self.datas.title)
  end
  local txt = self.datas.str or self.deleStrs[self.datas.tag]
  self.ui.butt_a:setVisible(self.datas.tag ~= 3)
  self.ui.butt_c:setVisible(self.datas.tag ~= 2)
  self.ui.butt_b:setVisible(self.datas.tag ~= 1)
  if self.datas.tag == 1 then
    self.ui.butt_c:setPosition(self.ui.butt_b:getPosition())
  end
  local thisCon = self.ui.lay_post:getContentSize()
  local posX, posY = self.ui.lay_post:getPosition()
  local info = {
    cliprect = CCRectMake(posX, posY, thisCon.width + 20, thisCon.height + 10),
    container = self.container,
    priority = self.mainTouchPriority,
    zorder = 2,
    noshade = true,
    doPressIn = self:doPressIn(),
    cancelPressIn = self:cancelPressInBreak(),
    doClickIn = self:doClickIn(),
    cancelClickIn = self:cancelPressInBreak()
  }
  self.deleItemList = ed.draglist.create(info)
  local posY, han = thisCon.height * 2 - 22, 10
  local align = self.datas.align or "LEFT"
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = txt,
    fontSize = 18,
    maxWidth = thisCon.width,
    color = ccc3(67, 59, 56),
    align = align
  })
  self.deleItemList:addItem(autoText.node)
  autoText.node:setPosition(ccp(thisCon.width / 2 + 50, posY + 20))
  local sizeW, sizeH = autoText:getContentSize()
  posY = posY - sizeH
  han = han + sizeH
  local items = self.datas.item or {}
  if 0 < #items then
    local itemPosX, itemPosY = thisCon.width / 2 + 75, posY
    itemPosX = self.datas.itemPosX or itemPosX
    itemPosY = self.datas.itemPosY and itemPosY - self.datas.itemPosY or itemPosY
    local itemAttach, ii = {}, 1
    for i, v in ipairs(items) do
      if v.toMax then
        v.id = v.id or 0
        local id = string.gsub(v.id, "toMax", "")
        if id and 0 < tonumber(id) then
          v.id = tonumber(id)
        else
          local type = string.gsub(v.type, "toMax", "")
          v.type = type
        end
      end
      local icon = ed.createItemIcon({
        type = v.type or v.kind,
        id = v.id,
        amount = v.amount
      })
      if icon then
        icon:setPosition(ccp(itemPosX, itemPosY))
        if i % 7 == 0 then
          itemPosY = itemPosY - 60
          itemPosX = thisCon.width / 2 + 75
        else
          if i % 7 == 1 then
            han = han + 62
          end
          itemPosX = itemPosX + 60
        end
        self.deleItemList:addItem(icon)
      else
        ed.showToast(T("\232\175\165\231\177\187\229\158\139\230\151\160\230\179\149\229\136\155\229\187\186 type = %s id = %s", v.kind or "nil", v.id or "nil"))
        ed.printTable(v)
      end
      itemAttach[ii] = {
        icon = icon,
        id = v.id,
        kind = v.type or v.kind,
        type = v.type
      }
      ii = ii + 1
    end
    self.itemAttach = itemAttach
    self.deleItemList:initListHeight(han)
  else
    autoText.node:setPosition(ccp(thisCon.width / 2 + 50, 285 + sizeH / 2))
    self.deleItemList:initListHeight(han)
  end
end

class.deleItemInit = deleItemInit

local function addItemInit(self)
  self.ui.Label_111:setString(T("\229\165\150\229\138\177\229\134\133\229\174\185\229\166\130\228\184\139:"))
  local thisCon = self.ui.lay_post:getContentSize()
  local posX, posY = self.ui.lay_post:getPosition()
  local info = {
    cliprect = CCRectMake(posX, posY, thisCon.width, thisCon.height),
    rect = CCRectMake(posX, posY, thisCon.width, thisCon.height),
    container = self.container,
    priority = self.mainTouchPriority,
    zorder = 2,
    doPressIn = self:doPressIn(),
    cancelPressIn = self:cancelPressInBreak(),
    doClickIn = self:doClickIn(),
    cancelClickIn = self:cancelPressInBreak()
  }
  self.addItemList = ed.draglist.create(info)
  local items = self.datas.item or {}
  if #items < 5 then
    self.closeList = true
  end
  if 0 < #items then
    local han = 0
    local widhtItem = 150
    local itemPosX, itemPosY = posX + widhtItem / 2, posY + thisCon.height - (widhtItem - 30) / 2
    local itemNum = 5
    if itemNum >= #items then
      local addPosx = (itemNum - #items) * (widhtItem / 2)
      itemPosX = itemPosX + addPosx
      itemPosY = itemPosY + 15
    elseif #items <= itemNum * 2 then
      itemPosY = itemPosY - 15
    else
      han = 10
    end
    local itemAttach = {}
    for i, v in ipairs(items) do
      if v.toMax then
        v.id = v.id or 0
        local id = string.gsub(v.id, "toMax", "")
        if id and 0 < tonumber(id) then
          v.id = tonumber(id)
        else
          local type = string.gsub(v.type, "toMax", "")
          v.type = type
        end
      end
      local icon, label = ed.createItemIcon({
        type = v.type or v.kind,
        id = v.id,
        amount = v.amount
      }, true)
      icon:setScale(1)
      icon:setPosition(ccp(itemPosX, itemPosY))
      if i % itemNum == 0 then
        itemPosY = itemPosY - (widhtItem - 30)
        itemPosX = posX + widhtItem / 2
      elseif i % itemNum == 1 then
        han = han + (widhtItem - 30)
        itemPosX = itemPosX + widhtItem
      else
        itemPosX = itemPosX + widhtItem
      end
      self.addItemList:addItem(icon)
      if label then
        label:limitSizeByScale(widhtItem * 0.9, 40)
        local labelHeight = label:getContentSize().height * label:getScaleY()
        label:setPosition(ccp(45, -labelHeight * 0.5 + 3))
        label:setColor(ccc3(ed.colorToStr("#fffce7")))
        label:setShadow(ccc3(0, 0, 0), ccp(1, 1))
      end
      local labBj
      if v.toMax then
        local thisCon = icon:getContentSize()
        labBj = ed.createSprite("UI/alpha/1080P/common/item_maxtxtbj.png")
        labBj:setPosition(ccp(thisCon.width / 2, thisCon.height - 24))
        labBj:setScale(1.5)
        icon:addChild(labBj)
        label = ed.createttf(T("\229\183\178\232\182\133\233\162\157"), 21)
        label:setPosition(ccp(thisCon.width / 2, thisCon.height - 23))
        label:setColor(ccc3(245, 108, 106))
        icon:addChild(label)
        label:setShadow(ccc3(0, 0, 0), ccp(1, 1))
      end
      icon:setCascadeOpacityEnabled(true)
      icon:setOpacity(0)
      icon:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.1 * i), CCFadeIn:create(0.15)))
      table.insert(itemAttach, {
        icon = icon,
        id = v.id,
        kind = v.kind or v.type,
        type = v.type,
        label = label,
        labBj = labBj
      })
    end
    self.itemAttach = itemAttach
    self.addItemList:initListHeight(han)
  end
end

class.addItemInit = addItemInit

local function werrWinInit(self)
  local str = self.datas.str
  local confirm = ed.ui.autoText.new()
  confirm:initParam({
    color = ccc3(254, 251, 232),
    context = str,
    fontSize = 18,
    maxWidth = self.ui.boyPos:getContentSize().width
  })
  local width, height = confirm:getCurContentSize()
  local posx, posy = self.ui.boyPos:getPosition()
  confirm.node:setPosition(ccp(posx + (self.ui.boyPos:getContentSize().width - width) * 0.5, posy + self.ui.boyPos:getContentSize().height - (self.ui.boyPos:getContentSize().height - height) * 0.6))
  self.container:addChild(confirm.node)
  self:btRegisterButtonClick({
    button = self.ui.buttOk,
    key = "buttOks",
    clickHandler = function()
      self:destroy({skipAnim = true})
    end,
    force = true,
    pressScale = 0.9
  })
end

class.werrWinInit = werrWinInit

local function deleItemInitTouchHandler(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.butt_a,
    key = "butt_a",
    clickHandler = function()
      if self.clickGeft then
        self.clickGeft()
        self:destroy({skipAnim = true})
      end
    end,
    force = true,
    pressScale = 0.9
  })
  self:btRegisterButtonClick({
    button = ui.butt_b,
    key = "butt_b",
    clickHandler = function()
      if self.clickBack then
        self.clickBack()
        if self.destroyBack then
          self.destroyBack()
        end
        self:destroy({skipAnim = true})
      end
    end,
    force = true,
    pressScale = 0.9
  })
  self:btRegisterButtonClick({
    button = ui.butt_c,
    key = "butt_c",
    clickHandler = function()
      if self.destroyBack then
        self.destroyBack()
      end
      self:destroy({skipAnim = true})
    end,
    force = true,
    pressScale = 0.9
  })
end

class.deleItemInitTouchHandler = deleItemInitTouchHandler

local function registerTouchHandler(self)
  local ui = self.ui
  self:btRegisterOutClick({
    area = ui.lay_post,
    key = "out_click",
    clickHandler = function()
      if self.notClose then
        self.notClose = 2
        return
      end
      if self.destroyBack then
        self.destroyBack()
      end
      if self.addMedalIds then
        for _, v in ipairs(self.addMedalIds) do
          ed.UITool.openView("getMedalPop", {id = v})
        end
      end
      self:destroy({skipAnim = true})
    end
  })
  self:btRegisterButtonClick({
    button = ui.ImageView_close,
    key = "close",
    clickHandler = function()
      if self.notClose then
        self.notClose = 2
        return
      end
      if self.destroyBack then
        self.destroyBack()
      end
      self:destroy({skipAnim = true})
    end,
    pressScale = 0.7,
    normalScale = 0.75
  })
end

class.registerTouchHandler = registerTouchHandler

local function doPressIn(self)
  local function handler(x, y)
    local ia = self.itemAttach or {}
    
    for i = 1, #ia do
      local a = ia[i]
      if a and a.icon then
        local icon = a.icon
        if icon and icon.getScale then
          self.oriItemScale = self.oriItemScale or icon:getScale()
          local id = a.id
          local kind = a.kind
          if ed.containsPoint(icon, x, y) then
            icon:setScale(self.oriItemScale * 0.95)
            self.scaledIcon = icon
            return {
              index = i,
              id = id,
              type = kind
            }
          end
        end
      end
    end
    if self.closeList then
      if self.notClose then
        self.notClose = 2
        return
      end
      if self.destroyBack then
        self.destroyBack()
      end
      self:destroy({skipAnim = true})
    end
  end
  
  return handler
end

class.doPressIn = doPressIn

local function doClickIn(self)
  local function handler(x, y, v)
    if not v then
      return
    end
    ed.ui.packageDetailWin.create({
      id = v.id,
      type = v.type
    }):popWindow()
  end
  
  return handler
end

class.doClickIn = doClickIn

local function createAttachDetail(self, icon, item)
  local x, y = icon:getPosition()
  y = y + 30
  local pos = icon:getParent():convertToWorldSpace(ccp(x, y))
  local panel = ed.readequip.getDetailCard(item.id, {ps = ""}, {
    noArrow = true,
    anchor = ccp(0.5, 0.5)
  })
  if panel then
    panel:setPosition(pos)
    self.container:addChild(panel, 40)
    self.attachDetailPanel = panel
  end
end

class.createAttachDetail = createAttachDetail

local function cancelPressInBreak(self)
  local function handler(x, y, args)
    if not tolua.isnull(self.scaledIcon) then
      self.scaledIcon:setScale(self.oriItemScale)
      
      self.scaledIcon = nil
    end
    local panel = self.attachDetailPanel
    if not tolua.isnull(panel) then
      panel:removeFromParentAndCleanup(true)
    end
  end
  
  return handler
end

class.cancelPressInBreak = cancelPressInBreak

local function overlapping(data)
  local newTbas = {}
  local newItem = {}
  local i = 1
  for k, v in pairs(data or {}) do
    v.type = v.type or v.kind
    local key = v.id and tonumber(v.id) > 0 and v.id or v.type
    if key then
      if v.toMax then
        if v.id and tonumber(v.id) > 0 then
          v.id = v.id .. "toMax"
          key = v.id
        else
          v.type = v.type .. "toMax"
          key = v.type
        end
      end
      if newTbas[key] then
        newItem[newTbas[key]].amount = newItem[newTbas[key]].amount + v.amount
      else
        newItem[i] = {
          id = v.id,
          type = v.type,
          amount = v.amount,
          toMax = v.toMax
        }
        newTbas[key] = i
        i = i + 1
      end
    else
      newItem[i] = v
      i = i + 1
    end
  end
  return newItem
end

class.overlapping = overlapping
