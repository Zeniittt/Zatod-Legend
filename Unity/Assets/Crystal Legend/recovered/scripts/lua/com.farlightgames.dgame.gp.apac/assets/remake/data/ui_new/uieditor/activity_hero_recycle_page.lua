ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_hero_recycle_page = {
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
      res = "UI/alpha/1080P/activity/hero_recycle/hero_recycle_bg.jpg",
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
      fix_wh = {w = 850, h = 247.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/hero_recycle/hero_recycle_title.png",
      name = "image_title",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(681.5, 538)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 271.5, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/hero_recycle/hero_recycle_remaining_time_bg.png",
      name = "image_left_time",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(815.5, 523)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 230, h = 94.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/hero_recycle/hero_recycle_step_unselected.png",
      name = "btn_step1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(375, 466.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 230, h = 94.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/hero_recycle/hero_recycle_step_unselected.png",
      name = "btn_step2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(545, 466.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 230, h = 94.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/hero_recycle/hero_recycle_step_unselected.png",
      name = "btn_step3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(715, 466.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(480, 270)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_step1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(315, 160)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(480, 270)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_step2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(315, 160)
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
      name = "panel_hero_pos1",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(551.5, 275)
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
      name = "panel_hero_pos2",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(430, 260)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(480, 270)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_step3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(315, 160)
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
      name = "panel_hero_pos3",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(430, 260)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(480, 270)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_finish",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(315, 160)
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
      name = "panel_hero_pos_finish",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(551.5, 275)
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
      parent = "image_left_time",
      res = "UI/alpha/1080P/activity/hero_recycle/hero_recycle_remaining_time.png",
      name = "ImageView_7601",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.75, 13.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 248, 213),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_left_time",
      z = 0,
      parent = "image_left_time",
      text = T("\229\137\169\228\189\153 12\229\164\1696\230\151\182"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(84.25, 14)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 230, h = 94.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_step1",
      res = "UI/alpha/1080P/activity/hero_recycle/hero_recycle_step_selected.png",
      name = "btn_step1_select",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(115, 47.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 246, 202),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_step1",
      z = 1,
      parent = "btn_step1",
      text = T("\230\173\165\233\170\1641"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(123, 57.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 246, 202),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_step1_desc",
      z = 1,
      parent = "btn_step1",
      text = T("\233\128\137\230\139\169\233\135\141\231\148\159\231\154\132\232\139\177\233\155\132"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(123.5, 38.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 230, h = 94.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_step2",
      res = "UI/alpha/1080P/activity/hero_recycle/hero_recycle_step_selected.png",
      name = "btn_step2_select",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(115, 47.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 246, 202),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_step2",
      z = 1,
      parent = "btn_step2",
      text = T("\230\173\165\233\170\1642"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(123, 57.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 246, 202),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_step2_desc",
      z = 1,
      parent = "btn_step2",
      text = T("\229\164\132\231\144\134\233\135\141\231\148\159\229\137\141\228\186\139\233\161\185"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(123.5, 38.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 230, h = 94.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_step3",
      res = "UI/alpha/1080P/activity/hero_recycle/hero_recycle_step_selected.png",
      name = "btn_step3_select",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(115, 47.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 246, 202),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_step3",
      z = 1,
      parent = "btn_step3",
      text = T("\230\173\165\233\170\1643"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(123, 57.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 246, 202),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_step3_desc",
      z = 1,
      parent = "btn_step3",
      text = T("\231\161\174\232\174\164\232\191\148\232\191\152\231\154\132\232\181\132\230\186\144"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(123.5, 38.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 161.5, h = 161},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_step1",
      res = "UI/alpha/1080P/activity/hero_recycle/hero_recycle_hero_select_2.png",
      name = "image_hero_select_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(236.5, 171)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 83.5, h = 85},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_step1",
      res = "UI/alpha/1080P/activity/hero_recycle/hero_recycle_hero_select_1.png",
      name = "btn_hero_select",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(235.5, 170.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 266.5, h = 107},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_step1",
      res = "UI/alpha/1080P/activity/hero_recycle/hero_recycle_text_bg_1.png",
      name = "image_step1_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(242.5, 83.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 167.64997605, h = 50.3999928},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_step1",
      res = "UI/alpha/1080P/activity/activity_gift_btn_img.png",
      name = "btn_next1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(239, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 112.5, h = 114},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_step1",
      res = "UI/alpha/1080P/activity/hero_recycle/hero_recycle_hero_change.png",
      name = "btn_change",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(433, 171.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 167.64997605, h = 50.3999928},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_step2",
      res = "UI/alpha/1080P/activity/activity_gift_btn_img.png",
      name = "btn_next2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(525, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 167.64997605, h = 50.3999928},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_step2",
      res = "UI/alpha/1080P/activity/activity_gift_btn_img.png",
      name = "btn_previous2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(100, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(604, 227)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_condition_bg",
      z = 0,
      parent = "panel_step2",
      res = "UI/alpha/1080P/activity/hero_recycle/hero_recycle_list_bg.png",
      capInsets = CCRectMake(201, 72, 201, 72)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(360, 160.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(550, 217)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_item_bg",
      z = 0,
      parent = "panel_step3",
      res = "UI/alpha/1080P/activity/hero_recycle/hero_recycle_list_bg.png",
      capInsets = CCRectMake(200, 50, 200, 50)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(375, 165.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 167.64997605, h = 50.3999928},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_step3",
      res = "UI/alpha/1080P/activity/activity_gift_btn_img.png",
      name = "btn_next3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(525, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 167.64997605, h = 50.3999928},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_step3",
      res = "UI/alpha/1080P/activity/activity_gift_btn_img.png",
      name = "btn_previous3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(100, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 351, h = 107.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_finish",
      res = "UI/alpha/1080P/activity/hero_recycle/hero_recycle_text_bg_2.png",
      name = "ImageView_7685",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(237, 54)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 248, 228),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_7622",
      z = 0,
      parent = "image_step1_tips",
      text = T("\228\187\133\230\156\137"),
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53.25, 55.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 231, 44),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_recycle_times",
      z = 0,
      parent = "image_step1_tips",
      text = T("1\230\172\161"),
      size = 27
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104.75, 55.5)
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
      name = "label_next1",
      z = 0,
      parent = "btn_next1",
      text = T("\228\184\139\228\184\128\230\173\165"),
      size = 35
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(114.25, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 248, 228),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_7624",
      z = 0,
      parent = "image_step1_tips",
      text = T("\233\135\141\231\148\159\230\156\186\228\188\154"),
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(184.75, 54.5)
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
      name = "label_next2",
      z = 0,
      parent = "btn_next2",
      text = T("\228\184\139\228\184\128\230\173\165"),
      size = 35
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(114.25, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45, h = 46},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_change",
      res = "UI/alpha/1080P/summon/transform_btn.png",
      name = "ImageView_7636",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53.75, 57.5)
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
      name = "label_previous2",
      z = 0,
      parent = "btn_previous2",
      text = T("\228\184\138\228\184\128\230\173\165"),
      size = 35
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(114.25, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(407.5, 212.5)
    },
    t = "Layer",
    base = {
      parent = "image_condition_bg",
      name = "panel_condition_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(127, 8.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(430, 200)
    },
    t = "Layer",
    base = {
      parent = "image_item_bg",
      name = "panel_item_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(90, 8.5)
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
      name = "label_next3",
      z = 0,
      parent = "btn_next3",
      text = T("\228\184\139\228\184\128\230\173\165"),
      size = 35
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(114.25, 41.5)
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
      name = "label_previous3",
      z = 0,
      parent = "btn_previous3",
      text = T("\228\184\138\228\184\128\230\173\165"),
      size = 35
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(114.25, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 249, 194),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_finish",
      z = 0,
      parent = "ImageView_7685",
      text = T("\229\183\178\233\135\141\231\148\159\239\188\140\232\191\148\232\191\152\231\154\132\232\181\132\230\186\144\229\183\178\233\128\154\232\191\135\233\130\174\228\187\182\229\143\145\233\128\129"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(175.5, 55.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_7636",
      res = "UI/alpha/1080P/summon/transform.png",
      name = "ImageView_7635",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.5, 24)
    }
  }
}
