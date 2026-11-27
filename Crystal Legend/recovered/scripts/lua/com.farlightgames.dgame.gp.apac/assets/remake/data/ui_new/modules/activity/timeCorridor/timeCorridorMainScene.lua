local base = ed.ui.commonscene
local timeCorridorScene = newclass(base.mt)
ed.ui.timeCorridorScene = timeCorridorScene

function timeCorridorScene.create()
  local self = base.create("timeCorridorScene", {noBottomButton = true})
  setmetatable(self, timeCorridorScene.mt)
  self.eventScope = {}
  self:init()
  return self
end

function timeCorridorScene:init()
  self.endTime = ed.timeCorridorMgr.endTime
  self:initData()
  self:initUI()
  self:initDraglist()
  self:initLabel()
  self:registerEvents()
  self:registerBackGroundEvent()
end

function timeCorridorScene:initData()
  self.fcaPos = self.mainLayer:convertToNodeSpace(ed.display.center)
  self.mainFcaScale = self:getFcaScaleForAdapt()
  self.mainSKinId = ed.timeCorridorMgr:getMainSkinID()
  self.mainSKinId2 = ed.timeCorridorMgr:getMainSkinID2()
end

function timeCorridorScene:initUI()
  local container, ui = ed.editorui(ed.uieditor.timeCorridorScene)
  self.ui = ui
  self.container = container
  self.mainLayer:addChild(self.container)
  ed.layout.lazyAdaptBG(self.ui.bg_img)
  self.ui.theme_img:setScale(self.ui.bg_img:getScale())
  local imgSize = self.ui.theme_img:getContentSize()
  local imgScale = self.ui.theme_img:getScaleX()
  local deltaSize = ccp(imgSize.width * 0.5 * (1 - imgScale), imgSize.height * 0.5 * (1 - imgScale))
  ed.UITool.setPositionBy(self.ui.theme_img, ccp(-deltaSize.x, deltaSize.y * 0.6))
  ed.layout.layoutWithMagin(self.ui.layer_title, {left = 0, top = 0})
  ed.layout.layoutWithMagin(self.ui.btn_record, {left = 50, bottom = 50})
  ed.layout.layoutWithMagin(self.ui.btn_reward_pool, {left = 50, bottom = 130})
  self.ui.btn_skip:removeFromParentAndCleanup(false)
  self.mainLayer:addChild(ui.btn_skip, 99)
  ed.layout.layoutWithMagin(self.ui.btn_skip, {top = 0, right = 0})
  self.ui.btn_skip:setVisible(false)
  ed.setLabelStroke(self.ui.label_skip, ed.toccc3(3483679), 1)
  ed.layout.layoutWithMagin(self.ui.btn_shop, {right = 20, top = 45}, false, true)
  ed.layout.layoutWithMagin(self.ui.panel_reward, {right = 120, bottom = 20}, true)
  self:initBGSpine()
  self:initResourceBar()
  self:initRewardPanel()
  self:initRulePop()
  self:initCard()
  local touchMask = CCLayerColor:create(ccc4(127, 127, 127, 0))
  self.mainLayer:addChild(touchMask, 10)
  touchMask:registerScriptTouchHandler(self:clickSkipHandler(), false, -9999, true)
  touchMask:setTouchEnabled(false)
  self.touchMask = touchMask
  local mask = CCLayerColor:create(ccc4(127, 127, 127, 0))
  self.getTopNode():addChild(mask)
  mask:setTouchEnabled(false)
  self.mask = mask
end

function timeCorridorScene:initBGSpine()
  local spine = ed.createSpine("effect/eff_UI_skin_meteor/eff_UI_skin_meteor", 0.5)
  spine:setAnimation(0, "Idle", true)
  spine:setTimeScale(2)
  self.ui.bg_img:addChild(spine)
  spine:setZOrder(1)
  ed.layout.centerInParent(spine)
  local waterSpine = ed.createSpine("effect/eff_UI_skin_ripple/eff_UI_skin_ripple", 0.5)
  waterSpine:setAnimation(0, "Idle", true)
  self.ui.bg_img:addChild(waterSpine)
  waterSpine:setZOrder(2)
  local posX, posY = self.ui.bg_water_pos:getPosition()
  waterSpine:setPosition(ccp(posX, posY + 20))
end

function timeCorridorScene:initResourceBar()
  ed.layout.layoutWithMagin(self.ui.resource_bar, {right = 0, top = 0})
  local rb_conf = ed.timeCorridorMgr:getResourceBarInfo()
  for name, conf in pairs(rb_conf) do
    ed.setTexture(self.ui[name .. "_icon"], conf.uiRes)
    local scale = self.ui[name .. "_icon"]:getScaleX()
    local icon = self.ui[name .. "_icon"]
    self:btRegisterRectClick({
      rect = CCRectMake(0, 0, 30, 30),
      parent = self.ui[name .. "_icon"],
      pressHandler = function()
        if not tolua.isnull(icon) then
          icon:setScale(1.1 * scale)
        end
      end,
      cancelPressHandler = function()
        if not tolua.isnull(icon) then
          icon:setScale(scale)
        end
      end,
      clickHandler = function()
        ed.UITool.openView("packageDetail", {
          id = conf.itemId,
          type = "item"
        })
      end,
      priority = ed.ui.commonscene.TOUCH_PRIORITY
    })
  end
  self:btRegisterRectClick({
    rect = CCRectMake(0, 0, 100, 28),
    parent = self.ui.moon_add,
    pressHandler = function()
      if not tolua.isnull(self.ui.moon_add) then
        self.ui.moon_add:setScale(1.1)
      end
    end,
    cancelPressHandler = function()
      if not tolua.isnull(self.ui.moon_add) then
        self.ui.moon_add:setScale(1)
      end
    end,
    clickHandler = function()
      ed.playEffect(ed.sound.main.clickRecharge)
      local ds = ed.playerlimit.getAreaUnlockPrompt("MallGift")
      if ds then
        ed.showToast(ds)
        return
      else
        ed.pushScene(ed.ui.RechargeScene.create({page = "Gift", giftItemId = 20470}))
      end
    end,
    priority = ed.ui.commonscene.TOUCH_PRIORITY
  })
  self:updateAllResourceValue()
end

