module("ed.battlehero", package.seeall)
local ed = ed
godHand = {}
godHand.useCd = 5
godHand.thunderIcon = "UI/alpha/HVGA/battle_special/field_thunder.png"
godHand.pointEffect = "eff_impact_Zeus_ult.cha"

function godHand.useThunder(skill)
  skill.remainUseLimit = skill.remainUseLimit and skill.remainUseLimit - 1 or 0
  if ed.run_with_scene and skill.remainUseLimit and skill.thunderIconList then
    local useThunderIndex = skill.remainUseLimit + 1
    local icon = skill.thunderIconList[useThunderIndex]
    if icon then
      icon:setScale(1)
      icon:setOpacity(255)
      local fadeOut = CCFadeOut:create(0.3)
      local scale = CCScaleTo:create(0.4, 1.5)
      local spawn = CCSpawn:create(ccArrayMake(scale, fadeOut))
      icon:runAction(spawn)
    end
  end
end

function godHand.addThunder(skill)
  skill.remainUseLimit = skill.remainUseLimit and skill.remainUseLimit + 1 or 1
  if ed.run_with_scene and skill.remainUseLimit and skill.thunderIconList then
    local addThunderIndex = skill.remainUseLimit
    local icon = skill.thunderIconList[addThunderIndex]
    if icon then
      icon:setScale(1)
      icon:setOpacity(255)
      local action = CCSequence:create(ccArrayMake(CCScaleTo:create(0.2, 1.4), CCScaleTo:create(0.2, 1)))
      icon:runAction(action)
    end
  end
end

function godHand.takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  local originInfo = skill.info
  skill.info = ed.wraptable(originInfo, {
    ["Basic Num"] = 2333
  })
  if ed.run_with_scene then
    local effect_name = godHand.pointEffect
    local deltaX = 0
    local pos = {
      location[1] + deltaX,
      location[2]
    }
    local effect = ed.scene:playEffectOnScene(effect_name, pos, {1, 1}, nil, 0)
  end
  basefunc(skill, location, source)
  godHand.useThunder(skill)
  skill.info = originInfo
end

function godHand.skill_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  if not skill.alreadyIni then
    skill.alreadyIni = true
    skill.useLimitCd = godHand.useCd
    skill.remainUseLimit = 5
    skill.thunderIconList = {}
    if ed.run_with_scene then
      local origin = CCDirector:sharedDirector():getVisibleOrigin()
      local ox, oy = origin.x, -origin.y * 0.25
      local header_y = 440 + oy
      local thunderMarker = ed.createScale9Sprite("UI/alpha/HVGA/battle_number_bg.png")
      ed.sceneui.goldmarker = thunderMarker
      ed.sceneui.ui_layer:addChild(thunderMarker)
      thunderMarker:setAnchorPoint(ccp(1, 0.5))
      thunderMarker:setPosition(ccp(777 - ox, header_y))
      thunderMarker:setContentSize(CCSizeMake(191, 44))
      local dx = 36
      local x1 = 8
      for i = 1, 5 do
        local icon = ed.createSprite(godHand.thunderIcon)
        icon:setAnchorPoint(ccp(1, 0.5))
        local size = thunderMarker:getContentSize()
        icon:setPosition(size.width - dx * (i - 1) - x1, size.height * 0.5)
        thunderMarker:addChild(icon)
        skill.thunderIconList[i] = icon
      end
    end
  end
  if skill.remainUseLimit < godHand.useCd then
    skill.useLimitCd = skill.useLimitCd - dt_action
    if skill.useLimitCd <= 0 then
      skill.useLimitCd = godHand.useCd
      godHand.addThunder(skill)
    end
  end
end

function godHand.init_fieldSkill(skill)
  skill.update = override(skill.update, godHand.skill_update)
  skill.takeEffectAt = override(skill.takeEffectAt, godHand.takeEffectAt)
  return skill
end

return godHand.init_fieldSkill
