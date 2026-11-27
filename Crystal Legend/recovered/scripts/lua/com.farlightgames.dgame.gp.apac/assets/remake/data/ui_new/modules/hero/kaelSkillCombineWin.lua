local base = ed.ui.popwindow
local kaelSkillCombineWin = newclass(base.mt)
ed.ui.kaelSkillCombineWin = kaelSkillCombineWin
local ElementArr = {
  {
    type = "ice",
    des = T("\229\134\176\229\133\131\231\180\160")
  },
  {
    type = "fire",
    des = T("\231\129\171\229\133\131\231\180\160")
  },
  {
    type = "lightning",
    des = T("\231\148\181\229\133\131\231\180\160")
  }
}
local SkillGroupArr = {
  [1] = {
    {
      hid = 53,
      slot = 102,
      elements = {
        "ice",
        "ice",
        "ice"
      }
    },
    {
      hid = 53,
      slot = 103,
      elements = {
        "ice",
        "ice",
        "fire"
      }
    },
    {
      hid = 53,
      slot = 104,
      elements = {
        "ice",
        "ice",
        "lightning"
      }
    }
  },
  [2] = {
    {
      hid = 53,
      slot = 108,
      elements = {
        "lightning",
        "lightning",
        "lightning"
      }
    },
    {
      hid = 53,
      slot = 109,
      elements = {
        "lightning",
        "lightning",
        "fire"
      }
    },
    {
      hid = 53,
      slot = 110,
      elements = {
        "lightning",
        "lightning",
        "ice"
      }
    },
    {
      hid = 53,
      slot = 101,
      elements = {
        "ice",
        "lightning",
        "fire"
      }
    }
  },
  [3] = {
    {
      hid = 53,
      slot = 105,
      elements = {
        "fire",
        "fire",
        "fire"
      }
    },
    {
      hid = 53,
      slot = 106,
      elements = {
        "fire",
        "fire",
        "ice"
      }
    },
    {
      hid = 53,
      slot = 107,
      elements = {
        "fire",
        "fire",
        "lightning"
      }
    }
  }
}

function kaelSkillCombineWin.create(param)
  local self = base.create("kaelSkillCombineWin", {noShade = true})
  setmetatable(self, kaelSkillCombineWin.mt)
  self:init()
  return self
end

function kaelSkillCombineWin:init()
  self.draglistArr = {}
  self.refreshCliprectConfig = {}
  self:initView()
  self:addEventListener()
  self:show()
end

function kaelSkillCombineWin:initView()
  local container, ui = ed.editorui(ed.uieditor.kaelSkillCombineWin)
  self.container:addChild(container)
  self.ui = ui
  self:createElementDes()
  self:createSkillInfo()
end

function kaelSkillCombineWin:createElementDes()
  self.ui.panel_element:removeAllChildrenWithCleanup(true)
  local elementPanelSize = self.ui.panel_element:getContentSize()
  local posX = 0
  for i, v in ipairs(ElementArr) do
    local container = CCLayer:create()
    container:setPositionX(posX)
    self.ui.panel_element:addChild(container)
    local icon = ed.createSprite(string.format("UI/alpha/1080P/tag/Kael_%s.png", v.type))
    container:addChild(icon)
    icon:setScale(0.8)
    local iconWidth = icon:getContentSize().width * icon:getScale()
    icon:setPosition(ccp(iconWidth * 0.5, elementPanelSize.height * 0.5))
    local des = ed.createLabelTTF(v.des, 16)
    container:addChild(des)
    ed.setLabelColor(des, ed.toccc3(16773257))
    local desWidth = des:getContentSize().width
    des:setPosition(ccp(iconWidth + 2 + desWidth * 0.5, elementPanelSize.height * 0.5))
    posX = posX + iconWidth + 2 + desWidth + 5
  end
  local desDraglist = ed.UITool.createDraglist(self.ui.panel_des, {})
  table.insert(self.draglistArr, desDraglist)
  local desPanelSize = self.ui.panel_des:getContentSize()
  local desTxt = ed.ui.autoText.new()
  local str = T("1.<lable color=ccc3(255,240,137)>\229\143\172\229\148\164\229\184\136</lable>\229\146\140<lable color=ccc3(255,240,137)>\229\133\182\233\152\159\229\143\139</lable>\228\188\154\230\143\144\228\190\155\229\133\131\231\180\160\231\144\131\227\128\130<br/>") .. "2.<lable color=ccc3(255,240,137)>\231\130\185\229\135\187\229\133\131\231\180\160\231\144\131</lable>\229\143\175\228\187\165\230\144\156\233\155\134\229\133\131\231\180\160\231\144\131\227\128\130<br/>" .. "3.\233\155\134\233\189\144<lable color=ccc3(255,240,137)>\231\137\185\229\174\154\231\187\132\229\144\136</lable>\231\154\132\229\133\131\231\180\160\231\144\131\229\143\175\228\187\165\233\135\138\230\148\190<lable color=ccc3(255,240,137)>\228\184\141\229\144\140\231\154\132\230\138\128\232\131\189</lable>\227\128\130"
  desTxt:initParam({
    context = str,
    fontSize = 16,
    maxWidth = desPanelSize.width,
    color = ed.toccc3(16776423),
    isTripLastSpacing = true
  })
  local _, desHeight = desTxt:getCurContentSize()
  desDraglist:addItem(desTxt.node)
  local offsetY = 0
  if desHeight < desPanelSize.height then
    offsetY = (desPanelSize.height - desHeight) * 0.5
  end
  offsetY = offsetY + desTxt:getFirstLineHeight() * 0.5
  desTxt.node:setPosition(ccp(0, desPanelSize.height - offsetY))
  desDraglist:initListHeight(desHeight)
