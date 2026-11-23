local base = ed.ui.popwindow
local signIn = newclass(base.mt)
ed.ui.dailylogin = signIn
local mainButtonCfg = ed.ui.configs.mainButton
local ButtonType = mainButtonCfg.ButtonType
ed.UITool.registViewOpenFunc("signIn", function()
  local cpl = ed.playerlimit.getAreaUnlockPrompt("DailyLogin")
  if cpl then
    ed.showToast(cpl)
    return
  end
  ed.ui.dailylogin.isDestroy = false
  local panel = ed.ui.dailylogin.create()
  panel:popWindow()
end)
ListenEvent("mainSceneEnter", function()
  if not ed.playerlimit:moduleIsOpened("DailyLogin") then
    return
  end
  local rewardStatus = ed.player:getLoginIsToDay()
  if rewardStatus == "no" then
    ListenTimer(Timer:Once(0.2), function()
      ed.UITool.openView("signIn")
    end)
  end
end)

function signIn.create(param)
  local self = base.create("signIn")
  setmetatable(self, signIn.mt)
  self.ui = {}
  self.mailList = {}
  self.container, self.ui = ed.editorui(ed.uieditor.dailylogin)
  self.mainLayer:addChild(self.container)
  ed.setLabelStroke(self.ui.label_login_month, ed.toccc3(10640150), 1)
  ed.setLabelFontName(self.ui.label_login_month, ed.fontBold)
  self.ui.rule_butt:setPositionX(self.ui.label_login_month:getPositionX() + self.ui.label_login_month:getContentSize().width + 20)
  local rewardsStatus = {
    [1] = "yes",
    [0] = "no"
  }
  local data = ed.player:getDailyLoginData()
  data._reward_status = rewardsStatus[data._reward_status] or data._reward_status
  if data._reward_status == "yes" then
    ed.player:getLoginIsToDay()
  end
  local thisCon = self.ui.dailylogin_bj:getContentSize()
  self.container:setPosition(ed.display.center.x - thisCon.width / 2, ed.display.center.y - thisCon.height / 2 - 13)
  self:screenAdjustment()
  self:registerTouchHandler()
  self:show()
  
  function self.destroyCallback()
    if ed.GobackManager.activityId > 0 and ed.GobackManager:getViewFlag() == false then
      ed.ui.GobackMailWin.create(true)
    end
  end
  
  return self
end

