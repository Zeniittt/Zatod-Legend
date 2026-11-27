ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildClashMainScene = {
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
      res = "UI/alpha/1080P/guild/guild_clash/brawls_background.jpg",
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
      z = 5
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
      fix_wh = {w = 26.5, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_title",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(187.25, 17.75)
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
      res = "UI/alpha/1080P/guild/guild_clash/bench_floor.png",
      name = "bg_step_info",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(475, 588)
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
      text = T("\229\137\169\228\189\153\230\151\182\233\151\180"),
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 212, h = 107.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash/nature_notice_floor.png",
      name = "bg_guild_notice",
      z = 5
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
      fix_wh = {w = 76.5, h = 74.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_step_info",
      res = "UI/alpha/1080P/guild/guild_clash/brawls_details.png",
      name = "icon_stepinfo",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44.5, 50)
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 209, h = 65},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash/dark_guildname_floor.png",
      name = "bg_camp2_guild",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(944, 490)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop_red.png",
      name = "camp1_main",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(195.5, 190.5)
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop_red.png",
      name = "camp2_main",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(951.5, 531.5)
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
      text = T("\228\188\154\233\149\191\229\133\172\229\145\138"),
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(109, 18.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_edit_notice",
      z = 0,
      parent = "bg_guild_notice",
      res = "UI/alpha/1080P/guild/guild_clash/nature_notice_write.png",
      capInsets = CCRectMake(10, 10, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106, 51.75)
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
      res = "UI/alpha/1080P/common/button_big_common.png",
      name = "btn_set_defend",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(762.5, 143)
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
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 153.599990784, h = 45.199997288},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/button_big_common.png",
      name = "btn_set_team",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(964.5, 143)
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
      parent = "bg_camp2_guild",
      res = "UI/alpha/1080P/guild/avatar_frame/guild_avatar_frame_lightning.png",
      name = "icon_camp2_guild",
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
      name = "name_camp2_guild",
      z = 0,
      parent = "bg_camp2_guild",
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
      fix_wh = {w = 66, h = 66},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "bg_btn1",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1030, 425)
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
      parent = "bg_camp2_guild",
      res = "UI/alpha/1080P/guild/guild_clash/dark_guild_popup.png",
      name = "bg_camp2_guild_detail",
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
      fix_wh = {w = 66, h = 66},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "bg_btn2",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1030, 360)
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
      text = T("\231\130\185\229\135\187\231\188\150\232\190\145\229\133\172\229\145\138"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(6, 9.25)
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
      parent = "bg",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "bg_btn3",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1030, 295)
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
      name = "layer_for_battle",
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
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "touchArea_camp1_mid",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(353, 244.5)
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
      name = "touchArea_camp1_bottom",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(443.5, 145.5)
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
      name = "Label_6141",
      z = 0,
      parent = "btn_set_defend",
      text = T("\232\176\131\230\149\180\229\184\131\233\152\178"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111, 29.25)
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
      parent = "bg_camp2_guild_detail",
      res = "UI/alpha/1080P/guild/avatar_frame/guild_avatar_frame_lightning.png",
      name = "icon_camp2_guild1",
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
      name = "name_camp2_guild1",
      z = 0,
      parent = "bg_camp2_guild_detail",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32, h = 31},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_set_defend",
      res = "UI/alpha/1080P/guild/guild_clash/brawls_defenceicon.png",
      name = "ImageView_6151",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 28.25)
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
      name = "camp2_guild_chair1",
      z = 0,
      parent = "bg_camp2_guild_detail",
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
      name = "camp2_guild_member1",
      z = 0,
      parent = "bg_camp2_guild_detail",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "touchArea_camp1_top",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(162, 333)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 171, h = 42.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_set_defend",
      res = "UI/alpha/1080P/guild/guild_clash/button_dec.png",
      name = "btn_defend_dec",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(268, 69.25)
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
      name = "camp2_guild_wincount1",
      z = 0,
      parent = "bg_camp2_guild_detail",
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
      name = "camp2_guild_server",
      z = 0,
      parent = "bg_camp2_guild_detail",
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
      name = "camp2_guild_chair",
      z = 0,
      parent = "bg_camp2_guild_detail",
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
      name = "camp2_guild_member",
      z = 0,
      parent = "bg_camp2_guild_detail",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "touchArea_camp2_top",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(632, 515)
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
      name = "Label_614",
      z = 0,
      parent = "btn_set_team",
      text = T("\229\135\186\229\190\129\233\152\159\228\188\141"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111, 29.75)
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
      name = "camp2_guild_wincount",
      z = 0,
      parent = "bg_camp2_guild_detail",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 41.5, h = 47.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_set_team",
      res = "UI/alpha/1080P/hero/icon_hero.png",
      name = "ImageView_615",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 29.25)
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
      name = "touchArea_camp2_mid",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(721.5, 411)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 171, h = 42.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_set_team",
      res = "UI/alpha/1080P/guild/guild_clash/button_dec.png",
      name = "button_dec",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96, 67.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_set_team",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "image_set_team_reddot",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(179, 46.75)
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
      name = "touchArea_camp2_bottom",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(907, 318.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 55, h = 49},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_btn1",
      res = "UI/alpha/1080P/pvp/ranking.png",
      name = "icon_btn1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 40)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(155, 125)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "touchArea_camp1_main",
      z = 9
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(126, 146)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(155, 120)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "touchArea_camp2_main",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(879, 470)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43, h = 37},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_btn2",
      res = "UI/alpha/1080P/pvp/reward.png",
      name = "icon_btn2",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_btn2",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "img_reward_red_tag",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 371.5, h = 78},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash/bench_floor_special.png",
      name = "ImageView_131",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(495.5, 587)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50.5, h = 49.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_btn3",
      res = "UI/alpha/1080P/toparena/toparena_shop_icon.png",
      name = "icon_btn3",
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
      color = ccc3(249, 229, 121),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1479",
      z = 0,
      parent = "btn_defend_dec",
      text = T("\228\188\154\233\149\191\232\176\131\230\149\180\228\184\173"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(85.5, 21.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_for_battle",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop_red.png",
      name = "top2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(286, 466)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_for_battle",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop_red.png",
      name = "mid2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(603.5, 326.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_for_battle",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop_red.png",
      name = "bottom2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(872.5, 196.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_for_battle",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop_red.png",
      name = "bottom1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(769.5, 154)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_for_battle",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop_red.png",
      name = "bottom3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(949.5, 250)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "touchArea_camp1_mid",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop_red.png",
      name = "camp1_tower_mid",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(249, 229, 121),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_14791",
      z = 0,
      parent = "button_dec",
      text = T("\228\188\154\233\149\191\232\176\131\230\149\180\228\184\173"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(85.5, 21.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_for_battle",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop_red.png",
      name = "mid3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(685, 380)
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
      parent = "touchArea_camp1_mid",
      res = "UI/alpha/1080P/guild/guild_clash/nature_tower_floor.png",
      name = "camp1_bg_tower_mid",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47, 12)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_for_battle",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop_red.png",
      name = "top3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(399.5, 525)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 231, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_btn1",
      z = 0,
      parent = "icon_btn1",
      text = T("\230\142\146\232\161\140\230\166\156"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27.5, -2)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_for_battle",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop_red.png",
      name = "top1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(240, 430)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_for_battle",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop_red.png",
      name = "mid1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(503.5, 288.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "touchArea_camp1_bottom",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop_red.png",
      name = "camp1_tower_bottom",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 19)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_for_battle",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop_red.png",
      name = "top0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(215.5, 379)
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
      parent = "touchArea_camp1_bottom",
      res = "UI/alpha/1080P/guild/guild_clash/nature_tower_floor.png",
      name = "camp1_bg_tower_bottom",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51, 11)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_for_battle",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop_red.png",
      name = "top4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(638.5, 534.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_for_battle",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop_red.png",
      name = "mid0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(412, 266)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_for_battle",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop_red.png",
      name = "mid4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(732, 412.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "touchArea_camp1_top",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop_red.png",
      name = "camp1_tower_top",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 231, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_btn2",
      z = 0,
      parent = "icon_btn2",
      text = T("\229\165\150\229\138\177"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.5, -2.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_for_battle",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop_red.png",
      name = "bottom0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(537.5, 157.5)
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
      parent = "touchArea_camp1_top",
      res = "UI/alpha/1080P/guild/guild_clash/nature_tower_floor.png",
      name = "camp1_bg_tower_top",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 12)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_for_battle",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop_red.png",
      name = "bottom4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(958, 312)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "touchArea_camp2_top",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop_red.png",
      name = "camp2_tower_top",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 19.5)
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
      parent = "touchArea_camp2_top",
      res = "UI/alpha/1080P/guild/guild_clash/dark_tower_floor.png",
      name = "camp2_bg_tower_top",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51, 12)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 231, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_btn3",
      z = 0,
      parent = "icon_btn3",
      text = T("\229\133\145\230\141\162"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25.25, 2.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "touchArea_camp2_mid",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop_red.png",
      name = "camp2_tower_mid",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.5, 21)
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
      parent = "touchArea_camp2_mid",
      res = "UI/alpha/1080P/guild/guild_clash/dark_tower_floor.png",
      name = "camp2_bg_tower_mid",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "touchArea_camp2_bottom",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop_red.png",
      name = "camp2_tower_bottom",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52.5, 22)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 77, h = 29.15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "touchArea_camp2_bottom",
      res = "UI/alpha/1080P/guild/guild_clash/dark_tower_floor.png",
      name = "camp2_bg_tower_bottom",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.5, 13)
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
      parent = "touchArea_camp1_main",
      res = "UI/alpha/1080P/guild/guild_clash/nature_guildname_floor.png",
      name = "bg_camp1_guild",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(68, -19.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 156, 108),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "camp1_name_tower_mid",
      z = 0,
      parent = "camp1_bg_tower_mid",
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
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_132",
      z = 0,
      parent = "ImageView_131",
      text = T("\229\183\178\232\189\174\231\169\186,\231\187\147\231\174\151\230\151\182\229\176\134\232\135\170\229\138\168\232\142\183\229\190\151\232\131\156\229\136\169"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(218.75, 45)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 156, 108),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "camp1_name_tower_bottom",
      z = 0,
      parent = "camp1_bg_tower_bottom",
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
      color = ccc3(255, 156, 108),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "camp1_name_tower_top",
      z = 0,
      parent = "camp1_bg_tower_top",
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
      name = "camp2_name_tower_top",
      z = 0,
      parent = "camp2_bg_tower_top",
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
      name = "camp2_name_tower_mid",
      z = 0,
      parent = "camp2_bg_tower_mid",
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
      name = "camp2_name_tower_bottom",
      z = 0,
      parent = "camp2_bg_tower_bottom",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 230.5, h = 153},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_camp1_guild",
      res = "UI/alpha/1080P/guild/guild_clash/nature_guild_popup.png",
      name = "bg_camp1_guild_detail",
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
      parent = "bg_camp1_guild",
      res = "UI/alpha/1080P/guild/avatar_frame/guild_avatar_frame_lightning.png",
      name = "icon_camp1_guild",
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
      color = ccc3(255, 156, 108),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "name_camp1_guild",
      z = 0,
      parent = "bg_camp1_guild",
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
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 55.999992, h = 55.999992},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_camp1_guild_detail",
      res = "UI/alpha/1080P/guild/avatar_frame/guild_avatar_frame_lightning.png",
      name = "icon_camp1_guild1",
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
      name = "name_camp1_guild1",
      z = 0,
      parent = "bg_camp1_guild_detail",
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
      name = "camp1_guild_server",
      z = 0,
      parent = "bg_camp1_guild_detail",
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
      name = "camp1_guild_chair",
      z = 0,
      parent = "bg_camp1_guild_detail",
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
      name = "camp1_guild_chair1",
      z = 0,
      parent = "bg_camp1_guild_detail",
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
      name = "camp1_guild_member",
      z = 0,
      parent = "bg_camp1_guild_detail",
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
      name = "camp1_guild_member1",
      z = 0,
      parent = "bg_camp1_guild_detail",
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
      name = "camp1_guild_wincount",
      z = 0,
      parent = "bg_camp1_guild_detail",
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
      name = "camp1_guild_wincount1",
      z = 0,
      parent = "bg_camp1_guild_detail",
      text = T("2\232\131\1561\232\180\159"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(80.25, 28.5)
    }
  }
}
