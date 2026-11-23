local LoginPage = newclass("g")
local GobackMainScene = ed.ui.GobackMainScene
GobackMainScene.login = LoginPage

function LoginPage:initData(param)
  self.scene = param.scene
  self.loginRewards = ed.GobackManager:getLoginRewads()
end

function LoginPage:refreshData(hero)
end

function LoginPage:initUI()
  local container, ui = ed.editorui(ed.uieditor.GobackLoginPage)
  self.mainLayer = container
  self.ui = ui
  ed.setLabelStroke(ui.time, ed.toccc3(2844450), 1)
  local timeStr = T("\229\183\178\231\187\147\230\157\159")
  if ed.GobackManager.endTime > ed.getServerTime() then
    timeStr = string.format(T("\229\137\169\228\189\153%s"), ed.time2dhmsV2(ed.GobackManager.endTime - ed.getServerTime()))
  end
  ui.time:setString(timeStr)
  self:createDays()
  self:refreshUI()
end

function LoginPage:createDays()
  for i = 1, 7 do
    local icon = ed.createItemIcon(self.loginRewards[i].reward)
    icon:setScale(1)
    self.ui["day" .. i]:addChild(icon)
    icon:setPosition(ccp(50, 75))
    if i == 7 then
      icon:setScale(1)
      icon:setPosition(ccp(78, 129))
    end
    if self.loginRewards[i].state == "Got" then
      local tick = ed.createSprite("UI/alpha/1080P/package/selected.png")
      self.ui["day" .. i]:addChild(tick)
      tick:setPosition(ccp(30, 44))
      ed.setLabelColor(self.ui["label_day" .. i], ed.toccc3(16765076), 1)
      ed.setLabelStroke(self.ui["label_day" .. i], ed.toccc3(7095361), 1)
    else
      ed.setLabelColor(self.ui["label_day" .. i], ed.toccc3(13200933), 1)
      ed.setLabelStroke(self.ui["label_day" .. i], ed.toccc3(16776423), 1)
      if i == 7 then
        ed.setTexture(self.ui["day" .. i], "UI/alpha/1080P/goback/login_reward/goback_login_reward_item_bg_big_1.png")
      else
        ed.setTexture(self.ui["day" .. i], "UI/alpha/1080P/goback/login_reward/goback_login_reward_item_bg_1.png")
      end
      if self.loginRewards[i].state == "CanGet" then
        local light = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
        icon:addChild(light)
        self.ui["light" .. i] = light
        light:setPosition(ccp(44, 44))
        light:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
      end
    end
    self.scene:btRegisterButtonClick({
      button = icon,
      key = "day" .. i,
      clickHandler = function(_, x, y)
        if self.loginRewards[i].state == "CanGet" then
          ed.GobackNetwork:sendLoginReward(i)
        else
          ed.ui.packageDetailWin.create(self.loginRewards[i].reward):popWindow()
        end
      end,
      clickInterval = 0.3,
      priority = -1
    })
  end
end

function LoginPage:refreshUI()
  local timeStr = T("\229\183\178\231\187\147\230\157\159")
  if ed.GobackManager.endTime > ed.getServerTime() then
    timeStr = string.format(T("\229\137\169\228\189\153%s"), ed.time2dhmsV2(ed.GobackManager.endTime - ed.getServerTime()))
  end
  self.ui.time:setString(timeStr)
end

function LoginPage:registerTouchHandlers()
end

function LoginPage:registerEvents()
  self.scene:listenEvent("GobackGetLoginRewards", function(i)
    ed.setLabelColor(self.ui["label_day" .. i], ed.toccc3(16765076), 1)
    ed.setLabelStroke(self.ui["label_day" .. i], ed.toccc3(7095361), 1)
    if i == 7 then
      ed.setTexture(self.ui["day" .. i], "UI/alpha/1080P/goback/login_reward/goback_login_reward_item_bg_big_2.png")
    else
      ed.setTexture(self.ui["day" .. i], "UI/alpha/1080P/goback/login_reward/goback_login_reward_item_bg_2.png")
    end
    local tick = ed.createSprite("UI/alpha/1080P/package/selected.png")
    self.ui["day" .. i]:addChild(tick)
    tick:setPosition(ccp(30, 44))
    self.ui["light" .. i]:removeFromParentAndCleanup(true)
  end)
end

function LoginPage.create(param)
  local self = {}
  setmetatable(self, {__index = LoginPage})
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  return self
end
