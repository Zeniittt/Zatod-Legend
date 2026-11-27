ed.uieditor = ed.uieditor or {}
ed.uieditor.hades_reward_item = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 775, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activityadventure/adventure_reward_bg1.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_desc",
      z = 0,
      parent = "image_bg",
      text = T("\230\148\182\233\155\1341234"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(33, 45)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(300, 75)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "reward_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(269.5, 6.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 124.5, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/button_com_big.png",
      name = "btn_get_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(675.5, 44.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(128.5, 51)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "btn_uncomplete",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(611.5, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 126, h = 74},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activityadventure/adventure_reward_finish.png",
      name = "btn_complete",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(675.5, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(240, 230, 167),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1225",
      z = 0,
      parent = "btn_get_reward",
      text = T("\233\162\134\229\143\150"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.25, 26.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 124.5, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_uncomplete",
      res = "UI/alpha/1080P/common/button_grey.png",
      name = "image",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.5, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(235, 224, 202),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1230",
      z = 0,
      parent = "btn_uncomplete",
      text = T("\230\156\170\229\174\140\230\136\144"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.5, 25.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(220, 179, 123),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1225",
      z = 0,
      parent = "btn_complete",
      text = T("\229\183\178\229\174\140\230\136\144"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63, 38.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 54.5, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/summon/hero_new_tag.png",
      name = "image_new",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.5, 73)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 779, h = 93},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/hades/hades_preview_bg.png",
      name = "image_bg_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 221, 145),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_new_task_tips",
      z = 0,
      parent = "image_bg_tips",
      text = T("\231\131\173\229\138\155\230\140\145\230\136\152\228\187\187\229\138\161\229\176\134\229\156\16810\230\156\13631\230\151\165\229\143\145\229\184\131"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(393, 47)
    }
  }
}
