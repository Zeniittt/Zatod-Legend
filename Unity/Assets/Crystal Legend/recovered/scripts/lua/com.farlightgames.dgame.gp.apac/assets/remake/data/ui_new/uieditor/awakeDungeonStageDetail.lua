ed.uieditor = ed.uieditor or {}
ed.uieditor.awakeDungeonStageDetail = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 741, h = 428},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dungeon/dungeon_stage_bg.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 250.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 272.5, h = 88},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/dungeon/dungeon_stage_title.png",
      name = "title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(370.5, 442.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 236, 128),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "stage_name",
      z = 0,
      parent = "title",
      text = T("\228\184\187\229\185\178\233\129\147-1"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(134.25, 29.5)
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
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "stage_desc",
      z = 0,
      parent = "image_bg",
      text = T("\229\143\175\228\187\165\232\142\183\229\190\151"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(31, 370)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 165, 49),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "power_title",
      z = 0,
      parent = "image_bg",
      text = T("\232\131\189\233\135\143\230\182\136\232\128\151\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(108.5, 319)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 165, 49),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "power_number",
      z = 0,
      parent = "image_bg",
      text = "12",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(135.5, 319)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/icon/dungeon_energy.png",
      name = "power_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(175, 318.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 165, 49),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "efficiency_title",
      z = 0,
      parent = "image_bg",
      text = T("\230\137\171\232\141\161\230\149\136\231\142\135\230\143\144\229\141\135\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(133.5, 63)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 165, 49),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "enemy_title",
      z = 0,
      parent = "image_bg",
      text = T("\230\149\140\230\150\185\233\152\181\229\174\185\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(108.5, 249.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 165, 49),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "reward_title",
      z = 0,
      parent = "image_bg",
      text = T("\233\128\154\229\133\179\229\165\150\229\138\177\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(108.5, 160)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 192, h = 56.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/buttion_big.png",
      name = "challenge_button",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(616.5, 56)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 38, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/dungeon/boss/boss_esc.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(726, 415.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 291, h = 46},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/dungeon/dungeon_firstblood_frame.png",
      name = "image_first_blood",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(574.5, 312.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.95, x = 0.95},
      flip = "",
      opacity = 255,
      fix_wh = {w = 127.775, h = 23.75},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/dungeon/stageinfo/buff_icon_bg.png",
      name = "image_buff_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(627, 136.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "challenge_button",
      res = "UI/alpha/1080P/battle/battle_prepare_butt_fit_img.png",
      name = "go_button_img",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.5, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 240, 158),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "reset_label",
      z = 0,
      parent = "challenge_button",
      text = T("\230\140\145 \230\136\152"),
      size = 22
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(92.5, 30.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 62)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "enemy_panel",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(135, 215)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 62)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "reward_panel",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(135, 127.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 62)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "efficiency_panel",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(135, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 191, 18),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_23491",
      z = 0,
      parent = "image_first_blood",
      text = T("\233\166\150\233\128\154\232\128\133\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44.5, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(136, 126, 108),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "none_first_blood",
      z = 0,
      parent = "image_bg",
      text = T("\230\154\130\230\151\160\233\166\150\233\128\154\232\174\176\229\189\149"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(574.5, 312.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(40, 40)
    },
    t = "Layer",
    base = {
      parent = "image_first_blood",
      name = "panel_head",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(78.5, 3)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 191, 18),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_guild",
      z = 0,
      parent = "image_first_blood",
      text = T("\229\133\172\228\188\154\229\144\141\229\133\173\228\184\170\229\173\151"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(120, 13.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(125, 22)
    },
    t = "Layer",
    base = {
      parent = "image_first_blood",
      name = "panel_name",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(119.5, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_first_blood",
      res = "UI/alpha/1080P/dungeon/dungeon_firstblood_detail.png",
      name = "btn_first_blood_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(267, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(243, 192, 92),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_buff",
      z = 0,
      parent = "image_buff_bg",
      text = T("200%\229\188\186\229\140\150"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(36.75, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49.5, h = 45},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_buff_bg",
      res = "UI/alpha/1080P/dungeon/stageinfo/buff_icon.png",
      name = "ImageView_848",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(9.75, 11.5)
    }
  }
}
