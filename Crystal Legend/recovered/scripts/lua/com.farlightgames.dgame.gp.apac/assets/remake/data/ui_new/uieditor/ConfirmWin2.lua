ed.uieditor = ed.uieditor or {}
ed.uieditor.ConfirmWin2 = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(503.5, 281)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 19, 201.5),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 291)
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
      name = "title",
      z = 0,
      parent = "bg",
      text = T("\229\188\128\229\144\175\229\137\175\230\156\172"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(251.75, 259)
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
      name = "line1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(351.75, 256.5)
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
      name = "line2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(151.75, 256.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(123.5, 50.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_cancle",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      capInsets = CCRectMake(10, 10, 81, 22)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(123.75, 54.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(123.5, 50.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_ok",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      capInsets = CCRectMake(10, 10, 81, 22)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(379.75, 54.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "label1",
      z = 0,
      parent = "bg",
      text = "label1",
      size = 10
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(49.75, 190)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "label_sub_title",
      z = 0,
      parent = "bg",
      text = "label2",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(251.75, 230)
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
      name = "label_cancle",
      z = 0,
      parent = "btn_cancle",
      text = T("\229\143\150 \230\182\136"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.75, 26.75)
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
      name = "label_ok",
      z = 0,
      parent = "btn_ok",
      text = T("\231\161\174 \232\174\164"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.75, 26.75)
    }
  }
}
