local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.rogueGoldenScene = class
ed.UITool.registViewOpenFunc("rogueGoldenScene", function()
  local scene = ed.ui.rogueGoldenScene.create()
  ed.pushScene(scene)
end)

function class.create(param)
  local self = base.create("rogueGoldenScene")
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init(param)
  param = param or {}
  self.rogueGoldenRewardTB = ed.getDataTable("RogueGoldenReward")
  self.rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  self.weeklyPoint = self.rogueLikeMgr:getWeeklyPoint()
  self.goldenPoint = self.rogueLikeMgr:getGoldenPoint()
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueGoldenScene)
  self.ui = ui
  self.mainLayer:addChild(container)
  local _, titleText = ed.UITool.createSceneTitle(T("\233\187\132\233\135\145\229\177\139"), self.ui.image_title_bg, {
    position = ccp(9, 19)
  })
  ed.layout.relateLayout(titleText, self.ui.btn_rule, {
    right = titleText:getContentSize().width * 0.5 + 20
  })
  self.titleText = titleText
  self:initLabels()
  self:adaptUI()
  self:initEffect()
  self:setBackButton()
  self:initDragList()
  self:refreshView()
end

function class:showOpenAction()
  self.ui.image_title_bg:setCascadeOpacityEnabled(true)
  self.ui.btn_rule:setCascadeOpacityEnabled(true)
  self.ui.image_title_bg:setOpacity(0)
  self.ui.image_title_bg:runAction(CCFadeTo:create(0.5, 255))
  self.titleText:setOpacity(0)
  self.titleText:runAction(CCFadeTo:create(0.5, 255))
end

function class:initEffect()
  local eff_book = ed.createSpine("effect/eff_UI_rogue_golden_house_book/eff_UI_rogue_golden_house_book", 0.5)
  eff_book:setAnimation(0, "Idle", false)
  self.ui.image_bg:addChild(eff_book)
  eff_book:setPosition(ccp(585, 360))
  eff_book:registerScriptSpineHandler(function(event)
    if event == "end" then
      eff_book:setAnimation(1, "Idle2", true)
    end
  end)
  local eff_paper_left = ed.createSpine("effect/eff_UI_rogue_golden_house_paper/eff_UI_rogue_golden_house_paper", 0.5)
  eff_paper_left:setAnimation(0, "Idle", false)
  eff_paper_left:setPosition(ccp(600, 360))
  self.ui.image_bg:addChild(eff_paper_left)
  eff_paper_left:registerScriptSpineHandler(function(event)
    if event == "end" then
      eff_paper_left:setAnimation(1, "Idle2", true)
    end
  end)
  local eff_paper_right = ed.createSpine("effect/eff_UI_rogue_golden_house_paper/eff_UI_rogue_golden_house_paper", 0.5)
  eff_paper_right:setScaleX(-1)
  eff_paper_right:setAnimation(0, "Idle", false)
  eff_paper_right:setPosition(ccp(580, 360))
  self.ui.image_bg:addChild(eff_paper_right)
  eff_paper_right:registerScriptSpineHandler(function(event)
    if event == "end" then
      eff_paper_right:setAnimation(1, "Idle2", true)
    end
  end)
  local eff_get = ed.createSpine("effect/eff_UI_rogue_golden_house_get/eff_UI_rogue_golden_house_get", 0.5)
  self.ui.image_bg:addChild(eff_get)
  eff_get:setPosition(ccp(585, 360))
  self.eff_get = eff_get
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_exp, ed.toccc3(7153021), 1)
  ed.setLabelStroke(self.ui.label_exp_max, ed.toccc3(7153021), 1)
  ed.setLabelStroke(self.ui.label_weekly_exp, ed.toccc3(7153021), 1)
  ed.setLabelStroke(self.ui.label_weekly_exp_max, ed.toccc3(7153021), 1)
  ed.setLabelStroke(self.ui.label_weekly_exp_tips, ed.toccc3(7153021), 1)
  local labelLevel = ed.ui.gradientLabel.create({
    fontSize = 67,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16772468),
    endColor = ed.toccc3(16776423),
    strokeSize = 2,
    strokeColor = ed.toccc3(12481071)
  })
  self.ui.panel_level:addChild(labelLevel.node)
  ed.layout.centerInParent(labelLevel.node)
  self.labelLevel = labelLevel
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.image_title_bg, {left = 80, top = 21}, false, true)
  ed.layout.layoutWithMagin(self.ui.image_weekly_exp_bg, {right = 0}, false, true)
