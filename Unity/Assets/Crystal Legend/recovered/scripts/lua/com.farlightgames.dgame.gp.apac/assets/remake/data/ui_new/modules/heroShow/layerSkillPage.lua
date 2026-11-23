local layerSkill = {}
ed.ui.heroShowPop.heroMode.layerSkill = layerSkill
local res = ed.heroDetailManager.resConfig
local SKILL_DESC_SELECTED = {
  SIMPLE_DESC = "SIMPLE_DESC",
  DETAIL_DESC = "DETAIL_DESC"
}

function layerSkill.create(popSelf, param)
  local container, ui = ed.editorui(ed.uieditor.herodetailSkill)
  return setmetatable({
    popSelf = popSelf,
    param = param,
    container = container,
    ui = ui
  }, {__index = layerSkill}):init()
end

function layerSkill:init()
  self:adaptUI()
  self:initLabels()
  self.skillIndex = 1
  self.hero = self.param
  self.hid = self.hero._tid
  self.upLevelNum = {
    0,
    0,
    0,
    0
  }
  self.skillEvoTb = ed.getDataTable("SkillEvo")
  self.ui.btn_skillup:setVisible(false)
  self.ui.label_need:setVisible(false)
  self.ui.skill_unlock_condition:setVisible(false)
  self.ui.btn_add_material:setVisible(false)
  self:refresh(self.param)
  local index = 1
  
  local function func(node, click, press, normal)
    self.popSelf:btRegisterButtonClick({
      button = node,
      key = "layerSkillPage_" .. index,
      clickHandler = click,
      force = true,
      pressScale = press or 0.9,
      normalScale = normal or 1
    })
    index = index + 1
  end
  
  func(self.ui.btn_simple, function()
    self:setDescSelect(SKILL_DESC_SELECTED.SIMPLE_DESC)
    self:refreshSkillDesExpand()
  end)
  func(self.ui.btn_detail, function()
    self:setDescSelect(SKILL_DESC_SELECTED.DETAIL_DESC)
    self:refreshSkillDesExpand()
  end)
  func(self.ui.skill1, function()
    self:refreshUI(1)
  end)
  func(self.ui.skill2, function()
    self:refreshUI(2)
  end)
  func(self.ui.skill3, function()
    self:refreshUI(3)
  end)
  func(self.ui.skill4, function()
    self:refreshUI(4)
  end)
  func(self.ui.skill_introduction_arrow, function()
    self:changeSkillDesView()
  end)
  return self
end

function layerSkill:refresh(param)
  self.hero = param
  self.hid = self.hero._tid
  self.attInfo = ed.readhero.getHeroAttByHero(self.hero)
  self:initSkill(self.hero)
  self:refreshUI()
  self:createHeroFca()
  local nb = ed.getCenterPos(self.ui.frame_name_bg)
  local name, w, h = ed.readhero.createHeroNameByInfo({
    name = ed.getDataTable("Unit")[self.hid]["Display Name"],
    rank = self.hero._rank,
    tid = self.hero._tid
  })
  self.ui.hero_name:removeFromParentAndCleanup(true)
  ed.setTexture(self.ui.frame_name_bg, string.format("UI/alpha/1080P/hero/rank/hero_rank_%d.png", self.hero._rank))
  self.ui.hero_name = name
  name:setPosition(ccp(nb.x - w / 2, nb.y))
  self.ui.frame_name_bg:addChild(name)
  self.ui.frame_name_bg:setZOrder(1)
end

function layerSkill:refreshUI(skillIndex)
  if skillIndex and skillIndex == self.skillIndex then
    return
  end
  self.skillIndex = skillIndex or self.skillIndex
  self:refreshSkillUI(self.hero)
  self:refreshSimpleDesc()
  self:refreshDetailDesc()
  self:refreshNameAndLevel()
  self:refreshSkillEvoDesc()
  self:setDescSelect(self.selectDesc or SKILL_DESC_SELECTED.SIMPLE_DESC)
  self:refreshSkillDesExpand()
end

