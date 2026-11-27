local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.fireForgeBuffTipsWindow = class
ed.UITool.registViewOpenFunc("fireForgeBuffTipsWindow", function()
  ed.ui.fireForgeBuffTipsWindow.create():popWindow()
end)

function class.create()
  local self = base.create("fireForgeBuffTipsWindow", {noShade = true})
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self.mgr = ed.legendEquipMgr.getInstance()
  self:initView()
  self:addTouchEvent()
end

function class:initView()
  local bg = ed.createSprite()
  bg:setContentSize(CCSizeMake(428.61, 187.79999999999998))
  local container, ui = ed.editorui(ed.uieditor.fire_forge_buff_tips_window)
  self.container:addChild(bg)
  bg:addChild(container)
  ed.layout.centerInParent(container)
  self.bg = bg
  self.ui = ui
  ed.setLabelStroke(self.ui.label_desc_1, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.label_tips, ccc3(0, 0, 0), 1)
  local bgSize = self.ui.panel_desc:getContentSize()
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = string.format(T("\229\137\141<lable color=ccc3(255,250,109) fontSize=f16>%s</lable>\230\172\161\233\148\187\233\128\160\229\134\133\229\191\133\229\174\154\228\188\154\229\135\186\231\130\137\228\184\128\228\187\182<lable color=ccc3(255,250,109) fontSize=f16>\229\148\175\228\184\128\232\163\133\229\164\135</lable>\230\149\180\232\163\133(\229\189\147\229\137\141\229\183\178\233\148\187\233\128\160:<lable color=ccc3(255,250,109) fontSize=f16>%s</lable>\230\172\161)"), ed.legendEquipDefine.Forge_Buff_Times, self.mgr:getFirstOnlyTimes()),
    maxWidth = bgSize.width,
    fontSize = 16,
    color = ed.toccc3(16773059),
    strokeColor = ed.toccc3(4854547),
    strokeSize = 1
  })
  self.ui.panel_desc:addChild(autoText.node)
  local w, h = autoText:getCurContentSize()
  autoText.node:setPosition(ccp(bgSize.width / 2 - w / 2, bgSize.height / 2 + h / 2 - 8))
end

function class:addTouchEvent()
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "clickOut",
    clickHandler = function()
      self:destroy({skipAnim = true})
    end,
    force = true
  })
end
