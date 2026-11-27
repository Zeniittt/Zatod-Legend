local base = ed.ui.popwindow
local KingsRecordDetail1Win = newclass(base.mt)
ed.ui.KingsRecordDetail1Win = KingsRecordDetail1Win

function KingsRecordDetail1Win.create(param)
  local self = base.create("KingsRecordDetail1Win", {noShade = true})
  setmetatable(self, KingsRecordDetail1Win.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  return self
end

function KingsRecordDetail1Win:initData(param)
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

function KingsRecordDetail1Win:initLabels()
  ed.setLabelStroke(self.ui.left_result, ed.toccc3(13458726), 1.5)
  ed.setLabelStroke(self.ui.right_result, ed.toccc3(6574746), 1.5)
  ed.setLabelStroke(self.ui.score, ed.toccc3(4136200), 1.5)
  ed.setLabelStroke(self.ui.label_result, ed.toccc3(13458726), 1.5)
  self.ui.left_result:setFontName(ed.fontBold)
  self.ui.right_result:setFontName(ed.fontBold)
  self.ui.label_result:setFontName(ed.fontBold)
end

function KingsRecordDetail1Win:initUI()
  ed.editorui(ed.uieditor.KingsRecordDetail1Win, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  ed.setString(self.ui.left_name, self.hostSummary._name)
  ed.setString(self.ui.right_name, self.guestSummary._name)
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
  local data = self.param.replays[1]
  local isWin = data._result == "victory" and self.isHost or data._result ~= "victory" and not self.isHost
  for i, oppoHero in ipairs(data._self_heroes) do
    local heroIcon = self.createHeroIcon(oppoHero)
    self.ui.bg_item:addChild(heroIcon)
    heroIcon:setPosition(ccp(324 - i * 41, 30))
  end
  for i, selfHero in ipairs(data._oppo_heroes) do
    local heroIcon = self.createHeroIcon(selfHero)
    self.ui.bg_item:addChild(heroIcon)
    heroIcon:setPosition(ccp(360 + i * 41, 30))
  end
  local selfBanHeroes = self.param.selfBan[1] or {}
  for i, heroId in ipairs(selfBanHeroes._hero_id or {}) do
    local heroIcon = self.createBanIcon(heroId)
    self.ui.bg_item:addChild(heroIcon)
    heroIcon:setPosition(ccp(324 - i * 35, 65))
  end
  local oppoBanHeroes = self.param.oppoBan[1] or {}
  for i, heroId in ipairs(oppoBanHeroes._hero_id or {}) do
    local heroIcon = self.createBanIcon(heroId)
    self.ui.bg_item:addChild(heroIcon)
    heroIcon:setPosition(ccp(360 + i * 35, 65))
  end
  local leftScore = 0
  local rightScore = 0
  if data._result == "victory" then
    leftScore = leftScore + 1
    ed.setLabelString(self.ui.left_result, T("\232\131\156"))
    ed.setLabelColor(self.ui.left_result, ed.toccc3(16769933))
    ed.setLabelStroke(self.ui.left_result, ed.toccc3(13458726), 1.5)
    ed.setLabelString(self.ui.right_result, T("\232\180\165"))
    ed.setLabelColor(self.ui.right_result, ed.toccc3(11842501))
    ed.setLabelStroke(self.ui.right_result, ed.toccc3(6574746), 1.5)
  else
    rightScore = rightScore + 1
    ed.setLabelString(self.ui.left_result, T("\232\180\165"))
    ed.setLabelColor(self.ui.left_result, ed.toccc3(11842501))
    ed.setLabelStroke(self.ui.left_result, ed.toccc3(6574746), 1.5)
    ed.setLabelString(self.ui.right_result, T("\232\131\156"))
    ed.setLabelColor(self.ui.right_result, ed.toccc3(16769933))
    ed.setLabelStroke(self.ui.right_result, ed.toccc3(13458726), 1.5)
  end
  if isWin then
    ed.setLabelString(self.ui.label_result, T("\232\131\156"))
    ed.setLabelColor(self.ui.label_result, ed.toccc3(16769933))
    ed.setLabelStroke(self.ui.label_result, ed.toccc3(13458726), 1.5)
    ed.setTexture(self.ui.bg_result, "UI/alpha/1080P/newkingspvp/battlerecord/battle_record_win_1.png", true)
  else
    ed.setLabelString(self.ui.label_result, T("\232\180\165"))
    ed.setLabelColor(self.ui.label_result, ed.toccc3(11842501))
    ed.setLabelStroke(self.ui.label_result, ed.toccc3(6574746), 1.5)
    ed.setTexture(self.ui.bg_result, "UI/alpha/1080P/newkingspvp/battlerecord/battle_record_lose_1.png", true)
  end
  ed.setString(self.ui.score, string.format("%d:%d", leftScore, rightScore))
end

function KingsRecordDetail1Win.createHeroIcon(hero)
  local heroIcon = ed.readhero.createIconByServer(hero)
  heroIcon.icon:setScale(0.5)
  return heroIcon.icon
end

function KingsRecordDetail1Win.createBanIcon(heroId)
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

function KingsRecordDetail1Win:enterReplay(record_data, round_index)
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

function KingsRecordDetail1Win:registerEvents()
end

function KingsRecordDetail1Win:onClickBtnReplay(index)
  local record_data = ed.realarena.replay_detail_data.replays[index]
  if not record_data then
    ed.showToast(T("\230\154\130\230\151\160\230\136\152\230\150\151\232\174\176\229\189\149"))
    return
  end
  self:enterReplay(record_data, index)
end

function KingsRecordDetail1Win:onClickBtnData(index)
  local summary = self.param.summarys[index]
  if not summary then
    ed.showToast(T("\230\154\130\230\151\160\230\136\152\230\150\151\230\149\176\230\141\174"))
    return
  end
  ed.ui.BattleStaticsWin.create(summary, "common")
end

function KingsRecordDetail1Win:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = true})
    end,
    clickInterval = 0.5
  })
  ed.UITool.registerBtn(self, "btn_statics", function()
    self:onClickBtnData(1)
  end, {pressScale = 0.5, normalScale = 0.55})
  ed.UITool.registerBtn(self, "btn_replay", function()
    self:onClickBtnReplay(1)
  end, {pressScale = 0.5, normalScale = 0.55})
end
