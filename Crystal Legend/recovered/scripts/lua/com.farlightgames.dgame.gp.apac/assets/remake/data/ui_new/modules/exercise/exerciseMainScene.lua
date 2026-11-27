local base = ed.ui.commonscene
local exerciseMainScene = newclass(base.mt)
ed.ui.exerciseMainScene = exerciseMainScene

function exerciseMainScene.create()
  local self = base.create("exerciseMainScene")
  setmetatable(self, exerciseMainScene.mt)
  self:initData()
  self:initUI()
  self:registerTouchEvents()
  self:registerEvents()
  self:registerOnEnterHandler("onEnter", function()
    self:refreshUI()
  end)
  self:registerOnPopSceneHandler("onPop", function()
    CloseScope(self.eventScope)
    self.eventScope = nil
  end)
  return self
end

function exerciseMainScene:initData()
  self.stagecell = {}
  self.rewardicon = {}
  self.eventScope = {}
end

function exerciseMainScene:initUI()
  self.container, self.ui = ed.editorui(ed.uieditor.exerciseMainScene)
  self.mainLayer:addChild(self.container)
  self.baseui.right_bottom_panel:setVisible(false)
  self:adaptWinSize()
  self:initLabel()
  self:initStageList()
  self:refreshBuff()
end

function exerciseMainScene:initLabel()
  ed.setLabelStroke(self.ui.times, ccc3(ed.colorToStr("#000000")), 1)
  ed.setLabelStroke(self.ui.today_label, ccc3(ed.colorToStr("#321A13")), 1)
  local _, titleTxt = ed.UITool.createSceneTitle(T("\232\139\177\233\155\132\232\175\149\231\130\188"), self.ui.title_bg, {
    position = ccp(20, 18)
  })
  ed.layout.relateLayout(titleTxt, self.ui.rule_btn, {
    right = titleTxt:getContentSize().width * 0.5 + 20
  })
  self.ui.title_light:setVisible(false)
  self.ui.times:setString(T("\228\187\138\230\151\165\229\137\169\228\189\153\230\140\145\230\136\152\230\172\161\230\149\176\239\188\154%s/%s", ed.exerciseNetWork:getQueryActStageReply()._user_left_time, ed.exerciseManager.dayMaxCount))
  self.ui.preview_label:limitWidthByScale(self.ui.preview_btn:getContentSize().width * 0.8)
end

function exerciseMainScene:doClickInStage()
  local function handler(x, y, group)
    ed.ui.exerciseStageWin.create(self, group)
  end
  
  return handler
end

function exerciseMainScene:doPressInStage()
  local function handler(x, y)
    if self.namePanel == nil then
      for i = 1, #self.stagecell do
        local stage = self.stagecell[i]
        
        if ed.containsPoint(stage.bg, x, y) and not ed.containsPoint(stage.itemLay, x, y) then
          return stage.group
        end
      end
    end
  end
  
  return handler
end

function exerciseMainScene:initStageList()
  local layersize = self.ui.listLayer:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, layersize.width, layersize.height),
    noshade = true,
    container = self.ui.listLayer,
    priority = 0,
    doClickIn = self:doClickInStage(),
    doPressIn = self:doPressInStage()
  }
  self.stagedraglist = ed.draglist.create(info)
  self:addStageCell()
end

function exerciseMainScene:refreshBuff()
  local buffMgr = ed.activityBuffMgr.getInstance()
  local param = {
    buffIdList = buffMgr:getbuffByType({
      "act_stage_item_multi"
    }),
    column = 5
  }
  if not self.buffTipsPanel then
    self.buffTipsPanel = ed.buffTipsPanel.create(param)
    self.mainLayer:addChild(self.buffTipsPanel.container)
    ed.layout.layoutWithMagin(self.buffTipsPanel.container, {left = 120, top = 90})
  else
    self.buffTipsPanel:refrehsPanel(param)
  end
end

