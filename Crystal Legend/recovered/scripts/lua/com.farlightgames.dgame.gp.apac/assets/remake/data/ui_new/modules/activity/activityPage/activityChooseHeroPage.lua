local chooseHeroPage = newclass("g")
ed.ui.activityChooseHeroPage = chooseHeroPage

function chooseHeroPage.create(base, param, pageKey)
  local this = {param = param, pageKey = pageKey}
  setmetatable(chooseHeroPage, {__index = base})
  setmetatable(this, {__index = chooseHeroPage})
  this:initView(param)
  this:setButtonClick()
  return this
end

function chooseHeroPage:initView(param)
  local container, ui = ed.editorui(ed.uieditor.activity_choose_hero_page)
  self.ui = ui
  self.container = container
  ui.Label_01:setStroke(ed.toccc3(3084973), 1.2)
  ui.Label_03:setStroke(ed.toccc3(9391616), 1.2)
  ui.Label_001:setStroke(ed.toccc3(3084973), 1.2)
  ui.Label_002:setStroke(ed.toccc3(9391616), 1.2)
  ui.Label_003:setStroke(ed.toccc3(9391616), 1.2)
  ui.Label_time:setStroke(ed.toccc3(3813318), 1.2)
  ui.Label_3280:setStroke(ed.toccc3(3084973), 1.2)
  ui.Label_btn_gift:setStroke(ed.toccc3(2844450), 1.2)
  ui.Label_btn_right:setStroke(ed.toccc3(2844450), 1.2)
  local time = (param._end_time or 0) - ed.getServerTime()
  if time < 86400 then
    self.ui.Label_time:setString(T("\230\180\187\229\138\168\229\183\178\231\187\147\230\157\159"))
  else
    local h, m, s = ed.second2hms(time - 86400)
    local d = math.floor(h / 24)
    local h = h % 24
    self.ui.Label_time:setString(T("\229\137\169\228\189\153 %s", T("%d\229\164\169%d\230\151\182", d, h)))
  end
  self:pageUpDate(param)
end

