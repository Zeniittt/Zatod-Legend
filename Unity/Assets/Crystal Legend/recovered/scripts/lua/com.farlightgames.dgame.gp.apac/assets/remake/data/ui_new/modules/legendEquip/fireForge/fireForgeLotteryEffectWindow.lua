local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.fireForgeLotteryEffectWindow = class
ed.UITool.registViewOpenFunc("fireForgeLotteryEffectWindow", function(param)
  param = param or {}
  local rewards = param.rewards
  local normalEquipAmount = 0
  local onlyEquipAmount = 0
  for index, reward in ipairs(rewards or {}) do
    local type = reward._type
    local id = reward._id
    local amount = reward._amount
    if type == "item" then
      local typeId = ed.legendEquipTool.getTypeIdByFragmentId(id)
      if typeId and 0 < typeId then
        local legendEquipCfg = ed.getDataTable("LegendEquip")[typeId]
        local fragmentAmount = legendEquipCfg["Fragment Amount"]
        if amount >= fragmentAmount then
          if legendEquipCfg["Is Only"] then
            onlyEquipAmount = onlyEquipAmount + 1
          else
            normalEquipAmount = normalEquipAmount + 1
          end
        end
      end
    elseif type == "legend_equip" then
      local legendEquipCfg = ed.getDataTable("LegendEquip")[id]
      if legendEquipCfg["Is Only"] then
        onlyEquipAmount = onlyEquipAmount + 1
      else
        normalEquipAmount = normalEquipAmount + 1
      end
    end
  end
  local quality
  if 0 < onlyEquipAmount then
    quality = 3
  elseif 0 < normalEquipAmount then
    quality = 2
  else
    quality = 1
  end
  param.quality = quality
  local window = ed.ui.fireForgeLotteryEffectWindow.create(param)
  window:popWindow()
end)

function class.create(param)
  local self = base.create("fireForgeLotteryEffectWindow")
  setmetatable(self, class.mt)
  self:init(param or {})
  return self
end

function class:init(param)
  self.closeCallBack = param.closeCallBack
  self.quality = param.quality or 1
  self.delayTimeCfg = {
    4.733333333333333,
    5.4,
    6
  }
  self:initView()
  self:addTouchEvent()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.fire_forge_lottery_effect_window)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  self:adaptUI()
  if self.quality >= 3 then
    self.ui.btn_skip:setVisible(false)
  else
    self.ui.btn_skip:setVisible(true)
  end
  if self.quality == 3 then
    ed.playEffect(ed.sound.deo.fire_forge_do3)
  elseif self.quality == 2 then
    ed.playEffect(ed.sound.deo.fire_forge_do2)
  elseif self.quality == 1 then
    ed.playEffect(ed.sound.deo.fire_forge_do1)
  end
  local eff = ed.createSpine("effect/eff_UI_fireforge_OpenCard/eff_UI_fireforge_OpenCard", 0.5)
  self.mainLayer:addChild(eff)
  eff:setAnimation(0, "Idle" .. self.quality, false)
  eff:setTimeScale(1.2)
  eff:setPosition(ccp(self.mainLayer:getContentSize().width / 2 + 20, 0))
  local time = self.delayTimeCfg[self.quality] or 4
  local delayTime = CCDelayTime:create(time / 1.2)
  local callFunc = CCCallFunc:create(function()
    self:close()
  end)
  self.mainLayer:runAction(CCSequence:create(ccArrayMake(delayTime, callFunc)))
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_skip, ed.toccc3(3483679), 1)
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.btn_skip, {right = 20, top = 20})
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_skip", function()
    self:close()
  end, {pressScale = 0.95})
end

function class:close()
  self:destroy({skipAnim = true})
  if self.closeCallBack then
    self.closeCallBack()
  end
end