function layerSkill:setDescSelect(type)
  if self.selectDesc and type == self.selectDesc then
    return
  end
  if not tolua.isnull(self.dictBg) then
    self.dictBg:removeAllChildrenWithCleanup(true)
  end
  self.selectDesc = type
  if type == SKILL_DESC_SELECTED.SIMPLE_DESC then
    self.ui.skill_simple_desc:setVisible(true)
    self.ui.skill_detail_desc:setVisible(false)
    self.ui.btn_simple_select:setVisible(true)
    self.ui.btn_simple_normal:setVisible(false)
    self.ui.btn_detail_select:setVisible(false)
    self.ui.btn_detail_normal:setVisible(true)
  else
    self.ui.skill_simple_desc:setVisible(false)
    self.ui.skill_detail_desc:setVisible(true)
    self.ui.btn_simple_select:setVisible(false)
    self.ui.btn_simple_normal:setVisible(true)
    self.ui.btn_detail_select:setVisible(true)
    self.ui.btn_detail_normal:setVisible(false)
  end
end

function layerSkill:refreshSkillUI()
  local function replaceUI(ui, parent, to, from)
    local x, y = ui[to]:getPosition()
    
    ui[to]:setVisible(false)
    from:setPosition(ccp(x, y))
    ui[parent]:addChild(from)
    ui[to] = from
  end
  
  for i = 1, 4 do
    local icon, bg = ed.readhero.createSkillIcon(self.hid, self.skill[i].slot, self.hero)
    icon:setScale(0.9)
    replaceUI(self.ui, "skill" .. i, "icon" .. i, icon)
    local level = self:getSkillLevel(self.hero, self.skill[i].slot)
    if self.hero._rank < self.skill[i].rank then
      self.ui["skill_mask" .. i]:setVisible(true)
      self.ui["bg_skill_rank" .. i]:setVisible(false)
      ed.setLabelColor(self.ui["skill_level" .. i], ed.toccc3(16739436))
      ed.setLabelStroke(self.ui["skill_level" .. i], ed.toccc3(5577228), 1)
      self.ui["skill_level" .. i]:setZOrder(10)
      ed.setString(self.ui["skill_level" .. i], string.format("%s", res.skill_unlock_color_text[self.skill[i].rank]))
      if self.skillIndex == i then
        self.ui["skill_selected" .. i]:setVisible(true)
      else
        self.ui["skill_selected" .. i]:setVisible(false)
      end
    else
      self.ui["skill_mask" .. i]:setVisible(false)
      self.ui["bg_skill_rank" .. i]:setVisible(true)
      ed.setLabelColor(self.ui["skill_level" .. i], ccc3(255, 252, 231))
      ed.setLabelStroke(self.ui["skill_level" .. i], ed.toccc3(3744789), 1)
      self.ui["skill_level" .. i]:setZOrder(1)
      ed.setString(self.ui["skill_level" .. i], ed.formatLevel("lv.") .. level)
      if self.skillIndex == i then
        self.ui["skill_selected" .. i]:setVisible(true)
      else
        self.ui["skill_selected" .. i]:setVisible(false)
      end
    end
    local step = self:getSkillStep(self.skill[i])
    ed.setString(self.ui["skill_rank" .. i], step)
  end
end

function layerSkill:getSkillLevel(hero, slot)
  return hero._skill_levels[slot] + self.upLevelNum[slot]
end

function layerSkill:getSkillStep(skill)
  local skillEvoTb = self.skillEvoTb
  local level = self:getSkillLevel(self.hero, skill.slot)
  local evo = skillEvoTb[skill.groupID] or {}
  local step = 0
  for k, v in pairs(evo) do
    if level >= evo[k]["EvoSkill UnlockLevel"] then
      step = math.max(step, k)
    end
  end
  return step
end

function layerSkill:showDictInfo()
  return function(index, x, y)
    if self.dictBg then
      self.dictBg:removeAllChildrenWithCleanup(true)
    end
    if not index then
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
    bg:setPosition(ccp(x - ed.display.halfFixedWidth - 50, y - height - 10))
    autoText.node:setPosition(ccp(10, height))
    bg:addChild(autoText.node)
    self.dictBg = bg
    self.container:addChild(bg, 999)
    self.popSelf:btRegisterOutClick({
      area = self.dictBg,
      key = "layerSkillPage_dict_out_click",
      clickHandler = function()
        if self.dictBg then
          self.dictBg:removeAllChildrenWithCleanup(true)
        end
        self.popSelf:btRemoveMainTouchHandler({
          key = "layerSkillPage_dict_out_click"
        })
      end,
      force = true,
      priority = 0
    })
  end
