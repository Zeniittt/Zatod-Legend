module("ed.battleprepare", package.seeall)
UIPool = {}
UIPool.__index = UIPool

function UIPool:create(uiview, param)
  local obj = {}
  setmetatable(obj, self)
  obj:init(uiview, param)
  return obj
end

function UIPool:release()
  self.ui = {}
  self.layer = nil
  self.heroPool:release()
  self.presetPool:release()
  self.heroPool = nil
  self.presetPool = nil
end

function UIPool:init(uiview, param)
  local param = param or {}
  self.param = param
  self.type = param.type
  self.layer = CCLayer:create()
  self.uiview = uiview
  self.ui = {}
  self:initWindow()
  self:createTabs()
  self:registerEvent()
end

function UIPool:createTabs()
  self.heroPool = HeroPool:create(self.uiview, self.param)
  self.layer:addChild(self.heroPool:getView(), 50)
  self.presetPool = Preset:create(self.uiview, self.param)
  self.presetPool:setVisible(false)
  self.layer:addChild(self.presetPool:getView(), 51)
  self.curTab = "team"
  self.tabHash = {
    team = self.heroPool,
    preset = self.presetPool
  }
end

function UIPool:initWindow()
  local container, ui = ed.editorui(ed.uieditor.battle_prepare)
  self.layer = container
  self.ui = ui
  if self.param.type == "incubus" then
    self.ui.frame:setPosition(ccp(434, 240))
    self.ui.frame:setContentSize(CCSizeMake(664, 440))
    self.ui.line:setPosition(ccp(524, 223))
    self.ui.line:setContentSize(CCSizeMake(6.25, 417))
    self.ui.piont_1:setPosition(ccp(107, 435))
    self.ui.piont_2:setPosition(ccp(218, 435))
    self.ui.piont_3:setPosition(ccp(331, 435))
    self.ui.piont_4:setPosition(ccp(442, 435))
    self.ui.piont_5:setPosition(ccp(556, 435))
    self.ui.piont_frame_1:setPosition(ccp(655, 430))
    self.ui.piont_frame_2:setPosition(ccp(8, 430))
  end
end

function UIPool:getView()
  return self.layer
end

function UIPool:setVisible(visible)
  self.layer:setVisible(visible)
end

function UIPool:isLoadEnd()
  return self.heroPool:isLoadEnd()
end

function UIPool:registerEvent()
  WaitEvent("changeChannel", function(channel)
    self:changeChannel(channel)
  end)
  WaitEvent("changeTab", function(tab)
    self:changeTab(tab)
  end)
end

function UIPool:changeChannel(channel)
  if self.curTab == "team" then
    self.heroPool:changeChannel(channel)
  elseif self.curTab == "mercenary" then
    self.mercenary:changeChannel(channel)
  end
end

function UIPool:changeTab(tab)
  if tab == "recommend" or tab == "team" then
    self.heroPool:changeTab(tab)
    tab = "team"
  end
  self.curTab = tab
  if not self.tabHash[tab] then
    self:createTab(tab)
    return
  end
  self:refreshTabUI(tab)
end

function UIPool:refreshTabUI(tab)
  for key, ui in pairs(self.tabHash) do
    if key == tab then
      ui:setVisible(true)
    else
      ui:setVisible(false)
    end
  end
end

function UIPool:createTab(tab)
  if tab == "mercenary" then
    self:doCreateMercenary()
  end
end

function UIPool:doCreateMercenary()
  local mercenaryData = self:getMercenaryData()
  if mercenaryData then
    self:createMercenary(mercenaryData)
    self.uiview.controller:initMercenaryMode(mercenaryData)
  else
    manager:sendRequestMercenary(self.type)
  end
end

function UIPool:createMercenary(info)
  self.mercenary = mercenary.create(self.uiview, self.param, info)
  self.layer:addChild(self.mercenary.mainLayer)
  self.tabHash.mercenary = self.mercenary
  self:refreshTabUI("mercenary")
end

function UIPool:getMercenaryData()
  if self.type == "multi_stage" then
    local mercenary = ed.GuildManager.multistageMercenary
    if mercenary then
      return {mercenary}
    end
  end
end

function UIPool:doRecommendReply()
  self.heroPool:doRecommendReply()
end

function UIPool:doMercenaryReply(info)
  if self.type and config:getMercenaryUiInfo(self.type) then
    self:createMercenary(info)
  end
end
