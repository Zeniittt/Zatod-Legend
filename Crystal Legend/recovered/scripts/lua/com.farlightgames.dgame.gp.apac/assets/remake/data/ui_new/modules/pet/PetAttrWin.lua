local base = ed.ui.popwindow
local petAttrWin = {}
petAttrWin.__index = petAttrWin
setmetatable(petAttrWin, base.mt)
ed.ui.petAttrWin = petAttrWin
local res = ed.heroDetailManager.resConfig

function petAttrWin.create(param)
  local self = base.create("petAttrWin")
  setmetatable(self, petAttrWin)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self.refreshCliprectConfig = {
    draglist = self.draglist
  }
  self:popWindow()
  self:show()
  return self
end

function petAttrWin:initPetEvoAttr()
  local petTypeId = self.pet:getTypeId()
  local tbData = ed.getDataTable("Pet")[petTypeId]
  local attrList = {}
  for i = 1, 3 do
    local attrCN = res.att_anim_name[tbData["Extra Attr " .. i .. " Type"]]
    if self.pet:getLevel() >= tbData["Extra Attr " .. i .. " Unlock Level"] then
      local used = false
      for k, v in ipairs(self.attrInfo) do
        if v[1] == attrCN then
          v[2] = v[2] + tbData["Extra Attr " .. i .. " Value"]
          used = true
          break
        end
      end
      local suffix = res.att_suffix[tbData["Extra Attr " .. i .. " Type"]] or ""
      if not used then
        table.insert(self.attrInfo, {
          attrCN,
          tbData["Extra Attr " .. i .. " Value"] .. suffix
        })
      end
    end
  end
end

function petAttrWin:initPetAttr()
  local heroId = self.pet:getCarriedHeroId()
  if heroId then
    local growth = ed.readhero.getGrowth(heroId)
    self.attrInfo = {
      {
        T("\229\138\155\233\135\143\230\136\144\233\149\191"),
        string.format("%.2f", growth.STR / 100 * self.pet:getPetAttrRadio("STR"))
      },
      {
        T("\230\153\186\229\138\155\230\136\144\233\149\191"),
        string.format("%.2f", growth.INT / 100 * self.pet:getPetAttrRadio("INT"))
      },
      {
        T("\230\149\143\230\141\183\230\136\144\233\149\191"),
        string.format("%.2f", growth.AGI / 100 * self.pet:getPetAttrRadio("AGI"))
      }
    }
    local heroAttr = ed.readhero.getHeroAttByHero(ed.player:getHero(heroId))
    table.insert(self.attrInfo, {
      T("\229\138\155\233\135\143"),
      string.format("%.1f", self.pet:getPetAttrValue("STR"))
    })
    table.insert(self.attrInfo, {
      T("\230\153\186\229\138\155"),
      string.format("%.1f", self.pet:getPetAttrValue("INT"))
    })
    table.insert(self.attrInfo, {
      T("\230\149\143\230\141\183"),
      string.format("%.1f", self.pet:getPetAttrValue("AGI"))
    })
    self:initPetEvoAttr()
  end
end

function petAttrWin:initData(param)
  self.pet = param.pet
  self:initPetAttr()
end

function petAttrWin:createGrowthItem(index, v)
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  local readnode = ed.readnode.create(container, ui)
  if index % 2 == 1 then
    readnode:addNode(ed.uieditor.itemAttr1)
  else
    readnode:addNode(ed.uieditor.itemAttr2)
  end
  ed.setLabelStroke(ui.attrname, ccc3(57, 36, 21), 1)
  ed.setString(ui.attrname, v[1])
  ed.setString(ui.attrnum, v[2])
  return container, ui
end

function petAttrWin:refreshDraglist()
  self.draglist:clearList()
  local size = self.ui.layer_att:getContentSize()
  local ox, oy, dy = size.width / 2, size.height, 35
  
  local function getPos(i)
    return ccp(ox, oy - (i - 0.5) * dy)
  end
  
  for k, v in ipairs(self.attrInfo) do
    local container, ui
    container, ui = self:createGrowthItem(k, v)
    self.draglist:addItem(container)
    container:setPosition(getPos(k))
  end
  self.draglist:initListHeight(35 * #self.attrInfo)
end

function petAttrWin:initUI()
  ed.editorui(ed.uieditor.heroAttWin, {
    container = self.container,
    ui = self.ui
  })
  self.ui.desc:setVisible(false)
  self.ui.comment:setVisible(false)
  ed.setString(self.ui.title, T("\232\139\177\233\155\132\229\177\158\230\128\167\230\143\144\229\141\135\232\175\166\230\131\133"))
  self.ui.layer_att:setContentSize(CCSizeMake(500, 280))
  self.draglist = ed.UITool.createDraglist(self.ui.layer_att, {})
  self:refreshDraglist()
end

function petAttrWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end
  })
end
