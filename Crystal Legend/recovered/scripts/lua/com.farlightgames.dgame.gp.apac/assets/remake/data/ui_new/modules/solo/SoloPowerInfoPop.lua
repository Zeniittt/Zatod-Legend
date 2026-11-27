local base = ed.ui.popwindow
local SoloPowerInfoPop = newclass(base.mt)
ed.ui.SoloPowerInfoPop = SoloPowerInfoPop

function SoloPowerInfoPop:initLabels()
  ed.setLabelFontName(self.ui.label_power_name, ed.fontBold)
  ed.setLabelStroke(self.ui.label_power_name, ccc3(18, 16, 16), 1)
  ed.setLabelStroke(self.ui.label_use, ccc3(18, 16, 16), 1)
end

function SoloPowerInfoPop:getPowerTipNum(power)
  for k, v in ipairs(power._effects or {}) do
    if v._cur_effect_times and v._cur_effect_times < v._max_effect_times then
      for _, condition in ipairs(v._conditions or {}) do
        return v._max_effect_times - v._cur_effect_times, condition._type
      end
    end
  end
  return 0, nil
end

function SoloPowerInfoPop:refreshUI()
  if self.autoText then
    self.autoText:removeFromParentAndCleanup(true)
    self.autoText = nil
  end
  self.ui.ImageView_601:removeAllChildrenWithCleanup(true)
  local times, type = self:getPowerTipNum(self.power)
  local fixHeight = 10
  if 0 < times and (string.find(type, "use") or string.find(type, "specify_faction")) and self.canOp then
    self.ui.btn_use_power:setVisible(true)
    if string.find(type, "specify_faction") then
      ed.setString(self.ui.label_use, T("\233\128\137\230\139\169"))
    else
      ed.setString(self.ui.label_use, T("\228\189\191\231\148\168"))
    end
    fixHeight = fixHeight + 40
  else
    self.ui.btn_use_power:setVisible(false)
  end
  local desc = ""
  for k, effect in ipairs(self.power._effects or {}) do
    for kk, record in ipairs(effect._records or {}) do
      local type = record._type
      if self.func[type] then
        desc = desc .. self.func[type](record)
      end
    end
  end
  if desc ~= "" then
    local autoText = ed.ui.autoText.new()
    autoText:initParam({
      context = desc,
      fontSize = 12,
      maxWidth = 180,
      lineSpacing = 2,
      color = ed.toccc3(16710887)
    })
    self.autoText = autoText.node
    local width, height = autoText:getCurContentSize()
    self.ui.bg:addChild(autoText.node)
    fixHeight = fixHeight + height - 5
    autoText.node:setPosition(ccp(25, fixHeight))
    self.ui.line:setVisible(true)
    fixHeight = fixHeight + 10
    self.ui.line:setPositionY(fixHeight)
  else
    self.ui.line:setVisible(false)
  end
  local tbData = ed.getDataTable("SoloPower")[self.power._id]
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = tbData.Description,
    fontSize = 13,
    lineSpacing = 2,
    maxWidth = 170,
    color = ed.toccc3(16710887)
  })
  ed.UITool.replaceUINew(self.ui, "label_power_desc", autoText.node)
  local width, height = autoText:getCurContentSize()
  fixHeight = fixHeight + height - 5
  self.ui.label_power_desc:setPositionY(fixHeight)
  local clipNode = ed.createClippingNodeOnly("UI/alpha/1080P/chesscard/treasure_2.png")
  local powerIcon = ed.createSprite(tbData.Icon)
  clipNode:addChild(powerIcon)
  self.ui.ImageView_601:addChild(clipNode)
  clipNode:setPosition(ccp(27, 27))
  fixHeight = fixHeight + 40
  self.ui.ImageView_601:setPositionY(fixHeight)
  ed.setString(self.ui.label_power_name, tbData["HeroPower Name"])
  self.ui.label_power_name:setPositionY(fixHeight)
  self.ui.bg:setContentSize(CCSizeMake(209, fixHeight + 45))
end