function signIn:screenAdjustment()
  self.serverData = self.serverData or self.getDate()
  local date = self.serverData
  local y, m = date.y, date.m
  local newMonth = m
  ed.setTexture(self.ui.img_month_num, "UI/alpha/1080P/dailylogin/dailylogin_month_" .. newMonth .. ".png")
  local data = ed.player:getDailyLoginData()
  self.dailyData = {
    last_login_time = data._last_login_time or 0,
    logined_days = data._logined_days or {},
    frequent = data._frequent or 0,
    reward_status = data._reward_status or "no",
    make_up_days = self.tableToKey(data._make_up_days or {})
  }
  self.ui.txt_time:setPositionX(self.ui.Label_59:getPositionX() + self.ui.Label_59:getContentSize().width + self.ui.txt_time:getContentSize().width * 0.5)
  self.ui.txt_money_day:setString("")
  local lable = richText:new()
  lable:setString(T("<text|daily_time|\230\156\172\230\156\136\229\183\178\231\180\175\232\174\161\231\173\190\229\136\176><text|daily_time_green|%s><text|daily_time|\229\164\169>", self.dailyData.frequent))
  lable:setPosition(ccp(self.ui.txt_money_day:getPositionX() - lable:getContentSize().width, self.ui.txt_money_day:getPositionY()))
  self.ui.txt_money_day:getParent():addChild(lable.rootNode)
  self.txt_money_day = lable
  
  local function funcAction(icon)
    icon:stopAllActions()
    icon:runAction(CCSequence:create(ccArrayMake(unpack({
      CCEaseBackIn:create(CCRotateBy:create(0.18, -10)),
      CCRotateBy:create(0.12, 20),
      CCRotateBy:create(0.11, -20),
      CCRotateBy:create(0.1, 15),
      CCRotateBy:create(0.09, -10),
      CCEaseBackOut:create(CCRotateBy:create(0.15, 5))
    }))))
  end
  
  local function clickHandler(day)
    local function ret()
      if self.iconItem and self.iconItem[day] and not self.iconItem[day].pasImg:isVisible() then
        local item = self.iconItem[day].item
        
        ed.ui.packageDetailWin.create({
          id = item.id,
          type = item.type
        }):popWindow()
      end
    end
    
    return ret
  end
  
  local progressLang = {
    [1] = 18,
    [2] = 45,
    [3] = 72,
    [4] = 100
  }
  self.dayPosMax = 0
  self.progressLang = {
    [0] = 0
  }
  local requireDay, longTag = self:getRequireDay()
  if #requireDay == 0 and #longTag == 0 then
    self:registerTouchHandler()
    return
  end
  for i, v in ipairs(longTag) do
    self.ui["progress_day_num" .. i]:setStroke(ccc3(0, 0, 0), 1)
    self.ui["progress_day_num" .. i]:setString(v)
    self.progressLang[v] = progressLang[i]
    if self.progressLang[v] == 100 then
      self.dayPosMax = v
    end
    self.ui["Label_33_" .. i]:setStroke(ccc3(0, 0, 0), 1)
    ed.adaptLabel(self.ui["Label_33_" .. i], {maxWidth = 20, minScale = 0.5})
    ed.left2(self.ui["progress_day_num" .. i], self.ui["Label_33_" .. i], 2)
  end
  self.iconItem = {}
  local posx, posy, item
  for i = 1, 4 do
    posx, posy = self.ui["item_pos" .. i]:getPosition()
    item = requireDay[i] or {}
    local icon
    local scale1, scale2 = 0.5, 2.2
    local icon = ed.createItemIcon(item)
    if icon then
      icon:setPosition(posx, posy)
      self.ui.top_rig_lay:addChild(icon)
      icon:setScale(scale1)
      local pasImg = ed.createSprite("UI/alpha/1080P/dailylogin/dailylogin_itembj1.png")
      pasImg:setPosition(posx, posy)
      pasImg:setScale(0.75)
      self.ui.top_rig_lay:addChild(pasImg, 99)
      local selected = ed.createSprite("UI/alpha/1080P/package/selected.png")
      selected:setPosition(20, 15)
      selected:setScale(0.65)
      pasImg:addChild(selected, 99)
      pasImg:setVisible(false)
      local newDayItme = ed.createSprite("UI/alpha/1080P/dailylogin/dailylogin_item_lig.png")
      newDayItme:setPosition(45, 45)
      if scale2 ~= 2.2 then
        newDayItme:setPosition(24, 24)
      end
      icon:addChild(newDayItme, 98)
      newDayItme:setVisible(false)
      newDayItme:setScale(scale2)
      local star = self.ui["img_progress_pot_" .. i]
      star:setOpacity(1)
      self:btRegisterButtonClick({
        button = icon,
        key = "icon" .. i,
        clickHandler = clickHandler(i),
        force = true,
        pressScale = scale1 - 0.05,
        normalScale = scale1
      })
      self.iconItem[i] = {
        icon = icon,
        pasImg = pasImg,
        isPas = false,
        newDayItme = newDayItme,
        tag = longTag[i],
        star = star,
        item = item
      }
    end
  end
  self.resetTime = ed.getTimeBeforeResetTime()
  
  local function timer_funBrk()
    self.resetTime = self.resetTime - 1
    if self.resetTime < -2 then
      self.resetTime = ed.getTimeBeforeResetTime()
      self:timeMaturityUpData()
      return
    end
    local resetTime = self.resetTime < 0 and 0 or self.resetTime
    local ret = ""
    local d, h, m, s = 0, 0, 0, 0
    h = math.floor(resetTime % 86400 / 3600)
    h = h < 10 and "0" .. h or h
    ret = ret .. h .. ":"
    m = math.floor(resetTime % 3600 / 60)
    m = m < 10 and "0" .. m or m
    ret = ret .. m .. ":"
    s = resetTime % 3600 % 60
    s = s < 10 and "0" .. s or s
    ret = ret .. s
    self.ui.txt_time:setString(ret)
  end
  
  local thisCon = self.ui.img_progress_bar:getContentSize()
  local progress = CCProgressTimer:create(self.ui.img_progress_bar)
  progress:setType(kCCProgressTimerTypeBar)
  progress:setPosition(thisCon.width / 2, thisCon.height / 2)
  self.ui.img_progress_bj:addChild(progress)
  progress:setMidpoint(ccp(0, 0.5))
  progress:setBarChangeRate(ccp(1, 0))
  self.ui.img_progress_bar:setVisible(false)
  self.dayProgress = progress
  self:setProgressTo(self.dailyData.frequent)
  self:createListLayer()
  if self.dailyData.reward_status == "no" then
    self.ui.top_rig_lay:runAction(CCSequence:create(ccArrayMake(unpack({
      CCDelayTime:create(0.7),
      CCCallFunc:create(function()
        ed.netreply.dailylogin = self:askRewardReply(timer_funBrk)
        local msg = ed.upmsg.new_daily_login_req()
        msg._sign_in = ed.upmsg.daily_login_sign_in()
        ed.send(msg, "new_daily_login")
      end)
    }))))
    local time = self.serverData
    local newDay = time.d or 0
    self.dayItemDt[newDay].ui.all_panel:runAction(CCSequence:create(ccArrayMake(unpack({
      CCEaseBackIn:create(CCScaleTo:create(0.5, 0.9)),
      CCEaseBackOut:create(CCScaleTo:create(0.6, 1))
    }))))
  else
    timer_funBrk()
    self.timer_fun = ListenTimer(Timer:Always(1), timer_funBrk)
  end
