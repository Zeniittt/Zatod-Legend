local PetDetail = newclass("g")
local herodetail = ed.ui.heroDetailScene
local res = ed.heroDetailManager.resConfig
herodetail.newpet = PetDetail
local lsr = ed.heroDetailManager.listener.create()

function PetDetail:initPetInfo(data)
  if self.openFromPet then
    self.pet = data
    self.hid = self.pet:getCarriedHeroId()
    self.hero = ed.player.heroes[self.hid]
  else
    self.hero = data
    self.hid = data._tid
    if not data._pet then
      self.pet = nil
      return
    end
    self.pet = ed.player:getPet(data._pet._id)
  end
  self.skill = self.pet:getSkillsInfo()
end

function PetDetail:refreshData(data)
  self:sendPetSkillUp()
  self:initPetInfo(data)
  self.skillIndex = 1
  self.upSkillLevelNum = {0, 0}
end

function PetDetail:adaptUI()
  local fixWidth = (ed.display.winSize.width - 960) * 0.66
  self.fixWidth = fixWidth
  self.ui.bg_skill_info:setContentSize(CCSizeMake(self.ui.bg_skill_info:getContentSize().width + fixWidth, self.ui.bg_skill_info:getContentSize().height))
  local width = self.ui.bg_skill_info:getContentSize().width
  self.ui.bg_skill_info:setPositionX(self.ui.bg_skill_info:getPositionX() + fixWidth / 2)
  self.ui.skill_btn_bg:setPositionX(self.ui.bg_skill_info:getContentSize().width / 2)
  self.ui.bg_title_feature:setPositionX(self.ui.bg_skill_info:getContentSize().width / 2)
  self.ui.bg_feature1:setContentSize(CCSizeMake(self.ui.bg_feature1:getContentSize().width + fixWidth, self.ui.bg_feature1:getContentSize().height))
  self.ui.bg_feature2:setContentSize(CCSizeMake(self.ui.bg_feature2:getContentSize().width + fixWidth, self.ui.bg_feature2:getContentSize().height))
  self.ui.bg_feature3:setContentSize(CCSizeMake(self.ui.bg_feature3:getContentSize().width + fixWidth, self.ui.bg_feature3:getContentSize().height))
  self.ui.btn_find_master:setContentSize(CCSizeMake(self.ui.btn_find_master:getContentSize().width + fixWidth, self.ui.btn_find_master:getContentSize().height))
  self.ui.ImageView_8579:setContentSize(CCSizeMake(self.ui.ImageView_8579:getContentSize().width + fixWidth, self.ui.ImageView_8579:getContentSize().height))
  self.ui.Panel_7499:setContentSize(CCSizeMake(self.ui.Panel_7499:getContentSize().width + fixWidth, self.ui.Panel_7499:getContentSize().height))
  ed.UITool.setPositionBy(self.ui.btn_attr_detail, ccp(fixWidth, 0))
  ed.UITool.setPositionBy(self.ui.bg_switch_btn, ccp(fixWidth, 0))
  ed.UITool.setPositionBy(self.ui.btn_quit_master, ccp(fixWidth, 0))
  self.ui.bg_skill_ranks:setClipRect(CCRectMake(0, -48, width, 196))
  ed.UITool.setPositionBy(self.ui.bg_skill, ccp(fixWidth / 2, 0))
  ed.UITool.setPositionBy(self.ui.skill_line, ccp(fixWidth / 2, 0))
  ed.UITool.setPositionBy(self.ui.ImageView_6807, ccp(fixWidth, 0))
  ed.UITool.setPositionBy(self.ui.type_desc, ccp(fixWidth, 0))
  ed.UITool.setPositionBy(self.ui.ImageView_6809, ccp(fixWidth / 2, 0))
  self.ui.ImageView_6809:setScaleX(width / self.ui.ImageView_6809:getContentSize().width)
  self.ui.skill_simple_desc:setContentSize(CCSizeMake(width - 20, 96))
  self.ui.skill_detail_desc:setContentSize(CCSizeMake(width - 20, 96))
  self.ui.ImageView_6811:setContentSize(CCSizeMake(width, 47))
  ed.UITool.setPositionBy(self.ui.btn_train, ccp(fixWidth, 0))
  ed.UITool.setPositionBy(self.ui.ImageView_6966, ccp(fixWidth / 2, 0))
  ed.UITool.setPositionBy(self.ui.ImageView_6968, ccp(fixWidth / 2, 0))
  ed.UITool.setPositionBy(self.ui.ImageView_7048, ccp(fixWidth / 2, 0))
  ed.UITool.setPositionBy(self.ui.pet_max_skill, ccp(fixWidth / 2, 0))
end

function PetDetail:initData(param)
  self.controller = param.controller
  self.pos = param.pos
  self.skillIndex = 1
  self.isSimple = true
  self.upSkillLevelNum = {0, 0}
  self:initPetInfo(param.hero)
end

function PetDetail:getSkillLevel(pet, slot)
  return pet:getSkillLevel(slot) + self.upSkillLevelNum[slot]
end

