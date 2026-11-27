ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaDefensiveWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(797, 498)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(20, 20, 49.5, 351),
      res = "UI/alpha/1080P/common/com_new_2.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(478, 268)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 781.5, h = 57},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/toparena/toparena_record_bg.png",
      name = "ImageView_16742",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(398.5, 459.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.72, x = 0.72},
      flip = "",
      opacity = 255,
      fix_wh = {w = 38.88, h = 39.6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(783, 482)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_back",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_902",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 28.5)
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
      name = "title",
      z = 0,
      parent = "bg",
      text = T("\233\152\178\229\174\136\233\152\181\229\174\185\232\174\190\231\189\174"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(398.5, 463)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(179, 204, 97),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tip",
      z = 0,
      parent = "bg",
      text = T("\231\130\185\229\135\187\232\139\177\233\155\132\229\164\180\229\131\143\232\174\190\231\189\174\233\154\144\232\151\143"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(399, 105)
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
      position = ccp(305.5, 51.5)
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
      name = "btn_adjust",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(491, 51.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_3.png",
      name = "img_title_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(287.5, 460)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "img_title_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(509, 460)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 139.5, h = 66},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_hide",
      res = "UI/alpha/1080P/toparena/toparena_team_invisible_choose.png",
      name = "btn_hide_save",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.25, 25.25)
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
      name = "label_hide_tips",
      z = 2,
      parent = "btn_hide",
      text = T("\232\174\190\231\189\174\233\154\144\232\151\143"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.75, 26.25)
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
      name = "label_adjust",
      z = 2,
      parent = "btn_adjust",
      text = T("\232\176\131\230\149\180"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.25, 26.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(716, 310)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_team",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(40.5, 121.5)
    }
  }
}
