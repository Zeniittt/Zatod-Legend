ed.uieditor = ed.uieditor or {}
ed.uieditor.PeakArenaOppoInfoWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(557, 519)
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
      position = ccp(479.5, 265)
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
      position = ccp(179.5, 490.5)
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
      position = ccp(377.5, 490.5)
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
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(278.5, 493)
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
      parent = "bg",
      res = "UI/alpha/1080P/mainhead/main_head_frame_dr.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90.5, 426.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 289, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/toparena/toparena_enemy_info_name.png",
      name = "bg_name",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(295, 459.5)
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
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\229\135\160\228\184\170\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(164, 459.5)
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
      name = "server1",
      z = 0,
      parent = "bg",
      text = T("\229\140\186    \230\156\141:"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(156, 429.5)
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
      name = "grade1",
      z = 0,
      parent = "bg",
      text = T("\230\174\181    \228\189\141:"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(155.5, 382)
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
      name = "zone1",
      z = 0,
      parent = "bg",
      text = T("\232\181\155    \229\140\186:"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(156, 406)
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
      name = "zonerank1",
      z = 0,
      parent = "bg",
      text = T("\232\181\155\229\140\186\230\142\146\229\144\141:"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(318.5, 406)
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
      name = "server2",
      z = 0,
      parent = "bg",
      text = T("\229\183\168\233\190\153\229\174\136\230\138\164"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(236, 429.5)
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
      name = "zone2",
      z = 0,
      parent = "bg",
      text = T("\231\172\172123\232\181\155\229\140\186"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(236, 406)
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
      name = "grade2",
      z = 0,
      parent = "bg",
      text = T("\229\183\168\233\190\153\229\174\136\230\138\164"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(236, 382)
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
      name = "score2",
      z = 0,
      parent = "bg",
      text = "1234",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(398.5, 382)
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
      position = ccp(278.5, 46.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(484, 283.5)
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
      position = ccp(279, 224.5)
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
      text = T("\231\167\175    \229\136\134:"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(318.5, 382)
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
      name = "guild1",
      z = 0,
      parent = "bg",
      text = T("\229\133\172    \228\188\154:"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(318.5, 429.5)
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
      name = "guild2",
      z = 0,
      parent = "bg",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(398.5, 429.5)
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
      name = "zonerank2",
      z = 0,
      parent = "bg",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(398.5, 406)
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
      position = ccp(42.5, 28.5)
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
      position = ccp(110.5, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 448.5, h = 33.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_info",
      res = "UI/alpha/1080P/toparena/toparena_enemy_info_gs1.png",
      name = "bg_gs",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(230, 265.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(475, 244.5)
    },
    t = "Layer",
    base = {
      parent = "bg_info",
      name = "Panel_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(5, 4.75)
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
      position = ccp(107.25, 16.75)
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
      position = ccp(8.75, 17.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(475, 244.5)
    },
    t = "Layer",
    base = {
      parent = "Panel_item",
      name = "item_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 472, h = 76},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_layer",
      res = "UI/alpha/1080P/toparena/toparena_enemy_team_bg1.png",
      name = "bg_team1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(237, 204.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 472, h = 76},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_layer",
      res = "UI/alpha/1080P/toparena/toparena_enemy_team_bg2.png",
      name = "bg_team2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(237, 125)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 472, h = 76},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_layer",
      res = "UI/alpha/1080P/toparena/toparena_enemy_team_bg3.png",
      name = "bg_team3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(237, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 472, h = 76},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_layer",
      res = "UI/alpha/1080P/toparena/toparena_enemy_team_bg4_tf.png",
      name = "bg_team4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(237, -34)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 472, h = 76},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_layer",
      res = "UI/alpha/1080P/toparena/toparena_enemy_team_bg5_tf.png",
      name = "bg_team5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(237, -113.5)
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
      name = "label_team1",
      z = 0,
      parent = "bg_team1",
      text = T("1\233\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.5, 38)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(171, 247, 246),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_team2",
      z = 0,
      parent = "bg_team2",
      text = T("2\233\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.5, 38)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 214, 186),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_team3",
      z = 0,
      parent = "bg_team3",
      text = T("3\233\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.5, 38)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(237, 195, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_team4",
      z = 0,
      parent = "bg_team4",
      text = T("4\233\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.5, 38)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 71, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_team4",
      res = "UI/alpha/1080P/toparena/toparena_prepare_bench_tag4.png",
      name = "ImageView_17030",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36, 66)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(163, 233, 212),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_team5",
      z = 0,
      parent = "bg_team5",
      text = T("5\233\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.5, 38)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 71, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_team5",
      res = "UI/alpha/1080P/toparena/toparena_prepare_bench_tag5.png",
      name = "ImageView_17030_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.5, 65.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 227, 142),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_17034",
      z = 0,
      parent = "ImageView_17030",
      text = T("\233\162\132\229\164\135"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.5, 11)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 227, 142),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_17034",
      z = 0,
      parent = "ImageView_17030_Copy0",
      text = T("\233\162\132\229\164\135"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.5, 11)
    }
  }
}