function timeCorridorScene:getFcaScaleForAdapt()
  local resRatio = 1.8611111111111112
  local scale = 1
  local winRatio = ed.display.winSize.width / ed.display.winSize.height
  local designRatio = ed.display.designSize.width / ed.display.designSize.height
  if winRatio < designRatio then
    scale = ed.display.winSize.height / ed.display.designSize.height
  elseif resRatio < winRatio then
    scale = ed.display.winSize.width / ed.display.designSize.width
  end
  return scale
end

function timeCorridorScene:updateAllResourceValue()
  local rbRes = ed.timeCorridorMgr:getResourceBarInfo()
  for name, v in pairs(rbRes) do
    local num = ed.player:getEquipAmount(v.itemId) or 0
    self.ui[name .. "_num"]:setString(num)
  end
end

function timeCorridorScene:initRewardPanel()
  self.foldSize = self.ui.layer_reward:getContentSize()
  self.unfoldHeight = 388
  self.deltaHeight = self.unfoldHeight - self.foldSize.height
  self.ori_close_btn_pos_Y = self.ui.btn_reward_close:getPositionY()
  self.dest_close_btn_pos_Y = self.ori_close_btn_pos_Y + self.deltaHeight
end

function timeCorridorScene:foldRewardPanel(isFold, callBack)
  local deltaHeight = isFold and -self.deltaHeight or self.deltaHeight
  local destHeight = isFold and self.foldSize.height or self.unfoldHeight
  local deltaDLHei = isFold and -self.draglistSize.height or self.draglistSize.height
  local oriDLHei = isFold and self.draglistSize.height or 0
  local curDLHei = oriDLHei
  local times = 1
  self:listenTimer(Timer:Times(0.01, 10), function()
    times = times + 1
    local bgSize = self.ui.layer_reward:getContentSize()
    bgSize.height = bgSize.height + deltaHeight / 10
    self.ui.layer_reward:setContentSize(bgSize)
    self.ui.btn_reward_close:setPositionY(self.ui.btn_reward_close:getPositionY() + deltaHeight / 10)
    curDLHei = curDLHei + deltaDLHei / 10
    self.taskDraglist:setClipRect(CCRectMake(0, 0, self.draglistSize.width, curDLHei))
    if 9 < times then
      self.ui.layer_reward:setContentSize(CCSizeMake(self.foldSize.width, destHeight))
      self.ui.btn_reward_close:setPositionY(isFold and self.ori_close_btn_pos_Y or self.dest_close_btn_pos_Y)
      self.taskDraglist:setClipRect(CCRectMake(0, 0, self.draglistSize.width, oriDLHei + deltaDLHei))
      if callBack then
        callBack()
      end
    end
  end)
end

function timeCorridorScene:refreshLabel()
end

function timeCorridorScene:refreshUI()
  self:updateAllResourceValue()
  self:refreshLabel()
  self:refreshSummonTips()
end

