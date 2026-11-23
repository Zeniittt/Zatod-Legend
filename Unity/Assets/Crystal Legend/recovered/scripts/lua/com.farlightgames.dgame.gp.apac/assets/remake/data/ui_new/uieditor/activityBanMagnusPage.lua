ed.uieditor = ed.uieditor or {}
ed.uieditor.activityBanMagnusPage = {
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
      res = "UI/alpha/1080P/activity/ban_magnus/ban_magnus_bg.jpg",
      name = "bg",
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
      fix_wh = {w = 412, h = 172},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/activity/ban_magnus/ban_magnus_server_reward_bg.png",
      name = "server_progress_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(842.5, 396)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 383, h = 94.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/activity/ban_magnus/ban_magnus_title.png",
      name = "title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(832, 529)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 100,
      fix_wh = {w = 131.5, h = 24},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "title",
      res = "UI/alpha/1080P/activity/ban_magnus/ban_magnus_time.png",
      name = "left_time_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(92, 19.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 79, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/lottery/lottery_meat_bg.png",
      name = "item_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(726, 506)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 398, h = 348},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/activity/ban_magnus/ban_magnus_stage.png",
      name = "magnus_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(460, 385)
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
      name = "role_progress_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(380.5, 206)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 122.5, h = 120.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "server_progress_bg",
      res = "UI/alpha/1080P/activity/ban_magnus/ban_magnus_reward_bg_2.png",
      name = "reward_slot1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(145, 107.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 122.5, h = 120.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "server_progress_bg",
      res = "UI/alpha/1080P/activity/ban_magnus/ban_magnus_reward_bg_2.png",
      name = "reward_slot2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(263.5, 107.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90.5, h = 9.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "server_progress_bg",
      res = "UI/alpha/1080P/activity/ban_magnus/ban_magnus_got.png",
      name = "got_reward_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(204, 55)
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
      parent = "server_progress_bg",
      name = "server_progress_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(204, 37)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(376.5, 25)
    },
    t = "Scale9Sprite",
    base = {
      name = "server_progress_bg",
      z = 0,
      parent = "server_progress_bg",
      res = "UI/alpha/1080P/activity/ban_magnus/ban_magnus_server_progress_bar_1.png",
      capInsets = CCRectMake(7.5, 7.5, 14, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(206, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15.5, h = 15.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "left_time_bg",
      res = "UI/alpha/1080P/activity/ban_magnus/ban_magnus_time_icon.png",
      name = "left_time_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.25, 12)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 247, 214),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "left_time_label",
      z = 0,
      parent = "left_time_bg",
      text = T("\229\137\169\228\189\15312\229\164\1696\230\151\182"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(23.25, 12)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 29, h = 31},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_bg",
      res = "UI/alpha/1080P/activity/ban_magnus/ban_magnus_item.png",
      name = "item_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21, 17.75)
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
      name = "item_cnt_label",
      z = 0,
      parent = "item_bg",
      text = "12",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53, 16.75)
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
      parent = "magnus_bg",
      name = "magnus_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(198, 94)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(550, 7)
    },
    t = "Scale9Sprite",
    base = {
      name = "role_progress_bg",
      z = 0,
      parent = "role_progress_layer",
      res = "UI/alpha/1080P/activity/ban_magnus/ban_magnus_role_progress_bar_1.png",
      capInsets = CCRectMake(5, 2.5, 4, 2)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(44.5, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 71, h = 71},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "role_progress_layer",
      res = "UI/alpha/1080P/activity/ban_magnus/ban_magnus_role_progress_icon.png",
      name = "role_progress_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44.5, 58.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 148.5, h = 56},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "role_progress_layer",
      res = "UI/alpha/1080P/activity/ban_magnus/ban_magnus_button_blue.png",
      name = "btn_ban_one",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(202.5, -29)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 148.5, h = 56},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "role_progress_layer",
      res = "UI/alpha/1080P/activity/ban_magnus/ban_magnus_button_yellow.png",
      name = "btn_ban_ten",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(407.5, -29)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(225, 200)
    },
    t = "Layer",
    base = {
      parent = "magnus_bg",
      name = "magnus_panel",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(92.5, 92.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 98.5, h = 98.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "reward_slot1",
      res = "UI/alpha/1080P/activity/ban_magnus/ban_magnus_reward_bg_1.png",
      name = "reward_bg1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.25, 61.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 98.5, h = 98.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "reward_slot2",
      res = "UI/alpha/1080P/activity/ban_magnus/ban_magnus_reward_bg_1.png",
      name = "reward_bg2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.25, 61.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(239, 203, 111),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "got_reward_label",
      z = 0,
      parent = "got_reward_bg",
      text = T("\229\183\178\232\142\183\229\190\151"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.25, 4.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(294, 9)
    },
    t = "Scale9Sprite",
    base = {
      name = "server_progress_bar",
      z = 0,
      parent = "server_progress_bg",
      res = "UI/alpha/1080P/activity/ban_magnus/ban_magnus_server_progress_bar_2.png",
      capInsets = CCRectMake(5, 4.5, 16.5, 0.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(8.75, 12)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 240),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "server_target_label",
      z = 0,
      parent = "server_progress_bg",
      text = T("2000\228\184\135"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(304.25, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(14, 7)
    },
    t = "Scale9Sprite",
    base = {
      name = "role_progress_bar",
      z = 0,
      parent = "role_progress_bg",
      res = "UI/alpha/1080P/activity/ban_magnus/ban_magnus_role_progress_bar_2.png",
      capInsets = CCRectMake(5, 2, 4, 3)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0, 3.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 22.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "total_cnt_bg",
      z = 0,
      parent = "role_progress_icon",
      res = "UI/alpha/1080P/activity/ban_magnus/ban_magnus_role_progress_text_bg_1.png",
      capInsets = CCRectMake(10, 10, 23.5, 2.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.5, -10.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 29, h = 31},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_ban_one",
      res = "UI/alpha/1080P/activity/ban_magnus/ban_magnus_item.png",
      name = "ban_one_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(31.75, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(30, 61, 88),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "ban_one_label",
      z = 0,
      parent = "btn_ban_one",
      text = "x1",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(50.75, 29)
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
      parent = "btn_ban_one",
      name = "ban_one_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(104.75, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 29, h = 31},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_ban_ten",
      res = "UI/alpha/1080P/activity/ban_magnus/ban_magnus_item.png",
      name = "ban_ten_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(31.75, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(80, 52, 13),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "ban_ten_label",
      z = 0,
      parent = "btn_ban_ten",
      text = "x10",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(50.75, 29)
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
      parent = "btn_ban_ten",
      name = "ban_ten_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(104.75, 28)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 224, 128),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "total_cnt_label",
      z = 0,
      parent = "total_cnt_bg",
      text = "123",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35, 11.25)
    }
  }
}
