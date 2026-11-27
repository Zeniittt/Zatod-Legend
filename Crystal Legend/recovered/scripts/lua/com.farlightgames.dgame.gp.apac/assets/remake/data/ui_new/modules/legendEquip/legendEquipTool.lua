local class = newclass("g")
ed.legendEquipTool = class
class.forge_item_unlock_cfg = {
  Item = {
    desc = function(forgeQueueCfg)
      local itemId = forgeQueueCfg["Unlock Param"]
      local name = ed.getEquipNameWithId(itemId)
      return string.format(T("\230\182\136\232\128\151<sprite src=UI/alpha/1080P/fireforge/art5.png>%sx1\239\188\140\232\167\163\233\148\129\232\175\165\230\160\143\228\189\141\239\188\140\230\152\175\229\144\166\232\167\163\233\148\129"), name)
    end,
    confirmHandler = function(forgeQueueCfg)
      local itemId = forgeQueueCfg["Unlock Param"]
      local amount = ed.player:getEquipAmount(itemId)
      if amount <= 0 then
        ed.showToast(T("\233\129\147\229\133\183\228\184\141\232\182\179"))
        ed.UITool.openView("packageDetail", {id = itemId})
      else
        ed.legendEquipNet.sendUnlockPos(forgeQueueCfg["Queue ID"], forgeQueueCfg["Field ID"], {
          costType = "item",
          costId = itemId,
          costAmount = 1
        })
      end
    end,
    costType = "item",
    costAmount = 1,
    costId = function(forgeQueueCfg)
      local itemId = forgeQueueCfg["Unlock Param"]
      return itemId
    end
  },
  Diamond = {
    desc = function(forgeQueueCfg)
      local cost = forgeQueueCfg["Unlock Param"]
      return string.format(T("\230\182\136\232\128\151<sprite src=UI/alpha/1080P/icon/diamond.png><lable color=ccc3(141,244,118)>%s</lable>\232\167\163\233\148\129\233\148\187\233\128\160\230\160\143\228\189\141\239\188\140\230\152\175\229\144\166\232\167\163\233\148\129"), cost)
    end,
    confirmHandler = function(forgeQueueCfg)
      local cost = forgeQueueCfg["Unlock Param"]
      local diamondAmount = ed.player:getDiamondAmount()
      if cost > diamondAmount then
        ed.showToast(T("\233\146\187\231\159\179\228\184\141\232\182\179"))
      else
        ed.legendEquipNet.sendUnlockPos(forgeQueueCfg["Queue ID"], forgeQueueCfg["Field ID"], {costType = "diamond", costAmount = cost})
      end
    end,
    costType = "diamond",
    costAmount = function(forgeQueueCfg)
      local cost = forgeQueueCfg["Unlock Param"]
      return cost
    end
  },
  ["Month Card"] = {
    desc = T("\229\188\128\233\128\154\232\182\133\229\128\188\230\156\136\229\141\161\229\143\175\232\167\163\233\148\129\233\148\187\233\128\160\230\160\143\228\189\141\239\188\140\230\152\175\229\144\166\229\137\141\229\190\128\229\149\134\229\159\142\232\180\173\228\185\176\232\182\133\229\128\188\230\156\136\229\141\161"),
    confirmHandler = function(forgeQueueCfg)
      ed.pushScene(ed.ui.RechargeScene.create({page = "MonthCard"}))
    end
  }
}

function class.getLegendEquipMaxInfo(legendEquip)
  local typeId = legendEquip._type_id
  local curStar = legendEquip._star
  local curRank = legendEquip._rank
  local legendEquipEnhanceCfg = ed.getDataTable("LegendEquipEnhance")[typeId]
  local basicStar = ed.getDataTable("LegendEquip")[typeId]["Basic Star"]
  local maxStar = 1
  local maxRank = 0
  for star = basicStar, 20 do
    if not legendEquipEnhanceCfg[star] then
      break
    end
    maxStar = star
  end
  for rank = 0, 20 do
    if not legendEquipEnhanceCfg[curStar][rank] then
      break
    end
    maxRank = rank
  end
  return maxStar, maxRank
