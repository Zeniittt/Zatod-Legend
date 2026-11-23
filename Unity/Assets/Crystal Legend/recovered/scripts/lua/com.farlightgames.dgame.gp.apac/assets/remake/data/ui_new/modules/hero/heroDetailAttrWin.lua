local base = ed.ui.popwindow
local heroDetailAttrWin = {}
heroDetailAttrWin.__index = heroDetailAttrWin
setmetatable(heroDetailAttrWin, base.mt)
ed.ui.heroDetailAttrWin = heroDetailAttrWin
local res = ed.heroDetailManager.resConfig

function heroDetailAttrWin.create(param)
  local self = base.create("heroDetailAttrWin")
  setmetatable(self, heroDetailAttrWin)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow(500)
  self:show()
  return self
end

function heroDetailAttrWin:initData(param)
  self.hero = param.hero
  self.awakeDungeonAttrInfo = param.awakeDungeonAttrInfo
  self.hid = self.hero._tid
  self.desc = ed.getDataTable("Unit")[self.hid].Description or "\228\184\128\228\184\170\230\178\161\230\156\137\231\174\128\228\187\139\231\154\132\229\176\143\232\167\146\232\137\178"
  self.comment = ed.getDataTable("Unit")[self.hid].Narrative or "\228\184\128\228\184\170\230\178\161\230\156\137\229\143\176\232\175\141\231\154\132\229\176\143\232\167\146\232\137\178"
  self.attInfo = ed.readhero.getHeroAttByHero(self.hero)
  self.growth = ed.readhero.getGrowthByHero(self.hero)
  self.growthRatio = ed.readhero.getGrowthRatioByHero(self.hero)
end

local growth = {
  {
    name = "STR",
    cn = T("\229\138\155\233\135\143\230\136\144\233\149\191"),
    growthRatioKey = "+STR%"
  },
  {
    name = "INT",
    cn = T("\230\153\186\229\138\155\230\136\144\233\149\191"),
    growthRatioKey = "+INT%"
  },
  {
    name = "AGI",
    cn = T("\230\149\143\230\141\183\230\136\144\233\149\191"),
    growthRatioKey = "+AGI%"
  }
}
heroDetailAttrWin.growth = growth

function heroDetailAttrWin:createGrowthItem(index, pos)
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  local readnode = ed.readnode.create(container, ui)
  if pos % 2 == 1 then
    readnode:addNode(ed.uieditor.itemAttr1)
  else
    readnode:addNode(ed.uieditor.itemAttr2)
  end
  ui.attrname:setColor(ccc3(254, 211, 109))
  ed.setLabelStroke(ui.attrname, ccc3(57, 36, 21), 1)
  ed.setString(ui.attrname, growth[index].cn)
  local text = string.format("<lable color=ccc3(245,221,183)>%0.2f</lable>", self.growth[growth[index].name])
  local ratioKey = growth[index].growthRatioKey
  local growthRatio = self.growthRatio[ratioKey] or 0
  if 0 < growthRatio then
    text = string.format("<lable color=ccc3(245,221,183)>%0.2f</lable><lable color=ccc3(112,255,84) strokeColor=ccc3(23,49,31) strokeSize=1>+%0.2f</lable>", self.growth[growth[index].name], self.growth[growth[index].name] * growthRatio / 100)
  end
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = text,
    fontSize = 16,
    align = "RIGHT"
  })
  autoText.node:setPosition(ccp(80, 16))
  ui.attrnum:setVisible(false)
  ui.bg:addChild(autoText.node)
  return container, ui
end