end

function kaelSkillCombineWin:createSkillItem(data)
  local container, ui = ed.editorui(ed.uieditor.kaelSkillCombineItem)
  local icon, bg = ed.readhero.createSkillIcon(data.hid, data.slot)
  icon:setScale(ui.img_skill:getScaleX())
  ed.UITool.replaceUI(ui, "panel_bg", "img_skill", icon)
  local skillTableItem = ed.getDataTable("SkillGroup")[data.hid][data.slot]
  ed.setLabelString(ui.label_skill, skillTableItem["Display Name"])
  for i = 1, 3 do
    local elementImg = ui["img_element_" .. i]
    if nil == data.elements[i] then
      elementImg:setVisible(false)
    else
      elementImg:setVisible(true)
      ed.setTexture(elementImg, string.format("UI/alpha/1080P/tag/Kael_%s.png", data.elements[i]))
    end
  end
  return container, ui
end

function kaelSkillCombineWin:createSkillInfo()
  local groupPanelSize = self.ui.panel_group:getContentSize()
  local groupSize = CCSizeMake(200, groupPanelSize.height)
  local spaceX = 15
  local startX = (groupPanelSize.width - ((groupSize.width + spaceX) * #SkillGroupArr - spaceX)) * 0.5
  for groupIndex, skillArr in ipairs(SkillGroupArr) do
    local groupContainer = CCLayer:create()
    self.ui.panel_group:addChild(groupContainer)
    groupContainer:setContentSize(groupSize)
    groupContainer:setPosition(ccp(startX + (groupIndex - 1) * (groupSize.width + spaceX), 0))
    local draglist = ed.UITool.createDraglist(groupContainer, {})
    table.insert(self.draglistArr, draglist)
    local totalHeight = 0
    local spaceY = 0
    for skillIndex, skillItem in ipairs(skillArr) do
      totalHeight = totalHeight + spaceY
      local skillContainer, skillUI = self:createSkillItem(skillItem)
      draglist:addItem(skillContainer)
      local itemHeight = skillUI.panel_bg:getContentSize().height
      skillContainer:setPosition(ccp(groupSize.width * 0.5, groupPanelSize.height - totalHeight - itemHeight * 0.5))
      totalHeight = totalHeight + itemHeight
      spaceY = 2
    end
    draglist:initListHeight(totalHeight)
  end
end

function kaelSkillCombineWin:getRefreshCliprectHandler(draglist, scaleContainer)
  local function handler(dt)
    if tolua.isnull(scaleContainer) then
      self:endRefreshCliprect()
      
      return
    end
    for i, v in ipairs(self.draglistArr) do
      v:refreshClipRect(scaleContainer:getScale())
    end
  end
  
  return handler
end

function kaelSkillCombineWin:refreshCliprect(draglist, scaleContainer)
  for i, v in ipairs(self.draglistArr) do
    v:refreshClipRect(scaleContainer:getScale())
  end
end

function kaelSkillCombineWin:addEventListener()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy()
  end, {pressScale = 0.9})
end
