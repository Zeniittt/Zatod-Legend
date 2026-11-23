local boatUIConfig = {
  upgrade0 = {
    upgrade = 1,
    boatRes = "UI/alpha/1080P/dragonboat/db_boat/db_boat_firstget.png",
    nameColor1 = ed.toccc3(11170121),
    nameColor2 = ed.toccc3(7491639)
  },
  upgrade1 = {
    upgrade = 1,
    boatRes = "UI/alpha/1080P/dragonboat/db_boat/db_boat_first.png",
    nameColor1 = ed.toccc3(11170121),
    nameColor2 = ed.toccc3(7491639)
  },
  upgrade2 = {
    upgrade = 2,
    boatRes = "UI/alpha/1080P/dragonboat/db_boat/db_boat_second.png",
    transBoatRes = "UI/alpha/1080P/dragonboat/db_boat/db_boat_secondtothird.png",
    nameColor1 = ed.toccc3(5615492),
    nameColor2 = ed.toccc3(3824955)
  },
  upgrade3 = {
    upgrade = 3,
    boatRes = "UI/alpha/1080P/dragonboat/db_boat/db_boat_third.png",
    nameColor1 = ed.toccc3(15566924),
    nameColor2 = ed.toccc3(11025706)
  }
}
local base = ed.ui.popwindow
local class = {}
class.__index = class
setmetatable(class, base.mt)
ed.ui.dragonBoatBoatPop = class

function class.create(params)
  local self = base.create("dragonBoatBoatPop", {notBlurBg = true})
  setmetatable(self, class)
  self:init(params)
  return self
end

function class:init(params)
  self:initData(params)
  self:initUI()
  self:registerEvent()
end

function class:initData(params)
  self.boatLevel = params.boatLevel
  self.boatLevel = self.boatLevel > 3 and 3 or self.boatLevel
  self.upgradeScope = {}
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.DragonBoatBoatPop)
  self.container:addChild(container)
  self.ui = ui
  ed.setLabelShadow(self.ui.label_speed, ed.toccc3(4402707), ccp(0, 3))
  self.ui.img_dialog:setOpacity(0)
  local str = ""
  local strLab = ed.createLabelTTF(str, 14)
  ed.setLabelColor(strLab, ed.toccc3(469785))
  self.ui.img_dialog:addChild(strLab)
  self.progressStr = strLab
  self.progressStr:setOpacity(0)
  self:refreshUI()
  if self.boatLevel == 0 then
    self.ui.btn_update_boat:setCascadeOpacityEnabled(true)
    local scaleTo_1 = CCScaleTo:create(1, 1.15)
    local fadeTo_1 = CCFadeTo:create(1, 204)
    local action1 = CCSpawn:create(ccArrayMake(scaleTo_1, fadeTo_1))
    local scaleTo_2 = CCScaleTo:create(1, 1)
    local fadeTo_2 = CCFadeTo:create(1, 255)
    local action2 = CCSpawn:create(ccArrayMake(scaleTo_2, fadeTo_2))
    local action = CCSequence:create(ccArrayMake(action1, action2))
    self.ui.btn_update_boat:runAction(CCRepeatForever:create(action))
  end
  local spine = ed.createSpine("effect/eff_UI_DragonBoat_zongzi/eff_UI_DragonBoat_zongzi", 0.5)
  spine:setAnimation(0, "Idle", true)
  self.ui.zongzi_pos:addChild(spine)
  self.spine = spine
  if self.boatLevel == 3 and self.have then
    self.spine:setAnimation(0, "Idle2", true)
  end
  local levelUpSpine = ed.createSpine("effect/eff_UI_DragonBoat_LevelUP/eff_UI_DragonBoat_LevelUP", 0.5)
  self.ui.levelup_pos:addChild(levelUpSpine)
  levelUpSpine:setVisible(false)
  self.levelUpSpine = levelUpSpine
  self.ui.arrow_left:setVisible(self.boatLevel > 1)
  self.ui.arrow_right:setVisible(3 > self.boatLevel and 0 < self.boatLevel)
  self.ui.arrow_left:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCMoveBy:create(0.7, ccp(-10, 0)), CCMoveBy:create(0.7, ccp(10, 0)))))
  self.ui.arrow_right:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCMoveBy:create(0.7, ccp(10, 0)), CCMoveBy:create(0.7, ccp(-10, 0)))))
