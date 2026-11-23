ed.uieditor = ed.uieditor or {}
ed.uieditor.AutoChessRankGradeItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 200.5, h = 413},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chess/season/orange.png",
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "labelGradeName",
      z = 11,
      parent = "bg",
      text = T("\229\163\171\229\133\181"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(100.25, 237)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 71.99999568, h = 71.99999568},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "iconReward",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(100.75, 128)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 146, h = 201},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/season/2.png",
      name = "iconGrade",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(100.25, 293)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24, h = 25},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/season/star_2.png",
      name = "star1",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.25, 375)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24, h = 25},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/season/star_2.png",
      name = "star2",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.25, 375)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24, h = 25},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/season/star_2.png",
      name = "star3",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(89.25, 375)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24, h = 25},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/season/star_2.png",
      name = "star4",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111.25, 375)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24, h = 25},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/season/star_2.png",
      name = "star5",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(133.25, 375)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24, h = 25},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/season/star_2.png",
      name = "star6",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(155.25, 375)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "iconReward",
      res = "UI/alpha/1080P/common/frame/equip_frame_mask.png",
      name = "icon_mask",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 117, h = 117},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "iconReward",
      res = "UI/alpha/1080P/taskModel/player_award_list_item_eff.png",
      name = "icon_light",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 44)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.5, h = 47},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "icon_mask",
      res = "UI/alpha/1080P/common/common_mark.png",
      name = "ImageView_11473",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 45)
    }
  }
}