function chooseHeroPage:createHeroItem(cond_id)
  if self.selectedHeroId then
    return
  end
  self.selectedHeroId = 0
  local requireGroupArr = ed.getDataTable("ActivityRequireGroup")[cond_id]
  local unitTable = ed.getDataTable("Unit")
  local width, tablang = 96, 0
  for _, _ in pairs(requireGroupArr) do
    tablang = tablang + 1
  end
  local posx = tablang * width / 2
  local oldFrame, oldFrameUp
  for i, v in ipairs(requireGroupArr) do
    local bg = ed.createSpriteTools({
      res = "UI/alpha/1080P/activity/bbpick/bbpick_hero_frame_bg.png",
      pos = ccp(i * width - posx - width / 2, 0),
      parent = self.ui.Panel_hero_item,
      scale = 1
    })
    local name
    if v["Param Type"] == "Hero" then
      name = unitTable[v.ID]["Display Name"]
      ed.createSpriteTools({
        res = ed.readequip.getHeroIconRes(v.ID),
        pos = ccp(69.25, 64),
        parent = bg,
        scale = 0.98
      })
    else
      name = ed.readequip.value(v.ID, "Name")
      ed.createSpriteTools({
        res = ed.readequip.value(v.ID, "Icon"),
        pos = ccp(69.25, 64),
        parent = bg,
        scale = 0.98
      })
      ed.createLabelTools({
        txt = v.Target,
        size = 16,
        pos = ccp(100.25, 32),
        color = ccc3(255, 251, 231),
        stroke = {
          ccc3(39, 37, 36),
          1.7
        },
        anchor = ccp(1, 0),
        parent = bg
      })
    end
    local frame = ed.createSpriteTools({
      res = "UI/alpha/1080P/activity/bbpick/bbpick_hero_frame_1.png",
      pos = ccp(69.25, 67),
      parent = bg,
      scale = 1,
      notShow = self.selectedHeroId == v.ID,
      z = 9
    })
    local frameUp = ed.createSpriteTools({
      res = "UI/alpha/1080P/activity/bbpick/bbpick_hero_frame_2.png",
      pos = ccp(69.25, 67),
      parent = bg,
      scale = 1,
      notShow = self.selectedHeroId ~= v.ID,
      z = 9
    })
    frameUp:setScaleX(-1)
    ed.createLabelTools({
      txt = name,
      size = 15,
      pos = ccp(42.5, 47),
      color = ccc3(245, 230, 255),
      parent = ed.createSpriteTools({
        res = "UI/alpha/1080P/activity/bbpick/bbpick_name_unchoose.png",
        pos = ccp(69.25, -12),
        parent = frame
      })
    })
    ed.createLabelTools({
      txt = name,
      size = 15,
      pos = ccp(42.5, 47),
      color = ccc3(246, 255, 255),
      stroke = {
        ccc3(ed.colorToStr("#4581d2")),
        1.3
      },
      parent = ed.createSpriteTools({
        res = "UI/alpha/1080P/activity/bbpick/bbpick_name_choose.png",
        pos = ccp(69.25, -12),
        parent = frameUp
      })
    }):setScaleX(-1)
    if v["Param Type"] == "Hero" then
      if not ed.player.heroes[v.ID] then
        ed.createSpriteTools({
          res = "UI/alpha/1080P/summondestiny/destiny_notown.png",
          pos = ccp(69.25, 87),
          parent = bg
        })
      elseif ed.readhero.checkHeroMaxStar(v.ID) then
        ed.createLabelTools({
          txt = T("\229\183\178\230\187\161\230\152\159"),
          size = 18,
          pos = ccp(34, 12),
          color = ed.toccc3(16775796),
          font = ed.fontBold,
          stroke = {
            ed.toccc3(9978880),
            1.2
          },
          parent = ed.createSpriteTools({
            res = "UI/alpha/1080P/summon/summon_hero_star_max.png",
            pos = ccp(69.25, 85),
            parent = bg,
            scale = 0.75
          })
        })
      end
      local count = ed.readhero.getHeroInitStars(v.ID)
      if ed.player.heroes[v.ID] then
        local hero = ed.player:getHero(v.ID)
        count = hero._stars
      end
      local node = CCNode:create()
      bg:addChild(node)
      for _ = count, 1, -1 do
        ed.createSpriteTools({
          res = "UI/alpha/1080P/hero/hero_star_1.png",
          parent = node,
          scale = 0.5
        })
      end
      local gs = CCSizeMake(13, 13)
      local ps = CCSizeMake(gs.width * count, 13)
      ed.layout.layoutChildrenWithSize(node, ps, ed.layoutType.Grid, {gridSize = gs})
      node:setPosition((138.5 - ps.width) / 2, 33)
    end
    self:btRegisterButtonClick({
      button = bg,
      key = "hero_icon_" .. i,
      force = true,
      pressScale = 0.94,
      clickHandler = function()
        if oldFrame then
          oldFrame:setVisible(true)
          oldFrameUp:setVisible(false)
        end
        if self.selectedHeroId == v.ID then
          local type = ed.itemType(self.selectedHeroId)
          if type == "hero" then
            ed.UITool.openView("heroShowPop", {
              heros = {
                {
                  index = 1,
                  _tid = v.ID,
                  _level = 80
                }
              },
              index = 1
            })
          else
            ed.ui.packageDetailWin.create({
              id = v.ID,
              type = "item"
            }):popWindow()
          end
        end
        frame:setVisible(false)
        frameUp:setVisible(true)
        self.selectedHeroId = v.ID
        self.selectedHeroIndex = v.Index
        self.selectedHeroTarget = v.Target
        oldFrame, oldFrameUp = frame, frameUp
      end,
      centerOffset = ccpAdd(ccp(bg:getPosition()), ccp(-69.25, -67)),
      radius = 40
    })
  end
end

