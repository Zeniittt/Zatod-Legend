local class = newclass("g")
ed.ui.debugLogList = class
class.floatingWindow = nil

function class.open()
  if not class.floatingWindow then
    class.floatingWindow = class.create()
  end
end

function class.close()
  if class.floatingWindow then
    class.floatingWindow:close()
  end
end

function class.create()
  local self = {}
  setmetatable(self, {__index = class})
  self:init()
  return self
end

function class:init()
  self.isHide = false
  self.logList = {}
  self.inputString = ""
  self:initUI()
  self:addTouchEvent()
  self.oldPrint = print
  
  function print(...)
    self.oldPrint(...)
    self:printLog(...)
  end
end

function class:initUI()
  local touchNode = ed.ui.basetouchnode.btCreate()
  self.touchNode = touchNode
  local container = ed.getCurrentScene():getTopNode()
  local mainLayer = CCLayerColor:create(ccc4(0, 0, 0, 0))
  mainLayer:registerScriptTouchHandler(touchNode:btGetMainTouchHandler(), false, -300, false)
  mainLayer:setTouchEnabled(true)
  self.size = CCSizeMake(300, ed.display.winSize.height)
  mainLayer:setContentSize(self.size)
  self.mainLayer = mainLayer
  self.mainLayerSize = mainLayer:getContentSize()
  container:addChild(mainLayer)
  local btnClose = ed.createSprite("UI/alpha/1080P/common/btn_back.png")
  self.btnClose = btnClose
  self.mainLayer:addChild(btnClose)
  btnClose:setPosition(ccp(30, 30))
  local btnHide = ed.createSprite("UI/alpha/1080P/common/break_butt.png")
  self.btnHide = btnHide
  self.mainLayer:addChild(btnHide)
  btnHide:setPosition(ccp(30, 70))
  local btnCopy = ed.createSprite("UI/alpha/1080P/common/button_com_mini.png")
  local labelCopy = ed.createLabelTTF(T("\229\164\141\229\136\182"), 18)
  btnCopy:addChild(labelCopy)
  ed.layout.centerInParent(labelCopy)
  btnCopy:setScale(0.5)
  self.btnCopy = btnCopy
  self.mainLayer:addChild(btnCopy)
  btnCopy:setPosition(ccp(80, 30))
  local btnClean = ed.createSprite("UI/alpha/1080P/common/button_com_mini.png")
  local labelClean = ed.createLabelTTF(T("\230\184\133\233\153\164\230\151\165\229\191\151"), 18)
  btnClean:addChild(labelClean)
  ed.layout.centerInParent(labelClean)
  btnClean:setScale(0.5)
  self.btnClean = btnClean
  self.mainLayer:addChild(btnClean)
  btnClean:setPosition(ccp(80, 70))
  local btnInput = ed.createSprite("UI/alpha/1080P/common/button_com_mini.png")
  local labelEdit = ed.createLabelTTF(T("\232\190\147\229\133\165"), 18)
  btnInput:addChild(labelEdit)
  ed.layout.centerInParent(labelEdit)
  btnInput:setScale(0.5)
  self.btnInput = btnInput
  self.mainLayer:addChild(btnInput)
  btnInput:setPosition(ccp(140, 30))
  local btnCleanInput = ed.createSprite("UI/alpha/1080P/common/button_com_mini.png")
  local labelCleanInput = ed.createLabelTTF(T("\230\184\133\233\153\164\232\190\147\229\133\165"), 18)
  btnCleanInput:addChild(labelCleanInput)
  ed.layout.centerInParent(labelCleanInput)
  btnCleanInput:setScale(0.5)
  self.btnCleanInput = btnCleanInput
  self.mainLayer:addChild(btnCleanInput)
  btnCleanInput:setPosition(ccp(140, 70))
  local btnLoadStr = ed.createSprite("UI/alpha/1080P/common/button_com_mini.png")
  local labelLoadStr = ed.createLabelTTF(T("\230\137\167\232\161\140"), 18)
  btnLoadStr:addChild(labelLoadStr)
  ed.layout.centerInParent(labelLoadStr)
  btnLoadStr:setScale(0.5)
  self.btnLoadStr = btnLoadStr
  self.mainLayer:addChild(btnLoadStr)
  btnLoadStr:setPosition(ccp(200, 30))
  self:createEditPanel()
  self:createLogPanel()
end

