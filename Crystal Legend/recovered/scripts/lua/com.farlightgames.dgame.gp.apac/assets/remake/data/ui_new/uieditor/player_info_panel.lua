ed.uieditor = ed.uieditor or {}
ed.uieditor.player_info_panel = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 627, h = 427},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/honorwall/honorwall_bg_1.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(570, 272.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(620, 416)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "node_grids",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(7, 10.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 204, h = 521},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/honorwall/honorwall_banner_new.png",
      name = "image_bg2",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-94, 203)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 626.5, h = 33.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/honorwall/honorwall_title_bg.png",
      name = "image_title",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(313.5, 440.5)
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
      name = "label_name",
      z = 1,
      parent = "image_bg2",
      text = T("\228\189\160\230\176\180\231\148\181\232\180\185\230\176\180\231\148\181\232\180\185"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102, 389)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "image_bg2",
      name = "node_medal",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(29, 378)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(600, 45)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "node_btn",
      z = 9
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(31, -39.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "image_bg2",
      name = "node_head",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(102, 457)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 199, 65),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_hero_count_tip",
      z = 0,
      parent = "image_bg2",
      text = T("\232\139\177\233\155\132\230\128\187\230\149\176\239\188\154"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(26, 360)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(620, 45)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "node_chat",
      z = 9
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(9.5, -40.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 199, 65),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_hero_gs_tip",
      z = 0,
      parent = "image_bg2",
      text = T("\230\136\152\229\138\155\230\128\187\229\146\140\239\188\154"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(26, 320.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 199, 65),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_union_tip",
      z = 0,
      parent = "image_bg2",
      text = T("\229\133\172\228\188\154\239\188\154"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(26.5, 300)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_title",
      res = "UI/alpha/1080P/common/line_2b.png",
      name = "ImageView_7972",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(191.25, 18.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(668.5, 50)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_7974",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/honorwall/honorwall_bg_2.png",
      capInsets = CCRectMake(209, 16.5, 209, 16.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(292, -19.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 199, 65),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_server_tip",
      z = 0,
      parent = "image_bg2",
      text = T("\230\156\141\229\138\161\229\153\168\239\188\154"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(26.5, 279.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 67, h = 12.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_title",
      res = "UI/alpha/1080P/common/line_2b.png",
      name = "ImageView_7972_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(442.25, 18.25)
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
      name = "label_hero_count",
      z = 0,
      parent = "image_bg2",
      text = "123/156",
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(179, 360)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(678, 506)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_7975",
      z = 1,
      parent = "image_bg",
      res = "UI/alpha/1080P/scale9/frame_common1.png",
      capInsets = CCRectMake(15.5, 20, 20, 150)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(292, 205)
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
      name = "label_gs",
      z = 0,
      parent = "image_bg2",
      text = "12345678",
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(179, 320.5)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(101.5, 42),
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
      normal = "UI/alpha/1080P/common/button_com_mini.png",
      capInsets = CCRectMake(10, 10, 12.5, 10),
      name = "btn_edit",
      z = 0,
      parent = "node_btn",
      text = "",
      press = "UI/alpha/1080P/common/button_com_mini.png",
      size = 11
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(530.5, 20)
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
      name = "label_server",
      z = 1,
      parent = "image_bg2",
      text = "server",
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(179, 279.5)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(101.5, 42),
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
      normal = "UI/alpha/1080P/common/button_com_mini.png",
      capInsets = CCRectMake(10, 10, 50, 20),
      name = "btn_save",
      z = 0,
      parent = "node_btn",
      text = "",
      press = "UI/alpha/1080P/common/button_com_mini.png",
      size = 11
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(530.5, 20)
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
      name = "btn_close",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(621, 446.5)
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
      name = "label_sign",
      z = 0,
      parent = "image_bg2",
      text = T("\233\152\159\233\149\191\230\154\130\230\156\170\231\188\150\232\190\145\231\173\190\229\144\141"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(26.5, 240)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(101.5, 42),
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
      normal = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(11, 10, 50, 5),
      name = "btn_honor",
      z = 0,
      parent = "node_btn",
      text = "",
      press = "UI/alpha/1080P/common/button_com_sys.png",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(405.5, 20)
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
      name = "label_union",
      z = 0,
      parent = "image_bg2",
      text = "sdfsdfsdf",
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(179, 300)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(100.5, 35.5),
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
      normal = "UI/alpha/1080P/honorwall/honorwall_del_button.png",
      capInsets = CCRectMake(15, 10, 35, 5),
      name = "btn_delete",
      z = 0,
      parent = "node_btn",
      text = "",
      press = "UI/alpha/1080P/honorwall/honorwall_del_button.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.5, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 199, 65),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_sign_tip",
      z = 1,
      parent = "image_bg2",
      text = T("\231\173\190\229\144\141\239\188\154"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(26.5, 255)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(101.5, 42),
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
      normal = "UI/alpha/1080P/common/button_com_mini.png",
      capInsets = CCRectMake(10, 10, 12.5, 10),
      name = "btn_undo",
      z = 0,
      parent = "node_btn",
      text = "",
      press = "UI/alpha/1080P/common/button_com_mini.png",
      size = 11
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(405.5, 20)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(102, 42),
      flip = "",
      labelConfig = {
        color = ccc3(246, 236, 216)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(10, 10, 12.5, 5),
      name = "btn_chat",
      z = 0,
      parent = "node_chat",
      text = T("\231\167\129\232\129\138"),
      press = "UI/alpha/1080P/common/button_com_sys.png",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.5, h = 18},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg2",
      res = "UI/alpha/1080P/ranking/lv_bg.png",
      name = "img_level_bj",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.5, 417)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(102, 42),
      flip = "",
      labelConfig = {
        color = ccc3(246, 236, 216)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(10, 10, 12.5, 5),
      name = "btn_black",
      z = 0,
      parent = "node_chat",
      text = T("\230\139\137\233\187\145"),
      press = "UI/alpha/1080P/common/button_com_sys.png",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(426.5, 21)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(135.5, 21.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_name_bj",
      z = 0,
      parent = "image_bg2",
      res = "UI/alpha/1080P/honorwall/honorwall_name_bg.png",
      capInsets = CCRectMake(10, 7.5, 15, 6.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102, 388.5)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(102, 42),
      flip = "",
      labelConfig = {
        color = ccc3(246, 236, 216)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(10, 10, 12.5, 5),
      name = "btn_friend",
      z = 0,
      parent = "node_chat",
      text = T("\229\138\160\229\165\189\229\143\139"),
      press = "UI/alpha/1080P/common/button_com_sys.png",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(306.5, 21)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 236, 216),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_edit",
      z = 2,
      parent = "btn_edit",
      text = T("\231\188\150\232\190\145"),
      size = 16
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
      color = ccc3(0, 0, 0),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_edit_Copy0",
      z = 0,
      parent = "btn_edit",
      text = T("\231\188\150\232\190\145"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 128, h = 2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg2",
      res = "UI/alpha/1080P/honorwall/honorwall_banner_line.png",
      name = "ImageView_7981_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102, 265.5)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(102, 42),
      flip = "",
      labelConfig = {
        color = ccc3(246, 236, 216)
      },
      opacity = 255,
      visible = false,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(10, 10, 12.5, 5),
      name = "btn_deal",
      z = 0,
      parent = "node_chat",
      text = T("\228\186\164\230\152\147"),
      press = "UI/alpha/1080P/common/button_com_sys.png",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(187, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 44, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg2",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_cup_silver.png",
      name = "cup_silver",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.5, 83)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(102, 42),
      flip = "",
      labelConfig = {
        color = ccc3(246, 236, 216)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_mini_red.png",
      capInsets = CCRectMake(10, 10, 12.5, 5),
      name = "btn_delete_friend",
      z = 0,
      parent = "node_chat",
      text = T("\229\136\160\229\165\189\229\143\139"),
      press = "UI/alpha/1080P/common/button_mini_red.png",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(306.5, 21)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 241, 165),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_edit",
      z = 2,
      parent = "btn_save",
      text = T("\228\191\157\229\173\152"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(0, 0, 0),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_edit_Copy0",
      z = 0,
      parent = "btn_save",
      text = T("\228\191\157\229\173\152"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.7, x = 0.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 52.15, h = 67.55},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg2",
      res = "UI/alpha/1080P/honorwall/honorwall_cup_bg.png",
      name = "cup_silver_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.5, 75.5)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(102, 42),
      flip = "",
      labelConfig = {
        color = ccc3(246, 236, 216)
      },
      opacity = 255,
      visible = false,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(10, 10, 12.5, 5),
      name = "btn_report",
      z = 0,
      parent = "node_chat",
      text = T("\228\184\190\230\138\165"),
      press = "UI/alpha/1080P/common/button_com_sys.png",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(546, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 44, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg2",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_cup_gold.png",
      name = "cup_gold",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49, 83)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(77.5, 35.5),
      flip = "",
      labelConfig = {
        color = ccc3(246, 236, 216)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(10, 10, 12.5, 10),
      name = "btn_gm",
      z = 0,
      parent = "node_chat",
      text = "GM",
      press = "UI/alpha/1080P/common/button_com_sys.png",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(574.5, 79.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15.2, h = 16.8},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_honor",
      res = "UI/alpha/1080P/common/buy_add.png",
      name = "image_add",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(31.25, 21)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 236, 216),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_honor",
      z = 2,
      parent = "btn_honor",
      text = T("\232\141\163\232\170\137"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.75, 22)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.7, x = 0.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 52.15, h = 67.55},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg2",
      res = "UI/alpha/1080P/honorwall/honorwall_cup_bg.png",
      name = "cup_gold_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.5, 75.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(0, 0, 0),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_honor_Copy0",
      z = 0,
      parent = "btn_honor",
      text = T("\232\141\163\232\170\137"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.75, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 44, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg2",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_cup_copper.png",
      name = "cup_copper",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(157, 83)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(107.5, 44)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_delete_valid",
      z = 0,
      parent = "btn_delete",
      res = "UI/alpha/1080P/honorwall/honorwall_choose_tip.png",
      capInsets = CCRectMake(15, 10, 35, 5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.25, 13.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 236, 216),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_delete",
      z = 2,
      parent = "btn_delete",
      text = T("\229\136\160\233\153\164\232\141\163\232\170\137"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49.75, 18.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.7, x = 0.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 52.15, h = 67.55},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg2",
      res = "UI/alpha/1080P/honorwall/honorwall_cup_bg.png",
      name = "cup_copper_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(156.5, 75.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(0, 0, 0),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_delete_Copy0",
      z = 1,
      parent = "btn_delete",
      text = T("\229\136\160\233\153\164\232\141\163\232\170\137"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49.75, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 55, h = 55},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg2",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_cup_diamond.png",
      name = "cup_diamond",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.5, 157.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 236, 216),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_undo",
      z = 2,
      parent = "btn_undo",
      text = T("\230\146\164\233\148\128"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(101.5, 42)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_undo_disable",
      z = 0,
      parent = "btn_undo",
      res = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(10, 10, 50, 5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 74.5, h = 96.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg2",
      res = "UI/alpha/1080P/honorwall/honorwall_cup_bg.png",
      name = "cup_diamond_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.5, 147)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(0, 0, 0),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_undo_Copy0",
      z = 0,
      parent = "btn_undo",
      text = T("\230\146\164\233\148\128"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 20)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 128, h = 2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg2",
      res = "UI/alpha/1080P/honorwall/honorwall_banner_line.png",
      name = "ImageView_7981_Copy1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102, 194.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_close",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_7977",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 199, 65),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_skin_count_tip",
      z = 0,
      parent = "image_bg2",
      text = T("\231\154\174\232\130\164\230\149\176\233\135\143\239\188\154"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(26, 341)
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
      name = "label_skin_count",
      z = 0,
      parent = "image_bg2",
      text = "123/156",
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(179, 341)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150.5, 63.5)
    },
    t = "Layer",
    base = {
      parent = "image_bg2",
      name = "Panel_1207",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(27, 199)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "img_level_bj",
      name = "node_level",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(16.25, 9)
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
      name = "cup_silver_amount",
      z = 0,
      parent = "cup_silver_bg",
      text = "99",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.25, 18.25)
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
      name = "cup_gold_amount",
      z = 0,
      parent = "cup_gold_bg",
      text = "99",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.25, 18.25)
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
      name = "cup_copper_amount",
      z = 0,
      parent = "cup_copper_bg",
      text = "99",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.25, 18.25)
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
      name = "cup_diamond_amount",
      z = 0,
      parent = "cup_diamond_bg",
      text = "99",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.25, 19.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 238, 147),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "image_title",
      text = T("\230\136\152\233\152\159\232\141\163\232\170\137"),
      size = 28
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(313.25, 19.25)
    }
  }
}