function exerciseMainScene:addStageCell()
  local stages = ed.exerciseNetWork:getQueryActStageReply()._opened_act_stage
  local showStages = {}
  for i, v in ipairs(stages) do
    local ul = ed.getDataTable("Stage")[v]["Unlock Level"]
    if ul <= ed.player:getLevel() then
      table.insert(showStages, v)
    end
  end
  local listwidth = 0
  for i, group in ipairs(showStages) do
    local stageNode, stageUI = ed.editorui(ed.uieditor.exerciseStageCell)
    stageNode:setPosition(ccp(listwidth, 0))
    local bg = stageUI.bg
    local wanted_bg = stageUI.wanted_bg
    if ed.display.fit == "high" then
      bg = stageUI.bg_ipad
      wanted_bg = stageUI.wanted_bg_ipad
      local height = stageUI.wanted_bg_ipad:getContentSize().height - stageUI.wanted_bg:getContentSize().height
      stageUI.name:setPositionY(stageUI.name:getPositionY() + height)
      stageUI.reward_label:setPositionY(stageUI.reward_label:getPositionY() + 25)
      stageUI.rewardLayer:setPositionY(stageUI.rewardLayer:getPositionY() + 25)
    end
    bg:setVisible(true)
    wanted_bg:setVisible(true)
    self:createCellAnimation(wanted_bg, group, group)
    local groupTable = ed.lookupDataTable("ActStageGroup", nil, group)
    ed.setLabelStroke(stageUI.name, ccc3(ed.colorToStr("#874B15")), 1)
    stageUI.name:setString(groupTable["Group Name"])
    stageUI.name:limitWidthByScale(170)
    ed.setLabelStroke(stageUI.reward_label, ccc3(ed.colorToStr("#321E14")), 1)
    self:initStageCellRewardList(stageUI, groupTable["UI reward"])
    self.stagedraglist:addItem(stageNode)
    listwidth = listwidth + bg:getContentSize().width + 20 / ed.display.scaleFactor
    table.insert(self.stagecell, {
      bg = wanted_bg,
      group = group,
      itemLay = stageUI.rewardLayer
    })
  end
  self.stagedraglist:initListWidth(listwidth)
  local layersize = self.ui.listLayer:getContentSize()
  if listwidth <= layersize.width then
    local posx = layersize.width - listwidth
    local list = self.stagedraglist:getList()
    local listPosx, listPosy = list:getPosition()
    self.stagedraglist:setListPos(ccp(listPosx + posx / 2, listPosy))
  end
end

function exerciseMainScene:createCellAnimation(parent, group, degree)
  local bgsize = parent:getContentSize()
  local data = ed.exerciseManager.entryStage[group]
  local stagerow = ed.lookupDataTable("Stage", nil, degree)
  local battlerow = ed.lookupDataTable("Battle", nil, degree, stagerow.Waves)
  local id = string.format("Monster %d ID", battlerow["Boss Position"])
  local f = ed.lookupDataTable("Unit", "Puppet", battlerow[id])
  local n = string.gsub(f, "%.cha$", "")
  local fn
  if ed.getDataTable("Puppet")[f].Resource then
    local res = ed.getDataTable("Puppet")[f].Resource
    local comps = ed.getDataTable("Puppet")[f]["Change Components"]
    fn = ed.createFcaActor(res, data.scale)
    if comps and 0 < #comps then
      for i = 1, #comps, 2 do
        pcall(function()
          fn:setComponent(comps[i], comps[i + 1])
        end)
      end
    end
  else
    fn = ed.createFcaActor(n, data.scale)
  end
  local fa = "Idle"
  if data.fcaaction then
    fa = data.fcaaction
  end
  fn:setAction(fa)
  fn:setLoop(true)
  fn:setPosition(ccpAdd(ccp(bgsize.width / 2, bgsize.height / 2), data.offset or ccp(0, -50)))
  parent:addChild(fn, 10)
  self:addFca(fn)
  if data.shader then
    fn:useShader(data.shader)
  end
end

function exerciseMainScene:doPressInReward()
  local function handler(x, y)
    self.stagedraglist:setTouchEnabled(false)
    
    for i = 1, #self.rewardicon do
      local reward = self.rewardicon[i]
      if ed.containsPoint(reward.icon, x, y) then
        return reward, x
      end
    end
  end
  
  return handler
end

function exerciseMainScene:cancelPressInReward()
  local function handler(x, y, reward, oldx)
    self.stagedraglist:setTouchEnabled(true)
    
    self.touch = math.abs(oldx - x) < 20
    if self.touch then
      ed.ui.packageDetailWin.create({
        id = reward.id
      }):popWindow()
    end
  end
  
  return handler
end

function exerciseMainScene:initStageCellRewardList(stageUI, reward)
  local layersize = stageUI.rewardLayer:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, layersize.width, layersize.height),
    noshade = true,
    container = stageUI.rewardLayer,
    priority = -100,
    doPressIn = self:doPressInReward(),
    cancelPressIn = self:cancelPressInReward()
  }
  local rewardlist = ed.draglist.create(info)
  self:addStageReward(rewardlist, reward, stageUI)
end

