ed.uieditor = ed.uieditor or {}
ed.uieditor.AutoChessSelectWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 406.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chess/heropower/bottom_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 281)
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
      name = "Label_656",
      z = 0,
      parent = "bg",
      text = T("\233\128\137\230\139\169\228\184\128\228\184\170\232\139\177\233\155\132\229\138\169\229\138\155"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(585, 380.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 47.5, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/heropower/title.png",
      name = "ImageView_657",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(748.5, 380.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47.5, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/heropower/title.png",
      name = "ImageView_657_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(423.5, 380.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 124.5, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_big.png",
      name = "btn_hide",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(585, 44.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 189.5, h = 279.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/heropower/card_bg.png",
      name = "card1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(311.5, 217.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 189.5, h = 279.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/heropower/card_bg.png",
      name = "card2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(585, 216.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 189.5, h = 279.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/heropower/card_bg.png",
      name = "card3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(855, 218.75)
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
      name = "Label_660",
      z = 0,
      parent = "btn_hide",
      text = T("\233\154\144 \232\151\143"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.25, 26.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 111, h = 111},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "card1",
      res = "UI/alpha/1080P/chess/heropower/frame_2.png",
      name = "icon1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(94.75, 203.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 243, 181),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "name1",
      z = 0,
      parent = "card1",
      text = "Text Label",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(94.75, 119.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(80, 49, 24),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "desc1",
      z = 0,
      parent = "card1",
      text = T("\231\137\169\231\144\134\230\148\187\229\135\187\230\175\143\229\162\158\229\138\160\228\184\128\230\172\161\228\188\154\229\143\160\229\138\160\228\188\164\229\174\179"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(94.75, 72.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 111, h = 111},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "card2",
      res = "UI/alpha/1080P/chess/heropower/frame_2.png",
      name = "icon2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(94.75, 203.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 243, 181),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "name2",
      z = 0,
      parent = "card2",
      text = "Text Label",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(94.75, 119.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(80, 49, 24),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "desc2",
      z = 0,
      parent = "card2",
      text = T("\231\137\169\231\144\134\230\148\187\229\135\187\230\175\143\229\162\158\229\138\160\228\184\128\230\172\161\228\188\154\229\143\160\229\138\160\228\188\164\229\174\179"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(94.75, 72.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 111, h = 111},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "card3",
      res = "UI/alpha/1080P/chess/heropower/frame_2.png",
      name = "icon3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(94.75, 203.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 243, 181),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "name3",
      z = 0,
      parent = "card3",
      text = "Text Label",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(94.75, 119.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(80, 49, 24),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "desc3",
      z = 0,
      parent = "card3",
      text = T("\231\137\169\231\144\134\230\148\187\229\135\187\230\175\143\229\162\158\229\138\160\228\184\128\230\172\161\228\188\154\229\143\160\229\138\160\228\188\164\229\174\179"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(94.75, 72.25)
    }
  }
}
