local SpanServerSet = {}
SpanServerSet.__index = SpanServerSet
ed.ui.SpanServerSet = SpanServerSet
local spanServerMgr = ed.SpanServerMgr.getInstance()
local SpanServerSetScope = {}

function SpanServerSet:onDestory(result)
  if not result then
    CloseScope(SpanServerSetScope)
    self:destroy({skipAnim = true})
    return
  end
  local id = self.obj.id
  local section = self.obj.section
  local res = self.obj.res
  if section == 1 then
    if self.headBack then
      self.headBack(id)
    end
  elseif section == 2 then
    if self.kuangBack then
      self.kuangBack(id, res)
    end
  elseif section == 3 then
    ed.TitleMgr.getInstance():setPlayerTitle(id)
    if self.medalBack then
      self.medalBack()
    end
  end
  CloseScope(SpanServerSetScope)
  self:destroy({skipAnim = true})
end

function SpanServerSet.create(param)
  local base = ed.ui.popwindow
  setmetatable(SpanServerSet, base.mt)
  local self = base.create("spanserverset", {isShade = true})
  setmetatable(self, SpanServerSet)
  self:show({skipAnim = true})
  self:initData(param)
  self:initUI()
  self:registerHandler()
  self:registerListenEvents()
  self:requestAcc()
  return self
end

function SpanServerSet:initData(param)
  self.ui = {}
  self.container = {}
  self.roleDraglist = nil
  self.roleNode = {}
  self.roleUI = {}
  self.eleDraglist = nil
  self.eleUI = {}
  self.obj = {}
  self.headBack = param.headBack
  self.kuangBack = param.kuangBack
  self.medalBack = param.medalBack
end

function SpanServerSet:initUI()
  local container, ui = ed.editorui(ed.uieditor.SpanServerSet)
  self.container = container
  self.ui = ui
  self.mainLayer:addChild(container)
  self:createRoleDraglist()
  self:createEleDraglist()
end

function SpanServerSet:requestAcc()
  spanServerMgr:setIsReqRoleData(true)
  ed.ui.serverlogin.selectServer()
end

function SpanServerSet:updateRoleInfo()
  self.roleData = {}
  local roleData = spanServerMgr:getRoleData()
  for _, v in pairs(roleData) do
    if tostring(v.svrid) ~= game_server_id then
      table.insert(self.roleData, v)
    end
  end
  self:initRoleList()
end

function SpanServerSet:updateEleInfo()
  self.eleData = spanServerMgr:getEleData()
  self.eleDraglist:clearList()
  self:initEleList()
end

function SpanServerSet:createRoleDraglist()
  local info = {
    container = self.ui.bgL,
    cliprect = CCRectMake(5, 10, 180, 320),
    noshade = true,
    zorder = 5,
    priority = -1
  }
  local draglist = ed.draglist.create(info)
  self.roleDraglist = draglist
end