end

function signIn:setProgressTo(day)
  local function getProgressTo(self)
    local dayPosMax, dayPosMil = self.dayPosMax, 0
    
    for k, v in pairs(self.progressLang) do
      if k == day then
        return v
      end
      if k > day and k < dayPosMax then
        dayPosMax = k
      end
      if k < day and k > dayPosMil then
        dayPosMil = k
      end
    end
    local days = dayPosMax - dayPosMil
    local pros = self.progressLang[dayPosMax] - self.progressLang[dayPosMil]
    local newProPos = (day - dayPosMil) * (pros / days) + self.progressLang[dayPosMil]
    return newProPos, dayPosMax
  end
  
  local newPros, dayPosMax = getProgressTo(self)
  for i, v in ipairs(self.iconItem) do
    if day >= v.tag and not v.pasImg:isVisible() then
      v.pasImg:setVisible(true)
      v.star:runAction(CCFadeTo:create(i * i / 50, 255))
    end
    v.newDayItme:setVisible(dayPosMax == v.tag)
    v.isPas = dayPosMax == v.tag
  end
  self.dayProgress:runAction(CCProgressTo:create(0.2, newPros))
end

function signIn:createListLayer()
  self.dayItemDt = {}
  local thisCon = self.ui.day_item_pos:getContentSize()
  local handler, ui = ed.editorui(ed.uieditor.dailylogin_item)
  ed.setLabelStroke(ui.label_buqian, ed.toccc3(5649677), 1)
  local handCon = handler:getContentSize()
  handCon = {width = 104.5, height = 71}
  local posX, posY = -1, thisCon.height - handCon.height + 2
  self.serverData = self.serverData or self.getDate()
  local time = self.serverData
  local newDay = time.d or 0
  local newMoDay = self.dailyData.frequent
  local monthDay = self:getMonthDayAmount() or 0
  self.dayIsPass = self.monthDayToPass(monthDay, self.dailyData.logined_days)
  local dayIsPass = self.dayIsPass
  
  local function clickHandler(day)
    local function ret()
      if self.dayIsPass[day] then
      elseif newDay < day then
        local item = self:getRewardAt(day)
        ed.ui.packageDetailWin.create({
          id = item.id,
          type = item.type
        }):popWindow()
      elseif self.dailyData.make_up_days[day] then
        local panel = ed.ui.maillocalbox.create({
          type = "deleItem",
          tag = 3,
          clickBack = function()
            self.buQianDay = day
            ed.netreply.dailylogin = self:askRewardReply()
            local msg = ed.upmsg.new_daily_login_req()
            msg._make_up = ed.upmsg.daily_login_make_up()
            msg._make_up._day = day
            ed.send(msg, "new_daily_login")
          end,
          title = T("\232\161\165\231\173\190"),
          str = T("<br/><br/>             \230\152\175\229\144\166\232\138\177\232\180\185<sprite src=UI/alpha/1080P/common/rmbicon.png scale=0.7>50\232\191\155\232\161\140\232\161\165\231\173\190\239\188\159<br/>                 \232\161\165\231\173\190\229\144\142\229\143\175\232\142\183\229\190\151:"),
          item = self.dayItemDt[day].item,
          itemPosX = 475,
          itemPosY = 15,
          skipAnim = true
        })
        panel:popWindow()
      else
        ed.showToast(T("\230\179\168\229\134\140\232\180\166\229\143\183\229\137\141\231\154\132\229\164\169\230\149\176\228\184\141\229\143\175\232\161\165\231\173\190"))
      end
    end
    
    return ret
  end
  
  local function callbackWithArgs(ui, i)
    local function ret()
      ui.img_disabled:setVisible(true)
      
      ui.img_selected:setVisible(true)
    end
    
    return ret
  end
  
  local ii = 1
  for i = 1, monthDay do
    handler, ui = ed.editorui(ed.uieditor.dailylogin_item)
    self.ui.day_item_pos:addChild(handler)
    handler:setPosition(posX, posY)
    ui.txt_day:setString(i)
    ed.setLabelStroke(ui.txt_day, ed.toccc3(5586983), 1)
    ed.setLabelStroke(ui.label_buqian, ed.toccc3(5649677), 1)
    ui.all_panel:setAnchorPoint(ccp(0.5, 0.5))
    ed.setLabelDimensions(ui.label_buqian, CCSizeMake(70, 0))
    ui.label_buqian:setHorizontalAlignment(kCCTextAlignmentCenter)
    if newDay == i then
      ui.img_pressed:setVisible(true)
    end
    ui.txt_day:setColor(newDay == i and ed.toccc3(16776423) or ed.toccc3(13419962))
    if dayIsPass[i] and i <= newDay then
      if newDay == i and self.dailyData.reward_status ~= "no" then
        callbackWithArgs(ui, i)()
      elseif i < newDay then
        callbackWithArgs(ui, i)()
      end
    elseif i < newDay then
      ui.img_buqian:setVisible(self.dailyData.make_up_days[i])
      ui.img_disabled:setVisible(not self.dailyData.make_up_days[i])
    end
    self:btRegisterButtonClick({
      button = ui.all_panel,
      key = "handler" .. i,
      clickHandler = clickHandler(i),
      force = true,
      pressScale = 0.95,
      radius = 35
    })
    local item = self:getRewardAt(i)
    local icon = ed.createItemIcon(item)
    if icon then
      icon:setPosition(ccp(20, 20))
      ui.item_pos:addChild(icon)
    end
    if i % 7 == 0 then
      posX, posY = -1, posY - handCon.height
    else
      posX = posX + handCon.width - 1.5
    end
    self.dayItemDt[i] = {}
    self.dayItemDt[i].ui = ui
    self.dayItemDt[i].item = {
      [1] = item
    }
  end
