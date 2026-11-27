local base = ed.ui.popwindow
local GuildRaidVictoryWin = newclass(base.mt)
ed.ui.GuildRaidVictoryWin = GuildRaidVictoryWin
local GuildRaidVictoryScope = {}

function GuildRaidVictoryWin.create(param)
  local self = base.create("GuildRaidVictoryWin")
  setmetatable(self, GuildRaidVictoryWin.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function GuildRaidVictoryWin:initData(param)
  self.param = param
end

local guildBestRank = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(460, 320)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 25, 10, 25),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(480, 439)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 175.5, h = 52},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pvp/newrecord.png",
      name = "title",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(230, 325)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.3, x = 1.3},
      flip = "",
      opacity = 255,
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/hero/hero_rankup_light.png",
      name = "light",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(230, 315)
    }
  },
  {
    t = "Scale9Sprite",
    base = {
      parent = "bg",
      name = "line_1",
      res = "UI/alpha/1080P/pvp/diamond_bg.png",
      capInsets = CCRectMake(15, 4, 350, 30)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(230, 225)
    },
    config = {
      scaleSize = CCSizeMake(300, 25)
    }
  },
  {
    t = "Label",
    config = {
      color = ccc3(255, 252, 231)
    },
    base = {
      name = "text_1",
      text = T("\229\133\168\230\156\141\229\142\134\229\143\178\230\156\128\233\171\152\228\188\164\229\174\179"),
      parent = "line_1",
      z = 1,
      size = 16
    },
    layout = {
      position = ccp(150, 13)
    }
  },
  {
    t = "Scale9Sprite",
    base = {
      parent = "bg",
      name = "line_2",
      res = "UI/alpha/1080P/pvp/diamond_bg.png",
      capInsets = CCRectMake(15, 4, 350, 30)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(160, 175)
    },
    config = {
      scaleSize = CCSizeMake(200, 22),
      opacity = 100
    }
  },
  {
    t = "Label",
    config = {
      color = ccc3(255, 252, 231)
    },
    base = {
      name = "text_2",
      text = T(""),
      parent = "line_2",
      z = 1,
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(50, 10)
    }
  },
  {
    t = "Label",
    config = {
      color = ccc3(255, 252, 231)
    },
    base = {
      name = "text_shanhai",
      text = T("\228\188\164\229\174\179:"),
      parent = "line_2",
      z = 1,
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(230, 10)
    }
  },
  {
    t = "Scale9Sprite",
    base = {
      parent = "bg",
      name = "line_3",
      res = "UI/alpha/1080P/pvp/diamond_bg.png",
      capInsets = CCRectMake(15, 4, 350, 30)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(230, 110)
    },
    config = {
      scaleSize = CCSizeMake(300, 25)
    }
  },
  {
    t = "Label",
    config = {
      color = ccc3(255, 252, 231)
    },
    base = {
      name = "text_3",
      text = T("\230\150\176\231\186\170\229\189\149"),
      parent = "line_3",
      z = 1,
      size = 16
    },
    layout = {
      position = ccp(150, 13)
    }
  }
}

function GuildRaidVictoryWin:createBestDamageLayer()
  local breakHistory = self.param.breakHistory
  if not breakHistory then
    return
  end
  local pvpLayer = CCLayerColor:create(ccc4(0, 0, 0, 150))
  self.mainLayer:addChild(pvpLayer)
  self.pvpLayer = pvpLayer
  pvpLayer:setTouchEnabled(true)
  self.pvpui = {}
  local readNode = ed.readnode.create(pvpLayer, self.pvpui)
  readNode:addNode(guildBestRank)
  self.pvpLayer:setPosition(ed.display.halfFixedWidth, ed.display.halfFixedHeight)
  local userData = breakHistory._old_summary
  local hand = ed.getTeamHead({
    id = userData._avatar,
    vip = 0 < (userData._vip or 0)
  })
  hand:setScale(0.75)
  hand:setPosition(65, 170)
  self.pvpui.bg:addChild(hand)
  local frame = ed.createSprite("UI/alpha/1080P/ranking/lv_bg.png")
  frame:setPosition(65, 142)
  self.pvpui.bg:addChild(frame)
  local levelLabel = ed.createLabelTTF(userData._level or 0, 16)
  ed.setLabelStroke(levelLabel, ccc3(43, 28, 8), 1)
  ed.setLabelColor(levelLabel, ccc3(251, 224, 116))
  levelLabel:setPosition(65, 142)
  self.pvpui.bg:addChild(levelLabel)
  local name = ed.getPlayerName(userData._name, userData._medal, {
    anchorPoint = ccp(0, 0.5)
  })
  ed.UITool.replaceUI(self.pvpui, "line_2", "text_2", name)
  local bestRank = ed.getNumberNode({
    text = breakHistory._old_damage,
    folder = "damage",
    padding = 0
  }).node
  bestRank:setAnchorPoint(ccp(0, 0.5))
  local posx, posy = self.pvpui.text_shanhai:getPosition()
  bestRank:setPosition(posx + 40, posy)
  bestRank:setScale(0.9)
  self.pvpui.line_2:addChild(bestRank)
  local lable = richText:new()
  lable:setString(T("<text|guildRankTxt|\228\189\160\231\154\132\228\188\164\229\174\179: ><text|guildRankTxtYellow|%s><text|guildRankTxt| \230\137\147\231\160\180\228\186\134\229\133\168\230\156\141\230\156\128\233\171\152\232\174\176\229\189\149!>", breakHistory._damage))
  lable:setPosition(ccp(30, 70))
  self.pvpui.bg:addChild(lable.rootNode)
  self:btRegisterOutClick({
    area = self.pvpui.bg,
    key = "best_out_click",
    clickHandler = function()
      self.pvpLayer:setVisible(false)
    end,
    force = true
  })
  self.pvpLayer:setVisible(false)
