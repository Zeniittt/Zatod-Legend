local class = newclass()
ed.ui.stageselectres = class

local function getStageIcon(id)
  local isElite = ed.stageType(id) == "elite"
  local st = ed.getDataTable("Stage")
  local row = st[id]
  if row["Awake Icon"] then
    return "UI/alpha/HVGA/" .. row["Awake Icon"]
  end
  local cid = row["Chapter ID"]
  local sid = isElite and row["Stage Group"] or id
  local sres = class.map["chapter" .. cid].stage
  for i = 1, #sres do
    local v = sres[i]
    if v.id == sid then
      sid = v.resid or v.id
      break
    end
  end
  local res = string.format("UI/alpha/1080P/campaign/key_stages/stage-%d.png", sid)
  return res
end

class.getStageIcon = getStageIcon

local function getChapterStageEid(chapter, stage)
  local sres = class.map["chapter" .. chapter].stage
  for i = 1, #sres do
    local v = sres[i]
    if v.eid and v.eid == stage then
      return v.id
    end
  end
  return
end

class.getChapterStageEid = getChapterStageEid

local function getChapterIcon(cid)
  local sid = ""
  local sres = class.map["chapter" .. cid].stage
  for i = 1, #sres do
    local v = sres[i]
    if v.eid then
      sid = v.resid or v.id
      break
    end
  end
  local res = string.format("UI/alpha/1080P/campaign/key_stages/stage-%d.png", sid)
  return res
end

class.getChapterIcon = getChapterIcon

local function getChapterDefaultStage(cid, isElite)
  local sid = 0
  local sres = class.map["chapter" .. cid].stage
  for i = 1, #sres do
    local v = sres[i]
    if isElite then
      if v.eid then
        sid = v.eid
        break
      end
    else
      sid = v.id
      break
    end
  end
  return sid
end

class.getChapterDefaultStage = getChapterDefaultStage

local function getStageBossId(eid)
  local monsterId
  for _, v in ipairs(ed.getDataTable("Battle")[eid]) do
    if v["Boss Position"] > 0 then
      monsterId = v[string.format("Monster %s ID", v["Boss Position"])]
      break
    end
  end
  return monsterId
end