function chooseHeroPage:pageUpDate(param)
  self.param = param
  local task = param._tasks
  local heroData, heroLoginData
  for _, v in ipairs(task) do
    if v._cond_type == "choose_reward" then
      heroData = v
    elseif v._cond_type == "choose_reward_login" then
      heroLoginData = v
    end
  end
  local isCompleted = heroData._progress >= heroData._cond_target
  if not isCompleted then
    self.ui.Panel_hero:setVisible(true)
    self.ui.Panel_gift:setVisible(false)
    self:createHeroItem(heroData._cond_id)
  else
    self.ui.Panel_hero:setVisible(false)
    self.ui.Panel_gift:setVisible(true)
    local reward = heroData._extend._choose_rewards
    local type = reward[1]._type
    local rewardId = reward[1]._id
    local amount = reward[1]._amount
    local fca = ed.createFcaNode("eff_UI_bbpick_light")
    self.ui.Panel_mod:addChild(fca, -1)
    self:addFca(fca)
    fca:setScale(1.2)
    if type == "hero" and not self.puppet then
      local puppet, cha = ed.readhero.getActor(rewardId, "Idle", true, false, nil, false)
      puppet:setPosition(ccp(0, -110))
      self.ui.Panel_mod:addChild(puppet, 10)
      puppet:setScale(1.3)
      self:addFca(puppet)
      self.puppet = puppet
    elseif not self.itemBig then
      self.itemBig = ed.createItemIcon({
        type = "item",
        id = rewardId,
        amount = amount
      })
      self.itemBig:setPosition(ccp(-1, -1))
      self.ui.Panel_mod:addChild(self.itemBig)
      self.itemBig:setScale(1)
      self:btRegisterButtonClick({
        button = self.itemBig,
        key = "itemBig",
        force = true,
        pressScale = 0.94,
        clickInterval = 0.5,
        clickHandler = function()
          ed.ui.packageDetailWin.create({id = rewardId, type = "item"}):popWindow()
        end
      })
    end
    isCompleted = heroLoginData._progress >= heroLoginData._cond_target
    if isCompleted then
      self.ui.ImageView_3258s:setVisible(false)
      self.ui.btn_gift:setVisible(true)
      local isFinished = heroLoginData._cur_reward_times and heroLoginData._cur_reward_times >= heroLoginData._max_reward_times
      if isFinished then
        self.ui.btn_gift:setVisible(false)
        self.ui.Label_3280:setVisible(true)
      end
    end
  end
  self.heroData, self.heroLoginData = heroData, heroLoginData
end

function chooseHeroPage:setButtonClick()
  self:btRegisterButtonClick({
    button = self.ui.btn_right,
    key = "btn_right",
    force = true,
    mcpMode = true,
    pressScale = 0.75,
    normalScale = 0.8,
    clickHandler = function()
      local time = (self.param._end_time or 0) - ed.getServerTime()
      if time < 86400 then
        ed.showToast(T("\230\180\187\229\138\168\229\183\178\231\187\147\230\157\159"))
        return
      end
      if self.selectedHeroId and self.selectedHeroId == 0 then
        ed.showToast(T("\232\175\183\229\133\136\233\128\137\230\139\169\231\164\188\231\137\169"))
        return
      end
      local type, str, name = ed.itemType(self.selectedHeroId), T("\228\184\128\231\187\143\233\128\137\230\139\169\230\151\160\230\179\149\230\155\180\230\148\185\239\188\140\232\175\183\232\176\168\230\133\142\233\128\137\230\139\169\227\128\130")
      if type == "hero" then
        if ed.player.heroes[self.selectedHeroId] then
          local hero = ed.player:getHero(self.selectedHeroId)
          if hero._stars >= 5 then
            str = T("\230\130\168\233\128\137\230\139\169\228\186\134\228\184\128\228\184\170\229\183\178\230\187\161\230\152\159\231\154\132\232\139\177\233\155\132")
          end
        end
        name = ed.getDataTable("Unit")[self.selectedHeroId]["Display Name"]
      else
        name = ed.readequip.value(self.selectedHeroId, "Name")
      end
      ed.UITool.openView("commonDelayRewardPop", {
        autoStr = T("\231\161\174\229\174\154\233\128\137\230\139\169 <lable color=ccc3(255,165,49)>%s</lable> \228\189\156\228\184\186\229\191\131\228\187\170\231\164\188\231\137\169\229\144\151?<br/>\230\152\142\230\151\165\231\153\187\229\189\149\230\151\182\229\143\175\233\162\134\229\143\150!<br/><lable color=ccc3(211,43,46)>%s</lable>", name, str),
        clickHandler = function()
          self.objWork:activityChooseHerSubmit(self.param._id, self.heroData._id, self.selectedHeroIndex, self.selectedHeroId, self.selectedHeroTarget)
        end
      })
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_gift,
    key = "btn_gift",
    force = true,
    mcpMode = true,
    pressScale = 0.75,
    normalScale = 0.8,
    clickInterval = 0.5,
    clickHandler = function()
      self.objWork:activitySubmit(self.param._id, self.heroLoginData._id)
    end
  })
end
