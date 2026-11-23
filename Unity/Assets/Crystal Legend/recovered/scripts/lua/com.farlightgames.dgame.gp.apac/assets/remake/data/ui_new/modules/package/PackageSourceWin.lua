local base = ed.ui.popwindow
local PackageSourceWin = {}
PackageSourceWin.__index = PackageSourceWin
setmetatable(PackageSourceWin, base.mt)
ed.ui.PackageSourceWin = PackageSourceWin
local PackageSourceWinScope = {}

local function packageGetWay(id)
  local row = ed.getDataTable("equip")[id] or {}
  local stageTable = ed.getDataTable("Stage")
  local getWay = {}
  local dropInfo = row.Drop
  for k, stageId in ipairs(dropInfo or {}) do
    local chapter = (ed.getDataTable("Stage")[stageId] or {})["Chapter ID"]
    local isElite = ed.stageType(stageId) == "elite"
    if 0 < (stageId or 0) and chapter then
      local name = stageTable[stageId]["Stage Name"]
      if isElite then
        name = string.format(T("\227\128\144\231\178\190\232\139\177\231\172\172%d\231\171\160\227\128\145%s"), chapter, name)
      else
        name = string.format(T("\227\128\144\230\153\174\233\128\154\231\172\172%d\231\171\160\227\128\145%s"), chapter, name)
      end
      local st = ed.stageType(stageId)
      local state = "Locked"
      if ed.isElementInTable(st, {"normal", "elite"}) then
        local star = ed.player:getStageStar(stageId) or 0
        local preStar = ed.player:getStageStar(stageId - 1) or 0
        if 0 < star + preStar then
          state = "Normal"
        end
        if isElite and state == "Normal" then
          local sId = ed.ui.stageselectres.getChapterStageEid(chapter, stageId)
          if sId and 0 < (ed.player:getStageStar(sId) or 0) then
            state = "Normal"
          else
            state = "Locked"
          end
        end
        local ul = ed.playerlimit.chapterJumpLevel(chapter)
        if ul and ul > ed.player:getLevel() then
          state = "Locked"
        end
      end
      if ed.ui.stageselectres.getIsLootStages(stageId) then
        if ed.ui.stageselectres.getLootStagesIsOpen(stageId) then
          state = "Normal"
        else
          state = "Locked"
        end
      end
      table.insert(getWay, {
        id = stageId,
        name = name,
        type = "stage",
        state = state
      })
    end
  end
  local howToGet = row["How To Get"]
  for k, access in ipairs(howToGet or {}) do
    local state = "Normal"
    if access == T("\229\143\172\229\148\164\230\179\149\233\152\181\232\142\183\229\143\150") then
      table.insert(getWay, {
        id = 1,
        name = "  " .. access,
        type = "summon",
        state = "Normal"
      })
    elseif access == T("\230\180\187\229\138\168\232\142\183\229\143\150") then
      table.insert(getWay, {
        id = 1,
        name = "  " .. access,
        type = "activity",
        state = "Special"
      })
    elseif access == T("\229\138\155\228\185\139\229\185\187\229\162\131\232\142\183\229\143\150") then
      state = ed.SkillTowerManager:isTowerOpen(1) and "Normal" or "Locked"
      table.insert(getWay, {
        id = 1,
        name = "  " .. access,
        type = "skillTower",
        state = state
      })
    elseif access == T("\230\149\143\228\185\139\229\185\187\229\162\131\232\142\183\229\143\150") then
      state = ed.SkillTowerManager:isTowerOpen(2) and "Normal" or "Locked"
      table.insert(getWay, {
        id = 2,
        name = "  " .. access,
        type = "skillTower",
        state = state
      })
    elseif access == T("\230\153\186\228\185\139\229\185\187\229\162\131\232\142\183\229\143\150") then
      state = ed.SkillTowerManager:isTowerOpen(3) and "Normal" or "Locked"
      table.insert(getWay, {
        id = 3,
        name = "  " .. access,
        type = "skillTower",
        state = state
      })
    elseif access == T("\231\153\190\232\180\167\229\149\134\229\186\151\232\142\183\229\143\150") then
      state = ed.shopData:getShopOpenVis(1) and "Normal" or "Locked"
      table.insert(getWay, {
        id = 1,
        name = "  " .. access,
        type = "shop",
        state = state
      })
    elseif access == T("\231\171\158\230\138\128\229\156\186\229\149\134\229\186\151\232\142\183\229\143\150") then
      state = ed.shopData:getShopOpenVis(2) and "Normal" or "Locked"
      table.insert(getWay, {
        id = 2,
        name = "  " .. access,
        type = "shop",
        state = state
      })
    elseif access == T("\232\191\156\229\190\129\229\149\134\229\186\151\232\142\183\229\143\150") then
      state = ed.shopData:getShopOpenVis(3) and "Normal" or "Locked"
      table.insert(getWay, {
        id = 3,
        name = "  " .. access,
        type = "shop",
        state = state
      })
    elseif access == T("\230\162\166\229\162\131\229\149\134\229\186\151\232\142\183\229\143\150") then
      state = ed.shopData:getShopOpenVis(4) and "Normal" or "Locked"
      table.insert(getWay, {
        id = 4,
        name = "  " .. access,
        type = "shop",
        state = state
      })
    elseif access == T("\229\133\172\228\188\154\229\149\134\229\186\151\232\142\183\229\143\150") then
      state = ed.shopData:getShopOpenVis(5) and "Normal" or "Locked"
      table.insert(getWay, {
        id = 5,
        name = "  " .. access,
        type = "shop",
        state = state
      })
    elseif access == T("\228\191\161\228\189\191\229\149\134\229\186\151\232\142\183\229\143\150") then
      state = ed.shopData:getShopOpenVis(7) and "Normal" or "Locked"
      table.insert(getWay, {
        id = 7,
        name = "  " .. access,
        type = "shop",
        state = state
      })
    elseif access == T("\232\139\177\233\155\132\229\185\187\229\162\131\232\142\183\229\143\150") then
      state = ed.playerlimit:moduleIsOpened("Exercise") and "Normal" or "Locked"
      table.insert(getWay, {
        id = 1,
        name = "  " .. access,
        type = "heroExercise",
        state = state
      })
    elseif access == T("\229\174\140\230\136\144\228\187\187\229\138\161\232\142\183\229\143\150") then
      state = "Normal"
      table.insert(getWay, {
        id = 1,
        name = "  " .. access,
        type = "task",
        state = state
      })
    elseif access == T("\232\139\177\233\155\132\232\175\149\231\130\188\232\142\183\229\143\150") then
      state = ed.playerlimit:moduleIsOpened("Exercise") and "Normal" or "Locked"
      table.insert(getWay, {
        id = 1,
        name = "  " .. access,
        type = "heroExercise",
        state = state
      })
    elseif access == T("\229\156\176\229\186\149\229\142\134\233\153\169\232\142\183\229\143\150") then
      local dropsId = ed.awakeDungeonMgr.getInstance():getDropsId() or 0
      table.insert(getWay, {
        id = 1,
        name = "  " .. access,
        type = "awakeDungeon",
        state = dropsId == id and "Normal" or "Locked"
      })
    elseif access == T("\231\165\158\231\167\152\229\149\134\229\186\151\232\142\183\229\143\150") then
      table.insert(getWay, {
        id = 1,
        name = "  " .. access,
        type = "shop",
        state = "Locked"
      })
    elseif access == T("\229\185\180\229\133\189\229\164\167\228\189\156\230\136\152\232\142\183\229\143\150") then
      local state = ed.nianMonsterMgr.getInstance():getNianMonsterIsOpen() and "Normal" or "Locked"
      table.insert(getWay, {
        id = 1,
        name = "  " .. access,
        type = "nianMonster",
        state = state
      })
    elseif access == T("\232\129\138\229\164\169\233\162\145\233\129\147\229\143\145\233\128\129\229\175\185\229\186\148\230\154\151\232\175\173\232\142\183\229\143\150") then
      table.insert(getWay, {
        id = 1,
        name = "  " .. access,
        type = "chat",
        state = "Normal"
      })
    elseif access == T("\230\150\176\229\185\180\231\173\190\229\136\176\230\180\187\229\138\168\232\142\183\229\143\150") then
      local state = "Locked"
      if ed.activityHints.data:getActivityIsOpenById(85) or ed.activityHints.data:getActivityIsOpenById(94) then
        state = "Normal"
      end
      table.insert(getWay, {
        id = 1,
        name = "  " .. access,
        type = "NewYearDaysLogin",
        state = state
      })
    elseif access == T("\229\133\145\230\141\162\231\160\129\232\142\183\229\143\150") then
      table.insert(getWay, {
        id = 1,
        name = "  " .. access,
        type = "CDKey",
        state = "Normal"
      })
    elseif access == T("\230\160\189\229\159\185\230\180\187\229\138\168\232\142\183\229\143\150") then
      local actList = ed.activityHints.data:getActivityInfoByType("grow_plan")
      local isOpen = false
      for index, actInfo in ipairs(actList) do
        if ed.activityHints.data:getActivityIsOpenById(actInfo._cfg_id) then
          isOpen = true
          break
        end
      end
      local state = isOpen and "Normal" or "Locked"
      table.insert(getWay, {
        id = 1,
        name = "  " .. access,
        type = "growPlan",
        state = state
      })
    elseif access == T("\229\149\134\229\159\142\231\164\188\229\140\133\232\142\183\229\143\150") then
      local state = ed.playerlimit:moduleIsOpened("MallGift") and "Normal" or "Locked"
      table.insert(getWay, {
        id = 2,
        name = "  " .. access,
        type = "RechargeScene",
        state = state
      })
    elseif access == T("\229\185\187\228\185\166\229\165\135\232\176\173\232\142\183\229\143\150") then
      local state = ed.playerlimit:moduleIsOpened("Rogue") and "Normal" or "Locked"
      table.insert(getWay, {
        id = 1,
        name = "  " .. access,
        type = "rogueMainScene",
        state = state
      })
    elseif access == T("\232\191\156\229\143\164\231\134\148\231\130\137\232\142\183\229\143\150") then
      local state = ed.playerlimit:moduleIsOpened("LegendEquipForge") and "Normal" or "Locked"
      table.insert(getWay, {
        id = 1,
        name = "  " .. access,
        type = "fireForgeMainScene",
        state = state
      })
    elseif access == T("\230\136\152\229\189\185\232\142\183\229\143\150(80\231\186\167\229\144\142)") then
      local state = "Normal"
      table.insert(getWay, {
        id = 1,
        name = "  " .. access,
        type = "latestStageScene",
        state = state
      })
    elseif access == T("\229\185\187\229\162\131\228\185\139\229\161\148\232\142\183\229\143\150") then
      local state = ed.SkillTowerManager:isTowerOpen() and "Normal" or "Locked"
      table.insert(getWay, {
        id = 3,
        name = "  " .. access,
        type = "skillTowerMainScene",
        state = state
      })
    elseif access == T("\231\134\148\231\130\137\229\149\134\229\186\151\232\142\183\229\143\150") then
      local state = "Normal"
      local unlockLevel = ed.playerlimit:getModuleUnlockLevel("LegendEquipForge")
      if unlockLevel > ed.player:getLevel() then
        state = "Locked"
      end
      table.insert(getWay, {
        id = 1,
        name = "  " .. access,
        type = "legendEquipShopScene",
        state = state
      })
    elseif access == T("\228\188\160\229\165\135\229\144\175\231\168\139\232\142\183\229\143\150") then
      local state = ed.dayAwardsManager.isOpen and "Normal" or "Locked"
      table.insert(getWay, {
        id = 1,
        name = "  " .. access,
        type = "dayAwardsScene",
        state = state
      })
    elseif access == T("\233\133\146\233\166\134\229\149\134\229\186\151\232\142\183\229\143\150") then
      state = ed.shopData:getShopOpenVis(7) and "Normal" or "Locked"
      table.insert(getWay, {
        id = 7,
        name = "  " .. access,
        type = "shop",
        state = state
      })
    end
  end
  return getWay
