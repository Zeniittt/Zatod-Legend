local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.legendEquipWindow = class
ed.UITool.registViewOpenFunc("legendEquipWindow", function(param)
  local window = ed.ui.legendEquipWindow.create(param)
  window:show()
  window:popWindow()
end)

function class.create(param)
  local self = base.create("legendEquipWindow")
  setmetatable(self, class.mt)
  self:init(param or {})
  return self
end

function class:init(param)
  self.legendEquip = param.legendEquip
  self.typeId = self.legendEquip._type_id
  self.legendEquipCfg = ed.getDataTable("LegendEquip")[self.typeId]
  self.legendEquipEnhanceCfg = ed.getDataTable("LegendEquipEnhance")[self.typeId]
  self.oldLegendEquip = self.legendEquip
  self.mgr = ed.legendEquipMgr.getInstance()
  self:initData()
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
end

function class:initData()
  local skillUnlockInfo = ed.legendEquipTool.getLegendEquipUnlockInfo(self.legendEquip)
  self.skillUnlockInfo = skillUnlockInfo
  self.maxStar, self.maxRank = ed.legendEquipTool.getLegendEquipMaxInfo(self.legendEquip)
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.legend_equip_window)
  self.container:addChild(container)
  self.ui = ui
  self:initRankBar()
  self:initEffect()
  self:initLabels()
  self:initDragList()
  self:refreshUI()
end

function class:initRankBar()
  self.ui.bar:setVisible(false)
  local progress = CCProgressTimer:create(self.ui.bar)
  progress:setType(kCCProgressTimerTypeBar)
  progress:setPosition(self.ui.bar:getPosition())
  progress:setAnchorPoint(self.ui.bar:getAnchorPoint())
  self.ui.image_rank_bar_bg:addChild(progress)
  progress:setMidpoint(ccp(0, 1))
  progress:setBarChangeRate(ccp(1, 0))
  self.bar = progress
  self.ui.image_rank_arrow:setVisible(false)
  local progressArrow = CCProgressTimer:create(self.ui.image_rank_arrow)
  progressArrow:setType(kCCProgressTimerTypeBar)
  progressArrow:setPosition(self.ui.image_rank_arrow:getPosition())
  progressArrow:setAnchorPoint(self.ui.image_rank_arrow:getAnchorPoint())
  self.ui.image_rank_bar_bg:addChild(progressArrow)
  progressArrow:setMidpoint(ccp(0, 1))
  progressArrow:setBarChangeRate(ccp(1, 0))
  self.arrowBar = progressArrow
end

function class:initEffect()
  local particle = CCParticleSystemQuad:create("UI/particle/blend/weiyizhuangbei.plist")
  self.ui.image_only_tag:addChild(particle, 1)
  ed.layout.centerInParent(particle)
  local fire_left = ed.createSpine("effect/eff_UI_legendequip_fire/eff_UI_legendequip_fire", 0.5)
  fire_left:setScaleX(-1)
  self.ui.image_bg:addChild(fire_left, 0)
  fire_left:setAnimation(0, "Idle", true)
  fire_left:setPosition(ccp(145, 195))
  local fire_right = ed.createSpine("effect/eff_UI_legendequip_fire/eff_UI_legendequip_fire", 0.5)
  fire_right:setScaleX(1)
  self.ui.image_bg:addChild(fire_right, 0)
  fire_right:setAnimation(0, "Idle", true)
  fire_right:setPosition(ccp(445, 195))
  local time = 3
  local poxX = 0
  local poxY = 10
  self.ui.equip_icon:runAction(CCRepeatForever:create(CCSequence:create(ccArrayMake(CCMoveBy:create(time * 0.155, ccp(poxX * 0.1, poxY * 0.1)), CCMoveBy:create(time * 0.12, ccp(poxX * 0.1, poxY * 0.1)), CCMoveBy:create(time * 0.095, ccp(poxX * 0.1, poxY * 0.1)), CCMoveBy:create(time * 0.08, ccp(poxX * 0.1, poxY * 0.1)), CCMoveBy:create(time * 0.07, ccp(poxX * 0.1, poxY * 0.1)), CCMoveBy:create(time * 0.07, ccp(poxX * 0.1, -poxY * 0.1)), CCMoveBy:create(time * 0.08, ccp(poxX * 0.1, -poxY * 0.1)), CCMoveBy:create(time * 0.095, ccp(poxX * 0.1, -poxY * 0.1)), CCMoveBy:create(time * 0.12, ccp(poxX * 0.1, -poxY * 0.1)), CCMoveBy:create(time * 0.155, ccp(poxX * 0.1, -poxY * 0.1))))))
end

