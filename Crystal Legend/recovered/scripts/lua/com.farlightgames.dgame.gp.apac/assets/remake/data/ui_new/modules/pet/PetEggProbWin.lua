local base = ed.ui.popwindow
local petEggProbWin = {}
petEggProbWin.__index = petEggProbWin
setmetatable(petEggProbWin, base.mt)
ed.ui.petEggProbWin = petEggProbWin

function petEggProbWin.create(param)
  local self = base.create("petEggProbWin")
  setmetatable(self, petEggProbWin)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function petEggProbWin:initData(param)
  self.petEggId = param.petEggId
  local eggCfg = ed.getDataTable("PetEgg")[self.petEggId]
  local lootDisplay = ed.copyTable(eggCfg["Loot Display"] or {})
  local lootProb = ed.copyTable(eggCfg["Loot Prob Display"] or {})
  self.probsList = {}
  for i = 1, #lootDisplay do
    self.probsList[i] = {
      petid = lootDisplay[i],
      prob = lootProb[i] or 0
    }
  end
end

function petEggProbWin:initUI()
  ed.editorui(ed.uieditor.pet_egg_prob, {
    container = self.container,
    ui = self.ui
  })
  local container, ui = self.container, self.ui
  local list_num = #self.probsList
  if list_num < 8 then
    local ori_panel_size = ui.panel_list:getContentSize()
    local deltaHei = ori_panel_size.height * 0.125 * (8 - list_num)
    local halfDeltaHei = 0.5 * deltaHei
    local panel_height = ori_panel_size.height - deltaHei
    local bgSize = ui.Image_bg:getContentSize()
    ui.panel_list:setContentSize(CCSizeMake(ori_panel_size.width, panel_height))
    ui.Image_bg:setContentSize(CCSizeMake(bgSize.width, bgSize.height - deltaHei))
    ed.UITool.setPositionBy(ui.btn_back, ccp(0, -halfDeltaHei))
    ed.UITool.setPositionBy(ui.label_title, ccp(0, -halfDeltaHei))
  end
  self.dlSize = ui.panel_list:getContentSize()
  self:initDraglist()
end

function petEggProbWin:initDraglist()
  local width, height = self.dlSize.width, self.dlSize.height
  
  local function calcPos(i)
    return ccp(28, height + 23 - i * 55)
  end
  
  self.dragList = ed.UITool.createDraglist(self.ui.panel_list, {
    zorder = 20,
    bar = {
      bglen = height,
      bgpos = ccp(width + 20, height / 2)
    }
  })
  self.refreshCliprectConfig = {
    draglist = self.dragList
  }
  for i, v in ipairs(self.probsList) do
    local icon = ed.readpet.createIcon({
      type = v.petid,
      showTag = true,
      length = 45
    }).icon
    icon:setPosition(calcPos(i))
    local prob_bg = ed.createScale9Sprite("UI/alpha/1080P/pet/incubate/pet_house_info_bg.png")
    prob_bg:setContentSize(CCSizeMake(265, 30))
    local label_prob = ed.createLabelTTF(string.format("%.02f%%", v.prob * 100), 18)
    ed.setLabelColor(label_prob, ed.toccc3(15249746))
    ed.setLabelStroke(label_prob, ed.toccc3(2565412), 1)
    local label_name = ed.createLabelTTF(ed.lookupDataTable("Unit", "Display Name", v.petid), 18)
    ed.setLabelColor(label_name, ed.toccc3(16776423))
    ed.setLabelStroke(label_name, ed.toccc3(2565412), 1)
    self.dragList:addItem(prob_bg)
    self.dragList:addItem(label_name)
    self.dragList:addItem(label_prob)
    self.dragList:addItem(icon)
    ed.right2(prob_bg, icon, 10)
    ed.right2(label_name, icon, 25)
    ed.right2(label_prob, icon, 200)
  end
  self.dragList:initListHeight(55 * #self.probsList)
end

function petEggProbWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.Image_bg,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_back,
    key = "back_btn",
    force = true,
    mcpMode = true,
    pressScale = 0.7,
    normalScale = 0.75,
    clickHandler = function()
      self:destroy()
    end
  })
end
