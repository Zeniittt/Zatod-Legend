ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_adventure_stage_detail = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(741, 449)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(29.5, 130, 29.5, 130),
      res = "UI/alpha/1080P/common/com_new_2.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479, 248)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 650.5, h = 202.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activityadventure/adventure_stage_namebg_3.png",
      name = "title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(370, 427.5)
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
      name = "stage_name",
      z = 0,
      parent = "title",
      text = T("\229\134\146\233\153\169\229\133\179\229\141\1611"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(330.25, 120.25)
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
      name = "stage_desc",
      z = 0,
      parent = "image_bg",
      text = T("\229\133\179\229\141\161\228\191\161\230\129\175"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(31, 397.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.5, x = 1.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 41.25, h = 56.25},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/campaign/main/prevchap.png",
      name = "image_left_arrow",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.5, 270)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(691, 5)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_line1",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/campaign/campaign_detail_line_1.png",
      capInsets = CCRectMake(80, 1.5, 80, 1.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(371, 359)
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
      text = T("\230\140\145\230\136\152\230\182\136\232\128\151\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(30.5, 336)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.5, x = 1.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 41.25, h = 56.25},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/campaign/main/nextchap.png",
      name = "image_right_arrow",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(925, 270)
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
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(137, 336.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.5, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activityadventure/actvitality/adventure_vitality_icon_1.png",
      name = "power_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(182, 336.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(725.5, 74)
    },
    t = "Scale9Sprite",
    base = {
      name = "enemy_bg",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/campaign/campaign_detail_bg.png",
      capInsets = CCRectMake(241.5, 5, 241.5, 5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(370.5, 275.5)
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
      anchor = ccp(0, 0.5),
      position = ccp(30.5, 278)
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
      name = "award_title",
      z = 0,
      parent = "image_bg",
      text = T("\230\140\145\230\136\152\229\165\150\229\138\177\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(30.5, 186)
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
      name = "history_title",
      z = 0,
      parent = "image_bg",
      text = T("\229\142\134\229\143\178\230\156\128\233\171\152\229\138\160\230\136\144\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(29.5, 129)
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
      name = "history_number",
      z = 0,
      parent = "image_bg",
      text = "60%",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(155, 129)
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
      name = "sweep_title",
      z = 0,
      parent = "image_bg",
      text = T("\229\141\149\230\172\161\230\137\171\232\141\161\229\143\175\232\142\183\229\190\151\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(29.5, 102)
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
      name = "sweep_reward_number",
      z = 0,
      parent = "image_bg",
      text = "123",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(173.5, 102)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25, h = 20.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activityadventure/acttoken/adventure_token_icon_1.png",
      name = "sweep_reward_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(221, 101)
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
      position = ccp(607.5, 62)
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
      parent = "image_bg",
      res = "UI/alpha/1080P/common/button_com_big.png",
      name = "sweep_one_button",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(221.5, 58.5)
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
      parent = "image_bg",
      res = "UI/alpha/1080P/common/button_com_big.png",
      name = "sweep_some_button",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88, 58.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34, h = 14},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/campaign/campaign_detail_line_2_fa.png",
      name = "image_line2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(371.5, 145)
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
      anchor = ccp(0.5, 0.5),
      position = ccp(117.5, 30.25)
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
      name = "sweep_one_label",
      z = 0,
      parent = "sweep_one_button",
      text = T("\230\137\171\232\141\161"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.25, 26.75)
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
      name = "sweep_some_label",
      z = 0,
      parent = "sweep_some_button",
      text = T("\230\137\171\232\141\16110\230\172\161"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.25, 26.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(327.5, 14)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_line_left",
      z = 0,
      parent = "image_line2",
      res = "UI/alpha/1080P/campaign/campaign_detail_line_2_lin.png",
      capInsets = CCRectMake(35.5, 6.5, 35.5, 6.5)
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(0, 6.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(327.5, 14)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_line_right",
      z = 0,
      parent = "image_line2",
      res = "UI/alpha/1080P/campaign/campaign_detail_line_2_lin.png",
      capInsets = CCRectMake(35.5, 6.5, 35.5, 6.5)
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(34, 7)
    }
  }
}