end

ed.packageGetWay = packageGetWay

function PackageSourceWin.create(param)
  local self = base.create("PackageSourceWin")
  setmetatable(self, PackageSourceWin)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:listenEvent("RefreshHeroRed", function()
    self.totalNum = ed.player:getNewEquipAmount(self.id, self.insid) or 0
    self.ui.label_amount:setString(self.totalNum)
  end)
  self:popWindow()
  self:show()
  return self
end

function PackageSourceWin:initData(param)
  self.id = param.id
  self.insid = param.insid
  self.totalNum = ed.player:getNewEquipAmount(self.id, self.insid) or 0
  local getWay = packageGetWay(self.id)
  self.getWay = getWay
end

function PackageSourceWin:initUI()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.package_source_win)
  ed.layout.centerInScreen(self.ui.bg_detail, true)
  ui.label_amount:setString(self.totalNum)
  ui.label_name:setString(ed.readequip.value(self.id, "Name"))
  self.ui.label_name:setColor(ccc3(255, 252, 231))
  ed.setLabelStroke(self.ui.label_name, ccc3(39, 37, 36), 2)
  local icon = ed.readequip.createIcon(self.id)
  local x, y = ui.icon_item:getPosition()
  ui.icon_item:setVisible(false)
  icon:setPosition(ccp(x, y))
  ui.top_layer:addChild(icon)
  self.labelPosX = self.ui.label_amount_str:getPositionX()
  self.draglist = ed.UITool.createDraglist(self.ui.mid_layer, {priority = -300})
  self:refreshDraglist()
  self:refreshUI()
