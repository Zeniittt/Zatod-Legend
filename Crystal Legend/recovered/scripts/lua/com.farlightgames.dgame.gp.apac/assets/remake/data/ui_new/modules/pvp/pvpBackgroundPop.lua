local base = ed.ui.popwindow
local pvpBackgroundPop = newclass(base.mt)
ed.ui.pvpBackgroundPop = pvpBackgroundPop

function pvpBackgroundPop.create(param)
  local self = base.create("pvpBackgroundPop")
  setmetatable(self, pvpBackgroundPop.mt)
  self:init(param)
  return self
end

function pvpBackgroundPop:init(param)
  self.param = param
  self:initView(param)
  self:addEventListener()
end

function pvpBackgroundPop:initView(param)
  local container, ui = ed.editorui(ed.uieditor.PvpBackgroundPop)
  self.ui = ui
  self.container:addChild(container)
  ed.setLabelStroke(self.ui.Label_24589, ed.toccc3(7687475), 2)
  local data = param.data
  self:createDragList(param)
  self:show()
end

function pvpBackgroundPop:addEventListener()
  self:btRegisterOutClick({
    area = {
      self.ui.ImageView_24577,
      self.ui.btn_close
    },
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end
  })
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy()
  end, {pressScale = 0.8, normalScale = 0.85})
  ed.UITool.registerBtn(self, "button", function()
    if self.selectedId ~= (ed.pvpManager.backgroundId or 1) then
      ed.pvpNetwork:sendUseBackground(self.selectedId)
    end
  end, {pressScale = 0.95, normalScale = 1})
  self:listenEvent("useBackgroundReply", function(txt)
    self:refreshDragList()
  end)
end

function pvpBackgroundPop:createDragList(param)
  local thisCon = self.ui.Panel_item:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = self.ui.Panel_item,
    noshade = true,
    priority = -300,
    doPressIn = self:doPressInList(),
    doClickIn = self:doClickInList(),
    cancelPressIn = self:cancelPressInList()
  }
  self.dragList = ed.draglist.create(info)
  self.refreshCliprectConfig = {
    draglist = self.dragList
  }
  self.selectedId = 1
  self:refreshDragList()
end

