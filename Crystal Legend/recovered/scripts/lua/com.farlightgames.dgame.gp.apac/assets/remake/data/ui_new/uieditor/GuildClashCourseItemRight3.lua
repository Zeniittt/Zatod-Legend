ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildClashCourseItemRight3 = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(303, 110)
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
      fix_wh = {w = 289.5, h = 29.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/guild/guild_clash_course/title_background.png",
      name = "image_title_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(151, 97.5)
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
      z = 1,
      parent = "image_bg",
      text = "5:00",
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(10.5, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(154, 214, 210),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_date",
      z = 1,
      parent = "image_bg",
      text = T("1\230\156\13615\230\151\165"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(10.5, 66.5)
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
      z = 1,
      parent = "image_bg",
      text = T("\232\181\155\229\173\163\231\187\147\231\174\151\230\156\159\239\188\140\229\176\154\229\143\175\229\133\145\230\141\162\233\131\168\229\136\134\233\129\147\229\133\183"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(100, 77)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(357.5, 115)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_current",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/guild/guild_clash_course/currentstage_background.png",
      capInsets = CCRectMake(119, 33.5, 119, 33.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(176.5, 55)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(239, 231, 146),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "image_title_bg",
      text = T("\232\181\155\229\173\163\231\187\147\230\157\159"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(144.75, 16.25)
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
      name = "ImageView_10675",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(11.25, 57.5)
    }
  }
}
