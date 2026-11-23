local base = ed.ui.popwindow
local pvpBattleVictoryWin = {}
pvpBattleVictoryWin.__index = pvpBattleVictoryWin
setmetatable(pvpBattleVictoryWin, base.mt)
ed.ui.pvpBattleVictoryWin = pvpBattleVictoryWin
local pvpBattleVictoryWinScope = {}
local lsr = ed.ui.stagedonelsr.create()

function pvpBattleVictoryWin.create(params)
  local self = base.create("pvpBattleVictoryWin")
  setmetatable(self, pvpBattleVictoryWin)
  self:initData(params)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function pvpBattleVictoryWin:initData(params)
  self.param = params
  pvpBattleVictoryWinScope = {}
end

function pvpBattleVictoryWin:createHeroIcon()
  local heroui = {}
  local unitLevel = ed.getDataTable("Levels")
  local heroes = self.param.heroes
  local hcount = math.min(#heroes, 5)
  for i = 1, 5 do
    if heroes[i] then
      local hero = ed.player.heroes[heroes[i].id]
      local head = ed.readhero.createIconByID(heroes[i].id, {length = 63})
      local heroIcon = head.icon
      local x, y = self.ui["icon" .. i]:getPosition()
      self.ui["icon" .. i]:setVisible(false)
      heroIcon:setPosition(ccp(x, y))
      self.ui["bg_bar" .. i]:addChild(heroIcon)
      ed.setString(self.ui["exp" .. i], string.format(T("EXP+%d"), heroes[i].addExp))
      local stencil_res = "UI/alpha/1080P/battleresult/expbar.png"
      local clippingNode = ed.createClippingNodeOnly(stencil_res, 0.5)
      local sprite = ed.createScale9Sprite("UI/alpha/1080P/battleresult/expbar.png", CCRectMake(1.5, 2.5, 72, 3))
      clippingNode:setPosition(0.5, 5.5)
      local stencil = clippingNode:getStencil()
      local stencil_size = stencil:getContentSize()
      self.barScale = 65.5 / stencil_size.width
      stencil:setScaleX(self.barScale)
      sprite:setContentSize(CCSizeMake(65.5, 9))
      stencil:setAnchorPoint(ccp(0, 0.5))
      sprite:setAnchorPoint(ccp(0, 0.5))
      stencil:setScaleX(heroes[i].exp / heroes[i].maxExp * self.barScale)
      clippingNode:addChild(sprite)
      self.ui["bar" .. i]:setVisible(false)
      self.ui["bar" .. i] = stencil
      self.ui["bg_bar" .. i]:addChild(clippingNode)
      heroui[i] = {
        icon = head,
        barBg = self.ui["bg_bar" .. i],
        bar = stencil,
        lv = 1
      }
    else
      self.ui["bg_bar" .. i]:setVisible(false)
    end
  end
  self.heroui = heroui
  self:playHeroBarAnim()
end

function pvpBattleVictoryWin:playLevelupEffect(icon, id)
  if not self.levelupEffect then
    self.levelupEffect = {}
  end
  if self.levelupEffect[id] then
    self.levelupEffect[id] = nil
  end
  local fca = ed.createFcaNode("eff_UI_levelup")
  local img_levelUp
  if ed.isAreaZhCn() then
    img_levelUp = ed.createSprite("UI/alpha/1080P/common/drtrtr.png")
  else
    img_levelUp = ed.createSprite("UI/alpha/1080P/common/drtrtr-global.png")
    img_levelUp:setScale(0.9)
  end
  local img_node = CCSprite:create()
  img_node:addChild(img_levelUp)
  fca:addNodeToComponent(img_node, "Node", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
  self:addFca(fca)
  fca:setScale(1.25)
  fca:setPosition(ccp(38, 38))
  icon:addChild(fca, 5)
  self.levelupEffect[id] = fca
end

function pvpBattleVictoryWin:playHeroBarAnim()
  local dt = 0.3
  for i = 1, #self.heroui do
    local ui = self.heroui[i]
    local hero = self.param.heroes[i]
    local array = CCArray:create()
    local delay = CCDelayTime:create(dt)
    array:addObject(delay)
    for j = 1, hero.tLevel - hero.level do
      local a = CCScaleTo:create(0.5, 1, 1)
      dt = dt + 0.5
      local f = CCCallFunc:create(function()
        if not tolua.isnull(ui.bar) then
          lsr:report("heroLevelup")
          ui.bar:setScaleX(0)
          ui.icon:refreshLevel(hero.level + j)
          self:playLevelupEffect(ui.icon.icon, i)
        end
      end)
      array:addObject(a)
      array:addObject(f)
    end
    local a = CCScaleTo:create(0.2, hero.tExp / hero.tMaxExp, 1)
    dt = dt + 0.2
    local f = CCCallFunc:create(function()
      if not tolua.isnull(ui.bar) and hero.isMaxLevel then
        local tag = ed.createttf(T("\231\187\143\233\170\140\229\183\178\230\187\161"), 12)
        tag:setPosition(ccp(40, -8))
        ui.bar:addChild(tag)
      end
    end)
    array:addObject(a)
    array:addObject(f)
    local sequence = CCSequence:create(array)
    ui.bar:runAction(sequence)
  end
end

function pvpBattleVictoryWin:playLightAnim()
  local node = ed.createFcaNode("eff_UI_pvp_light")
  self:addFca(node)
  local x, y = self.ui.light:getPosition()
  node:setPosition(ccp(x, y - 55))
  self.ui.light:setVisible(false)
  self.ui.bg:addChild(node)
  self.ui.ImageView_22248:setVisible(false)
  local node = ed.createFcaNode("eff_UI_pve_victory_wings")
  self:addFca(node)
  node:setPosition(ccp(x, y + 15))
  self.ui.bg:addChild(node)
  local node = ed.createFcaNode("eff_UI_pvp_newrecord_particles")
  self:addFca(node)
  node:setPosition(ccp(x, y + 15))
  self.ui.bg:addChild(node)
end

function pvpBattleVictoryWin:playWinAnim()
  lsr:report("createScene")
  self:playLightAnim()
end

function pvpBattleVictoryWin:playInfoBgAnim()
  local bg = self.ui.info_bg
  local fade = CCFadeIn:create(0.2)
  bg:runAction(fade)
  local fade2 = CCFadeIn:create(0.2)
  self.ui.battleStatistNode:runAction(fade2)
end

function pvpBattleVictoryWin:doPvpLayerTouch()
  local function handler(event, x, y)
    if not self.pvpLayer:isVisible() then
      return false
    end
    if event == "began" then
      if ed.containsPoint(self.pvpui.btn_back_Copy0, x, y) then
        self.isClickCloseBest = true
      end
    elseif event == "ended" and self.isClickCloseBest then
      self.pvpLayer:setVisible(false)
      self.isClickCloseBest = nil
    end
    return true
  end
  
  return handler
end

function pvpBattleVictoryWin:createPvpRankReward()
  local pvpLayer = CCLayerColor:create(ccc4(0, 0, 0, 150))
  self.mainLayer:addChild(pvpLayer)
  self.pvpLayer = pvpLayer
  pvpLayer:setTouchEnabled(true)
  pvpLayer:registerScriptTouchHandler(self:doPvpLayerTouch(), false, -600, true)
  self.pvpui = {}
  local readNode = ed.readnode.create(pvpLayer, self.pvpui)
  readNode:addNode(ed.uieditor.PvpBestRank)
  local x, y = self.pvpui.curRank:getPosition()
  local curRank = ed.getNumberNode({
    text = self.param.bestRankReward._cur_rank,
    folder = "big_pvp",
    padding = -1
  }).node
  curRank:setPosition(ccp(x + curRank:getContentSize().width / 2, y))
  curRank:setScale(0.9)
  self.pvpui.curRank = curRank
  self.pvpui.bg:addChild(curRank)
  local rank_delta_string = string.format("(<sprite src=UI/alpha/1080P/battleresult/arrow_up.png>%d)", self.param.bestRankReward._best_rank - self.param.bestRankReward._cur_rank)
  local rank = ed.ui.autoText.new()
  rank:initParam({context = rank_delta_string, fontSize = 16})
  rank.node:setPosition(ccp(x + curRank:getContentSize().width / 2 + 35, y))
  self.pvpui.bg:addChild(rank.node)
  x = self.pvpui.Label_15668:getPositionX() + self.pvpui.Label_15668:getContentSize().width
  y = self.pvpui.Label_15668:getPositionY()
  local bestRank = ed.getNumberNode({
    text = self.param.bestRankReward._best_rank,
    folder = "big_pvp",
    padding = -1
  }).node
  bestRank:setPosition(ccp(x + bestRank:getContentSize().width / 2, y))
  bestRank:setScale(0.9)
  ed.setString(self.pvpui.num_diamond, self.param.bestRankReward._best_rank_reward._dimond)
  self.pvpui.bestRank = bestRank
  self.pvpui.bg:addChild(bestRank)
  self.pvpui.bg:setPositionX(ed.display.winSize.width / 2)
  self.pvpLayer:setVisible(false)
end

function pvpBattleVictoryWin:initUI()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.pvpBattleVictoryWin)
  self.draglist = ed.UITool.createDraglist(self.ui.layer_reward, {priority = -300})
  self:createHeroIcon()
  local posx, posy = self.ui.label_ranknum:getPosition()
  local numNode = ed.getNumberNode({
    text = self.param.bestRankReward._cur_rank or 0,
    folder = "blue"
  }).node
  numNode:setPosition(posx, posy)
  numNode:setAnchorPoint(ccp(1, 0.5))
  self.ui.bg_rank:addChild(numNode)
  ed.setString(self.ui.label_hisranknum, self.param.bestRankReward._best_rank)
  ed.setString(self.ui.label_playerlevel, string.format(T("\230\136\152\233\152\159\231\173\137\231\186\167   Lv.%d"), ed.player:getLevel()))
  ed.setString(self.ui.label_exp, "0")
  ed.setLabelShadow(self.ui.label_back, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelStroke(self.ui.label_reward, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.label_rank, ccc3(57, 36, 21), 1)
  ed.setLabelStroke(self.ui.label_historyrank, ccc3(57, 36, 21), 1)
  ed.setLabelStroke(self.ui.label_playerlevel, ccc3(57, 36, 21), 1)
  ed.setLabelStroke(self.ui.label_exp, ccc3(23, 49, 31), 1)
  local rank_delta = self.param.bestRankReward._best_rank - self.param.bestRankReward._cur_rank
  print("rank_delta", rank_delta)
  if 0 < rank_delta then
    local size = numNode:getContentSize()
    local rank_delta_string = string.format("(<sprite src=UI/alpha/1080P/battleresult/arrow_up.png>%d)", self.param.bestRankReward._best_rank - self.param.bestRankReward._cur_rank)
    local rankup = ed.ui.autoText.new()
    rankup:initParam({context = rank_delta_string, fontSize = 16})
    rankup.node:setPosition(ccp(self.ui.label_ranknum:getPositionX() - size.width - 15, self.ui.label_ranknum:getPositionY()))
    self.ui.bg_rank:addChild(rankup.node)
    ed.left2(numNode, rankup.node, 5)
    self:createPvpRankReward()
    if self.param.bestRankReward._best_rank_reward._dimond ~= 0 then
      self.mainLayer:setTouchEnabled(false)
      ListenTimer(Timer:Once(0.5), function()
        self.mainLayer:setTouchEnabled(true)
        local action = CCScaleTo:create(0.5, 1)
        action = CCEaseBackOut:create(action)
        if self.pvpLayer and not tolua.isnull(self.pvpLayer) then
          self.pvpLayer:runAction(action)
          self.pvpLayer:setVisible(true)
        end
        if self.pvpui.light and not tolua.isnull(self.pvpui.light) then
          local light = ed.createFcaNode("eff_UI_pvp_newrecord_light")
          self.pvpui.light:setVisible(false)
          light:setPosition(ccp(self.pvpui.light:getPosition()))
          self.pvpui.bg:addChild(light)
          self:addFca(light)
        end
        local particles = ed.createFcaNode("eff_UI_pvp_newrecord_particles")
        particles:setPosition(ccp(self.pvpui.light:getPosition()))
        self.pvpui.bg:addChild(particles, 999)
        self:addFca(particles)
      end, pvpBattleVictoryWinScope)
    end
  end
  local playerLevel = ed.player:getLevel()
  local playerExp = ed.player:getExp()
  local pt = ed.getDataTable("PlayerLevel")
  local playerMaxExp = pt[playerLevel].Exp
  local size = self.ui.exp_bar:getContentSize()
  ed.setString(self.ui.label_playerlevel, string.format(T("\230\136\152\233\152\159\231\173\137\231\186\167   Lv.%d"), playerLevel))
  ed.left2(self.ui.exp, self.ui.label_exp, 8)
  self.barsize = self.ui.bar1:getContentSize()
  self.ui.exp_bar:setContentSize(CCSizeMake(playerExp / playerMaxExp * size.width, size.height))
  self:refreshDraglist()
  self:playWinAnim()
end

function pvpBattleVictoryWin:refreshDraglist()
  self.draglist.listLayer:removeAllChildrenWithCleanup(true)
  self.lootui = {}
  
  local function getRewardId(data)
    if data.id then
      return data.id
    elseif data.type == "diamond" then
      return "Diamond"
    end
    return nil
  end
  
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
      icon:setScale(0.88)
      icon:setPosition(getPos(k))
      self.draglist:addItem(icon)
      self:btRegisterButtonClick({
        button = icon,
        key = "reward" .. k,
        clickHandler = function()
          ed.ui.packageDetailWin.create({
            type = v._type
          }):popWindow()
        end,
        priority = -350
      })
      table.insert(self.lootui, {
        icon = icon,
        id = getRewardId(v)
      })
    end)
    array:addObject(f)
    array:addObject(CCDelayTime:create(0.5))
  end
  local sequence = CCSequence:create(array)
  self.ui.bg:runAction(sequence)
  self.draglist:initListWidth(#self.rewards * dx)
end

function pvpBattleVictoryWin:doClickInLoot()
  local function handler(x, y, id)
    if self.namePanel then
      self.namePanel:removeFromParentAndCleanup(true)
      
      self.namePanel = nil
    end
  end
  
  return handler
end

function pvpBattleVictoryWin:cancelClickInLoot()
  local function handler(x, y, id)
    if self.namePanel then
      self.namePanel:removeFromParentAndCleanup(true)
      
      self.namePanel = nil
    end
  end
  
  return handler
end

function pvpBattleVictoryWin:doPressInLoot()
  local function handler(x, y)
    for i = 1, #self.lootui do
      local loot = self.lootui[i]
      
      if ed.containsPoint(loot.icon, x, y) then
        local panel = ed.readequip.getDetailCard(loot.id)
        local iconsize = loot.icon:getContentSize()
        local iconpos = loot.icon:getParent():convertToWorldSpace(ccp(loot.icon:getPosition()))
        local pos = ccpAdd(iconpos, ccp(iconsize.width / 2, iconsize.height / 2))
        panel:setPosition(pos)
        self.mainLayer:addChild(panel, 50)
        self.namePanel = panel
        return i
      end
    end
  end
  
  return handler
end

function pvpBattleVictoryWin:cancelPressInLoot()
  local function handler(x, y, id)
    if self.namePanel then
      self.namePanel:removeFromParentAndCleanup(true)
      
      self.namePanel = nil
    end
  end
  
  return handler
end

function pvpBattleVictoryWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    pvpBattleVictoryWinScope = nil
    CloseScope(pvpBattleVictoryWinScope)
    base.destroy(self)
    ed.popScene()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_data", function()
    ed.ui.BattleStaticsWin.create(ed.engine.unit_list, "pvp", true)
  end, {pressScale = 0.9})
end
