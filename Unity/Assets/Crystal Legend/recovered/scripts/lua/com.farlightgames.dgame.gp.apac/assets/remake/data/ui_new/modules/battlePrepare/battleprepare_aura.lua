module("ed", package.seeall)
local time_move = 0.4
local time_fade_out = 0.3
local hint_interval = 1.4

local function AuraCompare(a, b)
  if a.order <= b.order then
    return true
  else
    return false
  end
end

AuraHint = {}
AuraHint.__index = AuraHint

function AuraHint.create(hero_list, awake_flags)
  local aura_hint = {}
  aura_hint.what = "AuraHint"
  setmetatable(aura_hint, AuraHint)
  hero_list = hero_list or {}
  awake_flags = awake_flags or {}
  aura_hint:InitAura(hero_list, awake_flags)
  local seq_mgr = Sequence.SequenceMgr.Current()
  if seq_mgr == nil then
    seq_mgr = Sequence.SequenceMgr.Create()
    Sequence.SequenceMgr.SetCurrent(seq_mgr)
  end
  aura_hint.seq_mgr = seq_mgr
  aura_hint.sequence = Sequence.Sequence.Create(tostring(aura_hint), seq_mgr)
  return aura_hint
end

function AuraHint:destroy()
  self:Reset()
end

function AuraHint:InitAura(init_hero_list, init_awake_flags)
  self.aura_list = {}
  local tags = getDataTable("Tags")
  for order, hid in ipairs(init_hero_list) do
    local awake_flag = init_awake_flags[order]
    if awake_flag == nil then
      awake_flag = false
    end
    local aura_skill_list = {}
    local skill_groups_of_hero = getDataTable("SkillGroup")[hid]
    for slot, skill_group in pairs(skill_groups_of_hero) do
      local skill = lookupDataTable("Skill", nil, skill_group["Skill Group ID"], 0)
      local active_type = skill["Active Type"]
      if active_type == "aura" and skill_group.Awake and awake_flag then
        table.insert(aura_skill_list, skill)
      end
    end
    for _, skill in ipairs(aura_skill_list) do
      local affect_tag = skill["Aura Affect Hero Tag"]
      if affect_tag ~= nil and tags[affect_tag] ~= nil then
        local aura = {}
        aura.order = order
        aura.hero_id = hid
        aura.name = skill["Skill Name"]
        aura.icon_res = tags[affect_tag].Sign
        aura.hero_tag = affect_tag
        table.insert(self.aura_list, aura)
      end
    end
  end
  self:ReorderAuraList()
end

function AuraHint:CheckAuraImpact(hid, aura)
  local unit = getDataTable("Unit")[hid]
  local tags = unit["Hero Tags"]
  local hero = ed.player.heroes[hid]
  if hero then
    tags = ed.getHeroTags(hero)
  end
  if aura.hero_tag and isElementInTable(aura.hero_tag, tags) then
    return true
  end
  return false
end

function AuraHint:CheckAuraImpactAll(hid)
  local result = false
  for i, aura in ipairs(self.aura_list) do
    result = result or self:CheckAuraImpact(hid, aura)
  end
  return result
end

function AuraHint:ReorderAuraList()
  table.sort(self.aura_list, AuraCompare)
end

function AuraHint:AddAura(hid, order, awake_flag)
  awake_flag = false
  local flag = false
  local tags = getDataTable("Tags")
  for i, aura in ipairs(self.aura_list) do
    if order <= aura.order and aura.hid ~= hid then
      aura.order = aura.order + 1
    end
  end
  local aura_skill_list = {}
  local skill_groups_of_hero = getDataTable("SkillGroup")[hid]
  for slot, skill_group in pairs(skill_groups_of_hero) do
    local skill = lookupDataTable("Skill", nil, skill_group["Skill Group ID"], 0)
    local active_type = skill["Active Type"]
    if active_type == "aura" and skill_group.Awake and awake_flag then
      table.insert(aura_skill_list, skill)
    end
  end
  for _, skill_info in ipairs(aura_skill_list) do
    local affect_tag = skill_info["Aura Affect Hero Tag"]
    if affect_tag ~= nil and tags[affect_tag] ~= nil then
      local aura = {}
      aura.order = order
      aura.hero_id = hid
      aura.name = skill_info["Skill Name"]
      aura.icon_res = tags[affect_tag].Sign
      aura.hero_tag = affect_tag
      table.insert(self.aura_list, aura)
      flag = true
    end
  end
  self:ReorderAuraList()
  return flag
end

function AuraHint:RemoveAura(hid)
  local remove_idx_list = {}
  for i, aura in ipairs(self.aura_list) do
    if aura.hero_id == hid then
      table.insert(remove_idx_list, i)
    end
  end
  for _, idx in ipairs(remove_idx_list) do
    table.remove(self.aura_list, idx)
  end
  self:ReorderAuraList()
