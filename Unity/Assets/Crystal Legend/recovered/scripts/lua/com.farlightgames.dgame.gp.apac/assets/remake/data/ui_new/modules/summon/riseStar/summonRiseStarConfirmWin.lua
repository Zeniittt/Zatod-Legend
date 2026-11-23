local base = ed.ui.popwindow
local summonRiseStarConfirmWin = newclass(base.mt)
ed.ui.summonRiseStarConfirmWin = summonRiseStarConfirmWin
ed.ui.summonRiseStarRule = {}
ed.ui.summonRiseStarRule.strPage2 = T("<sprite src=UI/alpha/1080P/common/rivet_big.png><lable color=summonYellow>\229\189\147\233\152\159\233\149\191\232\190\190\229\136\17670\231\186\167\230\151\182</lable>\239\188\140\229\176\134\229\188\128\229\144\175\230\152\159\232\190\137\233\153\144\230\151\182\229\143\172\229\148\164\239\188\140\229\138\169\229\138\155\233\152\159\233\149\191\232\142\183\229\190\151\228\184\137\230\152\159\232\139\177\233\155\132\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\156\168\230\152\159\232\190\137\233\153\144\230\151\182\229\143\172\229\148\164\228\184\173\239\188\140\233\152\159\233\149\191\229\143\175\228\187\165<lable color=summonYellow>\230\140\135\229\174\154\228\184\128\229\144\141\228\184\137\230\152\159\232\139\177\233\155\132\232\191\155\232\161\140\230\166\130\231\142\135\230\143\144\229\141\135</lable>\239\188\140\229\185\182\228\189\191\231\148\168<lable color=summonRed>\229\143\172\229\148\164\229\136\184</lable>\232\191\155\232\161\140\229\143\172\229\148\164\227\128\130\230\152\159\232\190\137\233\153\144\230\151\182\229\143\172\229\148\164\228\184\173\229\133\182\228\189\153\229\134\133\229\174\185\229\146\140\230\166\130\231\142\135\229\157\135\228\184\142\232\139\177\233\155\132\229\143\172\229\148\164\228\191\157\230\140\129\228\184\128\232\135\180\227\128\130<br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\175\143\232\191\155\232\161\140<lable color=summonRed>80\230\172\161</lable>\229\143\172\229\148\164\239\188\140\229\176\134\232\135\179\229\176\145\232\142\183\229\190\151\228\184\128\229\144\141<lable color=summonYellow>\229\136\157\229\167\1393\230\152\159\232\139\177\233\155\132</lable>\239\188\140\228\184\148\230\156\137<lable color=summonRed>50%</lable>\231\154\132\230\166\130\231\142\135\228\184\186<lable color=summonRed>\230\140\135\229\174\154\232\139\177\233\155\132</lable>\227\128\130\232\139\165\229\156\168\232\142\183\229\143\150\229\136\157\229\167\1393\230\152\159\232\139\177\233\155\132\230\151\182\228\184\141\228\184\186\230\140\135\229\174\154\232\139\177\233\155\132\239\188\140\229\136\153<lable color=summonYellow>\228\184\139\228\184\128\230\172\161\232\142\183\229\143\150\229\136\157\229\167\1393\230\152\159\232\139\177\233\155\132\230\151\182\229\191\133\228\184\186\230\140\135\229\174\154\232\139\177\233\155\132</lable>\227\128\130<br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\156\168\230\152\159\232\190\137\233\153\144\230\151\182\229\143\172\229\148\164\228\184\173\239\188\140<lable color=summonRed>\233\166\150\230\172\161\231\180\175\231\167\175\229\143\172\229\148\164\230\187\16180\230\172\161</lable>\230\151\182\239\188\140\229\143\175\228\187\165<lable color=summonRed>\233\162\157\229\164\150\232\142\183\229\190\151</lable>1\229\188\160\230\140\135\229\174\154\232\139\177\233\155\132\230\149\180\229\141\161\239\188\140\232\139\165\229\156\168\230\173\164\229\137\141\229\183\178\231\187\143\232\142\183\229\190\151\232\175\165\232\139\177\233\155\132\239\188\140\229\136\153\229\176\134\232\189\172\230\141\162\228\184\186\232\175\165\232\139\177\233\155\132\231\129\181\233\173\130\231\159\179*80\227\128\130<br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\152\159\232\190\137\233\153\144\230\151\182\229\143\172\229\148\164\228\184\173\230\156\170\229\143\172\229\148\164\229\135\186<lable color=summonYellow>\229\136\157\229\167\139\228\184\137\230\152\159\232\139\177\233\155\132</lable>\229\146\140\230\156\170\229\143\172\229\148\164\229\135\186<lable color=summonYellow>\230\140\135\229\174\154\232\139\177\233\155\132</lable>\231\154\132\230\172\161\230\149\176\229\176\134<lable color=summonRed>\231\139\172\231\171\139\231\180\175\232\174\161</lable>\239\188\140\228\184\141\228\188\154\232\174\161\229\133\165\229\133\182\228\187\150\229\143\172\229\148\164\229\138\159\232\131\189\228\184\173\227\128\130<br/>")

