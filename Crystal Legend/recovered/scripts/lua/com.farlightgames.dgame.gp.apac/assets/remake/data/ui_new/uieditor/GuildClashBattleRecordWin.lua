ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildClashBattleRecordWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 653, h = 452},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/guild/guild_clash_report/clashreport_background.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 274)
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
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(645.5, 437.5)
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
      fix_wh = {w = 111.5, h = 47.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/tab_selected.png",
      name = "tab1_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(709.5, 280)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 105, h = 47.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/tab_unselected.png",
      name = "tab1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(704.5, 280)
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
      name = "label_tab1_selected",
      z = 0,
      parent = "tab1_selected",
      text = T("\233\152\159\228\188\141\228\191\161\230\129\175"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44.75, 24.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 105, h = 47.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/tab_unselected.png",
      name = "tab2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(704, 155.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 111.5, h = 47.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/tab_selected.png",
      name = "tab2_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(709, 155.5)
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
      name = "label_tab1",
      z = 0,
      parent = "tab1",
      text = T("\233\152\159\228\188\141\228\191\161\230\129\175"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46, 24.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 105, h = 47.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/tab_unselected.png",
      name = "tab3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(704, 94)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 111.5, h = 47.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/tab_selected.png",
      name = "tab3_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(709, 94)
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
      name = "label_tab2",
      z = 0,
      parent = "tab2",
      text = T("\231\165\158\231\172\166\231\172\1721\230\151\165"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 24.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 105, h = 47.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/tab_unselected.png",
      name = "tab4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(703, 32.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 111.5, h = 47.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/tab_selected.png",
      name = "tab4_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(708, 32.5)
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
      name = "label_tab2_selected",
      z = 0,
      parent = "tab2_selected",
      text = T("\231\165\158\231\172\166\231\172\1721\230\151\165"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.25, 24.25)
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
      name = "layer1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-0.5, -0.5)
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
      name = "layer2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-0.5, -0.5)
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
      name = "label_tab3",
      z = 0,
      parent = "tab3",
      text = T("\231\165\158\231\172\166\231\172\1722\230\151\165"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 24.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 699, h = 60.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_report/clashreport_unstart.png",
      name = "bg_tip",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(326.5, 226)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 105, h = 47.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/tab_unselected.png",
      name = "tab0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(704, 341)
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
      name = "label_tab3_selected",
      z = 0,
      parent = "tab3_selected",
      text = T("\231\165\158\231\172\166\231\172\1722\230\151\165"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.25, 24.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 111.5, h = 47.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/tab_selected.png",
      name = "tab0_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(709, 341)
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
      name = "layer0",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-0.5, -0.5)
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
      name = "label_tab4",
      z = 0,
      parent = "tab4",
      text = T("\231\165\158\231\172\166\231\172\1723\230\151\165"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 24.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 111.5, h = 47.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/tab_selected.png",
      name = "tab5_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(707.5, 217)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 105, h = 47.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/tab_unselected.png",
      name = "tab5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(702.5, 217)
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
      name = "label_tab4_selected",
      z = 0,
      parent = "tab4_selected",
      text = T("\231\165\158\231\172\166\231\172\1723\230\151\165"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.25, 24.25)
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
      parent = "bg",
      name = "layer3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-0.5, -0.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58.5, h = 69.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer1",
      res = "UI/alpha/1080P/guild/guild_clash_report/bot_botroad_unselected.png",
      name = "btn_line3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(431.5, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 650, h = 29.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer1",
      res = "UI/alpha/1080P/guild/guild_clash_report/clashreport_roletitlefloor.png",
      name = "bg_floor",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(327, 383.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58.5, h = 69.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer1",
      res = "UI/alpha/1080P/guild/guild_clash_report/bot_midroad_unselected.png",
      name = "btn_line2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(327, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58.5, h = 69.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer1",
      res = "UI/alpha/1080P/guild/guild_clash_report/bot_toproad_unselected.png",
      name = "btn_line1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(223.5, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(646, 299)
    },
    t = "Layer",
    base = {
      parent = "layer1",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(4.5, 68.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 221, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_559",
      z = 0,
      parent = "layer2",
      text = T("\229\133\172\228\188\154\230\136\152\230\138\165"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(327, 422.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 278.5, h = 94},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer1",
      res = "UI/alpha/1080P/guild/guild_clash_report/report_win_floor.png",
      name = "layer1_win",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(326.5, 441.5)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "Label_560",
      z = 0,
      parent = "layer2",
      text = T("\230\136\152\230\150\151\231\187\147\230\158\156\229\166\130\228\184\139\239\188\154"),
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(326.5, 379)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 258.5, h = 85.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer1",
      res = "UI/alpha/1080P/guild/guild_clash_report/report_lose_floor.png",
      name = "layer1_lose",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(331.5, 429.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 646.5, h = 71},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer2",
      res = "UI/alpha/1080P/guild/guild_clash_report/clashreport_table_win.png",
      name = "power1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(327, 325)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 646.5, h = 71},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer2",
      res = "UI/alpha/1080P/guild/guild_clash_report/clashreport_table_win.png",
      name = "power2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(327.5, 253.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 646.5, h = 71},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer2",
      res = "UI/alpha/1080P/guild/guild_clash_report/clashreport_table_win.png",
      name = "power3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(326, 182)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(157, 146, 142),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "tip",
      z = 0,
      parent = "bg_tip",
      text = T("\230\154\130\230\151\160\230\175\148\232\181\155\230\149\176\230\141\174"),
      size = 26
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(349.5, 30.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 646.5, h = 71},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer2",
      res = "UI/alpha/1080P/guild/guild_clash_report/clashreport_table_win.png",
      name = "power4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(327, 110.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 221, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "tip_title",
      z = 0,
      parent = "bg_tip",
      text = T("\230\175\148\232\181\155\230\136\152\230\138\165"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(349.5, 225.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 646.5, h = 71},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer2",
      res = "UI/alpha/1080P/guild/guild_clash_report/clashreport_table_win.png",
      name = "power5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(326, 39)
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
      name = "label_tab0",
      z = 0,
      parent = "tab0",
      text = T("\230\175\148\232\181\155\230\136\152\230\138\165"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46, 24.25)
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
      name = "label_tab0_selected",
      z = 0,
      parent = "tab0_selected",
      text = T("\230\175\148\232\181\155\230\136\152\230\138\165"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44.75, 24.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58.5, h = 69.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_line3",
      res = "UI/alpha/1080P/guild/guild_clash_report/bot_botroad_selected.png",
      name = "btn_line3_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(29.25, 34.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 278.5, h = 94},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer0",
      res = "UI/alpha/1080P/guild/guild_clash_report/report_win_floor.png",
      name = "layer0_win",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(327, 442)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 183, 137),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "name",
      z = 0,
      parent = "bg_floor",
      text = T("\231\142\169\229\174\182\229\144\141\231\167\176"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.5, 15.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 183, 137),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "kill",
      z = 0,
      parent = "bg_floor",
      text = T("\229\135\187\230\157\128\233\152\159\228\188\141"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(351.5, 15.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 258.5, h = 85.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer0",
      res = "UI/alpha/1080P/guild/guild_clash_report/report_lose_floor.png",
      name = "layer0_lose",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(332, 430)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 183, 137),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "survive",
      z = 0,
      parent = "bg_floor",
      text = T("\229\173\152\230\180\187\233\152\159\228\188\141"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(510, 15.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19, h = 17.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_floor",
      res = "UI/alpha/1080P/guild/guild_clash_report/icon_kill.png",
      name = "ImageView_533",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(313.5, 14.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 646.5, h = 104.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer0",
      res = "UI/alpha/1080P/guild/guild_clash_report/battleinfo_lose.png",
      name = "layer0_line1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(327, 343)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 16.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_floor",
      res = "UI/alpha/1080P/guild/guild_clash_report/icon_survival.png",
      name = "ImageView_534",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(474, 14.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58.5, h = 69.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_line2",
      res = "UI/alpha/1080P/guild/guild_clash_report/bot_midroad_selected.png",
      name = "btn_line2_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(29.25, 34.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 646.5, h = 104.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer0",
      res = "UI/alpha/1080P/guild/guild_clash_report/battleinfo_lose.png",
      name = "layer0_line2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(327, 237)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 646.5, h = 104.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer0",
      res = "UI/alpha/1080P/guild/guild_clash_report/battleinfo_lose.png",
      name = "layer0_line3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(327, 131)
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
      name = "label_tab5_selected",
      z = 0,
      parent = "tab5_selected",
      text = T("\229\136\134\232\183\175\230\136\152\229\134\181"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.25, 24.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58.5, h = 69.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_line1",
      res = "UI/alpha/1080P/guild/guild_clash_report/bot_toproad_selected.png",
      name = "btn_line1_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(29.25, 34.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 0.93},
      flip = "",
      opacity = 255,
      fix_wh = {w = 650.07, h = 76},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer0",
      res = "UI/alpha/1080P/guild/guild_clash_report/table_bottom.png",
      name = "ImageView_3323",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(327, 40.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 183, 137),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_3324",
      z = 0,
      parent = "layer0",
      text = T("\230\156\172\232\189\174\229\165\150\229\138\177\229\183\178\233\128\154\232\191\135\233\130\174\228\187\182\229\143\145\230\148\190"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(327, 43.5)
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
      name = "label_tab5",
      z = 0,
      parent = "tab5",
      text = T("\229\136\134\232\183\175\230\136\152\229\134\181"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 24.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 111, h = 37},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer1_win",
      res = "UI/alpha/1080P/guild/guild_clash_report/report_win.png",
      name = "ImageView_3317",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(139.25, 27.5)
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
      parent = "power1",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_lose1.png",
      name = "result_power1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36.75, 35.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 63.99999616, h = 63.99999616},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "power1",
      res = "UI/alpha/1080P/guild/avatar_frame/guild_avatar_frame_normal.png",
      name = "icon_power1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108.75, 35.5)
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
      name = "name_power1",
      z = 0,
      parent = "power1",
      text = T("\229\138\155\233\135\143\231\165\158\231\172\166"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(253.25, 53)
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
      name = "info_power1",
      z = 0,
      parent = "power1",
      text = T("\230\136\145\230\150\185\230\138\149\231\172\166\230\136\144\229\138\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(253.25, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 104, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer1_lose",
      res = "UI/alpha/1080P/guild/guild_clash_report/report_lose.png",
      name = "ImageView_33171",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(124.25, 33.75)
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
      parent = "power2",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_lose1.png",
      name = "result_power2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36.75, 35.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 63.99999616, h = 63.99999616},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "power2",
      res = "UI/alpha/1080P/guild/avatar_frame/guild_avatar_frame_normal.png",
      name = "icon_power2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108.75, 35.5)
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
      name = "name_power2",
      z = 0,
      parent = "power2",
      text = T("\229\138\155\233\135\143\231\165\158\231\172\166"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(253.25, 53)
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
      name = "info_power2",
      z = 0,
      parent = "power2",
      text = T("\230\136\145\230\150\185\230\138\149\231\172\166\230\136\144\229\138\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(253.25, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58.5, h = 69.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer3",
      res = "UI/alpha/1080P/guild/guild_clash_report/bot_toproad_unselected.png",
      name = "layer3_btn_line1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(223.5, 28.5)
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
      parent = "power3",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_lose1.png",
      name = "result_power3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36.75, 35.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 63.99999616, h = 63.99999616},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "power3",
      res = "UI/alpha/1080P/guild/avatar_frame/guild_avatar_frame_normal.png",
      name = "icon_power3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108.75, 35.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(646, 242)
    },
    t = "Layer",
    base = {
      parent = "layer3",
      name = "layer3_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(4.5, 68)
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
      name = "name_power3",
      z = 0,
      parent = "power3",
      text = T("\229\138\155\233\135\143\231\165\158\231\172\166"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(253.25, 53)
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
      name = "info_power3",
      z = 0,
      parent = "power3",
      text = T("\230\136\145\230\150\185\230\138\149\231\172\166\230\136\144\229\138\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(253.25, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58.5, h = 69.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer3",
      res = "UI/alpha/1080P/guild/guild_clash_report/bot_midroad_unselected.png",
      name = "layer3_btn_line2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(327, 28.5)
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
      parent = "power4",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_lose1.png",
      name = "result_power4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36.75, 35.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 63.99999616, h = 63.99999616},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "power4",
      res = "UI/alpha/1080P/guild/avatar_frame/guild_avatar_frame_normal.png",
      name = "icon_power4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108.75, 35.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58.5, h = 69.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer3",
      res = "UI/alpha/1080P/guild/guild_clash_report/bot_botroad_unselected.png",
      name = "layer3_btn_line3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(431.5, 28.5)
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
      name = "name_power4",
      z = 0,
      parent = "power4",
      text = T("\229\138\155\233\135\143\231\165\158\231\172\166"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(253.25, 53)
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
      name = "info_power4",
      z = 0,
      parent = "power4",
      text = T("\230\136\145\230\150\185\230\138\149\231\172\166\230\136\144\229\138\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(253.25, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(650, 95)
    },
    t = "Layer",
    base = {
      parent = "layer3",
      name = "Panel_2189",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(2.5, 310.5)
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
      parent = "power5",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_lose1.png",
      name = "result_power5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36.75, 35.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 63.99999616, h = 63.99999616},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "power5",
      res = "UI/alpha/1080P/guild/avatar_frame/guild_avatar_frame_normal.png",
      name = "icon_power5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108.75, 35.5)
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
      name = "name_power5",
      z = 0,
      parent = "power5",
      text = T("\229\138\155\233\135\143\231\165\158\231\172\166"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(253.25, 53)
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
      name = "info_power5",
      z = 0,
      parent = "power5",
      text = T("\230\136\145\230\150\185\230\138\149\231\172\166\230\136\144\229\138\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(253.25, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 111, h = 37},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer0_win",
      res = "UI/alpha/1080P/guild/guild_clash_report/report_win.png",
      name = "ImageView_3317",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(139.25, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 104, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer0_lose",
      res = "UI/alpha/1080P/guild/guild_clash_report/report_lose.png",
      name = "ImageView_33171",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(124.25, 33.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(231, 192, 117),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "layer0_line1_name",
      z = 0,
      parent = "layer0_line1",
      text = T("\228\184\138\232\183\175"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49.25, 52.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47.5, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer0_line1",
      res = "UI/alpha/1080P/guild/guild_clash_report/art_lose.png",
      name = "layer0_line1_result",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(212.25, 52.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 44.5, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer0_line1",
      res = "UI/alpha/1080P/guild/guild_clash_report/art_vs.png",
      name = "layer0_line1_vs",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.25, 52.25)
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
      name = "layer0_line1_self",
      z = 0,
      parent = "layer0_line1",
      text = T("\230\136\145\230\150\185\239\188\15450\233\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(338.75, 52.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 102, 88),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "layer0_line1_oppo",
      z = 0,
      parent = "layer0_line1",
      text = T("\230\136\145\230\150\185\239\188\15450\233\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(523.25, 52.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(231, 192, 117),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "layer0_line2_name",
      z = 0,
      parent = "layer0_line2",
      text = T("\228\184\173\232\183\175"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49.25, 52.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15.89999735, h = 15.89999735},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer0_line1",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_why1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(231.75, 62.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47.5, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer0_line2",
      res = "UI/alpha/1080P/guild/guild_clash_report/art_lose.png",
      name = "layer0_line2_result",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(212.25, 52.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 44.5, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer0_line2",
      res = "UI/alpha/1080P/guild/guild_clash_report/art_vs.png",
      name = "layer0_line2_vs",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.25, 52.25)
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
      name = "layer0_line2_self",
      z = 0,
      parent = "layer0_line2",
      text = T("\230\136\145\230\150\185\239\188\15450\233\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(338.75, 52.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 102, 88),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "layer0_line2_oppo",
      z = 0,
      parent = "layer0_line2",
      text = T("\230\136\145\230\150\185\239\188\15450\233\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(523.25, 52.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(231, 192, 117),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "layer0_line3_name",
      z = 0,
      parent = "layer0_line3",
      text = T("\228\184\139\232\183\175"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49.25, 52.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15.89999735, h = 15.89999735},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer0_line2",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_why2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(231.75, 62.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47.5, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer0_line3",
      res = "UI/alpha/1080P/guild/guild_clash_report/art_lose.png",
      name = "layer0_line3_result",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(212.25, 52.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 44.5, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer0_line3",
      res = "UI/alpha/1080P/guild/guild_clash_report/art_vs.png",
      name = "layer0_line3_vs",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.25, 52.25)
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
      name = "layer0_line3_self",
      z = 0,
      parent = "layer0_line3",
      text = T("\230\136\145\230\150\185\239\188\15450\233\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(338.75, 52.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 102, 88),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "layer0_line3_oppo",
      z = 0,
      parent = "layer0_line3",
      text = T("\230\136\145\230\150\185\239\188\15450\233\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(523.25, 52.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15.89999735, h = 15.89999735},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer0_line3",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_why3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(231.75, 62.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58.5, h = 69.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer3_btn_line1",
      res = "UI/alpha/1080P/guild/guild_clash_report/bot_toproad_selected.png",
      name = "layer3_btn_line1_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(29.25, 34.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58.5, h = 69.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer3_btn_line2",
      res = "UI/alpha/1080P/guild/guild_clash_report/bot_midroad_selected.png",
      name = "layer3_btn_line2_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(29.25, 34.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58.5, h = 69.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer3_btn_line3",
      res = "UI/alpha/1080P/guild/guild_clash_report/bot_botroad_selected.png",
      name = "layer3_btn_line3_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(29.25, 34.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.93, x = 0.93},
      flip = "",
      opacity = 255,
      fix_wh = {w = 326.43, h = 89.28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_2189",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/nature_guildfloor.png",
      name = "left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(162.5, 48.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.93, x = 0.93},
      flip = "",
      opacity = 255,
      fix_wh = {w = 328.29, h = 85.56},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_2189",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/dark_guildfloor.png",
      name = "right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(487.5, 46)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 188, h = 114},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_2189",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/icon_vs.png",
      name = "icon_vs",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(327.5, 50)
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
      parent = "btn_why1",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "icon_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.25, 13.75)
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
      parent = "btn_why2",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "icon_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.25, 13.75)
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
      parent = "btn_why3",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "icon_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.25, 13.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(182, 230, 192),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "camp1",
      z = 0,
      parent = "left",
      text = T("\230\136\145\230\150\185"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.5, 48)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 72, h = 72},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "left",
      res = "UI/alpha/1080P/guild/avatar_frame/guild_avatar_frame_normal.png",
      name = "avatar_camp1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(264.5, 46.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 228, 123),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "camp1_teams",
      z = 0,
      parent = "left",
      text = T("\229\137\169\228\189\153\233\152\159\228\188\141:185/240"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(225.5, 35.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 196, 188),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "name_camp1",
      z = 0,
      parent = "left",
      text = T("\229\133\172\228\188\154\229\144\141\229\133\173\228\184\170\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(225.5, 56)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 196, 188),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "camp2",
      z = 0,
      parent = "right",
      text = T("\230\149\140\230\150\185"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(313, 48.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 72, h = 72},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "right",
      res = "UI/alpha/1080P/guild/avatar_frame/guild_avatar_frame_normal.png",
      name = "avatar_camp2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(86, 47)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 228, 123),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "camp2_teams",
      z = 0,
      parent = "right",
      text = T("\229\137\169\228\189\153\233\152\159\228\188\141:185/240"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(128, 36.5)
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
      name = "name_camp2",
      z = 0,
      parent = "right",
      text = T("\229\133\172\228\188\154\229\144\141\229\133\173\228\184\170\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(128, 57)
    }
  }
}
