ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaOppoInfoWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(605, 526)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 19, 201.5),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(483.5, 269)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/line_2b.png",
      name = "title_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(199, 499.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 67, h = 12.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/line_2b.png",
      name = "title_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(397, 499.5)
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
      parent = "bg",
      text = T("\229\175\185\230\137\139\228\191\161\230\129\175"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(298, 501)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.95, x = 0.95},
      flip = "",
      opacity = 255,
      fix_wh = {w = 104.5, h = 104.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/mainhead/main_head_frame_dr.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96.5, 433)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 280, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_enemy_info_name.png",
      name = "bg_name",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(295.5, 465)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 154, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_server_des",
      z = 0,
      parent = "bg",
      text = T("\229\140\186\230\156\141:"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(157.5, 429)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 154, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_grade_des",
      z = 0,
      parent = "bg",
      text = T("\230\174\181\228\189\141:"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(323, 429)
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
      name = "label_name",
      z = 0,
      parent = "bg_name",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\229\135\160\228\184\170\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(20, 15.25)
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
      name = "label_server_name",
      z = 0,
      parent = "bg",
      text = T("123\230\156\141 \229\183\168\233\190\153\229\174\136\230\138\164"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(201, 429)
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
      name = "label_score_val",
      z = 0,
      parent = "bg",
      text = "1234",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(367, 399.5)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(191, 57),
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_com_big.png",
      capInsets = CCRectMake(20, 15.5, 90, 32.5),
      name = "btn_battle",
      z = 2,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/common/button_com_big.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(296.5, 40.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(484, 294)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_info",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/toparena/toparena_enemy_info_gs2.png",
      capInsets = CCRectMake(17, 10, 450, 34)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(298.5, 227)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 154, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "score1",
      z = 0,
      parent = "bg",
      text = T("\231\167\175\229\136\134:"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(323, 399.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 154, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_guild_des",
      z = 0,
      parent = "bg",
      text = T("\229\133\172\228\188\154:"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(157.5, 399.5)
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
      name = "label_guild_name",
      z = 0,
      parent = "bg",
      text = T("\229\133\172\228\188\154\229\144\141\231\167\176"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(201, 399.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_battle",
      res = "UI/alpha/1080P/battle/battle_prepare_butt_fit_img.png",
      name = "icon_change",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(66, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_change",
      z = 0,
      parent = "btn_battle",
      text = T("\230\140\145 \230\136\152"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119.5, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 468.5, h = 33.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_info",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_enemy_info_gs.png",
      name = "bg_gs",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(241, 276)
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
      name = "label_gs",
      z = 0,
      parent = "bg_gs",
      text = "Text Label",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111.75, 16.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 247, 184),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_gs_tips",
      z = 0,
      parent = "bg_gs",
      text = T("\230\128\187\230\136\152\229\138\155"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(16.75, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 144.5, h = 109},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_enemy_info_camp.png",
      name = "bg_camp",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(507.5, 434.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6, x = 0.6},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/cuparena_rank_medal_1_name.png",
      name = "img_grade_name",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(397.5, 428.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(484, 254)
    },
    t = "Layer",
    base = {
      parent = "bg_info",
      name = "panel_team",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 3)
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
      name = "label_team_num",
      z = 0,
      parent = "bg_gs",
      text = T("\233\152\159\228\188\141\230\149\176\233\135\143\239\188\154%d"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(465.25, 14.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 204, 93),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_camp",
      z = 0,
      parent = "bg_camp",
      text = T("\229\190\183\233\178\129\228\188\138\233\152\181\229\174\185"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(71.25, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.1, x = 1.1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 82.5, h = 82.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_camp",
      res = "UI/alpha/1080P/cuparena/cuparena_camp_symbol_min_1.png",
      name = "img_camp_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(70.25, 68)
    }
  }
}
