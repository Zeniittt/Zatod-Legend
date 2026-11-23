local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.SoloSelectPowerWin = class

function class:initData(data)
  self.powerOptions = data._power_options
  self.powerPos = data._power_pos
  self.fRefreshTimes = data._max_free_refresh_times - data._cur_free_refresh_times
  self.cPayRefreshTimes = data._cur_pay_refresh_times
  self.mPayRefreshTimes = data._max_pay_refresh_times
  self.coins = data._pay_coin_num
  self.payLeftRTimes = math.min(self.mPayRefreshTimes - self.cPayRefreshTimes, self.coins)
end

function class:createChessPowerIcon(key)
  local powerInfo = ed.getDataTable("SoloPower")[key]
  local icon = ed.createSprite(powerInfo.Icon)
  icon:setScale(1.5)
  local clipNode = ed.createClippingNodeOnly("UI/alpha/1080P/chesscard/hero/hero_unlock.png")
  clipNode:addChild(icon)
  return clipNode
end

function class:initUI()
  ed.editorui(ed.uieditor.SoloSelectWin, {
    container = self.container,
    ui = self.ui
  })
  self.ui.btn_ok:setVisible(false)
  for i = 1, 3 do
    self.ui["card" .. i]:setPositionY(self.ui["card" .. i]:getPositionY() + 100)
    self.ui["card" .. i]:setVisible(false)
    self:listenTimer(Timer:Once(0.05 * i), function()
      if self.powerOptions[i] then
        self.ui["card" .. i]:setVisible(true)
        local powerInfo = ed.getDataTable("SoloPower")[self.powerOptions[i]._power_id]
        local icon = self:createChessPowerIcon(self.powerOptions[i]._power_id)
        ed.UITool.replaceUINew(self.ui, "icon" .. i, icon)
        icon:setZOrder(-1)
        ed.setString(self.ui["name" .. i], powerInfo["HeroPower Name"])
        local text = ed.ui.gradientLabel.create({
          text = powerInfo["HeroPower Name"],
          fontSize = 22.5,
          fontName = ed.fontBold,
          startColor = ed.toccc3(16774069),
          endColor = ed.toccc3(16766830),
          strokeSize = 1.5,
          strokeColor = ed.toccc3(3152392)
        })
        ed.UITool.replaceUINew(self.ui, "name" .. i, text.node)
        ed.setLabelDimensions(self.ui["desc" .. i], CCSizeMake(115, 0))
        local desc = powerInfo.Description:gsub("<[^>]+>", "")
        ed.setString(self.ui["desc" .. i], desc)
        local callfunc = CCCallFunc:create(function()
          local fca = ed.createSpine("effect/eff_UI_solo_treasure_refresh/eff_UI_solo_treasure_refresh", 0.5)
          self.ui["card" .. i]:addChild(fca, 2)
          ed.layout.centerInParent(fca)
          fca:setAnimation(0, "Start", false)
        end)
        self.ui["card" .. i]:runAction(CCSequence:createWithTwoActions(CCMoveBy:create(0.2, ccp(0, -100)), callfunc))
        local fca1 = ed.createSpine("effect/eff_UI_solo_treasure_light/eff_UI_solo_treasure_light", 0.5)
        self.ui["card" .. i]:addChild(fca1, -10)
        ed.layout.centerInParent(fca1)
        fca1:setAnimation(0, "Loop", true)
        fca1:setVisible(false)
        self.ui["spine" .. i] = fca1
      else
        self.ui["card" .. i]:setVisible(false)
      end
    end)
  end
  if self.fRefreshTimes > 0 then
    self.ui.ImageView_9031:setVisible(true)
    self.ui.ImageView_3084:setVisible(false)
  else
    self.ui.ImageView_9031:setVisible(false)
    self.ui.ImageView_3084:setVisible(true)
    ed.setString(self.ui.Label_3085, string.format("%d/%d", self.payLeftRTimes, self.mPayRefreshTimes))
  end
  ed.setLabelStroke(self.ui.Label_11788, ccc3(20, 18, 18), 2)
  ed.setLabelFontName(self.ui.Label_11788, ed.fontBold)
  ed.setLabelStroke(self.ui.Label_9032, ccc3(20, 18, 18), 1)
  ed.setLabelFontName(self.ui.Label_3085, ed.fontBold)
  ed.setLabelStroke(self.ui.Label_3085, ccc3(20, 18, 18), 1)
  ed.setString(self.ui.Label_9032, self.fRefreshTimes)
  ed.setString(self.ui.Label_11796, ed.SoloModel:getTotalGold())
end

function class:registerEvents()
  for i = 1, 3 do
    ed.UITool.registerBtn(self, "card" .. i, function()
      if self.curSelected == i then
        return
      end
      if self.curSelected then
        self.ui["card" .. self.curSelected]:setScale(1)
        self.ui["spine" .. self.curSelected]:setVisible(false)
      end
      self.curSelected = i
      ed.SoloNetwork:sendChooseHeroPower(self.powerPos, self.curSelected, 0)
      self.ui["card" .. i]:setScale(1.1)
      self.ui["spine" .. i]:setVisible(true)
      self.ui.btn_ok:setVisible(true)
    end)
  end
  ed.UITool.registerBtn(self, "btn_ok", function()
    if not self.curSelected then
      return
    end
    ed.SoloNetwork:sendChooseHeroPower(self.powerPos, self.curSelected, 1)
    for j = 1, 3 do
      self.ui["card" .. j]:setVisible(self.curSelected == j)
    end
    self.ui.btn_refresh:setVisible(false)
    local x, y = self.ui.card2:getPosition()
    local action = CCSpawn:create(ccArrayMake({
      CCMoveTo:create(0.6, ccp(x, y)),
      CCScaleTo:create(0.6, 1.3)
    }))
    local action = CCSequence:create(ccArrayMake({
      action,
      CCEaseOut:create(CCScaleTo:create(0.5, 0.95), 0.3),
      CCScaleTo:create(0.05, 1)
    }))
    self.ui["card" .. self.curSelected]:runAction(action)
    self.ui.btn_ok:setVisible(false)
  end, {pressScale = 0.75, normalScale = 0.8})
  self:listenEvent("EventCloseOtherWin", function()
    base.destroy(self, {skipAnim = true})
  end)
  ed.UITool.registerBtn(self, "btn_refresh", function()
    if self.fRefreshTimes <= 0 and 0 >= self.payLeftRTimes then
      ed.showToast(T("\229\136\183\230\150\176\233\129\147\229\133\183\228\184\141\232\182\179"))
      return
    end
    ed.SoloNetwork:sendRefreshChoices(self.fRefreshTimes <= 0)
  end)
end

function class.create(data)
  local self = base.create("SoloSelectPowerWin")
  setmetatable(self, class.mt)
  self:initData(data)
  self:initUI()
  self:registerEvents()
  self:popWindow()
  return self
end
