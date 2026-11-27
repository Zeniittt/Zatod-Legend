local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.legendEquipResetConfirm = class
ed.UITool.registViewOpenFunc("legendEquipResetConfirm", function(param)
  local window = ed.ui.legendEquipResetConfirm.create(param)
  window:show()
  window:popWindow()
end)

function class.create(param)
  local self = base.create("legendEquipResetConfirm")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  self.legendEquip = param.legendEquip
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.legend_equip_reset_confirm)
  self.container:addChild(container)
  self.ui = ui
  ed.setLabelShadow(self.ui.label_confirm, ccc3(0, 0, 0), ccp(0, 2))
  self:refreshInfo()
  self:refreshTimes()
  self:refreshBtn()
end

function class:refreshInfo()
  local typeId = self.legendEquip._type_id
  local curStar = self.legendEquip._star
  local curRank = self.legendEquip._rank
  local equipIcon = ed.readequip.createLegendEquipIcon(self.legendEquip)
  equipIcon:setScale(0.75)
  self.ui.panel_source:addChild(equipIcon, 1)
  ed.layout.centerInParent(equipIcon)
  local costPrice = 0
  local costEquip = 0
  local costMap = {}
  local legendEquipEnhanceTable = ed.getDataTable("LegendEquipEnhance")[typeId]
  for star, tab in pairs(legendEquipEnhanceTable) do
    for rank, tableItem in pairs(tab) do
      if star < curStar or star == curStar and rank < curRank then
        costPrice = costPrice + tableItem["Cost Price"]
        costEquip = costEquip + tableItem["Cost Equip Amount"]
        for index = 1, 10 do
          local costItemId = tableItem[string.format("Cost Item ID %s", index)]
          if not costItemId or costItemId == 0 then
            break
          end
          local costItemAmount = tableItem[string.format("Cost Item Amount %s", index)]
          costItemId[costItemId] = (costMap[costItemId] or 0) + costItemAmount
        end
      end
    end
  end
  local costItemList = {}
  if 0 < costPrice then
    table.insert(costItemList, {type = "Gold", amount = costPrice})
  end
  for k, v in pairs(costMap) do
    table.insert(costItemList, {
      type = "item",
      id = k,
      amount = v
    })
  end
  costEquip = costEquip + 1
  if 0 < costEquip then
    table.insert(costItemList, {
      type = "legend_equip",
      id = typeId,
      amount = costEquip
    })
  end
  self.ui.panel_result:removeAllChildrenWithCleanup(true)
  local posY = self.ui.panel_result:getContentSize().height / 2
  local itemList = {}
  for index, itemCfg in ipairs(costItemList) do
    local itemIcon = ed.createItemIcon({
      id = itemCfg.id,
      type = itemCfg.type,
      amount = 0
    })
    local amountStr
    if itemCfg.type == "Gold" then
      amountStr = itemCfg.amount
    else
      amountStr = "x" .. itemCfg.amount
    end
    local labelNeedAmount = ed.createLabelTTF(amountStr, 20)
    itemIcon:addChild(labelNeedAmount)
    ed.setLabelColor(labelNeedAmount, ed.toccc3(16776423))
    ed.setLabelColor(labelNeedAmount, ed.toccc3(16776423))
    labelNeedAmount:setAnchorPoint(ccp(1, 0.5))
    labelNeedAmount:setStroke(ccc3(39, 37, 36), 1)
    labelNeedAmount:setPosition(ccp(80, 20))
    self.ui.panel_result:addChild(itemIcon)
    table.insert(itemList, itemIcon)
    itemIcon:setScale(0.75)
    itemIcon:setPositionY(posY)
  end
  ed.layout.horizontalSortNode(itemList, nil, 0, 0)
end

