local autoTextConfig = {}
autoTextConfig.__index = autoTextConfig
ed.ui.autoTextConfig = autoTextConfig
ed.ui.autoTextConfig.Color_Style = {
  black = ccc3(0, 0, 0),
  green = ccc3(0, 255, 0),
  blue = ccc3(0, 0, 255),
  red = ccc3(240, 30, 30),
  white = ccc3(255, 255, 255),
  hightlight = ccc3(169, 91, 28),
  mailTitle = ccc3(169, 91, 28),
  mailContent = ccc3(255, 252, 231),
  headlineBlue = ccc3(1, 160, 234),
  headlineGreen = ccc3(124, 254, 101),
  headlineYellow = ccc3(250, 206, 55),
  headlinePurple = ccc3(230, 91, 252),
  tipColorLight = ccc3(138, 56, 1),
  chatName = ccc3(241, 193, 113),
  chatContent = ccc3(255, 234, 198),
  headlineOrange = ccc3(254, 151, 69),
  tradingLineText = ccc3(51, 165, 159),
  defaultColor = ccc3(240, 224, 193),
  headlineRed = ccc3(255, 34, 34),
  mailRed = ccc3(184, 55, 63),
  summonRed = ccc3(255, 108, 108),
  peakSummary = ccc3(112, 255, 84),
  summonYellow = ccc3(232, 177, 82),
  activityPurple = ccc3(197, 179, 255),
  chatEntranceMsgName = ccc3(245, 221, 183),
  chatEntranceMsgGreen = ccc3(112, 225, 84),
  chatEntranceMsgContent = ccc3(255, 252, 231),
  skillup = ccc3(200, 100, 190),
  skillm = ccc3(127, 255, 170),
  ad = ccc3(248, 141, 36),
  ap = ccc3(88, 140, 247),
  holy = ccc3(255, 215, 0),
  arm = ccc3(247, 236, 117),
  mr = ccc3(222, 102, 230),
  hp = ccc3(239, 78, 28),
  hit = ccc3(220, 120, 0),
  dodg = ccc3(152, 252, 152),
  mdodg = ccc3(200, 102, 220),
  mp = ccc3(99, 219, 203),
  crit = ccc3(241, 48, 48),
  mcrit = ccc3(200, 100, 200),
  hpr = ccc3(254, 211, 109),
  hast = ccc3(237, 210, 30),
  heal = ccc3(0, 255, 127),
  str = ccc3(255, 63, 63),
  int = ccc3(68, 182, 255),
  agi = ccc3(116, 255, 62),
  res = ccc3(173, 216, 230),
  ice = ccc3(135, 206, 250),
  fire = ccc3(255, 70, 20),
  lightning = ccc3(147, 112, 219),
  onlineStr1 = ccc3(242, 235, 212),
  onlineStr2 = ccc3(85, 64, 39),
  strokeColor1 = ccc3(32, 31, 28),
  strokeColor2 = ccc3(255, 255, 255),
  rankStrokeColor1 = ccc3(61, 57, 53),
  rankStrokeColor2 = ccc3(245, 246, 250),
  dreamRewardPopgreen = ccc3(156, 243, 104),
  guildClashGrading1 = ccc3(255, 246, 209),
  guildClashGrading2 = ccc3(51, 41, 32),
  guildClashGuide = ccc3(218, 130, 27),
  fundPassNumber = ccc3(107, 84, 223),
  fundStrokeColor = ccc3(189, 240, 255),
  serverDayTitle = ed.toccc3(14711556),
  timelySummary1 = ed.toccc3(15434792),
  timelySummary2 = ed.toccc3(14046112),
  destinyStrokeColor = ed.toccc3(2368548),
  forgingRecordStrokeColor = ed.toccc3(4854547),
  forgingRecordHighStrokeColor = ed.toccc3(11357460),
  guildMountRankTab1StrokeColor1 = ed.toccc3(34, 27, 56),
  guildMountRankTab1StrokeColor2 = ed.toccc3(25, 22, 33),
  guildMountRankTab2StrokeColor1 = ed.toccc3(37, 34, 45),
  guildMountRankTab2StrokeColor2 = ed.toccc3(37, 34, 45),
  topArenaTeamStrokeColor1 = ccc3(204, 112, 22),
  topArenaTeamStrokeColor2 = ccc3(59, 94, 174),
  topArenaTeamStrokeColor3 = ccc3(184, 63, 43),
  heroRecycleColor1 = ccc3(255, 165, 49),
  heroRecycleColor2 = ccc3(248, 230, 159),
  mailLinkColor = ccc3(255, 133, 67),
  card = ccc3(137, 95, 64),
  power = ccc3(174, 114, 18),
  creviceStrokeColor = ed.toccc3(3744789),
  creviceMainStrokeColor = ed.toccc3(8388611),
  creviceMainTitleStrokeColor = ed.toccc3(3543048),
  creviceHeadlineOrangeColor = ed.toccc3(1519903),
  creviceHeadlineGreenColor = ed.toccc3(7405396),
  solocard1 = ccc3(255, 198, 120),
  solocard2 = ccc3(177, 249, 255),
  solocard3 = ccc3(255, 249, 131),
  soloDrug = ccc3(0, 128, 0),
  soloShield = ccc3(240, 123, 76),
  soloHaste = ccc3(59, 205, 193),
  soloWeak = ccc3(201, 52, 24),
  sologold = ccc3(255, 215, 0),
  solodamage = ccc3(255, 50, 50),
  soloheal = ccc3(50, 255, 50),
  solonumber = ccc3(100, 150, 255),
  solopercent = ccc3(255, 150, 100),
  solospecial = ccc3(200, 100, 255)
}
ed.ui.autoTextConfig.fontSize_Style = {
  f8 = 8,
  f9 = 9,
  f10 = 10,
  f11 = 11,
  f12 = 12,
  f13 = 13,
  f14 = 14,
  f15 = 15,
  f16 = 16,
  f17 = 17,
  f18 = 18,
  f19 = 19,
  f20 = 20,
  f21 = 21,
  f22 = 22,
  f23 = 23,
  f24 = 24,
  f25 = 25,
  f26 = 26,
  f27 = 27,
  f28 = 28,
  f29 = 29,
  f30 = 30,
  f31 = 31,
  f32 = 32,
  f33 = 33,
  f34 = 34,
  f35 = 35,
  f36 = 36,
  f37 = 37,
  f38 = 38,
  f39 = 39,
  f40 = 40,
  f41 = 41,
  f42 = 42
}

