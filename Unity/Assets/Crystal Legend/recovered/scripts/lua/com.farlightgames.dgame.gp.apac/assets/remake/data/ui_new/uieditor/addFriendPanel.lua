ed.uieditor = ed.uieditor or {}
ed.uieditor.addFriendPanel = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(570, 380)
    },
    t = "Layer",
    base = {name = "bg", z = 2},
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
      scaleSize = CCSizeMake(557, 283.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "playerList",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(7, 10.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 332.5, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/friend/friend_recommend_bg.png",
      name = "recommendFriendBg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(285.5, 314.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(550, 33)
    },
    t = "Scale9Sprite",
    base = {
      name = "findBg",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/friend/friend_find_input.png",
      capInsets = CCRectMake(15, 10, 15, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(286.5, 356.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 35)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "btnChangeBg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(462, 299)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(210, 33)
    },
    t = "Layer",
    base = {
      parent = "findBg",
      name = "findInput",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(170.5, 0.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "findBg",
      res = "UI/alpha/1080P/friend/friend_find.png",
      name = "btnFind",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(532.5, 17)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 200,
      visible = true,
      scaleSize = CCSizeMake(99, 35)
    },
    t = "Scale9Sprite",
    base = {
      name = "btnChangeEnable",
      z = 0,
      parent = "btnChangeBg",
      res = "UI/alpha/1080P/friend/friend_refresh_button_1.png",
      capInsets = CCRectMake(52.5, 11.5, 26, 11.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 15.5)
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
      name = "changeLabel",
      z = 1,
      parent = "btnChangeBg",
      text = T("\230\141\162\228\184\128\230\137\185"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 17.5, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btnChangeBg",
      res = "UI/alpha/1080P/friend/friend_refresh.png",
      name = "ImageView_124",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.5, 16)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 200,
      visible = true,
      scaleSize = CCSizeMake(99, 35)
    },
    t = "Scale9Sprite",
    base = {
      name = "btnChangeDisable",
      z = 0,
      parent = "btnChangeBg",
      res = "UI/alpha/1080P/friend/friend_refresh_button.png",
      capInsets = CCRectMake(52.5, 11.5, 26, 11.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 16)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 244, 152),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_recommend",
      z = 0,
      parent = "recommendFriendBg",
      text = T("\230\142\168\232\141\144\229\165\189\229\143\139"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(166.75, 14.5)
    }
  }
}
