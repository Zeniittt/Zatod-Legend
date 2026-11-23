local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.AutoChessRaceDetailWin = class
local ColorParam = ed.AutoChessDefine.ColorParam
local ColorStrokeParam = ed.AutoChessDefine.ColorStrokeParam
local BaseParam = ed.AutoChessDefine.BaseParam
local LightParam = ed.AutoChessDefine.LightParam
local RARE = {
  T("\230\153\174\233\128\154"),
  T("\231\168\128\230\156\137"),
  T("\231\189\149\232\167\129"),
  T("\229\143\178\232\175\151"),
  T("\228\188\160\232\175\180")
}

function class:initData(heroData)
  self.heroData = heroData
  self.selectStar = 1
  self.heroTags = {}
end

function class:initHead()
  local heroIcon = ed.readhero.createChessIcon({
    id = self.heroData.hid
  })
  self.ui.node_head:addChild(heroIcon.icon)
  ed.layout.centerInParent(heroIcon.icon)
  local name = ed.getDataTable("ChessUnit")[self.heroData.hid]["Display Name"]
  ed.setString(self.ui.label_hero_name, name)
  local price = ed.getChessUnitBuyPrice(self.heroData.hid)
  ed.setLabelColor(self.ui.label_hero_name, ColorParam["color_" .. price])
  ed.setLabelStroke(self.ui.label_hero_name, ColorStrokeParam["color_" .. price], 1)
  ed.setString(self.ui.label_price, price)
  local tagNode = self.ui.node_tag
  local raceTags = ed.getChessUnitRaceTags(self.heroData.hid)
  local offsetX = 0
  local scale = 0.8
  for _, tag in pairs(raceTags) do
    local tagConfig = ed.AutoChessModel:getTagNumByType(tag)
    local tagData = ed.getDataTable("ChessTags")[tag]
    local tagSprite = ed.createSprite(tagData.Sign)
    local tagSize = tagSprite:getContentSize()
    tagSprite:setAnchorPoint(ccp(0, 0))
    tagSprite:setPosition(ccp(offsetX, -8))
    tagSprite:setScale(scale)
    tagNode:addChild(tagSprite)
    offsetX = offsetX + tagSize.width * scale
    table.insert(self.heroTags, {
      tagIcon = tagSprite,
      tagData = {
        tag = tag,
        num = 0,
        level = 0,
        target = #tagConfig
      }
    })
  end
  local abilityTags = ed.getChessUnitAbilityTags(self.heroData.hid)
  for _, tag in pairs(abilityTags) do
    local tagConfig = ed.AutoChessModel:getTagNumByType(tag)
    local tagData = ed.getDataTable("ChessTags")[tag]
    local tagSprite = ed.createSprite(tagData.Sign)
    local tagSize = tagSprite:getContentSize()
    tagSprite:setAnchorPoint(ccp(0, 0))
    tagSprite:setPosition(ccp(offsetX, -8))
    tagSprite:setScale(scale)
    tagNode:addChild(tagSprite)
    offsetX = offsetX + tagSize.width * scale
    table.insert(self.heroTags, {
      tagIcon = tagSprite,
      tagData = {
        tag = tag,
        num = 0,
        level = 0,
        target = #tagConfig
      }
    })
  end
  ed.setString(self.ui.label_rare, RARE[price] or T("\230\153\174\233\128\154"))
  ed.setLabelColor(self.ui.label_rare, ColorParam["color_" .. price] or ccc3(255, 151, 70))
  self.ui.label_rare:setDimensions(CCSizeMake(50, 0))
  ed.right2(self.ui.label_rare, self.ui.label_rare_title, -4)
end

function class:resetClickStar()
  for i = 1, 3 do
    self.ui["btn_star" .. i .. "_selected"]:setVisible(false)
  end
end

function class:initAttr()
  local chessId = self.heroData.chessIds[self.selectStar]
  local info = ed.lookupDataTable("ChessUnit", nil, chessId)
  ed.setString(self.ui.label_attr_hp, info.HP)
  ed.setString(self.ui.label_attr_ad, info.AD)
  ed.setString(self.ui.label_attr_arm, info.ARM)
  ed.setString(self.ui.label_attr_crit, info.MR)
end

