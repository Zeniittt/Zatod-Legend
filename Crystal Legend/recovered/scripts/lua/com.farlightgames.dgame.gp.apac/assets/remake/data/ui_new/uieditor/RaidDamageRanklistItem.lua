ed.uieditor = ed.uieditor or {}
ed.uieditor.RaidDamageRanklistItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(559, 67.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(5, 5, 26, 25.5),
      res = "UI/alpha/1080P/raid/rank_bg.png",
      name = "bg",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90.5, h = 70},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/rankingscene/ranking_yellow.png",
      name = "rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 33.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 56.09999065, h = 56.3999906},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/mainhead/main_head_frame_silver.png",
      name = "avatar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(142, 33.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.1, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 161.34997695, h = 13.75},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crusade/bar_data_bg.png",
      name = "bg_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(449.5, 33.75)
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
      name = "label_bar",
      z = 2,
      parent = "bg",
      text = "Text Label",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(449.5, 33.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "rank",
      res = "UI/alpha/1080P/rankingscene/1st.png",
      name = "rank_num",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.25, 35)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 230.5, h = 12.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_bar",
      res = "UI/alpha/1080P/crusade/bar_self_data.png",
      name = "bar",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-0.25, 6.25)
    }
  }
}
