local base = ed.ui.popwindow
local stageChooseLootPop = newclass(base.mt)
ed.ui.stageChooseLootPop = stageChooseLootPop

function stageChooseLootPop.create(params)
  local self = base.create("stageChooseLootPop", {notBlurBg = true})
  setmetatable(self, stageChooseLootPop.mt)
  self.params = params
  self:initUieditor()
  self:registEvents()
  self:show()
  return self
end

function stageChooseLootPop:initUieditor()
  local container, ui = ed.editorui(ed.uieditor.stage_choose_loot_pop)
  self.container:addChild(container)
  self.ui = ui
  self:createDragList()
end

function stageChooseLootPop:createDragList()
  local thisCon = self.ui.Panel_3337:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = self.ui.Panel_3337,
    noshade = true,
    zorder = 10,
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
  local stageItemId
  for _, v in ipairs(ed.player:getStageSelectReward() or {}) do
    if v._stage_id == self.params.eid then
      stageItemId = v._reward_id
      break
    end
  end
  local itemSize = 97
  local posx, posy, Height = 0, thisCon.height, 0
  for i, v in ipairs(ed.getDataTable("Stage")[self.params.eid]["Select Reward"] or {}) do
    local item = self.heroMode.new(self, {id = v})
    self.dragList:addItem(item.headIcon, ccp(posx + itemSize / 2, posy - itemSize / 2))
    if stageItemId == v then
      item:refresh(true)
      self.newPassItem = item
    end
    if i % 5 == 0 then
      posx, posy = 0, posy - (itemSize + 14)
    else
      posx = posx + itemSize
    end
    if i % 5 == 1 then
      Height = Height + (itemSize + 14)
    end
    self:btRegisterButtonClick({
      button = item.headIcon,
      key = "icon_" .. i,
      param = v,
      clickHandler = function(v, x, y)
        if not ed.containsPoint(self.ui.Panel_3337, x, y) then
          return
        end
        if self.touch then
          if self.newPassItem then
            self.newPassItem:refresh(false)
          end
          item:refresh(true)
          self.newPassItem = item
        end
      end,
      pressScale = 0.95,
      normalScale = 1
    })
  end
  self.dragList:initListHeight(Height + 10)
end

local function clickFunc(self, node, click, press, normal, key)
  self:btRegisterButtonClick({
    button = node,
    key = key,
    clickHandler = click,
    force = true,
    pressScale = press or 0.9,
    normalScale = normal or 1,
    clickInterval = 0.2
  })
  local toStr = ""
  for _, v in ipairs(ed.getDataTable("Stage")[self.params.eid]["Select Reward"] or {}) do
    toStr = toStr .. "#" .. v
  end
  ed.storage.setValue(ed.getRoleKey("lootStages" .. self.params.eid), toStr)
  FireEvent("lootStagesNewShow", {
    eid = self.params.eid
  })
end

function stageChooseLootPop:registEvents()
  clickFunc(self, self.ui.btn_close, function()
    ed.playEffect(ed.sound.deo.common_back)
    self:destroy()
  end, 0.65, 0.7, "btn_close")
  clickFunc(self, self.ui.btn_cancel, function()
    ed.playEffect(ed.sound.deo.common_back)
    self:destroy()
  end, 0.95, 1, "btn_cancel")
  clickFunc(self, self.ui.btn_right, function()
    if self.newPassItem then
      local msg = ed.upmsg.select_stage_reward_req()
      msg._stage_id = self.params.eid
      msg._reward_id = self.newPassItem.param.id
      ed.send(msg, "select_stage_reward")
    else
      ed.showToast(T("\232\175\183\233\128\137\228\184\173\231\129\181\233\173\130\231\159\179"))
    end
  end, 0.95, 1, "btn_right")
  self:listenEvent("stageRewardReply", function()
    self:destroy()
  end)
end

local heroMode = {}

function heroMode.new(popSelf, param)
  return setmetatable({popSelf = popSelf, param = param}, {__index = heroMode}):create()
end

function heroMode:create()
  local ui = {}
  local heroid = ed.readhero.getMakeid(self.param.id)
  local head = ed.readhero.createIconByID(heroid, {state = "idle"})
  self.headIcon = head.icon
  local amount = ed.readhero.getStoneAmount(heroid)
  local need = ed.readhero.getStoneNeed(heroid) or amount
  local scale = ed.clamp(amount / need, 0, 1)
  local hero = ed.player.heroes[heroid]
  local txt = hero and hero._stars >= 5 and T("\229\183\178\230\187\161\230\152\159") or T("%d/%d", amount, need)
  self.heroIconUp = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/frame/equip_frame_selected.png",
    pos = ccp(35, 34),
    parent = self.headIcon,
    scale = 1.07,
    z = 98,
    notShow = true
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/package/bg_progress_bar.png",
    pos = ccp(35, -18),
    parent = self.headIcon,
    scale = 1,
    z = 99
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/package/progress_bar1.png",
    pos = ccp(1, -18),
    parent = self.headIcon,
    scale = 1,
    z = 99,
    anchor = ccp(0, 0.5)
  }):setScaleX(scale)
  ed.createSpriteTools({
    res = "UI/alpha/1080P/herolist/icon_stone.png",
    pos = ccp(5, -18),
    parent = self.headIcon,
    scale = 0.75,
    z = 99
  })
  local label_stone = ed.createLabelTools({
    txt = txt,
    size = 14,
    pos = ccp(42, -18),
    color = ccc3(255, 252, 231),
    parent = self.headIcon,
    z = 99
  })
  label_stone:limitWidthByScale(55)
  local info = ed.ui.stageselectres.lootStagesIdToHeroShowNew[self.popSelf.params.eid]
  local isVis = info[self.param.id] and 1 or 0
  ed.createSpriteTools({
    res = "UI/alpha/1080P/summon/hero_new_tag.png",
    pos = ccp(7, 65),
    parent = self.headIcon,
    scale = 1,
    z = 99,
    notShow = isVis ~= 1
  })
  self.ui = ui
  return self
end

function heroMode:refresh(isShow)
  self.heroIconUp:setVisible(isShow)
end

stageChooseLootPop.heroMode = heroMode