function class:initLabels()
  local equipName = ed.ui.gradientLabel.create({
    text = self.legendEquipCfg["Equip Name"],
    fontSize = 22,
    startColor = ed.toccc3(16777215),
    endColor = ed.toccc3(16776069),
    strokeSize = 1,
    strokeColor = ed.toccc3(2565412)
  })
  self.equipName = equipName
  self.ui.image_name_bg:addChild(equipName.node)
  equipName.node:setPosition(self.ui.equip_name_pos:getPosition())
  local onlyTag = ed.ui.gradientLabel.create({
    text = T("\229\148\175\228\184\128\232\163\133\229\164\135"),
    fontSize = 13,
    startColor = ed.toccc3(16777215),
    endColor = ed.toccc3(16776069)
  })
  self.ui.image_only_tag:addChild(onlyTag.node)
  ed.layout.centerInParent(onlyTag.node)
  local fullStar = ed.ui.gradientLabel.create({
    text = T("\232\163\133\229\164\135\229\183\178\230\187\161\230\152\159"),
    fontSize = 21,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16774590),
    endColor = ed.toccc3(16770161)
  })
  self.ui.image_max_star:addChild(fullStar.node)
  ed.layout.centerInParent(fullStar.node)
  ed.setLabelShadow(self.ui.label_up, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelStroke(self.ui.label_title_attr, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_title_skill, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_skill_name, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_rune_name_1, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_rune_name_2, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_skill_lock, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_rune_lock_1, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_rune_lock_2, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_bind_hero, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_unbind, ed.toccc3(10906909), 1)
  ed.setLabelStroke(self.ui.label_reset, ed.toccc3(594187), 1)
end

function class:initDragList()
  self.attrDragList = ed.UITool.createDraglist(self.ui.panel_attr_list, {priority = -300})
  self.skillDescDragList = ed.UITool.createDraglist(self.ui.panel_skill_desc, {priority = -300})
end

function class:refreshUI()
  self:refreshLegendEquipIcon()
  self:refreshOnlyTag()
  self:refreshStarPanel()
  self:refreshRankBar()
  self:refreshUpgradeTips()
  self:refreshCostItem()
  self:refreshBindInfo()
  self:refreshAttr()
  self:refreshSkill()
  self:refreshRune()
  self:refreshReset()
end

function class:refreshLegendEquipIcon()
  ed.setTexture(self.ui.equip_icon, self.legendEquipCfg.Painting)
end

function class:refreshOnlyTag()
  local isOnly = ed.getDataTable("LegendEquip")[self.typeId]["Is Only"]
  self.ui.image_only_tag:setVisible(isOnly)
end

function class:refreshStarPanel()
  local panelSize = self.ui.panel_star:getContentSize()
  local curStar = self.legendEquip._star
  local curRank = self.legendEquip._rank
  local nodeList = {}
  self.ui.panel_star:removeAllChildrenWithCleanup(true)
  local isUpStar = self.legendEquipEnhanceCfg[curStar][curRank]["Is UpStar"]
  if isUpStar then
    ed.setLabelString(self.ui.label_up, T("\229\141\135\230\152\159"))
  else
    ed.setLabelString(self.ui.label_up, T("\229\141\135\233\152\182"))
  end
  local node = self:createStar(curStar, self.maxStar)
  self.starNode = node
  self.ui.panel_star:addChild(node)
  table.insert(nodeList, node)
  ed.layout.horizontalSortNode(nodeList, nil, panelSize.width / 2)
end

function class:refreshReset()
  local isOnly = ed.getDataTable("LegendEquip")[self.typeId]["Is Only"]
  local curStar = self.legendEquip._star
  self.ui.btn_reset:setVisible(not isOnly and 1 < curStar)
end

function class:createStar(star, maxStar)
  local totalWidth = 0
  local node = CCSprite:create()
  for index = 1, maxStar do
    local imageStar
    if index <= star then
      imageStar = ed.createSprite("UI/alpha/1080P/legendequip/star_unlock.png")
    else
      imageStar = ed.createSprite("UI/alpha/1080P/legendequip/star_lock.png")
    end
    local size = imageStar:getContentSize()
    node:addChild(imageStar)
    imageStar:setPositionX(totalWidth + size.width / 2)
    totalWidth = totalWidth + size.width
    node["star_" .. index] = imageStar
  end
  node:setContentSize(CCSizeMake(totalWidth, 0))
  return node
end

function class:refreshBindInfo()
  local bindHero = self.legendEquip._carried_hero_id
  if bindHero and 0 < bindHero then
    self.ui.btn_bind:setVisible(false)
    self.ui.image_bind_info_bg:setVisible(true)
    local nextUnequipTime = self.legendEquip._next_unequip_time
    if nextUnequipTime and nextUnequipTime > ed.getServerTime() then
      local leftTime = nextUnequipTime - ed.getServerTime()
      local day = math.floor(leftTime / 86400)
      local hour = math.floor(leftTime % 86400 / 3600)
      local min = math.floor(leftTime % 3600 / 60)
      if 1 <= day then
        ed.setLabelString(self.ui.label_bind_hero, string.format("%s\229\164\169%s\230\151\182\229\144\142\229\143\175\232\167\163\231\187\145", day, hour))
      else
        ed.setLabelString(self.ui.label_bind_hero, string.format("%s\230\151\182%s\229\136\134\229\144\142\229\143\175\232\167\163\231\187\145", hour, min))
      end
      ed.updateSpriteStone(self.ui.btn_unbind, true)
      ed.setLabelColor(self.ui.label_unbind, ccc3(255, 252, 231))
    else
      local heroName = ed.getDataTable("Unit")[bindHero]["Display Name"]
      ed.setLabelString(self.ui.label_bind_hero, string.format(T("%s\229\183\178\231\187\145\229\174\154"), heroName))
      ed.updateSpriteStone(self.ui.btn_unbind, false)
    end
    ed.setLabelColor(self.ui.label_bind_hero, ed.toccc3(16771782))
    local heroIcon = ed.readhero.createIconByID(bindHero).icon
    self.ui.panel_bind_hero:addChild(heroIcon)
    ed.layout.centerInParent(heroIcon)
    heroIcon:setScale(0.4)
  else
    self.ui.btn_bind:setVisible(true)
    self.ui.label_bind:runAction(ed.UITool.getBreathActionByOpacity(0.8, 255, 100))
    self.ui.btn_bind:runAction(ed.UITool.getBreathActionByOpacity(0.8, 255, 100))
    self.ui.image_bind_add:runAction(ed.UITool.getBreathActionByOpacity(0.8, 255, 100))
    self.ui.image_bind_info_bg:setVisible(false)
  end
end

function class:refreshRankBar()
  local curStar = self.legendEquip._star
  local curRank = self.legendEquip._rank
  local maxRank = self.maxRank
  if self.maxStar == curStar and curRank == maxRank then
    self.ui.image_rank_bar_bg:setVisible(false)
    self.ui.btn_up:setVisible(false)
    return
  else
    self.ui.image_rank_bar_bg:setVisible(true)
    self.ui.btn_up:setVisible(true)
  end
  local barSize = self.ui.bar:getContentSize()
  self.bar:removeAllChildrenWithCleanup(true)
  for rank = 1, self.maxRank do
    local starBg = ed.createSprite("UI/alpha/1080P/legendequip/newline3.png")
    self.bar:addChild(starBg)
    starBg:setPosition(ccp(rank / (self.maxRank + 1) * barSize.width, barSize.height / 2))
    local imageRankStar = ed.createSprite("UI/alpha/1080P/legendequip/line3.png")
    starBg:addChild(imageRankStar)
    ed.layout.centerInParent(imageRankStar)
    self.ui["star_" .. rank] = imageRankStar
    imageRankStar:setVisible(rank <= curRank)
  end
  self.ui.image_next_star:setVisible(false)
  self.ui.image_full_star:setVisible(false)
  self.bar:setPercentage(curRank / (self.maxRank + 1) * 100)
  self.arrowBar:setPercentage(0)
end

function class:refreshUpgradeTips()
  self.ui.next_star_tips_bg:removeAllChildrenWithCleanup(true)
  local attrChange, newSkill = ed.legendEquipTool.getLegendEquipAttrChange(self.legendEquip)
  local curStar = self.legendEquip._star
  local curRank = self.legendEquip._rank
  local isUpStar = self.legendEquipEnhanceCfg[curStar][curRank]["Is UpStar"]
  local desc = ""
  if isUpStar then
    if 0 < #newSkill then
      local skillId = newSkill[1]
      local skillCfg = ed.getDataTable("LegendEquipSkill")[skillId]
      local skillName = skillCfg["Display Name"]
      local type = skillCfg["Skill Type"]
      desc = string.format(T("\229\141\135\230\152\159\239\188\154\232\163\133\229\164\135\229\177\158\230\128\167\229\164\167\229\185\133\230\143\144\229\141\135\239\188\140\232\167\163\233\148\129%s<lable color=ccc3(254,211,109)>%s</lable>"), type == "Skill" and T("\230\138\128\232\131\189") or T("\231\172\166\230\150\135"), skillName)
    else
      desc = string.format(T("\229\141\135\230\152\159\239\188\154\232\163\133\229\164\135\229\177\158\230\128\167\229\164\167\229\185\133\230\143\144\229\141\135"))
    end
  elseif 0 < #attrChange then
    local attrName = attrChange[1].attrName
    local changeValue = attrChange[1].changeValue
    desc = string.format(T("\228\184\139\228\184\170\232\138\130\231\130\185\239\188\154\230\143\144\229\141\135<lable color=ccc3(112,255,84)>%s</lable>\231\130\185%s"), changeValue, ed.ui.baseres.att_cn_name[attrName] or "")
  end
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = desc,
    color = ed.toccc3(16771782),
    maxWidth = 9999,
    fontSize = 15,
    strokeColor = ed.toccc3(2565412),
    strokeSize = 1
  })
  local w, h = autoText:getCurContentSize()
  self.ui.next_star_tips_bg:addChild(autoText.node)
  local bgSize = self.ui.next_star_tips_bg:getContentSize()
  autoText.node:setPosition(ccp(bgSize.width / 2 - w / 2, bgSize.height / 2))
