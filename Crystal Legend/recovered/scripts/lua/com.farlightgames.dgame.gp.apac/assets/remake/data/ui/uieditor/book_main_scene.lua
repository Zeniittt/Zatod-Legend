ed.uieditor = ed.uieditor or {}
ed.uieditor.book_main_scene = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(690.63, 439.06)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(78.13, 78.13, 0.78, 0.78),
      res = "UI/alpha/HVGA/bookOTB/bookOTB_bg.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(400.78, 232.81)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 57.8125, h = 58.59375},
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
      normal = "UI/alpha/1080P/common/backbtn.png",
      name = "btn_back",
      z = 1,
      text = "",
      press = "UI/alpha/1080P/common/backbtn-disabled.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42.19, 436.72)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(117.19, 51.56),
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
      normal = "UI/alpha/HVGA/task_button.png",
      name = "btn_team",
      z = 1,
      capInsets = CCRectMake(15.63, 15.63, 0.78, 0.78),
      text = "",
      press = "UI/alpha/HVGA/task_button_press.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(656.25, 117.19)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 620.3125, h = 228.125},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/bookOTB/bookOTB_bookBg.png",
      name = "image_book_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(400, 300.78)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 194.53125, h = 47.65625},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/chef/chef_title_bg.png",
      name = "image_title_bar",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(402.34, 442.19)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(45.31, 45.31),
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
      normal = "UI/alpha/HVGA/task_button.png",
      name = "btn_rule",
      z = 1,
      capInsets = CCRectMake(21.09, 23.44, 31.25, 23.44),
      text = "",
      press = "UI/alpha/HVGA/task_button_press.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(246.09, 442.19)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 102,
      visible = true,
      scaleSize = CCSizeMake(234.38, 42.97)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(40.63, 18.75, 0.78, 17.19),
      res = "UI/alpha/1080P/common/main_vit_tips.png",
      name = "image_ticket_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(624.22, 439.84)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(171.88, 51.56),
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
      normal = "UI/alpha/HVGA/task_button.png",
      name = "btn_fight",
      z = 1,
      capInsets = CCRectMake(15.63, 15.63, 0.78, 0.78),
      text = "",
      press = "UI/alpha/HVGA/task_button_press.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(590.63, 94.53)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(289.06, 66.41)
    },
    t = "Layer",
    base = {
      name = "node_reward",
      z = 5
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(146.09, 35.94)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 39.84375, h = 58.59375},
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
      normal = "UI/alpha/HVGA/herodetail_arrow_left.png",
      name = "btn_prev",
      z = 2,
      parent = "image_book_bg",
      text = "",
      press = "UI/alpha/HVGA/herodetail_arrow_left.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.13, 107.81)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 39.84375, h = 58.59375},
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
      normal = "UI/alpha/HVGA/herodetail_arrow_right.png",
      name = "btn_next",
      z = 2,
      parent = "image_book_bg",
      text = "",
      press = "UI/alpha/HVGA/herodetail_arrow_right.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(585.94, 107.81)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(241, 193, 113),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "lab_reward_tip",
      z = 0,
      parent = "image_bg",
      text = T("\229\165\150\229\138\177:"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(39.06, 80.47)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(507.81, 210.94)
    },
    t = "Layer",
    base = {
      parent = "image_book_bg",
      name = "clippingLayer",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(51.56, 9.38)
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
      name = "lab_quest_des",
      z = 0,
      parent = "image_bg",
      text = T("\230\182\136\231\129\173\229\133\168\233\131\168\230\149\140\228\186\186\230\182\136"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(91.41, 131.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(241, 193, 113),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "lab_quest_tip",
      z = 0,
      parent = "image_bg",
      text = T("\228\187\187\229\138\161:"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(39.06, 130.47)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(625, 23.44)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_progress_bg",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/HVGA/bookOTB/bookOTB_progressbarBg.png",
      capInsets = CCRectMake(78.13, 10.16, 0.78, 0.78)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(347.66, 155.47)
    }
  },
  {
    config = {
      rotation = 90,
      fix_scale = {y = 0.5, x = 0.25},
      flip = "",
      opacity = 255,
      fix_wh = {w = 97.65625, h = 1.953125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/HVGA/herodetail_delimiter.png",
      name = "ImageView_80",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(385.94, 83.59)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 206, 16),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_team",
      z = 0,
      parent = "btn_team",
      text = T("\231\187\132\233\152\159"),
      size = 24
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(50.78, 25.78)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 99.21875, h = 29.6875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_title_bar",
      res = "UI/alpha/HVGA/bookOTB/bookOTB_title.png",
      name = "image_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97.27, 23.83)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.34375, h = 36.71875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_team",
      res = "UI/alpha/HVGA/battledone_push_guildraid.png",
      name = "ImageView_72",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27.34, 25.78)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 142.1875, h = 161.71875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "clippingLayer",
      res = "UI/alpha/HVGA/bookOTB/bookOTB_Chapter_Book1_2.png",
      name = "image_chapter_a",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.13, 87.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.84375, h = 27.34375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_rule",
      res = "UI/alpha/HVGA/artifact/artifact_rune_exclamation_1.png",
      name = "image_btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.66, 21.88)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 142.1875, h = 161.71875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "clippingLayer",
      res = "UI/alpha/HVGA/bookOTB/bookOTB_Chapter_Book1.png",
      name = "image_chapter_b",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(253.91, 114.06)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 142.1875, h = 161.71875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "clippingLayer",
      res = "UI/alpha/HVGA/bookOTB/bookOTB_Chapter_Book1_2.png",
      name = "image_chapter_c",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(429.69, 87.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 142.1875, h = 161.71875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "clippingLayer",
      res = "UI/alpha/HVGA/bookOTB/bookOTB_Chapter_Book1_2.png",
      name = "image_chapter_d",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(596.88, 85.94)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(241, 193, 113),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "lab_ticket_tip",
      z = 0,
      parent = "image_ticket_bg",
      text = T("\229\139\135\232\128\133\228\185\139\229\191\131"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.41, 24.61)
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
      name = "lab_ticket",
      z = 0,
      parent = "image_ticket_bg",
      text = "1/2",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(92.19, 24.61)
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
      parent = "image_ticket_bg",
      res = "UI/alpha/HVGA/bookOTB/bookOTB_ticketBg.png",
      name = "image_ticket_bg_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(125, 24.61)
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
      parent = "image_ticket_bg",
      res = "UI/alpha/HVGA/bookOTB/bookOTB_ticketBg.png",
      name = "image_ticket_bg_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(154.69, 24.61)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.21875, h = 22.65625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_ticket_bg",
      res = "UI/alpha/HVGA/bookOTB/bookOTB_ticket.png",
      name = "image_ticket_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(125, 23.83)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 206, 16),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_fight",
      z = 0,
      parent = "btn_fight",
      text = T("\231\187\167\231\187\173\229\134\146\233\153\169"),
      size = 24
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(59.38, 25.78)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.21875, h = 22.65625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_ticket_bg",
      res = "UI/alpha/HVGA/bookOTB/bookOTB_ticket.png",
      name = "image_ticket_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(154.69, 24.61)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 29.6875, h = 34.375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_fight",
      res = "UI/alpha/HVGA/bookOTB/bookOTB_enterButton.png",
      name = "ImageView_72",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(31.25, 25.78)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(625, 31.25)
    },
    t = "Layer",
    base = {
      parent = "image_progress_bg",
      name = "progress_clipping_node",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, -3.13)
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
      name = "lab_progress_percent",
      z = 0,
      parent = "image_progress_bg",
      text = "35%",
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(312.5, 11.72)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(623.44, 21.88)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_progress",
      z = 0,
      parent = "progress_clipping_node",
      res = "UI/alpha/HVGA/bookOTB/bookOTB_progressbar.png",
      capInsets = CCRectMake(78.13, 10.16, 0.78, 0.78)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(312.5, 14.84)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(195.31, 85.94)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(39.06, 23.44, 0.78, 0.78),
      res = "UI/alpha/1080P/common/main_vit_tips.png",
      name = "image_ticket_tip_bg",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(403.13, 353.91)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(241, 193, 113),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tip1",
      z = 0,
      parent = "image_ticket_tip_bg",
      text = T("\231\180\175\232\174\161\232\191\155\229\186\166\239\188\1541000/2000"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(11.72, 27.34)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(175.78, 39.06)
    },
    t = "Layer",
    base = {
      parent = "image_ticket_tip_bg",
      name = "node_tip2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(10.16, 69.53)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(70.31, 50.78),
      flip = "",
      labelConfig = {
        color = ccc3(255, 234, 198)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/stageselect_difficulty_button_normal.png",
      capInsets = CCRectMake(7.81, 7.81, 39.06, 23.44),
      name = "btn_exchange",
      z = 0,
      parent = "image_ticket_bg",
      text = T("\231\140\174\231\165\173"),
      press = "UI/alpha/HVGA/stageselect_difficulty_button_normal_pressed.png",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(207.03, 22.27)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(117.19, 51.56),
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
      normal = "UI/alpha/HVGA/task_button.png",
      name = "btn_single",
      z = 1,
      capInsets = CCRectMake(15.63, 15.63, 0.78, 0.78),
      text = "",
      press = "UI/alpha/HVGA/task_button_press.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(656.25, 64.06)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(109.38, 45.31),
      flip = "",
      labelConfig = {
        color = ccc3(251, 206, 16)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/task_button.png",
      name = "btn_rank",
      z = 1,
      capInsets = CCRectMake(21.09, 23.44, 31.25, 23.44),
      text = T("\230\142\146\232\161\140\230\166\156"),
      press = "UI/alpha/HVGA/task_button_press.png",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(150, 442.97)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(156.25, 156.25)
    },
    t = "Layer",
    base = {name = "node_sweep", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(442.19, 25.78)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(0.78, 0.78)
    },
    t = "Layer",
    base = {
      parent = "image_ticket_bg",
      name = "node_ticket_full",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(139.06, 25.39)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 206, 16),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_single",
      z = 0,
      parent = "btn_single",
      text = T("\229\141\149\228\186\186"),
      size = 24
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(50.78, 25.78)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.34375, h = 33.59375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_single",
      res = "UI/alpha/HVGA/multiplayer_battle/single_play_button.png",
      name = "ImageView_72",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27.34, 25.78)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(117.19, 52.34),
      flip = "",
      labelConfig = {
        color = ccc3(255, 234, 198)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "installer/herodetail-upgrade.png",
      capInsets = CCRectMake(15.63, 7.81, 31.25, 31.25),
      name = "btn_sweep",
      z = 3,
      parent = "node_sweep",
      text = "",
      press = "installer/herodetail-upgrade-mask.png",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83.59, 35.94)
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
      name = "label_sweep_tip",
      z = 0,
      parent = "node_sweep",
      text = T("\229\189\147\229\137\141\231\167\175\229\136\134\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83.59, 136.72)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(124, 252, 0),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_sweep_tip1",
      z = 0,
      parent = "node_sweep",
      text = T("\239\188\1362000\229\136\134\229\188\128\229\144\175\230\137\171\232\141\161\239\188\137"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83.59, 71.88)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(78.13, 39.06)
    },
    t = "Layer",
    base = {
      parent = "node_sweep",
      name = "node_sweep_score",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(37.5, 102.34)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(117.19, 52.34)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_sweep_disable",
      z = 0,
      parent = "btn_sweep",
      res = "installer/herodetail-upgrade-disabled.png",
      capInsets = CCRectMake(15.63, 7.81, 31.25, 31.25)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.59, 26.17)
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
      name = "label_sweep",
      z = 0,
      parent = "btn_sweep",
      text = T("\230\137\171\232\141\161"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.59, 27.73)
    }
  }
}