function timeCorridorScene:refreshSummonTips()
  local ui = self.ui
  ui.free_times_bg:setVisible(false)
  ui.use_ticket_tip_one:setVisible(false)
  ui.use_ticket_tip_ten:setVisible(false)
  ui.label_discount_pos_ten:removeAllChildrenWithCleanup(true)
  ui.label_discount_pos_one:removeAllChildrenWithCleanup(true)
  ui.label_discount_pos_one:setVisible(false)
  ui.label_discount_pos_ten:setVisible(false)
  local singleCost = ed.timeCorridorMgr.summonCostPassNum
  local hasFreeSummon = ed.timeCorridorMgr.freeSummonTimes > 0
  local ticket_num = ed.player:getEquipAmount(ed.timeCorridorMgr.ticketId)
  local curCostOne = singleCost
  local curCostTen = singleCost * 10
  local costOneLabFont = ed.font
  if hasFreeSummon then
    ui.free_times_bg:setVisible(true)
    ui.label_free_times:setString(T("\229\137\1413\230\172\161\229\141\149\230\172\161\232\191\189\229\175\187\229\133\141\232\180\185%d/3", ed.timeCorridorMgr.freeSummonTimes))
    curCostOne = T("\229\133\141\232\180\185")
    costOneLabFont = ed.fontBold
  elseif 0 < ticket_num then
    ui.label_discount_pos_one:setVisible(true)
    local oriCostOne = ed.createLabelTTF(singleCost, 15)
    ed.setLabelColor(oriCostOne, ed.toccc3(16777215))
    ed.setLabelStroke(oriCostOne, ed.toccc3(8541986), 1)
    ui.label_discount_pos_one:addChild(oriCostOne)
    local line = ed.createSprite("UI/alpha/1080P/timecorridor/timecorridor_discount_line.png")
    ui.label_discount_pos_one:addChild(line)
    ui.use_ticket_tip_one:setVisible(true)
    ui.label_use_cnt_one:setString("1/" .. ticket_num)
    curCostOne = singleCost * 0.5
  end
  if 0 < ticket_num then
    ui.label_discount_pos_ten:setVisible(true)
    local oriCostTen = ed.createLabelTTF(curCostTen, 15)
    ed.setLabelColor(oriCostTen, ed.toccc3(16777215))
    ed.setLabelStroke(oriCostTen, ed.toccc3(8541986), 1)
    ui.label_discount_pos_ten:addChild(oriCostTen)
    local line = ed.createSprite("UI/alpha/1080P/timecorridor/timecorridor_discount_line.png")
    ui.label_discount_pos_ten:addChild(line)
    ui.use_ticket_tip_ten:setVisible(true)
    local useTicket = math.min(ticket_num, 10)
    ui.label_use_cnt_ten:setString(useTicket .. "/" .. ticket_num)
    curCostTen = singleCost * 0.5 * useTicket + singleCost * (10 - useTicket)
  end
  local isDiscount = 0 < ticket_num or hasFreeSummon
  local startColor = ed.toccc3(16774266)
  local endColor = ed.toccc3(16777215)
  local strokeColor = ed.toccc3(6894872)
  if self.summonOnceLab ~= nil then
    self.summonOnceLab:removeFromParentAndCleanup(true)
    self.summonOnceLab = nil
  end
  local gl_summon = ed.ui.gradientLabel.create({
    text = T("\232\191\189\229\175\187%d\230\172\161", 1),
    fontName = ed.fontBold,
    fontSize = 21,
    startColor = startColor,
    endColor = endColor,
    strokeColor = strokeColor,
    strokeSize = 1
  })
  self.ui.btn_one:addChild(gl_summon.node)
  if gl_summon.node:getContentSize().width > 107 then
    gl_summon.node:setScale(107 / gl_summon.node:getContentSize().width)
  end
  gl_summon.node:setPositionY(self.ui.one_icon:getPositionY())
  self.summonOnceLab = gl_summon.node
  if self.costLabelOne ~= nil then
    self.costLabelOne:removeFromParentAndCleanup(true)
    self.costLabelOne = nil
  end
  local gl_summon_cost = ed.ui.gradientLabel.create({
    text = curCostOne,
    fontName = costOneLabFont,
    fontSize = 22.5,
    startColor = startColor,
    endColor = endColor,
    strokeColor = strokeColor,
    strokeSize = 1
  })
  self.ui.btn_one:addChild(gl_summon_cost.node)
  gl_summon_cost.node:setPositionY(self.ui.one_icon:getPositionY())
  if ui.label_discount_pos_one:isVisible() then
    ed.layout.horizontalSortNode({
      gl_summon.node,
      self.ui.one_icon,
      gl_summon_cost.node,
      ui.label_discount_pos_one
    }, {
      4,
      4,
      15,
      0
    }, self.ui.btn_one:getContentSize().width * 0.5)
  else
    ed.layout.horizontalSortNode({
      gl_summon.node,
      self.ui.one_icon,
      gl_summon_cost.node
    }, {
      4,
      4,
      0
    }, self.ui.btn_one:getContentSize().width * 0.5)
  end
  self.costLabelOne = gl_summon_cost.node
  isDiscount = 0 < ticket_num
  if self.summonTenLab ~= nil then
    self.summonTenLab:removeFromParentAndCleanup(true)
    self.summonTenLab = nil
  end
  gl_summon = ed.ui.gradientLabel.create({
    text = T("\232\191\189\229\175\187%d\230\172\161", 10),
    fontName = ed.fontBold,
    fontSize = 21,
    startColor = startColor,
    endColor = endColor,
    strokeColor = strokeColor,
    strokeSize = 1
  })
  self.ui.btn_ten:addChild(gl_summon.node)
  if gl_summon.node:getContentSize().width > 107 then
    gl_summon.node:setScale(107 / gl_summon.node:getContentSize().width)
  end
  ed.left2(gl_summon.node, self.ui.ten_icon, 4)
  self.summonTenLab = gl_summon.node
  if self.costLabelTen ~= nil then
    self.costLabelTen:removeFromParentAndCleanup(true)
    self.costLabelTen = nil
  end
  gl_summon_cost = ed.ui.gradientLabel.create({
    text = curCostTen,
    fontName = ed.font,
    fontSize = 22.5,
    startColor = startColor,
    endColor = endColor,
    strokeColor = strokeColor,
    strokeSize = 1
  })
  self.ui.btn_ten:addChild(gl_summon_cost.node)
  ed.right2(gl_summon_cost.node, self.ui.ten_icon, 4)
  if ui.label_discount_pos_ten:isVisible() then
    ed.layout.horizontalSortNode({
      gl_summon.node,
      self.ui.ten_icon,
      gl_summon_cost.node,
      ui.label_discount_pos_ten
    }, {
      4,
      4,
      15,
      0
    }, self.ui.btn_ten:getContentSize().width * 0.5)
  else
    ed.layout.horizontalSortNode({
      gl_summon.node,
      self.ui.ten_icon,
      gl_summon_cost.node
    }, {
      4,
      4,
      0
    }, self.ui.btn_ten:getContentSize().width * 0.5)
  end
  self.costLabelTen = gl_summon_cost.node
  self.curCostOne = curCostOne
  self.curCostTen = curCostTen
end

function timeCorridorScene:initDraglist()
  self.firstOpen = true
  local draglist = ed.UITool.createDraglist(self.ui.reward_list, {priority = -300})
  self.taskDraglist = draglist
  self.draglistSize = self.ui.reward_list:getContentSize()
  self:refreshDraglist()
  self.taskDraglist:setClipRect(CCRectMake(0, 0, self.draglistSize.width, 0))
  self.taskDraglist:setTouchEnabled(false)
end

