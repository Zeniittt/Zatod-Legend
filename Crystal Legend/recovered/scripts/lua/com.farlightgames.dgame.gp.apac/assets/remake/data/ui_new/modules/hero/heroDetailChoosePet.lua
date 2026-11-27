local base = ed.ui.popwindow
local heroDetailChoosePet = newclass(base.mt)
ed.ui.heroDetailChoosePet = heroDetailChoosePet
local res = ed.heroDetailManager.resConfig

function heroDetailChoosePet.create(param)
  local self = base.create("heroDetailChoosePet")
  setmetatable(self, heroDetailChoosePet.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function heroDetailChoosePet:initLabels()
  ed.setLabelStroke(self.ui.label_str, ed.toccc3(1184532), 1)
  ed.setLabelStroke(self.ui.label_agi, ed.toccc3(1184532), 1)
  ed.setLabelStroke(self.ui.label_int, ed.toccc3(1184532), 1)
  ed.setLabelStroke(self.ui.name, ed.toccc3(1184532), 1)
  ed.setLabelStroke(self.ui.level, ed.toccc3(1184532), 1)
end

function heroDetailChoosePet:initData(param)
  self.hid = param.hid
  self.tabIndex = 1
  self.petList = {
    {},
    {},
    {},
    {}
  }
  local pets = ed.player:getPets()
  for k, v in pairs(pets or {}) do
    table.insert(self.petList[1], v)
    if v:getColor() == 2 then
      table.insert(self.petList[4], v)
    elseif v:getColor() == 3 then
      table.insert(self.petList[3], v)
    elseif v:getColor() == 4 then
      table.insert(self.petList[2], v)
    end
  end
  for k, v in ipairs(self.petList) do
    table.sort(v, ed.cmpSort({
      {
        getValue = function(pet)
          if pet:getCarriedHeroId() > 0 then
            return 1
          end
          return 0
        end
      },
      {
        getValue = function(pet)
          return pet:getColor()
        end,
        reverse = true
      },
      {
        getValue = function(pet)
          return pet:getLevel()
        end,
        reverse = true
      },
      {
        getValue = function(pet)
          return pet:getId()
        end
      }
    }))
  end
end

function heroDetailChoosePet:initPetSkill(data)
  self.skill = self.pet:getSkillsInfo()
end

function heroDetailChoosePet:refreshTalents()
  local function createTalentLabel(talent)
    local bg = ed.createSprite("UI/alpha/1080P/pet/hero_pet/hero_pet_talent_bg.png")
    
    local label = ed.createLabelTTF(ed.getDataTable("PetTalent")[talent]["Pet Talent Name"], 16)
    ed.setLabelColor(label, ed.toccc3(16310150))
    ed.setLabelStroke(label, ed.toccc3(11622675), 1)
    bg:addChild(label)
    ed.layout.centerInParent(label)
    return bg
  end
  
  self.ui.type:removeAllChildrenWithCleanup(true)
  local data = self.pet:getTalents()
  
  local function getPos(i)
    local offsetY = 0
    if #data <= 3 then
      offsetY = -12
    end
    local row = math.ceil(i / 3)
    local col = i - 3 * (row - 1)
    return ccp(15 + 52 * col, 55 - row * 24 + offsetY)
  end
  
  for i, v in ipairs(data) do
    local talent = createTalentLabel(v)
    self.ui.type:addChild(talent)
    talent:setPosition(getPos(i))
  end
end

function heroDetailChoosePet:refreshPetInfo()
  self.ui.Panel_433:setVisible(self.pet ~= nil)
  if self.pet == nil then
    return
  end
  self:initPetSkill()
  self:refreshTalents()
  local icon = ed.readpet.createIconByPet(self.pet, {noLevel = true}).icon
  ed.UITool.replaceUINew(self.ui, "icon", icon)
  ed.setString(self.ui.name, self.pet:getName())
  ed.setString(self.ui.level, "+" .. self.pet:getLevel())
  ed.right2(self.ui.level, self.ui.name, 3)
  self.ui.level:setVisible(self.pet:getLevel() > 0)
  local tag_res = ed.Pet.getTagResByTypeId(self.pet:getTypeId())
  ed.setTexture(self.ui.tag, tag_res)
  local type = ed.getDataTable("Unit")[self.pet:getTypeId()]["Hero Type"]
  ed.setTexture(self.ui.type, ed.readhero.getTypeRes(self.pet:getTypeId()))
  local strRadio = self.pet:getPetAttrRadio("STR")
  local agiRadio = self.pet:getPetAttrRadio("AGI")
  local intRadio = self.pet:getPetAttrRadio("INT")
  ed.setString(self.ui.label_str, T("\229\138\155\233\135\143+") .. strRadio .. "%")
  ed.setString(self.ui.label_int, T("\230\153\186\229\138\155+") .. intRadio .. "%")
  ed.setString(self.ui.label_agi, T("\230\149\143\230\141\183+") .. agiRadio .. "%")
  local petTypeId = self.pet:getTypeId()
  local tbData = ed.getDataTable("Pet")[petTypeId]
  for i = 1, 3 do
    local attrCN = res.att_anim_name[tbData["Extra Attr " .. i .. " Type"]]
    local suffix = res.att_suffix[tbData["Extra Attr " .. i .. " Type"]] or ""
    ed.setString(self.ui["name_attr" .. i], attrCN)
    ed.setString(self.ui["value_attr" .. i], tbData["Extra Attr " .. i .. " Value"] .. suffix)
    if self.pet:getLevel() < tbData["Extra Attr " .. i .. " Unlock Level"] then
      ed.setLabelColor(self.ui["name_attr" .. i], ed.toccc3(11908533))
      ed.setLabelColor(self.ui["value_attr" .. i], ed.toccc3(11908533))
      ed.setString(self.ui["name_attr" .. i], attrCN .. string.format(T("(\232\167\163\233\148\129\231\173\137\231\186\167%d)"), tbData["Extra Attr " .. i .. " Unlock Level"]))
    else
      ed.setLabelColor(self.ui["name_attr" .. i], ed.toccc3(16771782))
      ed.setLabelColor(self.ui["value_attr" .. i], ed.toccc3(16771782))
    end
  end
  for i = 1, 2 do
    if self.skill[i] then
      local icon, bg = ed.readhero.createSkillIcon(self.pet:getTypeId(), self.skill[i].slot)
      icon:setScale(0.7)
      ed.UITool.replaceUINew(self.ui, "icon_skill" .. i, icon)
      if i == 1 then
        self:refreshDesc1()
      else
        self:refreshDesc2()
      end
      self.ui["skill_desc_" .. i]:setVisible(true)
    else
      self.ui["icon_skill" .. i]:setVisible(false)
      self.ui["skill_desc_" .. i]:setVisible(false)
    end
  end
  self.ui.btn_ok:setVisible(self.pet:getCarriedHeroId() == 0)
end

function heroDetailChoosePet:refreshDesc1()
  local size = self.ui.skill_desc_1:getContentSize()
  if self.descList1 then
    self.descList1:clearList()
  else
    self.descList1 = ed.UITool.createDraglist(self.ui.skill_desc_1)
  end
  local slot = self.skill[1].slot
  local autoStr = ed.heroDetailManager.getSkillAutoText(self.pet:getTypeId(), slot, self.pet:getSkillLevel(slot), false)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = autoStr,
    fontSize = 14,
    maxWidth = size.width - 5,
    strokeColor = ed.toccc3(2693915),
    strokeSize = 1,
    color = ccc3(255, 234, 197)
  })
  local width, height = autoText:getCurContentSize()
  self.descList1:addItem(autoText.node)
  autoText.node:setPosition(ccp(0, size.height - 10))
  self.descList1:initListHeight(height)