function PetDetail:showDictInfo(index, x, y)
  if not index then
    return
  end
  if not tolua.isnull(self.dictBg) then
    return
  end
  local tb = ed.getDataTable("Dictionary")
  local desc = tb[tonumber(index)].Description
  desc = string.gsub(desc, "#br#", "<br/>")
  local autoText = ed.ui.autoText:new()
  autoText:initParam({
    context = desc,
    fontSize = 16,
    maxWidth = 400,
    color = ccc3(255, 251, 231)
  })
  local bg = ed.createScale9Sprite("UI/alpha/1080P/common/mail_bj9_1.png", CCRectMake(10, 10, 10, 200))
  local width, height = autoText:getCurContentSize()
  bg:setContentSize(CCSizeMake(width + 20, height + 20))
  local bgWidth = bg:getContentSize().width
  local x = math.min(x, ed.display.winSize.width - bgWidth / 2)
  bg:setPosition(ccp(x - ed.display.halfFixedWidth, y - height - 10))
  autoText.node:setPosition(ccp(10, height))
  bg:addChild(autoText.node)
  self.dictBg = bg
  self.controller:listenTimer(Timer:Once(0), function()
    self.touchNode:btRegisterOutClick({
      area = bg,
      key = "dict_out_click",
      clickHandler = function()
        if not tolua.isnull(bg) then
          bg:removeFromParentAndCleanup(true)
        end
      end,
      force = true
    })
  end)
  ed.getCurrentScene().scene:addChild(bg, 999)
end

function PetDetail:refreshSkillUI()
  for i = 1, 2 do
    self.ui["pet_skill" .. i]:setVisible(self.skill[i] ~= nil)
    if self.skill[i] then
      local icon = ed.readhero.createSkillIcon(self.pet:getTypeId(), self.skill[i].slot)
      icon:setScale(0.9)
      ed.UITool.replaceUINew(self.ui, "icon_skill" .. i, icon)
      self.ui["selected_skill" .. i]:setVisible(self.skillIndex == i)
    end
  end
  if #self.skill == 1 then
    ed.layout.centerInParent(self.ui.pet_skill1)
  else
    self.ui.pet_skill1:setPositionX(79.25)
  end
end

function PetDetail:refreshPetName()
  local config = {
    [2] = 4,
    [3] = 7,
    [4] = 12
  }
  ed.setString(self.ui.pet_name, self.pet:getName())
  ed.setTexture(self.ui.frame_name_bg, string.format("UI/alpha/1080P/hero/rank/hero_rank_%d.png", config[self.pet:getColor()] or 1))
  ed.setTexture(self.ui.icon_pet_color, ed.Pet.getTagResByTypeId(self.pet:getTypeId()))
end

function PetDetail:refreshPetLevel()
  ed.setString(self.ui.pet_level, T("\231\173\137\231\186\167") .. self:getPetLevel())
end

function PetDetail:refreshPetAddAttr()
  local strRadio = self.pet:getPetAttrRadio("STR")
  local agiRadio = self.pet:getPetAttrRadio("AGI")
  local intRadio = self.pet:getPetAttrRadio("INT")
  ed.setString(self.ui.label_str, T("\229\138\155\233\135\143+") .. strRadio .. "%")
  ed.setString(self.ui.label_int, T("\230\153\186\229\138\155+") .. intRadio .. "%")
  ed.setString(self.ui.label_agi, T("\230\149\143\230\141\183+") .. agiRadio .. "%")
end

