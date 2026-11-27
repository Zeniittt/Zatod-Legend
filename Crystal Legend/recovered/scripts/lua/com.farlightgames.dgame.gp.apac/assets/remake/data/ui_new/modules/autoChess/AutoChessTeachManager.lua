local class = {}
class.__index = class
local maker = ed.tutorialmaker
local res = ed.tutorialres
local items = {}
local STEP_CONFIG = {
  [1] = {
    type = "shopchess",
    param = 1,
    res = "openChessShop",
    pos = ccp(220 + ed.display.halfFixedWidth / 2, 300 + ed.display.halfFixedHeight),
    radius = 60
  },
  [2] = {
    type = "closeshop",
    param = 1,
    res = "closeChessShop",
    pos = ccp(ed.display.winSize.width - 130 - ed.display.halfFixedWidth * 0.38, 55 + ed.display.halfFixedHeight),
    radius = 30
  },
  [3] = {
    type = "slot",
    param = 1,
    res = "dragChessBattle",
    pos = ccp(230 + ed.display.halfFixedWidth / 2, 45 + ed.display.halfFixedHeight),
    radius = 1,
    target = ccp(180 + ed.display.halfFixedWidth / 2, 275 + ed.display.halfFixedHeight)
  },
  [4] = {
    type = "hero",
    param = 1,
    res = "showChessDetail",
    pos = ccp(170 + ed.display.halfFixedWidth * 0.4, 275 + ed.display.halfFixedHeight),
    radius = 30
  },
  [5] = {
    type = "prepare",
    param = 1,
    res = "showPrepareTip",
    pos = ccp(ed.display.winSize.width / 2 - 70, ed.display.winSize.height - 80),
    radius = 30
  },
  [6] = {
    type = "shopchess",
    param = 1,
    res = "openChessShopTwo",
    pos = ccp(220 + ed.display.halfFixedWidth / 2, 300 + ed.display.halfFixedHeight),
    radius = 60
  },
  [7] = {
    type = "slot",
    param = 1,
    res = "dragChessBattle",
    pos = ccp(230 + ed.display.halfFixedWidth / 2, 45 + ed.display.halfFixedHeight),
    radius = 30,
    target = ccp(250 + ed.display.halfFixedWidth / 2, 275 + ed.display.halfFixedHeight)
  },
  [8] = {
    type = "tag",
    param = 1,
    res = "openChessTag",
    pos = ccp(105, 456 + ed.display.halfFixedHeight),
    radius = 30
  },
  [9] = {
    type = "prepare",
    param = 1,
    res = "showPrepareTip",
    pos = ccp(ed.display.winSize.width / 2 - 70, ed.display.winSize.height - 80),
    radius = 30
  },
  [10] = {
    type = "shopchess",
    param = 1,
    res = "openChessShopThree",
    pos = ccp(220 + ed.display.halfFixedWidth / 2, 300 + ed.display.halfFixedHeight),
    radius = 60
  },
  [11] = {
    type = "shopchess",
    param = 2,
    res = "openChessShopThree",
    pos = ccp(355 + ed.display.halfFixedWidth * 0.77, 300 + ed.display.halfFixedHeight),
    radius = 60
  },
  [12] = {
    type = "shopchess",
    param = 3,
    res = "openChessShopFour",
    pos = ccp(490 + ed.display.halfFixedWidth * 0.99, 300 + ed.display.halfFixedHeight),
    radius = 60
  },
  [13] = {
    type = "closeshop",
    param = 1,
    res = "closeChessShop",
    pos = ccp(ed.display.winSize.width - 130 - ed.display.halfFixedWidth * 0.38, 55 + ed.display.halfFixedHeight),
    radius = 30
  },
  [14] = {
    type = "starup",
    param = 1,
    res = "showStarUpTip",
    pos = ccp(110 + ed.display.halfFixedWidth * 0.35, 385 + ed.display.halfFixedHeight / 2),
    radius = 30,
    target = ccp(80, 260),
    updateNext = true
  },
  [15] = {
    type = "limit",
    param = 1,
    res = "showLimitTip",
    pos = ccp(180 + ed.display.halfFixedWidth * 0.47, 145 + ed.display.halfFixedHeight / 2),
    radius = 30,
    target = ccp(80, 260),
    updateNext = true
  },
  [16] = {
    type = "exp",
    param = 1,
    res = "openChessLevel",
    pos = ccp(120 + ed.display.halfFixedWidth * 0.3, 95 + ed.display.halfFixedHeight),
    radius = 60
  },
  [17] = {
    type = "slot",
    param = 1,
    res = "dragChessBattle",
    pos = ccp(230 + ed.display.halfFixedWidth / 2, 45 + ed.display.halfFixedHeight),
    radius = 60,
    target = ccp(320 + ed.display.halfFixedWidth / 2, 275 + ed.display.halfFixedHeight)
  }
}

