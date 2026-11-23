local base = ed.ui.popwindow
local astrolabeAttDiffWin = {}
astrolabeAttDiffWin.__index = astrolabeAttDiffWin
setmetatable(astrolabeAttDiffWin, base.mt)
ed.ui.astrolabeAttDiffWin = astrolabeAttDiffWin
local res = ed.heroDetailManager.resConfig

function astrolabeAttDiffWin.create(param)
  local self = base.create("astrolabeAttDiffWin")
  setmetatable(self, astrolabeAttDiffWin)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function astrolabeAttDiffWin:initData(param)
  self.param = param
  self.data = param.data
  self.preData = param.preData
  self.type = param.type
  self.levelGroup = param.levelGroup
end

function astrolabeAttDiffWin:createItem(v)
  local labelColors = {
    {
      color = ed.toccc3(9303158),
      stroke = {
        ed.toccc3(1453599),
        1.5
      },
      res = "astrolabe_quality_1"
    },
    {
      color = ed.toccc3(6797817),
      stroke = {
        ed.toccc3(1449265),
        1.5
      },
      res = "astrolabe_quality_2"
    },
    {
      color = ed.toccc3(15570943),
      stroke = {
        ed.toccc3(3873091),
        1.5
      },
      res = "astrolabe_quality_3"
    },
    {
      color = ed.toccc3(16700269),
      stroke = {
        ed.toccc3(3744789),
        1.5
      },
      res = "astrolabe_quality_4"
    },
    {
      color = ed.toccc3(16734039),
      stroke = {
        ed.toccc3(4268829),
        1.5
      },
      res = "astrolabe_quality_1"
    }
  }
  self.labelColors = labelColors
  
  local function getColorFunc(v)
    local attrInfo = ed.getDataTable("AstrolabeRandomAttr")[self.levelGroup][v._id]
    for i = 1, 4 do
      if v._value <= attrInfo["Value Quality " .. i][2] then
        return labelColors[i], 4 <= i
      end
    end
    return labelColors[5]
  end
  
  local function getPercentage(v)
    local num = v._value / ed.getDataTable("AstrolabeRandomAttr")[self.levelGroup][v._id]["Max Value"]
    return math.floor(num * 100 + 0.5) .. "%"
  end
  
  local container, ui = ed.editorui(ed.uieditor.astrolabeDiffItem)
  local attr = v
  local preAttr = self.preData._stars[v._index]
  local name2 = res.att_cn_name[ed.getDataTable("AstrolabeRandomAttr")[self.levelGroup][attr._id]["Attr Type"]]
  ed.setString(ui.name2, name2)
  ed.setString(ui.num2, string.format("%s(%s)", attr._value, getPercentage(attr)))
  local attrColor = getColorFunc(attr)
  ed.setLabelColor(ui.name2, attrColor.color)
  ed.setLabelStroke(ui.name2, attrColor.stroke[1], attrColor.stroke[2])
  ed.setLabelColor(ui.num2, attrColor.color)
  ed.setLabelStroke(ui.num2, attrColor.stroke[1], attrColor.stroke[2])
  local name1 = res.att_cn_name[ed.getDataTable("AstrolabeRandomAttr")[self.levelGroup][preAttr._id]["Attr Type"]]
  ed.setString(ui.name1, name1)
  ed.setString(ui.num1, string.format("%s(%s)", preAttr._value, getPercentage(preAttr)))
  local preAttrColor = getColorFunc(preAttr)
  ed.setLabelColor(ui.name1, preAttrColor.color)
  ed.setLabelStroke(ui.name1, preAttrColor.stroke[1], preAttrColor.stroke[2])
  ed.setLabelColor(ui.num1, preAttrColor.color)
  ed.setLabelStroke(ui.num1, preAttrColor.stroke[1], preAttrColor.stroke[2])
  return container, ui
end

function astrolabeAttDiffWin:refreshDraglist()
  local function getPos(i)
    return ccp(2, 200 - (i - 0.5) * 36)
  end
  
  for k, v in ipairs(self.data._replace_stars) do
    local container, ui
    container, ui = self:createItem(v)
    self.ui.bg_attr:addChild(container)
    container:setPosition(getPos(k))
  end
end

function astrolabeAttDiffWin:initUI()
  ed.editorui(ed.uieditor.astroAttDiffWin, {
    container = self.container,
    ui = self.ui
  })
  ed.setLabelShadow(self.ui.left_button_label, ed.toccc3(0), ccp(1, 1))
  ed.setLabelShadow(self.ui.right_button_label, ed.toccc3(0), ccp(1, 1))
  ed.setLabelStroke(self.ui.Label_287, ed.toccc3(2565412), 1)
  ed.setLabelShadow(self.ui.gs_pre, ccc3(0, 0, 0), ccp(1, 1))
  ed.setLabelShadow(self.ui.gs, ccc3(0, 0, 0), ccp(1, 1))
  ed.setString(self.ui.gs_pre, T("\230\136\152\229\138\155: ") .. self.preData._gs)
  ed.setString(self.ui.gs, T("\230\136\152\229\138\155: ") .. self.data._replace_gs)
  self:refreshDraglist()
  local diffGs = self.data._replace_gs - self.preData._gs
  local desc = string.format(T("\230\156\172\230\172\161\228\191\157\229\173\152\228\188\154\232\174\169\230\152\159\231\155\152\231\154\132\230\136\152\229\138\155%s<lable color=ccc3(255,165,49) strokeColor=ccc3(0,0,0) strokeSize=1>%d</lable>,\230\152\175\229\144\166\228\191\157\229\173\152\239\188\159"), diffGs < 0 and T("\233\153\141\228\189\142") or T("\230\143\144\229\141\135"), math.abs(diffGs))
  if self.type == 2 then
    desc = T("\230\152\175\229\144\166\231\161\174\232\174\164\230\148\190\229\188\131?")
    ed.setString(self.ui.right_button_label, T("\230\148\190\229\188\131"))
    if self.param.isContainOrange then
      desc = T("\229\190\133\228\191\157\229\173\152\229\177\158\230\128\167\229\140\133\229\144\171<lable color=ccc3(254,211,109) strokeColor=ccc3(0,0,0) strokeSize=1>\230\169\153\232\137\178</lable>\232\175\141\230\157\161\239\188\140\230\152\175\229\144\166\231\161\174\232\174\164\230\148\190\229\188\131?")
    end
  end
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = desc,
    color = ed.toccc3(16776423),
    strokeColor = ccc3(0, 0, 0),
    strokeSize = 1,
    fontSize = 16
  })
  local width, height = autoText:getCurContentSize()
  autoText.node:setPosition(ccp(10 - width / 2, height))
  self.ui.ImageView_305:addChild(autoText.node)
end

function astrolabeAttDiffWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "right_button", function()
    self:destroy({
      skipAnim = self.param.skipDestroyAnim,
      callback = self.param.rightHandler
    })
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "left_button", function()
    self:destroy({
      skipAnim = self.param.skipDestroyAnim,
      callback = self.param.leftHandler
    })
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "middle_button", function()
    self:destroy({
      skipAnim = self.param.skipDestroyAnim,
      callback = self.param.middleHandler
    })
  end, {pressScale = 0.9})
  self.ui.middle_button:setVisible(self.param.middleHandler ~= nil)
end
