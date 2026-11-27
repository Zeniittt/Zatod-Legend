local class = newclass("g")
ed.rogueLikeTool = class
class.RARITY_CFG = {
  [1] = {
    typeStrokeColor = ed.toccc3(3439829)
  },
  [2] = {
    typeStrokeColor = ed.toccc3(12596437)
  },
  [3] = {
    typeStrokeColor = ed.toccc3(13995828)
  },
  [4] = {
    typeStrokeColor = ed.toccc3(10838742)
  }
}

local function doTouchLoad()
  return true
end

function class.createDestinyCard(destinyId, param)
  param = param or {}
  local container = CCSprite:create()
  local node, ui = ed.editorui(ed.uieditor.rogueDestinyCard, {container = container})
  container:setContentSize(ui.image_bg:getContentSize())
  ed.layout.centerInParent(ui.image_bg)
  local destinyCfg = ed.getDataTable("RogueDestiny")[destinyId] or {}
  local iconPath = string.format("UI/alpha/1080P/rogue/bless/%s.png", destinyCfg.Icon)
  ed.setTexture(ui.image_icon, iconPath)
  local name = ed.createttf(destinyCfg["Display Name"] or "", 36)
  ed.setLabelFontName(name, ed.fontBold)
  ed.setLabelColor(name, ed.toccc3(16776423))
  ed.setLabelStroke(name, ed.toccc3(8268783), 2)
  ui.image_bg:addChild(name)
  name:setPosition(ui.panel_name_pos:getPosition())
  ui.name = name
  return node, ui
end

function class.createRevelationCard(destinyId, param)
  param = param or {}
  local descType = param.descType or "Revelation Description"
  local container = CCSprite:create()
  local node, ui = ed.editorui(ed.uieditor.rogueRevelationCard, {container = container})
  container:setContentSize(ui.image_bg:getContentSize())
  ed.layout.centerInParent(ui.image_bg)
  local destinyCfg = ed.getDataTable("RogueDestiny")[destinyId] or {}
  ed.setLabelString(ui.label_name, destinyCfg["Revelation Name"] or "")
  ed.setLabelStroke(ui.label_name, ed.toccc3(2565412), 1)
  ed.setLabelFontName(ui.label_bless_type, ed.fontBold)
  ed.setLabelString(ui.label_bless_type, destinyCfg["Display Name"] or "")
  ed.setLabelStroke(ui.label_bless_type, ed.toccc3(10838742), 1)
  local typeLabelSize = ui.label_bless_type:getContentSize()
  local typeBgPath = "UI/alpha/1080P/rogue/bless/bless_name_bg_4.png"
  ui.image_bless_type_bg:setSpriteFrame(ed.getSpriteFrame(typeBgPath))
  ui.image_bless_type_bg:setContentSize(CCSizeMake(typeLabelSize.width + 29, 28))
  local iconPath = string.format("UI/alpha/1080P/rogue/bless/%s_simple.png", destinyCfg.Icon)
  ed.setTexture(ui.image_icon, iconPath)
  local descDragList = ed.UITool.createDraglist(ui.panel_desc)
  local panelSize = ui.panel_desc:getContentSize()
  local desc = destinyCfg[descType] or ""
  local descAutoText = ed.rogueLikeTool.parseAutoTextDesc(desc, destinyCfg, {
    color = ed.toccc3(16776423),
    strokeColor = ed.toccc3(2565412),
    strokeSize = 1,
    maxWidth = panelSize.width,
    fontSize = 15,
    priority = -300
  })
  descDragList:addItem(descAutoText.node)
  descAutoText.node:setPosition(ccp(0, panelSize.height - 15))
  local descWidth, descHeight = descAutoText:getCurContentSize()
  descDragList:initListHeight(descHeight)
  return node, ui
end