function summonRiseStarConfirmWin.create(param)
  local self = base.create("summonRiseStarConfirmWin")
  setmetatable(self, summonRiseStarConfirmWin.mt)
  self:init(param)
  self:popWindow()
  return self
end

function summonRiseStarConfirmWin:init(param)
  param = param or {}
  self.destroyCallback = param.destroyCallback
  self.time = param.time or 10
  self.tid = param.tid
  self:initView()
  self:addEventListener()
end

function summonRiseStarConfirmWin:addEventListener()
  self:listenTimer(Timer:Always(1), function()
    self.time = self.time - 1
    if self.time > 0 then
      ed.setString(self.ui.label_ok, string.format(T("\231\161\174\232\174\164(%ds)"), self.time))
    else
      self.ui.btn_ok:setVisible(true)
      self.ui.btn_ok_Copy0:setVisible(false)
    end
  end)
  ed.UITool.registerBtn(self, "btn_cancel", function()
    self:destroy()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_ok", function()
    if self.time <= 0 then
      ed.summonNet:send("switch_wish", {
        _hero_id = self.tid,
        _summon_type = "rise_star"
      })
    end
  end, {pressScale = 0.9})
  self:listenEvent("SummonSwitchWish", function(success)
    if success then
      ed.summonMgr.rise_starHeroId = self.tid
      FireEvent("EventSummonRiseStarSelectSuccess", success)
      self:destroy({skipAnim = true})
    end
  end)
end

function summonRiseStarConfirmWin:initView()
  ed.editorui(ed.uieditor.summonRiseStarConfirmWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self.puppet, self.cha = ed.readhero.getActor(self.tid, "Idle")
  self:addFca(self.puppet)
  ed.UITool.replaceUINew(self.ui, "hero", self.puppet)
  ed.setString(self.ui.name, ed.lookupDataTable("Unit", "Display Name", self.tid))
  self.ui.label_hot:setString(ed.hothero.manager:getHeroHot(self.tid))
  local fca = ed.createFcaNode("eff_UI_SummonBeginner_HeroChoose")
  self.ui.bg_hero:addChild(fca)
  fca:setPosition(ccp(115, 99))
  self:addFca(fca)
  if self.time > 0 then
    ed.setString(self.ui.label_ok, string.format(T("\231\161\174\232\174\164(%ds)"), self.time))
  else
    self.ui.btn_ok:setVisible(true)
    self.ui.btn_ok_Copy0:setVisible(false)
  end
end

function summonRiseStarConfirmWin:initLabels()
  local tip_label = T("<lable color=ccc3(255,233,248) strokeColor=ccc3(111,45,112) strokeSize=1>\233\128\137\229\174\154\229\144\142\229\176\134</lable>\230\151\160\230\179\149\228\191\174\230\148\185")
  local atText = ed.ui.autoText.new()
  atText:initParam({
    context = tip_label,
    fontSize = 18,
    color = ccc3(255, 0, 4)
  })
  self.ui.ImageView_739:addChild(atText.node)
  ed.layout.centerInParent(atText.node)
  local wid, _ = atText:getCurContentSize()
  atText.node:setPositionX(atText.node:getPositionX() - wid * 0.5)
  ed.setLabelStroke(self.ui.label_cancel, ed.toccc3(4925829), 1)
  ed.setLabelStroke(self.ui.label_ok1, ed.toccc3(4925829), 1)
  ed.setLabelStroke(self.ui.label_ok, ed.toccc3(5720177), 1)
  ed.setLabelStroke(self.ui.label_hot, ed.toccc3(7353983), 1)
  self.ui.name:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.name, ed.toccc3(8344356), 1)
end