end

function class.getLegendEquipUnlockInfo(legendEquip)
  local typeId = legendEquip._type_id
  local curStar = legendEquip._star
  local curRank = legendEquip._rank
  local skill_unlock_star, rune_1_unlock_star, rune_2_unlock_star, skill_id, rune_1_id, rune_2_id
  local basicStar = ed.getDataTable("LegendEquip")[typeId]["Basic Star"]
  local legendEquipEnhanceCfg = ed.getDataTable("LegendEquipEnhance")[typeId]
  for star = basicStar, 20 do
    if not legendEquipEnhanceCfg[star] then
      break
    end
    if 0 < legendEquipEnhanceCfg[star][0]["Skill ID 1"] and not skill_unlock_star then
      skill_unlock_star = star
      skill_id = legendEquipEnhanceCfg[star][0]["Skill ID 1"]
    end
    if 0 < legendEquipEnhanceCfg[star][0]["Skill ID 2"] and not rune_1_unlock_star then
      rune_1_unlock_star = star
      rune_1_id = legendEquipEnhanceCfg[star][0]["Skill ID 2"]
    end
    if 0 < legendEquipEnhanceCfg[star][0]["Skill ID 3"] and not rune_2_unlock_star then
      rune_2_unlock_star = star
      rune_2_id = legendEquipEnhanceCfg[star][0]["Skill ID 3"]
    end
  end
  return {
    skill_id = skill_id,
    rune_1_id = rune_1_id,
    rune_2_id = rune_2_id,
    skill_unlock_star = skill_unlock_star,
    rune_1_unlock_star = rune_1_unlock_star,
    rune_2_unlock_star = rune_2_unlock_star,
    skill_is_unlock = curStar >= skill_unlock_star,
    rune_1_is_unlock = curStar >= rune_1_unlock_star,
    rune_2_is_unlock = curStar >= rune_2_unlock_star
  }
end

function class.getLegendEquipAttrChange(legendEquip)
  local typeId = legendEquip._type_id
  local curStar = legendEquip._star
  local curRank = legendEquip._rank
  local legendEquipEnhanceTB = ed.getDataTable("LegendEquipEnhance")
  local enhanceCfg = legendEquipEnhanceTB[typeId][curStar][curRank]
  local nextEnhanceCfg
  if enhanceCfg["Is UpStar"] then
    nextEnhanceCfg = legendEquipEnhanceTB[typeId][curStar + 1][0]
  else
    nextEnhanceCfg = legendEquipEnhanceTB[typeId][curStar][curRank + 1]
  end
  if not nextEnhanceCfg then
    return {}, {}
  end
  local attrChange = {}
  for index = 1, 20 do
    local attrName = nextEnhanceCfg[string.format("Attr Type %s", index)]
    if not attrName then
      break
    end
    local oldValue = enhanceCfg[string.format("Attr Value %s", index)]
    local newValue = nextEnhanceCfg[string.format("Attr Value %s", index)]
    if oldValue < newValue then
      table.insert(attrChange, {
        attrName = attrName,
        oldValue = oldValue,
        newValue = newValue,
        changeValue = newValue - oldValue
      })
    end
  end
  local newSkill = {}
  for index = 1, 20 do
    local newSkillId = nextEnhanceCfg[string.format("Skill ID %s", index)]
    if not newSkillId or newSkillId == 0 then
      break
    end
    local oldSkillId = enhanceCfg[string.format("Skill ID %s", index)]
    if oldSkillId == 0 then
      table.insert(newSkill, newSkillId)
    end
  end
  return attrChange, newSkill
end