end

function AuraHint:AddMemberHint(team_member)
  if team_member == nil then
    EDLog("AuraHint:AddMemberHint team_member is nil!")
    return
  end
  local hint_node = team_member.icon.icon
  local hid = team_member.heroIcon.info.id
  self:AddMemberHintWithNodeAndId(hint_node, hid)
end

function AuraHint:AddMemberHintWithNodeAndId(hint_node, hid)
  local clip_args_set = {}
  local target_aura
  for i, aura in ipairs(self.aura_list) do
    if hid ~= aura.hero_id and self:CheckAuraImpact(hid, aura) then
      local clip_args = aura.icon_res
      table.insert(clip_args_set, clip_args)
    end
  end
  for _, clip_args in ipairs(clip_args_set) do
    self.sequence:AddClip("ShowAuraHint", hint_node, clip_args):AddClip("wait", hint_interval)
  end
end

function AuraHint:AddTeamHint(team)
  if team == nil then
    EDLog("AuraHint:AddTeamHint team is nil!")
    return
  end
  local clip_args_set = {}
  for i, aura in ipairs(self.aura_list) do
    local clip_args = {}
    for j, member_data in ipairs(team) do
      local hint_node = member_data.icon.icon
      local hid = member_data.heroIcon.info.id
      if self:CheckAuraImpact(hid, aura) then
        local element = {
          "ShowAuraHint",
          hint_node,
          aura.icon_res
        }
        table.insert(clip_args, element)
      end
    end
    table.insert(clip_args_set, clip_args)
  end
  for _, clip_args in ipairs(clip_args_set) do
    if next(clip_args) ~= nil then
      self.sequence:AddClip("group", clip_args):AddClip("wait", hint_interval)
    end
  end
end

function AuraHint:AddTeamHintByHero(team, target_hid)
  if team == nil then
    EDLog("AuraHint:AddTeamHintByHero team is nil!")
    return
  end
  local nodeAndIdTeam = {}
  for j, member_data in ipairs(team) do
    local hid = member_data.heroIcon.info.id
    local node = member_data.icon.icon
    local member = {id = hid, node = node}
    table.insert(nodeAndIdTeam, member)
  end
  self:AddTeamHintWithNodeAndIdByHero(nodeAndIdTeam, target_hid)
end

function AuraHint:AddTeamHintWithNodeAndIdByHero(nodeAndIdTeam, target_hid)
  local clip_args_set = {}
  for i, aura in ipairs(self.aura_list) do
    local clip_args = {}
    for j, member in ipairs(nodeAndIdTeam) do
      local hid = member.id
      if aura.hero_id == target_hid and self:CheckAuraImpact(hid, aura) then
        local hint_node = member.node
        local element = {
          "ShowAuraHint",
          hint_node,
          aura.icon_res
        }
        table.insert(clip_args, element)
      end
    end
    table.insert(clip_args_set, clip_args)
  end
  for _, clip_args in ipairs(clip_args_set) do
    if next(clip_args) ~= nil then
      self.sequence:AddClip("group", clip_args):AddClip("wait", hint_interval)
    end
  end
end

function AuraHint:Play()
  self.sequence:Play()
end

function AuraHint:Reset()
  self.sequence:Reset()
end

SequenceClip("ShowAuraHint")

function OnCreate(data, hint_node, icon_res)
  data.icon_res = icon_res
  data.node = hint_node
end

function OnEnter(data)
  if tolua.isnull(data.node) then
    return
  end
  local aura_icon = ed.createSprite(data.icon_res)
  data.node:addChild(aura_icon, 1000)
  local center = ed.getCenterPos(data.node)
  aura_icon:setPosition(center)
  center.y = center.y + 30
  aura_icon:stopAllActions()
  local move_1 = CCMoveTo:create(time_move, center)
  local fadeout = CCFadeOut:create(time_fade_out)
  center.y = center.y + 5
  local move_2 = CCMoveTo:create(time_fade_out, center)
  local spawn = CCSpawn:createWithTwoActions(move_2, fadeout)
  local sequence = CCSequence:createWithTwoActions(move_1, spawn)
  aura_icon:runAction(sequence)
  ed.playEffect(ed.sound.prepare.buffAdd)
  data.aura_icon = aura_icon
end

function OnUnblock(data, delta)
  local count = 0
  if data.aura_icon and not tolua.isnull(data.aura_icon) then
    count = data.aura_icon:numberOfRunningActions()
  end
  if count == 0 then
    return false
  end
  return true
end

function OnLeave(data)
  if data.aura_icon and not tolua.isnull(data.aura_icon) then
    data.aura_icon:removeFromParentAndCleanup(true)
    data.aura_icon = nil
  end
end
