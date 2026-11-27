local base = ed.ui.commonscene
local CrusadeScene = newclass(base.mt)
ed.ui.CrusadeMainScene = CrusadeScene
local acts = require("util.cocos2dx.actions")
local crusade = {}
ed.UITool.registViewOpenFunc("crusade", function()
  ed.playEffect(ed.sound.deo.common_click_feedback)
  local ds = ed.playerlimit.getAreaUnlockPrompt("Crusade")
  if ds then
    ed.showToast(ds)
    return
  end
  if ReloadModule then
    ReloadModule("ui_new/modules/crusade/CrusadeModuleList")
  end
  ed.CrusadeNetwork:sendOpenPanel()
end)
local dragPressX, layerOriPos
local CrusadeStageConfig = {
  [1] = {
    boxFcaRes = "eff_UI_box_bronze",
    posOffset = 0,
    offsetClick = ccp(0, 0),
    offsetRadius = -8
  },
  [2] = {
    boxFcaRes = "eff_UI_box_bronze",
    posOffset = 0,
    offsetClick = ccp(0, -10),
    offsetRadius = -10
  },
  [3] = {
    boxFcaRes = "eff_UI_box_silver",
    posOffset = 0,
    offsetClick = ccp(0, 0),
    offsetRadius = -15
  },
  [4] = {
    boxFcaRes = "eff_UI_box_bronze",
    posOffset = -260,
    offsetClick = ccp(0, 0),
    offsetRadius = -8
  },
  [5] = {
    boxFcaRes = "eff_UI_box_bronze",
    posOffset = -360,
    offsetClick = ccp(0, -5),
    offsetRadius = -8
  },
  [6] = {
    boxFcaRes = "eff_UI_box_silver",
    posOffset = -600,
    offsetClick = ccp(0, -5),
    offsetRadius = -8
  },
  [7] = {
    boxFcaRes = "eff_UI_box_bronze",
    posOffset = -820,
    offsetClick = ccp(0, -5),
    offsetRadius = -10
  },
  [8] = {
    boxFcaRes = "eff_UI_box_bronze",
    posOffset = -980,
    offsetClick = ccp(0, 0),
    offsetRadius = -8
  },
  [9] = {
    boxFcaRes = "eff_UI_box_silver",
    posOffset = -1000,
    offsetClick = ccp(0, 0),
    offsetRadius = -8
  },
  [10] = {
    boxFcaRes = "eff_UI_box_bronze",
    posOffset = -1250,
    offsetClick = ccp(0, -5),
    offsetRadius = -8
  },
  [11] = {
    boxFcaRes = "eff_UI_box_bronze",
    posOffset = -1350,
    offsetClick = ccp(0, 0),
    offsetRadius = -8
  },
  [12] = {
    boxFcaRes = "eff_UI_box_silver",
    posOffset = -1380,
    offsetClick = ccp(0, 0),
    offsetRadius = -8
  },
  [13] = {
    boxFcaRes = "eff_UI_box_bronze",
    posOffset = -1380,
    offsetClick = ccp(0, 0),
    offsetRadius = -8
  },
  [14] = {
    boxFcaRes = "eff_UI_box_bronze",
    posOffset = -1380,
    offsetClick = ccp(0, 0),
    offsetRadius = -8
  },
  [15] = {
    boxFcaRes = "eff_UI_box_gold",
    posOffset = -1380,
    offsetClick = ccp(0, 0),
    offsetRadius = -8
  },
  [16] = {posOffset = -1380}
}
local fogPos = {
  620,
  1350,
  1630,
  2000
}

function CrusadeScene:refreshHintPos()
  local hint = self.ui.currentStageHint
  hint:stopAllActions()
  local curStageIndex = ed.CrusadeManager.curStageIndex
  if curStageIndex >= ed.CrusadeManager.sumOfCrusadeStage then
    hint:setVisible(false)
    return
  else
    hint:setVisible(true)
  end
  local ui = self.ui[string.format("battle%d", curStageIndex)]
  if ed.CrusadeManager.battleState[curStageIndex - 1] == "passed" then
    ui = self.ui[string.format("box%d", curStageIndex - 1)]
  end
  local pos = ccp(ui:getPosition())
  pos.y = pos.y + 80
  hint:setPosition(pos)
  local action = CCSequence:createWithTwoActions(CCMoveTo:create(0.8, ccp(pos.x, pos.y - 20)), CCMoveTo:create(0.8, ccp(pos.x, pos.y)))
  action = CCRepeatForever:create(action)
  hint:runAction(action)