function pvpBackgroundPop:refreshDragList()
  local thisCon = self.ui.Panel_item:getContentSize()
  local cfg = ed.copyTable(ed.getDataTable("ArenaBackground"))
  local backgroundId = ed.pvpManager.backgroundId or 1
  local maps = {}
  for i, v in ipairs(cfg) do
    v.have = 0
    v.quality = ed.readequip.quality(v["Item ID"]) or 1
    if v["Item ID"] == 0 or 0 < (ed.player.equip_qunty[v["Item ID"]] or 0) then
      v.mask_using = v.ID == backgroundId
      table.insert(maps, v)
      v.have = 1
    elseif not v.Hide then
      v.mask = true
      table.insert(maps, v)
    end
    v.selected = v.ID == self.selectedId
    v.sort = v["Item ID"] == 0 and 9 or 0
  end
  table.sort(maps, ed.cmpSort({
    {key = "have", reverse = true},
    {key = "sort", reverse = true},
    {key = "quality", reverse = true},
    {key = "Item ID", reverse = true}
  }))
  self.dragList:clearList()
  self.items = {}
  local width, height = 192, 116
  for i, v in ipairs(maps) do
    local item = self.itemModule.create(self, v, i)
    self.dragList:addItem(item.ui.Layer, ccp((i - 1) % 3 * width + width / 2 + 9, thisCon.height - height * math.ceil(i / 3) + height / 2 - 8))
    table.insert(self.items, item)
  end
  self.dragList:initListHeight(math.ceil(#maps / 3) * height + 10)
  if self.selectedId == backgroundId then
    self.ui.button:setVisible(false)
    self.ui.ImageView_24588:setVisible(true)
  elseif self.selectedId == 1 or 0 < (ed.player.equip_qunty[cfg[self.selectedId]["Item ID"]] or 0) then
    self.ui.button:setVisible(true)
    self.ui.ImageView_24588:setVisible(false)
  else
    self.ui.button:setVisible(false)
    self.ui.ImageView_24588:setVisible(false)
  end
end

local itemModule = {}

function itemModule.create(mainSelf, param, index)
  local this = setmetatable({
    mainSelf = mainSelf,
    param = param,
    index = index
  }, {__index = itemModule})
  this:init(param)
  return this
end

local frame_res = {
  "green",
  "green",
  "blue",
  "purple",
  "purple",
  "orange",
  "red",
  "pink",
  "prismatic"
}

function itemModule:init(param)
  local Layer = ed.createSpriteTools({})
  local selected = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/frame/arena_background_frame_selected.png",
    parent = Layer,
    pos = ccp(0.2, -0.7),
    scale = 0.98,
    notShow = true
  })
  local clippingNode = ed.createClippingNodeOnly("UI/alpha/1080P/common/frame/arena_background_mask.png", nil)
  ed.createSpriteTools({
    res = param.Picture,
    parent = clippingNode,
    scale = 0.17
  })
  Layer:addChild(clippingNode)
  local mask_using = ed.createSpriteTools({
    res = "UI/alpha/1080P/pvp/arena_background_mask_using.png",
    parent = Layer
  })
  ed.createLabelTools({
    txt = T("\228\189\191\231\148\168\228\184\173"),
    size = 13,
    pos = ccp(82.25, 47),
    ed.toccc3(16776925),
    parent = mask_using,
    stroke = {
      ccc3(ed.colorToStr("#195900")),
      1.3
    }
  })
  local title = ed.createSpriteTools({
    res = "UI/alpha/1080P/pvp/arena_background_title_bg.png",
    parent = Layer,
    pos = ccp(0, -32)
  })
  local name = T("\231\187\143\229\133\184")
  if param["Item ID"] ~= 0 then
    name = ed.getDataTable("equip")[param["Item ID"]].Name
  end
  param.name = name
  ed.createLabelTools({
    txt = name,
    size = 16,
    pos = ccp(81.75, 10.5),
    ed.toccc3(16710632),
    parent = title,
    stroke = {
      ccc3(ed.colorToStr("#272524")),
      1.3
    }
  })
  local mask = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/frame/arena_background_mask.png",
    parent = Layer,
    notShow = true,
    scale = 0.95
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/skill/skill_lock.png",
    parent = mask,
    pos = ccp(85, 55),
    scale = 0.8
  })
  local bg = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/frame/arena_background_frame_" .. frame_res[param.quality] .. ".png",
    parent = Layer
  })
  local detail = ed.createSpriteTools({
    res = "UI/alpha/1080P/hero/hero_info_detail.png",
    parent = bg,
    pos = ccp(158, 87),
    scale = 0.7
  })
  self.ui = {
    Layer = Layer,
    bg = bg,
    selected = selected,
    mask_using = mask_using,
    mask = mask,
    detail = detail
  }
  self:refresh()
end

function itemModule:refresh(param)
  self.ui.Layer:setScale(self.param.selected and 1.1 or 1.05)
  self.ui.selected:setVisible(self.param.selected)
  self.ui.mask_using:setVisible(self.param.mask_using)
  self.ui.mask:setVisible(self.param.mask)
end

pvpBackgroundPop.itemModule = itemModule

function pvpBackgroundPop:doPressInList()
  local function handler(x, y)
    for _, v in pairs(self.items) do
      if ed.containsPoint(v.ui.bg, x, y) then
        if ed.containsPoint(v.ui.detail, x, y) then
          v.ui.detail:setScale(0.65)
          
          return {
            icon = v.ui.detail,
            fun = function(this)
              self.lookBackgroundPop.create(this.param):popWindow()
            end,
            param = v,
            normalScale = 0.7
          }
        end
        v.ui.Layer:setScale(1.03)
        return {
          icon = v.ui.Layer,
          fun = function(this)
            self.selectedId = this.param.ID
            self:refreshDragList()
          end,
          param = v,
          normalScale = 1.05
        }
      end
    end
  end
  
  return handler