end

function layerSkill:refreshSimpleDesc()
  local size = self.ui.skill_simple_desc:getContentSize()
  if self.simple_desc_list then
    self.simple_desc_list:clearList()
  else
    local param = {
      cliprect = CCRectMake(0, 0, size.width, size.height),
      noshade = true,
      container = self.ui.skill_simple_desc,
      priority = -300,
      zorder = 99,
      mcpMode = true
    }
    self.simple_desc_list = ed.draglist.create(param)
  end
  local autoStr = self:getAutoTextDesc(self.hero, self.skillIndex)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = autoStr,
    fontSize = 16,
    maxWidth = size.width - 2,
    strokeColor = ed.toccc3(2693915),
    strokeSize = 2,
    color = ccc3(255, 251, 231),
    priority = -333
  })
  autoText:addRegisterHandler("simple", self:showDictInfo())
  local width, height = autoText:getCurContentSize()
  self.simple_desc_list:addItem(autoText.node)
  autoText.node:setPosition(ccp(0, size.height - 10))
  self.simple_desc_list:initListHeight(height)
  self.defineSimpleHeight = height
  self.simple_desc_autoText = autoText
end

function layerSkill:refreshDetailDesc()
  local size = self.ui.skill_detail_desc:getContentSize()
  if self.detail_desc_list then
    self.detail_desc_list:clearList()
  else
    local param = {
      cliprect = CCRectMake(0, 0, size.width, size.height),
      noshade = true,
      container = self.ui.skill_detail_desc,
      priority = -300,
      zorder = 99,
      mcpMode = true,
      bar = {
        bglen = size.height,
        bgpos = ccp(size.width - 1, size.height / 2),
        barres = "UI/alpha/1080P/skill/new/skill_slide.png",
        bgres = "UI/alpha/1080P/skill/new/skill_slide_bg.png",
        alwaysShow = true
      }
    }
    self.detail_desc_list = ed.draglist.create(param)
  end
  local autoStr = self:getAutoTextDesc(self.hero, self.skillIndex, true)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = autoStr,
    fontSize = 16,
    maxWidth = size.width - 2,
    strokeColor = ed.toccc3(2693915),
    strokeSize = 2,
    color = ccc3(255, 251, 231),
    priority = -333
  })
  autoText:addRegisterHandler("detail", self:showDictInfo())
  local width, height = autoText:getCurContentSize()
  self.detail_desc_list:addItem(autoText.node)
  autoText.node:setPosition(ccp(0, size.height - 10))
  self.detail_desc_list:initListHeight(height)
  self.defineDetaiHeight = height
  self.detail_desc_autoText = autoText
end

