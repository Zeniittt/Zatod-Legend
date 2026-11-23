local AutoChessTagPanel = newclass()
ed.ui.AutoChessTagPanel = AutoChessTagPanel

function AutoChessTagPanel:initData(params)
  self.data = params
  self.tag = params.tag
  self.target = params.target
  self.num = params.num
  self.level = params.level
  self.tabTable = ed.getDataTable("ChessTags")[self.tag]
end

function AutoChessTagPanel:initLabels()
  self.ui.label_effect:setFontName(ed.fontBold)
  self.ui.name:setFontName(ed.fontBold)
  self.ui.desc_skill:setDimensions(CCSizeMake(145, 100))
  ed.setLabelStroke(self.ui.level, ed.toccc3(1315346), 1)
  ed.setLabelStroke(self.ui.name, ed.toccc3(1315346), 1)
  ed.setLabelStroke(self.ui.gold_num, ed.toccc3(1315346), 1)
  ed.setLabelStroke(self.ui.desc_skill, ccc3(20, 18, 18), 1)
  ed.setLabelStroke(self.ui.label_attr_crit, ccc3(20, 18, 18), 1)
  ed.setLabelStroke(self.ui.label_attr_arm, ccc3(20, 18, 18), 1)
  ed.setLabelStroke(self.ui.label_attr_ad, ccc3(20, 18, 18), 1)
  ed.setLabelStroke(self.ui.label_attr_hp, ccc3(20, 18, 18), 1)
end

function AutoChessTagPanel:createTagDesc()
  local tagConfig = ed.AutoChessModel:getTagNumByType(self.tag)
  self.offsetY = 0
  local formatStr
  for i = 1, 3 do
    local config = tagConfig[i]
    if config then
      local color = i <= self.level and "ccc3(119,255,91)" or "ccc3(255,232,185)"
      if nil ~= formatStr then
        formatStr = formatStr .. "<br/>"
      else
        formatStr = ""
      end
      formatStr = formatStr .. string.format("<lable color=%s strokeColor=ccc3(20,18,18) strokeSize=1>%s</lable>", color, config.desc)
    end
  end
  print(tagConfig)
  if nil ~= formatStr then
    local autoText = ed.ui.autoText.new()
    autoText:initParam({
      context = formatStr,
      fontSize = 15,
      maxWidth = 230,
      maxHeight = 200
    })
    autoText.node:setPositionY(self.offsetY)
    local width, height = autoText:getContentSize()
    self.offsetY = self.offsetY - height
    self.ui.node_desc:addChild(autoText.node)
  end
end

