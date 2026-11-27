ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_arena_competition_page = {
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
      res = "UI/alpha/1080P/activity/pvp_guild/pvp_guild_bg.jpg",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {name = "panel_page", z = 0},
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
      fix_wh = {w = 285.5, h = 158},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_page",
      res = "UI/alpha/1080P/activity/pvp_guild/pvp_guild_title.png",
      name = "img_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(355.5, 422)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 222, h = 37},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_page",
      res = "UI/alpha/1080P/activity/pvp_guild/pvp_guild_timebg3.png",
      name = "bg_end_time",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(353.5, 358.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 524.5, h = 286.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "panel_page",
      res = "UI/alpha/1080P/activity/pvp_guild/pvp_guild_timebg1.png",
      name = "bg_prepare",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(606, 196)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 193.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_page",
      res = "UI/alpha/1080P/activity/pvp_guild/pvp_guild_framebg.png",
      name = "bg_frame_des",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(604.5, 356)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(540, 265)
    },
    t = "Layer",
    base = {
      parent = "panel_page",
      name = "panel_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(330, 73)
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
      parent = "panel_page",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_member",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(920.5, 70.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 106.5, h = 106.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_page",
      res = "UI/alpha/1080P/activity/pvp_guild/pvp_guild_framebg2.png",
      name = "img_frame_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(604.5, 449)
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
      name = "label_end_time",
      z = 0,
      parent = "bg_end_time",
      text = T("\231\187\147\231\174\151\229\128\146\232\174\161\230\151\182\239\188\1543\229\164\1698\230\151\182"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58.5, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_prepare",
      res = "UI/alpha/1080P/activity/pvp_guild/pvp_guild_timebg2.png",
      name = "bg_start_time_hour",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(186.25, 205.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58.5, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_prepare",
      res = "UI/alpha/1080P/activity/pvp_guild/pvp_guild_timebg2.png",
      name = "bg_start_time_sec",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(338.25, 205.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58.5, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_prepare",
      res = "UI/alpha/1080P/activity/pvp_guild/pvp_guild_timebg2.png",
      name = "bg_start_time_min",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(262.75, 205.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 229, 149),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_rank_time_des",
      z = 0,
      parent = "bg_prepare",
      text = T("\233\166\150\230\172\161\229\133\172\228\188\154\230\142\146\229\144\141\229\128\146\232\174\161\230\151\182"),
      size = 27
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(262.25, 255.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(480, 130)
    },
    t = "Layer",
    base = {
      parent = "bg_prepare",
      name = "panel_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(22.25, 31.75)
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
      name = "label_frame_name",
      z = 0,
      parent = "bg_frame_des",
      text = T("\229\134\160\229\134\155\229\133\172\228\188\154\229\164\180\229\131\143\230\161\134"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96.75, 15)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 558.5, h = 103},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_rank",
      res = "UI/alpha/1080P/activity/pvp_guild/pvp_guild_scorebg3.png",
      name = "bg_my_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(270, -5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47.5, h = 41.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_member",
      res = "UI/alpha/1080P/activity/pvp_guild/pvp_guild_membericon.png",
      name = "icon",
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
      color = ccc3(244, 231, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_member",
      z = 0,
      parent = "btn_member",
      text = T("\230\136\144\229\145\152\229\136\151\232\161\168"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 4)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 217, 102),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_start_time_mark1",
      z = 0,
      parent = "bg_prepare",
      text = ":",
      size = 51
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(224.75, 205.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 217, 102),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_start_time_mark2",
      z = 0,
      parent = "bg_prepare",
      text = ":",
      size = 51
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(300.25, 205.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 165, h = 164.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_frame_bg",
      res = "UI/alpha/1080P/activity/pvp_guild/pvp_guild_frameicon.png",
      name = "img_frame_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.75, 54.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 217, 102),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_start_time_hour",
      z = 0,
      parent = "bg_start_time_hour",
      text = "03",
      size = 51
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(29.25, 25.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 217, 102),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_start_time_sec",
      z = 0,
      parent = "bg_start_time_sec",
      text = "03",
      size = 51
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(29.25, 25.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 217, 102),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_start_time_min",
      z = 0,
      parent = "bg_start_time_min",
      text = "03",
      size = 51
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(29.25, 25.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 232, 178),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_rank",
      z = 0,
      parent = "bg_my_rank",
      text = "28",
      size = 35
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82.75, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 82.5, h = 82.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_my_rank",
      res = "UI/alpha/1080P/guild/avatar_frame/guild_avatar_honor_king.png",
      name = "img_guild_frame",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(167.75, 46)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 64.35, h = 34.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_my_rank",
      res = "UI/alpha/1080P/toparena/rank/rank_3rd.png",
      name = "img_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82.75, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 134.5, h = 57},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_my_rank",
      res = "UI/alpha/1080P/activity/pvp_guild/pvp_guild_scorebg2.png",
      name = "bg_score",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(439.25, 46.5)
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
      parent = "bg_my_rank",
      text = T("\232\135\170\229\183\177\231\154\132"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(213.25, 56.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 240, 136),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_chairman_name",
      z = 0,
      parent = "bg_my_rank",
      text = T("\228\188\154\233\149\191\239\188\154"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(213.75, 36)
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
      name = "label_score_des",
      z = 0,
      parent = "bg_score",
      text = T("\231\171\158\230\138\128\229\156\186\230\128\187\231\167\175\229\136\134"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.25, 42.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 25)
    },
    t = "Layer",
    base = {
      parent = "bg_score",
      name = "panel_score",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(17.25, 8)
    }
  }
}