function layerSkill:getAutoTextDesc(hero, slot, isFull)
  local skillLevel = self:getSkillLevel(hero, slot)
  local skillGroupTb = ed.getDataTable("SkillGroup")
  local skillTb = ed.getDataTable("Skill")
  local buffTb = ed.getDataTable("Buff")
  local dictTb = ed.getDataTable("Dictionary")
  local skills = ed.getSkillExpBase(self.hid)
  local skill = skillTb[skills[slot]["Skill Group ID"]][0]
  local str = isFull and self.skill[slot].fullDescription or self.skill[slot].description
  local handlerName = isFull and "detail" or "simple"
  local tmpStr = str
  local args = {}
  while true do
    local pos1, pos2 = string.find(tmpStr, "%%Skill&.-%%")
    local pos3, pos4 = string.find(tmpStr, "%%Buff&.-%%")
    local pos1 = pos1 or 9999999
    local pos3 = pos3 or 9999999
    if pos1 == 9999999 and pos3 == 9999999 then
      break
    elseif pos1 < pos3 then
      local paramName = string.sub(tmpStr, pos1 + 7, pos2 - 1)
      local value = skill[paramName] or buffTb[self.skill[slot].buffId][paramName]
      local skillGroupItems = skillGroupTb[self.hid] or {}
      for k, v in pairs(skillGroupItems) do
        if v["Skill Group ID"] == self.skill[slot].groupID then
          for i = 1, 5 do
            if v["Growth " .. i .. " Field"] and v["Growth " .. i .. " Field"] == paramName then
              value = value + v["Growth " .. i .. " Value"] * (skillLevel - 1)
            end
          end
        end
      end
      value = math.abs(value)
      table.insert(args, value)
      tmpStr = string.sub(tmpStr, pos2 + 1)
    else
      local paramName = string.sub(tmpStr, pos3 + 6, pos4 - 1)
      local value = buffTb[self.skill[slot].buffId][paramName]
      local skillGroupItems = skillGroupTb[self.hid] or {}
      for k, v in pairs(skillGroupItems) do
        if v["Skill Group ID"] == self.skill[slot].groupID then
          for i = 1, 5 do
            local growthField = v["Growth " .. i .. " Field"]
            if growthField == paramName then
              value = value + v["Growth " .. i .. " Value"] * (skillLevel - 1)
            end
          end
        end
      end
      value = math.abs(value)
      table.insert(args, value)
      tmpStr = string.sub(tmpStr, pos4 + 1)
    end
  end
  str = string.gsub(str, "%%Skill&.-%%", "%%s")
  str = string.gsub(str, "%%Buff&.-%%", "%%s")
  str = string.gsub(str, "%%%%", "#p#")
  str = string.format(str, unpack(args))
  tmpStr = str
  args = {}
  while true do
    local pos1, pos2 = string.find(tmpStr, "<#%d+#.-#>")
    if not pos1 then
      break
    else
      local paramName = string.sub(tmpStr, pos1, pos2)
      local pos3, pos4 = string.find(paramName, "%d+")
      local paramIndex = tonumber(string.sub(paramName, pos3, pos4))
      local paramValue = string.sub(paramName, pos4 + 2, -3)
      local value = string.format("<lable color=ccc3(255,251,231) clickhandler=%s data=%d>%s</lable>", handlerName, paramIndex, paramValue)
      table.insert(args, value)
      tmpStr = string.sub(tmpStr, pos2 + 1)
    end
  end
  str = string.gsub(str, "<#%d+#.-#>", "%%s")
  str = string.format(str, unpack(args))
  str = string.gsub(str, "#p#", "%%")
  return str
end

function layerSkill:refreshNameAndLevel()
  local skillLevel = self:getSkillLevel(self.hero, self.skill[self.skillIndex].slot)
  ed.setString(self.ui.skill_info_name, self.skill[self.skillIndex].name)
  self.ui.skill_info_name:limitWidthByScale(140)
  if self.hero._rank < self.skill[self.skillIndex].rank then
    ed.setString(self.ui.skill_info_level, T("\230\156\170\232\167\163\233\148\129"))
    ed.setLabelColor(self.ui.skill_info_level, ccc3(255, 252, 231))
    ed.setLabelStroke(self.ui.skill_info_level, ed.toccc3(5577228), 1)
    self.ui.skill_info_level:setScale(0.7142857142857143)
  else
    ed.setString(self.ui.skill_info_level, ed.formatLevel("lv.") .. skillLevel)
    ed.setLabelColor(self.ui.skill_info_level, ccc3(255, 252, 231))
    ed.setLabelStroke(self.ui.skill_info_level, ed.toccc3(3744789), 1)
    self.ui.skill_info_level:setScale(1)
  end
  self.ui.max_banner:setVisible(skillLevel >= ed.parameter.team_level_max)
  local bgSize = self.ui.bg_title_skill:getContentSize()
  ed.layout.horizontalSortNode({
    self.ui.skill_info_name,
    self.ui.skill_info_level
  }, {10, 0}, bgSize.width * 0.5)
end