function class:refreshBtn()
  local bindHero = self.legendEquip._carried_hero_id
  if bindHero and 0 < bindHero then
    self.ui.panel_reset:setVisible(false)
    self.ui.bg_bind:setVisible(true)
    ed.setLabelColor(self.ui.label_confirm, ccc3(255, 252, 231))
    ed.setTexture(self.ui.btn_reset, "UI/alpha/1080P/common/button_mini_grey.png")
  else
    self.ui.panel_reset:setVisible(true)
    self.ui.bg_bind:setVisible(false)
    ed.setLabelColor(self.ui.label_confirm, ccc3(254, 241, 169))
    ed.setTexture(self.ui.btn_reset, "UI/alpha/1080P/common/button_com_mini.png")
  end
end

function class:refreshTimes()
  local curTimes = ed.legendEquipMgr.getInstance():getLeftResetTimes()
  self.ui.btn_add_times:setVisible(true)
  ed.setLabelString(self.ui.label_times, T("\230\156\172\229\145\168\229\137\169\228\189\153\230\172\161\230\149\176\239\188\154%d", curTimes))
  ed.layout.horizontalSortNode({
    self.ui.label_times,
    self.ui.btn_add_times
  }, {-2, 0}, self.ui.panel_reset:getContentSize().width * 0.5)
end

function class:addTouchEvent()
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "clickOut",
    clickHandler = function()
      self:destroy({skipAnim = false})
    end,
    force = true
  })
  ed.UITool.registerBtn(self, "btn_reset", function()
    self:onClickBtnReset()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_add_times", function()
    self:toAddResetTimes()
  end, {pressScale = 0.95})
end

function class:onClickBtnReset()
  local bindHero = self.legendEquip._carried_hero_id
  if bindHero and 0 < bindHero then
    ed.showToast(T("\232\163\133\229\164\135\232\167\163\231\187\145\229\144\142\239\188\140\229\143\175\232\191\155\232\161\140\233\135\141\231\189\174"))
    return
  end
  local curTimes = ed.legendEquipMgr.getInstance():getLeftResetTimes()
  if 0 < curTimes then
    ed.legendEquipNet.sendEquipReset(self.legendEquip._id)
  else
    self:toAddResetTimes()
  end
end

function class:toAddResetTimes()
  local cost = ed.legendEquipDefine.Reset_Times_Cost
  local info = {
    autoText = string.format(T("\230\152\175\229\144\166\232\166\129\232\138\177\232\180\185<sprite src=UI/alpha/1080P/icon/diamond.png><lable color=headlineOrange>%d</lable>\233\146\187\231\159\179\232\180\173\228\185\1761\230\172\161\233\135\141\231\189\174\230\172\161\230\149\176\239\188\159"), cost),
    rightHandler = function()
      if ed.player._rmb < cost then
        ed.showToast("\233\146\187\231\159\179\228\184\141\232\182\179\239\188\140\232\175\183\229\133\133\229\128\188")
      else
        ed.legendEquipNet.sendBuyResetTimes()
      end
    end,
    leftText = T("\229\143\150\230\182\136"),
    rightText = T("\231\161\174\229\174\154"),
    mode = "simple",
    fontSize = 17
  }
  ed.showConfirmDialog(info)
end

function class:addEventListener()
  self:listenEvent("UpdateLegendEquip", function(id)
    self:onUpdateLegendEquip(id)
  end)
  self:listenEvent("UpdateLegendEquipResetTimes", function()
    self:refreshTimes()
  end)
  self:listenEvent("LegendEquipResetSuccess", function()
    self:destroy({skipAnim = true})
    local equipWin = ed.getPopWindow("legendEquipWindow")
    if equipWin then
      equipWin:destroy({skipAnim = true})
    end
  end)
end

function class:onUpdateLegendEquip(id)
  if id == self.legendEquip._id then
    local legendEquip = ed.legendEquipMgr.getInstance():getLegendEquip(id)
    if nil == legendEquip then
      return
    end
    self.legendEquip = legendEquip
    self:refreshInfo()
  end
end
