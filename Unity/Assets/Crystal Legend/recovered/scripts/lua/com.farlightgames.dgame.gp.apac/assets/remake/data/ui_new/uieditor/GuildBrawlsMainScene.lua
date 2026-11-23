ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildBrawlsMainScene = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/guild/guild_brawls/brawls_background.jpg",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 270)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 248.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crusade/bg_title_crusade.png",
      name = "bg_title",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(186.5, 596)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 332, h = 78},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_brawls/bench_floor.png",
      name = "bg_step_info",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(475, 588)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 212, h = 107.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_brawls/nature_notice_floor.png",
      name = "bg_guild_notice",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(142, 517)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 206, h = 61.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_brawls/nature_guildname_floor.png",
      name = "bg_self_guild",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(185.5, 136.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 209, h = 65},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_brawls/dark_guildname_floor.png",
      name = "bg_oppo_guild",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(934, 499)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 144.5, h = 144},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_brawls/nature_base.png",
      name = "self_main",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(205, 214)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 95.5, h = 98},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_brawls/nature_tower.png",
      name = "self_tower_down",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(489, 192)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 95.5, h = 98},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_brawls/nature_tower.png",
      name = "self_tower_mid",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(346.5, 281.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 95.5, h = 98},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_brawls/nature_tower.png",
      name = "self_tower_up",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(209, 394)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 71, h = 89.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_brawls/dark_tower.png",
      name = "oppo_tower_down",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(942, 370)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 71, h = 89.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_brawls/dark_tower.png",
      name = "oppo_tower_mid",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(777, 464.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 71, h = 89.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_brawls/dark_tower.png",
      name = "oppo_tower_up",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(658.5, 540)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 169.5, h = 152},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_brawls/dark_base.png",
      name = "oppo_main",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(943, 538)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(164, 50.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_set_defend",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_big.png",
      capInsets = CCRectMake(41.5, 16.5, 41.5, 17)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(792.5, 143.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(164, 50.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_set_team",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_big.png",
      capInsets = CCRectMake(41.5, 16.5, 41.5, 17)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(964.5, 143)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_title",
      res = "UI/alpha/1080P/toparena/toparena_title.png",
      name = "title",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(24.75, 19.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 76.5, h = 74.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_step_info",
      res = "UI/alpha/1080P/guild/guild_brawls/brawls_details.png",
      name = "icon_stepinfo",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44, 50)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(158, 152, 151),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_stepname",
      z = 0,
      parent = "bg_step_info",
      text = T("\230\175\148\232\181\155\233\152\182\230\174\181"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(141.5, 55)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(158, 152, 151),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_steptime",
      z = 0,
      parent = "bg_step_info",
      text = T("\230\175\148\232\181\155\233\152\182\230\174\181"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(242.5, 55)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_steptime1",
      z = 0,
      parent = "bg_step_info",
      text = T("6\229\164\1693\229\176\143\230\151\182\229\144\142\231\187\147\230\157\159"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(242.5, 34.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_stepname1",
      z = 0,
      parent = "bg_step_info",
      text = T("\229\135\134\229\164\135\228\184\173"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(141.5, 34.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(230, 224, 124),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_notice_title",
      z = 0,
      parent = "bg_guild_notice",
      text = T("\230\136\152\229\156\186\229\143\183\228\185\166"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106, 92.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 108.5, h = 18.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_guild_notice",
      res = "UI/alpha/1080P/guild/guild_brawls/nature_notice_write.png",
      name = "btn_edit_notice",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106, 51.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(187, 217, 168),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_notice",
      z = 0,
      parent = "bg_guild_notice",
      text = T("\228\188\154\233\149\191\229\190\136\230\135\146\239\188\140\228\187\128\228\185\136\233\131\189\230\178\161\231\149\153\228\184\139"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(106, 68.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 230.5, h = 153},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_self_guild",
      res = "UI/alpha/1080P/guild/guild_brawls/nature_guild_popup.png",
      name = "bg_self_guild_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(116.5, 132.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47.999992, h = 47.999992},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_self_guild",
      res = "UI/alpha/1080P/guild/avatar_frame/guild_avatar_frame_lightning.png",
      name = "icon_self_guild",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38, 33.75)
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
      name = "name_self_guild",
      z = 0,
      parent = "bg_self_guild",
      text = T("\230\151\160\230\149\140\229\133\172\228\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(126, 32.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47.999992, h = 47.999992},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_oppo_guild",
      res = "UI/alpha/1080P/guild/avatar_frame/guild_avatar_frame_lightning.png",
      name = "icon_oppo_guild",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.5, 35.5)
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
      name = "name_oppo_guild",
      z = 0,
      parent = "bg_oppo_guild",
      text = T("\230\151\160\230\149\140\229\133\172\228\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(127.5, 34.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 230.5, h = 153},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_oppo_guild",
      res = "UI/alpha/1080P/guild/guild_brawls/dark_guild_popup.png",
      name = "bg_oppo_guild_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(110.5, -71.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 77, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "self_tower_down",
      res = "UI/alpha/1080P/guild/guild_brawls/nature_tower_floor.png",
      name = "self_bg_tower_down",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 77, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "self_tower_mid",
      res = "UI/alpha/1080P/guild/guild_brawls/nature_tower_floor.png",
      name = "self_bg_tower_mid",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 77, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "self_tower_up",
      res = "UI/alpha/1080P/guild/guild_brawls/nature_tower_floor.png",
      name = "self_bg_tower_up",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 77, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "oppo_tower_down",
      res = "UI/alpha/1080P/guild/guild_brawls/nature_tower_floor.png",
      name = "oppo_bg_tower_down",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 8.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 77, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "oppo_tower_mid",
      res = "UI/alpha/1080P/guild/guild_brawls/nature_tower_floor.png",
      name = "oppo_bg_tower_mid",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 8.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 77, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "oppo_tower_up",
      res = "UI/alpha/1080P/guild/guild_brawls/nature_tower_floor.png",
      name = "oppo_bg_tower_up",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 8.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 206, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_6141",
      z = 0,
      parent = "btn_set_defend",
      text = T("\232\176\131\230\149\180\229\184\131\233\152\178"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(99.5, 26.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 44, h = 44.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_set_defend",
      res = "UI/alpha/1080P/hero/icon_skinnew.png",
      name = "ImageView_6151",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.5, 26.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 206, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_614",
      z = 0,
      parent = "btn_set_team",
      text = T("\231\188\150\233\152\159"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(99.5, 26.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 44, h = 44.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_set_team",
      res = "UI/alpha/1080P/hero/icon_skinnew.png",
      name = "ImageView_615",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.5, 26.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.5, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "title",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(181.5, 18.75)
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
      name = "Label_555",
      z = 0,
      parent = "icon_stepinfo",
      text = T("\230\175\148\232\181\155\232\175\166\230\131\133"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.25, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(187, 217, 168),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_564",
      z = 0,
      parent = "btn_edit_notice",
      text = T("\231\130\185\229\135\187\231\188\150\232\190\145\229\143\183\228\185\166"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.75, 9.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 55.999992, h = 55.999992},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_self_guild_detail",
      res = "UI/alpha/1080P/guild/avatar_frame/guild_avatar_frame_lightning.png",
      name = "icon_self_guild1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49.75, 116.5)
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
      name = "name_self_guild1",
      z = 0,
      parent = "bg_self_guild_detail",
      text = T("\230\151\160\230\149\140\229\133\172\228\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(81.25, 126.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(187, 217, 168),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "self_guild_server",
      z = 0,
      parent = "bg_self_guild_detail",
      text = T("317\230\156\141 \228\184\150\231\149\140\229\143\164\230\160\145"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(78.75, 102)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(187, 217, 168),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "self_guild_chair",
      z = 0,
      parent = "bg_self_guild_detail",
      text = T("\228\188\154\233\149\191\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(29.75, 72.5)
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
      name = "self_guild_chair1",
      z = 0,
      parent = "bg_self_guild_detail",
      text = T("\230\151\160\230\149\140\233\163\142\231\129\171\232\189\174\233\187\145\229\147\165"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(80.25, 72.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(187, 217, 168),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "self_guild_member",
      z = 0,
      parent = "bg_self_guild_detail",
      text = T("\230\136\144\229\145\152\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(29.75, 50.5)
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
      name = "self_guild_member1",
      z = 0,
      parent = "bg_self_guild_detail",
      text = T("80\229\144\141"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(80.25, 50.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(187, 217, 168),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "self_guild_wincount",
      z = 0,
      parent = "bg_self_guild_detail",
      text = T("\232\131\156\229\156\186\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(29.75, 28.5)
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
      name = "self_guild_wincount1",
      z = 0,
      parent = "bg_self_guild_detail",
      text = T("2\232\131\1561\232\180\159"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(80.25, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 55.999992, h = 55.999992},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_oppo_guild_detail",
      res = "UI/alpha/1080P/guild/avatar_frame/guild_avatar_frame_lightning.png",
      name = "icon_oppo_guild1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49.75, 116.5)
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
      name = "name_oppo_guild1",
      z = 0,
      parent = "bg_oppo_guild_detail",
      text = T("\230\151\160\230\149\140\229\133\172\228\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(81.25, 126.5)
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
      name = "oppo_guild_chair1",
      z = 0,
      parent = "bg_oppo_guild_detail",
      text = T("\230\151\160\230\149\140\233\163\142\231\129\171\232\189\174\233\187\145\229\147\165"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(80.25, 72.5)
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
      name = "oppo_guild_member1",
      z = 0,
      parent = "bg_oppo_guild_detail",
      text = T("80\229\144\141"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(80.25, 50.5)
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
      name = "oppo_guild_wincount1",
      z = 0,
      parent = "bg_oppo_guild_detail",
      text = T("2\232\131\1561\232\180\159"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(80.25, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(243, 173, 152),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "oppo_guild_server",
      z = 0,
      parent = "bg_oppo_guild_detail",
      text = T("317\230\156\141 \228\184\150\231\149\140\229\143\164\230\160\145"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(78.75, 102)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(243, 173, 152),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "oppo_guild_chair",
      z = 0,
      parent = "bg_oppo_guild_detail",
      text = T("\228\188\154\233\149\191\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(29.75, 72.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(243, 173, 152),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "oppo_guild_member",
      z = 0,
      parent = "bg_oppo_guild_detail",
      text = T("\230\136\144\229\145\152\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(29.75, 50.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(243, 173, 152),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "oppo_guild_wincount",
      z = 0,
      parent = "bg_oppo_guild_detail",
      text = T("\232\131\156\229\156\186\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(29.75, 28.5)
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
      name = "self_name_tower_down",
      z = 0,
      parent = "self_bg_tower_down",
      text = T("\228\184\139\232\183\175"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 14.75)
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
      name = "self_name_tower_mid",
      z = 0,
      parent = "self_bg_tower_mid",
      text = T("\228\184\173\232\183\175"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 14.75)
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
      name = "self_name_tower_up",
      z = 0,
      parent = "self_bg_tower_up",
      text = T("\228\184\138\232\183\175"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 14.75)
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
      name = "oppo_name_tower_down",
      z = 0,
      parent = "oppo_bg_tower_down",
      text = T("\228\184\139\232\183\175"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 14.75)
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
      name = "oppo_name_tower_mid",
      z = 0,
      parent = "oppo_bg_tower_mid",
      text = T("\228\184\173\232\183\175"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 14.75)
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
      name = "oppo_name_tower_up",
      z = 0,
      parent = "oppo_bg_tower_up",
      text = T("\228\184\138\232\183\175"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 14.75)
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
      parent = "btn_rule",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "icon_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.25, 13.25)
    }
  }
}