function layerSkill:refreshSkillEvoDesc()
  local skill = self.skill[self.skillIndex]
  local evo = self.skillEvoTb[skill.groupID] or {}
  local skillTb = ed.getDataTable("Skill")
  local skillTbInfo = skillTb[skill.groupID][0]
  self.ui.is_passive_skill:setVisible(skillTbInfo["Active Type"] == "passive")
  self.ui.is_aura_skill:setVisible(skillTbInfo["Active Type"] == "aura" or skillTbInfo["Active Type"] == "negative_aura")
  if self.skillEvoDesclist then
    self.skillEvoDesclist:clearList()
  else
    self.skillEvoDesclist = ed.UITool.createDraglist(self.ui.bg_skill_ranks, {priority = -333})
  end
  local size = self.ui.bg_skill_ranks:getContentSize()
  local posY = 0
  for i = 1, 3 do
    if evo[i] and evo[i].Description then
      local itemContainer, itemUI = ed.editorui(ed.uieditor.skillEvoDescItem)
      local str, suffix = self:getStepRichTextDesc(self.hero, self.skillIndex, i)
      local autoText = ed.ui.autoText.new()
      if suffix then
        autoText:initParam({
          context = str,
          fontSize = 16,
          maxWidth = self.ui.bg_skill_info:getContentSize().width - 90,
          color = ccc3(143, 143, 143),
          strokeColor = ed.toccc3(986381),
          strokeSize = 1,
          priority = -333
        })
      else
        autoText:initParam({
          context = str,
          fontSize = 16,
          maxWidth = self.ui.bg_skill_info:getContentSize().width - 90,
          color = ccc3(255, 251, 231),
          strokeColor = ed.toccc3(3744789),
          strokeSize = 1,
          priority = -333
        })
      end
      autoText:addRegisterHandler("dictHandler" .. i, self:showDictInfo())
      local textWidth, textHeight = autoText:getContentSize()
      local itemSize = CCSizeMake(size.width, math.max(textHeight, 45))
      itemUI.bg1:setVisible(i % 2 ~= 0)
      itemUI.bg2:setVisible(i % 2 == 0)
      itemUI.bg1:setContentSize(itemSize)
      itemUI.bg2:setContentSize(itemSize)
      itemContainer:setContentSize(itemSize)
      itemUI.desc_skill:addChild(autoText.node)
      itemUI.desc_skill:setPositionX(-itemSize.width / 2 + 40)
      itemUI.desc_skill:setPositionY(0)
      itemUI.desc_skill_rank:setString(i)
      autoText.node:setPosition(ccp(45, textHeight / 2))
      self.skillEvoDesclist:addItem(itemContainer)
      itemContainer:setPosition(ccp(itemSize.width / 2, size.height - (posY + itemSize.height / 2)))
      posY = posY + itemSize.height + 1
    end
  end
  self.skillEvoDesclist:initListHeight(posY)
end

function layerSkill:getStepRichTextDesc(hero, skillIndex, step)
  local dictTb = ed.getDataTable("Dictionary")
  local skillLevel = self:getSkillLevel(hero, skillIndex)
  local skillEvoTb = self.skillEvoTb
  local Evo = skillEvoTb[self.skill[skillIndex].groupID] or {}
  local handlerName = "dictHandler" .. step
  if Evo[step] and Evo[step].Description then
    local suffix
    if skillLevel < Evo[step]["EvoSkill UnlockLevel"] then
      suffix = string.format(T("<lable color=ccc3(255,108,108) strokeSize=1 strokeColor=ccc3(85,26,12)>(\230\138\128\232\131\189\232\190\190\229\136\176%d\231\186\167\232\167\163\233\148\129)</lable>"), Evo[step]["EvoSkill UnlockLevel"])
    end
    local str = Evo[step].Description
    local tmpstr = str
    str = string.gsub(tmpstr, "%%(.-)%%", function(content)
      local splitPos = string.find(content, "&")
      if nil == splitPos then
        return "unknown"
      else
        return Evo[step][string.gsub(content, "&", "")]
      end
    end)
    tmpstr = str
    local args = {}
    while true do
      local pos1, pos2 = string.find(str, "<#%d+#.-#>")
      if not pos1 then
        break
      else
        local tmpStr = string.sub(str, pos1, pos2)
        local pos3, pos4 = string.find(tmpStr, "%d+")
        local paramIndex = tonumber(string.sub(tmpStr, pos3, pos4))
        local paramValue = string.sub(tmpStr, pos4 + 2, -3)
        local value = string.format("<lable color=ccc3(255,251,231) clickhandler=%s data=%d>%s</lable>", handlerName, paramIndex, paramValue)
        str = string.sub(str, pos2 + 1)
        table.insert(args, value)
      end
    end
    str = string.gsub(tmpstr, "<#%d+#.-#>", "%%s")
    str = string.format(str, unpack(args))
    str = string.gsub(str, "#p#", "%%")
    if suffix then
      str = string.gsub(str, "<.->", "")
      str = string.format("<lable color=ccc3(143,143,143) strokeColor=ccc3(15,13,13) strokeSize=1>%s</lable>", str)
      str = str .. suffix
    else
      tmpstr = ""
      local args = {}
      while true do
        local pos1, pos2 = string.find(str, "<lable .->.-</lable>")
        if not pos1 then
          tmpstr = tmpstr .. string.format("<lable color=ccc3(255,234,197) strokeColor=ccc3(15,13,13) strokeSize=1>%s</lable>", str)
          break
        else
          tmpstr = tmpstr .. string.format("<lable color=ccc3(255,234,197) strokeColor=ccc3(15,13,13) strokeSize=1>%s</lable>", string.sub(str, 1, pos1 - 1))
          tmpstr = tmpstr .. string.sub(str, pos1, pos2)
          str = string.sub(str, pos2 + 1)
        end
      end
      str = tmpstr
      str = string.gsub(str, "#br#", "<br/>")
    end
    return str, true
  else
    return ""
  end
