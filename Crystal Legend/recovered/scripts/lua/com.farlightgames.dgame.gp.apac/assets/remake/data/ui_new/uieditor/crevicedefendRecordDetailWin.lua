ed.uieditor = ed.uieditor or {}
ed.uieditor.crevicedefendRecordDetailWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(665, 350)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(4, 20, 4, 20),
      res = "UI/alpha/1080P/common/com_new_3.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(479, 451)
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
      position = ccp(659.5, 345)
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
      text = T("\230\136\152\230\150\151\232\175\166\230\131\133"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(325, 321)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(660, 297.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_team",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(5, 5)
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "title",
      res = "UI/alpha/1080P/common/battle_prepare_lins_3.png",
      name = "img_title_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-71, 10)
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
      parent = "title",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "img_title_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(150.5, 10)
    }
  }
}