class.getStageBossId = getStageBossId
local stageRes = {}
stageRes = {
  locked = "UI/alpha/1080P/campaign/stagecircle_skeleton%d.png",
  passed = "UI/alpha/1080P/campaign/stagecircle_elite.png",
  current = "UI/alpha/1080P/campaign/stagecircle_current.png",
  elite = "UI/alpha/1080P/campaign/stagecircle_elite.png"
}
class.stageRes = stageRes
local keyStageRes = {}
keyStageRes = {
  icon = {
    locked = "UI/alpha/1080P/campaign/key_stages/stage-%d-locked.png",
    passed = "UI/alpha/1080P/campaign/key_stages/stage-%d.png",
    current = "UI/alpha/1080P/campaign/key_stages/stage-%d.png"
  },
  mask = {
    passed = "UI/alpha/1080P/campaign/key_stages/stage-%d-passed.png",
    current = "UI/alpha/1080P/campaign/key_stages/stage-%d-current.png"
  }
}
class.keyStageRes = keyStageRes
local map = {}
map.chapter1 = {
  tag = 1,
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_1.png",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map1.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(217.47, 185.18),
      id = 1,
      eid = 10001,
      challengeInstanceId = {
        11001,
        12001,
        13001
      }
    },
    {
      pos = ccp(147, 250),
      id = 2
    },
    {
      pos = ccp(133.12, 298.78),
      id = 3
    },
    {
      pos = ccp(220.97, 362.68),
      id = 4,
      eid = 10002,
      challengeInstanceId = {
        11002,
        12002,
        13002
      }
    },
    {
      pos = ccp(321.27, 380.46),
      id = 5
    },
    {
      pos = ccp(378.11, 362.68),
      id = 6
    },
    {
      pos = ccp(385.43, 281.1),
      id = 7,
      eid = 10003,
      challengeInstanceId = {
        11003,
        12003,
        13003
      }
    },
    {
      pos = ccp(461.39, 215.34),
      id = 8
    },
    {
      pos = ccp(512.91, 171.04),
      id = 9
    },
    {
      pos = ccp(576.74, 163.9),
      id = 10
    },
    {
      pos = ccp(699.23, 181.68),
      id = 11,
      eid = 10004,
      challengeInstanceId = {
        11004,
        12004,
        13004
      }
    },
    {
      pos = ccp(798.62, 192.32),
      id = 12
    },
    {
      pos = ccp(837.68, 226.06),
      id = 13
    },
    {
      pos = ccp(805.76, 265.04),
      id = 14
    },
    {
      pos = ccp(779.17, 343.15),
      id = 15,
      eid = 10005,
      challengeInstanceId = {
        11005,
        12005,
        13005
      }
    },
    {
      pos = ccp(702.87, 421.27),
      id = 16
    },
    {
      pos = ccp(642.54, 387.53),
      id = 17
    },
    {
      pos = ccp(551.96, 352.04),
      id = 18,
      eid = 10006,
      challengeInstanceId = {
        11006,
        12006,
        13006
      }
    }
  }
}
map.chapter2 = {
  tag = 1,
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_2.png",
    pos = ccp(402, 210)
  },
  route = {
    res = "UI/alpha/HVGA/map2.png",
    pos = ccp(402, 210)
  },
  stage = {
    {
      pos = ccp(120.66, 155.1),
      id = 19
    },
    {
      pos = ccp(221.23, 150.51),
      id = 20,
      eid = 10007,
      challengeInstanceId = {
        11007,
        12007,
        13007
      },
      z = 99
    },
    {
      pos = ccp(269.75, 236.69),
      id = 21
    },
    {
      pos = ccp(218.23, 257.97),
      id = 22
    },
    {
      pos = ccp(163.78, 330.2),
      id = 23,
      eid = 10008,
      resid = 7,
      challengeInstanceId = {
        11008,
        12008,
        13008
      },
      z = 99
    },
    {
      pos = ccp(225.37, 391.1),
      id = 24
    },
    {
      pos = ccp(275, 423),
      id = 25
    },
    {
      pos = ccp(333.73, 419.44),
      id = 26
    },
    {
      pos = ccp(427.88, 380.52),
      id = 27,
      eid = 10009,
      challengeInstanceId = {
        11009,
        12009,
        13009
      }
    },
    {
      pos = ccp(424.34, 282.61),
      id = 28
    },
    {
      pos = ccp(384.79, 231.38),
      id = 29
    },
    {
      pos = ccp(447.71, 179.29),
      id = 30,
      eid = 10010,
      challengeInstanceId = {
        11010,
        12010,
        13010
      }
    },
    {
      pos = ccp(575.25, 249.33),
      id = 31
    },
    {
      pos = ccp(555.54, 303.24),
      id = 32
    },
    {
      pos = ccp(643.53, 367.92),
      id = 33,
      eid = 10011,
      challengeInstanceId = {
        11011,
        12011,
        13011
      }
    },
    {
      pos = ccp(746, 412.89),
      id = 34
    },
    {
      pos = ccp(798, 393.11),
      id = 35
    },
    {
      pos = ccp(814.27, 296.06),
      id = 36,
      eid = 10012,
      challengeInstanceId = {
        11012,
        12012,
        13012
      }
    },
    {
      pos = ccp(810.62, 173.87),
      id = 37
    },
    {
      pos = ccp(772.9, 137.91),
      id = 38
    },
    {
      pos = ccp(659.71, 156.33),
      id = 39,
      eid = 10013,
      challengeInstanceId = {
        11013,
        12013,
        13013
      }
    }
  }
}
map.chapter3 = {
  tag = 3,
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_3.png",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map3.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(108.05, 380.52),
      id = 40
    },
    {
      pos = ccp(163.78, 398.47),
      id = 41
    },
    {
      pos = ccp(240.15, 351.8),
      id = 42,
      eid = 10014,
      challengeInstanceId = {
        11014,
        12014,
        13014
      }
    },
    {
      pos = ccp(135.06, 222.37),
      id = 43
    },
    {
      pos = ccp(145.78, 175.7),
      id = 44
    },
    {
      pos = ccp(249.16, 143.33),
      id = 45,
      eid = 10015,
      challengeInstanceId = {
        11015,
        12015,
        13015
      }
    },
    {
      pos = ccp(382.97, 155.92),
      id = 46
    },
    {
      pos = ccp(434.15, 188.23),
      id = 47
    },
    {
      pos = ccp(457.51, 276.28),
      id = 48,
      eid = 10016,
      challengeInstanceId = {
        11016,
        12016,
        13016
      }
    },
    {
      pos = ccp(513.25, 393.11),
      id = 49
    },
    {
      pos = ccp(559.98, 407.47),
      id = 50
    },
    {
      pos = ccp(649.8, 382.34),
      id = 51,
      eid = 10017,
      challengeInstanceId = {
        11017,
        12017,
        13017
      }
    },
    {
      pos = ccp(824.19, 332.02),
      id = 52
    },
    {
      pos = ccp(777.46, 256.56),
      id = 53,
      eid = 10018,
      challengeInstanceId = {
        11018,
        12018,
        13018
      }
    },
    {
      pos = ccp(703.71, 139.73),
      id = 54
    },
    {
      pos = ccp(605.54, 156.69),
      id = 55,
      eid = 10019,
      challengeInstanceId = {
        11019,
        12019,
        13019
      }
    }
  }
}
map.chapter4 = {
  tag = 4,
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_4.png",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map4.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(167.32, 112.78),
      id = 56
    },
    {
      pos = ccp(107, 143),
      id = 57
    },
    {
      pos = ccp(197, 223),
      id = 58,
      eid = 10020,
      challengeInstanceId = {
        11020,
        12020,
        13020
      }
    },
    {
      pos = ccp(310, 124),
      id = 59
    },
    {
      pos = ccp(403, 175),
      id = 60,
      eid = 10021,
      challengeInstanceId = {
        11021,
        12021,
        13021
      }
    },
    {
      pos = ccp(129, 319),
      id = 61
    },
    {
      pos = ccp(152, 364),
      id = 62
    },
    {
      pos = ccp(255, 396),
      id = 63,
      eid = 10022,
      resid = 7,
      challengeInstanceId = {
        11022,
        12022,
        13022
      }
    },
    {
      pos = ccp(380, 340),
      id = 64
    },
    {
      pos = ccp(434, 302),
      id = 65
    },
    {
      pos = ccp(501, 396),
      id = 66,
      eid = 10023,
      challengeInstanceId = {
        11023,
        12023,
        13023
      }
    },
    {
      pos = ccp(632, 399),
      id = 67
    },
    {
      pos = ccp(660, 345),
      id = 68
    },
    {
      pos = ccp(605, 256),
      id = 69,
      eid = 10024,
      resid = 20,
      challengeInstanceId = {
        11024,
        12024,
        13024
      }
    },
    {
      pos = ccp(639, 142),
      id = 70
    },
    {
      pos = ccp(747, 144),
      id = 71,
      eid = 10025,
      challengeInstanceId = {
        11025,
        12025,
        13025
      }
    },
    {
      pos = ccp(874, 247),
      id = 72
    },
    {
      pos = ccp(855, 301),
      id = 73
    },
    {
      pos = ccp(808, 399),
      id = 74,
      eid = 10026,
      challengeInstanceId = {
        11026,
        12026,
        13026
      }
    }
  }
}
map.chapter5 = {
  tag = 5,
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_5.png",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map5.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(307, 118),
      id = 75
    },
    {
      pos = ccp(197, 163),
      id = 76,
      eid = 10027,
      challengeInstanceId = {
        11027,
        12027,
        13027
      }
    },
    {
      pos = ccp(132, 248),
      id = 77
    },
    {
      pos = ccp(177, 301),
      id = 78
    },
    {
      pos = ccp(181, 386),
      id = 79,
      eid = 10028,
      challengeInstanceId = {
        11028,
        12028,
        13028
      }
    },
    {
      pos = ccp(294, 415),
      id = 80
    },
    {
      pos = ccp(346, 388),
      id = 81
    },
    {
      pos = ccp(348, 283),
      id = 82,
      eid = 10029,
      challengeInstanceId = {
        11029,
        12029,
        13029
      }
    },
    {
      pos = ccp(409, 174),
      id = 83
    },
    {
      pos = ccp(469, 192),
      id = 84
    },
    {
      pos = ccp(538, 300),
      id = 85,
      eid = 10030,
      challengeInstanceId = {
        11030,
        12030,
        13030
      },
      z = 99
    },
    {
      pos = ccp(515, 395),
      id = 86
    },
    {
      pos = ccp(578, 413),
      id = 87
    },
    {
      pos = ccp(682, 398),
      id = 88,
      eid = 10031,
      challengeInstanceId = {
        11031,
        12031,
        13031
      }
    },
    {
      pos = ccp(788, 390),
      id = 89
    },
    {
      pos = ccp(826, 337),
      id = 90
    },
    {
      pos = ccp(804, 248),
      id = 91,
      eid = 10032,
      challengeInstanceId = {
        11032,
        12032,
        13032
      }
    },
    {
      pos = ccp(794, 143),
      id = 92
    },
    {
      pos = ccp(729, 129),
      id = 93
    },
    {
      pos = ccp(628, 151),
      id = 94,
      eid = 10033,
      challengeInstanceId = {
        11033,
        12033,
        13033
      }
    }
  }
}
map.chapter6 = {
  tag = 6,
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_6.png",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map6.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(159, 395),
      id = 95,
      eid = 10034,
      challengeInstanceId = {
        11034,
        12034,
        13034
      }
    },
    {
      pos = ccp(253, 321),
      id = 96
    },
    {
      pos = ccp(271, 276),
      id = 97
    },
    {
      pos = ccp(170, 240),
      id = 98,
      eid = 10035,
      challengeInstanceId = {
        11035,
        12035,
        13035
      }
    },
    {
      pos = ccp(134, 154),
      id = 99
    },
    {
      pos = ccp(192, 120),
      id = 100
    },
    {
      pos = ccp(316, 138),
      id = 101,
      eid = 10036,
      challengeInstanceId = {
        11036,
        12036,
        13036
      }
    },
    {
      pos = ccp(443, 133),
      id = 102
    },
    {
      pos = ccp(495, 154),
      id = 103
    },
    {
      pos = ccp(488, 244),
      id = 104,
      eid = 10037,
      challengeInstanceId = {
        11037,
        12037,
        13037
      }
    },
    {
      pos = ccp(389, 292),
      id = 105
    },
    {
      pos = ccp(366, 334),
      id = 106
    },
    {
      pos = ccp(438, 400),
      id = 107,
      eid = 10038,
      challengeInstanceId = {
        11038,
        12038,
        13038
      }
    },
    {
      pos = ccp(567, 411),
      id = 108
    },
    {
      pos = ccp(671, 398),
      id = 109,
      eid = 10039,
      challengeInstanceId = {
        11039,
        12039,
        13039
      }
    },
    {
      pos = ccp(801, 398),
      id = 110
    },
    {
      pos = ccp(839, 345),
      id = 111
    },
    {
      pos = ccp(812, 248),
      id = 112,
      eid = 10040,
      challengeInstanceId = {
        11040,
        12040,
        13040
      }
    },
    {
      pos = ccp(790, 125),
      id = 113
    },
    {
      pos = ccp(687, 150),
      id = 114,
      eid = 10041,
      challengeInstanceId = {
        11041,
        12041,
        13041
      }
    }
  }
}
map.chapter7 = {
  tag = 4,
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_7.png",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map7.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(255, 135),
      id = 115
    },
    {
      pos = ccp(203, 162),
      id = 116,
      z = 99
    },
    {
      pos = ccp(174, 243),
      id = 117,
      eid = 10042,
      guildInstanceId = 40001,
      challengeInstanceId = {
        11042,
        12042,
        13042
      }
    },
    {
      pos = ccp(165, 365),
      id = 118
    },
    {
      pos = ccp(213, 403),
      id = 119
    },
    {
      pos = ccp(312, 380),
      id = 120,
      eid = 10043,
      guildInstanceId = 40002,
      challengeInstanceId = {
        11043,
        12043,
        13043
      }
    },
    {
      pos = ccp(431, 408),
      id = 121
    },
    {
      pos = ccp(486, 414),
      id = 122
    },
    {
      pos = ccp(580, 405),
      id = 123,
      eid = 10044,
      guildInstanceId = 40003,
      challengeInstanceId = {
        11044,
        12044,
        13044
      }
    },
    {
      pos = ccp(740, 423),
      id = 124
    },
    {
      pos = ccp(797, 398),
      id = 125
    },
    {
      pos = ccp(736, 315),
      id = 126,
      eid = 10045,
      guildInstanceId = 40004,
      challengeInstanceId = {
        11045,
        12045,
        13045
      }
    },
    {
      pos = ccp(553, 281),
      id = 127
    },
    {
      pos = ccp(499, 265),
      id = 128
    },
    {
      pos = ccp(414, 256),
      id = 129,
      eid = 10046,
      guildInstanceId = 40005,
      challengeInstanceId = {
        11046,
        12046,
        13046
      }
    },
    {
      pos = ccp(411, 135),
      id = 130
    },
    {
      pos = ccp(467, 128),
      id = 131
    },
    {
      pos = ccp(569, 159),
      id = 132,
      eid = 10047,
      guildInstanceId = 40006,
      challengeInstanceId = {
        11047,
        12047,
        13047
      }
    },
    {
      pos = ccp(709, 160),
      id = 133
    },
    {
      pos = ccp(812, 194),
      id = 134,
      eid = 10048,
      guildInstanceId = 40007,
      challengeInstanceId = {
        11048,
        12048,
        13048
      }
    }
  },
  guildInstance = true
}
map.chapter8 = {
  tag = 3,
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_8.png",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map8.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(120, 392),
      id = 135
    },
    {
      pos = ccp(183, 412),
      id = 136
    },
    {
      pos = ccp(290, 405),
      id = 137,
      eid = 10049,
      guildInstanceId = 40008,
      challengeInstanceId = {
        11049,
        12049,
        13049
      }
    },
    {
      pos = ccp(301, 320),
      id = 138
    },
    {
      pos = ccp(229, 299),
      id = 139
    },
    {
      pos = ccp(152, 264),
      id = 140,
      eid = 10050,
      guildInstanceId = 40009,
      challengeInstanceId = {
        11050,
        12050,
        13050
      }
    },
    {
      pos = ccp(98, 133),
      id = 141
    },
    {
      pos = ccp(175, 124),
      id = 142
    },
    {
      pos = ccp(292, 144),
      id = 143,
      eid = 10051,
      guildInstanceId = 40010,
      challengeInstanceId = {
        11051,
        12051,
        13051
      }
    },
    {
      pos = ccp(400, 169),
      id = 144
    },
    {
      pos = ccp(452, 198),
      id = 145
    },
    {
      pos = ccp(467, 284),
      id = 146,
      eid = 10052,
      guildInstanceId = 40011,
      challengeInstanceId = {
        11052,
        12052,
        13052
      },
      z = 1
    },
    {
      pos = ccp(515, 383),
      id = 147
    },
    {
      pos = ccp(573, 410),
      id = 148
    },
    {
      pos = ccp(675, 363),
      id = 149,
      eid = 10053,
      guildInstanceId = 40012,
      challengeInstanceId = {
        11053,
        12053,
        13053
      }
    },
    {
      pos = ccp(591, 236),
      id = 150
    },
    {
      pos = ccp(610, 177),
      id = 151
    },
    {
      pos = ccp(715, 157),
      id = 152,
      eid = 10054,
      guildInstanceId = 40013,
      challengeInstanceId = {
        11054,
        12054,
        13054
      }
    },
    {
      pos = ccp(824, 207),
      id = 153
    },
    {
      pos = ccp(822, 301),
      id = 154,
      eid = 10055,
      guildInstanceId = 40014,
      challengeInstanceId = {
        11055,
        12055,
        13055
      }
    }
  },
  guildInstance = true
}
map.chapter9 = {
  tag = 1,
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_9.png",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map9.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(136, 135),
      id = 155
    },
    {
      pos = ccp(222, 130),
      id = 156
    },
    {
      pos = ccp(269, 218),
      id = 157,
      eid = 10056,
      guildInstanceId = 40015
    },
    {
      pos = ccp(175, 261),
      id = 158
    },
    {
      pos = ccp(136, 315),
      id = 159
    },
    {
      pos = ccp(201, 401),
      id = 160,
      eid = 10057,
      guildInstanceId = 40016
    },
    {
      pos = ccp(301, 331),
      id = 161
    },
    {
      pos = ccp(391, 389),
      id = 162,
      eid = 10058,
      guildInstanceId = 40017
    },
    {
      pos = ccp(495, 337),
      id = 163
    },
    {
      pos = ccp(492, 281),
      id = 164
    },
    {
      pos = ccp(436, 184),
      id = 165,
      eid = 10059,
      guildInstanceId = 40018
    },
    {
      pos = ccp(560, 159),
      id = 166
    },
    {
      pos = ccp(679, 175),
      id = 167,
      eid = 10060,
      guildInstanceId = 40019,
      z = 99
    },
    {
      pos = ccp(605, 270),
      id = 168
    },
    {
      pos = ccp(637, 322),
      id = 169,
      z = 99
    },
    {
      pos = ccp(594, 394),
      id = 170,
      eid = 10061,
      guildInstanceId = 40020
    },
    {
      pos = ccp(715, 430),
      id = 171
    },
    {
      pos = ccp(792, 412),
      id = 172
    },
    {
      pos = ccp(837, 356),
      id = 173
    },
    {
      pos = ccp(801, 245),
      id = 174,
      eid = 10062,
      guildInstanceId = 40021
    }
  },
  guildInstance = true
}
map.chapter10 = {
  tag = 1,
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_10.png",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map10.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(111, 160),
      id = 175
    },
    {
      pos = ccp(211, 159),
      id = 176,
      eid = 10063,
      guildInstanceId = 40022,
      z = 1
    },
    {
      pos = ccp(258, 243),
      id = 177
    },
    {
      pos = ccp(201, 263),
      id = 178
    },
    {
      pos = ccp(149, 369),
      id = 179,
      eid = 10064,
      guildInstanceId = 40023
    },
    {
      pos = ccp(267, 423),
      id = 180
    },
    {
      pos = ccp(393, 385),
      id = 181,
      eid = 10065,
      guildInstanceId = 40024
    },
    {
      pos = ccp(416, 290),
      id = 182
    },
    {
      pos = ccp(373, 238),
      id = 183
    },
    {
      pos = ccp(441, 182),
      id = 184,
      eid = 10066,
      guildInstanceId = 40025
    },
    {
      pos = ccp(528, 220),
      id = 185
    },
    {
      pos = ccp(569, 306),
      id = 186
    },
    {
      pos = ccp(639, 383),
      id = 187,
      eid = 10067,
      guildInstanceId = 40026
    },
    {
      pos = ccp(745, 425),
      id = 188
    },
    {
      pos = ccp(801, 403),
      id = 189
    },
    {
      pos = ccp(813, 320),
      id = 190,
      eid = 10068,
      guildInstanceId = 40027
    },
    {
      pos = ccp(821, 229),
      id = 191
    },
    {
      pos = ccp(812, 178),
      id = 192
    },
    {
      pos = ccp(772, 141),
      id = 193
    },
    {
      pos = ccp(655, 165),
      id = 194,
      eid = 10069,
      guildInstanceId = 40028
    }
  },
  guildInstance = true
}
map.chapter11 = {
  tag = 3,
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_11.png",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map11.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(111, 390),
      id = 195
    },
    {
      pos = ccp(168, 410),
      id = 196
    },
    {
      pos = ccp(267, 376),
      id = 197,
      eid = 10070,
      guildInstanceId = 40029
    },
    {
      pos = ccp(215, 275),
      id = 198
    },
    {
      pos = ccp(138, 222),
      id = 199
    },
    {
      pos = ccp(186, 189),
      id = 200,
      eid = 10071,
      guildInstanceId = 40030
    },
    {
      pos = ccp(283, 130),
      id = 201
    },
    {
      pos = ccp(357, 132),
      id = 202
    },
    {
      pos = ccp(384, 235),
      id = 203,
      eid = 10072,
      guildInstanceId = 40031
    },
    {
      pos = ccp(519, 220),
      id = 204
    },
    {
      pos = ccp(519, 277),
      id = 205
    },
    {
      pos = ccp(472, 390),
      id = 206,
      eid = 10073,
      guildInstanceId = 40032
    },
    {
      pos = ccp(555, 414),
      id = 207
    },
    {
      pos = ccp(616, 421),
      id = 208
    },
    {
      pos = ccp(723, 390),
      id = 209,
      eid = 10074,
      guildInstanceId = 40033
    },
    {
      pos = ccp(855, 414),
      id = 210
    },
    {
      pos = ccp(851, 340),
      id = 211
    },
    {
      pos = ccp(772, 257),
      id = 212,
      eid = 10075,
      guildInstanceId = 40034
    },
    {
      pos = ccp(727, 144),
      id = 213
    },
    {
      pos = ccp(621, 148),
      id = 214,
      eid = 10076,
      guildInstanceId = 40035
    }
  },
  guildInstance = true
}
map.chapter12 = {
  tag = 4,
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_12.png",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map12.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(294, 117),
      id = 215
    },
    {
      pos = ccp(182, 176.5),
      id = 216,
      eid = 10077,
      guildInstanceId = 40036,
      z = 99
    },
    {
      pos = ccp(96, 225),
      id = 217
    },
    {
      pos = ccp(157, 350),
      id = 218,
      eid = 10078,
      guildInstanceId = 40037
    },
    {
      pos = ccp(256, 440),
      id = 219
    },
    {
      pos = ccp(323, 428),
      id = 220
    },
    {
      pos = ccp(328, 303),
      id = 221,
      eid = 10079,
      guildInstanceId = 40038
    },
    {
      pos = ccp(301, 198),
      id = 222,
      z = 99
    },
    {
      pos = ccp(335, 157),
      id = 223
    },
    {
      pos = ccp(452, 166),
      id = 224,
      eid = 10080,
      guildInstanceId = 40039
    },
    {
      pos = ccp(551, 268),
      id = 225
    },
    {
      pos = ccp(489.5, 367.7),
      id = 226,
      eid = 10081,
      guildInstanceId = 40040,
      z = 99
    },
    {
      pos = ccp(571, 439),
      id = 227
    },
    {
      pos = ccp(639, 434),
      id = 228
    },
    {
      pos = ccp(727.6, 404.4),
      id = 229,
      eid = 10082,
      guildInstanceId = 40041
    },
    {
      pos = ccp(852, 420),
      id = 230
    },
    {
      pos = ccp(831.6, 258.2),
      id = 231,
      eid = 10083,
      guildInstanceId = 40042
    },
    {
      pos = ccp(820, 148),
      id = 232
    },
    {
      pos = ccp(749, 133),
      id = 233
    },
    {
      pos = ccp(637.8, 168.4),
      id = 234,
      eid = 10084,
      guildInstanceId = 40043
    }
  },
  guildInstance = true,
  lootStage = {
    pos = ccp(630, 255),
    eid = 10901,
    z = 999,
    bossId = getStageBossId(10901),
    show = function()
      return ed.player:getEliteStageProgress() > 10090
    end
  }
}
map.chapter13 = {
  tag = 6,
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_13.png",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map13.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(102, 385),
      id = 235
    },
    {
      pos = ccp(158, 407),
      id = 236
    },
    {
      pos = ccp(244, 329),
      id = 237,
      eid = 10085,
      guildInstanceId = 40044
    },
    {
      pos = ccp(131, 223),
      id = 238
    },
    {
      pos = ccp(143, 171),
      id = 239
    },
    {
      pos = ccp(242, 132),
      id = 240,
      eid = 10086,
      guildInstanceId = 40045
    },
    {
      pos = ccp(388, 155),
      id = 241
    },
    {
      pos = ccp(441, 189),
      id = 242
    },
    {
      pos = ccp(465, 277),
      id = 243,
      eid = 10087,
      guildInstanceId = 40046
    },
    {
      pos = ccp(520, 399),
      id = 244
    },
    {
      pos = ccp(571, 408),
      id = 245
    },
    {
      pos = ccp(668, 387),
      id = 246,
      eid = 10088,
      guildInstanceId = 40047
    },
    {
      pos = ccp(847, 335),
      id = 247
    },
    {
      pos = ccp(799, 239),
      id = 248,
      eid = 10089,
      guildInstanceId = 40048
    },
    {
      pos = ccp(722, 139),
      id = 249
    },
    {
      pos = ccp(617, 152),
      id = 250,
      eid = 10090,
      guildInstanceId = 40049
    }
  },
  guildInstance = true,
  lootStage = {
    pos = ccp(400, 360),
    eid = 10902,
    z = 999,
    bossId = getStageBossId(10902),
    show = function()
      return ed.player:getEliteStageProgress() > 10090
    end
  }
}
map.chapter14 = {
  tag = 3,
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_14.png",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map14.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(168, 414),
      id = 251
    },
    {
      pos = ccp(226, 414),
      id = 252
    },
    {
      pos = ccp(323, 403),
      id = 253,
      eid = 10091
    },
    {
      pos = ccp(336, 319),
      id = 254
    },
    {
      pos = ccp(270, 303),
      id = 255
    },
    {
      pos = ccp(193, 266),
      id = 256,
      eid = 10092
    },
    {
      pos = ccp(150, 148),
      id = 257
    },
    {
      pos = ccp(221, 142),
      id = 258
    },
    {
      pos = ccp(324, 170),
      id = 259,
      eid = 10093
    },
    {
      pos = ccp(425, 184),
      id = 260
    },
    {
      pos = ccp(474, 209),
      id = 261
    },
    {
      pos = ccp(484, 285),
      id = 262,
      eid = 10094,
      z = 99
    },
    {
      pos = ccp(533, 378),
      id = 263
    },
    {
      pos = ccp(583, 402),
      id = 264
    },
    {
      pos = ccp(680, 354),
      id = 265,
      eid = 10095
    },
    {
      pos = ccp(600, 240),
      id = 266
    },
    {
      pos = ccp(616, 186),
      id = 267
    },
    {
      pos = ccp(715, 158),
      id = 268,
      eid = 10096,
      z = 99
    },
    {
      pos = ccp(815, 216),
      id = 269
    },
    {
      pos = ccp(811, 311),
      id = 270,
      eid = 10097
    }
  },
  guildInstance = true
}
map.chapter15 = {
  tag = 4,
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_3.png",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map15.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(142, 68),
      id = 269
    },
    {
      pos = ccp(96, 94),
      id = 270
    },
    {
      pos = ccp(168, 154),
      id = 271,
      eid = 10097,
      guildInstanceId = 40056
    },
    {
      pos = ccp(257, 76),
      id = 272
    },
    {
      pos = ccp(331, 122),
      id = 273,
      eid = 10098,
      guildInstanceId = 40057
    },
    {
      pos = ccp(109, 235),
      id = 274
    },
    {
      pos = ccp(131, 272),
      id = 275
    },
    {
      pos = ccp(211, 297),
      id = 276,
      eid = 10099,
      guildInstanceId = 40058
    },
    {
      pos = ccp(314, 252),
      id = 277
    },
    {
      pos = ccp(356, 222),
      id = 278
    },
    {
      pos = ccp(411, 307),
      id = 279,
      eid = 10100,
      guildInstanceId = 40059
    },
    {
      pos = ccp(516, 300),
      id = 280
    },
    {
      pos = ccp(538, 258),
      id = 281
    },
    {
      pos = ccp(493, 186),
      id = 282,
      eid = 10101,
      guildInstanceId = 40060
    },
    {
      pos = ccp(523, 93),
      id = 283
    },
    {
      pos = ccp(606, 97),
      id = 284,
      eid = 10102,
      guildInstanceId = 40061
    },
    {
      pos = ccp(713, 175),
      id = 285
    },
    {
      pos = ccp(699, 220),
      id = 286
    },
    {
      pos = ccp(652, 289),
      id = 287,
      eid = 10103,
      guildInstanceId = 40062
    }
  },
  guildInstance = true
}
map.chapter16 = {
  tag = 3,
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_10.png",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map16.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(104, 280),
      id = 288
    },
    {
      pos = ccp(150, 301),
      id = 289
    },
    {
      pos = ccp(217, 246),
      id = 290,
      eid = 10104,
      guildInstanceId = 40063
    },
    {
      pos = ccp(128, 156),
      id = 291
    },
    {
      pos = ccp(136, 114),
      id = 292
    },
    {
      pos = ccp(219, 104),
      id = 293,
      eid = 10105,
      guildInstanceId = 40064
    },
    {
      pos = ccp(333, 101),
      id = 294
    },
    {
      pos = ccp(373, 129),
      id = 295
    },
    {
      pos = ccp(392, 205),
      id = 296,
      eid = 10106,
      guildInstanceId = 40065
    },
    {
      pos = ccp(436, 297),
      id = 297
    },
    {
      pos = ccp(475, 305),
      id = 298
    },
    {
      pos = ccp(552, 285),
      id = 299,
      eid = 10107,
      guildInstanceId = 40066
    },
    {
      pos = ccp(691, 246),
      id = 300
    },
    {
      pos = ccp(656, 159),
      id = 301,
      eid = 10108,
      guildInstanceId = 40067
    },
    {
      pos = ccp(593, 89),
      id = 302
    },
    {
      pos = ccp(512, 98),
      id = 303,
      eid = 10109,
      guildInstanceId = 40068
    }
  },
  guildInstance = true
}
map.chapter17 = {
  tag = 1,
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_17.png",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map17.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(217, 84),
      id = 304
    },
    {
      pos = ccp(176, 104),
      id = 305
    },
    {
      pos = ccp(152, 159),
      id = 306,
      eid = 10110,
      guildInstanceId = 40069
    },
    {
      pos = ccp(149, 261),
      id = 307
    },
    {
      pos = ccp(185, 292),
      id = 308
    },
    {
      pos = ccp(262, 277),
      id = 309,
      eid = 10111,
      guildInstanceId = 40070
    },
    {
      pos = ccp(356, 298),
      id = 310
    },
    {
      pos = ccp(399, 301),
      id = 311
    },
    {
      pos = ccp(473, 291),
      id = 312,
      eid = 10112,
      guildInstanceId = 40071
    },
    {
      pos = ccp(600, 308),
      id = 313
    },
    {
      pos = ccp(645, 289),
      id = 314
    },
    {
      pos = ccp(596, 230),
      id = 315,
      eid = 10113,
      guildInstanceId = 40072
    },
    {
      pos = ccp(452, 195),
      id = 316
    },
    {
      pos = ccp(411, 185),
      id = 317
    },
    {
      pos = ccp(344, 165),
      id = 318,
      eid = 10114,
      guildInstanceId = 40073
    },
    {
      pos = ccp(340, 80),
      id = 319
    },
    {
      pos = ccp(384, 76),
      id = 320
    },
    {
      pos = ccp(466, 106),
      id = 321,
      eid = 10115,
      guildInstanceId = 40074
    },
    {
      pos = ccp(576, 101),
      id = 322
    },
    {
      pos = ccp(654, 121),
      id = 323,
      eid = 10116,
      guildInstanceId = 40075
    }
  },
  guildInstance = true
}
map.chapter18 = {
  tag = 4,
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_18.png",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map18.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(117, 328),
      id = 324
    },
    {
      pos = ccp(168, 327),
      id = 325
    },
    {
      pos = ccp(255, 319),
      id = 326,
      eid = 10117,
      guildInstanceId = 40076
    },
    {
      pos = ccp(265, 242),
      id = 327
    },
    {
      pos = ccp(207, 226),
      id = 328
    },
    {
      pos = ccp(143, 200),
      id = 329,
      eid = 10118,
      guildInstanceId = 40077
    },
    {
      pos = ccp(101, 90),
      id = 330
    },
    {
      pos = ccp(162, 85),
      id = 331
    },
    {
      pos = ccp(259, 93),
      id = 332,
      eid = 10119,
      guildInstanceId = 40078
    },
    {
      pos = ccp(343, 120),
      id = 333
    },
    {
      pos = ccp(389, 143),
      id = 334
    },
    {
      pos = ccp(398, 206),
      id = 335,
      eid = 10120,
      guildInstanceId = 40079
    },
    {
      pos = ccp(438, 293),
      id = 336
    },
    {
      pos = ccp(485, 314),
      id = 337
    },
    {
      pos = ccp(567, 263),
      id = 338,
      eid = 10121,
      guildInstanceId = 40080
    },
    {
      pos = ccp(500, 174),
      id = 339
    },
    {
      pos = ccp(515, 124),
      id = 340
    },
    {
      pos = ccp(601, 115),
      id = 341,
      eid = 10122,
      guildInstanceId = 40081
    },
    {
      pos = ccp(689, 151),
      id = 342
    },
    {
      pos = ccp(683, 229),
      id = 343,
      eid = 10123,
      guildInstanceId = 40082
    }
  },
  guildInstance = true,
  gemBeastFcaRes = "AA",
  gemBeastFcaPos = ccp(200, 200),
  gemBeastFcaAction = "Idle"
}
map.chapter19 = {
  tag = 1,
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_19.png",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map19.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(102, 318),
      id = 344
    },
    {
      pos = ccp(132, 272),
      id = 345
    },
    {
      pos = ccp(220, 302),
      id = 346,
      eid = 10124,
      guildInstanceId = 40083
    },
    {
      pos = ccp(318, 337),
      id = 347
    },
    {
      pos = ccp(359, 275),
      id = 348
    },
    {
      pos = ccp(308, 207),
      id = 349,
      eid = 10125,
      guildInstanceId = 40084
    },
    {
      pos = ccp(169, 171),
      id = 350
    },
    {
      pos = ccp(118, 163),
      id = 351
    },
    {
      pos = ccp(183, 104),
      id = 352,
      eid = 10126,
      guildInstanceId = 40085
    },
    {
      pos = ccp(312, 98),
      id = 353
    },
    {
      pos = ccp(420, 134),
      id = 354,
      eid = 10127,
      guildInstanceId = 40086
    },
    {
      pos = ccp(503, 159),
      id = 355
    },
    {
      pos = ccp(460, 200),
      id = 356
    },
    {
      pos = ccp(457, 292),
      id = 357,
      eid = 10128,
      guildInstanceId = 40087
    },
    {
      pos = ccp(550, 273),
      id = 358
    },
    {
      pos = ccp(558, 322),
      id = 359
    },
    {
      pos = ccp(648, 292),
      id = 360,
      eid = 10129,
      guildInstanceId = 40088
    },
    {
      pos = ccp(647, 198),
      id = 361
    },
    {
      pos = ccp(606, 126),
      id = 362,
      eid = 10130,
      guildInstanceId = 40089
    }
  },
  guildInstance = true
}
map.chapter20 = {
  tag = 4,
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_20.png",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map20.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(214, 79),
      id = 363
    },
    {
      pos = ccp(173, 100),
      id = 364
    },
    {
      pos = ccp(148, 169),
      id = 365,
      eid = 10131,
      guildInstanceId = 40090
    },
    {
      pos = ccp(184, 190),
      id = 366
    },
    {
      pos = ccp(189, 229),
      id = 367
    },
    {
      pos = ccp(259, 264),
      id = 368,
      eid = 10132,
      guildInstanceId = 40091
    },
    {
      pos = ccp(335, 311),
      id = 369
    },
    {
      pos = ccp(399, 315),
      id = 370
    },
    {
      pos = ccp(470, 288),
      id = 371,
      eid = 10133,
      guildInstanceId = 40092
    },
    {
      pos = ccp(598, 303),
      id = 372
    },
    {
      pos = ccp(643, 284),
      id = 373
    },
    {
      pos = ccp(592, 225),
      id = 374,
      eid = 10134,
      guildInstanceId = 40093
    },
    {
      pos = ccp(460, 217),
      id = 375
    },
    {
      pos = ccp(408, 180),
      id = 376
    },
    {
      pos = ccp(296, 158),
      id = 377,
      eid = 10135,
      guildInstanceId = 40094
    },
    {
      pos = ccp(301, 87),
      id = 378
    },
    {
      pos = ccp(364, 76),
      id = 379
    },
    {
      pos = ccp(463, 95),
      id = 380,
      eid = 10136,
      guildInstanceId = 40095
    },
    {
      pos = ccp(541, 140),
      id = 381
    },
    {
      pos = ccp(651, 118),
      id = 382,
      eid = 10137,
      guildInstanceId = 40096
    }
  },
  guildInstance = true
}
map.chapter21 = {
  tag = 4,
  bg = {
    res = "UI/alpha/HVGA/Resource_for_titan/stageselect_map_bg_21.png",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/Resource_for_titan/map21.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(109, 337),
      id = 383
    },
    {
      pos = ccp(159, 280),
      id = 384
    },
    {
      pos = ccp(245, 315),
      id = 385,
      eid = 10138,
      guildInstanceId = 40097
    },
    {
      pos = ccp(345, 267),
      id = 386
    },
    {
      pos = ccp(236, 219),
      id = 387
    },
    {
      pos = ccp(147, 164),
      id = 388,
      eid = 10139,
      guildInstanceId = 40098
    },
    {
      pos = ccp(165, 73),
      id = 389
    },
    {
      pos = ccp(276, 70),
      id = 390
    },
    {
      pos = ccp(375, 140),
      id = 391,
      eid = 10140,
      guildInstanceId = 40099
    },
    {
      pos = ccp(440, 189),
      id = 392
    },
    {
      pos = ccp(515, 226),
      id = 393
    },
    {
      pos = ccp(452, 320),
      id = 394,
      eid = 10141,
      guildInstanceId = 40100
    },
    {
      pos = ccp(557, 271),
      id = 395
    },
    {
      pos = ccp(641, 347),
      id = 396
    },
    {
      pos = ccp(690, 300),
      id = 397,
      eid = 10142,
      guildInstanceId = 40101
    },
    {
      pos = ccp(640, 226),
      id = 398
    },
    {
      pos = ccp(564, 167),
      id = 399
    },
    {
      pos = ccp(685, 130),
      id = 400,
      eid = 10143,
      guildInstanceId = 40102
    }
  },
  guildInstance = true
}
map.chapter22 = {
  tag = 4,
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_22.png",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map22.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(98, 314),
      id = 401
    },
    {
      pos = ccp(171, 295),
      id = 402
    },
    {
      pos = ccp(266, 272),
      id = 403,
      eid = 10144,
      guildInstanceId = 40103
    },
    {
      pos = ccp(171, 229),
      id = 404
    },
    {
      pos = ccp(106, 205),
      id = 405
    },
    {
      pos = ccp(131, 140),
      id = 406,
      eid = 10145,
      guildInstanceId = 40104
    },
    {
      pos = ccp(144, 70),
      id = 407
    },
    {
      pos = ccp(247, 70),
      id = 408
    },
    {
      pos = ccp(348, 105),
      id = 409,
      eid = 10146,
      guildInstanceId = 40105
    },
    {
      pos = ccp(467, 106),
      id = 410
    },
    {
      pos = ccp(480, 167),
      id = 411
    },
    {
      pos = ccp(390, 223),
      id = 412,
      eid = 10147,
      guildInstanceId = 40106
    },
    {
      pos = ccp(382, 297),
      id = 413
    },
    {
      pos = ccp(465, 303),
      id = 414
    },
    {
      pos = ccp(569, 290),
      id = 415,
      eid = 10148,
      guildInstanceId = 40107
    },
    {
      pos = ccp(544, 217),
      id = 416
    },
    {
      pos = ccp(553, 157),
      id = 417
    },
    {
      pos = ccp(592, 102),
      id = 418,
      eid = 10149,
      guildInstanceId = 40108
    },
    {
      pos = ccp(686, 137),
      id = 419
    },
    {
      pos = ccp(680, 231),
      id = 420,
      eid = 10150,
      guildInstanceId = 40109
    }
  },
  guildInstance = true
}
map.chapter23 = {
  tag = 6,
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_23.png",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map23.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(95, 297),
      id = 421
    },
    {
      pos = ccp(164, 321),
      id = 422
    },
    {
      pos = ccp(275, 346),
      id = 423,
      eid = 10151,
      guildInstanceId = 40110
    },
    {
      pos = ccp(287, 277),
      id = 424
    },
    {
      pos = ccp(212, 246),
      id = 425
    },
    {
      pos = ccp(123, 219),
      id = 426,
      eid = 10152,
      guildInstanceId = 40111
    },
    {
      pos = ccp(114, 153),
      id = 427
    },
    {
      pos = ccp(115, 103),
      id = 428
    },
    {
      pos = ccp(236, 128),
      id = 429,
      eid = 10153,
      guildInstanceId = 40112
    },
    {
      pos = ccp(317, 172),
      id = 430
    },
    {
      pos = ccp(421, 167),
      id = 431
    },
    {
      pos = ccp(511, 116),
      id = 432,
      eid = 10154,
      guildInstanceId = 40113
    },
    {
      pos = ccp(624, 100),
      id = 433
    },
    {
      pos = ccp(703, 151),
      id = 434
    },
    {
      pos = ccp(617, 216),
      id = 435,
      eid = 10155,
      guildInstanceId = 40114
    },
    {
      pos = ccp(560, 258),
      id = 436
    },
    {
      pos = ccp(470, 243),
      id = 437
    },
    {
      pos = ccp(390, 300),
      id = 438,
      eid = 10156,
      guildInstanceId = 40115
    },
    {
      pos = ccp(460, 335),
      id = 439
    },
    {
      pos = ccp(567, 319),
      id = 440
    },
    {
      pos = ccp(691, 314),
      id = 441,
      eid = 10157,
      guildInstanceId = 40116
    }
  },
  guildInstance = true
}
map.chapter23_2 = {
  tag = 6,
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_23.png",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map23.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(95, 297),
      id = 421
    },
    {
      pos = ccp(164, 321),
      id = 422
    },
    {
      pos = ccp(275, 346),
      id = 423,
      eid = 10151,
      guildInstanceId = 40117
    },
    {
      pos = ccp(287, 277),
      id = 424
    },
    {
      pos = ccp(212, 246),
      id = 425
    },
    {
      pos = ccp(123, 219),
      id = 426,
      eid = 10152,
      guildInstanceId = 40118
    },
    {
      pos = ccp(114, 153),
      id = 427
    },
    {
      pos = ccp(115, 103),
      id = 428
    },
    {
      pos = ccp(236, 128),
      id = 429,
      eid = 10153,
      guildInstanceId = 40119
    },
    {
      pos = ccp(317, 172),
      id = 430
    },
    {
      pos = ccp(421, 167),
      id = 431
    },
    {
      pos = ccp(511, 116),
      id = 432,
      eid = 10154,
      guildInstanceId = 40120
    },
    {
      pos = ccp(624, 100),
      id = 433
    },
    {
      pos = ccp(703, 151),
      id = 434
    },
    {
      pos = ccp(617, 216),
      id = 435,
      eid = 10155,
      guildInstanceId = 40121
    },
    {
      pos = ccp(560, 258),
      id = 436
    },
    {
      pos = ccp(470, 243),
      id = 437
    },
    {
      pos = ccp(390, 300),
      id = 438,
      eid = 10156,
      guildInstanceId = 40122
    },
    {
      pos = ccp(460, 335),
      id = 439
    },
    {
      pos = ccp(567, 319),
      id = 440
    },
    {
      pos = ccp(691, 314),
      id = 441,
      eid = 10157,
      guildInstanceId = 40123
    }
  },
  guildInstance = true
}
map.chapter24 = {
  tag = 6,
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_24.png",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map24.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(71, 258),
      id = 442
    },
    {
      pos = ccp(124, 285),
      id = 443
    },
    {
      pos = ccp(192, 337),
      id = 444,
      eid = 10158,
      guildInstanceId = 40124
    },
    {
      pos = ccp(274, 340),
      id = 445
    },
    {
      pos = ccp(346, 333),
      id = 446
    },
    {
      pos = ccp(422, 315),
      id = 447,
      eid = 10159,
      guildInstanceId = 40125
    },
    {
      pos = ccp(377, 240),
      id = 448
    },
    {
      pos = ccp(248, 253),
      id = 449
    },
    {
      pos = ccp(193, 230),
      id = 450,
      eid = 10160,
      guildInstanceId = 40126
    },
    {
      pos = ccp(105, 155),
      id = 451
    },
    {
      pos = ccp(198, 112),
      id = 452
    },
    {
      pos = ccp(301, 139),
      id = 453,
      eid = 10161,
      guildInstanceId = 40127
    },
    {
      pos = ccp(392, 169),
      id = 454
    },
    {
      pos = ccp(514, 172),
      id = 455
    },
    {
      pos = ccp(586, 146),
      id = 456,
      eid = 10162,
      guildInstanceId = 40128
    },
    {
      pos = ccp(707, 121),
      id = 457
    },
    {
      pos = ccp(700, 196),
      id = 458
    },
    {
      pos = ccp(700, 265),
      id = 459,
      eid = 10163,
      guildInstanceId = 40129
    },
    {
      pos = ccp(629, 276),
      id = 460
    },
    {
      pos = ccp(577, 293),
      id = 461
    },
    {
      pos = ccp(626, 349),
      id = 462,
      eid = 10164,
      guildInstanceId = 40130
    }
  },
  guildInstance = true
}
map.chapter24_2 = {
  tag = 6,
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_24.png",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map24.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(71, 258),
      id = 442
    },
    {
      pos = ccp(124, 285),
      id = 443
    },
    {
      pos = ccp(192, 337),
      id = 444,
      eid = 10158,
      guildInstanceId = 40131
    },
    {
      pos = ccp(274, 340),
      id = 445
    },
    {
      pos = ccp(346, 333),
      id = 446
    },
    {
      pos = ccp(422, 315),
      id = 447,
      eid = 10159,
      guildInstanceId = 40132
    },
    {
      pos = ccp(377, 240),
      id = 448
    },
    {
      pos = ccp(248, 253),
      id = 449
    },
    {
      pos = ccp(193, 230),
      id = 450,
      eid = 10160,
      guildInstanceId = 40133
    },
    {
      pos = ccp(105, 155),
      id = 451
    },
    {
      pos = ccp(198, 112),
      id = 452
    },
    {
      pos = ccp(301, 139),
      id = 453,
      eid = 10161,
      guildInstanceId = 40134
    },
    {
      pos = ccp(392, 169),
      id = 454
    },
    {
      pos = ccp(514, 172),
      id = 455
    },
    {
      pos = ccp(586, 146),
      id = 456,
      eid = 10162,
      guildInstanceId = 40135
    },
    {
      pos = ccp(707, 121),
      id = 457
    },
    {
      pos = ccp(700, 196),
      id = 458
    },
    {
      pos = ccp(700, 265),
      id = 459,
      eid = 10163,
      guildInstanceId = 40136
    },
    {
      pos = ccp(629, 276),
      id = 460
    },
    {
      pos = ccp(577, 293),
      id = 461
    },
    {
      pos = ccp(626, 349),
      id = 462,
      eid = 10164,
      guildInstanceId = 40137
    }
  },
  guildInstance = true
}
map.chapter102 = {
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_1.png",
    pos = ccp(400, 212)
  },
  route = {
    res = nil,
    pos = ccp(0, 0)
  },
  stage = {}
}
map.chapter103 = {
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_1.png",
    pos = ccp(400, 212)
  },
  route = {
    res = nil,
    pos = ccp(0, 0)
  },
  stage = {}
}
map.chapter105 = {
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_1.png",
    pos = ccp(400, 212)
  },
  route = {
    res = nil,
    pos = ccp(0, 0)
  },
  stage = {}
}
map.chapter300 = {
  bg = {
    res = "UI/alpha/1080P/campaign/campaign_bg_1.png",
    pos = ccp(400, 212)
  },
  route = {
    res = nil,
    pos = ccp(0, 0)
  },
  stage = {}
}
class.map = map
local dotRes = {
  normal = "UI/alpha/1080P/campaign/main/campaign_pageup_spot_1.png",
  current = "UI/alpha/1080P/campaign/main/campaign_pageup_spot_2.png"
}
class.dotRes = dotRes
class.chapter_dot_gap_x = 20
class.normal_chapter_dot_y = 15
class.elite_chapter_dot_y = 15
local bossStageId = {
  [1] = {
    {
      1,
      4,
      7,
      11,
      15,
      18
    },
    {
      10001,
      10002,
      10003,
      10004,
      10005,
      10006
    }
  },
  [2] = {
    {
      20,
      23,
      27,
      30,
      33,
      36,
      39
    },
    {
      10007,
      10008,
      10009,
      10010,
      10011,
      10012,
      10013
    }
  },
  [3] = {
    {
      42,
      45,
      48,
      51,
      53,
      55
    },
    {
      10014,
      10015,
      10016,
      10017,
      10018,
      10019
    }
  },
  [4] = {
    {
      58,
      60,
      63,
      66,
      69,
      71,
      74
    },
    {
      10020,
      10021,
      10022,
      10023,
      10024,
      10025,
      10026
    }
  },
  [5] = {
    {
      76,
      79,
      82,
      85,
      88,
      91,
      94
    },
    {
      10027,
      10028,
      10029,
      10030,
      10031,
      10032,
      10033
    }
  },
  [6] = {
    {
      95,
      98,
      101,
      104,
      107,
      109,
      112,
      114
    },
    {
      10034,
      10035,
      10036,
      10037,
      10038,
      10039,
      10040,
      10041
    }
  },
  [7] = {
    {
      117,
      120,
      123,
      126,
      129,
      132,
      134
    },
    {
      10042,
      10043,
      10044,
      10045,
      10046,
      10047,
      10048
    }
  },
  [8] = {
    {
      137,
      140,
      143,
      146,
      149,
      152,
      154
    },
    {
      10049,
      10050,
      10051,
      10052,
      10053,
      10054,
      10055
    }
  },
  [9] = {
    {
      157,
      160,
      162,
      165,
      167,
      170,
      174
    },
    {
      10056,
      10057,
      10058,
      10059,
      10060,
      10061,
      10062
    }
  },
  [10] = {
    {
      176,
      179,
      181,
      184,
      187,
      190,
      194
    },
    {
      10063,
      10064,
      10065,
      10066,
      10067,
      10068,
      10069
    }
  },
  [11] = {
    {
      197,
      200,
      203,
      206,
      209,
      212,
      214
    },
    {
      10070,
      10071,
      10072,
      10073,
      10074,
      10075,
      10076
    }
  },
  [12] = {
    {
      216,
      218,
      221,
      224,
      226,
      229,
      231,
      234
    },
    {
      10077,
      10078,
      10079,
      10080,
      10081,
      10082,
      10083,
      10084
    }
  },
  [13] = {
    {
      237,
      240,
      243,
      246,
      248,
      250
    },
    {
      10085,
      10086,
      10087,
      10088,
      10089,
      10090
    }
  }
}
local normalTab = {}
local eliteTab = {}
for i, v in ipairs(ed.getDataTable("StageStarReward")) do
  if type(v) == "table" then
    if v.Difficulty and v.Difficulty == 1 then
      normalTab[v["Chapter ID"]] = normalTab[v["Chapter ID"]] or {}
      table.insert(normalTab[v["Chapter ID"]], {
        id = v.ID,
        StarNum = v["Require Star Count"]
      })
    else
      eliteTab[v["Chapter ID"]] = eliteTab[v["Chapter ID"]] or {}
      table.insert(eliteTab[v["Chapter ID"]], {
        id = v.ID,
        StarNum = v["Require Star Count"]
      })
    end
  end
