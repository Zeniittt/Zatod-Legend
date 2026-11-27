ed.uieditor = ed.uieditor or {}
ed.uieditor.mailListItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(293, 91.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(21.5, 20.5, 250, 50),
      res = "UI/alpha/1080P/mail/mail_butt_up_img.png",
      name = "mail_butt_up",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(146.5, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(293, 91.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(46.5, 20.5, 200, 50),
      res = "UI/alpha/1080P/mail/mail_butt_1.png",
      name = "ltemBj_1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(146, 45)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(293, 91.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(46.5, 20.5, 200, 50),
      res = "UI/alpha/1080P/mail/mail_butt_2.png",
      name = "ltemBj_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(146.5, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(99, 73, 63),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      size = 18,
      text = T("\231\171\158\230\138\128\229\156\186"),
      name = "name",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(79, 62.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(123, 92, 49),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      size = 14,
      text = T("\231\171\158\230\138\128\229\156\186"),
      name = "from",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(99.5, 38.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(110, 96, 91),
      opacity = 255,
      verticalAlignment = 1,
      visible = false
    },
    t = "Label",
    base = {
      size = 13,
      text = T("\229\143\145\228\187\182\228\186\186:"),
      name = "from_Copy0",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(81.5, 46.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19.5, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ltemBj_1",
      res = "UI/alpha/1080P/mail/mail_tag_1.png",
      name = "tagImgbj",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(267.5, 64.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 2,
      flip = "",
      color = ccc3(84, 61, 29),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 15,
      text = "",
      name = "Label_expire_time",
      z = 4
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(277.5, 19)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(18.5, 22.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(0.5, -8.5, 5, 10),
      res = "UI/alpha/1080P/mail/mail_name1_mask.png",
      name = "ImageView_1",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(247, 66.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19.5, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ltemBj_2",
      res = "UI/alpha/1080P/mail/mail_tag_2.png",
      name = "tagImgbj2",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(267.5, 64.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39, h = 39},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/mail/mailbox_maillist_milestone_icon.png",
      name = "itembjImg",
      z = 6
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44, 46)
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
      name = "Label1_tag1",
      z = 0,
      parent = "tagImgbj",
      text = T("\233\153\132"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(10.25, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(18.5, 22.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(0.5, -8.5, 5, 10),
      res = "UI/alpha/1080P/mail/mail_name2_mask.png",
      name = "ImageView_2",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(247.5, 66)
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
      name = "Label1_tag2",
      z = 0,
      parent = "tagImgbj",
      text = T("\228\187\182"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(10.25, 14.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(166, 158, 146),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label2_tag1",
      z = 0,
      parent = "tagImgbj2",
      text = T("\229\183\178\232\175\187"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(10.25, 21)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(166, 158, 146),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "Label2_tag2",
      z = 0,
      parent = "tagImgbj2",
      text = T("\232\175\187"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(9.75, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 10, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ltemBj_1",
      res = "UI/alpha/1080P/mail/mail_role_icon_2.png",
      name = "ImageView_375",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88, 38.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 10, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ltemBj_2",
      res = "UI/alpha/1080P/mail/mail_role_icon_1.png",
      name = "ImageView_375_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88, 38.25)
    }
  }
}