end

function heroDetailChoosePet:refreshDesc2()
  local size = self.ui.skill_desc_2:getContentSize()
  if self.descList2 then
    self.descList2:clearList()
  else
    self.descList2 = ed.UITool.createDraglist(self.ui.skill_desc_2)
  end
  local slot = self.skill[2].slot
  local autoStr = ed.heroDetailManager.getSkillAutoText(self.pet:getTypeId(), slot, self.pet:getSkillLevel(slot), false)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = autoStr,
    fontSize = 14,
    maxWidth = size.width - 5,
    strokeColor = ed.toccc3(2693915),
    strokeSize = 1,
    color = ccc3(255, 234, 197)
  })
  local width, height = autoText:getCurContentSize()
  self.descList2:addItem(autoText.node)
  autoText.node:setPosition(ccp(0, size.height - 10))
  self.descList2:initListHeight(height)
end

function heroDetailChoosePet:refreshDraglist()
  self.draglist:clearList()
  self.uiList = {}
  local size = self.ui.layer_item:getContentSize()
  local nCol = 6
  local dx, dy = 80, 80
  local ox, oy = 50, size.height - dy / 2
  
  local function getPos(i)
    local row = math.floor((i - 1) / nCol)
    local col = (i - 1) % nCol
    return ccp(ox + col * dx, oy - row * dy)
  end
  
  local n = 0
  for _, pet in ipairs(self.petList[self.tabIndex]) do
    n = n + 1
    local icon = ed.readpet.createIconByPet(pet, {showMaster = true})
    icon.icon:setPosition(getPos(n))
    table.insert(self.uiList, {
      data = pet,
      icon = icon.icon
    })
    self.draglist:addItem(icon.icon)
    if 0 < pet:getCarriedHeroId() then
      icon:addShade()
    end
  end
  if self.uiList[1] then
    self.selectIcon = ed.createSprite("UI/alpha/1080P/package/hero_selected.png")
    self.selectIcon:setScale(0.9)
    self.draglist:addItem(self.selectIcon)
    self.pet = self.uiList[1].data
    self.selectIcon:setPosition(ccp(self.uiList[1].icon:getPosition()))
  else
    self.pet = nil
  end
  self.draglist:initListHeight(dy * math.ceil(n / nCol))
