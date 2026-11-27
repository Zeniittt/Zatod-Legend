ed.uieditor = ed.uieditor or {}
ed.uieditor.kingsBattleResultWindow = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(1040, 356.5)
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
      position = ccp(470.5, 416.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(235, 209, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 19,
      text = T("10\231\167\146\229\144\142\232\135\170\229\138\168\231\187\167\231\187\173"),
      name = "label_close_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 22)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(900, 200.5)
    },
    t = "Layer",
    base = {
      name = "panel_battle_info",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(31.5, 82.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1053, h = 67.05},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/battle/battle_enter_rb_bg.png",
      name = "image_summary_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 328)
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
      name = "panel_head_blue",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(56.5, 297)
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
      name = "panel_head_red",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(835, 297)
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
      position = ccp(480, 439)
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
      position = ccp(480, 426.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(125, 30)
    },
    t = "Layer",
    base = {
      name = "panel_name_blue",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(124.5, 309.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(125, 30)
    },
    t = "Layer",
    base = {
      name = "panel_name_red",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(703.5, 309.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32, h = 33},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/battle/battle_prepare_butt_fit_img.png",
      name = "ImageView_79785",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 324.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 124.5, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/common/button_com_big.png",
      name = "btn_continue",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(820.5, 32)
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
      name = "image_total_score",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 384.5)
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
      name = "panel_score_red",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(493, 310.5)
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
      name = "panel_score_blue",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(301, 310)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 224, 159),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_continue",
      z = 0,
      parent = "btn_continue",
      text = T("\231\187\167\231\187\173"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.25, 26.25)
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
      parent = "image_total_score",
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
      parent = "image_total_score",
      res = "UI/alpha/1080P/battle/battle_stage_2.png",
      name = "image_score_blue",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108, 15.5)
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
      parent = "image_total_score",
      res = "UI/alpha/1080P/battle/battle_stage_1.png",
      name = "image_score_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(152.5, 15.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 153, 122),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_score_red_tips",
      z = 0,
      parent = "panel_score_red",
      text = T("\231\167\175\229\136\134"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-1.5, 40)
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
      parent = "panel_score_red",
      res = "UI/alpha/1080P/pvp/arrow_down.png",
      name = "image_down_red",
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
      parent = "panel_score_red",
      res = "UI/alpha/1080P/pvp/arrow_up.png",
      name = "image_up_red",
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
      color = ccc3(139, 193, 238),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_score_blue_tips",
      z = 0,
      parent = "panel_score_blue",
      text = T("\231\167\175\229\136\134"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(165.5, 40.5)
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
      name = "label_change_red",
      z = 0,
      parent = "panel_score_red",
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
      name = "label_change_blue",
      z = 0,
      parent = "panel_score_blue",
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
      parent = "panel_score_blue",
      res = "UI/alpha/1080P/pvp/arrow_up.png",
      name = "image_up_blue",
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
      parent = "panel_score_blue",
      res = "UI/alpha/1080P/pvp/arrow_down.png",
      name = "image_down_blue",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(72.5, 15)
    }
  }
}
