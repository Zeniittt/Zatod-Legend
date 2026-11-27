local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.SoloRecordWin = class

function class:initRecordTextFunc()
  local function getTagStr(tagId)
    local tagTb = ed.getDataTable("SoloCardTag")[tagId]
    
    if tagTb then
      return string.format(T("<sprite src=%s scale=0.3><lable color=card>%s</lable>"), tagTb["Tag Icon"], tagTb.Name)
    end
    return ""
  end
  
  local function getCardStr(cardId)
    local cardTb = ed.getDataTable("SoloCardSkill")[cardId]
    if cardTb.Tag2 and cardTb.Tag2 ~= 0 then
      return string.format(T("<lable color=solocard%d>%s</lable> %s %s"), cardTb.Quality, cardTb.Name, getTagStr(cardTb.Tag1), getTagStr(cardTb.Tag2))
    end
    return string.format(T("<lable color=solocard%d>%s</lable> %s"), cardTb.Quality, cardTb.Name, getTagStr(cardTb.Tag1))
  end
  
  self.func = {
    ChooseHero = function(params)
      local heroId = params._hero_id
      local heroName = ed.lookupDataTable("SoloUnit", "Display Name", heroId)
      local str = string.format(T("\233\128\137\230\139\169\232\139\177\233\155\132\227\128\144<lable color=card>%s</lable>\227\128\145"), heroName)
      return str
    end,
    ChoosePower = function(params)
      local powerId = params._power_id
      local powerName = ed.getDataTable("SoloPower")[powerId]["HeroPower Name"]
      local str = string.format(T("\233\128\137\230\139\169\228\186\134\227\128\144<lable color=power>%s</lable>\227\128\145"), powerName)
      return str
    end,
    PowerUpdateHP = function(params)
      local powerId = params._power_id
      local hpChange = params._hp
      local tip = 0 < hpChange and T("\229\162\158\229\138\160") or T("\229\164\177\229\142\187")
      local powerName = ed.getDataTable("SoloPower")[powerId]["HeroPower Name"]
      local str = string.format(T("\227\128\144<lable color=power>%s</lable>\227\128\145 %s%d\231\130\185\231\148\159\229\145\189"), powerName, tip, math.abs(hpChange))
      return str
    end,
    PowerUpdateGold = function(params)
      local powerId = params._power_id
      local hpChange = params._gold
      local tip = 0 < hpChange and T("\229\162\158\229\138\160") or T("\229\164\177\229\142\187")
      local powerName = ed.getDataTable("SoloPower")[powerId]["HeroPower Name"]
      local str = string.format(T("\227\128\144<lable color=power>%s</lable>\227\128\145 %s%d\230\158\154\233\135\145\229\184\129"), powerName, tip, math.abs(hpChange))
      return str
    end,
    RoundAcc = function(params)
      local tip = params._gold_victory > 0 and T("\232\131\156\229\136\169") or T("\232\180\165\232\161\165")
      local value = params._gold_victory > 0 and params._gold_victory or params._gold_defeat
      return string.format(T("\230\156\172\232\189\174\232\142\183\229\190\151\230\148\182\229\133\165\239\188\154\227\128\144\229\159\186\231\161\128\227\128\145%d\239\188\140\227\128\144%s\227\128\145%d\239\188\140\227\128\144\229\136\169\230\129\175\227\128\145%d"), params._gold_base, tip, value, params._gold_inst)
    end,
    BattleInfo = function(params)
      local tip = params._battle_result == "victory" and T("\232\131\156\229\136\169") or T("\229\164\177\232\180\165")
      return string.format(T("\229\175\185\230\136\152\227\128\144<lable color=int>%s</lable>\227\128\145\227\128\144<lable color=card>%s</lable>\227\128\145"), params._oppo_user._user_summary._name, tip)
    end,
    BuyCard = function(params)
      if params._type == "normal" then
        return string.format(T("\232\180\173\228\185\176\239\188\154%s"), getCardStr(params._card._cid))
      elseif params._type == "random" then
        return string.format(T("\233\154\143\230\156\186\232\180\173\228\185\176\239\188\154%s"), getCardStr(params._card._cid))
      elseif params._type == "power" then
        local name = ed.getDataTable("SoloPower")[params._power_id]["HeroPower Name"]
        return string.format(T("\227\128\144<lable color=power>%s</lable>\227\128\145\232\180\173\228\185\176\239\188\154\232\142\183\229\190\151 %s"), name, getCardStr(params._card._cid))
      end
    end,
    PowerCard = function(params)
      local name = ed.getDataTable("SoloPower")[params._power_id]["HeroPower Name"]
      return string.format(T("\227\128\144<lable color=power>%s</lable>\227\128\145\232\167\166\229\143\145\239\188\154\232\142\183\229\190\151 %s"), name, getCardStr(params._cid))
    end,
    PowerFactionExp = function(params)
      local factionId = params._faction_id
      local exp = params._exp
      local factionName = ed.getDataTable("SoloCardTag")[factionId].Name
      return string.format(T("\227\128\144<lable color=power>%s</lable>\227\128\145\232\167\166\229\143\145\239\188\154%s\232\142\183\229\190\151 %d\231\130\185\231\187\143\233\170\140"), factionName, getTagStr(factionId), exp)
    end
  }