function AutoChessTagPanel:createHeroList()
  local heroList = ed.AutoChessManager:getChessUnitListByTag(self.tag)
  local dx, dy = 60, 56
  local nCol = 4
  local ox, oy = -18, -100 + self.offsetY
  self.heroIconList = {}
  for k, v in ipairs(heroList) do
    local container, itemUI = ed.editorui(ed.uieditor.AutoChessHeroIcon)
    local heroIcon = ed.readhero.createChessIcon({
      id = v["Hero ID"],
      stars = 1,
      level = false
    })
    heroIcon.icon:setScale(0.5)
    ed.UITool.replaceUINew(itemUI, "icon", heroIcon.icon)
    table.insert(self.heroIconList, {ui = itemUI, data = v})
    ed.setTexture(itemUI.bg, string.format("UI/alpha/1080P/chess/battle/tag_chess_%d.png", v["Buy Price"]))
    ed.setLabelStroke(itemUI.num, ed.toccc3(1315346), 1)
    ed.setString(itemUI.num, v["Buy Price"])
    local row = math.ceil(k / nCol)
    local col = (k - 1) % nCol + 1
    container:setPosition(ccp(ox + col * dx, oy - row * dy))
    self.ui.layer_main:addChild(container)
  end
  self.offsetY = self.offsetY - math.ceil(#heroList / nCol) * dy
end

function AutoChessTagPanel:initUI()
  local container, ui = ed.editorui(ed.uieditor.AutoChessTagPanel)
  self.ui = ui
  self.container = container
  self:initLabels()
  ed.setLabelStroke(self.ui.level, ccc3(20, 18, 18), 1)
  ed.setString(self.ui.label_desc, T("\229\189\147\229\156\186\228\184\138\230\163\139\229\173\144\231\167\141\230\151\143\230\187\161\232\182\179\228\184\128\229\174\154\230\149\176\233\135\143\230\151\182\239\188\140\229\141\179\229\143\175\232\167\166\229\143\145\229\175\185\229\186\148\232\191\158\233\148\129\230\138\128\232\131\189\227\128\130"))
  self.ui.label_desc:limitSizeByScale(230, 35)
  ed.setString(self.ui.level, self.num)
  self.ui.level:setVisible(1 < self.num)
  ed.setString(self.ui.label_effect, self.tabTable["Display Name"])
  ed.setTexture(self.ui.node_tag_icon, self.tabTable.Sign)
  self:createTagDesc()
  self:createHeroList()
  local bgSize = self.ui.bg:getContentSize()
  self.ui.bg:setContentSize(CCSizeMake(bgSize.width, 120 - self.offsetY))
  self.ui.layer_main:setPositionY(120 - self.offsetY)
  self.ui.layer_hero_detail:setPositionY(120 - self.offsetY)
end

function AutoChessTagPanel:initAttrInfo(data)
  ed.setString(self.ui.label_attr_hp, data.HP)
  ed.setString(self.ui.label_attr_ad, data.AD)
  ed.setString(self.ui.label_attr_arm, data.ARM)
  ed.setString(self.ui.label_attr_crit, data.MR)
end

function AutoChessTagPanel:addChessTagNode(icon, hid)
  local function getPos(i)
    local ox, oy = 30, 12.5
    
    local dx, dy = 95, 25
    local row = math.floor((i - 1) / 2)
    local col = (i + 1) % 2
    return ccp(ox + col * dx, oy - dy * row)
  end
  
  local raceTags = ed.getChessUnitRaceTags(hid)
  local abilityTags = ed.getChessUnitAbilityTags(hid)
  local sumTags = #raceTags + #abilityTags
  local offsetY = -12.5
  local oy = 43.5
  for i = 3, sumTags, 2 do
    local tagBg = ed.createSprite("UI/alpha/1080P/chess/battle/tag_tips_bg.png")
    tagBg:setPosition(ccp(112, offsetY))
    icon:addChild(tagBg)
    offsetY = offsetY - 25
    oy = oy - 25
    self.ui.Panel_513:setPositionY(oy)
  end
  local index = 1
  
  local function createTag(tag)
    local tagConfig = ed.AutoChessModel:getTagNumByType(tag)
    local tagData = ed.getDataTable("ChessTags")[tag]
    local tagSprite = ed.createSprite(tagData.Sign)
    tagSprite:setScale(0.7)
    local name = ed.createLabelTTF(tagData["Display Name"], 15)
    name:setAnchorPoint(ccp(0, 0.5))
    ed.setLabelColor(name, ed.toccc3(16776423))
    ed.setLabelStroke(name, ccc3(20, 18, 18), 1)
    name:limitWidthByScale(65)
    local pos = getPos(index)
    tagSprite:setPosition(pos)
    icon:addChild(tagSprite, 2)
    name:setPosition(ccpAdd(pos, ccp(14, 0)))
    icon:addChild(name, 2)
    index = index + 1
  end
  
  for _, tag in ipairs(raceTags) do
    createTag(tag)
  end
  for _, tag in pairs(abilityTags) do
    createTag(tag)
  end
end

function AutoChessTagPanel:initSkillInfo(data)
  local skillGroupInfo = ed.lookupDataTable("ChessSkillGroup", nil, data["Hero ID"])
  local skillId = skillGroupInfo[1].none["Skill Group ID"]
  local skillInfo = ed.lookupDataTable("ChessSkill", nil, skillId, 0)
  local skillIcon = ed.readhero.createChessSkillIcon(data["Hero ID"], 1)
  skillIcon:setPosition(ccp(44, 45))
  self.ui.icon_skill:addChild(skillIcon)
  ed.setString(self.ui.desc_skill, skillInfo.Description)
end

function AutoChessTagPanel:refreshHeroDetailPanel(data)
  local heroIcon = ed.readhero.createChessIcon({
    id = data["Hero ID"],
    stars = 1,
    level = false
  })
  heroIcon.icon:setScale(0.6)
  ed.UITool.replaceUINew(self.ui, "icon", heroIcon.icon)
  ed.setString(self.ui.name, data["Display Name"])
  self.ui.name:limitWidthByScale(140)
  ed.setString(self.ui.gold_num, data["Buy Price"])
  self.ui.bg_tag:removeAllChildrenWithCleanup(true)
  self:addChessTagNode(self.ui.bg_tag, data["Hero ID"])
  self:initAttrInfo(data)
  self:initSkillInfo(data)
end

function AutoChessTagPanel:getTouchHandler()
  local selectIcon
  
  local function handler(event, x, y)
    if event == "began" then
    elseif event == "ended" then
      local clickIcon = false
      for k, v in ipairs(self.heroIconList) do
        if ed.containsPoint(v.ui.icon, x, y) then
          if selectIcon then
            selectIcon.ui.selected:setVisible(false)
            if selectIcon == v then
              self.ui.layer_hero_detail:setVisible(false)
              selectIcon = nil
              return
            end
            selectIcon = nil
          end
          self.ui.layer_hero_detail:setVisible(true)
          v.ui.selected:setVisible(true)
          self:refreshHeroDetailPanel(v.data)
          clickIcon = true
          selectIcon = v
        end
      end
      if not clickIcon then
        self.ui.layer_hero_detail:setVisible(false)
        if selectIcon then
          selectIcon.ui.selected:setVisible(false)
          selectIcon = nil
        end
      end
      if not ed.containsPoint(self.ui.bg, x, y) then
        FireEvent("AutoChessTagPanelClose")
        self:closeSelf()
      end
    end
    return true
  end
  
  return handler
end

function AutoChessTagPanel:registerTouchHandlers()
  self.container:setTouchEnabled(true)
  self.container:registerScriptTouchHandler(self:getTouchHandler(), false, -999, true)
end

function AutoChessTagPanel:closeSelf()
  self.container:removeFromParentAndCleanup(true)
end

function AutoChessTagPanel.createDetailTagPanel(icon, data, fixPos)
  if tolua.isnull(icon) then
    return
  end
  fixPos = fixPos or ccp(0, 0)
  local panel = ed.ui.AutoChessTagPanel.create(data)
  local pos = ccpAdd(ed.getWorldPos(icon), fixPos)
  panel.container:setPosition(pos)
  ed.getCurrentScene():ccScene():addChild(panel.container, 999)
  return panel
end

function AutoChessTagPanel.create(params)
  local self = {}
  setmetatable(self, AutoChessTagPanel.mt)
  self:initData(params)
  self:initUI()
  self:registerTouchHandlers()
  return self
end
