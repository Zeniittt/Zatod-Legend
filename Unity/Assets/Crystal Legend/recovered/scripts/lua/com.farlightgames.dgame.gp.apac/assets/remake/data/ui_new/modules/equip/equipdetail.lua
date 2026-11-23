local class = newclass()
ed.ui.equipdetail = class
local lsr = ed.ui.equipdetaillsr.create()
local offsetX = -40

local function refreshClipRect(self)
  local function handler(dt)
    xpcall(function()
      if tolua.isnull(self.layer) then
        self:endRefreshCliprect()
        
        return
      end
      self.draglist:refreshClipRect(self.layer:getScale())
    end, EDDebug)
  end
  
  return handler
end

class.refreshClipRect = refreshClipRect

local function beginRefreshCliprect(self)
  self.baseScene:registerUpdateHandler("refreshCliprect", self:refreshClipRect())
end

class.beginRefreshCliprect = beginRefreshCliprect

local function endRefreshCliprect(self)
  self.baseScene:removeUpdateHandler("refreshCliprect")
end

class.endRefreshCliprect = endRefreshCliprect

local function doGetwayTouch(self)
  local pressidx
  
  local function handler(event, x, y)
    if event == "began" then
      for k, v in pairs(self.listway) do
        if ed.containsPoint(self.listway[k].bg, x, y) then
          pressidx = k
          break
        end
      end
    elseif event == "ended" then
      local idx = pressidx
      pressidx = nil
      if idx then
        local stageid = self.listway[idx].id
        local st = ed.stageType(stageid)
        if ed.isElementInTable(st, {"normal", "elite"}) then
          local star = ed.player:getStageStar(stageid) or 0
          local preStar = ed.player:getStageStar(stageid - 1) or 0
          if 0 < star + preStar then
            local scene = ed.ui.stageselect.createByStage(stageid)
            ed.pushScene(scene)
          else
            ed.showToast(T("\229\133\179\229\141\161\229\176\154\230\156\170\229\188\128\229\144\175\227\128\130"))
          end
        end
      end
    end
  end
  
  return handler
end

class.doGetwayTouch = doGetwayTouch

local function doCloseTouch(self)
  local isPress
  local button = self.ui.close
  local press = self.ui.closePress
  
  local function handler(event, x, y)
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        if ed.containsPoint(button, x, y) then
          self:destroy()
        end
      end
      isPress = nil
    end
  end
  
  return handler
end

class.doCloseTouch = doCloseTouch

local function doOutLayerTouch(self)
  local isPress
  local ui = self.ui
  local bg = self.ui.bg
  
  local function handler(event, x, y)
    if event == "began" then
      if not ed.containsPoint(self.ui.bg, x, y) then
        isPress = true
      end
    elseif event == "ended" then
      if isPress and not ed.containsPoint(self.ui.bg, x, y) then
        self:destroy()
      end
      isPress = nil
    end
  end
  
  return handler
end

class.doOutLayerTouch = doOutLayerTouch

local function doMainLayerTouch(self)
  local outLayerTouch = self:doOutLayerTouch()
  local closeTouch = self:doCloseTouch()
  local getwayTouch = self:doGetwayTouch()
  
  local function handler(event, x, y)
    xpcall(function()
      outLayerTouch(event, x, y)
      closeTouch(event, x, y)
      getwayTouch(event, x, y)
    end, EDDebug)
    return true
  end
  
  return handler
end

class.doMainLayerTouch = doMainLayerTouch

