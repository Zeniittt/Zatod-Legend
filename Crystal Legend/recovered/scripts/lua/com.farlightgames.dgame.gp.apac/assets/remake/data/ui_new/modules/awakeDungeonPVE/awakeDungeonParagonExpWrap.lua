local awakeDungeonParagonExpWrap = newclass()
ed.ui.awakeDungeonParagonExpWrap = awakeDungeonParagonExpWrap

function awakeDungeonParagonExpWrap.create(params)
  local self = {}
  setmetatable(self, awakeDungeonParagonExpWrap.mt)
  self:init(params)
  return self
end

function awakeDungeonParagonExpWrap:init(params)
  self.uiDelegate = params.ui
  self.dungeonMgr = ed.awakeDungeonMgr.getInstance()
  self.uiDelegate.exp_change_bg:setVisible(false)
  local progress = CCProgressTimer:create(self.uiDelegate.image_circle_bar)
  progress:setType(kCCProgressTimerTypeRadial)
  self.uiDelegate.exp_change_bg:addChild(progress)
  self.uiDelegate.exp_change_bg:setCascadeOpacityEnabled(true)
  self.uiDelegate.image_circle_bar:setVisible(false)
  progress:setPosition(self.uiDelegate.image_circle_bar:getPosition())
  self.expBarProgress = progress
end

function awakeDungeonParagonExpWrap:updateNewExpAndLevel(oldExp, oldLevel, newExp, newLevel)
  if newExp == oldExp and newLevel == oldLevel then
    return
  end
  if oldLevel < newLevel then
    if ed.getPopWindow("awakeDungeonLevelUp") then
      return
    end
    ed.UITool.openView("awakeDungeonLevelUp", {oldLevel = oldLevel, newLevel = newLevel})
  end
  self.uiDelegate.exp_change_bg:setOpacity(0)
  self.uiDelegate.exp_change_bg:setVisible(true)
  local oldLevelMaxExp = self.dungeonMgr:getMaxExp(oldLevel)
  local curLevelMaxExp = self.dungeonMgr:getMaxExp(newLevel)
  local curPercent
  if not oldLevelMaxExp or not curLevelMaxExp then
    self.uiDelegate.exp_change_bg:setVisible(false)
    return
  end
  local curPercent = oldExp / oldLevelMaxExp * 100
  self.expBarProgress:setPercentage(curPercent)
  ed.setLabelString(self.uiDelegate.label_exp, string.format("%s/%s", newExp, curLevelMaxExp))
  ed.setLabelString(self.uiDelegate.label_change_level, oldLevel)
  self.uiDelegate.exp_change_bg:stopAllActions()
  self.expBarProgress:stopAllActions()
  local isLevelUp = oldLevel < newLevel
  if isLevelUp then
    ed.setLabelString(self.uiDelegate.label_get_exp, string.format(T("\232\142\183\229\190\151\231\187\143\233\170\140%s"), oldLevelMaxExp - oldExp + newExp))
    self:expChangeBarShow(curPercent, function()
      local action1 = CCProgressTo:create(1, 100)
      local action2 = CCCallFunc:create(function()
        ed.setLabelString(self.uiDelegate.label_change_level, newLevel)
      end)
      local endPercent = newExp / curLevelMaxExp * 100
      local action3 = CCProgressTo:create(1, endPercent)
      local action4 = CCDelayTime:create(1)
      local action5 = CCCallFunc:create(function()
        self:expChangeBarHide(endPercent)
      end)
      self.expBarProgress:runAction(ed.readaction.create({
        t = "seq",
        action1,
        action2,
        action3,
        action4,
        action5
      }))
    end)
  else
    ed.setLabelString(self.uiDelegate.label_get_exp, string.format(T("\232\142\183\229\190\151\231\187\143\233\170\140%s"), newExp - oldExp))
    if curLevelMaxExp then
      self:expChangeBarShow(curPercent, function()
        local endPercent = newExp / curLevelMaxExp * 100
        local action1 = CCProgressTo:create(1, endPercent)
        local action2 = CCDelayTime:create(1)
        local action3 = CCCallFunc:create(function()
          self:expChangeBarHide(endPercent)
        end)
        self.expBarProgress:runAction(ed.readaction.create({
          t = "seq",
          action1,
          action2,
          action3
        }))
      end)
    else
      self:expChangeBarShow(curPercent, function()
        self.expBarProgress:setPercentage(100)
        local action1 = CCDelayTime:create(1)
        local action2 = CCCallFunc:create(function()
          self:expChangeBarHide()
        end)
        self.expBarProgress:runAction(ed.readaction.create({
          t = "seq",
          action1,
          action2
        }))
      end)
    end
  end
end

function awakeDungeonParagonExpWrap:expChangeBarShow(curPercent, callBack)
  self.uiDelegate.exp_change_bg:setVisible(true)
  self.uiDelegate.exp_change_bg:setOpacity(0)
  local showAction = CCFadeIn:create(1.5)
  local callBackAction = CCCallFunc:create(function()
    if callBack then
      callBack()
    end
  end)
  if curPercent then
    self.expBarProgress:runAction(ed.readaction.create({
      t = "seq",
      CCProgressTo:create(1.5, curPercent + 0.001)
    }))
  end
  self.uiDelegate.exp_change_bg:runAction(ed.readaction.create({
    t = "seq",
    showAction,
    callBackAction
  }))
end

function awakeDungeonParagonExpWrap:expChangeBarHide(endPercent, callBack)
  self.uiDelegate.exp_change_bg:setOpacity(255)
  local hideAction = CCFadeOut:create(0.6)
  local callBackAction = CCCallFunc:create(function()
    if callBack then
      callBack()
    end
    self.uiDelegate.exp_change_bg:setVisible(false)
  end)
  if endPercent then
    self.expBarProgress:runAction(ed.readaction.create({
      t = "seq",
      CCProgressTo:create(0.6, endPercent + 0.001)
    }))
  end
  self.uiDelegate.exp_change_bg:runAction(ed.readaction.create({
    t = "seq",
    hideAction,
    callBackAction
  }))
end