end

function signIn:timeMaturityUpData()
  local rewardStatus = ed.player:getLoginIsToDay()
  if rewardStatus == "no" then
    ed.netreply.dailylogin = nil
    FireEvent("MainRedTagChange", ButtonType.SIGN)
    if self.timer_fun then
      CloseTimer(self.timer_fun.Name)
      self.timer_fun = nil
    end
    ed.ui.dailylogin.isDestroy = true
    self:destroy()
  end
end

function signIn:askRewardReply(timer_funBrk)
  local function handler(reply)
    if not self.timer_fun and not ed.ui.dailylogin.isDestroy then
      self.timer_fun = ListenTimer(Timer:Always(1), timer_funBrk)
    end
    if reply._error_code then
      if reply._error_code == "daily_login_makeupday_error" then
        ed.showToast(T("\229\189\147\229\137\141\230\151\165\230\156\159\228\184\141\229\143\175\232\161\165\231\173\190"))
      elseif reply._error_code == "dailylogin_has_rewarded" then
        local rewardStatus, isOld = ed.player:getLoginIsToDay()
        if rewardStatus == "no" and isOld then
          ed.player:recievedDailyLoginReward(self.serverData.d)
        end
      elseif reply._error_code then
        ed.showToast(reply._error_code)
      end
      return
    end
    local item = {}
    local tab = reply._login_rewards or {}
    for k, v in pairs(tab) do
      table.insert(item, {
        type = v._type,
        amount = v._amount,
        id = v._id
      })
    end
    tab = reply._line_rewards or {}
    for k, v in pairs(tab) do
      table.insert(item, {
        type = v._type,
        amount = v._amount,
        id = v._id
      })
    end
    if item and 0 < #item then
      local panel = ed.ui.maillocalbox.create({
        type = "addItem",
        item = item,
        destroyBack = function()
          if not self.timer_fun then
            return
          end
          if ed.ui.dailylogin.isDestroy then
            return
          end
          if self.buQianDay then
            self.dailyData.frequent = self.dailyData.frequent + 1
            self:setProgressTo(self.dailyData.frequent)
            self.txt_money_day:setString(T("<text|daily_time|\230\156\172\230\156\136\229\183\178\231\180\175\232\174\161\231\173\190\229\136\176><text|daily_time_green|%s><text|daily_time|\229\164\169>", self.dailyData.frequent))
          end
          
          local function callbackWithArgs(ui, i)
            local function ret()
              ui.img_disabled:setVisible(true)
              
              ui.img_selected:setVisible(true)
              ui.img_buqian:setVisible(false)
            end
            
            return ret
          end
          
          self.dayItemDt[self.buQianDay or self.serverData.d].ui.all_panel:runAction(CCSequence:create(ccArrayMake(unpack({
            CCDelayTime:create(0.2),
            CCEaseBackIn:create(CCScaleTo:create(0.3, 1, 0.01)),
            CCCallFunc:create(callbackWithArgs(self.dayItemDt[self.buQianDay or self.serverData.d].ui, self.buQianDay)),
            CCScaleTo:create(0.2, 1, 1),
            CCScaleTo:create(0.1, 1, 0.9),
            CCScaleTo:create(0.1, 1, 1)
          }))))
          self.buQianDay = nil
        end
      })
      panel:popWindow()
      if self.buQianDay then
        ed.player:subPoint("diamond", -50)
      end
      local rewards = {}
      for i, v in ipairs(item) do
        rewards[i] = {
          _id = v.id,
          _type = v.type,
          _amount = v.amount
        }
      end
      ed.player:addRewards(rewards)
      local rewardStatus, isOld = ed.player:getLoginIsToDay()
      if rewardStatus == "no" and isOld then
        ed.player:recievedDailyLoginRewardOld(self.serverData.d)
      end
      ed.player:recievedDailyLoginReward(self.buQianDay or self.serverData.d)
      if not self.timer_fun then
        return
      end
      if rewardStatus == "no" and isOld then
        self.dailyData.frequent = ed.player:getLoginFrequency()
        self:setProgressTo(self.dailyData.frequent)
        self.txt_money_day:setString(T("<text|daily_time|\230\156\172\230\156\136\229\183\178\231\180\175\232\174\161\231\173\190\229\136\176><text|daily_time_green|%s><text|daily_time|\229\164\169>", self.dailyData.frequent))
      end
      self.dayIsPass[self.buQianDay or self.serverData.d] = true
    end
  end
  
  return handler