end

function class:initData()
  self.maxRound = ed.SoloModel:getBattleRound()
  self.curRound = self.maxRound
  self:initRecordTextFunc()
end

function class:refreshPage()
  self.draglist:clearList()
  local container, ui = ed.editorui(ed.uieditor.SkillRecordRoundItem)
  ed.setLabelStroke(ui.label_round, ed.toccc3(1315346), 1)
  ed.setString(ui.label_round, string.format(T("\231\172\172\227\128\144%d\227\128\145\229\155\158\229\144\136"), self.curRound))
  container:setPosition(ccp(192.5, 372))
  local log = ed.SoloModel:getLogByRound(self.curRound)
  if not log then
    return
  end
  local autoContent = ""
  for k, v in ipairs(log[1]) do
    local str
    if v._choose_hero then
      str = self.func.ChooseHero(v._choose_hero)
    elseif v._round_start then
      local roundStart = v._round_start
      if roundStart._income then
        str = self.func.RoundAcc(roundStart._income)
      end
    elseif v._choose_power then
      str = self.func.ChoosePower(v._choose_power)
    elseif v._battle then
      str = self.func.BattleInfo(v._battle)
    elseif v._effect then
      local effect = v._effect._effect
      if effect._mod_hp then
        str = self.func.PowerUpdateHP({
          _hp = effect._mod_hp._mod_hp,
          _power_id = effect._power._id
        })
      elseif effect._gain_hero then
      elseif effect._gain_gold then
        str = self.func.PowerUpdateGold({
          _gold = effect._gain_gold._gold,
          _power_id = effect._power._id
        })
      elseif effect._user_shop then
      elseif effect._gain_cards then
        str = self.func.PowerCard({
          _cid = effect._gain_cards._cards[1]._cid,
          _power_id = effect._power._id
        })
      elseif effect._gain_faction_exp then
        str = self.func.PowerFactionExp({
          _faction_id = effect._gain_faction_exp._faction,
          _power_id = effect._power._id,
          _exp = effect._gain_faction_exp._exp
        })
      elseif effect._cost_gold then
        str = self.func.PowerUpdateGold({
          _gold = effect._cost_gold._gold * -1,
          _power_id = effect._power._id
        })
      elseif effect._new_power then
      elseif effect._user_damage then
      end
    elseif v._buy_card then
      str = self.func.BuyCard(v._buy_card)
    end
    if str then
      autoContent = autoContent .. str .. "<br/>"
    end
  end
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = autoContent,
    fontSize = 13,
    color = ed.toccc3(4600613)
  })
  local startY = -50
  local startX = -178
  autoText.node:setPosition(ccp(startX, startY))
  ui.bg:addChild(autoText.node)
  local w, h = autoText:getCurContentSize()
  ui.stage_battle:setPositionY(startY - h)
  startY = startY - h - 24
  local autoContent = ""
  for k, v in ipairs(log[2]) do
    local str
    if v._choose_hero then
      str = self.func.ChooseHero(v._choose_hero)
    elseif v._round_start then
    elseif v._choose_power then
      str = self.func.ChoosePower(v._choose_power)
    elseif v._battle then
      str = self.func.BattleInfo(v._battle)
    elseif v._effect then
      local effect = v._effect._effect
      if effect._mod_hp then
        str = self.func.PowerUpdateHP({
          _hp = effect._mod_hp._mod_hp,
          _power_id = effect._power._id
        })
      elseif effect._gain_hero then
      elseif effect._gain_gold then
        str = self.func.PowerUpdateGold({
          _gold = effect._gain_gold._gold,
          _power_id = effect._power._id
        })
      elseif effect._user_shop then
      elseif effect._gain_cards then
        str = self.func.PowerCard({
          _cid = effect._gain_cards._cards[1]._cid,
          _power_id = effect._power._id
        })
      elseif effect._gain_faction_exp then
        str = self.func.PowerFactionExp({
          _faction_id = effect._gain_faction_exp._faction_id,
          _power_id = effect._power._id,
          _exp = effect._gain_faction_exp._exp
        })
      elseif effect._cost_gold then
        str = self.func.PowerUpdateGold({
          _gold = effect._gain_gold._gold * -1,
          _power_id = effect._power._id
        })
      elseif effect._new_power then
      elseif effect._user_damage then
      end
    elseif v._buy_card then
      str = self.func.BuyCard(v._buy_card)
    end
    if str then
      autoContent = autoContent .. str .. "<br/>"
    end
  end
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = autoContent,
    fontSize = 13,
    color = ed.toccc3(4600613)
  })
  autoText.node:setPosition(ccp(startX, startY))
  ui.bg:addChild(autoText.node)
  local w, h = autoText:getCurContentSize()
  local total = h - startY
  self.draglist:initListHeight(total)
  self.draglist:addItem(container)