local function isChineseChar(char)
  local c1 = string.byte(char, 1)
  if 228 <= c1 and c1 <= 233 then
    local c2 = string.byte(char, 2)
    local c3 = string.byte(char, 3)
    if c2 and c3 and 128 <= c2 and c2 <= 191 and 128 <= c3 and c3 <= 191 then
      return true
    end
  end
  return false
end

local calcuLabel
local recordTab = {}
local chineseChar = string.char(229, 131, 181)

local function getStrWidth(str, fontSize, fontName)
  if nil == fontName then
    fontName = ed.font
  end
  local sizeTab = recordTab[fontName]
  if nil == sizeTab then
    sizeTab = {}
    recordTab[fontName] = sizeTab
  end
  local strTab = sizeTab[fontSize]
  if nil == strTab then
    strTab = {}
    sizeTab[fontSize] = strTab
  end
  if nil ~= strTab.totalNum and strTab.totalNum > 9999 then
    warn("====================getStrWidth is to large", strTab.totalNum)
    strTab = {}
  end
  if isChineseChar(str) then
    str = chineseChar
  end
  if nil == calcuLabel then
    calcuLabel = CCLabelTTF:create()
    calcuLabel:retain()
  end
  local size = strTab[str]
  if nil == size then
    calcuLabel:setFontSize(fontSize)
    calcuLabel:setFontName(fontName)
    calcuLabel:setString(str)
    size = {}
    strTab[str] = size
    local tmpSize = calcuLabel:getContentSize()
    size.width = tmpSize.width
    size.height = tmpSize.height
    strTab.totalNum = (strTab.totalNum or 0) + 1
  end
  return size
end

ed.ui.autoTextConfig.getStrWidth = getStrWidth
