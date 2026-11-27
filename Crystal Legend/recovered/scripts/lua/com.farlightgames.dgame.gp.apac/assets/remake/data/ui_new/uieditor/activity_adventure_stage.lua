ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_adventure_stage = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(209, 177)
    },
    t = "Layer",
    base = {name = "stage_bg", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 209, h = 177},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage_bg",
      res = "UI/alpha/1080P/campaign/key_stages/stage-4.png",
      name = "image_stage_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104.5, 88.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 188.5, h = 67.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage_bg",
      res = "UI/alpha/1080P/activityadventure/adventure_stage_namebg_1.png",
      name = "stage_name_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.5, 32.5)
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
      name = "stage_name",
      z = 2,
      parent = "stage_bg",
      text = T("\229\134\146\233\153\169-1"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.5, 43)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 211, 109),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "recommend_level",
      z = 2,
      parent = "stage_bg",
      text = T("\230\142\168\232\141\144\231\173\137\231\186\167 10"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.5, 24.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 188.5, h = 67.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage_bg",
      res = "UI/alpha/1080P/activityadventure/adventure_stage_namebg_2.png",
      name = "stage_name_selected_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.5, 32.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32, h = 32},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage_bg",
      res = "UI/alpha/1080P/activityadventure/adventure_stage_lock.png",
      name = "image_lock",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24, 31)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 209, h = 177},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage_bg",
      res = "UI/alpha/1080P/campaign/key_stages/stage-4-current.png",
      name = "image_stage_current",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104.5, 88.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 209, h = 177},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage_bg",
      res = "UI/alpha/1080P/campaign/key_stages/stage-4-locked.png",
      name = "image_stage_locked",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104.5, 88.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 209, h = 177},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage_bg",
      res = "UI/alpha/1080P/campaign/key_stages/stage-4-passed.png",
      name = "image_stage_passed",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104, 88)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 52, h = 67},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage_bg",
      res = "UI/alpha/1080P/campaign/main/campaign_stage_arrow.png",
      name = "image_current_tag",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(100.5, 180.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 154.5, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage_bg",
      res = "UI/alpha/1080P/activityadventure/adventure_stage_countdown.png",
      name = "image_countdown_locked",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104.5, 69)
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
      name = "label_countdown_locked",
      z = 0,
      parent = "image_countdown_locked",
      text = T("2\230\151\1656\230\151\182\229\144\142\229\188\128\229\144\175"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(77.25, 12.25)
    }
  }
}
