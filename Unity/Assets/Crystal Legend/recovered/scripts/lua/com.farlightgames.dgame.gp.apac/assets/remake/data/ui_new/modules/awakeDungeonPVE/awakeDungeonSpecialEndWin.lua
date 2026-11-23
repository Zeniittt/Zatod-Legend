local base = ed.ui.popwindow
local awakeDungeonSpecialEndWin = newclass(base.mt)
ed.ui.awakeDungeonSpecialEndWin = awakeDungeonSpecialEndWin

function awakeDungeonSpecialEndWin.create(param)
  local self = base.create("awakeDungeonSpecialEndWin")
  setmetatable(self, awakeDungeonSpecialEndWin.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function awakeDungeonSpecialEndWin:initData(param)
  self.stageId = param.stageId
  self.result = param.result
  self.conditionTab = param.conditionTab
end

function awakeDungeonSpecialEndWin:initUI()
  ed.editorui(ed.uieditor.awakeDungeonSpecialEndWin, {
    container = self.container,
    ui = self.ui
  })
  self.ui.btn_again:setVisible(false)
  self.ui.btn_replay:setVisible(false)
  self:initLabel()
  self:initConditionInfo()
  self:playEnterAnim()
  ed.layout.horizontalSortNode({
    self.ui.btn_again,
    self.ui.btn_back
  }, {80, 0}, self.ui.bg:getContentSize().width * 0.5)
end

function awakeDungeonSpecialEndWin:initLabel()
  ed.setLabelStroke(self.ui.label_back, ccc3(ed.colorToStr("#90550f")), 1)
  ed.setLabelShadow(self.ui.label_back, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelStroke(self.ui.label_again, ccc3(ed.colorToStr("#90550f")), 1)
  ed.setLabelShadow(self.ui.label_again, ccc3(0, 0, 0), ccp(0, 2))
end

function awakeDungeonSpecialEndWin:getConditionItemPos(i)
  local ox = 10
  local oy = self.ui.panel_condition:getContentSize().height
  local itemHeight = 42
  local itemSpace = 0
  local dy = oy - i * (itemHeight + itemSpace) + itemSpace
  return ccp(ox, dy)
end

function awakeDungeonSpecialEndWin:getConditionHeight(num)
  local itemHeight = 42
  local itemSpace = 0
  return (itemHeight + itemSpace) * num - itemSpace
end

function awakeDungeonSpecialEndWin:createConditionItem(data)
  local container, ui = CCLayer:create(), {}
  local posX = 0
  local flagImg = ed.createSprite(data.isComplete and "UI/alpha/1080P/dungeon/result/finished.png" or "UI/alpha/1080P/dungeon/result/not_finished.png")
  container:addChild(flagImg)
  local flagSize = flagImg:getContentSize()
  flagImg:setPosition(posX + flagSize.width * 0.5, flagSize.height * 0.5)
  posX = posX + flagSize.width + 5
  local bgImg = ed.createSprite("UI/alpha/1080P/dungeon/result/bg_condition.png")
  container:addChild(bgImg)
  local bgSize = bgImg:getContentSize()
  bgImg:setPosition(posX + bgSize.width * 0.5, flagSize.height * 0.5)
  posX = posX + bgSize.width + 5
  local desLabel = ed.createttf(data.str, 18)
  bgImg:addChild(desLabel)
  desLabel:setAnchorPoint(ccp(0, 0.5))
  desLabel:setPosition(10, bgSize.height * 0.5)
  if data.isComplete then
    ed.setLabelColor(desLabel, ed.toccc3(16700269))
    ed.setLabelStroke(desLabel, ed.toccc3(3744789), 1)
  else
    ed.setLabelColor(desLabel, ed.toccc3(14605257))
    ed.setLabelStroke(desLabel, ed.toccc3(0), 1)
  end
  return container, ui
end

function awakeDungeonSpecialEndWin:initConditionInfo()
  self.conditionDraglist = ed.UITool.createDraglist(self.ui.panel_condition, {})
  self.conditionList = {}
  local stageTableItem = ed.getDataTable("DungeonStage")[self.stageId]
  local conditionTable = ed.getDataTable("BattleSpecialCondition")
  for i, v in ipairs(stageTableItem["Condition Group"]) do
    local conditionTableItem = conditionTable[v]
    if nil ~= conditionTableItem then
      local des = string.gsub(conditionTableItem.Description, "%%(.-)%%", function(content)
        local splitPos = string.find(content, "&")
        if nil == splitPos then
          return "unknown"
        else
          local index = tonumber(string.sub(content, 1, splitPos - 1))
          local type = string.sub(content, splitPos + 1)
          if type == "unit" then
            local id = conditionTableItem["Condition Param"][index]
            return ed.lookupDataTable("Unit", "Display Name", id)
          elseif index then
            return conditionTableItem["Condition Param"][index]
          else
            return "unknown"
          end
        end
      end)
      table.insert(self.conditionList, {
        str = des,
        isComplete = self.conditionTab[v]
      })
    end
  end
  table.sort(self.conditionList, function(a, b)
    return #a.str < #b.str
  end)
  for i, v in ipairs(self.conditionList) do
    local container, ui = self:createConditionItem(v)
    self.conditionDraglist:addItem(container)
    container:setPosition(self:getConditionItemPos(i))
  end
  self.conditionDraglist:initListHeight(self:getConditionHeight(#self.conditionList))
end

function awakeDungeonSpecialEndWin:prepareEnterAnim()
  self.ui.btn_data:setCascadeOpacityEnabled(true)
  self.ui.btn_data:setOpacity(0)
  self.ui.btn_replay:setCascadeOpacityEnabled(true)
  self.ui.btn_replay:setOpacity(0)
  self.ui.btn_again:setCascadeOpacityEnabled(true)
  self.ui.btn_again:setOpacity(0)
  self.ui.btn_back:setCascadeOpacityEnabled(true)
  self.ui.btn_back:setOpacity(0)
end

function awakeDungeonSpecialEndWin:playEnterAnim()
  if "victory" == self.result then
    ed.setTexture(self.ui.info_bg_2, "UI/alpha/1080P/battleresult/new_resource/victory_bg.png", true)
    self.ui.img_victory:setVisible(true)
    local node = ed.createFcaNode("eff_UI_pvp_light")
    self:addFca(node)
    local x, y = self.ui.light:getPosition()
    node:setPosition(ccp(x, y))
    self.ui.light:setVisible(false)
    self.ui.bg:addChild(node, -1)
    local node = ed.createFcaNode("eff_UI_pve_victory_wings")
    self:addFca(node)
    node:setPosition(ccp(x, y + 44))
    self.ui.bg:addChild(node, -1)
    local node = ed.createFcaNode("eff_UI_pvp_newrecord_particles")
    self:addFca(node)
    node:setPosition(ccp(x, y + 44))
    self.ui.bg:addChild(node, -1)
    self.ui.btn_data:runAction(CCFadeIn:create(0.2))
  else
    ed.setTexture(self.ui.info_bg_2, "UI/alpha/1080P/battleresult/new_resource/fail_bg.png", true)
    self.ui.img_victory:setVisible(false)
    local x, y = self.ui.light:getPosition()
    self.ui.light:setVisible(false)
    local sprite
    if ed.isAreaZhCn() then
      sprite = ed.createFcaNode("eff_UI_battleresult_fail")
      self:addFca(sprite)
    else
      sprite = ed.createSprite("UI/alpha/1080P/battleresult/battleresult_fail.png")
    end
    sprite:setPosition(ccp(x, y - 10))
    self.ui.title = sprite
    self.ui.bg:addChild(sprite)
    local wingsFca = ed.createFcaNode("eff_UI_pve_fail_wings")
    self:addFca(wingsFca)
    wingsFca:setPosition(ccp(x, y - 10))
    self.ui.bg:addChild(wingsFca, -1)
  end
end

function awakeDungeonSpecialEndWin:doClickReplay()
end

function awakeDungeonSpecialEndWin:onClickBtnBack()
  base.destroy(self)
  ed.popScene()
end

function awakeDungeonSpecialEndWin:onClickBtnData()
  local unitList = {}
  for index, unit in ipairs(ed.engine.unit_list) do
    if not unit.reborn_unique_id then
      table.insert(unitList, unit)
    end
  end
  ed.ui.BattleStaticsWin.create(unitList, "common", true)
end

function awakeDungeonSpecialEndWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:onClickBtnBack()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_data", function()
    self:onClickBtnData()
  end, {pressScale = 0.9})
end
