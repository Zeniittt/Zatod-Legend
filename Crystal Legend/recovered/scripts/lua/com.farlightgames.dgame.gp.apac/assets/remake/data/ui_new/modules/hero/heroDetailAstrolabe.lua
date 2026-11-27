local AstrolabeDetail = newclass("g")
local herodetail = ed.ui.heroDetailScene
local res = ed.heroDetailManager.resConfig
herodetail.newAstrolabe = AstrolabeDetail
AstrolabeDetail.labelColors = {
  {
    color = ed.toccc3(9303158),
    stroke = {
      ed.toccc3(1453599),
      1.5
    },
    res = "astrolabe_quality_1"
  },
  {
    color = ed.toccc3(6797817),
    stroke = {
      ed.toccc3(1449265),
      1.5
    },
    res = "astrolabe_quality_2"
  },
  {
    color = ed.toccc3(15570943),
    stroke = {
      ed.toccc3(3873091),
      1.5
    },
    res = "astrolabe_quality_3"
  },
  {
    color = ed.toccc3(16700269),
    stroke = {
      ed.toccc3(3744789),
      1.5
    },
    res = "astrolabe_quality_4"
  },
  {
    color = ed.toccc3(16734039),
    stroke = {
      ed.toccc3(4268829),
      1.5
    },
    res = "astrolabe_quality_1"
  }
}

function AstrolabeDetail.create(param)
  local self = {}
  setmetatable(self, {__index = AstrolabeDetail})
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  return self
end

function AstrolabeDetail:initUI()
  local container, ui = ed.editorui(ed.uieditor.herodetailAstrolabe, {
    ui = self.ui
  })
  self.touchNode = ed.ui.basetouchnode.btCreate()
  self.mainLayer = container
  self.mainLayer:setTouchEnabled(true)
  self.mainLayer:registerScriptTouchHandler(self.touchNode:btGetMainTouchHandler(), false, 0, false)
  self.ui = ui
  self.ui.layer_astrolabe:setPosition(-33, -13)
  self.gsText = ed.getNumberNode({text = 0, folder = "hero_gs"})
  self.ui.ImageView_206:addChild(self.gsText.node)
  self.gsText.node:setPosition(ccp(120, 16))
  self.ui.panel_clip_rect:setClipRect(CCRectMake(0, 0, 450, 350))
  self:adaptUI()
  self:createFca()
  self:refreshUI(true)
end

function AstrolabeDetail:createFca()
  local itemSatr = ed.createFcaNode("eff_UI_astrolabe_idle")
  itemSatr:setLoop(true)
  itemSatr:setLoopAction("Loop")
  itemSatr:setPosition(ccp(173, 175))
  self.ui.Panel_item:addChild(itemSatr, 999)
  self.controller:addFca(itemSatr)
  self.skillUnlock = itemSatr
  self.skillUnlock:setVisible(false)
  local bgStars = {}
  local bgStar = ed.createSpine("effect/eff_UI_astrolabe_star1/eff_UI_astrolabe_star1", 0.5)
  bgStar:setAnimation(0, "Idle", true)
  bgStar:setPosition(ccp(700, 340))
  self.ui.ImageView_bg:addChild(bgStar)
  table.insert(bgStars, bgStar)
  bgStar = ed.createSpine("effect/eff_UI_astrolabe_star1/eff_UI_astrolabe_star1", 0.5)
  bgStar:setAnimation(0, "Idle", true)
  bgStar:setPosition(ccp(185, 150))
  self.ui.ImageView_bg:addChild(bgStar)
  bgStar:setScaleX(-1)
  bgStar:setScaleY(-1)
  table.insert(bgStars, bgStar)
  bgStar = ed.createSpine("effect/eff_UI_astrolabe_star2/eff_UI_astrolabe_star2", 0.4)
  bgStar:setAnimation(0, "Idle", true)
  bgStar:setPosition(ccp(680, 130))
  self.ui.ImageView_bg:addChild(bgStar)
  bgStar:setRotation(90)
  table.insert(bgStars, bgStar)
  bgStar = ed.createSpine("effect/eff_UI_astrolabe_star2/eff_UI_astrolabe_star2", 0.4)
  bgStar:setAnimation(0, "Idle", true)
  bgStar:setPosition(ccp(215, 340))
  self.ui.ImageView_bg:addChild(bgStar)
  table.insert(bgStars, bgStar)
  self.bgStars = bgStars
end

function AstrolabeDetail:initData(param)
  self.controller = param.controller
  self.pos = param.pos
  self:refreshData(param.hero)
end

function AstrolabeDetail:refreshData(data)
  self.hero = data
  if self.hid and self.hid ~= data._tid then
    self.oldAstrolabeStars = nil
    self.unlockIng = false
    if self.equipUnlock then
      self.equipUnlock:stopAllActions()
      self.ui.panel_main:stopAllActions()
    end
  end
  self.upLv = self.hid == data._tid
  self.hid = data._tid
  self.astrolabe = self.hero._astrolabe or {}
  if self.astrolabeProto and self.upLv then
    ed.heroDetailManager.astrolabes[self.hid]._lock_index_list = self.astrolabeProto._lock_index_list
  end
  self.astrolabeProto = ed.heroDetailManager.astrolabes[self.hid]
  if ed.heroDetailManager.astrolabes[self.hid] then
    local lockList = {}
    for i = 1, 5 do
      if ed.storage.getBool(ed.getRoleKey("astrolabeLock_" .. self.hid .. "_" .. i)) then
        table.insert(lockList, i)
      end
    end
    ed.heroDetailManager.astrolabes[self.hid]._lock_index_list = lockList
  end
  if not self.upLv and self.attrFloatingShowLay then
    self.attrFloatingShowLay:stopAllActions()
    self.addAttr = nil
  end
  local oldLv = self.astrolabeData and self.astrolabeData._level or 0
  self.astrolabeData = {
    _level = 1,
    _stars = {},
    _gs = 0
  }
  self.astrolabeData = ed.player.heroes[self.hid].data._astrolabe or self.astrolabeData
  self.upLv = oldLv ~= 0 and oldLv < self.astrolabeData._level and self.upLv
  self.astrolabeInfo = ed.getDataTable("Astrolabe")[self.hid]
  self.oldAstrolabeAttr = self.astrolabeAttr or {}
  self.astrolabeAttr = ed.getDataTable("AstrolabeLevelAttr")[self.astrolabeInfo["Level Group"]][self.astrolabeData._level]
