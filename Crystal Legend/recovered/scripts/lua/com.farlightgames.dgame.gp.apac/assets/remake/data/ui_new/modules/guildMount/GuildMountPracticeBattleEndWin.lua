local base = ed.ui.popwindow
local GuildMountPracticeBattleEndWin = newclass(base.mt)
ed.ui.GuildMountPracticeBattleEndWin = GuildMountPracticeBattleEndWin

function GuildMountPracticeBattleEndWin.create(params)
  params = params or ed.dsadawdadawdawd
  ed.dsadawdadawdawd = params
  local self = base.create("GuildMountPracticeBattleEndWin")
  setmetatable(self, GuildMountPracticeBattleEndWin.mt)
  self:initData(params)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function GuildMountPracticeBattleEndWin:initData(params)
  self.rewards = params.rewards or {}
  self.curStageData = params
end

function GuildMountPracticeBattleEndWin:initLabels()
  ed.setLabelStroke(self.ui.label_process_title, ed.toccc3(25252163), 1)
  self.ui.curtime2:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.curtime2, ed.toccc3(25252163), 1)
  ed.setLabelStroke(self.ui.label_reward, ed.toccc3(25252163), 1)
  self.ui.label_reward:setAnchorPoint(ccp(1, 0.5))
  self.ui.label_reward:setPositionX(self.ui.label_reward:getPositionX() + 36)
  ed.setLabelStroke(self.ui.Label_2031, ed.toccc3(25252163), 1)
  ed.setLabelStroke(self.ui.historytime2, ed.toccc3(25252163), 1)
  ed.setLabelStroke(self.ui.guildname, ed.toccc3(25252163), 1)
  self.ui.curtime2_Copy0:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.curtime2_Copy0, ed.toccc3(25252163), 1)
  ed.right2(self.ui.curtime2, self.ui.label_process_title, 1)
  ed.right2(self.ui.historytime1, self.ui.historytime2, 10)
  self.ui.label_process_title:setVisible(false)
  self.ui.curtime2:setVisible(false)
  self.ui.curtime2_Copy0:setVisible(false)
  self.ui.bar:setVisible(false)
  self.ui.ImageView_2034:setVisible(false)
  self.ui.label_reward:setVisible(false)
  ed.createSpriteTools({
    res = "UI/alpha/1080P/guildmount/practice/board_practice.png",
    pos = ccp(480, 323),
    parent = self.ui.bg
  })
  ed.createLabelTools({
    txt = T("\231\187\131\228\185\160\230\168\161\229\188\143"),
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
  ed.createLabelTools({
    txt = T("\230\156\172\230\168\161\229\188\143\230\136\152\230\150\151\231\187\147\230\158\156\228\184\141\231\148\159\230\149\136\239\188\140\228\187\133\228\190\155\231\187\131\228\185\160\228\189\191\231\148\168"),
    size = 19,
    pos = ccp(480, 40),
    color = ed.toccc3(11568222),
    stroke = {
      ed.toccc3(1445383),
      1.5
    },
    parent = self.ui.bg
  })
end

function GuildMountPracticeBattleEndWin:createTeamHeros(heroList)
  for i, v in ipairs(heroList) do
    local icon = ed.readhero.createIconByServer(v).icon
    icon:setPosition(ccp(440 + i * 80 - #heroList * 80 / 2, 270))
    self.ui.bg:addChild(icon)
    icon:setScale(0.8)
  end
end

function GuildMountPracticeBattleEndWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.GuildMountVictoryWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  local damage = math.floor(ed.engine:getPlayerTotalDamage(ed.emCampPlayer))
  ed.setString(self.ui.historytime1, damage or 0)
  ed.setString(self.ui.Label_2032, self.curStageData.score)
  ed.right2(self.ui.Label_2032, self.ui.Label_2031, 6)
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
  self:playLightAnim()
  self:createTeamHeros(self.curStageData.hero_list)
end

function GuildMountPracticeBattleEndWin:playLightAnim()
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

function GuildMountPracticeBattleEndWin:doClickInLoot()
  local function handler(x, y, id)
    ed.ui.packageDetailWin.create(self.lootui[id]):popWindow()
  end
  
  return handler
end

function GuildMountPracticeBattleEndWin:cancelClickInLoot()
  local function handler(x, y, id)
  end
  
  return handler
end

function GuildMountPracticeBattleEndWin:doPressInLoot()
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

function GuildMountPracticeBattleEndWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
    ed.popScene()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_data", function()
    ed.ui.BattleStaticsWin.create(ed.engine.unit_list, "guildMount", true)
  end, {pressScale = 0.9})
end
