ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaChallengeResultWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(1040, 348.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(320, 118.5, 320, 118.5),
      res = "UI/alpha/1080P/battleresult/victory_bg.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(471, 410.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 261, h = 31},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_score.png",
      name = "bg_total_score",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(458.5, 384.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(950, 221)
    },
    t = "Layer",
    base = {
      name = "panel_record",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(5, 71.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.700000048, x = 0.700000048},
      flip = "",
      opacity = 255,
      fix_wh = {w = 8.400000576, h = 15.400001056},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_total_score",
      res = "UI/alpha/1080P/battle/battle_stage_colon.png",
      name = "image_colon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(131, 15.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.1, x = 1.1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13.2, h = 24.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_total_score",
      res = "UI/alpha/1080P/battle/battle_stage_2.png",
      name = "image_total_score_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.1, x = 1.1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13.2, h = 24.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_total_score",
      res = "UI/alpha/1080P/battle/battle_stage_1.png",
      name = "image_total_score_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(152.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      name = "panel_win_anim",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(460, 426.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      name = "panel_fail_anim",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(459.5, 439)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 921.5, h = 72},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/cuparena/cuparena_battle_result_bg.png",
      name = "image_summary_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(476.5, 330)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 375.5, h = 34},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_summary_bg",
      res = "UI/alpha/1080P/cuparena/cuparena_battle_result_bg1.png",
      name = "bg_score",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(453.75, 28.5)
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
      name = "label_name_left",
      z = 0,
      parent = "image_summary_bg",
      text = T("\231\148\187\233\163\142\229\144\131\233\135\142\228\186\186"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(109.25, 36)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "image_summary_bg",
      name = "panel_head_left",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(40.75, 5.5)
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
      name = "label_name_right",
      z = 0,
      parent = "image_summary_bg",
      text = T("\230\156\186\229\153\168\228\186\186\228\184\141\230\142\137\229\136\134"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(805.75, 35)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "image_summary_bg",
      name = "panel_head_right",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(818.25, 5.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(165, 30)
    },
    t = "Layer",
    base = {
      parent = "image_summary_bg",
      name = "panel_score_left",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(264.25, 13.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(165, 30)
    },
    t = "Layer",
    base = {
      parent = "image_summary_bg",
      name = "panel_score_right",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(456.25, 14)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(165, 214, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_score_1",
      z = 0,
      parent = "image_summary_bg",
      text = T("\231\167\175\229\136\134"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(432.75, 56)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 158, 105),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_score_2",
      z = 0,
      parent = "image_summary_bg",
      text = T("\231\167\175\229\136\134"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(457.25, 56)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(135, 255, 77),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_change_left",
      z = 0,
      parent = "panel_score_left",
      text = "1234",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(62.5, 15.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.5, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_score_left",
      res = "UI/alpha/1080P/pvp/arrow_up.png",
      name = "image_up_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(72.5, 15)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.5, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_score_left",
      res = "UI/alpha/1080P/pvp/arrow_down.png",
      name = "image_down_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(72.5, 15)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.5, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_score_right",
      res = "UI/alpha/1080P/pvp/arrow_down.png",
      name = "image_down_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(95, 15)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.5, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_score_right",
      res = "UI/alpha/1080P/pvp/arrow_up.png",
      name = "image_up_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(95, 15.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 171, 130),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_change_right",
      z = 0,
      parent = "panel_score_right",
      text = "123",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(105, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 42, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/toparena/toparena_star_icon_2.png",
      name = "img_medal",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(444, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 245, 176),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 21,
      text = "+10",
      name = "label_medal",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(467, 42.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 941, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/cuparena/cuparena_battle_result_line.png",
      name = "bg_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 67.5)
    }
  }
}
