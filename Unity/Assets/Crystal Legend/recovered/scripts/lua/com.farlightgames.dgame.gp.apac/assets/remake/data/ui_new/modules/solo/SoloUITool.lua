module("ed.ui", package.seeall)
SoloUITool = {}
SoloUITool.__index = SoloUITool

function SoloUITool.getSkillAutoText(id, level, inShop)
  local skill = ed.getDataTable("SoloCardSkill")[id]
  local str = skill.Description or ""
  local tmpStr = str
  local args = {}
  
  local function insertTrueValue(paramName)
    local alevel = level
    if inShop then
      alevel = alevel + 1
    end
    if skill[paramName][alevel] then
      local value = skill[paramName][alevel]
      if not value then
        error("error card:" .. id .. "  level:" .. alevel .. "inShop" .. tostring(inShop))
      end
      table.insert(args, skill[paramName][alevel])
    else
      table.insert(args, "0")
    end
    if inShop and 0 < level then
      local value = skill[paramName][alevel]
      if not value then
        error("error card:" .. id .. "  level:" .. alevel .. "inShop" .. tostring(inShop))
      end
      table.insert(args, skill[paramName][level])
    end
  end
  
  while true do
    local pos1, pos2 = string.find(tmpStr, "%%CardSkill&.-%%")
    if pos1 == nil then
      break
    else
      local paramName = string.sub(tmpStr, pos1 + 11, pos2 - 1)
      insertTrueValue(paramName)
      tmpStr = string.sub(tmpStr, pos2 + 1)
    end
  end
  if inShop and 0 < level then
    str = string.gsub(str, "%%CardSkill&.-%%", "<lable color=headlineYellow>%%s</lable>(%%s)")
  else
    str = string.gsub(str, "%%CardSkill&.-%%", "<lable color=headlineYellow>%%s</lable>")
  end
  if 0 < #args then
    str = string.format(str, unpack(args))
  end
  str = string.gsub(str, "#p#", "%%")
  return str
end

function SoloUITool.createCardItem(id, level, inShop, gold)
  local tbData = ed.getDataTable("SoloCardSkill")[id]
  local quality = tbData.Quality
  local uieditorConfig = {
    "SoloCard1Item",
    "SoloCard2Item",
    "SoloCard3Item"
  }
  local container, ui = ed.editorui(ed.uieditor[uieditorConfig[quality]])
  local clipNode = ed.createClippingNodeOnly("UI/alpha/1080P/chesscard/skill/mask.png")
  local icon = ed.createSprite(tbData["Card Icon"])
  clipNode:addChild(icon)
  clipNode:setScale(0.94)
  ed.UITool.replaceUINew(ui, "icon", clipNode)
  icon:setScale(1.2)
  if not inShop and quality == 3 then
    local fca1 = ed.createSpine("effect/eff_UI_solo_card_rank3/eff_UI_solo_card_rank3", 0.5)
    ui.bg:addChild(fca1, -1)
    ed.layout.centerInParent(fca1)
    fca1:setAnimation(0, "Loop", true)
    local goldStar = ed.createSpine("effect/eff_UI_solo_card_rank3_star/eff_UI_solo_card_rank3_star", 0.5)
    ui.bg:addChild(goldStar, 2)
    ed.layout.centerInParent(goldStar)
    goldStar:setAnimation(0, "Loop", true)
  end
  local StartColorConfig = {
    ed.toccc3(16762488),
    ed.toccc3(11663871),
    ed.toccc3(16775555)
  }
  local EndColorConfig = {
    ed.toccc3(16768968),
    ed.toccc3(14347263),
    ed.toccc3(16773581)
  }
  local StrokeColorConfig = {
    ed.toccc3(4270104),
    ed.toccc3(3159613),
    ed.toccc3(5454592)
  }
  local label = ed.ui.gradientLabel.create({
    text = tbData.Name,
    fontName = ed.fontBold,
    fontSize = 22,
    startColor = StartColorConfig[quality],
    endColor = EndColorConfig[quality],
    strokeColor = StrokeColorConfig[quality],
    strokeSize = 1.5
  })
  ed.UITool.replaceUINew(ui, "name", label.node)
  ed.setLabelStroke(ui.label_gold, ed.toccc3(263172), 1.5)
  for i = 1, 2 do
    if tbData["Tag" .. i] and tbData["Tag" .. i] ~= 0 then
      local factionId = tbData["Tag" .. i]
      local factionRes = ed.getDataTable("SoloCardTag")[factionId]["Tag2 Icon"]
      local sprite = ed.createSprite(factionRes)
      sprite:setScale(1.25)
      ed.UITool.replaceUINew(ui, "faction" .. i, sprite)
      ui["bg_faction" .. i]:setVisible(true)
    end
  end
  local maxLevel = tbData["Max Level"]
  if maxLevel == level then
    inShop = false
  end
  local x = 84 - maxLevel * 28 / 2
  if level + 1 == maxLevel and inShop then
    quality = 3
  elseif level == maxLevel then
    quality = 3
  end
  for i = 1, maxLevel do
    local starbg = ed.createSpriteTools({
      res = "UI/alpha/1080P/chesscard/skill/star_0" .. quality .. ".png",
      pos = ccp(x + i * 28, 23),
      parent = ui.bg
    })
    if i <= level + 1 then
      local star = ed.createSpriteTools({
        res = "UI/alpha/1080P/chesscard/skill/star_0" .. quality .. "_1.png",
        pos = ccp(12, 15),
        parent = starbg
      })
      if i == level + 1 and inShop then
        ed.playBlinkAction(star, 0.8)
      elseif i == level + 1 and not inShop then
        star:setVisible(false)
      else
        star:setVisible(true)
      end
    end
  end
  if inShop then
    local price = gold or tbData.Quality * 100
    ed.setString(ui.label_gold, price)
    if price > ed.SoloModel:getTotalGold() then
      ui.label_gold:setColor(ccc3(255, 0, 0))
    else
      ui.label_gold:setColor(ccc3(255, 234, 197))
    end
  else
    ui.bg_gold:setVisible(false)
  end
  local autoStr = ed.ui.SoloUITool.getSkillAutoText(id, level, inShop)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = autoStr,
    fontSize = 14.5,
    maxWidth = 120,
    strokeColor = ed.toccc3(2693915),
    strokeSize = 1,
    lineSpacing = 0,
    color = ccc3(255, 234, 197)
  })
  ed.UITool.replaceUINew(ui, "label_desc", autoText.node)
  return container, ui
end
