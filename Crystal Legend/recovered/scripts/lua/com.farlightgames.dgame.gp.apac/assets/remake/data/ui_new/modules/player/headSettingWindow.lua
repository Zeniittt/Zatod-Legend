local base = ed.ui.popwindow
local headSettingWindow = newclass(base.mt)
ed.ui.headSettingWindow = headSettingWindow
local mapCfg = ed.ui.configs.mainSceneMap
local BuilddingType = mapCfg.builddingType

function headSettingWindow.create()
  local self = base.create("headSettingWindow")
  setmetatable(self, headSettingWindow.mt)
  headSettingWindow.eventScope = {}
  EDLoadShader("GrayScalingShader_2")
  self:init()
  return self
end

function headSettingWindow:init()
  self.tabData = {}
  self.isHad = {btn_head = true, btn_head_frame = true}
  self.subTag = "All"
  self.avatar = ed.player:getAvatarId()
  self.frame = ed.player:getAvatarFrame()
  self.avatarPass = nil
  self.framePass = nil
  self:initView()
  self:addEventListener()
end

function headSettingWindow:initView()
  local container, ui = ed.editorui(ed.uieditor.headSetting)
  self.ui = ui
  self.container:addChild(container)
  self.srcSize = self.ui.layer_item:getContentSize()
  ed.setLabelStroke(self.ui.label_All, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_Normal, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_Special, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_Skin, ed.toccc3(2565412), 1)
  ed.adaptLabel(self.ui.label_head, {maxWidth = 107, minScale = 0.8})
  ed.adaptLabel(self.ui.label_head_frame, {maxWidth = 90, minScale = 0.8})
  ed.adaptLabel(self.ui.label_medal, {maxWidth = 107, minScale = 0.8})
  ed.adaptLabel(self.ui.label_Normal, {maxWidth = 45, minScale = 0.6})
  ed.adaptLabel(self.ui.label_Special, {maxWidth = 45, minScale = 0.6})
  self:initTab()
  self.refreshCliprectConfig = {
    draglist = self.headListView.dragList
  }
  local msg = ed.upmsg.medal_req()
  msg._open_panel = ed.upmsg.medal_open_panel()
  ed.send(msg, "medal")
  self:listenEvent("medal_reply", function(info)
    if info._set_medal and info._set_medal._result == "success" then
      ed.showToast(T("\229\190\189\231\171\160\232\174\190\231\189\174\230\136\144\229\138\159\239\188\129"))
    end
  end)
  self.ui.btn_change_label:setPositionY(self.ui.btn_change_label:getPositionY() + 2)
  self:show()
end

function headSettingWindow:updateHeadView()
  local icon, frame, avtrFca, avtrSpine
  local data = self.curData
  if self.curData then
    if self.curTab == "btn_head" then
      icon = self.curData.res
      avtrFca = self.curData.fca
      avtrSpine = self.curData.spine
    elseif self.curTab == "btn_head_frame" then
      frame = self.curData.res
      self.frameId = self.curData.key
      frameFca = self.curData.fca
      frameSpine = self.curData.spine
    end
  else
    if self.curTab == "btn_head" then
      data = ed.getDataTable("Avatar")[ed.player:getAvatarId()]
    elseif self.curTab == "btn_head_frame" then
      data = ed.getDataTable("AvatarFrame")[ed.player:getAvatarFrame()]
    end
    data = {
      key = data["Avatar ID"] or data.ID,
      name = data.Name,
      desc = data.Description or data["Unlock Description"]
    }
  end
  if not self.ui.headicon then
    local head, headicon, headfca = ed.getHeadIcon()
    self.ui.head = head
    self.ui.headicon = headicon
    self.headfca = headfca
    self.ui.head_panel:addChild(head)
    local frame, frameicon, framefca = ed.getHeadFrame({hide_icon_when_dyna = true})
    self.ui.headframe = frame
    self.ui.frameicon = frameicon
    self.framefca = framefca
    self.ui.head_panel:addChild(frame)
    self.ui.desc_text:setDimensions(CCSizeMake(130, 200))
  else
    if icon then
      ed.setTexture(self.ui.headicon, icon)
    end
    if frame then
      ed.setTexture(self.ui.frameicon, frame)
      self.ui.frameicon:setVisible(true)
    end
    if self.curTab == "btn_head" then
      if self.headfca then
        self:removeFca(self.headfca)
        self.headfca:removeFromParentAndCleanup(true)
        self.headfca = nil
      end
      if avtrSpine then
        local spine = ed.createSpineEffect(avtrSpine)
        spine:setAnimation(0, "Idle", true)
        self.ui.head:addChild(spine)
        self.headfca = spine
        spine:setScale(self.curData.scale or 1)
      elseif avtrFca then
        local fca = ed.createFcaNode(avtrFca)
        self:addFca(fca)
        self.ui.head:addChild(fca)
        self.headfca = fca
        fca:setScale(self.curData.scale or 1)
      end
    elseif self.curTab == "btn_head_frame" then
      if self.framefca then
        self:removeFca(self.framefca)
        self.framefca:removeFromParentAndCleanup(true)
        self.framefca = nil
      end
      if frameSpine then
        local spine = ed.createSpineEffect(frameSpine)
        spine:setAnimation(0, "Idle", true)
        self.ui.headframe:addChild(spine)
        self.framefca = spine
        spine:setScale(self.curData.scale or 1)
        self.ui.frameicon:setVisible(false)
      elseif framefca then
        local fca = ed.createFcaNode(framefca)
        self:addFca(fca)
        self.ui.headframe:addChild(fca)
        self.framefca = fca
        fca:setScale(self.curData.scale or 1)
      end
    end
  end
  self.ui.name_text:setString(tostring(data.name) or "")
  ed.adaptLabel(self.ui.name_text, {maxWidth = 140})
  self.ui.name_text:setHorizontalAlignment(kCCTextAlignmentCenter)
  self.ui.desc_text:setString(tostring(data.desc) or "")
