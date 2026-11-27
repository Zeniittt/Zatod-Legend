local base = ed.ui.popwindow
local testShaderWin = newclass(base.mt)
ed.ui.testShaderWin = testShaderWin
local GuildMailScope = {}

function testShaderWin.create(param)
  local self = base.create("testShaderWin", {noShade = true})
  setmetatable(self, testShaderWin.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function testShaderWin:initData()
  self.H = 0
  self.S = 0
  self.V = 0
  self.perH = 0.05
  self.perS = 0.1
  self.perV = 0.1
  EDLoadShader("HSVtoRGBShaderV2")
end

function testShaderWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.testShaderWin, {
    container = self.container,
    ui = self.ui
  })
  local bg = ed.createSprite("UI/tilemap/test_bg.png")
  bg:setPosition(ed.display.center)
  self.mainLayer:addChild(bg, -1)
  local fireworks = ed.readhero.getActor(371, "Idle", true, false, 0, false)
  fireworks:setAction("Idle")
  fireworks:setLoop(true)
  self:addFca(fireworks)
  fireworks:setPosition(ccp(600, 150))
  self.mainLayer:addChild(fireworks, 999)
  self.puppet = fireworks
  ed.useShader(self.puppet, "HSVtoRGBShaderV2")
  local shader = CCShaderCache:sharedShaderCache():programForKey("HSVtoRGBShaderV2")
  local location = shader:getUniformLocationForName("HSV")
  shader:setUniformsForBuiltins()
  shader:setUniformLocationWith4f(location, self.H, self.S, self.V, 1)
  self:refreshUI()
end

function testShaderWin:refreshUI()
  ed.useShader(self.puppet, "HSVtoRGBShaderV2")
  local shader = CCShaderCache:sharedShaderCache():programForKey("HSVtoRGBShaderV2")
  local location = shader:getUniformLocationForName("HSV")
  shader:setUniformsForBuiltins()
  shader:setUniformLocationWith4f(location, self.H, self.S, self.V, 1)
  ed.setString(self.ui.label_H, string.format("H\232\137\178\232\176\131:%f", self.H))
  ed.setString(self.ui.label_S, string.format("S\233\165\177\229\146\140\229\186\166:%f", self.S))
  ed.setString(self.ui.label_V, string.format("V\228\186\174\229\186\166:%f", self.V))
end

function testShaderWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "subH", function()
    self.H = self.H - self.perH
    self:refreshUI()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "addH", function()
    self.H = self.H + self.perH
    self:refreshUI()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "subS", function()
    self.S = self.S - self.perS
    self:refreshUI()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "addS", function()
    self.S = self.S + self.perS
    self:refreshUI()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "subV", function()
    self.V = self.V - self.perV
    self:refreshUI()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "addV", function()
    self.V = self.V + self.perV
    self:refreshUI()
  end, {pressScale = 0.95})
end
