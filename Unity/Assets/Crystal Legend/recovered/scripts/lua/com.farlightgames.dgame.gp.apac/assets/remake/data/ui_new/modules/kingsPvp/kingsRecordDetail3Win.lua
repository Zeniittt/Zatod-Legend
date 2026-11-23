local base = ed.ui.popwindow
local KingsRecordDetail3Win = newclass(base.mt)
ed.ui.KingsRecordDetail3Win = KingsRecordDetail3Win

function KingsRecordDetail3Win.create(param)
  local self = base.create("KingsRecordDetail3Win", {noShade = true})
  setmetatable(self, KingsRecordDetail3Win.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  return self
end

function KingsRecordDetail3Win:initData(param)
  param = param or {}
  self.param = param
  self.isHost = param.isHost
  self.isAudience = param.isAudience
  if self.isAudience then
    self.isHost = true
  end
  local replay = param.replays[1]
  self.hostSummary = {
    _avatar = replay._avatar,
    _name = replay._username,
    _level = replay._level,
    _medal = replay._self_medal
  }
  self.guestSummary = {
    _avatar = replay._oppo_avatar,
    _name = replay._oppo_name,
    _level = replay._oppo_level,
    _medal = replay._oppo_medal
  }
end

function KingsRecordDetail3Win:initLabels()
  ed.setLabelStroke(self.ui.score, ed.toccc3(4136200), 1.5)
  self.ui.left_result:setFontName(ed.fontBold)
  self.ui.right_result:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.left_name, ed.toccc3(2954765), 1)
  ed.setLabelStroke(self.ui.right_name, ed.toccc3(2954765), 1)
end

function KingsRecordDetail3Win:createBattleItems()
  local leftScore = 0
  local rightScore = 0
  for i = 1, 3 do
    local container, ui = ed.editorui(ed.uieditor.KingsRecordBattleItem)
    local data = self.param.replays[i]
    if not data then
      break
    end
    local isWin = data._result == "victory" and self.isHost or data._result ~= "victory" and not self.isHost
    ed.setLabelString(ui.Label_971, i)
    ed.setLabelFontName(ui.Label_971, ed.fontBold)
    if data._result == "victory" then
      leftScore = leftScore + 1
    else
      rightScore = rightScore + 1
    end
    if isWin then
      ed.setLabelString(ui.label_result, T("\232\131\156"))
      ed.setLabelColor(ui.label_result, ed.toccc3(16769933))
      ed.setLabelStroke(ui.label_result, ed.toccc3(13458726), 1.5)
      ed.setLabelFontName(ui.label_result, ed.fontBold)
      ed.setTexture(ui.bg_result, "UI/alpha/1080P/newkingspvp/battlerecord/battle_record_win_1.png", true)
    else
      ed.setLabelString(ui.label_result, T("\232\180\165"))
      ed.setLabelColor(ui.label_result, ed.toccc3(11842501))
      ed.setLabelStroke(ui.label_result, ed.toccc3(6574746), 1.5)
      ed.setLabelFontName(ui.label_result, ed.fontBold)
      ed.setTexture(ui.bg_result, "UI/alpha/1080P/newkingspvp/battlerecord/battle_record_lose_1.png", true)
    end
    for index, selfHero in ipairs(data._self_heroes) do
      local heroIcon = self.createHeroIcon(selfHero)
      ui.bg:addChild(heroIcon)
      heroIcon:setPosition(ccp(336 - index * 41, 30))
    end
    for index, oppoHero in ipairs(data._oppo_heroes) do
      local heroIcon = self.createHeroIcon(oppoHero)
      ui.bg:addChild(heroIcon)
      heroIcon:setPosition(ccp(364 + index * 41, 30))
    end
    local selfBanHeroes = self.param.selfBan[i] or {}
    for index, heroId in ipairs(selfBanHeroes._hero_id or {}) do
      local heroIcon = self.createBanIcon(heroId)
      ui.bg:addChild(heroIcon)
      heroIcon:setPosition(ccp(336 - index * 35, 65))
    end
    local oppoBanHeroes = self.param.oppoBan[i] or {}
    for index, heroId in ipairs(oppoBanHeroes._hero_id or {}) do
      local heroIcon = self.createBanIcon(heroId)
      ui.bg:addChild(heroIcon)
      heroIcon:setPosition(ccp(364 + index * 35, 65))
    end
    self:btRegisterButtonClick({
      button = ui.btn_statics,
      key = "btn_statics" .. i,
      clickHandler = function()
        self:onClickBtnData(i)
      end,
      clickInterval = 0.5
    })
    self:btRegisterButtonClick({
      button = ui.btn_replay,
      key = "btn_replay" .. i,
      clickHandler = function()
        self:onClickBtnReplay(i)
      end,
      clickInterval = 0.5
    })
    container:setPosition(ccp(605, 340 - 90 * i))
    self.ui.bg:addChild(container)
  end
  ed.setString(self.ui.score, string.format("%d:%d", leftScore, rightScore))
  if leftScore > rightScore then
    ed.setLabelString(self.ui.left_result, T("\232\131\156"))
    ed.setLabelColor(self.ui.left_result, ed.toccc3(16769933))
    ed.setLabelStroke(self.ui.left_result, ed.toccc3(13458726), 1.5)
    ed.setLabelString(self.ui.right_result, T("\232\180\165"))
    ed.setLabelColor(self.ui.right_result, ed.toccc3(13158368))
    ed.setLabelStroke(self.ui.right_result, ed.toccc3(6574746), 1.5)
    ed.setLabelColor(self.ui.left_name, ed.toccc3(9236841))
    ed.setLabelColor(self.ui.right_name, ed.toccc3(16214120))
  else
    ed.setLabelString(self.ui.left_result, T("\232\180\165"))
    ed.setLabelColor(self.ui.left_result, ed.toccc3(13158368))
    ed.setLabelStroke(self.ui.left_result, ed.toccc3(6574746), 1.5)
    ed.setLabelString(self.ui.right_result, T("\232\131\156"))
    ed.setLabelColor(self.ui.right_result, ed.toccc3(16769933))
    ed.setLabelStroke(self.ui.right_result, ed.toccc3(13458726), 1.5)
    ed.setLabelColor(self.ui.left_name, ed.toccc3(16214120))
    ed.setLabelColor(self.ui.right_name, ed.toccc3(9236841))
  end
