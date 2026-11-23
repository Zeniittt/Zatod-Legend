ed.uieditor = ed.uieditor or {}
ed.uieditor.checkOthersHero = {
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
      name = "layer_normal",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(456, 268)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(646.5, 477.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg",
      z = 0,
      parent = "layer_normal",
      res = "UI/alpha/1080P/common/com_new_2.png",
      capInsets = CCRectMake(15, 32.5, 15, 15)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, -5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(232, 459.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_skill",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/hero/hero_info_bg_0.png",
      capInsets = CCRectMake(18, 150, 18, 160)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(522.75, 242.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(227, 48.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_level",
      z = 0,
      parent = "bg_skill",
      res = "UI/alpha/1080P/hero/hero_level_bg.png",
      capInsets = CCRectMake(150, 16, 5, 16)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(116, 431.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39, h = 45},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_level",
      res = "UI/alpha/1080P/herolist/icon_str.png",
      name = "icon_type",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.5, 27.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 225, 132),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_level",
      z = 0,
      parent = "bg_level",
      text = T("\231\173\137\231\186\1672"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(98.5, 25.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(227, 43.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_star",
      z = 0,
      parent = "bg_skill",
      res = "UI/alpha/1080P/hero/hero_star_bg_0.png",
      capInsets = CCRectMake(75, 14.5, 75, 19.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(115.5, 383.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 345, h = 228.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/hero/hero_bg_mid_2.png",
      name = "bg_name",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(205.75, 357.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(224, 149)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_skilllist",
      z = 0,
      parent = "bg_skill",
      res = "UI/alpha/1080P/hero/hero_info_bg_3.png",
      capInsets = CCRectMake(25, 50, 10, 50)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(116, 142.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.5, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star",
      res = "UI/alpha/1080P/hero/hero_star_bg.png",
      name = "bg_star1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.5, 21.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.5, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star",
      res = "UI/alpha/1080P/hero/hero_star_bg.png",
      name = "bg_star2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82.5, 21.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.5, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star",
      res = "UI/alpha/1080P/hero/hero_star_bg.png",
      name = "bg_star3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113, 21.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star1",
      res = "UI/alpha/1080P/hero/hero_star_1.png",
      name = "star1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.75, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.5, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star",
      res = "UI/alpha/1080P/hero/hero_star_bg.png",
      name = "bg_star4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(143.5, 21.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 398.5, h = 397.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/hero/hero_bg_tattoos_2.png",
      name = "bg_equip",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(203.25, 199.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 213, h = 38},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_name",
      res = "UI/alpha/1080P/hero/rank/hero_rank_1.png",
      name = "frame_name",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(172, 202.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.5, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star",
      res = "UI/alpha/1080P/hero/hero_star_bg.png",
      name = "bg_star5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(174.5, 21.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 225, h = 87.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_skilllist",
      res = "UI/alpha/1080P/hero/hero_show_skill_bg.png",
      name = "skill1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111.5, 249.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star2",
      res = "UI/alpha/1080P/hero/hero_star_1.png",
      name = "star2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.75, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 225, h = 87.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_skilllist",
      res = "UI/alpha/1080P/hero/hero_show_skill_bg.png",
      name = "skill2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111.5, 162.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 225, h = 87.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_skilllist",
      res = "UI/alpha/1080P/hero/hero_show_skill_bg.png",
      name = "skill3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111.5, 75.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star3",
      res = "UI/alpha/1080P/hero/hero_star_1.png",
      name = "star3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.75, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 225, h = 87.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_skilllist",
      res = "UI/alpha/1080P/hero/hero_show_skill_bg.png",
      name = "skill4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111.5, -11)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 39.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/hero/hero_bg_frame_1.png",
      name = "sep1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(406.25, 452.25)
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
      name = "name",
      z = 0,
      parent = "frame_name",
      text = T("\232\136\185\233\149\191+2"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106.5, 19)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star4",
      res = "UI/alpha/1080P/hero/hero_star_1.png",
      name = "star4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.75, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 72, h = 72},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill1",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "skill_icon1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 43.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58, h = 58},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill1",
      res = "UI/alpha/1080P/skill/skill_lock.png",
      name = "skill_lock1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 39.75)
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
      name = "skill_name1",
      z = 0,
      parent = "skill1",
      text = T("\228\186\161\231\129\181\229\143\172\229\148\164"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(97.5, 62.75)
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
      name = "skill_level1",
      z = 0,
      parent = "skill1",
      text = "lv.55",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(99, 26.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star5",
      res = "UI/alpha/1080P/hero/hero_star_1.png",
      name = "star5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.75, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill1",
      res = "UI/alpha/1080P/skill/skill_rank_2.png",
      name = "bg_skill_rank1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48, 72.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 72, h = 72},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill2",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "skill_icon2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 43.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58, h = 58},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill2",
      res = "UI/alpha/1080P/skill/skill_lock.png",
      name = "skill_lock2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 39.75)
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
      name = "skill_name2",
      z = 0,
      parent = "skill2",
      text = T("\228\186\161\231\129\181\229\143\172\229\148\164"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(97.5, 62.75)
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
      name = "skill_level2",
      z = 0,
      parent = "skill2",
      text = "lv.55",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(99, 26.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.2, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(805, 486.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_equip",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "equip1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.75, 357.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill2",
      res = "UI/alpha/1080P/skill/skill_rank_2.png",
      name = "bg_skill_rank2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48, 72.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 72, h = 72},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill3",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "skill_icon3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 43.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58, h = 58},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill3",
      res = "UI/alpha/1080P/skill/skill_lock.png",
      name = "skill_lock3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 39.75)
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
      name = "skill_name3",
      z = 0,
      parent = "skill3",
      text = T("\228\186\161\231\129\181\229\143\172\229\148\164"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(97.5, 62.75)
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
      name = "skill_level3",
      z = 0,
      parent = "skill3",
      text = "lv.55",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(99, 26.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_equip",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "equip2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.25, 262.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill3",
      res = "UI/alpha/1080P/skill/skill_rank_2.png",
      name = "bg_skill_rank3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48, 72.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 72, h = 72},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill4",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "skill_icon4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 43.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58, h = 58},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill4",
      res = "UI/alpha/1080P/skill/skill_lock.png",
      name = "skill_lock4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 39.75)
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
      name = "skill_name4",
      z = 0,
      parent = "skill4",
      text = T("\228\186\161\231\129\181\229\143\172\229\148\164"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(97.5, 62.75)
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
      name = "skill_level4",
      z = 0,
      parent = "skill4",
      text = "lv.55",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(99, 26.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_equip",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "equip3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.75, 169.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill4",
      res = "UI/alpha/1080P/skill/skill_rank_2.png",
      name = "bg_skill_rank4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48, 72.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_skill_rank1",
      res = "UI/alpha/1080P/skill/skill_rank_1.png",
      name = "frame_skill_rank1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17.75, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_equip",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "equip4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(337.25, 356.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_skill_rank2",
      res = "UI/alpha/1080P/skill/skill_rank_1.png",
      name = "frame_skill_rank2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17.75, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_equip",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "equip5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(337.75, 262.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "equip1",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "frame_equip1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_equip",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "equip6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(338.25, 168.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_skill_rank3",
      res = "UI/alpha/1080P/skill/skill_rank_1.png",
      name = "frame_skill_rank3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17.75, 10.75)
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
      name = "skill_rank1",
      z = 0,
      parent = "frame_skill_rank1",
      text = "1",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17.75, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 383, h = 54.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_equip",
      res = "UI/alpha/1080P/hero/hero_gs_bg.png",
      name = "bg_gs",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(195.75, 61.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "equip2",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "frame_equip2",
      z = 0
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
      fix_wh = {w = 35.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_skill_rank4",
      res = "UI/alpha/1080P/skill/skill_rank_1.png",
      name = "frame_skill_rank4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17.75, 10.75)
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
      name = "skill_rank2",
      z = 0,
      parent = "frame_skill_rank2",
      text = "1",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17.75, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_back",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "Image_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "equip3",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "frame_equip3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 45)
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
      name = "skill_rank3",
      z = 0,
      parent = "frame_skill_rank3",
      text = "1",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17.75, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "equip4",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "frame_equip4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 45)
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
      name = "skill_rank4",
      z = 0,
      parent = "frame_skill_rank4",
      text = "1",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17.75, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "equip5",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "frame_equip5",
      z = 0
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
      fix_wh = {w = 90, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "equip6",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "frame_equip6",
      z = 0
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
      fix_wh = {w = 20, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_gs",
      res = "UI/alpha/1080P/hero/hero_gs_2.png",
      name = "icon_gs",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(114.5, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_gs",
      res = "UI/alpha/1080P/hero/number/hero_gs_9.png",
      name = "num_gs",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(225.5, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(248, 224, 175),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_gs",
      z = 0,
      parent = "bg_gs",
      text = T("\230\136\152\229\138\155\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(127.5, 29.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 52.5, h = 52.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_name",
      res = "UI/alpha/1080P/pet/hero_pet_bottom.png",
      name = "bg_pet",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 198.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 144,
      fix_wh = {w = 21, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_pet",
      res = "UI/alpha/1080P/pet/bg_item_level.png",
      name = "bg_pet_level",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26.25, 6.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 44.999991, h = 44.999991},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_pet",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_7.png",
      name = "icon_pet",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26.25, 26.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 251, 165),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "pet_level",
      z = 0,
      parent = "bg_pet_level",
      text = "15",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(10.5, 6)
    }
  }
}
