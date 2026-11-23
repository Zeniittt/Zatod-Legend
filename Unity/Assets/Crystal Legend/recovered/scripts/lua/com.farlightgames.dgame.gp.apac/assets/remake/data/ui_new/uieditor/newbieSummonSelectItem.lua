ed.uieditor = ed.uieditor or {}
ed.uieditor.newbieSummonSelectItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 123.5, h = 135.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/summonbeginner/beignner_hero_choose_1.png",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_6.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.75, 85.75)
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
      name = "name",
      z = 0,
      parent = "bg",
      text = T("\232\136\185\233\149\191"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.75, 31.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.5, h = 19},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/herohot/herohot_fire_icon.png",
      name = "ImageView_713",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(79.25, 10.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 221, 139),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "hot",
      z = 0,
      parent = "bg",
      text = "123",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(68.25, 9.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 150.5, h = 162.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/summonbeginner/beignner_hero_choose_frame.png",
      name = "selected",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.75, 67.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 140.4, h = 140.4},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "selected",
      res = "UI/alpha/1080P/taskModel/player_award_list_item_eff.png",
      name = "ImageView_724",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(75.25, 98.75)
    }
  }
}