end

function KingsRecordDetail3Win:initUI()
  ed.editorui(ed.uieditor.KingsRecordDetail3Win, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  ed.setString(self.ui.left_name, self.hostSummary._name)
  ed.setString(self.ui.right_name, self.guestSummary._name)
  self.ui.left_name:setFontSize(18)
  self.ui.right_name:setFontSize(18)
  local rightMedal = ed.getPlayerName("", self.guestSummary._medal, {
    medalScale = 0.15,
    anchorPoint = ccp(1, 0.5)
  })
  self.ui.bg_right_name:addChild(rightMedal)
  ed.left2(rightMedal, self.ui.right_name)
  local param = {
    id = self.guestSummary._avatar,
    scale = 0.7
  }
  local head, headIcon = ed.getWholeHeadIcon(param)
  ed.UITool.replaceUINew(self.ui, "right_head", head)
  local leftMedal = ed.getPlayerName("", self.hostSummary._medal, {
    medalScale = 0.15,
    anchorPoint = ccp(1, 0.5)
  })
  self.ui.bg_left_name:addChild(leftMedal)
  ed.left2(leftMedal, self.ui.left_name)
  local param = {
    id = self.hostSummary._avatar,
    scale = 0.7
  }
  local head, headIcon = ed.getWholeHeadIcon(param)
  ed.UITool.replaceUINew(self.ui, "left_head", head)
  self:createBattleItems()
end

function KingsRecordDetail3Win.createHeroIcon(hero)
  local heroIcon = ed.readhero.createIconByServer(hero)
  heroIcon.icon:setScale(0.5)
  return heroIcon.icon
end

function KingsRecordDetail3Win.createBanIcon(heroId)
  local res = ed.getUnitPortrait(heroId)
  local head, headicon = ed.createClippingNode(res, "UI/alpha/1080P/common/main_head_mask.png", nil, CCSizeMake(0, 0))
  local frame = ed.createSprite("UI/alpha/1080P/newkingspvp/battlerecord/battle_record_ban_frame.png")
  ed.setSpriteStone(headicon)
  head:addChild(frame)
  frame:setScale(2.61)
  head:setScale(0.4)
  local icon = CCSprite:create()
  icon:addChild(head)
  local banTag = ed.createSprite("UI/alpha/1080P/newkingspvp/battlerecord/battle_record_ban.png")
  banTag:setPosition(10, -10)
  icon:addChild(banTag, 1)
  return icon
end

function KingsRecordDetail3Win:enterReplay(record_data, round_index)
  if not record_data then
    return
  end
  local mode = "real_pvp"
  local stageid = ed.realarena.stage_id[round_index]
  ed.ui.vcdLayer.setData(record_data, mode, stageid)
  local stage = ed.lookupDataTable("Stage", nil, stageid)
  local battle = ed.lookupDataTable("Battle", nil, stageid, 1)
  local info = {
    userId = record_data._userid,
    userName = record_data._username,
    userAvatar = record_data._avatar,
    vip = record_data._vip,
    oppoUserid = record_data._oppo_userid,
    oppoUserName = record_data._oppo_name,
    oppoUserAvatar = record_data._oppo_avatar,
    oppovip = record_data._oppo_vip,
    checkid = record_data._checkid
  }
  ed.srand(record_data._rseed)
  ed.engine:enterRelay({
    hero_list = record_data._self_heroes,
    hero_is_bot = 0 < (record_data._self_robot or 0),
    enemy_list = record_data._oppo_heroes,
    enemy_is_bot = 0 < (record_data._oppo_robot or 0),
    stage_id = stageid,
    operations = record_data._operations,
    right_operations = record_data._oppo_operations,
    mode = mode,
    selfBonus = record_data._self_bonus or nil,
    oppoBonus = record_data._oppo_bonus or nil
  })
  ed.scene:reset(stage, battle, {replayInfo = info})
  ed.pushScene(ed.scene)
end

function KingsRecordDetail3Win:onClickBtnData(index)
  local summary = self.param.summarys[index]
  if not summary then
    ed.showToast(T("\230\154\130\230\151\160\230\136\152\230\150\151\230\149\176\230\141\174"))
    return
  end
  ed.ui.BattleStaticsWin.create(summary, "common")
end

function KingsRecordDetail3Win:onClickBtnReplay(index)
  local record_data = ed.realarena.replay_detail_data.replays[index]
  if not record_data then
    ed.showToast(T("\230\154\130\230\151\160\230\136\152\230\150\151\232\174\176\229\189\149"))
    return
  end
  self:enterReplay(record_data, index)
end

function KingsRecordDetail3Win:registerEvents()
end

function KingsRecordDetail3Win:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = true})
    end,
    clickInterval = 0.5
  })
end
