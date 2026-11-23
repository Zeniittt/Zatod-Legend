local base = ed.ui.popwindow
local SoloRankPop = newclass(base.mt)
ed.ui.SoloRankPop = SoloRankPop
local CNName = {
  T("\228\184\128"),
  T("\228\186\140"),
  T("\228\184\137"),
  T("\229\155\155"),
  T("\228\186\148"),
  T("\229\133\173"),
  T("\228\184\131"),
  T("\229\133\171")
}

function SoloRankPop:initUI()
  ed.editorui(ed.uieditor.SoloRankPop, {
    container = self.container,
    ui = self.ui
  })
  self.ui.ImageView_521:setZOrder(-1)
  self.ui.ImageView_521:runAction(CCRepeatForever:create(CCRotateBy:create(3.7, 360)))
  local str = string.format(T("\231\172\172%s\229\144\141"), CNName[self.rank])
  if self.rank == 1 then
    local txt = ed.ui.gradientLabel.create({
      text = str,
      fontSize = 42,
      startColor = ed.toccc3(16763463),
      endColor = ed.toccc3(16578238),
      strokeColor = ed.toccc3(9123841),
      strokeSize = 2.5
    })
    ed.UITool.replaceUINew(self.ui, "Label_523", txt.node)
  elseif self.rank <= 4 then
    local txt = ed.ui.gradientLabel.create({
      text = str,
      fontSize = 42,
      startColor = ed.toccc3(16763463),
      endColor = ed.toccc3(16578238),
      strokeColor = ed.toccc3(9123841),
      strokeSize = 2.5
    })
    ed.UITool.replaceUINew(self.ui, "Label_523", txt.node)
    self.ui.Panel_524:setVisible(false)
  else
    local txt = ed.ui.gradientLabel.create({
      text = str,
      fontSize = 42,
      startColor = ed.toccc3(9813981),
      endColor = ed.toccc3(14808319),
      strokeColor = ed.toccc3(3162707),
      strokeSize = 2.5
    })
    ed.UITool.replaceUINew(self.ui, "Label_523", txt.node)
    self.ui.Panel_524:setVisible(false)
    ed.setTexture(self.ui.bg, "UI/alpha/1080P/chesscard/newrank/lose_1.png")
    ed.setTexture(self.ui.ImageView_521, "UI/alpha/1080P/chesscard/newrank/lose_3.png")
    ed.setTexture(self.ui.ImageView_522, "UI/alpha/1080P/chesscard/newrank/lose_2.png")
  end
end

function SoloRankPop.create(rank)
  local self = base.create("SoloRankPop", {notBlurBg = true, noShade = true})
  setmetatable(self, SoloRankPop.mt)
  self.rank = rank or 1
  self:initUI()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "rank_pop_destroy",
    clickHandler = function()
      self:destroy()
    end
  })
  self:listenEvent("EventCloseOtherWin", function()
    base.destroy(self, {skipAnim = true})
  end)
  self:popWindow()
  self:show()
  return self
end
