ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_adventure_scene = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 332, h = 62},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activityadventure/adventure_title.png",
      name = "image_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(234, 510.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.5, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_title",
      res = "UI/alpha/1080P/summon/rule_btn.png",
      name = "btn_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(303.5, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 9, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_tips",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "ImageView_176",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(15.75, 15.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 430, h = 41},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activityadventure/adventure_time_bg.png",
      name = "left_time_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 33.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {
      name = "drag_container",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "left_time_bg",
      res = "UI/alpha/1080P/activity/login_gift/login_gift_item_icon.png",
      name = "image_time",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(142, 21)
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
      name = "left_time",
      z = 0,
      parent = "left_time_bg",
      text = T("7\230\156\13630\230\151\16505\230\151\182\231\187\147\230\157\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(162.5, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 109.5, h = 97},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/hades/hades_heat_enter.png",
      name = "btn_heat_entry",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(75, 61)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 70.5, h = 72},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/campaign/campaign_map_bg_1.png",
      name = "btn_addition",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(766.5, 44.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 70.5, h = 72},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/campaign/campaign_map_bg_1.png",
      name = "btn_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(878, 44.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_heat_entry",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "image_heat_enter_reddot",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(77.75, 80.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 253, 195),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_heat_name",
      z = 0,
      parent = "btn_heat_entry",
      text = T("\229\156\176\231\139\177\229\165\145\231\186\166"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49.75, 11.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 98, h = 20.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_addition",
      res = "UI/alpha/1080P/campaign/campaign_map_bg.png",
      name = "ImageView_50042",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.25, 11)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_addition",
      z = 2,
      parent = "btn_addition",
      text = T("\229\138\160\230\136\144\228\184\128\232\167\136"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.25, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 77, h = 85},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_addition",
      res = "UI/alpha/1080P/activityadventure/adventure_bonus_icon.png",
      name = "ImageView_52689",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(30.25, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_reward",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "image_red_point",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.75, 61.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 98, h = 20.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_reward",
      res = "UI/alpha/1080P/campaign/campaign_map_bg.png",
      name = "ImageView_50046",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.25, 11.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_reward",
      z = 2,
      parent = "btn_reward",
      text = T("\229\134\146\233\153\169\229\165\150\229\138\177"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.25, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 82, h = 70.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_reward",
      res = "UI/alpha/1080P/activityadventure/adventure_reward.png",
      name = "ImageView_52690",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.75, 42.5)
    }
  }
}
