local base = ed.ui.commonscene
local class = newclass(base.mt)
ed.ui.TavernMainScene = class
class.Dancer_Talk = {
  T("\230\172\162\232\191\142\230\157\165\229\136\176\233\133\146\233\166\134\239\188\140\230\131\179\229\150\157\231\130\185\228\187\128\228\185\136\239\188\159"),
  T("\231\156\139\232\181\183\230\157\165\228\189\160\231\187\143\229\142\134\228\186\134\228\184\141\229\176\145\232\137\176\233\154\190\231\154\132\230\136\152\230\150\151\239\188\140\230\157\165\239\188\140\229\150\157\228\184\138\228\184\128\230\157\175\239\188\129"),
  T("\228\187\138\229\164\169\231\154\132\231\178\190\233\133\191\229\143\175\230\152\175\230\136\145\228\186\178\230\137\139\232\176\131\229\136\182\231\154\132\239\188\140\231\187\157\229\175\185\232\174\169\228\189\160\230\187\161\230\132\143\227\128\130")
}
class.Mode_Entry = {
  solo = {
    index = 1,
    ui = "tavernSoloEntry",
    spine = "eff_UI_Main_Solo",
    clickHandler = "onClickSoloArena"
  },
  autoChess = {
    index = 2,
    ui = "tavernAutoChessEntry",
    fca = "eff_UI_Chess_mode",
    clickHandler = "onClickAutoChess"
  },
  kingsPvp = {
    index = 3,
    ui = "tavernKingsPvpEntry",
    spine = "eff_UI_Main_KingsSword",
    clickHandler = "onClickKingsPvp"
  }
}
ed.UITool.registViewOpenFunc("TavernScene", function()
  local scene = ed.ui.TavernMainScene.create()
  ed.pushScene(scene)
end)

function class.create()
  local self = base.create("TavernMainScene", {noBottomButton = true})
  setmetatable(self, class.mt)
  self:init()
  self:registerOnPopSceneHandler("onPopScene", function()
    ed.stopMusic()
  end)
  return self
end

function class:init()
  self.curIndex = 1
  self.redPointMgr = ed.redPointMgr.getInstance()
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.tavernMainScene)
  self.mainLayer:addChild(container)
  self.ui = ui
  ed.layout.lazyAdaptBG(ui.image_bg)
  ed.UITool.createSceneTitle(T("\233\133\146\233\166\134"), self.ui.image_title_bg, {
    position = ccp(9, 19)
  })
  self.ui.btn_rule:setVisible(false)
  self:initLabels()
  self:initEffect()
  self:setBackButton()
  self:adaptUI()
  self:createAllEntry()
  self:refreshEntry()
  self:refreshArrow()
  self:refreshTokenAmount()
  self:showBubble()
  self:listenTimer(Timer:Always(5), function()
    self:showBubble()
  end)
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_weekly_amount, ed.toccc3(0), 1)
  ed.setLabelStroke(self.ui.label_bubble_1, ed.toccc3(3548706), 1)
  ed.setLabelStroke(self.ui.label_bubble_2, ed.toccc3(3873885), 1)
end

function class:initEffect()
  local dancer = ed.createSpine("effect/eff_UI_Tavern_Dancer/eff_UI_Tavern_Dancer", 0.5)
  dancer:setAnimation(0, "Idle", true)
  self.ui.panel_puppet:addChild(dancer)
  dancer:setPosition(ccp(self.ui.panel_puppet:getContentSize().width / 2, -75))
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.btn_toke_rule, {top = 22, right = 30})
  ed.layout.layoutWithMagin(self.ui.image_token_bg, {top = 22, right = 62})
  ed.layout.layoutWithMagin(self.ui.label_weekly_amount, {top = 60, right = 30})
  ed.layout.layoutWithMagin(self.ui.image_title_bg, {left = 80, top = 21}, false, true)
  ed.layout.layoutWithMagin(self.ui.image_arrow_left, {
    left = ed.display.getNotchHeight()
  }, false, true)
  ed.layout.layoutWithMagin(self.ui.image_arrow_right, {
    right = ed.display.getNotchHeight()
  }, false, true)
  self.ui.image_arrow_left:runAction(CCRepeatForever:create(CCSequence:create(ccArrayMake(CCMoveBy:create(1, ccp(20, 0)), CCMoveBy:create(1, ccp(-20, 0))))))
  self.ui.image_arrow_right:runAction(CCRepeatForever:create(CCSequence:create(ccArrayMake(CCMoveBy:create(1, ccp(-20, 0)), CCMoveBy:create(1, ccp(20, 0))))))
