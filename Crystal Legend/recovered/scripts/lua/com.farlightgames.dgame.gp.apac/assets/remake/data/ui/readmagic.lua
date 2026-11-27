local magic = newclass("g")
ed.readmagic = magic

local function getMagicIcon(param)
  local param = param or {}
  local id = param.id
  local res
  if id then
    local row = ed.getDataTable("MultiArenaMagic")[id]
    if row then
      res = row.Icon
    end
  else
    res = param.res
  end
  local card, ci = ed.createClippingNode(res, "UI/alpha/1080P/common/equip_stencil.png", nil, CCSizeMake(-10, -10))
  local size = ci:getContentSize()
  local len = size.width
  return card, ci
end

ed.getMagicIcon = getMagicIcon

local function addMagicName(length, name)
  local frameRes = "UI/alpha/1080P/common/main_vit_tips.png"
  local frameCapInsets = CCRectMake(10, 10, 58, 26)
  local name_bg = ed.createNode({
    t = "Scale9Sprite",
    base = {res = frameRes, capInsets = frameCapInsets}
  })
  name_bg:setContentSize(CCSizeMake(80, 30))
  local str = name
  local label = ed.createLabelWithFontInfo(str, "magic_white1")
  label:setPosition(ccp(40, 18))
  name_bg:addChild(label)
  name_bg:setPosition(ccp(length / 2, length + 10))
  return name_bg
end

function magic.createMagicIcon(param)
  local obj = {}
  setmetatable(obj, magic.mt)
  local param = param or {}
  local id = param.id
  if not id then
    print("magic id is nil !!! ")
    return
  end
  local length = param.length or 80
  local addName = param.addName
  local row = ed.getDataTable("MultiArenaMagic")[id]
  if not row then
    print("magic id ", id, "can not find in table")
    return nil
  end
  local icon = ed.createSprite("UI/alpha/HVGA/multiarena/multiarena_magic_bed.png")
  local size = icon:getContentSize()
  local card, ci = ed.getMagicIcon(param)
  local center = ed.getCenterPos(icon)
  card:setPosition(ccpAdd(center, ccp(0, 2)))
  local cs = ci:getContentSize()
  card:setScale(size.width / cs.width)
  icon:addChild(card)
  if addName then
    local nameNode = addMagicName(length, row["Display Name"])
    icon:addChild(nameNode)
  end
  obj.icon = icon
  obj.ci = ci
  obj:addForbiddenInfo(param.forbidden)
  icon:setScale(length / size.width)
  return obj
end

ed.createMagicIcon = magic.createMagicIcon

function magic:addForbiddenInfo(forbidden)
  local icon = self.ci
  local node = self.icon
  if not icon or not forbidden then
    return
  end
  local forbiddenNode = CCNode:create()
  local forbidden = ed.createSprite("UI/alpha/1080P/common/pvp_text_unavailable.png")
  forbidden:setPosition(44, 70)
  forbiddenNode:addChild(forbidden, 10)
  local shade = CCLayerColor:create(ccc4(0, 0, 0, 150))
  shade:setContentSize(node:getContentSize())
  forbiddenNode:addChild(shade)
  node:addChild(forbiddenNode)
  self.forbiddenNode = forbiddenNode
end
