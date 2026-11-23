module("ed", package.seeall)
TitleMgr = {}
local instance

function TitleMgr.getInstance()
  if instance == nil then
    instance = TitleMgr.create()
  end
  return instance
end

function TitleMgr.create()
  local self = {
    titleList = {},
    isReceviedMedal = false,
    layerCnt = 0
  }
  setmetatable(self, TitleMgr)
  TitleMgr.__index = TitleMgr
  self.playerTitle = self:getOneTitleById(0)
  self:initTitleList()
  instance = self
  return self
end

function TitleMgr:setMedal(medal)
  local medal = medal
  self:setPlayerTitle(medal.medal_id)
  self.playerTitle.getTime = medal.get_time or 0
end

function TitleMgr:setMedalList(medalList)
  if type(medalList) ~= "table" then
    EDLog("---> Error: Failed to setMedalList")
    return
  end
  self.medalList = medalList
end

function TitleMgr:setPlayerTitle(id)
  self.playerTitle = self:getOneTitleById(id)
  if self.playerTitle ~= false then
    return true
  end
end

function TitleMgr:getPlayerTitle()
  if self.playerTitle ~= nil then
    return self.playerTitle
  end
  return self:getOneTitleById(0)
end

function TitleMgr:initTitleList()
  self.unLockTitleList = {
    title = {},
    items = {}
  }
  self.lockTitleList = {
    title = {},
    items = {}
  }
  local titleList = {}
  table.insert(titleList, self.defaultTitle)
  local allTitles = ed.getDataTable("Medal")
  for _, oneTitle in ipairs(allTitles) do
    local t_title = {
      key = oneTitle.MedalID,
      name = oneTitle.Name,
      image = oneTitle.Picture,
      slot = oneTitle.Order,
      description = oneTitle.Description,
      isHide = oneTitle.Hide,
      lifeTimeDay = oneTitle.LifeTimeDay,
      seniorID = oneTitle.SeniorMedalID or 0,
      progress = 0
    }
    table.insert(titleList, t_title)
  end
  self.unLockTitleList.title = {
    name = T("\229\183\178\232\142\183\229\190\151\229\190\189\231\171\160"),
    image = "UI/alpha/HVGA/equip_detail_title_bg.png",
    description = ""
  }
  self.lockTitleList.title = {
    name = T("\230\156\170\232\142\183\229\190\151\229\190\189\231\171\160"),
    image = "UI/alpha/HVGA/equip_detail_title_bg.png",
    description = ""
  }
  self.lockTitleList.items = titleList
  self.titleList = titleList
end

function TitleMgr:refreshTitles(medalItems, medalProgress)
  local medalItems = medalItems or {}
  local medalProgress = medalProgress or {}
  self:setTitleListProgress(medalProgress)
  
  local function isGot(sid)
    for _, oneMeadl in pairs(medalItems) do
      if oneMeadl.medal_id == sid then
        return true
      end
    end
    return false
  end
  
  local unLockItems = {}
  local lockItems = {}
  local allTitles = self.titleList
  for _, oneTitle in ipairs(allTitles) do
    if not isGot(oneTitle.seniorID) then
      local resetedTitle = self:resetTitlesByMedals(oneTitle, medalItems)
      if resetedTitle then
        table.insert(unLockItems, resetedTitle)
      else
        table.insert(lockItems, oneTitle)
      end
    end
  end
  
  local function comparator(a, b)
    return a.slot < b.slot
  end
  
  table.sort(unLockItems, comparator)
  table.sort(lockItems, comparator)
  self.unLockTitleList.items = unLockItems
  self.lockTitleList.items = lockItems
  return true
end

function TitleMgr:setTitleListProgress(medalProgress)
  local function isGot(key)
    for _, oneMeadl in pairs(medalProgress) do
      if oneMeadl._id == key then
        local curStr = tostring(oneMeadl._current)
        
        if curStr == "0" then
          curStr = "-"
        end
        return curStr .. "/" .. tostring(oneMeadl._total)
      end
    end
    return false
  end
  
  for _, oneTitle in pairs(self.titleList) do
    local progress = isGot(oneTitle.key)
    if progress then
      oneTitle.progress = progress
    end
  end