end

function class.getChapterIdStarRed(Chapter, mode)
  local function func1(Chapter2)
    if mode == "elite" and map["chapter" .. Chapter2].lootStage and class.getLootStagesBoxRed(map["chapter" .. Chapter2].lootStage.eid) then
      return true
    end
    local chapterStarIds = ed.player:getChapterStarIds()
    
    local function func2(vv, tab, isn)
      local sn = 0
      for i, v in ipairs(vv) do
        sn = sn + ed.player:getStageStar(v)
      end
      if sn == 0 then
        return false
      end
      for i, v in ipairs(tab) do
        if sn >= v.StarNum and not ed.isElementInTable(v.id, chapterStarIds) then
          return true
        end
      end
      return false
    end
    
    if bossStageId[Chapter2] and normalTab[Chapter2] and eliteTab[Chapter2] then
      local v = bossStageId[Chapter2]
      return func2(v[mode == "normal" and 1 or 2], mode == "normal" and normalTab[Chapter2] or eliteTab[Chapter2])
    end
    return false
  end
  
  local function funcVis(num)
    local cond = Chapter + num
    while 0 < cond and cond <= #bossStageId do
      if func1(cond) then
        return true
      end
      cond = cond + num
    end
    return false
  end
  
  return funcVis(-1), funcVis(1)
