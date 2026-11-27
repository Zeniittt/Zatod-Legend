ed.uieditor = ed.uieditor or {}
ed.uieditor.failGuideItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(183.5, 183.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(61, 12.5, 61, 12.5),
      res = "UI/alpha/1080P/battleresult/fail_guide_bg.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40.1999933, h = 7.49999875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/line_2b.png",
      name = "ImageView_32323",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20.25, 163.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 167.5, h = 66.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/battleresult/fail_dungeonlevel_min.jpg",
      name = "image_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91.75, 115.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 40.1999933, h = 7.49999875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/line_2b.png",
      name = "ImageView_32324",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(163.25, 163.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 215, 151),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "image_bg",
      text = T("\230\143\144\229\141\135\231\167\145\230\138\128\231\173\137\231\186\167"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91.75, 165.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(220, 174, 102),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_desc",
      z = 0,
      parent = "image_bg",
      text = T("\230\143\144\229\141\135\231\159\174\228\186\186\231\167\145\230\138\128\231\173\137\231\186\167\239\188\140"),
      size = 13
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(16.75, 75.25)
    }
  }
}
