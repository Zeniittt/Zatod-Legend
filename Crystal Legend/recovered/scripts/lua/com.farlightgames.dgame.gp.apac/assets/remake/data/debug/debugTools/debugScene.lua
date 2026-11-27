local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.debugScene = class
class.BTN_CONFIG = {
  {
    btn = "\230\151\165\229\191\151\229\183\165\229\133\183",
    handle = function()
      ed.ui.debugLogList.open()
    end
  },
  {
    btn = "shader\230\181\139\232\175\149\229\156\186\230\153\175",
    handle = function()
      ed.UITool.openView("debugShaderScene")
    end
  },
  {
    btn = "fca\229\183\165\229\133\183",
    handle = function()
      ReloadModule("debug/debugTools/effectPreviewScene")
      ed.UITool.openView("effectPreviewScene")
    end
  }
}
ed.UITool.registViewOpenFunc("debugScene", function()
  local scene = ed.ui.debugScene.create()
  ed.pushScene(scene)
end)

function class.create()
  local self = base.create("debugScene")
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self:initView()
end

function class:initView()
  self:setBackButton()
  self:initBtn()
end

function class:initBtn()
  local posX = 0
  for index, btnCfg in ipairs(class.BTN_CONFIG) do
    local btn = self:createBtn(btnCfg)
    self.mainLayer:addChild(btn)
    btn:setPosition(posX + 100, 400)
    posX = posX + 110
    self:btRegisterButtonClick({
      button = btn,
      key = index,
      pressScale = 0.98,
      clickHandler = function()
        btnCfg.handle()
      end
    })
  end
end

function class:createBtn(btnCfg)
  local bg = ed.createSprite("UI/alpha/1080P/common/button_com_mini.png")
  local label = ed.createLabelTTF(btnCfg.btn, 15)
  bg:addChild(label)
  ed.layout.centerInParent(label)
  return bg
end
