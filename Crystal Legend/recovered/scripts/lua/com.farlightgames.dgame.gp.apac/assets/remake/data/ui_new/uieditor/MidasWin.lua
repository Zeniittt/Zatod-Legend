ed.uieditor = ed.uieditor or {}
ed.uieditor.MidasWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(500, 327.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 10, 10),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 304.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(500, 126)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 17, 10, 130),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "bg_result",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479, 79)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "bg",
      text = T("\231\130\185\233\135\145\230\137\139"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(250, 296.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_886",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(160, 296.25)
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
      name = "ImageView_887",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(340, 296.25)
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
      name = "btn_use",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/package/btn_package2.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(125, 39.75)
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
      name = "btn_use_continue",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/package/btn_package2.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(375, 39.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 251, 232),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_4438",
      z = 0,
      parent = "bg",
      text = T("\228\187\138\230\151\165\229\143\175\231\148\168"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(225, 227.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(191, 190, 184),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_num",
      z = 0,
      parent = "bg",
      text = "300/300",
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(308, 225.75)
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
      name = "Label_4442",
      z = 0,
      parent = "bg",
      text = T("\231\148\168\229\176\145\233\135\143\233\146\187\231\159\179\230\141\162\229\143\150\229\164\167\233\135\143\233\135\145\229\184\129"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(225, 189.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 599, h = 208},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/midas/midas_deco_bg.png",
      name = "bg_deco",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(250, 172.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 54, h = 55},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(485.5, 314.75)
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
      name = "label_use",
      z = 0,
      parent = "btn_use",
      text = T("\228\189\191\231\148\168"),
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
      name = "label_use_continue",
      z = 0,
      parent = "btn_use_continue",
      text = T("\232\191\158\231\187\173\228\189\191\231\148\168"),
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
      fix_wh = {w = 28, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_deco",
      res = "UI/alpha/1080P/icon/diamond.png",
      name = "icon_diamond",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(263, 42)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57, h = 46.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_deco",
      res = "UI/alpha/1080P/midas/midas_arrow.png",
      name = "ImageView_5438",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350.5, 42)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_deco",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "icon_money",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(418.5, 42)
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
      name = "icon_back",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 251, 227),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_diamond",
      z = 0,
      parent = "icon_diamond",
      text = "10",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(30.5, 14)
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
      name = "label_money",
      z = 0,
      parent = "icon_money",
      text = "100000",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(30.5, 14)
    }
  }
}
