ed.uieditor = ed.uieditor or {}
ed.uieditor.kingsBanPickScene = {
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
      res = "UI/alpha/1080P/newkingspvp/pickhero/select_bg.jpg",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 270)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 119, h = 459},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/pickhero/select_bg_3.png",
      name = "player_info_blue",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(66.5, 266)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 119, h = 459},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/pickhero/select_bg_4.png",
      name = "player_info_red",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(894, 266)
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
      parent = "player_info_blue",
      name = "panel_head_icon_blue",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(59.5, 442.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 122, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "player_info_blue",
      res = "UI/alpha/1080P/newkingspvp/pickhero/select_bg_6.png",
      name = "player_name_bg_blue",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(59.5, 411)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 165.5, h = 64},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/pickhero/select_light_1.png",
      name = "image_time_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 491.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(75, 362.5)
    },
    t = "Layer",
    base = {
      parent = "player_info_blue",
      name = "panel_pick_hero_blue",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(22.5, 36.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 183, h = 410.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "player_info_blue",
      res = "UI/alpha/1080P/newkingspvp/battleprepare/battleprepare_current_blue.png",
      name = "image_cur_blue",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(59.5, 284)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 205, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/pickhero/select_bg_5.png",
      name = "image_backup_time_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 453.5)
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
      parent = "player_info_red",
      name = "panel_head_icon_red",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(59.5, 442.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 122, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "player_info_red",
      res = "UI/alpha/1080P/newkingspvp/pickhero/select_bg_6.png",
      name = "player_name_bg_red",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(59.5, 411)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 135.5, h = 6},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/pickhero/select_line.png",
      name = "image_title_left",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(324, 521.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(75, 362.5)
    },
    t = "Layer",
    base = {
      parent = "player_info_red",
      name = "panel_pick_hero_red",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(22.5, 36.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 183, h = 410.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "player_info_red",
      res = "UI/alpha/1080P/newkingspvp/battleprepare/battleprepare_current_red.png",
      name = "image_cur_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(59.5, 283.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 135.5, h = 6},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/pickhero/select_line.png",
      name = "image_title_right",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(635.5, 521.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 253, 232),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_time",
      z = 0,
      parent = "image_time_bg",
      text = "20",
      size = 43
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82.75, 32)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 253, 232),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 18,
      text = T("\232\175\183\231\186\162\230\150\185\230\140\145\233\128\1372\228\184\170\232\139\177\233\155\132"),
      name = "label_title",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 520)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(237.5, 50)
    },
    t = "Layer",
    base = {
      name = "panel_ban_hero_blue",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(132.5, 441)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 135),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_backup_time",
      z = 0,
      parent = "image_backup_time_bg",
      text = T("\229\164\135\231\148\168\230\151\182\233\151\180\239\188\15420\231\167\146"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.5, 11.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(237.5, 50)
    },
    t = "Layer",
    base = {
      name = "panel_ban_hero_red",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(591.5, 441)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(702, 366.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(17.5, 122, 17.5, 122),
      res = "UI/alpha/1080P/newkingspvp/pickhero/select_bg_2.png",
      name = "hero_pool_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(482.5, 256.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(655, 260)
    },
    t = "Layer",
    base = {
      name = "panel_hero_pool",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(153, 151.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(693.5, 59)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(19.5, 12, 11, 12),
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan.png",
      name = "image_btn_filter_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 117)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 210.5, h = 51},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/pickhero/select_button.png",
      name = "btn_confirm",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(482.5, 42.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(690, 351.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(12, 12, 12, 12),
      res = "UI/alpha/1080P/newkingspvp/pickhero/shade.png",
      name = "image_lock",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 260)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 366},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/newkingspvp/pickhero/select_light_2.png",
      name = "image_ban_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(585, 536)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_btn_filter_bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "line_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.75, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_btn_filter_bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "line_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(641.75, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_btn_filter_bg",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_1.png",
      name = "btn_all",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(121.75, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_btn_filter_bg",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_1.png",
      name = "btn_front",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(196.75, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_btn_filter_bg",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_1.png",
      name = "btn_middle",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(271.75, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 253, 232),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_confirm",
      z = 0,
      parent = "btn_confirm",
      text = T("\231\161\174\232\174\164\233\128\137\230\139\169"),
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(103.25, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_btn_filter_bg",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_1.png",
      name = "btn_back",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(346.75, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 210.5, h = 51},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_confirm",
      res = "UI/alpha/1080P/newkingspvp/pickhero/select_button_shade.png",
      name = "btn_confirm_lock",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105.25, 25.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 314, h = 36.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_lock",
      res = "UI/alpha/1080P/newkingspvp/pickhero/select_bg_7.png",
      name = "image_lock_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(345, 207.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 98, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/ob/01_bg.png",
      name = "image_win_count_blue",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(187, 506.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 98, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/ob/02_bg.png",
      name = "image_win_count_red",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(773.5, 506.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 381.5, h = 86.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/ob/shadow.png",
      name = "image_ob_tips",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(482.5, 42.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(84, 53)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(20, 0, 124, 0.5),
      res = "UI/alpha/1080P/newkingspvp/chat/chat_tag_main.png",
      name = "image_chat_selection_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(170.5, 48.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_all",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_2.png",
      name = "btn_all_select",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
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
      name = "label_all",
      z = 0,
      parent = "btn_all",
      text = T("\229\133\168\233\131\168"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_front",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_2.png",
      name = "btn_front_select",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
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
      name = "label_front",
      z = 0,
      parent = "btn_front",
      text = T("\229\137\141\230\142\146"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_middle",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_2.png",
      name = "btn_middle_select",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
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
      name = "label_middle",
      z = 0,
      parent = "btn_middle",
      text = T("\228\184\173\230\142\146"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_back",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_2.png",
      name = "btn_back_select",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
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
      name = "label_back",
      z = 0,
      parent = "btn_back",
      text = T("\229\144\142\230\142\146"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_btn_filter_bg",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_1.png",
      name = "btn_int",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(571.75, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_btn_filter_bg",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_1.png",
      name = "btn_agi",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(496.75, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_btn_filter_bg",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_1.png",
      name = "btn_str",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(421.75, 27.5)
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
      name = "label_lock",
      z = 0,
      parent = "image_lock_tips",
      text = T("\229\175\185\230\150\185\230\173\163\229\156\168\233\128\137\230\139\169"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(157, 18.25)
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
      name = "label_win_count_blue",
      z = 0,
      parent = "image_win_count_blue",
      text = T("\232\131\156\229\156\186\239\188\1540"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(13, 11.5)
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
      name = "label_win_count_red",
      z = 0,
      parent = "image_win_count_red",
      text = T("\232\131\156\229\156\186\239\188\1540"),
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(85, 11.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(189, 220)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_chat_sticker_bg",
      z = 2,
      parent = "image_chat_selection_bg",
      res = "UI/alpha/1080P/newkingspvp/chat/chat_tag_main.png",
      capInsets = CCRectMake(20, 25, 124, 0.5)
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_chat_selection_bg",
      res = "UI/alpha/1080P/newkingspvp/chat/chat_tag_sticker_1.png",
      name = "btn_chat_sticker",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_chat_selection_bg",
      res = "UI/alpha/1080P/newkingspvp/chat/chat_tag_sticker_2.png",
      name = "image_chat_sticker_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_int",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_2.png",
      name = "btn_int_select",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
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
      name = "label_int",
      z = 0,
      parent = "btn_int",
      text = T("\230\149\143\230\141\183"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_agi",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_2.png",
      name = "btn_agi_select",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
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
      name = "label_agi",
      z = 0,
      parent = "btn_agi",
      text = T("\230\153\186\229\138\155"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_str",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_2.png",
      name = "btn_str_select",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
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
      name = "label_str",
      z = 0,
      parent = "btn_str",
      text = T("\229\138\155\233\135\143"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(225, 225, 225),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 15,
      text = T("BP\233\152\182\230\174\181\228\184\141\230\152\190\231\164\186\229\175\185\230\150\185\230\137\128\231\169\191\228\188\160\229\165\135\232\163\133\229\164\135"),
      name = "label_legend_equip_tips",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 421.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(174, 203)
    },
    t = "Layer",
    base = {
      parent = "image_chat_sticker_bg",
      name = "panel_sticker",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(7.5, 11)
    }
  }
}
