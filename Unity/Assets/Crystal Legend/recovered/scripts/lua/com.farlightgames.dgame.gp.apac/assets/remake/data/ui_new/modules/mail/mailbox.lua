local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.mailbox = class
ed.UITool.registViewOpenFunc("mailbox", function()
  local cpl = ed.playerlimit.getAreaUnlockPrompt("Mailbox")
  if cpl then
    ed.showToast(cpl)
    return
  end
  ed.ui.mailbox.create():popWindow()
end)
local mailListTimeBrk = {}

local function create(param)
  local self = base.create("mailbox")
  setmetatable(self, class.mt)
  self.mailList = {}
  local container, ui = ed.editorui(ed.uieditor.mailPop, {
    container = self.container,
    ui = self.ui
  })
  self.autoIng = false
  ui.mail_butDelestr2:limitWidthByScale(95)
  ui.mail_butDelestr1:limitWidthByScale(95)
  ed.player:resetNewMail()
  self:screenAdjustment()
  self:createListLayer()
  self:registerTouchHandler()
  self:show({
    callback = function()
      function ed.netreply.getMail()
        xpcall(function()
          local datas = ed.player:getMailData()
          
          self.mailList = self:orderMailData(datas)
          self.draglist:initListHeight(#self.mailList * 83 + 35)
          self:beginOrEndLoadMailList(true)
        end, EDDebug)
      end
      
      local msg = ed.upmsg.get_maillist()
      ed.send(msg, "get_maillist")
    end,
    skipAnim = true
  })
  return self
end

class.create = create

local function asyncLoadMail(self)
  self.unreads = 0
  local index = 1
  self.mails = {}
  
  local function handler()
    if index <= #self.mailList then
      self:createMail(index)
      if index == 1 then
        local m = self.mails[index]
        if m then
          m.mail_butt_up:setVisible(true)
          self.letterData = self:doReadMailRet(index)
          self:rigMailupData()
          self.longMailUp = m.mail_butt_up
          self.ui.mail_butDele:setVisible(true)
          self.ui.mail_butAuto:setVisible(true)
          self.ui.boyLays:setVisible(true)
          self.ui.mail_numMax:setString(#self.mailList .. "/100")
          self.ui.foxMailNil:setVisible(false)
        end
      end
      index = index + 1
    else
      self:beginOrEndLoadMailList()
      if index == 1 then
        self.ui.foxMailNil:setVisible(true)
      end
    end
  end
  
  return handler
end

class.asyncLoadMail = asyncLoadMail

local function beginOrEndLoadMailList(self, addUp)
  if addUp then
    self:getScene():registerUpdateHandler("asyncLoadMail", self:asyncLoadMail())
  else
    self:getScene():removeUpdateHandler("asyncLoadMail")
    self.autoIng = true
  end
end

class.beginOrEndLoadMailList = beginOrEndLoadMailList

local function refreshMailList(self)
  local list = self.draglist:getList()
  local listPosx, listPosy = list:getPosition()
  local listHeight = self.draglist.listHeight
  local ml = self.mails or {}
  local index = 1
  if #ml <= 0 then
    if self.draglist then
      self.draglist:clearList()
    end
  else
    self:orderMail()
    for i = 1, #ml do
      if ml[i] and ml[i].board then
        ml[i].board:setPosition(ccp(4 + self.btnUiPosx, self.thisConList.height - 84 * (index - 1) - 50))
        index = index + 1
      end
    end
    self.draglist:initListHeight(#self.mailList * 84 + 35)
  end
  self.ui.mail_numMax:setString(#self.mails .. "/100")
  if listPosx and listPosy and listHeight then
    if listHeight <= self.draglist.listHeight then
      self.draglist:setListPos(ccp(listPosx, listPosy))
    else
      if self.draglist.listHeight <= self.draglist.height then
        return
      elseif listPosy > self.draglist.listHeight - self.draglist.height then
        listPosy = self.draglist.listHeight - self.draglist.height
      end
      self.draglist:setListPos(ccp(listPosx, listPosy))
    end
  end
end

class.refreshMailList = refreshMailList

local function createListLayer(self)
  local function doPressInUp(x, y)
    local mails = self.mails or {}
    
    for i = 1, #mails do
      local m = mails[i]
      if ed.containsPoint(m.PressIn, x, y) then
        return i
      end
    end
  end
  
  local function doClickInUp(x, y, index)
    local m = self.mails[index]
    if ed.containsPoint(m.PressIn, x, y) then
      m.mail_butt_up:setVisible(true)
      if self.longMailUp and self.longMailUp ~= m.mail_butt_up then
        self.longMailUp:setVisible(false)
        self.letterData = self:doReadMailRet(index)
        self:rigMailupData()
      else
        self:rigMailItemButt()
      end
      self.longMailUp = m.mail_butt_up
    end
  end
  
  local thisCon = self.ui.mail_listPos:getContentSize()
  self.thisConList = thisCon
  local posX, posY = self.ui.mail_listPos:getPosition()
  local info = {
    cliprect = CCRectMake(posX, posY, thisCon.width, thisCon.height),
    rect = CCRectMake(posX + 6, posY - 3, thisCon.width - 12, thisCon.height + 6),
    container = self.ui.Panel_left,
    priority = self.mainTouchPriority - 5,
    bar = {
      bglen = thisCon.height,
      bgpos = ccp(posX, posY + thisCon.height / 2)
    },
    doPressIn = doPressInUp,
    doClickIn = doClickInUp,
    upShade = "UI/alpha/1080P/mail/mail_scroll_mask.png",
    downShade = "UI/alpha/1080P/mail/mail_scroll_mask.png",
    capInsets = CCRectMake(10, 1, 20, 1),
    contentSize = CCSizeMake(thisCon.width, 10)
  }
  self.draglist = ed.draglist.create(info)
  self.draglist.downShade:setScaleY(1)
  self.draglist.upShade:setOpacity(0)
end

class.createListLayer = createListLayer

function class:butUiAutoSize(ui)
  local thisCon = self.ui.mail_listPos:getContentSize()
  local posx = thisCon.width - 293
  ui.ltemBj_1:setContentSize(CCSizeMake(thisCon.width + 4, 91.5))
  ui.ltemBj_2:setContentSize(CCSizeMake(thisCon.width + 4, 91.5))
  ui.mail_butt_up:setContentSize(CCSizeMake(thisCon.width + 4, 91.5))
  ui.itembjImg:setPositionX(ui.itembjImg:getPositionX() - posx / 2)
  ui.name:setPositionX(ui.name:getPositionX() - posx / 2)
  ui.from:setPositionX(ui.from:getPositionX() - posx / 2)
  ui.Label_expire_time:setPositionX(ui.Label_expire_time:getPositionX() + posx / 2)
  ui.tagImgbj:setPositionX(ui.tagImgbj:getPositionX() + posx)
  ui.tagImgbj2:setPositionX(ui.tagImgbj2:getPositionX() + posx)
  ui.ImageView_1:setPositionX(ui.ImageView_1:getPositionX() + posx / 2 - 3)
  ui.ImageView_2:setPositionX(ui.ImageView_2:getPositionX() + posx / 2 - 3)
  return 0 < posx and posx / 2 + 4 or 0
end

local function createMail(self, index)
  if index > #self.mailList then
    return
  end
  local info = self.mailList[index] or {}
  local handler, ui = ed.editorui(ed.uieditor.mailListItem)
  ed.setLabelString(ui.Label2_tag1, "\229\183\178\n\232\175\187")
  if not ed.isAreaZh() then
    local img1 = ed.createSprite("UI/alpha/1080P/mail/mail_icon_item.png")
    ui.tagImgbj:addChild(img1)
    ed.layout.centerInParent(img1)
    local img2 = ed.createSprite("UI/alpha/1080P/mail/mail_icon_read.png")
    ui.tagImgbj2:addChild(img2)
    ed.layout.centerInParent(img2)
    ui.Label2_tag1:setVisible(false)
    ui.Label1_tag1:setVisible(false)
    ui.Label1_tag2:setVisible(false)
  end
  local posx = self:butUiAutoSize(ui)
  self.btnUiPosx = posx
  self.draglist:addItem(handler, ccp(4 + posx, self.thisConList.height - 83 * (index - 1) - 50))
  ui.from:setString(info.from or "nil")
  ui.name:setString(info.name or "nil" .. index)
  ui.name:limitWidthByScale(160)
  ui.ltemBj_1:setVisible(info.status == "unread")
  ui.name:setColor(ccc3(ed.colorToStr(info.status == "unread" and "#63493F" or "#68635c")))
  ui.from:setColor(ccc3(ed.colorToStr(info.status == "unread" and "#7B5C31" or "#68635c")))
  ui.Label_expire_time:setString(info.nTime)
  if info.readTime ~= "nil" then
    ui.Label_expire_time:setColor(info.readTime)
  end
  if info.timeRed then
    ui.Label_expire_time:setColor(info.timeRed)
  end
  ui.ImageView_1:setVisible(info.status == "unread")
  ui.ImageView_2:setVisible(info.status ~= "unread")
  self.unreads = info.status == "unread" and self.unreads + 1 or self.unreads
  if info.attached and info.status == "read" then
    ui.Label2_tag1:setString(T("\229\183\178\n\233\162\134"))
  end
  local posX, posY = ui.itembjImg:getPosition()
  if info.iconid and type(info.iconid) == "table" then
    local icon = ed.createItemIcon({
      type = info.iconid.type or "item",
      id = info.iconid.id,
      amount = 1
    })
    ui.icon = icon
    icon:setScale(0.8)
    icon:setPosition(ccp(posX, posY))
    handler:addChild(icon, 99)
  elseif info.iconres then
    ui.tagImgbj:setVisible(false)
    local icon = ed.createSprite(info.iconres)
    icon:setPosition(posX, posY)
    handler:addChild(icon, 99)
    icon:setScale(1.5)
    ui.icon = icon
  end
  ui.PressIn = ui.ltemBj_2
  ui.board = handler
  self.mails[index] = ui
  self.mails[index].data = info
end

class.createMail = createMail

local function createListLayerLetter(self)
  if self.letterlist then
    self.letterlist:initListHeight(5)
    self.letterlist:clearList()
  else
    self.ui.bodyPos:setPositionY(self.ui.bodyPos:getPositionY() + 60)
    local thisCon = self.ui.bodyPos:getContentSize()
    self.ui.bodyPos:setContentSize(CCSizeMake(thisCon.width, thisCon.height - 60))
    thisCon = self.ui.bodyPos:getContentSize()
    local posX, posY = self.ui.bodyPos:getPosition()
    local info = {
      cliprect = CCRectMake(posX, posY, thisCon.width + 10, thisCon.height),
      container = self.ui.boyLays,
      priority = self.mainTouchPriority - 5,
      noshade = true
    }
    self.letterlist = ed.draglist.create(info)
  end
  if self.letterlistItem then
    self.letterlistItem:initListHeight(5)
    self.letterlistItem:clearList()
  else
    local thisCon = self.ui.bodyPosItem:getContentSize()
    local posX, posY = self.ui.bodyPosItem:getPosition()
    local info = {
      cliprect = CCRectMake(posX, posY, thisCon.width + 10, thisCon.height),
      rect = CCRectMake(posX + 6, posY - 3, thisCon.width - 12, thisCon.height + 6),
      container = self.ui.boyLays,
      priority = self.mainTouchPriority - 5,
      noshade = true
    }
    self.letterlistItem = ed.draglist.create(info)
  end
  if self.itemlistRig then
    self.itemlistRig:clearList()
    self.itemAttach = {}
  else
    local thisCon = self.ui.Panel_itemPos:getContentSize()
    local posX, posY = self.ui.Panel_itemPos:getPosition()
    local info = {
      cliprect = CCRectMake(posX - 4, posY, thisCon.width - 7, thisCon.height),
      container = self.ui.itemLay,
      priority = self.mainTouchPriority - 5,
      noshade = true,
      doPressIn = self:doPressIn(),
      cancelPressIn = self:cancelPressInBreak(),
      doClickIn = self:doClickIn(),
      cancelClickIn = self:cancelPressInBreak()
    }
    self.itemlistRig = ed.draglist.create(info)
  end
  self.isAttached = self.letterData.attached
  self.newStatus = self.letterData.status
  self.newOpenId = self.letterData.id
  local content = self.letterData.content
  self.ui.Label_titleStr:setString(content.title)
  self.ui.Label_name:setString(content.from)
  self.ui.Label_time:setString(content.time .. ed.getUTCLabel())
  local thisList = self.isAttached and self.letterlistItem or self.letterlist
  local thisCon = self.isAttached and self.ui.bodyPosItem:getContentSize() or self.ui.bodyPos:getContentSize()
  local body, touchHandlers = content.body, {}
  if type(body) == "table" and body.t == "format_mail" then
    self.format_mail = true
    body, touchHandlers = ed.mailutil.create(body.mid, body.param, 29 + self.px)
    content.body = body
  end
  self.touchHandlers = touchHandlers or {}
  if type(body) == "string" then
    local labels = ed.mailutil.splitLabel(body)
    local autoStr = self:retAutoStrBoy(labels)
    local autoText = ed.ui.autoText.new()
    autoText:initParam({
      context = autoStr,
      maxWidth = thisCon.width - 20,
      priority = -300,
      color = ccc3(ed.colorToStr("#66ccff"))
    })
    autoText:addRegisterHandler("mailLinkHandler", function(index, x, y)
      local url = self.urlTab[tonumber(index)]
      if not url then
        return
      end
      print("click url : ", url)
      if self.letterData.type == 166 then
        if EDAndroidExtra then
          EDAndroidExtra("openUrlWithInnerBrowser", url)
        elseif EDIOSExtra then
          EDIOSExtra("openUrlWithInnerBrowser", url)
        end
      else
        ed.openURL(url)
      end
    end)
    local sizeW, sizeH = autoText:getContentSize()
    autoText.node:setPosition(ccp(10, thisCon.height + (self.isAttached and 137 or 44)))
    thisList:addItem(autoText.node)
    thisList:initListHeight(sizeH)
  else
    self.listui = {}
    local container = thisList:getList()
    local readnode = ed.readnode.create(container, self.listui)
    local ui_info = {
      {
        t = "CCNode",
        base = {name = "body", node = body},
        layout = {
          anchor = ccp(0, 1),
          position = ccp(10, thisCon.height + 140)
        }
      }
    }
    readnode:addNode(ui_info, 233)
    local size = self.listui.body:getContentSize()
    if not self.isAttached then
      self.listui.body:setPosition(ccp(10, thisCon.height + 50))
    end
    thisList:initListHeight(size.height + 10)
  end
  if self.isAttached then
    self.attachedItems = content.attach
    local itemAttach = {}
    for i, v in ipairs(self.attachedItems or {}) do
      local id = v.id
      local amount = v.amount
      local items = {
        type = v.kind or v.type,
        id = v.id,
        amount = v.amount
      }
      local icon = ed.createItemIcon(items)
      icon:setPosition(ccp(35 + 70 * i, 118))
      self.itemlistRig:addItem(icon)
      icon:setScale(0.8)
      local thisCon = icon:getContentSize()
      local labDj = ed.createSprite("UI/alpha/1080P/package/selected.png")
      labDj:setPosition(ccp(28, 23))
      labDj:setScale(0.8)
      icon:addChild(labDj)
      labDj:setVisible(self.newStatus ~= "unread")
      itemAttach[i] = {
        icon = icon,
        id = id,
        kind = v.kind or v.type,
        labDj = labDj
      }
    end
    self.itemAttach = itemAttach
    self.itemlistRig:initListWidth(#itemAttach * 70 + 13)
  end
end

class.createListLayerLetter = createListLayerLetter

local function rigMailupData(self)
  self.letterData = self.letterData or {}
  self:createListLayerLetter()
  self:rigMailItemButt()
end

class.rigMailupData = rigMailupData

local function rigMailItemButt(self)
  if self.letterData then
    self.url = self.letterData.url
    local buttonLable = self.isAttached and T("\233\162\134\229\143\150") or self.url and T("\231\171\139\229\141\179\229\137\141\229\190\128") or nil
    self.ui.getItemButStr:setString(buttonLable or "")
    self.ui.getItemButStr_bj:setString(buttonLable or "")
    self.ui.itemLay:setVisible(self.isAttached ~= nil)
    local vis = buttonLable ~= nil and self.newStatus == "unread" or self.url ~= nil
    self.ui.getItemBut:setVisible(vis)
    self.ui.deleOneBtn:setVisible(not vis)
    self:doReadMailStatus(self.isAttached or self.newStatus ~= "unread")
  end
end

class.rigMailItemButt = rigMailItemButt

local function registerTouchHandler(self)
  local ui = self.ui
  self:btRegisterOutClick({
    area = ui.mail9Bj_1,
    key = "mail9Bj_1",
    clickHandler = function()
      if self.autoIng then
        ed.getNetReply("readMail")
        ed.getNetReply("cut_read_mail")
        self:destroy({skipAnim = true})
        local BuilddingType = ed.ui.configs.mainSceneMap.builddingType
        FireEvent("MainBuildRedTagChange", BuilddingType.Mailbox)
        FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.MAIL)
      end
    end
  })
  
  local function loclaButtonClick(button, key, clickHandler, pressScale, normalScale)
    self:btRegisterButtonClick({
      button = button,
      key = key,
      clickHandler = clickHandler,
      force = true,
      pressScale = pressScale or 0.9,
      normalScale = normalScale or 1
    })
  end
  
  loclaButtonClick(ui.mail_offBut, "close_button", function()
    if self.autoIng then
      ed.getNetReply("readMail")
      ed.getNetReply("cut_read_mail")
      self:destroy({skipAnim = true})
      ed.player:setNewMailAmount(self.unreads)
    end
  end, 0.75, 0.85)
  loclaButtonClick(ui.getItemBut, "getItemBut", function()
    if not self.autoIng then
      return
    end
    if self.url then
      print("type:", self.letterData.type, " url:", self.url)
      if self.letterData.type == 166 then
        if EDAndroidExtra then
          EDAndroidExtra("openUrlWithInnerBrowser", self.url)
        elseif EDIOSExtra then
          EDIOSExtra("openUrlWithInnerBrowser", self.url)
        end
      else
        ed.openURL(self.url)
      end
    elseif self.newStatus == "unread" then
      self:doReadMail()
    end
  end)
  loclaButtonClick(ui.mail_butDele, "mail_butDele", function()
    if not self.autoIng then
      return
    end
    local panel = ed.ui.maillocalbox.create({
      type = "deleItem",
      tag = 3,
      clickBack = function()
        xpcall(function()
          self:autoDeleMailFun()
        end, EDDebug)
      end
    })
    panel:popWindow()
  end)
  loclaButtonClick(ui.deleOneBtn, "deleOneBtn", function()
    if not self.autoIng then
      return
    end
    local panel = ed.ui.maillocalbox.create({
      type = "deleItem",
      tag = 3,
      str = T("                 \230\152\175\229\144\166\229\136\160\233\153\164\233\130\174\228\187\182?"),
      clickBack = function()
        xpcall(function()
          print("delete oneMail")
          self:deleOneMailFun()
        end, EDDebug)
      end
    })
    panel:popWindow()
  end)
  loclaButtonClick(ui.mail_butAuto, "mail_butAuto", function()
    if not self.autoIng then
      return
    end
    if self.autoIng then
      self:doReadMailAuto()
    end
  end)
end

class.registerTouchHandler = registerTouchHandler

local function refreshMailAt(self, id)
  local index = self:getMailsIdToIndex(id)
  if index == 0 then
    return
  end
  local mail = self.mails[index]
  local data = mail.data
  self.unreads = data.status == "unread" and self.unreads - 1 or self.unreads
  if data.attached then
    local preStatus = data.status
    data.status = "read"
    if preStatus == "unread" then
      local board = mail.board
      mail.ltemBj_1:setVisible(data.status == "unread")
      mail.name:setColor(ccc3(ed.colorToStr(data.status == "unread" and "#63493F" or "#68635c")))
      mail.from:setColor(ccc3(ed.colorToStr(data.status == "unread" and "#7B5C31" or "#68635c")))
      mail.ImageView_2:setVisible(mail.data.status ~= "unread")
      mail.ImageView_1:setVisible(mail.data.status == "unread")
      mail.Label2_tag1:setString(T("\229\183\178\n\233\162\134"))
      for k, v in pairs(self.itemAttach) do
        v.labDj:setVisible(true)
      end
      self.ui.getItemBut:setVisible(false)
      self.ui.deleOneBtn:setVisible(true)
      self.newStatus = "read"
    end
  else
    if self.longMailRead == nil then
      self.longMailRead = {mail = mail, data = data}
      return
    end
    local newMail = self.longMailRead.mail
    local newData = self.longMailRead.data
    local preStatus = newData.status
    newData.status = "read"
    if preStatus == "unread" then
      local board = newMail.board
      local icon = newMail.icon
      newMail.ltemBj_1:setVisible(newData.status == "unread")
      newMail.name:setColor(ccc3(ed.colorToStr(newData.status == "unread" and "#63493F" or "#68635c")))
      newMail.from:setColor(ccc3(ed.colorToStr(newData.status == "unread" and "#7B5C31" or "#68635c")))
      icon:removeFromParentAndCleanup(true)
      local posX, posY = newMail.itembjImg:getPosition()
      local icon = ed.createSprite("UI/alpha/1080P/mail/mailbox_maillist_letter_open_icon.png")
      icon:setPosition(posX, posY)
      newMail.board:addChild(icon, 99)
      newMail.icon = icon
      icon:setScale(1.5)
      newMail.ImageView_2:setVisible(newMail.data.status ~= "unread")
      newMail.ImageView_1:setVisible(newMail.data.status == "unread")
    end
    self.longMailRead = {mail = mail, data = data}
  end
end

class.refreshMailAt = refreshMailAt

function class:triggerSpecialEquipEvent(Item)
  if next(Item) == nil then
    return
  end
  local newTab = {}
  for i, v in ipairs(Item or {}) do
    if (v.kind or v.type) ~= "hero" then
      table.insert(newTab, v)
    end
  end
  if 0 < #newTab then
    local panel = ed.ui.maillocalbox.create({type = "addItem", item = newTab})
    panel:popWindow()
  end
end

local function doReadMailStatus(self, isLongMailDex)
  if isLongMailDex then
    if self.longMailRead then
      local newMail = self.longMailRead.mail
      local newData = self.longMailRead.data
      local preStatus = newData.status
      newData.status = "read"
      if preStatus == "unread" then
        local board = newMail.board
        local icon = newMail.icon
        newMail.ltemBj_1:setVisible(newData.status == "unread")
        newMail.name:setColor(ccc3(ed.colorToStr(newData.status == "unread" and "#63493F" or "#68635c")))
        newMail.from:setColor(ccc3(ed.colorToStr(newData.status == "unread" and "#7B5C31" or "#68635c")))
        icon:removeFromParentAndCleanup(true)
        local posX, posY = newMail.itembjImg:getPosition()
        local icon = ed.createSprite("UI/alpha/1080P/mail/mailbox_maillist_letter_open_icon.png")
        icon:setPosition(posX, posY)
        newMail.board:addChild(icon, 99)
        newMail.icon = icon
        icon:setScale(1.5)
        newMail.ImageView_2:setVisible(newMail.data.status ~= "unread")
        newMail.ImageView_1:setVisible(newMail.data.status == "unread")
      end
    end
    return
  end
  ed.registerNetReply("readMail", function(data)
    xpcall(function()
      local function pop(index)
      end
      
      if data._result == "success" then
        pop()
        self:refreshMailAt(self.newOpenId)
      end
    end, EDDebug)
  end, {
    self.newOpenId
  })
  local msg = ed.upmsg.read_mail()
  msg._ids = {
    self.newOpenId
  } or {}
  ed.send(msg, "read_mail")
end

class.doReadMailStatus = doReadMailStatus

local function doReadMail(self)
  local function doRead(geftItem)
    ed.registerNetReply("readMail", function(data)
      xpcall(function()
        local function pop(index)
          index = index or 1
          
          if data._mail_acc then
            for i = index, #data._mail_acc do
              local v = data._mail_acc[i]
              if v._type == "hero" then
                local id = v._id
                ed.ui.SummonRewardCardWindow.create({
                  rewards = {
                    {
                      id = id,
                      amount = 1,
                      type = "hero"
                    }
                  },
                  noRewards = true,
                  closeCallback = function()
                    pop(index + 1)
                  end
                }):popWindow()
                break
              elseif v._type == "magic_soul" then
                local id = v._id
                local amount = v._amount
                local hid = ed.readhero.getMakeid(id)
                ed.ui.SummonRewardCardWindow.create({
                  rewards = {
                    {
                      id = hid,
                      amount = amount,
                      type = "hero"
                    }
                  },
                  convertIdxs = {true},
                  noRewards = true
                }):popWindow()
                ed.player:addRewards({
                  {
                    _type = "item",
                    _id = id,
                    _amount = amount
                  }
                })
                break
              elseif v._type == "pet" then
                local petId = v._pet._id
                local isBuyPet = false
                if v._extra then
                  for _, value in ipairs(v._extra) do
                    if value._key == "trading_action" and value._value == "buy" then
                      isBuyPet = true
                    end
                  end
                  if isBuyPet then
                    local panel = PetGainPanel.create(petId, function()
                      pop(index + 1)
                    end)
                    panel:popWindow()
                    break
                  end
                end
              elseif v._type == "magicstone" then
                local id = v._id
                local amount = v._amount
                ed.player:addMagicStone(id, amount)
              end
            end
          end
          if self.url then
            ed.openURL(self.url)
          end
        end
        
        if data._result == "success" then
          pop()
          self:refreshMailAt(self.letterData.id)
          self:triggerSpecialEquipEvent(geftItem)
        end
      end, EDDebug)
    end, {
      self.newOpenId
    })
    local msg = ed.upmsg.read_mail()
    msg._ids = {
      self.newOpenId
    } or {}
    ed.send(msg, "read_mail")
  end
  
  local itemIdKeyToNum = {}
  local overfull = {}
  local geftItem = {}
  local items = self.attachedItems or {}
  for i, v in ipairs(items) do
    local id = v.id
    local amount = v.amount
    local type = v.type
    local ca, maxAmount
    if id then
      ca = (ed.player.equip_qunty[id] or 0) + (itemIdKeyToNum[id] or 0)
      maxAmount = ed.player:getItemMaxAmount(id)
    else
      ca = ed.player:getPoint(v.type)
      maxAmount = ed.player:getItemMaxAmount(nil, v.type)
    end
    if type and (type == "hero" or type == "medal") then
      maxAmount = ca + amount + 1
    end
    print("maxAmount", maxAmount)
    local da = 0
    if v.id then
      da = ca + amount - maxAmount
      if 0 < da then
        table.insert(overfull, {
          id = id,
          amount = amount,
          kind = v.type
        })
      else
        itemIdKeyToNum[id] = (itemIdKeyToNum[id] or 0) + amount
      end
    else
      da = ca + amount - maxAmount
      if 0 < da then
        table.insert(overfull, {
          amount = amount,
          kind = v.kind or v.type
        })
      else
        itemIdKeyToNum[v.kind or v.type] = (itemIdKeyToNum[v.kind or v.type] or 0) + amount
      end
    end
    table.insert(geftItem, {
      id = id,
      amount = amount,
      kind = v.kind or v.type,
      toMax = 0 < da
    })
  end
  if #overfull == 0 then
    doRead(geftItem)
  else
    local panel = ed.ui.maillocalbox.create({
      type = "deleItem",
      tag = 1,
      item = overfull,
      clickGeft = function()
        xpcall(function()
          doRead(geftItem)
        end, EDDebug)
      end
    })
    panel:popWindow()
  end
end

class.doReadMail = doReadMail

local function deleOneMailFun(self)
  if not self.newOpenId then
    return
  end
  local deleTabId = {
    self.newOpenId
  }
  ed.registerNetReply("cut_read_mail", function(data)
    xpcall(function()
      if data and data._result == "success" then
        self.longMailRead = nil
        local key
        for i, v in ipairs(self.mails) do
          if v.data and v.data.id == self.newOpenId then
            v.board:removeFromParentAndCleanup(true)
            key = i
            break
          end
        end
        if key then
          table.remove(self.mails, key)
        end
        for i = 1, #self.mailList do
          if self.mailList[i].id == self.newOpenId then
            table.remove(self.mailList, i)
            break
          end
        end
        self:refreshMailList()
        key = key - 1
        local m = self.mails[key] or self.mails[1]
        if m then
          m.mail_butt_up:setVisible(true)
          self.letterData = self:doReadMailRet(self.mails[key] and key or 1)
          self:rigMailupData()
          self.longMailUp = m.mail_butt_up
        end
        self.ui.mail_butDele:setVisible(m ~= nil)
        self.ui.mail_butAuto:setVisible(m ~= nil)
        self.ui.boyLays:setVisible(m ~= nil)
        self.ui.foxMailNil:setVisible(m == nil)
        self.ui.Label_titleStr:setVisible(m ~= nil)
        ed.showToast(T("\229\183\178\229\136\160\233\153\164\233\130\174\228\187\182"))
      end
    end, EDDebug)
  end, deleTabId)
  local msg = ed.upmsg.cut_read_mail()
  msg._ids = deleTabId
  ed.send(msg, "cut_read_mail")
end

class.deleOneMailFun = deleOneMailFun

local function autoDeleMailFun(self)
  local deleTabId, newTabs, deleTabs = {}, {}, {}
  for i, v in ipairs(self.mails) do
    local data = v.data or {}
    if data.status and data.status == "read" then
      table.insert(deleTabId, data.id)
      table.insert(deleTabs, v)
    else
      table.insert(newTabs, v)
    end
  end
  if #deleTabId <= 0 then
    ed.showToast(T("\230\154\130\230\151\160\229\143\175\229\136\160\233\153\164\233\130\174\228\187\182"))
    return
  end
  ed.registerNetReply("cut_read_mail", function(data)
    xpcall(function()
      if data and data._result == "success" then
        for k, v in pairs(deleTabs) do
          local data = v.data or {}
          for i = 1, #self.mailList do
            if self.mailList[i].id == data.id then
              table.remove(self.mailList, i)
              if data.id == self.newOpenId then
                self.longMailUp = nil
              end
              break
            end
          end
          v.board:removeFromParentAndCleanup(true)
        end
        self.mails = newTabs
        self:refreshMailList()
        if not self.longMailUp then
          local m = self.mails[1]
          if m then
            m.mail_butt_up:setVisible(true)
            self.letterData = self:doReadMailRet(1)
            self:rigMailupData()
            self.longMailUp = m.mail_butt_up
          end
          self.ui.mail_butDele:setVisible(m ~= nil)
          self.ui.mail_butAuto:setVisible(m ~= nil)
          self.ui.boyLays:setVisible(m ~= nil)
          self.ui.foxMailNil:setVisible(m == nil)
          self.ui.Label_titleStr:setVisible(m ~= nil)
        end
        ed.showToast(T("\230\136\144\229\138\159\229\136\160\233\153\164\229\183\178\232\175\187\233\130\174\228\187\182"))
      end
    end, EDDebug)
  end, deleTabId)
  local msg = ed.upmsg.cut_read_mail()
  msg._ids = deleTabId
  ed.send(msg, "cut_read_mail")
end

class.autoDeleMailFun = autoDeleMailFun

local function doReadMailAuto(self)
  local mailId = {}
  local mailIdAll = {}
  local giveItemAll = {}
  local overfull = {}
  local giveItem = setmetatable({}, {
    __add = function(mytab, newtab)
      for i, v in ipairs(newtab) do
        table.insert(mytab, v)
      end
      return mytab
    end
  })
  local itemIdKeyToNum = {}
  
  local function toMaxAmount(v)
    local ca, maxAmount
    if v.id then
      ca = (ed.player.equip_qunty[v.id] or 0) + (itemIdKeyToNum[v.id] or 0)
      maxAmount = ed.player:getItemMaxAmount(v.id)
    else
      ca = ed.player:getPoint(v.type)
      maxAmount = ed.player:getItemMaxAmount(nil, v.type)
    end
    if v.type and (v.type == "hero" or v.type == "medal") then
      maxAmount = ca + v.amount + 1
    end
    local da = ca + v.amount - maxAmount
    return 0 < da
  end
  
  for i, v in ipairs(self.mails) do
    local data = v.data or {}
    if data.status and data.status == "unread" and data.attach and #data.attach > 0 then
      local isForce = false
      local newTab = {}
      for m, s in ipairs(data.attach) do
        local toMax = toMaxAmount(s)
        if toMax then
          local isHave = false
          for k, v in ipairs(overfull) do
            local type = s.kind or s.type
            if v.id == s.id and v.type == type then
              isHave = true
              v.amount = v.amount + s.amount
            end
          end
          if not isHave then
            table.insert(overfull, {
              id = s.id,
              amount = s.amount,
              kind = s.kind,
              type = s.kind or s.type
            })
          end
        else
          itemIdKeyToNum[s.id or s.kind or s.type] = (itemIdKeyToNum[s.id or s.kind or s.type] or 0) + s.amount
        end
        table.insert(giveItemAll, {
          id = s.id,
          amount = s.amount,
          kind = s.kind,
          type = s.kind or s.type,
          toMax = toMax
        })
        table.insert(newTab, {
          id = s.id,
          amount = s.amount,
          kind = s.kind,
          type = s.kind or s.type
        })
        isForce = isForce or toMax
      end
      if not isForce then
        table.insert(mailId, data.id)
        giveItem = giveItem + newTab
      end
      table.insert(mailIdAll, data.id)
    end
  end
  
  local function doRead(isDele)
    local ids = isDele and mailIdAll or mailId
    ed.registerNetReply("readMail", function(data)
      xpcall(function()
        local function pop()
          if data._mail_acc then
            for i = 1, #data._mail_acc do
              local v = data._mail_acc[i]
              
              if v._type == "hero" then
                local id = v._id
                ed.ui.SummonRewardCardWindow.create({
                  rewards = {
                    {
                      id = id,
                      amount = 1,
                      type = "hero"
                    }
                  },
                  noRewards = true
                }):popWindow()
              elseif v._type == "magic_soul" then
                local id = v._id
                local amount = v._amount
                local hid = ed.readhero.getMakeid(id)
                ed.ui.SummonRewardCardWindow.create({
                  rewards = {
                    {
                      id = hid,
                      amount = amount,
                      type = "hero"
                    }
                  },
                  convertIdxs = {true},
                  noRewards = true
                }):popWindow()
                ed.player:addRewards({
                  {
                    _type = "item",
                    _id = id,
                    _amount = amount
                  }
                })
              end
            end
          end
          local reads = 0
          local newItemtab = isDele and giveItemAll or giveItem
          for k, v in pairs(self.mails) do
            local data = v.data or {}
            for i, s in ipairs(ids) do
              if s == data.id then
                data.status = "read"
                v.ltemBj_1:setVisible(data.status == "unread")
                v.name:setColor(ccc3(ed.colorToStr(data.status == "unread" and "#63493F" or "#68635c")))
                v.from:setColor(ccc3(ed.colorToStr(data.status == "unread" and "#7B5C31" or "#68635c")))
                v.ImageView_2:setVisible(data.status ~= "unread")
                v.ImageView_1:setVisible(data.status == "unread")
                v.Label2_tag1:setString(T("\229\183\178\n\233\162\134"))
                if s == self.newOpenId then
                  for n, m in pairs(self.itemAttach) do
                    m.labDj:setVisible(true)
                  end
                  self.ui.getItemBut:setVisible(false)
                  self.ui.deleOneBtn:setVisible(true)
                end
                reads = reads + 1
                break
              end
            end
          end
          local newTab = {}
          for i, v in ipairs(newItemtab or {}) do
            if (v.kind or v.type) ~= "hero" then
              table.insert(newTab, v)
            end
          end
          if 0 < #newTab then
            local panel = ed.ui.maillocalbox.create({type = "addItem", item = newTab})
            panel:popWindow()
          end
          self.unreads = self.unreads - reads
        end
        
        if data._result == "success" then
          pop()
        end
      end, EDDebug)
    end, ids)
    if 0 < #ids then
      local msg = ed.upmsg.read_mail()
      msg._ids = ids
      ed.send(msg, "read_mail")
    else
      local panel = ed.ui.maillocalbox.create({
        type = "WerrWin",
        str = T("\230\154\130\230\151\160\229\143\175\233\162\134\229\143\150\231\154\132\229\165\150\229\138\177\229\134\133\229\174\185")
      })
      panel:popWindow()
    end
  end
  
  if #overfull == 0 then
    doRead()
  else
    local panel = ed.ui.maillocalbox.create({
      type = "deleItem",
      tag = 2,
      item = overfull,
      clickGeft = function()
        xpcall(function()
          doRead(true)
        end, EDDebug)
      end,
      clickBack = function()
        xpcall(function()
          doRead()
        end, EDDebug)
      end
    })
    panel:popWindow()
  end
end

class.doReadMailAuto = doReadMailAuto

local function screenAdjustment(self, data)
  local ui = self.ui
  ui.mail_butDelestr2:setVisible(false)
  ui.mail_butAutostr2:setVisible(false)
  ui.getItemButStr_bj:setVisible(false)
  ui.mail_butDelestr1:setShadow(ccc3(71, 48, 29), ccp(0, 3))
  ui.mail_butAutostr1:setShadow(ccc3(71, 48, 29), ccp(0, 3))
  ui.getItemButStr:setShadow(ccc3(71, 48, 29), ccp(0, 3))
  local deleBtn = ed.createScale9Sprite("UI/alpha/1080P/common/button_a_butt.png", CCRectMake(20, 9.5, 40, 30))
  deleBtn:setContentSize(CCSizeMake(190, 53.5))
  ui.boyLays:addChild(deleBtn, -1)
  local label = ed.createttf(T("\229\136\160\233\153\164\233\130\174\228\187\182"), 27.5)
  label:setPosition(ccp(95, 26))
  label:setColor(ccc3(251, 240, 165))
  label:setShadow(ccc3(71, 48, 29), ccp(0, 3))
  deleBtn:addChild(label)
  ui.deleOneBtn = deleBtn
  ui.mail_numMax:setStroke(ccc3(0, 0, 0), 1)
  ui.Label_titleStr:setStroke(ccc3(0, 0, 0), 1)
  self.ui.ImageView_823232_Copy0:setScale(0.5)
  self.ui.ImageView_8463_Copy0:setScaleX(-0.5)
  self.ui.ImageView_8463_Copy0:setScaleY(0.5)
  self.ui.ImageView_8432_Copy0:setScale(0.5)
  local ui = self.ui
  local fixWid = ed.display.halfFixedWidth * 2 / 1.5
  local fixHei = ed.display.halfFixedHeight * 2
  local thisCon = ui.ImageView_8432_Copy0:getContentSize()
  ui.ImageView_8463_Copy0:setContentSize(CCSizeMake(thisCon.width + fixWid / 2, thisCon.height))
  ui.ImageView_8432_Copy0:setContentSize(CCSizeMake(thisCon.width + fixWid / 2, thisCon.height))
  local thisCon = ui.mail9Bj_1:getContentSize()
  ui.mail9Bj_1:setContentSize(CCSizeMake(thisCon.width + fixWid, thisCon.height + fixHei))
  thisCon = ui.mail9Bj_2:getContentSize()
  ui.mail9Bj_2:setContentSize(CCSizeMake(thisCon.width + fixWid, thisCon.height + fixHei))
  local posx, posy = ui.mail_offBut:getPosition()
  ui.mail_offBut:setPosition(posx + fixWid / 2, posy + fixHei / 2)
  posx, posy = ui.Panel_left:getPosition()
  ui.Panel_left:setPosition(posx - fixWid / 2, posy - fixHei / 2)
  thisCon = ui.Panel_left:getContentSize()
  ui.Panel_left:setContentSize(CCSizeMake(thisCon.width + fixWid / 2, thisCon.height + fixHei))
  thisCon = ui.ImageView_183:getContentSize()
  ui.ImageView_183:setContentSize(CCSizeMake(thisCon.width + fixWid / 2, thisCon.height))
  posx, posy = ui.ImageView_183:getPosition()
  ui.ImageView_183:setPosition(posx + fixWid / 2 / 2, posy + fixHei)
  posx, posy = ui.mail_numMax:getPosition()
  ui.mail_numMax:setPosition(posx + fixWid / 2, posy + fixHei)
  posx, posy = ui.mail_imgTag:getPosition()
  ui.mail_imgTag:setPosition(posx, posy + fixHei)
  thisCon = ui.mail_lin:getContentSize()
  ui.mail_lin:setContentSize(CCSizeMake(thisCon.width, thisCon.height + fixHei))
  thisCon = ui.mail_listPos:getContentSize()
  ui.mail_listPos:setContentSize(CCSizeMake(thisCon.width + fixWid / 2, thisCon.height + fixHei))
  thisCon = ui.mail_listPos:getContentSize()
  ui.mail_butDele:setPositionX(40 + thisCon.width / 6)
  ui.mail_butAuto:setPositionX(thisCon.width - (30 + thisCon.width / 6))
  thisCon = ui.Panel_right:getContentSize()
  ui.Panel_right:setContentSize(CCSizeMake(thisCon.width + fixWid / 2, thisCon.height + fixHei))
  posx, posy = ui.Panel_right:getPosition()
  ui.Panel_right:setPosition(posx, posy - fixHei / 2)
  thisCon = ui.Panel_right:getContentSize()
  ui.mail_titles:setPosition(thisCon.width / 2, thisCon.height - 27)
  ui.Label_nameLeft:setPositionY(ui.Label_nameLeft:getPositionY() + fixHei)
  ui.Label_timeLeft:setPositionY(ui.Label_timeLeft:getPositionY() + fixHei)
  ui.ImageView_48:setPositionY(ui.ImageView_48:getPositionY() + fixHei)
  ui.Label_time:setPositionY(ui.Label_time:getPositionY() + fixHei)
  ui.Label_name:setPositionY(ui.Label_name:getPositionY() + fixHei)
  ui.mail_rig_lin:setPosition(thisCon.width / 2, 162)
  ui.getItemBut:setPositionX(thisCon.width - 150)
  deleBtn:setPosition(ui.getItemBut:getPosition())
  thisCon = ui.boyLays:getContentSize()
  ui.boyLays:setContentSize(CCSizeMake(thisCon.width + fixWid / 2, thisCon.height + fixHei))
  thisCon = ui.bodyPosItem:getContentSize()
  self.px = 30 / thisCon.width * (fixWid / 2)
  print("self.px == ", self.px)
  ui.bodyPosItem:setContentSize(CCSizeMake(thisCon.width + fixWid / 2, thisCon.height + fixHei))
  thisCon = ui.bodyPos:getContentSize()
  ui.bodyPos:setContentSize(CCSizeMake(thisCon.width + fixWid / 2, thisCon.height + fixHei))
  thisCon = ui.Panel_itemPos:getContentSize()
  ui.Panel_itemPos:setContentSize(CCSizeMake(thisCon.width + fixWid / 2, thisCon.height))
  posx, posy = ui.ImageView_278:getPosition()
  ui.ImageView_278:setPosition(posx + fixWid / 3, posy)
end

class.screenAdjustment = screenAdjustment

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
  end
  
  return handler
end

class.doPressIn = doPressIn

local function doClickIn(self)
  local function handler(x, y, v)
    if not v then
      return
    end
    if v.type == "hero" then
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

local function createAttachDetail(self, icon, id, kind)
  local x, y = icon:getPosition()
  y = y + 30
  local pos = icon:getParent():convertToWorldSpace(ccp(x, y))
  local did = id
  if (not id or id == 0) and ed.resToIconId[string.lower(kind)] then
    did = ed.resToIconId[string.lower(kind)]
  end
  local panel = ed.readequip.getDetailCard(did, {ps = ""}, {
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
    if self.scaledIcon then
      self.scaledIcon:setScale(self.oriItemScale)
      
      self.scaledIcon = nil
    end
    if self.attachDetailPanel then
      self.attachDetailPanel:removeFromParentAndCleanup(true)
      self.attachDetailPanel = nil
    end
  end
  
  return handler
end

class.cancelPressInBreak = cancelPressInBreak

local function orderMailData(self, data)
  local list = {}
  local mailList = {}
  data = data or {}
  for i = 1, #data do
    list[i] = self:formatMailData(data[i])
  end
  for i = 1, #list do
    if list[i] == "expire" then
      table.remove(data, i)
    else
      table.insert(mailList, list[i])
    end
  end
  table.sort(mailList, function(a, b)
    local prio1 = a.status == "read" and 1 or 2
    local prio2 = b.status == "read" and 1 or 2
    if prio1 == prio2 then
      return a.mailTime > b.mailTime
    else
      return prio1 > prio2
    end
  end)
  return mailList
end

class.orderMailData = orderMailData

local function isTeamWar(mid)
  local row = ed.getDataTable("Maillist")[mid]
  if row and row["Normal Icon"] then
    return row
  end
end

local function formatMailData(self, data)
  if data._expire_time < ed.getServerTime() then
    return "expire"
  end
  local id = data._id
  local status = data._status
  local unread = status == "unread" or status == 0
  status = unread and "unread" or "read"
  local mailTime = data._mail_time
  local date = data._mail_time
  date = ed.getYMDTime(ed.time2China(date))
  local nTime = ed.getServerTime()
  nTime = (data._expire_time or 0) - nTime
  local timeRed
  
  local function ntFun()
    timeRed = ccc3(ed.colorToStr("#792203"))
    if 86400 < nTime then
      local day = math.floor(nTime / 86400)
      if 3 < day then
        timeRed = nil
      end
      return day .. T("\229\164\169\229\144\142\232\191\135\230\156\159")
    elseif 3600 < nTime then
      return math.floor(nTime / 3600) .. T("\229\176\143\230\151\182\229\144\142\232\191\135\230\156\159")
    elseif 60 < nTime then
      return math.floor(nTime / 60) .. T("\229\136\134\233\146\159\229\144\142\232\191\135\230\156\159")
    else
      return T("1\229\136\134\233\146\159\229\134\133\232\191\135\230\156\159")
    end
  end
  
  nTime = nTime <= 0 and T("\229\183\178\232\191\135\230\156\159") or ntFun()
  local readTime = status == "read" and ccc3(ed.colorToStr("#4a453e")) or "nil"
  local from, name
  local content = data._content
  local mailType = data._type
  local newAttach = {}
  if 0 < (data._money or 0) then
    table.insert(newAttach, {
      type = "gold",
      amount = data._money
    })
  end
  if 0 < (data._diamonds or 0) then
    table.insert(newAttach, {
      type = "diamond",
      amount = data._diamonds
    })
  end
  for k, v in ipairs(data._items or {}) do
    table.insert(newAttach, {
      type = "item",
      amount = v._amount,
      id = v._id
    })
  end
  for k, v in ipairs(data._points or {}) do
    local tmpType = v._type
    if tmpType == "peak_arena_point" then
      tmpType = "peakarenapoint"
    elseif tmpType == "guild_mount_point" then
      tmpType = "guildmountpoint"
    end
    table.insert(newAttach, {
      type = tmpType,
      amount = v._value
    })
  end
  local monthcards, heroes, medal = {}, {}, {}
  for k, v in ipairs(data._mail_acc or {}) do
    if v._type == "selfmonthcard" then
      table.insert(monthcards, {
        id = v._id,
        amount = v._amount
      })
    elseif v._type == "hero" then
      table.insert(heroes, {
        id = v._id,
        amount = v._amount
      })
    elseif v._type == "medal" then
      table.insert(newAttach, {
        type = v._type,
        id = v._id,
        amount = 1
      })
    end
  end
  local attached
  if 0 < #newAttach + #monthcards + #heroes + #medal then
    attached = true
  end
  local iconbg = "UI/alpha/1080P/common/task_icon_bg.png"
  local iconres
  if mailType == 2 then
    iconres = "UI/alpha/1080P/mail/mailbox_maillist_letter_announce_icon.png"
    if status == "read" then
      iconres = "UI/alpha/1080P/mail/mailbox_maillist_letter_open_announce_icon.png"
    end
  else
    iconres = "UI/alpha/1080P/mail/mailbox_maillist_letter_icon.png"
    if status == "read" then
      iconres = "UI/alpha/1080P/mail/mailbox_maillist_letter_open_icon.png"
    end
  end
  local iconid
  if newAttach[1] then
    iconid = newAttach[1]
  end
  local mid
  if content._plain_mail then
    local pm = content._plain_mail
    from = ed.formatMultiLanMail(pm._from)
    name = ed.formatMultiLanMail(pm._title)
    content = ed.formatMultiLanMail(pm._content)
  elseif content._format_mail then
    local fm = content._format_mail
    local param = fm._params
    mid = fm._mail_cfg_id
    name, from = ed.mailutil.getMailText(mid, param)
    content = {
      t = "format_mail",
      mid = mid,
      param = param
    }
    local row = isTeamWar(mid)
    if row then
      iconres = row["Normal Icon"]
      if status == "read" then
        iconres = row["Open Icon"]
      end
    end
  end
  for i, v in ipairs(heroes) do
    v.type = "hero"
    table.insert(newAttach, v)
  end
  newAttach = ed.mailItemTidy(newAttach)
  return {
    id = id,
    attached = attached,
    status = status,
    date = date,
    nTime = nTime,
    timeRed = timeRed,
    readTime = readTime,
    from = from,
    name = name,
    content = content,
    medal = medal,
    monthcards = monthcards,
    iconres = iconres,
    iconid = iconid,
    iconbg = iconbg,
    mid = mid,
    attach = newAttach,
    mailTime = mailTime,
    mailType = mailType,
    url = data._url
  }
end

class.formatMailData = formatMailData

local function doReadMailRet(self, index)
  local m = self.mails[index]
  local data = m.data
  return {
    id = data.id,
    status = data.status,
    attached = data.attached,
    url = data.url,
    type = data.mailType or 0,
    content = {
      mid = data.mid,
      title = data.name,
      body = data.content,
      from = data.from,
      attach = data.attach,
      time = data.date
    }
  }
end

class.doReadMailRet = doReadMailRet

local function retAutoStrBoy(self, labels)
  self.urlTab = {}
  local concatTable = {}
  for _, label in ipairs(labels) do
    if label.type == "br" then
      local str = "<br/>"
      table.insert(concatTable, str)
    elseif label.type == "Link" then
      local strTable = {}
      self.urlTab[label.urlInd] = label.url
      strTable[1] = string.format("<lable clickhandler=%s data=%d color=", "mailLinkHandler", label.urlInd)
      strTable[2] = label.color
      strTable[3] = " fontSize="
      strTable[4] = label.size
      if label.strokeSize then
        strTable[5] = " strokeSize="
        strTable[6] = label.strokeSize
        strTable[7] = " strokeColor="
        strTable[8] = label.color
      end
      table.insert(strTable, ">")
      table.insert(strTable, label.text)
      table.insert(strTable, "</lable>")
      local strContent = table.concat(strTable)
      table.insert(concatTable, strContent)
    else
      local strTable = {}
      strTable[1] = "<lable color="
      strTable[2] = label.color
      strTable[3] = " fontSize="
      strTable[4] = label.size
      if label.strokeSize then
        strTable[5] = " strokeSize="
        strTable[6] = label.strokeSize
      end
      table.insert(strTable, ">")
      table.insert(strTable, label.text)
      table.insert(strTable, "</lable>")
      local strContent = table.concat(strTable)
      table.insert(concatTable, strContent)
    end
  end
  local autoStr = table.concat(concatTable)
  return autoStr or ""
end

class.retAutoStrBoy = retAutoStrBoy

local function orderMail(self)
  local ml = self.mails
  
  local function moveup(j)
    local i = j - 1
    local temp = ml[j]
    ml[j] = ml[i]
    ml[i] = temp
  end
  
  for i = 1, #ml do
    for j = i, 2, -1 do
      if ml[j - 1] and ml[j] then
        local pre = ml[j - 1].data
        local c = ml[j].data
        if c.status == "unread" and pre.status ~= "unread" then
          moveup(j)
        elseif c.status == pre.status and c.date > pre.date then
          moveup(j)
        end
      end
    end
  end
end

class.orderMail = orderMail

local function getMailsIdToIndex(self, id)
  for i, v in ipairs(self.mails) do
    if id == v.data.id then
      return i
    end
  end
  return 0
end

class.getMailsIdToIndex = getMailsIdToIndex
