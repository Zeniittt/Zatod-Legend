ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildClashChairSetTeam = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(917.5, 502.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(16.5, 16.5, 16.5, 16.5),
      res = "UI/alpha/1080P/common/com_new_3.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(18.5, 13.5)
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
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(916.5, 490)
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
      name = "ImageView_102",
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
      fix_wh = {w = 301.5, h = 511.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_headmodify/modify_teamdoor.png",
      name = "bg_line_top",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(151.5, 256.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 301.5, h = 511.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_headmodify/modify_teamdoor.png",
      name = "bg_line_mid",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(459, 256.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(300, 373)
    },
    t = "Layer",
    base = {
      parent = "bg_line_top",
      name = "layer_item_top",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0.75, 88.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34.5, h = 32},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_line_top",
      res = "UI/alpha/1080P/guild/guild_clash_deploy/operate_toproad.png",
      name = "icon_top",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82.75, 481.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 301.5, h = 511.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_headmodify/modify_teamdoor.png",
      name = "bg_line_bottom",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(765.5, 256.5)
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
      name = "name_top",
      z = 0,
      parent = "bg_line_top",
      text = T("\228\184\138\232\183\175"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(143.25, 481.25)
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
      name = "team_num_top",
      z = 0,
      parent = "bg_line_top",
      text = T("123\233\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(221.25, 480.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_btn",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(163, 148, 140),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "label_none_top",
      z = 0,
      parent = "bg_line_top",
      text = T("\230\154\130\230\151\160\233\152\159\228\188\141"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(159.75, 298.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(300, 373)
    },
    t = "Layer",
    base = {
      parent = "bg_line_mid",
      name = "layer_item_mid",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0.75, 88.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34.5, h = 32},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_line_mid",
      res = "UI/alpha/1080P/guild/guild_clash_deploy/operate_midroad.png",
      name = "icon_mid",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82.75, 481.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 914.5, h = 88.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_headmodify/modify_bottomdoor.png",
      name = "ImageView_1482",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(460.5, 43.5)
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
      name = "name_mid",
      z = 0,
      parent = "bg_line_mid",
      text = T("\228\184\173\232\183\175"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(143.25, 481.25)
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
      name = "team_num_mid",
      z = 0,
      parent = "bg_line_mid",
      text = T("123\233\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(221.25, 480.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(163, 148, 140),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "label_none_mid",
      z = 0,
      parent = "bg_line_mid",
      text = T("\230\154\130\230\151\160\233\152\159\228\188\141"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(159.75, 298.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(300, 373)
    },
    t = "Layer",
    base = {
      parent = "bg_line_bottom",
      name = "layer_item_bottom",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0.75, 88.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34.5, h = 32},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_line_bottom",
      res = "UI/alpha/1080P/guild/guild_clash_deploy/operate_botroad.png",
      name = "icon_bottom",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82.75, 481.25)
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
      name = "name_bottom",
      z = 0,
      parent = "bg_line_bottom",
      text = T("\228\184\139\232\183\175"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(143.25, 481.25)
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
      name = "team_num_bottom",
      z = 0,
      parent = "bg_line_bottom",
      text = T("123\233\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(221.25, 481.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(163, 148, 140),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "label_none_bottom",
      z = 0,
      parent = "bg_line_bottom",
      text = T("\230\154\130\230\151\160\233\152\159\228\188\141"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(159.75, 298.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/guild/guild_clash_headmodify/modify_exchange.png",
      name = "btn_top_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(279.5, 480.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 33, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/guild/guild_clash_headmodify/modify_exchange.png",
      name = "btn_bottom_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(647.5, 480.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/guild/guild_clash_headmodify/modify_exchange.png",
      name = "btn_mid_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(586.5, 480.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 33, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/guild/guild_clash_headmodify/modify_exchange.png",
      name = "btn_mid_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(334, 480.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 302.5, h = 58},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/guild/guild_clash_headmodify/modify_buttonfloor.png",
      name = "bg_btn_top",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(151.5, 60)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "ImageView_1482",
      name = "layer_tip",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(457.25, 44.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 302.5, h = 58},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/guild/guild_clash_headmodify/modify_buttonfloor.png",
      name = "bg_btn_mid",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(459, 60)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 124.5, h = 50.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "ImageView_1482",
      res = "UI/alpha/1080P/common/button_com_big.png",
      name = "btn_op",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(457.25, 55.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 302.5, h = 58},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/guild/guild_clash_headmodify/modify_buttonfloor.png",
      name = "bg_btn_bottom",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(765.5, 60)
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
      name = "label_optime1",
      z = 0,
      parent = "layer_btn",
      text = T("\232\176\131\230\149\180\229\128\146\232\174\161\230\151\182\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(459, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 216, 29),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_optime2",
      z = 0,
      parent = "layer_btn",
      text = T("29\229\136\13459\231\167\146"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(459, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 87.99999472, h = 87.99999472},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_tip",
      res = "UI/alpha/1080P/mainhead/main_head_frame_silver.png",
      name = "opHead",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-112.5, 0)
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
      name = "opName",
      z = 0,
      parent = "layer_tip",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\228\184\131\228\184\170\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-63, 15)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 216, 29),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tip",
      z = 0,
      parent = "layer_tip",
      text = T("\230\173\163\229\156\168\232\176\131\230\149\180\228\184\173(\229\137\169\228\189\15325\229\136\13420\231\167\146)"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-63, -13.5)
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
      parent = "bg_btn_top",
      res = "UI/alpha/1080P/common/button_com_big.png",
      name = "btn_add_top",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(151.25, 22.5)
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
      name = "label_op",
      z = 0,
      parent = "btn_op",
      text = T("\229\188\128\229\167\139\232\176\131\230\149\180"),
      size = 23
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
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_85",
      z = 0,
      parent = "btn_op",
      text = T("\229\141\149\230\172\161\232\176\131\230\149\180\228\184\138\233\153\144\230\151\182\233\151\180\229\156\16830\229\136\134\233\146\159\239\188\140\232\182\133\232\191\135\228\188\154\232\135\170\229\138\168\229\133\179\233\151\173\231\149\140\233\157\162"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.25, -11.75)
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
      parent = "bg_btn_mid",
      res = "UI/alpha/1080P/common/button_com_big.png",
      name = "btn_add_mid",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(151.25, 22.5)
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
      parent = "bg_btn_bottom",
      res = "UI/alpha/1080P/common/button_com_big.png",
      name = "btn_add_bottom",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(151.25, 22.5)
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
      parent = "btn_add_top",
      res = "UI/alpha/1080P/toparena/toparena_team_invisible_choose.png",
      name = "btn_add_top_selected",
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
      name = "label_add_top",
      z = 0,
      parent = "btn_add_top",
      text = T("\231\167\187\229\133\165\233\152\159\228\188\141"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.25, 25.25)
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
      parent = "btn_add_mid",
      res = "UI/alpha/1080P/toparena/toparena_team_invisible_choose.png",
      name = "btn_add_mid_selected",
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
      name = "label_add_mid",
      z = 0,
      parent = "btn_add_mid",
      text = T("\231\167\187\229\133\165\233\152\159\228\188\141"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.25, 25.25)
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
      parent = "btn_add_bottom",
      res = "UI/alpha/1080P/toparena/toparena_team_invisible_choose.png",
      name = "btn_add_bottom_selected",
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
      name = "label_add_bottom",
      z = 0,
      parent = "btn_add_bottom",
      text = T("\231\167\187\229\133\165\233\152\159\228\188\141"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.25, 25.25)
    }
  }
}
