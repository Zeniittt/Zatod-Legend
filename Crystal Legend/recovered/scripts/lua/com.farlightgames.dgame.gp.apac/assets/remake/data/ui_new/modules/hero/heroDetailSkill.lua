local SkillDetail = newclass("g")
local herodetail = ed.ui.heroDetailScene
local res = ed.heroDetailManager.resConfig
herodetail.newskill = SkillDetail
local acts = require("util.cocos2dx.actions")
local lsr = ed.heroDetailManager.listener.create()
local SKILL_DESC_SELECTED = {
  SIMPLE_DESC = "SIMPLE_DESC",
  DETAIL_DESC = "DETAIL_DESC"
}

function SkillDetail:initSkill(hero)
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

function SkillDetail:refreshData(hero)
  self:doLevelUp()
  self:initSkill(hero)
  self.isSkillBreak = 0
end

function SkillDetail:adaptUI()
  local fixWidth = (ed.display.winSize.width - 960) * 0.66
  self.fixWidth = fixWidth
  self.ui.bg_skill_info:setContentSize(CCSizeMake(self.ui.bg_skill_info:getContentSize().width + fixWidth, self.ui.bg_skill_info:getContentSize().height))
  self.ui.bg_skill_info:setPositionX(self.ui.bg_skill_info:getPositionX() + fixWidth / 2 - 1)
  self.ui.bg_title_skill:setPositionX(self.ui.bg_skill_info:getContentSize().width / 2)
  self.ui.bg_title_light:setPositionX(self.ui.bg_skill_info:getContentSize().width / 2)
  self.ui.skill_btn_bg:setPositionX(self.ui.bg_skill_info:getContentSize().width / 2)
  self.ui.skill_introduction_arrow:setPositionX(self.ui.bg_skill_info:getContentSize().width / 2)
  self.ui.skill_introduction:setContentSize(CCSizeMake(self.ui.bg_skill_info:getContentSize().width - 2, self.ui.skill_introduction:getContentSize().height))
  self.skillInitViewHeight = self.ui.skill_introduction:getContentSize().height
  self.skillInitDesViewHeight = self.ui.skill_detail_desc:getPositionY()
  self.skillRectViewHeight = self.ui.skill_detail_desc:getContentSize().height
  self.maxContentHeight = self.skillRectViewHeight * 3.8
  self.ui.skill_introduction:setPositionX(self.ui.bg_skill_info:getContentSize().width / 2)
  self.ui.bg_skill_ranks:setContentSize(CCSizeMake(self.ui.bg_skill_info:getContentSize().width, self.ui.bg_skill_ranks:getContentSize().height))
  self.ui.skill_simple_desc:setContentSize(CCSizeMake(self.ui.bg_skill_info:getContentSize().width - 10, self.ui.skill_simple_desc:getContentSize().height))
  self.ui.skill_detail_desc:setContentSize(CCSizeMake(self.ui.bg_skill_info:getContentSize().width - 10, self.ui.skill_detail_desc:getContentSize().height))
  self.ui.layer_skill_bottom:setPositionX(self.ui.bg_skill_info:getContentSize().width / 2)
  local skillLineLeftWidth = self.ui.skill_line_left:getContentSize().width
  local skillLineCenterWidth = self.ui.skill_line:getContentSize().width
  local skillLineScaleX = (self.ui.bg_skill_info:getContentSize().width - skillLineCenterWidth) / 2 / skillLineLeftWidth
  self.ui.skill_line_left:setScaleX(skillLineScaleX)
  self.ui.skill_line_right:setScaleX(skillLineScaleX)
  self.ui.desc_unlock_condition_1:limitWidthByScale(230)
end

function SkillDetail:initData(param)
  self.controller = param.controller
  self.pos = param.pos
  self.skillIndex = 1
  self.upLevelNum = {
    0,
    0,
    0,
    0
  }
  self.skillEvoTb = ed.getDataTable("SkillEvo")
  self:initSkill(param.hero)
end

function SkillDetail:getSkillLevel(hero, slot)
  return hero._skill_levels[slot] + self.upLevelNum[slot]
end

local function showDictInfo(index, x, y)
  local win = ed.getCurrentScene().layer_skill
  if not index then
    return
  end
  if not win or not tolua.isnull(win.dictBg) then
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
  win.dictBg = bg
  ed.getCurrentScene():btRegisterOutClick({
    area = bg,
    key = "dict_out_click",
    clickHandler = function()
      if not tolua.isnull(bg) then
        bg:removeFromParentAndCleanup(true)
      end
    end,
    force = true
  })
  ed.getCurrentScene().mainLayer:addChild(bg, 999)
end

function SkillDetail:getAutoTextDesc(hero, slot, isFull)
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
  str = ed.formatFloat(str)
  return str
end

function SkillDetail:getStepRichTextDesc(hero, skillIndex, step)
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

local function replaceUI(ui, parent, to, from)
  local x, y = ui[to]:getPosition()
  ui[to]:setVisible(false)
  from:setPosition(ccp(x, y))
  ui[parent]:addChild(from)
  ui[to] = from