end

function signIn:registerTouchHandler()
  local ui = self.ui
  self:btRegisterOutClick({
    area = ui.dailylogin_bj,
    key = "dailylogin_bj",
    clickHandler = function()
      if nil ~= ed.netreply.dailylogin then
        return
      end
      ed.netreply.dailylogin = nil
      ed.ui.dailylogin.isDestroy = true
      self:destroy()
      if self.timer_fun then
        CloseTimer(self.timer_fun.Name)
        self.timer_fun = nil
      end
      FireEvent("MainRedTagChange", ButtonType.SIGN)
    end
  })
  
  local function loclaButtonClick(button, key, clickHandler, pressScale, normalScale)
    self:btRegisterButtonClick({
      button = button,
      key = key,
      clickHandler = clickHandler,
      force = true,
      pressScale = pressScale or 0.9,
      normalScale = normalScale
    })
  end
  
  loclaButtonClick(ui.button_close, "button_close", function()
    if nil ~= ed.netreply.dailylogin then
      return
    end
    ed.netreply.dailylogin = nil
    ed.ui.dailylogin.isDestroy = true
    self:destroy()
    if self.timer_fun then
      CloseTimer(self.timer_fun.Name)
      self.timer_fun = nil
    end
    FireEvent("MainRedTagChange", ButtonType.SIGN)
  end, 0.7, 0.8)
  loclaButtonClick(ui.rule_butt, "rule_butt", function()
    self:createExplain()
  end, 0.6, 0.7)
