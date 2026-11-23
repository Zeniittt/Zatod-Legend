local base = ed.ui.popwindow
local funOpenWindow = newclass(base.mt)
ed.ui.funOpenWindow = funOpenWindow
local mapCfg = ed.ui.configs.mainSceneMap
local BuilddingType = mapCfg.builddingType
local unlockFunc = {
  SevenDayAssist = function()
    ed.SevenDayManager.open = true
    ed.SevenDayManager.redLight = true
    FireEvent("RefreshRightTopButtons")
  end,
  FeaturePreview = function()
    ed.featurePreviewManager.isOpen = true
    ed.featurePreviewManager.red = true
    FireEvent("RefreshRightTopButtons")
  end
}
local ignoreCommonList = {
  "SpeedHelper*3",
  "SpeedHelper*0.5"
}
funOpenWindow.ignoreCommonList = ignoreCommonList

function funOpenWindow.create(lv, newLv, vitality)
  local self = base.create("funOpenWindow", {notBlurBg = true})
  setmetatable(self, funOpenWindow.mt)
  funOpenWindow.eventScope = {}
  self.lv = lv
  self.newLv = newLv
  self:init()
  return self
end

function funOpenWindow:init()
  self:initView()
  self:addEventListener()
end

function funOpenWindow:splitFunction()
  local modules = ed.playerlimit:getLevelUpOpenedModules(self.lv, self.newLv)
  local buildingsFun = {}
  local commonFun = {}
  for i, v in ipairs(modules) do
    if unlockFunc[v[1]] then
      unlockFunc[v[1]]()
    end
    if BuilddingType[v[1]] then
      table.insert(buildingsFun, v)
    elseif not ed.isElementInTable(v[1], self.ignoreCommonList) then
      table.insert(commonFun, v)
    end
    FireEvent(ed.guide.eventNames.FUNCTION_OPEN, v[1])
  end
  self.buildingsFun = buildingsFun
  self.commonFun = commonFun
end

function funOpenWindow:initView()
  local container, ui = ed.editorui(ed.uieditor.playerFunctionOpen)
  self.ui = ui
  self.container:addChild(container)
  local cfg
  local vitality = ed.player:getVitality()
  for lv = self.lv, self.newLv - 1 do
    cfg = ed.playerlimit.row(lv)
    if cfg then
      vitality = vitality - cfg["Vitality Reward"]
    end
  end
  
  local function setInfo(key, lvl, vitality)
    cfg = ed.playerlimit.row(lvl)
    ui[key .. "_1"]:setString(lvl)
    ui[key .. "_2"]:setString(math.max(vitality, 0))
    ui[key .. "_3"]:setString(cfg["Max Vitality"])
    ui[key .. "_4"]:setString(cfg["Max Hero Level"])
  end
  
  setInfo("pro_value", self.lv, vitality)
  setInfo("pro_value_new", self.newLv, ed.player:getVitality())
  ui.img_title:setZOrder(1)
  self:splitFunction()
  local x, y = ui.img_title:getPosition()
  local light1 = ed.createFcaNode("eff_UI_pvp_newrecord_light")
  light1:setPosition(ccp(x, y))
  ui.img_title:getParent():addChild(light1)
  ed.getCurrentScene():addFca(light1)
  self.effect = light1
  local light2 = ed.createFcaNode("eff_UI_pvp_newrecord_particles")
  light2:setPosition(ccp(x, y))
  ui.img_title:getParent():addChild(light2, 2)
  ed.getCurrentScene():addFca(light2)
  self.effect1 = light2
  local bgSize = ui.item_1:getContentSize()
  for i = 1, 4 do
    ui["pro_name_" .. i]:setAnchorPoint(ccp(0, 0.5))
    ui["pro_name_" .. i]:setPosition(ccp(38, bgSize.height * 0.5))
  end
end

