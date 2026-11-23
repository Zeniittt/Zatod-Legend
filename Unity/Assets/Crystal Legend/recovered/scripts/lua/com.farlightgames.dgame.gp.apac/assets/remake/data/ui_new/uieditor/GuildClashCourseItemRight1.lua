ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildClashCourseItemRight1 = {
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
      position = ccp(151, 98)
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
      position = ccp(10.5, 42)
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
      color = ccc3(182, 242, 241),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_desc",
      z = 1,
      parent = "image_bg",
      text = T("\229\183\178\229\140\185\233\133\141\229\175\185\230\137\139"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(100.5, 66.5)
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
      name = "label_oppo_name",
      z = 1,
      parent = "image_bg",
      text = T("\229\133\172\228\188\154\229\144\141\229\173\151\229\133\173\228\184\170\229\173\151"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(100, 40.5)
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
      text = T("\231\172\172\228\186\140\232\189\174"),
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
      name = "ImageView_10676",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(9.75, 57.5)
    }
  }
}
