local base = ed.ui.popwindow
local pvpBattleFailedWin = {}
pvpBattleFailedWin.__index = pvpBattleFailedWin
setmetatable(pvpBattleFailedWin, base.mt)
ed.ui.pvpBattleFailedWin = pvpBattleFailedWin
local pvpBattleFailedWinScope = {}

function pvpBattleFailedWin.create(params)
  local self = base.create("pvpBattleFailedWin")
  setmetatable(self, pvpBattleFailedWin)
  self:initData(params)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function pvpBattleFailedWin:initData(params)
  self.param = params
end

function pvpBattleFailedWin:canAddFailGuidleTable(type, prob)
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
      handler = rh.canHeroWearEquip
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
    Rent = {
      res = "UI/alpha/1080P/battleresult/fail_employ_min.png",
      title = T("\228\189\163\229\133\181\231\167\159\232\181\129"),
      desc = T("\229\138\160\229\133\165\229\133\172\228\188\154\239\188\140\228\189\160\229\143\175\228\187\165\231\167\159\232\181\129\229\183\165\228\188\154\228\184\173\229\133\182\228\187\150\231\142\169\229\174\182\231\154\132\229\188\186\229\138\155\232\139\177\233\155\132\229\138\169\233\152\181\227\128\130"),
      handler = function()
        return true
      end
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

function pvpBattleFailedWin:screenPrompt()
  local pl = {}
  local ChapterID = (ed.getDataTable(ed.ui.stageaccount.stageCsvName)[self.param.stage_id] or {})["Chapter ID"]
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
    if rand <= range and #pl < 4 then
      table.insert(pl, v.config)
    end
  end
  return pl
end

function pvpBattleFailedWin:initUI()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.pvpBattleFailedWin)
  self.draglist = ed.UITool.createDraglist(self.ui.layer_reward, {priority = -300})
  local configList = self:screenPrompt()
  local gap = 395 / ed.display.scaleFactor
  for i = 1, #configList do
    local config = configList[i]
    if config then
      self.ui["tip_pic" .. i]:setVisible(false)
      local item = self:createFailGuideItem(config)
      self.ui.bg:addChild(item)
      item:setPosition(gap * (i - 1), 0)
    end
  end
  ed.setLabelStroke(self.ui.label_tip, ccc3(57, 36, 21), 1)
  ed.setLabelStroke(self.ui.label_reward, ccc3(0, 0, 0), 1)
  ed.setLabelShadow(self.ui.label_back, ccc3(0, 0, 0), ccp(0, 2))
  self:refreshDraglist()
end

function pvpBattleFailedWin:createFailGuideItem(config)
  local container, ui = ed.editorui(ed.uieditor.failGuideItem)
  container:setContentSize(ui.image_bg:getContentSize())
  ui.image_bg:setAnchorPoint(ccp(0, 0))
  ed.setLabelString(ui.label_title, config.title or "")
  ed.setTexture(ui.image_detail, config.res)
  ed.setLabelString(ui.label_desc, config.desc)
  ed.setLabelDimensions(ui.label_desc, CCSizeMake(158, 0))
  return container
end

function pvpBattleFailedWin:refreshDraglist()
  local uiList = {}
  self.draglist.listLayer:removeAllChildrenWithCleanup(true)
  local oy = self.ui.layer_reward:getContentSize().height / 2
  local ox = 0
  local dx = 82
  
  local function getPos(i)
    return ccp(ox + dx * i - dx / 2, oy)
  end
  
  self.rewards = self.param.bestRankReward._rewards or {}
  local array = CCArray:create()
  array:addObject(CCDelayTime:create(0.5))
  for k, v in ipairs(self.rewards) do
    local f = CCCallFunc:create(function()
      local item = {
        type = v._type,
        amount = v._amount
      }
      local icon = ed.createItemIcon(item)
      icon.data = v
      table.insert(uiList, icon)
      icon:setPosition(getPos(k))
      self.draglist:addItem(icon)
    end)
    array:addObject(f)
    array:addObject(CCDelayTime:create(0.5))
  end
  local sequence = CCSequence:create(array)
  self.ui.bg:runAction(sequence)
  self.uiList = uiList
  self.draglist:initListWidth(#self.rewards * dx)
end

function pvpBattleFailedWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    base.destroy(self)
    ed.popScene()
  end, {pressScale = 0.9})
end
