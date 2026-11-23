local base = ed.ui.popwindow
local commonBattleFail = {}
commonBattleFail.__index = commonBattleFail
setmetatable(commonBattleFail, base.mt)
ed.ui.commonBattleFail = commonBattleFail
local commonBattleFailScope = {}
local lsr = ed.ui.stagefailedlsr.create()

function commonBattleFail.create(param)
  local self = base.create("commonBattleFail")
  setmetatable(self, commonBattleFail)
  self:initData(param)
  self:initUI()
  self:initTimer()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function commonBattleFail:initData(param)
  self.param = param
  local list = param.heroes
  self.heroes = {}
  for k, v in pairs(list or {}) do
    table.insert(self.heroes, ed.player:getHero(v))
  end
  self.lootui = {}
  self.loot_x = 0
end

function commonBattleFail:initUI()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.commonBattleFail)
  local res = ed.ui.stageaccount.getLoseTitleRes(self.param.loseType)
  local sprite = ed.createSprite(res or "")
  sprite:setPosition(ccp(self.ui.bg:getContentSize().width / 2, self.ui.bg:getContentSize().height + 38 + 17 / ed.display.scaleFactor))
  if not res then
    if ed.isAreaZhCn() then
      sprite = ed.createFcaNode("eff_UI_battleresult_fail")
      self:addFca(sprite)
    else
      sprite = ed.createSprite("UI/alpha/1080P/battleresult/battleresult_fail.png")
    end
    sprite:setPosition(ccp(self.ui.bg:getContentSize().width / 2, self.ui.bg:getContentSize().height + 38 + 17 / ed.display.scaleFactor))
    self.ui.title = sprite
    self.ui.bg:addChild(sprite)
    sprite = ed.createFcaNode("eff_UI_pve_fail_wings")
    self:addFca(sprite)
    sprite:setPosition(ccp(self.ui.bg:getContentSize().width / 2, self.ui.bg:getContentSize().height + 38 + 17 / ed.display.scaleFactor))
    self.ui.bg:addChild(sprite, -1)
  end
  self.ui.title = sprite
  self.ui.bg:addChild(sprite)
  self.ui.btn_again:setVisible(false)
  self:initLabel()
  self:initPrompts()
  if self.param.bestRankReward then
    self:initLootList()
    self:createPvpReward()
  end
end

function commonBattleFail:initLabel()
  ed.setLabelStroke(self.ui.prompt_label, ccc3(ed.colorToStr("#392415")), 2)
  ed.setLabelStroke(self.ui.label_back, ccc3(ed.colorToStr("#90550f")), 1)
  ed.setLabelShadow(self.ui.label_back, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelStroke(self.ui.label_again, ccc3(ed.colorToStr("#90550f")), 1)
  ed.setLabelShadow(self.ui.label_again, ccc3(0, 0, 0), ccp(0, 2))
  self.ui.label_back:setString(T("\231\187\167\231\187\173"))
end

function commonBattleFail:initPrompts()
  local pl = self:createPrompt()
  local gap = 395 / ed.display.scaleFactor
  for i = 1, #pl do
    local config = pl[i]
    local item = self:createFailGuideItem(config)
    self.ui.promptLayer:addChild(item)
    item:setPosition(gap * (i - 1), 0)
  end
end

function commonBattleFail:createFailGuideItem(config)
  local container, ui = ed.editorui(ed.uieditor.failGuideItem)
  container:setContentSize(ui.image_bg:getContentSize())
  ui.image_bg:setAnchorPoint(ccp(0, 0))
  ed.setLabelString(ui.label_title, config.title or "")
  ui.label_title:limitWidthByScale(90)
  ed.setTexture(ui.image_detail, config.res)
  ed.setLabelString(ui.label_desc, config.desc)
  ed.setLabelDimensions(ui.label_desc, CCSizeMake(158, 0))
  return container
end

function commonBattleFail:initLootList()
  local layersize = self.ui.lootLayer:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, layersize.width, layersize.height),
    noshade = true,
    container = self.ui.lootLayer,
    zorder = 10,
    priority = -300
  }
  self.draglist = ed.draglist.create(info)