function class.createBlessCard(blessId, param)
  param = param or {}
  local descType = param.descType
  local isReinforce = param.isReinforce or false
  local container = CCSprite:create()
  local node, ui = ed.editorui(ed.uieditor.rogueBlessCard, {container = container})
  container:setContentSize(ui.image_bg:getContentSize())
  container:setCascadeOpacityEnabled(true)
  ui.image_bg:setCascadeOpacityEnabled(true)
  ed.layout.centerInParent(ui.image_bg)
  ui.image_select:setVisible(false)
  local blessCfg = ed.getDataTable("RogueBless")[blessId] or {}
  local rarity = blessCfg.Rarity or 1
  if isReinforce then
    ed.setTexture(ui.image_bg, string.format("UI/alpha/1080P/rogue/bless/bless_reinforce_rank_%s.png", rarity))
  else
    ed.setTexture(ui.image_bg, string.format("UI/alpha/1080P/rogue/bless/bless_rank_%s.png", rarity))
  end
  ed.setLabelString(ui.label_name, blessCfg["Bless Name"] or "")
  ed.setLabelStroke(ui.label_name, ed.toccc3(2565412), 1)
  local destinyTB = ed.getDataTable("RogueDestiny")
  local destinyId = blessCfg["Destiny ID"]
  local duoDestinyId = blessCfg["Duo Destiny ID"]
  local type
  if 0 < duoDestinyId then
    type = string.format("%s+%s", destinyTB[destinyId]["Display Name"], destinyTB[duoDestinyId]["Display Name"])
  else
    type = destinyTB[destinyId]["Display Name"]
  end
  ed.setLabelFontName(ui.label_bless_type, ed.fontBold)
  ed.setLabelString(ui.label_bless_type, type or "")
  ed.setLabelStroke(ui.label_bless_type, class.RARITY_CFG[rarity].typeStrokeColor, 1)
  local typeLabelSize = ui.label_bless_type:getContentSize()
  local typeBgPath = string.format("UI/alpha/1080P/rogue/bless/bless_name_bg_%s.png", rarity)
  ui.image_bless_type_bg:setSpriteFrame(ed.getSpriteFrame(typeBgPath))
  ui.image_bless_type_bg:setContentSize(CCSizeMake(typeLabelSize.width + 29, 28))
  local icon = class.createBlessIcon(blessId)
  local panelIconSize = ui.panel_icon:getContentSize()
  ui.image_bg:addChild(icon)
  icon:setPositionX(ui.panel_icon:getPositionX() + panelIconSize.width / 2)
  icon:setPositionY(ui.panel_icon:getPositionY() + panelIconSize.height / 2)
  ui.image_reinforce_bg:setVisible(isReinforce)
  local blessType = blessCfg["Bless Type"]
  ui.image_double_bg:setVisible(blessType == "DuoBless")
  local descDragList = ed.UITool.createDraglist(ui.panel_desc)
  local panelSize = ui.panel_desc:getContentSize()
  local desc = blessCfg[descType] or blessCfg.Description
  local descAutoText = ed.rogueLikeTool.parseAutoTextDesc(desc, blessCfg, {
    color = ed.toccc3(16776423),
    strokeColor = ed.toccc3(2565412),
    strokeSize = 1,
    maxWidth = panelSize.width,
    fontSize = 15,
    priority = -300
  })
  descDragList:addItem(descAutoText.node)
  descAutoText.node:setPosition(ccp(1, panelSize.height - 15))
  local descWidth, descHeight = descAutoText:getCurContentSize()
  descDragList:initListHeight(descHeight)
  ui.descAutoTextNode = descAutoText.node
  return node, ui
end

function class.createBlessIcon(blessId)
  local blessCfg = ed.getDataTable("RogueBless")[blessId] or {}
  local container = CCSprite:create()
  container:setContentSize(CCSizeMake(194, 141))
  local iconList = blessCfg.Icon or {}
  if #iconList == 1 then
    local iconPath = string.format("UI/alpha/1080P/rogue/bless/%s.png", iconList[1])
    local icon = ed.createSprite(iconPath)
    container:addChild(icon)
    ed.layout.centerInParent(icon)
  elseif #iconList == 2 then
    local topPath = string.format("UI/alpha/1080P/rogue/bless/%s.png", iconList[1])
    local iconTop = ed.createClippingNode(topPath, "UI/alpha/1080P/rogue/bless/bless_double_top.png", nil, CCSizeMake(0, 0))
    container:addChild(iconTop)
    ed.layout.centerInParent(iconTop)
    local bottomPath = string.format("UI/alpha/1080P/rogue/bless/%s.png", iconList[2])
    local bottomTop = ed.createClippingNode(bottomPath, "UI/alpha/1080P/rogue/bless/bless_double_bottom.png", nil, CCSizeMake(0, 0))
    container:addChild(bottomTop)
    ed.layout.centerInParent(bottomTop)
  end
  container:setCascadeOpacityEnabled(true)
  return container
end

function class.createRevelationSimpleIcon(destinyId)
  local destinyCfg = ed.getDataTable("RogueDestiny")[destinyId]
  local iconPath = destinyCfg.Icon or "bless_the_devil"
  local icon = ed.createSprite(string.format("UI/alpha/1080P/rogue/bless/%s_simple.png", iconPath))
  return icon
end

function class.parseAutoTextDesc(desc, t, param)
  desc = desc or ""
  t = t or {}
  param = param or {}
  local autoText = ed.ui.autoText.new()
  autoText:addRegisterHandler("clickLink", function(id, x, y)
    ed.UITool.openView("showDictInfoPop", {
      index = id,
      x = x,
      y = y
    })
  end)
  desc = string.gsub(desc, "%%(Script Arg&%d)%%", function(str)
    str = string.gsub(str, "&", "")
    if t and t[str] then
      local num = 0
      if type(t[str]) == "number" then
        num = math.abs(t[str])
      end
      local value = string.format("<lable color=ccc3(255,166,80)>%s</lable>", num)
      return value
    end
    return ""
  end)
  desc = string.gsub(desc, "<#(%d+)#(.-)#>", function(id, name)
    id = tonumber(id)
    local value = string.format("<lable color=ccc3(255,251,231) clickhandler=%s data=%d>%s</lable>", "clickLink", id, name or "")
    return value
  end)
  desc = string.gsub(desc, "#p#", "%%")
  param.context = desc
  autoText:initParam(param)
  return autoText
