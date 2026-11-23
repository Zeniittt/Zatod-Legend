ed.UITool.registViewOpenFunc("GobackMainScene", function(param)
  ed.GobackNetwork:sendOpenPanel()
end)
local base = ed.ui.commonscene
local GobackMainScene = newclass(base.mt)
ed.ui.GobackMainScene = GobackMainScene
local config = {
  {
    name = "loginPage",
    class = "login",
    iconNormal = "UI/alpha/1080P/goback/goback_tag_img_login_a.png",
    displayName = T("\228\184\131\230\151\165\231\164\188\233\129\135"),
    iconSelected = "UI/alpha/1080P/goback/goback_tag_img_login_b.png",
    redLight = function()
      return ed.GobackManager:getLoginPageLight()
    end
  },
  {
    name = "taskPage",
    class = "task",
    iconNormal = "UI/alpha/1080P/goback/goback_tag_img_line_reward_a.png",
    displayName = T("\229\155\158\229\189\146\229\138\169\229\138\155"),
    iconSelected = "UI/alpha/1080P/goback/goback_tag_img_line_reward_b.png",
    redLight = function()
      return ed.GobackManager:getTaskPageLight()
    end
  },
  {
    name = "privilegePage",
    class = "privilege",
    iconNormal = "UI/alpha/1080P/goback/goback_tag_img_bonus_a.png",
    displayName = T("\229\155\158\229\189\146\231\137\185\230\157\131"),
    iconSelected = "UI/alpha/1080P/goback/goback_tag_img_bonus_b.png",
    redLight = function()
      return false
    end
  },
  {
    name = "giftPage",
    class = "gift",
    iconNormal = "UI/alpha/1080P/goback/goback_tag_img_goods_a.png",
    displayName = T("\231\137\185\230\131\160\232\161\165\231\187\153"),
    iconSelected = "UI/alpha/1080P/goback/goback_tag_img_goods_b.png",
    redLight = function()
      return ed.GobackManager:getGiftPageLight()
    end
  }
}

function GobackMainScene:initData()
  self.tabIndex = 1
end

function GobackMainScene:adaptUI()
  ed.layout.layoutWithMagin(self.ui.bg_title, {left = 70, top = 18})
  ed.layout.layoutWithMagin(self.ui.bg_btn, {left = 70})
end

function GobackMainScene:initLabels()
end

function GobackMainScene:clickTaskGoto(data)
  ed.activityTaskTool.taskSkip(data.type, data.progressId)
end

function GobackMainScene:createTab(data)
  local container, ui = ed.editorui(ed.uieditor.GobackTabItem)
  ed.UITool.replaceUI(ui, "selected", "icon2", ed.createSprite(data.iconSelected))
  ed.setLabelStroke(ui.title1, ed.toccc3(9193746), 1)
  ed.setLabelStroke(ui.title2, ed.toccc3(159665177), 1)
  ed.setString(ui.title2, data.displayName)
  ed.UITool.replaceUI(ui, "unselected", "icon1", ed.createSprite(data.iconNormal))
  ed.setString(ui.title1, data.displayName)
  local redLight = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
  container:addChild(redLight, 1)
  ui.redLight = redLight
  redLight:setPosition(ccp(135, 42))
  ed.adaptLabel(ui.title2, {maxWidth = 100, minScale = 0.9})
  ed.adaptLabel(ui.title1, {maxWidth = 100, minScale = 0.9})
  return container, ui
end

function GobackMainScene:refreshRedLight()
  for k, v in ipairs(self.tabList) do
    v.redLight:setVisible(v.data.redLight())
  end
  if ed.GobackManager.onceFlag and self.mailRed then
    self.mailRed:setVisible(false)
  end
end