end

function AstrolabeDetail:refreshUI(isNotAct)
  if self.astrolabeProto and self.astrolabeProto._unlock == 1 then
    self.ui.panel_main:setVisible(true)
    if not self.unlockIng then
      self.ui.Panel_unlock:setVisible(false)
    end
    if self.bigIcon then
      self.bigIcon:removeFromParentAndCleanup(true)
      self.bigIcon2:removeFromParentAndCleanup(true)
    end
    self.bigIcon = ed.createSpriteTools({
      res = self.astrolabeInfo["Icon Main"],
      pos = ccp(173, 175),
      parent = self.ui.Panel_item
    })
    self.bigIcon2 = ed.createSpriteTools({
      res = self.astrolabeInfo["Icon Main"],
      pos = ccp(173, 175),
      parent = self.ui.Panel_item
    })
    if self.unlockIng then
      self.bigIcon:setOpacity(255)
      self.bigIcon:runAction(CCFadeIn:create(1.2))
      self.bigIcon2:setOpacity(255)
      self.bigIcon2:runAction(CCFadeIn:create(1.2))
    end
    self.bigIcon2:setOpacity(76.5)
    local blendFunc1 = ccBlendFunc()
    blendFunc1.src = GL_ONE
    blendFunc1.dst = GL_ONE
    self.bigIcon2:setBlendFunc(blendFunc1)
    ed.playBlinkActionV2(self.bigIcon2, 2, 76.5)
    self.skillUnlock:setVisible(self.astrolabeData._level >= 80)
    self:refreshInfo(isNotAct)
    self:refreshConsume()
  else
    self:showUnlock()
  end
end

