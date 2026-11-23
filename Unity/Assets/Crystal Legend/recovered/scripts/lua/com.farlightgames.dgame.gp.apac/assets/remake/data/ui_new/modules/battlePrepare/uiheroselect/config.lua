module("ed.battleprepare", package.seeall)
config = {}
config.__index = config

function config.create()
  local object = {}
  setmetatable(object, config)
  return object
end

function config:getHeroPoolUiInfo(type)
  local config = {
    normal = {
      titlePos = ccp(380, 440),
      colNum = 5,
      itemHeight = 100,
      hero_icon_ori_x = 169,
      hero_icon_ori_y = 400,
      hero_icon_gap_x = 100,
      hero_icon_gap_y = 100,
      cliprect = CCRectMake(125, 155, 487, 295),
      barpos = ccp(119, 295)
    },
    incubus = {
      titlePos = ccp(380, 440),
      colNum = 5,
      itemHeight = 100,
      hero_icon_ori_x = 169,
      hero_icon_ori_y = 375,
      hero_icon_gap_x = 100,
      hero_icon_gap_y = 100,
      cliprect = CCRectMake(125, 40, 487, 380),
      barpos = ccp(119, 240)
    },
    ancients = {
      titlePos = ccp(380, 440),
      colNum = 5,
      itemHeight = 100,
      hero_icon_ori_x = 169,
      hero_icon_ori_y = 375,
      hero_icon_gap_x = 100,
      hero_icon_gap_y = 100,
      cliprect = CCRectMake(125, 155, 487, 270),
      barpos = ccp(119, 295)
    },
    babel = {
      titlePos = ccp(380, 370),
      colNum = 5,
      itemHeight = 100,
      hero_icon_ori_x = 169,
      hero_icon_ori_y = 340,
      hero_icon_gap_x = 100,
      hero_icon_gap_y = 100,
      cliprect = CCRectMake(125, 155, 487, 225),
      barpos = ccp(119, 270),
      barLen = 200
    },
    multi_stage = {
      titlePos = ccp(380, 370),
      colNum = 5,
      itemHeight = 100,
      hero_icon_ori_x = 169,
      hero_icon_ori_y = 340,
      hero_icon_gap_x = 100,
      hero_icon_gap_y = 100,
      cliprect = CCRectMake(125, 155, 487, 225),
      barpos = ccp(119, 270),
      barLen = 200
    }
  }
  return config[type]
end

function config:getMercenaryUiInfo(type)
  local config = {
    normal = {
      titlePos = ccp(380, 440),
      colNum = 3,
      itemHeight = 150,
      hero_icon_ori_x = 200,
      hero_icon_ori_y = 335,
      hero_icon_gap_x = 150,
      hero_icon_gap_y = 150,
      cliprect = CCRectMake(125, 155, 487, 295),
      barpos = ccp(119, 295)
    },
    multi_stage = {
      titlePos = ccp(380, 370),
      colNum = 3,
      itemHeight = 160,
      hero_icon_ori_x = 205,
      hero_icon_ori_y = 335,
      hero_icon_gap_x = 155,
      hero_icon_gap_y = 160,
      cliprect = CCRectMake(125, 155, 487, 225),
      barpos = ccp(119, 270),
      barLen = 200
    }
  }
  return config[type]
end

config = config.create()