function SoloPowerInfoPop:initUI()
  ed.editorui(ed.uieditor.SoloPowerInfoPop, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self:refreshUI()
end

function SoloPowerInfoPop:initRecordTextFunc()
  self.func = {
    specify_faction = function(record)
      local desc = ""
      if record._int_values then
        local fData = ed.getDataTable("SoloCardTag")[record._int_values[1]]
        desc = string.format("<sprite src=%s scale=0.4>%s<br/>", fData["Tag Icon"], fData.Name)
      end
      return string.format("\233\128\137\230\139\169\230\181\129\230\180\190:%s<br/>", desc)
    end,
    income_gold = function(record)
      local num = 0
      if record._int_values then
        num = record._int_values[1]
      end
      return string.format("\231\180\175\232\174\161\233\135\145\229\184\129\230\148\182\231\155\138:%d<br/>", record._int_values[1])
    end,
    income_hp = function(record)
      local num = 0
      if record._int_values then
        num = record._int_values[1]
      end
      return string.format("\231\180\175\232\174\161\231\148\159\229\145\189\230\148\182\231\155\138:%d<br/>", record._int_values[1])
    end,
    income_faction_exp = function(record)
      local num = 0
      if record._int_values then
        num = record._int_values[1]
      end
      return string.format("\231\180\175\232\174\161\230\181\129\230\180\190\231\187\143\233\170\140:%d<br/>", record._int_values[1])
    end,
    income_card = function(record)
      local num = 0
      if record._int_values then
        num = record._int_values[1]
      end
      return string.format("\231\180\175\232\174\161\232\142\183\229\190\151\229\141\161\231\137\135:%d<br/>", record._int_values[1])
    end,
    income_damage = function(record)
      local num = 0
      if record._int_values then
        num = record._int_values[1]
      end
      return string.format("\231\180\175\232\174\161\229\162\158\229\138\160\228\188\164\229\174\179:%d<br/>", record._int_values[1])
    end,
    income_free_refresh = function(record)
      local num = 0
      if record._int_values then
        num = record._int_values[1]
      end
      return string.format("\231\180\175\232\174\161\229\133\141\232\180\185\229\136\183\230\150\176\230\172\161\230\149\176:%d<br/>", record._int_values[1])
    end,
    income_free_buy = function(record)
      local num = 0
      if record._int_values then
        num = record._int_values[1]
      end
      return string.format("\231\180\175\232\174\161\229\133\141\232\180\185\232\180\173\228\185\176\230\172\161\230\149\176:%d<br/>", record._int_values[1])
    end,
    series_faction_count = function(record)
      if not record._int_values then
        return ""
      end
      return string.format("\232\191\158\231\187\173\231\155\184\229\144\140\229\141\161\231\137\140\230\149\176:%d<br/>", record._int_values[1])
    end,
    series_same_faction = function(record)
      if not record._int_values then
        return ""
      end
      local str = T("\230\156\128\232\191\145\230\181\129\230\180\190:<br/>")
      for i = 1, #record._int_values, 2 do
        local fData = ed.getDataTable("SoloCardTag")[record._int_values[i]]
        local desc = string.format("<sprite src=%s scale=0.3>%s:%d<br/>", fData["Tag Icon"], fData.Name, record._int_values[i + 1])
        str = str .. desc
      end
      return str
    end,
    last_card_factions = function(record)
      if not record._int_values then
        return ""
      end
      local str = T("\228\184\138\230\172\161\232\142\183\229\190\151\229\141\161\231\137\140\230\181\129\230\180\190:<br/>")
      for i = 1, #record._int_values do
        local fData = ed.getDataTable("SoloCardTag")[record._int_values[i]]
        local desc = string.format("<sprite src=%s scale=0.3>%s<br/>", fData["Tag Icon"], fData.Name)
        str = str .. desc
      end
      return str
    end,
    shop_refresh_times = function(record)
      if not record._int_values then
        return ""
      end
      return string.format("\231\180\175\232\174\161\229\136\183\230\150\176\230\172\161\230\149\176:%d<br/>", record._int_values[1])
    end,
    after_rounds = function(record)
      if not record._int_values then
        return ""
      end
      return string.format("\229\137\169\228\189\153\229\155\158\229\144\136\230\149\176:%d<br/>", record._int_values[1])
    end,
    income_deposit = function(record)
      if not record._int_values then
        return ""
      end
      return string.format("\229\183\178\229\173\152\229\133\165\229\173\152\230\172\190:%d<br/>", record._int_values[1])
    end,
    income_interest = function(record)
      if not record._int_values then
        return ""
      end
      return string.format("\229\183\178\232\142\183\229\190\151\229\136\169\230\129\175:%d<br/>", record._int_values[1])
    end
  }
end

function SoloPowerInfoPop:registerEvents()
  self:listenEvent("EventCloseOtherWin", function()
    base.destroy(self, {skipAnim = true})
  end)
  self:btRegisterOutClick({
    area = self.ui.bg,
    clickHandler = function()
      base.destroy(self, {skipAnim = true})
    end,
    priority = -1
  })
  ed.UITool.registerBtn(self, "btn_use_power", function()
    if ed.SoloManager:getStage() ~= ed.SoloManager.GAMESTAGE.PREPARE then
      ed.showToast(T("\229\189\147\229\137\141\233\152\182\230\174\181\228\184\141\232\131\189\228\189\191\231\148\168"))
      return
    end
    local times, type = self:getPowerTipNum(self.power)
    if type == "use" then
      ed.SoloNetwork:sendUseHeroPower(self.power._id, self.power._pos)
    elseif type == "specify_faction" then
      local win = ed.ui.SoloChooseFactionWin.create({
        power = self.power
      })
      win:popWindow()
      ed.layout.relateLayout(self.ui.bg, win.ui.bg, {right = 100})
    end
  end)
  self:listenEvent("SkillUpdateSelfPower", function(power)
    if power._pos ~= self.power._pos then
      return
    end
    self.power = power
    self:refreshUI()
  end)
end

function SoloPowerInfoPop:destroy()
  base.destroy(self, {skipAnim = true})
end

function SoloPowerInfoPop:initData(params)
  self.power = params.power
  self.canOp = params.canOp
  self:initRecordTextFunc()
  self.destroyCallback = params.destroyHandler
end

function SoloPowerInfoPop.create(params)
  local self = base.create("SoloPowerInfoPop", {
    notBlurBg = true,
    noShade = true,
    priority = -999,
    swallow = true
  })
  setmetatable(self, SoloPowerInfoPop.mt)
  self:initData(params)
  self:initUI()
  self:registerEvents()
  return self
end
