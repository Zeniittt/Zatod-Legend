local base = ed.ui.basenode
local class = newclass(base.mt)
ed.ui.popwindow = class
setimplements(class, ed.guide.interface)
class.config = {
  SoloDataPanel = {
    touch_priority = -999,
    not_swallow = true,
    no_shade = true
  },
  equipboardofpackage = {
    touch_priority = -10,
    not_swallow = true,
    no_shade = true
  },
  rewardoffertaskpage = {
    touch_priority = -10,
    not_swallow = true,
    no_shade = true
  },
  rewardoffsetTaskpageHerolist = {
    touch_priority = -10,
    not_swallow = true,
    no_shade = true
  },
  usersummary = {touch_priority = -300, layer_opacity = 0},
  worldcup = {touch_priority = -130},
  maintask = {touch_priority = -130},
  dailytask = {touch_priority = -130},
  starshopbuywindow = {touch_priority = -130},
  herodetail = {touch_priority = -140},
  excavateteam = {touch_priority = -130},
  excavatehistory = {touch_priority = -130},
  excavateinvite = {touch_priority = -130},
  excavatecreate = {touch_priority = -130},
  springfutureact = {touch_priority = -130},
  eatexp = {touch_priority = -130},
  summonPractice = {touch_priority = -130},
  upgradeskill = {touch_priority = -130},
  finishupgrade = {touch_priority = -130},
  finishbook = {touch_priority = -130},
  warbuildingupgrade = {touch_priority = -130},
  warbuildingfinish = {touch_priority = -130},
  equipboardofsell = {touch_priority = -130},
  equipboardofbuy = {touch_priority = -130},
  decompose_upgrade = {touch_priority = -130},
  readexpexplain = {touch_priority = -130},
  rewardofferEnemyteam = {touch_priority = -130},
  rewardofferReadbook = {touch_priority = -130},
  monstersealdesc = {touch_priority = -130},
  guildwartactics = {touch_priority = -130},
  guildwartacticsinput = {touch_priority = -130},
  guildherochangeline = {touch_priority = -130},
  GuildRaidDamageRanklistWin = {touch_priority = -100},
  magicschoolbranch = {touch_priority = -151},
  herodetailskill = {
    touch_priority = -140,
    not_swallow = true,
    no_shade = true
  },
  herodetailcard = {
    touch_priority = -140,
    not_swallow = true,
    no_shade = true
  },
  herodetailatt = {
    touch_priority = -140,
    not_swallow = true,
    no_shade = true
  },
  evolveequip = {
    touch_priority = -140,
    not_swallow = true,
    no_shade = true
  },
  herodetailbook = {
    touch_priority = -140,
    not_swallow = true,
    no_shade = true
  },
  herodetailRune = {
    touch_priority = -140,
    not_swallow = true,
    no_shade = true
  },
  herodetailremnant = {
    touch_priority = -140,
    not_swallow = true,
    no_shade = true
  },
  task = {touch_priority = -135, layer_opacity = 200},
  fragmentcompose = {touch_priority = -140},
  equipstrengthenpop = {touch_priority = -140},
  configure = {touch_priority = -99},
  excavatebattlereport = {touch_priority = -145},
  autoexcavresult = {touch_priority = -145},
  notification = {touch_priority = -150},
  cdkeywindow = {touch_priority = -150},
  specialcdkeywindow = {touch_priority = -150},
  selectlanguage = {touch_priority = -150},
  rewardofferrewardlist = {touch_priority = -150},
  poptavernloot = {touch_priority = -155, layer_opacity = 200},
  mailbox = {touch_priority = -160},
  equipcraft = {touch_priority = -160},
  equipcraftopenchest = {touch_priority = -301},
  stonedetail = {touch_priority = -160},
  midas = {touch_priority = -401},
  multiMidas = {touch_priority = -402},
  rechargegift = {touch_priority = -180},
  popherocard = {touch_priority = -200},
  splitconfirmwindow = {touch_priority = -200},
  explainwindow = {touch_priority = -200},
  guildmail = {touch_priority = -200},
  giveNoHaveHeroWindow = {touch_priority = -200, layer_opacity = 100},
  heroListWindow = {touch_priority = -200, layer_opacity = 100},
  TavernCritPreviewWin = {touch_priority = -200, layer_opacity = 100},
  TavernMagicHeroSelectWin = {touch_priority = -200, layer_opacity = 200},
  mailoverfull = {touch_priority = -205},
  guildapplyreward = {touch_priority = -215},
  guildapplydetail = {touch_priority = -220},
  guildmonthcard = {touch_priority = -220},
  guildwarmyteam = {touch_priority = -220},
  guildwarviewbattledetail = {touch_priority = -220},
  guildwarviewbattleinfo = {touch_priority = -220},
  gvgprogress = {touch_priority = -300},
  heroselect = {touch_priority = -300},
  popherotask = {touch_priority = -300},
  bename = {touch_priority = -510},
  changeserver = {touch_priority = -510},
  changeserverexplain = {touch_priority = -600},
  changeserverconfirm = {touch_priority = -600},
  changeserverdoubleconfirm = {touch_priority = -600},
  autorecommend = {touch_priority = -150},
  confirmdialog = {touch_priority = -1000},
  debugerror = {touch_priority = -50000},
  playerinfo = {touch_priority = -135},
  applylist = {touch_priority = -135},
  matchlist = {touch_priority = -135},
  matchvideo = {touch_priority = -50},
  matchdescribtion = {touch_priority = -135},
  playoffseason = {touch_priority = -135},
  applyconfirm = {touch_priority = -135},
  playoffround = {touch_priority = -900},
  onetimeupgrade = {touch_priority = -297},
  conectinfo = {touch_priority = -135},
  titleselectframe = {touch_priority = -150},
  titlegetfcapop = {touch_priority = -155, layer_opacity = 200},
  recharge = {touch_priority = -150},
  spanserverset = {touch_priority = -150},
  guildforeign = {touch_priority = -150},
  guildbrowse = {touch_priority = -150},
  usersRefluxMainWin = {touch_priority = -150},
  usersRefluxprivilegeGitWin = {touch_priority = -150},
  usersRefluxprivilegeCode = {touch_priority = -150},
  URCarryHeroWin = {touch_priority = -150},
  URPrivilegeTwo = {touch_priority = -150},
  relationNoticePop = {touch_priority = -150},
  shopSeleteList = {touch_priority = -601},
  shopssaleequip = {touch_priority = -601, layer_opacity = 200},
  mentorframe = {touch_priority = -150},
  mentorbindwindow = {touch_priority = -200},
  mentorapplewindow = {touch_priority = -200},
  mentorrulewindow = {touch_priority = -200},
  heroBuyList = {touch_priority = -602},
  FBShopSelect = {touch_priority = -130},
  assassinateWindow = {touch_priority = -200},
  assRecordWindow = {touch_priority = -200},
  guildwarassignteam = {touch_priority = -200},
  bindaccountframe = {touch_priority = -800},
  equipboardofResolve = {touch_priority = -130},
  newRunemountwin = {touch_priority = -800},
  seleteMakeRuneWin = {touch_priority = -800},
  newRuneenhancesavewnd = {touch_priority = -800},
  makeRuneTipWin = {touch_priority = -800},
  resolveWin = {touch_priority = -300},
  oneKeyResolveRuneWin = {touch_priority = -300},
  newRuneAwakeSeleteWin = {touch_priority = -300},
  makeUpspeedWindow = {touch_priority = -130},
  NianMonsterFrame = {touch_priority = -130},
  NianInfoWindow = {touch_priority = -130},
  NianRankWindow = {touch_priority = -130},
  NianRewardWindow = {touch_priority = -130},
  NianNoticeWindow = {touch_priority = -999, layer_opacity = 100},
  GiftBox = {touch_priority = -130},
  babeljumpfloor = {touch_priority = -130},
  babelBattleRecord = {touch_priority = -130},
  batchAwakeRuneWin = {touch_priority = -300},
  mentorRecommendWindow = {touch_priority = -200},
  runePlishedConditionWin = {touch_priority = -350},
  legendArenaRecordWindow = {touch_priority = -130},
  legendArenaReplayWindow = {touch_priority = -130},
  legendArenaFormationWindow = {touch_priority = -130},
  proBatReWindow = {touch_priority = -130},
  batReWindow = {touch_priority = -130},
  oppoInfoWindow = {touch_priority = -170},
  offlinequestgoto = {touch_priority = -300},
  seleteMakeRuneWin = {touch_priority = -200},
  chefCookbookWin = {touch_priority = -200},
  cookHelpTrade = {touch_priority = -600},
  cookAnounce = {touch_priority = -600},
  selectnumberHelp = {touch_priority = -200},
  chefCookBag = {touch_priority = -200},
  cookChoseHero = {touch_priority = -200},
  newSelectNumber = {touch_priority = -200},
  foodAttrChangeWin = {touch_priority = -200},
  tradeQuestWait = {touch_priority = -600},
  realTimeTrade = {touch_priority = -600},
  tradeQuestAccept = {touch_priority = -600},
  tradeQuestRefuseBlock = {touch_priority = -600},
  realTimeTradeChoose = {touch_priority = -600},
  tradeFinishtWin = {touch_priority = -600},
  chefCooktalentChoose = {touch_priority = -200},
  foodAttributeHave = {touch_priority = -200},
  CrArenaRewards = {touch_priority = -200},
  chefHelpInvite = {touch_priority = -200},
  chefCookbagHeroEffect = {touch_priority = -200},
  cr_single_room = {layer_opacity = 200},
  cr_team_room = {layer_opacity = 200},
  cr_arena_room = {layer_opacity = 200},
  cursadeRward = {touch_priority = -200},
  chatPlayerInfoView = {touch_priority = -610},
  superHeroTaskConsumeWin = {touch_priority = -200},
  bookheropanel = {touch_priority = -130},
  bookmaplogwindow = {touch_priority = -130},
  BookSweepPanel = {touch_priority = -130},
  newMultiPlayerInvite = {touch_priority = -600},
  bookmapalertwindow = {touch_priority = -200},
  bookmappointtipwindow = {touch_priority = -130},
  bookmapruleswindow = {touch_priority = -130},
  chatSetting = {touch_priority = -510},
  chatBubbleSetting = {touch_priority = -510},
  delContactMsg = {touch_priority = -510},
  chatFriendRequest = {touch_priority = -510},
  chatServerSelectList = {touch_priority = -510},
  hotlist = {touch_priority = -100},
  hothero = {touch_priority = -111},
  promote = {touch_priority = -121},
  confirm_collect = {touch_priority = -140},
  add_collect = {touch_priority = -130},
  petMainPanel = {touch_priority = -160},
  petAttrPanel = {
    touch_priority = -160,
    not_swallow = true,
    no_shade = true
  },
  petBagPanel = {
    touch_priority = -160,
    not_swallow = true,
    no_shade = true
  },
  petSkillPanel = {
    touch_priority = -160,
    not_swallow = true,
    no_shade = true
  },
  petEggSelectPanel = {touch_priority = -130},
  petAcceleratePanel = {touch_priority = -130},
  petListPanel = {touch_priority = -170},
  petFoodPanel = {touch_priority = -170},
  petEquipSelectPanel = {touch_priority = -170},
  petGainPanel = {touch_priority = -510},
  petHeroSelectPanel = {touch_priority = -170},
  petLevelupPanel = {touch_priority = -170},
  consumptionChestWin = {touch_priority = -200},
  newMagicSeleteHeroWin = {touch_priority = -200},
  runeGuideWin = {touch_priority = -140},
  multistage_retreat = {touch_priority = -140},
  battleprepare_pay = {touch_priority = -140},
  playerInfoPanel = {touch_priority = -300},
  heroInfoPanel = {touch_priority = -999},
  rentHeroInfoPanel = {touch_priority = -130},
  heroInfoAttr = {touch_priority = -131, layer_opacity = 200},
  playerAddHonorPanel = {touch_priority = -999},
  medalInfoPanel = {touch_priority = -600},
  avatarInfoPanel = {touch_priority = -600},
  playerSignPanel = {touch_priority = -600},
  AchievementInfoPanel = {touch_priority = -600},
  activityMagicBox = {touch_priority = -130},
  videoplayer_endplayer = {touch_priority = -130},
  gambleMainPanel = {touch_priority = -130},
  GambleRecordPanel = {touch_priority = -130},
  tbc_record = {touch_priority = -130},
  heroPackage = {touch_priority = -130},
  sellhero_mainpanel = {touch_priority = -130},
  multiplaying_mainscene = {touch_priority = -130},
  PhotoInfoPanel = {touch_priority = -600},
  CustomPhotoPanel = {touch_priority = -600},
  PlayerReportPanel = {touch_priority = -600},
  PlayerGMPanel = {touch_priority = -600},
  pet_finish_panel = {touch_priority = -130},
  VideoPlayerBarrage = {touch_priority = -130},
  VideoPlayerReport = {touch_priority = -130},
  StarGatePlayerInfo = {touch_priority = -130},
  StarGateBattlePanel = {touch_priority = -130},
  StarGateRulePanel = {touch_priority = -130},
  StarGateRecordPanel = {touch_priority = -130},
  StarGateReplayPanel = {touch_priority = -160},
  StarGateRecordDetailPanel = {touch_priority = -160},
  StarGateBestRankPanel = {touch_priority = -130},
  StarGateRewardPanel = {touch_priority = -130},
  StarGateHeroTipPanel = {touch_priority = -130},
  EzioToyActivity = {touch_priority = -130},
  ItemSelectPanel = {touch_priority = -130},
  Age18Panel = {touch_priority = -999},
  ActivityNewYear = {touch_priority = -130},
  ShopSpecialTip = {touch_priority = -130},
  ChaosTowerSwitchPanel = {touch_priority = -130},
  WorldCupPanel = {touch_priority = -130},
  WorldCupBetPanel = {touch_priority = -130},
  titanchangesoulstone = {touch_priority = -130},
  titanquickupgrade = {touch_priority = -700},
  TitanConditionWindow = {touch_priority = -130},
  TitanConfirmWindow = {touch_priority = -130},
  heropackerconfirm = {touch_priority = -200},
  fortunewheel = {touch_priority = -160},
  TarotAllDisenchantWindow = {touch_priority = -160},
  TarotDisenchantWindow = {touch_priority = -160},
  TarotDisenchantConfirmWindow = {touch_priority = -161},
  TarotEquipWindow = {touch_priority = -160},
  TarotShowCardWindow = {touch_priority = -160},
  TarotComposeShowCardWindow = {touch_priority = -160},
  TarotComposeEquipWindow = {touch_priority = -160},
  TarotComposeShowWindow = {touch_priority = -180},
  TarotOpenPackage = {touch_priority = -160, layer_opacity = 215},
  TarotOpenPackageBatch = {touch_priority = -160, layer_opacity = 215},
  TarotQuickComposeWindow = {touch_priority = -160},
  ChaosTowerFastestFinish = {touch_priority = -160},
  gobackActivity = {touch_priority = -160},
  AutoChessRaceWin = {touch_priority = -160},
  AutoChessRaceDetailWin = {touch_priority = -700},
  AutoChessShopWindow = {no_shade = true},
  AutoChessHeroDetailWin = {no_shade = true, not_swallow = true},
  AutoChessTagNode = {
    touch_priority = -999,
    no_shade = true,
    not_swallow = true
  },
  SoloStickerNode = {
    touch_priority = -999,
    no_shade = true,
    not_swallow = true
  },
  AutoChessStickerNode = {
    touch_priority = -999,
    no_shade = true,
    not_swallow = true
  },
  AutoChessEquipPetWin = {no_shade = true},
  AutoChessPetBagWin = {no_shade = true},
  AutoChessRoomSwitch = {},
  AutoChessRoomPrepare = {},
  AutoChessMatchWin = {no_shade = true, not_swallow = true},
  SoloMatchWin = {no_shade = true, not_swallow = true},
  AutoChessRankGradeListWindow = {layer_opacity = 150},
  AssistantMainWin = {touch_priority = -100},
  AssistantFuncPanel = {touch_priority = -101},
  AssistantFuncDetail = {touch_priority = -103},
  AssistantHeroPanel = {touch_priority = -101},
  AssistantTeamDetail = {touch_priority = -103},
  AssistantTeamHotList = {touch_priority = -105},
  ArcanaTaskDialog = {touch_priority = -300},
  ArcanaAttributeWindow = {touch_priority = -300},
  ImpulseGiftWin = {touch_priority = -888},
  CupArenaChooseCampWin = {touch_priority = -999},
  CupArenaVSScheduleWin = {touch_priority = -999},
  CupArenaScheduleDetailWin = {touch_priority = -400},
  CupArenaChallengeWin = {touch_priority = -200},
  CupArenaScheduleWindow = {touch_priority = -300},
  CupArenaSeasonHistoryWindow = {touch_priority = -300},
  CupArenaBattleResultWin = {touch_priority = -300},
  CupArenaBattleLogWin = {touch_priority = -300},
  CupArenaEnemyDetailWin = {touch_priority = -999, layer_opacity = 220},
  CupArenaVSRecordWin = {touch_priority = -300},
  CupArenaGuessRecordWin = {touch_priority = -360},
  CupArenaFamousRecordWin = {touch_priority = -300},
  CupArenaGambleWindow = {touch_priority = -300, layer_opacity = 220},
  CupArenaLineupWin = {touch_priority = -300},
  CupArenaGambleAmountWindow = {touch_priority = -400},
  CupArenaReplayWin = {touch_priority = -500},
  CupArenaTaskWin = {touch_priority = -300},
  TarotGoldRefreshWin = {touch_priority = -300, layer_opacity = 220},
  TarotSilverRefreshWin = {touch_priority = -300, layer_opacity = 220},
  SecretAreaMonsterWin = {touch_priority = -100},
  SecretAreaRuleWin = {touch_priority = -120},
  SecretAreaBossStageWindow = {touch_priority = -300},
  SecretAreaShopWindow = {touch_priority = -300},
  SecretAreaRankUserSummary = {touch_priority = -300, layer_opacity = 0},
  SecretAreaMultiExchangeWin = {touch_priority = -302},
  RechargeNewGiftContentWindow = {touch_priority = -300},
  ActivityNewScene = {touch_priority = -100},
  CampBossRewardWin = {touch_priority = -300},
  CampBossChallengeWin = {touch_priority = -300, layer_opacity = 220},
  CampTowerStageWin = {touch_priority = -300},
  CampTowerRecommendWin = {touch_priority = -299},
  CampDetailAttrWin = {touch_priority = -300},
  CampCounterWin = {touch_priority = -300},
  GuildMountRankRewardWin = {touch_priority = -300},
  GuildMountRewardDetailWin = {touch_priority = -400},
  GuildMountGuildSummary = {touch_priority = -401},
  GuildInstanceResetPop = {touch_priority = -402},
  GuildRecruit = {touch_priority = -299},
  NewbieHelperMainWin = {touch_priority = -300},
  LeaderBackActivateWin = {touch_priority = -300},
  LeaderBackMainWin = {touch_priority = -305},
  LeaderBackRewardWin = {touch_priority = -310},
  MagicStoneStorageWin = {touch_priority = -310},
  MagicStoneDetails = {touch_priority = -310},
  MagicStone_Storage_ComparePanel = {touch_priority = -600},
  MagicStoneSelectStoneWin = {touch_priority = -320, layer_opacity = 200},
  MagicStoneApplyHero = {touch_priority = -600},
  MagicStoneTitleWin = {touch_priority = -600},
  MagicStoneShopStonesViewScene = {touch_priority = -501},
  TitanBondWindow = {touch_priority = -160},
  SeniorPlayerMainWin = {touch_priority = -300},
  SeasonArenaRewardWindow = {touch_priority = -300},
  SeasonArenaRanklistWindow = {touch_priority = -99},
  SeasonRecordReview = {touch_priority = -515},
  SeasonArenaHOFWin = {touch_priority = -301},
  SeasonArenaHeroPoolWin = {touch_priority = -100},
  SeasonArenaSetTeamWin = {touch_priority = -100},
  SeasonArenaBattleResultWin = {touch_priority = -100},
  SeasonArenaBattleLogWin = {touch_priority = -100},
  SeasonArenaReplayWin = {touch_priority = -301},
  SeasonArenaPlayerInfoWin = {touch_priority = -303},
  SeasonArenaWeekReportWin = {touch_priority = -100},
  SeasonArenaGradeUpDownWin = {touch_priority = -100},
  SeasonArenaBattlePanel = {touch_priority = -130},
  SeasonArenaChallengeResultWin = {touch_priority = -150},
  SeasonArenaReplayPanel = {touch_priority = -500},
  SeasonArenaHireWin = {touch_priority = -100},
  SeasonPassContent = {touch_priority = -100},
  SeasonPassBuyLevel = {touch_priority = -100},
  SeasonTowerResetValueWin = {touch_priority = -100},
  SeasonTowerBuyBonusWin = {touch_priority = -100},
  SeasonArenaTreasureTitanUp = {touch_priority = -100},
  UnlockSucceedWindow = {touch_priority = -100},
  TreasureRewardWin = {touch_priority = -300, layer_opacity = 200},
  CompleteWindow = {touch_priority = -301, layer_opacity = 200},
  SummonWishWindow = {touch_priority = -300},
  getProp = {touch_priority = -300},
  consumeTipsWin = {touch_priority = -516},
  summonRuleTips = {touch_priority = -301, layer_opacity = 50},
  stagedetail = {touch_priority = -175, layer_opacity = 200},
  stageReward = {touch_priority = -175, layer_opacity = 200},
  heroDetailWin = {touch_priority = -175},
  ontimeupgrade = {touch_priority = -176},
  stagedone = {layer_opacity = 229.5},
  ranklist = {touch_priority = -300},
  funOpenWindow = {touch_priority = -900},
  Dialog = {touch_priority = -999},
  chooseheroWin = {touch_priority = -301},
  ConfirmDialog = {touch_priority = -302},
  showMedalPop = {touch_priority = -999},
  summonRiseStarConfirmWin = {touch_priority = -302},
  summonNewbieConfirmWin = {touch_priority = -302},
  dragonBoatBoatPop = {layer_opacity = 102},
  dragonBoatGiveRecordPop = {layer_opacity = 102},
  dragonBoatPassPop = {layer_opacity = 102}
}
local window_stack = {}
ed.window_stack = window_stack
for k, v in pairs(class.config) do
  window_stack[k] = {}