function exerciseMainScene:addStageReward(rewardlist, reward, stageUI)
  local listwidth = 0
  for i, id in ipairs(reward) do
    local icon = ed.readequip.createIcon(id, rewardlist.cliprect.size.height - 5)
    icon:setAnchorPoint(ccp(0, 0))
    icon:setPosition(ccp(listwidth, 0))
    rewardlist:addItem(icon)
    listwidth = listwidth + ed.layout.getScaleSize(icon).width
    table.insert(self.rewardicon, {icon = icon, id = id})
  end
  rewardlist:initListWidth(listwidth)
  local posx = (rewardlist.cliprect.size.width - listwidth) / 2
  if 0 < posx then
    rewardlist.listLayer:setPositionX(posx)
  end
end

local strPage = T("\228\189\191\231\148\168\232\175\180\230\152\142\239\188\154\230\156\172\226\128\156\233\155\182\229\159\186\231\161\128\228\184\137\229\164\169\232\153\144\229\189\177\233\173\148\226\128\157\230\153\186\232\131\189\229\175\185\230\136\152\230\156\168\230\161\169\239\188\140\230\152\175\228\187\165\229\144\132\228\189\141\233\152\159\233\149\191\229\134\146\233\153\169\233\128\148\228\184\173\230\137\128\233\129\135<br/>") .. T("\229\188\186\230\149\140\228\184\186\232\147\157\230\156\172\239\188\140\229\191\160\232\175\154\232\191\152\229\142\159\229\133\182\230\136\152\229\138\155\227\128\129\233\152\181\229\174\185\229\143\138\228\186\164\230\136\152\231\142\175\229\162\131\231\154\132\230\168\161\230\139\159\229\153\168\227\128\130\228\189\191\231\148\168\230\156\172\231\179\187\229\136\151\228\186\167\229\147\129\239\188\140") .. T("\230\156\137\229\138\169\228\186\142\230\143\144\229\141\135\230\130\168\231\154\132\230\136\152\230\150\151\231\144\134\232\167\163\239\188\140\230\187\161\230\132\143\232\175\183\231\187\153\229\165\189\232\175\132\229\147\166\227\128\130<br/>") .. "<br/><br/>" .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\232\139\177\233\155\132\232\175\149\231\130\188\230\175\143\229\164\169\229\176\134\228\188\154\229\188\128\230\148\190\228\184\141\229\144\140\231\167\141\231\177\187\231\154\132\230\140\145\230\136\152\229\133\179\229\141\161\239\188\140\229\143\175\233\128\154\232\191\135\230\156\170\230\157\165\233\162\132\232\168\128\233\162\132\232\167\136\230\175\143\230\151\165\229\188\128\230\148\190\231\154\132\229\133\179\229\141\161\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\140\145\230\136\152\229\133\179\229\141\161\230\139\165\230\156\137\229\164\154\228\184\170\233\154\190\229\186\166\239\188\140\233\156\128\228\190\157\229\186\143\230\140\145\230\136\152\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\228\184\141\229\144\140\231\154\132\230\140\145\230\136\152\229\133\179\229\141\161\229\173\152\229\156\168\228\184\141\229\144\140\230\156\186\229\136\182\239\188\140\231\142\169\229\174\182\233\156\128\230\160\185\230\141\174\229\133\179\229\141\161\231\137\185\232\137\178\233\133\141\231\189\174\233\152\159\228\188\141\239\188\140\228\187\165\230\153\186\229\133\139\230\149\140\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\231\142\169\229\174\182\230\175\143\230\151\165\230\139\165\230\156\137%d\230\172\161\230\140\145\230\136\152\230\156\186\228\188\154\239\188\140\230\140\145\230\136\152/\230\137\171\232\141\161\228\187\187\230\132\143\229\133\179\229\141\161\233\156\128\232\166\129\230\182\136\232\128\151\230\140\145\230\136\152\230\172\161\230\149\176\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\140\145\230\136\152\230\172\161\230\149\176\230\175\143\230\151\1655\231\130\185\229\136\183\230\150\176\227\128\130<br/>")

function exerciseMainScene:showRulePopWin()
  strPage = string.format(strPage, ed.exerciseManager.dayMaxCount)
  ed.ui.commonRulePop.create({
    title = T("\232\167\132\229\136\153\232\175\180\230\152\142"),
    txt = strPage
  }):popWindow()
end

function exerciseMainScene:closeRulePopwin()
  if self.ruleContainer then
    local s = CCScaleTo:create(0.2, 0)
    s = CCEaseBackIn:create(s)
    local f = CCCallFunc:create(function()
      xpcall(function()
        self.ruleContainer:setVisible(false)
        self.ruleContainer:setTouchEnabled(false)
      end, EDDebug)
    end)
    s = CCSequence:createWithTwoActions(s, f)
    self.ruleContainer.sca:runAction(s)
  end
