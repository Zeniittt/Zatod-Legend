ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildClashGradingScene = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 861.5, h = 370},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/guild/guild_grading/grading_floor.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(461.5, 265.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 162.5, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/guild/guild_grading/guildname_floor.png",
      name = "guild_name_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(148.75, 160.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 206),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_guild_name",
      z = 0,
      parent = "guild_name_bg",
      text = T("\229\133\172\228\188\154\229\144\141\229\133\173\228\184\170\229\173\151"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(81.25, 14.25)
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
      parent = "image_bg",
      name = "panel_guild_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(98.75, 188.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 403.5, h = 130.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/guild/guild_grading/title_floor.png",
      name = "image_title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(469.5, 504.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 206),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_total_activity",
      z = 0,
      parent = "image_bg",
      text = T("\230\128\187\230\180\187\232\183\131\229\186\166\239\188\154"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(148.75, 133.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 134.3999808, h = 39.54999435},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/buttion_big.png",
      name = "btn_check",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(150.25, 92)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 223, h = 28.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/guild/guild_grading/endtime_floor.png",
      name = "image_time_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(473, 460.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(560, 300)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_grading",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(269.75, 39)
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
      z = 0,
      parent = "image_title_bg",
      text = T("\232\181\155\229\137\141-\229\133\172\228\188\154\229\174\154\231\186\167"),
      size = 34
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(205.25, 58.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 221, h = 202.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/guild/guild_grading/countgrade_floor.png",
      name = "image_countgrade_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(533.25, 171.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 222, 167),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "label_title_tips",
      z = 0,
      parent = "image_title_bg",
      text = T("\229\133\172\228\188\154\229\174\154\231\186\167\232\182\138\233\171\152\239\188\140\231\187\147\231\174\151\229\165\150\229\138\177\232\182\138\229\164\154\239\188\129"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(212.75, 28.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 144, h = 42.375},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/common/buttion_big.png",
      name = "btn_go",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(839.5, 61)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 210, 125),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_check",
      z = 0,
      parent = "btn_check",
      text = T("\230\159\165\231\156\139\230\180\187\232\183\131"),
      size = 29
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96, 30.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 137, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/guild/guild_grading/todaycontribute_shadow.png",
      name = "today_devote_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(838.5, 95.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(248, 105, 105),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_time",
      z = 0,
      parent = "image_time_bg",
      text = T("02\229\164\16923:45:31"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(77.5, 14.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 178, h = 51.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_grading",
      res = "UI/alpha/1080P/guild/guild_grading/othergrade_textfloor.png",
      name = "title_bg_2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108, 233)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 178, h = 51.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_grading",
      res = "UI/alpha/1080P/guild/guild_grading/othergrade_textfloor.png",
      name = "title_bg_3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(283.5, 248.5)
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
      name = "Label_10792",
      z = 0,
      parent = "image_time_bg",
      text = T("\229\174\154\231\186\167\231\187\147\230\157\159"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(162.5, 15.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 178, h = 51.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_grading",
      res = "UI/alpha/1080P/guild/guild_grading/othergrade_textfloor.png",
      name = "title_bg_4",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(460.5, 264)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 508.5, h = 18.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_grading",
      res = "UI/alpha/1080P/guild/guild_grading/progress_dark.png",
      name = "bar_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(285, 73)
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
      size = 12,
      text = T("\230\182\136\232\128\151\228\189\147\229\138\155\239\188\140\229\162\158\229\138\160\229\133\172\228\188\154\230\180\187\232\183\131"),
      name = "label_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(839, 30.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 191, 158),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_name_2",
      z = 1,
      parent = "panel_grading",
      text = T("\231\153\189\233\147\182\231\186\167"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(109.5, 50)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 273, h = 69.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_countgrade_bg",
      res = "UI/alpha/1080P/guild/guild_grading/countgrade_textfloor.png",
      name = "ImageView_10829",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(109, 110.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 173.5, h = 346},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "panel_grading",
      res = "UI/alpha/1080P/guild/guild_grading/curretgrade_floor.png",
      name = "image_current_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(109, 143)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 173.5, h = 346},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "panel_grading",
      res = "UI/alpha/1080P/guild/guild_grading/curretgrade_floor.png",
      name = "image_current_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(284, 143)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 173.5, h = 346},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "panel_grading",
      res = "UI/alpha/1080P/guild/guild_grading/curretgrade_floor.png",
      name = "image_current_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(459, 143)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(136, 35.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(15, 12.5, 15, 12.5),
      res = "UI/alpha/1080P/activity/activity_str_bg.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(967.5, 501)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 210, 125),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_go",
      z = 0,
      parent = "btn_go",
      text = T("\229\137\141\229\190\128"),
      size = 29
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(95.5, 30.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 191, 158),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_name_3",
      z = 1,
      parent = "panel_grading",
      text = T("\233\187\132\233\135\145\231\186\167"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(284, 50)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 191, 158),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_name_4",
      z = 1,
      parent = "panel_grading",
      text = T("\231\142\139\232\128\133\231\186\167"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(461, 50)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 136, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_grading",
      res = "UI/alpha/1080P/guild/guild_grading/othergrade_needfloor.png",
      name = "need_act_bg_2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108.5, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 169.5, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_grading",
      res = "UI/alpha/1080P/guild/guild_grading/currentgrade_needfloor.png",
      name = "need_act_bg_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(284, 23.5)
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
      res = "UI/alpha/1080P/crusade/bg_title_crusade.png",
      name = "scene_title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(10, 507.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 136, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_grading",
      res = "UI/alpha/1080P/guild/guild_grading/othergrade_needfloor.png",
      name = "need_act_bg_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(460, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 121.5, h = 111.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_grading",
      res = "UI/alpha/1080P/guild/guild_grading/silver_icon.png",
      name = "guild_icon_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(109.5, 143)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 138.5, h = 128.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_grading",
      res = "UI/alpha/1080P/guild/guild_grading/silver_icon_light.png",
      name = "guild_icon_light_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(109.5, 143)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 506.5, h = 7},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bar_bg",
      res = "UI/alpha/1080P/guild/guild_grading/progress_bright.png",
      name = "bar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(254.25, 9.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 230, 131),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_10830",
      z = 0,
      parent = "ImageView_10829",
      text = T("\229\174\154\231\186\167\231\187\147\230\158\156\231\187\147\231\174\151\228\184\173......"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(136.5, 51.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.5, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bar_bg",
      res = "UI/alpha/1080P/guild/guild_grading/progress_point.png",
      name = "point_2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.75, 9.25)
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
      name = "Label_10831",
      z = 0,
      parent = "ImageView_10829",
      text = T("\229\137\169\228\189\153\231\187\147\231\174\151\230\151\182\233\151\180\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106, 21.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 141, h = 140.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_grading",
      res = "UI/alpha/1080P/guild/guild_grading/gold_icon_light.png",
      name = "guild_icon_light_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(284.5, 157)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.5, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bar_bg",
      res = "UI/alpha/1080P/guild/guild_grading/progress_point.png",
      name = "point_3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(255.25, 9.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(248, 105, 105),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_grade_end_time",
      z = 0,
      parent = "ImageView_10829",
      text = T("15\229\136\13423\231\167\146"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(166.5, 21.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.5, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bar_bg",
      res = "UI/alpha/1080P/guild/guild_grading/progress_point.png",
      name = "point_4",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(429.25, 9.25)
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
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(988, 418)
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
      name = "label_today_devote",
      z = 0,
      parent = "today_devote_bg",
      text = T("\228\187\138\230\151\165\232\180\161\231\140\174\239\188\154580/900"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(71, 9.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 124, h = 124},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_grading",
      res = "UI/alpha/1080P/guild/guild_grading/gold_icon.png",
      name = "guild_icon_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(284.5, 157)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 150.5, h = 137.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_grading",
      res = "UI/alpha/1080P/guild/guild_grading/king_icon.png",
      name = "guild_icon_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(461, 172)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 167.5, h = 154.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_grading",
      res = "UI/alpha/1080P/guild/guild_grading/king_icon_light.png",
      name = "guild_icon_light_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(461, 172)
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
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_exchange",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(988, 337)
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
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_gameplay",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(988, 256)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.5, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_rule",
      res = "UI/alpha/1080P/summon/rule_btn.png",
      name = "ImageView_10823",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24, 16.25)
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
      name = "Label_10825",
      z = 0,
      parent = "btn_rule",
      text = T("\230\180\187\229\138\168\232\175\180\230\152\142"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82, 18.75)
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
      parent = "btn_reward",
      res = "UI/alpha/1080P/pvp/reward.png",
      name = "ImageView_10942",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.5, 33)
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
      name = "label_reward",
      z = 0,
      parent = "btn_reward",
      text = T("\229\165\150\229\138\177"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34, 9)
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
      parent = "btn_exchange",
      res = "UI/alpha/1080P/toparena/toparena_shop_icon.png",
      name = "ImageView_10942",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.5, 33.5)
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
      parent = "ImageView_10823",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "ImageView_10824",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(15.75, 16.25)
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
      name = "label_exchange",
      z = 0,
      parent = "btn_exchange",
      text = T("\229\133\145\230\141\162"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34, 9)
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
      parent = "btn_gameplay",
      res = "UI/alpha/1080P/pvp/record.png",
      name = "ImageView_10942",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.5, 33.5)
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
      name = "label_gameplay",
      z = 0,
      parent = "btn_gameplay",
      text = T("\231\142\169\230\179\149"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34, 9)
    }
  }
}
