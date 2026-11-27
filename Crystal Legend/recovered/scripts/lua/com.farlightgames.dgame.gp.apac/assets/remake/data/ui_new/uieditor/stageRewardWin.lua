ed.uieditor = ed.uieditor or {}
ed.uieditor.stageRewardWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(532, 410)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(13, 73.5, 13, 73.5),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "sweepBg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 255)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.7, x = 0.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 344.05, h = 39.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "sweepBg",
      res = "UI/alpha/1080P/campaign/campaign_detail_star_lock_bg.png",
      name = "title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(266, 389)
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
      parent = "sweepBg",
      text = T("\230\137\171\232\141\161"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(264.5, 390)
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
      parent = "sweepBg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "star_line1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(367, 391)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "sweepBg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "star_line2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(168, 391)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40.5, h = 41.25},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "sweepBg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "close_btn",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(517, 396.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 109, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "sweepBg",
      res = "UI/alpha/1080P/hero/equip/sweep_10_button.png",
      name = "sweep_btn",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(168, 32.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(124.5, 43.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "confirm_btn",
      z = 10,
      parent = "sweepBg",
      res = "UI/alpha/1080P/common/button_com_big.png",
      capInsets = CCRectMake(41.5, 16.5, 41.5, 16.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(365, 32)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 197.5, h = 9.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "sweepBg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_2.png",
      name = "image_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(265.5, 65.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(512, 300)
    },
    t = "Layer",
    base = {
      parent = "sweepBg",
      name = "reward_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(9.5, 70.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 97, h = 115},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/sweep/sweep_target_bg.png",
      name = "itemTargetBg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(796, 348.5)
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
      parent = "close_btn",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "close_btn_img",
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
      color = ccc3(168, 215, 235),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "sweep_label",
      z = 0,
      parent = "sweep_btn",
      text = T("\230\137\171\232\141\16110\230\172\161"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(54.5, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 218, 159),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "confirm_label",
      z = 0,
      parent = "confirm_btn",
      text = T("\231\161\174\232\174\164"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.25, 23.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 170, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_line",
      res = "UI/alpha/1080P/hero/equip/swerp_line.png",
      name = "ImageView_22309",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(98.75, 3.75)
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
      visible = true
    },
    t = "Label",
    base = {
      name = "sweep_times",
      z = 0,
      parent = "itemTargetBg",
      text = T("\230\156\172\230\172\161\230\137\171\232\141\161\239\188\154100"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49, 25)
    }
  }
}