end

function headSettingWindow:updateContenView()
  local padding = CCSizeMake(32, 45)
  if self.curTab == "btn_head_frame" then
    padding = CCSizeMake(16, 45)
  end
  if self.headListView then
    self.headListView.padding = padding
    self.headListView:reloadData()
    return
  end
  local delegate = {
    numberOfCells = function()
      if self.curTab == "btn_head" then
        return #self.tabData[self.curTab][self.subTag]
      else
        return #self.tabData[self.curTab]
      end
    end,
    cellSizeFromIndex = function(idx)
      if self.curTab == "btn_head" then
        return CCSizeMake(73, 73)
      end
      return CCSizeMake(90, 90)
    end,
    createCell = function(idx)
      local tb
      if self.curTab == "btn_head" then
        tb = self.tabData[self.curTab][self.subTag]
      else
        tb = self.tabData[self.curTab]
      end
      local data = tb[idx]
      local item, selected, selected2 = self:createItem(data)
      return item, {
        data = data,
        selected = selected,
        PassUi = selected2
      }
    end,
    doClickIn = function(cell, x, y)
      if not ed.containsPoint(cell.node, x, y) then
        return
      end
      local tb
      if self.curTab == "btn_head" then
        tb = self.tabData[self.curTab][self.subTag]
      else
        tb = self.tabData[self.curTab]
      end
      local data = tb[cell.idx]
      if self.curData == data then
        return
      end
      self.curData = data
      if data.isHad then
        self.isHadSetdata = cell
      else
        self.isHadSetdata = nil
      end
      if self.curTab == "btn_head" then
        if self.selectAvatarPass and not tolua.isnull(self.selectAvatarPass) then
          self.selectAvatarPass:setVisible(false)
        end
        self.selectAvatarPass = cell.data.PassUi
        self.selectAvatarPass:setVisible(true)
        self.avatarPass = data.key
      elseif self.curTab == "btn_head_frame" then
        if self.selectFramePass and not tolua.isnull(self.selectFramePass) then
          self.selectFramePass:setVisible(false)
        end
        self.selectFramePass = cell.data.PassUi
        self.selectFramePass:setVisible(true)
        self.framePass = data.key
      end
      self.isHad[self.curTab] = data.isHad
      self:updateHeadView()
    end
  }
  local size = self.ui.layer_item:getContentSize()
  local param = {
    delegate = delegate,
    container = self.ui.layer_item,
    cliprect = CCRectMake(0, 5, size.width, size.height - 10),
    dragMode = 1,
    colNum = 4,
    zorder = 999,
    touchpriority = -301,
    noshade = true,
    padding = padding,
    offset = {4, -15}
  }
  self.headListView = Tableview.create(param)
end

local frameBgs = {
  "equip_frame_white.png",
  "equip_frame_green.png",
  "equip_frame_blue.png",
  "equip_frame_purple.png",
  "equip_frame_purple.png",
  "equip_frame_orange.png",
  "equip_frame_red.png",
  "equip_frame_pink.png",
  "equip_frame_prismatic.png"
}

