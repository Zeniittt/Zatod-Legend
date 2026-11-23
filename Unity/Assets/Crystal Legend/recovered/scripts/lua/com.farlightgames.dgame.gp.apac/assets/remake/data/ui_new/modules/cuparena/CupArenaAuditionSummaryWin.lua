local base = ed.ui.popwindow
local CupArenaAuditionSummaryWin = newclass(base.mt)
ed.ui.CupArenaAuditionSummaryWin = CupArenaAuditionSummaryWin

function CupArenaAuditionSummaryWin:initLabels()
  ed.setLabelStroke(self.ui.label_camp_rank, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.label_camp_medal, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.label_stage_des, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.label_score, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.label_medal, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.label_audition_camp_rank, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.label_audition_rank, ed.toccc3(3087902), 1)
end

function CupArenaAuditionSummaryWin:initUI(data)
  ed.editorui(ed.uieditor.CupArenaAuditionSummaryWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  ed.setLabelString(self.ui.label_camp_rank, T("\233\152\181\232\144\165\230\142\146\229\144\141\239\188\154%d", data._camp_rank or 0))
  ed.setLabelString(self.ui.label_camp_medal, T("\230\128\187\229\139\139\231\171\160\239\188\154%d", data._camp_medal or 0))
  local gradeTableInfo = ed.CupArenaManager:getGradeInfoByScore(data._self_score or 0)
  ed.setTexture(self.ui.img_stage, gradeTableInfo.nameIconRes)
  ed.layout.horizontalSortNode({
    self.ui.label_stage_des,
    self.ui.img_stage
  }, {-11, 0}, self.ui.bg_stage:getContentSize().width * 0.5)
  ed.setLabelString(self.ui.label_score, T("\231\167\175\229\136\134\239\188\154%d", data._self_score or 0))
  ed.setLabelString(self.ui.label_medal, T("\229\139\139\231\171\160\239\188\154%d", data._self_medal or 0))
  ed.setLabelString(self.ui.label_audition_camp_rank, T("\230\181\183\233\128\137\233\152\181\232\144\165\230\142\146\229\144\141\239\188\154%d", data._audition_camp_rank or 0))
  ed.setLabelString(self.ui.label_audition_rank, T("\230\181\183\233\128\137\230\128\187\230\142\146\229\144\141\239\188\154%d", data._audition_rank or 0))
  ed.layout.horizontalSortNode({
    self.ui.label_medal,
    self.ui.img_my_medal
  }, {2, 0}, self.ui.bg_medal:getContentSize().width * 0.5)
  ed.layout.horizontalSortNode({
    self.ui.label_camp_medal,
    self.ui.img_camp_medal
  }, {2, 0}, self.ui.label_camp_medal:getPositionX(), 0)
  local titleLabel = ed.ui.gradientLabel.create({
    text = T("\230\181\183\233\128\137\232\181\155\230\158\156"),
    fontSize = 25,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16774858),
    endColor = ed.toccc3(16777215),
    strokeSize = 1,
    strokeColor = ed.toccc3(5197930)
  })
  self.ui.node_content:addChild(titleLabel.node)
  titleLabel.node:setPosition((self.ui.title_right:getPositionX() + self.ui.title_left:getPositionX()) * 0.5, self.ui.title_left:getPositionY())
  local campTableItem = ed.getDataTable("CupArenaCamp")[data._camp_id or 1]
  local campName = T("%s\233\152\181\232\144\165", campTableItem["Camp Name"])
  local nameLabel = ed.ui.gradientLabel.create({
    text = campName,
    fontSize = 25,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16772766),
    endColor = ed.toccc3(16777215),
    strokeSize = 1,
    strokeColor = ed.toccc3(15108181)
  })
  self.ui.bg_camp:addChild(nameLabel.node)
  local campBgSize = self.ui.bg_camp:getContentSize()
  nameLabel.node:setPosition(campBgSize.width * 0.5, campBgSize.height * 0.5 - 10)
  ed.setTexture(self.ui.img_camp_icon, campTableItem["Camp Symbol"])
  local isQualify = data._can_match == 1
  ed.setTexture(self.ui.bg, isQualify and "UI/alpha/1080P/cuparena/knockout/select_result_bg_qualify.png" or "UI/alpha/1080P/cuparena/knockout/select_result_bg_unqualify.png")
  ed.setTexture(self.ui.bg_qualify, isQualify and "UI/alpha/1080P/cuparena/knockout/select_result_notice_qualify.png" or "UI/alpha/1080P/cuparena/knockout/select_result_notice_unqualify.png")
  if isQualify then
    local qualifyBgSize = self.ui.bg_qualify:getContentSize()
    local qualifyTitleLabel = ed.ui.gradientLabel.create({
      text = T("\229\183\178\229\135\186\231\186\191"),
      fontSize = 24,
      fontName = ed.fontBold,
      startColor = ed.toccc3(16770652),
      endColor = ed.toccc3(16776154),
      strokeSize = 1,
      strokeColor = ed.toccc3(11423246)
    })
    self.ui.bg_qualify:addChild(qualifyTitleLabel.node)
    qualifyTitleLabel.node:setPosition(qualifyBgSize.width * 0.5, qualifyBgSize.height * 0.5 - 14)
    local desStr = T("\232\175\183\231\187\167\231\187\173\228\184\186 <lable fontSize=f20 fontName=fontBold color=empty startColor=0xffee9e endColor=0xffffff strokeColor=0xe68855 strokeSize=2 name=timeLabel whole=true>%s</lable> \231\154\132\232\141\163\232\128\128\232\128\140\230\136\152!", campName)
    local qualifyDesLabel = ed.ui.autoText.new()
    self.ui.bg_qualify:addChild(qualifyDesLabel.node)
    qualifyDesLabel:initParam({
      context = desStr,
      fontSize = 20,
      color = ccc3(255, 252, 231),
      strokeColor = ed.toccc3(3087902),
      strokeSize = 1,
      maxWidth = 9999
    })
    local desWidth, desHeight = qualifyDesLabel:getCurContentSize()
    qualifyDesLabel.node:setPosition((qualifyBgSize.width - desWidth) * 0.5, qualifyBgSize.height * 0.5 - 43)
  else
    local qualifyBgSize = self.ui.bg_qualify:getContentSize()
    local qualifyTitleLabel = ed.ui.gradientLabel.create({
      text = T("\230\156\170\229\135\186\231\186\191"),
      fontSize = 24,
      fontName = ed.fontBold,
      startColor = ed.toccc3(13882364),
      endColor = ed.toccc3(15659510),
      strokeSize = 1,
      strokeColor = ed.toccc3(4219059)
    })
    self.ui.bg_qualify:addChild(qualifyTitleLabel.node)
    qualifyTitleLabel.node:setPosition(qualifyBgSize.width * 0.5, qualifyBgSize.height * 0.5 - 14)
    local desStr = T("\230\130\168\229\143\175\229\143\130\228\184\142\231\171\158\231\140\156")
    local qualifyDesLabel = ed.ui.autoText.new()
    self.ui.bg_qualify:addChild(qualifyDesLabel.node)
    qualifyDesLabel:initParam({
      context = desStr,
      fontSize = 20,
      color = ccc3(255, 252, 231),
      strokeColor = ed.toccc3(3087902),
      strokeSize = 1
    })
    local desWidth, desHeight = qualifyDesLabel:getCurContentSize()
    qualifyDesLabel.node:setPosition((qualifyBgSize.width - desWidth) * 0.5, qualifyBgSize.height * 0.5 - 43)
  end
