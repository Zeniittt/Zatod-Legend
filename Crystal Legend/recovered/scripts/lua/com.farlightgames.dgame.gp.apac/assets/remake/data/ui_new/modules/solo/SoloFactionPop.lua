local base = ed.ui.popwindow
local SoloFactionPop = newclass(base.mt)
ed.ui.SoloFactionPop = SoloFactionPop

function SoloFactionPop:getFactionAutoText(id)
  local cardTag = ed.getDataTable("SoloCardTag")[id]
  local str = cardTag.Description or ""
  local tmpStr = str
  local args = {}
  
  local function insertTrueValue(paramName)
    local params = cardTag[paramName]
    for k, v in ipairs(params) do
      table.insert(args, v)
    end
  end
  
  while true do
    local pos1, pos2 = string.find(tmpStr, "%%CardTag&.-%%")
    if pos1 == nil then
      break
    else
      local paramName = string.sub(tmpStr, pos1 + 9, pos2 - 1)
      insertTrueValue(paramName)
      tmpStr = string.sub(tmpStr, pos2 + 1)
    end
  end
  str = string.gsub(str, "%%CardTag&.-%%", "<lable color=headlineYellow>%%s/%%s/%%s/%%s</lable>")
  if 0 < #args then
    str = string.format(str, unpack(args))
  end
  str = string.gsub(str, "#p#", "%%")
  return str
end

function SoloFactionPop:initUI()
  ed.editorui(ed.uieditor.SoloFactionPop, {
    container = self.container,
    ui = self.ui
  })
  local tbData = ed.getDataTable("SoloCardTag")[self.factionId]
  ed.setTextureV2(self.ui.ImageView_1807, tbData["Tag Icon"])
  ed.setString(self.ui.Label_588, tbData.Name)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = self:getFactionAutoText(self.factionId),
    color = ed.toccc3(16710887),
    fontSize = 14,
    lineSpacing = 1
  })
  ed.UITool.replaceUINew(self.ui, "Label_589_Copy0", autoText.node)
end

function SoloFactionPop:registerEvents()
  self:btRegisterOutClick({
    area = self.ui.bg,
    clickHandler = function()
      base.destroy(self, {skipAnim = true})
    end,
    priority = -1
  })
  self:listenEvent("EventCloseOtherWin", function()
    base.destroy(self, {skipAnim = true})
  end)
end

function SoloFactionPop:initData(param)
  self.factionId = param
end

function SoloFactionPop.create(fid)
  local self = base.create("SoloFactionPop", {
    notBlurBg = true,
    noShade = true,
    priority = -999,
    swallow = true
  })
  setmetatable(self, SoloFactionPop.mt)
  self:initData(fid)
  self:initUI()
  self:registerEvents()
  self:popWindow()
  return self
end
