local base = ed.ui.popwindow
local GuildMountBattleEndWin = newclass(base.mt)
ed.ui.GuildMountBattleEndWin = GuildMountBattleEndWin

function GuildMountBattleEndWin.create(params)
  local self = base.create("GuildMountBattleEndWin")
  setmetatable(self, GuildMountBattleEndWin.mt)
  self:initData(params)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function GuildMountBattleEndWin:initData(params)
  self.rewards = params.rewards or {}
  self.curStageData = params
  self.bossId = params.battleBossId
end

function GuildMountBattleEndWin:initLabels()
  ed.setLabelStroke(self.ui.label_reward, ed.toccc3(25252163), 1)
  self.ui.label_reward:setAnchorPoint(ccp(1, 0.5))
  self.ui.label_reward:setPositionX(self.ui.label_reward:getPositionX() + 36)
  ed.setLabelStroke(self.ui.Label_2031, ed.toccc3(25252163), 1)
  ed.setLabelStroke(self.ui.historytime2, ed.toccc3(25252163), 1)
  ed.setLabelStroke(self.ui.guildname, ed.toccc3(25252163), 1)
  self.ui.curtime2_Copy0:setVisible(false)
  self.ui.curtime2:setVisible(false)
  self.ui.label_process_title:setVisible(false)
  ed.setLabelStroke(self.ui.best_in_self, ed.toccc3(10551124), 0.5)
  ed.setLabelShadow(self.ui.best_in_self, ed.toccc3(1727272), ccp(0, 1))
  ed.setLabelFontName(self.ui.best_in_self, ed.fontBold)
  ed.left2(self.ui.historytime2, self.ui.historytime1, 10)
  ed.left2(self.ui.ImageView_3002, self.ui.guildname, 4)
  ed.right2(self.ui.ImageView_3002_Copy0, self.ui.guildname, 4)
  local bossId = self.bossId
  local monsterName = ed.getDataTable("GuildMountBoss")[bossId]["Boss Name"]
  local stageId = ed.getDataTable("GuildMountBoss")[bossId]["Stage ID"]
  local lv = ed.getDataTable("Battle")[stageId][1]["Level 1"]
  local title_bg = ed.createScale9Sprite("UI/alpha/1080P/guildmount/practice/board_practice.png", CCRectMake(50, 10, 80, 1))
  local oriSize = title_bg:getContentSize()
  title_bg:setPosition(ccp(480, 323))
  self.ui.bg:addChild(title_bg)
  local title_lab = ed.createLabelTools({
    txt = T("\231\172\172%d\232\189\174  %s (Lv.%d)", ed.GuildMountManager.getBossRoundById(bossId), monsterName, lv),
    size = 19,
    pos = ccp(480, 323),
    color = ed.toccc3(16313700),
    stroke = {
      ed.toccc3(1445383),
      1.5
    },
    parent = self.ui.bg,
    font = ed.fontBold
  })
  title_bg:setContentSize(CCSizeMake(math.max(oriSize.width, title_lab:getContentSize().width + 20), oriSize.height))
end

function GuildMountBattleEndWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.GuildMountVictoryWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self.ui.ImageView_2034:setVisible(false)
  ed.setString(self.ui.historytime1, self.curStageData.damage)
  ed.setString(self.ui.Label_2032, self.curStageData.score)
  ed.right2(self.ui.Label_2032, self.ui.Label_2031, 6)
  if self.curStageData.isNewRecord and self.curStageData.isNewRecord == 1 then
    self.ui.best_in_self:setVisible(true)
  end
  ed.right2(self.ui.best_in_self, self.ui.Label_2032, 10)
  if self.curStageData.maxDamageUser then
    local summary = self.curStageData.maxDamageUser
    local head = ed.getWholeHeadIcon({
      id = summary._avatar,
      level = summary._level,
      lvoffset = {x = -47, y = -18},
      scale = 0.5,
      no_name_bg = true
    })
    ed.UITool.replaceUINew(self.ui, "icon_head", head)
    local name = ed.getPlayerName(summary._name, summary._medal, {
      anchorPoint = ccp(0, 0.5)
    })
    ed.UITool.replaceUINew(self.ui, "label_name", name)
    ed.setString(self.ui.besttime2, self.curStageData.maxdamage)
    self.ui.bg_head:setVisible(true)
    ed.right2(self.ui.besttime2, self.ui.besttime1, 12)
  end
  self:refreshDraglist()
  self:playLightAnim()
  self:createTeamHeros(self.curStageData.hero_list)
end

function GuildMountBattleEndWin:createTeamHeros(heroList)
  for i, v in ipairs(heroList) do
    local icon = ed.readhero.createIconByServer(v).icon
    icon:setPosition(ccp(440 + i * 80 - #heroList * 80 / 2, 270))
    self.ui.bg:addChild(icon)
    icon:setScale(0.8)
  end
end

function GuildMountBattleEndWin:playLightAnim()
  local node = ed.createFcaNode("eff_UI_pvp_light")
  self:addFca(node)
  local x, y = self.ui.light:getPosition()
  node:setPosition(ccp(x, y - 55))
  self.ui.light:setVisible(false)
  self.ui.bg:addChild(node)
  local node = ed.createFcaNode("eff_UI_pve_victory_wings")
  self:addFca(node)
  node:setPosition(ccp(x, y + 13))
  self.ui.bg:addChild(node)
  local node = ed.createFcaNode("eff_UI_pvp_newrecord_particles")
  self:addFca(node)
  node:setPosition(ccp(x, y + 13))
  self.ui.bg:addChild(node)
end

function GuildMountBattleEndWin:refreshDraglist()
  self.lootui = {}
  local width = 0
  for i, v in ipairs(self.rewards) do
    local icon = ed.createItemIcon({
      type = v._type,
      amount = v._amount,
      id = v._id
    })
    icon:setAnchorPoint(ccp(0, 0))
    icon:setScale(0.88)
    icon:setPosition(ccp(width, 0))
    self.ui.layer_reward:addChild(icon)
    table.insert(self.lootui, {
      icon = icon,
      id = v._id,
      type = v._type
    })
    width = width + ed.layout.getScaleSize(icon).width
    if i == 1 then
      local randomFca = ed.createFcaNode("eff_UI_GuildMount_boxchange")
      icon:addChild(randomFca)
      randomFca:setPosition(ccp(43, 44))
      self:addFca(randomFca)
    end
    self:btRegisterButtonClick({
      button = icon,
      key = "number" .. i,
      clickHandler = function()
        ed.ui.packageDetailWin.create(self.lootui[i]):popWindow()
      end
    })
  end
  self.ui.label_reward:setVisible(0 < #self.rewards)
end

function GuildMountBattleEndWin:doClickInLoot()
  local function handler(x, y, id)
    ed.ui.packageDetailWin.create(self.lootui[id]):popWindow()
  end
  
  return handler
end

function GuildMountBattleEndWin:cancelClickInLoot()
  local function handler(x, y, id)
  end
  
  return handler
end

function GuildMountBattleEndWin:doPressInLoot()
  local function handler(x, y)
    for i = 1, #self.lootui do
      local loot = self.lootui[i]
      
      if ed.containsPoint(loot.icon, x, y) then
        return i
      end
    end
  end
  
  return handler
end

function GuildMountBattleEndWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
    ed.popScene()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_data", function()
    ed.ui.BattleStaticsWin.create(ed.engine.unit_list, "guildMount", true)
  end, {pressScale = 0.9})
end
