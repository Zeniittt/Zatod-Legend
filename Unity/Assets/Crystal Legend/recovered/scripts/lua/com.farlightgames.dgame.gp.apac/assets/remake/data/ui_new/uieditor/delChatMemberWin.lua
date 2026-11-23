ed.uieditor = ed.uieditor or {}
ed.uieditor.delChatMemberWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(505, 365)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(15, 110, 9, 1.5),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 285)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.4, h = 26.4},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "close_img",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(488.5, 351)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(43.2, 44),
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
      capInsets = CCRectMake(25, 25, 4, 5),
      name = "close_btn",
      z = 1,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/common/break_butt_bj.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(489, 351)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(499, 43.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "top_bg",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/chat/new/chat_recent_del_bg_3.png",
      capInsets = CCRectMake(15, 20, 9, 3.5)
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(252.5, 365)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(197.5, 9.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bottom_img",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_2.png",
      capInsets = CCRectMake(47.5, 0.5, 102.5, 9)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(252.5, 67.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 29, h = 29},
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
      normal = "UI/alpha/1080P/chat/new/chat_recent_del_choose.png",
      name = "all_select_btn",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/chat/new/chat_recent_del_choose.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35, 35.5)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(96, 41),
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
      capInsets = CCRectMake(35, 15, 7.5, 5.5),
      name = "clear_btn",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/common/button_com_sys.png",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(431.5, 34.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(459, 233.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "del_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(23, 77.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "title",
      z = 0,
      parent = "top_bg",
      text = T("\232\175\183\233\128\137\230\139\169\230\131\179\229\136\160\233\153\164\231\154\132\229\175\185\232\175\157"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(14.5, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "select_label",
      z = 0,
      parent = "top_bg",
      text = T("\229\183\178\233\128\137\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(384, 21.5)
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
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "select_num",
      z = 0,
      parent = "top_bg",
      text = "99/99",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(411.5, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "all_select_label",
      z = 0,
      parent = "all_select_btn",
      text = T("\229\133\168\233\128\137"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "clear_label",
      z = 0,
      parent = "clear_btn",
      text = T("\231\161\174\229\174\154\229\136\160\233\153\164"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4, x = 0.4},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.4, h = 18.8},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "all_select_btn",
      res = "UI/alpha/1080P/package/selected.png",
      name = "selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(14.5, 14.5)
    }
  }
}
