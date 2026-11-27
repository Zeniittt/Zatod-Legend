local base = ed.ui.popwindow
local checkOthersHeroWindow = newclass(base.mt)
ed.ui.checkOthersHeroWindow = checkOthersHeroWindow

function checkOthersHeroWindow.create(param)
  local self = base.create("checkOthersHeroWindow")
  setmetatable(self, checkOthersHeroWindow.mt)
  checkOthersHeroWindow.eventScope = {}
  self:init(param)
  return self
end

function checkOthersHeroWindow:init(param)
  self:initView()
  self:addEventListener()
  if param then
    self:refreshView(param)
  end
end

function checkOthersHeroWindow:initView()
  local container, ui = ed.editorui(ed.uieditor.checkOthersHero)
  self.ui = ui
  self.container:addChild(container)
  ed.setLabelStroke(self.ui.label_gs, ed.toccc3(3611404), 1)
  self:show()
end

function checkOthersHeroWindow:refreshView(hero)
  self.hero = hero
  self.hid = self.hero._tid
  self.equipState = {}
  self.equips = {}
  self:createHeroFca()
  self:refreshHeroStars()
  self:createEquipIcons()
  self:refreshHeroInfo()
  self:createGsNum()
  self:createHeroName()
  self:createSkill()
  self:createShardIcon()
  self:refreshPetIcon()
  self:createAstrolabeIcon()
  self:createLegendEquip()
end

function checkOthersHeroWindow:refreshHeroStars()
  for i = 1, 5 do
    if i <= self.hero._stars then
      self.ui["star" .. i]:setVisible(true)
    else
      self.ui["star" .. i]:setVisible(false)
    end
  end
end

function checkOthersHeroWindow:refreshHeroInfo()
  ed.setString(self.ui.label_level, T("\231\173\137\231\186\167") .. self.hero._level)
  ed.setTexture(self.ui.icon_type, ed.readhero.getTypeRes(self.hid))
end

function checkOthersHeroWindow:createHeroName()
  local ui = self.ui
  local nb = ed.getCenterPos(ui.frame_name)
  ui.name:removeFromParentAndCleanup(true)
  local name, w, h = ed.readhero.createHeroNameByInfo({
    name = ed.getDataTable("Unit")[self.hid]["Display Name"],
    rank = self.hero._rank,
    tid = self.hero._tid
  })
  ed.setTexture(ui.frame_name, string.format("UI/alpha/1080P/hero/rank/hero_rank_%d.png", self.hero._rank))
  ui.name = name
  name:setPosition(ccp(nb.x - w / 2, nb.y))
  ui.frame_name:addChild(name)
end

function checkOthersHeroWindow:createHeroFca()
  ed.asyncload.preloadFcaByUnitID(self.hid)
  ed.asyncload.registLoadingListener(function()
    local puppet, cha = ed.readhero.getActor(self.hid, "Idle", true, false, self.hero._fashion or 0, false)
    local row = ed.getDataTable("Puppet")[cha]
    local scale = row.Scale
    local wscale = row["Window Scale"]
    if wscale ~= 0 then
      scale = scale * wscale
    end
    puppet:setScale(scale)
    puppet:setPosition(ccp(200, 165))
    self.ui.bg_equip:addChild(puppet, 10)
    self:addFca(puppet)
    puppet:update(0)
    self.puppet = puppet
    self.cha = cha
    self.action_pre = "Idle"
    ed.asyncload.unregistLoadingListener()
  end)
end

function checkOthersHeroWindow:createGsNum()
  local numgs = ed.getNumberNode({
    text = self.hero._gs,
    folder = "hero_gs",
    padding = -1
  }).node
  self.pregs = self.hero._gs
  numgs:setPosition(ccp(230.5, 29.25))
  self.ui.num_gs:removeFromParentAndCleanup(true)
  self.ui.num_gs = numgs
  self.ui.bg_gs:addChild(numgs)
end

function checkOthersHeroWindow:createEquipIcons()
  for index = 1, #(self.hero._items or {}) do
    self:createEquipIcon(index)
  end
end

function checkOthersHeroWindow:createEquipIcon(index)
  local eid = self.hero._items[index]._item_id
  if eid <= 0 then
    return
  end
  local frame, icon, level, exp
  frame, icon = ed.readequip.createHeroItem(self.hid, index, nil, self.hero)
  exp = ed.readequip.getEquipExp(self.hid, index, self.hero)
  level = ed.readequip.getEquipLevel(self.hero, index, exp, self.hero)
  local x, y = self.ui["frame_equip" .. index]:getPosition()
  frame:setPosition(x, y)
  self.ui["equip" .. index]:addChild(frame)
  self.equips[index] = {
    id = eid,
    frame = frame,
    icon = icon,
    exp = exp,
    level = level
  }
  self:btRegisterButtonClick({
    button = icon,
    pressScale = 0.95,
    key = "equip_" .. index,
    clickHandler = function()
      self:doClickEquip(index)
    end,
    clickInterval = 0.5,
    force = true
  })