end

function pvpBackgroundPop:cancelPressInList()
  local function handler(x, y, info)
    info.icon:setScale(info.normalScale or 1)
  end
  
  return handler
end

function pvpBackgroundPop:doClickInList()
  local function handler(x, y, info)
    if info.fun then
      info.fun(info.param or {})
    end
  end
  
  return handler
end

local lookBackgroundPop = newclass(base.mt)

function lookBackgroundPop.create(param)
  local self = base.create("lookBackgroundPop")
  setmetatable(self, lookBackgroundPop.mt)
  self:init(param)
  return self
end

function lookBackgroundPop:init(param)
  self.param = param
  self:initView(param)
  self:addEventListener()
end

function lookBackgroundPop:initView(param)
  local ui = {}
  ui.bg = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/com_new_1.png",
    pos = ccp(480, 250),
    rectMake = CCRectMake(25, 20, 50, 350),
    sizeMake = CCSizeMake(654, 466),
    parent = self.container
  })
  ui.title = ed.createSpriteTools({
    res = "UI/alpha/1080P/package/bg_compose.png",
    parent = ui.bg,
    pos = ccp(327, 441),
    rectMake = CCRectMake(50, 0, 11, 1),
    sizeMake = CCSizeMake(330, 32)
  })
  ui.title_name = ed.createLabelTools({
    txt = param.name,
    size = 20,
    pos = ccp(165, 16),
    ed.toccc3(16776423),
    parent = ui.title,
    stroke = {
      ccc3(ed.colorToStr("#272524")),
      1.3
    }
  })
  local stencil = ed.createSpriteTools({
    res = "UI/alpha/1080P/pvp/arena_background_preview_mask.png",
    rectMake = CCRectMake(15, 15, 6, 6),
    sizeMake = CCSizeMake(584, 326)
  })
  local clippingNode = CCClippingNode:create()
  clippingNode:setAlphaThreshold(0.5)
  clippingNode:setCascadeOpacityEnabled(true)
  clippingNode:setStencil(stencil)
  ui.bg:addChild(clippingNode)
  clippingNode:setPosition(327, 253)
  ed.createSpriteTools({
    res = param.Picture,
    parent = clippingNode,
    scale = 0.7
  })
  ui.frame = ed.createSpriteTools({
    res = "UI/alpha/1080P/pvp/arena_background_preview_frame.png",
    parent = ui.bg,
    pos = ccp(327, 252.9),
    rectMake = CCRectMake(15, 15, 6, 6),
    sizeMake = CCSizeMake(587.1, 329.4)
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/common/comm_line_b_star.png",
    pos = ccp(327, 78),
    parent = ui.bg,
    scale = 0.5
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/common/comm_line_b.png",
    pos = ccp(214, 75),
    parent = ui.bg,
    rectMake = CCRectMake(20, 0, 0.5, 0.5),
    sizeMake = CCSizeMake(440, 12.5),
    scale = 0.5
  })
  local right = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/comm_line_b.png",
    pos = ccp(440, 75),
    parent = ui.bg,
    rectMake = CCRectMake(20, 0, 0.5, 0.5),
    sizeMake = CCSizeMake(440, 12.5)
  })
  right:setScaleX(-0.5)
  right:setScaleY(0.5)
  local descriptionNode = ed.createLabelTools({
    txt = param.Description,
    size = 14,
    pos = ccp(327, 50),
    color = ed.toccc3(7037275),
    parent = ui.bg
  })
  ui.descriptionNode = descriptionNode
  self.ui = ui
  self:show()
end

function lookBackgroundPop:addEventListener()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end
  })
end

pvpBackgroundPop.lookBackgroundPop = lookBackgroundPop