end

function class:refreshCostItem()
  local id = self.legendEquip._id
  local typeId = self.legendEquip._type_id
  local star = self.legendEquip._star
  local rank = self.legendEquip._rank
  if self.maxStar == star and rank == self.maxRank then
    self.ui.image_max_star:setVisible(true)
    self.ui.image_item_bg:setVisible(false)
    return
  else
    self.ui.image_max_star:setVisible(false)
    self.ui.image_item_bg:setVisible(true)
  end
  local enhanceCfg = self.legendEquipEnhanceCfg[star][rank]
  local costItemList = {}
  local costPrice = enhanceCfg["Cost Price"]
  local ownPrice = ed.player:getPoint("gold")
  self.goldEnough = costPrice <= ownPrice
  if 0 < costPrice then
    table.insert(costItemList, {type = "Gold", amount = costPrice})
  end
  self.itemEnough = true
  for index = 1, 10 do
    local costItemId = enhanceCfg[string.format("Cost Item ID %s", index)]
    if not costItemId or costItemId == 0 then
      break
    end
    local costItemAmount = enhanceCfg[string.format("Cost Item Amount %s", index)]
    local ownAmount = ed.player:getEquipAmount(costItemId)
    table.insert(costItemList, {
      type = "item",
      id = costItemId,
      amount = costItemAmount,
      ownAmount = ownAmount
    })
    self.itemEnough = self.itemEnough and costItemAmount <= ownAmount
  end
  local costEquipAmount = enhanceCfg["Cost Equip Amount"]
  if 0 < costEquipAmount then
    local ownAmount = self.mgr:getCanCostEquipAmount(typeId, id)
    table.insert(costItemList, {
      type = "legend_equip",
      id = typeId,
      amount = costEquipAmount,
      ownAmount = ownAmount
    })
    self.itemEnough = self.itemEnough and costEquipAmount <= ownAmount
  end
  local bgSize = self.ui.image_item_bg:getContentSize()
  self.ui.image_item_bg:removeAllChildrenWithCleanup(true)
  local itemList = {}
  local totalWidth = 0
  for index, itemCfg in ipairs(costItemList) do
    local needAmount = itemCfg.amount
    local ownAmount = itemCfg.ownAmount
    local itemIcon = ed.createItemIcon({
      id = itemCfg.id,
      type = itemCfg.type,
      amount = 0
    })
    local labelNeedAmount, labelOwnAmount
    if ownAmount then
      labelNeedAmount = ed.createLabelTTF(string.format("/%s", needAmount), 20)
      labelOwnAmount = ed.createLabelTTF(ownAmount, 20)
      labelOwnAmount:setPosition(ccp(80 - labelNeedAmount:getContentSize().width, 20))
    else
      labelNeedAmount = ed.createLabelTTF(needAmount, 20)
    end
    itemIcon:addChild(labelNeedAmount)
    ed.setLabelColor(labelNeedAmount, ed.toccc3(16776423))
    ed.setLabelColor(labelNeedAmount, ed.toccc3(16776423))
    labelNeedAmount:setAnchorPoint(ccp(1, 0.5))
    labelNeedAmount:setStroke(ccc3(39, 37, 36), 1)
    labelNeedAmount:setPosition(ccp(80, 20))
    if labelOwnAmount then
      itemIcon:addChild(labelOwnAmount)
      labelOwnAmount:setAnchorPoint(ccp(1, 0.5))
      labelOwnAmount:setStroke(ccc3(39, 37, 36), 1)
      if needAmount > ownAmount then
        ed.setLabelColor(labelOwnAmount, ed.toccc3(15806515))
      else
        ed.setLabelColor(labelOwnAmount, ed.toccc3(16776423))
      end
    end
    self.ui.image_item_bg:addChild(itemIcon)
    table.insert(itemList, itemIcon)
    itemIcon:setPositionY(bgSize.height / 2)
    totalWidth = totalWidth + itemIcon:getContentSize().width * itemIcon:getScale()
    self:btRegisterButtonClick({
      button = itemIcon,
      key = "click_cost_item" .. index,
      clickHandler = function()
        ed.UITool.openView("packageDetail", {
          id = itemCfg.id,
          type = itemCfg.type
        })
      end,
      force = true,
      mcpMode = true
    })
  end
  ed.layout.horizontalSortNode(itemList, nil, bgSize.width / 2)