end

function commonBattleFail:createPvpReward()
  for i, v in ipairs(self.param.bestRankReward._rewards or {}) do
    self:createLootIcon(v._type, {
      type = v._type,
      amount = v._amount
    })
  end
end

function commonBattleFail:createLootIcon(key, value)
  local icon = ed.createItemIcon(value)
  icon:setAnchorPoint(ccp(0, 0))
  icon:setScale(0.88)
  icon:setPosition(ccp(self.loot_x, 0))
  self.loot_x = self.loot_x + ed.layout.getScaleSize(icon).width
  self.draglist.listLayer:addChild(icon)
  self.draglist:initListWidth(self.loot_x)
end

function commonBattleFail:createPrompt()
  local pl = {}
  local ChapterID
  if self.param.ChapterID then
    ChapterID = self.param.ChapterID
  else
    local stageCsvName = ed.ui.stageaccount.stageCsvName
    if self.param.stageCsvName then
      stageCsvName = self.param.stageCsvName
    end
    ChapterID = (ed.getDataTable(stageCsvName)[self.param.stage_id] or {})["Chapter ID"]
  end
  local data = ed.getDataTable("Failguide")[ChapterID]
  local total = 0
  local FailGuidleTable = {}
  for k, v in pairs(data or {}) do
    if k ~= "Chapter Id" then
      local config = self:canAddFailGuidleTable(k, v)
      if config then
        total = total + v
        local temp = {pro = v, config = config}
        FailGuidleTable[k] = temp
      end
    end
  end
  local rand = math.floor(math.random() * (total - 1) + 1)
  local range = 0
  for k, v in pairs(FailGuidleTable) do
    range = v.pro + range
    if rand <= range and #pl < 2 then
      table.insert(pl, v.config)
    end
  end
  return pl
end

