local base = ed.ui.popwindow
local PetChooseMasterWin = newclass(base.mt)
ed.ui.PetChooseMasterWin = PetChooseMasterWin

function PetChooseMasterWin:refreshDraglist()
  self.draglist:clearList()
  self.uiList = {}
  local dx, dy = 90, 90
  local size = self.ui.layer_item:getContentSize()
  local ox, oy = 12 + dx / 2, size.height - dy / 2
  local colNum = 9
  
  local function getPos(i)
    local row = math.floor((i - 1) / colNum)
    local col = (i - 1) % colNum
    return ccp(ox + dx * col, oy - dy * row)
  end
  
  local heroList = self.heroList[self.tabName]
  for k, hero in ipairs(heroList) do
    local icon = ed.readhero.createIconByID(hero._tid)
    if hero._pet then
      icon:addShade()
      icon:addPetIcon(hero._pet._id)
    end
    icon.icon:setPosition(getPos(k))
    self.draglist:addItem(icon.icon)
    table.insert(self.uiList, {
      icon = icon.icon,
      data = hero
    })
  end
  self.draglist:initListHeight(math.ceil(#heroList / 9) * dy)
end

function PetChooseMasterWin:initUI()
  ed.editorui(ed.uieditor.PetChooseMasterWin, {
    container = self.container,
    ui = self.ui
  })
  ed.setLabelStroke(self.ui.Label_7232, ed.toccc3(2693915), 1)
  ed.setLabelShadow(self.ui.Label_5859, ccc3(0, 0, 0), ccp(1, 1))
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:doPressInList(),
    doClickIn = self:doClickInList()
  })
  self:refreshDraglist()
end

function PetChooseMasterWin.create(petId)
  local self = base.create("PetChooseMasterWin")
  setmetatable(self, PetChooseMasterWin.mt)
  self.petId = petId
  self.pet = ed.player:getPet(self.petId)
  self:initData()
  self:initUI()
  self:registerTouchHandlers()
  self.refreshCliprectConfig = {
    draglist = self.draglist
  }
  self:popWindow()
  self:show()
  return self
end

function PetChooseMasterWin:initData()
  local all, front, middle, back = ed.readhero.classify("prepare", "position", nil, nil, true)
  local a, STR, AGI, INT = ed.readhero.classify("prepare", "type", nil, nil, true)
  self.tabConfig = {
    "all",
    "front",
    "middle",
    "back",
    "STR",
    "INT",
    "AGI"
  }
  self.tabName = self.tabConfig[1]
  self.heroList = {
    all = all,
    front = front,
    middle = middle,
    back = back,
    STR = STR,
    AGI = AGI,
    INT = INT
  }
  for k, v in pairs(self.heroList) do
    local tmp = {}
    for i, hero in ipairs(v) do
      if ed.heroDetailManager.checkUnlockPet(hero._tid) then
        table.insert(tmp, hero)
      end
    end
    self.heroList[k] = tmp
  end
  for k, v in pairs(self.heroList) do
    table.sort(v, ed.cmpSort({
      {
        getValue = function(hero)
          return hero._pet and 1 or 0
        end
      },
      {key = "_level", reverse = true},
      {key = "_rank", reverse = true},
      {key = "_stars", reverse = true},
      {key = "_tid"}
    }))
  end
end

function PetChooseMasterWin:refreshBtns(index)
  local nameConfig = {
    T("\229\133\168\233\131\168"),
    T("\229\137\141\230\142\146"),
    T("\228\184\173\230\142\146"),
    T("\229\144\142\230\142\146"),
    T("\229\138\155\233\135\143"),
    T("\230\153\186\229\138\155"),
    T("\230\149\143\230\141\183")
  }
  self.ui.btn_tab_selected:setPosition(ccp(self.ui["tab" .. index]:getPosition()))
  self.ui.Label_7089:setString(nameConfig[index])
end

function PetChooseMasterWin:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      if ed.containsPoint(v.icon, x, y) then
        return v
      end
    end
  end
  
  return handler
end

function PetChooseMasterWin:doClickInList()
  local function handler(x, y, v)
    if v.data._pet then
      ed.showToast(T("\232\175\165\232\139\177\233\155\132\229\183\178\232\163\133\229\164\135\228\191\161\228\189\191"))
      
      return
    end
    self.selectItem = v
    if tolua.isnull(self.selectTag) then
      self.selectTag = ed.createSprite("UI/alpha/1080P/package/selected.png")
      self.draglist:addItem(self.selectTag)
    end
    self.selectTag:setPosition(ccp(v.icon:getPosition()))
  end
  
  return handler
end

function PetChooseMasterWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "clickOut",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
  for k, v in ipairs(self.tabConfig) do
    ed.UITool.registerBtn(self, "tab" .. k, function()
      if self.tabName ~= v then
        self.tabName = v
        self.selectItem = nil
        self:refreshBtns(k)
        self:refreshDraglist()
      end
    end)
  end
  ed.UITool.registerBtn(self, "btn_ok", function()
    if self.selectItem then
      if self.pet:getCD() ~= 0 then
        ed.showConfirmDialog1({
          title = T("\230\143\144\231\164\186"),
          autoText = string.format(T("\233\162\134\229\133\187\230\173\164\228\191\161\228\189\191\229\144\142\239\188\140\233\156\128\232\166\129\231\173\137\229\190\133<lable color=ccc3(255,0,0)>%s</lable>\229\144\142\230\137\141\232\131\189\231\166\187\229\188\128\228\184\187\228\186\186\239\188\140\230\152\175\229\144\166\231\187\167\231\187\173\239\188\159"), self.pet:getCDStr()),
          offsetY = 10,
          fontSize = 20,
          rightHandler = function()
            ed.PetNetwork:equipPet(self.selectItem.data._tid, self.pet:getId())
          end
        })
      else
        ed.PetNetwork:equipPet(self.selectItem.data._tid, self.pet:getId())
      end
    end
    self:destroy()
  end)
end