end

function signIn:createRewardDetail(reward, index, str)
  local index = index
  local type = reward.type
  local id = reward.id
  local container = CCLayer:create()
  self.rdContainer = container
  container:setTouchEnabled(true)
  container:registerScriptTouchHandler(function(event, x, y)
    xpcall(function()
      if event == "ended" then
        self:destroyRewardDetail()
      end
    end, EDDebug)
    return true
  end, false, -999, true)
  self.mainLayer:addChild(container)
  local icon = reward.icon
  local pos = ed.display.center
  local did = id
  if type == "Diamond" then
    did = type
  end
  local panel = ed.readequip.getDetailCard(did, {
    ps = str or ""
  }, {
    noArrow = true,
    anchor = ccp(0.5, 0.5)
  })
  if not panel then
    self.rdContainer:removeFromParentAndCleanup(true)
    self.rdContainer = nil
    return
  end
  panel:setPosition(pos)
  container:addChild(panel, 50)
  self.rdPanel = panel
  container:setScale(0)
  local s = CCScaleTo:create(0.2, 1)
  s = CCEaseBackOut:create(s)
  container:runAction(s)
end

function signIn:destroyRewardDetail()
  if self.rdContainer then
    local s = CCScaleTo:create(0.2, 0)
    s = CCEaseBackIn:create(s)
    local func = CCCallFunc:create(function()
      xpcall(function()
        self.rdContainer:removeFromParentAndCleanup(true)
        self.rdContainer = nil
      end, EDDebug)
    end)
    s = CCSequence:createWithTwoActions(s, func)
    self.rdContainer:runAction(s)
  end
end

local explain_text = T("\n\n    \230\175\143\230\151\165\231\173\190\229\136\176\233\162\134\229\143\150\229\189\147\230\151\165\229\165\150\229\138\177\239\188\140\231\180\175\231\167\175\231\173\190\229\136\176\232\190\190\229\136\176\228\184\128\229\174\154\229\164\169\230\149\176\229\144\142\233\162\134\229\143\150\229\175\185\229\186\148\232\191\155\229\186\166\229\165\150\229\138\177\227\128\130\n\n    \230\175\143\230\151\165\231\173\190\229\136\176\229\165\150\229\138\177\229\156\168\230\175\143\229\164\16905\239\188\15400\229\136\183\230\150\176\239\188\140\230\188\143\231\173\190\231\154\132\229\165\150\229\138\177\229\143\175\228\187\165\230\182\136\232\128\15150\233\146\187\231\159\179\232\191\155\232\161\140\232\161\165\231\173\190\227\128\130\n\n    \229\165\150\229\138\177\229\146\140\231\173\190\229\136\176\232\191\155\229\186\166\229\176\134\229\156\168\230\175\143\230\156\1361\229\143\18305\239\188\15400\229\136\183\230\150\176\239\188\140\230\156\172\230\156\136\231\154\132\231\180\175\231\167\175\231\173\190\229\136\176\232\191\155\229\186\166\228\184\141\228\188\154\231\187\167\230\137\191\229\136\176\228\184\139\230\156\136\227\128\130\n\n    ")

