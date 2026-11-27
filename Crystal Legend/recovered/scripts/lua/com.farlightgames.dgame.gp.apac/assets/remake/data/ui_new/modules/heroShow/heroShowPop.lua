local base = ed.ui.popwindow
local heroShow = newclass(base.mt)
ed.ui.heroShowPop = heroShow
ed.UITool.registViewOpenFunc("heroShowPop", function(param)
  heroShow.create(param):popWindow()
end)
heroShow.heroMode = {
  layerBase = nil,
  layerSkill = nil,
  layerSkin = nil,
  layerShard = nil
}
heroShow.indexKey = {
  "layerBase",
  "layerSkill",
  "layerSkin",
  "layerShard"
}

function heroShow.create(param)
  if param.type == "notHave" then
    param = {
      heros = {
        {
          index = 1,
          _tid = param.id,
          _stars = 2,
          _level = 1,
          _rank = 1,
          _items = {}
        }
      },
      index = 1
    }
  end
  return setmetatable(base.create("heroShowPop"), heroShow.mt):init(param)
end

function heroShow.getHeroInfo(param)
  local level = param._level or 1
  local data = {
    _stars = 5,
    _level = ed.parameter.team_level_max,
    _rank = ed.parameter.unit_max_rank,
    _state = "idle",
    _exp = 0,
    _gs = 0,
    _items = {},
    _tid = 1,
    _skill_levels = {
      level,
      level,
      level,
      level,
      level
    }
  }
  for i = 1, 6 do
    table.insert(data._items, {
      _index = i,
      _item_id = "max",
      _exp = 0
    })
  end
  for k, v in pairs(param or {}) do
    data[k] = v
  end
  
  local function getEquipIdFromTb(hid, slot, rank)
    local slotStr = string.format("Equip%d ID", slot)
    return ed.getDataTable("hero_equip")[hid][rank][slotStr]
  end
  
  for i, v in pairs(data._items) do
    v._item_id = v._item_id and type(v._item_id) == "number" and v._item_id or getEquipIdFromTb(data._tid, i, data._rank)
  end
  if not data._shard then
    local cfg = ed.heroDetailManager.getHeroIsShard(data._tid) or {}
    if cfg and cfg["Shard ID"] then
      data._shard = {}
      data._shard._id = cfg["Shard ID"]
      data._shard._level = ed.ui.heroDetailScene.newShard.data.getHeroShardMaxLv(data._shard._id)
    end
  end
  return data
end

function heroShow:init(param)
  self:initui()
  self:setBtnTouch()
  self.heros = param
  self:pageInitShow(self.getHeroInfo(param.heros[param.index]))
  self:show({skipAnim = true})
  return self
end

function heroShow:initui()
  self.containers, self.ui = ed.editorui(ed.uieditor.herodetail)
  self.container:addChild(self.containers)
  self.ui.btn4:setPosition(self.ui.btn3:getPosition())
  self.ui.btn3:setPosition(self.ui.btn5:getPosition())
  self.ui.btn5:setVisible(false)
  self:initWinsize(self.ui)
end

function heroShow:setBtnTouch()
  local function btnUp(idx)
    self.ui["btn_select" .. self.showPage]:setVisible(false)
    
    self.ui["btn_select" .. idx]:setVisible(true)
    self.showPage = idx
    self.param = self.getHeroInfo(self.heros.heros[self.heros.index]) or {}
    self:newPageShow()
  end
  
  self.btnUpFun = btnUp
  local index = 1
  
  local function func(node, click, press, normal)
    self:btRegisterButtonClick({
      button = node,
      key = "heroShow_" .. index,
      clickHandler = click,
      force = true,
      pressScale = press or 0.9,
      normalScale = normal or 1,
      clickInterval = 0.5
    })
    index = index + 1
  end
  
  func(self.ui.btn_back, function()
    self:removeUpdateHandler("checkFcaHandler")
    ed.asyncload.isdDirty = false
    self:destroy({skipAnim = true})
  end, 0.75, 0.8)
  func(self.ui.btn1, function()
    btnUp(1)
  end, 1, 1)
  func(self.ui.btn2, function()
    btnUp(2)
  end, 1, 1)
  func(self.ui.btn3, function()
    btnUp(3)
  end, 1, 1)
  func(self.ui.btn4, function()
    btnUp(4)
  end, 1, 1)
  func(self.ui.arrow_left, function()
    self:pageRefresh(-1)
  end, 1.4, 1.5)
  func(self.ui.arrow_right, function()
    self:pageRefresh(1)
  end, 1.4, 1.5)
