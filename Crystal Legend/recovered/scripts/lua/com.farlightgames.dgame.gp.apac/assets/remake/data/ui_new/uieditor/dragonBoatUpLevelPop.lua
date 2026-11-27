ed.uieditor = ed.uieditor or {}
ed.uieditor.dragonBoatUpLevelPop = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 550, h = 345},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dragonboat/db_race/db_pop-up_bottom_buy.png",
      name = "ImageView_2730",
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
      fix_wh = {w = 40, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2730",
      res = "UI/alpha/1080P/dragonboat/db_race/db_title_tag.png",
      name = "ImageView_2731",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(339, 325.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2730",
      res = "UI/alpha/1080P/dragonboat/db_race/db_title_tag.png",
      name = "ImageView_2731_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(210, 325.5)
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
      name = "Label_2733",
      z = 0,
      parent = "ImageView_2730",
      text = T("\231\161\174\232\174\164\229\141\135\231\186\167"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(275, 325.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58, h = 51.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2730",
      res = "UI/alpha/1080P/dragonboat/db_race/boatlevel_arrow.png",
      name = "ImageView_2734",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(275, 178.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 137, h = 56},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2730",
      res = "UI/alpha/1080P/dragonboat/db_race/db_eat_button.png",
      name = "ImageView_2735",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(275, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45.5, h = 45.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2730",
      res = "UI/alpha/1080P/dragonboat/db_race/db_quit2.png",
      name = "close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(540.5, 337.5)
    }
  }
}