function timeCorridorScene:refreshDraglist()
  local panelSize = self.ui.reward_list:getContentSize()
  
  local function calcPos(index)
    local posX = panelSize.width * 0.5
    local oriPosY = panelSize.height - 30
    local delY = 85
    return ccp(posX, oriPosY - delY * (index - 1))
  end
  
  local tasklist = ed.timeCorridorMgr.activityTaskList
  local progress = ed.timeCorridorMgr.activityProgress
  local nextProgress
  local oldPosx, oldPosy = self.taskDraglist:getListPos()
  self.taskDraglist:clearList()
  local showIconInd = #tasklist
  local noComplete = true
  for i = 1, #tasklist do
    local ind = #tasklist + 1 - i
    local task = tasklist[ind]
    local icon = self:createTaskIcon(task)
    icon:setPosition(calcPos(i))
    self.taskDraglist:addItem(icon)
    if nil == nextProgress or progress < task.target then
      nextProgress = task.target
    end
    if self.firstOpen then
      if noComplete then
        showIconInd = i
        if progress >= task.target and not task.canGetReward then
          noComplete = false
        end
      elseif task.canGetReward then
        showIconInd = i
        noComplete = true
      end
    end
  end
  self.taskDraglist:initListHeight(#tasklist * 85)
  if self.firstOpen then
    self.taskDraglist:setListPos(ccp(0, -panelSize.height + 85 * showIconInd), true)
    self.firstOpen = nil
  else
    self.taskDraglist:setListPos(ccp(oldPosx, oldPosy), true)
  end
  progress = math.min(progress, nextProgress)
  local summon_num_label = ed.ui.gradientLabel.create({
    text = T("%s\230\138\189", progress .. "/" .. nextProgress),
    fontName = ed.font,
    fontSize = 15,
    startColor = ed.toccc3(16442623),
    endColor = ed.toccc3(16777215),
    strokeColor = ed.toccc3(4134718),
    strokeSize = 1
  })
  self.ui.label_pos:removeAllChildrenWithCleanup(true)
  self.ui.label_pos:addChild(summon_num_label.node)
  self.ui.red_tag:setVisible(not self.ui.layer_reward:isVisible() and ed.timeCorridorMgr:hasRewards())
end

function timeCorridorScene:refreshDraglistPos()
  local tasklist = ed.timeCorridorMgr.activityTaskList
  local progress = ed.timeCorridorMgr.activityProgress
  local showIconInd = #tasklist
  local noComplete = true
  for i = 1, #tasklist do
    local ind = #tasklist + 1 - i
    local task = tasklist[ind]
    if noComplete then
      showIconInd = i
      if progress >= task.target and not task.canGetReward then
        noComplete = false
      end
    elseif task.canGetReward then
      showIconInd = i
      noComplete = true
    end
  end
  local panelSize = self.ui.reward_list:getContentSize()
  self.taskDraglist:setListPos(ccp(0, -panelSize.height + 85 * showIconInd), true)
end

function timeCorridorScene:createTaskIcon(taskInfo)
  local reward = taskInfo.reward
  local icon = ed.createItemIcon({
    type = reward._type,
    id = reward._id,
    amount = reward._amount
  }, nil, 0.7)
  local iconSize = icon:getContentSize()
  local centerPos = ccp(iconSize.width * 0.5, iconSize.height * 0.5)
  if not taskInfo.achiv or taskInfo.canGetReward then
    if taskInfo.achiv then
      local eff = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
      eff:setScale(0.9)
      icon:addChild(eff)
      eff:setPosition(centerPos)
      eff:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
      local config = {
        button = icon,
        key = "get_reward" .. taskInfo.target,
        clickHandler = function()
          ed.activityHints.network:activitySubmit(ed.timeCorridorMgr.activityId, taskInfo.id, 1)
        end,
        force = true,
        mcpMode = true,
        mcp_dis = 30,
        clickInterval = 0.3,
        pressScale = 0.65,
        normalScale = 0.7,
        priority = -1,
        extraCheckHandler = function(x, y)
          return ed.containsPoint(self.ui.reward_list, x, y)
        end
      }
      self:btRegisterButtonClick(config)
    else
      local config = {
        button = icon,
        key = "show_reward" .. taskInfo.target,
        clickHandler = function()
          ed.UITool.openView("packageDetail", {
            id = reward._id,
            type = "item"
          })
        end,
        force = true,
        mcpMode = true,
        mcp_dis = 30,
        clickInterval = 0.3,
        pressScale = 0.65,
        normalScale = 0.7,
        priority = -1,
        extraCheckHandler = function(x, y)
          return ed.containsPoint(self.ui.reward_list, x, y)
        end
      }
      self:btRegisterButtonClick(config)
    end
    local bar_bg = ed.createSprite(ed.timeCorridorMgr.commonUIPath .. "timecorridor_line_reward_4.png")
    icon:addChild(bar_bg)
    bar_bg:setPosition(ccp(centerPos.x, -10))
    local target_lab = ed.createLabelTTF(taskInfo.target, 15)
    ed.setLabelColor(target_lab, ccc3(251, 227, 253))
    bar_bg:addChild(target_lab)
    ed.layout.centerInParent(target_lab)
    bar_bg:setScale(1.5)
  else
    local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
    local imageReceived = ed.createSprite("UI/alpha/1080P/package/selected.png")
    icon:addChild(mask)
    icon:addChild(imageReceived)
    imageReceived:setPosition(centerPos)
    mask:setPosition(centerPos)
    local bar_bg = ed.createSprite(ed.timeCorridorMgr.commonUIPath .. "timecorridor_line_reward_5.png")
    icon:addChild(bar_bg)
    bar_bg:setPosition(ccp(centerPos.x, -10))
    local target_lab = ed.createLabelTTF(taskInfo.target, 15)
    ed.setLabelColor(target_lab, ccc3(182, 154, 184))
    bar_bg:addChild(target_lab)
    ed.layout.centerInParent(target_lab)
    bar_bg:setScale(1.5)
  end
  return icon
end

function timeCorridorScene:initLabel()
  ed.setLabelStroke(self.ui.label_record, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_reward_pool, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.left_time_label, ed.toccc3(8931233), 1)
  ed.setLabelFontName(self.ui.Label_299, ed.fontBold)
  ed.setLabelStroke(self.ui.Label_299, ed.toccc3(13847445), 1)
  ed.setLabelFontName(self.ui.legend_color_label, ed.fontBold)
  ed.setLabelStroke(self.ui.legend_color_label, ed.toccc3(16345527), 1.5)
  local prismaticLab = ed.ui.gradientLabel.create({
    text = T("\229\133\184\232\151\143"),
    fontName = ed.fontBold,
    fontSize = 18,
    startColor = ed.toccc3(16439295),
    endColor = ed.toccc3(13565948),
    strokeColor = ed.toccc3(13847445),
    strokeSize = 1.5
  })
  ed.UITool.replaceUINew(self.ui, "prismatic_color_label", prismaticLab.node)
  self:refreshLabel()
  self:refreshSummonTips()
  local shop_label = ed.ui.gradientLabel.create({
    text = T("\229\142\187\229\133\145\230\141\162"),
    fontName = ed.fontBold,
    fontSize = 23,
    startColor = ed.toccc3(16514989),
    endColor = ed.toccc3(16777203),
    strokeColor = ed.toccc3(12403197),
    strokeSize = 1
  })
  ed.UITool.replaceUINew(self.ui, "label_shop_pos", shop_label.node)
  
  local function getFashionName(fashionId)
    local fashionName = ed.lookupDataTable("Fashion", "Name", fashionId)
    local heroID = ed.lookupDataTable("Fashion", "Hero ID", fashionId)
    local heroName = ed.lookupDataTable("Unit", "Display Name", heroID)
    return T("%s\194\183%s", heroName, fashionName)
  end
  
  local fashionId = ed.getDataTable("equip")[self.mainSKinId]["Fashion ID"]
  local name = getFashionName(fashionId)
  local legendNameLab = ed.createLabelTTF(name, 21, ed.fontBold)
  ed.setLabelColor(legendNameLab, ed.toccc3(16776423))
  ed.setLabelStroke(legendNameLab, ed.toccc3(12667859), 1)
  legendNameLab:setPositionX(math.max(220, 125 + legendNameLab:getContentSize().width * 0.5))
  legendNameLab:setPositionY(110)
  self.ui.legend_card_bg:addChild(legendNameLab)
  fashionId = ed.getDataTable("equip")[self.mainSKinId2]["Fashion ID"]
  name = getFashionName(fashionId)
  local prismaticNameLab = ed.ui.gradientLabel.create({
    text = name,
    fontName = ed.fontBold,
    fontSize = 18,
    startColor = ed.toccc3(16439295),
    endColor = ed.toccc3(13565948),
    strokeColor = ed.toccc3(13847445),
    strokeSize = 1.5
  })
  prismaticNameLab.node:setPositionX(math.max(150, 66 + prismaticNameLab.node:getContentSize().width * 0.5))
  prismaticNameLab.node:setPositionY(50)
  self.ui.prismatic_card_bg:addChild(prismaticNameLab.node)
  local name_bg_res = ed.getFashionFrameRes(fashionId, "fashionNameBg")
  ed.setTexture(self.ui.fashion_name_bg, name_bg_res)
  local qualityLabel = ed.createFashionFrameName(ed.lookupDataTable("Fashion", "Quality", fashionId))(ed.createSpriteTools({
    res = ed.getFashionFrameRes(fashionId, "qualityBg"),
    pos = ccp(22, 22),
    parent = self.ui.fashion_name_bg
  }), ccp(28, 26), 18)
  qualityLabel:limitWidthByScale(45)
  local name = ed.lookupDataTable("Fashion", "Name", fashionId)
  local label = ed.createFashionFrameName(ed.lookupDataTable("Fashion", "Quality", fashionId))(self.ui.fashion_name_bg, ccp(23, 68), 19)
  ed.setLabelDimensions(label, CCSizeMake(22, 150))
  label:setString(name)
end

function timeCorridorScene:registerEvents()
  ed.UITool.registerBtn(self, "btn_back", function()
    ed.playEffect(ed.sound.common.back)
    if self.mask then
      self.mask:removeFromParentAndCleanup(true)
      self.mask = nil
    end
    ed.timeCorridorMgr:closeWin()
    ed.popScene()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_reward_open", function()
    self:refreshDraglistPos()
    self.ui.btn_reward_open:setVisible(false)
    self.ui.layer_reward:setVisible(true)
    self.ui.reward_list:setVisible(true)
    self.ui.red_tag:setVisible(false)
    self:foldRewardPanel(false, function()
      self.taskDraglist:setTouchEnabled(true)
    end)
  end)
  ed.UITool.registerBtn(self, "btn_reward_close", function()
    self.taskDraglist:setTouchEnabled(false)
    self:foldRewardPanel(true, function()
      self.ui.btn_reward_open:setVisible(true)
      self.ui.layer_reward:setVisible(false)
      self.ui.reward_list:setVisible(false)
      self.ui.red_tag:setVisible(ed.timeCorridorMgr:hasRewards())
    end)
  end, {priority = -301})
  ed.UITool.registerBtn(self, "btn_reward_close2", function()
    self.taskDraglist:setTouchEnabled(false)
    self:foldRewardPanel(true, function()
      self.ui.btn_reward_open:setVisible(true)
      self.ui.layer_reward:setVisible(false)
      self.ui.reward_list:setVisible(false)
      self.ui.red_tag:setVisible(ed.timeCorridorMgr:hasRewards())
    end)
  end)
  ed.UITool.registerBtn(self, "btn_record", function()
    ed.ui.timeCorridorRecordWin.create()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_reward_pool", function()
    ed.ui.timeCorridorPoolWin.create()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_shop", function()
    local shopScene = ed.ui.timeCorridorShopScene.create()
    ed.pushScene(shopScene)
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_one", function()
    self:doSummon()(1)
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_ten", function()
    self:doSummon()(10)
  end, {pressScale = 0.9})
  self:listenEvent("refreshTimeCorridorMainScene", function()
    self:refreshUI()
  end)
  self:listenEvent("TimeCorridorSummonReply", function(info)
    local maxQuality = 1
    self.summonInfo = info
    for i, v in pairs(info.rewards) do
      local quality = ed.readequip.value(v._id, "Quality")
      maxQuality = math.max(maxQuality, quality)
    end
    local summonColorName = {
      "blue",
      "blue",
      "blue",
      "purple",
      "purple",
      "orange",
      "red",
      "pink",
      "color"
    }
    self.touchMask:setTouchEnabled(true)
    self.mask:setColor(ccc3(63, 63, 101))
    self.mask:runAction(CCSequence:create(ccArrayMake(CCFadeIn:create(0.3), CCCallFunc:create(function()
      local summonAnim = ed.createFcaActor("eff_UI_skin_OpenCard", 1.6)
      summonAnim:setAction("Start_" .. summonColorName[maxQuality])
      summonAnim:setLoop(false)
      summonAnim:setScale(self.mainFcaScale)
      self.mainLayer:addChild(summonAnim)
      summonAnim:setPosition(self.fcaPos)
      self:addFcaOnce(summonAnim)
      self.summonAnim = summonAnim
      self.isPlaying = true
      ed.playEffect(ed.sound.deo.time_corridor_summon)
    end), CCDelayTime:create(0.1), CCFadeOut:create(0.2), CCDelayTime:create(1.2), CCCallFunc:create(function()
      self.ui.btn_skip:setVisible(true)
    end), CCDelayTime:create(1.3), CCCallFunc:create(function()
      self.mask:setColor(ccc3(255, 255, 255))
    end), CCFadeIn:create(0.3), CCCallFunc:create(function()
      self.summonInfo = nil
      self.ui.btn_skip:setVisible(false)
      self:removeFca(self.summonAnim)
      self.summonAnim:removeFromParentAndCleanup(true)
      self.summonAnim = nil
      self.isPlaying = nil
      self.touchMask:setTouchEnabled(false)
      local window = ed.ui.timeCorridorRewardCardWin.create({
        rewards = info.rewards,
        smashMap = info.smashMap,
        summonAction = self:doSummon()
      })
      window:popWindow()
    end), CCFadeTo:create(0.3, 0))))
    self:refreshUI()
    ed.activityHints.network:activityPull(ed.timeCorridorMgr.activityId)
  end)
  self:listenEvent("scope_activity_reply", function(msg)
    if msg._pull then
      self:handleTaskProgressUpdate(msg._pull)
    elseif msg._task_submit then
      self:handleTaskSubmitUpdate(msg._task_submit)
    end
  end)
  self:listenEvent("timeCorridorActivityClose", function()
    if self.mask then
      self.mask:removeFromParentAndCleanup(true)
      self.mask = nil
    end
    ed.timeCorridorMgr.isOpen = false
    ed.timeCorridorMgr:closeWin()
    ed.showToast(T("\230\180\187\229\138\168\229\183\178\229\133\179\233\151\173"))
    FireEvent("RefreshRightTopButtons")
    ed.popScene()
  end)
  self:registerOnEnterHandler("onEnter", function()
    if not self.GoBackScene then
      self.GoBackScene = true
      return
    end
    self:refreshScene()
  end)
  self:refreshLastTimeStr()
  self:listenTimer(Timer:Always(0.3), function()
    self:refreshLastTimeStr()
  end)
end

function timeCorridorScene:refreshLastTimeStr()
  local leftTime = self.endTime - ed.getServerTime()
  if leftTime <= 0 then
    FireEvent("timeCorridorActivityClose")
    return
  end
  leftTime = math.max(0, leftTime)
  self.ui.left_time_label:setString(T("\229\137\169\228\189\153%s", ed.time2dhmsV2(leftTime)))
end

function timeCorridorScene:handleTaskProgressUpdate(msg)
  local info = ed.copyProto(msg)
  for ind, act_list in pairs(info) do
    for i, act in pairs(act_list) do
      if act._id == ed.timeCorridorMgr.activityId then
        ed.timeCorridorMgr:refreshActivityProgress(act)
        self:refreshDraglist()
        return
      end
    end
  end
end

function timeCorridorScene:handleTaskSubmitUpdate(msg)
  if msg._act_id == ed.timeCorridorMgr.activityId then
    ed.timeCorridorMgr:refreshActivityProgress(msg)
    ed.player:addRewards(msg._rewards)
    ed.UITool.showRewardsFromServer(msg._rewards)
    self:refreshScene()
  end
end

function timeCorridorScene:refreshScene()
  self:refreshDraglist()
  self:refreshUI()
end

function timeCorridorScene:doSummon()
  return function(times)
    local passAmount = ed.player:getEquipAmount(ed.timeCorridorMgr.summonPassId)
    local needPassAmount = ed.timeCorridorMgr:calcSummonCost(times)
    if passAmount < needPassAmount then
      ed.showToast(T("%s\228\184\141\232\182\179", ed.lookupDataTable("equip", "Name", ed.timeCorridorMgr.summonPassId)))
      return false
    end
    local type = 1
    if 2 < times then
      type = 2
    elseif ed.timeCorridorMgr.freeSummonTimes > 0 then
      type = 0
    end
    ed.timeCorridorNet:sendSummon(type)
    return true
  end
end

function timeCorridorScene:clickSkipHandler()
  local function handler(event, x, y)
    if event == "began" then
      if ed.containsPoint(self.ui.btn_skip, x, y) and self.ui.btn_skip:isVisible() then
        self.touchSkip = true
        
        return true
      end
    elseif event == "ended" and self.touchSkip then
      if ed.containsPoint(self.ui.btn_skip, x, y) and self.ui.btn_skip:isVisible() then
        self:doSkip()
      end
      self.touchSkip = nil
      return true
    end
    return true
  end
  
  return handler
end

function timeCorridorScene:doSkip()
  if self.summonInfo then
    ed.stopAllEffects()
    local info = self.summonInfo
    local newFashion = {}
    for i, v in ipairs(info.rewards) do
      local rewardId = v._id
      local isFashion = ed.isElementInTable(ed.readequip.value(rewardId, "Consume Type"), {"\231\154\174\232\130\164"})
      if isFashion and not info.smashMap[i] then
        table.insert(newFashion, ed.copyProto(v))
      end
    end
    self.mask:stopAllActions()
    self.mask:setColor(ccc3(255, 255, 255))
    self.mask:runAction(CCSequence:create(ccArrayMake(CCFadeTo:create(0.3, 255), CCCallFunc:create(function()
      self.touchMask:setTouchEnabled(false)
      if self.isPlaying then
        self:removeFca(self.summonAnim)
        self.summonAnim:removeFromParentAndCleanup(true)
        self.summonAnim = nil
        self.isPlaying = nil
      end
      if 0 < #newFashion then
        ed.ui.timeCorridorRewardCardWin.create({
          rewards = info.rewards,
          smashMap = info.smashMap,
          summonAction = self:doSummon(),
          newFashion = newFashion
        }):popWindow()
      else
        ed.ui.timeCorridorRewardsWin.create({
          rewards = info.rewards,
          smashMap = info.smashMap,
          summonAction = self:doSummon()
        })
      end
    end), CCFadeTo:create(0.2, 0))))
    self.ui.btn_skip:setVisible(false)
  end
end

function timeCorridorScene:initCard()
  self:createCard(self.mainSKinId, 1, {
    container = self.ui.legend_card_pos,
    centerAnchor = ccp(0.5, 0.6),
    sprScale = 1.4
  })
  self:createCard(self.mainSKinId2, 2, {
    container = self.ui.prismatic_card_pos,
    centerAnchor = ccp(0.6, 0.6),
    sprScale = 1.4
  })
  if self.rtSpr1 then
    local spr = self.rtSpr1
    ed.UITool.setPositionBy(spr, ccp(0, 10))
    spr:setScaleX(0.98)
    spr:setScaleY(-0.98)
    local oriPosX, oriPosY = self.rtSpr1:getPosition()
    self.rtSpr1:runAction(self:getCardPingPongAction(ccp(oriPosX, oriPosY - 7), ccp(oriPosX, oriPosY + 7), 2))
    local starSpine = ed.createSpine("effect/eff_UI_skin_star/eff_UI_skin_star", 0.49)
    starSpine:setAnimation(0, "Idle", true)
    self.rtSpr1:addChild(starSpine)
    starSpine:setZOrder(4)
    local rtSprSize = self.rtSpr1:getContentSize()
    starSpine:setPosition(ccp(rtSprSize.width * 0.5 + 30, -10))
    local location = spr:getShaderProgram():getUniformLocationForName("angleVec4")
    spr:getShaderProgram():use()
    spr:getShaderProgram():setUniformsForBuiltins()
    spr:getShaderProgram():setUniformLocationWith4f(location, 1, -5, 0, 0)
  end
  if self.rtSpr2 then
    local spr = self.rtSpr2
    spr:setScaleX(0.79)
    spr:setScaleY(-0.79)
    local oriPosX, oriPosY = self.rtSpr2:getPosition()
    local func = CCCallFunc:create(function()
      self.rtSpr2:runAction(self:getCardPingPongAction(ccp(oriPosX, oriPosY - 4), ccp(oriPosX, oriPosY + 4), 2))
    end)
    self.rtSpr2:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.5), func))
    local location = spr:getShaderProgram():getUniformLocationForName("angleVec4")
    spr:getShaderProgram():use()
    spr:getShaderProgram():setUniformsForBuiltins()
    spr:getShaderProgram():setUniformLocationWith4f(location, 4, 4, 0, 0)
  end