end

function class.getStageStarBoxRed(fandModRed)
  if fandModRed and fandModRed == "elite" and class.getLootStagesBoxRed() or not fandModRed and class.getLootStagesBoxRed() then
    return true
  end
  local chapterStarIds = ed.player:getChapterStarIds()
  local no = true
  local bek = true
  
  local function func(vv, tab, isn)
    local sn = 0
    for i, v in ipairs(vv) do
      sn = sn + ed.player:getStageStar(v)
    end
    if sn == 0 and not bek then
      return true
    end
    bek = sn ~= 0
    for i, v in ipairs(tab) do
      if sn >= v.StarNum and not ed.isElementInTable(v.id, chapterStarIds) then
        no = isn
        return true
      end
    end
  end
  
  for i, v in ipairs(bossStageId) do
    bek, no = true, true
    if fandModRed then
      if fandModRed == "normal" then
        if func(v[1], normalTab[i], true) then
          return bek, i, "normal"
        end
      elseif fandModRed == "elite" and func(v[2], eliteTab[i]) then
        return bek, i, "elite"
      end
    elseif func(v[1], normalTab[i], true) or func(v[2], eliteTab[i]) then
      return bek, i, no and "normal" or "elite"
    end
  end
  return false
end

class.lootStages = {10901, 10902}