function headSettingWindow:createItem(data)
  if self.curTab == "btn_head" then
    local res = frameBgs[data.rank] or frameBgs[1]
    local frame = ed.createSprite("UI/alpha/1080P/common/frame/" .. res)
    local size = frame:getContentSize()
    local x, y = size.width / 2, size.height / 2
    local icon
    if data.spine and data.isHad then
      local clipLayer = CCLayer:create()
      clipLayer:setClipRect(CCRectMake(10, 10, size.width - 20, size.height - 20))
      icon = ed.createSpineEffect(data.spine)
      icon:setAnimation(0, "Idle", true)
      clipLayer:addChild(icon)
      icon:setPosition(x, y)
      frame:addChild(clipLayer, -1)
      icon:setScale(data.scale or 1)
    elseif data.fca and data.isHad then
      local clipLayer = CCLayer:create()
      clipLayer:setClipRect(CCRectMake(10, 10, size.width - 20, size.height - 20))
      icon = ed.createFcaNode(data.fca)
      self:addFca(icon)
      clipLayer:addChild(icon)
      icon:setPosition(x, y)
      frame:addChild(clipLayer, -1)
      icon:setScale(data.scale or 1)
    elseif data.res then
      icon = ed.createSprite(data.res)
      frame:addChild(icon, -1)
      icon:setPosition(x, y)
    end
    if not data.isHad then
      ed.setSpriteShader(icon, "GrayScalingShader_2")
      ed.setSpriteShader(frame, "GrayScalingShader_2")
      local lock = ed.createSprite("UI/alpha/1080P/skill/skill_lock.png")
      lock:setScale(0.62)
      lock:setPosition(x, y)
      frame:addChild(lock)
    end
    local name = ed.createLabelTTF(data.name, 15)
    ed.setLabelColor(name, ccc3(240, 172, 40))
    name:setPosition(x, -10)
    ed.adaptLabel(name, {
      maxWidth = size.width,
      minScale = 0.6
    })
    frame:addChild(name)
    local tick = ed.createSprite("UI/alpha/1080P/common/common_mark.png")
    tick:setScale(0.7)
    tick:setPosition(ccp(60, 25))
    frame:addChild(tick, 10)
    tick:setVisible(self.avatar == data.key and data.isHad)
    if self.avatar == data.key then
      self.selectAvatarUI = tick
    end
    local selected = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_selected.png")
    selected:setPosition(size.width / 2, size.height / 2)
    frame:addChild(selected)
    selected:setVisible(self.avatarPass and self.avatarPass == data.key)
    if self.avatarPass and self.avatarPass == data.key then
      self.selectAvatarPass = selected
      self.isHadSetdata = {
        node = frame,
        data = {selected = tick}
      }
    end
    return frame, tick, selected
  elseif self.curTab == "btn_head_frame" then
    local iconBg = CCNode:create()
    local icon = ed.createSprite(data.res)
    local size = icon:getContentSize()
    iconBg:setContentSize(size)
    iconBg:addChild(icon)
    iconBg:setScale(0.85)
    local x, y = size.width / 2, size.height / 2
    icon:setPosition(x, y)
    local name = ed.createLabelTTF(data.name, 17)
    ed.setLabelColor(name, ccc3(240, 172, 40))
    name:setPosition(size.width / 2, -10)
    ed.adaptLabel(name, {
      maxWidth = size.width * 0.8,
      minScale = 0.6
    })
    iconBg:addChild(name)
    local fcaIcon
    if data.isHad then
      if data.spine then
        fcaIcon = ed.createSpineEffect(data.spine)
        fcaIcon:setAnimation(0, "Idle", true)
        fcaIcon:setPosition(x, y)
        iconBg:addChild(fcaIcon)
        fcaIcon:setScale(data.scale or 1)
        icon:setVisible(false)
      elseif data.fca then
        fcaIcon = ed.createFcaNode(data.fca)
        self:addFca(fcaIcon)
        fcaIcon:setPosition(x, y)
        iconBg:addChild(fcaIcon)
        fcaIcon:setScale(data.scale or 1)
      end
    else
      ed.setSpriteShader(icon, "GrayScalingShader_2")
      local lock = ed.createSprite("UI/alpha/1080P/skill/skill_lock.png")
      lock:setScale(0.62)
      lock:setPosition(size.width / 2, size.height / 2)
      iconBg:addChild(lock)
    end
    local tick = ed.createSprite("UI/alpha/1080P/common/common_mark.png")
    tick:setScale(0.7)
    tick:setPosition(ccp(60, 25))
    tick:setVisible(self.frame == data.key and data.isHad)
    iconBg:addChild(tick, 10)
    if self.frame == data.key then
      self.selectAvatarUI = tick
    end
    local selected = ed.createSprite("UI/alpha/1080P/common/frame/mainhead_frame_selected.png")
    selected:setPosition(size.width / 2, size.height / 2)
    iconBg:addChild(selected, -9)
    selected:setVisible(false)
    selected:setVisible(self.framePass and self.framePass == data.key)
    if self.framePass and self.framePass == data.key then
      self.selectFramePass = selected
      self.isHadSetdata = {
        node = iconBg,
        data = {selected = tick}
      }
    end
    return iconBg, tick, selected
  end
end

function headSettingWindow:initTab()
  self.ui.btn_head_selected:setVisible(false)
  self.ui.btn_head_frame_selected:setVisible(false)
  self:selectedTab("btn_head", "All")
  self:updateHeadView()
end

