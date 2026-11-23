ed.uieditor = ed.uieditor or {}
ed.uieditor.PeakArenaBattleLogWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(798, 499.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(30, 130, 30, 130),
      res = "UI/alpha/1080P/common/com_new_2.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(466, 261)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.7999946, h = 38.4999945},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_close",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(784.5, 483.75)
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
      parent = "btn_close",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_240",
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
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 1,
      parent = "image_bg",
      text = T("\229\175\185\230\136\152\232\174\176\229\189\149"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(398.5, 469.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(765, 422.5)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "list_layer",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(16.5, 16.75)
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
      parent = "label_title",
      res = "UI/alpha/1080P/common/battle_prepare_lins_3.png",
      name = "ImageView_3624",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-79.5, 12.25)
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
      parent = "label_title",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_3625",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(118.5, 12.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 781.5, h = 57},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/toparena/toparena_record_bg.png",
      name = "ImageView_3979",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(399, 465.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 64.5, h = 73.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_1.png",
      name = "btn_record",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(828, 391.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 64.5, h = 73.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_1.png",
      name = "btn_statistic",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(828, 303.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(765, 422.5)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "statistic_layer",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(16, 16.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 72, h = 77},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_record",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_2.png",
      name = "btn_record_selected",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(30.75, 36.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_record",
      z = 0,
      parent = "btn_record",
      text = T("\229\175\185\230\136\152\232\174\176\229\189\149"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.25, 36.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_statistic",
      z = 0,
      parent = "btn_statistic",
      text = T("\230\149\176\230\141\174\231\187\159\232\174\161"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.25, 36.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 72, h = 77},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_statistic",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_2.png",
      name = "btn_statistic_selected",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(30.75, 36.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 815, h = 396.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "statistic_layer",
      res = "UI/alpha/1080P/toparena/toparena_data_bg.png",
      name = "image_statistic_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(382.5, 176)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(67, 57, 52),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_record_selected",
      z = 0,
      parent = "btn_record_selected",
      text = T("\229\175\185\230\136\152\232\174\176\229\189\149"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.5, 38.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 618.5, h = 39},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "statistic_layer",
      res = "UI/alpha/1080P/toparena/toparena_data_board.png",
      name = "image_bar1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(382.5, 290)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 618.5, h = 39},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "statistic_layer",
      res = "UI/alpha/1080P/toparena/toparena_data_board.png",
      name = "image_bar2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(382.5, 242)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 220, 149),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_total_times_tips",
      z = 0,
      parent = "statistic_layer",
      text = T("\230\128\187\229\156\186\230\172\161\239\188\154"),
      size = 28
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(393, 346)
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
      name = "label_total_times",
      z = 0,
      parent = "statistic_layer",
      text = "1234567",
      size = 28
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(393, 346)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 618.5, h = 39},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "statistic_layer",
      res = "UI/alpha/1080P/toparena/toparena_data_board.png",
      name = "image_bar4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(382.5, 69.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 618.5, h = 39},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "statistic_layer",
      res = "UI/alpha/1080P/toparena/toparena_data_board.png",
      name = "image_bar3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(382.5, 119)
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
      name = "label_today_times",
      z = 0,
      parent = "statistic_layer",
      text = "1234567",
      size = 28
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(419, 167.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 220, 149),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_today_times_tips",
      z = 0,
      parent = "statistic_layer",
      text = T("\228\187\138\230\151\165\229\156\186\230\172\161\239\188\154"),
      size = 24
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(418.5, 167.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(67, 57, 52),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_statistic_selected",
      z = 0,
      parent = "btn_statistic_selected",
      text = T("\230\149\176\230\141\174\231\187\159\232\174\161"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.5, 38.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 441, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "statistic_layer",
      res = "UI/alpha/1080P/toparena/toparena_record_line.png",
      name = "ImageView_69370",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(382.5, 397)
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
      name = "Label_1",
      z = 0,
      parent = "image_bar1",
      text = T("\232\191\155\230\148\187\229\156\186\230\172\161\239\188\154"),
      size = 24
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(202.75, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 246, 182),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_total_attack_times",
      z = 0,
      parent = "image_bar1",
      text = "123456",
      size = 24
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(202.75, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 246, 182),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_total_attack_win_times",
      z = 0,
      parent = "image_bar1",
      text = "123456",
      size = 24
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(506.25, 19.5)
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
      name = "Label_2",
      z = 0,
      parent = "image_bar1",
      text = T("\232\191\155\230\148\187\232\131\156\229\156\186\239\188\154"),
      size = 24
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(506.25, 19.5)
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
      name = "Label_3",
      z = 0,
      parent = "image_bar2",
      text = T("\233\152\178\229\174\136\229\156\186\230\172\161\239\188\154"),
      size = 24
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(202.75, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 246, 182),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_total_defend_times",
      z = 0,
      parent = "image_bar2",
      text = "123456",
      size = 24
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(202.75, 19.5)
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
      name = "Label_4",
      z = 0,
      parent = "image_bar2",
      text = T("\233\152\178\229\174\136\232\131\156\229\156\186\239\188\154"),
      size = 24
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(506.25, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 246, 182),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_total_defend_win_times",
      z = 0,
      parent = "image_bar2",
      text = "123456",
      size = 24
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(506.25, 19.5)
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
      name = "Label_3",
      z = 0,
      parent = "image_bar4",
      text = T("\233\152\178\229\174\136\229\156\186\230\172\161\239\188\154"),
      size = 24
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(202.75, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 246, 182),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_today_defend_times",
      z = 0,
      parent = "image_bar4",
      text = "123456",
      size = 24
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(202.75, 19.5)
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
      name = "Label_4_2",
      z = 0,
      parent = "image_bar4",
      text = T("\233\152\178\229\174\136\232\131\156\229\156\186\239\188\154"),
      size = 24
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(506.25, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 246, 182),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_today_defend_win_times",
      z = 0,
      parent = "image_bar4",
      text = "123456",
      size = 24
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(506.25, 19.5)
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
      name = "Label_1",
      z = 0,
      parent = "image_bar3",
      text = T("\232\191\155\230\148\187\229\156\186\230\172\161\239\188\154"),
      size = 24
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(202.75, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 246, 182),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_today_attack_times",
      z = 0,
      parent = "image_bar3",
      text = "123456",
      size = 24
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(202.75, 19.5)
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
      name = "Label_2_2",
      z = 0,
      parent = "image_bar3",
      text = T("\232\191\155\230\148\187\232\131\156\229\156\186\239\188\154"),
      size = 24
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(506.25, 19)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 246, 182),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_today_attack_win_times",
      z = 0,
      parent = "image_bar3",
      text = "123456",
      size = 24
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(506.25, 19.5)
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
      name = "label_statistic_title",
      z = 0,
      parent = "ImageView_69370",
      text = T("\228\187\133\231\187\159\232\174\161\230\173\163\229\188\143\232\181\155\229\173\163\231\154\132\229\156\186\230\172\161"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(219.5, 20)
    }
  }
}
