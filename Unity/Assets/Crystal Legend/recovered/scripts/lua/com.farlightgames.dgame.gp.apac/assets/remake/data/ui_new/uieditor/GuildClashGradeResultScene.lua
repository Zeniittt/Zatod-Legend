ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildClashGradeResultScene = {
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
      res = "UI/alpha/1080P/guild/guild_gradereslut/background.jpg",
      name = "image_bg",
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
      fix_wh = {w = 403.5, h = 130.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/guild/guild_grading/title_floor.png",
      name = "image_title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(580, 594.5)
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
      text = T("\232\181\155\229\137\141-\229\174\154\231\186\167\229\174\140\230\136\144"),
      size = 34
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(205.25, 47.25)
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
      text = T("\229\138\170\229\138\155\230\143\144\229\141\135\230\180\187\232\183\131\239\188\140\230\143\144\233\171\152\229\133\172\228\188\154\229\174\154\231\186\167\239\188\129"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(213.75, 27.25)
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
      position = ccp(337, 373.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(99, 79, 44),
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
      position = ccp(388, 317.5)
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
      position = ccp(388, 271.5)
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
      name = "btn_rule",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/activity_str_bg.png",
      capInsets = CCRectMake(15, 12.5, 15, 12.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1072.5, 591)
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
      parent = "image_bg",
      res = "UI/alpha/1080P/crusade/bg_title_crusade.png",
      name = "scene_title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(115, 597.5)
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
      parent = "image_bg",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1106.5, 508.5)
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
      fix_wh = {w = 66, h = 66},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_exchange",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1106.5, 436)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 272.5, h = 32},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/guild/guild_gradereslut/dividezone_floor.png",
      name = "image_zone_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(704, 276.5)
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
      fix_wh = {w = 259, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/guild/guild_gradereslut/countdown_floor.png",
      name = "image_time_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(707, 232)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 155.5, h = 155.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/guild/guild_gradereslut/art1.png",
      name = "image_art",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(885.5, 265)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 210, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/guild/guild_gradereslut/guildname_floor.png",
      name = "guild_name_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(388, 348)
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
      parent = "image_bg",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_gameplay",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1106.5, 363.5)
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
      fix_wh = {w = 121.5, h = 121.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/guild/guild_gradereslut/grade_nograde_floor.png",
      name = "image_no_grade",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(703.5, 373.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.30000007, x = 1.30000007},
      flip = "",
      opacity = 255,
      fix_wh = {w = 195.650010535, h = 178.750009625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/guild/guild_grading/king_icon.png",
      name = "image_guild_grade",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(704, 391.5)
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
      fix_wh = {w = 179, h = 36},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/guild/guild_gradereslut/grade_floor.png",
      name = "image_zone_level_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(704, 332)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(99, 79, 44),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_zone_tips",
      z = 0,
      parent = "image_zone_bg",
      text = T("\230\136\152\229\140\186\229\136\146\229\136\134\239\188\154"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(85.25, 16)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 100, 52),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_zone",
      z = 0,
      parent = "image_zone_bg",
      text = T("\231\142\139\232\128\133123\230\136\152\229\140\186"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(183.75, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(99, 79, 44),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "label_no_zone",
      z = 0,
      parent = "image_zone_bg",
      text = T("\230\156\170\232\142\183\229\190\151\229\133\172\228\188\154\230\136\152\229\143\130\228\184\142\232\181\132\230\160\188"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(136.25, 16)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.04999685, h = 22.04999685},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_zone_bg",
      res = "UI/alpha/1080P/summon/rule_btn.png",
      name = "btn_zone_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(256.75, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(99, 79, 44),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_11008",
      z = 0,
      parent = "image_time_bg",
      text = T("\229\144\142\229\188\128\229\144\175\229\133\172\228\188\154\230\136\152"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(184, 15)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 57, 57),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_left_time",
      z = 0,
      parent = "image_time_bg",
      text = T("05\230\151\18225\229\136\13423\231\167\146"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(127.5, 14)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(99, 79, 44),
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
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104.5, 15)
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
      name = "label_no_grade",
      z = 0,
      parent = "image_no_grade",
      text = T("\230\151\160\231\186\167\229\136\171"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60.75, 60.75)
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
      parent = "btn_zone_tips",
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
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_zone_level",
      z = 0,
      parent = "image_zone_level_bg",
      text = T("\231\142\139\232\128\133\231\186\167\229\133\172\228\188\154"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(89.5, 18.5)
    }
  }
}
