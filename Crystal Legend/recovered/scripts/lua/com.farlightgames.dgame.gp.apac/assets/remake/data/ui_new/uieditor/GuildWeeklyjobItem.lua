ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildWeeklyjobItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(622, 85)
    },
    t = "Layer",
    base = {
      name = "Panel_55735",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-311, -42.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(622, 85)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg",
      z = 0,
      parent = "Panel_55735",
      res = "UI/alpha/1080P/guild/guild_clash_rank/info_my_floor.png",
      capInsets = CCRectMake(100, 20, 161.5, 41.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(311, 42.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(622, 85)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg2",
      z = 0,
      parent = "Panel_55735",
      res = "UI/alpha/1080P/crusade/bg_replay_item.png",
      capInsets = CCRectMake(100, 20, 161.5, 41.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(311, 42.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 239, 214),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "name_txt",
      z = 0,
      parent = "Panel_55735",
      text = T("\229\155\162\230\156\172\230\148\187\230\137\147\228\184\128"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(14, 62.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(72, 56, 43),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "des_txt",
      z = 0,
      parent = "Panel_55735",
      text = T("\228\187\187\229\138\161\229\134\133\229\174\185\230\143\143\232\191\176\230\150\135\230\156\172\239\188\140\229\164\167\230\166\130"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(14, 38.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 140, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_55735",
      res = "UI/alpha/1080P/guild/guild_weektask/line_do.png",
      name = "line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83.5, 48.5)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(102, 39),
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/package/btn_package2.png",
      capInsets = CCRectMake(20, 12.5, 37.5, 10.5),
      name = "get_btn",
      z = 0,
      parent = "Panel_55735",
      text = "",
      press = "UI/alpha/1080P/package/btn_package2.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(547, 44)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 191.5, h = 9.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_55735",
      res = "UI/alpha/1080P/taskModel/day_task/day_task_progress_1.png",
      name = "pro_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108.5, 19)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(191.5, 9.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "pro_img",
      z = 0,
      parent = "Panel_55735",
      res = "UI/alpha/1080P/taskModel/day_task/day_task_progress_2.png",
      capInsets = CCRectMake(5, 2, 181.5, 1)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(12.5, 19)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(102, 39),
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/package/btn_package1.png",
      capInsets = CCRectMake(20, 12.5, 37.5, 10.5),
      name = "go_btn",
      z = 0,
      parent = "Panel_55735",
      text = "",
      press = "UI/alpha/1080P/package/btn_package1.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(547.5, 44)
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
      name = "pro_txt",
      z = 0,
      parent = "Panel_55735",
      text = "3/3",
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(109, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 70)
    },
    t = "Layer",
    base = {
      parent = "Panel_55735",
      name = "reward_panel",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(373.5, 6.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 116.5, h = 59},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_55735",
      res = "UI/alpha/1080P/guild/guild_weektask/background_done.png",
      name = "complete_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(549.5, 42.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 127,
      visible = true,
      scaleSize = CCSizeMake(622, 85)
    },
    t = "Scale9Sprite",
    base = {
      name = "mask_img",
      z = 1,
      parent = "Panel_55735",
      res = "UI/alpha/1080P/skilltower/bg_had_get_mask.png",
      capInsets = CCRectMake(20, 20, 513, 47)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(311, 42.5)
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
      name = "complete_txt",
      z = 0,
      parent = "complete_bg",
      text = T("\229\183\178\229\174\140\230\136\144"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(30.75, 30)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 252, 219),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "get_txt",
      z = 0,
      parent = "get_btn",
      text = T("\233\162\134\229\143\150"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 252, 219),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "go_txt",
      z = 0,
      parent = "go_btn",
      text = T("\229\137\141\229\190\128"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51, 19.5)
    }
  }
}
