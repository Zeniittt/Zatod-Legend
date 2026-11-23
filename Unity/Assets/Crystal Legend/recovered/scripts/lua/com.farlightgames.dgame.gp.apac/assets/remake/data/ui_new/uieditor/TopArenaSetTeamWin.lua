ed.uieditor = ed.uieditor or {}
ed.uieditor.TopArenaSetTeamWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(797, 510)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(20, 20, 49.5, 351),
      res = "UI/alpha/1080P/common/com_new_2.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(477.5, 264)
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
      parent = "bg",
      res = "UI/alpha/1080P/toparena/toparena_record_bg.png",
      name = "ImageView_16742_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(398.5, 476.5)
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
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(782.5, 498.5)
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
      name = "ImageView_902",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 28.5)
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
      name = "title",
      z = 0,
      parent = "bg",
      text = T("\233\152\178\229\174\136\233\152\181\229\174\185\232\174\190\231\189\174"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(400, 479.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(179, 204, 97),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tip",
      z = 0,
      parent = "bg",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(399, 97)
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
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_big.png",
      name = "button_hide",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(306.5, 55.5)
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
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_big.png",
      name = "button_adjust",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(490, 55.5)
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
      name = "ImageView_2121",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(291, 479)
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
      name = "ImageView_2122",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(510, 479)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(122.5, 39)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_star",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/button_mini_sys.png",
      capInsets = CCRectMake(10, 10, 81.5, 22)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(110.5, 475.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(725, 336.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "Panel_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(37.5, 115.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 139.5, h = 66},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "button_hide",
      res = "UI/alpha/1080P/toparena/toparena_team_invisible_choose.png",
      name = "button_hide_save",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.25, 25.25)
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
      name = "Label_913",
      z = 2,
      parent = "button_hide",
      text = T("\232\174\190\231\189\174\233\154\144\232\151\143"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.25, 26.25)
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
      name = "Label_914",
      z = 2,
      parent = "button_adjust",
      text = T("\230\155\180\230\141\162\232\139\177\233\155\132"),
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.5, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_star",
      res = "UI/alpha/1080P/toparena/toparena_star_icon_1.png",
      name = "ImageView_4169",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.25, 19)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_4170",
      z = 0,
      parent = "btn_star",
      text = T("\229\134\179\230\150\151\228\185\139\230\152\159"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(72.25, 21)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(725, 336.5)
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
      fix_wh = {w = 702.5, h = 94},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_layer",
      res = "UI/alpha/1080P/toparena/toparena_team_defense_bg1_tf.png",
      name = "team1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(361, 286)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 48, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "team1",
      res = "UI/alpha/1080P/toparena/toparena_team_exchange2.png",
      name = "button_switch1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(646.25, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 48, h = 35.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "team1",
      res = "UI/alpha/1080P/toparena/toparena_team_exchange1.png",
      name = "button_switch_save1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(643.25, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 702.5, h = 94},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_layer",
      res = "UI/alpha/1080P/toparena/toparena_team_defense_bg2_tf.png",
      name = "team2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(361, 187.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 723.5, h = 115},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "team1",
      res = "UI/alpha/1080P/toparena/toparena_team_choose.png",
      name = "team_choose1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(351.25, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 92, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "team1",
      res = "UI/alpha/1080P/toparena/toparena_team_defense_gs1.png",
      name = "bg_gs1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(133.75, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 702.5, h = 94},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_layer",
      res = "UI/alpha/1080P/toparena/toparena_team_defense_bg3_tf.png",
      name = "team3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(361, 89)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "team1",
      res = "UI/alpha/1080P/hero/hero_gs_2.png",
      name = "gs1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(93.75, 47)
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
      parent = "team1",
      text = T("1\233\152\159"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.75, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 48, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "team2",
      res = "UI/alpha/1080P/toparena/toparena_team_exchange2.png",
      name = "button_switch2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(646.25, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 48, h = 35.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "team2",
      res = "UI/alpha/1080P/toparena/toparena_team_exchange1.png",
      name = "button_switch_save2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(643.25, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 723.5, h = 115},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "team2",
      res = "UI/alpha/1080P/toparena/toparena_team_choose.png",
      name = "team_choose2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(351.25, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "team2",
      res = "UI/alpha/1080P/hero/hero_gs_2.png",
      name = "gs2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(93.25, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 92, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "team2",
      res = "UI/alpha/1080P/toparena/toparena_team_defense_gs2.png",
      name = "bg_gs2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(133.75, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 48, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "team3",
      res = "UI/alpha/1080P/toparena/toparena_team_exchange2.png",
      name = "button_switch3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(646.25, 47)
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
      parent = "team2",
      text = T("2\233\152\159"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.75, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 48, h = 35.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "team3",
      res = "UI/alpha/1080P/toparena/toparena_team_exchange1.png",
      name = "button_switch_save3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(643.25, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 723.5, h = 115},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "team3",
      res = "UI/alpha/1080P/toparena/toparena_team_choose.png",
      name = "team_choose3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(351.25, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "team3",
      res = "UI/alpha/1080P/hero/hero_gs_2.png",
      name = "gs3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96.25, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 92, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "team3",
      res = "UI/alpha/1080P/toparena/toparena_team_defense_gs3.png",
      name = "bg_gs3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(133.75, 47)
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
      parent = "team3",
      text = T("3\233\152\159"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.75, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 702.5, h = 94},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_layer",
      res = "UI/alpha/1080P/toparena/toparena_team_defense_bg4_tf.png",
      name = "team4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(361, -29)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 195.5, h = 4.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_layer",
      res = "UI/alpha/1080P/toparena/toparena_team_defense_dec.png",
      name = "ImageView_16957",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113.5, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 702.5, h = 94},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_layer",
      res = "UI/alpha/1080P/toparena/toparena_team_defense_bg5_tf.png",
      name = "team5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(361, -130.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 48, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "team4",
      res = "UI/alpha/1080P/toparena/toparena_team_exchange2.png",
      name = "button_switch4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(646.25, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 48, h = 35.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "team4",
      res = "UI/alpha/1080P/toparena/toparena_team_exchange1.png",
      name = "button_switch_save4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(643.25, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 723.5, h = 115},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "team4",
      res = "UI/alpha/1080P/toparena/toparena_team_choose.png",
      name = "team_choose4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(351.25, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "team4",
      res = "UI/alpha/1080P/hero/hero_gs_2.png",
      name = "gs4",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96.25, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 92, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "team4",
      res = "UI/alpha/1080P/toparena/toparena_team_defense_gs3.png",
      name = "bg_gs4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(133.75, 47)
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
      name = "label_team4",
      z = 0,
      parent = "team4",
      text = T("4\233\152\159"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.75, 47)
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
      name = "Label_16956",
      z = 0,
      parent = "ImageView_16957",
      text = T("\228\188\160\229\165\135\230\174\181\228\189\141\229\143\138\228\187\165\228\184\138\232\162\171\230\140\145\230\136\152\230\151\182\239\188\140\229\144\175\231\148\168\233\162\132\229\164\135\233\152\159\228\188\141"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(345.25, 2.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -195.5, h = 4.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_16957",
      res = "UI/alpha/1080P/toparena/toparena_team_defense_dec.png",
      name = "ImageView_16957_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(593.25, 2.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 48, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "team5",
      res = "UI/alpha/1080P/toparena/toparena_team_exchange2.png",
      name = "button_switch5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(646.25, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 48, h = 35.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "team5",
      res = "UI/alpha/1080P/toparena/toparena_team_exchange1.png",
      name = "button_switch_save5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(643.25, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 723.5, h = 115},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "team5",
      res = "UI/alpha/1080P/toparena/toparena_team_choose.png",
      name = "team_choose5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(351.25, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "team5",
      res = "UI/alpha/1080P/hero/hero_gs_2.png",
      name = "gs5",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96.25, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 92, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "team5",
      res = "UI/alpha/1080P/toparena/toparena_team_defense_gs3.png",
      name = "bg_gs5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(133.75, 47)
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
      name = "label_team5",
      z = 0,
      parent = "team5",
      text = T("5\233\152\159"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.75, 47)
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
      parent = "team4",
      res = "UI/alpha/1080P/toparena/toparena_prepare_bench_tag4.png",
      name = "ImageView_tag_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33.75, 85)
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
      parent = "team5",
      res = "UI/alpha/1080P/toparena/toparena_prepare_bench_tag5.png",
      name = "ImageView_tag_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33.75, 85)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 243, 134),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_tag_1",
      z = 0,
      parent = "ImageView_tag_1",
      text = T("\233\162\132\229\164\135"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35, 11)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 243, 134),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_tag_2",
      z = 0,
      parent = "ImageView_tag_2",
      text = T("\233\162\132\229\164\135"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35, 11)
    }
  }
}