function PetDetail:refreshPetTalents()
  local talents = self.pet:getTalents() or {}
  for i = 1, 5 do
    self.ui["talent" .. i]:setVisible(talents[i] ~= nil)
    if talents[i] then
      self.ui["label_talent" .. i]:setString(ed.getDataTable("PetTalent")[talents[i]]["Pet Talent Name"])
    end
  end
  self.ui.Label_7265:setVisible(#talents == 0)
end

function PetDetail:checkFcaHandler(action, duration)
  local time = 0
  
  local function handler(dt)
    time = time + dt
    if action ~= "Move" and time > duration and not tolua.isnull(self.puppet) then
      self.puppet:setAction("Idle")
      self.puppet:setLoop(true)
      self.controller:removeUpdateHandler("checkFcaHandlerPet")
    end
  end
  
  return handler
end

function PetDetail:changeFcaAction(name, with_sound)
  if with_sound == nil then
    with_sound = true
  end
  local action, duration = self:changeAction(name)
  if with_sound then
    lsr:report("clickHeroFca", {
      hid = self.pet:getTypeId(),
      action = action
    })
  end
  self.controller:registerUpdateHandler("checkFcaHandlerPet", self:checkFcaHandler(action, duration))
end

function PetDetail:changeAction(name)
  local row = ed.getDataTable("AnimDuration")[self.cha]
  local actions = {}
  local dur = {}
  local skill_items = ed.getDataTable("SkillGroup")[self.pet:getTypeId()]
  local can_show_action_tbl = {"Move"}
  for idx, skill_item in pairs(skill_items or {}) do
    for jdx, action in pairs(ed.getDataTable("Skill")[skill_item["Skill Group ID"]][0]["Action(s)"]) do
      if string.find(action, "special") == nil then
        can_show_action_tbl[#can_show_action_tbl + 1] = action
      end
    end
  end
  for k, v in pairs(row or {}) do
    if name then
      if k == name then
        table.insert(actions, k)
        table.insert(dur, v.Duration)
      end
    elseif ed.isElementInTable(k, can_show_action_tbl) and k ~= self.action_pre then
      table.insert(actions, k)
      table.insert(dur, v.Duration)
    end
  end
  local index
  if name then
    index = 1
  else
    index = math.random(1, #actions)
  end
  local action = actions[index]
  self.action_pre = action
  self.duration = dur[index]
  self.puppet:setAction(action)
  self.puppet:setLoop(action == "Move")
  return action, self.duration
end

function PetDetail:refreshPetSize()
  local petScale = self.pet:getBody()
  local rawScale = self.pet.data._scale / 1000
  ed.setString(self.ui.name_feature2_Copy0, string.format("\232\186\171\233\149\191 %.3f\231\177\179", petScale * ed.getDataTable("Pet")[self.pet:getTypeId()]["Scale Length"]))
  ed.setString(self.ui.name_feature2_Copy1, string.format("\228\189\147\229\158\139 %.3f", rawScale))
  ed.setString(self.ui.name_feature2_Copy2, string.format("(+%.3f)", petScale - rawScale))
  ed.right2(self.ui.name_feature2_Copy2, self.ui.name_feature2_Copy1)
  self.ui.name_feature2_Copy2:setVisible(petScale - rawScale ~= 0)
end

local acts = require("util.cocos2dx.actions")

function PetDetail:runRefreshGsAction(preGs)
  local bg_gsadd = ed.createSprite("UI/alpha/1080P/hero/hero_gs_up_bg.png")
  local icon = ed.readhero.createPureIcon({
    id = self.hero._tid,
    noStar = true,
    rank = self.hero._rank
  }).icon
  icon:setScale(0.9)
  local newgs = preGs < self.hero._gs
  local pregs = ed.getNumberNode({
    text = preGs,
    folder = "hero_gs",
    padding = -1
  }).node
  local addgs = ed.getNumberNode({
    text = math.abs(self.hero._gs - preGs),
    folder = "hero_gs_up",
    padding = -1
  }).node
  local gsText = ed.createSprite("UI/alpha/1080P/hero/hero_gs_up.png")
  local iconAdd = ed.createSprite(newgs and "UI/alpha/1080P/hero/hero_upgrade_add.png" or "UI/alpha/1080P/hero/hero_upgrade_sub.png")
  icon:setPosition(55, 20)
  gsText:setPosition(130, 20)
  iconAdd:setPosition(260, 20)
  pregs:setPosition(210, 20)
  addgs:setPosition(300, 20)
  bg_gsadd:addChild(icon)
  bg_gsadd:addChild(gsText)
  bg_gsadd:addChild(iconAdd)
  bg_gsadd:addChild(pregs)
  bg_gsadd:addChild(addgs)
  bg_gsadd:runAction(acts.sequence({
    acts.spawn({
      CCFadeIn:create(0.1),
      CCMoveBy:create(0.1, ccp(0, 10))
    }),
    CCMoveBy:create(0.4, ccp(0, 3)),
    CCFadeOut:create(0.8),
    CCCallFunc:create(function()
      bg_gsadd:removeFromParentAndCleanup(true)
    end)
  }))
  ed.layout.centerInScreen(bg_gsadd)
  self.mainLayer:addChild(bg_gsadd, 99)
end

function PetDetail:refreshPetMaster()
  local masterId = self.pet:getCarriedHeroId()
  local hasMaster = masterId and masterId ~= 0
  self.ui.bg_feature3:setVisible(hasMaster)
  self.ui.btn_find_master:setVisible(not hasMaster)
  if hasMaster then
    local icon = ed.readhero.createPureIcon({
      id = masterId,
      noStar = true,
      rank = self.hero._rank
    }).icon
    icon:setScale(0.4)
    ed.UITool.replaceUINew(self.ui, "icon_master", icon)
    ed.setString(self.ui.name_master, ed.player:getHero(masterId):getDisplayName())
  end
end

function PetDetail:hideCallBack()
  if not tolua.isnull(self.dictBg) then
    self.dictBg:removeAllChildrenWithCleanup(true)
  end
  self:sendPetSkillUp()
end

function PetDetail:refreshLevelUpMats()
  local mats = self.pet:getLevelUpMats()
  for i = 1, 2 do
    local mat = mats[i]
    if mat and mat.amount > 0 then
      local icon = ed.createItemIcon({
        id = mat.id,
        type = mat.type
      })
      icon:setScale(0.35)
      self.touchNode:btRemoveMainTouchHandler({
        key = "petLevelUp" .. i
      })
      self.touchNode:btRegisterButtonClick({
        button = icon,
        key = "petLevelUp" .. i,
        clickHandler = function()
          ed.ui.packageDetailWin.create({
            id = mat.id,
            type = mat.type
          }):popWindow()
        end
      })
      ed.UITool.replaceUINew(self.ui, "icon_food" .. i, icon)
      local autoText = ed.ui.autoText.new()
      local cost = mat.amount
      local amount = 0
      if mat.type == "gold" then
        amount = ed.player._money or 0
      elseif mat.type == "item" then
        amount = ed.player.equip_qunty[mat.id] or 0
      end
      local amountStr = tostring(amount)
      if 1000000 < amount then
        amountStr = math.floor(amount / 10000) .. T("\228\184\135")
      end
      autoText:initParam({
        context = string.format("<lable color=%s strokeColor=ccc3(22,40,31)>%s</lable>/%d", cost <= amount and "ccc3(141,244,118)" or "ccc3(255,0,0)", amountStr, cost),
        color = ed.toccc3(16776423),
        strokeColor = ccc3(0, 0, 0),
        strokeSize = 1,
        fontSize = 14
      })
      ed.UITool.replaceUINew(self.ui, "label_food_amount" .. i, autoText.node)
      local curWidth = autoText:getCurContentSize()
      self.ui["label_food_amount" .. i]:setPositionX(47.5 - curWidth / 2)
      self.ui["bg_food_amount" .. i]:setVisible(true)
    else
      self.ui["bg_food_amount" .. i]:setVisible(false)
    end
  end
end

function PetDetail:refreshSimpleDesc()
  local size = self.ui.skill_simple_desc:getContentSize()
  self.simple_desc_list:clearList()
  local slot = self.skill[self.skillIndex].slot
  local autoStr = ed.heroDetailManager.getSkillAutoText(self.pet:getTypeId(), slot, self:getSkillLevel(self.pet, slot), false)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = autoStr,
    fontSize = 16,
    maxWidth = size.width - 5,
    strokeColor = ed.toccc3(2693915),
    strokeSize = 1,
    color = ccc3(255, 234, 197),
    touchLayer = self.touchNode
  })
  autoText:addRegisterHandler("simple", function(index, x, y)
    self:showDictInfo(index, x, y)
  end)
  local width, height = autoText:getCurContentSize()
  self.simple_desc_list:addItem(autoText.node)
  autoText.node:setPosition(ccp(0, size.height - 10))
  self.simple_desc_list:initListHeight(height)
end

function PetDetail:refreshDetailDesc()
  local size = self.ui.skill_detail_desc:getContentSize()
  self.detail_desc_list:clearList()
  local slot = self.skill[self.skillIndex].slot
  local autoStr = ed.heroDetailManager.getSkillAutoText(self.pet:getTypeId(), slot, self:getSkillLevel(self.pet, slot), true)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = autoStr,
    fontSize = 16,
    maxWidth = size.width - 5,
    strokeColor = ed.toccc3(2693915),
    strokeSize = 1,
    color = ccc3(255, 234, 197)
  })
  autoText:addRegisterHandler("detail", function(index, x, y)
    self:showDictInfo(index, x, y)
  end)
  local width, height = autoText:getCurContentSize()
  self.detail_desc_list:addItem(autoText.node)
  autoText.node:setPosition(ccp(0, size.height - 10))
  self.detail_desc_list:initListHeight(height)