function headSettingWindow:setData(tabName, subTag)
  if tabName == "btn_head" then
    self.tabData[tabName] = self.tabData[tabName] or {}
    if self.tabData[tabName][subTag] then
      return self.tabData[tabName][subTag]
    end
  elseif self.tabData[tabName] then
    return self.tabData[tabName]
  end
  self.curData = nil
  local data = {}
  if tabName == "btn_head" then
    local avatars = ed.getDataTable("Avatar")
    for id, avatar in pairs(avatars) do
      if type(id) == "number" then
        local had = ed.ui.headUtil:headIsActived(id)
        if had or not avatar.Hide then
          local item = {
            key = id,
            res = avatar.Picture,
            desc = avatar.Description,
            name = avatar.Name,
            rank = avatar["Display Rank"],
            fca = avatar["Dynamic Model"],
            spine = avatar["Spine Dynamic Model"],
            scale = avatar.Scale > 0 and avatar.Scale or 1,
            type = avatar.Type,
            isHad = had
          }
          if avatar["Requirement Type"] == "HaveItem" and avatar["Requirement ID"] ~= 0 then
            local equipTableItem = ed.getDataTable("equip")[avatar["Requirement ID"]]
            if nil ~= equipTableItem then
              item.rank = equipTableItem.Quality
            end
          end
          if subTag == "All" then
            table.insert(data, item)
          elseif item.type == subTag then
            table.insert(data, item)
          end
        end
      end
    end
  elseif tabName == "btn_head_frame" then
    local avatarframes = ed.getDataTable("AvatarFrame")
    for id, frame in pairs(avatarframes) do
      local had = ed.ui.headUtil:headFrameIsActived(id)
      if not (type(id) ~= "number" or frame.Hide) or had then
        table.insert(data, {
          key = id,
          res = frame.Picture,
          desc = had and frame.Description or frame["Unlock Description"],
          name = frame.Name,
          rank = frame["Display ID"],
          fca = frame["Dynamic Model"],
          spine = frame["Spine Dynamic Model"],
          scale = frame.Scale > 0 and frame.Scale or 1,
          isHad = had
        })
      end
    end
  end
  table.sort(data, function(a, b)
    if a.isHad and b.isHad then
      if a.rank == b.rank then
        return a.key < b.key
      else
        return a.rank < b.rank
      end
    end
    if b.isHad then
      return false
    end
    return a.isHad
  end)
  if tabName == "btn_head" then
    self.tabData[tabName][subTag] = data
  else
    self.tabData[tabName] = data
  end
  return data
end

function headSettingWindow:selectedTab(tabName, subTag)
  if self.headListView then
    self.ui.head_panel:setVisible(true)
    self.ui.name_text:setVisible(true)
    self.ui.desc_text:setVisible(true)
    self.headListView.dragList:setVisible(true)
  end
  if self.medalDraglist then
    self.medalLayer:setVisible(false)
    self.medalDraglist:setVisible(false)
  end
  subTag = subTag or "All"
  if self.curTab == tabName and self.subTag == subTag then
    return
  end
  self.selectFrameUI = nil
  self.selectAvatarUI = nil
  if self.curTab then
    self.ui[self.curTab .. "_selected"]:setVisible(false)
  end
  self.curTab = tabName
  self.subTag = subTag or self.subTag
  self.ui[self.curTab .. "_selected"]:setVisible(true)
  self.ui.head_btn_layer:setVisible(tabName == "btn_head")
  self:setData(tabName, self.subTag)
  self:updateContenView()
  local size = self.srcSize
  if tabName == "btn_head" then
    self.headListView.dragList:initClipRect(CCRectMake(0, 0, size.width, size.height))
  else
    self.headListView.dragList:initClipRect(CCRectMake(0, -50, size.width, size.height + 50))
  end
end

function headSettingWindow:doChange()
  if self.isHad.btn_head and self.isHad.btn_head_frame then
    self.avatar = self.avatarPass or self.avatar
    self.frame = self.framePass or self.frame
    self.replyFun = nil
    
    local function func(id)
      ed.netdata.setAvatar = {id = id}
      local msg = ed.upmsg.set_avatar()
      msg._avatar = id
      ed.send(msg, "set_avatar")
    end
    
    local function reply1()
      local id = ed.packAvatar(ed.player:getAvatarFrame(), self.avatar)
      func(id)
      if self.isHadSetdata then
        local cell = self.isHadSetdata
        if not tolua.isnull(self.selectAvatarUI) then
          self.selectAvatarUI:setVisible(false)
        end
        self.selectAvatarUI = cell.data.selected
        if not tolua.isnull(self.selectAvatarUI) then
          self.selectAvatarUI:setVisible(true)
        end
      end
    end
    
    local function reply2()
      local id = ed.packAvatar(self.frame, ed.player:getAvatarId())
      func(id)
      if self.isHadSetdata then
        local cell = self.isHadSetdata
        if not tolua.isnull(self.selectAvatarUI) then
          self.selectAvatarUI:setVisible(false)
        end
        self.selectAvatarUI = cell.data.selected
        if not tolua.isnull(self.selectAvatarUI) then
          self.selectAvatarUI:setVisible(true)
        end
      end
    end
    
    if self.avatar and self.avatar ~= ed.player:getAvatarId() then
      reply1()
      if self.frame and self.frame ~= ed.player:getAvatarFrame() then
        self.replyFun = reply2
      end
    elseif self.frame and self.frame ~= ed.player:getAvatarFrame() then
      reply2()
      if self.avatar and self.avatar ~= ed.player:getAvatarId() then
        self.replyFun = reply1
      end
    end
  else
    local error = {
      btn_head = T("\228\184\141\232\131\189\232\174\190\231\189\174\229\176\154\230\156\170\230\139\165\230\156\137\231\154\132\229\164\180\229\131\143\230\161\134"),
      btn_head_frame = T("\228\184\141\232\131\189\232\174\190\231\189\174\229\176\154\230\156\170\230\139\165\230\156\137\231\154\132\229\164\180\229\131\143")
    }
    ed.showToast(T(error[self.isHad.btn_head and "btn_head" or "btn_head_frame"]))
    return false
  end
