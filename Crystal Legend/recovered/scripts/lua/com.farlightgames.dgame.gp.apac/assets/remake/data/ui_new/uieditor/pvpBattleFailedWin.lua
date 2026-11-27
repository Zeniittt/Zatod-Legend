ed.uieditor = ed.uieditor or {}
ed.uieditor.pvpBattleFailedWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 975, h = 347.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/battleresult/fail_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 245)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 867.5, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/battleresult/splitline.png",
      name = "line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(487.5, 102.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 165, 49),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_reward",
      z = 0,
      parent = "bg",
      text = T("\229\165\150\229\138\177:"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(75.5, 54.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(700, 100)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(104.5, -3.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 92.5, h = 39},
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/package/btn_package2.png",
      name = "btn_back",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/package/btn_package2.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(871.5, 48.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 658.5, h = 168},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/battleresult/fail_light.png",
      name = "bg_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(487.5, 361.25)
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
      name = "label_tip",
      z = 0,
      parent = "bg",
      text = T("\230\143\144\229\141\135\233\128\148\229\190\132\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113.5, 319.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(177.5, 178.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_tip1",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/battleresult/tips_bg.png",
      capInsets = CCRectMake(15, 20, 20, 15)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(157.5, 204.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 184.5, h = 183.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/battleresult/fail_manual .png",
      name = "tip_pic1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(158, 207.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(177.5, 178.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_tip2",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/battleresult/tips_bg.png",
      capInsets = CCRectMake(15, 20, 20, 15)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(377.5, 204.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 184.5, h = 183.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/battleresult/fail_manual .png",
      name = "tip_pic2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(377.5, 207.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(177.5, 178.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_tip3",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/battleresult/tips_bg.png",
      capInsets = CCRectMake(15, 20, 20, 15)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(597.5, 204.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 184.5, h = 183.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/battleresult/fail_manual .png",
      name = "tip_pic3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(597, 207.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(177.5, 178.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_tip4",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/battleresult/tips_bg.png",
      capInsets = CCRectMake(15, 20, 20, 15)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(817.5, 204.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 184.5, h = 183.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/battleresult/fail_manual .png",
      name = "tip_pic4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(817.5, 207.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_back",
      z = 0,
      parent = "btn_back",
      text = T("\233\128\128\229\135\186"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.25, 20)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 113, h = 64.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_title",
      res = "UI/alpha/1080P/battleresult/fail.png",
      name = "title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(329.25, 92)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 178.5, h = 178.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_tip1",
      res = "UI/alpha/1080P/battleresult/tips_frame.png",
      name = "frame1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88.75, 89.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 214, 151),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "title1",
      z = 0,
      parent = "bg_tip1",
      text = T("\232\176\131\230\149\180\233\152\181\229\174\185"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88.75, 159.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33.4999933, h = 6.24999875},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_tip1",
      res = "UI/alpha/1080P/common/comm_line_b.png",
      name = "deco11",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.75, 159.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.49999997, x = 0.49999997},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 33.49999799, h = 6.249999625},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_tip1",
      res = "UI/alpha/1080P/common/comm_line_b.png",
      name = "deco21",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(141.75, 159.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(220, 174, 102),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "tip1",
      z = 0,
      parent = "bg_tip1",
      text = T("\231\187\132\229\187\186\232\131\189\229\164\159\229\133\139\229\136\182\229\175\185\230\137\139\231\154\132\233\152\181\229\174\185"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88.75, 59.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 214, 151),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title2",
      z = 0,
      parent = "bg_tip2",
      text = T("\232\176\131\230\149\180\233\152\181\229\174\185"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88.75, 159.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.49999997, x = 0.49999997},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 33.49999799, h = 6.249999625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_tip2",
      res = "UI/alpha/1080P/common/comm_line_b.png",
      name = "deco22",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(141.75, 159.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(220, 174, 102),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "tip2",
      z = 0,
      parent = "bg_tip2",
      text = T("\231\187\132\229\187\186\232\131\189\229\164\159\229\133\139\229\136\182\229\175\185\230\137\139\231\154\132\233\152\181\229\174\185"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88.75, 59.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 178.5, h = 178.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_tip2",
      res = "UI/alpha/1080P/battleresult/tips_frame.png",
      name = "frame2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88.75, 89.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33.4999933, h = 6.24999875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_tip2",
      res = "UI/alpha/1080P/common/comm_line_b.png",
      name = "deco12",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.75, 159.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 214, 151),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title3",
      z = 0,
      parent = "bg_tip3",
      text = T("\232\176\131\230\149\180\233\152\181\229\174\185"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88.75, 159.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.49999997, x = 0.49999997},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 33.49999799, h = 6.249999625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_tip3",
      res = "UI/alpha/1080P/common/comm_line_b.png",
      name = "deco23",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(141.75, 159.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(220, 174, 102),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "tip3",
      z = 0,
      parent = "bg_tip3",
      text = T("\231\187\132\229\187\186\232\131\189\229\164\159\229\133\139\229\136\182\229\175\185\230\137\139\231\154\132\233\152\181\229\174\185"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88.75, 59.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 178.5, h = 178.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_tip3",
      res = "UI/alpha/1080P/battleresult/tips_frame.png",
      name = "frame3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88.75, 89.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33.4999933, h = 6.24999875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_tip3",
      res = "UI/alpha/1080P/common/comm_line_b.png",
      name = "deco3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.75, 159.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 214, 151),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title4",
      z = 0,
      parent = "bg_tip4",
      text = T("\232\176\131\230\149\180\233\152\181\229\174\185"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88.75, 159.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.49999997, x = 0.49999997},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 33.49999799, h = 6.249999625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_tip4",
      res = "UI/alpha/1080P/common/comm_line_b.png",
      name = "deco24",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(141.75, 159.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(220, 174, 102),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "tip4",
      z = 0,
      parent = "bg_tip4",
      text = T("\231\187\132\229\187\186\232\131\189\229\164\159\229\133\139\229\136\182\229\175\185\230\137\139\231\154\132\233\152\181\229\174\185"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88.75, 59.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 178.5, h = 178.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_tip4",
      res = "UI/alpha/1080P/battleresult/tips_frame.png",
      name = "frame4",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88.75, 89.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33.4999933, h = 6.24999875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_tip4",
      res = "UI/alpha/1080P/common/comm_line_b.png",
      name = "deco4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.75, 159.25)
    }
  }
}