function class.getLootStagesBoxRed(eid)
  local lootStages = ed.copyTable(class.lootStages)
  if eid then
    for ii, vv in ipairs(lootStages) do
      if eid == vv then
        lootStages = {eid}
        break
      end
    end
    if #lootStages ~= 1 then
      return false
    end
  end
  if ed.player:getEliteStageProgress() > 10090 then
    if class.getLootStagesNewRedShow(lootStages) then
      return true
    end
    for _, v in ipairs(ed.player:getStageSelectReward() or {}) do
      for ii, vv in ipairs(lootStages) do
        if v._stage_id == vv then
          table.remove(lootStages, ii)
          break
        end
      end
      if #lootStages == 0 then
        return false
      end
    end
    return true
  else
    return false
  end
end

class.lootStagesIdToHeroShowNew = {}
class.lootStagesIdInitReward = {
  [10901] = {
    524,
    154,
    2711
  },
  [10902] = {
    140,
    153,
    2193
  }
}

function class.getLootStagesNewRedShow(eid)
  local lootStages = eid
  if type(lootStages) ~= "table" then
    lootStages = {eid}
  end
  local newShow = false
  for _, vv in ipairs(lootStages) do
    local str = ed.storage.getString(ed.getRoleKey("lootStages" .. vv))
    local rewards = class.lootStagesIdInitReward[vv] or {}
    if str and str ~= "" then
      rewards = string.split(str or "", "#")
    end
    local showNewId = {}
    for _, v in ipairs(ed.getDataTable("Stage")[vv]["Select Reward"] or {}) do
      local isNew = true
      for _, vvv in ipairs(rewards) do
        if v == tonumber(vvv) then
          isNew = false
          break
        end
      end
      if isNew then
        newShow = true
        showNewId[v] = true
      end
    end
    class.lootStagesIdToHeroShowNew[vv] = showNewId
  end
  return newShow
