ed.uieditor = ed.uieditor or {}
ed.uieditor.crevicedefendRecordDetailItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(711.5, 72.5)
    },
    t = "Layer",
    base = {name = "bg", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-385, -37.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(655, 51)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_img",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/crevicedefend/team1.png",
      capInsets = CCRectMake(350, 15, 50, 15)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(9.5, 37)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 249, 161),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_num",
      z = 1,
      parent = "bg",
      text = "22222222",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(483.5, 37)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 249, 161),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_teamDamage",
      z = 1,
      parent = "bg",
      text = T("\228\188\164\229\174\179"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(377, 37)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(252.5, 55)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_hero",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(63.5, 8.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 249, 161),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_team",
      z = 1,
      parent = "bg",
      text = T("1\233\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.5, 37)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.7, x = 0.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.8, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_replay",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(615.5, 36.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.7, x = 0.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.8, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_statics",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(568.5, 36.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.19999993},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.799997795, h = 36},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_replay",
      res = "UI/alpha/1080P/crusade/btn_replay.png",
      name = "ImageView_2194",
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
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.8, h = 36},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_statics",
      res = "UI/alpha/1080P/crusade/btn_statics.png",
      name = "ImageView_2195",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
    }
  }
}