end

function layerSkill:refreshSkillDesExpand()
  if self.SkillDependState then
    self:changeAutoSkillDes(self.selectDesc == SKILL_DESC_SELECTED.SIMPLE_DESC)
  else
    self:resetAutoSkillDes(self.selectDesc == SKILL_DESC_SELECTED.SIMPLE_DESC)
  end
end

function layerSkill:changeSkillDesView()
  local currentRotation = self.ui.skill_introduction_arrow:getRotation()
  local targetRotation = currentRotation == 180 and 0 or 180
  self.ui.skill_introduction_arrow:setRotation(targetRotation)
  self:setSkillDepend(currentRotation == 0)
end

function layerSkill:setSkillDepend(state)
  self.SkillDependState = state
  if state then
    self.ui.skill_introduction:setContentSize(CCSizeMake(self.ui.bg_skill_info:getContentSize().width - 2, self.maxContentHeight))
    self:changeAutoSkillDes(self.selectDesc == SKILL_DESC_SELECTED.SIMPLE_DESC)
  else
    self.ui.skill_introduction:setContentSize(CCSizeMake(self.ui.bg_skill_info:getContentSize().width - 2, self.skillInitViewHeight))
    self:resetAutoSkillDes(self.selectDesc == SKILL_DESC_SELECTED.SIMPLE_DESC)
  end
end

function layerSkill:changeAutoSkillDes(isSimple)
  if isSimple then
    local size = self.ui.skill_simple_desc:getContentSize()
    self.simple_desc_list:initClipRect(CCRectMake(0, 0, size.width, self.maxContentHeight - 20))
    self.simple_desc_autoText.node:setPosition(ccp(0, self.maxContentHeight - 35))
    local width, height = self.detail_desc_autoText:getCurContentSize()
    self.simple_desc_list:initListHeight(height, true)
  else
    local size = self.ui.skill_detail_desc:getContentSize()
    self.detail_desc_list:initClipRect(CCRectMake(0, 0, size.width, self.maxContentHeight - 20))
    self.detail_desc_autoText.node:setPosition(ccp(0, self.maxContentHeight - 35))
    self.detail_desc_list:hideScrollbar()
    local width, height = self.detail_desc_autoText:getCurContentSize()
    self.detail_desc_list:initListHeight(height + 10, true)
  end
end

function layerSkill:resetAutoSkillDes(isSimple)
  if isSimple then
    local size = self.ui.skill_detail_desc:getContentSize()
    self.simple_desc_list:initClipRect(CCRectMake(0, 0, size.width, self.skillRectViewHeight))
    self.simple_desc_list:initListHeight(self.defineSimpleHeight)
    self.simple_desc_autoText.node:setPosition(ccp(0, self.skillRectViewHeight - 10))
  else
    local size = self.ui.skill_detail_desc:getContentSize()
    self.detail_desc_list:initClipRect(CCRectMake(0, 0, size.width, self.skillRectViewHeight))
    self.detail_desc_list:showScrollbar()
    self.detail_desc_list:initListHeight(self.defineDetaiHeight)
    self.detail_desc_autoText.node:setPosition(ccp(0, self.skillRectViewHeight - 10))
  end