end

function exerciseMainScene:registerTouchEvents()
  ed.UITool.registerBtn(self, "close_btn", function()
    CloseScope(self.eventScope)
    if self.buffTipsPanel then
      self.buffTipsPanel:CloseScope()
    end
    ed.popScene()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "rule_btn", function()
    self:showRulePopWin()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "preview_btn", function()
    ed.ui.exercisePreviewWin.create()
  end, {pressScale = 0.9})
end

function exerciseMainScene:refreshUI()
  self.ui.times:setString(T("\228\187\138\230\151\165\229\137\169\228\189\153\230\140\145\230\136\152\230\172\161\230\149\176\239\188\154%s/%s", ed.exerciseNetWork:getQueryActStageReply()._user_left_time, ed.exerciseManager.dayMaxCount))
end

function exerciseMainScene:registerEvents()
  ListenEvent("closeCommonBattleWin", function()
    ed.exerciseNetWork:sendQueryActStage()
  end, self.eventScope)
  ListenEvent("closeCommonBattleFail", function()
    ed.exerciseNetWork:sendQueryActStage()
  end, self.eventScope)
  ListenEvent("refreshExercise", function()
    self:refreshUI()
  end, self.eventScope)
end

function exerciseMainScene:adaptWinSize()
  if ed.display.fit == "wide" then
    self:setBackground("UI/alpha/1080P/pool/pool_bg_2340.jpg")
    self.ui.listLayer:setContentSize(CCSizeMake(ed.display.winSize.width - 90 / ed.display.scaleFactor * 2, 708 / ed.display.scaleFactor))
    self.ui.today_label:removeFromParentAndCleanup(false)
    self.bg:addChild(self.ui.today_label)
    local size = self.bg:getContentSize()
    self.ui.today_label:setPosition(size.width / 2, 905 / ed.display.scaleFactor)
  elseif ed.display.fit == "high" then
    self.ui.bottom_bg:setVisible(false)
    self:setBackground("UI/alpha/1080P/pool/pool_bg_ipad.jpg")
    self.ui.close_btn:setPositionY(self.ui.close_btn:getPositionY() + 170 / ed.display.scaleFactor)
    self.ui.title_bg:setPositionY(self.ui.title_bg:getPositionY() + 170 / ed.display.scaleFactor)
    self.ui.challenge_times_bg:setPositionY(self.ui.challenge_times_bg:getPositionY() + 170 / ed.display.scaleFactor)
    self.ui.preview_btn:setPositionY(self.ui.preview_btn:getPositionY() + 170 / ed.display.scaleFactor)
    self.ui.listLayer:setContentSize(CCSizeMake(1740 / ed.display.scaleFactor, 860 / ed.display.scaleFactor))
    self.ui.today_label:removeFromParentAndCleanup(false)
    self.bg:addChild(self.ui.today_label)
    local size = self.bg:getContentSize()
    self.ui.today_label:setPosition(size.width / 2, 1210 / ed.display.scaleFactor)
  else
    self:setBackground("UI/alpha/1080P/pool/pool_bg_1.jpg")
    self.ui.today_label:removeFromParentAndCleanup(false)
    self.bg:addChild(self.ui.today_label)
    local size = self.bg:getContentSize()
    self.ui.today_label:setPosition(size.width / 2, 905 / ed.display.scaleFactor)
    self.ui.listLayer:setContentSize(CCSizeMake(ed.display.winSize.width - 90 / ed.display.scaleFactor * 2, 708 / ed.display.scaleFactor))
  end
  ed.layout.setNodePosWithWorldPos(self.ui.close_btn, ccp(130 / ed.display.scaleFactor, ed.display.winSize.height - 90 / ed.display.scaleFactor))
  ed.layout.setNodePosWithWorldPos(self.ui.title_bg, ccp(420 / ed.display.scaleFactor, ed.display.winSize.height - 85 / ed.display.scaleFactor))
  ed.layout.setNodePosWithWorldPos(self.ui.challenge_times_bg, ccp(ed.display.winSize.width - 515 / ed.display.scaleFactor, ed.display.winSize.height - 86 / ed.display.scaleFactor))
  ed.layout.setNodePosWithWorldPos(self.ui.preview_btn, ccp(ed.display.winSize.width - 188 / ed.display.scaleFactor, ed.display.winSize.height - 88 / ed.display.scaleFactor))
  ed.layout.setNodePosWithWorldPos(self.ui.listLayer, ccp(90 / ed.display.scaleFactor, 136 / ed.display.scaleFactor + ed.display.halfFixedHeight / 2))
end
