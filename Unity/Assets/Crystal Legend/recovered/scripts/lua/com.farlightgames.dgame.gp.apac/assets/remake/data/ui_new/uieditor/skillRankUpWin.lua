ed.uieditor = ed.uieditor or {}
ed.uieditor.skillRankUpWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(775.5, 186.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(0, 10, 0.5, 161),
      res = "UI/alpha/1080P/skill/new/skill_rankup_bg.png",
      name = "skill_rankup_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 262)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 349.5, h = 175},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill_rankup_bg",
      res = "UI/alpha/1080P/skill/new/skill_rankup_tattoo.png",
      name = "skill_icon_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(398.75, 184.75)
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
      parent = "skill_icon_bg",
      res = "UI/alpha/1080P/skill/skill_rank_2.png",
      name = "bg_skill_rank",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(176.75, 129.5)
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
      parent = "bg_skill_rank",
      res = "UI/alpha/1080P/skill/skill_rank_1.png",
      name = "frame_skill_rank",
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
      name = "skill_rank",
      z = 1,
      parent = "frame_skill_rank",
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
      fix_wh = {w = 58.5, h = 58},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "frame_skill_rank",
      res = "UI/alpha/1080P/skill/new/skill_rankup_light.png",
      name = "ImageView_22157",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill_icon_bg",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "skill_icon",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(174.75, 93)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(420, 38.5)
    },
    t = "Layer",
    base = {
      parent = "skill_rankup_bg",
      name = "skill_attr",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(191.25, 75.75)
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
      name = "skill_level",
      z = 1,
      parent = "skill_icon_bg",
      text = "lv.55",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(175.25, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156.5, h = 128},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill_icon_bg",
      res = "UI/alpha/1080P/skill/new/skill_icon_bg_2.png",
      name = "ImageView_22123",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(174.75, 87.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(447.5, 56.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "skill_uprank_desc_bg",
      z = 0,
      parent = "skill_rankup_bg",
      res = "UI/alpha/1080P/skill/new/skill_name_light.png",
      capInsets = CCRectMake(0, 5, 447.5, 45)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(387.75, 50.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11, h = 11},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill_uprank_desc_bg",
      res = "UI/alpha/1080P/skill/new/skill_rankup_point.png",
      name = "ImageView_22122",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42.25, 28.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(400, 25)
    },
    t = "Layer",
    base = {
      parent = "skill_uprank_desc_bg",
      name = "uprank_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(54.75, 15.75)
    }
  }
}
