ed.uieditor = ed.uieditor or {}
ed.uieditor.dreamland_record_pop = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(675, 500)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(19.5, 20.5, 50, 350),
      res = "UI/alpha/1080P/common/com_new_2.png",
      name = "ImageView_6217",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480.5, 266)
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
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_close",
      z = 99
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(805, 502)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(657.5, 55)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(12, 11.5, 0.5, 0.5),
      res = "UI/alpha/1080P/mail/mail_tit_bj.png",
      name = "ImageView_6237",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480.5, 482.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(675, 500)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(25, 25, 5, 150),
      res = "UI/alpha/1080P/common/com_img_9bg2.png",
      name = "ImageView_6238",
      z = 98
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 265.5)
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
      res = "UI/alpha/1080P/common/battle_prepare_lins_3.png",
      name = "ImageView_6239",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(381, 484.5)
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
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_6240",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(580, 484.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 254, 232),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 20,
      text = T("\230\136\152\230\150\151\232\174\176\229\189\149"),
      name = "Label_6241",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 485)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(651, 428.5)
    },
    t = "Layer",
    base = {name = "item_list", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(155.5, 30)
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
      parent = "btn_close",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_6223",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 28.5)
    }
  }
}
