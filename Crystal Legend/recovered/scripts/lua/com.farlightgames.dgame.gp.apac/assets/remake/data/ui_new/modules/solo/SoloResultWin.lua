local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.SoloResultWin = class

function class.create(data)
  local self = base.create("SoloResultWin")
  setmetatable(self, class.mt)
  self:initData(data)
  self:initUI()
  self:registerEvents()
  self:popWindow()
  self:show()
  return self
end

function class:initData(data)
  self.data = data
end

function class:initUI()
  ed.editorui(ed.uieditor.SoloResultWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  local isWin = self.data._is_win == 1
  local flag = isWin and "+" or "-"
  if not isWin then
    self.ui.ImageView_547:setVisible(true)
    self.ui.ImageView_13082:setVisible(false)
    local txt = ed.ui.gradientLabel.create({
      text = string.format("\231\172\172%d\229\144\141", self.data._settle._rank),
      strokeSize = 1.5,
      fontSize = 25,
      startColor = ed.toccc3(15390102),
      endColor = ed.toccc3(13077846),
      strokeColor = ed.toccc3(5708571)
    })
    ed.UITool.replaceUINew(self.ui, "Label_13085", txt.node)
    ed.setLabelColor(self.ui.Label_13090, ed.toccc3(16739436))
  else
    local txt = ed.ui.gradientLabel.create({
      text = string.format("\231\172\172%d\229\144\141", self.data._settle._rank),
      strokeSize = 1.5,
      fontSize = 25,
      startColor = ed.toccc3(16774825),
      endColor = ed.toccc3(16770656),
      strokeColor = ed.toccc3(5708571)
    })
    ed.UITool.replaceUINew(self.ui, "Label_13085", txt.node)
    ed.setLabelColor(self.ui.Label_13090, ed.toccc3(7405396))
  end
  local name = ed.player:getName()
  if name == "" then
    name = "NickName"
  end
  ed.setString(self.ui.Label_13088, name)
  ed.setString(self.ui.Label_13089, string.format("\231\167\175\229\136\134\239\188\154%d", self.data._old_score))
  if self.data._base_score > 0 then
    ed.setString(self.ui.Label_13090, flag .. math.abs(self.data._base_score))
  else
    ed.setString(self.ui.Label_13090, "")
  end
  ed.right2(self.ui.Label_13090, self.ui.Label_13089)
  local heroId = self.data._settle._user_summary._hero_id
  local icon = ed.readhero.createSoloUnitIcon({id = heroId}).icon
  self.ui.Panel_549:addChild(icon)
end

function class:initLabels()
  ed.setLabelStroke(self.ui.Label_13085, ed.toccc3(2891270), 1)
  ed.setLabelStroke(self.ui.Label_13089, ed.toccc3(2891270), 1)
  ed.setLabelStroke(self.ui.Label_13090, ed.toccc3(2891270), 1)
  ed.setLabelStroke(self.ui.Label_13088, ed.toccc3(2891270), 1)
end

function class:registerEvents()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "click_out",
    clickHandler = function()
      self:destroy()
    end
  })
end
