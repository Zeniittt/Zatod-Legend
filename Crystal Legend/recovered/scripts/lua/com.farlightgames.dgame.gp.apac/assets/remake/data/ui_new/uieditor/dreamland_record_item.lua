ed.uieditor = ed.uieditor or {}
ed.uieditor.dreamland_record_item = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(646.5, 97)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(50, 25, 450, 50),
      res = "UI/alpha/1080P/crusade/bg_replay_item.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, -1)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 263.5, h = 24},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/dreamland/dream_record_bossname_bg.png",
      name = "namebg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(137.75, 81)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(81, 62, 47),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_6250",
      z = 0,
      parent = "bg",
      text = T("\233\128\160\230\136\144\228\188\164\229\174\179\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(277.75, 81)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 77, 75),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "num",
      z = 0,
      parent = "bg",
      text = "",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(314.75, 81)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(110, 96, 91),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "time",
      z = 0,
      parent = "bg",
      text = "",
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(630.25, 79)
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
      name = "btn_share",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(499.25, 28)
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
      name = "btn_statics",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(555.75, 28.5)
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
      name = "btn_replay",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(612.25, 27)
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
      visible = true
    },
    t = "Label",
    base = {
      name = "name",
      z = 0,
      parent = "namebg",
      text = T("\233\189\144\229\164\169\229\164\167\229\156\163"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(49.25, 12)
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
      parent = "btn_share",
      res = "UI/alpha/1080P/crusade/btn_share.png",
      name = "ImageView_6255",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26.5, 27.5)
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
      name = "ImageView_7543",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26, 27.5)
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
      parent = "btn_replay",
      res = "UI/alpha/1080P/crusade/btn_replay.png",
      name = "ImageView_6255",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26.5, 27.5)
    }
  }
}