function AstrolabeDetail:refreshInfo(isNotAct)
  self.ui.Label_name:setString(T("%s\231\154\132\230\152\159\231\155\152", ed.getDataTable("Unit")[self.hid]["Display Name"]))
  self.ui.Label_level:setString(T("\231\173\137\231\186\167 %d", self.astrolabeData._level))
  self.ui.ImageView_max:setVisible(self.astrolabeData._level >= 80)
  self.ui.Label_add_times:setString(T("\228\187\138\230\151\165\229\137\169\228\189\153\229\141\160\230\152\159\230\172\161\230\149\176 %d", self.astrolabeProto._left_times))
  self.ui.btn_add_times:setVisible(self.astrolabeProto._left_times == 0)
  ed.refreshNumberNode(self.gsText, self.astrolabeData._gs or 0)
  self.ui.Label_attr_1:setString(T("\229\138\155\233\135\143 %s", math.floor(self.astrolabeAttr.STR + 0.5)))
  self.ui.Label_attr_2:setString(T("\230\153\186\229\138\155 %s", math.floor(self.astrolabeAttr.INT + 0.5)))
  self.ui.Label_attr_3:setString(T("\230\149\143\230\141\183 %s", math.floor(self.astrolabeAttr.AGI + 0.5)))
  if self.upLv then
    self.ui.Label_attr_1:runAction(CCSequence:create(ccArrayMake(CCEaseBackOut:create(CCScaleTo:create(0.1, 1.3)), CCEaseBackOut:create(CCScaleTo:create(0.2, 1)))))
    self.ui.Label_attr_2:runAction(CCSequence:create(ccArrayMake(CCEaseBackOut:create(CCScaleTo:create(0.1, 1.3)), CCEaseBackOut:create(CCScaleTo:create(0.2, 1)))))
    self.ui.Label_attr_3:runAction(CCSequence:create(ccArrayMake(CCEaseBackOut:create(CCScaleTo:create(0.1, 1.3)), CCEaseBackOut:create(CCScaleTo:create(0.2, 1)))))
  end
  local addAttrs = {
    {
      key = "STR",
      num = self.astrolabeAttr.STR - (self.oldAstrolabeAttr.STR or 0),
      name = T("\229\138\155\233\135\143")
    },
    {
      key = "INT",
      num = self.astrolabeAttr.INT - (self.oldAstrolabeAttr.INT or 0),
      name = T("\230\153\186\229\138\155")
    },
    {
      key = "AGI",
      num = self.astrolabeAttr.AGI - (self.oldAstrolabeAttr.AGI or 0),
      name = T("\230\149\143\230\141\183")
    }
  }
  if self.astrolabeAttr.STR == (self.oldAstrolabeAttr.STR or 0) then
    addAttrs = {}
  end
  if self.attrLayer then
    self.attrLayer:removeAllChildrenWithCleanup(true)
  else
    self.attrLayer = CCLayer:create()
    self.ui.Panel_attr:addChild(self.attrLayer)
  end
  local replaceStars = {}
  for _, v in ipairs(self.astrolabeProto._replace_stars or {}) do
    replaceStars[v._index] = v
  end
  self.replaceStars = {}
  
  local function getColorFunc(v)
    local attrInfo = ed.getDataTable("AstrolabeRandomAttr")[self.astrolabeInfo["Level Group"]][v._id]
    for i = 1, 4 do
      if v._value <= attrInfo["Value Quality " .. i][2] then
        return self.labelColors[i], 4 <= i
      end
    end
    return self.labelColors[5]
  end
  
  local function getPercentage(v)
    local num = v._value / ed.getDataTable("AstrolabeRandomAttr")[self.astrolabeInfo["Level Group"]][v._id]["Max Value"]
    return math.floor(num * 100 + 0.5) .. "%"
  end
  
  local topAttr = 0
  for i = 1, 5 do
    if self.ui["echo_lock_" .. i] then
      self.ui["echo_lock_" .. i]:removeFromParentAndCleanup(true)
      self.ui["echo_lock_" .. i] = nil
    end
    self.astrolabeData._stars = self.astrolabeData._stars or {}
    local v = self.astrolabeData._stars[i]
    if v then
      local moveing = false
      if not isNotAct and self.oldAstrolabeStars and self.oldAstrolabeStars[i] and (self.oldAstrolabeStars[i]._id ~= v._id or self.oldAstrolabeStars[i]._value ~= v._value) then
        local arcanaLight2 = ed.createFcaNode("eff_UI_astrolabe_save_attr")
        arcanaLight2:setPosition(ccp(self.ui["astrolabe_quality_" .. i]:getPosition()))
        self.ui.ImageView_223:addChild(arcanaLight2, 9)
        self.controller:addFcaOnce(arcanaLight2)
        local key = ed.getDataTable("AstrolabeRandomAttr")[self.astrolabeInfo["Level Group"]][v._id]["Attr Type"]
        if self.oldAstrolabeStars[i]._id ~= v._id then
          table.insert(addAttrs, {
            key = key,
            num = v._value,
            name = res.att_cn_name[key]
          })
        else
          table.insert(addAttrs, {
            key = key,
            num = v._value - self.oldAstrolabeStars[i]._value,
            name = res.att_cn_name[key]
          })
        end
        moveing = true
      end
      local colorCfg, top = getColorFunc(v)
      if top then
        topAttr = topAttr + 1
      end
      ed.setTexture(self.ui["astrolabe_quality_" .. i], string.format("UI/alpha/1080P/astrolabe/%s.png", colorCfg.res))
      local name = res.att_cn_name[ed.getDataTable("AstrolabeRandomAttr")[self.astrolabeInfo["Level Group"]][v._id]["Attr Type"]]
      local label = ed.createLabelTools({
        txt = T("%s", name),
        anchor = ccp(0, 0.5),
        size = 15,
        pos = ccp(45, 325 - 50.5 * i),
        color = colorCfg.color,
        stroke = colorCfg.stroke,
        parent = self.attrLayer
      })
      if replaceStars[v._index] or moveing then
        if replaceStars[v._index] then
          table.insert(self.replaceStars, {
            v,
            replaceStars[v._index],
            color = {
              colorCfg.color
            }
          })
        end
        if moveing then
          replaceStars[v._index] = v
          label:runAction(CCSpawn:create(ccArrayMake(CCScaleTo:create(0.2, 0.1), CCFadeOut:create(0.3))))
        end
        label = ed.createLabelTools({
          txt = T("%s (%s)", v._value, getPercentage(v)),
          anchor = ccp(1, 0.5),
          size = 15,
          pos = ccp(230, 325 - 50.5 * i),
          color = colorCfg.color,
          stroke = colorCfg.stroke,
          parent = self.attrLayer
        })
        if moveing then
          label:runAction(CCSpawn:create(ccArrayMake(CCScaleTo:create(0.2, 0.1), CCFadeOut:create(0.3))))
        end
        if not moveing then
          ed.createSpriteTools({
            res = "UI/alpha/1080P/rogue/bless/bless_reinforce_arrow.png",
            pos = ccp(250, 325 - 50.5 * i),
            parent = self.attrLayer,
            scale = 0.6
          })
        end
        local sprite = ed.createSpriteTools({
          res = "UI/alpha/1080P/astrolabe/astrolabe_attr_update.png",
          pos = ccp(360, 325 - 50.5 * i),
          parent = self.attrLayer
        })
        if moveing then
          sprite:runAction(CCSpawn:create(ccArrayMake(CCScaleTo:create(0.2, 0.1), CCFadeOut:create(0.3))))
        else
          local particle1 = CCParticleSystemQuad:create("UI/particle/blend/astrolabe_stars.plist")
          sprite:addChild(particle1, 0)
          particle1:setPosition(ccp(110, 30))
        end
        colorCfg = getColorFunc(replaceStars[v._index])
        name = res.att_cn_name[ed.getDataTable("AstrolabeRandomAttr")[self.astrolabeInfo["Level Group"]][replaceStars[v._index]._id]["Attr Type"]]
        label = ed.createLabelTools({
          txt = T("%s", name),
          anchor = ccp(0, 0.5),
          size = 15,
          pos = ccp(272, 325 - 50.5 * i),
          color = colorCfg.color,
          stroke = colorCfg.stroke,
          parent = self.attrLayer
        })
        if not moveing then
          self.replaceStars[#self.replaceStars].color[2] = colorCfg.color
        end
        if moveing then
          label:runAction(CCSequence:create(ccArrayMake(CCScaleTo:create(0.1, 2), CCMoveTo:create(0.1, ccp(45, 325 - 50.5 * i)), CCScaleTo:create(0.1, 1))))
        end
        label = ed.createLabelTools({
          txt = T("%s (%s)", replaceStars[v._index]._value, getPercentage(replaceStars[v._index])),
          anchor = ccp(1, 0.5),
          size = 15,
          pos = ccp(461, 325 - 50.5 * i),
          color = colorCfg.color,
          stroke = colorCfg.stroke,
          parent = self.attrLayer
        })
        if moveing then
          label:runAction(CCSequence:create(ccArrayMake(CCScaleTo:create(0.01, 0.1), CCScaleTo:create(0.01, 3), CCScaleTo:create(0.2, 1))))
        end
        if not isNotAct and self.oldAstrolabeStars and not moveing then
          local arcanaLight2 = ed.createFcaNode("eff_UI_astrolabe_update_attr")
          arcanaLight2:setPosition(ccp(self.ui["astrolabe_quality_" .. i]:getPosition()))
          self.ui.ImageView_223:addChild(arcanaLight2, 9)
          self.controller:addFcaOnce(arcanaLight2)
        end
      else
        ed.createLabelTools({
          txt = T("%s (%s)", v._value, getPercentage(v)),
          anchor = ccp(1, 0.5),
          size = 15,
          pos = ccp(461, 325 - 50.5 * i),
          color = colorCfg.color,
          stroke = colorCfg.stroke,
          parent = self.attrLayer
        })
        if self.oldAstrolabeStars and not self.oldAstrolabeStars[i] then
          local key = ed.getDataTable("AstrolabeRandomAttr")[self.astrolabeInfo["Level Group"]][v._id]["Attr Type"]
          table.insert(addAttrs, {
            key = key,
            num = v._value,
            name = res.att_cn_name[key]
          })
          local arcanaLight2 = ed.createFcaNode("eff_UI_astrolabe_update_attr")
          arcanaLight2:setPosition(ccp(self.ui["astrolabe_quality_" .. i]:getPosition()))
          self.ui.ImageView_223:addChild(arcanaLight2, 9)
          self.controller:addFcaOnce(arcanaLight2)
        end
      end
      local isLock = ed.isElementInTable(v._index, self.astrolabeProto._lock_index_list or {})
      local lockBtn = ed.createSpriteTools({
        res = string.format("UI/alpha/1080P/astrolabe/astrolabe_attr_lock_%d.png", isLock and 2 or 1),
        pos = ccp(488, 325 - 50.5 * i),
        parent = self.attrLayer
      })
      ed.createSpriteTools({
        res = string.format("UI/alpha/1080P/astrolabe/astrolabe_lock_%d.png", isLock and 2 or 1),
        pos = ccp(20.5, 16),
        parent = lockBtn
      })
      self.controller:btRemoveMainTouchHandler({
        key = "lockBtn" .. i
      })
      self.controller:btRegisterButtonClick({
        button = lockBtn,
        key = "lockBtn" .. i,
        force = true,
        mcpMode = true,
        pressScale = 0.95,
        normalScale = 1,
        clickInterval = 0.1,
        clickHandler = function()
          self.astrolabeProto._lock_index_list = self.astrolabeProto._lock_index_list or {}
          local isLock = not ed.isElementInTable(v._index, self.astrolabeProto._lock_index_list or {})
          if isLock and #self.astrolabeProto._lock_index_list >= 4 then
            return ed.showToast(T("\230\156\128\229\164\154\229\143\170\232\131\189\233\148\129\229\174\1544\230\157\161\229\177\158\230\128\167"))
          end
          for _, vv in ipairs(self.astrolabeProto._replace_stars or {}) do
            if vv._index == v._index then
              return ed.showToast(T("\232\175\183\231\161\174\232\174\164\230\152\175\229\144\166\228\191\157\229\173\152\239\188\140\229\134\141\232\191\155\232\161\140\233\148\129\229\174\154"))
            end
          end
          lockBtn:removeAllChildrenWithCleanup(true)
          ed.setTexture(lockBtn, string.format("UI/alpha/1080P/astrolabe/astrolabe_attr_lock_%d.png", isLock and 2 or 1))
          ed.createSpriteTools({
            res = string.format("UI/alpha/1080P/astrolabe/astrolabe_lock_%d.png", isLock and 2 or 1),
            pos = ccp(20.5, 16),
            parent = lockBtn
          })
          if isLock then
            table.insert(self.astrolabeProto._lock_index_list, v._index)
          else
            for ii, vv in ipairs(self.astrolabeProto._lock_index_list or {}) do
              if vv == v._index then
                table.remove(self.astrolabeProto._lock_index_list, ii)
                break
              end
            end
          end
          ed.storage.setValue(ed.getRoleKey("astrolabeLock_" .. self.hid .. "_" .. v._index), isLock)
          self:refreshConsume()
        end
      })
      ed.resetSpriteShader(self.ui["astrolabe_quality_" .. i])
    else
      ed.setSpriteGray(self.ui["astrolabe_quality_" .. i])
      self.ui["echo_lock_" .. i] = ed.createSpriteTools({
        res = "UI/alpha/1080P/rogue/instance/instance_echo_lock.png",
        pos = ccp(self.ui["astrolabe_quality_" .. i]:getPosition()),
        scale = 0.6,
        parent = self.ui.ImageView_223
      })
      ed.createSpriteTools({
        res = string.format("UI/alpha/1080P/astrolabe/astrolabe_attr_lock_%d.png", 1),
        pos = ccp(488, 325 - 50.5 * i),
        parent = self.attrLayer
      })
      ed.createLabelTools({
        txt = T("\230\156\170\231\159\165 (\230\152\159\231\155\152\231\173\137\231\186\167\232\190\190\229\136\176%s\231\186\167\232\167\163\233\148\129)", self.astrolabeInfo["Rank " .. i .. " Level"]),
        anchor = ccp(0, 0.5),
        size = 15,
        pos = ccp(45, 325 - 50.5 * i),
        color = ed.toccc3(13226719),
        stroke = {
          ed.toccc3(1907497),
          1.5
        },
        parent = self.attrLayer
      })
    end
  end
  if not isNotAct and 0 < #addAttrs then
    self:addAttrFloatingShow(addAttrs)
  end
  self.oldAstrolabeStars = self.astrolabeData._stars
end

function AstrolabeDetail:showUnlock()
  self.ui.Label_name_2:setString(T("%s\231\154\132\230\152\159\231\155\152", ed.getDataTable("Unit")[self.hid]["Display Name"]))
  self.ui.panel_main:setVisible(false)
  self.ui.Panel_unlock:setVisible(true)
  self.ui.Label_163:setOpacity(255)
  for i = 1, 3 do
    self.ui["ImageView_" .. 158 + i]:stopAllActions()
    self.ui["ImageView_" .. 158 + i]:setOpacity(255)
  end
  if self.unLockIcon then
    self.unLockIcon:removeFromParentAndCleanup(true)
    self.unLockIcon = nil
  end
  self.ui.Label_name_2:setOpacity(255)
  self.ui.ImageView_title:setOpacity(255)
  self.ui.ImageView_168:setOpacity(255)
  for _, v in ipairs(self.bgStars or {}) do
    v:setOpacity(255)
  end
  if self.equipUnlock then
    self.equipUnlock:removeFromParentAndCleanup(true)
    self.equipUnlock_2:removeFromParentAndCleanup(true)
    self.iconLock:removeFromParentAndCleanup(true)
    self.equipUnlock = nil
    self.equipUnlock_2 = nil
  end
  self.ui.ImageView_204:setVisible(true)
  self.ui.ImageView_btn:setOpacity(255)
  local fixWidth = (ed.display.winSize.width - 960) * 0.66
  self.ui.ImageView_btn:setPosition(470 + fixWidth / 2, 264)
  self.ui.ImageView_bg:setOpacity(255)
  local particle1 = CCParticleSystemQuad:create("UI/particle/astrolabe_bg_stars.plist")
  self.ui.ImageView_bg:addChild(particle1)
  particle1:setPosition(ccp(431, 234.5))
  self.ui.ImageView_159:runAction(CCRepeatForever:create(CCRotateBy:create(50, 360)))
  self.ui.ImageView_160:runAction(CCRepeatForever:create(CCRotateBy:create(40, -360)))
  if not self.equipUnlock then
    self.iconLock = ed.createSpriteTools({
      res = self.astrolabeInfo["Icon Lock"],
      pos = ccp(163.9, 176),
      parent = self.ui.ImageView_btn
    })
    local fixWidth = (ed.display.winSize.width - 960) * 0.66
    local size = self.ui.ImageView_bg:getContentSize()
    local clipLayer = CCLayer:create()
    self.ui.ImageView_bg:addChild(clipLayer, 999)
    clipLayer:setClipRect(CCRectMake(0, 8, size.width, size.height - 10))
    local equipUnlock = ed.createSpine("effect/eff_UI_Shard_astrolabe/eff_UI_Shard_astrolabe", 1)
    equipUnlock:setAnimation(0, "Idle", true)
    equipUnlock:setPosition(ccp(161, 177))
    self.ui.ImageView_btn:addChild(equipUnlock, 8)
    self.equipUnlock_2 = equipUnlock
    equipUnlock = ed.createSpine("effect/eff_UI_Shard_astrolabe_b/eff_UI_Shard_astrolabe_b", 1)
    equipUnlock:setAnimation(0, "Idle", true)
    equipUnlock:setPosition(ccp(435 + fixWidth / 2 + 7, 241.5))
    clipLayer:addChild(equipUnlock, 999)
    self.equipUnlock = equipUnlock
  end
end

function AstrolabeDetail:refreshConsume()
  self.ui.ImageView_cost_1:removeAllChildrenWithCleanup(true)
  self.ui.ImageView_cost_2:removeAllChildrenWithCleanup(true)
  self.ui.ImageView_cost_3:removeAllChildrenWithCleanup(true)
  local icon = ed.createItemIcon({
    type = "item",
    id = self.astrolabeInfo["Pray Cost Item ID"],
    amount = self.astrolabeInfo["Pray Cost Item Amount"]
  })
  icon:setPosition(-15, 10)
  icon:setScale(0.35)
  self.ui.ImageView_cost_1:addChild(icon)
  local color = self.astrolabeInfo["Pray Cost Item Amount"] <= (ed.player.equip_qunty[self.astrolabeInfo["Pray Cost Item ID"]] or 0) and ed.toccc3(9303158) or ed.toccc3(16739436)
  ed.createLabelTools({
    txt = T("%d/%d", self.astrolabeInfo["Pray Cost Item Amount"], ed.player.equip_qunty[self.astrolabeInfo["Pray Cost Item ID"]] or 0),
    anchor = ccp(0.5, 0.5),
    size = 14,
    pos = ccp(48.25, 10),
    color = color,
    stroke = {
      ed.toccc3(1907497),
      1.5
    },
    parent = self.ui.ImageView_cost_1
  })
  self.controller:btRemoveMainTouchHandler({
    key = "itemShowAstrolabePray"
  })
  self.controller:btRegisterButtonClick({
    button = icon,
    key = "itemShowAstrolabePray",
    pressScale = 0.4,
    normalScale = 0.35,
    clickInterval = 0.1,
    clickHandler = function()
      ed.UITool.openView("packageDetail", {
        type = "item",
        id = self.astrolabeInfo["Pray Cost Item ID"]
      })
    end
  })
  local icon = ed.createItemIcon({
    type = "gold",
    id = nil,
    amount = 1
  })
  icon:setPosition(-15, 10)
  icon:setScale(0.35)
  self.ui.ImageView_cost_2:addChild(icon)
  local color = self.astrolabeInfo["Pray Cost Gold"] <= ed.player:getPoint("gold") and ed.toccc3(9303158) or ed.toccc3(16739436)
  local gold = ed.player:getPoint("gold")
  gold = 1000000 <= gold and math.floor(gold / 10000) .. T("\228\184\135") or gold
  ed.createLabelTools({
    txt = T("%d/%s", self.astrolabeInfo["Pray Cost Gold"], gold),
    anchor = ccp(0.5, 0.5),
    size = 14,
    pos = ccp(48.25, 10),
    color = color,
    stroke = {
      ed.toccc3(1907497),
      1.5
    },
    parent = self.ui.ImageView_cost_2
  })
  self.controller:btRemoveMainTouchHandler({
    key = "itemShowAstrolabeGold"
  })
  self.controller:btRegisterButtonClick({
    button = icon,
    key = "itemShowAstrolabeGold",
    pressScale = 0.4,
    normalScale = 0.35,
    clickInterval = 0.1,
    clickHandler = function()
      ed.UITool.openView("packageDetail", {
        type = "gold",
        id = nil,
        amount = 1
      })
    end
  })
  local icon = ed.createItemIcon({
    type = "item",
    id = self.astrolabeInfo["Lock Cost Item ID"],
    amount = 1
  })
  icon:setPosition(-15, 10)
  icon:setScale(0.35)
  self.ui.ImageView_cost_3:addChild(icon)
  self.ui.ImageView_cost_3:setVisible(true)
  local index = 0
  if 10 <= self.astrolabeData._level then
    for _, _ in pairs(self.astrolabeProto._lock_index_list or {}) do
      index = index + 1
    end
    if index == 0 then
      self.lockAmount = 0
    else
      self.lockAmount = self.astrolabeInfo["Lock Cost Item Amount"][4 < index and 4 or index] or 1
    end
  else
    self.lockAmount = 0
  end
  self.ui.ImageView_cost_3:setVisible(0 < self.lockAmount)
  if 0 < self.lockAmount then
    local color = self.lockAmount <= (ed.player.equip_qunty[self.astrolabeInfo["Lock Cost Item ID"]] or 0) and ed.toccc3(9303158) or ed.toccc3(16739436)
    ed.createLabelTools({
      txt = T("%d/%d", self.lockAmount, ed.player.equip_qunty[self.astrolabeInfo["Lock Cost Item ID"]] or 0),
      anchor = ccp(0.5, 0.5),
      size = 14,
      pos = ccp(48.25, 10),
      color = color,
      stroke = {
        ed.toccc3(1907497),
        1.5
      },
      parent = self.ui.ImageView_cost_3
    })
    self.controller:btRemoveMainTouchHandler({
      key = "LockiconAstrolabe"
    })
    self.controller:btRegisterButtonClick({
      button = icon,
      key = "LockiconAstrolabe",
      pressScale = 0.4,
      normalScale = 0.35,
      clickInterval = 0.1,
      clickHandler = function()
        local buyResourceBox = ed.ui.buyResourceBox.create({
          buyLimitNum = 999,
          defaultBuyNum = 1,
          goodsResType = ed.ui.configs.resType.getResType("item"),
          goodsId = self.astrolabeInfo["Lock Cost Item ID"],
          costResType = ed.ui.configs.resType.getResType("diamond"),
          price = self.astrolabeInfo["Lock Cost Item Value"],
          buyAction = function(num)
            self.network.sendBuyStoneMsg(self.hid, num)
          end
        })
        buyResourceBox:popWindow()
        buyResourceBox.ui.text_buy_num_limit:setVisible(false)
      end
    })
  end
  index = 0
  for _, _ in pairs(self.astrolabeProto._replace_stars or {}) do
    index = index + 1
  end
  self.ui.btn_save:setVisible(0 < index)
  self.ui.btn_dalete:setVisible(0 < index)
end

function AstrolabeDetail:isContainOrangeStar(stars)
  local function isOrange(v)
    local attrInfo = ed.getDataTable("AstrolabeRandomAttr")[self.astrolabeInfo["Level Group"]][v._id]
    
    for i = 1, 4 do
      if v._value <= attrInfo["Value Quality " .. i][2] then
        return 4 <= i
      end
    end
    return false
  end
  
  for k, v in ipairs(stars or {}) do
    if isOrange(v) then
      return true
    end
  end
  return false
end

function AstrolabeDetail:registerTouchHandlers(level)
  self.controller:listenEvent("AstrolabePray", function(reply)
    self:refreshData(ed.player.heroes[self.hid])
    self:refreshUI()
    ed.record:refreshCommonRecord("AstrolabePray", 1)
  end)
  self.controller:listenEvent("AstrolabeUnlock", function(reply)
    self:refreshData(ed.player.heroes[self.hid])
    self:refreshUI(true)
  end)
  self.controller:listenEvent("AstrolabeConfirm", function(reply)
    self:refreshData(ed.player.heroes[self.hid])
    self:refreshUI()
  end)
  self.controller:listenEvent("AstrolabeBuyTime", function(reply)
    self:refreshData(ed.player.heroes[self.hid])
    self:refreshUI(true)
  end)
  self.controller:listenEvent("AstrolabeBuyStone", function(reply)
    self:refreshData(ed.player.heroes[self.hid])
    self:refreshUI(true)
  end)
  
  function self.localBtRegisterButtonClick(name, clickHandler, pressScale, clickInterval)
    self.controller:btRegisterButtonClick({
      button = self.ui[name],
      key = name,
      pressScale = pressScale or 0.95,
      clickInterval = clickInterval or 0.1,
      clickHandler = function()
        clickHandler(self)
      end
    })
  end
  
  self.localBtRegisterButtonClick("btn_upgrade", self.upgradeClickHandler)
  self.localBtRegisterButtonClick("btn_save", self.saveClickHandler)
  self.localBtRegisterButtonClick("btn_dalete", self.daleteClickHandler)
  self.localBtRegisterButtonClick("ImageView_btn", self.unlockeClickHandler, 1, 0.5)
  self.localBtRegisterButtonClick("btn_add_times", self.addTimesClickHandler)
  self.localBtRegisterButtonClick("ImageView_what", self.rulePopClickHandler)
end

function AstrolabeDetail:addAttrFloatingShow(addAttr)
  if not self.attrFloatingShowLay then
    local layer = CCLayer:create()
    layer:setPosition(ccp(170, 180))
    self.ui.Panel_item:addChild(layer, 999)
    self.attrFloatingShowLay = layer
  end
  if self.addAttr then
    for i, v in ipairs(addAttr) do
      table.insert(self.addAttr, v)
    end
    return
  else
    self.addAttr = addAttr
  end
  local idx = 1
  
  local function addShow()
    local attrStr = self.addAttr[idx]
    if attrStr then
      self.attrFloatingShowLay:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.3), CCCallFunc:create(function()
        local num = attrStr.num > 0 and "+" .. attrStr.num or attrStr.num
        local txt = ed.createttf(attrStr.name .. num, 18)
        txt:setColor(ed.toccc3(7405396))
        ed.setLabelStroke(txt, ed.toccc3(1519903), 2)
        txt:setPosition(ccp(0, 10))
        self.attrFloatingShowLay:addChild(txt)
        local act1 = CCMoveTo:create(0.5, ccp(0, 35))
        local act2 = CCFadeOut:create(0.1)
        local act3 = CCCallFunc:create(function()
          txt:removeFromParentAndCleanup(true)
        end)
        txt:runAction(ed.readaction.create({
          t = "seq",
          act1,
          act2,
          act3
        }))
        idx = idx + 1
        addShow()
      end))))
    else
      self.addAttr = nil
    end
  end
  
  addShow()
