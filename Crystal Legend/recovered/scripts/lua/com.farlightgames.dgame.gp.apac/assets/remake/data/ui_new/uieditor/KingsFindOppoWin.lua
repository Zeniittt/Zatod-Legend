ed.uieditor = ed.uieditor or {}
ed.uieditor.KingsFindOppoWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 731, h = 273},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/ob/07_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 267)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35, h = 5.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newkingspvp/battleprepare/battleprepare_match_player_cursor.png",
      name = "ImageView_839",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(459.5, 252.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 35, h = 5.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newkingspvp/battleprepare/battleprepare_match_player_cursor.png",
      name = "ImageView_839_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(272.5, 252.5)
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
      name = "label_title",
      z = 0,
      parent = "bg",
      text = T("\229\183\178\230\137\190\229\136\176\229\175\185\229\177\128"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(365.5, 253.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.50000012, x = 1.50000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 185.25001482, h = 31.50000252},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newkingspvp/battlerecord/battle_record_player_name_bg.png",
      name = "bg_name_blue",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(225.5, 121)
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
      name = "label_guild_tips_blue",
      z = 0,
      parent = "bg",
      text = T("\229\133\172  \228\188\154:"),
      size = 17
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(227.5, 73.5)
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
      name = "label_server_tips_blue",
      z = 0,
      parent = "bg",
      text = T("\230\156\141\229\138\161\229\153\168:"),
      size = 17
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(227.5, 47)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 209, 130),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_server_blue",
      z = 0,
      parent = "bg",
      text = T("\230\156\141\229\138\161\229\153\168\229\144\141"),
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(245.5, 47)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 209, 130),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_guild_blue",
      z = 0,
      parent = "bg",
      text = T("\230\156\170\229\138\160\229\133\165\229\133\172\228\188\154"),
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(246, 73.5)
    }
  },
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
      parent = "bg",
      name = "panel_head_blue",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(178.5, 126)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 209, 130),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_guild_red",
      z = 0,
      parent = "bg",
      text = T("\230\156\170\229\138\160\229\133\165\229\133\172\228\188\154"),
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(531.5, 74)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 209, 130),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_server_red",
      z = 0,
      parent = "bg",
      text = T("\230\156\141\229\138\161\229\153\168\229\144\141"),
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(531, 47.5)
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
      name = "label_server_tips_red",
      z = 0,
      parent = "bg",
      text = T("\230\156\141\229\138\161\229\153\168:"),
      size = 17
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(513, 47.5)
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
      name = "label_guild_tips_red",
      z = 0,
      parent = "bg",
      text = T("\229\133\172  \228\188\154:"),
      size = 17
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(513, 74)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.50000012, x = 1.50000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 185.25001482, h = 31.50000252},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newkingspvp/battlerecord/battle_record_player_name_bg.png",
      name = "bg_name_red",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(505.5, 121)
    }
  },
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
      parent = "bg",
      name = "panel_head_red",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(453.5, 126)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4, x = 0.4},
      flip = "",
      opacity = 255,
      fix_wh = {w = 78.8, h = 205.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_count_vs.png",
      name = "image_vs",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(365.5, 140.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 71.5, h = 71.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_task_bg1.png",
      name = "grade_icon_bg_blue",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(121.5, 59.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 71.5, h = 71.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_task_bg1.png",
      name = "grade_icon_bg_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(414, 59.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.3, x = 0.3},
      flip = "",
      opacity = 255,
      fix_wh = {w = 110.1, h = 78.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "grade_icon_bg_blue",
      res = "UI/alpha/1080P/newkingspvp/rank/rank_8.png",
      name = "grade_icon_blue",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.75, 35.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.3, x = 0.3},
      flip = "",
      opacity = 255,
      fix_wh = {w = 110.1, h = 78.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "grade_icon_bg_red",
      res = "UI/alpha/1080P/newkingspvp/rank/rank_8.png",
      name = "grade_icon_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.75, 35.75)
    }
  }
}