function GobackMainScene:createTabList()
  self.tabList = {}
  for k, v in ipairs(config) do
    local container, ui = self:createTab(v)
    container:setPosition(ccp(-22, 290 - 58.5 * k))
    table.insert(self.tabList, ui)
    ui.data = v
    self.ui.bg_btn:addChild(container)
    self:btRegisterButtonClick({
      button = ui.bg,
      key = "btn" .. k,
      clickHandler = function(_, x, y)
        self:doClickBtn(k)
      end,
      clickInterval = 0.3,
      priority = -1
    })
  end
  for k, v in ipairs(self.tabList) do
    v.selected:setVisible(k == self.tabIndex)
    v.unselected:setVisible(k ~= self.tabIndex)
  end
  self:refreshRedLight()
end

function GobackMainScene:initUI()
  ed.editorui(ed.uieditor.GobackScene, {
    container = self.mainLayer,
    ui = self.ui
  })
  ed.GobackManager.actOpenLight = false
  self:setBackButton(function()
    ed.GobackManager:setNotifyRedLight(false)
    FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.GOBACK)
    ed.GobackManager.scene = nil
    ed.playEffect(ed.sound.common.back)
  end)
  self:adaptUI()
  self.ui.title:setVisible(false)
  ed.UITool.createSceneTitle(T("\229\155\158\229\189\146\229\165\189\231\164\188"), self.ui.bg_title, {
    position = ccp(120, 18),
    anchor = ccp(0.5, 0.5),
    maxWidth = 180
  })
  if not ed.GobackManager.onceFlag then
    local redLight = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
    redLight:setPosition(ccp(30, 30))
    self.mailRed = redLight
    self.ui.btn_mail:addChild(redLight)
  end
  self:createTabList()
end

function GobackMainScene:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_mail", function()
    ed.ui.GobackMailWin.create()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "bg_rule", function()
    ed.ui.GobackRuleWin.create():popWindow()
  end, {pressScale = 0.95})
end

function GobackMainScene:refreshBtnState(index)
  for k, v in ipairs(self.tabList) do
    v.selected:setVisible(k == self.tabIndex)
    v.unselected:setVisible(k ~= self.tabIndex)
  end
end

function GobackMainScene:doClickBtn(index)
  if self.tabIndex == index then
    return
  end
  self.tabIndex = index
  self:refreshBtnState(index)
  self.currentLayer:setVisible(false)
  self:refreshLayer()
end

function GobackMainScene:registerEvents()
  self:listenEvent("GobackConfirmSuccess", function()
    self.ui.btn_mail:removeAllChildrenWithCleanup(true)
  end)
  self:listenEvent("GobackRedChange", function()
    self:refreshRedLight()
  end)
  local showAlert = true
  self:listenTimer(Timer:Always(1), function()
    if showAlert and ed.getCurrentScene().identity == "GobackMainScene" and ed.GobackManager.endTime < ed.getServerTime() then
      ed.GobackManager:setActiving(false)
      ed.GobackManager.activityId = 0
      FireEvent("RefreshRightTopButtons")
      showAlert = false
      ed.showAlertDialog({
        text = T("\230\180\187\229\138\168\229\183\178\231\187\147\230\157\159"),
        skipDestroyAnim = true,
        handler = function()
          ed.popScene()
        end
      })
    end
  end)
end

function GobackMainScene:refreshLayer()
  local layerConfig = config[self.tabIndex]
  if not layerConfig then
    return
  end
  if self[layerConfig.name] then
    self[layerConfig.name].mainLayer:setVisible(true)
    self[layerConfig.name]:refreshUI(true)
  else
    self[layerConfig.name] = ed.ui.GobackMainScene[layerConfig.class].create({scene = self})
    self.mainLayer:addChild(self[layerConfig.name].mainLayer, -1)
  end
  self.currentLayer = self[layerConfig.name].mainLayer
end

function GobackMainScene.create()
  local self = base.create("GobackMainScene", {noBottomButton = true})
  setmetatable(self, GobackMainScene.mt)
  self:initData()
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:registerOnEnterHandler("GobackMainSceneEnter", function()
    self:refreshLayer()
  end)
  ed.GobackManager.scene = self
  return self
end
