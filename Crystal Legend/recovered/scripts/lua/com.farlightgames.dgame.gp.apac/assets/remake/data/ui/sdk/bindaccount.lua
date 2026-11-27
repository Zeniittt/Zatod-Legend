module("accSystem", package.seeall)
BindAccount = {}
BindAccount.__index = BindAccount
local BindAccountScope = {}

function BindAccount:onDestory(result)
  if result then
  end
  CloseScope(BindAccountScope)
  self:destroy({skipAnim = true})
end

function BindAccount.create()
  local base = ed.ui.popwindow
  setmetatable(BindAccount, base.mt)
  local self = base.create("bindaccountframe", {isShade = true})
  setmetatable(self, BindAccount)
  self:show({skipAnim = true})
  self:initData()
  self:initUI()
  self:registerHandler()
  self:registerListenEvents()
  return self
end

function BindAccount:initData()
  self.ui = {}
  self.container = {}
  self.accDraglist = nil
  self.roleDraglist = nil
  self.accNode = {}
  self.accUI = {}
end

function BindAccount:initUI()
  local container, ui = ed.editorui(ed.uieditor.BindAccountFrame)
  self.container = container
  self.ui = ui
  self.mainLayer:addChild(container)
  self:createAccDraglist()
  self:createRoleDraglist()
  self:updateAccInfo()
end

function BindAccount:updateAccInfo()
  self.accDraglist:clearList()
  local accData = BindAccountMgr.getInstance():getAccounts() or {}
  self.accData = accData
  self:initAccList(accData)
  self:updateRoleInfo()
end

function BindAccount:createAccDraglist()
  local info = {
    container = self.ui.bgL,
    cliprect = CCRectMake(5, 62, 155, 272),
    noshade = true,
    zorder = 5,
    priority = -1
  }
  local draglist = ed.draglist.create(info)
  self.accDraglist = draglist
end

function BindAccount:initAccList(accData)
  for index = 1, #accData do
    local oneData = accData[index]
    self:createOneAccItem(index, oneData)
  end
  self.accDraglist:initListHeight(44 * #accData)
end

function BindAccount:createOneAccItem(index, oneData)
  local oneItemNode = CCSprite:create()
  local oneItemUI = {}
  local readNode = ed.readnode.create(oneItemNode, oneItemUI)
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "Bg",
        res = "installer/serverselect_selected_highlight_green.png",
        capInsets = CCRectMake(50, 20, 50, 15)
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(10, -15)
      },
      config = {
        scaleSize = CCSizeMake(140, 40),
        opacity = 1
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "Acc",
        res = "installer/serverselect_selected_highlight_green.png",
        capInsets = CCRectMake(50, 20, 50, 15)
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(10, -15)
      },
      config = {
        scaleSize = CCSizeMake(140, 40),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "AccountName",
        text = T("\230\181\139\232\175\149\230\156\141\239\188\154"),
        size = 20,
        fontinfo = "dark_yellow1"
      },
      layout = {
        position = ccp(80, -7),
        anchor = ccp(0.5, 1)
      },
      config = {},
      listData = true
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "lineinfo",
        res = "installer/serverselect_delimiter_2.png",
        capInsets = CCRectMake(80, 0, 80, 2)
      },
      layout = {
        anchor = ccp(0, 1),
        position = ccp(0, -36)
      },
      config = {
        scaleSize = CCSizeMake(160, 2)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "lineinfo2",
        res = "installer/serverselect_delimiter_2.png",
        capInsets = CCRectMake(80, 0, 80, 2)
      },
      layout = {
        anchor = ccp(0, 1),
        position = ccp(0, 6)
      },
      config = {
        scaleSize = CCSizeMake(160, 2),
        visible = false
      }
    }
  }
  readNode:addNode(ui_info)
  if index == 1 then
    oneItemUI.lineinfo2:setVisible(true)
  end
  oneItemNode:setPosition(ccp(-8, 370 - 44 * index))
  ed.setString(oneItemUI.AccountName, tostring(oneData.uin))
  self.accNode[index] = oneItemNode
  self.accUI[index] = oneItemUI
  self:btRegisterButtonClick({
    button = oneItemUI.Bg,
    press = oneItemUI.Bg_press,
    key = "Acc" .. index,
    clickHandler = function()
      self:accNodeTouch(index, oneData)
    end,
    force = true,
    mcpMode = true,
    clickInterval = 0.5,
    pressScale = 0.95
  })
  self.accDraglist:addItem(oneItemNode)
end

function BindAccount:accNodeTouch(index, oneData)
  self.selectIndex = index
  if self.selectedAccUI then
    self.selectedAccUI.Acc:setVisible(false)
  end
  self.selectedAccUI = self.accUI[index]
  self.accUI[index].Acc:setVisible(true)
  self:updateRoleInfo(oneData.uin)
