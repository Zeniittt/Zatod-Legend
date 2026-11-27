local base = ed.ui.popwindow
local heroAstrolabeAttWin = {}
heroAstrolabeAttWin.__index = heroAstrolabeAttWin
setmetatable(heroAstrolabeAttWin, base.mt)
ed.ui.heroAstrolabeAttWin = heroAstrolabeAttWin
local res = ed.heroDetailManager.resConfig

function heroAstrolabeAttWin.create(param)
  local self = base.create("heroAstrolabeAttWin")
  setmetatable(self, heroAstrolabeAttWin)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self.refreshCliprectConfig = {
    draglist = self.draglist
  }
  self:popWindow()
  self:show()
  return self
end

function heroAstrolabeAttWin:initRandomAttr()
  local labelColors = {
    {
      color = ed.toccc3(9303158),
      stroke = ed.toccc3(1453599)
    },
    {
      color = ed.toccc3(6797817),
      stroke = ed.toccc3(1449265)
    },
    {
      color = ed.toccc3(15570943),
      stroke = ed.toccc3(3873091)
    },
    {
      color = ed.toccc3(16700269),
      stroke = ed.toccc3(3744789)
    },
    {
      color = ed.toccc3(16734039),
      stroke = ed.toccc3(4268829)
    }
  }
  local randomGroupId = ed.getDataTable("Astrolabe")[self.hid]["Random Attr Group"]
  local randomAttTb = ed.getDataTable("AstrolabeRandomAttr")[randomGroupId]
  
  local function getColorFunc(v)
    local attrInfo = randomAttTb[v._id]
    for i = 1, 4 do
      if v._value <= attrInfo["Value Quality " .. i][2] then
        return labelColors[i]
      end
    end
    return labelColors[5]
  end
  
  local percent = randomAttTb["Value Is Pct"] and 0.01 or 1
  for ii, word in ipairs(self.hero._astrolabe._stars or {}) do
    local attrName = randomAttTb[word._id]["Attr Type"]
    local attrCN = res.att_anim_name[attrName]
    local suffix = res.att_suffix[attrName] or ""
    table.insert(self.attrInfo, {
      attrCN,
      word._value * percent .. suffix,
      getColorFunc(word)
    })
  end
end

function heroAstrolabeAttWin:initAstrolabeAttr()
  local level = self.hero._astrolabe._level
  local groupId = ed.getDataTable("Astrolabe")[self.hid]["Level Group"]
  local astrolabeSTR = ed.getDataTable("AstrolabeLevelAttr")[groupId][level].STR
  local astrolabeAGI = ed.getDataTable("AstrolabeLevelAttr")[groupId][level].AGI
  local astrolabeINT = ed.getDataTable("AstrolabeLevelAttr")[groupId][level].INT
  self.attrInfo = {
    {
      T("\229\138\155\233\135\143"),
      string.format("%.2f", astrolabeSTR)
    },
    {
      T("\230\153\186\229\138\155"),
      string.format("%.2f", astrolabeINT)
    },
    {
      T("\230\149\143\230\141\183"),
      string.format("%.2f", astrolabeAGI)
    }
  }
  self:initRandomAttr()
end

function heroAstrolabeAttWin:initData(param)
  self.hero = param.hero
  self.hid = self.hero._tid
  self:initAstrolabeAttr()
end

function heroAstrolabeAttWin:createAttrItem(index, v)
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  local readnode = ed.readnode.create(container, ui)
  if index % 2 == 1 then
    readnode:addNode(ed.uieditor.itemAttr1)
  else
    readnode:addNode(ed.uieditor.itemAttr2)
  end
  ed.setLabelStroke(ui.attrname, ccc3(57, 36, 21), 1)
  ed.setString(ui.attrname, v[1])
  ed.setString(ui.attrnum, v[2])
  if v[3] then
    ed.setLabelColor(ui.attrname, v[3].color)
    ed.setLabelColor(ui.attrnum, v[3].color)
    ed.setLabelStroke(ui.attrname, v[3].stroke, 1)
    ed.setLabelStroke(ui.attrnum, v[3].stroke, 1)
  end
  return container, ui
end

function heroAstrolabeAttWin:refreshDraglist()
  self.draglist:clearList()
  local size = self.ui.layer_att:getContentSize()
  local ox, oy, dy = size.width / 2, size.height, 35
  
  local function getPos(i)
    return ccp(ox, oy - (i - 0.5) * dy)
  end
  
  for k, v in ipairs(self.attrInfo) do
    local container, ui
    container, ui = self:createAttrItem(k, v)
    self.draglist:addItem(container)
    container:setPosition(getPos(k))
  end
  self.draglist:initListHeight(35 * #self.attrInfo)
end

function heroAstrolabeAttWin:initUI()
  ed.editorui(ed.uieditor.heroAttWin, {
    container = self.container,
    ui = self.ui
  })
  self.ui.desc:setVisible(false)
  self.ui.comment:setVisible(false)
  ed.setString(self.ui.title, T("\230\152\159\231\155\152\229\177\158\230\128\167\232\175\166\230\131\133"))
  self.ui.layer_att:setContentSize(CCSizeMake(500, 280))
  self.draglist = ed.UITool.createDraglist(self.ui.layer_att, {})
  self:refreshDraglist()
end

function heroAstrolabeAttWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end
  })
end
