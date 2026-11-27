ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloMultiplayerwarn = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(273, 109)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 19, 201.5),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "img_bg_matchroom",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(475.5, 288.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 100, h = 80},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_bg_matchroom",
      res = "UI/alpha/1080P/common/loading.png",
      name = "img_flower_mhr",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(54.5, 78)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "lab_title_mhr",
      z = 0,
      parent = "img_bg_matchroom",
      text = T("\230\173\163\229\156\168\233\154\143\230\156\186\229\140\185\233\133\141\233\152\159\229\143\139..."),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(82, 78)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(285, 162.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(25, 25, 21.5, 21.5),
      res = "UI/alpha/1080P/chesscard/match/match_bg1.png",
      name = "img_bg_joinroom",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(475.5, 288.5)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(195, 46.5),
      flip = "",
      labelConfig = {
        color = ccc3(255, 234, 198)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_com_mini.png",
      capInsets = CCRectMake(31.25, 24.22, 0.78, 13.28),
      name = "btn_cancel_mhr",
      z = 0,
      parent = "img_bg_matchroom",
      text = "",
      press = "UI/alpha/1080P/common/button_com_mini.png",
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(136.5, 34)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "lab_cancel_mhr",
      z = 0,
      parent = "img_bg_matchroom",
      text = T("\229\143\150\230\182\136\229\140\185\233\133\141"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(136.5, 36.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(156, 23)
    },
    t = "Layer",
    base = {
      name = "layer_input_jnr",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(398.5, 288)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(180, 45)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_input_jnr",
      z = 0,
      parent = "img_bg_joinroom",
      res = "UI/alpha/1080P/guild/setup_rename_bg.png",
      capInsets = CCRectMake(50, 10, 241.5, 20)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(142.5, 92.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 236, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "lab_title_tag_jnr",
      z = 0,
      parent = "img_bg_joinroom",
      text = T("\232\175\183\232\190\147\229\133\165\230\136\191\233\151\180ID\239\188\154"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(16.5, 135.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(273, 78)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 19, 201.5),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "img_bg_createroom",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(475.5, 288.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      fix_wh = {w = 89.5999872, h = 40.5999942},
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
      normal = "UI/alpha/1080P/chesscard/match/match_button_1.png",
      name = "btn_enter_jnr",
      z = 0,
      parent = "img_bg_joinroom",
      text = "",
      press = "UI/alpha/1080P/chesscard/match/match_button_1.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(142.5, 42.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 39.5, h = 39.5},
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
      normal = "UI/alpha/1080P/chesscard/match/closed.png",
      name = "btn_close_jnr",
      z = 0,
      parent = "img_bg_joinroom",
      text = "",
      press = "UI/alpha/1080P/chesscard/match/closed.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(268, 151.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 100, h = 80},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "img_bg_joinroom",
      res = "UI/alpha/1080P/common/loading.png",
      name = "img_flower_jnr",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52.5, 42.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "lab_enter",
      z = 0,
      parent = "btn_enter_jnr",
      text = T("\230\144\156\231\180\162"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64, 29)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 100, h = 80},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_bg_createroom",
      res = "UI/alpha/1080P/common/loading.png",
      name = "img_flower_ctr",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.5, 44.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "lab_title_ctr",
      z = 0,
      parent = "img_bg_createroom",
      text = T("\230\173\163\229\156\168\228\184\186\230\130\168\229\136\155\229\187\186\230\136\191\233\151\180..."),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(74, 39)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "lab_title_jnr",
      z = 0,
      parent = "img_flower_jnr",
      text = T("\230\173\163\229\156\168\228\184\186\230\130\168\230\144\156\231\180\162\230\136\191\233\151\180..."),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(77.5, 40)
    }
  }
}