end

function AstrolabeDetail:adaptUI()
  local fixWidth = (ed.display.winSize.width - 960) * 0.66
  self.ui.bg:setContentSize(CCSizeMake(self.ui.bg:getContentSize().width + fixWidth, self.ui.bg:getContentSize().height))
  self.ui.bg:setPositionX(self.ui.bg:getPositionX() + fixWidth / 2)
  self.ui.main_title:setPositionX(self.ui.main_title:getPositionX() + fixWidth / 2)
  self.ui.main_level:setPositionX(self.ui.main_level:getPositionX() + fixWidth / 2)
  self.ui.Panel_item:setPositionX(self.ui.Panel_item:getPositionX() + fixWidth / 2)
  self.ui.Panel_attr:setPositionX(self.ui.Panel_attr:getPositionX() + fixWidth / 2)
  self.ui.Panel_count:setPositionX(self.ui.Panel_count:getPositionX() + fixWidth / 2)
  self.ui.Panel_cost:setPositionX(self.ui.Panel_cost:getPositionX() + fixWidth / 2)
  self.ui.ImageView_bg:setContentSize(CCSizeMake(self.ui.ImageView_bg:getContentSize().width + fixWidth, self.ui.ImageView_bg:getContentSize().height))
  self.ui.ImageView_bg:setPositionX(self.ui.ImageView_bg:getPositionX() + fixWidth / 2)
  self.ui.ImageView_btn:setPositionX(self.ui.ImageView_btn:getPositionX() + fixWidth / 2)
  self.ui.ImageView_title:setPositionX(self.ui.ImageView_title:getPositionX() + fixWidth / 2)
  self.fiveItemsFca = self.ui.ImageView_245
  self.ui.ImageView_245:setVisible(false)
  ed.setLabelStroke(self.ui.Label_163, ed.toccc3(8146078), 1)
  ed.setLabelStroke(self.ui.Label_add_times, ed.toccc3(1907497), 1)
  ed.setLabelStroke(self.ui.Label_name, ed.toccc3(3744789), 1)
  ed.setLabelStroke(self.ui.Label_level, ed.toccc3(3744789), 1)
  ed.setLabelStroke(self.ui.Label_attr_1, ed.toccc3(3744789), 1)
  ed.setLabelStroke(self.ui.Label_attr_2, ed.toccc3(3744789), 1)
  ed.setLabelStroke(self.ui.Label_attr_3, ed.toccc3(3744789), 1)
  self.ui.Label_max:setFontName(ed.fontBold)