function SpanServerSet:initRoleList()
  for index = 1, #self.roleData do
    self:createOneRoleItem(index)
  end
  self.roleDraglist:initListHeight(120 * #self.roleData)
end

function SpanServerSet:createOneRoleItem(index)
  local oneItemNode, oneItemUI = ed.editorui(ed.uieditor.SpanServerRoleBar)
  oneItemNode:setPosition(ccp(8, 340 - 120 * index))
  local v = self.roleData[index]
  local param = {
    id = v.avatar,
    uid = v.uid,
    level = v.level,
    vip = ed.getVipLevel(v.vip),
    avatar = v.avatar,
    name = v.name,
    babelLevel = v.babel_level
  }
  local roleNode, roleUI = ed.createMainFrameHead(param)
  self.roleNode[index] = roleNode
  self.roleUI[index] = roleUI
  roleNode:setAnchorPoint(ccp(0.5, 0.5))
  roleNode:setPosition(ccp(48, 48))
  oneItemUI.itemBg:addChild(roleNode)
  self:btRegisterButtonClick({
    button = oneItemUI.itemBg,
    press = oneItemUI.itemBg_press,
    key = "itemBtn" .. index,
    clickHandler = function()
      self:roleNodeTouch(index)
    end,
    force = true,
    mcpMode = true,
    clickInterval = 0.5,
    pressScale = 0.95
  })
  self.roleDraglist:addItem(oneItemNode)
end

function SpanServerSet:roleNodeTouch(index)
  self.selectIndex = index
  if self.selectedRoleNode then
    self.selectedRoleNode:setScale(1)
  end
  self.selectedRoleNode = self.roleNode[index]
  self.selectedRoleNode:setScale(1.15)
  local serId = self.roleData[index].svrid
  local serStr = spanServerMgr:getServerNameBySerId(serId)
  ed.setLabelString(self.ui.titleLabel, serStr)
  self:sendGetRemoteItems(serId)
end

function SpanServerSet:sendGetRemoteItems(serId)
  local msg = ed.upmsg.remote_setting()
  msg._get_remote_items = ed.upmsg.get_remote_items()
  msg._get_remote_items.svr_id = serId
  ed.send(msg, "remote_setting")
end

local titleHeight = 40
local cellHeight = 95
local cellWidth = 90

function SpanServerSet:createEleDraglist()
  local info = {
    container = self.ui.bgR,
    cliprect = CCRectMake(5, 10, 525, 320),
    noshade = true,
    zorder = 5
  }
  local draglist = ed.draglist.create(info)
  self.eleDraglist = draglist
end

local function getOneRowNum(obj)
  local sum = 0
  local oneRowNum = 5
  local obj = obj
  if 0 < #obj then
    sum = sum + math.floor((#obj - 1) / oneRowNum) + 1
  end
  return sum
end

function SpanServerSet:getStartPosY(section, isEle)
  local posY = 310
  if section == 2 then
    posY = posY - getOneRowNum(self.eleData.head) * cellHeight - titleHeight
  elseif section == 3 then
    posY = posY - getOneRowNum(self.eleData.head) * cellHeight - getOneRowNum(self.eleData.kuang) * cellHeight - titleHeight * 2
  end
  if isEle == true then
    posY = posY - titleHeight - 10
  end
  return posY
end

function SpanServerSet:initEleList()
  self:createEleItem()
  local eleRowNum = getOneRowNum(self.eleData.head) + getOneRowNum(self.eleData.kuang) + getOneRowNum(self.eleData.medal)
  local totHeight = cellHeight * eleRowNum + titleHeight * 3
  self.eleDraglist:initListHeight(totHeight)
end

function SpanServerSet:createEleItem()
  self:createTitleItem()
  for index, oneHead in pairs(self.eleData.head) do
    local oneNode = self:createOneEle(1, oneHead, index)
    self.eleDraglist:addItem(oneNode)
  end
  for index, oneHeadKuang in pairs(self.eleData.kuang) do
    local oneNode = self:createOneEle(2, oneHeadKuang, index)
    self.eleDraglist:addItem(oneNode)
  end
  for index, oneMedal in pairs(self.eleData.medal) do
    local oneNode = self:createOneEle(3, oneMedal, index)
    self.eleDraglist:addItem(oneNode)
  end
end

function SpanServerSet:createTitleItem()
  local posY = self:getStartPosY(1)
  local titleNode1 = self:createOneTitle(T("\229\143\175\228\189\169\229\184\166\229\164\180\229\131\143"), posY)
  self.eleDraglist:addItem(titleNode1)
  posY = self:getStartPosY(2)
  local titleNode2 = self:createOneTitle(T("\229\143\175\228\189\169\229\184\166\229\164\180\229\131\143\230\161\134"), posY)
  self.eleDraglist:addItem(titleNode2)
  posY = self:getStartPosY(3)
  local titleNode3 = self:createOneTitle(T("\229\143\175\228\189\169\229\184\166\229\190\189\231\171\160"), posY)
  self.eleDraglist:addItem(titleNode3)
end

function SpanServerSet:createOneTitle(text, posY)
  local posX = 265
  local titleNode = CCSprite:create()
  local titleSprite = ed.createSprite("UI/alpha/HVGA/equip_detail_title_bg.png")
  titleNode:addChild(titleSprite)
  local titleLabel = ed.createttf(text, 15)
  ed.setLabelColor(titleLabel, ccc3(255, 236, 22))
  titleNode:addChild(titleLabel)
  titleNode:setPosition(ccp(posX, posY))
  return titleNode
end

function SpanServerSet:createOneEle(section, oneData, index)
  index = index - 1
  local res = oneData.res
  local is_dyna = oneData.is_dyna
  local avt_fca = oneData.avt_fca
  local avt_scale = oneData.avt_scale
  local eleNode = CCSprite:create()
  local layer = CCLayer:create()
  local button = ed.createNode({
    t = "Sprite",
    base = {res = res},
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  }, layer)
  local bt_ctr = ed.getCenterPos(button)
  local press = ed.createNode({
    t = "Sprite",
    base = {res = res},
    layout = {position = bt_ctr},
    config = {visible = false}
  }, button)
  if is_dyna then
    ed.createAvatarFca(avt_fca, avt_scale, button)
  end
  local isPress
  layer:registerScriptTouchHandler(function(event, x, y)
    if tolua.isnull(button) then
      return false
    end
    if event == "began" then
      isPress = nil
      if ed.checkVisible(button) and ed.containsPoint(button, x, y) then
        button:setScale(0.9)
        press:setVisible(true)
        isPress = true
        return true
      end
    elseif event == "ended" and ed.containsPoint(button, x, y) then
      if isPress then
        button:setScale(1)
        press:setVisible(false)
        self:eleNodeTouch(section, oneData)
        return true
      end
    elseif not ed.containsPoint(button, x, y) then
      button:setScale(1)
    end
    return false
  end, false, -200, true)
  layer:setTouchEnabled(true)
  eleNode:addChild(layer)
  local oneRowNum = 5
  local startX = -5
  local startY = self:getStartPosY(section, true)
  local posX = startX + index % oneRowNum * cellWidth + cellWidth
  local posY = startY - math.floor(index / oneRowNum) * cellHeight - titleHeight / 3
  eleNode:setPosition(ccp(posX, posY))
  return eleNode
end

function SpanServerSet:eleNodeTouch(section, oneData)
  self.obj.section = section
  self.obj.id = oneData.id
  self.obj.res = oneData.res
  local msg = ed.upmsg.remote_setting()
  msg._set_remote_item = ed.upmsg.set_remote_item()
  msg._set_remote_item._remote_item_type = section
  local itemId = oneData.id
  msg._set_remote_item._remote_item_id = itemId
  ed.send(msg, "remote_setting")
end

function SpanServerSet:setRemoteReply(result)
  if result then
    self:onDestory(result)
  else
    ed.showToast(T("\232\174\190\231\189\174\229\164\177\232\180\165"))
  end
end

function SpanServerSet:registerHandler()
  self:btRegisterHandler({
    handler = self.roleDraglist:getListLayerTouchHandler()
  })
  self:btRegisterHandler({
    handler = self.eleDraglist:getListLayerTouchHandler()
  })
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.closeBtn,
    press = ui.closeBtn_press,
    key = "backmain",
    clickHandler = function()
      self:onDestory()
    end,
    force = true,
    mcpMode = true,
    clickInterval = 0.5
  })
end

function SpanServerSet:registerListenEvents()
  ListenEvent("requestRoleDataReply", function()
    self:updateRoleInfo()
  end, SpanServerSetScope)
  ListenEvent("_get_remote_items", function()
    self:updateEleInfo()
  end, SpanServerSetScope)
  ListenEvent("_set_remote_item", function(result)
    self:setRemoteReply(result)
  end, SpanServerSetScope)
end