end

function class:playAttrChangeAnim()
  local oldStar = self.oldLegendEquip._star
  local oldRank = self.oldLegendEquip._rank
  local newStar = self.legendEquip._star
  local newRank = self.legendEquip._rank
  if oldStar > newStar or newStar == oldStar and oldRank > newRank then
    return
  end
  local attrChange, _ = ed.legendEquipTool.getLegendEquipAttrChange(self.oldLegendEquip)
  for index, attrChangeCfg in ipairs(attrChange) do
    local attrName = attrChangeCfg.attrName
    local changeValue = attrChangeCfg.changeValue
    local attrAnimText = ed.ui.baseres.att_anim_name[attrName] or ""
    local label = ed.createNode({
      t = "Label",
      base = {
        text = attrAnimText .. "+" .. changeValue,
        size = 20
      },
      layout = {
        position = ccp(301.25, 290)
      },
      config = {
        color = ccc3(0, 255, 0),
        stroke = {
          color = ccc3(0, 0, 0),
          size = 2
        },
        visible = false
      }
    }, self.ui.image_bg)
    label:setZOrder(5)
    local delay = CCDelayTime:create(0.4 * index)
    local func = CCCallFunc:create(function()
      label:setVisible(true)
    end)
    local fade = CCFadeOut:create(0.8)
    local move = CCMoveBy:create(0.5, ccp(0, 50))
    label:runAction(ed.readaction.create({
      t = "seq",
      delay,
      func,
      {
        t = "sp",
        fade,
        move
      }
    }))
  end
end