end

function AstrolabeDetail:upgradeClickHandler()
  ed.playEffect(ed.sound.deo.common_click_feedback)
  local count = ed.player.equip_qunty[self.astrolabeInfo["Lock Cost Item ID"]] or 0
  if self.lockAmount and count < self.lockAmount then
    local buyResourceBox = ed.ui.buyResourceBox.create({
      buyLimitNum = 999,
      defaultBuyNum = self.lockAmount - count,
      goodsResType = ed.ui.configs.resType.getResType("item"),
      goodsId = self.astrolabeInfo["Lock Cost Item ID"],
      costResType = ed.ui.configs.resType.getResType("diamond"),
      price = self.astrolabeInfo["Lock Cost Item Value"],
      buyAction = function(num)
        self.network.sendBuyStoneMsg(self.hid, num)
      end
    })
    buyResourceBox:popWindow()
    buyResourceBox.ui.text_buy_num_limit:setVisible(false)
    return
  end
  count = ed.player.equip_qunty[self.astrolabeInfo["Pray Cost Item ID"]] or 0
  if count < self.astrolabeInfo["Pray Cost Item Amount"] then
    ed.showToast(T("%s\228\184\141\232\182\179", ed.getEquipNameWithId(self.astrolabeInfo["Pray Cost Item ID"])))
    return
  end
  if self.astrolabeInfo["Pray Cost Gold"] > ed.player:getPoint("gold") then
    ed.showToast(T("%s\228\184\141\232\182\179", "\233\135\145\229\184\129"))
    return
  end
  if 0 >= self.astrolabeProto._left_times then
    if self.astrolabeProto._buy_times >= 4 then
      ed.showToast(T("\229\141\160\230\152\159\230\172\161\230\149\176\228\184\141\232\182\179"))
      return
    end
    local cost = ed.clamp(self.astrolabeProto._buy_times + 1, 1, 4)
    local info = ed.getDataTable("AstrolabePrayPurchase")[cost]
    ed.showConfirmDialog({
      autoText = T("\230\152\175\229\144\166\228\189\191\231\148\168%d<sprite src=UI/alpha/1080P/icon/diamond.png>\232\180\173\228\185\176%d\230\172\161\239\188\159", info["Purchase Cost"], info["Add Pray Times"]),
      rightHandler = function()
        self.network.sendBuyTimeMsg(self.hid)
      end
    })
    return
  end
  if self.astrolabeProto._replace_gs and self.astrolabeProto._replace_gs > self.astrolabeData._gs or self:isContainOrangeStar(self.astrolabeProto._replace_stars) then
    ed.ui.astrolabeAttDiffWin.create({
      preData = self.astrolabeData,
      data = self.astrolabeProto,
      rightHandler = function()
        self.network.sendConfirmMsg(self.hid)
      end,
      middleHandler = function()
        self.network.sendClearCacheMsg(self.hid)
      end,
      levelGroup = self.astrolabeInfo["Level Group"]
    })
  else
    self.network.sendPrayMsg(self.hid, self.astrolabeProto._lock_index_list)
  end