end

function layerSkill:initSkill(hero)
  self.hero = hero
  self.hid = hero._tid
  self.pregs = hero._gs
  local hid = self.hid
  local skill = {}
  local allSkillInfo = ed.getDataTable("Skill")
  local skills = ed.getSkillExpBase(hid)
  for i = 1, #skills do
    local skinf = allSkillInfo[skills[i]["Skill Group ID"]][0]
    skill[i] = {
      name = ed.heroToSkill(skills[i]["Display Name"]),
      skillName = skills[i]["Skill Name"],
      buffId = skinf["Buff ID"],
      res = skills[i].Icon,
      rank = skills[i].Unlock,
      groupID = skills[i]["Skill Group ID"],
      group = skills[i],
      slot = skills[i].Slot,
      olderSlot = skills[i].Slot,
      giftSkill = 0 < #skills[i]["School SkillGroup KN"] and true or false,
      description = skinf.Description or "",
      fullDescription = skinf["Full Description"],
      richTextDes = skinf["Richtext Description"],
      awakeRichTextDes = skinf["Awake Richtext Description"],
      awakeSkillGroupId = skinf["Awake Richtext Skill Group ID"],
      skillTags = skills[i]["Skill Tags"],
      isUnlock = skills[i].Unlock <= hero._rank
    }
  end
  table.sort(skill, function(a, b)
    return a.olderSlot < b.olderSlot
  end)
  self.skill = skill
end

