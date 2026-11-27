ed.uieditor = ed.uieditor or {}
ed.uieditor.pet_egg_prob = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40.5, h = 41.25},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(716.5, 501)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(460, 510)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 10, 80),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "Image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(497, 258.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(275, 30)
    },
    t = "Layer",
    base = {
      name = "label_title",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(360.5, 472.5)
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(330, 445)
    },
    t = "Layer",
    base = {
      parent = "Image_bg",
      name = "panel_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(65, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "label_title",
      res = "UI/alpha/1080P/common/line_2b.png",
      name = "ImageView_692",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.5, 15.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 67, h = 12.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "label_title",
      res = "UI/alpha/1080P/common/line_2b.png",
      name = "ImageView_692_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(231.5, 16)
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
      name = "Label_699",
      z = 0,
      parent = "label_title",
      text = T("\229\173\181\229\140\150\231\187\188\229\144\136\230\166\130\231\142\135"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(136.5, 15.5)
    }
  }
}
