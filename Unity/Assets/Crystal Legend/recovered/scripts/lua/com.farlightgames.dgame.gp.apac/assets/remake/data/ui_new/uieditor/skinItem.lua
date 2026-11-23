ed.uieditor = ed.uieditor or {}
ed.uieditor.skinItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 82, h = 117},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/skin/show/Coco_Skin_1.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49, 95)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 124.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "icon",
      res = "UI/alpha/1080P/skin/skin_small_frame.png",
      name = "frame",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41, 58.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 108, h = 142},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "icon",
      res = "UI/alpha/1080P/skin/skin_choose.png",
      name = "select",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41, 59.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18.5, h = 22},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "icon",
      res = "UI/alpha/1080P/common/pvp_battle_lock.png",
      name = "lock",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41, 58.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(84, 33.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_select",
      z = 1,
      parent = "icon",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      capInsets = CCRectMake(10, 10, 80, 20)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, -22)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 211, 109),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "label_select",
      z = 1,
      parent = "icon",
      text = T("\231\169\191\230\136\180"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, -21)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 211, 109),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "label_weared",
      z = 1,
      parent = "icon",
      text = T("\229\183\178\231\169\191\230\136\180"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, -16.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(187, 187, 187),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "label_lock",
      z = 1,
      parent = "icon",
      text = T("\230\156\170\232\167\163\233\148\129"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, -16.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 226, 171),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title",
      z = 1,
      parent = "icon",
      text = T("\230\149\172\232\175\183\230\156\159\229\190\133"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41, 60)
    }
  }
}
