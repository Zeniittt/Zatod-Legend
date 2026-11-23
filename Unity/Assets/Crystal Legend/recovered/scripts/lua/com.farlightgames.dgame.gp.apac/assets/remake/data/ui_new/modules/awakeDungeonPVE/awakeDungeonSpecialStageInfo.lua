local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.awakeDungeonSpecialStageInfo = class
ed.UITool.registViewOpenFunc("awakeDungeonSpecialStageInfo", function(param)
  local panel = class.create(param)
  panel:popWindow()
end)

function class.create(param)
  local self = base.create("awakeDungeonSpecialStageInfo")
  setmetatable(self, class.mt)
  self:init(param)
  self:show()
  return self
end

function class:init(param)
  self.param = param or {}
  self.stageId = param.stageId
  self:initView()
  self:addTouchEvent()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.awakeDungeonSpecialStageInfo)
  self.ui = ui
  self.container:addChild(container)
  local stageTableItem = ed.getDataTable("DungeonStage")[self.stageId]
  ed.setLabelString(self.ui.stage_desc, stageTableItem.Description)
  ed.setLabelDimensions(self.ui.stage_desc, CCSizeMake(550, 0))
end

function class:addTouchEvent()
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = true})
    end,
    force = true
  })
end