end

function PackageSourceWin:clickGetWay(data)
  if data.type == "stage" then
    ed.ui.stagedetail.create(data.id):popWindow()
    ed.stageSelectParam = nil
  elseif data.type == "summon" then
    ed.summonMgr.noBottomButton = true
    ed.UITool.openView("summonScene")
  elseif data.type == "skillTower" then
    ed.UITool.openView("SkillTowerStageScene", data.id)
  elseif data.type == "shop" then
    ed.UITool.openView("shopMain", {
      page = data.id
    })
  elseif data.type == "heroExercise" then
    ed.exerciseManager:openExerciseMainScene()
  elseif data.type == "task" then
    ed.UITool.openView("taskScene", {})
  elseif data.type == "awakeDungeon" then
    ed.UITool.openView("awakeDungeonScene")
  elseif data.type == "nianMonster" then
    ed.UITool.openView("nianMonsterMainScene")
  elseif data.type == "chat" then
    ed.chatManager:openChatMainWin(ed.chatManager.ChannelEnum.world_channel)
  elseif data.type == "NewYearDaysLogin" then
    local actId
    if ed.activityHints.data:getActivityIsOpenById(85) then
      actId = 85
    elseif ed.activityHints.data:getActivityIsOpenById(94) then
      actId = 94
    end
    ed.UITool.openView("activityScene", {actId = actId})
  elseif data.type == "CDKey" then
    if not ed.getPopWindow("playerInfoWindow") then
      ed.ui.playerInfoWindow.create():popWindow()
    end
  elseif data.type == "growPlan" then
    ed.UITool.openView("activityScene", {openActType = "grow_plan"})
  elseif data.type == "RechargeScene" then
    if self.id == ed.getDataTable("DragonBoat")[1]["Item ID"] then
      ed.pushScene(ed.ui.RechargeScene.create({
        page = "FestivalGift"
      }))
    else
      ed.pushScene(ed.ui.RechargeScene.create({
        page = "Gift",
        giftItemId = self.id
      }))
    end
  elseif data.type == "rogueMainScene" then
    ed.UITool.openView("rogueMainScene")
  elseif data.type == "fireForgeMainScene" then
    ed.UITool.openView("fireForgeMainScene")
  elseif data.type == "latestStageScene" then
    ed.UITool.openView("stageSelect")
  elseif data.type == "skillTowerMainScene" then
    ed.UITool.openView("SkillTowerScene", data.id)
  elseif data.type == "legendEquipShopScene" then
    ed.UITool.openView("legendEquipShopScene")
  elseif data.type == "dayAwardsScene" then
    ed.UITool.openView("dayAwardsScene", {})
  end