local function getEquipData(self, id)
  local equipList = {}
  local craftData = ed.getDataTable("equipcraft")
  for k, v in pairs(craftData) do
    for i = 1, 4 do
      if v["Component" .. i] == id and not ed.getDataTable("equip")[k].Hide and ed.readequip.isEquipOpen(k) then
        if k ~= id then
          table.insert(equipList, {
            id = k,
            name = ed.getDataTable("equip")[k].Name
          })
        end
        break
      end
    end
  end
  self.equipList = equipList
  local heroList = {}
  local idList = {}
  local heroData = ed.getDataTable("hero_equip")
  local unitData = ed.getDataTable("Unit")
  for k, v in pairs(heroData) do
    local index = 1
    while v[index] do
      local row = v[index]
      for j = 1, 6 do
        if row["Equip" .. j .. " ID"] == id then
          if 0 < k then
            local ur = unitData[k]
            if ur and ed.readhero.isHeroOpen(k) and (ur.Enable or 0 < (ed.player.equip_qunty[ed.readhero.getStoneid(k)] or 0) or ed.player.heroes[k]) and index <= ed.parameter.display_equipale_hero_rank then
              local name = ur["Display Name"]
              table.insert(heroList, {
                id = k,
                rank = index,
                name = name
              })
              table.insert(idList, k)
            end
          end
          break
        end
      end
      index = index + 1
    end
  end
  self.heroList = heroList
  local equipInfo = ed.getDataTable("equip")[id]
  if equipInfo.Category ~= T("\228\185\166\230\156\172") then
    return
  end
  local bookid = 1
  while ed.getDataTable("SchoolBook")[bookid] ~= nil do
    local bookcsv = ed.getDataTable("SchoolBook")[bookid]
    if bookcsv["Unlock Requirement Type"] == "HaveItem" and bookcsv["Unlock Requirement ID"] == id then
      break
    end
    bookid = bookid + 1
  end
  local affectHeroList = {}
  local affectHeroNum = 0
  local skillGroup = ed.getDataTable("SchoolSkillGroup")[bookid]
  for i = 1, #skillGroup do
    local skill = skillGroup[i]
    local affectHeroes = skill["Affect Hero"]
    for j = 1, #affectHeroes do
      local hid = affectHeroes[j]
      if hid ~= 0 then
        local has = ed.player.heroes[hid]
        if not affectHeroList[hid] then
          affectHeroNum = affectHeroNum + 1
          local heroUnit = ed.getDataTable("Unit")[hid]
          affectHeroList[hid] = {
            id = hid,
            has = has,
            name = heroUnit["Display Name"]
          }
        end
      end
    end
  end
  self.affectHeroList = affectHeroList
  self.affectHeroNum = affectHeroNum
end

class.getEquipData = getEquipData

