PlayerAddHonorPanel = {}
PlayerAddHonorPanel.__index = PlayerAddHonorPanel
local base = ed.ui.popwindow
setmetatable(PlayerAddHonorPanel, base.mt)
local ITEM_WIDTH = 82
local ITEM_HEIGHT = 128

function PlayerAddHonorPanel.create()
  local panel = base.create("playerAddHonorPanel")
  setmetatable(panel, PlayerAddHonorPanel)
  panel:initData()
  panel:initAppearance()
  panel:registerTouchHandler()
  panel:showTab("hero")
  return panel
end

function PlayerAddHonorPanel:initData()
  self.heros = ed.readhero.classify(nil, "position")
  self.avatarFrames = self:getAvatarFrames()
  self.avatars = self:getAvatars()
  self.achievements = self:getAchievements()
end

function PlayerAddHonorPanel:initAppearance()
  local container, ui = ed.editorui(ed.uieditor.add_honor_panel)
  self.mainLayer:addChild(container)
  self.container = container
  self.ui = ui
  ui.line_l:setScaleX(-0.5)
  ui.line_l:setScaleY(0.5)
  ui.line_r:setScale(0.5)
  self.ui.label_title:setShadow(ccc3(0, 0, 0), ccp(0, 2))
  local newWid = ed.display.halfFixedWidth
  local newHei = ed.display.halfFixedHeight
  container:setPosition(newWid, newHei)
  self:createTabList()
  self:createTabs()
end

function PlayerAddHonorPanel:registerTouchHandler()
  self:btRegisterButtonClick({
    button = self.ui.btn_back,
    press = self.ui.btn_back_press,
    key = "btn_back",
    clickHandler = function()
      self:destroy()
      FireEvent("add_honor_back")
    end,
    clickInterval = 0.5,
    pressScale = 0.75,
    normalScale = 0.8
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_save_continue,
    key = "btn_save_continue",
    clickHandler = function()
      self:addItem()
    end,
    clickInterval = 0.5,
    pressScale = 0.98
  })
end

function PlayerAddHonorPanel:addItem()
  if self.selectedTab == "medal" then
    if self.selectedIndex then
      local medal = self.medals[self.selectedIndex]
      FireEvent("HomePage_Add_Honor", {type = "medal", medal = medal})
      self:resetSelect()
    end
  elseif self.selectedTab == "hero" then
    if self.selectedIndex then
      local hero = self.heros[self.selectedIndex]
      FireEvent("HomePage_Add_Honor", {type = "hero", hero = hero})
      self:resetSelect()
    end
  elseif self.selectedTab == "avatar" then
    if self.frameSelectedIndex and self.avatarSelectedIndex then
      local avatar = self.avatars[self.avatarSelectedIndex]
      local frame = self.avatarFrames[self.frameSelectedIndex]
      if avatar.type == "photo" then
        FireEvent("HomePage_Add_Honor", {
          type = "photo",
          photoId = avatar.res,
          frame = frame
        })
      else
        FireEvent("HomePage_Add_Honor", {
          type = "avatar",
          avatar = avatar,
          frame = frame
        })
      end
      self:resetSelect()
    elseif self.frameSelectedIndex then
      ed.showToast(T("\232\175\183\233\128\137\230\139\169\230\144\173\233\133\141\231\154\132\229\164\180\229\131\143"))
      return
    elseif self.avatarSelectedIndex then
      ed.showToast(T("\232\175\183\233\128\137\230\139\169\230\144\173\233\133\141\231\154\132\229\164\180\229\131\143\230\161\134"))
    else
      ed.showToast(T("\232\175\183\233\128\137\230\139\169\229\164\180\229\131\143\229\146\140\229\164\180\229\131\143\230\161\134"))
    end
  elseif self.selectedTab == "achievement" and self.selectedIndex then
    local achievement = self.achievements[self.selectedIndex]
    FireEvent("HomePage_Add_Honor", {
      type = "achievement",
      achievement = achievement
    })
    self:resetSelect()
  end
end

