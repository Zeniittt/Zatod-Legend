ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaAuditionSummaryWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 674, h = 492},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/cuparena/knockout/select_result_bg_qualify.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(482, 294)
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
      name = "node_content",
      z = 0,
      parent = "bg",
      text = "",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(337, 246)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 41.5, h = 29.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_content",
      res = "UI/alpha/1080P/cuparena/knockout/select_result_dec.png",
      name = "title_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.5, 110)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 371.5, h = 133},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_content",
      res = "UI/alpha/1080P/cuparena/knockout/select_result_notice_unqualify.png",
      name = "bg_qualify",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(118.5, -127.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 41.5, h = 29.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_content",
      res = "UI/alpha/1080P/cuparena/knockout/select_result_dec.png",
      name = "title_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(197.5, 110)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 171, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_content",
      res = "UI/alpha/1080P/cuparena/knockout/select_result_camp_info.png",
      name = "bg_camp_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-186.5, -138.5)
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
      name = "label_camp_rank",
      z = 0,
      parent = "bg_camp_rank",
      text = T("\233\152\181\232\144\165\230\142\146\229\144\141\239\188\154 1"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(29, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 249.5, h = 58},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_content",
      res = "UI/alpha/1080P/cuparena/knockout/select_result_camp_title.png",
      name = "bg_camp",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-187, 119)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 250, h = 250},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_content",
      res = "UI/alpha/1080P/cuparena/cuparena_camp_symbol_1.png",
      name = "img_camp_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-186.5, -13.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 171, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_content",
      res = "UI/alpha/1080P/cuparena/knockout/select_result_camp_info.png",
      name = "bg_camp_medal",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-187, -169)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 309.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_content",
      res = "UI/alpha/1080P/cuparena/knockout/select_result_info_bg.png",
      name = "bg_stage",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(116.5, 64)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 309.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_content",
      res = "UI/alpha/1080P/cuparena/knockout/select_result_info_bg.png",
      name = "bg_score",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(116.5, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 309.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_content",
      res = "UI/alpha/1080P/cuparena/knockout/select_result_info_bg.png",
      name = "bg_medal",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(116.5, -8)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 309.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_content",
      res = "UI/alpha/1080P/cuparena/knockout/select_result_info_bg.png",
      name = "bg_audition_camp_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(116.5, -44)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 309.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_content",
      res = "UI/alpha/1080P/cuparena/knockout/select_result_info_bg.png",
      name = "bg_audition_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(116.5, -80.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 46, h = 46},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_content",
      res = "UI/alpha/1080P/cuparena/knockout/select_result_quit_button.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(315, 155)
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
      name = "label_camp_medal",
      z = 0,
      parent = "bg_camp_medal",
      text = T("\233\152\181\232\144\165\230\142\146\229\144\141\239\188\154 1"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(29, 13.25)
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
      name = "label_stage_des",
      z = 0,
      parent = "bg_stage",
      text = T("\230\174\181\228\189\141\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(117.75, 15.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.7, x = 0.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 105, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_stage",
      res = "UI/alpha/1080P/cuparena/cuparena_rank_medal_1_name.png",
      name = "img_stage",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(154.25, 15)
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
      name = "label_score",
      z = 0,
      parent = "bg_score",
      text = T("\231\167\175\229\136\134\239\188\1541234"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(117.75, 15.5)
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
      name = "label_medal",
      z = 0,
      parent = "bg_medal",
      text = T("\229\139\139\231\171\160\239\188\1541234"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(117.75, 15.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 230, 122),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_audition_camp_rank",
      z = 0,
      parent = "bg_audition_camp_rank",
      text = T("\230\181\183\233\128\137\233\152\181\232\144\165\230\142\146\229\144\141\239\188\1541234"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(154.75, 15.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 230, 122),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_audition_rank",
      z = 0,
      parent = "bg_audition_rank",
      text = T("\230\181\183\233\128\137\230\128\187\230\142\146\229\144\141\239\188\1541234"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(154.75, 15.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.7, x = 0.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.5, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_camp_medal",
      res = "UI/alpha/1080P/toparena/toparena_star_icon_2.png",
      name = "img_camp_medal",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(139.5, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.7, x = 0.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.5, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_medal",
      res = "UI/alpha/1080P/toparena/toparena_star_icon_2.png",
      name = "img_my_medal",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(222.25, 15)
    }
  }
}
