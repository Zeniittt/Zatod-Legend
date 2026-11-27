local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.SoloTestWin = class

function class:initData(mainPanel)
  self.mainPanel = mainPanel
end

function class:initUI()
  ed.editorui(ed.uieditor.SoloTestWin, {
    container = self.container,
    ui = self.ui
  })
end

function class:registerEvents()
  ed.UITool.registerBtn(self, "ImageView_6292", function()
    ReloadModule("ui_new/modules/solo/SoloTestData")
    ed.SoloBattleTest(self.mainPanel)
  end)
  ed.UITool.registerBtn(self, "ImageView_6292_Copy0", function()
    ReloadModule("ui_new/modules/solo/SoloShopWindow")
    FireEvent("EventSoloBattleCheckEnd", -1)
  end)
end

function class:SoloJumpBattle()
  local transFca = ed.createFcaNode("eff_UI_transition_smoke")
  self:addFca(transFca)
  self.mainLayer:addChild(transFca, 999)
  ed.layout.centerInScreen(transFca)
  local ticks = ed.engine.ticks
  ed.SoloModel:resetBattleDataList(2, 2)
  self.mainPanel.dataPanel:onBattleStart()
  ed.engine:clearAllSoloUnits()
  ed.engine.ticks = 0
  ed.engine.time_limit = 60
  ed.engine:onPrepareJoinBattle({
    hero = {
      _hid = 2,
      _powers = {}
    },
    camp = -1,
    params = {
      _cards = {},
      _card_factions = {}
    }
  })
  ed.engine:onPrepareJoinBattle({
    camp = 1,
    hero = {
      _hid = 2,
      _powers = {}
    },
    params = {
      _cards = {},
      _card_factions = {}
    }
  })
  ed.engine.canTick = true
  ed.engine:jumpToTick(ticks)
end

function class.create(mainPanel)
  local self = base.create("SoloTestWin", {
    notBlurBg = true,
    noShade = true,
    priority = -999,
    swallow = false
  })
  setmetatable(self, class.mt)
  self:initData(mainPanel)
  self:initUI()
  self:registerEvents()
  return self
end