end

class.ROMAN_NUM_TO_RES = {
  I = "UI/alpha/1080P/rogue/main/main_num_1.png",
  V = "UI/alpha/1080P/rogue/main/main_num_5.png"
}

function class.createRomanNum(number, resCfg, param)
  param = param or {}
  resCfg = resCfg or class.ROMAN_NUM_TO_RES
  local spacing = param.spacing or -2
  local romanNumList = {
    {10, "X"},
    {9, "IX"},
    {5, "V"},
    {4, "IV"},
    {1, "I"}
  }
  local container = ed.createSprite()
  container:setCascadeOpacityEnabled(true)
  container:setAnchorPoint(ccp(0.5, 0.5))
  local width = 0
  local height = 0
  local numList = {}
  for _, v in ipairs(romanNumList) do
    while number >= v[1] do
      number = number - v[1]
      for str in string.gmatch(v[2], "%w") do
        local resPath = resCfg[str]
        local imageNum = ed.createSprite(resPath)
        local size = imageNum:getContentSize()
        container:addChild(imageNum)
        table.insert(numList, {imageNum = imageNum, size = size})
        width = width + size.width
        height = math.max(height, size.height)
      end
    end
  end
  container:setContentSize(CCSizeMake(width, height))
  local posX = 0
  for _, cfg in ipairs(numList) do
    local imageNum = cfg.imageNum
    local size = cfg.size
    imageNum:setPosition(ccp(posX + size.width / 2, height / 2))
    posX = posX + size.width + spacing
  end
  return container
end

function class.showTransformEffect(luaScene, enterNewSceneCB)
  local curScene = ed.getCurrentScene()
  if curScene.getTopNode then
    local eff = ed.createFcaNode("eff_UI_transition_smoke")
    local container = curScene:getTopNode()
    eff:setActionSpeeder(1.5)
    container:addChild(eff)
    curScene:addFcaOnce(eff, true)
    ed.layout.centerInScreen(eff)
  end
  if luaScene then
    local transitionScene = ed.ui.TransitionScene.create(CCTransitionFade:create(0.5, luaScene:ccScene()), luaScene, {onEnterNewSceneCallBack = enterNewSceneCB})
    ed.pushScene(transitionScene)
  elseif enterNewSceneCB then
    enterNewSceneCB()
  end
end

function class.jumpToMapScene()
  local curScene = ed.getCurrentScene()
  if curScene.getTopNode then
    container = curScene:getTopNode()
  else
    container = curScene:ccScene()
  end
  local eff = ed.createFcaNode("eff_UI_transition_smoke")
  local container = curScene:getTopNode()
  eff:setActionSpeeder(1.5)
  container:addChild(eff)
  curScene:addFcaOnce(eff, true)
  ed.layout.centerInScreen(eff)
  eff:update(0)
  local layer = CCLayerColor:create(ccc4(0, 0, 0, 0))
  layer:setTouchEnabled(true)
  layer:registerScriptTouchHandler(doTouchLoad, false, -5000, true)
  container:addChild(layer, 600)
  local times = 0
  
  local function checkPreload()
    times = times + 1
    if ed.asyncload.isCompleted then
      layer:removeFromParentAndCleanup(true)
      curScene:resumeFca(eff)
      CloseTimer("checkBattleHeroPreload")
      local rogueMapScene = ed.ui.rogueMapScene.create({isEnterChapter = true})
      FireEvent("rogueEnterChapter")
      local transitionScene = ed.ui.TransitionScene.create(CCTransitionFade:create(0.5, rogueMapScene:ccScene()), rogueMapScene)
      ed.pushScene(transitionScene)
    elseif 10 == times then
      curScene:pauseFca(eff)
    end
  end
  
  ListenTimer(Timer:Always(0.01, "checkBattleHeroPreload"), function()
    checkPreload()
  end)
end

function class.showPetDetail(petId)
  local map = {
    1,
    4,
    7,
    12,
    12
  }
  local panel = ed.readequip.getDetailCard(petId, {
    level = 1,
    rank = map[ed.Pet.getColorByType(petId)],
    nameScale = 1,
    namePosY = 94,
    isUnit = true,
    hidelv = true
  })
  if panel.name then
    panel.name:setPositionY(panel:getContentSize().height - 31)
  end
  return panel
end

function class.saveLastBookId(bookId)
  local key = ed.getRoleKey("RogueLastBook")
  ed.storage.setValue(key, bookId)
end

function class.getLastBookId()
  local key = ed.getRoleKey("RogueLastBook")
  local bookId = ed.storage.getInt(key)
  return bookId or 0
end