end

function CrusadeScene:refreshBattleState()
  for i = 1, ed.CrusadeManager.sumOfCrusadeStage do
    local battle = string.format("battle%d", i)
    local box = string.format("box%d", i)
    if ed.CrusadeManager.battleState[i] == "passed" or ed.CrusadeManager.battleState[i] == "rewarded" then
      self.ui[battle]:removeAllChildrenWithCleanup(true)
      ed.setTexture(self.ui[battle], string.format(T("UI/alpha/1080P/crusade/level%d_passed.png"), i))
    elseif self.curSelectStage == i then
      self.ui[battle]:removeAllChildrenWithCleanup(true)
      local texture = ed.createSprite(string.format(T("UI/alpha/1080P/crusade/level%d_selected.png"), i))
      texture:setPosition(ed.getCenterPos(self.ui[battle]))
      self.ui[battle]:addChild(texture)
    else
      self.ui[battle]:removeAllChildrenWithCleanup(true)
      ed.setTexture(self.ui[battle], string.format(T("UI/alpha/1080P/crusade/level%d.png"), i))
    end
  end
  self:refreshHintPos()
end

function CrusadeScene:refreshBoxState()
  for i = 1, ed.CrusadeManager.sumOfCrusadeStage do
    local box = string.format("box%d", i)
    if ed.CrusadeManager.battleState[i] == "rewarded" then
      self.ui[box]:setAction("Opened")
    elseif ed.CrusadeManager.battleState[i] == "unpassed" then
      self.ui[box]:setAction("Close")
    else
      self.ui[box]:setAction("Shake")
    end
  end
end

function CrusadeScene:refreshFog()
  local curStageIndex = ed.CrusadeManager.curStageIndex
  local index = math.floor(curStageIndex / 3)
  if curStageIndex % 3 == 1 then
    local fog1 = self.ui["fog" .. index]
    local fog2 = self.ui["fog" .. index + 1]
    if fog1 then
      fog1:setLoopAction("")
      fog1:setAction("End_" .. index)
      self:listenTimer(Timer:Once(3), function()
        fog1:setVisible(false)
      end)
    end
    if fog2 then
      fog2:setVisible(true)
      fog2:setAction("Start_" .. index + 1)
      fog2:setLoopAction("Loop_" .. index + 1)
    end
  end
end

function CrusadeScene:showBattleInfo(data)
  ed.ui.CrusadeChallengeWin.create(data, self.curSelectStage)
end

function CrusadeScene:getReward()
  self.ui["box" .. self.selectBox]:setAction("Opening")
  self:listenTimer(Timer:Once(0.8), function()
    self:refreshBoxState()
  end)
  self:refreshHintPos()
end

local function getMaxRight(index)
  if index <= 3 then
    return -200 + ed.display.halfFixedWidth
  elseif index <= 6 then
    return -600 + ed.display.halfFixedWidth
  elseif index <= 9 then
    return -1000 + ed.display.halfFixedWidth
  else
    return -1380 + ed.display.halfFixedWidth
  end
end

function CrusadeScene:dragLayerTouch(event, x, y)
  local function handler(event, x, y)
    if event == "began" then
      dragPressX = x
      
      local x, y = self.ui.dragContainer:getPosition()
      layerOriPos = ccp(x, y)
    elseif event == "moved" then
      if nil == dragPressX then
        return
      end
      if math.abs(x - dragPressX) < 5 then
        return
      end
      local posX = layerOriPos.x + x - dragPressX
      posX = math.min(-ed.display.halfFixedWidth, math.max(posX, getMaxRight(ed.CrusadeManager.curStageIndex)))
      self.ui.dragContainer:setPosition(ccp(posX, layerOriPos.y))
    elseif event == "ended" then
      dragPressX = nil
    end
    return true
  end
  
  return handler
end

