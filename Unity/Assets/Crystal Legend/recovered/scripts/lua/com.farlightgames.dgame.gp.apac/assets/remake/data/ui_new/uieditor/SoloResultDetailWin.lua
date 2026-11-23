ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloResultDetailWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(695, 445)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(250, 40, 194.5, 7.5),
      res = "UI/alpha/1080P/chesscard/log/result_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(480, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 84, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/log/result_title.png",
      name = "bg_title1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(132, 423.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 84, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/log/result_title.png",
      name = "bg_title2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(254.5, 423.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 84, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/log/result_title.png",
      name = "bg_title4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(476, 423.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 84, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/log/result_title.png",
      name = "bg_title5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(613, 423.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 84, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/log/result_title.png",
      name = "bg_title3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(364, 423.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.1, x = 1.1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 292.6, h = 60.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/log/victory_bg.png",
      name = "ImageView_13082",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(349.5, 458.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 198, 138),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title1",
      z = 0,
      parent = "bg_title1",
      text = T("\231\142\169\229\174\182"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 11)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 198, 138),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title2",
      z = 0,
      parent = "bg_title2",
      text = T("\231\167\175\229\136\134"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 11)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 198, 138),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title3",
      z = 0,
      parent = "bg_title4",
      text = T("\228\184\187\230\181\129\230\180\190"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 11)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 198, 138),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title4",
      z = 0,
      parent = "bg_title5",
      text = T("\231\167\152\229\174\157"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 11)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 198, 138),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title4",
      z = 0,
      parent = "bg_title3",
      text = T("\232\131\156\232\180\159\230\175\148"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 11)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_13082",
      res = "UI/alpha/1080P/chesscard/log/victory.png",
      name = "ImageView_13084",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(133, 35)
    }
  }
}
