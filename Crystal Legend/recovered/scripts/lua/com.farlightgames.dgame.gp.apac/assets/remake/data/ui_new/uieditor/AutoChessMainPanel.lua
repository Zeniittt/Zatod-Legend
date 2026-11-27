ed.uieditor = ed.uieditor or {}
ed.uieditor.AutoChessMainPanel = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {name = "bg", z = 0},
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
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_bottom",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(480, 0)
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
      parent = "layer_bottom",
      name = "layer_hero",
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
      fix_wh = {w = 85.5, h = 85},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_hero",
      res = "UI/alpha/1080P/chess/battle/bag_bg.png",
      name = "img_slot_1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-317, 49)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 85.5, h = 85},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_hero",
      res = "UI/alpha/1080P/chess/battle/bag_bg.png",
      name = "img_slot_2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-229, 49)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 133, h = 143},
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
      normal = "UI/alpha/1080P/chess/battle/main_shop.png",
      name = "btn_shop",
      z = 0,
      parent = "layer_bottom",
      text = "",
      press = "UI/alpha/1080P/chess/battle/main_shop.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(425, 60)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 85.5, h = 85},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_hero",
      res = "UI/alpha/1080P/chess/battle/bag_bg.png",
      name = "img_slot_3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-141, 49)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 85.5, h = 85},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_hero",
      res = "UI/alpha/1080P/chess/battle/bag_bg.png",
      name = "img_slot_4",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-53.5, 49)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(50, 50)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_right",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(479.5, 540)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 101.5, h = 42},
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = false,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_undo",
      z = 0,
      parent = "layer_bottom",
      text = "",
      press = "UI/alpha/1080P/common/button_com_mini.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(277.5, 127.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 85.5, h = 85},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_hero",
      res = "UI/alpha/1080P/chess/battle/bag_bg.png",
      name = "img_slot_5",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.5, 49)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33.6, h = 33.6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "img_gold_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.5, 31.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 85.5, h = 85},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_hero",
      res = "UI/alpha/1080P/chess/battle/bag_bg.png",
      name = "img_slot_6",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(123, 49)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 210, 53),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_gold",
      z = 0,
      parent = "btn_shop",
      text = "0",
      size = 33
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(71, 31.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 101.5, h = 42},
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = false,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_reset",
      z = 0,
      parent = "layer_bottom",
      text = "",
      press = "UI/alpha/1080P/common/button_com_mini.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55.5, 127.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 85.5, h = 85},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_hero",
      res = "UI/alpha/1080P/chess/battle/bag_bg.png",
      name = "img_slot_7",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(210.5, 49)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 85.5, h = 85},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_hero",
      res = "UI/alpha/1080P/chess/battle/bag_bg.png",
      name = "img_slot_8",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(298.5, 49)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      fix_wh = {w = 43.2, h = 44},
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
      normal = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_quit",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/common/break_butt_bj.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-39.5, 507)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 130.5, h = 167},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_bottom",
      res = "UI/alpha/1080P/chess/battle/lv_icon.png",
      name = "bg_role",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-437, 75)
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
      name = "label_round",
      z = 0,
      parent = "layer_right",
      text = T("\231\172\1721\229\155\158\229\144\136"),
      size = 20
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(569, -15.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 96.5, h = 96.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_hero",
      res = "UI/alpha/1080P/chess/battle/bag_select_2.png",
      name = "img_slot_select",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-317, 49)
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
      name = "label_next",
      z = 0,
      parent = "btn_undo",
      text = T("\228\184\139\228\184\128\230\173\165"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 101.5, h = 42},
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = false,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_npc",
      z = 0,
      parent = "layer_bottom",
      text = "",
      press = "UI/alpha/1080P/common/button_com_mini.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(165.5, 127.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(194, 285)
    },
    t = "Layer",
    base = {
      parent = "layer_right",
      name = "layer_oppo_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(391.5, -367.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45, h = 187},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/tag_mian_bg.png",
      name = "bg_btn_tag",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-41, 384.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 200,
      fix_wh = {w = 136, h = 41},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_bottom",
      res = "UI/alpha/1080P/chess/battle/chess_equip_bg.png",
      name = "img_pet_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-227, 124.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 149,
      fix_wh = {w = 171.5, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_right",
      res = "UI/alpha/1080P/chess/battle/challenge_playername_bg.png",
      name = "img_oppo_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(498, -55.5)
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
      name = "label_reset",
      z = 0,
      parent = "btn_reset",
      text = T("\232\191\152\229\142\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 127.5, h = 47},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_bottom",
      res = "UI/alpha/1080P/chess/battle/chess_icon_bg.png",
      name = "img_chess_limit_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-354.5, 129)
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
      name = "layer_center",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(480, 270)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39.5, h = 40},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_bottom",
      res = "UI/alpha/1080P/chess/battle/shop_tips_normal.png",
      name = "btn_win_tip",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(385.5, 99)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_quit",
      res = "UI/alpha/1080P/common/break_butt.png",
      name = "ImageView_3150",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
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
      name = "label_exp_progress",
      z = 7,
      parent = "bg_role",
      text = "12/50",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63.25, 53)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19.5999972, h = 19.5999972},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_role",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "img_cost_icon",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(31.25, 31.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(261.5, 185)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_gold_tip",
      z = 1,
      parent = "layer_bottom",
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      capInsets = CCRectMake(10, 10, 19, 201.5)
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(121.5, 116)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 204, 43),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_cost",
      z = 10,
      parent = "bg_role",
      text = "4",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44.75, 31.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 210, 53),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_role_level",
      z = 10,
      parent = "bg_role",
      text = T("5\231\186\167"),
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.25, 79)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(80, 60)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "btn_power",
      z = 3
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-58.5, 160)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 91, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_role",
      res = "UI/alpha/1080P/chess/battle/chess_EXP.png",
      name = "img_exp_progress",
      z = 6
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(17.25, 53)
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
      name = "label_reset",
      z = 0,
      parent = "btn_npc",
      text = "NPC",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 192, 118),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_target",
      z = 10,
      parent = "img_oppo_bg",
      text = T("\233\154\143\230\156\186\231\142\169\229\174\182"),
      size = 20
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(110.25, 28.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(208, 197, 162),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_exp_add",
      z = 0,
      parent = "bg_role",
      text = T("\231\130\185\229\135\187\232\180\173\228\185\176"),
      size = 12
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(49.75, 31.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.599999964, x = 0.599999964},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.899998326, h = 26.99999838},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_oppo_bg",
      res = "UI/alpha/1080P/raid/challenging_icon.png",
      name = "img_target_tip",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(139.75, 25.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 38, h = 51.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_btn_tag",
      res = "UI/alpha/1080P/chess/battle/chess_data.png",
      name = "ImageView_7022",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23, 87.5)
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
      name = "label_pet_num",
      z = 0,
      parent = "img_pet_bg",
      text = "0",
      size = 25
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(74, 20.5)
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
      name = "label_pet_equip",
      z = 0,
      parent = "img_pet_bg",
      text = "0",
      size = 25
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(59.5, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 38, h = 51.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_btn_tag",
      res = "UI/alpha/1080P/chess/battle/chess_data_close.png",
      name = "ImageView_7023",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.5, 87.5)
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
      name = "Label_15195",
      z = 0,
      parent = "img_pet_bg",
      text = "/",
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 54.5, h = 54.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "img_pet_bg",
      res = "UI/alpha/1080P/chess/battle/chess_equip_select.png",
      name = "img_pet_bag_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19.5, 21)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(45, 61.5)
    },
    t = "Layer",
    base = {
      parent = "bg_btn_tag",
      name = "btn_open_damage",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0.5, 62.5)
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
      name = "Label_13623",
      z = 0,
      parent = "img_chess_limit_bg",
      text = "/",
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65, 18.5)
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
      name = "label_hero_cur",
      z = 0,
      parent = "img_chess_limit_bg",
      text = "0",
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(174.5, 275)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_damage_bg",
      z = 0,
      parent = "bg_btn_tag",
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      capInsets = CCRectMake(10, 10, 20, 200)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(131.5, -3.5)
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
      name = "label_hero_limit",
      z = 0,
      parent = "img_chess_limit_bg",
      text = "0",
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.5, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 758.5, h = 78},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_center",
      res = "UI/alpha/1080P/chess/battle/loser_bg.png",
      name = "img_round_start_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-10, 158.5)
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
      name = "Label_7028",
      z = 0,
      parent = "btn_win_tip",
      text = "0",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19.75, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 464, h = 48},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_center",
      res = "UI/alpha/1080P/chess/battle/start_bg.png",
      name = "img_oppo_info_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-10, 158.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 758.5, h = 78},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_center",
      res = "UI/alpha/1080P/chess/battle/loser_bg.png",
      name = "img_battle_start_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-10, 158.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53, h = 53},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_gold_tip",
      res = "UI/alpha/1080P/chess/battle/tag_select.png",
      name = "btn_win_tip_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(266, -12)
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
      name = "label_gold_tip",
      z = 0,
      parent = "bg_gold_tip",
      text = T("\233\135\145\229\184\129\232\175\180\230\152\142"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55, 157.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 247, h = 80.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_center",
      res = "UI/alpha/1080P/chess/battle/phase_preparation_bg.png",
      name = "img_prepare_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-10, 230)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 232, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_gold_tip1",
      z = 0,
      parent = "bg_gold_tip",
      text = T("\233\135\145\229\184\129\230\152\175\231\148\168\230\157\165\232\180\173\228\185\176\232\139\177\233\155\132\239\188\140\229\141\135\231\186\167\228\186\186\229\143\163\229\146\140\229\136\183\230\150\176\229\149\134\229\186\151\231\154\132\229\159\186\231\161\128\232\181\132\230\186\144"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(18.5, 130.5)
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
      name = "Label_10191",
      z = 0,
      parent = "bg_gold_tip",
      text = T("\229\159\186\231\161\128"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37, 73)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 464, h = 48},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_center",
      res = "UI/alpha/1080P/chess/battle/start_bg.png",
      name = "img_battle_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-10, 150)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 52, h = 52},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_power",
      res = "UI/alpha/1080P/chess/heropower/heropower_bg.png",
      name = "icon_power",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, 30)
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
      name = "Label_10191_Copy0",
      z = 0,
      parent = "bg_gold_tip",
      text = T("\229\136\169\230\129\175"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(126.5, 73)
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
      name = "Label_10191_Copy1",
      z = 0,
      parent = "bg_gold_tip",
      text = T("\232\191\158\232\180\165"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(217, 73)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 758.5, h = 78},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_center",
      res = "UI/alpha/1080P/chess/battle/loser_bg.png",
      name = "img_battle_lose_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-10, 158.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25, h = 26.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_power",
      res = "UI/alpha/1080P/common/add_big.png",
      name = "btn_select_power",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.7999972, h = 16.7999972},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_gold_tip",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "ImageView_10194",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(30.5, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.7999972, h = 16.7999972},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_gold_tip",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "ImageView_10194_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 464, h = 48},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_center",
      res = "UI/alpha/1080P/chess/battle/start_bg.png",
      name = "img_wait_info_bg",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-10, 158.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(176.5, 42.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_power_detail",
      z = 0,
      parent = "btn_power",
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      capInsets = CCRectMake(10, 20, 19, 181.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(87, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.7999972, h = 16.7999972},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_gold_tip",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "ImageView_10194_Copy1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(210, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 206, 15),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_gold_base",
      z = 0,
      parent = "bg_gold_tip",
      text = "+5",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 758.5, h = 78},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_center",
      res = "UI/alpha/1080P/chess/battle/winer_bg.png",
      name = "img_battle_victory_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-10, 158.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 235, 96),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_823",
      z = 1,
      parent = "btn_power",
      text = "1/3",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, 30)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 206, 15),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_gold_add",
      z = 0,
      parent = "bg_gold_tip",
      text = "+5",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(138, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 206, 15),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_gold_extra",
      z = 0,
      parent = "bg_gold_tip",
      text = "+5",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(229, 45.5)
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
      parent = "layer_center",
      name = "Panel_207",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-10, 222)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(171, 275)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_damage",
      z = 1,
      parent = "img_damage_bg",
      res = "UI/alpha/1080P/chess/battle/chess_data_bg_colour_1.png",
      capInsets = CCRectMake(50, 50, 71, 5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88.25, 136.5)
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
      name = "label_gain_title",
      z = 0,
      parent = "img_round_start_bg",
      text = T("\232\142\183\229\190\151\239\188\154"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(251.75, 20)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_round_start_bg",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "ImageView_12173",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(290.75, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 210, 53),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_gain_gold",
      z = 0,
      parent = "img_round_start_bg",
      text = "0",
      size = 21
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(417.25, 21)
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
      name = "label_award_title",
      z = 0,
      parent = "img_round_start_bg",
      text = T("\229\136\169\230\129\175\239\188\154"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(365.75, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_round_start_bg",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "ImageView_12174",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(401.25, 20)
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
      name = "label_oppo_title",
      z = 0,
      parent = "img_oppo_info_bg",
      text = T("\229\141\179\229\176\134\232\191\142\230\136\152\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(197, 24)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 210, 53),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_total_gold",
      z = 0,
      parent = "img_round_start_bg",
      text = "0",
      size = 21
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(306.25, 20)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 192, 103),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_oppe_type",
      z = 0,
      parent = "img_oppo_info_bg",
      text = T("\233\154\143\230\156\186\231\142\169\229\174\182"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(239.5, 24)
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
      name = "label_failed",
      z = 0,
      parent = "img_round_start_bg",
      text = T("\232\191\158\232\131\156\239\188\154"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(474.25, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_round_start_bg",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "ImageView_12175",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(507.75, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 210, 53),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_failed_gold",
      z = 0,
      parent = "img_round_start_bg",
      text = "0",
      size = 21
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(524.75, 20.5)
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
      name = "label_battle_start_round",
      z = 0,
      parent = "img_battle_start_bg",
      text = T("\231\172\172 1 \229\155\158\229\144\136"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(379.25, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 120, 78),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_5395",
      z = 0,
      parent = "img_round_start_bg",
      text = T("\229\155\158\229\144\136\229\188\128\229\167\139"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(379.25, 50.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 243, 113),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_5394",
      z = 0,
      parent = "img_battle_start_bg",
      text = T("\230\136\152\230\150\151\229\188\128\229\167\139"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(379.25, 56.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(119, 255, 91),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_stage",
      z = 10,
      parent = "img_prepare_bg",
      text = T("\229\135\134\229\164\135\233\152\182\230\174\181"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(124, 65.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 76, h = 60},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "icon_power",
      res = "UI/alpha/1080P/chess/heropower/frame_1.png",
      name = "ImageView_647",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26, 26)
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
      name = "label_timer",
      z = 10,
      parent = "img_prepare_bg",
      text = "12",
      size = 40
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(123.5, 34.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(164, 227)
    },
    t = "Layer",
    base = {
      parent = "img_damage",
      name = "Panel_damage_list_1",
      z = 10
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(2, 9.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(164, 227)
    },
    t = "Layer",
    base = {
      parent = "img_damage",
      name = "Panel_damage_list_2",
      z = 10
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(2, 9)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(119, 255, 91),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_damage_title",
      z = 0,
      parent = "img_damage",
      text = T("\230\136\145\230\150\185\228\188\164\229\174\179"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(72, 258)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(163.5, 33.5)
    },
    t = "Layer",
    base = {
      parent = "img_damage",
      name = "btn_damage",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(3, 241)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(74, 117, 204),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_5392",
      z = 0,
      parent = "img_battle_lose_bg",
      text = T("\233\152\178\229\174\136\229\164\177\232\180\165"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(379.25, 39)
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
      name = "power_detail",
      z = 0,
      parent = "bg_power_detail",
      text = T("2\229\155\158\229\144\136\229\144\142\232\167\163\233\148\129\232\139\177\233\155\132\232\131\189\229\138\155"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(15, 23.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.2, h = 19.8},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_damage",
      res = "UI/alpha/1080P/chess/battle/chess_data_name_1.png",
      name = "icon_switch",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(128, 257)
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
      name = "label_wait_title",
      z = 0,
      parent = "img_wait_info_bg",
      text = T("\231\173\137\229\190\133\229\133\182\228\187\150\231\142\169\229\174\182\231\187\147\230\157\159\230\136\152\230\150\151"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(232, 24)
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
      name = "label_victory_gold_title",
      z = 5,
      parent = "img_battle_victory_bg",
      text = T("\232\142\183\229\190\151\239\188\154"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(356.75, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_battle_victory_bg",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "ImageView_12173_Copy0",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(390.25, 18)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 210, 53),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_victory_gain_gold",
      z = 5,
      parent = "img_battle_victory_bg",
      text = "0",
      size = 21
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(405.75, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 120, 78),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_5393",
      z = 0,
      parent = "img_battle_victory_bg",
      text = T("\233\152\178\229\174\136\232\131\156\229\136\169"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(379.25, 56.5)
    }
  }
}