end

function timeCorridorScene:createCard(skinId, ind, params)
  local fashionId = ed.getDataTable("equip")[skinId]["Fashion ID"]
  local hid = ed.lookupDataTable("Fashion", "Hero ID", fashionId)
  if not hid or not fashionId then
    return
  end
  ind = ind or 1
  local frameRes = ed.timeCorridorMgr.commonUIPath .. "timecorridor_skin_frame_" .. (ind == 1 and "pink" or "prismatic") .. ".png"
  local card = self:createCardUI(fashionId, frameRes, params.centerAnchor or ccp(0.5, 0.5), params.sprScale or 1)
  local sprite = card.container
  self.ui["oriSprite" .. ind] = sprite
  self.mainLayer:addChild(sprite, 999)
  sprite:setVisible(true)
  sprite:setPosition(ccp(1, 1))
  local rt = CCRenderTexture:create(274, 441, 0, 35056)
  self.ui["oriRt" .. ind] = sprite
  if params.container then
    params.container:addChild(rt)
  else
    self.mainLayer:addChild(rt)
  end
  rt:setVisible(true)
  EDLoadShader("SpitePerspective")
  self:refreshCard(rt, sprite, ind)
  sprite:getScheduler():scheduleScriptFunc(function()
    self:refreshCard(rt, sprite, ind)
  end, 0, false)
