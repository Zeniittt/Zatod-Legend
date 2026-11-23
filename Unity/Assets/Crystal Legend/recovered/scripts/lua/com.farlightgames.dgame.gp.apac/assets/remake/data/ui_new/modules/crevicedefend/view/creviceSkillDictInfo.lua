local base = ed.ui.popwindow
local creviceSkillDictInfo = newclass(base.mt)
ed.ui.creviceSkillDictInfo = creviceSkillDictInfo
ed.UITool.registViewOpenFunc("OpenCreviceSkillDictInfo", function(param)
  setmetatable(base.create("creviceSkillDictInfo", {noShade = true, notBlurBg = true}), creviceSkillDictInfo.mt):create(param):popWindow()
end)

function creviceSkillDictInfo.localCreatettf(param)
  local label = ed.createttf(param.txt or 0, param.size or 17)
  if param.pos.x == -1 then
    label:setPosition(ccp(label:getContentSize().width / 2 + 18, param.pos.y))
  else
    label:setPosition(param.pos or ccp(0, 0))
  end
  label:setColor(param.color or ccc3(243, 220, 181))
  label:setAnchorPoint(param.anchor or ccp(0.5, 0.5))
  param.parent:addChild(label)
  if param.stroke then
    ed.setLabelStroke(label, param.stroke.color, param.stroke.size or 1)
  end
  return label
end

function creviceSkillDictInfo:create(param)
  self.name = param.name
  self.desc = param.desc
  self:showDictInfo(param.index, param.x, param.y)
  self:registerTouchHandler()
  self:show({skipAnim = false})
  return self
end

function creviceSkillDictInfo:showDictInfo(index, x, y)
  y = y + 65
  if not index then
    return
  end
  local desc = self.desc
  if not desc then
    local tb = ed.getDataTable("Dictionary")
    desc = tb[tonumber(index)].Description
    desc = string.gsub(desc, "#br#", "<br/>")
  end
  local autoText = ed.ui.autoText:new()
  autoText:initParam({
    context = desc,
    fontSize = 16,
    maxWidth = 400,
    color = ccc3(255, 252, 231)
  })
  ed.setLabelShadow(autoText, ed.toccc3(4854547), 1)
  local bg = ed.createScale9Sprite("UI/alpha/1080P/crevicedefend/skilltipbg.png", CCRectMake(10, 10, 10, 60))
  local width, height = autoText:getCurContentSize()
  bg:setContentSize(CCSizeMake(width + 35, height + 20 + 35))
  autoText.node:setPosition(ccp(20, height + 10))
  bg:addChild(autoText.node)
  bg:setPosition(ccp(ed.display.winSize.width / 2, ed.display.winSize.height / 2 + 40))
  self.actionLayer:setPosition(x - ed.display.winSize.width / 2, y + height / 2 + 10 - ed.display.winSize.height / 2)
  self.uiBg = bg
  self.actionLayer:addChild(bg)
  local label_title = self.localCreatettf({
    txt = self.name,
    size = 18,
    pos = ccp(-1, height + 35),
    stroke = {
      color = ed.toccc3(2298379)
    },
    color = ccc3(226, 181, 104),
    parent = bg
  })
  local parent = bg:getParent()
  local pos = parent:convertToWorldSpace(ccp(bg:getPosition()))
  local tips = ed.createSprite("UI/alpha/1080P/crevicedefend/tiparrows.png")
  bg:addChild(tips)
  if pos.x - bg:getContentSize().width / 2 < 0 then
    ed.layout.layoutWithMagin(bg, {
      left = ed.display.getNotchHeight()
    })
  else
    if pos.x + bg:getContentSize().width / 2 > ed.display.winSize.width then
      ed.layout.layoutWithMagin(bg, {
        right = ed.display.getNotchHeight()
      })
    else
    end
  end
  local PoxMap = {
    190,
    160,
    240,
    320
  }
  tips:setPosition(ccp(PoxMap[index], 6.3))
end

function creviceSkillDictInfo:registerTouchHandler()
  self:btRegisterOutClick({
    area = self.uiBg,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = false})
    end
  })
end
