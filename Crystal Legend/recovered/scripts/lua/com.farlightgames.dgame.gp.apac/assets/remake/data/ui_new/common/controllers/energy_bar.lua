EnergyBar = {}
EnergyBar.__index = EnergyBar

function EnergyBar.Create(config)
  local obj = {}
  setmetatable(obj, EnergyBar)
  obj:Init(config)
  return obj
end

function EnergyBar:Init(config)
  self:InitData(config)
  self:InitUI()
end

function EnergyBar:InitData(config)
  self.pos = ccp(0, 0)
  self.maxEnergy = config.maxEnergy or 1
  self.currentEnergy = config.currentEnergy or 0
  self.limitEnergy = 0
  self.getLimitHandler = config.limitHandler
  self.getCurrentHandler = config.currentHandler
end

function EnergyBar:InitUI()
  local ui_res = EnergyBar.Res
  local container, ui = ed.editorui(ui_res)
  self.container, self.ui = container, ui
  self:CreateEnergyPgFca()
end

function EnergyBar:CreateEnergyPgFca()
  local ui = self.ui
  local energyPgFca = ed.createFcaNode("eff_UI_energybar_head")
  energyPgFca:setLoop(true)
  energyPgFca:setStartAction("Start_time")
  energyPgFca:setLoopAction("Start_time")
  local eContainer = ui.layer_energy_progress_container
  eContainer:addChild(energyPgFca)
  energyPgFca:setPositionY(14)
  self.energyPgFca = energyPgFca
end

function EnergyBar:CreateBGFca()
  local energyBgFca = ed.createFcaNode("eff_UI_energybar_body")
  energyBgFca:setLoop(true)
  energyBgFca:setStartAction("Start_HP_hero")
  energyBgFca:setLoopAction("Loop_HP_hero")
  local container = self.container
  container:addChild(energyBgFca, -1)
  energyBgFca:setPosition(ccp(440, 145))
  self.energyBgFca = energyBgFca
end

function EnergyBar:Update(dt)
  local ui = self.ui
  local pg = self.energyPgFca
  local current_energy = self:GetCurrentEnergy()
  local limit = self:GetLimitEnergy()
  local ratio = limit / self.maxEnergy
  local box = ui.img_energy_progress_bg:boundingBox()
  local x = box.origin.x + box.size.width * ratio
  ui.img_separator:setPositionX(x)
  ratio = current_energy / self.maxEnergy
  ui.img_energy_progress:setScaleX(ratio)
  local progressX = ui.img_energy_progress:getPositionX()
  local size = ui.img_energy_progress:getContentSize()
  x = progressX + size.width * ratio
  pg:setPositionX(x)
  pg:update(dt)
  local energyBgFca = self.energyBgFca
  if current_energy >= limit and not energyBgFca then
    self:CreateBGFca()
  elseif current_energy < limit and energyBgFca then
    self.energyBgFca = nil
    energyBgFca:removeFromParentAndCleanup(true)
  end
  if self.energyBgFca then
    self.energyBgFca:update(dt)
  end
  if self.getCurrentHandler then
    self.currentEnergy = self.getCurrentHandler()
  end
  if self.getLimitHandler then
    self.limitEnergy = self.getLimitHandler()
  end
end

function EnergyBar:GetLimitEnergy()
  return self.limitEnergy
end

function EnergyBar:SetLimitEnergy(energy)
  self.limitEnergy = energy
end

function EnergyBar:GetCurrentEnergy()
  return self.currentEnergy
end

function EnergyBar:SetCurrentEnergy(energy)
  self.currentEnergy = energy
end

function EnergyBar:setPosition(pos)
  self.pos = pos
  self.container:setPosition(pos)
end

function EnergyBar:getPosition()
  return self.pos
end

EnergyBar.Res = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.125, h = 33.59375},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/denfese/defense_crystal.png",
      name = "img_crystal",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(299.22, 145.31)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(263.28, 28.13)
    },
    t = "Layer",
    base = {
      name = "layer_energy_progress_container",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(306.25, 131.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(263.28, 28.13)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(5.47, 5.47, 45.31, 17.19),
      res = "UI/alpha/HVGA/denfese/defense_enegy_bg.png",
      name = "img_energy_progress_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(304.69, 128.91)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 7.8125, h = 21.09375},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/denfese/defense_energy_barrier.png",
      name = "img_separator",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(517.97, 145.31)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 248.4375, h = 11.71875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_energy_progress_container",
      res = "UI/alpha/HVGA/denfese/defense_energy_bar.png",
      name = "img_energy_progress",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(6.25, 7.81)
    }
  }
}
