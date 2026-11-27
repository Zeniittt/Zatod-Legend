ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaOperateItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(132, 101.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(50, 50, 10, 10),
      res = "UI/alpha/1080P/chat/config_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(113, 35.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(30, 35.5, 0.5, 0.5),
      res = "UI/alpha/1080P/common/button_com_sys.png",
      name = "btn_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 10)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(113, 35.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(30, 35.5, 0.5, 0.5),
      res = "UI/alpha/1080P/common/button_com_sys.png",
      name = "btn_battle_info",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, -26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_detail",
      res = "UI/alpha/1080P/cuparena/knockout/course/course_player_info.png",
      name = "ImageView_17088",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22, 18.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 235, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_detail",
      z = 0,
      parent = "btn_detail",
      text = T("\228\191\161\230\129\175"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.5, 19.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_battle_info",
      res = "UI/alpha/1080P/cuparena/knockout/course/course_battle_video.png",
      name = "ImageView_17088",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.5, 18.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 235, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_battle_info",
      z = 0,
      parent = "btn_battle_info",
      text = T("\230\136\152\229\134\181"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.5, 19.75)
    }
  }
}