end

function headSettingWindow:addEventListener()
  self:btRegisterButtonClick({
    button = self.ui.btn_head,
    press = self.ui.btn_head_press,
    key = "btn_head",
    clickInterval = 0.3,
    force = true,
    pressScale = 0.9,
    clickHandler = function()
      self.ui.btn_medal_selected:setVisible(false)
      self.ui["btn_" .. self.subTag .. "_selected"]:setVisible(false)
      self:selectedTab("btn_head")
      self.ui["btn_" .. self.subTag .. "_selected"]:setVisible(true)
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_head_frame,
    press = self.ui.btn_head_frame_press,
    key = "btn_head_frame",
    clickInterval = 0.3,
    force = true,
    pressScale = 0.9,
    clickHandler = function()
      self.ui.btn_medal_selected:setVisible(false)
      self.ui["btn_" .. self.subTag .. "_selected"]:setVisible(false)
      self:selectedTab("btn_head_frame")
      self.ui["btn_" .. self.subTag .. "_selected"]:setVisible(true)
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_medal,
    press = self.ui.btn_medal_press,
    key = "btn_medal_frame",
    clickInterval = 0.3,
    force = true,
    pressScale = 0.9,
    clickHandler = function()
      self.curTab = nil
      self.ui["btn_" .. self.subTag .. "_selected"]:setVisible(false)
      self.ui.btn_head_selected:setVisible(false)
      self.ui.btn_head_frame_selected:setVisible(false)
      self.ui.btn_medal_selected:setVisible(true)
      self:refreshMedalPage()
      self.ui.head_btn_layer:setVisible(false)
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_All,
    key = "btn_head_All",
    clickInterval = 0.3,
    force = true,
    clickHandler = function()
      self.ui["btn_" .. self.subTag .. "_selected"]:setVisible(false)
      self:selectedTab("btn_head", "All")
      self.ui["btn_" .. self.subTag .. "_selected"]:setVisible(true)
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_Normal,
    key = "btn_head_Normal",
    clickInterval = 0.3,
    force = true,
    clickHandler = function()
      self.ui["btn_" .. self.subTag .. "_selected"]:setVisible(false)
      self:selectedTab("btn_head", "Normal")
      self.ui["btn_" .. self.subTag .. "_selected"]:setVisible(true)
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_Special,
    key = "btn_head_Special",
    clickInterval = 0.3,
    force = true,
    clickHandler = function()
      self.ui["btn_" .. self.subTag .. "_selected"]:setVisible(false)
      self:selectedTab("btn_head", "Special")
      self.ui["btn_" .. self.subTag .. "_selected"]:setVisible(true)
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_Skin,
    key = "btn_head_Skin",
    clickInterval = 0.3,
    force = true,
    clickHandler = function()
      self.ui["btn_" .. self.subTag .. "_selected"]:setVisible(false)
      self:selectedTab("btn_head", "Skin")
      self.ui["btn_" .. self.subTag .. "_selected"]:setVisible(true)
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_change,
    press = self.ui.btn_change_press,
    key = "btn_change",
    clickInterval = 0.3,
    force = true,
    pressScale = 0.9,
    clickHandler = function()
      if self.isHad.btn_head and self.isHad.btn_head_frame then
        if self:canSetMedal() then
          self:setMedal()
          self:doChange()
        end
      else
        local error = {
          btn_head = T("\228\184\141\232\131\189\232\174\190\231\189\174\229\176\154\230\156\170\230\139\165\230\156\137\231\154\132\229\164\180\229\131\143\230\161\134"),
          btn_head_frame = T("\228\184\141\232\131\189\232\174\190\231\189\174\229\176\154\230\156\170\230\139\165\230\156\137\231\154\132\229\164\180\229\131\143")
        }
        ed.showToast(T(error[self.isHad.btn_head and "btn_head" or "btn_head_frame"]))
      end
    end
  })
  local pressInwin = false
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event == "began" then
        pressInwin = ed.containsPoint(self.ui.bg, x, y) or ed.containsPoint(self.ui.tab_bg, x, y)
      elseif event == "ended" and not pressInwin then
        if not ed.containsPoint(self.ui.bg, x, y) and not ed.containsPoint(self.ui.tab_bg, x, y) then
          self:destroy()
          return
        end
        pressInwin = nil
      end
      return false
    end,
    key = "headSettingWindow",
    priority = -100
  })
  self:listenEvent("setAvatarFrame", function(result)
    if not result then
    else
      if self.replyFun then
        self.replyFun()
        self.replyFun = nil
      else
      end
    end
  end)
