local base = ed.ui.basescene
local presetScene = newclass(base.mt)
local DATA = ed.presetData
local MODULE = ed.presetModule
local Network = ed.presetNetwork
ed.presetScene = presetScene
ed.UITool.registViewOpenFunc("presetScene", function(param)
  ed.pushScene(presetScene.create(param))
end)

function presetScene.create(param)
  return setmetatable(base.create("presetScene"), presetScene.mt):init(param)
end

function presetScene:init(param)
  self.param = param
  self.frameContainer, self.ui = MODULE.editorui(self)
  self.canClick = true
  self:setBackButton(function()
    ed.playEffect(ed.sound.common.back)
    if self.editbox.edit and self.editbox.edit.unregisterScriptEditBoxHandler then
      self.editbox.edit:unregisterScriptEditBoxHandler()
    end
  end)
  self:moduleInitCreate()
  self:registerTouchHandler()
  self:initLegendEquip()
  self:listenEvent("scene_preset_reply", function(info)
    self:refreshPresetScene(info)
  end)
  return self
end

function presetScene:moduleInitCreate()
  local param = self.param
  self.heroCategoryInfo, self.idToIndex = DATA:InitHeroListData()
  self.newTeamIdx = 1
  self.categoryIdx = 1
  self.groupId = param.groupId or 1
  self.teamIdx = param.teamIdx or 1
  self.notAdd = param.notAdd
  self.oldId = DATA.packPreseIds(self.teamIdx, self.groupId)
  self.teamIdxInfo, self.preseInfo = DATA.getPreseTeamInfo(self.groupId, self.teamIdx)
  self.teamName = self.preseInfo.name or T("\230\150\176\233\162\132\232\174\190") .. self.teamIdx
  self.teamNameModule = MODULE.teamName:init(self, {
    info = {
      teamName = self.teamName
    },
    callbackOver = function(info)
      if self.teamName ~= info.teamName then
        self.teamName = info.teamName
        self.settingName = true
      end
    end
  })
  self.btnsDragList = MODULE.sategoryBtns:init(self, {
    index = self.categoryIdx,
    info = {
      btnStr = {
        {
          "all",
          T("\229\133\168\233\131\168")
        },
        {
          "front",
          T("\229\137\141\230\142\146")
        },
        {
          "middle",
          T("\228\184\173\230\142\146")
        },
        {
          "back",
          T("\229\144\142\230\142\146")
        }
      }
    },
    callbackOver = function(categoryIdx)
      self.categoryIdx = categoryIdx
      self.presetHerosDragList:refresh({})
    end
  })
  self.presetHerosDragList = MODULE.presetHerosDragList:init(self, {
    info = {
      heroCategoryInfo = self.heroCategoryInfo,
      teamIdxInfo = self.teamIdxInfo
    },
    callbackOver = function(info)
      self.heroCategoryInfo = info.heroCategoryInfo or self.heroCategoryInfo
      self.teamIdxInfo = info.teamIdxInfo or self.teamIdxInfo
      info.newTeamIdx = self.newTeamIdx
      self.newTeamDragList:refresh(info)
    end
  })
  self.newTeamDragList = MODULE.newTeamDragList:init(self, {
    info = {
      newTeamIdx = self.newTeamIdx,
      teamIdxInfo = self.teamIdxInfo
    },
    callbackOver = function(info)
      self.teamIdxInfo = info.teamIdxInfo or self.teamIdxInfo
      self.presetHerosDragList:refresh({})
    end
  })
  self.teamIdxDragList = MODULE.teamIdxDragList:init(self, {
    info = {
      newTeamIdx = self.groupId,
      team_count = 4
    },
    callbackOver = function(idx)
      self.groupId = idx
      self.teamIdx = ed.presetData.getPreseTeamNewIndexId(self.groupId)
      if not self.notAdd then
        self.oldId = DATA.packPreseIds(self.teamIdx, self.groupId)
        if not self.settingName then
          self.teamName = T("\230\150\176\233\162\132\232\174\190") .. self.teamIdx
        end
        self.teamNameModule:update({
          teamName = self.teamName
        })
      end
    end
  })
  self:refreshBtn()
end

function presetScene:refreshBtn()
  if not self.notAdd then
    self.ui.img_btn_delete:setVisible(false)
    local thisCon = self.ui.panel_btn_list:getContentSize()
    self.ui.img_btn_set:setPositionX(thisCon.width * 0.5)
  end
end