end

function class.getIsLootStages(eid)
  for _, v in ipairs(class.lootStages) do
    if eid == v then
      return true
    end
  end
  return false
end

function class.getLootStagesIsOpen(eid)
  if class.getIsLootStages(eid) then
    return ed.player:getStageStar(eid) > 0
  end
  return false
end

class.StageStar_ui_info = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(71.5, 71)
    },
    t = "Layer",
    base = {name = "star_box", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 71.5, h = 71},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "star_box",
      res = "UI/alpha/1080P/campaign/main/campaign_chest_light.png",
      name = "img_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.5, 35.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.5, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "star_box",
      res = "UI/alpha/1080P/campaign/main/campaign_chest_2.png",
      name = "img_chest",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.5, 35.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.5, h = 13.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "star_box",
      res = "UI/alpha/1080P/campaign/main/campaign_stage_star_requirebg.png",
      name = "ImageView_992",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.5, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 238),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_chest",
      z = 0,
      parent = "ImageView_992",
      text = "12",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(12.25, 6.75)
    }
  }
}
class.bigMapTit_ui_info = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(268.5, 38.5)
    },
    t = "Layer",
    base = {
      name = "panel_title",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 268.5, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_title",
      res = "UI/alpha/1080P/campaign/worldmap/worldmap_title_bg.png",
      name = "ImageView_990",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(134, 19)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 60, h = 82},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_title",
      res = "UI/alpha/1080P/campaign/main/campaign_difficulty_normal_1.png",
      name = "img_normal_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(178, 20)
    }
  },
  {
    t = "Label",
    base = {
      parent = "img_normal_1",
      name = "label_normal_1",
      text = T("\230\153\174\233\128\154"),
      size = 15
    },
    layout = {
      position = ccp(30, 22)
    },
    config = {
      color = ed.toccc3(12758429),
      stroke = {
        color = ed.toccc3(2565412),
        size = 1
      }
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 60, h = 82},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_title",
      res = "UI/alpha/1080P/campaign/main/campaign_difficulty_normal_2.png",
      name = "img_normal_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(178, 20)
    }
  },
  {
    t = "Label",
    base = {
      parent = "img_normal_2",
      name = "label_normal_2",
      text = T("\230\153\174\233\128\154"),
      size = 15
    },
    layout = {
      position = ccp(30, 22)
    },
    config = {
      color = ed.toccc3(16772503),
      stroke = {
        color = ed.toccc3(9128457),
        size = 1
      }
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 60, h = 82},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_title",
      res = "UI/alpha/1080P/campaign/main/campaign_difficulty_hard_1.png",
      name = "img_hard_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(232.5, 20)
    }
  },
  {
    t = "Label",
    base = {
      parent = "img_hard_1",
      name = "label_hard_1",
      text = T("\231\178\190\232\139\177"),
      size = 15
    },
    layout = {
      position = ccp(30, 22)
    },
    config = {
      color = ed.toccc3(12758429),
      stroke = {
        color = ed.toccc3(2565412),
        size = 1
      }
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 60, h = 82},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "panel_title",
      res = "UI/alpha/1080P/campaign/main/campaign_difficulty_hard_2.png",
      name = "img_hard_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(232.5, 20)
    }
  },
  {
    t = "Label",
    base = {
      parent = "img_hard_2",
      name = "label_hard_2",
      text = T("\231\178\190\232\139\177"),
      size = 15
    },
    layout = {
      position = ccp(30, 22)
    },
    config = {
      color = ed.toccc3(16772503),
      stroke = {
        color = ed.toccc3(9128457),
        size = 1
      }
    }
  }
}
class.bigMapName_ui_info = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(165, 150)
    },
    t = "Layer",
    base = {name = "panel_name", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.4000001, x = 1.4000001},
      flip = "",
      opacity = 255,
      fix_wh = {w = 152.6000109, h = 31.50000225},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_name",
      res = "UI/alpha/1080P/campaign/worldmap/worldmap_chapter_hard_bg.png",
      name = "ImageView_997",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(80.5, 55)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_name",
      z = 1,
      parent = "panel_name",
      text = T("1.\229\190\129\233\128\148\229\134\141\232\181\183"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(79.5, 55)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18.5, h = 18.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_name",
      res = "UI/alpha/1080P/campaign/worldmap/worldmap_star_normal.png",
      name = "img_star_1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(80.5, 33)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true,
      stroke = {
        color = ccc3(ed.colorToStr("#271906")),
        size = 1
      }
    },
    t = "Label",
    base = {
      name = "label_1",
      z = 1,
      parent = "panel_name",
      text = "70%",
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(94, 34)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true,
      stroke = {
        color = ccc3(ed.colorToStr("#271906")),
        size = 1
      }
    },
    t = "Label",
    base = {
      name = "label_2",
      z = 1,
      parent = "panel_name",
      text = "77%",
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(94, 15)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 142, h = 43.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_name",
      res = "UI/alpha/1080P/campaign/worldmap/worldmap_star_bg.png",
      name = "ImageView_1003",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(84, 23)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18.5, h = 18.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_name",
      res = "UI/alpha/1080P/campaign/worldmap/worldmap_star_hard.png",
      name = "img_star_2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(80.5, 14)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true,
      stroke = {
        color = ccc3(ed.colorToStr("#271906")),
        size = 1
      }
    },
    t = "Label",
    base = {
      name = "Label_1006",
      z = 0,
      parent = "panel_name",
      text = T("\230\153\174\233\128\154"),
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(63, 34)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ed.toccc3(16774537),
      opacity = 255,
      verticalAlignment = 0,
      visible = true,
      stroke = {
        color = ccc3(ed.colorToStr("#c83401")),
        size = 1
      }
    },
    t = "Label",
    base = {
      name = "Label_1007",
      z = 0,
      parent = "panel_name",
      text = T("\231\178\190\232\139\177"),
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(63.5, 15)
    }
  }
}