function class:playGsChangeAnim()
  local oldStar = self.oldLegendEquip._star
  local oldRank = self.oldLegendEquip._rank
  local oldGs = self.legendEquipEnhanceCfg[oldStar][oldRank].GS
  local newStar = self.legendEquip._star
  local newRank = self.legendEquip._rank
  local newGs = self.legendEquipEnhanceCfg[newStar][newRank].GS
  if oldGs < newGs then
    local bg = ed.createSprite("UI/alpha/1080P/hero/hero_gs_up_bg.png")
    bg:setCascadeOpacityEnabled(true)
    self.ui.image_bg:addChild(bg)
    bg:setPosition(ccp(301.25, 310))
    local preGs = ed.getNumberNodeEx({
      text = oldGs,
      folder = "hero_gs",
      padding = -1
    }).node
    local addGs = ed.getNumberNodeEx({
      text = math.abs(newGs - oldGs),
      folder = "hero_gs_up",
      padding = -1
    }).node
    preGs:setCascadeOpacityEnabled(true)
    addGs:setCascadeOpacityEnabled(true)
    local gsText = ed.createSprite("UI/alpha/1080P/hero/hero_gs_up.png")
    local iconAdd = ed.createSprite(newGs and "UI/alpha/1080P/hero/hero_upgrade_add.png" or "UI/alpha/1080P/hero/hero_upgrade_sub.png")
    gsText:setPosition(130, 20)
    iconAdd:setPosition(260, 20)
    preGs:setPosition(210, 20)
    addGs:setPosition(300, 20)
    bg:addChild(gsText)
    bg:addChild(iconAdd)
    bg:addChild(preGs)
    bg:addChild(addGs)
    local fadeTo = CCFadeTo:create(0.1, 255)
    local move = CCMoveBy:create(0.1, ccp(0, 20))
    local fadeTo2 = CCFadeTo:create(0.4, 0)
    local callFunc = CCCallFunc:create(function()
      bg:removeFromParentAndCleanup(true)
    end)
    bg:runAction(CCSequence:create(ccArrayMake(CCSpawn:create(ccArrayMake(fadeTo, move)), fadeTo2, callFunc)))
  end
end

function class:playUpgradeAnim(finishCallBack)
  self.isPlayUpgradeAnim = true
  local curStar = self.legendEquip._star
  local curRank = self.legendEquip._rank
  local isMaxRank = curRank == self.maxRank
  if isMaxRank then
    local nextStar = curStar + 1
    ed.playEffect(ed.sound.deo.fire_forge_up2)
    self.bar:runAction(CCSequence:create(ccArrayMake(CCProgressTo:create(0.7, 100), CCCallFunc:create(function()
      local star = ed.createSpine("effect/eff_UI_legendequip_star/eff_UI_legendequip_star", 0.5)
      star:setAnimation(0, "Idle", false)
      self.ui.image_rank_bar_bg:addChild(star)
      star:setPosition(self.ui.image_full_star:getPosition())
    end), CCDelayTime:create(0.1), CCCallFunc:create(function()
      self.ui.image_full_star:setVisible(true)
    end))))
    self.arrowBar:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.7), CCProgressTo:create(0.7, 100))))
    local star2 = ed.createSpine("effect/eff_UI_legendequip_star2/eff_UI_legendequip_star2", 0.5)
    self.mainLayer:addChild(star2)
    star2:setVisible(false)
    local targetNode = self.starNode["star_" .. nextStar]
    local startPos = ed.getWorldPos(self.ui.image_next_star)
    local mainLayerPos = ed.getWorldPos(self.mainLayer)
    local targetPos = ed.getWorldPos(targetNode)
    targetPos = ccpSub(targetPos, mainLayerPos)
    star2:setPosition(startPos)
    star2:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(1.4), CCCallFunc:create(function()
      star2:setVisible(true)
      star2:setAnimation(0, "Idle", false)
    end), CCDelayTime:create(0.9333333333333333), CCCallFunc:create(function()
      self.ui.image_next_star:setVisible(true)
    end), CCMoveTo:create(0.4, targetPos), CCCallFunc:create(function()
      self:playEquipAnim()
      if finishCallBack then
        finishCallBack()
      end
    end))))
    local delay = CCDelayTime:create(1.4)
    local call = CCCallFunc:create(function()
      if nextStar == self.skillUnlockInfo.skill_unlock_star then
        self.ui.image_skill_lock:setVisible(false)
        local skill_unlock_eff = ed.createFcaNode("eff_UI_legendequip_Unlock")
        self.ui.image_skill_detail_bg:addChild(skill_unlock_eff)
        self:addFca(skill_unlock_eff)
        skill_unlock_eff:setPosition(ccp(43, 153))
      end
      if nextStar == self.skillUnlockInfo.rune_1_unlock_star then
        local rune_unlock_eff_1 = ed.createFcaNode("eff_UI_legendequip_Unlock2")
        self.ui.image_rune_1:addChild(rune_unlock_eff_1)
        self:addFca(rune_unlock_eff_1)
        rune_unlock_eff_1:setPosition(ccp(22, 18.5))
      end
      if nextStar == self.skillUnlockInfo.rune_2_unlock_star then
        local rune_unlock_eff_2 = ed.createFcaNode("eff_UI_legendequip_Unlock2")
        self.ui.image_rune_2:addChild(rune_unlock_eff_2)
        self:addFca(rune_unlock_eff_2)
        rune_unlock_eff_2:setPosition(ccp(22, 18.5))
      end
    end)
    self.ui.image_skill_detail_bg:runAction(CCSequence:create(ccArrayMake(delay, call)))
    self.mainLayer:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(3), CCCallFunc:create(function()
      self.isPlayUpgradeAnim = false
    end))))
  else
    local nextRank = curRank + 1
    ed.playEffect(ed.sound.deo.fire_forge_up1)
    local progressAction = CCProgressTo:create(0.3, nextRank / (self.maxRank + 1) * 100)
    self.bar:runAction(progressAction)
    local node = self.ui["star_" .. nextRank]
    node:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.3), CCCallFunc:create(function()
      local star1 = ed.createSpine("effect/eff_UI_legendequip_star/eff_UI_legendequip_star", 0.5)
      star1:setAnimation(0, "Idle", false)
      self.bar:addChild(star1)
      star1:setPosition(node:getParent():getPosition())
      self:playEquipAnim()
    end), CCDelayTime:create(0.1), CCCallFunc:create(function()
      self.isPlayUpgradeAnim = false
      node:setVisible(true)
      if finishCallBack then
        finishCallBack()
      end
    end))))
    self.mainLayer:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.6), CCCallFunc:create(function()
      self.isPlayUpgradeAnim = false
    end))))
  end
