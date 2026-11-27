ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaMatchBaseScene = {
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
      name = "panel_content",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 400)
    },
    t = "Layer",
    base = {name = "panel_left", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(39, 75.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(350, 35.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(50, 0, 40, 35.5),
      res = "UI/alpha/1080P/crusade/bg_title_crusade.png",
      name = "bg_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(259, 502.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 59.4, h = 59.4},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_left",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37, 290.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 59.4, h = 59.4},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_left",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37, 217.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 59.4, h = 59.4},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_left",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_record",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37, 149)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 59.4, h = 59.4},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_left",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_grades",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36, 77.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 59.4, h = 59.4},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_left",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_timeline",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37, 6)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 59.4, h = 59.4},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_left",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_honor",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37, 364)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(5, 100)
    },
    t = "Layer",
    base = {
      name = "panel_right",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(952.5, 228.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.5, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_title",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(258.5, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.111, x = 1.111},
      flip = "",
      opacity = 255,
      fix_wh = {w = 61.105, h = 54.439},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_rank",
      res = "UI/alpha/1080P/pvp/ranking.png",
      name = "icon_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 37)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1.111, x = 1.111},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_rank",
      z = 0,
      parent = "btn_rank",
      text = T("\230\142\146\232\161\140\230\166\156"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33.5, 5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.111, x = 1.111},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47.773, h = 41.107},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_reward",
      res = "UI/alpha/1080P/pvp/reward.png",
      name = "icon_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 33)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1.111, x = 1.111},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_reward",
      z = 0,
      parent = "btn_reward",
      text = T("\229\165\150\229\138\177"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33.5, 6)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.111, x = 1.111},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51.106, h = 41.6625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_record",
      res = "UI/alpha/1080P/pvp/record.png",
      name = "icon_record",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.5, 30)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1.111, x = 1.111},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_record",
      z = 0,
      parent = "btn_record",
      text = T("\232\174\176\229\189\149"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.111, x = 1.111},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.329, h = 48.3285},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_grades",
      res = "UI/alpha/1080P/toparena/toparena_history_icon.png",
      name = "icon_grades",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 29)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1.111, x = 1.111},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_grades",
      z = 0,
      parent = "btn_grades",
      text = T("\230\136\152\231\187\169"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.111, x = 1.111},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51.6615, h = 56.1055},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_timeline",
      res = "UI/alpha/1080P/cuparena/cuparena_schedule_enter.png",
      name = "icon_timeline",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34, 30.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1.111, x = 1.111},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_timeline",
      z = 0,
      parent = "btn_timeline",
      text = T("\230\151\182\233\151\180\232\161\168"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(31, 5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.111, x = 1.111},
      flip = "",
      opacity = 255,
      fix_wh = {w = 61.105, h = 50.5505},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_honor",
      res = "UI/alpha/1080P/cuparena/cuparena_honor_enter.png",
      name = "icon_honor",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 31.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1.111, x = 1.111},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_honor",
      z = 0,
      parent = "btn_honor",
      text = T("\229\144\141\228\186\186\229\160\130"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33.5, 5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 14.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_reward",
      res = "UI/alpha/1080P/cuparena/cuparena_reward_redpoint.png",
      name = "img_reward_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.5, 51.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 14.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_record",
      res = "UI/alpha/1080P/cuparena/cuparena_reward_redpoint.png",
      name = "img_record_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.5, 51.5)
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
      parent = "btn_rule",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "icon_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.25, 13.25)
    }
  }
}
