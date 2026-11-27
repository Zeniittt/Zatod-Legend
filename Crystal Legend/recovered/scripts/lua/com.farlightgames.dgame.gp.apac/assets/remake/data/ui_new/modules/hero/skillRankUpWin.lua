local base = ed.ui.popwindow
local skillRankUpWin = newclass(base.mt)
ed.ui.skillRankUpWin = skillRankUpWin

function skillRankUpWin.create(param)
  local self = base.create("skillRankUpWin")
  setmetatable(self, skillRankUpWin.mt)
  param = param or {}
  self:init(param)
  return self
end

function skillRankUpWin:init(param)
  self.param = param
  self.hero = param.hero
  self.skill = param.skill
  self.skillLevel = param.skillLevel
  self.step = param.step
  self.stepRichText = param.stepRichText
  self.maxAttrLength = 0
  self.attrLabelList = {}
  self:show()
  self:initView()
  self:addEventListener()
end

function skillRankUpWin:initView()
  local container, ui = ed.editorui(ed.uieditor.skillRankUpWin)
  self.container:addChild(container)
  self.ui = ui
  local upRankDesc = ed.ui.autoText.new()
  local str = T("<lable color=ccc3(255,234,198) strokeColor=ccc3(41,27,27) strokeSize=1>\230\138\128\232\131\189\232\191\155\233\152\182\239\188\154</lable>") .. self.stepRichText
  local param = {
    context = str,
    fontSize = 16,
    maxWidth = 500,
    isTripLastSpacing = true
  }
  upRankDesc:initParam(param)
  self.ui.skill_uprank_desc_bg:addChild(upRankDesc.node)
  local _, descHeight = upRankDesc:getCurContentSize()
  local marginY = 20
  local descBgSize = self.ui.skill_uprank_desc_bg:getContentSize()
  local detalHeight = math.max(descHeight + marginY * 2, 56.5) - descBgSize.height
  local totalBgSize = self.ui.skill_rankup_bg:getContentSize()
  totalBgSize.height = totalBgSize.height + detalHeight
  self.ui.skill_rankup_bg:setContentSize(totalBgSize)
  self.ui.skill_icon_bg:setPositionY(self.ui.skill_icon_bg:getPositionY() + detalHeight)
  self.ui.skill_attr:setPositionY(self.ui.skill_attr:getPositionY() + detalHeight)
  descBgSize.height = descBgSize.height + detalHeight
  self.ui.skill_uprank_desc_bg:setContentSize(descBgSize)
  self.ui.skill_uprank_desc_bg:setPositionY(self.ui.skill_uprank_desc_bg:getPositionY() + detalHeight * 0.5)
  local posY = (descBgSize.height + descHeight) * 0.5 - upRankDesc:getFirstLineHeight() * 0.5
  upRankDesc.node:setPosition(self.ui.ImageView_22122:getPositionX() + self.ui.ImageView_22122:getContentSize().width * 0.5 + 7, posY)
  self.ui.ImageView_22122:setPositionY(posY)
  self.skillEvoDesclist = ed.UITool.createDraglist(self.ui.skill_attr, {priority = -101})
  local icon, bg = ed.readhero.createSkillIcon(self.hero._tid, self.skill.slot)
  self.ui.skill_icon:addChild(icon)
  ed.layout.centerInParent(icon)
  self.ui.skill_level:setString(ed.formatLevel("Lv.") .. self.skillLevel)
  ed.setLabelStroke(self.ui.skill_level, ed.toccc3(5577228), 1)
  ed.setLabelStroke(self.ui.skill_rank, ed.toccc3(2565412), 1)
  self.ui.skill_rank:setString(self.step)
  self:refreshAttList()
  self:adaptUI()
end