function class:printLog(...)
  local n = select("#", ...)
  local tb = {}
  local dbg = debug.getinfo(3)
  local path = string.split(dbg.source, "/")
  local detais = "[" .. path[#path] .. "#Line:" .. dbg.currentline .. "]"
  table.insert(tb, detais)
  for i = 1, n do
    local v = select(i, ...)
    local str = serialize(v)
    table.insert(tb, str)
  end
  local ret = table.concat(tb, "  ")
  table.insert(self.logList, ret)
  local label = ed.createLabelTTF(ret, 18)
  label:setColor(ccc3(255, 252, 231))
  label:setStroke(ccc3(0, 0, 0), 1)
  label:setDimensions(CCSizeMake(self.logPanelSize.width, 0))
  label:setHorizontalAlignment(kCCTextAlignmentLeft)
  self.dragList:addItem(label)
  local size = label:getContentSize()
  label:setAnchorPoint(ccp(0, 1))
  label:setPosition(ccp(0, self.logPanelSize.height - self.posY))
  self.posY = self.posY + size.height
  self.dragList:initListHeight(self.posY)
  self.dragList:setListPos(ccp(0, self.posY - self.logPanelSize.height))
end

function class:refreshInputLabel()
  self.inputDragList:clearList()
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = self.inputString,
    color = ed.toccc3(16776423),
    strokeColor = ed.toccc3(0),
    strokeSize = 1,
    maxWidth = self.inputPanel:getContentSize().width,
    fontSize = 18
  })
  local w, h = autoText:getCurContentSize()
  self.inputDragList:addItem(autoText.node)
  self.inputDragList:initListHeight(h)
  autoText.node:setPosition(ccp(0, self.inputPanel:getContentSize().height - 9))
end

function class:createLogPanel()
  local logPanel = CCLayerColor:create(ccc4(0, 0, 0, 0))
  self.logPanelSize = CCSizeMake(300, self.size.height - 80)
  logPanel:setContentSize(self.logPanelSize)
  logPanel:setPosition(ccp(0, 80))
  self.mainLayer:addChild(logPanel)
  self.logPanel = logPanel
  self.posY = 0
  self.dragList = ed.UITool.createDraglist(logPanel)
end

function class:createEditPanel()
  local inputPanel = CCLayerColor:create(ccc4(0, 0, 0, 0))
  local inputPanelSize = CCSizeMake(300, self.size.height - 80)
  inputPanel:setContentSize(inputPanelSize)
  inputPanel:setPosition(ccp(300, 80))
  self.mainLayer:addChild(inputPanel)
  self.inputPanel = inputPanel
  self.inputDragList = ed.UITool.createDraglist(inputPanel)
  local info = {
    config = {
      editSize = inputPanel:getContentSize(),
      maxLength = 9999,
      fontColor = ccc3(255, 252, 231),
      fontSize = 18
    }
  }
  local editBox = editBox:new(info)
  inputPanel:addChild(editBox.edit)
  editBox.edit:setVisible(false)
  self.editBox = editBox
  editBox.edit:registerScriptEditBoxHandler(function(event)
    if event == "began" then
    elseif event == "return" then
      self.inputString = self.inputString .. editBox.edit:getText()
      self:refreshInputLabel()
      editBox.edit:setText("")
    elseif event == "ended" then
    end
  end)
end

function class:onClickBtnHide()
  self.isHide = not self.isHide
  if self.isHide then
    self.inputPanel:setVisible(false)
    self.logPanel:setVisible(false)
  else
    self.inputPanel:setVisible(true)
    self.logPanel:setVisible(true)
  end
end

function class:onClickBtnCopy()
  local copyStr = ""
  for index, str in ipairs(self.logList) do
    copyStr = copyStr .. str
  end
  ed.copyString(copyStr)
end

function class:onClickBtnClean()
  self.logList = {}
  self.dragList:clearList()
end

function class:onClickBtnInput()
  self.editBox.edit:openKeyBoard()
end

function class:onClickBtnCleanInput()
  self.inputString = ""
  self:refreshInputLabel()
end

function class:onClickBtnLoadStr()
  if self.inputString ~= "" then
    local func, err = loadstring(self.inputString)
    if type(func) == "function" then
      func()
    end
  end
end

function class:addTouchEvent()
  self.touchNode:btRegisterButtonClick({
    button = self.btnClose,
    key = "btn_close",
    clickHandler = function()
      self:close()
    end,
    pressScale = 0.95
  })
  self.touchNode:btRegisterButtonClick({
    button = self.btnHide,
    key = "btn_hide",
    clickHandler = function()
      self:onClickBtnHide()
    end,
    pressScale = 0.95
  })
  self.touchNode:btRegisterButtonClick({
    button = self.btnCopy,
    key = "btn_copy",
    clickHandler = function()
      self:onClickBtnCopy()
    end,
    pressScale = 0.45,
    normalScale = 0.5
  })
  self.touchNode:btRegisterButtonClick({
    button = self.btnClean,
    key = "btn_clean",
    clickHandler = function()
      self:onClickBtnClean()
    end,
    normalScale = 0.5,
    pressScale = 0.45
  })
  self.touchNode:btRegisterButtonClick({
    button = self.btnInput,
    key = "btn_input",
    clickHandler = function()
      self:onClickBtnInput()
    end,
    normalScale = 0.5,
    pressScale = 0.45
  })
  self.touchNode:btRegisterButtonClick({
    button = self.btnCleanInput,
    key = "btn_clean_input",
    clickHandler = function()
      self:onClickBtnCleanInput()
    end,
    normalScale = 0.5,
    pressScale = 0.45
  })
  self.touchNode:btRegisterButtonClick({
    button = self.btnLoadStr,
    key = "btn_load_str",
    clickHandler = function()
      self:onClickBtnLoadStr()
    end,
    normalScale = 0.5,
    pressScale = 0.45
  })
end

function class:close()
  print = self.oldPrint
  class.floatingWindow = nil
  self.mainLayer:removeFromParentAndCleanup(true)
end