end

function class:playEquipAnim()
  local path = self.legendEquipCfg.Painting
  local blendFunc = ccBlendFunc()
  blendFunc.src = GL_ONE
  blendFunc.dst = GL_ONE
  local sprite2 = ed.createSprite(path)
  sprite2:setScale(1.1)
  self.ui.equip_icon:addChild(sprite2)
  ed.layout.centerInParent(sprite2)
  sprite2:setBlendFunc(blendFunc)
  local scaleAction = CCScaleTo:create(0.6, 1.5)
  local fadeAction = CCFadeTo:create(0.6, 0)
  local callFunc = CCCallFunc:create(function()
    sprite2:removeFromParentAndCleanup(true)
  end)
  local spawn = CCSpawn:createWithTwoActions(scaleAction, fadeAction)
  sprite2:runAction(CCSequence:create(ccArrayMake(spawn, callFunc)))
  local sprite3 = ed.createSprite(path)
  sprite3:setScale(1.2)
  self.ui.equip_icon:addChild(sprite3)
  ed.layout.centerInParent(sprite3)
  sprite3:setBlendFunc(blendFunc)
  local scaleAction = CCScaleTo:create(0.6, 1.6)
  local fadeAction = CCFadeTo:create(0.6, 0)
  local spawn = CCSpawn:createWithTwoActions(scaleAction, fadeAction)
  local callFunc = CCCallFunc:create(function()
    sprite3:removeFromParentAndCleanup(true)
  end)
  sprite3:runAction(CCSequence:create(ccArrayMake(spawn, callFunc)))
end

function class:refreshAttr()
  local panelSize = self.ui.panel_attr_list:getContentSize()
  self.attrDragList:clearList()
  local star = self.legendEquip._star
  local rank = self.legendEquip._rank
  local enhanceCfg = self.legendEquipEnhanceCfg[star][rank]
  local totalHeight = 0
  local gapY = 0
  for index = 1, 50 do
    local attrName = enhanceCfg["Attr Type " .. index]
    if not attrName then
      break
    end
    local attrValue = enhanceCfg["Attr Value " .. index]
    local attrItem, itemSize = self:createAttrItem(index, attrName, attrValue)
    self.attrDragList:addItem(attrItem)
    attrItem:setPosition(ccp(panelSize.width / 2, panelSize.height - totalHeight - itemSize.height / 2))
    totalHeight = totalHeight + itemSize.height + gapY
  end
  self.attrDragList:initListHeight(totalHeight)
end

function class:createAttrItem(index, attrName, attrValue)
  local bgPath
  if index % 2 == 1 then
    bgPath = "UI/alpha/1080P/legendequip/attribute1.png"
  else
    bgPath = "UI/alpha/1080P/legendequip/attribute2.png"
  end
  local container = ed.createScale9Sprite(bgPath, CCRectMake(30, 8, 8, 8))
  local size = CCSizeMake(336, 27)
  container:setContentSize(size)
  local labelName = ed.createLabelTTF(ed.ui.baseres.att_cn_name[attrName] or "", 16)
  ed.setLabelColor(labelName, ed.toccc3(16771782))
  ed.setLabelStroke(labelName, ed.toccc3(2565412), 1)
  labelName:setAnchorPoint(ccp(0, 0.5))
  container:addChild(labelName)
  labelName:setPosition(ccp(30, size.height / 2))
  local attrNum = attrValue
  if ed.ui.baseres.att_suffix[attrName] then
    attrNum = attrNum .. ed.ui.baseres.att_suffix[attrName]
  end
  local labelAttr = ed.createLabelTTF(attrNum, 16)
  ed.setLabelColor(labelAttr, ed.toccc3(16771782))
  ed.setLabelStroke(labelAttr, ed.toccc3(2565412), 1)
  labelAttr:setAnchorPoint(ccp(1, 0.5))
  container:addChild(labelAttr)
  labelAttr:setPosition(ccp(size.width - 20, size.height / 2))
  return container, size
end