end

function TitleMgr:resetTitlesByMedals(oneTitle, medalItems)
  for _, oneMeadl in pairs(medalItems) do
    if oneTitle.key == oneMeadl.medal_id and 0 ~= oneMeadl.get_time then
      oneTitle.getTime = oneMeadl.get_time or 0
      oneTitle.expireTime = oneMeadl.expire_time or 0
      oneTitle.isNew = oneMeadl.is_new or 0
      return oneTitle
    end
  end
  return false
end

function TitleMgr:getTitleList()
  return self.titleList
end

function TitleMgr:getLockTitleList()
  return self.lockTitleList
end

function TitleMgr:getNotHideLockTitleList()
  local showList = {
    title = self.lockTitleList.title,
    items = {}
  }
  for _, oneItem in pairs(self.lockTitleList.items) do
    if not oneItem.isHide then
      table.insert(showList.items, oneItem)
    end
  end
  return showList
end

function TitleMgr:getUnLockTitleList()
  return self.unLockTitleList
end

function TitleMgr:getOneTitleById(titleId)
  local defaultTitle = {
    key = 0,
    name = T("\230\156\170\228\189\169\230\136\180"),
    image = "UI/alpha/HVGA/medal/medal_blank.png",
    description = T("\230\156\170\228\189\169\230\136\180\228\187\187\228\189\149\229\190\189\231\171\160\239\188\140\229\143\175\229\156\168\228\184\170\228\186\186\228\191\161\230\129\175\233\161\181\233\157\162\232\174\190\231\189\174\229\183\178\232\142\183\229\190\151\231\154\132\229\190\189\231\171\160"),
    lifeTimeDay = 0,
    getTime = 0,
    seniorID = 0
  }
  if titleId == nil or titleId == 0 then
    return defaultTitle
  end
  for _, onetitle in pairs(self.titleList) do
    if titleId == onetitle.key then
      return onetitle
    end
  end
  return false
end

function TitleMgr:checkMedalIsExpired(title, getTime)
  local lifeTimeDay = title.lifeTimeDay
  if lifeTimeDay == 0 or getTime == 0 then
    return false
  end
  local expireTime = getTime + lifeTimeDay * 24 * 3600
  if expireTime < ed.getFitServerTime() then
    return true
  end
  return false
end

function TitleMgr:setNewMedalId(id)
  self.newDropMedalId = id
  if self.newDropMedalId then
    self:setIsReceviedMedal(true)
    self:setShowDealTag(true)
  end
end

function TitleMgr:getNewMedalId()
  return self.newDropMedalId
end

function TitleMgr:setIsReceviedMedal(isTech)
  self.isReceviedMedal = isTech
end

function TitleMgr:setShowDealTag(isOpen)
  self.showDealTag = isOpen
end

function TitleMgr:getShowDealTag()
  if self.showDealTag == nil then
    return false
  end
  return self.showDealTag
end

function TitleMgr:checkOpenMedalSetTech()
  if self.isOpenedMedalTech == true then
    return false
  end
  if self.isReceviedMedal and self:isFirstGetMedal() then
    self.isOpenedMedalTech = true
    return true
  end
  return false
end

function TitleMgr:isFirstGetMedal()
  if self.medalList and #self.medalList > 0 then
    return false
  end
  return true
end

local function getCurrentScene()
  return ed.getCurrentScene().scene
end

function TitleMgr:saveLayer(layer)
  if ed.getCurrentScene().identity == "guild" then
    self.t_layer[self.layerCnt] = layer
    self.layerCnt = self.layerCnt + 1
  end
end

function TitleMgr:cleanLayer()
  self.t_layer = {}
  self.layerCnt = 0
end

