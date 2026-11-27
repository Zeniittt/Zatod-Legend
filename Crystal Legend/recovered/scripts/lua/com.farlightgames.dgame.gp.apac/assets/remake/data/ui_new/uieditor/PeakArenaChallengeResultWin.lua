ed.uieditor = ed.uieditor or {}
ed.uieditor.PeakArenaChallengeResultWin = {
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
      name = "image_total_score",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(459.5, 384.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(950, 205)
    },
    t = "Layer",
    base = {
      name = "panel_battle_info",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 92.5)
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
      text = T("\231\130\185\229\135\187\231\169\186\231\153\189\229\164\132\233\128\128\229\135\186"),
      name = "label_close_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(464, 40.5)
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
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_info_bg.png",
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
      scaleSize = CCSizeMake(950, 205)
    },
    t = "Layer",
    base = {
      parent = "panel_battle_info",
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
      scaleSize = CCSizeMake(888, 60.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_team_bg1",
      z = 0,
      parent = "item_layer",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_team_bg4.png",
      capInsets = CCRectMake(7.5, 7.5, 7.5, 7.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(476.5, 170)
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
      scaleSize = CCSizeMake(888, 60.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_team_bg2",
      z = 0,
      parent = "item_layer",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_team_bg4.png",
      capInsets = CCRectMake(7.5, 7.5, 7.5, 7.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(476.5, 106.5)
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
      scaleSize = CCSizeMake(888, 60.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_team_bg3",
      z = 0,
      parent = "item_layer",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_team_bg4.png",
      capInsets = CCRectMake(7.5, 7.5, 7.5, 7.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(476.5, 43)
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 102.5, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_summary_bg",
      res = "UI/alpha/1080P/toparena/toparena_fail_protect_bg.png",
      name = "image_protect_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(570.75, 59)
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
      color = ccc3(255, 153, 122),
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 888, h = 60.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_team_bg1",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_team_bg1_tf.png",
      name = "image_team_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(444, 30.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 888, h = 60.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_team_bg2",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_team_bg2_tf.png",
      name = "image_team_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(444, 30.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 888, h = 60.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_team_bg3",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_team_bg3_tf.png",
      name = "image_team_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(444, 30.25)
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
      parent = "image_team_1",
      name = "panel_hero_left_1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(107.5, 6.25)
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
      parent = "image_team_1",
      name = "panel_hero_right_1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(488, 6.25)
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
      parent = "image_team_1",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_win2_tf.png",
      name = "image_result_win_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(424, 30.25)
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
      parent = "image_team_1",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_detail_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(797.5, 28.25)
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
      parent = "image_team_1",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_record_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(853, 28.25)
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
      parent = "image_team_1",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_lose1_tf.png",
      name = "image_result_fail_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(424, 30.25)
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
      parent = "image_team_2",
      name = "panel_hero_left_2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(107.5, 6.25)
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
      parent = "image_team_2",
      name = "panel_hero_right_2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(488, 6.25)
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
      parent = "image_team_2",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_win2_tf.png",
      name = "image_result_win_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(424, 30.25)
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
      parent = "image_team_2",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_detail_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(797.5, 28.25)
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
      parent = "image_team_2",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_record_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(853, 28.25)
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
      parent = "image_team_2",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_lose1_tf.png",
      name = "image_result_fail_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(424, 30.25)
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
      parent = "btn_detail_1",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(255, 50)
    },
    t = "Layer",
    base = {
      parent = "image_team_3",
      name = "panel_hero_left_3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(107.5, 6.25)
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
      parent = "btn_record_1",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(255, 50)
    },
    t = "Layer",
    base = {
      parent = "image_team_3",
      name = "panel_hero_right_3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(488, 6.25)
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
      parent = "image_team_3",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_win2_tf.png",
      name = "image_result_win_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(424, 30.25)
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
      parent = "image_team_3",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_detail_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(797.5, 28.25)
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
      parent = "image_team_3",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_record_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(853, 28.25)
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
      parent = "image_team_3",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_lose1_tf.png",
      name = "image_result_fail_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(424, 30.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(888, 60.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_team_bg4",
      z = 0,
      parent = "item_layer",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_team_bg4.png",
      capInsets = CCRectMake(7.5, 7.5, 7.5, 7.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(476.5, -20)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(888, 60.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_team_bg5",
      z = 0,
      parent = "item_layer",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_team_bg4.png",
      capInsets = CCRectMake(7.5, 7.5, 7.5, 7.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(476.5, -83.5)
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
      parent = "btn_detail_2",
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
      parent = "btn_record_2",
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
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.8, h = 36},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_detail_3",
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
      fix_scale = {y = 1.2, x = 1.19999993},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.799997795, h = 36},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_record_3",
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 253, 91),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_protect_right",
      z = 0,
      parent = "image_protect_right",
      text = T("\229\164\177\232\180\165\228\191\157\230\138\164"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.25, 13.25)
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
      name = "label_result_win_1",
      z = 0,
      parent = "image_result_win_1",
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
      name = "label_result_fail_1",
      z = 0,
      parent = "image_result_fail_1",
      text = T("\232\180\159"),
      size = 32
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42.25, 41.5)
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
      name = "label_result_win_2",
      z = 0,
      parent = "image_result_win_2",
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
      name = "label_result_fail_2",
      z = 0,
      parent = "image_result_fail_2",
      text = T("\232\180\159"),
      size = 32
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42.25, 41.5)
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
      name = "label_result_win_3",
      z = 0,
      parent = "image_result_win_3",
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
      name = "label_result_fail_3",
      z = 0,
      parent = "image_result_fail_3",
      text = T("\232\180\159"),
      size = 32
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42.25, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 888, h = 60.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_team_bg4",
      res = "UI/alpha/1080P/toparena/toparena_team_bg5.png",
      name = "image_team_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(444, 30.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 888, h = 60.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_team_bg5",
      res = "UI/alpha/1080P/toparena/toparena_team_bg6.png",
      name = "image_team_5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(444, 30.25)
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
      parent = "image_team_4",
      name = "panel_hero_left_4",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(107.5, 6.25)
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
      parent = "image_team_4",
      name = "panel_hero_right_4",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(488, 6.25)
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
      parent = "image_team_4",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_win2_tf.png",
      name = "image_result_win_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(424, 30.25)
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
      parent = "image_team_4",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_detail_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(797.5, 28.25)
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
      parent = "image_team_4",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_record_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(853, 28.25)
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
      parent = "image_team_4",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_lose1_tf.png",
      name = "image_result_fail_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(424, 30.25)
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
      parent = "image_team_5",
      name = "panel_hero_left_5",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(107.5, 6.25)
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
      parent = "image_team_5",
      name = "panel_hero_right_5",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(488, 6.25)
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
      parent = "image_team_5",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_win2_tf.png",
      name = "image_result_win_5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(424, 30.25)
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
      parent = "image_team_5",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_detail_5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(797.5, 28.25)
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
      parent = "image_team_5",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_record_5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(853, 28.25)
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
      parent = "image_team_5",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_lose1_tf.png",
      name = "image_result_fail_5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(424, 30.25)
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
      name = "label_result_win_4",
      z = 0,
      parent = "image_result_win_4",
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
      parent = "btn_detail_4",
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
      parent = "btn_record_4",
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
      name = "label_result_fail_4",
      z = 0,
      parent = "image_result_fail_4",
      text = T("\232\180\159"),
      size = 32
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42.25, 41.5)
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
      name = "label_result_win_5",
      z = 0,
      parent = "image_result_win_5",
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
      parent = "btn_detail_5",
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
      parent = "btn_record_5",
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
      name = "label_result_fail_5",
      z = 0,
      parent = "image_result_fail_5",
      text = T("\232\180\159"),
      size = 32
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42.25, 41.5)
    }
  }
}