end

function PackageSourceWin:createGetWayItem(data)
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  local readnode = ed.readnode.create(container, ui)
  if data.state == "Normal" then
    readnode:addNode(ed.uieditor.accessNormalItem)
    self:btRegisterButtonClick({
      button = ui.bg,
      key = data.type .. data.id,
      clickHandler = function()
        self:clickGetWay(data)
      end,
      force = true,
      mcpMode = true,
      clickInterval = 0.5,
      pressScale = 0.9,
      priority = -301
    })
  elseif data.state == "Special" then
    readnode:addNode(ed.uieditor.accessSpecialItem)
  else
    readnode:addNode(ed.uieditor.accessLockItem)
    ui.label_lock:setHorizontalAlignment(kCCTextAlignmentCenter)
    ed.adaptLabel(ui.label_lock, {
      maxWidth = 45,
      minScale = 0.7,
      maxHeight = 60
    })
  end
  ed.setString(ui.label_info, data.name)
  ed.setLabelStroke(self.ui.label_info, ccc3(255, 252, 231), 1)
  ed.adaptLabel(ui.label_info, {maxWidth = 160, minScale = 0.7})
  return container, ui
end

function PackageSourceWin:refreshDraglist()
  local uiList = {}
  self.draglist.listLayer:removeAllChildrenWithCleanup(true)
  local oy = self.ui.mid_layer:getContentSize().height
  local ox = self.ui.mid_layer:getContentSize().width / 2
  local dy = 48
  
  local function getPos(i)
    return ccp(ox, oy - dy * i + 23)
  end
  
  for k, v in ipairs(self.getWay or {}) do
    local container, ui = self:createGetWayItem(v)
    ui.data = v
    table.insert(uiList, ui)
    self.draglist:addItem(container)
    container:setPosition(getPos(k))
  end
  self.uiList = uiList
  self.draglist:initListHeight(#self.getWay * dy)
end

function PackageSourceWin:refreshUI()
  if self.totalNum < 10 then
    self.ui.label_amount_str:setPositionX(self.labelPosX + 9)
    ed.right2(self.ui.label_amount, self.ui.label_amount_str, 1)
  elseif self.totalNum < 100 then
    self.ui.label_amount_str:setPositionX(self.labelPosX + 6)
    ed.right2(self.ui.label_amount, self.ui.label_amount_str, 1)
  elseif self.totalNum < 1000 then
    self.ui.label_amount_str:setPositionX(self.labelPosX + 3)
    ed.right2(self.ui.label_amount, self.ui.label_amount_str, 1)
  end
end

function PackageSourceWin:gotoGetWay(index)
  local stageid = self.getWay[index].id
  local st = ed.stageType(stageid)
  if ed.isElementInTable(st, {"normal", "elite"}) then
    local star = ed.player:getStageStar(stageid) or 0
    local preStar = ed.player:getStageStar(stageid - 1) or 0
    if 0 < star + preStar then
      local scene = ed.ui.stageselect.createByStage(stageid)
      ed.pushScene(scene)
    else
      ed.showToast(T("\229\133\179\229\141\161\229\176\154\230\156\170\229\188\128\229\144\175\227\128\130"))
    end
  else
    ed.showToast(T("\230\178\161\230\156\137\230\153\174\233\128\154\230\136\150\231\178\190\232\139\177\229\133\179\229\141\161\229\143\175\228\187\165\230\142\137\232\144\189"))
  end
end

function PackageSourceWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg_detail,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
end
