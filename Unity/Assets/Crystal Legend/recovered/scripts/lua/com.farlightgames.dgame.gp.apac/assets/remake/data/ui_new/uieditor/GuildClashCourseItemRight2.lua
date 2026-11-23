ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildClashCourseItemRight2 = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(303, 98)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(101, 5, 101, 250),
      res = "UI/alpha/1080P/guild/guild_clash_course/currentstage_light.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 357.5, h = 101.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/guild/guild_clash_course/currentstage_background.png",
      name = "image_current",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(176.5, 49)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 238, 111),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_date",
      z = 0,
      parent = "image_bg",
      text = T("1\230\156\13615\230\151\165"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(12, 58.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 238, 210),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_time",
      z = 0,
      parent = "image_bg",
      text = "5:00",
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(12, 37)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 250, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_state",
      z = 0,
      parent = "image_bg",
      text = T("\229\135\134\229\164\135\233\152\182\230\174\181"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(101.5, 74)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(185, 229, 121),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_left_time",
      z = 0,
      parent = "image_bg",
      text = T("\229\137\169\228\189\1533\229\164\1692\229\176\143\230\151\182"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(101.5, 52)
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
      name = "label_desc",
      z = 0,
      parent = "image_bg",
      text = T("\232\175\183\229\184\131\233\152\178\228\189\160\231\154\132\233\152\159\228\188\141\229\185\182\229\136\134\233\133\141\233\152\178\229\174\136\232\183\175\231\186\191"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(101.5, 43.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 63, h = 43.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/guild/guild_clash_course/currentstage_go.png",
      name = "btn_go",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(269.5, 48)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(151, 250, 242),
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
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18.5, 22.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19, h = 98.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_current",
      res = "UI/alpha/1080P/guild/guild_clash_course/currentstage_connectline.png",
      name = "ImageView_10676",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(9.75, 50.75)
    }
  }
}