end

function SkillDetail:refreshSkillUI()
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

function SkillDetail:getSkillStep(skill)
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

function SkillDetail:refreshHeroName()
  local nb = ed.getCenterPos(self.ui.frame_name_bg)
  self.ui.hero_name:removeFromParentAndCleanup(true)
  local name, w, h = ed.readhero.createHeroNameByInfo({
    name = ed.getDataTable("Unit")[self.hid]["Display Name"],
    rank = self.hero._rank,
    tid = self.hero._tid
  })
  ed.setTexture(self.ui.frame_name_bg, string.format("UI/alpha/1080P/hero/rank/hero_rank_%d.png", self.hero._rank))
  self.ui.hero_name = name
  local wScale = 1
  if 190 < w then
    wScale = 190 / w
    self.ui.hero_name:setScale(wScale)
  end
  name:setPosition(ccp(nb.x - w * wScale / 2, nb.y))
  self.ui.frame_name_bg:addChild(name)
  self.ui.frame_name_bg:setZOrder(1)
end

function SkillDetail:refreshSimpleDesc()
  local size = self.ui.skill_simple_desc:getContentSize()
  if self.simple_desc_list then
    self.simple_desc_list:clearList()
  else
    local param = {
      cliprect = CCRectMake(0, 0, size.width, size.height),
      noshade = true,
      container = self.ui.skill_simple_desc,
      priority = 300,
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
    maxWidth = size.width - 5,
    strokeColor = ed.toccc3(2693915),
    strokeSize = 1,
    color = ccc3(255, 234, 197)
  })
  autoText:addRegisterHandler("simple", showDictInfo)
  local width, height = autoText:getCurContentSize()
  self.simple_desc_list:addItem(autoText.node)
  autoText.node:setPosition(ccp(0, size.height - 10))
  self.defineSimpleHeight = height
  self.simple_desc_list:initListHeight(height)
  self.simple_desc_autoText = autoText
end

function SkillDetail:refreshDetailDesc()
  local size = self.ui.skill_detail_desc:getContentSize()
  if self.detail_desc_list then
    self.detail_desc_list:clearList()
  else
    local param = {
      cliprect = CCRectMake(0, 0, size.width, size.height),
      noshade = true,
      container = self.ui.skill_detail_desc,
      priority = 300,
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
    maxWidth = size.width - 5,
    strokeColor = ed.toccc3(2693915),
    strokeSize = 1,
    color = ccc3(255, 234, 197)
  })
  autoText:addRegisterHandler("detail", showDictInfo)
  local width, height = autoText:getCurContentSize()
  self.detail_desc_list:addItem(autoText.node)
  autoText.node:setPosition(ccp(0, size.height - 10))
  self.defineDetaiHeight = height
  self.detail_desc_list:initListHeight(height)
  self.detail_desc_autoText = autoText
end

function SkillDetail:initLabels()
  ed.setLabelStroke(self.ui.label_need, ed.toccc3(2693915), 1)
  ed.setLabelStroke(self.ui.skill_info_name, ed.toccc3(2565412), 1)
  ed.setLabelColor(self.ui.skill_info_name, ed.toccc3(16700269))
  for i = 1, 3 do
    ed.setLabelStroke(self.ui["skill_rank" .. i], ed.toccc3(2565412), 1)
    ed.setLabelStroke(self.ui["skill_name" .. i], ed.toccc3(2565412), 1)
  end
  ed.setLabelStroke(self.ui.label_add_material, ed.toccc3(2565412), 2)
  ed.setLabelStroke(self.ui.label_is_passive_skill, ed.toccc3(4859271), 1)
  ed.setLabelStroke(self.ui.label_is_aura_skill, ed.toccc3(7290909), 1)
  ed.setLabelStroke(self.ui.label_unique_skill, ed.toccc3(4336670), 1)
  self.ui.label_unique_skill:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_simple_normal, ed.toccc3(986381), 1)
  ed.setLabelStroke(self.ui.label_detail_normal, ed.toccc3(986381), 1)
  ed.setLabelStroke(self.ui.label_max_banner, ed.toccc3(7887680), 1.5)
  self.ui.label_max_banner:setFontName(ed.fontBold)
end

function SkillDetail:refreshNameAndLevel()
  local skillLevel = self:getSkillLevel(self.hero, self.skill[self.skillIndex].slot)
  ed.setString(self.ui.skill_info_name, self.skill[self.skillIndex].name)
  self.ui.skill_info_name:limitWidthByScale(140)
  local levelScale
  if self.hero._rank < self.skill[self.skillIndex].rank then
    ed.setString(self.ui.skill_info_level, T("\230\156\170\232\167\163\233\148\129"))
    ed.setLabelColor(self.ui.skill_info_level, ccc3(255, 252, 231))
    ed.setLabelStroke(self.ui.skill_info_level, ed.toccc3(5577228), 1)
    levelScale = 0.7142857142857143
    self.ui.skill_info_level:setScale(levelScale)
  else
    ed.setString(self.ui.skill_info_level, ed.formatLevel("lv.") .. skillLevel)
    ed.setLabelColor(self.ui.skill_info_level, ccc3(255, 252, 231))
    ed.setLabelStroke(self.ui.skill_info_level, ed.toccc3(3744789), 1)
    levelScale = 1
    self.ui.skill_info_level:setScale(levelScale)
  end
  local bgSize = self.ui.bg_title_skill:getContentSize()
  ed.layout.horizontalSortNode({
    self.ui.skill_info_name,
    self.ui.skill_info_level
  }, {10, 0}, bgSize.width * 0.5)
