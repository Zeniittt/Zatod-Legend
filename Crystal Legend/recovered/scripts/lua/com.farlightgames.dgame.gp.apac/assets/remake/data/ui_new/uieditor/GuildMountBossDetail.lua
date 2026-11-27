ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildMountBossDetail = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 914.5, h = 490},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/guildmount/challenge/background.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 267)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 358, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guildmount/challenge/bossname_board.png",
      name = "bg_boss_name",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(686.25, 427)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1, h = 24},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_boss_name",
      res = "UI/alpha/1080P/guildmount/challenge/line.png",
      name = "ImageView_4172",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(273, 23)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(237, 193, 64),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_4173",
      z = 0,
      parent = "bg_boss_name",
      text = T("\233\154\190\229\186\1664"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(301.5, 23)
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
      parent = "bg",
      res = "UI/alpha/1080P/guildmount/challenge/close_button.png",
      name = "btn_back",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(893.25, 467.5)
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
      name = "name",
      z = 0,
      parent = "bg_boss_name",
      text = "name",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(146.5, 23.5)
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
      parent = "bg",
      name = "right_arrow",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(417.75, 248.5)
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
      parent = "bg",
      name = "left_arrow",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(58.25, 248)
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
      parent = "bg",
      res = "UI/alpha/1080P/skin/skin_quality_bg_purple.png",
      name = "boss",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(252.25, 189)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -40.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "right_arrow",
      res = "UI/alpha/1080P/skin/skin_arrow.png",
      name = "ImageView_1499",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20, 20)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(177, 176, 192),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "boss_desc",
      z = 0,
      parent = "bg",
      text = "desc",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(527.25, 390.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 320, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guildmount/challenge/title_board.png",
      name = "ImageView_1526_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(670.25, 274)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "left_arrow",
      res = "UI/alpha/1080P/skin/skin_arrow.png",
      name = "ImageView_14991",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20, 20)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 320, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guildmount/challenge/title_board.png",
      name = "ImageView_1526_Copy1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(670.25, 190)
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
      name = "layer_cur",
      z = 5
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(457.25, 245)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(250, 25)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_2038",
      z = 5,
      parent = "bg",
      res = "UI/alpha/1080P/guildmount/challenge/lockdec_board.png",
      capInsets = CCRectMake(16, 10, 100, 5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(258.25, 380)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(300.5, 27.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_2255",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/guildmount/challenge/lockdec_board.png",
      capInsets = CCRectMake(65, 10, 2, 5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(682.75, 90)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(340, 82.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "boss_buff_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(505.25, 295)
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
      name = "Label_1529_Copy0",
      z = 0,
      parent = "ImageView_1526_Copy0",
      text = T("BOSS\230\138\128\232\131\189"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(17.5, 12.5)
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
      name = "Label_1529_Copy0",
      z = 0,
      parent = "ImageView_1526_Copy1",
      text = T("\229\165\150\229\138\177"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(17.5, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(247, 83.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_reward_detail",
      z = 3,
      parent = "ImageView_1526_Copy1",
      res = "UI/alpha/1080P/guildmount/award_clickopen1.png",
      capInsets = CCRectMake(100, 25, 5, 10)
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(1.5, -9.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49.5, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_1526_Copy1",
      res = "UI/alpha/1080P/guildmount/challenge/rdaward_board.png",
      name = "random_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46, -29.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 50)
    },
    t = "Layer",
    base = {
      parent = "ImageView_1526_Copy1",
      name = "layer_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(79, -53.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(303.5, 103)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_rank_board",
      z = 0,
      parent = "layer_cur",
      res = "UI/alpha/1080P/guildmount/challenge/rank_board.png",
      capInsets = CCRectMake(100, 35, 103.5, 5)
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(-197.5, -209)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(192, 50)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_battle",
      z = 0,
      parent = "layer_cur",
      res = "UI/alpha/1080P/common/button_big_common.png",
      capInsets = CCRectMake(75, 25, 1, 1)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(232, -181)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(303.5, 359.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_rank_board_detail",
      z = 0,
      parent = "layer_cur",
      res = "UI/alpha/1080P/guildmount/challenge/rank_board.png",
      capInsets = CCRectMake(100, 35, 103.5, 5)
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(-197.5, -209)
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
      parent = "layer_cur",
      res = "UI/alpha/1080P/summon/transform_btn.png",
      name = "btn_practice",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(74, -180)
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
      name = "Label_2039",
      z = 0,
      parent = "ImageView_2038",
      text = T("\229\143\170\229\143\175\230\159\165\231\156\139\230\156\170\230\157\165\228\184\164\232\189\174BOSS"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(125, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32, h = 32},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2255",
      res = "UI/alpha/1080P/activityadventure/adventure_stage_lock.png",
      name = "ImageView_2256",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.75, 13.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(177, 176, 192),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_2257",
      z = 0,
      parent = "ImageView_2255",
      text = T("\229\176\154\230\156\170\232\167\163\233\148\129"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(150.25, 13.75)
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
      parent = "ImageView_2255",
      res = "UI/alpha/1080P/summon/transform_btn.png",
      name = "btn_practices",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(149.75, -30.25)
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
      name = "Label_1543",
      z = 0,
      parent = "bg_reward_detail",
      text = T("\233\154\143\230\156\186\229\165\150\229\138\177"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(17.5, 65)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 4.09999847},
      flip = "",
      opacity = 255,
      fix_wh = {w = 207.049922735, h = 1.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_reward_detail",
      res = "UI/alpha/1080P/raid/line.png",
      name = "ImageView_1544",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(18.5, 46.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1545",
      z = 0,
      parent = "bg_reward_detail",
      text = T("\230\175\143\230\172\161\230\140\145\230\136\152\233\154\143\230\156\186\232\142\183\229\190\151\229\133\182\228\184\173\228\184\128\228\187\189\229\165\150\229\138\177"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(17.5, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 46, h = 39},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "random_reward",
      res = "UI/alpha/1080P/guildmount/challenge/rdaward_icon.png",
      name = "ImageView_1542",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.75, 25)
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
      name = "label_rank_board",
      z = 0,
      parent = "bg_rank_board",
      text = T("\229\133\172\228\188\154\229\134\133\229\141\149\230\172\161\228\188\164\229\174\179\230\142\146\229\144\141"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(151.75, 90)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_rank_board",
      res = "UI/alpha/1080P/guildmount/futureshow_button.png",
      name = "btn_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(291.25, 89.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(140, 126, 117),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_3338",
      z = 0,
      parent = "bg_rank_board",
      text = T("\229\189\147\229\137\141\230\154\130\230\151\160\231\142\169\229\174\182\228\184\138\230\166\156"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(151.75, 38)
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
      parent = "btn_battle",
      res = "UI/alpha/1080P/battle/battle_prepare_butt_fit_img.png",
      name = "ImageView_1534",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38, 25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 206, 116),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1535",
      z = 0,
      parent = "btn_battle",
      text = T("\230\136\152\230\150\151"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87.5, 26)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 239, 134),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1537",
      z = 1,
      parent = "btn_battle",
      text = T("\230\136\152\230\150\151\232\161\165\230\151\182:"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(95, 66.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_rank_board_detail",
      res = "UI/alpha/1080P/guildmount/futureshow_button.png",
      name = "btn_detail_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(291.25, 345.5)
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
      name = "label_rank_board_detail",
      z = 0,
      parent = "bg_rank_board_detail",
      text = T("\229\133\172\228\188\154\229\134\133\229\141\149\230\172\161\228\188\164\229\174\179\230\142\146\229\144\141"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(151.75, 346)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(293, 327)
    },
    t = "Layer",
    base = {
      parent = "bg_rank_board_detail",
      name = "Panel_damage_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(5.75, 5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(140, 126, 117),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_3338_Copy0",
      z = 0,
      parent = "bg_rank_board_detail",
      text = T("\229\189\147\229\137\141\230\154\130\230\151\160\231\142\169\229\174\182\228\184\138\230\166\156"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(151.75, 200)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_practice",
      res = "UI/alpha/1080P/guildmount/practice/icon_practice.png",
      name = "img_practice",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24, 24)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_practice",
      z = 0,
      parent = "btn_practice",
      text = T("\231\187\131\228\185\160\230\168\161\229\188\143"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23, 6)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_practices",
      res = "UI/alpha/1080P/guildmount/practice/icon_practice.png",
      name = "img_practice",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24, 24)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_practice",
      z = 0,
      parent = "btn_practices",
      text = T("\231\187\131\228\185\160\230\168\161\229\188\143"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23, 6)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "y",
      opacity = 255,
      fix_wh = {w = 13, h = 11.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_detail",
      res = "UI/alpha/1080P/guildmount/futureshow_3.png",
      name = "icon_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(12, 13.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 11.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_detail_close",
      res = "UI/alpha/1080P/guildmount/futureshow_3.png",
      name = "icon_detail_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(12, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 284, h = 39.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_cur",
      res = "UI/alpha/1080P/guildmount/challenge/time_board.png",
      name = "bg_left_time",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-196.5, 184)
    }
  }
}
