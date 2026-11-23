ed.uieditor = ed.uieditor or {}
ed.uieditor.friendItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(552, 82.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(184.5, 12, 184.5, 12),
      res = "UI/alpha/1080P/crusade/bg_replay_item.png",
      name = "bg",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(75, 75)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "headFrame",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(9.5, 3)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 229, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/friend/friend_name_bg.png",
      name = "playerNameBg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(172, 53)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(75, 55, 39),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "guildName",
      z = 0,
      parent = "bg",
      text = T("\229\133\172\228\188\154\229\144\141\229\173\151"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(83, 27.5)
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
      name = "playerName",
      z = 0,
      parent = "playerNameBg",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\228\184\131\228\184\170\229\173\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(26, 12.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1, h = 71.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/friend/friend_line_1.png",
      name = "line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(348.5, 40)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 65.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "chat",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(375, 8)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 65.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "blacklist",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(373.5, 5.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 65.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "applyFriend",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(364.5, 5.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 65.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "addFriend",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(291.5, 5.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(99, 227, 78),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "state",
      z = 0,
      parent = "chat",
      text = T("\229\156\168\231\186\191"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(24.5, 34)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(54, 54)
    },
    t = "Scale9Sprite",
    base = {
      name = "btnChat",
      z = 0,
      parent = "chat",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      capInsets = CCRectMake(38.5, 41, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(115, 33.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(114, 42)
    },
    t = "Scale9Sprite",
    base = {
      name = "btnRemove",
      z = 0,
      parent = "blacklist",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      capInsets = CCRectMake(38.5, 31, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(81.5, 35)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(102, 42)
    },
    t = "Scale9Sprite",
    base = {
      name = "btnApplyFriend",
      z = 0,
      parent = "applyFriend",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      capInsets = CCRectMake(38.5, 31, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(79, 35)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btnChat",
      res = "UI/alpha/1080P/friend/friend_chat.png",
      name = "ImageView_62",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(102, 42)
    },
    t = "Scale9Sprite",
    base = {
      name = "btnAddFriend",
      z = 0,
      parent = "addFriend",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      capInsets = CCRectMake(38.5, 31, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.5, 35)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(102, 42)
    },
    t = "Scale9Sprite",
    base = {
      name = "btnDelFriend",
      z = 0,
      parent = "addFriend",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      capInsets = CCRectMake(38.5, 31, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(193.5, 35)
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
      name = "Label_160",
      z = 0,
      parent = "btnRemove",
      text = T("\231\167\187\233\153\164\233\187\145\229\144\141\229\141\149"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(57, 23)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 231, 168),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_160",
      z = 0,
      parent = "btnApplyFriend",
      text = T("\230\183\187\229\138\160"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51, 23)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 231, 168),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_160",
      z = 0,
      parent = "btnAddFriend",
      text = T("\230\183\187\229\138\160"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51, 23)
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
      name = "Label_160",
      z = 0,
      parent = "btnDelFriend",
      text = T("\230\139\146\231\187\157"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51, 23)
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
      name = "label_svr_name",
      z = 0,
      parent = "bg",
      text = T("1\230\156\141 \233\187\132\233\135\145\229\156\163\230\160\145"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(156, 28)
    }
  }
}