end

function AstrolabeDetail:unlockeClickHandler()
  ed.playEffect(ed.sound.deo.common_click_feedback)
  local cfg = ed.heroDetailManager.AstrolabeOpenConfig
  local rank_info = ed.heroDetailManager.resConfig.equip_rank_info[cfg.rank]
  if self.hero._rank < cfg.rank or self.hero._level < cfg.level then
    return ed.showToast(T("\232\139\177\233\155\132\231\173\137\231\186\167%d\231\186\167\239\188\140%s\229\147\129\233\152\182\228\187\165\228\184\138\232\167\163\233\148\129", cfg.level, rank_info.name))
  end
  if self.unlockIng then
    return
  end
  local fixWidth = (ed.display.winSize.width - 960) * 0.66
  self.unlockIng = true
  self.equipUnlock:setAnimation(0, "Idle2", false)
  self.equipUnlock_2:setAnimation(0, "Idle2", false)
  self.ui.Label_163:runAction(CCFadeOut:create(0.5))
  for i = 1, 3 do
    self.ui["ImageView_" .. 158 + i]:runAction(CCFadeOut:create(2))
  end
  self.unLockIcon = ed.createSpriteTools({
    res = self.astrolabeInfo["Icon Main"],
    pos = ccp(163.9, 176),
    parent = self.ui.ImageView_btn,
    opacity = 1
  })
  self.unLockIcon:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(1.7), CCFadeIn:create(1.5), CCFadeOut:create(2.2))))
  self.equipUnlock:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(2.9), CCCallFunc:create(function()
    self.network.sendUnlockeMsg(self.hid)
    self.ui.Label_name_2:runAction(CCFadeOut:create(0.5))
    self.ui.ImageView_title:runAction(CCFadeOut:create(0.5))
    self.iconLock:runAction(CCFadeOut:create(0.5))
    self.ui.ImageView_168:runAction(CCFadeOut:create(0.5))
    for i, v in ipairs(self.bgStars) do
      v:runAction(CCFadeOut:create(0.5))
    end
    self.equipUnlock:setVisible(false)
    self.ui.ImageView_204:setVisible(false)
    self.ui.ImageView_btn:runAction(CCEaseExponentialOut:create(CCMoveTo:create(1.3, ccp(214.5 + fixWidth / 2 + 0.3, 264.1))))
    self.ui.panel_main:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.95), CCCallFunc:create(function()
      self.ui.panel_main:setVisible(true)
      self.ui.ImageView_btn:runAction(CCFadeOut:create(0.5))
      self.ui.ImageView_bg:runAction(CCSequence:create(ccArrayMake(CCFadeOut:create(0.5), CCCallFunc:create(function()
        self.ui.Panel_unlock:setVisible(false)
        self.unlockIng = false
      end))))
      self.ui.ImageView_204:setVisible(true)
    end)))
  end))))