end

function heroDetailChoosePet:refreshUI()
  self:refreshDraglist()
  self:refreshPetInfo()
end

function heroDetailChoosePet:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    if ed.containsPoint(v.icon, x, y) then
      if v.data == self.pet then
        return
      else
        self.pet = v.data
        self.selectIcon:setPosition(ccp(v.icon:getPosition()))
        self:refreshPetInfo()
      end
    end
  end
  
  return handler
end

function heroDetailChoosePet:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      if ed.containsPoint(v.icon, x, y) then
        return v
      end
    end
    return nil
  end
  
  return handler
end

function heroDetailChoosePet:initUI()
  ed.editorui(ed.uieditor.herodetailChoosePet, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:doPressInList(),
    doClickIn = self:doClickInList()
  })
  self:refreshUI()
end

function heroDetailChoosePet:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {pressScale = 0.7, normalScale = 0.75})
  for i = 1, 4 do
    local labelName = {
      T("\229\133\168\233\131\168"),
      T("\230\169\153\232\137\178"),
      T("\231\180\171\232\137\178"),
      T("\232\147\157\232\137\178")
    }
    local posX = {
      56,
      192,
      317,
      452
    }
    ed.UITool.registerBtn(self, "tab" .. i, function()
      if self.tabIndex == i then
        return
      end
      if #self.petList[i] == 0 then
      end
      self.ui.no_egg_bg_Copy0:setVisible(#self.petList[i] == 0)
      self.tabIndex = i
      self.ui.btn_tab_selected:setPosition(ccp(posX[i], 16.5))
      self.ui.Label_7089:setString(labelName[i])
      self:refreshUI()
    end)
  end
  ed.UITool.registerBtn(self, "btn_ok", function()
    if self.pet:getCD() ~= 0 then
      ed.showConfirmDialog1({
        title = T("\230\143\144\231\164\186"),
        autoText = string.format(T("\233\162\134\229\133\187\230\173\164\228\191\161\228\189\191\229\144\142\239\188\140\233\156\128\232\166\129\231\173\137\229\190\133<lable color=ccc3(255,0,0)>%s</lable>\229\144\142\230\137\141\232\131\189\231\166\187\229\188\128\228\184\187\228\186\186\239\188\140\230\152\175\229\144\166\231\187\167\231\187\173\239\188\159"), self.pet:getCDStr()),
        offsetY = 10,
        fontSize = 20,
        rightHandler = function()
          ed.PetNetwork:equipPet(self.hid, self.pet:getId())
        end
      })
    else
      ed.PetNetwork:equipPet(self.hid, self.pet:getId())
    end
  end, {pressScale = 0.9})
  self:listenEvent("PetEquipSuccess", function()
    self:destroy()
  end)
end
