ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaChallengeResultItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(890, 62)
    },
    t = "Layer",
    base = {name = "bg", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-445, -31)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(575, 76)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_img",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_team_1.png",
      capInsets = CCRectMake(200, 15, 150, 5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(445, 31)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(255, 50)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_hero_left",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(110.5, 6)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(255, 50)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_hero_right",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(487, 7)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 70, h = 63},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_win2_tf.png",
      name = "image_result_win",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(428.5, 31.5)
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
      name = "btn_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(799.5, 29.5)
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
      name = "btn_record",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(853.5, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 84.5, h = 83},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_lose1_tf.png",
      name = "image_result_fail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(429, 34)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 124),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_result_win",
      z = 0,
      parent = "image_result_win",
      text = T("\232\131\156"),
      size = 32
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35, 31.5)
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
      parent = "btn_detail",
      res = "UI/alpha/1080P/crusade/btn_statics.png",
      name = "ImageView_2195",
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
      fix_scale = {y = 1.2, x = 1.19999993},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.799997795, h = 36},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_record",
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 216, 229),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_result_fail",
      z = 0,
      parent = "image_result_fail",
      text = T("\232\180\159"),
      size = 32
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42.25, 41.5)
    }
  }
}