function class:refreshSkill()
  local skill_unlock_star = self.skillUnlockInfo.skill_unlock_star
  local skill_id = self.skillUnlockInfo.skill_id
  local skill_is_unlock = self.skillUnlockInfo.skill_is_unlock
  local skillCfg = ed.getDataTable("LegendEquipSkill")[skill_id]
  ed.setLabelString(self.ui.label_skill_name, skillCfg["Display Name"])
  local clipNode, icon = ed.createClippingNodeEx(skillCfg.Icon, "UI/alpha/1080P/legendequip/skill_mask.png", nil, CCSizeMake(0, 0))
  self.ui.image_skill_frame:addChild(clipNode, -1)
  ed.layout.centerInParent(clipNode)
  if skill_is_unlock then
    ed.setLabelColor(self.ui.label_skill_name, ed.toccc3(16771782))
    ed.updateSpriteGray(icon, false)
    self.ui.label_skill_lock:setVisible(false)
    self.ui.image_skill_lock:setVisible(false)
  else
    ed.setLabelString(self.ui.label_skill_lock, string.format(T("%s\230\152\159\232\167\163\233\148\129"), skill_unlock_star))
    ed.setLabelColor(self.ui.label_skill_name, ed.toccc3(10851710))
    ed.updateSpriteGray(icon, true)
    self.ui.label_skill_lock:setVisible(true)
    self.ui.image_skill_lock:setVisible(true)
  end
  local autoText = ed.legendEquipTool.getLegendEquipSkillDesc(skill_id, {
    maxWidth = self.ui.panel_skill_desc:getContentSize().width,
    fontSize = 15,
    color = skill_is_unlock and ed.toccc3(16771782) or ed.toccc3(10851710),
    strokeColor = ed.toccc3(2565412),
    strokeSize = 1
  })
  local w, h = autoText:getCurContentSize()
  self.skillDescDragList:clearList()
  self.skillDescDragList:addItem(autoText.node)
  autoText.node:setPosition(ccp(0, self.ui.panel_skill_desc:getContentSize().height - 8))
  self.skillDescDragList:initListHeight(h)
end

function class:refreshRune()
  local star = self.legendEquip._star
  local rune_1_is_unlock = self.skillUnlockInfo.rune_1_is_unlock
  local rune_1_id = self.skillUnlockInfo.rune_1_id
  local rune_1_unlock_star = self.skillUnlockInfo.rune_1_unlock_star
  local runeCfg_1 = ed.getDataTable("LegendEquipSkill")[rune_1_id]
  ed.setLabelString(self.ui.label_rune_name_1, string.format(T("\231\172\166\230\150\135-%s"), runeCfg_1["Display Name"]))
  ed.setTexture(self.ui.rune_icon_1, runeCfg_1.Icon, true)
  if rune_1_is_unlock then
    ed.setLabelColor(self.ui.label_rune_name_1, ed.toccc3(16771782))
    ed.setLabelString(self.ui.label_rune_lock_1, T("\229\183\178\232\167\163\233\148\129"))
    ed.setLabelColor(self.ui.label_rune_lock_1, ed.toccc3(7405396))
    ed.updateSpriteStone(self.ui.rune_icon_1, false)
  else
    ed.setLabelColor(self.ui.label_rune_name_1, ed.toccc3(10851710))
    ed.setLabelString(self.ui.label_rune_lock_1, string.format(T("%s\230\152\159\232\167\163\233\148\129"), rune_1_unlock_star))
    ed.setLabelColor(self.ui.label_rune_lock_1, ed.toccc3(16739438))
    ed.updateSpriteStone(self.ui.rune_icon_1, true)
  end
  local rune_2_is_unlock = self.skillUnlockInfo.rune_2_is_unlock
  local rune_2_id = self.skillUnlockInfo.rune_2_id
  local rune_2_unlock_star = self.skillUnlockInfo.rune_2_unlock_star
  local runeCfg_2 = ed.getDataTable("LegendEquipSkill")[rune_2_id]
  ed.setLabelString(self.ui.label_rune_name_2, string.format(T("\231\172\166\230\150\135-%s"), runeCfg_2["Display Name"]))
  ed.setTexture(self.ui.rune_icon_2, runeCfg_2.Icon, true)
  if rune_2_is_unlock then
    ed.setLabelColor(self.ui.label_rune_name_2, ed.toccc3(16771782))
    ed.setLabelString(self.ui.label_rune_lock_2, T("\229\183\178\232\167\163\233\148\129"))
    ed.setLabelColor(self.ui.label_rune_lock_2, ed.toccc3(7405396))
    ed.updateSpriteStone(self.ui.rune_icon_2, false)
  else
    ed.setLabelColor(self.ui.label_rune_name_2, ed.toccc3(10851710))
    ed.setLabelString(self.ui.label_rune_lock_2, string.format(T("%s\230\152\159\232\167\163\233\148\129"), rune_2_unlock_star))
    ed.setLabelColor(self.ui.label_rune_lock_2, ed.toccc3(16739438))
    ed.updateSpriteStone(self.ui.rune_icon_2, true)
  end
end

function class:onClickBtnBind()
  ed.UITool.openView("legendEquipBindHeroWindow", {
    legendEquip = self.legendEquip,
    confirmCallBack = function(heroId)
      ed.legendEquipNet.sendEquip(heroId, self.legendEquip._id)
    end
  })
end

function class:onClickBtnUnbind()
  local bindHero = self.legendEquip._carried_hero_id
  if bindHero and 0 < bindHero then
    local nextUnequipTime = self.legendEquip._next_unequip_time
    if nextUnequipTime and nextUnequipTime > ed.getServerTime() then
      local leftTime = nextUnequipTime - ed.getServerTime()
      local day = math.floor(leftTime / 86400)
      local hour = math.floor(leftTime % 86400 / 3600)
      local min = math.floor(leftTime % 3600 / 60)
      if 1 <= day then
        ed.showToast(string.format("%s\229\164\169%s\230\151\182\229\144\142\229\143\175\232\167\163\231\187\145", day, hour))
      else
        ed.showToast(string.format("%s\230\151\182%s\229\136\134\229\144\142\229\143\175\232\167\163\231\187\145", hour, min))
      end
      return
    end
  end
  ed.UITool.openView("legendEquipUnbindConfirm", {
    legendEquip = self.legendEquip,
    confirmCallBack = function()
      ed.legendEquipNet.sendUnEquip(self.legendEquip._carried_hero_id)
    end
  })