end

function PetDetail:initLabels()
  ed.setLabelStroke(self.ui.pet_name, ccc3(0, 0, 0), 1.5)
  ed.setLabelStroke(self.ui.pet_level, ed.toccc3(3744789), 1)
  ed.setLabelStroke(self.ui.label_str, ed.toccc3(3744789), 1)
  ed.setLabelStroke(self.ui.label_int, ed.toccc3(3744789), 1)
  ed.setLabelStroke(self.ui.label_agi, ed.toccc3(3744789), 1)
  ed.setLabelStroke(self.ui.feature, ed.toccc3(2693915), 1)
  ed.setLabelStroke(self.ui.name_feature2_Copy0, ed.toccc3(2693915), 1)
  ed.setLabelStroke(self.ui.name_feature2_Copy1, ed.toccc3(2693915), 1)
  ed.setLabelStroke(self.ui.name_master, ed.toccc3(2693915), 1)
  ed.setLabelStroke(self.ui.skill_name, ed.toccc3(2693915), 1)
  for i = 1, 3 do
    ed.setLabelStroke(self.ui["name_attr" .. i], ed.toccc3(2693915), 1)
    ed.setLabelStroke(self.ui["value_attr" .. i], ed.toccc3(2693915), 1)
    ed.setLabelStroke(self.ui["name_feature" .. i], ed.toccc3(2693915), 1)
  end
  for i = 1, 5 do
    ed.setLabelStroke(self.ui["label_talent" .. i], ed.toccc3(11622675), 1)
  end
  ed.setLabelStroke(self.ui.Label_7265, ed.toccc3(2693915), 1)
  ed.setLabelStroke(self.ui.label_level_skill1, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.label_level_skill2, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.name_skill, ed.toccc3(3744789), 1)
  ed.setLabelStroke(self.ui.type_desc, ed.toccc3(2693915), 1)
  ed.setLabelShadow(self.ui.Label_5859, ccc3(0, 0, 0), ccp(1, 1))
  ed.setLabelShadow(self.ui.Label_58591, ccc3(0, 0, 0), ccp(1, 1))
  ed.setLabelStroke(self.ui.Label_6965, ed.toccc3(10446347), 1)
  ed.setLabelStroke(self.ui.Label_6967, ed.toccc3(2693915), 1)
  ed.setLabelStroke(self.ui.Label_6967_Copy0, ed.toccc3(2693915), 1)
  ed.setLabelStroke(self.ui.label_pet_max_level, ed.toccc3(7887680), 1.5)
  self.ui.label_pet_max_level:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_pet_max_skill, ed.toccc3(7887680), 1.5)
  self.ui.label_pet_max_skill:setFontName(ed.fontBold)
end

