ed.uieditor = ed.uieditor or {}
ed.uieditor.awakeDungeonSpecialStageDetail = {
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
      res = "UI/alpha/1080P/dungeon/stageinfo/special_level_bg.png",
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
      fix_wh = {w = 529, h = 99},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/dungeon/stageinfo/shader.png",
      name = "ImageView_1077",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(375.5, 377.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 628, h = 74.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/dungeon/stageinfo/special_title.png",
      name = "title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(375.5, 434.5)
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
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(309.5, 33.25)
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
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "stage_desc",
      z = 0,
      parent = "image_bg",
      text = T("\229\156\186\229\156\176\230\149\136\230\158\156\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(28, 355.5)
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
      position = ccp(575.5, 357.5)
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
      position = ccp(625.5, 124)
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
      scaleSize = CCSizeMake(700, 230)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_content",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(19, 99)
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
      parent = "title",
      res = "UI/alpha/1080P/dungeon/stageinfo/info.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(418, 32.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 671.5, h = 76},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_content",
      res = "UI/alpha/1080P/dungeon/stageinfo/enemy_bg.png",
      name = "bg_enemy",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350, 181)
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
      name = "condition_title",
      z = 0,
      parent = "panel_content",
      text = T("\232\142\183\232\131\156\230\157\161\228\187\182\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(90, 113.5)
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
      parent = "panel_content",
      text = T("\230\149\140\230\150\185\228\191\161\230\129\175\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(90, 183.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 694, h = 7},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/dungeon/stageinfo/line.png",
      name = "img_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(370, 97)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 694, h = 7},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/dungeon/stageinfo/line.png",
      name = "img_line_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(370, 331)
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
      position = ccp(575.5, 357.5)
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
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(580, 102)
    },
    t = "Layer",
    base = {
      parent = "panel_content",
      name = "enemy_panel",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(97.5, 129.5)
    }
  }
}