end

local function getPopWindow(identity)
  if window_stack[identity] and not tolua.isnull(window_stack[identity].mainLayer) then
    return window_stack[identity]
  end
  return nil
end

ed.getPopWindow = getPopWindow

local function destroy(self, param)
  if self.isDestroyed then
    return
  end
  self.isDestroyed = true
  if type(param) ~= "table" then
    param = {}
  end
  
  local function destroyMainLayer()
    ed.playEffect(ed.sound.deo.common_close_popup_window)
    if not tolua.isnull(self.mainLayer) then
      local windows = ed.getCurrentScene().windowsStack
      if not self.noShade and windows and 1 < #windows then
        local preWindow = windows[#windows - 1]
        if not tolua.isnull(preWindow.mainLayer) then
          preWindow.mainLayer:setOpacity(preWindow.layer_opacity or 170)
        end
      end
      if self:getScene().destroyWindow then
        self:getScene():destroyWindow(self)
        return
      end
      self.mainLayer:removeAllChildrenWithCleanup(true)
      self.mainLayer = nil
    end
  end
  
  local container = self.actionLayer
  local callback = param.callback or self.destroyCallback
  if self.isSkipTransAnim or self.isSkipDestroyAnim or param.skipAnim then
    if callback then
      callback()
    end
    destroyMainLayer()
    return
  end
  local draglist, scaleContainer
  if self.refreshCliprectConfig then
    local config = self.refreshCliprectConfig
    draglist = config.draglist or self.draglist
    scaleContainer = config.scaleContainer or container
    self:beginRefreshCliprect(draglist, scaleContainer)
  end
  local s = CCScaleTo:create(param.actionTime or 0.2, 0)
  s = CCEaseBackIn:create(s)
  local f = CCCallFunc:create(function()
    xpcall(function()
      if self.refreshCliprectConfig then
        self:endRefreshCliprect()
        self:refreshCliprect(draglist, scaleContainer)
      end
      if callback then
        callback()
      end
      destroyMainLayer()
    end, EDDebug)
  end)
  s = CCSequence:createWithTwoActions(s, f)
  container:runAction(s)
end

class.destroy = destroy

local function show(self, param)
  param = param or {}
  local container = self.actionLayer
  local callback = param.callback or self.showCallback
  if self.isSkipTransAnim or self.isSkipShowAnim or param.skipAnim then
    if callback then
      callback()
    end
    return
  end
  local draglist, scaleContainer
  if self.refreshCliprectConfig then
    local config = self.refreshCliprectConfig
    draglist = config.draglist or self.draglist
    scaleContainer = config.scaleContainer or container
    self:beginRefreshCliprect(draglist, scaleContainer)
  end
  container:setScale(0)
  local s = CCScaleTo:create(0.2, 1)
  s = CCEaseBackOut:create(s)
  local f = CCCallFunc:create(function()
    xpcall(function()
      if self.refreshCliprectConfig then
        self:endRefreshCliprect()
        self:refreshCliprect(draglist, scaleContainer)
      end
      if callback then
        callback()
      end
    end, EDDebug)
  end)
  s = CCSequence:createWithTwoActions(s, f)
  container:runAction(s)
end

class.show = show
ed.refreshBlurBg()

local function create(identity, param)
  param = param or {}
  local self = base.create("window")
  setmetatable(self, class.mt)
  print("----------->>>>>popwindow: ", identity)
  window_stack[identity] = self
  self.onEnterHandlers = {}
  self.onExitHandlers = {}
  self.param = param
  self.identity = identity
  self.isDestroyed = false
  self.isForceCleanTextures = false
  local cfg = self.config[identity] or {}
  local noShade = param.noShade or cfg.no_shade
  self.noShade = noShade
  local shadeColor = param.shadeColor or cfg.shade_color
  local forbidTouch = param.forbidTouch
  local swallow = param.swallow
  if swallow == nil then
    if cfg.not_swallow then
      swallow = false
    else
      swallow = true
    end
  end
  local windows = ed.getCurrentScene().windowsStack
  if not noShade and windows and 0 < #windows and not tolua.isnull(windows[#windows].mainLayer) then
    windows[#windows].mainLayer:setOpacity(0)
  end
  if not noShade then
    self.layer_opacity = cfg.layer_opacity or param.layer_opacity or 170
    self.mainLayer = CCLayerColor:create(shadeColor or ccc4(0, 0, 0, self.layer_opacity))
  else
    self.layer_opacity = 0
    self.mainLayer = CCLayerColor:create(ccc4(0, 0, 0, self.layer_opacity))
  end
  local mainLayer = self.mainLayer
  local actionLayer = CCLayer:create()
  self.actionLayer = actionLayer
  self.mainLayer:addChild(actionLayer)
  local container = CCLayer:create()
  container:setPosition(ed.display.halfFixedWidth, ed.display.halfFixedHeight)
  self.container = container
  actionLayer:addChild(container)
  self.ui = {}
  self.mainTouchPriority = param.priority or cfg.touch_priority or -300
  if self.mainTouchPriority then
    mainLayer:setTouchEnabled(true)
    mainLayer:registerScriptTouchHandler(self:btGetMainTouchHandler(), false, self.mainTouchPriority, swallow)
  end
  if self.forbidTouch then
    mainLayer:setTouchEnabled(false)
  end
  self.windowEventScope = {}
  mainLayer:registerScriptHandler(self:getEventHandler())
  if ed.isBlurBg and not param.notBlurBg then
    local function updateBGBlur()
      self.mainLayer:setVisible(false)
      
      local windows = ed.getCurrentScene().windowsStack
      if windows and 0 < #windows then
        local curWindow = windows[#windows]
        if curWindow.blurBg and not tolua.isnull(curWindow.blurBg) then
          curWindow.blurBg:setVisible(false)
        end
      end
      local texture = ed.getScreenshotTexture()
      if not texture then
        self.mainLayer:setVisible(true)
        return
      end
      if not self.blurBg then
        self.blurBg = CCSprite:createWithTexture(texture)
      else
        self.blurBg:setTexture(texture)
      end
      local sprite = self.blurBg
      sprite:setFlipY(true)
      self.blurBg = sprite
      mainLayer:addChild(sprite, -1)
      ed.layout.centerInParent(sprite)
      self.mainLayer:setVisible(true)
    end
    
    updateBGBlur()
  end
  return self
end

class.create = create

local function setContainer(self, container, z)
  if not tolua.isnull(self.container) then
    self.container:removeFromParentAndCleanup(true)
  end
  self.container = container
  self.mainLayer:addChild(container, z or 0)
end

class.setContainer = setContainer

local function ccScene(self)
  if not (ed.getCurrentScene() or {}).ccScene then
    return
  end
  return ed.getCurrentScene():ccScene()
end

class.ccScene = ccScene

local function getScene(self)
  return self.m_parentScene or ed.getCurrentScene()
end

class.getScene = getScene

local function registerOnEnterHandler(self, key, handler)
  self.onEnterHandlers[key] = handler
end

class.registerOnEnterHandler = registerOnEnterHandler

local function removeOnEnterHandler(self, key)
  self.onEnterHandlers[key] = nil
end

class.removeOnEnterHandler = removeOnEnterHandler

local function registerOnExitHandler(self, key, handler)
  self.onExitHandlers = self.onExitHandlers or {}
  self.onExitHandlers[key] = handler
end

class.registerOnExitHandler = registerOnExitHandler

local function removeOnExitHandler(self, key)
  self.onExitHandlers[key] = nil
end

class.removeOnExitHandler = removeOnExitHandler

function class:onWinDestroy()
  FireEvent(ed.guide.eventNames.CLOSE_VIEW, self)
  CloseScope(self.windowEventScope)
  self.windowEventScope = nil
  if self.redPointMgr then
    self.redPointMgr:unregisterAllValueChange(self)
  end
end

function class:listenEvent(eventName, fun)
  return ListenEvent(eventName, fun, self.windowEventScope)
end

function class:listenTimer(timer, fun)
  return ListenTimer(timer, fun, self.windowEventScope)
end

local function getEventHandler(self)
  local function handler(event)
    xpcall(function()
      if event == "enter" then
        for k, v in pairs(self.onEnterHandlers) do
          v()
        end
        FireEvent(ed.guide.eventNames.OPEN_VIEW, self)
        return
      elseif event == "exit" then
        for k, v in pairs(self.onExitHandlers) do
          v()
        end
        return
      elseif event == "cleanup" and self.windowEventScope then
        self:onWinDestroy()
        return
      end
    end, EDDebug)
  end
  
  return handler
end

class.getEventHandler = getEventHandler

local function registerUpdateHandler(self, key, handler)
  if self:getScene().registerUpdateHandler then
    self:getScene():registerUpdateHandler(key, handler)
  end
end

class.registerUpdateHandler = registerUpdateHandler

local function removeUpdateHandler(self, key)
  if self:getScene().removeUpdateHandler then
    self:getScene():removeUpdateHandler(key)
  end
end

class.removeUpdateHandler = removeUpdateHandler

local function addFca(self, fca, addition)
  if not addition then
    self:getScene():addFca(fca)
  elseif addition.isOnce then
    self:getScene():addFcaOnce(fca)
  end
end

class.addFca = addFca

local function removeFca(self, fca)
  self:getScene():removeFca(fca)
end

class.removeFca = removeFca

local function addFcaOnce(self, fca)
  self:getScene():addFcaOnce(fca)
end

class.addFcaOnce = addFcaOnce

local function popWindow(self, z)
  if self:getScene().popWindow then
    self:getScene():popWindow(self, z or 300)
    return
  end
  self:getScene().scene:addChild(self.mainLayer, z or 300)
end

class.popWindow = popWindow

local function getRefreshCliprectHandler(self, draglist, scaleContainer)
  local function handler(dt)
    if tolua.isnull(scaleContainer) then
      self:endRefreshCliprect()
      
      return
    end
    draglist:refreshClipRect(scaleContainer:getScale())
  end
  
  return handler
end

class.getRefreshCliprectHandler = getRefreshCliprectHandler

local function refreshCliprect(self, draglist, scaleContainer)
  draglist:refreshClipRect(scaleContainer:getScale())
end

class.refreshCliprect = refreshCliprect

local function beginRefreshCliprect(self, draglist, scaleContainer)
  if self:getScene().registerUpdateHandler then
    self:getScene():registerUpdateHandler("refresh_cliprect", self:getRefreshCliprectHandler(draglist, scaleContainer))
  else
    ListenTimer(Timer:Always(0.02, "cliprectTimer"), self:getRefreshCliprectHandler(draglist, scaleContainer), self.windowEventScope)
  end
end

class.beginRefreshCliprect = beginRefreshCliprect

local function endRefreshCliprect(self)
  if self:getScene().removeUpdateHandler then
    self:getScene():removeUpdateHandler("refresh_cliprect")
  else
    CloseTimer("cliprectTimer")
  end
end

class.endRefreshCliprect = endRefreshCliprect

function class:createVoicetalk(mode, priority)
  local param = {
    touchNode = self,
    uimode = mode or 1,
    priority = priority or -300
  }
  self.voicetalk = ed.voicetalk.getInstance()
  local container = self.voicetalk:createVoiceTalkUI(param)
  self.mainLayer:addChild(container)
end

function class:openVoicetalk(partner)
  if self.voicetalk then
    self.voicetalk:openVoicetalk(partner)
  end
end

function class:closeVoicetalk()
  if self.voicetalk then
    self.voicetalk:closeVoicetalk()
  end
end

function class:registerEditBox(name, params)
  local item = self.ui[name]
  local x, y = item:getPosition()
  params = params or {}
  params.editSize = params.editSize or item:getContentSize()
  params.maxLength = params.maxLength or 24
  params.fontColor = params.fontColor or ccc3(255, 255, 255)
  params.fontSize = params.fontSize or 20
  params.position = params.position or ccp(x + params.editSize.width / 2, y + params.editSize.height / 2)
  local edit = editBox:new({config = params})
  local zOlder = params.zOlder or 10
  self.container:addChild(edit.edit, zOlder)
  local holder = params.holder or ""
  edit:setPlaceHolder(holder)
  self.editbox = edit
  self.editbox_info = params
  self:btRegisterHandler({
    handler = function(event, x, y)
      self.editbox:touch(event, x, y)
    end,
    key = "editbox_" .. name
  })
end

function class:setVoicetalkUIPosition(position)
  if self.voicetalk and self.voicetalk.mainLayer then
    local voicetalkMainLayer = self.voicetalk.mainLayer
    voicetalkMainLayer:setPosition(position)
  end
end