end

function class:refreshUI()
  self.conf = boatUIConfig["upgrade" .. self.boatLevel]
  ed.setTexture(self.ui.boat_bg, self.conf.boatRes)
  if self.boatLevel == 0 then
    local spine = ed.createSpine("effect/eff_UI_DragonBoat_get/eff_UI_DragonBoat_get", 0.8)
    spine:setAnimation(0, "Idle", true)
    ed.UITool.setPositionBy(spine, ccp(0, -80))
    self.ui.levelup_pos:addChild(spine)
  end
  self:refreshLabel()
  local isUpdate = self.boatLevel > 0 and self.boatLevel < 3
  self.ui.btn_back:setVisible(self.boatLevel > 0)
end

function class:refreshLabel()
  local mgr = ed.dragonBoatMgr.getInstance()
  local butTxt
  if self.boatLevel < (mgr.skin or 0) + 1 and self.boatLevel ~= 0 then
    ed.setTexture(self.ui.btn_update_boat, "UI/alpha/1080P/dragonboat/db_boat/db_bottom.png")
    self.have = true
  elseif self.boatLevel > (mgr.skin or 0) + 1 then
    ed.setTexture(self.ui.btn_update_boat, "UI/alpha/1080P/dragonboat/db_boat/db_bottom.png")
  end
  self.notCanUpgrade = (self.boatLevel == 0 and 1 or self.boatLevel) ~= (mgr.skin or 0) + 1
  local skinTbl = ed.getDataTable("DragonBoatSkin")[self.boatLevel == 0 and 1 or self.boatLevel]
  self.ui.boat_name_pos:removeAllChildrenWithCleanup(true)
  local name = ed.ui.gradientLabel.create({
    text = skinTbl.BoatName,
    fontSize = 39,
    fontName = ed.fontBold,
    startColor = self.conf.nameColor1,
    endColor = self.conf.nameColor2,
    strokeSize = 3,
    strokeColor = ed.toccc3(16775654)
  })
  self.ui.boat_name_pos:addChild(name.node)
  self.ui.btn_update_boat:removeAllChildrenWithCleanup(true)
  if self.boatLevel == 3 and (mgr.skin or 0) == 3 and self.have then
    self.ui.btn_update_boat:setVisible(false)
    self.ui.label_owned:setVisible(false)
    self.ui.line_left:setVisible(false)
    self.ui.line_right:setVisible(false)
    local x, y = self.ui.btn_update_boat:getPosition()
    local bottom = ed.createSpriteTools({
      res = "UI/alpha/1080P/dragonboat/db_boat/max_level_bottom.png",
      parent = self.ui.btn_update_boat:getParent(),
      pos = ccp(x, y)
    })
    ed.layout.centerInParent(ed.createLabelTools({
      txt = T("\230\156\128\229\164\167\231\173\137\231\186\167"),
      size = 23,
      color = ed.toccc3(16771979),
      parent = bottom,
      stroke = {
        ccc3(ed.colorToStr("#7c271a")),
        2
      }
    }))
    self.ui.bottomMax = bottom
    ed.UITool.registerBtn(self, "bottomMax", function()
      ed.showToast(T("\229\183\178\232\190\190\230\156\128\233\171\152\231\186\167"))
    end, {normalScale = 1, pressScale = 0.95})
  elseif skinTbl then
    self.ui.btn_update_boat:setVisible(not self.have)
    self.ui.label_owned:setVisible(self.have)
    self.ui.line_left:setVisible(self.have)
    self.ui.line_right:setVisible(self.have)
    local upgradeCostType = skinTbl["Price Type"]
    local upgradePrice = skinTbl.Price
    self.upgradeCostType = upgradeCostType
    self.upgradePrice = upgradePrice
    local btn_node
    if upgradeCostType == "Free" then
      local btn_label = ed.ui.gradientLabel.create({
        text = butTxt and butTxt or T("\233\162\134\229\143\150\232\136\185\229\143\170"),
        fontSize = 32,
        startColor = self.notCanUpgrade and ed.toccc3(14670034) or ed.toccc3(16775901),
        endColor = self.notCanUpgrade and ed.toccc3(12431009) or ed.toccc3(16774308),
        strokeSize = 2,
        strokeColor = self.notCanUpgrade and ed.toccc3(6311755) or ed.toccc3(11748623)
      })
      btn_node = btn_label.node
      ed.setLabelString(self.ui.label_owned, T("\229\183\178\230\139\165\230\156\137"))
    elseif upgradeCostType == "Diamond" then
      btn_node = CCNode:create()
      local btn_label = ed.ui.gradientLabel.create({
        text = butTxt and butTxt or T("%s\229\141\135\231\186\167", upgradePrice),
        fontSize = 32,
        startColor = self.notCanUpgrade and ed.toccc3(14670034) or ed.toccc3(16775901),
        endColor = self.notCanUpgrade and ed.toccc3(12431009) or ed.toccc3(16774308),
        strokeSize = 2,
        strokeColor = self.notCanUpgrade and ed.toccc3(6311755) or ed.toccc3(11748623)
      })
      btn_node:addChild(btn_label.node)
      if not butTxt then
        local icon = ed.createSprite("UI/alpha/1080P/icon/diamond.png")
        btn_node:addChild(icon)
        local totalWid = icon:getContentSize().width + btn_label.node:getContentSize().width
        local scale = math.min(1, 180 / totalWid)
        icon:setScale(scale)
        btn_label.node:setScale(scale)
        ed.layout.horizontalSortNode({
          icon,
          btn_label.node
        }, {0, 0}, 0)
      end
      self.btnTxt = T("%s\229\141\135\231\186\167", upgradePrice)
      self.isDiamond = true
      ed.setLabelString(self.ui.label_owned, T("\229\183\178\229\141\135\231\186\167"))
    elseif upgradeCostType == "Gift Ticket" then
      local btn_label = ed.ui.gradientLabel.create({
        text = butTxt and butTxt or T("%s\229\141\135\231\186\167", ed.RechargeManager:getCostDisplayByCNYCost(upgradePrice)),
        fontSize = 32,
        startColor = self.notCanUpgrade and ed.toccc3(14670034) or ed.toccc3(16775901),
        endColor = self.notCanUpgrade and ed.toccc3(12431009) or ed.toccc3(16774308),
        strokeSize = 2,
        strokeColor = self.notCanUpgrade and ed.toccc3(6311755) or ed.toccc3(11748623)
      })
      btn_node = btn_label.node
      self.btnTxt = T("%s\229\141\135\231\186\167", ed.RechargeManager:getCostDisplayByCNYCost(upgradePrice))
      self.isDiamond = false
      if not self.have then
        local dialogue = ed.createScale9Sprite("UI/alpha/1080P/dragonboat/db_boat/db_extra_reward.png", CCRectMake(60, 15, 20, 5))
        local oriSize = dialogue:getContentSize()
        self.ui.btn_update_boat:addChild(dialogue)
        dialogue:setPosition(ccp(222, 67))
        local tipLab = ed.createLabelTools({
          txt = T("\232\180\173\228\185\176\229\144\142\233\162\157\229\164\150\232\142\183\229\190\1511980"),
          size = 14,
          pos = ccp(74.75, 18.5),
          color = ed.toccc3(8609069),
          parent = dialogue
        })
        local tipDiamond = ed.createSpriteTools({
          res = "UI/alpha/1080P/icon/diamond.png",
          parent = dialogue,
          pos = ccp(149.5, 19.5),
          scale = 0.8
        })
        local totalWid = tipLab:getContentSize().width + tipDiamond:getContentSize().width
        local newWid = math.max(oriSize.width, totalWid)
        dialogue:setContentSize(CCSizeMake(newWid, oriSize.height))
        ed.layout.horizontalSortNode({tipLab, tipDiamond}, {0, 0}, newWid * 0.5)
      end
    end
    self.ui.btn_update_boat:addChild(btn_node)
    ed.layout.centerInParent(btn_node)
    btn_node:setScale(math.min(1, 180 / btn_node:getContentSize().width))
  end
  if self.boatLevel == 0 then
    ed.setLabelString(self.ui.label_speed, T("\232\136\170\233\128\159:%s\229\176\186/\230\151\182", ed.getDataTable("DragonBoatSkin")[1].Speed))
  else
    ed.setLabelString(self.ui.label_speed, T("\232\136\170\233\128\159:%s\229\176\186/\230\151\182", ed.getDataTable("DragonBoatSkin")[self.boatLevel].Speed))
  end
  if (mgr.skin or 0) + 1 == self.boatLevel and not self.have then
    ed.dragonBoatNet:sendQueryAddFeet()
  end
