local base = ed.ui.commonscene
local GuildClashPrepareScene = newclass(base.mt)
ed.ui.GuildClashPrepareScene = GuildClashPrepareScene

function GuildClashPrepareScene:initData()
  self.mgr = ed.GuildClashManager
end

function GuildClashPrepareScene:adaptUI()
end

function GuildClashPrepareScene:initLabels()
end

function GuildClashPrepareScene:refreshUI()
  local state = self.mgr:getCurState()
  state = "grade_show"
  if state == "preview" then
    self.ui.layer_1:setVisible(true)
    self.ui.layer_2:setVisible(false)
    self.ui.layer_3:setVisible(false)
  elseif state == "grading" then
    self.ui.layer_1:setVisible(false)
    self.ui.layer_2:setVisible(true)
    self.ui.layer_3:setVisible(false)
  elseif state == "grade_show" then
    self.ui.layer_1:setVisible(false)
    self.ui.layer_2:setVisible(false)
    self.ui.layer_3:setVisible(true)
  end
end

function GuildClashPrepareScene:initUI()
  local container, ui = ed.editorui(ed.uieditor.GuildClashPrepareScene)
  self.ui = ui
  self.mainLayer:addChild(container)
  self:setBackButton()
  self:adaptUI()
  self:initLabels()
  self:refreshUI()
end

function GuildClashPrepareScene:registerTouchHandlers()
end

function GuildClashPrepareScene:registerEvents()
  ed.UITool.registerBtn(self, "btn_rule", function()
    ed.ui.commonRulePop.create({
      title = T("\232\167\132\229\136\153\232\175\180\230\152\142"),
      txt = ed.GuildClashDefine.RULES_TEXT
    }):popWindow()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_reward", function()
    ed.showToast("\229\165\150\229\138\177\233\161\181\233\157\162")
  end, {pressScale = 0.75, normalScale = 0.8})
  ed.UITool.registerBtn(self, "btn_book", function()
    ed.showToast("\231\142\169\230\179\149\233\161\181\233\157\162")
  end, {pressScale = 0.75, normalScale = 0.8})
  ed.UITool.registerBtn(self, "btn_shop", function()
    ed.showToast("\229\149\134\229\186\151\233\161\181\233\157\162")
  end, {pressScale = 0.75, normalScale = 0.8})
  ed.UITool.registerBtn(self, "btn_active", function()
    ed.showToast("\230\159\165\231\156\139\229\144\132\228\184\170\230\136\144\229\145\152")
  end, {pressScale = 0.75, normalScale = 0.8})
  ed.UITool.registerBtn(self, "btn_go", function()
    ed.pushScene(ed.ui.stageselect.createByStage(1))
  end, {pressScale = 0.75, normalScale = 0.8})
end

function GuildClashPrepareScene.create()
  local self = base.create("GuildClashPrepareScene", {noBottomButton = true})
  setmetatable(self, GuildClashPrepareScene.mt)
  self:initData()
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  return self
end
