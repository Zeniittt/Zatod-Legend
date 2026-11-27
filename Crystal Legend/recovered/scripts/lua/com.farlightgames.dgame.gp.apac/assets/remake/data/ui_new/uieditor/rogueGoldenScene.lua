ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueGoldenScene = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/main/main_golden_bg.jpg",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 270)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 248.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/crusade/bg_title_crusade.png",
      name = "image_title_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67, 508.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 583, h = 396},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/main/main_golden_dec_1.png",
      name = "image_dec_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(497.5, 384.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 453, h = 575.5},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/main/main_golden_dec_2.png",
      name = "image_dec_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(838.5, 294.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 457.5, h = 575.5},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/main/main_golden_dec_3.png",
      name = "image_dec_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(123, 294.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 268, h = 383},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/main/main_golden_dec_4.png",
      name = "image_dec_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(487, 168)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 449.5, h = 116.5},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/main/main_golden_book.png",
      name = "image_golden_book",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(491, 44.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 262.5, h = 32.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/main/main_golden_exp_bg.png",
      name = "image_exp_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 348)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 289, h = 32.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/main/weekly_reward_point_bg.png",
      name = "image_weekly_exp_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(911, 510)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(90, 90)
    },
    t = "Layer",
    base = {
      name = "panel_level",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(436, 364.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(760, 150)
    },
    t = "Layer",
    base = {name = "panel_list", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(101, 95)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.5, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_title_bg",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(191.75, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 226, 245),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_exp",
      z = 0,
      parent = "image_exp_bg",
      text = "1234",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(131.25, 16.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(182, 163, 201),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_exp_max",
      z = 0,
      parent = "image_exp_bg",
      text = "/12345",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(131.25, 16.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.5, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_exp_bg",
      res = "UI/alpha/1080P/rogue/main/rogue_exp.png",
      name = "exp_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(194.25, 14.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 226, 245),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_weekly_exp",
      z = 0,
      parent = "image_weekly_exp_bg",
      text = "1850",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(169.5, 16.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(182, 163, 201),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_weekly_exp_max",
      z = 0,
      parent = "image_weekly_exp_bg",
      text = "/12000",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(169.5, 16.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.5, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_weekly_exp_bg",
      res = "UI/alpha/1080P/rogue/main/rogue_exp.png",
      name = "weekly_exp_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(252, 16.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(182, 163, 201),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_weekly_exp_tips",
      z = 0,
      parent = "image_weekly_exp_bg",
      text = T("\230\156\172\229\145\168\231\129\171\232\138\177\228\184\138\233\153\144"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(113, 16.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 9, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_rule",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "ImageView_27775",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.25, 13.25)
    }
  }
}