function funOpenWindow:showOpenBuilding(idx)
  local building = self.buildingsFun[idx]
  if not building then
    return false
  end
  self.ui.bg:setVisible(false)
  self.ui.panel_info:setVisible(false)
  self.ui.panel_function:setVisible(false)
  self.ui.bg_buildling:setVisible(true)
  self.ui.img_title:setVisible(false)
  self.ui.icon_tips_bg:removeAllChildrenWithCleanup(true)
  self.mainLayer:setTouchEnabled(false)
  self:listenTimer(Timer:Once(0.75), function()
    if not tolua.isnull(self.mainLayer) then
      self.mainLayer:setTouchEnabled(true)
    end
  end)
  local fca = ed.createFcaNode("eff_UI_Main_Building_Unlock")
  self:addFca(fca)
  self.ui.icon:setScale(0.95)
  ed.UITool.replaceUI(self.ui, "bg_buildling", "fca_build", fca)
  ed.setTexture(self.ui.icon, string.format("UI/alpha/1080P/main/unlock/%s.png", string.lower(building[1])))
  local text = string.format("<lable color=ccc3(112,255,84) strokeSize=2 strokeColor=ccc3(23,49,31)>%s </lable><lable color=ccc3(254,225,109) strokeSize=2 strokeColor=ccc3(127,64,18)>%s</lable><lable color=ccc3(112,255,84) strokeSize=2 strokeColor=ccc3(23,49,31)> %s</lable>", T("\230\129\173\229\150\156"), building[2], T("\229\188\128\230\148\190\229\149\166\239\188\129"))
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = text,
    fontSize = 18,
    align = "CENTER",
    maxWidth = self.ui.icon_tips_bg:getContentSize().width
  })
  autoText.node:setPositionY(20)
  self.ui.icon_tips_bg:addChild(autoText.node)
  return true
end

function funOpenWindow:showCommonFuc()
  if #self.commonFun == 0 or self.isShowLabel then
    return false
  end
  local ui = self.ui
  self.ui.bg:setVisible(false)
  self.ui.panel_info:setVisible(false)
  self.ui.panel_function:setVisible(true)
  self.ui.bg_buildling:setVisible(false)
  self.ui.img_title:setVisible(false)
  local fca = ed.createFcaNode("eff_UI_Main_WithoutBuilding_Unlock")
  self:addFca(fca)
  ed.UITool.replaceUI(self.ui, "panel_function", "bg_function", fca)
  self.mainLayer:setTouchEnabled(false)
  self:listenTimer(Timer:Once(0.75), function()
    self.mainLayer:setTouchEnabled(true)
  end)
  local names = ""
  for i, v in ipairs(self.commonFun) do
    names = names .. v[2]
    if i < #self.commonFun then
      names = names .. (EDCurLanguage == "en" and ", " or "\227\128\129")
    end
  end
  local text = string.format("<lable color=ccc3(112,255,84) strokeSize=2 strokeColor=ccc3(23,49,31)>%s </lable><lable color=ccc3(254,225,109) strokeSize=2 strokeColor=ccc3(127,64,18)>%s</lable><lable color=ccc3(112,255,84) strokeSize=2 strokeColor=ccc3(23,49,31)> %s</lable>", T("\230\129\173\229\150\156"), names, T("\229\188\128\230\148\190\229\149\166\239\188\129"))
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = text,
    fontSize = 18,
    align = "CENTER",
    maxWidth = 492
  })
  local width, height = autoText:getCurContentSize()
  autoText.node:setPosition(ccp(275 - width / 2, 60 + height / 2))
  autoText.node:setOpacity(0)
  autoText.node:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.9), CCFadeIn:create(0.3)))
  ui.panel_function:addChild(autoText.node)
  self.isShowLabel = true
  return true
end

function funOpenWindow:addEventListener()
  local idx = 1
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event == "ended" then
        if not self:showCommonFuc() then
          if not self:showOpenBuilding(idx) then
            idx = nil
            self:destroy()
            return
          else
            idx = idx + 1
          end
        end
        if self.effect then
          self.effect:setVisible(false)
        end
        if self.effect1 then
          self.effect1:setVisible(false)
        end
      end
      return true
    end,
    key = "funOpenWindow",
    priority = -999
  })
end