end

function headSettingWindow:switchMenu(key, open)
  self.ui["close_" .. key .. "_bg"]:setVisible(open)
  self.ui["btn_" .. key]:setPositionX(open and 13 or 34.5)
end

function headSettingWindow:canSetMedal()
  if self.newMedalItem then
    local item = self.newMedalItem
    if item.param.expire_time and item.param.expire_time < ed.getServerTime() then
      item.param.isHave = false
      return false, ed.showToast(T("\229\190\189\231\171\160\229\183\178\232\191\135\230\156\159\239\188\129"))
    end
    if not item.param.isHave then
      return false, ed.showToast(T("\228\184\141\232\131\189\232\174\190\231\189\174\229\176\154\230\156\170\230\139\165\230\156\137\231\154\132\229\190\189\231\171\160\239\188\129"))
    end
  end
  return true
end

function headSettingWindow:setMedal()
  if self.newMedalItem then
    local item = self.newMedalItem
    if self:canSetMedal() then
      if ed.ui.headSettingWindow.setMedalId ~= item.param.MedalID then
        ed.ui.headSettingWindow.setMedalId = item.param.MedalID
        local msg = ed.upmsg.medal_req()
        msg._set_medal = ed.upmsg.medal_set()
        msg._set_medal._medal_id = item.param.MedalID
        ed.send(msg, "medal")
      else
        ed.showToast(T("\229\164\180\229\131\143\232\174\190\231\189\174\230\136\144\229\138\159\239\188\129"))
      end
    end
  elseif self.medalLayer and self.newitemtick ~= nil then
    self.newitemtick = nil
    local roleMedal = ed.player:getMedal()
    local wearId = roleMedal.wearId or roleMedal.wearInfo and (roleMedal.wearInfo._medal_id or 0) or 0
    if wearId and wearId ~= 0 then
      self.newitemtick = nil
      ed.ui.headSettingWindow.setMedalId = nil
      local msg = ed.upmsg.medal_req()
      msg._set_medal = ed.upmsg.medal_set()
      ed.send(msg, "medal")
    else
      ed.showToast(T("\229\164\180\229\131\143\232\174\190\231\189\174\230\136\144\229\138\159\239\188\129"))
    end
  else
    ed.showToast(T("\229\164\180\229\131\143\232\174\190\231\189\174\230\136\144\229\138\159\239\188\129"))
  end
  if not tolua.isnull(self.curMedalUI) then
    self.curMedalUI:setVisible(false)
  end
  self.curMedalUI = self.newitemtick
  if self.curMedalUI and not tolua.isnull(self.curMedalUI) then
    self.curMedalUI:setVisible(true)
  end
end

local function csLocalfunc(res, pos, scale, parent)
  local sprite = ed.createSprite(res)
  sprite:setPosition(pos)
  sprite:setScale(scale or 1)
  if parent then
    parent:addChild(sprite)
  end
  return sprite
end

local moduleItem = {}

function moduleItem.new(pgSelf, param)
  return setmetatable({sceneSelf = pgSelf, param = param}, {__index = moduleItem}):create()
end

function moduleItem:create()
  self.bj = csLocalfunc("UI/alpha/1080P/medal/medal_bg_2.png", ccp(0, 0), 1)
  self.selected = csLocalfunc("UI/alpha/1080P/common/frame/medal_frame_selected.png", ccp(40, 39), 1, self.bj)
  self.selected:setVisible(false)
  self.icon = csLocalfunc(self.param.Picture, ccp(40, 43), 0.5, self.bj)
  local size = self.icon:getContentSize()
  if not self.param.isHave or self.param.expire_time and self.param.expire_time < ed.getServerTime() then
    ed.setSpriteShader(self.icon, "GrayScalingShader_2")
    local lockImg = csLocalfunc("UI/alpha/1080P/skill/skill_lock.png", ccp(size.width / 2 - 2, size.height / 2 - 2), 1, self.icon)
    ed.setSpriteShader(lockImg, "GrayScalingShader_2")
  end
  if self.param.LifeTimeDay and 0 < self.param.LifeTimeDay then
    local timeImg = csLocalfunc("UI/alpha/1080P/medal/medal_time_limit.png", ccp(size.width - 35, size.height - 30), 2, self.icon)
    if not self.param.isHave or self.param.expire_time and self.param.expire_time < ed.getServerTime() then
      ed.setSpriteShader(timeImg, "GrayScalingShader_2")
    end
  end
  local label = ed.createttf(self.param.Name or "nil", 16)
  label:setPosition(ccp(40, -15))
  label:setColor(ccc3(232, 169, 7))
  ed.adaptLabel(label, {
    maxWidth = self.bj:getContentSize().width,
    minScale = 0.5
  })
  local tick = ed.createSprite("UI/alpha/1080P/common/common_mark.png")
  tick:setScale(0.7)
  tick:setPosition(ccp(60, 25))
  tick:setVisible(false)
  self.tick = tick
  self.bj:addChild(tick, 10)
  self.bj:addChild(label)
  return self
