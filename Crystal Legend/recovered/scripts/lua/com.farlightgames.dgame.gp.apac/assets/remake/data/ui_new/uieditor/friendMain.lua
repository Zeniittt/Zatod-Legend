ed.uieditor = ed.uieditor or {}
ed.uieditor.friendMain = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(590, 403)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(27.5, 127, 27.5, 127),
      res = "UI/alpha/1080P/battle/battle_prepare_9bg_1.png",
      name = "friendPanelBg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(435.5, 268)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(120, 171)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(20, 25, 40, 250),
      res = "UI/alpha/1080P/battle/battle_prepare_9bg_1.png",
      name = "btnPanelBg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(792.5, 380)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(590, 403)
    },
    t = "Scale9Sprite",
    base = {
      name = "friendPanelBorder",
      z = 0,
      parent = "friendPanelBg",
      res = "UI/alpha/1080P/common/com_img_9bg2.png",
      capInsets = CCRectMake(18, 74.5, 18, 74.5)
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(1, -2)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(125, 180)
    },
    t = "Scale9Sprite",
    base = {
      name = "btnPanelBorder",
      z = 0,
      parent = "btnPanelBg",
      res = "UI/alpha/1080P/common/com_img_9bg2.png",
      capInsets = CCRectMake(20, 35, 15, 55)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60.5, 84.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 100.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btnPanelBg",
      res = "UI/alpha/1080P/friend/friend_tag_4.png",
      name = "btnBg1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60, 136)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 100.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btnPanelBg",
      res = "UI/alpha/1080P/friend/friend_tag_4.png",
      name = "btnBg2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60, 87.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 100.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btnPanelBg",
      res = "UI/alpha/1080P/friend/friend_tag_4.png",
      name = "btnBg3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60, 37.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 107.5, h = 44},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btnBg1",
      res = "UI/alpha/1080P/friend/friend_tag_3.png",
      name = "btnSelect1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.25, 13.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 107.5, h = 44},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btnBg2",
      res = "UI/alpha/1080P/friend/friend_tag_3.png",
      name = "btnSelect2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.25, 13.75)
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
      name = "btnLabel1",
      z = 0,
      parent = "btnBg1",
      text = T("\229\165\189\229\143\139"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.25, 19.75)
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
      name = "btnLabel2",
      z = 0,
      parent = "btnBg2",
      text = T("\230\183\187\229\138\160"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.25, 19.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 107.5, h = 44},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btnBg3",
      res = "UI/alpha/1080P/friend/friend_tag_3.png",
      name = "btnSelect3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.25, 13.75)
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
      name = "btnLabel3",
      z = 0,
      parent = "btnBg3",
      text = T("\231\148\179\232\175\183"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.25, 19.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(570, 380)
    },
    t = "Layer",
    base = {
      parent = "friendPanelBg",
      name = "subPanelBase",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(10.5, 13.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11.6, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btnBg3",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "red_point3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96.25, 30.75)
    }
  }
}
