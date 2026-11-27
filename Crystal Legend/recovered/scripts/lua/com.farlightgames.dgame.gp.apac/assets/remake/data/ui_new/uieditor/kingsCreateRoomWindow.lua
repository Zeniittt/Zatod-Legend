ed.uieditor = ed.uieditor or {}
ed.uieditor.kingsCreateRoomWindow = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 541, h = 312},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/battleprepare/battleprepare_room_bg.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 269.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.199997408, h = 43.99999736},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(529, 305)
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
      name = "ImageView_71528",
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
      fix_wh = {w = 35, h = 5.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/newkingspvp/battleprepare/battleprepare_match_player_cursor.png",
      name = "image_title_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(335, 292.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 238, 207),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "image_bg",
      text = T("\228\184\128\229\177\128\232\131\156\232\180\159"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(270.5, 292.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 35, h = 5.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/newkingspvp/battleprepare/battleprepare_match_player_cursor.png",
      name = "image_title_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(200.5, 292.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 231.5, h = 34.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/newkingspvp/battleprepare/battleprepare_room_num_bg.png",
      name = "room_num_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(193.5, 233.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 91.35, h = 37.8},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_copy",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(369.5, 232)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.7999946, h = 38.4999945},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_share",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(447, 231.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 106, h = 117.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/newkingspvp/battleprepare/battleprepare_wait_player.png",
      name = "image_waiting",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(270.5, 124)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(177.5, 101)
    },
    t = "Scale9Sprite",
    base = {
      name = "share_bg",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/newkingspvp/battleprepare/battleprepare_room_share_bg.png",
      capInsets = CCRectMake(50, 50, 50, 19)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(483.5, 160)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 238, 207),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_room_num_tips",
      z = 0,
      parent = "room_num_bg",
      text = T("\230\136\191\233\151\180\231\188\150\229\143\183"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.25, 17.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 238, 207),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_room_num",
      z = 0,
      parent = "room_num_bg",
      text = "888888",
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(168.25, 17.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(247, 210, 141),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_copy",
      z = 0,
      parent = "btn_copy",
      text = T("\229\164\141\229\136\182"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 23)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.4000001, x = 1.4000001},
      flip = "",
      opacity = 255,
      fix_wh = {w = 44.10000315, h = 42.000003},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_share",
      res = "UI/alpha/1080P/crusade/btn_share.png",
      name = "ImageView_71539",
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
      color = ccc3(255, 238, 207),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_waiting",
      z = 0,
      parent = "image_waiting",
      text = T("\230\173\163\229\156\168\231\173\137\229\190\133\229\175\185\230\137\139..."),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(59.5, -16.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(166, 37.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_share_server",
      z = 0,
      parent = "share_bg",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      capInsets = CCRectMake(33, 13, 33, 13)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88.25, 81)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(166, 37.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_share_guild",
      z = 0,
      parent = "share_bg",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      capInsets = CCRectMake(33, 13, 33, 13)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88.25, 65.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(166, 37.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_share_friend",
      z = 0,
      parent = "share_bg",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      capInsets = CCRectMake(33, 13, 33, 13)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88.25, 26)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26, h = 26},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_share_server",
      res = "UI/alpha/1080P/newkingspvp/battleprepare/battleprepare_room_share_to_world.png",
      name = "icon_share_server",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23, 18.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 235, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_share_server",
      z = 0,
      parent = "btn_share_server",
      text = T("\229\136\134\228\186\171\229\136\176\228\184\150\231\149\140\233\162\145\233\129\147"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97, 20.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26, h = 26},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_share_guild",
      res = "UI/alpha/1080P/newkingspvp/battleprepare/battleprepare_room_share_to_guild.png",
      name = "icon_share_guild",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23, 18.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 235, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_share_guild",
      z = 0,
      parent = "btn_share_guild",
      text = T("\229\136\134\228\186\171\229\136\176\229\133\172\228\188\154\233\162\145\233\129\147"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97, 20.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_share_friend",
      res = "UI/alpha/1080P/newkingspvp/battleprepare/battleprepare_room_invite_friend.png",
      name = "icon_share_friend",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23, 18.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 235, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_share_friend",
      z = 0,
      parent = "btn_share_friend",
      text = T("\233\130\128\232\175\183\229\165\189\229\143\139"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(93, 20.25)
    }
  }
}