end

function moduleItem:refresh(param)
end

function headSettingWindow:refreshMedalPage()
  self.ui.head_panel:setVisible(false)
  self.ui.name_text:setVisible(false)
  self.ui.desc_text:setVisible(false)
  self.headListView.dragList:setVisible(false)
  if self.medalDraglist then
    self.medalDraglist:setVisible(true)
    self.medalLayer:setVisible(true)
  else
    local thisCon = self.ui.layer_item:getContentSize()
    thisCon.height = thisCon.height + 56
    local info = {
      cliprect = CCRectMake(0, -56, thisCon.width, thisCon.height),
      container = self.ui.layer_item,
      noshade = true,
      zorder = 10,
      priority = -300,
      doPressIn = function(_, y)
        return y
      end,
      cancelPressIn = function(_, y, oldy)
        self.touch = math.abs(oldy - y) < 50
      end
    }
    self.medalDraglist = ed.draglist.create(info)
    self.refreshCliprectConfig = {
      draglist = self.medalDraglist
    }
    self.allItems = {}
    local size, num = 102, 0
    local posX, poxY = size / 2, thisCon.height - size / 2 - 56
    local roleMedal = ed.player:getMedal()
    local wearId = roleMedal.wearId or roleMedal.wearInfo and (roleMedal.wearInfo._medal_id or 0) or 0
    for i, v in ipairs(self:getPlayerMedalInfo()) do
      local item = moduleItem.new(self, v)
      if v.MedalID == wearId then
        self.curMedalUI = item.tick
        self.curMedalUI:setVisible(true)
        self.medalSelected = item.selected
        self.medalSelected:setVisible(true)
        self.newitemtick = item.tick
      end
      self.medalDraglist:addItem(item.bj, ccp(posX, poxY))
      self.allItems[i] = item
      if i % 4 == 0 then
        posX, poxY = size / 2, poxY - (size + 16)
      else
        posX = posX + size
      end
      if i % 4 == 1 then
        num = num + 1
      end
      self:btRegisterButtonClick({
        button = item.icon,
        key = "medal_icon_" .. i,
        clickInterval = 0.3,
        force = true,
        pressScale = 0.47,
        normalScale = 0.5,
        clickHandler = function()
          if self.touch then
            self.newitemtick = item.tick
            if not tolua.isnull(self.medalSelected) then
              self.medalSelected:setVisible(false)
            end
            self.medalSelected = item.selected
            self.medalSelected:setVisible(true)
            self:refreshMedalLeftLay(item)
          end
        end
      })
    end
    self.medalDraglist:initListHeight(num * (size + 16))
    self:createMedalLeftLay()
  end
end

function headSettingWindow:refreshMedalLeftLay(item)
  if not item or item and item.param.isHave and self.newMedalItem and self.newMedalItem.param.MedalID == item.param.MedalID then
    self.newMedalItem = nil
    self.medalIcon:setVisible(false)
    self.medalNameLabel:setString(item and item.param.isHave and T("\230\156\170\228\189\169\230\136\180") or "")
    self.medalDescText:setString("")
    self.medalTimeLabel:setString("")
    if not tolua.isnull(self.medalSelected) then
      self.medalSelected:setVisible(false)
    end
    return
  elseif item and not item.param.isHave and self.newMedalItem and self.newMedalItem.param.MedalID == item.param.MedalID then
    if not tolua.isnull(self.medalSelected) then
      self.medalSelected:setVisible(false)
    end
    self.newMedalItem = nil
    return
  end
  self.medalIcon:setVisible(true)
  ed.setTexture(self.medalIcon, item.param.Picture)
  self.medalNameLabel:setString(item.param.Name)
  ed.adaptLabel(self.medalNameLabel, {maxWidth = 105, minScale = 0.7})
  local descText = item.param.isHave and item.param.Description or item.param["Unlock Description"]
  self.medalDescText:setString(descText or "")
  ed.adaptLabel(self.medalDescText, {
    maxWidth = 140,
    maxHeight = 40,
    minScale = 0.8
  })
  if item.param.LifeTimeDay and item.param.LifeTimeDay > 0 then
    self.medalTimeLabel:setVisible(true)
    if item.param.expire_time and item.param.expire_time > ed.getServerTime() and item.param.isHave then
      self.medalTimeLabel:setString(T("\230\156\137\230\149\136\230\156\159\232\135\179:%s", ed.getYMDHMSTime(ed.time2Server(item.param.expire_time), "goback")) .. ed.getUTCLabel())
      ed.adaptLabel(self.medalTimeLabel, {maxWidth = 150, minScale = 0.7})
    else
      self.medalTimeLabel:setString("")
    end
  else
    self.medalTimeLabel:setVisible(false)
  end
  if item.param.isProgress and item.param.progress and not item.param.isHave then
    self.progressBg:setVisible(true)
    self.progressMode:setPro(0)
    if 0 < item.param.progress then
      self.progressMode:addPro(item.param.progress / item.param.target)
    end
    self.progressTxt:setString(T("%d/%d", item.param.progress, item.param.target))
  else
    self.progressBg:setVisible(false)
  end
  self.newMedalItem = item