function PetDetail:refreshSkillInfo()
  ed.setString(self.ui.name_skill, self.skill[self.skillIndex].name)
  for i = 1, 2 do
    if self.skill[i] then
      ed.setString(self.ui["label_level_skill" .. i], "lv." .. self:getSkillLevel(self.pet, self.skill[i].slot))
    end
  end
end

function PetDetail:refreshPetEvoAttr()
  local petTypeId = self.pet:getTypeId()
  local tbData = ed.getDataTable("Pet")[petTypeId]
  for i = 1, 3 do
    local attrCN = res.att_anim_name[tbData["Extra Attr " .. i .. " Type"]] or ""
    local suffix = res.att_suffix[tbData["Extra Attr " .. i .. " Type"]] or ""
    ed.setString(self.ui["name_attr" .. i], attrCN)
    ed.setString(self.ui["value_attr" .. i], tbData["Extra Attr " .. i .. " Value"] .. suffix)
    if self:getPetLevel() < tbData["Extra Attr " .. i .. " Unlock Level"] then
      ed.setLabelColor(self.ui["name_attr" .. i], ed.toccc3(11908533))
      ed.setLabelColor(self.ui["value_attr" .. i], ed.toccc3(11908533))
      ed.setString(self.ui["name_attr" .. i], attrCN .. string.format(T("(\232\167\163\233\148\129\231\173\137\231\186\167%d)"), tbData["Extra Attr " .. i .. " Unlock Level"]))
    else
      ed.setLabelColor(self.ui["name_attr" .. i], ed.toccc3(16771782))
      ed.setLabelColor(self.ui["value_attr" .. i], ed.toccc3(16771782))
    end
  end
end

function PetDetail:refreshSkillUpMaterials()
  local skill = self.skill[self.skillIndex]
  local skillLevel = self:getSkillLevel(self.pet, self.skill[self.skillIndex].slot)
  local materials = self.pet:getSkillUpMaterials(skillLevel) or {}
  for i = 1, 2 do
    local material = materials[i]
    if material and material.amount > 0 then
      local icon = ed.createItemIcon({
        id = material.id,
        type = material.type
      })
      icon:setScale(0.35)
      ed.UITool.replaceUINew(self.ui, "icon_cost" .. i, icon)
      self.touchNode:btRemoveMainTouchHandler({
        key = "petSkillUp" .. i
      })
      self.touchNode:btRegisterButtonClick({
        button = icon,
        key = "petSkillUp" .. i,
        clickHandler = function()
          ed.ui.packageDetailWin.create({
            id = material.id,
            type = material.type
          }):popWindow()
        end
      })
      local autoText = ed.ui.autoText.new()
      local cost = material.amount
      local amount = 0
      if material.type == "gold" then
        amount = ed.player._money or 0
      elseif material.type == "item" then
        amount = ed.player.equip_qunty[material.id] or 0
      end
      local amountStr = tostring(amount)
      if 1000000 < amount then
        amountStr = math.floor(amount / 10000) .. T("\228\184\135")
      end
      autoText:initParam({
        context = string.format("<lable color=%s strokeColor=ccc3(22,40,31)>%s</lable>/%d", cost <= amount and "ccc3(141,244,118)" or "ccc3(255,0,0)", amountStr, cost),
        color = ed.toccc3(16776423),
        strokeColor = ccc3(0, 0, 0),
        strokeSize = 1,
        fontSize = 14
      })
      ed.UITool.replaceUINew(self.ui, "label_cost" .. i, autoText.node)
      local curWidth = autoText:getCurContentSize()
      self.ui["label_cost" .. i]:setPositionX(47.5 - curWidth / 2)
      self.ui["bg_cost" .. i]:setVisible(true)
    else
      self.ui["bg_cost" .. i]:setVisible(false)
    end
  end
end

function PetDetail:initUI()
  local container, ui = ed.editorui(ed.uieditor.herodetailPet, {
    ui = self.ui
  })
  self.touchNode = ed.ui.basetouchnode.btCreate()
  self.mainLayer = container
  self.mainLayer:setTouchEnabled(true)
  self.mainLayer:registerScriptTouchHandler(self.touchNode:btGetMainTouchHandler(), false, self.openFromPet and -300 or 0, false)
  self.ui = ui
  self:adaptUI()
  self.ui.layer_pet:setPosition(self.pos)
  self:initLabels()
  self.simple_desc_list = ed.UITool.createDraglist(self.ui.skill_simple_desc)
  self.detail_desc_list = ed.UITool.createDraglist(self.ui.skill_detail_desc)
  self:refreshUI(true)
  self.ui.ImageView_6964:runAction(ed.UITool.getBreathAction(1.2))
end

function PetDetail:addFca(fca)
  self.controller:addFca(fca)
end

function PetDetail:createPetFca()
  if self.pet then
    self.ui.pet_pos:removeAllChildrenWithCleanup(true)
    local puppet, cha = ed.readpet.getActor(self.pet:getTypeId(), self.pet:isVariation())
    local row = ed.getDataTable("Puppet")[cha]
    local scale = row.Scale
    local wscale = row["Window Scale"]
    if wscale ~= 0 then
      scale = scale * wscale
    end
    local baseScale = ed.lookupDataTable("Pet", "Puppet Scale", self.pet:getTypeId())
    if baseScale then
      scale = scale * baseScale * self.pet:getBody()
    end
    puppet:setScale(scale)
    local extraShader = self.pet:getExtraShader()
    if extraShader then
      ed.useShader(puppet, extraShader)
    end
    for k, v in ipairs(self.pet:getTalents()) do
      if v == 2 then
        puppet:addEffect("eff_buff_pet_shine", 1)
      end
    end
    self.ui.pet_pos:addChild(puppet)
    self:addFca(puppet)
    self.puppet = puppet
    self.cha = ed.getDataTable("Puppet")[cha].Resource .. ".cha"
  end
