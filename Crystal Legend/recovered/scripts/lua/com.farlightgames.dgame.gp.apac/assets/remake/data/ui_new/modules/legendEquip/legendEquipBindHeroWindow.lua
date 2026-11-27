local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.legendEquipBindHeroWindow = class
class.BTN_LIST = {
  "all",
  "front",
  "middle",
  "back",
  "str",
  "int",
  "agi"
}
class.BTN_CONFIG = {
  all = {
    text = T("\229\133\168\233\131\168"),
    filter = function(unitCfg)
      return true
    end
  },
  front = {
    text = T("\229\137\141\230\142\146"),
    filter = function(unitCfg)
      return unitCfg["Position Type"] == T("\229\137\141\230\142\146")
    end
  },
  middle = {
    text = T("\228\184\173\230\142\146"),
    filter = function(unitCfg)
      return unitCfg["Position Type"] == T("\228\184\173\230\142\146")
    end
  },
  back = {
    text = T("\229\144\142\230\142\146"),
    filter = function(unitCfg)
      return unitCfg["Position Type"] == T("\229\144\142\230\142\146")
    end
  },
  str = {
    text = T("\229\138\155\233\135\143"),
    filter = function(unitCfg)
      return unitCfg["Main Attrib"] == "STR"
    end
  },
  int = {
    text = T("\230\153\186\229\138\155"),
    filter = function(unitCfg)
      return unitCfg["Main Attrib"] == "INT"
    end
  },
  agi = {
    text = T("\230\149\143\230\141\183"),
    filter = function(unitCfg)
      return unitCfg["Main Attrib"] == "AGI"
    end
  }
}
ed.UITool.registViewOpenFunc("legendEquipBindHeroWindow", function(param)
  local window = ed.ui.legendEquipBindHeroWindow.create(param)
  window:show()
  window:popWindow()
end)

function class.create(param)
  local self = base.create("legendEquipBindHeroWindow")
  setmetatable(self, class.mt)
  self:init(param or {})
  return self
end

function class:init(param)
  self.selectFilterType = "all"
  self.selectHeroId = nil
  self.confirmCallBack = param.confirmCallBack
  self.legendEquip = param.legendEquip
  self.heroList = {}
  self:initView()
  self:addTouchEvent()
  self.refreshCliprectConfig = {
    draglist = self.tableView.dragList
  }
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.legend_equip_bind_hero_window)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  self:initTableView()
  self:createAllFilterBtn()
  self:refreshBtnFilter()
  self:refreshTableView()
end

function class:initLabels()
  ed.setLabelShadow(self.ui.label_confirm, ccc3(0, 0, 0), ccp(0, 2))
end

function class:initTableView()
  local size = self.ui.panel_list:getContentSize()
  self.delegate = {
    numberOfCells = function()
      return #self.heroList
    end,
    cellSizeFromIndex = function(index)
      return self:getIconSize()
    end,
    createCell = function(index)
      local hero = self.heroList[index]
      local icon = self:createHeroIcon(hero)
      return icon, {hero = hero}
    end,
    doPressIn = function(cell, x, y)
      local node = cell.node
      node.heroIcon:setScale(0.95)
    end,
    cancelPressIn = function(cell)
      local node = cell.node
      node.heroIcon:setScale(1)
    end,
    doClickIn = function(cell, x, y)
      local data = cell.data
      local node = cell.node
      self:onClickHeroIcon(data.hero)
    end
  }
  local param = {
    delegate = self.delegate,
    container = self.ui.panel_list,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 9,
    dragMode = 1,
    touchpriority = -300,
    offset = {0, 0},
    noshade = true
  }
  self.tableView = Tableview.create(param)
end

function class:refreshTableView()
  self.heroList = {}
  for index, hero in pairs(ed.player:getAllHero()) do
    local heroId = hero._tid
    local unitCfg = ed.getDataTable("Unit")[heroId]
    local filter = self.BTN_CONFIG[self.selectFilterType].filter
    if filter(unitCfg) then
      table.insert(self.heroList, hero)
    end
  end
  table.sort(self.heroList, ed.cmpSort({
    {
      getValue = function(hero)
        return ed.heroDetailManager:getLegendEquipUnlock(hero._tid) and 0 or 1
      end
    },
    {
      getValue = function(hero)
        local heroLegendEquip = hero._legend_equip
        local legendEquip = heroLegendEquip and heroLegendEquip._equip
        return legendEquip and 1 or 0
      end
    },
    {
      getValue = function(hero)
        return ed.player:isHeroCollect(hero._tid) and 0 or 1
      end
    },
    {key = "_level", reverse = true},
    {key = "_rank", reverse = true},
    {key = "_stars", reverse = true},
    {
      getValue = function(hero)
        return ed.getDataTable("Unit")[hero._tid]["Initial Stars"]
      end,
      reverse = true
    },
    {key = "_gs", reverse = true},
    {key = "_tid"}
  }))
  self.tableView:reloadData()
end

function class:getIconSize()
  return CCSizeMake(90, 90)
end