end

function class:initDragList()
  self.dragList = ed.UITool.createDraglist(self.ui.panel_list, {
    doPressIn = function(x, y)
      for index, item in ipairs(self.rewardIconList) do
        local icon = item.icon
        if ed.containsPoint(icon, x, y) then
          icon:setScale(0.95)
          return item
        end
      end
    end,
    doClickIn = function(x, y, item)
      local level = item.level
      local rewardCfg = item.rewardCfg
      local flag = self.rogueLikeMgr:getGoldenRewardFlagById(level)
      if not flag and self.goldenPoint >= rewardCfg.Point then
        self.eff_get:setAnimation(0, "Idle", false)
        self.eff_get:registerScriptSpineHandler(function(event)
          if event == "end" then
            ed.rogueLikeNet.sendGoldenReward(level)
          end
        end)
      else
        local rewardId = rewardCfg["Reward ID"]
        local rewardType = rewardCfg["Reward Type"]
        local amount = rewardCfg["Reward Amount"]
        ed.UITool.openView("packageDetail", {
          type = rewardType,
          id = rewardId,
          count = amount
        })
      end
    end,
    cancelPressIn = function(x, y, item)
      local icon = item.icon
      if not tolua.isnull(icon) then
        icon:setScale(1)
      end
    end,
    priority = -300
  })
end

function class:refreshDragList()
  local listX, listY = self.dragList:getListPos()
  self.dragList:clearList()
  local scoreContainer, targetPosX = self:createListItem()
  self.dragList:addItem(scoreContainer)
  self.dragList:initListWidth(scoreContainer:getContentSize().width)
  if targetPosX then
    targetPosX = targetPosX - self.ui.panel_list:getContentSize().width / 2
    targetPosX = math.min(targetPosX, self.dragList.listWidth - self.ui.panel_list:getContentSize().width)
    targetPosX = math.max(targetPosX, 0)
    self.dragList:setListPos(ccp(-targetPosX, listY))
  else
    self.dragList:setListPos(ccp(listX, listY))
  end
end

function class:refreshView()
  self:refreshDragList()
  self.labelLevel:setString(self.curLevel)
  local maxExp, curExp = 0, 0
  if self.rogueGoldenRewardTB[self.curLevel + 1] then
    local curMaxExp = self.rogueGoldenRewardTB[self.curLevel] and self.rogueGoldenRewardTB[self.curLevel].Point or 0
    local nextLevelExp = self.rogueGoldenRewardTB[self.curLevel + 1].Point
    maxExp = nextLevelExp - curMaxExp
    curExp = self.goldenPoint - curMaxExp
  end
  ed.setLabelString(self.ui.label_exp_max, "/" .. maxExp)
  ed.setLabelString(self.ui.label_exp, curExp)
  self.ui.exp_icon:setPositionX(self.ui.label_exp_max:getPositionX() + self.ui.label_exp_max:getContentSize().width + 5)
  ed.layout.horizontalSortNode({
    self.ui.label_exp,
    self.ui.label_exp_max,
    self.ui.exp_icon
  }, {
    0,
    0,
    0
  }, self.ui.image_exp_bg:getContentSize().width * 0.5)
  local weeklyExpMax = ed.getDataTable("RogueConfig")["Weekly Exp Max"]["Script Arg"]
  ed.setLabelString(self.ui.label_weekly_exp, self.weeklyPoint)
  ed.setLabelString(self.ui.label_weekly_exp_max, "/" .. weeklyExpMax)
  self.ui.weekly_exp_icon:setPositionX(self.ui.label_weekly_exp_max:getPositionX() + self.ui.label_weekly_exp_max:getContentSize().width + 5)
  self.ui.label_weekly_exp_tips:setPositionX(self.ui.label_weekly_exp:getPositionX() - self.ui.label_weekly_exp:getContentSize().width - 5)
end