function TitleMgr:enableLayer(enable)
  local t_layer = self.t_layer or {}
  for _, layer in pairs(t_layer) do
    if not tolua.isnull(layer) then
      layer:setTouchEnabled(enable)
    end
  end
end

function TitleMgr:addTitleNode(cfg, parentNode, nameNode)
  if cfg.titleId == nil or cfg.titleId == 0 then
    return nil
  end
  local offX = cfg.offX or 0
  local offY = cfg.offY or 0
  local nameOffX = cfg.nameOffX or offX
  if cfg.scale == 0.5 then
    cfg.scale = cfg.scale + 0.1
    offX = offX + 8
    offY = offY - 5
    nameOffX = nameOffX + 9
  end
  offX = offX - 18
  offY = offY + 18
  local titleNode = self:createTitleNode(cfg)
  if not titleNode then
    return
  end
  local px, py = nameNode:getPosition()
  titleNode:setPosition(ccp(px + offX, py + offY))
  parentNode:addChild(titleNode)
  nameNode:setPositionX(px + nameOffX)
  return titleNode
end

function TitleMgr:createTitleNode(cfg, parentNode)
  local titleId = cfg.titleId or 0
  local title = self:getOneTitleById(titleId)
  if not title then
    return
  end
  local res = title.image
  local scale = cfg.scale or 1
  local x, y = cfg.x or 0, cfg.y or 0
  local node = CCNode:create()
  local layer = CCLayer:create()
  node:addChild(layer)
  local button = ed.createNode({
    t = "Sprite",
    base = {res = res},
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(x, y)
    }
  }, layer)
  local press = ed.createNode({
    t = "Sprite",
    base = {res = res},
    layout = {
      position = ed.getCenterPos(button)
    },
    config = {visible = false}
  }, button)
  local isPress
  button:setScale(scale)
  layer:registerScriptTouchHandler(function(event, x, y)
    if tolua.isnull(button) then
      return false
    end
    if event == "began" then
      isPress = nil
      if ed.checkVisible(button) and ed.containsPoint(button, x, y) then
        press:setVisible(true)
        isPress = true
        self:createTitlePromptCard(x, y, title, parentNode)
        return true
      else
        return false
      end
    elseif event == "ended" and isPress then
      press:setVisible(false)
      self:destroyTitlePromptCard()
      return true
    end
    return false
  end, false, -200, true)
  layer:setTouchEnabled(true)
  self:saveLayer(layer)
  return node
end

function TitleMgr:createTitlePromptCard(x, y, title, parentNode)
  self:destroyTitlePromptCard()
  local bgWidth = 240
  local bgHeight = 120
  local popNode = self:createTitlePromptNode(bgWidth, bgHeight, title)
  local px = x - 120
  local py = y + 100
  if 460 < py then
    py = 460
  end
  popNode:setPosition(ccp(px, py))
  if parentNode ~= nil then
    parentNode:addChild(popNode, 5000)
  elseif getCurrentScene() ~= nil then
    getCurrentScene():addChild(popNode, 5000)
  end
  self.popContainer = popNode
end

