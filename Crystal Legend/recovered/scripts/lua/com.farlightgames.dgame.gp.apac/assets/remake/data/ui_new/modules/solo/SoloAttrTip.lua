local base = ed.ui.popwindow
local SoloAttrTip = newclass(base.mt)
ed.ui.SoloAttrTip = SoloAttrTip
local ATTRCONFIG = {
  T("<sprite src=UI/alpha/1080P/chesscard/1.png><lable color=ccc3(255,129,117)>\230\148\187\229\135\187\229\138\155:</lable>\230\153\174\230\148\187\228\188\164\229\174\179"),
  T("<sprite src=UI/alpha/1080P/chesscard/5.png><lable color=ccc3(113,255,237)>\230\148\187  \233\128\159:</lable>\230\175\143\231\167\146\230\148\187\229\135\187\230\172\161\230\149\176"),
  T("<sprite src=UI/alpha/1080P/chesscard/2.png><lable color=ccc3(255,237,85)>\230\154\180\229\135\187\231\142\135:</lable>\233\187\152\232\174\164\230\153\174\230\148\187\230\137\141\228\188\154\232\167\166\229\143\145\230\154\180\229\135\187"),
  T("<sprite src=UI/alpha/1080P/chesscard/6.png><lable color=ccc3(104,128,219)>\233\151\170\233\129\191\231\142\135:</lable>\233\187\152\232\174\164\231\137\169\231\144\134\228\188\164\229\174\179\230\137\141\232\131\189\232\162\171\233\151\170\233\129\191"),
  T("<sprite src=UI/alpha/1080P/chesscard/3.png><lable color=ccc3(81,189,77)>\228\184\173\230\175\146\229\128\188:</lable>\230\149\176\229\128\188\232\182\138\233\171\152\239\188\140\230\175\143\231\167\146\229\143\151\229\136\176\228\188\164\229\174\179\232\182\138\233\171\152"),
  T("<sprite src=UI/alpha/1080P/chesscard/4.png><lable color=ccc3(64,184,245)>\233\156\156\229\134\187\229\128\188:</lable>\230\149\176\229\128\188\232\182\138\233\171\152\239\188\140\230\148\187\233\128\159\232\182\138\228\189\142"),
  T("<sprite src=UI/alpha/1080P/chesscard/11.png><lable color=ccc3(166,216,247)>\230\158\129\233\128\159\229\128\188:</lable>\230\138\181\230\138\151\233\156\156\229\134\187\239\188\140\230\149\176\229\128\188\232\182\138\233\171\152\239\188\140\229\138\160\233\128\159\229\141\161\231\137\140\230\138\128\232\131\189\233\135\138\230\148\190\229\145\168\230\156\159"),
  T("<sprite src=UI/alpha/1080P/chesscard/9.png><lable color=ccc3(216,155,106)>\230\138\164\231\155\190\229\128\188:</lable>\230\149\176\229\128\188\232\182\138\233\171\152\239\188\140\229\143\151\229\136\176\228\188\164\229\174\179\232\182\138\228\189\142"),
  T("<sprite src=UI/alpha/1080P/chesscard/12.png><lable color=ccc3(156,79,183)>\229\162\158\228\188\164\229\128\188:</lable>\230\149\176\229\128\188\232\182\138\233\171\152\239\188\140\229\143\151\229\136\176\228\188\164\229\174\179\232\182\138\233\171\152")
}

function SoloAttrTip:initUI()
  ed.editorui(ed.uieditor.SoloAttrTip, {
    container = self.container,
    ui = self.ui
  })
  local enabledDynamicFactions = {}
  if ed.SoloModel and ed.SoloModel.factions then
    local dynamicFactionIds = {
      7,
      8,
      9,
      10,
      11
    }
    for _, factionId in ipairs(dynamicFactionIds) do
      if ed.SoloModel.factions[factionId] then
        table.insert(enabledDynamicFactions, factionId)
      end
    end
    table.sort(enabledDynamicFactions)
  end
  local factionToAttrMap = {
    [7] = 5,
    [8] = 6,
    [9] = 8,
    [10] = 9,
    [11] = 7
  }
  local maxWidth = 0
  local attrTexts = {}
  local itemSpacing = 0
  local topMargin = 20
  local sideMargin = 20
  local tempTexts = {}
  local totalContentHeight = 0
  for i = 1, 4 do
    local autoText = ed.ui.autoText.new()
    autoText:initParam({
      context = ATTRCONFIG[i],
      color = ed.toccc3(16776423),
      maxWidth = 300,
      fontSize = 13,
      lineSpacing = 1
    })
    local w, h = autoText:getCurContentSize()
    maxWidth = math.max(maxWidth, w)
    totalContentHeight = totalContentHeight + h
    table.insert(tempTexts, {
      autoText = autoText,
      width = w,
      height = h
    })
  end
  for _, factionId in ipairs(enabledDynamicFactions) do
    local attrIndex = factionToAttrMap[factionId]
    if attrIndex and ATTRCONFIG[attrIndex] then
      local autoText = ed.ui.autoText.new()
      autoText:initParam({
        context = ATTRCONFIG[attrIndex],
        color = ed.toccc3(16776423),
        maxWidth = 300,
        fontSize = 13,
        lineSpacing = 1
      })
      local w, h = autoText:getCurContentSize()
      maxWidth = math.max(maxWidth, w)
      totalContentHeight = totalContentHeight + h
      table.insert(tempTexts, {
        autoText = autoText,
        width = w,
        height = h
      })
    end
  end
  local totalItems = #tempTexts
  local totalHeight = totalContentHeight + (totalItems - 1) * itemSpacing + topMargin * 2
  local totalWidth = maxWidth + sideMargin * 2
  totalHeight = math.max(totalHeight, 100)
  totalWidth = math.max(totalWidth, 200)
  self.ui.bg:setContentSize(CCSize(totalWidth, totalHeight))
  self.ui.layer_item:setContentSize(CCSize(totalWidth, totalHeight))
  local currentY = totalHeight - topMargin
  for _, textInfo in ipairs(tempTexts) do
    textInfo.autoText.node:setPosition(ccp(5, currentY - textInfo.height - 7))
    currentY = currentY - textInfo.height - itemSpacing
    self.ui.layer_item:addChild(textInfo.autoText.node)
    table.insert(attrTexts, textInfo.autoText)
  end
end

function SoloAttrTip.create()
  local self = base.create("SoloAttrTip", {
    notBlurBg = true,
    noShade = true,
    priority = -300,
    swallow = true
  })
  setmetatable(self, SoloAttrTip.mt)
  self:initUI()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "attr_tip_destroy",
    clickHandler = function()
      base.destroy(self, {skipAnim = true})
    end
  })
  self:listenEvent("EventCloseOtherWin", function()
    base.destroy(self, {skipAnim = true})
  end)
  self:popWindow()
  return self
end