end

function class:onQueryAddFeet(data)
  local addFeet = data._add_feet
  local mgr = ed.dragonBoatMgr.getInstance()
  if (mgr.skin or 0) + 1 == self.boatLevel and not self.have then
    ed.setLabelString(self.progressStr, T("\229\141\135\231\186\167\229\144\142\239\188\140\232\183\157\231\166\187\230\180\187\229\138\168\231\187\147\230\157\159\229\143\175\229\164\154\232\183\145%s\229\176\186", addFeet))
    self.ui.img_dialog:setContentSize(CCSizeMake(self.progressStr:getContentSize().width + 90, self.ui.img_dialog:getContentSize().height))
    self.progressStr:setPosition(ccp(self.progressStr:getContentSize().width * 0.5 + 45, 40))
    self.ui.img_dialog:setOpacity(255)
    self.progressStr:setOpacity(255)
    ListenTimer(Timer:Once(2), function()
      self.ui.img_dialog:runAction(CCFadeTo:create(1, 0))
      self.progressStr:runAction(CCFadeTo:create(1, 0))
    end, self.upgradeScope)
  end
end

function class:registerEvent()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:closeWindow()
  end, {normalScale = 1, pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_update_boat", function()
    if self.have then
      ed.showToast(T("\229\183\178\230\139\165\230\156\137"))
      return
    end
    if self.notCanUpgrade then
      ed.showToast(T("\233\156\128\229\141\135\231\186\167\232\135\179\231\142\132\233\190\153\232\136\159\229\144\142\232\167\163\233\148\129"))
      return
    end
    local mgr = ed.dragonBoatMgr.getInstance()
    if self.boatLevel == 0 then
      ed.dragonBoatNet.getInstance():sendStart()
      self:closeWindow()
    elseif (mgr.skin or 0) == 3 then
      ed.showToast(T("\229\183\178\232\190\190\230\156\128\233\171\152\231\186\167"))
    else
      self:onBtnLevelup()
    end
  end, {normalScale = 1, pressScale = 0.95})
  ed.UITool.registerBtn(self, "arrow_left", function()
    CloseScope(self.upgradeScope)
    self:destroy({skipAnim = true})
    ed.ui.dragonBoatBoatPop.create({
      boatLevel = self.boatLevel - 1
    }):popWindow()
  end)
  ed.UITool.registerBtn(self, "arrow_right", function()
    CloseScope(self.upgradeScope)
    self:destroy({skipAnim = true})
    ed.ui.dragonBoatBoatPop.create({
      boatLevel = self.boatLevel + 1
    }):popWindow()
  end)
  self:listenEvent("dragonBoatUpgrade", function(skin)
    self:doUpgrade(skin)
  end)
  self:listenEvent("DragonBoatQueryAddFeet", function(data)
    self:onQueryAddFeet(data)
  end)
