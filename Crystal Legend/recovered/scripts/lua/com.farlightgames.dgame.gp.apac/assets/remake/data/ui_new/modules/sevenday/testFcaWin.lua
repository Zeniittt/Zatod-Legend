local base = ed.ui.popwindow
local testFcaWin = newclass(base.mt)
ed.ui.testFcaWin = testFcaWin
local tb = {
  {},
  {},
  {},
  {}
}

local function getSubDirs(path)
  local pfile = io.popen("dir \"" .. path .. "\" /AD /B")
  for filename in pfile:lines() do
    if string.find(filename, "^eff_tile") then
      table.insert(tb[1], filename)
    elseif string.find(filename, "^eff_buff") then
      table.insert(tb[2], filename)
    elseif string.find(filename, "^eff_impact") then
      table.insert(tb[3], filename)
    else
      table.insert(tb[4], filename)
    end
  end
end

local dirPath = "fca/effect/"

function testFcaWin.create(param)
  local self = base.create("testFcaWin")
  setmetatable(self, testFcaWin.mt)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  return self
end

function testFcaWin:refreshUI()
  self.ui.Panel_1323:removeAllChildrenWithCleanup(true)
  ed.setString(self.ui.Label_1322, "Page: " .. self.curPage + 1 .. "/" .. math.ceil(#tb[self.type] / 28))
  
  local function getPos(i)
    local row = math.floor((i - 1) / 7) + 1
    local col = i - (row - 1) * 7
    return ccp(col * 140 - 70, row * 100 - 30)
  end
  
  local s = self.curPage
  local k = 1
  for i = s * 28 + 1, s * 28 + 28 do
    local name = tb[self.type][i]
    if name then
      local fca = ed.createFcaNode(name)
      fca:setLoop(true)
      self.ui.Panel_1323:addChild(fca)
      self:addFca(fca)
      fca:setPosition(getPos(k))
      ed.createLabelTools({
        txt = name,
        size = 10,
        pos = ccp(0, -20),
        color = ed.toccc3(16776423),
        parent = fca
      })
      k = k + 1
    end
  end
end

function testFcaWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.TestFcaWin, {
    container = self.container,
    ui = self.ui
  })
  getSubDirs(dirPath)
  self.curPage = 0
  self.type = 1
  self:refreshUI()
end

function testFcaWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "ImageView_1318", function()
    if self.curPage > 0 then
      self.curPage = self.curPage - 1
      self:refreshUI()
    end
  end)
  ed.UITool.registerBtn(self, "ImageView_1318_Copy0", function()
    self.curPage = self.curPage + 1
    self:refreshUI()
  end)
  ed.UITool.registerBtn(self, "ImageView_1318_Copy1", function()
    self.curPage = 0
    self.type = 2
    self:refreshUI()
  end)
  ed.UITool.registerBtn(self, "ImageView_1318_Copy2", function()
    self.curPage = 0
    self.type = 1
    self:refreshUI()
  end)
  ed.UITool.registerBtn(self, "ImageView_1318_Copy3", function()
    self.curPage = 0
    self.type = 3
    self:refreshUI()
  end)
  ed.UITool.registerBtn(self, "ImageView_1318_Copy4", function()
    self.curPage = 0
    self.type = 4
    self:refreshUI()
  end)
  ed.UITool.registerBtn(self, "ImageView_1318_Copy5", function()
    self:refreshUI()
  end)
end