end

function timeCorridorScene:refreshCard(rt, sprite, ind)
  rt:beginWithClear(0, 0, 0, 0)
  sprite:setVisible(true)
  sprite:visit()
  rt:endToLua()
  sprite:setVisible(false)
  if not self["rtSpr" .. ind] then
    local rtSpr = rt:getSprite()
    local texture = rt:getSprite():getTexture()
    texture:setAntiAliasTexParameters()
    self["rtSpr" .. ind] = rtSpr
    local scale = 1
    rtSpr:setScaleX(scale)
    rtSpr:setScaleY(-scale)
    ed.useShader(self["rtSpr" .. ind], "SpitePerspective")
    local sprSize = rtSpr:getContentSize()
    local location = rtSpr:getShaderProgram():getUniformLocationForName("sizeAnchorVec4")
    rtSpr:getShaderProgram():use()
    rtSpr:getShaderProgram():setUniformsForBuiltins()
    rtSpr:getShaderProgram():setUniformLocationWith4f(location, sprSize.width, sprSize.height, 0.5, 0.5)
  end
  if ind == 1 then
    self["rtSpr" .. ind] = rt:getSprite()
  end
end

function timeCorridorScene:createCardUI(fashionId, frameRes, centerAnchor, sprScale)
  local ui = {}
  local container = CCSprite:create()
  container:setCascadeOpacityEnabled(true)
  local cardSize = CCSizeMake(272, 439)
  ui.container = container
  ui.frame = ed.createSprite(frameRes)
  ui.frame:setPosition(cardSize.width * 0.5, cardSize.height * 0.5)
  container:addChild(ui.frame, 9)
  ui.frame:setCascadeOpacityEnabled(true)
  local cardres, card, ci, height
  ui.card_fashion = {}
  ui.card_fashion_effect = {}
  ui.card_fashion_plist = {}
  cardres = ed.lookupDataTable("Fashion", "Art Switch", fashionId)
  card, ci = ed.createClippingNode(cardres, ed.timeCorridorMgr.commonUIPath .. "timecorridor_skin_bg.png", nil, CCSizeMake(0, -40))
  card:setPosition(ccp(ui.frame:getPositionX(), ui.frame:getPositionY() - 5))
  height = ci:getContentSize().height
  card:setScale(cardSize.height / height)
  container:addChild(card)
  ui.card_fashion[fashionId] = card
  local fashion_spine_res = ed.lookupDataTable("Fashion", "Art Spine", fashionId)
  local fashion_effect_res = ed.lookupDataTable("Fashion", "Art Fca", fashionId)
  if fashion_spine_res and ed.isSupportSpine() then
    local spine = ed.createSpine("effect/" .. fashion_spine_res .. "/" .. fashion_spine_res, height / 928)
    spine:setAnimation(0, "Idle", true)
    local size = ci:getContentSize()
    spine:setPosition(-size.width * sprScale * centerAnchor.x, -size.height * sprScale * centerAnchor.y)
    spine:setScale(sprScale)
    card:addChild(spine)
    ui.card_fashion_spine = spine
  elseif fashion_effect_res then
    local effect_fca = ed.createFcaActor(fashion_effect_res)
    effect_fca:setLoop(true)
    effect_fca:setAction("Loop")
    effect_fca:setScale(sprScale)
    card:addChild(effect_fca, 5)
    ui.card_fashion_effect[fashionId] = effect_fca
  end
  local fashion_plist_res = ed.lookupDataTable("Fashion", "Plist", fashionId)
  if fashion_plist_res then
    local particle = CCParticleSystemQuad:create("UI/particle/" .. fashion_plist_res)
    card:addChild(particle, 6)
    particle:setScale(sprScale)
    ui.card_fashion_plist[fashionId] = particle
  end
  return ui