local function createDetail(self, id)
  id = id or self.id
  self.draglist:clearList()
  self:getEquipData(id)
  local layer = self.draglist:getList()
  local height = 15
  local gap = 20
  if #self.equipList > 0 then
    local equipTitleBg = ed.createSprite("UI/alpha/HVGA/equip_detail_title_bg.png")
    equipTitleBg:setPosition(ccp(440 + offsetX, 435 - height - equipTitleBg:getContentSize().height / 2))
    layer:addChild(equipTitleBg)
    local equipTitle = ed.createttf(T("\229\143\175\229\144\136\230\136\144\232\163\133\229\164\135"), 24)
    ed.setLabelColor(equipTitle, ccc3(250, 205, 16))
    equipTitle:setPosition(ccp(equipTitleBg:getPosition()))
    layer:addChild(equipTitle)
    height = height + gap + equipTitleBg:getContentSize().height
    local equipHeight = 15 + 55 * math.ceil(#self.equipList / 2)
    local equipListBg = ed.createScale9Sprite("UI/alpha/1080P/common/tip_detail_bg.png", CCRectMake(80, 10, 5, 5))
    equipListBg:setAnchorPoint(ccp(0.5, 1))
    equipListBg:setPosition(ccp(440 + offsetX, 435 - height))
    if equipHeight < 60 then
      equipHeight = 60
    end
    equipListBg:setContentSize(CCSizeMake(410, equipHeight))
    layer:addChild(equipListBg)
    local list = self.equipList
    for i = 1, #list do
      local icon = ed.readequip.createIcon(list[i].id, 40)
      if icon then
        icon:setPosition(ccp(280 + 190 * ((i - 1) % 2) + offsetX, 435 - height - 35 - 55 * math.floor((i - 1) / 2)))
        layer:addChild(icon)
      end
      local name = ed.createttf(list[i].name, 20)
      name:setAnchorPoint(ccp(0, 0.5))
      name:setPosition(ccp(310 + 190 * ((i - 1) % 2) + offsetX, 435 - height - 35 - 55 * math.floor((i - 1) / 2)))
      if resource_config.equipdetailColor then
        ed.setLabelColor(name, ccc3(0, 0, 0))
        ed.setLabelShadow(name, ccc3(0, 0, 0), ccp(0, 2))
      else
        ed.setLabelColor(name, ccc3(255, 234, 198))
      end
      layer:addChild(name)
    end
    height = height + gap + equipHeight
  end
  if 0 < #self.heroList then
    local heroTitleBg = ed.createSprite("UI/alpha/HVGA/equip_detail_title_bg.png")
    heroTitleBg:setPosition(ccp(440 + offsetX, 435 - height - heroTitleBg:getContentSize().height / 2))
    layer:addChild(heroTitleBg)
    local heroTitle = ed.createttf(T("\229\143\175\232\163\133\229\164\135\232\139\177\233\155\132"), 24)
    ed.setLabelColor(heroTitle, ccc3(250, 205, 16))
    heroTitle:setPosition(ccp(heroTitleBg:getPosition()))
    layer:addChild(heroTitle)
    height = height + gap + heroTitleBg:getContentSize().height
    local heroHeight = 15 + 55 * math.ceil(#self.heroList / 2)
    local heroListBg = ed.createScale9Sprite("UI/alpha/1080P/common/tip_detail_bg.png", CCRectMake(80, 10, 5, 5))
    heroListBg:setAnchorPoint(ccp(0.5, 1))
    heroListBg:setPosition(ccp(440 + offsetX, 435 - height))
    if heroHeight < 60 then
      heroHeight = 60
    end
    heroListBg:setContentSize(CCSizeMake(410, heroHeight))
    layer:addChild(heroListBg)
    local list = self.heroList
    for i = 1, #list do
      local icon = ed.readhero.getIcon({
        id = list[i].id,
        rank = list[i].rank,
        length = 40
      })
      if icon then
        icon:setPosition(ccp(280 + 190 * ((i - 1) % 2) + offsetX, 435 - height - 35 - 55 * math.floor((i - 1) / 2)))
        layer:addChild(icon)
      end
      local nameColor = ccc3(255, 234, 198)
      if resource_config.equipdetailColor then
        nameColor = ccc3(0, 0, 0)
      end
      local name, w = ed.readhero.createHeroNameByInfo({
        name = list[i].name,
        rank = list[i].rank,
        nameColor = nameColor,
        tid = list[i].id
      })
      name:setPosition(ccp(310 + 190 * ((i - 1) % 2) + offsetX, 435 - height - 35 - 55 * math.floor((i - 1) / 2)))
      layer:addChild(name)
    end
    height = height + gap + heroHeight
  end
  if self.affectHeroList and 0 < self.affectHeroNum then
    local heroTitleBg = ed.createSprite("UI/alpha/HVGA/equip_detail_title_bg.png")
    heroTitleBg:setPosition(ccp(440 + offsetX, 435 - height - heroTitleBg:getContentSize().height / 2))
    layer:addChild(heroTitleBg)
    local heroTitle = ed.createttf(T("\231\155\184\229\133\179\232\139\177\233\155\132"), 24)
    ed.setLabelColor(heroTitle, ccc3(250, 205, 16))
    heroTitle:setPosition(ccp(heroTitleBg:getPosition()))
    layer:addChild(heroTitle)
    height = height + gap + heroTitleBg:getContentSize().height
    local heroHeight = 15 + 55 * math.ceil(self.affectHeroNum / 2)
    local heroListBg = ed.createScale9Sprite("UI/alpha/1080P/common/tip_detail_bg.png", CCRectMake(80, 10, 5, 5))
    heroListBg:setAnchorPoint(ccp(0.5, 1))
    heroListBg:setPosition(ccp(440 + offsetX, 435 - height))
    if heroHeight < 60 then
      heroHeight = 60
    end
    heroListBg:setContentSize(CCSizeMake(410, heroHeight))
    layer:addChild(heroListBg)
    local list = self.affectHeroList
    local idx = 0
    for k, v in pairs(list) do
      idx = idx + 1
      local unit
      if v.has then
        unit = ed.readhero.createIconByID(v.id)
      else
        unit = ed.readhero.createIcon({
          id = v.id,
          rank = 1,
          awake = false
        })
        ed.setSpriteGray(unit.icon)
      end
      unit.icon:setPosition(ccp(280 + 190 * ((idx - 1) % 2) + offsetX, 435 - height - 35 - 55 * math.floor((idx - 1) / 2)))
      unit.icon:setScale(0.5)
      layer:addChild(unit.icon)
      local nameColor = ccc3(255, 234, 198)
      local name = ed.createLabelTTF(v.name, 20)
      name:setPosition(ccp(310 + 190 * ((idx - 1) % 2) - 30, 435 - height - 35 - 55 * math.floor((idx - 1) / 2)))
      name:setColor(nameColor)
      name:setAnchorPoint(ccp(0, 0.5))
      layer:addChild(name)
    end
    height = height + gap + heroHeight
  end
  local getTitleBg = ed.createSprite("UI/alpha/HVGA/equip_detail_title_bg.png")
  getTitleBg:setPosition(ccp(440 + offsetX, 435 - height - getTitleBg:getContentSize().height / 2))
  layer:addChild(getTitleBg)
  local getTitle = ed.createttf(T("\232\142\183\229\190\151\233\128\148\229\190\132"), 24)
  ed.setLabelColor(getTitle, ccc3(250, 205, 16))
  getTitle:setPosition(ccp(getTitleBg:getPosition()))
  layer:addChild(getTitle)
  height = height + gap + getTitleBg:getContentSize().height
  local row = ed.getDataTable("equip")[id] or {}
  local stageTable = ed.getDataTable("Stage")
  local getWay = {}
  local dropInfo = row.Drop
  for k, stageId in ipairs(dropInfo) do
    local chapter = (ed.getDataTable("Stage")[stageId] or {})["Chapter ID"]
    local isElite = ed.stageType(stageId) == "elite"
    local maxChapter = isElite and ed.playerlimit.maxChapter("elite") or ed.playerlimit.maxChapter("normal")
    if 0 < (stageId or 0) and chapter and chapter <= maxChapter then
      local name = stageTable[stageId]["Stage Name"]
      if isElite then
        name = T("\231\178\190\232\139\177") .. "\n" .. name
      end
      local res = ed.ui.stageselectres.getStageIcon(stageId)
      table.insert(getWay, {
        id = stageId,
        name = name,
        res = res
      })
    end
  end
  self.listway = {}
  for i = 1, #getWay do
    local way = getWay[i]
    local getDetailBg = ed.createScale9Sprite("UI/alpha/1080P/common/tip_detail_bg.png", CCRectMake(80, 10, 5, 5))
    getDetailBg:setAnchorPoint(ccp(0.5, 0.5))
    getDetailBg:setContentSize(CCSizeMake(202, 62))
    layer:addChild(getDetailBg)
    local iconPos, namePos
    if resource_config.equipdetail_getway_single_column then
      iconPos = ccp(280 + offsetX, 435 - height - 35 - 65 * (i - 1))
      namePos = ccp(310 + offsetX, 435 - height - 35 - 65 * (i - 1))
      getDetailBg:setPosition(ccp(340 + offsetX, 435 - height - 35 - 65 * (i - 1)))
    else
      iconPos = ccp(280 + 205 * ((i - 1) % 2) + offsetX, 435 - height - 35 - 65 * math.floor((i - 1) / 2))
      namePos = ccp(310 + 205 * ((i - 1) % 2) + offsetX, 435 - height - 35 - 65 * math.floor((i - 1) / 2))
      getDetailBg:setPosition(ccp(340 + 205 * ((i - 1) % 2) + offsetX, 433 - height - 35 - 65 * math.floor((i - 1) / 2)))
    end
    local icon = ed.createNode({
      t = "Sprite",
      base = {
        res = way.res
      },
      layout = {position = iconPos},
      config = {fix_height = 60}
    }, layer)
    local name = ed.createNode({
      t = "Label",
      base = {
        text = way.name,
        size = 20
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = namePos
      },
      config = {
        color = ccc3(255, 234, 198),
        horizontalAlignment = kCCTextAlignmentLeft
      }
    }, layer)
    table.insert(self.listway, {
      bg = getDetailBg,
      icon = icon,
      id = way.id
    })
  end
  local getHeight
  if resource_config.equipdetail_getway_single_column then
    getHeight = 65 * #getWay
  else
    getHeight = 65 * math.ceil(#getWay / 2)
  end
  local getText = table.concat(row["How To Get"], "\n")
  if getText and getText ~= "" then
    local label = ed.createNode({
      t = "Label",
      base = {text = getText, size = 18},
      layout = {
        anchor = ccp(0.5, 1),
        position = ccp(440 + offsetX, 435 - height - getHeight - 10)
      },
      config = {
        color = ccc3(238, 204, 119),
        dimension = CCSizeMake(240, 0),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    }, layer)
    getHeight = getHeight + 20 + label:getContentSize().height
  end
  if getHeight < 60 then
    getHeight = 60
  end
  height = height + getHeight + 20
  self.draglist:initListHeight(height)
end

class.createDetail = createDetail

local function createIcon(self, id)
  if self.ui.icon then
    self.ui.icon:removeFromParentAndCleanup(true)
  end
  local icon = ed.readequip.createIcon(id)
  icon:setPosition(ccp(178 + offsetX, 402))
  self.ui.icon = icon
  self.layer:addChild(icon)
end

class.createIcon = createIcon

local function createList(self, id)
  local info = {
    cliprect = CCRectMake(0, 50, 800, 385),
    rect = CCRectMake(235 + offsetX, 50, 410, 385),
    container = self.layer,
    zorder = 10,
    priority = -200,
    bar = {
      bglen = 360,
      bgpos = ccp(230 + offsetX, 240)
    }
  }
  self.draglist = ed.draglist.create(info)
  self:createDetail()
end

class.createList = createList

local function create(id)
  local self = {}
  setmetatable(self, class.mt)
  self.id = id
  local baseScene = ed.getCurrentScene()
  self.baseScene = baseScene
  local mainLayer = CCLayerColor:create(ccc4(0, 0, 0, 150))
  mainLayer:setTouchEnabled(true)
  self.mainLayer = mainLayer
  local layer = CCLayer:create()
  self.layer = layer
  self.mainLayer:addChild(layer)
  local ui = {}
  self.ui = ui
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "bg",
        res = "UI/alpha/1080P/common/main_vit_tips.png",
        capInsets = CCRectMake(15, 15, 10, 10)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(440 + offsetX, 240)
      },
      config = {
        scaleSize = CCSizeMake(446, 401)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "close",
        res = "UI/alpha/1080P/common/herodetail-detail-close.png",
        z = 11
      },
      layout = {
        position = ccp(618, 420)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "closePress",
        res = "UI/alpha/1080P/common/herodetail-detail-close-p.png",
        parent = "close"
      },
      layout = {
        position = ccp(618, 420)
      },
      config = {visible = false}
    }
  }
  local readnode = ed.readnode.create(layer, ui)
  readnode:addNode(ui_info)
  self:createIcon(id)
  self:createList(id)
  self:show()
  mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, -200, true)
  return self
end

class.create = create

local function show(self)
  self.layer:setScale(0)
  self.mainLayer:setVisible(true)
  self.mainLayer:setTouchEnabled(true)
  local refresh = self:refreshClipRect()
  self:beginRefreshCliprect()
  local s = CCScaleTo:create(0.2, 1)
  s = CCEaseBackOut:create(s)
  local func = CCCallFunc:create(function()
    xpcall(function()
      self:endRefreshCliprect()
      refresh()
    end, EDDebug)
  end)
  local s = CCSequence:createWithTwoActions(s, func)
  self.layer:runAction(s)
end

class.show = show

local function destroy(self)
  lsr:report("closeWindow")
  self:beginRefreshCliprect()
  local s = CCScaleTo:create(0.2, 0)
  s = CCEaseBackIn:create(s)
  local func = CCCallFunc:create(function()
    xpcall(function()
      self:endRefreshCliprect()
      self.mainLayer:removeFromParentAndCleanup(true)
      if self.destroyHandler then
        self.destroyHandler()
      end
    end, EDDebug)
  end)
  s = CCSequence:createWithTwoActions(s, func)
  self.layer:runAction(s)
end

class.destroy = destroy

local function isShow(self)
  return self.mainLayer:isVisible()
end

class.isShow = isShow