end

function SkillDetail:refreshSkillEvoDesc()
  local skill = self.skill[self.skillIndex]
  local evo = self.skillEvoTb[skill.groupID] or {}
  local skillTb = ed.getDataTable("Skill")
  local skillTbInfo = skillTb[skill.groupID][0]
  self.ui.is_passive_skill:setVisible(skillTbInfo["Active Type"] == "passive")
  self.ui.is_aura_skill:setVisible(skillTbInfo["Active Type"] == "aura" or skillTbInfo["Active Type"] == "negative_aura")
  if self.skillEvoDesclist then
    self.skillEvoDesclist:clearList()
  else
    self.skillEvoDesclist = ed.UITool.createDraglist(self.ui.bg_skill_ranks, {priority = -101})
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
          strokeSize = 1
        })
      else
        autoText:initParam({
          context = str,
          fontSize = 16,
          maxWidth = self.ui.bg_skill_info:getContentSize().width - 90,
          color = ccc3(255, 251, 231),
          strokeColor = ed.toccc3(3744789),
          strokeSize = 1
        })
      end
      autoText:addRegisterHandler("dictHandler" .. i, showDictInfo)
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

function SkillDetail:refreshSkillUpMaterials(isSupplyTrigger)
  local skill = self.skill[self.skillIndex]
  local Evo = self.skillEvoTb[skill.groupID] or {}
  local skillLevel = self:getSkillLevel(self.hero, self.skill[self.skillIndex].slot)
  local gold, materials = self:getUpMaterials(skillLevel, Evo)
  local islock = self.hero._rank < self.skill[self.skillIndex].rank
  local isMaxLevel = ed.getHeroMaxLevel() == skillLevel
  self.needItemIds = {}
  self.lackOfItemIds = {}
  if 0 < gold then
    table.insert(materials, {type = "Gold", amount = gold})
  end
  for _, label in ipairs(self.actionLabels or {}) do
    label:stopAllActions()
  end
  self.actionLabels = {}
  if #materials == 0 then
    self.ui.label_need:setVisible(false)
  else
    self.ui.label_need:setVisible(true)
    for i = 1, 7 do
      if materials[i] then
        local needAmount = materials[i].amount
        local ownAmount = materials[i].ownAmount
        local icon = ed.createItemIcon({
          id = materials[i].id,
          type = materials[i].type,
          amount = 0
        })
        local bgsize = icon:getContentSize()
        local amountStr1, amountStr2, amountStr3
        local color = ccc3(255, 251, 231)
        if ownAmount then
          amountStr1 = string.format("%s", ownAmount)
          amountStr3 = string.format("/%s", needAmount)
          if needAmount > ownAmount then
            color = ed.toccc3(15806515)
            table.insert(self.lackOfItemIds, {
              id = materials[i].id,
              type = materials[i].type,
              wantageAmount = needAmount - ownAmount
            })
          end
          table.insert(self.needItemIds, {
            id = materials[i].id,
            type = materials[i].type,
            wantageAmount = needAmount - ownAmount
          })
          if self.materialSupplyWin and self.materialSupplyWin.mainLayer:isVisible() then
            local itemCount = self.materialSupplyWin:getItemAddCountByItemId(materials[i].id)
            if 0 < itemCount then
              amountStr2 = string.format("+%s", itemCount)
              if needAmount <= itemCount + ownAmount then
                color = ccc3(255, 251, 231)
              end
            end
          end
        else
          amountStr3 = needAmount
        end
        local labelWidth = 0
        local labelList = {}
        local amountLabel3 = ed.createttf(amountStr3, 16)
        ed.setLabelColor(amountLabel3, color)
        amountLabel3:setPosition(-labelWidth, 10)
        labelWidth = labelWidth + amountLabel3:getContentSize().width / icon:getScale()
        table.insert(labelList, amountLabel3)
        if amountStr2 then
          local amountLabel2 = ed.createttf(amountStr2, 16)
          ed.setLabelColor(amountLabel2, ed.toccc3(7405396))
          amountLabel2:setPosition(-labelWidth, 10)
          labelWidth = labelWidth + amountLabel2:getContentSize().width / icon:getScale()
          amountLabel2:runAction(CCRepeatForever:create(CCSequence:create(ccArrayMake(unpack({
            CCCallFunc:create(function()
              amountLabel2:runAction(CCFadeTo:create(0.9, 255 - amountLabel2:getOpacity()))
            end),
            CCDelayTime:create(1)
          })))))
          table.insert(self.actionLabels, amountLabel2)
          table.insert(labelList, amountLabel2)
        end
        if amountStr1 then
          local amountLabel1 = ed.createttf(amountStr1, 16)
          ed.setLabelColor(amountLabel1, color)
          amountLabel1:setPosition(-labelWidth, 10)
          labelWidth = labelWidth + amountLabel1:getContentSize().width / icon:getScale()
          table.insert(labelList, amountLabel1)
        end
        for k = 1, #labelList do
          label = labelList[k]
          label:setPositionX(label:getPositionX() + bgsize.width - 10)
          ed.setLabelStroke(label, ccc3(39, 37, 36), 1)
          label:setScale(1 / icon:getScale())
          label:setAnchorPoint(ccp(1, 0))
          icon:addChild(label)
        end
        icon:setScale(0.7)
        replaceUI(self.ui, "label_need", "material" .. i, icon)
        self.controller:btRegisterButtonClick({
          button = icon,
          key = "firstIcon" .. i,
          clickHandler = function()
            ed.ui.packageDetailWin.create({
              id = materials[i].id,
              type = materials[i].type
            }):popWindow()
          end,
          force = true
        })
      else
        self.ui["material" .. i]:setVisible(false)
      end
    end
    local iconSize = self.ui.material1:getContentSize()
    self.ui.label_need:setPositionX(-25 - #materials * iconSize.width * 0.85 / 2)
  end
  if islock or 80 <= skillLevel or 7 > ed.player:getLevel() then
    self.ui.btn_skillup:setVisible(false)
    self.ui.label_need:setVisible(false)
    self.lackOfItemIds = {}
    self.needItemIds = {}
  else
    self.ui.btn_skillup:setVisible(true)
  end
  if 80 <= skillLevel then
    self.ui.max_banner:setVisible(true)
  else
    self.ui.max_banner:setVisible(false)
  end
  if not islock and 7 > ed.player:getLevel() then
    self.ui.skill_upgrade_tips:setVisible(true)
  else
    self.ui.skill_upgrade_tips:setVisible(false)
  end
  if islock then
    self.ui.skill_unlock_condition:setVisible(true)
    self.ui.desc_unlock_condition:setString(T("\232\139\177\233\155\132\232\190\190\229\136\176%s\232\167\163\233\148\129", res.skill_unlock_color_text[skill.rank]))
    self.ui.desc_unlock_condition:limitWidthByScale(140)
  else
    self.ui.skill_unlock_condition:setVisible(false)
  end
  if 0 < self.isSkillBreak then
    self.ui.label_skillup:setString(T("\232\191\155\233\152\182"))
  else
    self.ui.label_skillup:setString(T("\229\141\135\231\186\167"))
  end
  if self.metarialSkill ~= skill then
    self:closeMaterialSupplyWin()
  end
  self.metarialSkill = skill
  if not isSupplyTrigger then
    self:refreshMatertialBtnVisible()
  end
end

function SkillDetail:initUI()
  local container, ui = ed.editorui(ed.uieditor.herodetailSkill, {
    ui = self.controller.ui
  })
  self.mainLayer = container
  self.ui = ui
  self:adaptUI()
  self.ui.layer_skill:setPosition(self.pos)
  self:initLabels()
  self:createHeroFca()
  self:refreshUI(true)
end

function SkillDetail:createHeroFca()
  if self.puppet then
    self.puppet:setVisible(false)
  end
  local puppet, cha = ed.readhero.getActor(self.hid, "Idle", true, false, self.hero._fashion, false)
  local row = ed.getDataTable("Puppet")[cha]
  local scale = row.Scale
  local wscale = row["Window Scale"]
  if wscale ~= 0 then
    scale = scale * wscale
  end
  puppet:setScale(scale)
  self.ui.hero_pos:addChild(puppet, 10)
  puppet:setPositionX(self.ui.hero_pos:getContentSize().width / 2)
  puppet:setPositionY(50)
  self.controller:addFca(puppet)
  self.puppet = puppet
  self.cha = row.Resource
  self.action_pre = "Idle"
  local isSpine = string.match(self.cha, "%.sp$")
  if not isSpine then
    self.cha = self.cha .. ".cha"
  end
end

function SkillDetail:setDetailInfo(isShow)
  if not isShow and not tolua.isnull(self.fullDesText) then
    self.fullDesText:removeFromParentAndCleanup(true)
  end
end

function SkillDetail:getUpMaterials(level, evo)
  local heroType = ed.getDataTable("Unit")[self.hid]["Hero Type"]
  local skilllevelTb = ed.getDataTable("SkillLevels")
  local type
  if heroType == T("\229\138\155\233\135\143") then
    type = "STR"
  elseif heroType == T("\230\153\186\229\138\155") then
    type = "INT"
  else
    type = "AGI"
  end
  local items = {}
  self.isSkillBreak = 0
  for i = 1, 3 do
    if evo[i] and evo[i]["EvoSkill UnlockLevel"] == level + 1 then
      local id = evo[i]["EvoKey Item ID"]
      local item = {
        type = "item",
        id = id,
        amount = evo[i]["EvoKey Item Amount"],
        ownAmount = ed.player.equip_qunty[id] or 0
      }
      table.insert(items, item)
      self.isSkillBreak = i
    end
  end
  local skillLevelData = skilllevelTb[type][level]
  local gold = skillLevelData.Price or 0
  for i = 1, 5 do
    if skillLevelData["Item Amount " .. i] and 0 < skillLevelData["Item ID " .. i] and 0 < skillLevelData["Item Amount " .. i] then
      local id = skillLevelData["Item ID " .. i]
      local item = {
        type = "item",
        id = id,
        amount = skillLevelData["Item Amount " .. i],
        ownAmount = ed.player.equip_qunty[id] or 0
      }
      table.insert(items, item)
    end
  end
  self.gold = gold
  self.materials = items
  return gold, items
end

function SkillDetail:refreshUI(updateHero)
  if updateHero then
    self:refreshHeroName()
    self:createHeroFca()
  end
  self:refreshSkillUI()
  self:refreshSimpleDesc()
  self:refreshDetailDesc()
  self:refreshNameAndLevel()
  self:refreshSkillEvoDesc()
  self:refreshSkillUpMaterials()
  self:setDetailInfo(false)
  self:setDescSelect(self.selectDesc or SKILL_DESC_SELECTED.SIMPLE_DESC)
  self:refreshSkillDesExpand()
  if not tolua.isnull(self.dictBg) then
    self.dictBg:removeAllChildrenWithCleanup(true)
  end
end

function SkillDetail:refreshUIByLevelUp(refreshDesc)
  self:refreshSkillUI()
  if refreshDesc then
    self:refreshSimpleDesc()
    self:refreshDetailDesc()
  end
  self:refreshSkillDesExpand()
  self:refreshNameAndLevel()
  self:refreshSkillEvoDesc()
  self:refreshSkillUpMaterials()
  self:setDetailInfo(false)
  if not tolua.isnull(self.dictBg) then
    self.dictBg:removeAllChildrenWithCleanup(true)
  end
  self.needRefreshSkillDescWhenCancel = true
end

function SkillDetail:playAttAnim(id)
  local slot = self.skill[id].slot
  local att = ed.heroDetailManager:getSkillLvupAtt(self.hid, slot)
  local icon = self.ui["icon" .. id]
  if tolua.isnull(icon) then
    return
  end
  local effect = ed.createFcaNode("eff_UI_skill_level_up")
  effect:setScale(1.3)
  effect:setPosition(self.ui["icon" .. id]:getPosition())
  self.ui["skill" .. id]:addChild(effect, 10)
  self.controller:addFcaOnce(effect, true)
  local dt = 0.2
  for i = 1, #att do
    local label = ed.createNode({
      t = "Label",
      base = {
        text = att[i],
        size = 18
      },
      layout = {
        position = ccpAdd(ccp(self.ui.hero_pos:getPosition()), ccp(50, 100))
      },
      config = {
        color = ed.toccc3(7405396),
        stroke = {
          color = ed.toccc3(1519903),
          size = 2
        },
        visible = false
      }
    }, self.ui.layer_skill)
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
  self.ui["skill_level" .. id]:runAction(action1)
  if self.isSkillBreak and 0 < self.isSkillBreak then
    local step = self:getSkillStep(self.skill[id])
    local param = {
      hero = self.hero,
      skill = self.skill[id],
      skillLevel = self:getSkillLevel(self.hero, slot),
      step = step,
      stepRichText = self:getStepRichTextDesc(self.hero, self.skillIndex, step)
    }
    ed.ui.skillRankUpWin.create(param):popWindow()
    self.isSkillBreak = 0
  end
end

function SkillDetail:getBoxItemsByMetarail(needItemIds, countZeroAmount)
  local chestTable = ed.getDataTable("ChestCombination")
  local chestList = {}
  local enoughLevelUp = true
  for i = 1, #needItemIds do
    local itemInfo = needItemIds[i]
    local totalAmount = 0
    for chestId, chestInfo in pairs(chestTable) do
      local itemSetList = chestInfo["Item Set"]
      local itemSetCountList = chestInfo["Item Set Count"]
      local chestItemId = chestInfo["Item Id"]
      local priority = chestInfo["If Fast Skill Use"] or 0
      if 0 < priority then
        for k = 1, #itemSetList do
          local itemSetId = itemSetList[k]
          if itemSetId == itemInfo.id then
            local amount = ed.player:getEquipAmount(chestItemId) or 0
            totalAmount = totalAmount + amount * itemSetCountList[k]
            if 0 < amount or countZeroAmount then
              local cfg = {
                ui = nil,
                chestInfo = chestInfo,
                useAmountLimit = amount,
                needItemId = itemInfo.id,
                callBack = function()
                  self:refreshSkillUpMaterials(true)
                end,
                priority = priority,
                itemOpenCount = itemSetCountList[k]
              }
              table.insert(chestList, cfg)
            end
            break
          end
        end
      end
    end
    if totalAmount < itemInfo.wantageAmount then
      enoughLevelUp = false
    end
  end
  table.sort(chestList, function(a, b)
    return a.priority > b.priority
  end)
  return chestList, enoughLevelUp
end

function SkillDetail:openMaterialSupplyWin()
  if self.materialSupplyWin then
    self.materialSupplyWin.mainLayer:setVisible(true)
  else
    self.materialSupplyWin = ed.ui.MaterialSupplyWin.create({
      controller = self.controller
    })
    self.controller.mainLayer:addChild(self.materialSupplyWin.mainLayer, 400)
  end
  local chestList = self:getBoxItemsByMetarail(self.lackOfItemIds)
  if 0 < #chestList then
    chestList = self:getBoxItemsByMetarail(self.lackOfItemIds, true)
  end
  self.materialSupplyWin:refreshDragList(chestList, true)
  self:refreshMatertialBtnVisible()
end

function SkillDetail:closeMaterialSupplyWin()
  if self.materialSupplyWin then
    self.materialSupplyWin.mainLayer:setVisible(false)
    self:refreshMatertialBtnVisible()
  end
end

function SkillDetail:refreshMatertialBtnVisible()
  local isVisible = #self.lackOfItemIds > 0
  local isShining = self.materialSupplyWin == nil or not self.materialSupplyWin.mainLayer:isVisible()
  local chestList = {}
  local enoughLevelUp = true
  if #self.lackOfItemIds > 0 or self.bLevelUpUpdate then
    self.bLevelUpUpdate = false
    chestList, enoughLevelUp = self:getBoxItemsByMetarail(self.lackOfItemIds)
    if #chestList <= 0 or not enoughLevelUp then
      isVisible = false
    end
    if self.materialSupplyWin and self.materialSupplyWin.mainLayer:isVisible() then
      if #chestList <= 0 then
        chestList = self:getBoxItemsByMetarail(self.lackOfItemIds, true)
      end
      if #chestList <= 0 then
        chestList = self:getBoxItemsByMetarail(self.needItemIds)
      end
      if #chestList <= 0 then
        chestList = self:getBoxItemsByMetarail(self.needItemIds, true)
      end
      self.materialSupplyWin:refreshDragList(chestList)
      if #chestList <= 0 then
        self.materialSupplyWin.mainLayer:setVisible(false)
      end
    end
  end
  self.ui.btn_add_material:setVisible(isVisible)
  self.ui.btn_add_material:stopAllActions()
  self.ui.icon_add_material:stopAllActions()
  self.ui.label_add_material:stopAllActions()
  self.ui.label_add_material:setOpacity(255)
  self.ui.icon_add_material:setOpacity(255)
  if isVisible and isShining then
    self.ui.btn_add_material:runAction(CCRepeatForever:create(CCSequence:create(ccArrayMake(unpack({
      CCCallFunc:create(function()
        self.ui.icon_add_material:runAction(CCFadeTo:create(0.9, 255 - self.ui.icon_add_material:getOpacity()))
        self.ui.label_add_material:runAction(CCFadeTo:create(0.9, 255 - self.ui.label_add_material:getOpacity()))
      end),
      CCDelayTime:create(1)
    })))))
  end
end

function SkillDetail:hideCallBack()
  self:closeMaterialSupplyWin()
  for _, label in ipairs(self.actionLabels or {}) do
    label:stopAllActions()
  end
  self.ui.btn_add_material:stopAllActions()
  self.ui.icon_add_material:stopAllActions()
  self.ui.label_add_material:stopAllActions()
  self.ui.label_add_material:setOpacity(255)
  self.ui.icon_add_material:setOpacity(255)
  if not tolua.isnull(self.dictBg) then
    self.dictBg:removeAllChildrenWithCleanup(true)
  end
  self:doLevelUp()
end

function SkillDetail:doLevelUp()
  if self.upLevelNum[1] == 0 and self.upLevelNum[2] == 0 and self.upLevelNum[3] == 0 and self.upLevelNum[4] == 0 then
    return
  end
  ed.registerNetReply("skill_level_up", function(result)
    if not result then
      ed.showToast(T("\230\138\128\232\131\189\229\188\186\229\140\150\229\164\177\232\180\165"))
    else
      self.upLevelNum = {
        0,
        0,
        0,
        0
      }
    end
  end, {
    hid = self.hid,
    order = ed.copyTable(self.upLevelNum)
  })
  local ups = {}
  for k, v in pairs(self.upLevelNum) do
    table.insert(ups, {_id = k, _amount = v})
  end
  local msg = ed.upmsg.skill_levelup()
  msg._heroid = self.hid
  msg._ups = ups
  ed.send(msg, "skill_levelup")
  self.upLevelNum = {
    0,
    0,
    0,
    0
  }
end

function SkillDetail:setDescSelect(type)
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

function SkillDetail:keepeatHandler()
  local count = 0
  local delay = 0.8
  local oriSpeed = 10
  local oriAccSpeed = 2
  local accAcc = 2
  local speed = oriSpeed
  local accSpeed = oriAccSpeed
  local times = 0
  local times_dt = 0
  
  local function skillLevelUpHandler(dt)
    count = count + dt
    if count > delay then
      accSpeed = accSpeed + accAcc * dt
      speed = speed + accSpeed * dt
      times = times + speed * dt
      times_dt = times_dt + dt
      while 1 < times do
        if self.isSkillBreak == 0 then
          self:OnClickSkillLevelUp(0.2 <= times_dt)
          if 0.2 <= times_dt then
            times_dt = 0
          end
        end
        times = times - 1
      end
    end
  end
  
  return skillLevelUpHandler
end

function SkillDetail:OnClickSkillLevelUp(refreshDesc)
  if not tolua.isnull(self.fullDesText) then
    self.fullDesText:removeFromParentAndCleanup(true)
  end
  if ed.player:getLevel() < 7 then
    ed.showToast(T("\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\1767\231\186\167\229\144\142\229\188\128\230\148\190\230\138\128\232\131\189\229\141\135\231\186\167"))
    return
  end
  local skillLevel = self:getSkillLevel(self.hero, self.skill[self.skillIndex].slot) or 1
  local skill = self.skill[self.skillIndex]
  local Evo = self.skillEvoTb[skill.groupID] or {}
  local gold, materials = self:getUpMaterials(skillLevel, Evo)
  if gold > ed.player._money then
    ed.showToast(T("\233\135\145\229\184\129\228\184\141\232\182\179"))
    return
  end
  for k, v in ipairs(materials or {}) do
    local num = ed.player.equip_qunty[v.id] or 0
    if num < v.amount then
      ed.showToast(T("\230\157\144\230\150\153\228\184\141\232\182\179"))
      return
    end
  end
  if skillLevel >= self.hero._level then
    ed.showToast(T("\230\138\128\232\131\189\231\173\137\231\186\167\232\190\190\229\136\176\229\189\147\229\137\141\228\184\138\233\153\144\239\188\140\233\156\128\229\133\136\230\143\144\229\141\135\232\139\177\233\155\132\231\173\137\231\186\167"))
    return
  end
  self.upLevelNum[self.skillIndex] = self.upLevelNum[self.skillIndex] + 1
  ed.player:addMoney(-gold)
  for k, v in ipairs(materials or {}) do
    ed.player:consumeEquip(v.id, v.amount)
  end
  self.bLevelUpUpdate = true
  self:playAttAnim(self.skillIndex)
  self:refreshUIByLevelUp(refreshDesc)
end

function SkillDetail:changeFcaAction(name, with_sound)
  if with_sound == nil then
    with_sound = true
  end
  local action, duration = self:changeAction(name)
  if with_sound then
    lsr:report("clickHeroFca", {
      hid = self.hid,
      action = action,
      fashionId = self.hero._fashion
    })
  end
  self.controller:registerUpdateHandler("checkFcaHandler", self:checkFcaHandler(action, duration))
end

function SkillDetail:changeAction(name)
  local row = ed.getDataTable("AnimDuration")[self.cha]
  local actions = {}
  local dur = {}
  local skill_items = ed.getDataTable("SkillGroup")[self.hid]
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

function SkillDetail:checkFcaHandler(action, duration)
  local time = 0
  
  local function handler(dt)
    time = time + dt
    if action ~= "Move" and time > duration then
      self.puppet:setAction("Idle")
      self.puppet:setLoop(true)
      self.controller:removeUpdateHandler("checkFcaHandler")
    end
  end
  
  return handler
end

function SkillDetail:doOutLayerTouch()
  local isPressClose
  
  local function handler(event, x, y)
    local isClickInRange = self.materialSupplyWin and self.materialSupplyWin.mainLayer:isVisible() and not ed.containsPoint(self.materialSupplyWin.ui.bg_detail, x, y)
    isClickInRange = isClickInRange and not ed.containsPoint(self.ui.btn_skillup, x, y)
    local isClickWin = self.materialSupplyWin and self.materialSupplyWin.mainLayer:isVisible() and ed.containsPoint(self.materialSupplyWin.ui.bg_detail, x, y)
    local isClickOutBtn = ed.containsPoint(self.ui.skill1, x, y) or ed.containsPoint(self.ui.skill2, x, y) or ed.containsPoint(self.ui.skill3, x, y) or ed.containsPoint(self.ui.skill4, x, y)
    isClickOutBtn = isClickOutBtn or ed.containsPoint(self.ui.btn_simple, x, y) or ed.containsPoint(self.ui.btn_detail, x, y) or ed.containsPoint(self.controller.ui.btn_back, x, y)
    isClickOutBtn = isClickOutBtn or ed.containsPoint(self.controller.ui.arrow_left, x, y) or ed.containsPoint(self.controller.ui.arrow_right, x, y)
    isClickOutBtn = isClickOutBtn or ed.containsPoint(self.controller.ui.btn1, x, y) or ed.containsPoint(self.controller.ui.btn2, x, y)
    isClickOutBtn = isClickOutBtn or ed.containsPoint(self.controller.ui.btn3, x, y) or ed.containsPoint(self.controller.ui.btn4, x, y)
    if event == "began" then
      if isClickInRange then
        isPressClose = true
        return not isClickOutBtn
      end
    elseif event == "ended" then
      if isPressClose and isClickInRange then
        self:closeMaterialSupplyWin()
        self:refreshSkillUpMaterials()
        isPressClose = nil
        return not isClickOutBtn
      end
      isPressClose = nil
    end
    return isClickWin
  end
  
  return handler
end

function SkillDetail:refreshSkillDesExpand()
  if self.SkillDependState then
    self:changeAutoSkillDes(self.selectDesc == SKILL_DESC_SELECTED.SIMPLE_DESC)
  else
    self:resetAutoSkillDes(self.selectDesc == SKILL_DESC_SELECTED.SIMPLE_DESC)
  end
end

function SkillDetail:changeSkillDesView()
  local currentRotation = self.ui.skill_introduction_arrow:getRotation()
  local targetRotation = currentRotation == 180 and 0 or 180
  self.ui.skill_introduction_arrow:setRotation(targetRotation)
  self:setSkillDepend(currentRotation == 0)
end

function SkillDetail:setSkillDepend(state)
  self.SkillDependState = state
  if state then
    self.ui.skill_introduction:setContentSize(CCSizeMake(self.ui.bg_skill_info:getContentSize().width - 2, self.maxContentHeight))
    self:changeAutoSkillDes(self.selectDesc == SKILL_DESC_SELECTED.SIMPLE_DESC)
  else
    self.ui.skill_introduction:setContentSize(CCSizeMake(self.ui.bg_skill_info:getContentSize().width - 2, self.skillInitViewHeight))
    self:resetAutoSkillDes(self.selectDesc == SKILL_DESC_SELECTED.SIMPLE_DESC)
  end
end

function SkillDetail:changeAutoSkillDes(isSimple)
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

function SkillDetail:resetAutoSkillDes(isSimple)
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

function SkillDetail:doMainLayerTouch()
  local outLayerTouch = self:doOutLayerTouch()
  
  local function handler(event, x, y)
    local isPress
    xpcall(function()
      isPress = outLayerTouch(event, x, y)
    end, EDDebug)
    return isPress
  end
  
  return handler
end

function SkillDetail:registerTouchHandlers(level)
  ed.UITool.registerBtn(self.controller, "skill1", function()
    self:closeMaterialSupplyWin()
    if self.skillIndex == 1 then
      return
    end
    self.skillIndex = 1
    self:refreshUI()
  end, {})
  ed.UITool.registerBtn(self.controller, "skill2", function()
    self:closeMaterialSupplyWin()
    if self.skillIndex == 2 then
      return
    end
    self.skillIndex = 2
    self:refreshUI()
  end, {})
  ed.UITool.registerBtn(self.controller, "skill3", function()
    self:closeMaterialSupplyWin()
    if self.skillIndex == 3 then
      return
    end
    self.skillIndex = 3
    self:refreshUI()
  end, {})
  ed.UITool.registerBtn(self.controller, "skill4", function()
    self:closeMaterialSupplyWin()
    if self.skillIndex == 4 then
      return
    end
    self.skillIndex = 4
    self:refreshUI()
  end, {})
  ed.UITool.registerBtn(self.controller, "btn_simple", function()
    self:setDescSelect(SKILL_DESC_SELECTED.SIMPLE_DESC)
    self:refreshSkillDesExpand()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self.controller, "btn_detail", function()
    self:setDescSelect(SKILL_DESC_SELECTED.DETAIL_DESC)
    self:refreshSkillDesExpand()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self.controller, "btn_skillup", function()
  end, {
    pressScale = 0.95,
    clickInterval = 0.1,
    pressHandler = function()
      self:OnClickSkillLevelUp()
      self.controller:registerUpdateHandler("hero_skill_long_levelup_click_button", self:keepeatHandler())
    end,
    cancelPressHandler = function()
      if self.needRefreshSkillDescWhenCancel then
        self.needRefreshSkillDescWhenCancel = nil
        self:refreshSimpleDesc()
        self:refreshDetailDesc()
        self:refreshSkillDesExpand()
      end
      self.controller:removeUpdateHandler("hero_skill_long_levelup_click_button")
    end
  })
  ed.UITool.registerBtn(self.controller, "skill_introduction_arrow", function()
    self:changeSkillDesView()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self.controller, "hero_pos", function()
    self:changeFcaAction()
  end, {})
  ed.UITool.registerBtn(self.controller, "btn_add_material", function()
    self:openMaterialSupplyWin()
  end, {})
  self.mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, -300, true)
  self.mainLayer:setTouchEnabled(true)
end

function SkillDetail.create(param)
  local self = {}
  setmetatable(self, {__index = SkillDetail})
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  return self
end