function PlayerAddHonorPanel:resetSelect()
  if self.selectedIndex and self.curTableView then
    local cells = self.curTableView:usedCellFromIndex(self.selectedIndex)
    if cells then
      cells.data.ui.image_checkbox:setVisible(false)
    end
    self.selectedIndex = nil
  end
  if self.frameSelectedIndex and self.frameTableView then
    local cells = self.frameTableView:usedCellFromIndex(self.frameSelectedIndex)
    if cells then
      cells.data.ui.image_checkbox:setVisible(false)
    end
    self.frameSelectedIndex = nil
  end
  if self.avatarSelectedIndex and self.avatarTableView then
    local cells = self.avatarTableView:usedCellFromIndex(self.avatarSelectedIndex)
    if cells then
      cells.data.ui.image_checkbox:setVisible(false)
    end
    self.avatarSelectedIndex = nil
  end
  self.ui.node_view:removeAllChildrenWithCleanup(true)
end

function PlayerAddHonorPanel:createTabList()
  local contentSize = self.ui.node_tab_list:getContentSize()
  self.tabListHeight = contentSize.height
  local info = {
    cliprect = CCRectMake(0, 0, contentSize.width, contentSize.height),
    container = self.ui.node_tab_list,
    noshade = true,
    priority = -999,
    doPressIn = self:getDoPressInHander(),
    cancelPressIn = self:doButtonListCancelPressIn()
  }
  self.dragTablist = ed.draglist.create(info)
end

function PlayerAddHonorPanel:getDoPressInHander()
  local function doPressIn(x, y)
    for key, tab in pairs(self.tabs) do
      if ed.containsPoint(tab.button, x, y) and key ~= self.selectedTab then
        tab.press:setVisible(true)
        
        tab.button:setVisible(false)
        tab.name:setColor(ccc3(ed.colorToStr("#fffce7")))
        return key
      end
    end
  end
  
  return doPressIn
end

function PlayerAddHonorPanel:doButtonListCancelPressIn()
  local function doCancelPressIn(x, y, key)
    local tab = self.tabs[key]
    
    if ed.containsPoint(tab.button, x, y) then
      self:showTab(key)
    else
      tab.button:setVisible(true)
      tab.press:setVisible(false)
      tab.name:setColor(ccc3(ed.colorToStr("#b0a89a")))
    end
  end
  
  return doCancelPressIn
end