end

function heroShow:pageInitShow(param)
  self.param = param or {}
  self.showPage = self.param.showPage or 1
  if self.oldShowPage and self.oldShowPage == self.showPage then
    return
  end
  self:newPageShow()
  self.ui.arrow_left:setVisible(1 < self.heros.index)
  self.ui.arrow_right:setVisible(self.heros.index < #self.heros.heros)
  if ed.heroDetailManager.getHeroIsShard(self.heros.heros[self.heros.index]._tid) then
    self.ui.btn4:setVisible(true)
  else
    self.ui.btn4:setVisible(false)
  end
end

function heroShow:pageRefresh(up)
  self.heros.index = ed.clamp(self.heros.index + up, 1, #self.heros.heros)
  self.ui.arrow_left:setVisible(self.heros.index > 1)
  self.ui.arrow_right:setVisible(self.heros.index < #self.heros.heros)
  if self.indexKey[self.showPage] ~= "layerShard" or ed.heroDetailManager.getHeroIsShard(self.heros.heros[self.heros.index]._tid) then
  else
    self.btnUpFun(1)
  end
  if ed.heroDetailManager.getHeroIsShard(self.heros.heros[self.heros.index]._tid) then
    self.ui.btn4:setVisible(true)
  else
    self.ui.btn4:setVisible(false)
  end
  self.pageMode[self.indexKey[self.oldShowPage]]:refresh(self.getHeroInfo(self.heros.heros[self.heros.index]))
end

function heroShow:newPageShow()
  if self.heroMode[self.indexKey[self.showPage]] then
    self.pageMode = self.pageMode or {}
    if self.oldShowPage then
      self.pageMode[self.indexKey[self.oldShowPage]]:show(false)
    end
    if self.pageMode[self.indexKey[self.showPage]] then
      self.pageMode[self.indexKey[self.showPage]]:show(true, self.getHeroInfo(self.heros.heros[self.heros.index]))
    else
      local page = self.heroMode[self.indexKey[self.showPage]].create(self, self.param)
      if page.container then
        self.ui.bg:addChild(page.container)
      end
      self.pageMode[self.indexKey[self.showPage]] = page
    end
    self.oldShowPage = self.showPage
  end
end

function heroShow:initWinsize()
  local fixWidth = (ed.display.winSize.width - 960) * 0.66
  self.ui.bg:setContentSize(CCSizeMake(self.ui.bg:getContentSize().width + fixWidth, self.ui.bg:getContentSize().height))
  self.ui.btn_back:setPositionX(self.ui.btn_back:getPositionX() + fixWidth)
  self.ui.arrow_left:setPositionX(self.ui.arrow_left:getPositionX() - fixWidth / 2)
  self.ui.arrow_right:setPositionX(self.ui.arrow_right:getPositionX() + fixWidth / 2)
  self.ui.arrow_left:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(1.5, 255), CCFadeTo:create(1.5, 0))))
  self.ui.arrow_right:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(1.5, 255), CCFadeTo:create(1.5, 0))))
  ed.setLabelStroke(self.ui.label_btn_select1, ccc3(255, 252, 231), 1)
  ed.setLabelStroke(self.ui.label_btn_select2, ccc3(255, 252, 231), 1)
  ed.setLabelStroke(self.ui.label_btn_select3, ccc3(255, 252, 231), 1)
  ed.setLabelStroke(self.ui.label_btn_select4, ccc3(255, 252, 231), 1)
  ed.setLabelStroke(self.ui.label_btn1, ccc3(56, 38, 34), 1)
  ed.setLabelStroke(self.ui.label_btn2, ccc3(56, 38, 34), 1)
  ed.setLabelStroke(self.ui.label_btn3, ccc3(56, 38, 34), 1)
  ed.setLabelStroke(self.ui.label_btn4, ccc3(56, 38, 34), 1)
end