function CrusadeScene:refreshWeeklyRewardInfo()
  local rewardInfo = ed.CrusadeManager.weeklyRewardInfo
  if rewardInfo then
    local reward = rewardInfo._rewards[1]
    local icon = ed.createItemIcon({
      id = reward._id,
      amount = reward._amount,
      type = reward._type
    })
    ed.UITool.replaceUI(self.ui, "bg_weekly_reward", "weekly_reward_icon", icon)
    if rewardInfo._reward_flag == 1 then
      local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
      mask:setPosition(45, 46)
      icon:addChild(mask)
      local tick = ed.createSprite("UI/alpha/1080P/package/selected.png")
      icon:addChild(tick)
      tick:setPosition(ccp(45, 46))
    else
      if rewardInfo._cur_progress >= rewardInfo._max_progress then
        local light = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
        icon:addChild(light)
        light:setPosition(ccp(44, 44))
        light:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
      else
      end
    end
    ed.setString(self.ui.cur_progress, string.format(T("\233\128\154\229\133\179%d"), rewardInfo._cur_progress))
    ed.setString(self.ui.weekly_progress, string.format(T("/%d\229\144\142\232\142\183\229\190\151"), rewardInfo._max_progress))
    local desWidth = self.ui.weekly_progress:getContentSize().width + self.ui.cur_progress:getContentSize().width
    local posX = self.ui.Label_8599:getPositionX() + math.min(desWidth * 0.5, 80) - self.ui.weekly_progress:getContentSize().width
    self.ui.weekly_progress:setPositionX(posX)
    self.ui.cur_progress:setPositionX(posX)
    self:btRemoveMainTouchHandler({
      key = "weekly_reward_icon"
    })
    ed.UITool.registerBtn(self, "weekly_reward_icon", function()
      if rewardInfo._reward_flag == 0 and rewardInfo._cur_progress >= rewardInfo._max_progress then
        ed.CrusadeNetwork:getWeeklyReward()
      else
        ed.ui.packageDetailWin.create({
          id = reward._id,
          amount = reward._amount,
          type = reward._type
        }):popWindow()
      end
    end)
  end
end

function CrusadeScene:refreshUI()
  self.curSelectStage = ed.CrusadeManager.curStageIndex
  self:initDragPos()
  self:refreshBattleState()
  self:refreshWeeklyRewardInfo()
  self:refreshBoxState()
  self:refreshFog()
  if ed.CrusadeManager.leftTime == 0 then
    self.ui.btn_restart:setVisible(false)
    self.ui.btn_restart_none:setVisible(true)
  else
    self.ui.btn_restart:setVisible(true)
    self.ui.btn_restart_none:setVisible(false)
  end
  local vis = ed.CrusadeManager:canRush()
  self.ui.btn_rush:setVisible(vis)
  self.ui.btn_rush_none:setVisible(not vis)
end

function CrusadeScene:refreshBuff()
  local buffMgr = ed.activityBuffMgr.getInstance()
  local param = {
    buffIdList = buffMgr:getbuffByType({
      "tbc_gold_multi",
      "cruspoint_multi",
      "opensvr_crusade_buff"
    }),
    extraTypeList = {
      "cruspoint_multi"
    },
    column = 5
  }
  if not self.buffTipsPanel then
    self.buffTipsPanel = ed.buffTipsPanel.create(param)
    self.ui.bg_title:addChild(self.buffTipsPanel.container)
    self.buffTipsPanel.container:setPosition(ccp(35, -25))
  else
    self.buffTipsPanel:refreshPanel(param)
  end
end

function CrusadeScene:createFogs()
  for i = 1, 4 do
    local fog = ed.createFcaNode("eff_UI_Main_Crusade")
    local curStageIndex = ed.CrusadeManager.curStageIndex
    local index = math.floor((curStageIndex + 2) / 3)
    if i == index then
      fog:setAction("Start_" .. i)
      fog:setLoopAction("Loop_" .. i)
    else
      fog:setVisible(false)
    end
    fog:setPosition(ccp(fogPos[i], 270))
    self.ui.dragContainer:addChild(fog)
    self:addFca(fog)
    self.ui["fog" .. i] = fog
  end
end

function CrusadeScene:createBoxs()
  for i = 1, ed.CrusadeManager.sumOfCrusadeStage do
    local box = self.ui["box" .. i]
    local fca = ed.createFcaNode(CrusadeStageConfig[i].boxFcaRes)
    local x, y = box:getPosition()
    box:setVisible(false)
    fca:setScale(0.8)
    fca:setPosition(ccp(x, y))
    fca:setAction("Close")
    self.ui["box" .. i] = fca
    self:addFca(fca)
    self.ui.layer_battle:addChild(fca, 11)
    self:btRegisterCircleClick({
      center = ccp(x, y),
      radius = 35,
      parent = self.ui.layer_battle,
      pressHandler = function()
        self:hintBoxDown(i)
      end,
      cancelPressHandler = function()
        self.ui.rewardInfo:setVisible(false)
      end,
      clickHandler = function()
        if not dragPressX then
          self:hintBox(i)
        end
      end
    })
  end