end

function PetDetail:setDetailInfo(isShow)
  if not isShow and not tolua.isnull(self.fullDesText) then
    self.fullDesText:removeFromParentAndCleanup(true)
  end
end

function PetDetail:refreshUI(updateHero)
  if not self.pet then
    self.ui.layer_unpet:setVisible(true)
    self.ui.layer_pet_left:setVisible(false)
    self.ui.layer_pet_right:setVisible(false)
    ed.setLabelColor(self.ui.feature, ed.toccc3(8352869))
    ed.setLabelColor(self.ui.skill_name, ed.toccc3(8352869))
    self.ui.pet_pos:removeAllChildrenWithCleanup(true)
    self.ui.pet_skill1:setVisible(false)
    self.ui.pet_skill2:setVisible(false)
    return
  else
    self.ui.layer_unpet:setVisible(false)
    self.ui.layer_pet_left:setVisible(true)
    self.ui.layer_pet_right:setVisible(true)
    ed.setLabelColor(self.ui.feature, ed.toccc3(16771782))
    ed.setLabelColor(self.ui.skill_name, ed.toccc3(16771782))
  end
  if updateHero then
    self:refreshPetName()
    self:createPetFca()
  end
  self:refreshSkillUI()
  self:refreshPetLevel()
  self:refreshPetAddAttr()
  self:refreshLevelUpMats()
  self:refreshPetTalents()
  self:refreshPetSize()
  self:refreshPetMaster()
  self:refreshSimpleDesc()
  self:refreshDetailDesc()
  self:refreshSkillInfo()
  self:refreshPetEvoAttr()
  self:refreshSkillUpMaterials()
  self:setDetailInfo(false)
  self:setDescSelect(self.isSimple)
  if not tolua.isnull(self.dictBg) then
    self.dictBg:removeAllChildrenWithCleanup(true)
  end
  if not tolua.isnull(self.talentDetailBg) then
    self.talentDetailBg:removeAllChildrenWithCleanup(true)
  end
  self.ui.ImageView_6811:setVisible(self:getSkillLevel(self.pet, self.skill[self.skillIndex].slot) < 30)
  self.ui.pet_max_skill:setVisible(self:getSkillLevel(self.pet, self.skill[self.skillIndex].slot) >= 30)
  self.ui.bg_eat:setVisible(self:getPetLevel() < 15)
  self.ui.pet_max_level:setVisible(self:getPetLevel() >= 15)
  local type = ed.getDataTable("Unit")[self.pet:getTypeId()]["Hero Type"]
  ed.setTexture(self.ui.icon_attr_type, ed.readhero.getTypeRes(self.pet:getTypeId()))
end

function PetDetail:playLevelUpAnim()
end

function PetDetail:playSkillUpAnim(id)
  id = id or self.skillIndex
  local slot = self.skill[id].slot
  local att = ed.heroDetailManager:getSkillLvupAtt(self.pet:getTypeId(), slot)
  local effect = ed.createFcaNode("eff_UI_skill_level_up")
  effect:setScale(1.3)
  effect:setPosition(self.ui["icon_skill" .. id]:getPosition())
  self.ui["pet_skill" .. id]:addChild(effect, 10)
  self.controller:addFcaOnce(effect, true)
  local dt = 0.2
  for i = 1, #att do
    local label = ed.createNode({
      t = "Label",
      base = {
        text = att[i],
        size = 18,
        z = 999
      },
      layout = {
        position = ed.getWorldPos(self.ui["pet_skill" .. id], ccp(-50, 40))
      },
      config = {
        color = ed.toccc3(7405396),
        stroke = {
          color = ed.toccc3(1519903),
          size = 2
        },
        visible = false
      }
    }, self.mainLayer)
    local a1 = CCDelayTime:create(dt * (i - 1))
    local a2 = CCCallFunc:create(function()
      label:setVisible(true)
    end)
    local a3 = CCMoveBy:create(0.5, ccp(0, 35))
    local a4 = CCFadeOut:create(0.1)
    local a5 = CCCallFunc:create(function()
      label:removeFromParentAndCleanup(true)
    end)
    label:runAction(ed.readaction.create({
      t = "seq",
      a1,
      a2,
      a3,
      a4,
      a5
    }))
  end
  local action1 = ed.UITool.getRefreshAction()
  self.ui["label_level_skill" .. id]:runAction(action1)
end

function PetDetail:sendPetSkillUp()
  if self.upSkillLevelNum[1] == 0 and self.upSkillLevelNum[2] == 0 then
    return
  end
  local ups = {}
  for k, v in pairs(self.upSkillLevelNum) do
    table.insert(ups, {_index = k, _amount = v})
  end
  ed.PetNetwork:levelupPetSkill(self.pet:getId(), ups)
end

function PetDetail:sendLevelUp()
  ed.PetNetwork:levelupPet(self.pet:getId(), 1)
end