function presetScene:initLegendEquip()
  if not ed.openLegendEquip() then
    self.ui.switch_equip_bg:setVisible(false)
  end
  local constAdaptScale = 1.8
  local currentScale = ed.display.winSize.width / ed.display.winSize.height
  if constAdaptScale >= currentScale then
    self.ui.switch_equip_bg:setScale(0.85)
    self.ui.switch_equip_bg:setPositionX(62)
  else
    self.ui.switch_equip_bg:setPositionX(75)
  end
  self.ui.close_equip_bg:setVisible(not ed.off_legendEquipOp)
  self.ui.label_equip:setVisible(not ed.off_legendEquipOp)
  self.ui.btn_equip:setPositionX(ed.off_legendEquipOp and 17 or 59)
  self.ui.label_equip_enable:setVisible(ed.off_legendEquipOp)
  if not ed.off_legendEquipOp then
    self.ui.label_equip:setPositionX(17)
    self.ui.btn_equip:setPositionX(59)
  end
  ed.setString(self.ui.label_equip_enable, "\228\184\141\229\177\149\231\164\186")
  ed.setLabelColor(self.ui.label_equip_des, ed.toccc3(16771194))
  ed.setLabelStroke(self.ui.label_equip_des, ed.toccc3(1973790), 1.5)
  ed.setLabelColor(self.ui.label_equip, ed.toccc3(16776423))
  ed.setLabelStroke(self.ui.label_equip, ed.toccc3(65793), 1.5)
  ed.setLabelColor(self.ui.label_equip_enable, ed.toccc3(16776423))
  ed.setLabelStroke(self.ui.label_equip_enable, ed.toccc3(65793), 1.5)
  self:btRegisterButtonClick({
    button = self.ui.switch_equip_bg,
    key = "switch_equip_bg",
    clickInterval = 0.3,
    force = true,
    clickHandler = function()
      ed.off_legendEquipOp = not ed.off_legendEquipOp
      ed.saveLegendEquip()
      self:switchLegendEquipMenu(ed.off_legendEquipOp)
    end
  })
end

function presetScene:switchLegendEquipMenu(open)
  self.ui.close_equip_bg:setVisible(not open)
  self.ui.label_equip:setVisible(not open)
  self.ui.label_equip_enable:setVisible(open)
  self.ui.btn_equip:setPositionX(open and 17 or 59)
  self:refreshLegendEquip()
end

function presetScene:refreshLegendEquip()
  self.presetHerosDragList:refresh({})
  self.newTeamDragList:refreshLegendEquip()
end

function presetScene:registerTouchHandler()
  ed.UITool.registerBtn(self, "img_btn_delete", function()
    if self.waiting then
      return
    end
    ed.showConfirmDialog({
      text = string.format(T("\230\152\175\229\144\166\229\136\160\233\153\164\229\189\147\229\137\141\233\152\181\229\174\185"), self.newTeamIdx),
      rightText = T("\231\161\174\229\174\154"),
      skipDestroyAnim = true,
      rightHandler = function()
        Network.deleteLineupReq(self.oldId)
      end
    })
  end, {pressScale = 0.98})
  ed.UITool.registerBtn(self, "img_btn_set", function()
    if self.waiting then
      return
    end
    ed.showConfirmDialog({
      text = string.format(T("\230\152\175\229\144\166\228\191\157\229\173\152\229\189\147\229\137\141\233\152\181\229\174\185"), self.newTeamIdx),
      rightText = T("\231\161\174\229\174\154"),
      skipDestroyAnim = true,
      rightHandler = function()
        if not self.notAdd and not ed.presetData.canAdd() then
          ed.showToast(T("\233\152\181\229\174\185\230\149\176\233\135\143\229\183\178\232\190\190\228\184\138\233\153\144\239\188\129"))
          return
        end
        if #self.teamIdxInfo[1] == 0 then
          ed.showToast(T("\232\175\183\233\128\137\230\139\169\228\184\138\233\152\181\232\139\177\233\155\132\239\188\129"))
          return
        end
        self.waiting = true
        local id = DATA.packPreseIds(self.teamIdx, self.groupId)
        if self.oldId ~= id then
          self.deleteIng = id
          Network.deleteLineupReq(self.oldId)
        else
          Network.setLineupReq(id, self.teamName or "nil", self.teamIdxInfo[1])
        end
      end
    })
  end, {pressScale = 0.98})
end

function presetScene:refreshPresetScene(info)
  if info._set_lineup then
    self.waiting = false
    ed.popScene()
    ListenTimer(Timer:Once(0.3), function()
      ed.showToast(T("\233\152\181\229\174\185\228\191\157\229\173\152\230\136\144\229\138\159\239\188\129"))
    end)
  elseif info._delete_lineup then
    if self.deleteIng then
      Network.setLineupReq(self.deleteIng, self.teamName or "nil", self.teamIdxInfo[1])
      self.deleteIng = nil
    else
      ed.popScene()
      ListenTimer(Timer:Once(0.3), function()
        ed.showToast(T("\233\152\181\229\174\185\229\136\160\233\153\164\230\136\144\229\138\159\239\188\129"))
      end)
    end
  end
end
