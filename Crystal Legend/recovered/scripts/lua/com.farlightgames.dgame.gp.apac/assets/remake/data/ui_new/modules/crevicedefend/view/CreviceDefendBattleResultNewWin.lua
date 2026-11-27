local base = ed.ui.popwindow
local CreviceDefendBattleResultWin = newclass(base.mt)
ed.ui.CreviceDefendBattleResultWin = CreviceDefendBattleResultWin
local TeamUIConfig = {
  [1] = {
    bgPath = "UI/alpha/1080P/crevicedefend/team1.png",
    teamColor = ed.toccc3(16775585),
    teamStrokeColor = ed.toccc3(11954462)
  },
  [2] = {
    bgPath = "UI/alpha/1080P/crevicedefend/team2.png",
    teamColor = ed.toccc3(12910590),
    teamStrokeColor = ed.toccc3(2455953)
  },
  [3] = {
    bgPath = "UI/alpha/1080P/crevicedefend/team3.png",
    teamColor = ed.toccc3(16770763),
    teamStrokeColor = ed.toccc3(10240554)
  },
  [4] = {
    bgPath = "UI/alpha/1080P/crevicedefend/team4.png",
    teamColor = ed.toccc3(16771503),
    teamStrokeColor = ed.toccc3(10240554)
  },
  [5] = {
    bgPath = "UI/alpha/1080P/crevicedefend/team5.png",
    teamColor = ed.toccc3(13625343),
    teamStrokeColor = ed.toccc3(2379449)
  }
}

function CreviceDefendBattleResultWin.create(data)
  local self = base.create("CreviceDefendBattleResultWin", {layer_opacity = 217})
  setmetatable(self, CreviceDefendBattleResultWin.mt)
  self:initData(data)
  self:initAppearance()
  self:registerTouchHandlers()
  self:registerEvents()
  self:initView()
  self:popWindow()
  return self
end

function CreviceDefendBattleResultWin:initData(data)
  self.new_rank = data._new_rank
  self.last_rank = data._last_rank
  self.new_damage = data._new_damage
  self.last_damage = data._last_damage
  self.replay = data._battle_replay
  self.summary = data._battle_summary
  self.target_damage = data._target_damage
  self.target_rank = data._target_rank
  self.best_lineup_damage = data._best_lineup_damage
end

function CreviceDefendBattleResultWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_close", function()
    FireEvent("EventCreviceDefendStageEnd")
    ed.stopEffect(ed.audioParam.effects.battleResult)
    self:destroy()
  end, {pressScale = 0.95})
end

function CreviceDefendBattleResultWin:registerEvents()
end

function CreviceDefendBattleResultWin:initAppearance()
  ed.editorui(ed.uieditor.crevicedefendBattleResultWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabel()
  self:setLabelContent()
end

function CreviceDefendBattleResultWin:initLabel()
  self:initTitleLabel()
  ed.setLabelColor(self.ui.label_damage_title, ed.toccc3(16700269))
  ed.setLabelStroke(self.ui.label_damage_title, ed.toccc3(3744789), 1)
  ed.setLabelColor(self.ui.label_zonerank_value, ed.toccc3(16700269))
  ed.setLabelStroke(self.ui.label_zonerank_value, ed.toccc3(3087902), 1)
  ed.setLabelColor(self.ui.label_damage_high_score, ed.toccc3(16745529))
  ed.setLabelStroke(self.ui.label_damage_high_score, ed.toccc3(9178635), 1)
end

function CreviceDefendBattleResultWin:initTitleLabel()
  local content
  local damage_delta = self.new_damage - self.last_damage
  if 0 < damage_delta then
    content = T("\228\188\164\229\174\179\230\143\144\229\141\135")
  else
    content = T("\230\140\145\230\136\152\231\187\147\230\157\159")
  end
  local title_node = ed.ui.gradientLabel.create({
    text = content,
    fontSize = 36,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16775891),
    endColor = ed.toccc3(16769357),
    strokeSize = 2,
    strokeColor = ccc3(102, 15, 5)
  })
  self.ui.layer_title:addChild(title_node.node, 2)