function class.getInstance(...)
  local object = {}
  setmetatable(object, class)
  object:initData()
  return object
end

function class:initData(...)
  self.curStep = 1
  self.guideType = "shopchess"
  self.guideParam = 1
  self.guideFlag = false
  self.baseData = {}
  local guideTable = ed.getDataTable("ChessGuide")
  for k, v in pairs(guideTable) do
    if k ~= "name" and k ~= 0 then
      for id, v2 in pairs(v) do
        local round = k
        local playerIndex = id + 1
        if not self.baseData["round_" .. round] then
          self.baseData["round_" .. round] = {}
        end
        self.baseData["round_" .. round][playerIndex] = v2
      end
    end
  end
  self:initGuideData()
end

function class:enterStep(type, param)
  self.guideType = type
  self.guideParam = param
end

function class:nextStep()
  self.curStep = math.min(self.curStep + 1, #STEP_CONFIG)
  local config = STEP_CONFIG[self.curStep]
  if not config then
    return
  end
  self:enterStep(config.type, config.param)
end

function class:isGuideFlag(...)
  return self.guideFlag == 1
end

function class:setGuideFlag(flag)
  self.guideFlag = flag
end

function class:isShopGuideType(...)
  return self.guideType == "shopchess" or self.guideType == "refresh" or self.guideType == "lock" or self.guideType == "closeshop"
end

function class:isMainGuideType(...)
  return self.guideType == "slot" or self.guideType == "exp" or self.guideType == "hero" or self.guideType == "prepare" or self.guideType == "tag" or self.guideType == "starup" or self.guideType == "limit" or self.guideType == "exp"
end

function class:updateStep(flag, curPos)
  if flag then
    self.targetPos = self.curStep == 3 and curPos or nil
    if self.targetPos then
      self.targetPos.x = self.targetPos.x + 55 + ed.display.halfFixedWidth * 0.8
      self.targetPos.y = self.targetPos.y + 15 + ed.display.halfFixedHeight / 2
      self.heroPos = self.targetPos
    end
    self:endTeach()
    if self.curStep == #STEP_CONFIG then
      FireEvent("EventGuideStartTimer")
      return
    end
    self:nextStep()
    if self.guideFlag then
      FireEvent("EventGuideNextStep")
    end
  end
end

function class:isGuideEnd(...)
  return self.curStep == #STEP_CONFIG
end

function class:checkGuideStep(param)
  local isGuideFlag = ed.AutoChessTeachManager:isGuideFlag()
  if not isGuideFlag then
    return false, false
  end
  local type = param.type
  if type == "shopchess" and type == self.guideType then
    local index = param.index
    if index == self.guideParam then
      return true, true
    end
  elseif type == "closeshop" and type == self.guideType then
    return true, true
  elseif type == "slot" and type == self.guideType then
    local slot = param.slot
    if slot == self.guideParam then
      return true, true
    end
  elseif type == "hero" and type == self.guideType then
    return true, true
  elseif type == "exp" and type == self.guideType then
    return true, true
  elseif type == "tag" and type == self.guideType then
    return true, true
  end
  return true, false
end

function class:createTeach(parent)
  if not self.guideFlag then
    return
  end
  local config = STEP_CONFIG[self.curStep]
  if not config then
    ed.showToast(T("\229\174\140\230\136\144\229\188\149\229\175\188"))
    return
  end
  print("<<<<<<<<<<<<<<<<<<<< CreateTeach >>>>>>>>>>>>>>>>" .. type(parent) .. "_" .. self.curStep)
  local pos = self.targetPos and self.targetPos or config.pos
  if self.curStep == 14 then
    pos = self.heroPos
    pos.x = pos.x - 62
    pos.y = pos.y + 77
  end
  self:instTipCreate(config.res, pos, config.radius, parent, nil, false, config.target)
  if config.updateNext then
    ListenTimer(Timer:Once(3), function()
      self:updateStep(config.updateNext)
    end)
  end
end

function class:createPetTeach(parent)
  local config = {
    type = "pet",
    param = 1,
    res = "showChessPetTip",
    pos = ccp(240, 115),
    radius = 30
  }
  local key = string.format("CHESS_EQUIP_PET_TIP_%s_%s", game_server_id, ed.getUserid())
  local isShow = ed.storage.getBool(key)
  if not isShow then
    ed.storage.setValue(key, true)
    self:instTipCreate(config.res, config.pos, config.radius, parent, nil, false, config.target)
  end
end

function class:instTipCreate(key, pos, radius, parent, container, force, targetPos)
  xpcall(function()
    local container = self:preInstTipCreate(key, container, force)
    if not container then
      return
    end
    local ir = res[key]
    if ir.type == "finger" then
      items[key] = maker.createCommonFingerLayer(key, pos, radius, parent)
    elseif ir.type == "newtips" then
      items[key] = maker.createChessTipsLayer(key, pos, radius, parent)
    elseif ir.type == "nofingertip" then
      items[key] = maker.createTipsLayerNoFinger(key, pos)
    elseif ir.type == "dragchess" then
      items[key] = maker.createChessTipsLayer(key, pos, radius, parent, targetPos, true)
    end
    self:addTutorial(key, container, {
      pos = pos,
      radius = radius,
      parent = parent
    })
  end, EDDebug)
end

function class:preInstTipCreate(key, container, force)
  xpcall(function()
    if items[key] then
      if not force then
        if not tolua.isnull(items[key].mainLayer) then
          container = nil
          return
        else
          items[key] = nil
        end
      else
        self:removeTutorial(key)
      end
    end
    if not container then
      container = CCDirector:sharedDirector():getRunningScene()
    end
  end, EDDebug)
  return container
end

function class:removeTutorial(key, noClear)
  xpcall(function()
    if not noClear and items[key] and not tolua.isnull(items[key].mainLayer) then
      items[key].mainLayer:removeFromParentAndCleanup(true)
    end
    items[key] = nil
  end, EDDebug)
end

function class:endTeach()
  local config = STEP_CONFIG[self.curStep]
  local key = config.res
  local result
  xpcall(function()
    self:removeTutorial(key)
    result = true
  end, EDDebug)
  return result
end

function class:addTutorial(key, container, addition)
  xpcall(function()
    local dc, hc
    if type(container) == "userdata" then
      dc = container
      hc = container
    elseif type(container) == "table" then
      dc = container.tutorialContainer or container[1]
      hc = container.dialogContainer or container[2]
    end
    if dc then
      dc:addChild(items[key].mainLayer, 999)
    end
  end, EDDebug)
end

function class:runNextRoundState()
  if not self.guideFlag then
    return
  end
  if self.stage == nil then
    self.stage = "start"
  end
  local round = ed.AutoChessModel:getBattleRound()
  if self.stage == "start" then
    self.stage = "prepare"
    self:dispatchGuideNotify("round", "start", round)
  elseif self.stage == "prepare" then
    self.stage = "lock"
    self:dispatchGuideNotify("round", "prepare", round)
  elseif self.stage == "lock" then
    self.stage = "battle"
    self:dispatchGuideNotify("round", "lock", round)
  elseif self.stage == "battle" then
    self.stage = "over"
    self:dispatchGuideNotify("round", "battle", round)
  elseif self.stage == "over" then
    self.stage = "start"
    self:dispatchGuideNotify("round", "over", round)
    ed.AutoChessModel:setBattleRound(round + 1)
  end
end

function class:initGuideData(...)
  self.guideData = {
    roudData = {
      round = {
        start = {
          [1] = {
            _hp = self.baseData.round_1[1].HP,
            _gold = self.baseData.round_1[1].Gold,
            _level = self.baseData.round_1[1].Level,
            _exp = self.baseData.round_1[1].Exp,
            _gain_base = self.baseData.round_1[1]["Base Gold"],
            _gain_inst = 0,
            _max_hp = self.baseData.round_1[1]["Max HP"]
          },
          [2] = {
            _hp = self.baseData.round_2[1].HP,
            _gold = self.baseData.round_2[1].Gold,
            _level = self.baseData.round_2[1].Level,
            _exp = self.baseData.round_2[1].Exp,
            _gain_base = self.baseData.round_2[1]["Base Gold"],
            _gain_inst = 0,
            _gain_combo_v = 1,
            _max_hp = self.baseData.round_2[1]["Max HP"]
          },
          [3] = {
            _hp = self.baseData.round_3[1].HP,
            _gold = self.baseData.round_3[1].Gold,
            _level = self.baseData.round_3[1].Level,
            _exp = self.baseData.round_3[1].Exp,
            _gain_base = self.baseData.round_3[1]["Base Gold"],
            _gain_inst = 0,
            _gain_combo_v = 2,
            _max_hp = self.baseData.round_3[1]["Max HP"]
          }
        },
        prepare = {
          [1] = {
            _oppo_type = "monster",
            _hero_shop = {
              _heroes = {
                {
                  _insid = 1,
                  _hid = self.baseData.round_1[1].Shop[1],
                  _sold = 0
                },
                {
                  _insid = 2,
                  _hid = self.baseData.round_1[1].Shop[2],
                  _sold = 0
                },
                {
                  _insid = 3,
                  _hid = self.baseData.round_1[1].Shop[3],
                  _sold = 0
                },
                {
                  _insid = 4,
                  _hid = self.baseData.round_1[1].Shop[4],
                  _sold = 0
                },
                {
                  _insid = 5,
                  _hid = self.baseData.round_1[1].Shop[5],
                  _sold = 0
                }
              },
              _is_locked = 0
            },
            _end_time = ed.getServerTime() + 30
          },
          [2] = {
            _oppo_type = "monster",
            _hero_shop = {
              _heroes = {
                {
                  _insid = 6,
                  _hid = self.baseData.round_2[1].Shop[1],
                  _sold = 0
                },
                {
                  _insid = 7,
                  _hid = self.baseData.round_2[1].Shop[2],
                  _sold = 0
                },
                {
                  _insid = 8,
                  _hid = self.baseData.round_2[1].Shop[3],
                  _sold = 0
                },
                {
                  _insid = 9,
                  _hid = self.baseData.round_2[1].Shop[4],
                  _sold = 0
                },
                {
                  _insid = 10,
                  _hid = self.baseData.round_2[1].Shop[5],
                  _sold = 0
                }
              },
              _is_locked = 0
            },
            _end_time = ed.getServerTime() + 30
          },
          [3] = {
            _oppo_type = "monster",
            _hero_shop = {
              _heroes = {
                {
                  _insid = 11,
                  _hid = self.baseData.round_3[1].Shop[1],
                  _sold = 0
                },
                {
                  _insid = 12,
                  _hid = self.baseData.round_3[1].Shop[2],
                  _sold = 0
                },
                {
                  _insid = 13,
                  _hid = self.baseData.round_3[1].Shop[3],
                  _sold = 0
                },
                {
                  _insid = 14,
                  _hid = self.baseData.round_3[1].Shop[4],
                  _sold = 0
                },
                {
                  _insid = 15,
                  _hid = self.baseData.round_3[1].Shop[5],
                  _sold = 0
                }
              },
              _is_locked = 0
            },
            _end_time = ed.getServerTime() + 30
          }
        },
        lock = {
          [1] = {
            _team = {
              _heroes = {
                {_insid = 1, _hid = 201}
              },
              _positions = {1}
            }
          },
          [2] = {
            _team = {
              _heroes = {
                {_insid = 1, _hid = 201},
                {_insid = 3, _hid = 3201}
              },
              _positions = {1, 6}
            }
          },
          [3] = {
            _team = {
              _heroes = {
                {_insid = 1, _hid = 202},
                {_insid = 7, _hid = 1001}
              },
              _positions = {1, 6}
            }
          }
        },
        battle = {
          [1] = {
            _record = {
              _checkid = 12440,
              _gamid = 10,
              _round = 1,
              _battle = {
                _index = 1,
                _self_user = {},
                _oppo_type = "monster",
                _oppo_user = {},
                _rseed = 462,
                _self_team = {
                  _heroes = {
                    {_insid = 10, _hid = 101},
                    {_insid = 11, _hid = 201}
                  },
                  _positions = {1, 6}
                },
                _oppo_team = {
                  _heroes = {
                    {
                      _insid = 100,
                      _hid = self.baseData.round_1[self.baseData.round_1[1]["Oppo ID"]].Lineup[1]
                    }
                  },
                  _positions = {1}
                }
              },
              _result = "victory",
              _time = 90
            },
            _events = {}
          },
          [2] = {
            _record = {
              _checkid = 12440,
              _gamid = 10,
              _round = 1,
              _battle = {
                _index = 2,
                _self_user = {},
                _oppo_type = "monster",
                _oppo_user = {},
                _rseed = 462,
                _self_team = {
                  _heroes = {
                    {_insid = 1, _hid = 201},
                    {_insid = 10, _hid = 3201}
                  },
                  _positions = {1, 6}
                },
                _oppo_team = {
                  _heroes = {
                    {
                      _insid = 101,
                      _hid = self.baseData.round_2[self.baseData.round_2[1]["Oppo ID"]].Lineup[1]
                    }
                  },
                  _positions = {1}
                }
              },
              _result = "victory",
              _time = 90
            },
            _events = {}
          },
          [3] = {
            _record = {
              _checkid = 12440,
              _gamid = 10,
              _round = 1,
              _battle = {
                _index = 2,
                _self_user = {},
                _oppo_type = "player",
                _oppo_user = {},
                _rseed = 462,
                _self_team = {
                  _heroes = {
                    {_insid = 1, _hid = 202},
                    {_insid = 22, _hid = 1001}
                  },
                  _positions = {1, 6}
                },
                _oppo_team = {
                  _heroes = {
                    {
                      _insid = 104,
                      _hid = self.baseData.round_3[self.baseData.round_3[1]["Oppo ID"]].Lineup[1]
                    },
                    {
                      _insid = 105,
                      _hid = self.baseData.round_3[self.baseData.round_3[1]["Oppo ID"]].Lineup[2]
                    }
                  },
                  _positions = {1, 6}
                }
              },
              _result = "victory",
              _time = 90
            },
            _events = {}
          }
        },
        over = {
          [1] = {
            _hp = self.baseData.round_1[1].HP,
            _gold = 10,
            _end_time = 0,
            _max_hp = self.baseData.round_1[1]["Max HP"]
          },
          [2] = {
            _hp = self.baseData.round_2[1].HP,
            _gold = 10,
            _end_time = 0,
            _max_hp = self.baseData.round_2[1]["Max HP"]
          },
          [3] = {
            _hp = self.baseData.round_3[1].HP,
            _gold = 10,
            _end_time = 0,
            _max_hp = self.baseData.round_3[1]["Max HP"]
          }
        }
      }
    },
    replyData = {
      buychess = {
        step_1 = {
          _hero = {
            _insid = 1,
            _hid = self.baseData.round_1[1].Shop[1]
          },
          _gold = 1
        },
        step_6 = {
          _hero = {
            _insid = 6,
            _hid = self.baseData.round_2[1].Shop[1]
          },
          _gold = 1
        },
        step_10 = {
          _hero = {
            _insid = 11,
            _hid = self.baseData.round_3[1].Shop[1]
          },
          _gold = 9
        },
        step_11 = {
          _hero = {
            _insid = 12,
            _hid = self.baseData.round_3[1].Shop[2]
          },
          _compose_rcds = {
            {
              _hero_insids = {11, 12},
              _hero = {_insid = 1, _hid = 202}
            }
          },
          _gold = 8
        },
        step_12 = {
          _hero = {
            _insid = 13,
            _hid = self.baseData.round_3[1].Shop[3]
          },
          _gold = 6
        }
      },
      buyexp = {
        _level = 3,
        _exp = 2,
        _gold = 4
      }
    }
  }
end

function class:dispatchGuideNotify(type, subtype, round)
  if 4 <= round then
    return
  end
  if type == "start" then
  elseif type == "round" then
    local data = {}
    data._round_num = round
    local roundData = self.guideData.roudData
    if subtype == "start" then
      data._round_start = roundData.round.start[round]
      ed.AutoChessManager:handlerRoundNotify(data)
    elseif subtype == "prepare" then
      data._round_prepare = roundData.round.prepare[round]
      data._round_prepare._end_time = ed.getServerTime() + 30
      ed.AutoChessManager:handlerRoundNotify(data)
    elseif subtype == "lock" then
      data._round_lock = {
        _team = {
          _heroes = {},
          _positions = {}
        }
      }
      local battleHeroData = ed.AutoChessModel:getBattleHeroData()
      for k, battleHero in pairs(battleHeroData) do
        local chessHero = ed.AutoChessModel:getChessHeroBySid(battleHero.heroSid)
        table.insert(data._round_lock._team._heroes, {
          _insid = chessHero:getHeroInsid(),
          _hid = chessHero:getChessId()
        })
        table.insert(data._round_lock._team._positions, battleHero.posIndex)
      end
      ed.AutoChessManager:handlerRoundNotify(data)
    elseif subtype == "battle" then
      ed.AutoChessModel:setWinGold(1)
      ed.AutoChessModel:setBattleResult("victory")
      data._round_battle = roundData.round.battle[round]
      local recordData = data._round_battle._record
      recordData._battle._self_team = {
        _heroes = {},
        _positions = {}
      }
      local battleHeroData = ed.AutoChessModel:getBattleHeroData()
      for k, battleHero in pairs(battleHeroData) do
        local chessHero = ed.AutoChessModel:getChessHeroBySid(battleHero.heroSid)
        table.insert(recordData._battle._self_team._heroes, {
          _insid = chessHero:getHeroInsid(),
          _hid = chessHero:getChessId()
        })
        table.insert(recordData._battle._self_team._positions, battleHero.posIndex)
      end
      ed.AutoChessManager:handlerRoundNotify(data)
    elseif subtype == "over" then
      data._round_over = roundData.round.over[round]
      data._round_over._end_time = ed.getServerTime() + 5
      ed.AutoChessManager:handlerRoundNotify(data)
    end
  end
end

function class:dispatchGuideReply(type)
  print("<<<<<<<<<<< dispatchGuideReply >>>>>>>>>>>>" .. type .. "_" .. self.curStep)
  if type == "buychess" then
    local data = self.guideData.replyData[type]["step_" .. self.curStep]
    ed.AutoChessManager:handlerBuyHero(data)
    if self.curStep == 6 then
      FireEvent("EventCloseChessShop")
    end
  elseif type == "buyexp" then
    local data = self.guideData.replyData[type]
    ed.AutoChessManager:handlerBuyExp(data)
  elseif type == "sellhero" then
  elseif type == "shoprefresh" then
    local shopdata = self.guideData.replyData.shoprefresh
    ed.AutoChessManager:handlerShopRefresh(shopdata)
  elseif type == "shoplock" then
  elseif type == "equippet" then
  elseif type == "replacepet" then
  end
end

function class:handlerRookieStart(data)
  local summary = data._summary
  if summary then
    local users = summary._users
    for _, v in pairs(summary._users) do
      v._user_summary._name = T(v._user_summary._name)
    end
    ed.AutoChessModel:setPlayerList(users)
  end
  self:setGuideFlag(1)
  ed.popScene()
  ed.pushScene(ed.ui.AutoChessLoadScene.create())
end

function class:handlerRookieFinish(data)
  local notofy = data._notify
  ed.AutoChessManager.gameId = notofy._game_id
  ed.AutoChessManager.gameAddr = notofy._game_addr
  ed.AutoChessManager.guideFlag = 0
  if notofy._game_id ~= 0 then
    local ip, port, svrid = ed.getIPPortFromString(notofy._game_addr)
    ed.AutoChessNetwork:doGameConnect(ip, port, svrid)
    self:setGuideFlag(0)
  end
end

function class:handlerRookieResolve(data)
  if data._result == "success" then
    ed.AutoChessManager.guideFlag = 0
    self:setGuideFlag(0)
    FireEvent("EventResolveRookie")
  end
end

ed.AutoChessTeachManager = class.getInstance()
