ed.uieditor = ed.uieditor or {}
ed.uieditor.hades_task_window = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/hades/hades_task_bg_new.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479, 270)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 308, h = 97},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/hades/hades_task_title.png",
      name = "image_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(628.5, 547)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(215, 337)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_task_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(144, 173)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(25, 25)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_task_name",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(476.5, 470.5)
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
      name = "label_total_heat_tips",
      z = 0,
      parent = "image_bg",
      text = T("\230\128\187\231\131\173\229\138\155\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(842, 470.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 12.5, h = 20.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/hades/hades_task_subtitle.png",
      name = "image_dec_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(543, 470.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 12.5, h = 20.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/hades/hades_task_subtitle.png",
      name = "image_dec_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(407.5, 470.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 29.5, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/hades/hades_task_heat_icon.png",
      name = "image_heat_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(853.5, 469)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 244, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_total_heat",
      z = 0,
      parent = "image_bg",
      text = "12345",
      size = 25
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(866.5, 470.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(528, 29.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_desc_bg",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/hades/hades_task_des.png",
      capInsets = CCRectMake(176, 9.5, 176, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(653.5, 426.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 563, h = 1.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/hades/hades_task_line.png",
      name = "image_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(669, 394.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(550, 140)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_task_heat",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(401.5, 251.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 565, h = 85},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/hades/hades_task_reward_1.png",
      name = "image_reward_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(671.5, 201)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/hades/hades_task_arrow.png",
      name = "image_task_arrow_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(273, 151)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 171.5, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/hades/hades_task_advance_bg.png",
      name = "image_advance_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(272.5, 488.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39, h = 39},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/hades/hades_task_close_button.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(975, 553.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(169, 132, 102),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_desc",
      z = 0,
      parent = "image_desc_bg",
      text = T("\228\187\187\229\138\161\230\143\143\232\191\176"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(264, 14.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 214, 90),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_6195",
      z = 0,
      parent = "image_reward_bg",
      text = T("\229\165\150\229\138\177\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48, 42.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(325, 60)
    },
    t = "Layer",
    base = {
      parent = "image_reward_bg",
      name = "panel_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(85, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 126, h = 74},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_reward_bg",
      res = "UI/alpha/1080P/hades/hades_task_finish_symbol.png",
      name = "image_task_finish",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(486, 42.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 124.5, h = 50.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_reward_bg",
      res = "UI/alpha/1080P/common/button_com_big.png",
      name = "btn_get_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(485, 42.5)
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
      parent = "image_reward_bg",
      res = "UI/alpha/1080P/common/button_com_big.png",
      name = "btn_trace",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(485, 42.5)
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
      name = "label_advance_tips",
      z = 0,
      parent = "image_advance_tips",
      text = T("\228\184\139\230\172\161\230\155\180\230\150\176\228\187\187\229\138\16110\230\156\13630\230\151\165"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(85.75, 21)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(208, 173, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_finish",
      z = 0,
      parent = "image_task_finish",
      text = T("\229\183\178\233\162\134\229\143\150"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63, 37)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 214, 90),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_get_reward",
      z = 0,
      parent = "btn_get_reward",
      text = T("\233\162\134\229\143\150"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.25, 26.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 214, 90),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_trace",
      z = 0,
      parent = "btn_trace",
      text = T("\232\191\189\232\184\170\228\187\187\229\138\161"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.25, 26.25)
    }
  }
}