function class:createListItem()
  local bg = CCLayerColor:create(ccc4(255, 0, 0, 255))
  local gapX = 25
  local count = 0
  self.rewardIconList = {}
  self.curLevel = 0
  local targetPosX
  local curExpWidth = 0
  local prePoint = 0
  local prePosX = 5
  for level, rewardCfg in ipairs(self.rogueGoldenRewardTB) do
    count = count + 1
    local requirePoint = rewardCfg.Point
    local isReached = requirePoint <= self.goldenPoint
    if isReached then
      self.curLevel = level
    end
    local icon, target = self:createRewardIcon(level, rewardCfg, isReached)
    table.insert(self.rewardIconList, {
      icon = icon,
      level = level,
      rewardCfg = rewardCfg
    })
    local scoreBg = ed.createSprite("UI/alpha/1080P/rogue/main/main_golden_reward_bg.png")
    local labelLevel = ed.createttf(level, 18)
    ed.setLabelColor(labelLevel, ed.toccc3(16776423))
    ed.setLabelStroke(labelLevel, ed.toccc3(8205759), 1)
    scoreBg:addChild(labelLevel)
    ed.layout.centerInParent(labelLevel)
    local barPoint
    if isReached then
      barPoint = ed.createSprite("UI/alpha/1080P/rogue/main/main_golden_progress_point.png")
    else
      barPoint = ed.createSprite("UI/alpha/1080P/rogue/main/main_golden_progress_3.png")
    end
    bg:addChild(scoreBg, 1)
    bg:addChild(barPoint, 1)
    bg:addChild(icon, 1)
    local posX = level * icon:getContentSize().width + gapX * (level - 1)
    barPoint:setPosition(ccp(posX, 10))
    scoreBg:setPosition(ccp(posX, 40))
    icon:setPosition(ccp(posX, 100))
    icon:setScale(1)
    if target and not targetPosX then
      targetPosX = posX
    end
    if requirePoint <= self.goldenPoint then
      curExpWidth = curExpWidth + (posX - prePosX)
      prePoint = requirePoint
      prePosX = posX
    elseif requirePoint > self.goldenPoint and level - self.curLevel == 1 then
      curExpWidth = curExpWidth + (self.goldenPoint - prePoint) / (requirePoint - prePoint) * (posX - prePosX)
    end
  end
  local width = count * 90 + count * gapX
  local barBg = ed.createScale9Sprite("UI/alpha/1080P/rogue/main/main_golden_progress_2.png", CCRectMake(57, 0, 57, 0))
  barBg:setAnchorPoint(ccp(0, 0.5))
  barBg:setContentSize(CCSizeMake(width + 25, 74.5))
  local bar = ed.createScale9Sprite("UI/alpha/1080P/rogue/main/main_golden_progress_1.png", CCRectMake(2, 0, 36.5, 1))
  bar:setAnchorPoint(ccp(0, 0.5))
  barBg:addChild(bar)
  bar:setPositionX(30)
  bar:setPositionY(barBg:getContentSize().height / 2)
  if curExpWidth == 0 then
    bar:setVisible(false)
  end
  bar:setContentSize(CCSizeMake(curExpWidth, 3.5))
  bg:addChild(barBg, 0)
  barBg:setPosition(ccp(-25, 10))
  bg:setContentSize(CCSizeMake(width + 45, 0))
  return bg, targetPosX
end

function class:createRewardIcon(level, rewardCfg, isReached)
  local rewardId = rewardCfg["Reward ID"]
  local rewardType = rewardCfg["Reward Type"]
  local amount = rewardCfg["Reward Amount"]
  local icon = ed.createItemIcon({
    id = rewardId,
    type = rewardType,
    amount = amount
  })
  local flag = self.rogueLikeMgr:getGoldenRewardFlagById(level)
  local target = false
  if flag then
    local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
    local imageReceived = ed.createSprite("UI/alpha/1080P/package/selected.png")
    icon:addChild(mask, 1)
    icon:addChild(imageReceived, 2)
    imageReceived:setPosition(ccp(45, 40))
    mask:setPosition(ccp(45, 45))
  elseif isReached then
    target = true
    local eff = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
    icon:addChild(eff)
    eff:setPosition(46, 45)
    eff:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
  else
    target = true
  end
  return icon, target
end

function class:onClickBtnRule()
  ed.ui.commonRulePop.create({
    title = T("\230\180\187\229\138\168\232\175\180\230\152\142"),
    txt = ed.rogueDefine.RULES_TEXT
  }):popWindow()
end

function class:onClickWeeklyExpIcon()
  ed.ui.packageDetailWin.create({type = "RogueExp"}):popWindow()
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_rule", function()
    self:onClickBtnRule()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "weekly_exp_icon", function()
    self:onClickWeeklyExpIcon()
  end)
end

function class:addEventListener()
  self:listenEvent("rogueGoldenReward", function()
    self:refreshView()
  end)
end