end

function class:initLabels()
end

function class:initUI()
  ed.editorui(ed.uieditor.SoloRecordWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {})
  ed.setString(self.ui.Label_3048, string.format(T("\231\172\172%d/%d\233\161\181"), self.curRound, self.maxRound))
  self.ui.arrow_left:setVisible(self.curRound ~= 1)
  self.ui.arrow_right:setVisible(self.curRound ~= self.maxRound)
  local mr = CCMoveBy:create(0.6, ccp(-20, 0))
  local ml = CCMoveBy:create(0.6, ccp(20, 0))
  local action = CCRepeatForever:create(CCSequence:createWithTwoActions(mr, ml))
  self.ui.arrow_left:runAction(action)
  local mr = CCMoveBy:create(0.6, ccp(20, 0))
  local ml = CCMoveBy:create(0.6, ccp(-20, 0))
  local action = CCRepeatForever:create(CCSequence:createWithTwoActions(mr, ml))
  self.ui.arrow_right:runAction(action)
end

function class:registerEvents()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "btn_destroy",
    clickHandler = function()
      base.destroy(self, {skipAnim = true})
    end,
    priority = 1
  })
  ed.UITool.registerBtn(self, "arrow_left", function()
    if self.curRound > 1 then
      self.curRound = self.curRound - 1
      self.ui.arrow_left:setVisible(self.curRound ~= 1)
      self.ui.arrow_right:setVisible(self.curRound ~= self.maxRound)
      self:refreshPage()
      ed.setString(self.ui.Label_3048, string.format(T("\231\172\172%d/%d\233\161\181"), self.curRound, self.maxRound))
    end
  end)
  ed.UITool.registerBtn(self, "arrow_right", function()
    if self.curRound < self.maxRound then
      self.curRound = self.curRound + 1
      self.ui.arrow_left:setVisible(self.curRound ~= 1)
      self.ui.arrow_right:setVisible(self.curRound ~= self.maxRound)
      self:refreshPage()
      ed.setString(self.ui.Label_3048, string.format(T("\231\172\172%d/%d\233\161\181"), self.curRound, self.maxRound))
    end
  end)
  self:listenEvent("EventCloseOtherWin", function()
    base.destroy(self, {skipAnim = true})
  end)
  self:listenEvent("SoloViewJournal", function()
    self:refreshPage()
  end)
end

function class.create()
  local self = base.create("SoloRecordWin", {
    notBlurBg = true,
    swallow = true,
    layer_opacity = 190
  })
  setmetatable(self, class.mt)
  self:initData()
  self:initUI()
  self:registerEvents()
  self:popWindow()
  self:show()
  return self
end
