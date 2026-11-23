local HeroHint = {}
HeroHint.__index = HeroHint
ed.heroHint = HeroHint
HeroHint.config = {
  hintBgRes = "UI/alpha/HVGA/offlinetask/offlinetask_herotalk_bg.png",
  stencil = "UI/alpha/HVGA/offlinetask/offlinetask_herotalk_bg_1.png",
  texPos = {
    {
      ccp(58, 68)
    },
    {
      ccp(58, 76),
      ccp(58, 60)
    },
    {
      ccp(58, 84),
      ccp(58, 68),
      ccp(58, 52)
    }
  }
}

function ed.createHeroHint(heroid, hintStr)
  if not heroid or not hintStr then
    return nil
  end
  local heroHintBg = ed.createSprite(HeroHint.config.hintBgRes)
  local label = ed.createLabelTTF(hintStr, 14)
  label:setDimensions(CCSizeMake(125, 0))
  label:setHorizontalAlignment(kCCTextAlignmentLeft)
  label:setPosition(ccp(58, 75))
  label:setAnchorPoint(ccp(0, 0.5))
  heroHintBg:addChild(label)
  ed.setLabelColor(label, ccc3(67, 59, 56))
  ed.setLabelShadow(label, ccc3(255, 255, 255), ccp(1, 2))
  local portrait = HeroHint.getHeroPortrait(heroid)
  heroHintBg:addChild(portrait)
  return heroHintBg
end

local ssize = CCSizeMake(75, 82)
local scale = 0.14285714285714285

function HeroHint.getHeroPortrait(heroid)
  local portraitRes = ed.getUnitIconName(heroid)
  local portrait, icon = ed.createClippingNode(portraitRes, HeroHint.config.stencil, nil, CCSizeMake(-20, -20))
  portrait:setPosition(ccp(39, 72))
  icon:setScaleX(scale)
  icon:setScaleY(scale)
  icon:setPosition(ccp(-13, -1))
  local ow = ssize.width
  local oh = ssize.height
  local stencil = portrait:getStencil()
  local ss = stencil:getContentSize()
  stencil:setScaleX((ow - 4) / ss.width)
  stencil:setScaleY((oh - 4) / ss.height)
  return portrait
end

function HeroHint.getIncisionStr(hintStr)
  local strs = {}
  local strLen = #hintStr
  if 24 < strLen then
    local firstStr = string.sub(hintStr, 1, 24)
    strs[1] = firstStr
    if 48 < strLen then
      local secondStr = string.sub(hintStr, 25, 48)
      strs[2] = secondStr
      local threeStr = string.sub(hintStr, 49, strLen)
      strs[3] = threeStr
    else
      local secondStr = string.sub(hintStr, 25, strLen)
      strs[2] = secondStr
    end
  else
    strs[1] = hintStr
  end
  return strs
end