end

function checkOthersHeroWindow:doClickEquip(id)
  local context = "herodetail"
  local config = {
    context = context,
    eid = self.equips[id].id,
    level = self.equips[id].level,
    titanEquipLevel = self.equips[id].exp,
    hid = self.hid,
    hero = self.hero,
    sid = id,
    isEquiped = true,
    showUpgrade = false,
    hideBtn = true,
    priority = -301
  }
  local craftLayer = ed.ui.equipcraft.create(config)
  craftLayer:popWindow(502)
end

function checkOthersHeroWindow:createSkill()
  local skills = ed.getSkillExpBase(self.hid)
  local skillList = {}
  for i = 1, #skills do
    skillList[i] = {
      name = skills[i]["Display Name"],
      skillName = skills[i]["Skill Name"],
      slot = skills[i].Slot,
      olderSlot = skills[i].Slot,
      rank = skills[i].Unlock,
      groupID = skills[i]["Skill Group ID"]
    }
  end
  table.sort(skillList, function(a, b)
    return a.olderSlot < b.olderSlot
  end)
  for i = 1, 4 do
    local skillLevel = self.hero._skill_levels and self.hero._skill_levels[i] or 0
    local skill = skillList[i]
    ed.setString(self.ui["skill_name" .. i], skill.name)
    ed.adaptLabel(self.ui["skill_name" .. i], {maxWidth = 120, minScale = 0.7})
    ed.setLabelStroke(self.ui["skill_name" .. i], ed.toccc3(2565412), 1)
    local icon, bg = ed.readhero.createSkillIcon(self.hid, skill.slot, self.hero)
    self.ui["skill_icon" .. i]:addChild(icon)
    local x, y = self.ui["skill_icon" .. i]:getPosition()
    icon:setPosition(x - 2, y)
    local skill_level = self.ui["skill_level" .. i]
    if self.hero._rank < skill.rank then
      self.ui["skill_lock" .. i]:setVisible(true)
      ed.setString(skill_level, T("\230\156\170\232\167\163\233\148\129"))
      ed.setLabelColor(skill_level, ed.toccc3(9408399))
      ed.setLabelStroke(skill_level, ed.toccc3(2565412), 1)
    else
      self.ui["skill_lock" .. i]:setVisible(false)
      ed.setString(skill_level, ed.formatLevel("lv.") .. skillLevel)
      ed.setLabelColor(skill_level, ed.toccc3(16776423))
      ed.setLabelStroke(skill_level, ed.toccc3(2565412), 1)
    end
    local skillEvoTb = ed.getDataTable("SkillEvo")
    local evo = skillEvoTb[skill.groupID] or {}
    local step = 0
    for k, v in pairs(evo) do
      if skillLevel >= evo[k]["EvoSkill UnlockLevel"] then
        step = math.max(step, k)
      end
    end
    ed.setString(self.ui["skill_rank" .. i], step)
    ed.setLabelStroke(self.ui["skill_rank" .. i], ed.toccc3(2565412), 1)
  end
end

function checkOthersHeroWindow:createShardIcon()
  local shard = self.hero._shard or {}
  if shard and shard._level and shard._id and shard._level > 0 then
    local res
    for _, v in pairs(ed.getDataTable("ShardToHero")) do
      if shard._id == v["Shard ID"] and v["Hero ID"] == self.hid then
        res = v.Icon
      end
    end
    if not res then
      return
    end
    local shardEquipBg = ed.createSprite("UI/alpha/1080P/shard/shard_frame.png")
    shardEquipBg:setPosition(242, 18)
    self.ui.frame_name:addChild(shardEquipBg)
    local shardEquip = ed.createSprite(res)
    local size = shardEquipBg:getContentSize()
    shardEquip:setPosition(size.width / 2, size.height / 2)
    shardEquipBg:addChild(shardEquip)
    local labelBg = ed.createSprite("UI/alpha/1080P/skill/skill_rank_2.png")
    labelBg:setPosition(size.width / 2, 7)
    shardEquipBg:addChild(labelBg)
    labelBg:setScale(0.66)
    local label = ed.createttf(shard._level, 15)
    label:setPosition(size.width / 2, 7)
    label:setColor(ccc3(254, 255, 170))
    shardEquipBg:addChild(label)
    ed.setLabelStroke(label, ccc3(39, 37, 36), 1)
  end
end