end

function class:onClickBtnUp()
  if not self.itemEnough or not self.goldEnough then
    ed.showToast(T("\230\157\144\230\150\153\228\184\141\232\182\179"))
    return
  end
  if self.isPlayUpgradeAnim then
    return
  end
  local star = self.legendEquip._star
  local rank = self.legendEquip._rank
  local isUpStar = self.legendEquipEnhanceCfg[star][rank]["Is UpStar"]
  if isUpStar then
    ed.UITool.openView("legendEquipStarUpConfirm", {
      legendEquip = self.legendEquip,
      confirmCallBack = function()
        self:playUpgradeAnim(function()
          ed.legendEquipNet.sendStarUp(self.legendEquip._id)
        end)
      end
    })
  else
    ed.UITool.openView("legendEquipRankUpConfirm", {
      legendEquip = self.legendEquip,
      confirmCallBack = function()
        self:playUpgradeAnim(function()
          ed.legendEquipNet.sendRankUp(self.legendEquip._id)
        end)
      end
    })
  end
end

function class:onClickBtnBreakDown()
  ed.UITool.openView("fireForgeBreakdownScene")
end

function class:onClickBtnReset()
  if self.isPlayUpgradeAnim then
    return
  end
  local isOnly = ed.getDataTable("LegendEquip")[self.typeId]["Is Only"]
  if isOnly then
    return
  end
  local curStar = self.legendEquip._star
  if curStar <= 1 then
    return
  end
  ed.UITool.openView("legendEquipResetConfirm", {
    legendEquip = self.legendEquip
  })
end

function class:onClickBtnAbandon()
  local discard
  if self.legendEquip._is_discard == 1 then
    discard = 0
  else
    discard = 1
    ed.showToast(T("\232\175\165\232\163\133\229\164\135\229\183\178\230\160\135\232\174\176\229\188\131\231\189\174\231\138\182\230\128\129"))
  end
  ed.legendEquipNet.sendDiscard(self.legendEquip._id, discard)
end

function class:onClickRune1()
  local rune_1_is_unlock = self.skillUnlockInfo.rune_1_is_unlock
  local rune_1_id = self.skillUnlockInfo.rune_1_id
  local rune_1_unlock_star = self.skillUnlockInfo.rune_1_unlock_star
  local window = ed.ui.legendEquipRuneDetailWindow.create(rune_1_id, rune_1_is_unlock, rune_1_unlock_star)
  window:popWindow()
  local parentSize = self.ui.image_rune_1:getContentSize()
  ed.layout.relateLayout(self.ui.image_rune_1, window.bg, {
    left = parentSize.width / 2,
    top = parentSize.height / 2
  })
end

function class:onClickRune2()
  local rune_2_is_unlock = self.skillUnlockInfo.rune_2_is_unlock
  local rune_2_id = self.skillUnlockInfo.rune_2_id
  local rune_2_unlock_star = self.skillUnlockInfo.rune_2_unlock_star
  local window = ed.ui.legendEquipRuneDetailWindow.create(rune_2_id, rune_2_is_unlock, rune_2_unlock_star)
  window:popWindow()
  local parentSize = self.ui.image_rune_2:getContentSize()
  ed.layout.relateLayout(self.ui.image_rune_2, window.bg, {
    left = parentSize.width / 2,
    top = parentSize.height / 2
  })
end

function class:onClickOnlyTag()
  ed.legendEquipTool.showLegendEquipOnlyTips(self.ui.image_only_tag)
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy()
  end, {normalScale = 0.75, pressScale = 0.7})
  ed.UITool.registerBtn(self, "btn_unbind", function()
    self:onClickBtnUnbind()
  end, {normalScale = 0.9, pressScale = 0.85})
  ed.UITool.registerBtn(self, "btn_bind", function()
    self:onClickBtnBind()
  end, {normalScale = 1, pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_up", function()
    self:onClickBtnUp()
  end, {normalScale = 0.75, pressScale = 0.7})
  ed.UITool.registerBtn(self, "btn_breakdown", function()
    self:onClickBtnBreakDown()
  end, {normalScale = 1, pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_abandon", function()
    self:onClickBtnAbandon()
  end, {normalScale = 1, pressScale = 0.95})
  ed.UITool.registerBtn(self, "image_rune_1", function()
    self:onClickRune1()
  end)
  ed.UITool.registerBtn(self, "image_rune_2", function()
    self:onClickRune2()
  end)
  ed.UITool.registerBtn(self, "image_only_tag", function()
    self:onClickOnlyTag()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_reset", function()
    self:onClickBtnReset()
  end, {pressScale = 0.95})
end

function class:onUpdateLegendEquip(id)
  if id == self.legendEquip._id then
    self.legendEquip = self.mgr:getLegendEquip(id)
    self:initData()
    self:refreshUI()
    self:playAttrChangeAnim()
    self:playGsChangeAnim()
    self.oldLegendEquip = self.legendEquip
  end
end

function class:onUnequipLegendEquip()
  ed.showToast(T("\232\167\163\231\187\145\230\136\144\229\138\159"))
  self:destroy()
end

function class:addEventListener()
  self:listenEvent("UpdateLegendEquip", function(id)
    self:onUpdateLegendEquip(id)
  end)
  self:listenEvent("UnequipLegendEquip", function()
    self:onUnequipLegendEquip()
  end)
end
