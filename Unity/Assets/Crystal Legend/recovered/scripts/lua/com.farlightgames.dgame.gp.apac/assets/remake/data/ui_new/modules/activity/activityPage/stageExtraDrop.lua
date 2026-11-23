local class = {}
ed.ui.activitystageExtraDrop = class

function class.create(base, param, pageKey)
  local self = {}
  setmetatable(class, {__index = base})
  setmetatable(self, {__index = class})
  self:init(param, pageKey)
  return self
end

function class:init(param, pageKey)
  self.pageKey = pageKey
  self.activityId = param._id
  self.cfgId = param._cfg_id
  self.endTime = param._end_time
  self:initView()
  self:addListenEvent()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.activity_extra_drop_page)
  self.container = container
  self.ui = ui
  local activityCfg = ed.getDataTable("Activity")[self.cfgId]
  if activityCfg then
    ed.setTexture(self.ui.image_bg, activityCfg.Banner)
  end
  ed.setLabelStroke(self.ui.label_go, ed.toccc3(10641433), 1)
  ed.setLabelStroke(self.ui.label_go, ed.toccc3(10641433), 1)
  ed.setLabelStroke(self.ui.label_left_time_common, ed.toccc3(10041245), 1)
  local tag = activityCfg["Activity Tag"]
  if ed.isElementInTable(tag, {"common", "newyear"}) then
    self:refreshCountDown()
    self.ui.btn_go:setVisible(false)
    self.ui.btn_go_common:setVisible(true)
    self.ui.label_left_time_common:setVisible(true)
    if tag == "newyear" then
      ed.UITool.setPositionBy(self.ui.label_left_time_common, ccp(0, -5))
    end
    self.ui.panel_drop_item_common:setVisible(true)
    local specialLootItemId = activityCfg["Extra AN"][1]
    local specialLootTb = ed.getDataTable("SpecialLoot")
    local dropItemId = specialLootTb[specialLootItemId]["Item Id"]
    local itemIcon = ed.readequip.createIcon(dropItemId)
    self.ui.panel_drop_item_common:addChild(itemIcon)
    ed.layout.centerInParent(itemIcon)
    itemIcon:setZOrder(1)
    self.ui.image_mask:setZOrder(2)
    self:btRegisterButtonClick({
      button = itemIcon,
      key = "click_item",
      clickHandler = function()
        ed.ui.packageDetailWin.create({id = dropItemId}):popWindow()
      end
    })
  else
    self.ui.btn_go:setVisible(true)
    self.ui.btn_go_common:setVisible(false)
    self.ui.label_left_time_common:setVisible(false)
    self.ui.panel_drop_item_common:setVisible(false)
  end
end

function class:refreshCountDown()
  if not self.endTime then
    return
  end
  local leftTime = self.endTime - ed.getServerTime()
  leftTime = math.max(0, leftTime)
  local day = math.floor(leftTime / 86400)
  local hour = math.floor(leftTime % 86400 / 3600)
  local min = math.floor(leftTime % 3600 / 60)
  if day <= 0 and hour <= 0 then
    self.ui.label_left_time_common:setString(T("\229\137\169\228\189\153 %s\230\151\182%s\229\136\134", hour, min))
  else
    self.ui.label_left_time_common:setString(T("\229\137\169\228\189\153 %s\229\164\169%s\230\151\182", day, hour))
  end
end

function class:pageUpDate(param)
end

function class:addListenEvent()
  self:btRegisterButtonClick({
    button = self.ui.btn_go,
    press = self.ui.btn_go_press,
    normalScale = 0.85,
    pressScale = 0.84,
    key = "btn_go",
    clickHandler = function()
      ed.activityTaskTool.openStageSelect()
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_go_common,
    press = self.ui.btn_go_common_press,
    normalScale = 0.7,
    pressScale = 0.65,
    key = "btn_go_common",
    clickHandler = function()
      ed.activityTaskTool.openStageSelect()
    end
  })
end
