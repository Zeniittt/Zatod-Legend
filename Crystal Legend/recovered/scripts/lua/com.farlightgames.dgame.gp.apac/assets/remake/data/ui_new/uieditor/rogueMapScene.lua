ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueMapScene = {
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
      res = "UI/alpha/1080P/rogue/instance/instance_bg.jpg",
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
      fix_wh = {w = 90.5, h = 90.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_function_icon_bg.png",
      name = "btn_global",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87, 185)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 85, h = 85},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_global",
      res = "UI/alpha/1080P/rogue/instance/instance_function_global_buff.png",
      name = "icon_global",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.25, 45.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 84.5, h = 31},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_global",
      res = "UI/alpha/1080P/rogue/instance/instance_function_name.png",
      name = "global_name_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.25, 11.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90.5, h = 90.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_function_icon_bg.png",
      name = "btn_team",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87, 272.5)
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
      name = "label_global",
      z = 0,
      parent = "global_name_bg",
      text = T("\232\131\140\230\153\175\232\174\190\229\174\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42.25, 19)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90.5, h = 90.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_function_icon_bg.png",
      name = "btn_bag",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87, 362.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 85, h = 85},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_team",
      res = "UI/alpha/1080P/rogue/instance/instance_function_team.png",
      name = "icon_team",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.25, 45.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 84.5, h = 31},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_team",
      res = "UI/alpha/1080P/rogue/instance/instance_function_name.png",
      name = "team_name_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.25, 11.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 248.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/crusade/bg_title_crusade.png",
      name = "image_title_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(213, 594.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(271, 30.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "left_time_bg",
      z = 1,
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_time_bg.png",
      capInsets = CCRectMake(93.5, 10, 93.5, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1011.5, 157.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 85, h = 85},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_bag",
      res = "UI/alpha/1080P/rogue/instance/instance_function_bag.png",
      name = "icon_bag",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.25, 45.25)
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
      name = "label_team",
      z = 0,
      parent = "team_name_bg",
      text = T("\233\152\159\228\188\141"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42.25, 19)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 84.5, h = 31},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_bag",
      res = "UI/alpha/1080P/rogue/instance/instance_function_name.png",
      name = "bag_name_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.25, 11.75)
    }
  },
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
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/map/map_chapter_1.png",
      name = "image_map_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(585, 360)
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
      name = "btn_go",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(585, 175)
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
      parent = "image_title_bg",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(191.75, 17.75)
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
      name = "label_bag",
      z = 0,
      parent = "bag_name_bg",
      text = T("\230\159\165\231\156\139\231\165\157\231\166\143"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42.25, 19)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 289, h = 29.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_progress.png",
      name = "image_tips_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(585, 601.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 17, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "left_time_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_time_icon.png",
      name = "left_time_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49, 15.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 238, 125),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_left_time",
      z = 0,
      parent = "left_time_bg",
      text = "00:00:00",
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(131, 15.25)
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
      name = "btn_end",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(585, 175)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(202, 181, 158),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_left_time_tips",
      z = 0,
      parent = "left_time_bg",
      text = T("\229\144\142\230\140\145\230\136\152\231\187\147\230\157\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(180, 15.25)
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
      name = "ImageView_27775",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.25, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.2, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90.5, 592.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 35.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_retry_bg",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/lottery/lottery_meat_bg.png",
      capInsets = CCRectMake(25, 12.5, 25, 12.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(930, 605.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 35.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_pearl_bg",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/lottery/lottery_meat_bg.png",
      capInsets = CCRectMake(25, 12.5, 25, 12.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1041, 605.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 241, 161),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_go",
      z = 0,
      parent = "btn_go",
      text = T("\231\187\167\231\187\173\229\137\141\232\191\155"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(118.5, 29.75)
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
      parent = "btn_go",
      res = "UI/alpha/1080P/battle/battle_prepare_butt_fit_img.png",
      name = "ImageView_55760",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43, 28.25)
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
      name = "label_tips",
      z = 0,
      parent = "image_tips_bg",
      text = "0/0",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(144.5, 14.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 241, 161),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_end",
      z = 0,
      parent = "btn_end",
      text = T("\231\187\147\230\157\159\230\184\184\231\142\169"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96, 29.75)
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
      parent = "btn_back",
      res = "UI/alpha/1080P/common/break_butt.png",
      name = "ImageView_51626",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_retry_bg",
      res = "UI/alpha/1080P/rogue/instance/rogue_retry.png",
      name = "retry_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17, 18.25)
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
      name = "retry_amount",
      z = 0,
      parent = "image_retry_bg",
      text = "88888",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62, 17.75)
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
      parent = "image_pearl_bg",
      res = "UI/alpha/1080P/icon/pearl.png",
      name = "pearl_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17, 18.25)
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
      name = "pearl_amount",
      z = 0,
      parent = "image_pearl_bg",
      text = "88888",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90.5, h = 90.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_function_icon_bg.png",
      name = "btn_charm",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87, 455)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 35.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_reborn_bg",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/lottery/lottery_meat_bg.png",
      capInsets = CCRectMake(25, 12.5, 25, 12.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(819, 605.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 85, h = 85},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_charm",
      res = "UI/alpha/1080P/rogue/instance/instance_charm_icon.png",
      name = "icon_charm",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.25, 45.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 84.5, h = 31},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_charm",
      res = "UI/alpha/1080P/rogue/instance/instance_function_name.png",
      name = "charm_name_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.25, 11.75)
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
      parent = "image_reborn_bg",
      res = "UI/alpha/1080P/rogue/instance/rogue_reborn.png",
      name = "reborn_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17, 18.25)
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
      name = "reborn_amount",
      z = 0,
      parent = "image_reborn_bg",
      text = "88888",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62, 17.75)
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
      name = "label_charm",
      z = 0,
      parent = "charm_name_bg",
      text = T("\230\138\164\231\172\166\231\154\174\232\162\139"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42.25, 19)
    }
  }
}