end

function class:onBtnLevelup()
  ed.dragonBoatMgr.getInstance():doRechargeBoatUpgrade(self.upgradeCostType, self.upgradePrice, self.boatLevel)
end

function class:doUpgrade(skin)
  local oldLv = self.boatLevel - 1
  oldLv = oldLv < 0 and 1 or oldLv
  local conf = boatUIConfig["upgrade" .. oldLv]
  ed.setTexture(self.ui.boat_bg, conf.transBoatRes or conf.boatRes)
  if self.upgradeCostType == "Diamond" then
    ed.player:addrmb(-self.upgradePrice)
  else
    FireEvent("QueryDataRsp")
  end
  self.boatLevel = skin
  CloseScope(self.upgradeScope)
  self.levelUpSpine:setAnimation(0, "Idle", true)
  self.levelUpSpine:setVisible(true)
  ListenTimer(Timer:Once(1.8333333333333333), function()
    self:refreshUI()
    self.spine:setAnimation(0, "Idle2", true)
  end, self.upgradeScope)
  ListenTimer(Timer:Once(4), function()
    self.levelUpSpine:setAnimation(0, "Idle2", true)
  end, self.upgradeScope)
end

function class:closeWindow()
  CloseScope(self.upgradeScope)
  self:destroy()
end