end

function CupArenaAuditionSummaryWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    clickHandler = function()
      self:destroy()
    end,
    key = "clickout"
  })
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy()
  end, {pressScale = 0.95})
end

function CupArenaAuditionSummaryWin:playShowAction()
  self.ui.bg:setScale(0.6)
  local scaleAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.1, 1.06), CCEaseOut:create(CCScaleTo:create(0.2, 1), 2))
  local fadeAction = CCSequence:createWithTwoActions(CCDelayTime:create(0.15), CCCallFunc:create(function()
  end))
  self.ui.bg:runAction(CCSpawn:create(ccArrayMake(scaleAction, fadeAction)))
  self.ui.btn_close:setOpacity(0)
  self.ui.btn_close:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.35), CCFadeIn:create(0.25)))
  ed.setCascadeOpacityEnabled(self.ui.node_content, true, true)
  self.ui.node_content:setOpacity(0)
  self.ui.node_content:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.1), CCFadeIn:create(0.25)))
end

function CupArenaAuditionSummaryWin.create(data)
  local self = base.create("CupArenaAuditionSummaryWin")
  setmetatable(self, CupArenaAuditionSummaryWin.mt)
  self:initUI(data)
  self:registerTouchHandlers()
  self:popWindow()
  self:playShowAction()
  return self
end