end

function GuildRaidVictoryWin:createProgressBar()
  local ui = self.ui
  local bar, scale = self:createProcessBar("UI/alpha/1080P/raid/progressbar_1.png", ui.bg_progress_bar, CCRectMake(45, 8, 45, 2))
  local raidData = self.param.guildInstanceData
  bar:setScaleX(raidData.oldProgress / ed.GuildRaidConfig.MaxStageProgress * scale)
  bar:runAction(CCScaleTo:create(1.5, raidData.progress / ed.GuildRaidConfig.MaxStageProgress * scale, 1))
  ed.setString(ui.label_exp, "+" .. string.format("%.2f%%", (raidData.progress - raidData.oldProgress) / 100))
end

function GuildRaidVictoryWin:createDamageText()
  local ui = self.ui
  local raidData = self.param.guildInstanceData
  local damageText = ed.getNumberNode({
    text = raidData.damage,
    folder = "raid",
    padding = -1
  }).node
  ui.bg:addChild(damageText)
  ed.right2(damageText, ui.label_damage, 2)
end

function GuildRaidVictoryWin:createRewardText()
  local ui = self.ui
  local raidData = self.param.guildInstanceData
  local rewardText = ed.ui.autoText.new()
  local strs = string.format("<lable color=ccc3(255,252,231) strokeColor=strokeColor1 strokeSize=1>%s</lable><sprite src=UI/alpha/1080P/icon/gold.png scale=0.8>" .. "<lable color=ccc3(255,173,76) strokeColor=strokeColor1 strokeSize=1>%d</lable>", T("\232\142\183\229\190\151\239\188\154"), raidData.gold)
  rewardText:initParam({context = strs, fontSize = 18})
  ui.bg:addChild(rewardText.node)
  ed.right2(rewardText.node, ui.arrow, 80)
end

function GuildRaidVictoryWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.raidBattleVictoryWin)
  self.container:addChild(container)
  self.ui = ui
  self:initLabel()
  self:createProgressBar()
  self:createDamageText()
  self:createRewardText()
  if self.param.breakHistory then
    self:createBestDamageLayer()
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
    end, GuildRaidVictoryScope)
  end
  self:playWinAnim()
end

function GuildRaidVictoryWin:playLightAnim()
  local node = ed.createFcaNode("eff_UI_pvp_light")
  self:addFca(node)
  local x, y = self.ui.light:getPosition()
  node:setPosition(ccp(x, y - 20))
  self.ui.light:setVisible(false)
  self.ui.bg:addChild(node)
  local node = ed.createFcaNode("eff_UI_pve_victory_wings")
  self:addFca(node)
  node:setPosition(ccp(x, y + 24))
  self.ui.bg:addChild(node)
  local node = ed.createFcaNode("eff_UI_pvp_newrecord_particles")
  self:addFca(node)
  node:setPosition(ccp(x, y + 24))
  self.ui.bg:addChild(node)
end

function GuildRaidVictoryWin:playWinAnim()
  self:playLightAnim()
end

function GuildRaidVictoryWin:createProcessBar(res, parentUI, ccRect)
  local size = parentUI:getContentSize()
  local clippingNode = ed.createClippingNodeOnly(res)
  clippingNode:setPosition(ccp(1, size.height / 2))
  local stencil = clippingNode:getStencil()
  stencil:setAnchorPoint(ccp(0, 0.5))
  local barScale = size.width / stencil:getContentSize().width - 0.01
  stencil:setScale(barScale)
  local bar = ed.createSprite(res)
  bar:setScaleX(barScale)
  bar:setAnchorPoint(ccp(0, 0.5))
  clippingNode:addChild(bar)
  parentUI:addChild(clippingNode)
  return stencil, barScale
end

function GuildRaidVictoryWin:initLabel()
  ed.setLabelStroke(self.ui.label_damage, ed.toccc3(16700269), 1)
  ed.setLabelStroke(self.ui.label_progress, ed.toccc3(16700269), 1)
  ed.setLabelStroke(self.ui.label_exp, ed.toccc3(661534), 1)
end

function GuildRaidVictoryWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
    ed.popScene()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_data", function()
    ed.ui.BattleStaticsWin.create(ed.engine.unit_list, "common", true)
  end, {pressScale = 0.9})
end
