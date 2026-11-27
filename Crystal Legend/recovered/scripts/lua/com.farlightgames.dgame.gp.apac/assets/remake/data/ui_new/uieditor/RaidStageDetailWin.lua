ed.uieditor = ed.uieditor or {}
ed.uieditor.RaidStageDetailWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(600, 380)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(20, 20, 50, 350),
      res = "UI/alpha/1080P/common/com_new_2.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 242)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 448.399973096, h = 49.999997},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/raid/map_title.png",
      name = "bg_title",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(300, 382.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(33, 1, 3),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_16895",
      z = 2,
      parent = "bg_title",
      text = T("1-1  \229\133\168\229\134\155\229\135\186\229\135\187"),
      size = 26
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(280.25, 34.25)
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
      name = "btn_back",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(582, 363)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(80, 30)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_rank",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/skilltower/bg_btn_reward.png",
      capInsets = CCRectMake(36.5, 11, 36.5, 11)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(501.5, 340)
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
      name = "ImageView_2427",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(250, 25)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_step",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/campaign/campaign_detail_in_bg.png",
      capInsets = CCRectMake(14, 5, 10, 6)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(300, 340)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 235, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_rank",
      z = 0,
      parent = "btn_rank",
      text = T("\230\156\172\230\156\141\230\142\146\232\161\140"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, 17)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_rank",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "icon_redLight",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(86, 27)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(550, 5)
    },
    t = "Scale9Sprite",
    base = {
      name = "line1",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/campaign/campaign_detail_line_1.png",
      capInsets = CCRectMake(5, 0, 238, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(300, 282.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 165, 49),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_enemy",
      z = 0,
      parent = "bg",
      text = T("\230\149\140\230\150\185\233\152\181\229\174\185\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(50, 247)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 204, 102),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_step",
      z = 0,
      parent = "bg_step",
      text = T("\231\172\1721\230\179\162\230\149\140\228\186\186\239\188\136\229\133\1773\230\179\162\239\188\137"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(125, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 165, 49),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_reward",
      z = 0,
      parent = "bg",
      text = T("\229\143\175\232\131\189\232\142\183\229\190\151\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(50, 160)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(550, 5)
    },
    t = "Scale9Sprite",
    base = {
      name = "line2",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/campaign/campaign_detail_line_1.png",
      capInsets = CCRectMake(5, 0, 238, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(300, 102)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 153.599990784, h = 45.199997288},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/buttion_big.png",
      name = "btn_go",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(498.5, 44)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "label_time",
      z = 0,
      parent = "bg",
      text = T("\228\187\138\230\151\165\229\137\169\228\189\153\230\172\161\230\149\176\239\188\1540/3"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(499.5, 81.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(300, 115)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_other",
      z = 2,
      parent = "bg",
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      capInsets = CCRectMake(15, 15, 15, 191.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(160, 67)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(500, 37.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "describe_panel",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(50, 287.5)
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
      name = "label_go",
      z = 0,
      parent = "btn_go",
      text = T("\230\140\145\230\136\152"),
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(123.5, 29.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.1, x = 1.1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35.2, h = 36.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_go",
      res = "UI/alpha/1080P/battle/battle_prepare_butt_fit_img.png",
      name = "icon_go",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(66, 28.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 110, h = 110},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_other",
      res = "UI/alpha/1080P/mainhead/main_head_frame_silver.png",
      name = "avatar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69, 59)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 46.5, h = 45},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_other",
      res = "UI/alpha/1080P/raid/challenging_icon.png",
      name = "icon_challenging",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(184, 81.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 148, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_other",
      res = "UI/alpha/1080P/raid/challenging_bg.png",
      name = "icon_challenging1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(187, 48.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 151.1999784, h = 20.2999971},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_other",
      res = "UI/alpha/1080P/raid/name_bg_1.png",
      name = "bg_othername",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(186, 23)
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
      name = "label_state",
      z = 0,
      parent = "bg_other",
      text = T("\229\135\134\229\164\135\228\184\173..."),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(186.5, 51.5)
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
      name = "label_name",
      z = 0,
      parent = "bg_other",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\229\135\160\228\184\170\229\173\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(187.5, 22)
    }
  }
}