function class:createHeroIcon(hero)
  local container = ed.createSprite()
  container:setContentSize(self:getIconSize())
  local heroLegendEquip = hero._legend_equip
  local legendEquip = heroLegendEquip and heroLegendEquip._equip
  local isSelect = hero._tid == self.selectHeroId
  local isUnlock = ed.heroDetailManager:getLegendEquipUnlock(hero._tid)
  local heroInfo = ed.readhero.createIconByHero(hero, {
    isShowLegendEquip = ed.openLegendEquip()
  })
  local heroIcon = heroInfo.icon
  heroInfo:showLegendEquip(not ed.openLegendEquip())
  container:addChild(heroIcon)
  ed.layout.centerInParent(heroIcon)
  local selectMask = CCLayerColor:create(ccc4(0, 0, 0, 150))
  selectMask:setContentSize(CCSizeMake(77, 77))
  heroIcon:addChild(selectMask)
  ed.layout.centerInParent(selectMask)
  local image_select = ed.createSprite("UI/alpha/1080P/package/selected.png")
  selectMask:addChild(image_select)
  ed.layout.centerInParent(image_select)
  selectMask:setVisible(isSelect)
  if legendEquip or not isUnlock then
    local unableMask = CCLayerColor:create(ccc4(0, 0, 0, 150))
    unableMask:setContentSize(CCSizeMake(77, 77))
    heroIcon:addChild(unableMask)
    ed.layout.centerInParent(unableMask)
  end
  container.heroIcon = heroIcon
  container.selectMask = selectMask
  return container
end

function class:refreshBtnFilter()
  for index, btn in ipairs(self.btnFilterList) do
    local isSelect = self.selectFilterType == btn.key
    btn.btnNormal:setVisible(not isSelect)
    btn.btnSelect:setVisible(isSelect)
  end
end

function class:createAllFilterBtn()
  self.btnFilterList = {}
  local totalWidth = 0
  for index, key in ipairs(self.BTN_LIST) do
    local btn, size = self:createFilterBtn(key)
    self.ui.btn_filter_bg:addChild(btn)
    table.insert(self.btnFilterList, btn)
    btn:setPosition(ccp(totalWidth + size.width / 2, 16.5))
    totalWidth = totalWidth + size.width
    self:btRegisterButtonClick({
      button = btn,
      key = "btn_filter" .. key,
      clickHandler = function()
        self:onClickBtnFilter(key)
      end,
      force = true,
      clickInterval = 0.3,
      pressScale = 0.95
    })
  end
end

function class:createFilterBtn(key)
  local btnCfg = self.BTN_CONFIG[key]
  local btn = ed.createSprite()
  local size = CCSizeMake(110, 33)
  btn:setContentSize(size)
  local btnNormal = ed.createSprite()
  local labelNormal = ed.createLabelTTF(btnCfg.text, 17)
  ed.setLabelColor(labelNormal, ed.toccc3(16776423))
  btnNormal:addChild(labelNormal)
  local btnSelect = ed.createSprite("UI/alpha/1080P/pet/pet_room_tag_chosen_2.png")
  local labelSelect = ed.createLabelTTF(btnCfg.text, 17)
  ed.setLabelColor(labelSelect, ed.toccc3(16776423))
  btnSelect:addChild(labelSelect)
  ed.layout.centerInParent(labelSelect)
  btn.key = key
  btn.btnNormal = btnNormal
  btn.btnSelect = btnSelect
  btn:addChild(btnNormal)
  btnNormal:setPosition(ccp(55, 16.5))
  btn:addChild(btnSelect)
  btnSelect:setPosition(ccp(55, 16.5))
  return btn, size
end

function class:onClickHeroIcon(hero)
  local heroLegendEquip = hero._legend_equip
  local legendEquip = heroLegendEquip and heroLegendEquip._equip
  if legendEquip then
    ed.showToast(T("\232\175\165\232\139\177\233\155\132\229\183\178\231\169\191\230\136\180\228\188\160\229\165\135\232\163\133\229\164\135"))
    return
  end
  local isUnlock = ed.heroDetailManager:getLegendEquipUnlock(hero._tid)
  if not isUnlock then
    ed.showToast(T("\232\139\177\233\155\132\232\190\190\229\136\17680\231\186\167\239\188\140\231\180\171+2\233\152\182\229\144\142\229\143\175\231\169\191\230\136\180\228\188\160\229\165\135\232\163\133\229\164\135"))
    return
  end
  self.selectHeroId = hero._tid
  self.tableView:staticSync()
end

function class:onClickBtnFilter(key)
  if self.selectFilterType == key then
    return
  end
  self.selectFilterType = key
  self:refreshBtnFilter()
  self:refreshTableView()
end

function class:onClickBtnConfirm()
  if not self.selectHeroId then
    ed.showToast(T("\232\175\183\233\128\137\230\139\169\228\184\128\228\184\170\232\139\177\233\155\132"))
    return
  end
  if self.legendEquip._next_unequip_time and self.legendEquip._next_unequip_time > ed.getServerTime() then
    ed.UITool.openView("legendEquipBindConfirmWindow", {
      legendEquip = self.legendEquip,
      confirmCallBack = function()
        self:close()
      end
    })
    return
  end
  self:close()
end

function class:close()
  if self.confirmCallBack then
    self.confirmCallBack(self.selectHeroId)
  end
  self:destroy()
end

function class:addTouchEvent()
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "clickOut",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
  ed.UITool.registerBtn(self, "btn_confirm", function()
    self:onClickBtnConfirm()
  end, {normalScale = 1.2, pressScale = 1.15})
end