function class:initActor()
  local price = ed.getChessUnitBuyPrice(self.heroData.hid)
  ed.setTexture(self.ui.img_actor_base, BaseParam["base_" .. price])
  self.ui.node_actor:removeAllChildrenWithCleanup(true)
  local chessId = self.heroData.chessIds[self.selectStar]
  local actor = ed.readhero.getChessActor(chessId, "Idle")
  self.ui.node_actor:addChild(actor, 5)
  self:addFca(actor)
  local stars = ed.getChessUnitStar(chessId)
  local starNode = CCNode:create()
  local offsetX = 0
  for i = 1, stars do
    local star = ed.createSprite("UI/alpha/1080P/skilltower/detail_star.png")
    local starSize = star:getContentSize()
    star:setScale(1)
    star:setPositionX(offsetX)
    starNode:addChild(star)
    offsetX = offsetX + starSize.width
  end
  starNode:setPosition(ccp(15 - offsetX / 2, -23))
  self.ui.node_actor:addChild(starNode, 10)
end

function class:initSkill()
  local hid = self.heroData.chessIds[self.selectStar]
  local uinfo = ed.lookupDataTable("ChessUnit", nil, hid)
  local heroId = uinfo["Hero ID"]
  local skillGroupInfo = ed.lookupDataTable("ChessSkillGroup", nil, heroId)
  local skillId = skillGroupInfo[1].none["Skill Group ID"]
  local skillInfo = ed.lookupDataTable("ChessSkill", nil, skillId, 0) or {}
  local skillIcon = ed.readhero.createChessSkillIcon(heroId, 1)
  skillIcon:setPosition(ccp(45, 46))
  self.ui.node_skill:addChild(skillIcon)
  local skillDesc = self.ui.label_skill_desc
  ed.setString(skillDesc, skillInfo.Description)
  skillDesc:limitSizeByScale(200, 75)
end

function class:initPanel()
  self:initAttr()
  self:initActor()
  self:initSkill()
end

function class:onClickStar(index)
  self.selectStar = index
  self:resetClickStar()
  self.ui["btn_star" .. index .. "_selected"]:setVisible(true)
  self:initPanel()
end

function class:initUI()
  ed.editorui(ed.uieditor.AutoChessRaceDetail, {
    container = self.container,
    ui = self.ui
  })
  ed.setLabelColor(self.ui.label_price, ccc3(239, 212, 61))
  self.ui.label_hero_name:setFontName(ed.fontBold)
  self:initHead()
  self:onClickStar(self.selectStar)
end

function class:registerTouchEvents()
  for i = 1, 3 do
    ed.UITool.registerBtn(self, "btn_star" .. i, function()
      self:onClickStar(i)
    end)
  end
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy({skipAnim = true})
  end, {normalScale = 0.8, pressScale = 0.75})
  self:btRegisterHandler({
    key = "autochess_race_detail",
    handler = function(event, x, y)
      if event == "began" then
        for i, v in ipairs(self.heroTags) do
          if ed.containsPoint(v.tagIcon, x, y) then
            v.isPress = true
            return true
          end
        end
      elseif event == "ended" then
        for i, v in ipairs(self.heroTags) do
          if ed.containsPoint(v.tagIcon, x, y) and v.isPress then
            self:handlerClickHeroTag(i)
            v.isPress = false
            break
          end
        end
      end
    end,
    force = true,
    priority = 0
  })
end

function class:handlerClickHeroTag(i)
  local heroTag = self.heroTags[i]
  if heroTag then
    local isGuideFlag = ed.AutoChessTeachManager:isGuideFlag()
    if isGuideFlag then
      return
    end
    self:removeTagDetail()
    self.tagDetail = ed.ui.AutoChessTagPanel.createDetailTagPanel(heroTag.tagIcon, heroTag.tagData, ccp(150, 2))
  end
end

function class:removeTagDetail()
  if self.tagDetail and not tolua.isnull(self.tagDetail.container) then
    self.tagDetail:closeSelf()
    self.tagDetail = nil
  end
end

function class.create(heroData)
  local self = base.create("AutoChessRaceDetailWin")
  setmetatable(self, class.mt)
  self:initData(heroData)
  self:initUI()
  self:registerTouchEvents()
  return self
end
