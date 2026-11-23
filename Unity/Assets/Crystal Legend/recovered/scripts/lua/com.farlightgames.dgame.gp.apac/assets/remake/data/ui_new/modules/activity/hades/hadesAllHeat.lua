local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.hadesAllHeatWin = class
local GROUP_ID_TO_CONFIG = {
  [1] = {
    title = T("\229\165\145\231\186\166\230\157\161\228\187\182")
  },
  [2] = {
    title = T("\229\172\137\230\136\143\230\157\161\228\187\182")
  }
}
class.GROUP_ID_TO_CONFIG = GROUP_ID_TO_CONFIG

function class.create(param)
  local self = base.create("hadesAllHeatWin", {noShade = true, notBlurBg = true})
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.chooseHeat = param.chooseHeat or {}
  self.groupId = param.groupId or 1
  self:initUI()
  self:refreshUI()
  self:addTouchEvent()
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.hades_all_heat)
  self.container:addChild(container)
  self.ui = ui
  ed.setLabelStroke(self.ui.label_empty_tips, ed.toccc3(2565412), 1)
  local titleText = GROUP_ID_TO_CONFIG[self.groupId] and GROUP_ID_TO_CONFIG[self.groupId].title or T("\229\165\145\231\186\166\230\157\161\228\187\182")
  ed.setLabelString(self.ui.label_title, titleText)
  self:initDragList()
end

function class:initDragList()
  local size = self.ui.list_layer:getContentSize()
  self.dragList = ed.UITool.createDraglist(self.ui.list_layer, {
    bar = {
      bglen = size.height,
      bgpos = ccp(size.width - 1, size.height / 2),
      barres = "UI/alpha/1080P/hades/hades_prepare_slide.png",
      bgres = "UI/alpha/1080P/hades/hades_prepare_slide_bg.png",
      alwaysShow = false
    }
  })
end

function class:refreshUI()
  self.ui.label_empty_tips:setVisible(#self.chooseHeat <= 0)
  self:refreshDragList()
end

function class:refreshDragList()
  table.sort(self.chooseHeat, ed.cmpSort({
    {key = "_heat_id"}
  }))
  self.dragList:clearList()
  local posY, gapY = 0, 5
  local layerSize = self.ui.list_layer:getContentSize()
  for _, heatData in ipairs(self.chooseHeat or {}) do
    local option, itemSize = self:createHeatItem(heatData._heat_id, heatData._times)
    self.dragList:addItem(option)
    option:setPosition(ccp(20, layerSize.height - (posY + gapY) - 10))
    posY = posY + itemSize.height + gapY
  end
  self.dragList:initListHeight(posY)
end

function class:createHeatItem(heatId, level)
  local autoText = ed.ui.autoText.new()
  local heatCfg = ed.getDataTable("Heat")[heatId]
  local frontDesc = heatCfg.FrontDescription
  local heatValue = heatCfg.HeatValue1
  local scriptArg = heatCfg.ScriptArg1
  local parameter = heatCfg.Parameter
  local desc
  if level then
    desc = frontDesc .. "\239\188\154" .. string.format("<lable color=ccc3(232,177,82) strokeColor=ccc3(39,37,36), strokeSize=1>%s</lable>", scriptArg * level .. (parameter or ""))
  else
    desc = frontDesc
  end
  if scriptArg then
    desc = string.gsub(desc, "%%ScriptArg&1%%", string.format("<lable color=ccc3(255,87,87) strokeColor=ccc3(65,35,29), strokeSize=1>%s</lable>", scriptArg))
  end
  desc = string.gsub(desc, "%%HeatValue&1%%", string.format("<lable color=ccc3(255,87,87) strokeColor=ccc3(65,35,29), strokeSize=1>%s</lable>", heatValue))
  desc = string.gsub(desc, "#p#", "%%")
  autoText:initParam({
    context = desc,
    color = ed.toccc3(16776423),
    strokeColor = ed.toccc3(2565412),
    strokeSize = 1,
    maxWidth = 360,
    fontSize = 18
  })
  local imageRivet = ed.createSprite("UI/alpha/1080P/common/rivet_big.png")
  imageRivet:addChild(autoText.node)
  autoText.node:setPosition(ccp(20, 5))
  local autoTextW, autoTextH = autoText:getCurContentSize()
  local itemSize = CCSizeMake(autoTextW, autoTextH)
  return imageRivet, itemSize
end

function class:addTouchEvent()
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event == "began" then
        if ed.containsPoint(self.ui.image_bg, x, y) then
          self.clickInList = true
        else
          self.clickInList = false
        end
      elseif event == "ended" and not ed.containsPoint(self.ui.image_bg, x, y) and not self.clickInList then
        self:destroy({skipAnim = true})
        return false
      end
      return false
    end,
    key = "close"
  })
end