end

function headSettingWindow:createMedalLeftLay()
  self.initedMedalLayer = true
  local layer = CCLayer:create()
  layer:setPosition(ccpAdd(ccp(self.ui.head_panel:getPosition()), ccp(0, 20)))
  self.ui.head_panel:getParent():addChild(layer)
  local bj = csLocalfunc("UI/alpha/1080P/medal/medal_bg_1.png", ccp(0, 0), 1, layer)
  self.medalIcon = csLocalfunc(self.allItems[1].param.Picture, ccp(57, 75), 0.7, bj)
  self.medalLayer = layer
  local board = ed.createScale9Sprite("UI/alpha/1080P/medal/medal_name_bg.png", CCRectMake(10, 10, 5, 5))
  board:setContentSize(CCSizeMake(114, 25))
  board:setPosition(0, -80)
  layer:addChild(board)
  local label = ed.createttf("", 16)
  label:setPosition(ccp(57, 12))
  label:setColor(ccc3(232, 169, 7))
  board:addChild(label)
  self.medalNameLabel = label
  label = ed.createttf("", 15)
  label:setPosition(ccp(0, -130))
  label:setColor(ccc3(255, 255, 240))
  label:setHorizontalAlignment(kCCTextAlignmentLeft)
  layer:addChild(label)
  self.medalDescText = label
  label = ed.createttf("", 15)
  label:setPosition(ccp(0, -170))
  label:setColor(ccc3(127, 246, 66))
  layer:addChild(label)
  self.medalTimeLabel = label
  self.progressBg = ed.createSpriteTools({
    res = "UI/alpha/1080P/medal/medal_progress_1.png",
    pos = ccp(0, -180),
    parent = layer
  })
  local progressImg = ed.createSpriteTools({
    res = "UI/alpha/1080P/medal/medal_progress_2.png",
    pos = ccp(0.5, 5.6),
    parent = self.progressBg,
    rectMake = CCRectMake(5, 0, 116, 0.5),
    sizeMake = CCSizeMake(126, 12),
    anchor = ccp(0, 0.5)
  })
  self.progressMode = ed.taskProModule.new(progressImg, 20)
  self.progressMode:setPro(0)
  self.progressTxt = ed.createLabelTools({
    txt = "",
    size = 13,
    anchor = ccp(0.5, 0.5),
    pos = ccp(64, 5.5),
    color = ccc3(ed.colorToStr("#fffce7")),
    stroke = {
      ccc3(ed.colorToStr("#0e0e0c")),
      1
    },
    parent = self.progressBg
  })
  if self.wearInfo then
    self:refreshMedalLeftLay(self.wearInfo)
  else
    self:refreshMedalLeftLay(self.allItems[1])
    self.newMedalItem = nil
  end
end

function headSettingWindow:getPlayerMedalInfo()
  local roleMedal = ed.player:getMedal()
  local medalTask = ed.player:getMedalTask()
  local wearId = roleMedal.wearId or roleMedal.wearInfo and (roleMedal.wearInfo._medal_id or 0) or 0
  local tabs = {}
  for _, v in pairs(ed.getDataTable("Medal")) do
    local have
    local tab = {}
    for _, vv in pairs(roleMedal.haveInfo or {}) do
      if vv._medal_id == v.MedalID then
        if 0 < v.LifeTimeDay and vv._expire_time and vv._expire_time >= ed.getServerTime() then
          have = vv
          break
        end
        if v.LifeTimeDay == 0 then
          have = vv
        end
        break
      end
    end
    if v.Hide or have then
      if have then
        tab.isHave = true
        tab.expire_time = have._expire_time
        tab.is_new = have._is_new
        tab.get_time = have._get_time
      else
        tab.isHave = false
      end
      tab.MedalID = v.MedalID
      tab.Description = v["Unlock Description"]
      tab.Picture = v.Picture
      tab.Name = v.Name
      tab.LifeTimeDay = v.LifeTimeDay
      tab.Hide = v.Hide
      tab.Order = v.Order
      tab.isProgress = v.Progress
      if v.Progress and medalTask[v.MedalID] then
        tab.progress = medalTask[v.MedalID].progress
        tab.target = medalTask[v.MedalID].target
      end
      tab["Unlock Description"] = v["Unlock Description"]
      table.insert(tabs, tab)
      if not self.wearInfo and wearId == v.MedalID then
        self.wearInfo = {param = tab}
      end
    end
  end
  table.sort(tabs, function(a, b)
    return a.Order < b.Order
  end)
  return tabs
end