end

function AstrolabeDetail:saveClickHandler()
  ed.playEffect(ed.sound.deo.common_click_feedback)
  local index = 0
  for _, _ in pairs(self.astrolabeProto._replace_stars or {}) do
    index = index + 1
  end
  if 0 < index then
    if self.astrolabeProto._replace_gs and self.astrolabeProto._replace_gs < self.astrolabeData._gs then
      ed.ui.astrolabeAttDiffWin.create({
        preData = self.astrolabeData,
        data = self.astrolabeProto,
        rightHandler = function()
          self.network.sendConfirmMsg(self.hid)
        end,
        levelGroup = self.astrolabeInfo["Level Group"]
      })
    else
      self.network.sendConfirmMsg(self.hid)
    end
  else
    ed.showToast(T("\230\178\161\230\156\137\229\143\175\228\191\157\229\173\152\231\154\132\229\177\158\230\128\167"))
  end
end

function AstrolabeDetail:daleteClickHandler()
  ed.playEffect(ed.sound.deo.common_click_feedback)
  if self.astrolabeProto._replace_gs and self.astrolabeProto._replace_gs > self.astrolabeData._gs or self:isContainOrangeStar(self.astrolabeProto._replace_stars) then
    ed.ui.astrolabeAttDiffWin.create({
      preData = self.astrolabeData,
      data = self.astrolabeProto,
      rightHandler = function()
        self.network.sendClearCacheMsg(self.hid)
      end,
      type = 2,
      isContainOrange = self:isContainOrangeStar(self.astrolabeProto._replace_stars),
      levelGroup = self.astrolabeInfo["Level Group"]
    })
  else
    self.network.sendClearCacheMsg(self.hid)
  end