function heroDetailAttrWin:createAttItem(index, pos)
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  local readnode = ed.readnode.create(container, ui)
  if pos % 2 == 1 then
    readnode:addNode(ed.uieditor.itemAttr1)
  else
    readnode:addNode(ed.uieditor.itemAttr2)
  end
  local attName = res.att_name[index]
  ui.attrname:setColor(ccc3(255, 234, 198))
  ed.setLabelStroke(ui.attrname, ccc3(41, 27, 27), 1)
  ed.setString(ui.attrname, res.att_cn_name[attName])
  local text = ""
  if not self.attInfo[attName] then
    text = "<lable color=ccc3(245,221,183)>0</lable>"
  elseif self.attInfo[attName].add and self.attInfo[attName].add > 0 then
    text = string.format("<lable color=ccc3(245,221,183)>%d</lable><lable color=ccc3(112,255,84) strokeColor=ccc3(23,49,31) strokeSize=1>+%d</lable>", self.attInfo[attName].base or 0, self.attInfo[attName].add)
  elseif self.attInfo[attName].add and self.attInfo[attName].add < 0 then
    text = string.format("<lable color=ccc3(245,221,183)>%d</lable><lable color=ccc3(112,255,84) strokeColor=ccc3(23,49,31) strokeSize=1>%d</lable>", self.attInfo[attName].base or 0, self.attInfo[attName].add)
  else
    text = string.format("<lable color=ccc3(245,221,183)>%d</lable>", self.attInfo[attName].base or 0)
  end
  if res.att_suffix[attName] then
    text = text .. "<lable color=ccc3(245,221,183)>" .. res.att_suffix[attName] .. "</lable>"
  end
  if self.awakeDungeonAttrInfo and ed.awakeDungeonMgr.getInstance():awakeDungeonIsOpen() and ed.storage.getBool("base_detail_dungeon_switch") then
    local attr = self.awakeDungeonAttrInfo[attName] and math.floor(self.awakeDungeonAttrInfo[attName] + 0.5 or 0) or nil
    if attr then
      text = text .. string.format("<lable color=ccc3(255,215,129) strokeColor=ccc3(120,65,35) strokeSize=1>+%d</lable>", attr)
    end
  end
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = text,
    fontSize = 16,
    align = "RIGHT"
  })
  autoText.node:setPosition(ccp(80, 16))
  ui.attrnum:setVisible(false)
  ui.bg:addChild(autoText.node)
  return container, ui
end

function heroDetailAttrWin:refreshDraglist()
  self.draglist:clearList()
  local size = self.ui.layer_att:getContentSize()
  
  local function getPos(i)
    return ccp(size.width / 2, size.height - (i - 0.5) * 35 - 2)
  end
  
  local names = {
    STR = T("\229\138\155\233\135\143\230\136\144\233\149\191"),
    INT = T("\230\153\186\229\138\155\230\136\144\233\149\191"),
    AGI = T("\230\149\143\230\141\183\230\136\144\233\149\191")
  }
  local gt = self.growth
  local i = 1
  for k = 1, 3 do
    local container, ui
    container, ui = self:createGrowthItem(k, i)
    self.draglist:addItem(container)
    container:setPosition(getPos(k))
    i = i + 1
  end
  for k = 1, #res.att_name do
    local attName = res.att_name[k]
    local isGrowthAttr = false
    for _, growthCfg in ipairs(heroDetailAttrWin.growth) do
      if attName == growthCfg.growthRatioKey then
        isGrowthAttr = true
        break
      end
    end
    if not isGrowthAttr then
      local att = self.attInfo[attName] or {}
      local base = att.base or 0
      local add = att.add or 0
      if res.att_cn_name[attName] and (0 < base or 0 < add) then
        local container, ui
        container, ui = self:createAttItem(k, i)
        self.draglist:addItem(container)
        container:setPosition(getPos(i))
        i = i + 1
      end
    end
  end
  self.draglist:initListHeight(35 * i - 32)
end

function heroDetailAttrWin:initUI()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.heroAttWin)
  ed.setLabelDimensions(self.ui.desc, CCSizeMake(500, 0))
  self.ui.desc:setHorizontalAlignment(kCCTextAlignmentCenter)
  ed.setString(self.ui.desc, self.desc)
  ed.setString(self.ui.comment, self.comment)
  self.ui.comment:limitWidthByScale(540)
  self.draglist = ed.UITool.createDraglist(self.ui.layer_att, {})
  self:refreshDraglist()
end

function heroDetailAttrWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end
  })
end