function skillRankUpWin:adaptUI()
  if #self.changedAttrList > 1 then
    local detalHeight = (#self.changedAttrList - 1) * 28
    local oldSize = self.ui.skill_rankup_bg:getContentSize()
    self.ui.skill_rankup_bg:setContentSize(CCSizeMake(oldSize.width, oldSize.height + detalHeight))
    self.ui.skill_icon_bg:setPositionY(self.ui.skill_icon_bg:getPositionY() + detalHeight)
    self.ui.skill_attr:setPositionY(self.ui.skill_attr:getPositionY() + detalHeight)
  end
end

function skillRankUpWin:refreshAttList()
  local posY = 14
  self.maxAttrLength = 0
  self.attrLabelList = {}
  local oldLevelAttrList = self:getSkillAtt(self.skill, self.skillLevel - 1)
  local newLevelAttrList = self:getSkillAtt(self.skill, self.skillLevel)
  local changedAttrList = self:calcChangedAttr(oldLevelAttrList, newLevelAttrList)
  self.changedAttrList = {}
  for index, changedAttr in ipairs(changedAttrList) do
    if changedAttr.growthPopup then
      table.insert(self.changedAttrList, changedAttr)
      local arrItem = self:createAttChangeItem(changedAttr)
      local height = arrItem:getContentSize().height
      arrItem:setPositionX(15)
      self.ui.skill_attr:addChild(arrItem)
      arrItem:setPositionY(posY)
      posY = posY - height
    end
  end
  local maxPosX = 0
  for index, lui in ipairs(self.attrLabelList) do
    ed.right2(lui.arrow, lui.old_attr, 20)
    maxPosX = math.max(maxPosX, lui.arrow:getPositionX())
  end
  for index, lui in ipairs(self.attrLabelList) do
    lui.arrow:setPositionX(maxPosX)
    ed.right2(lui.new_attr, lui.arrow, 20)
  end
end

function skillRankUpWin:createAttChangeItem(changedAttr)
  local growthPopup = changedAttr.growthPopup
  local oldValue = changedAttr.oldValue
  local newValue = changedAttr.newValue
  local container, ui = ed.editorui(ed.uieditor.skillAttrChangeItem)
  container:setContentSize(ui.bg:getContentSize())
  ed.setLabelStroke(ui.old_attr, ed.toccc3(2693915), 2)
  ed.setLabelStroke(ui.new_attr, ed.toccc3(1519903), 2)
  ed.setLabelStroke(ui.attr_name, ed.toccc3(2693915), 2)
  local attrName = string.gsub(growthPopup, "+?#.*", "")
  ui.old_attr:setString(string.format(T("%s\239\188\154%s"), attrName, math.abs(oldValue)))
  local width = ui.old_attr:getContentSize().width
  self.maxAttrLength = math.max(width, self.maxAttrLength)
  ui.new_attr:setString(math.abs(newValue))
  table.insert(self.attrLabelList, {
    old_attr = ui.old_attr,
    arrow = ui.arrow,
    new_attr = ui.new_attr
  })
  return container
end

function skillRankUpWin:getSkillAtt(skill, skillLevel)
  local skillInfo = ed.Skill.getSkillInfo(skill.group, skillLevel)
  local skillGroupTb = ed.getDataTable("SkillGroup")
  local buffTb = ed.getDataTable("Buff")
  local skillGroupItemList = skillGroupTb[self.hero._tid] or {}
  local attrResult = {}
  for i = 1, 5 do
    for k, skillGroupItem in pairs(skillGroupItemList) do
      if skillGroupItem["Skill Group ID"] == skill.groupID then
        local growthField = skillGroupItem["Growth " .. i .. " Field"]
        if growthField then
          local growthPopup = skillGroupItem["Growth " .. i .. " Popup"]
          local value = 0
          if skillInfo[growthField] then
            value = skillInfo[growthField]
          else
            if skill[growthField] then
              value = skill[growthField]
            elseif buffTb[skill.buffId] and buffTb[skill.buffId][growthField] then
              value = buffTb[skill.buffId][growthField]
            end
            local growthValue = skillGroupItem["Growth " .. i .. " Value"] or 0
            value = value + growthValue * (skillLevel - 1)
          end
          table.insert(attrResult, {
            value = value,
            growthField = growthField,
            growthPopup = growthPopup
          })
        end
      end
    end
  end
  return attrResult
end

function skillRankUpWin:calcChangedAttr(oldLevelAttrList, newLevelAttrList)
  local changedAttrList = {}
  for index, newAttrResult in ipairs(newLevelAttrList) do
    local oldValue = 0
    for index, oldAttrResult in ipairs(oldLevelAttrList) do
      if newAttrResult.growthField == oldAttrResult.growthField then
        oldValue = oldAttrResult.value
        break
      end
    end
    local changeAttr = {
      growthField = newAttrResult.growthField,
      oldValue = oldValue,
      newValue = newAttrResult.value,
      growthPopup = newAttrResult.growthPopup
    }
    table.insert(changedAttrList, changeAttr)
  end
  return changedAttrList
end

function skillRankUpWin:addEventListener()
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event ~= "ended" then
        return false
      end
      if not ed.containsPoint(self.ui.skill_rankup_bg, x, y) then
        self:pop()
        return false
      end
      return false
    end,
    key = "close",
    priority = -100
  })
end

function skillRankUpWin:pop()
  self:destroy()
end
