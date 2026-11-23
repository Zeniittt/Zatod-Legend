ed.uieditor = ed.uieditor or {}
ed.uieditor.awakeDungeonBossDetail = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 508.5, h = 342},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dungeon/boss/boss_skill_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(478, 271.5)
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
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_9.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88.75, 288.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(222, 214, 129),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "name",
      z = 0,
      parent = "bg",
      text = T("BOSS\229\144\141\229\173\151"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(133.75, 309)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 59.5, h = 59.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/DOTA-ITEM/2654.jpg",
      name = "skill1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(86.75, 193)
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
      name = "desc",
      z = 0,
      parent = "bg",
      text = "Text Label",
      size = 15
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(133.75, 294)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(222, 214, 129),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "skillname",
      z = 0,
      parent = "bg",
      text = T("\230\138\128\232\131\189\229\144\141\231\167\176"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(65.75, 137)
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
      name = "skilldesc",
      z = 0,
      parent = "bg",
      text = "skilldesc",
      size = 14
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(67.75, 113)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 59.5, h = 59.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/DOTA-ITEM/2654.jpg",
      name = "skill2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(171.25, 193)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 59.5, h = 59.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/DOTA-ITEM/2654.jpg",
      name = "skill3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(256.25, 193)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 59.5, h = 59.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/DOTA-ITEM/2654.jpg",
      name = "skill4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(341.25, 193)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 59.5, h = 59.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/DOTA-ITEM/2654.jpg",
      name = "skill5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(426.25, 193)
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
      parent = "skill1",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "frame1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35, 35)
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
      parent = "skill1",
      res = "UI/alpha/1080P/common/frame/equip_frame_selected.png",
      name = "select1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35, 35)
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
      parent = "skill2",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "frame2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35, 35)
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
      parent = "skill2",
      res = "UI/alpha/1080P/common/frame/equip_frame_selected.png",
      name = "select2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35, 35)
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
      parent = "skill3",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "frame3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35, 35)
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
      parent = "skill3",
      res = "UI/alpha/1080P/common/frame/equip_frame_selected.png",
      name = "select3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35, 35)
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
      parent = "skill4",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "frame4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35, 35)
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
      parent = "skill4",
      res = "UI/alpha/1080P/common/frame/equip_frame_selected.png",
      name = "select4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35, 35)
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
      parent = "skill5",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "frame5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35, 35)
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
      parent = "skill5",
      res = "UI/alpha/1080P/common/frame/equip_frame_selected.png",
      name = "select5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35, 35)
    }
  }
}