end

function CreviceDefendBattleResultWin:setLabelContent()
  self:setTargetLabel()
  self:setSeasonRank()
end

function CreviceDefendBattleResultWin:setTargetLabel()
  local desc
  local autoText = ed.ui.autoText.new()
  if self.new_rank == 1 then
    desc = string.format(T("<lable color=ccc3(255,252,231) strokeColor=creviceStrokeColor strokeSize=1>\230\130\168\229\183\178\231\187\143\230\136\144\228\184\186\232\181\155\229\140\186\231\172\172 </lable><sprite src=UI/alpha/1080P/crevicedefend/big_pvp_%s.png>") .. "<lable color=ccc3(255,252,231) strokeColor=creviceStrokeColor strokeSize=1> \229\144\141</lable>", self.new_rank)
    autoText:initParam({context = desc, fontSize = 18})
    autoText:setVerticalCenter()
    local width, height = autoText:getCurContentSize()
    autoText.node:setPositionX(-width * 0.5)
    self.ui.layer_damagerank:addChild(autoText.node, 5)
  else
    desc = string.format(T("<lable color=ccc3(255,252,231) strokeColor=creviceStrokeColor strokeSize=1>\232\191\152\233\156\128 </lable><lable color=ccc3(255,161,99)  strokeColor=creviceStrokeColor strokeSize=1 >%s</lable><lable color=ccc3(255,252,231) strokeColor=creviceStrokeColor strokeSize=1 > \228\188\164\229\174\179\232\182\133\232\182\138\231\172\172 </lable><lable color=ccc3(255,252,231) strokeColor=creviceStrokeColor strokeSize=1 >   \229\144\141</lable>"), self.target_damage - self.new_damage + 1)
    autoText:initParam({context = desc, fontSize = 18})
    autoText:setVerticalCenter()
    local width, height = autoText:getCurContentSize()
    autoText.node:setPositionX(-width * 0.5)
    self.ui.layer_damagerank:addChild(autoText.node, 5)
    local rank = ed.ui.gradientLabel.create({
      text = self.target_rank,
      fontSize = 18,
      fontName = ed.font,
      startColor = ed.toccc3(9041918),
      endColor = ed.toccc3(6727423),
      strokeSize = 2,
      strokeColor = ed.toccc3(1975884),
      hAlignment = kCCTextAlignmentCenter
    })
    self.ui.layer_damagerank:addChild(rank.node, 5)
    local width2, _ = autoText:getCurContentSize()
    local w = rank.node:getContentSize().width
    local offset = 5
    if self.target_rank >= 10 and self.target_rank < 100 then
      offset = 4.1
    elseif self.target_rank >= 100 then
      offset = 3
    end
    rank.node:setPositionX(width2 - 168 + offset)
  end
end

function CreviceDefendBattleResultWin:setSeasonRank()
  self:setResultRank()
  self:setResultDamage()
end

function CreviceDefendBattleResultWin:setResultRank()
  local rank_delta = self.new_rank - self.last_rank
  local countParam
  local normalDamage = string.format(T("<lable color=ccc3(255,252,231) strokeColor=creviceStrokeColor strokeSize=1 fontSize=f18>%s</lable>"), tostring(self.new_rank))
  local upDamage = string.format(T("<lable color=creviceHeadlineGreenColor strokeColor=creviceHeadlineOrangeColor strokeSize=1>(</lable><sprite src=UI/alpha/1080P/battleresult/arrow_up.png><lable color=creviceHeadlineGreenColor strokeColor=creviceHeadlineOrangeColor strokeSize=1>%s)</lable>"), tostring(rank_delta))
  if 0 < rank_delta then
    countParam = {
      context = normalDamage .. upDamage
    }
    local AutoText = ed.ui.autoText.new()
    AutoText:initParam(countParam)
    ed.UITool.replaceUI(self.ui, "bg", "label_zonerank_title", AutoText.node)
    local width, height = AutoText:getCurContentSize()
    AutoText.node:setPositionX(width + self.ui.label_zonerank_value:getPositionX() + 265)
  else
    local rank = ed.ui.gradientLabel.create({
      text = self.new_rank,
      fontSize = 18,
      fontName = ed.font,
      startColor = ed.toccc3(9041918),
      endColor = ed.toccc3(6727423),
      strokeSize = 2,
      strokeColor = ed.toccc3(1975884)
    })
    self.ui.layer_zonerank_title:addChild(rank.node)
    rank.node:setAnchorPoint(ccp(1, 0.5))
    rank.node:setPositionX(rank.node:getPositionX() + 5)
  end