function checkOthersHeroWindow:createAstrolabeIcon()
  local astrolabe = self.hero._astrolabe or {}
  if self.astrolabeEquipBg then
    self.astrolabeEquipBg:removeFromParentAndCleanup(true)
    self.astrolabeEquipBg = nil
  end
  if astrolabe and astrolabe._level then
    local res = ed.getDataTable("Astrolabe")[self.hid].Icon
    if not res then
      return
    end
    local astrolabeEquipBg = ed.createSprite("UI/alpha/1080P/shard/shard_frame.png")
    astrolabeEquipBg:setPosition(-30, 18)
    self.ui.frame_name:addChild(astrolabeEquipBg)
    local shardEquip = ed.createSprite(res)
    local size = astrolabeEquipBg:getContentSize()
    shardEquip:setPosition(size.width / 2, size.height / 2)
    astrolabeEquipBg:addChild(shardEquip)
    local labelBg = ed.createSprite("UI/alpha/1080P/skill/skill_rank_2.png")
    labelBg:setPosition(size.width / 2, 7)
    astrolabeEquipBg:addChild(labelBg)
    labelBg:setScale(0.66)
    local label = ed.createttf(astrolabe._level, 16)
    label:setPosition(size.width / 2, 7)
    label:setColor(ccc3(254, 255, 170))
    astrolabeEquipBg:addChild(label)
    ed.setLabelStroke(label, ccc3(39, 37, 36), 1)
    self.astrolabeEquipBg = astrolabeEquipBg
    self:btRemoveMainTouchHandler({
      key = "astrolabeEquipBg"
    })
    self:btRegisterButtonClick({
      button = self.astrolabeEquipBg,
      pressScale = 0.98,
      key = "astrolabeEquipBg",
      clickHandler = function()
        ed.ui.heroAstrolabeAttWin.create({
          hero = self.hero
        })
      end
    })
  end
end

function checkOthersHeroWindow:createPetFca()
  if self.hero._pet then
    local pet = self.hero:getPet()
    local puppet, cha = ed.readpet.getActor(self.hero._pet._type_id, pet:isVariation())
    local row = ed.getDataTable("Puppet")[cha]
    local scale = row.Scale
    local wscale = row["Window Scale"]
    if wscale ~= 0 then
      scale = scale * wscale
    end
    local mul = 1
    for k, v in ipairs(self.hero._pet._talents or {}) do
      if v == 4 then
        ed.useShader(puppet, ed.getDataTable("Pet")[self.hero._pet._type_id]["Pet Variation Shader"])
      end
      if v == 2 then
        puppet:addEffect("eff_buff_pet_shine", 1)
      end
      if v == 1 then
        mul = 1.1
      end
    end
    local baseScale = ed.lookupDataTable("Pet", "Puppet Scale", self.hero._pet._type_id)
    scale = scale * baseScale * self.hero._pet._scale / 1000 * mul * 0.6
    puppet:setScale(scale)
    self:addFca(puppet)
    return puppet
  end
end

function checkOthersHeroWindow:refreshPetIcon()
  if self.petFca and not tolua.isnull(self.petFca) then
    self.petFca:removeFromParentAndCleanup(true)
  end
  if self.hero._pet then
    self.ui.bg_pet:setVisible(true)
    local petIcon = ed.readpet.createIcon({
      type = self.hero._pet._type_id
    }).icon
    petIcon:setScale(0.52)
    ed.UITool.replaceUINew(self.ui, "icon_pet", petIcon)
    ed.setLabelStroke(self.ui.pet_level, ccc3(0, 0, 0), 1)
    ed.setString(self.ui.pet_level, self.hero._pet._level)
    self.petFca = self:createPetFca()
    if self.petFca then
      self.petFca:setPosition(ccp(240, 150))
      self.ui.bg_equip:addChild(self.petFca, 11)
    end
  else
    self.ui.bg_pet:setVisible(false)
  end
end

function checkOthersHeroWindow:addEventListener()
  self:btRegisterButtonClick({
    button = self.ui.btn_back,
    pressScale = 0.78,
    normalScale = 0.8,
    key = "btn_back",
    clickHandler = function()
      self:doClickBack()
    end
  })
  self:listenEvent("req_hero_info", function(replyInfo)
    self:refreshView(replyInfo)
  end)
end

function checkOthersHeroWindow:doClickBack()
  ed.asyncload.unregistLoadingListener()
  self:destroy()
end

function checkOthersHeroWindow:createLegendEquip()
  local heroLegendEquip = ed.copyProto(self.hero._legend_equip or {})
  local legendEquip = heroLegendEquip and heroLegendEquip._equip
  local bg = ed.createSpriteTools({
    res = string.format("UI/alpha/1080P/legendequip/%s.png", legendEquip and "equip_background2" or "equip_background1"),
    pos = ccp(200, 370),
    parent = self.ui.bg_equip
  })
  local equipBg = ed.createSpriteTools({
    res = "UI/alpha/1080P/legendequip/equip_board.png",
    pos = ccp(113, 56),
    parent = bg
  })
  if legendEquip then
    local icon = ed.readequip.createLegendEquipIcon(legendEquip)
    equipBg:addChild(icon)
    icon:setPosition(37.5, 39)
    icon:setScale(0.89)
  end
  self.ui.legendEquipBg = equipBg
  ed.UITool.registerBtn(self, "legendEquipBg", function()
    if legendEquip then
      ed.UITool.openView("legendEquipTip", {legendEquip = legendEquip})
    end
  end)
end