function class.showLegendEquipOnlyTips(referNode)
  local window = ed.ui.legendEquipOnlyTips.create()
  window:popWindow()
  if referNode then
    local referNodeSize = referNode:getContentSize()
    local bgSize = window.bg:getContentSize()
    ed.layout.relateLayout(referNode, window.bg, {
      bottom = referNodeSize.height / 2 + bgSize.height / 2 + 3
    })
  end
end

function class.createSuccessMask(parent)
  local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
  local labelBg = ed.createSprite("UI/alpha/1080P/fireforge/wishlist_finished.png")
  mask:addChild(labelBg)
  ed.layout.centerInParent(labelBg)
  local labelSuccess = ed.createLabelTTF(T("\229\183\178\232\190\190\230\136\144"), 13)
  ed.setLabelColor(labelSuccess, ed.toccc3(7470928))
  ed.setLabelStroke(labelSuccess, ed.toccc3(1651731), 1)
  labelBg:addChild(labelSuccess)
  ed.layout.centerInParent(labelSuccess)
  if parent then
    parent:addChild(mask)
    ed.layout.centerInParent(mask)
  end
  return mask
end

function class.createUnBindTimeMask(nextUnequipTime)
  local bg = ed.createSprite("UI/alpha/1080P/legendequip/left_time_bg.png")
  local icon = ed.createSprite("UI/alpha/1080P/lottery/lottery_time_newyear.png")
  bg:addChild(icon)
  icon:setScale(0.7)
  icon:setPosition(ccp(8, 9.5))
  local serverTime = ed.getServerTime()
  local leftTime = nextUnequipTime - serverTime
  local day = math.floor(leftTime / 86400)
  local hour = math.floor(leftTime % 86400 / 3600)
  local min = math.floor(leftTime % 3600 / 60)
  local label
  if 0 < day then
    label = ed.createLabelTTF(string.format("%s\229\164\169%s\230\151\182", day, hour), 12)
  else
    label = ed.createLabelTTF(string.format("%s\230\151\182%s\229\136\134", hour, min), 12)
  end
  bg:addChild(label)
  label:setPosition(ccp(40, 9.5))
  ed.setLabelColor(label, ed.toccc3(16735324))
  ed.setLabelStroke(label, ed.toccc3(1510926), 1)
  return bg
end

function class.getLegendEquipSkillDesc(skillId, param)
  local t = ed.getDataTable("LegendEquipSkill")[skillId]
  local autoText = ed.ui.autoText.new()
  param = param or {}
  local desc = t["Skill Dec"]
  local str = string.gsub(desc, "%%Skill&(.-)%%", function(replaceStr)
    if t and t[replaceStr] then
      local value = 0
      if type(t[replaceStr]) == "number" then
        value = math.abs(t[replaceStr])
      end
      return value
    end
    return ""
  end)
  str = string.gsub(str, "<#(%d+)#(.-)#>", function(id, name)
    id = tonumber(id)
    local value = string.format("<lable color=ccc3(255,251,231) clickhandler=%s data=%d>%s</lable>", "clickLink", id, name or "")
    return value
  end)
  str = string.gsub(str, "#p#", "%%")
  str = string.gsub(str, "%%Skill&.-%%", "%%s")
  str = string.gsub(str, "%%Buff&.-%%", "%%s")
  str = string.gsub(str, "%%%%", "#p#")
  param.context = str
  autoText:initParam(param)
  return autoText
end

function class.getTypeIdByFragmentId(itemId)
  if not class.fragmentIdToTypeId then
    class.fragmentIdToTypeId = {}
    for typeId, legendEquipCfg in ipairs(ed.getDataTable("LegendEquip")) do
      local fragmentId = legendEquipCfg["Fragment Item"]
      class.fragmentIdToTypeId[fragmentId] = typeId
    end
  end
  return class.fragmentIdToTypeId[itemId]
end

function class.getIsShowLegendEquipShopNew()
  local timeStamp = ed.storage.getInt(ed.getRoleKey("legendShopNextRefreshTime")) or 0
  return timeStamp <= ed.getServerTime()
end