end

function class:createAllEntry()
  local entryList = {}
  for key, cfg in pairs(class.Mode_Entry) do
    local entry, ui = self:createEntry(key, cfg)
    entry.key = key
    entry.cfg = cfg
    entry.ui = ui
    table.insert(entryList, entry)
    self.ui.image_desk:addChild(entry)
    self:btRegisterButtonClick({
      button = ui.touch_area,
      key = key,
      pressHandler = function()
        ui.node:setScale(0.7)
      end,
      cancelPressHandler = function()
        ui.node:setScale(0.75)
      end,
      clickHandler = function()
        if cfg.clickHandler then
          self[cfg.clickHandler]()
        end
      end,
      force = true
    })
  end
  table.sort(entryList, function(a, b)
    return a.cfg.index < b.cfg.index
  end)
  self.entryList = entryList
end

function class:createEntry(key, cfg)
  local container, ui = ed.editorui(ed.uieditor[cfg.ui])
  container:setContentSize(CCSizeMake(225, 275))
  local effNode
  if cfg.spine then
    effNode = ed.createSpine(string.format("effect/%s/%s", cfg.spine, cfg.spine), 0.5)
    effNode:setAnimation(0, "Idle", true)
  elseif cfg.fca then
    effNode = ed.createFcaNode(cfg.fca)
    effNode:setAction("Idle_single")
    effNode:setLoopAction("Idle_single")
    effNode:setLoop(true)
    self:addFca(effNode)
    effNode:setScale(0.75)
  end
  ui.eff_pos:addChild(effNode)
  ed.setLabelFontName(ui.label_name, ed.fontBold)
  ed.setLabelStroke(ui.label_name, ed.toccc3(12807449), 1.5)
  if key == "kingsPvp" then
    local kingsPvpSeasonId = ed.realarena.mgr:getSeasonId()
    if 0 < kingsPvpSeasonId then
      local kingsSeasonCfg = ed.getDataTable("KingsSeason")[kingsPvpSeasonId]
      ed.setLabelString(ui.kings_pvp_label_test, kingsSeasonCfg["Season Name"])
    end
    self.redPointMgr:registerValueChange("kings_pvp_entry", self, {
      handle = function(value)
        ui.kings_pvp_red:setVisible(0 < value)
      end
    })
  elseif key == "solo" then
    self.soloRed = ed.createSpriteTools({
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      pos = ccp(200, 43),
      parent = ui.ImageView_79944,
      notShow = ed.storage.getBool(ed.getRoleKey("cricketFirstRed"))
    })
  end
  return container, ui
end