function TitleMgr:createTitlePromptNode(bgWidth, bgHeight, title)
  local timeDes = ""
  if title.getTime and title.getTime ~= 0 then
    timeDes = T(ed.getYMDTime(title.getTime) .. T(" \232\142\183\229\143\150"))
  end
  local text = title.description
  local textLen = string.len(text)
  local bgNode = ed.createNode({
    t = "Scale9Sprite",
    base = {
      res = "UI/alpha/1080P/common/main_vit_tips.png",
      capInsets = CCRectMake(15, 20, 45, 15)
    },
    layout = {
      anchor = ccp(0, 1)
    },
    config = {
      scaleSize = CCSizeMake(bgWidth, bgHeight)
    }
  })
  local titleSprite = ed.createNode({
    t = "Sprite",
    base = {
      res = title.image
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, bgHeight - 30)
    }
  }, bgNode)
  titleSprite:setScale(0.8)
  ed.createNode({
    t = "Label",
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(80, bgHeight - 20)
    },
    base = {
      text = title.name,
      size = 18
    },
    config = {
      color = ccc3(255, 255, 255)
    }
  }, bgNode)
  ed.createNode({
    t = "Label",
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(80, bgHeight - 40)
    },
    base = {text = timeDes, size = 16},
    config = {
      color = ccc3(173, 156, 131)
    }
  }, bgNode)
  ed.createNode({
    t = "Scale9Sprite",
    base = {
      res = "UI/alpha/HVGA/act/act_comment_bg.png",
      capInsets = CCRectMake(18, 10, 45, 15)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(bgWidth / 2, bgHeight / 4 + 5)
    },
    config = {
      scaleSize = CCSizeMake(bgWidth - 5, bgHeight / 2 - 10)
    }
  }, bgNode)
  local py = 28
  if 39 < textLen then
    py = 20
  end
  ed.createNode({
    t = "Label",
    layout = {
      anchor = ccp(0, 0),
      position = ccp(17, py)
    },
    base = {text = text, size = 16},
    config = {
      horizontalAlignment = kCCTextAlignmentLeft,
      dimensions = CCSizeMake(bgWidth - 30, 0),
      color = ccc3(243, 191, 113)
    }
  }, bgNode)
  return bgNode
end

function TitleMgr:destroyTitlePromptCard()
  if self.popContainer then
    self.popContainer:removeFromParentAndCleanup(true)
    self.popContainer = nil
  end
end

function TitleMgr:createSelectWindow(parm)
  local container, ui = ed.editorui(ed.uieditor.setSelectPanel)
  self.selectContainer = container
  self.selectUI = ui
  self:initSelectWindow(ui, parm)
  self:setSelectBtnCfg(ui)
  if self:isRemoteAvatarDisable() then
    ui.bgS:setVisible(false)
    local x, y = container:getPosition()
    container:setPosition(ccp(x, y + 30))
  end
  return container, ui
end

function TitleMgr:initSelectWindow(ui, parm)
  local ui = ui
  if parm == nil then
    return
  end
  local btnName = parm.selectedBtn
  ed.setTexture(ui[btnName], "UI/alpha/HVGA/ranklist/ranklist_subbutton_current_1s.png")
  ui.dealTag:setVisible(self:getShowDealTag())
end

function TitleMgr:setSelectBtnCfg(ui)
  local ui = ui
  local btnRes = "UI/alpha/HVGA/ranklist/ranklist_subbutton_current_1s.png"
  local btnResPress = "UI/alpha/HVGA/ranklist/ranklist_subbutton_normal_1s.png"
  local selectBtnCfg = {
    {
      name = "headBtn",
      press = function()
        ed.setTexture(ui.headBtn, btnRes)
      end,
      cancle = function()
        ed.setTexture(ui.headBtn, btnResPress)
      end,
      eventName = "openHeadFrame"
    },
    {
      name = "kuangBtn",
      press = function()
        ed.setTexture(ui.kuangBtn, btnRes)
      end,
      cancle = function()
        ed.setTexture(ui.kuangBtn, btnResPress)
      end,
      eventName = "openHeadKuangFrame"
    },
    {
      name = "titleBtn",
      press = function()
        ed.setTexture(ui.titleBtn, btnRes)
      end,
      cancle = function()
        ed.setTexture(ui.titleBtn, btnResPress)
      end,
      eventName = "openTitleFrame"
    }
  }
  self.selectBtnCfg = selectBtnCfg
end

function TitleMgr:getSelectBtnCfg()
  return self.selectBtnCfg
end

function TitleMgr:isRemoteAvatarDisable()
  local switch = ed.player.global_config._module_switch or {}
  local moduleDisable = switch._ban_module or {}
  if "table" == type(moduleDisable) then
    return ed.isElementInTable(31, moduleDisable)
  elseif "number" == type(moduleDisable) then
    return moduleDisable == 31
  end
  return true
end