end

function CreviceDefendBattleResultWin:setResultDamage()
  local damage_delta = self.new_damage - self.last_damage
  local normalDamage = string.format(T("<lable color=ccc3(255,252,231) strokeColor=creviceStrokeColor strokeSize=1 fontSize=f18>%s</lable>"), tostring(self.new_damage))
  local upDamage = string.format(T("<lable color=creviceHeadlineGreenColor strokeColor=creviceHeadlineOrangeColor strokeSize=1> (</lable><sprite src=UI/alpha/1080P/battleresult/arrow_up.png><lable color=creviceHeadlineGreenColor strokeColor=creviceHeadlineOrangeColor strokeSize=1>%s)</lable>"), tostring(damage_delta))
  if 0 < damage_delta and self.last_damage > 0 then
    local damageAutoText2 = ed.ui.autoText.new()
    local countParam = {context = upDamage}
    damageAutoText2:initParam(countParam)
    damageAutoText2.node:setAnchorPoint(ccp(0, 0.5))
    self.ui.layer_damage_title_value:addChild(damageAutoText2.node)
  end
  local damageAutoText = ed.ui.autoText.new()
  local countParam2 = {context = normalDamage}
  damageAutoText:initParam(countParam2)
  local width, height = damageAutoText:getCurContentSize()
  damageAutoText.node:setPositionX(4 - width)
  self.ui.layer_damage_title_value:addChild(damageAutoText.node)
  if self.last_damage > 0 then
    local totalDamage = 0
    for i, v in pairs(self.best_lineup_damage) do
      totalDamage = totalDamage + v
    end
    local damageLabel = ed.ui.gradientLabel.create({
      text = ed.formatDamage(totalDamage),
      fontSize = 18,
      startColor = ed.toccc3(16775386),
      endColor = ed.toccc3(16745529),
      strokeSize = 1,
      strokeColor = ed.toccc3(2564894)
    })
    damageLabel.node:setAnchorPoint(ccp(1, 0.5))
    ed.UITool.replaceUI(self.ui, "bg", "label_damage_high_scorevalue", damageLabel.node)
  end
  self.ui.label_damage_des:setVisible(self.last_damage > 0)
  self.ui.label_damage_high_score:setVisible(self.last_damage > 0)
end

function CreviceDefendBattleResultWin:initView()
  self:refreshView()
  self:addViewAnimation()
end