function class:refreshEntry(isShowAction)
  self.curIndex = math.max(self.curIndex, 1)
  self.curIndex = math.min(self.curIndex, #self.entryList - 1)
  for index, entry in ipairs(self.entryList) do
    local targetPos
    if index < self.curIndex then
      targetPos = ccp(-300, 188.5)
    elseif index == self.curIndex then
      targetPos = ccp(self.ui.pos_left:getPosition())
    elseif index == self.curIndex + 1 then
      targetPos = ccp(self.ui.pos_right:getPosition())
    elseif index > self.curIndex + 1 then
      targetPos = ccp(ed.display.winSize.width + 300, 188.5)
    end
    if isShowAction then
      entry:runAction(CCEaseSineOut:create(CCMoveTo:create(0.3, targetPos)))
    else
      entry:setPosition(targetPos)
    end
  end
end

function class:refreshArrow()
  self.ui.image_arrow_left:setVisible(self.curIndex ~= 1)
  self.ui.image_arrow_right:setVisible(self.curIndex + 1 ~= #self.entryList)
end

function class:refreshTokenAmount()
  local tokenAmount = ed.player:getPoint("tavern_point")
  ed.setLabelString(self.ui.label_token_amount, tokenAmount)
  local weeklyAmount = ed.player:getPoint("tavern_point_weekly")
  local maxAmount = ed.player:getPointMaxAmount("TavernPointWeekly")
  ed.setLabelString(self.ui.label_weekly_amount, string.format("\230\156\172\229\145\168\232\142\183\229\143\150\228\184\138\233\153\144\239\188\154%s/%s", weeklyAmount, maxAmount))
end

function class:showBubble()
  local bubbleIndex = math.random(1, #self.Dancer_Talk)
  local text = self.Dancer_Talk[bubbleIndex]
  ed.setLabelString(self.ui.label_bubble_1, text)
  local labelWidth = self.ui.label_bubble_1:getContentSize().width
  labelWidth = math.max(labelWidth, 282)
  local bubbleSize = CCSizeMake(labelWidth + 30, 104.5)
  self.ui.image_bubble:setContentSize(bubbleSize)
  self.ui.label_bubble_1:setPositionX(bubbleSize.width / 2)
  self.ui.label_bubble_2:setPositionX(bubbleSize.width / 2)
end

function class:refreshTag()
end

function class:onClickAutoChess()
  ed.UITool.openView("AutoChessArenaScene")
end

function class:onClickKingsPvp()
  ed.UITool.openView("KingsPvpMainScene")
end

function class:onClickSoloArena()
  ed.UITool.openView("SoloArenaScene")
end

function class:onEnter()
  ed.player:requestPoint({
    "tavern_point",
    "tavern_point_weekly"
  })
  ed.playMusic(ed.music.TavernMainScene)
end

function class:onClickLeftArrow()
  if self.curIndex <= 1 then
    return
  end
  self.curIndex = self.curIndex - 1
  self:refreshEntry(true)
  self:refreshArrow()
end

function class:onClickRightArrow()
  if self.curIndex >= #self.entryList - 1 then
    return
  end
  self.curIndex = self.curIndex + 1
  self:refreshEntry(true)
  self:refreshArrow()
end

function class:slideArenaTouch()
  local function handle(event, x, y)
    if event == "began" then
      self.startX = x
    elseif event == "ended" then
      if self.startX then
        if self.startX - x > 200 then
          self:onClickRightArrow()
        elseif x - self.startX > 200 then
          self:onClickLeftArrow()
        end
      end
      self.startX = nil
    end
    return true
  end
  
  return handle
end

function class:addTouchEvent()
  self.ui.slide_arena:setTouchEnabled(true)
  self.ui.slide_arena:registerScriptTouchHandler(self:slideArenaTouch(), false, -300, false)
  ed.UITool.registerBtn(self, "btn_toke_rule", function()
    ed.ui.commonRulePop.create({
      title = T("\232\175\180\230\152\142"),
      txt = ed.tavernDefine.TavernPointTips
    }):popWindow()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "image_token_bg", function()
    ed.UITool.openView("packageDetail", {
      type = "TavernPoint"
    })
  end, {pressScale = 0.95})
  self:btRegisterButtonClick({
    button = self.ui.panel_puppet,
    key = "click_puppet",
    clickHandler = function()
      ed.UITool.openView("shopMain", {page = 7})
    end,
    force = true
  })
  ed.UITool.registerBtn(self, "image_arrow_left", function()
    self:onClickLeftArrow()
  end, {pressScale = 0.65, normalScale = 0.7})
  ed.UITool.registerBtn(self, "image_arrow_right", function()
    self:onClickRightArrow()
  end, {pressScale = 0.65, normalScale = 0.7})
end

function class:addEventListener()
  self:listenEvent("ResourceNumChange", function(name)
    if name == "tavern_point" or name == "tavern_point_weekly" then
      self:refreshTokenAmount()
    end
  end)
  self:listenEvent("MainBuildRedTagChange", function(buildType)
    if buildType == ed.ui.configs.mainSceneMap.builddingType.Tavern then
      self.soloRed:setVisible(not ed.storage.getBool(ed.getRoleKey("cricketFirstRed")))
    end
  end)
end