end

function AstrolabeDetail:addTimesClickHandler()
  ed.playEffect(ed.sound.deo.common_click_feedback)
  if self.astrolabeProto._buy_times >= 4 then
    return ed.showToast(T("\228\187\138\230\151\165\229\183\178\230\151\160\232\180\173\228\185\176\230\172\161\230\149\176"))
  end
  if self.astrolabeProto._left_times >= 26 then
    return ed.showToast(T("\229\189\147\229\137\141\229\137\169\228\189\153\230\172\161\230\149\176\229\183\178\231\187\143\232\182\179\229\164\159\239\188\140\232\175\183\230\182\136\232\128\151\228\184\128\228\186\155\229\144\167"))
  end
  local cost = ed.clamp(self.astrolabeProto._buy_times + 1, 1, 4)
  local info = ed.getDataTable("AstrolabePrayPurchase")[cost]
  ed.showConfirmDialog({
    autoText = T("\230\152\175\229\144\166\228\189\191\231\148\168%d<sprite src=UI/alpha/1080P/icon/diamond.png>\232\180\173\228\185\176%d\230\172\161\239\188\159\228\187\138\230\151\165\233\153\144\232\180\173\239\188\154%d/%d", info["Purchase Cost"], info["Add Pray Times"], self.astrolabeProto._buy_times, 4),
    rightHandler = function()
      self.network.sendBuyTimeMsg(self.hid)
    end
  })
end

function AstrolabeDetail:rulePopClickHandler()
  ed.playEffect(ed.sound.deo.common_click_feedback)
  local allAttr = {}
  for i, v in pairs(ed.getDataTable("AstrolabeLevelAttr")[self.astrolabeInfo["Level Group"]]) do
    allAttr[v.Level] = {
      {
        num = v.STR,
        key = "STR",
        name = T("\229\138\155\233\135\143")
      },
      {
        num = v.INT,
        key = "INT",
        name = T("\230\153\186\229\138\155")
      },
      {
        num = v.AGI,
        key = "AGI",
        name = T("\230\149\143\230\141\183")
      }
    }
  end
  ed.UITool.openView("heroDetailAstrolabeRulePop", {
    hero = {
      hid = self.hid,
      level = self.astrolabeData._level
    },
    allAttrs = allAttr,
    hid = self.hid,
    astrolabe = self.astrolabe,
    astrolabeData = self.astrolabeData,
    astrolabeProto = self.astrolabeProto
  })
end

local network = {}
AstrolabeDetail.network = network

function network.sendUnlockeMsg(hid)
  local msg = ed.upmsg.astrolabe_req()
  msg._unlock = ed.upmsg.astrolabe_unlock()
  ed.heroDetailManager.unlockAstroID = hid
  msg._unlock._hero_id = hid
  ed.send(msg, "astrolabe")
end

function network.sendPrayMsg(hid, lockList)
  local msg = ed.upmsg.astrolabe_req()
  msg._pray = ed.upmsg.astrolabe_pray()
  msg._pray._hero_id = hid
  msg._pray._lock_index_list = lockList or {}
  ed.send(msg, "astrolabe")
end

function network.sendConfirmMsg(hid)
  local msg = ed.upmsg.astrolabe_req()
  msg._confirm = ed.upmsg.astrolabe_confirm()
  msg._confirm._hero_id = hid
  ed.send(msg, "astrolabe")
end

function network.sendClearCacheMsg(hid)
  local msg = ed.upmsg.astrolabe_req()
  msg._clear_cache = ed.upmsg.astrolabe_clear_cache()
  msg._clear_cache._hero_id = hid
  ed.send(msg, "astrolabe")
end

function network.sendBuyTimeMsg(hid)
  local msg = ed.upmsg.astrolabe_req()
  msg._buy_times = ed.upmsg.astrolabe_buy_times()
  msg._buy_times._hero_id = hid
  ed.send(msg, "astrolabe")
end

function network.sendBuyStoneMsg(hid, time)
  local msg = ed.upmsg.astrolabe_req()
  msg._buy_stone = ed.upmsg.astrolabe_buy_stone()
  msg._buy_stone._hero_id = hid
  msg._buy_stone._buy_times = time
  ed.send(msg, "astrolabe")
end