function PetDetail:setDescSelect(type)
  self.isSimple = type
  if not tolua.isnull(self.dictBg) then
    self.dictBg:removeAllChildrenWithCleanup(true)
  end
  if self.isSimple then
    ed.setString(self.ui.type_desc, T("\231\174\128\232\166\129\230\143\143\232\191\176"))
    self.ui.skill_simple_desc:setVisible(true)
    self.ui.skill_detail_desc:setVisible(false)
    self.ui.icon_switch:runAction(CCMoveTo:create(0.1, ccp(15, 15)))
  else
    ed.setString(self.ui.type_desc, T("\232\175\166\231\187\134\230\143\143\232\191\176"))
    self.ui.skill_simple_desc:setVisible(false)
    self.ui.skill_detail_desc:setVisible(true)
    self.ui.icon_switch:runAction(CCMoveTo:create(0.1, ccp(48, 15)))
  end
end

function PetDetail:keepHandler(handler)
  local count = 0
  local delay = 0.8
  local oriSpeed = 10
  local oriAccSpeed = 2
  local accAcc = 2
  local speed = oriSpeed
  local accSpeed = oriAccSpeed
  local times = 0
  
  local function UpHandler(dt)
    count = count + dt
    if count > delay then
      accSpeed = accSpeed + accAcc * dt
      speed = speed + accSpeed * dt
      times = times + speed * dt
      while 1 < times do
        handler(self)
        times = times - 1
      end
    end
  end
  
  return UpHandler
end

function PetDetail:OnClickSkillLevelUp()
  if not tolua.isnull(self.fullDesText) then
    self.fullDesText:removeFromParentAndCleanup(true)
  end
  if ed.player:getLevel() < 7 then
    ed.showToast(T("\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\1767\231\186\167\229\144\142\229\188\128\230\148\190\230\138\128\232\131\189\229\141\135\231\186\167"))
    return
  end
  local skillLevel = self:getSkillLevel(self.pet, self.skill[self.skillIndex].slot) or 1
  if 30 <= skillLevel then
    ed.showToast(T("\230\138\128\232\131\189\229\183\178\230\187\161\231\186\167"))
    return
  end
  local materials = self.pet:getSkillUpMaterials(skillLevel)
  if not ed.heroDetailManager.checkMaterials(materials) then
    ed.showToast(T("\230\157\144\230\150\153\228\184\141\232\182\179"))
    return
  end
  self.upSkillLevelNum[self.skillIndex] = self.upSkillLevelNum[self.skillIndex] + 1
  ed.heroDetailManager.consumeMaterials(materials)
  self:playSkillUpAnim(self.skillIndex)
  self:refreshUI()
end

function PetDetail:getPetLevel()
  return self.pet:getLevel()
end

function PetDetail:OnClickLevelUp()
  if not tolua.isnull(self.fullDesText) then
    self.fullDesText:removeFromParentAndCleanup(true)
  end
  if self:getPetLevel() >= 15 then
    ed.showToast(T("\229\183\178\230\187\161\231\186\167"))
    return
  end
  local materials = self.pet:getLevelUpMats()
  if not ed.heroDetailManager.checkMaterials(materials) then
    ed.showToast(T("\230\157\144\230\150\153\228\184\141\232\182\179"))
    return
  end
  self.levelUpmat = materials
  self:sendLevelUp()
end

function PetDetail:doFindMaster()
  ed.ui.PetChooseMasterWin.create(self.pet:getId())
end

function PetDetail:doQuitMaster()
  if self.pet:getCD() > 0 then
    ed.ui.petQuitHeroWin.create({
      pet = self.pet,
      controller = self
    })
    return
  end
  local timeStr = T("48\229\176\143\230\151\182")
  for k, v in ipairs(self.pet:getTalents()) do
    if v == 3 then
      timeStr = T("10\229\136\134\233\146\159")
    end
  end
  ed.showConfirmDialog1({
    title = T("\230\143\144\231\164\186"),
    autoText = string.format(T("\228\191\161\228\189\191\231\166\187\229\188\128\228\184\187\228\186\186\229\144\142\239\188\140\228\184\139\228\184\128\230\172\161\233\156\128\232\166\129\231\173\137\229\190\133%s\229\144\142\230\137\141\232\131\189\231\166\187\229\188\128\227\128\130\230\152\175\229\144\166\231\187\167\231\187\173\239\188\159"), timeStr),
    offsetY = 10,
    fontSize = 20,
    rightHandler = function()
      self:sendPetSkillUp()
      ed.PetNetwork:unequipPet(self.pet:getCarriedHeroId())
    end
  })
end

function PetDetail:doFindPet()
  for k, v in pairs(ed.player:getPets() or {}) do
    if v then
      ed.ui.heroDetailChoosePet.create({
        hid = self.hid
      })
      return
    end
  end
  ed.showToast(T("\230\154\130\230\151\160\228\191\161\228\189\191"))
end

function PetDetail:petUpdate()
  if self.openFromPet then
    self.hid = self.pet:getCarriedHeroId()
    self.hero = ed.player.heroes[self.hid]
    self:refreshUI(true)
  else
    if self.hero._pet then
      self:initPetInfo(self.hero)
    else
      self.pet = nil
      self.skill = nil
    end
    self:refreshUI(true)
  end
end