function PlayerAddHonorPanel:createTabs()
  local resConfig = {
    {
      key = "hero",
      name = T("\232\139\177\233\155\132"),
      button = "UI/alpha/1080P/honorwall/honorwall_del_button.png",
      press = "UI/alpha/1080P/honorwall/honorwall_choose_tip.png"
    },
    {
      key = "medal",
      name = T("\229\190\189\231\171\160"),
      button = "UI/alpha/1080P/honorwall/honorwall_del_button.png",
      press = "UI/alpha/1080P/honorwall/honorwall_choose_tip.png"
    },
    {
      key = "avatar",
      name = T("\229\164\180\229\131\143"),
      button = "UI/alpha/1080P/honorwall/honorwall_del_button.png",
      press = "UI/alpha/1080P/honorwall/honorwall_choose_tip.png"
    }
  }
  local BUTTON_WIDTH = 120
  local BUTTON_HEIGHT = 70
  self.tabs = {}
  for i, res in ipairs(resConfig) do
    local key = res.key
    local name = res.name
    local button = ed.createSprite(res.button)
    local press = ed.createSprite(res.press)
    local name = ed.createLabelTTF(name, 18)
    name:setColor(ccc3(ed.colorToStr("#fffce7")))
    ed.setLabelStroke(name, ccc3(0, 0, 0), 1)
    local posX = BUTTON_WIDTH / 2 + 1
    local posY = self.tabListHeight - (i - 1) * BUTTON_HEIGHT - BUTTON_HEIGHT / 2
    button:setPosition(ccp(posX, posY))
    press:setPosition(ccp(posX, posY - 3))
    name:setPosition(ccp(posX, posY))
    self.dragTablist.listLayer:addChild(button)
    self.dragTablist.listLayer:addChild(press)
    self.dragTablist.listLayer:addChild(name)
    press:setVisible(false)
    self.tabs[key] = {
      button = button,
      press = press,
      name = name
    }
  end
  self.dragTablist:initListHeight(BUTTON_HEIGHT * #resConfig)
end

function PlayerAddHonorPanel:createHeroTableView()
  if self.curTableView then
    self.curTableView = nil
  end
  local dlgt = {}
  
  function dlgt.numberOfCells()
    return #self.heros
  end
  
  function dlgt.cellSizeFromIndex(idx)
    return CCSizeMake(ITEM_WIDTH, ITEM_HEIGHT)
  end
  
  function dlgt.createCell(idx)
    local container, ui = ed.editorui(ed.uieditor.honor_item)
    local hero = self.heros[idx]
    local icon = ed.readhero.createIconByID(hero._tid, {length = 60})
    ui.node_icon:addChild(icon.icon)
    ui.image_checkbox:setVisible(self.selectedIndex == idx)
    container:setContentSize(CCSizeMake(70, 100))
    return container, {ui = ui, hero = hero}
  end
  
  function dlgt.doPressIn(cell)
    local node = cell.node
    node:setScale(0.95)
  end
  
  function dlgt.doClickIn(cell)
    local data = cell.data
    local node = cell.node
    local ui = data.ui
    ed.playEffect(ed.sound.deo.common_click_feedback)
    if self.selectedIndex == cell.idx then
      return
    end
    local cells = self.curTableView:usedCellFromIndex(self.selectedIndex)
    if cells then
      cells.data.ui.image_checkbox:setVisible(false)
    end
    ui.image_checkbox:setVisible(true)
    self.selectedIndex = cell.idx
    self:preview()
  end
  
  function dlgt.cancelClickIn(cell)
    local node = cell.node
    node:setScale(1)
  end
  
  function dlgt.cancelPressIn(cell)
    local node = cell.node
    node:setScale(1)
  end
  
  local contentSize = self.ui.node_list:getContentSize()
  local param = {
    delegate = dlgt,
    cliprect = CCRectMake(15, 0, contentSize.width, contentSize.height),
    container = self.ui.node_list,
    touchpriority = -999,
    zorder = 10,
    bar = {
      bglen = contentSize.height,
      bgpos = ccp(1, contentSize.height / 2)
    },
    dragMode = 1,
    colNum = 6,
    noshade = true
  }
  local tb_view = Tableview.create(param)
  self.curTableView = tb_view
  local cellsUsed = tb_view:getUsedCell()
  if cellsUsed[1] then
    param.delegate.doClickIn(cellsUsed[1])
  end
end

function PlayerAddHonorPanel:createMedalTableView()
  if self.curTableView then
    self.curTableView = nil
  end
  local dlgt = {}
  
  function dlgt.numberOfCells()
    return #self.medals
  end
  
  function dlgt.cellSizeFromIndex(idx)
    return CCSizeMake(ITEM_WIDTH, ITEM_HEIGHT)
  end
  
  function dlgt.createCell(idx)
    local medal = self.medals[idx]
    local container, ui = ed.editorui(ed.uieditor.honor_item)
    local medalImage = ed.createSprite(medal.image)
    medalImage:setScale(60 / medalImage:getContentSize().width)
    ui.node_icon:addChild(medalImage)
    ui.image_checkbox:setVisible(self.selectedIndex == idx)
    container:setContentSize(CCSizeMake(70, 100))
    return container, {ui = ui, medal = medal}
  end
  
  function dlgt.doPressIn(cell)
    local node = cell.node
    node:setScale(0.95)
  end
  
  function dlgt.doClickIn(cell)
    local data = cell.data
    local node = cell.node
    local ui = data.ui
    ed.playEffect(ed.sound.deo.common_click_feedback)
    if self.selectedIndex == cell.idx then
      return
    end
    local cells = self.curTableView:usedCellFromIndex(self.selectedIndex)
    if cells then
      cells.data.ui.image_checkbox:setVisible(false)
    end
    ui.image_checkbox:setVisible(true)
    self.selectedIndex = cell.idx
    self:preview()
  end
  
  function dlgt.cancelClickIn(cell)
    local node = cell.node
    node:setScale(1)
  end
  
  function dlgt.cancelPressIn(cell)
    local node = cell.node
    node:setScale(1)
  end
  
  local contentSize = self.ui.node_list:getContentSize()
  local param = {
    delegate = dlgt,
    cliprect = CCRectMake(15, 0, contentSize.width, contentSize.height),
    container = self.ui.node_list,
    touchpriority = -999,
    zorder = 10,
    bar = {
      bglen = contentSize.height,
      bgpos = ccp(1, contentSize.height / 2)
    },
    dragMode = 1,
    colNum = 6,
    noshade = true
  }
  local tb_view = Tableview.create(param)
  self.curTableView = tb_view
  local cellsUsed = tb_view:getUsedCell()
  if cellsUsed[1] then
    param.delegate.doClickIn(cellsUsed[1])
  end
end

function PlayerAddHonorPanel:createFrameTableView()
  if self.frameTableView then
    self.frameTableView = nil
  end
  local dlgt = {}
  
  function dlgt.numberOfCells()
    return #self.avatarFrames
  end
  
  function dlgt.cellSizeFromIndex(idx)
    return CCSizeMake(ITEM_WIDTH, ITEM_HEIGHT)
  end
  
  function dlgt.createCell(idx)
    local frame = self.avatarFrames[idx]
    local container, ui = ed.editorui(ed.uieditor.honor_item)
    local frameImage = ed.createSprite(frame.picture)
    local scale = 60 / frameImage:getContentSize().width
    frameImage:setScale(scale)
    ui.node_icon:addChild(frameImage)
    ui.image_checkbox:setVisible(idx == self.frameSelectedIndex)
    container:setContentSize(CCSizeMake(70, 100))
    if frame.spine then
      local frameSpine = ed.createSpineEffect(frame.spine)
      frameSpine:setAnimation(0, "Idle", true)
      frameSpine:setScale(frame.scale * scale)
      ui.node_icon:addChild(frameSpine)
      frameImage:setVisible(false)
    elseif frame.fca then
      local frame_fca = ed.createAvatarFca(frame.fca, frame.scale, ui.node_icon)
      local ctr = ed.getCenterPos(frameImage)
      frame_fca:setPosition(ctr)
    end
    return container, {ui = ui, frame = frame}
  end
  
  function dlgt.doPressIn(cell)
    local node = cell.node
    node:setScale(0.95)
  end
  
  function dlgt.doClickIn(cell)
    local data = cell.data
    local node = cell.node
    local ui = data.ui
    ed.playEffect(ed.sound.deo.common_click_feedback)
    if self.frameSelectedIndex == cell.idx then
      return
    end
    local cells = self.frameTableView:usedCellFromIndex(self.frameSelectedIndex)
    if cells then
      cells.data.ui.image_checkbox:setVisible(false)
    end
    ui.image_checkbox:setVisible(true)
    self.frameSelectedIndex = cell.idx
    self:preview()
  end
  
  function dlgt.cancelClickIn(cell)
    local node = cell.node
    node:setScale(1)
  end
  
  function dlgt.cancelPressIn(cell)
    local node = cell.node
    node:setScale(1)
  end
  
  local contentSize = self.ui.node_frame_list:getContentSize()
  local param = {
    delegate = dlgt,
    cliprect = CCRectMake(15, 0, contentSize.width, contentSize.height),
    container = self.ui.node_frame_list,
    touchpriority = -999,
    zorder = 10,
    bar = {
      bglen = contentSize.height,
      bgpos = ccp(1, contentSize.height / 2)
    },
    dragMode = 1,
    colNum = 3,
    noshade = true
  }
  local tb_view = Tableview.create(param)
  self.frameTableView = tb_view
end

function PlayerAddHonorPanel:createAvatarTableView()
  if self.avatarTableView then
    self.avatarTableView = nil
  end
  local dlgt = {}
  
  function dlgt.numberOfCells()
    return #self.avatars
  end
  
  function dlgt.cellSizeFromIndex(idx)
    return CCSizeMake(ITEM_WIDTH, ITEM_HEIGHT)
  end
  
  function dlgt.createCell(idx)
    local avatar = self.avatars[idx]
    local container, ui = ed.editorui(ed.uieditor.honor_item)
    if avatar.type == "photo" then
      local function callback(path)
        if not self.isDestroyed then
          local avatarImage = ed.createSprite(path)
          
          avatarImage:setScale(60 / avatarImage:getContentSize().width)
          ui.node_icon:addChild(avatarImage)
        end
      end
      
      ed.UploadImage:getImage(avatar.res, true, callback)
    else
      local avatarImage = ed.createSprite(avatar.res)
      avatarImage:setScale(60 / avatarImage:getContentSize().width)
      ui.node_icon:addChild(avatarImage)
      local size = avatarImage:getContentSize()
      local clipLayer = CCLayer:create()
      clipLayer:setClipRect(CCRectMake(0, 0, size.width - 10, size.height - 10))
      avatarImage:addChild(clipLayer)
      if avatar.spine then
        local headSpine = ed.createSpineEffect(avatar.spine, avatar.scale)
        headSpine:setAnimation(0, "Idle", true)
        clipLayer:addChild(headSpine)
        headSpine:setPosition(size.width / 2 + 2, size.height / 2 + 2)
      elseif avatar.fca then
        local avtr_fca = ed.createAvatarFca(avatar.fca, avatar.scale, clipLayer)
        local ctr = ed.getCenterPos(avatarImage)
        avtr_fca:setPosition(ctr)
      end
    end
    local frame = ed.createSprite("UI/alpha/1080P/common/frame/hero_icon_frame_1.png")
    if avatar.rank then
      local res = ed.getFrameRes(avatar.rank)
      frame = ed.createSprite(res)
    end
    frame:setScale(78 / frame:getContentSize().width)
    ui.node_icon:addChild(frame)
    ui.image_checkbox:setVisible(idx == self.avatarSelectedIndex)
    container:setContentSize(CCSizeMake(70, 100))
    return container, {ui = ui, avatar = avatar}
  end
  
  function dlgt.doPressIn(cell)
    local node = cell.node
    node:setScale(0.95)
  end
  
  function dlgt.doClickIn(cell)
    local data = cell.data
    local node = cell.node
    local ui = data.ui
    ed.playEffect(ed.sound.deo.common_click_feedback)
    if self.avatarSelectedIndex == cell.idx then
      return
    end
    local cells = self.avatarTableView:usedCellFromIndex(self.avatarSelectedIndex)
    if cells then
      cells.data.ui.image_checkbox:setVisible(false)
    end
    ui.image_checkbox:setVisible(true)
    self.avatarSelectedIndex = cell.idx
    self:preview()
    if self.frameSelectedIndex == nil then
      local cellsUsed = self.frameTableView:getUsedCell()
      if cellsUsed[1] then
        self.frameTableView:doClickIn(cellsUsed[1])
      end
    end
  end
  
  function dlgt.cancelClickIn(cell)
    local node = cell.node
    node:setScale(1)
  end
  
  function dlgt.cancelPressIn(cell)
    local node = cell.node
    node:setScale(1)
  end
  
  local contentSize = self.ui.node_avatar_list:getContentSize()
  local param = {
    delegate = dlgt,
    cliprect = CCRectMake(15, 0, contentSize.width, contentSize.height),
    container = self.ui.node_avatar_list,
    touchpriority = -999,
    zorder = 10,
    bar = {
      bglen = contentSize.height,
      bgpos = ccp(1, contentSize.height / 2)
    },
    dragMode = 1,
    colNum = 3,
    noshade = true
  }
  local tb_view = Tableview.create(param)
  self.avatarTableView = tb_view
  local cellsUsed = tb_view:getUsedCell()
  if cellsUsed[1] then
    param.delegate.doClickIn(cellsUsed[1])
  end
end

function PlayerAddHonorPanel:createAchievementTableView()
  if self.curTableView then
    self.curTableView = nil
  end
  local dlgt = {}
  
  function dlgt.numberOfCells()
    return #self.achievements
  end
  
  function dlgt.cellSizeFromIndex(idx)
    return CCSizeMake(ITEM_WIDTH, ITEM_HEIGHT)
  end
  
  function dlgt.createCell(idx)
    local achievement = self.achievements[idx]
    local container, ui = ed.editorui(ed.uieditor.honor_item)
    local icon = ed.createSprite(achievement.res)
    icon:setScale(60 / icon:getContentSize().width)
    ui.node_icon:addChild(icon)
    ui.image_checkbox:setVisible(idx == self.selectedIndex)
    container:setContentSize(CCSizeMake(70, 100))
    return container, {ui = ui, achievement = achievement}
  end
  
  function dlgt.doPressIn(cell)
    local node = cell.node
    node:setScale(0.95)
  end
  
  function dlgt.doClickIn(cell)
    local data = cell.data
    local node = cell.node
    local ui = data.ui
    ed.playEffect(ed.sound.deo.common_click_feedback)
    if self.selectedIndex == cell.idx then
      return
    end
    local cells = self.curTableView:usedCellFromIndex(self.selectedIndex)
    if cells then
      cells.data.ui.image_checkbox:setVisible(false)
    end
    ui.image_checkbox:setVisible(true)
    self.selectedIndex = cell.idx
    self:preview()
  end
  
  function dlgt.cancelClickIn(cell)
    local node = cell.node
    node:setScale(1)
  end
  
  function dlgt.cancelPressIn(cell)
    local node = cell.node
    node:setScale(1)
  end
  
  local contentSize = self.ui.node_list:getContentSize()
  local param = {
    delegate = dlgt,
    cliprect = CCRectMake(15, 0, contentSize.width, contentSize.height),
    container = self.ui.node_list,
    touchpriority = -999,
    zorder = 10,
    bar = {
      bglen = contentSize.height,
      bgpos = ccp(1, contentSize.height / 2)
    },
    dragMode = 1,
    colNum = 6,
    noshade = true
  }
  local tb_view = Tableview.create(param)
  self.curTableView = tb_view
  local cellsUsed = tb_view:getUsedCell()
  if cellsUsed[1] then
    param.delegate.doClickIn(cellsUsed[1])
  end
end

function PlayerAddHonorPanel:showTab(name)
  if self.selectedTab == name then
    return
  end
  ed.playEffect(ed.sound.deo.common_change_filter)
  self.selectedTab = name
  self:resetSelect()
  for key, tab in pairs(self.tabs) do
    if key == name then
      tab.press:setVisible(true)
      tab.button:setVisible(false)
      tab.name:setColor(ccc3(ed.colorToStr("#fffce7")))
    else
      tab.button:setVisible(true)
      tab.press:setVisible(false)
      tab.name:setColor(ccc3(ed.colorToStr("#b0a89a")))
    end
  end
  self:setTitle(name)
  self.ui.node_list:removeAllChildrenWithCleanup(true)
  self.ui.node_avatar_list:removeAllChildrenWithCleanup(true)
  self.ui.node_frame_list:removeAllChildrenWithCleanup(true)
  if name == "medal" then
    function ed.netreply.medalOpenPanel()
      local medalList = ed.TitleMgr.getInstance().unLockTitleList.items
      
      self.medals = medalList
      self:createMedalTableView()
    end
    
    self:listenEvent("medal_reply", function(info)
      if info._open_panel then
        local roleMedal = ed.player:getMedal()
        local medalList = {}
        for _, v in ipairs(roleMedal.haveInfo or {}) do
          table.insert(medalList, {
            key = v._medal_id or 0,
            getTime = v._get_time or 0,
            expireTime = v._expire_time or 0,
            isNew = v._is_new or 0,
            image = ed.getMedalRes(v)
          })
        end
        self.medals = medalList
        self:createMedalTableView()
      end
    end)
    local msg = ed.upmsg.medal_req()
    msg._open_panel = ed.upmsg.medal_open_panel()
    ed.send(msg, "medal")
  elseif name == "hero" then
    self:createHeroTableView()
  elseif name == "avatar" then
    self:createFrameTableView()
    self:createAvatarTableView()
  elseif name == "achievement" then
    self:createAchievementTableView()
  end
end

function PlayerAddHonorPanel:setTitle(name)
  local title = {
    medal = T("\233\128\137\230\139\169\229\183\178\232\142\183\229\190\151\231\154\132\229\190\189\231\171\160"),
    hero = T("\233\128\137\230\139\169\229\183\178\230\139\165\230\156\137\231\154\132\232\139\177\233\155\132"),
    avatar = T("\231\187\132\229\144\136\229\183\178\230\139\165\230\156\137\231\154\132\229\164\180\229\131\143\228\184\142\229\164\180\229\131\143\230\161\134"),
    achievement = T("\233\128\137\230\139\169\229\183\178\229\174\140\230\136\144\231\154\132\230\136\144\229\176\177")
  }
  ed.setString(self.ui.label_title, title[name])
end

function PlayerAddHonorPanel:getAvatarFrames()
  local function insertFramesTable(ftable, id, res, fca, spine, scale, des, name, sortid)
    local params = {
      id = id,
      
      picture = res,
      fca = fca,
      spine = spine,
      scale = scale or 1,
      des = des,
      Name = name,
      sort = sortid
    }
    table.insert(ftable, params)
  end
  
  local unlockframes = {}
  local avatarframes = ed.getDataTable("AvatarFrame")
  for k, v in pairs(avatarframes) do
    if type(k) == "number" then
      local requirement = v["Requirement Type"]
      if requirement == "PlayerLevel" then
        insertFramesTable(unlockframes, v.ID, v.Picture, v["Dynamic Model"], v["Spine Dynamic Model"], v.Scale, v["Unlock Description"], v.Name, v["Display ID"])
      elseif requirement == "VIPLevel" then
        if ed.player:getvip() >= v["Requirement Target"] then
          insertFramesTable(unlockframes, v.ID, v.Picture, v["Dynamic Model"], v["Spine Dynamic Model"], v.Scale, v["Unlock Description"], v.Name, v["Display ID"])
        end
      elseif requirement == "HaveItem" and v["Requirement ID"] > 0 and ed.player:getEquipAmount(v["Requirement ID"]) >= v["Requirement Target"] then
        insertFramesTable(unlockframes, v.ID, v.Picture, v["Dynamic Model"], v["Spine Dynamic Model"], v.Scale, v["Unlock Description"], v.Name, v["Display ID"])
      end
    end
  end
  return unlockframes
end

function PlayerAddHonorPanel:getAvatars()
  local list = {}
  local at = ed.getDataTable("Avatar")
  for k, v in pairs(at) do
    if type(k) == "number" then
      local requirement = v["Requirement Type"]
      local actType = v["Act Type"]
      local is_dyna = v["Is Dynamic"]
      local ut = ed.unitType(k)
      if requirement == "HaveItem" then
        ut = is_dyna and "dynavatar" or "equipment"
      elseif requirement == "HeroAwake" or requirement == "HeroAwakeExtra" then
        ut = "awake"
      elseif requirement == "UnlockFashion" then
        ut = "fashion"
      elseif ut == "monster" then
        ut = "free"
      elseif ut == "hero" then
        if ed.isElementInTable(k, {1}) then
          ut = "free"
        else
          ut = "hero"
        end
      end
      if ut then
        list[ut] = list[ut] or {}
        if not requirement then
          table.insert(list[ut], {
            key = k,
            res = v.Picture,
            type = ut,
            type = ut,
            rank = v["Display Rank"]
          })
        elseif requirement == "HeroRank" then
          local id = v["Requirement ID"]
          local tg = v["Requirement Target"]
          local hero = ed.player.heroes[id]
          local rank = (hero or {})._rank or 0
          if tg <= rank then
            table.insert(list[ut], {
              key = k,
              hero = hero,
              res = v.Picture,
              type = ut,
              rank = v["Display Rank"]
            })
          end
        elseif requirement == "HeroStars" then
          local id = v["Requirement ID"]
          local tg = v["Requirement Target"]
          local hero = ed.player.heroes[id]
          local star = (hero or {})._stars or 0
          if tg <= star then
            table.insert(list[ut], {
              key = k,
              hero = hero,
              res = v.Picture,
              type = ut,
              rank = v["Display Rank"]
            })
          end
        elseif requirement == "PlayerLevel" then
          local tg = v["Requirement Target"]
          if tg <= ed.player:getLevel() then
            table.insert(list[ut], {
              key = k,
              res = v.Picture,
              type = ut,
              type = ut,
              rank = v["Display Rank"]
            })
          end
        elseif requirement == "HaveItem" then
          if ed.player:getEquipAmount(v["Requirement ID"]) >= v["Requirement Target"] then
            local fca = v["Is Dynamic"] and v["Dynamic Model"]
            local spine = v["Is Dynamic"] and v["Spine Dynamic Model"]
            local param = {
              key = k,
              res = v.Picture,
              type = ut,
              rank = v["Display Rank"],
              fca = fca,
              spine = spine,
              scale = v.Scale
            }
            table.insert(list[ut], param)
          end
        elseif requirement == "UnlockFashion" then
          local fashion_id = v["Requirement ID"]
          local hero_id = (ed.getDataTable("Fashion")[fashion_id] or {})["Hero ID"]
          if hero_id then
            local hero = ed.player:getHero(hero_id)
            if ed.protoFashion(hero, fashion_id) then
              if fashion_id == "100741" then
                local fca = v["Is Dynamic"] and v["Dynamic Model"]
                local spine = v["Is Dynamic"] and v["Spine Dynamic Model"]
                local param = {
                  key = k,
                  res = v.Picture,
                  type = ut,
                  rank = v["Display Rank"],
                  fca = fca,
                  spine = spine,
                  scale = v.Scale
                }
                table.insert(list[ut], param)
              else
                table.insert(list[ut], {
                  key = k,
                  res = v.Picture,
                  type = ut,
                  type = ut,
                  rank = v["Display Rank"]
                })
              end
            end
          end
        end
      end
    end
  end
  local type_priority = {
    "free",
    "hero",
    "fashion",
    "worldcup",
    "equipment",
    "dynavatar"
  }
  local ret = {}
  local enable = ed.player:getCustomPhotoSwitch()
  local valid = ed.player:hasValidMonthCard()
  if enable and valid then
    local customPhoto = ed.player:getCustomPhoto()
    if customPhoto.photoId then
      local info = {
        res = customPhoto.photoId,
        type = "photo",
        rank = 1
      }
      table.insert(ret, info)
    end
  end
  list = list or {}
  for _, type in pairs(type_priority) do
    for _, avatar in pairs(list[type] or {}) do
      table.insert(ret, avatar)
    end
  end
  return ret
end

function PlayerAddHonorPanel:getAchievements()
  local list = {}
  local tbl = ed.getDataTable("AchievementPixel")
  for id, info in pairs(tbl) do
    if id ~= "name" then
      local itemId = info.Item_ID
      local haveAmount = ed.player.equip_qunty[itemId] or 0
      if 0 < haveAmount then
        table.insert(list, {
          id = id,
          res = info.Picture
        })
      end
    end
  end
  return list
end

function PlayerAddHonorPanel:preview()
  self.ui.node_view:removeAllChildrenWithCleanup(true)
  if self.selectedTab == "medal" then
    if self.selectedIndex then
      local medal = self.medals[self.selectedIndex]
      local medalImage = ed.createSprite(medal.image)
      medalImage:setScale(80 / medalImage:getContentSize().width)
      self.ui.node_view:addChild(medalImage)
    end
  elseif self.selectedTab == "hero" then
    if self.selectedIndex then
      local hero = self.heros[self.selectedIndex]
      local icon = ed.readhero.createIconByID(hero._tid, {length = 60})
      self.ui.node_view:addChild(icon.icon)
    end
  elseif self.selectedTab == "avatar" then
    if self.frameSelectedIndex then
      local frame = self.avatarFrames[self.frameSelectedIndex]
      local frameImage = ed.createSprite(frame.picture)
      local scale = 90 / frameImage:getContentSize().width
      frameImage:setScale(scale)
      self.ui.node_view:addChild(frameImage, 1)
      if frame.spine then
        local frameSpine = ed.createSpineEffect(frame.spine)
        frameSpine:setAnimation(0, "Idle", true)
        frameSpine:setScale(frame.scale * scale)
        self.ui.node_view:addChild(frameSpine, 2)
        frameImage:setVisible(false)
      elseif frame.fca then
      end
    end
    if self.avatarSelectedIndex then
      local avatar = self.avatars[self.avatarSelectedIndex]
      if avatar.type == "photo" then
        local function callback(path)
          if not self.isDestroyed then
            local avatarImage, headicon = ed.getHeadIcon({
              res = path,
              
              length = 55,
              not_fca = true
            })
            headicon:setScale(1.1)
            self.ui.node_view:addChild(avatarImage)
          end
        end
        
        ed.UploadImage:getImage(avatar.res, true, callback)
      else
        local avatarImage, headicon = ed.getHeadIcon({
          id = avatar.key,
          length = 55
        })
        headicon:setScale(1.1)
        self.ui.node_view:addChild(avatarImage)
      end
    end
  elseif self.selectedTab == "achievement" and self.selectedIndex then
    local achievement = self.achievements[self.selectedIndex]
    local icon = ed.createSprite(achievement.res)
    icon:setScale(60 / icon:getContentSize().width)
    self.ui.node_view:addChild(icon)
  end
end