end

function BindAccount:createRoleDraglist()
  local info = {
    container = self.ui.bgR,
    cliprect = CCRectMake(5, 10, 525, 320),
    noshade = true,
    zorder = 5
  }
  local draglist = ed.draglist.create(info)
  self.roleDraglist = draglist
end

function BindAccount:updateRoleInfo(uin)
  self.roleDraglist:clearList()
  uin = uin or self.accData[1].uin
  if uin then
    self.selectUin = uin
    local roleData = BindAccountMgr.getInstance():getRolesByUin(uin)
    self.roleData = roleData
    local data = {}
    if self.ui.HideImg:isVisible() then
      for _, v in pairs(self.roleData) do
        if 1 < v.level then
          table.insert(data, v)
        end
      end
    else
      data = self.roleData
    end
    self:initRoleList(data)
  end
end

function BindAccount:initRoleList(roleData)
  for index = 1, #roleData do
    local oneData = roleData[index]
    self:createOneEle(index, oneData)
  end
  local totHeight = 138 * #roleData
  self.roleDraglist:initListHeight(totHeight)
end

local function getPxByIndex(index)
  local width = 165
  local height = 135
  local row = (index - 1) % 3
  local line = math.floor((index - 1) / 3)
  return 60 + row * width, 260 - line * height
end

function BindAccount:createOneEle(index, oneData)
  local v = oneData
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
  roleNode:setAnchorPoint(ccp(0.5, 0.5))
  local px, py = getPxByIndex(index)
  roleNode:setPosition(ccp(px, py))
  local serverName = ed.createttf(v.svrname or T(""), 18)
  ed.setLabelColor(serverName, ccc3(238, 204, 119))
  serverName:setAnchorPoint(ccp(0.5, 0.5))
  serverName:setPosition(ccp(32, -60))
  roleNode:addChild(serverName)
  self:btRegisterButtonClick({
    button = roleUI.head,
    press = roleUI.head_press,
    key = "head" .. index,
    clickHandler = function()
      self:roleNodeTouch(oneData)
    end,
    force = true,
    mcpMode = true,
    clickInterval = 1,
    pressScale = 0.95
  })
  self.roleDraglist:addItem(roleNode)
end

function BindAccount:roleNodeTouch()
  if self.selectUin then
    local curAccount = sBindAccountMgr.getInstance():getAccountByUin(self.selectUin)
    if curAccount.bind_status ~= "bind_status_none" then
      ed.showToast(T("\230\138\177\230\173\137\239\188\140\232\175\165\232\180\166\229\143\183\229\143\175\232\131\189\231\148\177\228\186\142\229\183\178\231\187\145\229\174\154\230\150\176\231\154\132\232\142\137\232\142\137\228\184\157\232\180\166\229\143\183\230\136\150\229\133\182\228\187\150\229\142\159\229\155\160\230\151\160\230\179\149\232\191\155\232\161\140\231\187\145\229\174\154\230\150\176\232\180\166\229\143\183\229\138\159\232\131\189\239\188\129"))
      return
    end
    BindAccountMgr.getInstance():setSelectedUin(self.selectUin)
    EDSDKLogin()
  end
end

function BindAccount:registerHandler()
  self:btRegisterHandler({
    handler = self.accDraglist:getListLayerTouchHandler()
  })
  self:btRegisterHandler({
    handler = self.roleDraglist:getListLayerTouchHandler()
  })
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.HelpBtn,
    press = ui.HelpBtn_press,
    key = "HelpBtn",
    clickHandler = function()
      self:onDestory()
    end,
    force = true,
    mcpMode = true,
    clickInterval = 0.5,
    priority = -1
  })
  self:btRegisterButtonClick({
    button = ui.HideBg,
    press = ui.HideBg_press,
    key = "HideBg",
    clickHandler = function()
      self:onHideOneLv()
    end,
    force = true,
    mcpMode = true,
    clickInterval = 0.5,
    priority = -1
  })
end

function BindAccount:onHideOneLv()
  self.ui.HideImg:setVisible(not self.ui.HideImg:isVisible())
  self.roleDraglist:clearList()
  local data = {}
  if self.ui.HideImg:isVisible() then
    for _, v in pairs(self.roleData) do
      if v.level > 1 then
        table.insert(data, v)
      end
    end
  else
    data = self.roleData
  end
  self:initRoleList(data)
end

function BindAccount:registerListenEvents()
  ListenEvent("IDFABindReply", function()
    self:updateRoleInfo()
  end, BindAccountScope)
end
