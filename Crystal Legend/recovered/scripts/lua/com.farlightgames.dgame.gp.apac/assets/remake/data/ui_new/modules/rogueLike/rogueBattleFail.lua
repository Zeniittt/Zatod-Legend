local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.rogueBattleFail = class
local lsr = ed.ui.stagedonelsr.create()
ed.UITool.registViewOpenFunc("rogueBattleFail", function(param)
  ed.ui.rogueBattleFail.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("rogueBattleFail")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.heroInfos = param.heroInfos or {}
  self.stageId = param.stageId
  self.results = param.results or {}
  self.showEndFailTips = param.showEndFailTips or false
  self.rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  self.canBattle = self.rogueLikeMgr:getCanBattle()
  self.retryTimes = self.rogueLikeMgr:getRetryTimes()
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
  self:show()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueBattleFail)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  self:initHeroList()
  self:initEffect()
  self.ui.label_end_fail_tips:setVisible(self.showEndFailTips)
  ed.setLabelString(self.ui.label_again, T("\233\135\141\232\175\149"))
  if self.retryTimes <= 0 or not self.canBattle then
    ed.setSpriteGray(self.ui.btn_again)
  end
  if #self.heroInfos == 0 then
    self.ui.btn_data:setVisible(false)
  end
end

function class:initLabels()
end

function class:initHeroList()
  local panelSize = self.ui.heroLayer:getContentSize()
  local width = 40
  for index, heroData in ipairs(self.heroInfos) do
    local heroId = heroData._heroid
    local hero = ed.player:getHero(heroId)
    local heroIcon = ed.readhero.createIcon({
      id = hero._tid,
      rank = hero._rank,
      hp = heroData._hp_perc,
      mp = heroData._mp_perc,
      level = hero._level,
      stars = hero._stars,
      fashion_id = hero._fashion,
      summary = hero
    })
    self.ui.heroLayer:addChild(heroIcon.icon)
    heroIcon.icon:setPosition(ccp(width, panelSize.height / 2))
    width = width + 100
  end
end

function class:initEffect()
  local sprite
  if ed.isAreaZhCn() then
    sprite = ed.createFcaNode("eff_UI_battleresult_fail")
    self:addFca(sprite)
  else
    sprite = ed.createSprite("UI/alpha/1080P/battleresult/battleresult_fail.png")
  end
  sprite:setPosition(ccp(self.ui.image_bg:getContentSize().width / 2, self.ui.image_bg:getContentSize().height + 38 + 17 / ed.display.scaleFactor))
  self.ui.title = sprite
  self.ui.image_bg:addChild(sprite)
  sprite = ed.createFcaNode("eff_UI_pve_fail_wings")
  self:addFca(sprite)
  sprite:setPosition(ccp(self.ui.image_bg:getContentSize().width / 2, self.ui.image_bg:getContentSize().height + 38 + 17 / ed.display.scaleFactor))
  self.ui.image_bg:addChild(sprite, -1)
end

function class:onClickBtnData()
  lsr:report("showBattleCount")
  ed.ui.BattleStaticsWin.create(ed.engine.unit_list, "common", true)
end

function class:onClickBtnAgain()
  if not self.canBattle or self.retryTimes == 0 then
    ed.showToast(T("\232\161\165\231\187\153\229\183\178\232\128\151\229\176\189"))
    return
  end
  ed.UITool.openView("rogueExitBattleTipsWindow", {
    content = T("\230\152\175\229\144\166\230\182\136\232\128\151\232\161\165\231\187\153\232\191\155\232\161\140\233\135\141\232\175\149\239\188\159\233\135\141\232\175\149\229\176\134\229\155\158\229\136\176\230\140\145\230\136\152\229\137\141\231\154\132\231\138\182\230\128\129"),
    extTips = string.format(T("\229\189\147\229\137\141\232\161\165\231\187\153\230\149\176\233\135\143\239\188\154<lable color=ccc3(255,165,49)>%s</lable>"), self.retryTimes),
    confirmCallBack = function()
      local curChapter = self.rogueLikeMgr:getCurChapter()
      if ed.getCurrentScene() and ed.getCurrentScene().identity == "battle" then
        ed.popScene()
      else
        self:destroy({skipAnim = true})
      end
      ed.UITool.openView("rogueBattlePrepare", {
        mode = "fight",
        stageId = self.stageId,
        destinyId = curChapter._destiny,
        chapterId = curChapter._chapter_id,
        difficulty = curChapter._difficulty
      })
    end
  })
end

function class:onClickBattleBack()
  if self.retryTimes > 0 then
    ed.UITool.openView("rogueExitBattleTipsWindow", {
      content = T("\230\130\168\232\191\152\230\156\137\229\143\175\233\135\141\232\175\149\230\172\161\230\149\176\239\188\140<lable color=ccc3(255,108,108)>\233\128\128\229\135\186\229\176\134\231\187\147\230\157\159\230\156\172\230\172\161\230\184\184\231\142\169\239\188\140</lable>\230\152\175\229\144\166\231\161\174\229\174\154\233\128\128\229\135\186\239\188\159"),
      confirmCallBack = function()
        ed.rogueLikeNet.sendEndChapter()
        if ed.getCurrentScene() and ed.getCurrentScene().identity == "battle" then
          ed.popScene()
        else
          self:destroy({skipAnim = true})
        end
      end
    })
  else
    ed.rogueLikeNet.sendEndChapter()
    if ed.getCurrentScene() and ed.getCurrentScene().identity == "battle" then
      ed.popScene()
    else
      self:destroy({skipAnim = true})
    end
  end
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:onClickBattleBack()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_again", function()
    self:onClickBtnAgain()
  end, {pressScale = 0.95, press = nil})
  ed.UITool.registerBtn(self, "btn_data", function()
    self:onClickBtnData()
  end, {pressScale = 0.95})
end

function class:addEventListener()
end