end

function CrusadeScene:initUI()
  self.ui = {}
  local readnode = ed.readnode.create(self.mainLayer, self.ui)
  readnode:addNode(ed.uieditor.crusadeMainScene)
  ed.layout.layoutWithMagin(self.ui.bg_title, {left = 70, top = 18})
  self:setBackButton(function()
    if self.buffTipsPanel then
      self.buffTipsPanel:CloseScope()
    end
    ed.playEffect(ed.sound.common.back)
  end)
  self.ui.layer_buff:setVisible(false)
  self.ui.title:setVisible(false)
  ed.layout.horizontalSortNode({
    self.ui.icon_crusadepoint,
    self.ui.label_shop
  }, {2, 0}, self.ui.btn_shop:getContentSize().width * 0.5)
  local _, titleTxt = ed.UITool.createSceneTitle(T("\232\139\177\233\155\132\231\154\132\232\191\156\229\190\129"), self.ui.bg_title, {
    position = ccp(13, 18)
  })
  ed.layout.relateLayout(titleTxt, self.ui.btn_rule, {
    right = titleTxt:getContentSize().width * 0.5 + 20
  })
  self.ui.bg_btn:setContentSize(CCSizeMake(ed.display.winSize.width - 30, self.ui.bg_btn:getContentSize().height))
  self.ui.btn_restart:setPositionX(ed.display.winSize.width - 115)
  self.ui.btn_restart_none:setPositionX(ed.display.winSize.width - 115)
  self.ui.btn_restart_none:setVisible(false)
  ed.layout.layoutWithMagin(self.ui.bg_btn, {bottom = 10})
  ed.layout.layoutWithParentMagin(self.ui.btn_shop, {
    left = 20 + ed.display.getNotchHeight()
  })
  ed.layout.layoutWithParentMagin(self.ui.btn_rush, {
    left = 162 + ed.display.getNotchHeight()
  })
  ed.layout.layoutWithParentMagin(self.ui.btn_rush_none, {
    left = 162 + ed.display.getNotchHeight()
  })
  ed.layout.layoutWithParentMagin(self.ui.btn_replay, {
    left = 310 + ed.display.getNotchHeight()
  })
  ed.layout.layoutWithParentMagin(self.ui.bg_weekly_reward, {right = 172})
  ed.setLabelShadow(self.ui.label_shop, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelShadow(self.ui.label_restart, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelShadow(self.ui.label_rush_none, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelShadow(self.ui.label_replay, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelShadow(self.ui.label_hot, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelShadow(self.ui.label_rush, ccc3(0, 0, 0), ccp(2, 0))
  self.ui.label_replay:limitWidthByScale(70)
  ed.setLabelStroke(self.ui.Label_8599, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.cur_progress, ed.toccc3(1453599), 1)
  ed.setLabelStroke(self.ui.weekly_progress, ed.toccc3(2565412), 1)
  self:createBoxs()
  self:createFogs()
  self:refreshUI()
  self:refreshBuff()
  self.ui.btn_hot:setVisible(false)
end

function CrusadeScene:registerTouchEvents()
  self.ui.dragContainer:setTouchEnabled(true)
  self.ui.dragContainer:registerScriptTouchHandler(self:dragLayerTouch(), false, -128, false)
  ed.UITool.registerBtn(self, "btn_rule", function()
    ed.ui.CrusadeRuleWin.create():popWindow()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_replay", function()
    ed.CrusadeNetwork:showBattleRecord()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_shop", function()
    ed.UITool.openView("shopMain", {page = 3})
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_restart", function()
    ed.showConfirmDialog({
      text = T("\230\152\175\229\144\166\233\135\141\231\189\174\232\191\156\229\190\129?"),
      leftText = T("\229\143\150\230\182\136"),
      rightText = T("\231\161\174\229\174\154"),
      rightHandler = function()
        ed.CrusadeNetwork:resetBattle("normal")
      end
    })
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_restart_none", function()
    ed.showToast(T("\228\187\138\230\151\165\233\135\141\230\150\176\229\188\128\229\167\139\230\172\161\230\149\176\229\183\178\231\148\168\229\174\140\239\188\140\230\152\142\230\151\1655\231\130\185\230\129\162\229\164\141"))
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_rush", function()
    if not ed.CrusadeManager:canRush(true) then
      return
    end
    crusade.rushBattle()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_rush_none", function()
    ed.CrusadeManager:canRush(true)
  end, {pressScale = 0.95})
  for i = 1, ed.CrusadeManager.sumOfCrusadeStage do
    local x, y = self.ui["battle" .. i]:getPosition()
    self:btRegisterCircleClick({
      center = ccpAdd(ccp(x, y), CrusadeStageConfig[i].offsetClick),
      radius = 60 + CrusadeStageConfig[i].offsetRadius,
      parent = self.ui.layer_battle,
      pressHandler = function()
      end,
      cancelPressHandler = function()
      end,
      clickHandler = function()
        if not dragPressX then
          ed.CrusadeManager.LocalObjData.isAdvanceTeam = false
          self:reqEnemyInfo(i)
        end
      end
    })
  end
end

function CrusadeScene:shakeBox()
  local function handler()
    for i = 1, 15 do
      if ed.CrusadeManager.battleState[i] ~= nil and ed.CrusadeManager.battleState[i] == "passed" then
        self.ui["box" .. i]:setAction("Shake")
      end
    end
  end
  
  return handler
end

function CrusadeScene:initDragPos()
  self.offset = math.max(-1800, CrusadeStageConfig[ed.CrusadeManager.curStageIndex].posOffset + ed.display.halfFixedWidth)
  self.offset = math.min(self.offset, -ed.display.halfFixedWidth)
  self.ui.dragContainer:setPositionX(self.offset)
end

function CrusadeScene:initRewardUI(index)
  local data = ed.CrusadeManager.battleReward[index]
  if nil == data then
    return
  end
  local rewardBg = ed.createScale9Sprite("UI/alpha/1080P/common/mail_bj9_1.png", CCRectMake(10, 10, 19, 201.5))
  rewardBg:setContentSize(CCSizeMake(140, 44 * #data + 10))
  self.ui.layer_battle:addChild(rewardBg, 12)
  local x, y = self.ui["box" .. index]:getPosition()
  local posY = math.min(ed.display.winSize.height - 22 * #data - 40, y + 80)
  self.ui.rewardInfo = rewardBg
  self.ui.rewardInfo:setPosition(ccp(x, posY))
  self.ui.rewardInfo:setScale(0)
  self.ui.rewardInfo:runAction(CCScaleTo:create(0.1, 1))
  local oy = 44 * #data - 19
  for i, v in ipairs(data) do
    local itemIcon, itemNumber
    if v._type == "gold" then
      itemIcon = ed.createItemIcon({
        type = v._type,
        amount = 1
      })
      itemIcon:setScale(0.45)
      itemNumber = ed.createttf("x" .. v._amount, 18)
    elseif v._type == "simple_chest" then
      itemIcon = ed.createSprite("UI/alpha/1080P/common/handbook_icon_lock.png")
      local frame = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_blue.png")
      frame:setScale(0.5)
      itemIcon:addChild(frame)
      frame:setPosition(ed.getCenterPos(frame))
      itemIcon:setScale(0.9)
      itemNumber = ed.createttf("x" .. v._amount, 18)
    elseif v._type == "level_chest" then
      itemIcon = ed.createSprite("UI/alpha/1080P/common/handbook_icon_lock.png")
      local frame = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_blue.png")
      frame:setScale(0.5)
      itemIcon:addChild(frame)
      frame:setPosition(ed.getCenterPos(frame))
      itemIcon:setScale(0.9)
      itemNumber = ed.createttf("x" .. v._amount, 18)
    elseif v._type == "crusadepoint" then
      itemIcon = ed.createItemIcon({
        type = v._type,
        amount = 1
      })
      itemIcon:setScale(0.45)
      itemNumber = ed.createttf("x" .. v._amount, 18)
    end
    itemNumber:setColor(ed.toccc3(16776423))
    itemIcon:setPosition(35, oy)
    itemNumber:setPosition(100, oy)
    rewardBg:addChild(itemIcon)
    rewardBg:addChild(itemNumber)
    oy = oy - 40
  end
end

function CrusadeScene:hintBoxDown(index)
  if ed.CrusadeManager.battleState[index] ~= "unpassed" then
    return
  end
  if ed.CrusadeManager.curStageIndex <= 3 and 3 < index then
    return
  end
  if ed.CrusadeManager.curStageIndex <= 6 and 6 < index then
    return
  end
  if ed.CrusadeManager.curStageIndex <= 9 and 9 < index then
    return
  end
  if ed.CrusadeManager.curStageIndex <= 12 and 12 < index then
    return
  end
  self:initRewardUI(index)
end

function CrusadeScene:hintBox(index)
  if ed.CrusadeManager.battleState[index] == "rewarded" or ed.CrusadeManager.battleState[index] ~= "passed" then
    return
  end
  self.selectBox = index
  ed.CrusadeNetwork:drawReward(index)
end

function CrusadeScene:refreshLocalHeros(data)
  if data and data._oppos then
    for i = 1, #data._oppos do
      local index = (self.curSelectStage - 1) * 5 + i
      local heroId = string.format("tbcHero%d", index)
      local oldId = ed.storage.getInt(heroId)
      local newId = data._oppos[i]._base._tid
      if oldId ~= newId and newId ~= nil then
        ed.storage.setValue(heroId, newId)
        local heroLevel = data._oppos[i]._base._level
        local heroStar = data._oppos[i]._base._stars
        local heroRank = data._oppos[i]._base._rank
        local newLevel = string.format("tbcHeroLevel%d", index)
        local newStar = string.format("tbcHeroStar%d", index)
        local newRank = string.format("tbcHeroRank%d", index)
        local newArousaStatus = string.format("tbcHeroStatus%d", index)
        ed.storage.setValue(newLevel, heroLevel)
        ed.storage.setValue(newStar, heroStar)
        ed.storage.setValue(newRank, heroRank)
      end
    end
  end
end

function CrusadeScene:reqEnemyInfo(index)
  if index <= ed.CrusadeManager.curStageIndex and (index == 1 or ed.CrusadeManager.battleState[index - 1] == "rewarded") then
    self.curSelectStage = index
    ed.CrusadeNetwork:reqEnemyInfo(index)
  else
    ed.showToast(T("\229\133\179\229\141\161\230\156\170\229\188\128\229\144\175"))
  end
end

function CrusadeScene:OnChatRsp(data)
  if data._say and data._say._result == "success" then
    ed.showToast(T("\229\136\134\228\186\171\230\136\144\229\138\159"))
  end
end

function CrusadeScene:initData()
  self.curSelectStage = ed.CrusadeManager.curStageIndex
  ed.CrusadeManager.scene = self
end

function CrusadeScene:registerEvents(data)
  self:listenTimer(Timer:Always(1.5), self:shakeBox())
  self:listenEvent("ChatRsp", function(data)
    self:OnChatRsp(data)
  end)
  self:listenEvent(ed.CrusadeEventNames.GetReward, function()
    self:getReward()
  end)
  self:listenEvent(ed.CrusadeEventNames.QueryOppo, function(data)
    self:refreshLocalHeros(data)
    self:showBattleInfo(data)
  end)
  self:listenEvent(ed.CrusadeEventNames.BattleRecord, function(data)
    if not data._records then
      ed.showToast(T("\230\154\130\230\151\160\229\189\149\229\131\143\232\174\176\229\189\149"))
    else
      ed.ui.CrusadeReplayMainWin.create(data):popWindow()
    end
  end)
  self:listenEvent(ed.CrusadeEventNames.Reset, function(data)
    self:refreshUI()
  end)
  self:listenEvent(ed.CrusadeEventNames.GetWeeklyReward, function(data)
    self:refreshWeeklyRewardInfo()
  end)
end

function CrusadeScene.create()
  local self = base.create("crusade", {noBottomButton = true})
  setmetatable(self, CrusadeScene.mt)
  self:initData()
  self:initUI()
  self:registerTouchEvents()
  self:registerEvents()
  self:registerOnEnterHandler("onEnter", function()
    if self.needRefresh then
      self:refreshUI()
      self.needRefresh = false
    end
  end)
  return self
end

function crusade.rushBattle()
  if not ed.CrusadeManager:canRush() then
    return
  end
  local crusadeMercenary = ed.GuildManager.crusadeMercenary
  ed.pushScene(ed.ui.battleprepare.create({
    mode = "crusade",
    extraMode = "normal",
    tbc_rush_mode = true,
    tbc_recommend_heros = ed.CrusadeManager.rushHeros or {},
    heroLimit = {type = "level", detail = 65},
    hireMercenary = crusadeMercenary,
    objData = {isAdvanceTeam = true}
  }))
end

ed.crusade = crusade
