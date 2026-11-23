local base = ed.ui.popwindow
local summonRiseStarSelectWin = newclass(base.mt)
ed.ui.summonRiseStarSelectWin = summonRiseStarSelectWin
local Rank_Tag_Config = {
  [1] = {
    bg = "UI/alpha/1080P/summonbeginner/banner/recommend_summon_top1.png",
    fontSize = 19,
    startColor = ed.toccc3(15728537),
    endColor = ed.toccc3(16777215),
    strokeColor = ed.toccc3(12529416)
  },
  [2] = {
    bg = "UI/alpha/1080P/summonbeginner/banner/recommend_summon_top2.png",
    fontSize = 18,
    startColor = ed.toccc3(16776113),
    endColor = ed.toccc3(16776684),
    strokeColor = ed.toccc3(11033603)
  },
  [3] = {
    bg = "UI/alpha/1080P/summonbeginner/banner/recommend_summon_top3.png",
    fontSize = 18,
    startColor = ed.toccc3(16768082),
    endColor = ed.toccc3(16775300),
    strokeColor = ed.toccc3(7733447)
  }
}

function summonRiseStarSelectWin.create(param)
  local self = base.create("summonRiseStarSelectWin")
  setmetatable(self, summonRiseStarSelectWin.mt)
  self:init(param)
  self:popWindow()
  return self
end

function summonRiseStarSelectWin:init(param)
  param = param or {}
  self.destroyCallback = param.destroyCallback
  self:initData()
  self:initView()
  self:addEventListener()
end

function summonRiseStarSelectWin:initData()
  self.heroList = self:getCurHeroList()
  self.hotTab = {}
  for i, v in ipairs(ed.summonMgr.riseStarHeroList) do
    self.hotTab[v._hero_id] = {
      rank = i,
      val = v._hot_value
    }
  end
end

function summonRiseStarSelectWin:initView()
  ed.editorui(ed.uieditor.summonRiseStarSelectWin, {
    container = self.container,
    ui = self.ui
  })
  self.ui.title:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.title, ed.toccc3(13326484), 1)
  ed.setLabelShadow(self.ui.label_ok, ccc3(0, 0, 0), ccp(0, 2))
  self.ui.title:limitWidthByScale(135)
  self.ui.btn_ok:setVisible(false)
  self:setBackButton()
  self:createDragList()
  self:refreshDragList()
end

function summonRiseStarSelectWin:addEventListener()
  ed.UITool.registerBtn(self, "btn_ok", function()
    self:onClickSave()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy({skipAnim = true})
  end, {pressScale = 0.75, normalScale = 0.8})
  self:listenEvent("EventSummonRiseStarSelectSuccess", function(result)
    if result then
      ed.showToast(T("\228\191\157\229\173\152\230\136\144\229\138\159\239\188\129"))
      self:destroy()
      if self.callback then
        self.callback()
      end
      return
    else
      ed.showToast(T("\228\191\157\229\173\152\229\164\177\232\180\165\239\188\129"))
      self:destroy()
    end
  end)
end

function summonRiseStarSelectWin:getCurHeroList()
  local tb = ed.getDataTable("SummonRiseStar")
  local curTime = ed.getServerTime()
  local heroIds = {}
  for k, v in ipairs(tb) do
    if type(k) == "number" then
      local onlineTime = ed.getTimeByYMDHMS(v["Online Time"])
      if curTime >= onlineTime then
        table.insert(heroIds, 1, v["Hero ID"])
      end
    end
  end
  return heroIds
end

function summonRiseStarSelectWin:createDragList()
  self.heroDragList = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList()
  })
end

function summonRiseStarSelectWin:getPos(index)
  local size = self.ui.layer_item:getContentSize()
  local topPadding = 12
  local nCol = 5
  local dx, dy = 137, 148
  local ox, oy = 75, size.height - dy / 2 - topPadding
  local row = math.floor((index - 1) / nCol)
  local col = (index - 1) % nCol
  return ccp(ox + col * dx, oy - row * dy)
end