function layerSkill:createHeroFca()
  if self.panelHeroFca then
    self.panelHeroFca:removeAllChildrenWithCleanup(true)
  else
    local panel = CCLayer:create()
    panel:setPosition(50, 145)
    panel:setContentSize(CCSizeMake(160, 200))
    self.ui.hero_pos:addChild(panel)
    self.panelHeroFca = panel
  end
  ed.asyncload.unregistLoadingListener()
  ed.asyncload.preloadFcaByUnitID(self.hid)
  ed.asyncload.registLoadingListener(function()
    local puppet, puppet_id, cha = ed.readhero.getActor(self.hid, "Idle", true, false, nil, false)
    local row = ed.getDataTable("Puppet")[puppet_id]
    local scale = row.Scale
    local wscale = row["Window Scale"]
    if wscale ~= 0 then
      scale = scale * wscale
    end
    puppet:setScale(scale)
    puppet:setPosition(0, -100)
    self.panelHeroFca:addChild(puppet, 10)
    self.popSelf:addFca(puppet)
    ed.asyncload.unregistLoadingListener()
    self.puppet = puppet
    self.cha = cha
    local actions = {}
    local row = ed.getDataTable("AnimDuration")[self.cha]
    local can_show_action_tbl = {"Move"}
    local skill_items = ed.getDataTable("SkillGroup")[self.hid]
    for idx, skill_item in pairs(skill_items or {}) do
      for jdx, action in pairs(ed.getDataTable("Skill")[skill_item["Skill Group ID"]][0]["Action(s)"]) do
        if string.find(action, "special") == nil then
          can_show_action_tbl[#can_show_action_tbl + 1] = action
        end
      end
    end
    for k, v in pairs(row or {}) do
      if ed.isElementInTable(k, can_show_action_tbl) then
        table.insert(actions, {
          act = k,
          time = v.Duration
        })
      end
    end
    self.actions = actions
    self.popSelf:btRegisterButtonClick({
      button = self.panelHeroFca,
      key = "Panel_skill",
      force = true,
      mcpMode = true,
      clickHandler = function()
        if self.timeTig then
          return
        end
        local actions = ed.copyProto(self.actions)
        if self.oldIdx then
          table.remove(actions, self.oldIdx)
        end
        self.oldIdx = math.random(1, #actions)
        local action = actions[self.oldIdx].act
        self.puppet:setAction(action)
        self.puppet:setLoop(action == "Move")
        self.timeTig = true
        self.popSelf:listenTimer(Timer:Once(actions[self.oldIdx].time), function()
          self.puppet:setAction("Idle")
          self.puppet:setLoop(true)
          self.timeTig = false
        end)
      end
    })
  end)
end

function layerSkill:show(vis, param)
  self.container:setVisible(vis)
  if vis then
    self:refresh(param)
  end
end

function layerSkill:initLabels()
  ed.setLabelStroke(self.ui.label_need, ed.toccc3(2693915), 1)
  ed.setLabelStroke(self.ui.skill_info_name, ed.toccc3(2565412), 1)
  ed.setLabelColor(self.ui.skill_info_name, ed.toccc3(16700269))
  self.ui.skill_info_name:setAnchorPoint(ccp(0.5, 0.5))
  self.ui.skill_info_name:setPositionX(self.ui.skill_info_name:getPositionX() - 30)
  ed.setLabelStroke(self.ui.label_is_passive_skill, ed.toccc3(4859271), 1)
  ed.setLabelStroke(self.ui.label_is_aura_skill, ed.toccc3(7290909), 1)
  ed.setLabelStroke(self.ui.label_unique_skill, ed.toccc3(4336670), 1)
  self.ui.label_unique_skill:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_simple_normal, ed.toccc3(986381), 1)
  ed.setLabelStroke(self.ui.label_detail_normal, ed.toccc3(986381), 1)
  ed.setLabelStroke(self.ui.label_max_banner, ed.toccc3(7887680), 1.5)
  self.ui.label_max_banner:setFontName(ed.fontBold)
  for i = 1, 3 do
    ed.setLabelStroke(self.ui["skill_rank" .. i], ed.toccc3(2565412), 1)
    ed.setLabelStroke(self.ui["skill_name" .. i], ed.toccc3(2565412), 1)
  end
end

function layerSkill:adaptUI()
  self.ui.layer_skill:setPosition(ccp(433.75, 239.75))
  local fixWidth = (ed.display.winSize.width - 960) * 0.66
  self.fixWidth = fixWidth
  self.ui.bg_skill_info:setContentSize(CCSizeMake(self.ui.bg_skill_info:getContentSize().width + fixWidth, self.ui.bg_skill_info:getContentSize().height))
  self.ui.bg_skill_info:setPositionX(self.ui.bg_skill_info:getPositionX() + fixWidth / 2 - 1)
  self.ui.bg_title_skill:setPositionX(self.ui.bg_skill_info:getContentSize().width / 2)
  self.ui.bg_title_light:setPositionX(self.ui.bg_skill_info:getContentSize().width / 2)
  self.ui.skill_btn_bg:setPositionX(self.ui.bg_skill_info:getContentSize().width / 2)
  self.ui.skill_introduction_arrow:setPositionX(self.ui.bg_skill_info:getContentSize().width / 2)
  self.ui.skill_introduction:setContentSize(CCSizeMake(self.ui.bg_skill_info:getContentSize().width - 2, self.ui.skill_introduction:getContentSize().height))
  self.ui.skill_introduction:setPositionX(self.ui.bg_skill_info:getContentSize().width / 2)
  self.skillInitViewHeight = self.ui.skill_introduction:getContentSize().height
  self.skillInitDesViewHeight = self.ui.skill_detail_desc:getPositionY()
  self.skillRectViewHeight = self.ui.skill_detail_desc:getContentSize().height
  self.maxContentHeight = self.skillRectViewHeight * 3.8
  self.ui.bg_skill_ranks:setContentSize(CCSizeMake(self.ui.bg_skill_info:getContentSize().width, self.ui.bg_skill_ranks:getContentSize().height))
  self.ui.skill_simple_desc:setContentSize(CCSizeMake(self.ui.bg_skill_info:getContentSize().width - 10, self.ui.skill_simple_desc:getContentSize().height))
  self.ui.skill_detail_desc:setContentSize(CCSizeMake(self.ui.bg_skill_info:getContentSize().width - 10, self.ui.skill_detail_desc:getContentSize().height))
  self.ui.layer_skill_bottom:setPositionX(self.ui.bg_skill_info:getContentSize().width / 2)
end
