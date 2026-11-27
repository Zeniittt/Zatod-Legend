local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.ui.announce.base
setmetatable(class, base.mt)
ed.ui.announce.heroUpgrade = class
local resFactor = ed.display.resFactor

local function getHero(self)
  return ed.player.heroes[self.hid]
end

class.getHero = getHero

local function getHeroRank(self)
  return self:getHero()._rank
end

class.getHeroRank = getHeroRank

local function unlockSkill(self)
  local skills = ed.getSkillExpBase(self.hid)
  for i = 1, #skills do
    local row = skills[i]
    local rank = row.Unlock
    if self:getHeroRank() == rank then
      return {
        slotid = row.Slot,
        sgid = row["Skill Group ID"]
      }
    end
  end
  return nil
end

class.unlockSkill = unlockSkill

local function getSkillInfo(self, slot, sgid)
  local skill_frame = {
    "UI/alpha/HVGA/equip_frame_white.png",
    "UI/alpha/HVGA/equip_frame_green.png",
    "UI/alpha/HVGA/equip_frame_blue.png",
    "UI/alpha/HVGA/equip_frame_purple.png",
    "UI/alpha/HVGA/equip_frame_red.png"
  }
  local sgTable = ed.getDataTable("SkillGroup")
  local sTable = ed.getDataTable("Skill")
  local sgRow = sgTable[self.hid][slot]
  local hid = self.hid
  return {
    frame = skill_frame[slot],
    name = sgRow["Display Name"],
    iconres = sgRow.Icon,
    desc = sTable[sgid][0].Description
  }
end

class.getSkillInfo = getSkillInfo

local function getInformation(self, hero)
  local rank = hero._rank
  local unit = ed.UnitCreate(hero)
  local gs = hero._gs
  local hp = math.floor(unit.attribs.HP)
  return rank, unit, gs, hp
end

class.getInformation = getInformation

local function create(param)
  local self = base.create("heroUpgrade")
  setmetatable(self, class.mt)
  local container = self.container
  local handler = param.handler
  self:setClickDestroyEnabled(true)
  self:setDestroyHandler(handler)
  local hid = param.id
  self.hid = hid
  local preHero = param.preHero
  local preRank, preUnit, pregs, prehp, prehpAdded, pregsAdded = preHero.rank, preHero.unit, preHero.gs, preHero.hp, preHero.hpAdded or 0, preHero.gsAdded or 0
  local preIcon = ed.readhero.createIcon({
    id = hid,
    rank = preRank,
    fashion_id = param.fashion_id
  }).icon
  local hero = self:getHero()
  local rank, unit, gs, hp, fashion_id = self:getInformation(hero)
  local icon = ed.readhero.createIcon({
    id = hid,
    rank = rank,
    fashion_id = fashion_id
  }).icon
  local skill = self:unlockSkill()
  local ui = {}
  self.ui = ui
  local container = self.container
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.upgradeAnnounce)
  ui.pre_icon = preIcon
  ui.icon = icon
  local width = 450
  local height = 0
  if skill then
    local info = self:getSkillInfo(skill.slotid, skill.sgid)
    local len = ed.stringutil.len(info.desc)
    if 42 < len then
      info.desc = ed.stringutil.sub(info.desc, 1, resource_config.heroupgrade_announce_skilldesc_len or 39) .. "..."
    end
    ui.bg:setVisible(false)
    ui.bg1:setVisible(true)
    local iconSkill = ed.readhero.createSkillIcon(self.hid, skill.slotid, hero)
    local x, y = ui.icon_skill:getPosition()
    iconSkill:setPosition(ccp(x, y))
    iconSkill:setScale(0.9)
    ui.icon_skill:setVisible(false)
    ui.bg1:addChild(iconSkill)
    ed.setString(ui.name_skill, string.format(T("\232\167\163\233\148\129\230\150\176\230\138\128\232\131\189  %s!"), info.name))
  end
  ed.setString(ui.from1, prehp)
  ed.setString(ui.to1, hp)
  ed.setString(ui.from2, pregs)
  ed.setString(ui.to2, gs)
  local x, y = ui.icon1:getPosition()
  preIcon:setPosition(ccp(x, y))
  x, y = ui.icon2:getPosition()
  icon:setPosition(ccp(x, y))
  ui.bg_heroicon:addChild(preIcon)
  ui.bg_heroicon:addChild(icon)
  local x, y = ui.light:getPosition()
  local light1 = ed.createFcaNode("eff_UI_pvp_newrecord_light")
  light1:setPosition(ccp(x, y))
  ui.layer_main:addChild(light1)
  ed.getCurrentScene():addFca(light1)
  local light2 = ed.createFcaNode("eff_UI_pvp_newrecord_particles")
  light2:setPosition(ccp(x, y))
  ui.layer_main:addChild(light2, 3)
  ed.getCurrentScene():addFca(light2)
  self:show(self:titleAnimHandler())
  return self
end

class.create = create

local function titleAnimHandler(self)
  local function handler()
    local ui = self.ui
    
    local title = ui.title
    title:setVisible(true)
    title:setScale(2.2)
    title:runAction(CCEaseBackOut:create(CCScaleTo:create(0.2, 1.5)))
  end
  
  return handler
end

class.titleAnimHandler = titleAnimHandler
