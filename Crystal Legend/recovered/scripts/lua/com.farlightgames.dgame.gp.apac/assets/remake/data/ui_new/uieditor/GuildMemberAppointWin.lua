ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildMemberAppointWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(430, 167)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 25, 10, 150),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 270)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.199997408, h = 43.99999736},
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
      position = ccp(413, 153)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 74.799995512, h = 75.199995488},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/main/main_head_playtop.png",
      name = "avatar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67, 115.5)
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
      name = "label_monthcard",
      z = 0,
      parent = "bg",
      text = T("\230\151\160\229\133\172\228\188\154\230\156\136\229\141\161"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(101.5, 87.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 43)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_elder",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(25, 11.5, 25, 11.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(80, 47)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 43)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_chairman",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(25, 11.5, 25, 11.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(215, 47)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 43)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_out",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(25, 11.5, 25, 11.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350, 47)
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
      name = "ImageView_2427",
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
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_elder",
      z = 0,
      parent = "btn_elder",
      text = T("\229\141\135\228\184\186\233\149\191\232\128\129"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 23)
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
      name = "label_chairman",
      z = 0,
      parent = "btn_chairman",
      text = T("\229\141\135\228\184\186\228\188\154\233\149\191"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 23)
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
      name = "label_out",
      z = 0,
      parent = "btn_out",
      text = T("\232\184\162\229\135\186\229\133\172\228\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 23)
    }
  }
}
