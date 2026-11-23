ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_calender_item = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(95.5, 357.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(31.5, 115, 31.5, 115),
      res = "UI/alpha/1080P/activity/calendar/activity_calendar_item.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-0.5, -0.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(93, 42)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(5, 15, 0.5, 0.5),
      res = "UI/alpha/1080P/activity/calendar/calendar_select_bg.png",
      name = "image_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 335)
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
      size = 15,
      text = T("\230\152\159\230\156\159\228\186\140"),
      name = "label_week",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.5, 342.5)
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
      size = 15,
      text = T("9\230\156\13613\230\151\165"),
      name = "label_date",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.5, 324.5)
    }
  }
}