function CreviceDefendBattleResultWin:refreshView()
  if self.last_damage == 0 then
    self.ui.panel_record:setPositionY(self.ui.panel_record:getPositionY() + 20)
  end
  local recordList = self.replay._records
  if nil == self.ui.recordDraglist then
    self.ui.recordDraglist = ed.UITool.createDraglist(self.ui.panel_record, {
      priority = -300,
      doPressIn = self:getPressInHandler(),
      doClickIn = self:getClickInHandler(),
      cancelPressIn = self:getCancelPressInHandler()
    })
    self.refreshCliprectConfig = {
      draglist = self.ui.recordDraglist
    }
  else
    self.ui.recordDraglist:clearList()
  end
  self.recordUIArr = {}
  for i, v in ipairs(recordList) do
    local itemContainer, itemUI = self:createTeamItem(i, v)
    self.ui.recordDraglist:addItem(itemContainer)
    itemContainer:setPosition(self:getPos(i))
    table.insert(self.recordUIArr, itemUI)
  end
  self.ui.recordDraglist:initListHeight(self:getHeight(#recordList))
end

function CreviceDefendBattleResultWin:getPos(i)
  local size = self.ui.panel_record:getContentSize()
  local ox = size.width / 2
  local oy = size.height
  local itemHeight = 50
  local itemSpace = 4
  local dy = oy - (i - 0.5) * itemHeight - (i - 1) * itemSpace
  return ccp(ox, dy)
end

function CreviceDefendBattleResultWin:getHeight(num)
  local itemHeight = 50
  local itemSpace = 4
  return (itemHeight + itemSpace) * num - itemSpace
end

function CreviceDefendBattleResultWin:createTeamItem(index, teamData)
  local container, ui = ed.editorui(ed.uieditor.crevicedefendBattleResultItem)
  container:setContentSize(ui.bg:getContentSize())
  ui.index = index
  local uiConfig = TeamUIConfig[index]
  ed.setScale9SpriteTexture(ui.bg_img, uiConfig.bgPath)
  ui.bg_img:setContentSize(CCSizeMake(650, 51))
  ed.setLabelColor(ui.label_team, uiConfig.teamColor)
  ed.setLabelStroke(ui.label_team, uiConfig.teamStrokeColor, 1)
  ed.setLabelStroke(ui.label_damage_des, ed.toccc3(2564894), 1)
  ed.setString(ui.label_team, T("%s\233\152\159", index))
  ui.label_team:setFontName(ed.fontBold)
  ed.setLabelColor(ui.label_teamDamage, ccc3(232, 177, 82))
  ed.setLabelStroke(ui.label_teamDamage, ed.toccc3(2564894), 1)
  ed.setLabelColor(ui.label_teamDamage_high, ed.toccc3(14649679))
  ed.setLabelStroke(ui.label_teamDamage_high, ed.toccc3(9178635), 1)
  ed.setLabelColor(ui.label_teamDamage_normal, ccc3(232, 177, 82))
  ed.setLabelStroke(ui.label_teamDamage_normal, ed.toccc3(2564894), 1)
  ui.label_num:setVisible(self.last_damage ~= 0)
  ui.label_num_histoy_score:setVisible(self.last_damage ~= 0)
  ui.label_teamDamage:setVisible(self.last_damage ~= 0)
  ui.label_teamDamage_high:setVisible(self.last_damage ~= 0)
  ui.label_num_score_normal:setVisible(self.last_damage == 0)
  ui.label_teamDamage_normal:setVisible(self.last_damage == 0)
  if self.last_damage > 0 then
    local teamDamage = self.best_lineup_damage[index]
    if teamDamage < teamData._damage then
      ed.setTexture(ui.image_score_state, "UI/alpha/1080P/crevicedefend/arrow_up.png", true)
    else
      ed.setTexture(ui.image_score_state, "UI/alpha/1080P/crevicedefend/arrow_down.png", true)
    end
    ui.image_score_state:setVisible(true)
    local damageLabel = ed.ui.gradientLabel.create({
      text = ed.formatDamage(teamData._damage),
      fontSize = 18,
      startColor = ed.toccc3(16775386),
      endColor = ed.toccc3(16764526),
      strokeSize = 1,
      strokeColor = ed.toccc3(2564894)
    })
    ed.UITool.replaceUI(ui, "bg", "label_num", damageLabel.node)
    local teamDamage = self.best_lineup_damage[index]
    local damageLabel2 = ed.ui.gradientLabel.create({
      text = ed.formatDamage(teamDamage),
      fontSize = 18,
      startColor = ed.toccc3(16775386),
      endColor = ed.toccc3(16745529),
      strokeSize = 1,
      strokeColor = ed.toccc3(2564894)
    })
    ed.UITool.replaceUI(ui, "bg", "label_num_histoy_score", damageLabel2.node)
  else
    local damageLabel = ed.ui.gradientLabel.create({
      text = ed.formatDamage(teamData._damage),
      fontSize = 18,
      startColor = ed.toccc3(16775386),
      endColor = ed.toccc3(16764526),
      strokeSize = 1,
      strokeColor = ed.toccc3(2564894)
    })
    ed.UITool.replaceUI(ui, "bg", "label_num_score_normal", damageLabel.node)
    ui.image_score_state:setVisible(false)
  end
  self:createHeroList(ui.panel_hero, teamData._self_heroes)
  return container, ui
end

function CreviceDefendBattleResultWin:createHeroList(container, heroData)
  ed.readhero.sortIDByRange(heroData._heroes or {}, function(tab)
    return tab._tid
  end)
  container:removeAllChildrenWithCleanup(true)
  local containerSize = container:getContentSize()
  for i, v in ipairs(heroData._heroes or {}) do
    local heroInfo = ed.readhero.createIconByServer(v, {state = "idle"})
    local icon = heroInfo.icon
    heroInfo:showLegendEquip(false)
    container:addChild(icon)
    icon:setScale(0.6)
    icon:setPosition(ccp((i - 0.5) * 50, containerSize.height * 0.5 + 2))
  end
end

function CreviceDefendBattleResultWin:getPressInHandler()
  local function handler(x, y)
    for _, item in ipairs(self.recordUIArr or {}) do
      if ed.containsPoint(item.bg, x, y) then
        if item.btn_statics and ed.containsPoint(item.btn_statics, x, y) then
          item.btn_statics:setScale(0.78)
        end
        if item.btn_replay and ed.containsPoint(item.btn_replay, x, y) then
          item.btn_replay:setScale(0.78)
        end
        return item
      end
    end
  end
  
  return handler
end

function CreviceDefendBattleResultWin:getClickInHandler()
  local function handler(x, y, ui)
    if ui then
      if ed.containsPoint(ui.btn_statics, x, y) then
        self:onStaticsEvent(ui.index)
      elseif ed.containsPoint(ui.btn_replay, x, y) then
        self:onReplayEvent(ui.index)
      end
    end
  end
  
  return handler
end

function CreviceDefendBattleResultWin:getCancelPressInHandler()
  local function handler(x, y)
    for _, item in ipairs(self.recordUIArr or {}) do
      if item.btn_statics then
        item.btn_statics:setScale(0.6)
      end
      if item.btn_replay then
        item.btn_replay:setScale(0.6)
      end
    end
  end
  
  return handler
end

function CreviceDefendBattleResultWin:onStaticsEvent(index)
  local summary = self.summary[index]
  ed.ui.BattleStaticsWin.create({
    _hero_data = summary._hero_data
  }, "common")
end

function CreviceDefendBattleResultWin:onReplayEvent(index)
  local recordData = self.replay._records[index]
  if not recordData then
    ed.showToast(T("\230\154\130\230\151\160\229\189\149\229\131\143"))
    return
  end
  ed.CreviceDefendBattleManager:enterReplay(recordData, recordData._round)
end

function CreviceDefendBattleResultWin:addViewAnimation()
  local spineLeft = ed.createSpine("effect/eff_UI_CreviceDefend_closefire/eff_UI_CreviceDefend_closefire", 0.5)
  spineLeft:setAnimation(0, "Idle", true)
  local spineRight = ed.createSpine("effect/eff_UI_CreviceDefend_closefire/eff_UI_CreviceDefend_closefire", 0.5)
  spineRight:setAnimation(0, "Idle", true)
  spineRight:setScaleX(-1)
  local x, y = spineLeft:getPosition()
  spineLeft:setPosition(ccp(x - 20, y))
  local x_r, y_r = spineRight:getPosition()
  spineRight:setPosition(ccp(x_r + 20, y_r))
  self.ui.fcaNode:addChild(spineLeft, 1)
  self.ui.fcaNode:addChild(spineRight, 1)
end
