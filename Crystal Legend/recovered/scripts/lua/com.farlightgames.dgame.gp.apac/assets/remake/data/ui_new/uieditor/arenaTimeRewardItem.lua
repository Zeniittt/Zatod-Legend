ed.uieditor = ed.uieditor or {}
ed.uieditor.arenaTimeRewardItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(275, 83)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(5, 5, 543, 77),
      res = "UI/alpha/1080P/crusade/bg_replay_item.png",
      name = "bg_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 215, 126),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "rank",
      z = 0,
      parent = "bg_Copy0",
      text = T("\230\142\146\229\144\141:"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(16.5, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(125, 70)
    },
    t = "Layer",
    base = {
      parent = "bg_Copy0",
      name = "Panel_6912",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(141, 6.5)
    }
  }
}