function commonBattleFail:canAddFailGuidleTable(type, prob)
  local rh = ed.readhero
  local config = {
    HeroStars = {
      res = "UI/alpha/1080P/battleresult/fail_star_min.jpg",
      title = T("\229\141\135\230\152\159"),
      desc = T("\230\148\182\233\155\134\232\182\179\229\164\159\231\154\132\231\129\181\233\173\130\231\159\179\239\188\140\228\184\186\232\139\177\233\155\132\230\143\144\229\141\135\230\152\159\231\186\167\227\128\130"),
      handler = rh.canHeroEvolve
    },
    UnitRank = {
      res = "UI/alpha/1080P/battleresult/fail_rank_min.jpg",
      title = T("\232\191\155\233\152\182"),
      desc = T("\231\169\191\233\189\144\229\133\173\228\187\182\232\163\133\229\164\135\231\154\132\232\139\177\233\155\132\229\143\175\228\187\165\232\191\155\233\152\182\229\143\152\229\190\151\230\155\180\229\188\186\227\128\130"),
      handler = rh.canUpgradeHero
    },
    Equip = {
      res = "UI/alpha/1080P/battleresult/fail_equip_min.jpg",
      title = T("\230\155\180\230\150\176\232\163\133\229\164\135"),
      desc = T("\228\184\186\232\139\177\233\155\132\231\169\191\230\136\180\232\163\133\229\164\135\239\188\140\232\174\169\228\189\160\231\154\132\232\139\177\233\155\132\230\155\180\229\138\160\229\188\186\229\164\167"),
      handler = rh.canHeroWearEquip,
      param = self.heroes
    },
    LevelUp = {
      res = "UI/alpha/1080P/battleresult/fail_levelup_min.jpg",
      title = T("\230\143\144\229\141\135\232\139\177\233\155\132\231\173\137\231\186\167"),
      desc = T("\230\156\141\231\148\168\231\187\143\233\170\140\232\141\175\230\176\180\229\143\138\229\143\130\229\138\160\229\137\175\230\156\172\230\152\175\230\143\144\229\141\135\232\139\177\233\155\132\231\173\137\231\186\167\231\154\132\229\165\189\230\150\185\230\179\149\227\128\130"),
      handler = function()
        return true
      end
    },
    ["Skill Levelup"] = {
      res = "UI/alpha/1080P/battleresult/fail_skill_min.jpg",
      title = T("\230\138\128\232\131\189\229\141\135\231\186\167"),
      desc = T("\230\143\144\229\141\135\232\139\177\233\155\132\231\154\132\230\138\128\232\131\189\231\173\137\231\186\167\239\188\140\232\139\177\233\155\132\229\174\158\229\138\155\229\176\134\230\158\129\229\164\167\229\156\176\230\143\144\233\171\152\227\128\130"),
      handler = rh.canHeroSkillLevelup
    },
    Manipulate = {
      res = "UI/alpha/1080P/battleresult/fail_manual_min.jpg",
      title = T("\230\140\135\229\176\150\230\147\141\228\189\156"),
      desc = T("\233\128\130\230\151\182\229\156\176\233\135\138\230\148\190\232\139\177\233\155\132\231\154\132\231\156\169\230\153\149\230\178\137\233\187\152\231\173\137\229\164\167\230\139\155\239\188\140\229\143\175\228\187\165\232\174\169\228\189\160\228\186\139\229\141\138\229\138\159\229\128\141\227\128\130"),
      handler = function()
        return true
      end
    },
    ["Battle Array"] = {
      res = "UI/alpha/1080P/battleresult/fail_exchange_lineup_min.jpg",
      title = T("\232\176\131\230\149\180\233\152\181\229\174\185"),
      desc = T("\231\187\132\229\187\186\232\131\189\229\164\159\229\133\139\229\136\182\229\175\185\230\137\139\231\154\132\233\152\181\229\174\185\229\143\175\228\187\165\232\174\169\228\189\160\230\155\180\232\189\187\230\157\190\229\156\176\230\136\152\232\131\156\228\189\160\231\154\132\229\175\185\230\137\139"),
      handler = function()
        return #ed.player.heroes >= 10
      end
    },
    DungeonLevel = {
      res = "UI/alpha/1080P/battleresult/fail_dungeonlevel_min.jpg",
      title = T("\231\159\174\228\186\186\231\167\145\230\138\128\231\173\137\231\186\167"),
      desc = T("\230\143\144\229\141\135\231\159\174\228\186\186\231\167\145\230\138\128\231\173\137\231\186\167\239\188\140\228\187\165\230\143\144\233\171\152\230\137\128\230\156\137\232\139\177\233\155\132\229\156\168\229\156\176\229\186\149\229\142\134\233\153\169\228\184\173\231\154\132\229\177\158\230\128\167"),
      handler = function()
        return true
      end
    }
  }
  local data = config[type] or {}
  if data.handler and data.handler(data.param) and 0 < prob then
    return data
  end
end

function commonBattleFail:initTimer()
  if self.param.mode == "real_arena" then
    self.isReportRoundReset = false
    self:listenTimer(Timer:Once(10, "countDown"), function()
      self.isReportRoundReset = true
      FireEvent("ReportRoundReset")
    end)
  end
end

function commonBattleFail:onClickBtnBack()
  if self.param.mode == "real_arena" then
    if self.isReportRoundReset then
      base.destroy(self)
      ed.popScene()
    else
      self.isReportRoundReset = true
      FireEvent("ReportRoundReset")
      local real_arena_data = self.param.real_arena_data
      if real_arena_data and real_arena_data.next_round ~= 0 then
        ed.showToast(T("\231\173\137\229\190\133\229\175\185\230\137\139\231\161\174\232\174\164"))
      end
    end
  else
    base.destroy(self)
    ed.popScene()
    FireEvent("closeCommonBattleFail")
  end
end

function commonBattleFail:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:onClickBtnBack()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_data", function()
    lsr:report("showBattleCount")
    ed.ui.BattleStaticsWin.create(ed.engine.unit_list, self.param.isArenaMode and "pvp" or "common", true)
  end, {pressScale = 0.9})
end