function summonRiseStarSelectWin:refreshDragList()
  self.uiList = {}
  local data = self.heroList or {}
  if #data == 0 then
    return
  end
  for k, v in ipairs(data) do
    local container, ui = self:createItem(v)
    container:setPosition(self:getPos(k))
    local item = {
      container = container,
      ui = ui,
      data = v
    }
    table.insert(self.uiList, item)
    self.heroDragList:addItem(container)
  end
  local nCol = 5
  local topPadding = 12
  local dx, dy = 137, 148
  local nRow = math.floor((#data - 1) / nCol) + 1
  self.heroDragList:initListHeight(nRow * dy + topPadding)
end

function summonRiseStarSelectWin:createItem(hid)
  local container, ui = ed.editorui(ed.uieditor.summonRiseStarSelectItem)
  ui.selected:setVisible(false)
  local icon = ed.readhero.createIcon({
    id = hid,
    rank = 1,
    star = 3
  }).icon
  ed.setLabelStroke(ui.hot, ed.toccc3(4731991), 1)
  ed.setString(ui.name, ed.lookupDataTable("Unit", "Display Name", hid))
  ed.UITool.replaceUINew(ui, "icon", icon)
  local hot = ed.hothero.manager:getHeroHot(hid)
  ed.setLabelStroke(ui.hot, ed.toccc3(4731975), 1)
  ui.hot:setString(hot)
  ui.ImageView_724:setVisible(false)
  local fca = ed.createFcaNode("eff_UI_SummonBeginner_Select")
  self:addFca(fca)
  ed.UITool.replaceUINew(ui, "ImageView_724", fca)
  if ed.summonMgr.riseStarNewestHeroId == hid then
    local bgSize = ui.bg:getContentSize()
    local tagImg = ed.createSprite("UI/alpha/1080P/summon/hero_new_tag.png")
    ui.bg:addChild(tagImg)
    tagImg:setPosition(14, bgSize.height - 7)
  else
    local hotInfo = self.hotTab[hid]
    if nil ~= hotInfo then
      local bgSize = ui.bg:getContentSize()
      local colorConfig = Rank_Tag_Config[hotInfo.rank]
      local tagImg = ed.createSprite(colorConfig.bg)
      ui.bg:addChild(tagImg)
      tagImg:setPosition(15, bgSize.height - 5)
      local tagSize = tagImg:getContentSize()
      local topNode = ed.ui.gradientLabel.create({
        text = "Top" .. hotInfo.rank,
        fontSize = colorConfig.fontSize,
        fontName = ed.font,
        startColor = colorConfig.startColor,
        endColor = colorConfig.endColor,
        strokeSize = 1.5,
        strokeColor = colorConfig.strokeColor
      })
      tagImg:addChild(topNode.node)
      topNode.node:setRotation(-10)
      topNode.node:setPosition(tagSize.width * 0.5, tagSize.height * 0.5 + 2)
      local selectBg = ed.createSprite("UI/alpha/1080P/summonbeginner/banner/recommend_like.png")
      ui.bg:addChild(selectBg)
      local selectSize = selectBg:getContentSize()
      selectBg:setPosition(bgSize.width - selectSize.width * 0.5 + 2, bgSize.height - selectSize.height * 0.5 + 2)
      local selectLabel = ed.createLabelTTF(string.format("%d%%", math.floor(hotInfo.val * 100)), 15)
      selectBg:addChild(selectLabel)
      ed.setLabelColor(selectLabel, ccc3(255, 252, 231))
      ed.setLabelStroke(selectLabel, ed.toccc3(10888742), 1)
      selectLabel:setPosition(13, selectSize.height * 0.5 + 3.5)
    end
  end
  return container, ui
end

function summonRiseStarSelectWin:setBackButton()
  local ui = self.ui
  local readnode = ed.readnode.create(self.container, ui)
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "btn_back",
        res = "UI/alpha/1080P/common/break_butt_bj.png"
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "back_arrow",
        res = "UI/alpha/1080P/common/break_butt.png",
        parent = "btn_back"
      },
      config = {}
    }
  }
  readnode:addNode(ui_info)
  ed.layout.centerInParent(ui.back_arrow)
  ui.btn_back:setScale(0.8)
  ed.layout.layoutWithMagin(ui.btn_back, {left = 0, top = 0})
end

function summonRiseStarSelectWin:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      if ed.containsPoint(v.ui.bg, x, y) then
        return v
      end
    end
    return nil
  end
  
  return handler
end

function summonRiseStarSelectWin:doClickInList()
  local function handler(x, y, item)
    if not item then
      return
    end
    if ed.containsPoint(item.ui.bg, x, y) then
      if self.selectItem then
        local ui = self.selectItem.ui
        ui.selected:setVisible(false)
        ed.setTexture(ui.bg, "UI/alpha/1080P/summonbeginner/beignner_hero_choose_1.png")
      end
      self.selectItem = item
      item.ui.selected:setVisible(true)
      ed.setTexture(item.ui.bg, "UI/alpha/1080P/summonbeginner/beignner_hero_choose_2.png")
      self.ui.btn_ok:setVisible(true)
    end
  end
  
  return handler
end

function summonRiseStarSelectWin:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
  end
  
  return handler
end

function summonRiseStarSelectWin:onClickSave()
  if self.selectItem then
    self.ui.btn_ok:setVisible(false)
    ed.ui.summonRiseStarConfirmWin.create({
      tid = self.selectItem.data,
      destroyCallback = function()
        self.ui.btn_ok:setVisible(true)
      end
    })
  else
    self:destroy({skipAnim = true})
  end
end
