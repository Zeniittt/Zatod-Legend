local base = ed.ui.popwindow
local stageLineupPop = newclass(base.mt)
ed.ui.stageLineupPop = stageLineupPop

function stageLineupPop.create(params)
  local self = base.create("stageLineupPop", {notBlurBg = true})
  setmetatable(self, stageLineupPop.mt)
  self.params = params
  self:initUieditor()
  self:registEvents()
  self:show()
  return self
end

function stageLineupPop:initUieditor()
  local ui = {
    bg = ed.createSpriteTools({
      res = "UI/alpha/1080P/common/com_new_3.png",
      pos = ccp(480, 270),
      rectMake = CCRectMake(25, 25, 2, 2),
      sizeMake = CCSizeMake(600, 350),
      parent = self.container
    })
  }
  self:createDragList(ui.bg)
  local lab = ed.createLabelTools({
    txt = T("\233\128\154\229\133\179\233\152\181\229\174\185\229\143\130\232\128\131"),
    size = 18,
    pos = ccp(300, 322),
    color = ed.toccc3(16113079),
    parent = ui.bg
  })
  local left = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/battle_prepare_lins_3.png",
    pos = ccp(200, 322),
    parent = ui.bg
  })
  local right = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
    pos = ccp(400, 322),
    parent = ui.bg
  })
  ed.left2(left, lab, 5)
  ed.right2(right, lab, 5)
  ui.close = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/break_butt_bj.png",
    pos = ccp(595, 345),
    parent = ui.bg,
    scale = 0.75
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/common/butt_off.png",
    pos = ccp(27, 27),
    parent = ui.close
  })
  ui.norecom = ed.createSpriteTools({
    res = "UI/alpha/1080P/dreamland/dream_prepare_recommend_bg.png",
    pos = ccp(300, 174),
    rectMake = CCRectMake(150, 15, 50, 10),
    sizeMake = CCSizeMake(508, 42),
    parent = ui.bg,
    notShow = true,
    z = 99
  })
  ed.createLabelTools({
    txt = T("\230\149\176\230\141\174\230\173\163\229\156\168\231\187\159\232\174\161\228\184\173\239\188\140\230\154\130\230\151\160\230\142\168\232\141\144\232\139\177\233\155\132"),
    size = 21,
    pos = ccp(254, 21),
    color = ed.toccc3(13484461),
    parent = ui.norecom
  })
  self.ui = ui
end

function stageLineupPop:createDragList(container)
  local thisCon = container:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 5, thisCon.width, thisCon.height - 23 - 24),
    container = container,
    noshade = true,
    priority = -300,
    doPressIn = function(x, y)
      return y
    end,
    cancelPressIn = function(x, y, oldy)
      self.touch = math.abs(oldy - y) < 30
    end
  }
  self.dragList = ed.draglist.create(info)
  self.refreshCliprectConfig = {
    draglist = self.dragList
  }
  self.thisCon = thisCon
end

function stageLineupPop:registEvents()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = false})
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.close,
    key = "close",
    clickHandler = function()
      self:destroy({skipAnim = false})
    end,
    pressScale = 0.85,
    normalScale = 0.8
  })
  self:listenEvent("hh_lineup_recommend_reply", function(info)
    if info._stageid ~= self.params.stageid then
      print(T("hh_lineup_recommend_reply\239\188\154\232\191\148\229\155\158\229\133\179\229\141\161id\228\184\141\228\184\128\232\135\180"))
    end
    self.dragList:clearList()
    local posy = self.thisCon.height - 56 - 37
    table.sort(info._stage_lineups or {}, function(a, b)
      if a._gs == b._gs then
        return a._stars < b._stars
      else
        return a._gs < b._gs
      end
    end)
    for _, v in ipairs(info._stage_lineups or {}) do
      local item = self.itemMode.new(self, v)
      self.dragList:addItem(item.ui.bg, ccp(300, posy))
      posy = posy - 83
    end
    self.dragList:initListHeight(#(info._stage_lineups or {}) * 83 + 10)
    self.ui.norecom:setVisible(#(info._stage_lineups or {}) == 0)
  end)
  ed.HeroRecommendNetwork:sendLineupRecommend(self.params.stageid or 1, self.params.gameplay or "stage")
end

local itemMode = {}

function itemMode.new(popSelf, param)
  return setmetatable({popSelf = popSelf, param = param}, {__index = itemMode}):create()
end

function itemMode:create()
  local ui = {
    bg = ed.createSpriteTools({
      res = "UI/alpha/1080P/campaign/lineup_guide/bg_new2.png"
    })
  }
  local res1, res2 = "UI/alpha/1080P/campaign/main/campaign_stage_star_1.png", "UI/alpha/1080P/campaign/main/campaign_stage_star_3.png"
  ed.createSpriteTools({
    res = self.param._stars >= 1 and res1 or res2,
    pos = ccp(73, 55),
    parent = ui.bg,
    scale = 0.9
  })
  ed.createSpriteTools({
    res = self.param._stars >= 2 and res1 or res2,
    pos = ccp(111, 55),
    parent = ui.bg,
    scale = 0.9
  })
  ed.createSpriteTools({
    res = self.param._stars >= 3 and res1 or res2,
    pos = ccp(149, 55),
    parent = ui.bg,
    scale = 0.9
  })
  ui.gsbg = ed.createSpriteTools({
    res = "UI/alpha/1080P/campaign/lineup_guide/power_bg.png",
    rectMake = CCRectMake(15, 2, 10, 6),
    sizeMake = CCSizeMake(160, 26),
    pos = ccp(108, 21),
    parent = ui.bg
  })
  local teamPower_lab = ed.createLabelTools({
    txt = T("\233\152\159\228\188\141\230\136\152\229\138\155:"),
    size = 15,
    pos = ccp(8, 13),
    color = ed.toccc3(16776423),
    parent = ui.gsbg,
    anchor = ccp(0, 0.5)
  })
  local labSize = teamPower_lab:getContentSize()
  local teamPower = ed.createLabelTools({
    txt = self.param._gs,
    size = 20,
    pos = ccp(80 + labSize.width / 2, 13),
    color = ed.toccc3(16753969),
    parent = ui.gsbg,
    anchor = ccp(0.5, 0.5)
  })
  ed.left2(teamPower_lab, teamPower, 0)
  for i, v in ipairs(self.param._heros or {}) do
    local icon = ed.readhero.createIcon({
      id = v._tid,
      rank = v._rank,
      level = v._level,
      stars = v._stars,
      state = "idle"
    }).icon
    icon:setScale(0.7)
    icon:setPosition(187 + i * 70, 38)
    ui.bg:addChild(icon)
    if not ed.player.heroes[v._tid] then
      local opacity = CCLayerColor:create(ccc4(0, 0, 0, 102))
      opacity:setContentSize(icon:getContentSize())
      icon:addChild(opacity, 999)
      ed.createLabelTools({
        txt = T("\230\156\170\230\139\165\230\156\137"),
        size = 14,
        pos = ccp(35, 35),
        color = ed.toccc3(16740401),
        parent = opacity,
        stroke = {
          ed.toccc3(656398),
          1
        }
      })
    end
  end
  self.ui = ui
  return self
end

stageLineupPop.itemMode = itemMode