function signIn:createExplain()
  if self.explainContainer then
    self:destroyExplain()
    return
  end
  local container = CCLayer:create()
  self.explainContainer = container
  container:setTouchEnabled(true)
  container:registerScriptTouchHandler(function(event, x, y)
    xpcall(function()
      if event == "ended" then
        self:destroyExplain()
      end
    end, EDDebug)
    return true
  end, false, -999, true)
  self.mainLayer:addChild(container, 999)
  local ui = {}
  local readnode = ed.readnode.create(container, ui)
  while string.sub(explain_text, 1, 1) == "\n" do
    explain_text = string.sub(explain_text, 2)
  end
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "frame",
        res = "UI/alpha/1080P/common/mail_bj9_1.png",
        capInsets = CCRectMake(10, 10, 19, 200)
      },
      layout = {
        position = ccp(400, 335)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "label",
        text = explain_text,
        fontinfo = "dark_yellow2"
      },
      layout = {
        position = ccp(400, 320)
      },
      config = {
        dimension = CCSizeMake(360, 0),
        horizontalAlignment = kCCTextAlignmentLeft
      }
    }
  }
  readnode:addNode(ui_info)
  local label = ui.label
  local frame = ui.frame
  local size = label:getContentSize()
  frame:setContentSize(CCSizeMake(400, size.height + 16))
  if ui.frame_1 then
    ui.frame_1:setContentSize(CCSizeMake(400, size.height + 16))
  end
  container:setScale(0)
  local s = CCScaleTo:create(0.2, 1)
  s = CCEaseBackOut:create(s)
  container:runAction(s)
end

function signIn:destroyExplain()
  if self.explainContainer then
    local s = CCScaleTo:create(0.2, 0)
    s = CCEaseBackIn:create(s)
    local f = CCCallFunc:create(function()
      xpcall(function()
        self.explainContainer:removeFromParentAndCleanup(true)
        self.explainContainer = nil
      end, EDDebug)
    end)
    s = CCSequence:createWithTwoActions(s, f)
    self.explainContainer:runAction(s)
  end
end

function signIn.getDate()
  local time = ed.getFitServerTime()
  local dateNew = ed.getYMDHMS(time)
  if tonumber(dateNew.hour) < 5 then
    dateNew = ed.getYMDHMS(time - 18000)
  end
  local y = tonumber(dateNew.year)
  local m = tonumber(dateNew.month)
  local d = tonumber(dateNew.day)
  return {
    y = y,
    m = m,
    d = d
  }
end

function signIn:getMonthDayAmount()
  self.serverData = self.serverData or self.getDate()
  local date = self.serverData
  local y, m = date.y, date.m
  self.monthData = self.monthData or ed.getDataTable("DailyLoginReward")[y][m]
  local index, dt = 1, self.monthData
  while dt[index] and dt[index]["Reward Type"] do
    index = index + 1
  end
  return index - 1
end

function signIn:getRewardAt(i)
  self.serverData = self.serverData or self.getDate()
  local date = self.serverData
  local y, m, d = date.y, date.m, i or date.d
  self.monthData = self.monthData or ed.getDataTable("DailyLoginReward")[y][m]
  local row = self.monthData[d]
  if not row then
    return
  end
  local type = row["Reward Type"]
  local id = row["Reward ID"]
  local amount = row["Reward Amount"]
  local vip = row["Double Reward VIP Level"] or 0
  return {
    type = type,
    id = id,
    amount = amount,
    vip = vip
  }
end

function signIn.monthDayToPass(max, data)
  local newDayTab = {}
  for k, v in pairs(data) do
    newDayTab[v] = 1
  end
  for i = 1, max do
    newDayTab[i] = newDayTab[i] and newDayTab[i] == 1
  end
  return newDayTab
end

function signIn:getRequireDay()
  self.serverData = self.serverData or self.getDate()
  local date = self.serverData
  local y, m = date.y, date.m
  local tb = ed.getDataTable("DailyLoginLineReward")
  local row = (tb[y] or {})[m]
  if row == nil then
    ed.showToast(T("\231\180\175\231\173\190\232\161\168nil ") .. y .. ":" .. m)
    return {}, {}
  end
  local lineRewardItems = {}
  local day = {}
  for i = 1, 4 do
    local requireDay = row["Require Day Count " .. i]
    day[i] = requireDay
    local reward = {
      type = row["Reward Type " .. i],
      id = row["Reward ID " .. i],
      amount = row["Reward Amount " .. i]
    }
    table.insert(lineRewardItems, reward)
  end
  return lineRewardItems, day
end

function signIn.tableToKey(tab)
  local newTab = {}
  for i, v in ipairs(tab) do
    newTab[v] = true
  end
  return newTab
end
