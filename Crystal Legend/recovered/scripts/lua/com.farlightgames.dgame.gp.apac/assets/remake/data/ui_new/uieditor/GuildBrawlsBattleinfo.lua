ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildBrawlsBattleinfo = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 804.5, h = 440.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/guild/guild_brawls_battleinfo/battleinfo_share_background.png",
      name = "ImageView_bj",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(477.5, 270)
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
      name = "Panel_title",
      z = 9
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(480, 445)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(400, 440)
    },
    t = "Layer",
    base = {name = "Panel_left", z = 3},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(75.5, 49.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 304, h = 486},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/guild/guild_brawls_battleinfo/battleinfo_thorns_left.png",
      name = "ImageView_302",
      z = 8
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(195, 264.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(400, 440)
    },
    t = "Layer",
    base = {
      name = "Panel_right",
      z = 3
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(480, 49.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 333, h = 486.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/guild/guild_brawls_battleinfo/battleinfo_thorns_right.png",
      name = "ImageView_3022",
      z = 8
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(786, 264.5)
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
      name = "Panel_bottom",
      z = 9
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(477, 96)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 440)
    },
    t = "Layer",
    base = {
      name = "Panel_buttons",
      z = 9
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(860, 49.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 352, h = 382.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/guild/guild_brawls_battleinfo/battleinfo_vs.png",
      name = "ImageView_VS",
      z = 99
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(482.5, 269.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 404, h = 140.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_title",
      res = "UI/alpha/1080P/guild/guild_brawls_battleinfo/battleinfo_title.png",
      name = "ImageView_294",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 37)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 228, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_title",
      res = "UI/alpha/1080P/guild/guild_brawls_battleinfo/battleinfo_info.png",
      name = "ImageView_295",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(3, 27)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35.5, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_title",
      res = "UI/alpha/1080P/guild/guild_brawls_battleinfo/battleinfo_info4.png",
      name = "ImageView_num",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 243, 171),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_time",
      z = 0,
      parent = "Panel_title",
      text = T("\231\187\147\230\157\159\229\128\146\232\174\161\230\151\182\239\188\15412\229\164\16923\229\176\143\230\151\182"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1.5, -13)
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
      name = "Label_warZone",
      z = 0,
      parent = "Panel_title",
      text = T("\231\142\139\232\128\133123\230\136\152\229\140\186"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-4, -38)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 361.5, h = 458},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_left",
      res = "UI/alpha/1080P/guild/guild_brawls_battleinfo/battleinfo_nature_background.png",
      name = "ImageView_301",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(191, 219)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 85.5, h = 37},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_left",
      res = "UI/alpha/1080P/guild/guild_brawls_battleinfo/battleinfo_flowerlight_off.png",
      name = "ImageView_303",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(136.5, 384)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 234, 146),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_win_left",
      z = 0,
      parent = "Panel_left",
      text = T("2\232\131\1560\232\180\159"),
      size = 36
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(159, 338)
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
      name = "Label_server_left",
      z = 0,
      parent = "Panel_left",
      text = T("250\230\156\141 \229\164\167\230\160\145\229\174\136\229\141\171"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(127, 150.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 343, h = 101},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_left",
      res = "UI/alpha/1080P/guild/guild_brawls_battleinfo/battleinfo_flag_left.png",
      name = "ImageView_306",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(179, 218)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 409, h = 436.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_right",
      res = "UI/alpha/1080P/guild/guild_brawls_battleinfo/battleinfo_dark_background.png",
      name = "ImageView_301",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(192.5, 203.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 79, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_right",
      res = "UI/alpha/1080P/guild/guild_brawls_battleinfo/battleinfo_mushroom_off.png",
      name = "ImageView_303",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(268.5, 391.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 234, 146),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_win_right",
      z = 0,
      parent = "Panel_right",
      text = T("2\232\131\1560\232\180\159"),
      size = 36
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(243, 338)
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
      name = "Label_server_right",
      z = 0,
      parent = "Panel_right",
      text = T("250\230\156\141 \229\164\167\230\160\145\229\174\136\229\141\171"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(250.5, 150.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 372.5, h = 101},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_right",
      res = "UI/alpha/1080P/guild/guild_brawls_battleinfo/battleinfo_flag_right.png",
      name = "ImageView_306",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(240.5, 218.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 111.5, h = 318},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_right",
      res = "UI/alpha/1080P/guild/guild_brawls_battleinfo/battleinfo_thorns_bottom.png",
      name = "ImageView_350",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(454, 242.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 650.5, h = 116.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_bottom",
      res = "UI/alpha/1080P/guild/guild_brawls_battleinfo/battleinfo_award_background.png",
      name = "ImageView_344",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
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
      name = "Label_345",
      z = 0,
      parent = "Panel_bottom",
      text = T("\232\131\156\229\136\169\229\165\150\229\138\177"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-122, 24)
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
      name = "Label_345_Copy0",
      z = 0,
      parent = "Panel_bottom",
      text = T("\229\164\177\232\180\165\229\165\150\229\138\177"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-122, -23.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(250, 50)
    },
    t = "Layer",
    base = {
      parent = "Panel_bottom",
      name = "Panel_item_fail",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-69.5, -51)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(250, 50)
    },
    t = "Layer",
    base = {
      parent = "Panel_bottom",
      name = "Panel_item_win",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-69.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66, h = 66},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_buttons",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "ImageView_btn_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(74, 315)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66, h = 66},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_buttons",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "ImageView_btn_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(74, 242)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66, h = 66},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_buttons",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "ImageView_btn_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(74, 169)
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
      name = "Label_guild_name_left",
      z = 0,
      parent = "ImageView_306",
      text = T("\229\133\172\228\188\154\229\144\141\229\173\151\228\184\131\228\184\170\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119, 76.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(205, 255, 181),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_309",
      z = 0,
      parent = "ImageView_306",
      text = T("\230\136\144\229\145\152:"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73, 50.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(205, 255, 181),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_309_Copy0",
      z = 0,
      parent = "ImageView_306",
      text = T("\229\155\162\233\149\191:"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73, 27.5)
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
      name = "Label_team_num_left",
      z = 0,
      parent = "ImageView_306",
      text = T("30\229\144\141"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(95, 50.5)
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
      name = "Label_leader_left",
      z = 0,
      parent = "ImageView_306",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\228\184\131\228\184\170\229\173\151"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(95.5, 27.5)
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
      name = "Label_guild_name_right",
      z = 0,
      parent = "ImageView_306",
      text = T("\229\133\172\228\188\154\229\144\141\229\173\151\228\184\131\228\184\170\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(194.75, 76.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(205, 255, 181),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_309",
      z = 0,
      parent = "ImageView_306",
      text = T("\230\136\144\229\145\152:"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(149.25, 50.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(205, 255, 181),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_309_Copy0",
      z = 0,
      parent = "ImageView_306",
      text = T("\229\155\162\233\149\191:"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(149.25, 27.5)
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
      name = "Label_team_num_right",
      z = 0,
      parent = "ImageView_306",
      text = T("30\229\144\141"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(171.25, 50.5)
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
      name = "Label_leader_right",
      z = 0,
      parent = "ImageView_306",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\228\184\131\228\184\170\229\173\151"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(171.75, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 46, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_btn_1",
      res = "UI/alpha/1080P/pvp/record.png",
      name = "ImageView_352",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 33)
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
      name = "Label_353",
      z = 0,
      parent = "ImageView_btn_1",
      text = T("\231\142\169\230\179\149"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33.5, 9.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 46.5, h = 51.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_btn_2",
      res = "UI/alpha/1080P/toparena/toparena_report_icon.png",
      name = "ImageView_352",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 33)
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
      name = "Label_353",
      z = 0,
      parent = "ImageView_btn_2",
      text = T("\230\136\152\230\138\165"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33.5, 9.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 60, h = 60},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_btn_3",
      res = "UI/alpha/1080P/battle/battle_prepare_hot_1.png",
      name = "ImageView_352",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33.5, 35)
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
      name = "Label_353",
      z = 0,
      parent = "ImageView_btn_3",
      text = T("\232\181\155\231\168\139"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33.5, 9.5)
    }
  }
}
