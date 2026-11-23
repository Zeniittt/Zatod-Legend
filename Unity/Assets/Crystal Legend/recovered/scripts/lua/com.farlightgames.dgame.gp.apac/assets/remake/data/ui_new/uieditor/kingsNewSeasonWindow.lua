ed.uieditor = ed.uieditor or {}
ed.uieditor.kingsNewSeasonWindow = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 539, h = 410},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/main/new_season_bg_3.png",
      name = "image_new_season_bg1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 287)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(172, 154, 114),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 16,
      text = T("\231\130\185\229\135\187\228\187\187\230\132\143\228\189\141\231\189\174\231\187\167\231\187\173"),
      name = "label_exit_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 25.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 539, h = 410},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/main/new_season_bg_3.png",
      name = "image_new_season_bg2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 287)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(25, 25)
    },
    t = "Layer",
    base = {
      parent = "image_new_season_bg1",
      name = "panel_new_season_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(269.5, 407.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 723, h = 540},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_new_season_bg1",
      res = "UI/alpha/1080P/newkingspvp/main/new_season_bg_1.png",
      name = "image_new_season_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(269.5, 202)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 351.5, h = 99.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_new_season_bg1",
      res = "UI/alpha/1080P/newkingspvp/main/new_season_bg_2.png",
      name = "image_new_season_name_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(269.5, 72)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 131, h = 146},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_new_season_bg1",
      res = "UI/alpha/1080P/newkingspvp/rank/rank_1.png",
      name = "image_rank_icon_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(269.5, 205)
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
      name = "label_tips_1",
      z = 1,
      parent = "image_new_season_bg1",
      text = T("\228\184\138\232\181\155\229\173\163\230\174\181\228\189\141\231\187\147\231\174\151\229\166\130\228\184\139\239\188\154"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(269.5, 361.5)
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
      name = "label_tips_2",
      z = 1,
      parent = "image_new_season_bg2",
      text = T("\228\184\138\232\181\155\229\173\163\231\154\132\230\174\181\228\189\141\231\187\167\230\137\191\229\166\130\228\184\139\239\188\154"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(269.5, 372.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 131, h = 146},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_new_season_bg2",
      res = "UI/alpha/1080P/newkingspvp/rank/rank_1.png",
      name = "image_rank_icon_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(269.5, 205)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 191),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_rank_name_2",
      z = 0,
      parent = "image_new_season_bg2",
      text = T("\228\184\135\229\143\164\230\181\129\232\138\179"),
      size = 27
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(269.5, 104.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 225, 109),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_score_2",
      z = 0,
      parent = "image_new_season_bg2",
      text = "1234",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(269.5, 70.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 191),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_rank_name_1",
      z = 0,
      parent = "image_new_season_name_bg",
      text = T("\228\184\135\229\143\164\230\181\129\232\138\179"),
      size = 27
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(175.75, 80.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 225, 109),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_score_1",
      z = 0,
      parent = "image_new_season_name_bg",
      text = "1234",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(175.75, 42.25)
    }
  }
}
