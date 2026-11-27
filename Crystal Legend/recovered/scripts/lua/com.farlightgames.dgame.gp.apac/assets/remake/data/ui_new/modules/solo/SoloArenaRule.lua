local base = ed.ui.popwindow
local SoloArenaRule = newclass(base.mt)
ed.ui.SoloArenaRule = SoloArenaRule

function SoloArenaRule.create(params)
  local self = base.create("SoloArenaRule")
  setmetatable(self, SoloArenaRule.mt)
  self.params = params
  self.ui = {}
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ed.uieditor.SoloRuleWin)
  self:init()
  self:registerTouchHandler()
  self:show()
  return self
end

function SoloArenaRule:init()
  self.curPage = 1
  self.maxPage = 5
end

function SoloArenaRule:registerTouchHandler()
  self:listenEvent("EventCloseOtherWin", function()
    base.destroy(self, {skipAnim = true})
  end)
  local ui = self.ui
  self:btRegisterOutClick({
    area = ui.bg,
    key = "out_click",
    clickHandler = function()
      if self.notClose then
        return
      end
      if self.destroyBack then
        self.destroyBack()
      end
      self:destroy()
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.ImageView_2851,
    key = "arrow_left",
    clickHandler = function()
      self:movePageNewPos(-1)
    end,
    force = true
  })
  self:btRegisterButtonClick({
    button = self.ui.ImageView_2852,
    key = "arrow_right",
    clickHandler = function()
      self:movePageNewPos(1)
    end,
    force = true
  })
end

function SoloArenaRule:TouchHandler()
  local function handler(event, x, y)
    if event == "began" then
      self.newTouPosX = x
    elseif event == "ended" then
      local newX = self.newTouPosX - x
      self:movePageNewPos(math.abs(newX) > 100 and newX or false)
    elseif event == "moved" then
      local newX = x - self.newTouPosX
      for i = 1, #self.strPage do
        local posX, posY = self.pagePos[self.posIndex + i - 1].x + newX, self.pagePos[self.posIndex + i - 1].y
        self.ui["page_" .. i]:setPosition(posX, posY)
      end
    end
    return true
  end
  
  return handler
end

function SoloArenaRule:movePageNewPos(move)
  self.curPage = ed.clamp(self.curPage + move, 1, self.maxPage)
  ed.setTexture(self.ui.ImageView_2854, string.format("UI/alpha/1080P/chesscard/rule/%d.png", self.curPage))
  ed.setString(self.ui.Label_2853, string.format(T("%d/%d"), self.curPage, self.maxPage))
end

SoloArenaRule.strPage = {
  T("<lable color=summonYellow>\232\167\132\229\136\153\232\175\180\230\152\142:</lable><br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>1.\233\128\137\230\138\128\229\164\167\228\185\177\230\150\151\232\167\132\229\136\153") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>2.\231\165\157\228\189\160\230\163\139\229\188\128\229\190\151\232\131\156\227\128\130<br/>")
}

function SoloArenaRule:createPageString()
  for k, v in ipairs(self.strPage) do
    local autoText = ed.ui.autoText.new()
    autoText:initParam({
      context = v,
      fontSize = 16,
      lineSpacing = 4,
      maxWidth = self.ui.panel_clipping:getContentSize().width - 46,
      maxHeight = self.ui.panel_clipping:getContentSize().height
    })
    self.ui["page_" .. k]:addChild(autoText.node)
    autoText.node:setPosition(20, self.ui.panel_clipping:getContentSize().height - autoText:getFirstLineHeight())
  end
end