end

function timeCorridorScene:getCardPingPongAction(oriPos, dstPos, time)
  local fo = CCEaseSineInOut:create(CCMoveTo:create(time, dstPos))
  local fi = CCEaseSineInOut:create(CCMoveTo:create(time, oriPos))
  return CCRepeatForever:create(CCSequence:createWithTwoActions(fo, fi))
end

function timeCorridorScene:registerBackGroundEvent()
  local indToColor = {
    [1] = "legend_card_pos",
    [2] = "prismatic_card_pos"
  }
  
  local function removeAllCardInfo(ind)
    if self.ui["oriSprite" .. ind] then
      self.ui["oriSprite" .. ind]:removeFromParentAndCleanup(true)
      self.ui["oriSprite" .. ind] = nil
    end
    self.ui[indToColor[ind]]:removeAllChildrenWithCleanup(true)
    if self["oriRt" .. ind] then
      self["oriRt" .. ind]:removeFromParentAndCleanup(true)
    end
    if self["rtSpr" .. ind] then
      self["rtSpr" .. ind] = nil
    end
  end
  
  self:listenEvent("applicationWillEnterForeground", function()
    removeAllCardInfo(1)
    removeAllCardInfo(2)
    self:initCard()
  end)
end

local ruleStr = T("\230\151\182\233\151\180\228\184\142\231\169\186\233\151\180\231\154\132\232\190\185\231\149\140\229\156\168\230\173\164\228\186\164\233\148\153\231\188\160\231\187\149\239\188\140\231\165\158\231\167\152\229\138\155\233\135\143\230\130\132\231\132\182\230\182\140\229\138\168\239\188\140\228\186\186\228\187\172\229\165\189\229\165\135\231\157\128\239\188\140\232\191\189\229\175\187\231\157\128\239\188\140\230\156\137\228\186\186\233\130\130\233\128\133\228\186\134\229\143\164\232\128\129\228\188\160\229\165\135\231\154\132\229\141\142\228\184\189\233\147\160\231\148\178\239\188\140\228\186\166\230\156\137\228\186\186\230\141\149\230\141\137\229\136\176\228\186\134\230\156\170\230\157\165\228\184\150\231\149\140\231\154\132\231\167\145\230\138\128\229\185\187\230\131\179\227\128\130<br/>") .. T("<br/><sprite src=UI/alpha/1080P/common/rivet_big.png><lable color=summonYellow>\230\180\187\229\138\168\232\175\166\230\131\133</lable><br/><br/>") .. T("\239\188\1361\239\188\137\230\180\187\229\138\168\228\184\141\229\174\154\230\151\182\229\188\128\229\144\175\239\188\140\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\17610\231\186\167\229\143\175\229\143\130\228\184\142\227\128\130<br/><br/>") .. T("\239\188\1362\239\188\137\233\152\159\233\149\191\229\143\175<lable color=summonRed>\228\189\191\231\148\168\230\181\129\229\133\137\228\185\139\233\146\165\233\128\154\229\190\128\229\185\179\232\161\140\230\151\182\231\169\186\232\191\189\229\175\187\229\174\157\231\137\169\239\188\140</lable>\229\137\1413\230\172\161\229\141\149\230\172\161\232\191\189\229\175\187\229\133\141\232\180\185\227\128\130<br/><br/>") .. T("\239\188\1363\239\188\137\229\174\157\231\137\169\229\140\133\230\139\172\232\139\177\233\155\132\231\154\174\232\130\164\227\128\129\229\164\180\229\131\143\230\161\134\227\128\129\232\161\168\230\131\133\229\140\133\229\146\140\230\152\159\232\190\137\231\173\137\239\188\140\232\139\165\232\142\183\229\190\151\229\183\178\230\139\165\230\156\137\231\154\132\229\164\150\232\167\130\239\188\140\229\176\134\232\135\170\229\138\168\232\189\172\229\140\150\228\184\186\228\184\128\229\174\154\230\149\176\233\135\143\231\154\132\230\152\159\232\190\137\239\188\140\229\133\183\228\189\147\230\166\130\231\142\135\229\143\138\232\189\172\229\140\150\230\149\176\233\135\143\229\143\175\229\156\168\229\165\150\230\177\160\228\184\173\230\159\165\231\156\139\227\128\130<br/><br/>") .. T("\239\188\1364\239\188\137\231\180\175\232\174\161\232\191\189\229\175\187\232\190\190\229\136\176\228\184\128\229\174\154\230\172\161\230\149\176\229\143\175\232\142\183\229\190\151\233\162\157\229\164\150\229\165\150\229\138\177\227\128\130<br/><br/>") .. T("\239\188\1365\239\188\137<lable color=summonRed>\228\189\191\231\148\168\230\152\159\232\190\137\229\143\175\229\156\168\230\152\159\232\190\137\228\186\164\230\152\147\230\137\128\229\133\145\230\141\162\229\149\134\229\147\129\227\128\130</lable><br/><br/>") .. T("\239\188\1366\239\188\137\228\186\148\230\138\152\229\136\184\231\148\168\228\186\142\228\189\191\232\191\189\229\175\187\231\154\132\228\187\183\230\160\188\229\135\143\229\141\138\239\188\140\232\191\189\229\175\187\230\151\182\229\176\134\232\135\170\229\138\168\228\189\191\231\148\168\230\140\129\230\156\137\231\154\132\228\186\148\230\138\152\229\136\184\227\128\130<br/><br/>") .. T("\239\188\1367\239\188\137\230\180\187\229\138\168\231\187\147\230\157\159\229\144\142\239\188\140\229\137\169\228\189\153\231\154\132\230\152\159\232\190\137\229\146\140\228\186\148\230\138\152\229\136\184\229\176\134\228\188\154\232\191\135\230\156\159\239\188\140\230\181\129\229\133\137\228\185\139\233\146\165\228\184\141\228\188\154\232\191\135\230\156\159\227\128\130<br/><br/>")

function timeCorridorScene:initRulePop()
  ed.UITool.registerBtn(self, "btn_rule", function()
    ed.ui.commonRulePop.create({
      title = T("\232\167\132\229\136\153\232\175\180\230\152\142"),
      txt = ruleStr
    }):popWindow()
  end, {pressScale = 0.95})
end