function PetDetail:showTalentInfo(index)
  if not tolua.isnull(self.talentDetailBg) then
    self.talentDetailBg:removeFromParentAndCleanup(true)
  end
  local talentId = self.pet:getTalents()[index]
  if not talentId then
    return
  end
  local desc = ed.getDataTable("PetTalent")[talentId]["Pet Talent Description"]
  desc = string.gsub(desc, "#br#", "<br/>")
  local autoText = ed.ui.autoText:new()
  autoText:initParam({
    context = desc,
    fontSize = 16,
    maxWidth = 180,
    color = ccc3(255, 251, 231)
  })
  local bg = ed.createScale9Sprite("UI/alpha/1080P/common/dialog_timely_summon_show.png", CCRectMake(40, 10, 10, 20))
  bg:setAnchorPoint(ccp(0, 0.5))
  local width, height = autoText:getCurContentSize()
  bg:setContentSize(CCSizeMake(width + 40, height + 20))
  local bgWidth = bg:getContentSize().width
  autoText.node:setPosition(ccp(20, height + 2))
  bg:addChild(autoText.node)
  self.touchNode:btRegisterOutClick({
    area = bg,
    key = "talent_out_click",
    clickHandler = function()
      if not tolua.isnull(bg) then
        bg:removeFromParentAndCleanup(true)
      end
    end,
    force = true
  })
  self.talentDetailBg = bg
  if index == 5 or index == 4 then
    bg:setScaleX(-1)
    autoText.node:setScaleX(-1)
    autoText.node:setPosition(ccp(bgWidth - 20, height + 2))
  end
  local pos = ed.getWorldPos(self.ui.layer_pet_right, ccp(-140 + index * 55, 220))
  bg:setPosition(pos)
  ed.getCurrentScene().scene:addChild(bg, 300)
end

function PetDetail:registerBtn(key, func, params)
  local ui = self.ui
  local config = {
    button = ui[key],
    press = ui[key .. "_press"],
    key = key,
    clickHandler = function(_, x, y)
      ed.playEffect(ed.sound.deo.common_back)
      func(x, y)
    end,
    force = true,
    mcpMode = true,
    mcp_dis = 30,
    clickInterval = 0.3,
    priority = -1
  }
  for k, v in pairs(params or {}) do
    config[k] = v
  end
  self.touchNode:btRegisterButtonClick(config)
end

function PetDetail:registerTouchHandlers(level)
  self.controller:listenEvent("PetEquipSuccess", function(result)
    self:petUpdate()
  end)
  self.controller:listenEvent("HeroGsUpdate", function(preGs)
    self:runRefreshGsAction(preGs)
  end)
  self.controller:listenEvent("PetUnEquipSuccess", function()
    self:petUpdate()
  end)
  self.controller:listenEvent("petLevelupSuccess", function(param)
    ed.ui.PetLevelUpTip.create(param)
    ed.heroDetailManager.consumeMaterials(self.levelUpmat)
    self.levelUpmat = {}
    self:playLevelUpAnim(self.skillIndex)
    self:refreshUI()
  end)
  self.controller:listenEvent("petSkillLevelupSuccess", function(result)
    self.upSkillLevelNum = {0, 0}
  end)
  self:registerBtn("Panel_7499", function()
    self:doFindMaster()
  end)
  self:registerBtn("ImageView_6961", function()
    self:doFindPet()
  end, {pressScale = 0.96})
  self:registerBtn("btn_attr_detail", function()
    ed.ui.petAttrWin.create({
      pet = self.pet
    })
  end, {pressScale = 0.9})
  self:registerBtn("btn_quit_master", function()
    self:doQuitMaster()
  end, {pressScale = 0.9})
  self:registerBtn("pet_skill1", function()
    if self.skillIndex == 1 then
      return
    end
    self.skillIndex = 1
    self:refreshUI()
  end, {})
  self:registerBtn("pet_skill2", function()
    if self.skillIndex == 2 then
      return
    end
    self.skillIndex = 2
    self:refreshUI()
  end, {})
  self:registerBtn("bg_switch_btn", function()
    self:setDescSelect(not self.isSimple)
  end)
  self:registerBtn("btn_train", function()
  end, {
    pressScale = 0.75,
    normalScale = 0.8,
    clickInterval = 0.1,
    pressHandler = function()
      self:OnClickSkillLevelUp()
      self.controller:registerUpdateHandler("pet_skill_long_levelup_click_button", self:keepHandler(self.OnClickSkillLevelUp))
    end,
    cancelPressHandler = function()
      self.controller:removeUpdateHandler("pet_skill_long_levelup_click_button")
    end
  })
  self:registerBtn("btn_eat", function()
    self:OnClickLevelUp()
  end, {pressScale = 0.75, normalScale = 0.8})
  for i = 1, 5 do
    self:registerBtn("talent" .. i, function()
      self:showTalentInfo(i)
    end, {pressScale = 1})
  end
  self.touchNode:btRegisterRectClick({
    rect = CCRectMake(-100, -20, 200, 180),
    parent = self.ui.pet_pos,
    key = "pet_touch",
    clickHandler = function()
      if self.controller.tabIndex == 5 or self.openFromPet then
        self:changeFcaAction()
      end
    end,
    force = true
  })
end

function PetDetail.create(param)
  local self = {}
  setmetatable(self, {__index = PetDetail})
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  return self
end
