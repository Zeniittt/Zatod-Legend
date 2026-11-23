ed.uieditor = ed.uieditor or {}
ed.uieditor.headline = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100),
      clipAble = false
    },
    t = "Layer",
    base = {z = 0, name = "mainLayer"},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 48.5)
    },
    t = "Scale9Sprite",
    base = {
      z = 0,
      name = "bgServer",
      parent = "mainLayer",
      res = "UI/alpha/1080P/headline/server.png",
      capInsets = CCRectMake(30, 6, 900, 36.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.7854, 480)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 33)
    },
    t = "Scale9Sprite",
    base = {
      z = 0,
      name = "bgGuild",
      parent = "mainLayer",
      res = "UI/alpha/1080P/headline/guild.png",
      capInsets = CCRectMake(30, 6, 900, 21)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(484.7854, 474.5398)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(780, 32),
      clipAble = true
    },
    t = "Layer",
    base = {
      z = 0,
      name = "headLayer",
      parent = "mainLayer"
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(100, 460)
    }
  }
}
