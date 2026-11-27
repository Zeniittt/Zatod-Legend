local class = newclass("g")
ed.ui.marketconfig = class
setfenv(1, class)
scaleIcon = {
  common = {
    six_discount = {
      res = "UI/alpha/HVGA/shop_sale_6.png",
      discount = 60
    },
    eight_discount = {
      res = "UI/alpha/HVGA/shop_sale_8.png",
      discount = 80
    }
  },
  diamond = {
    ["10"] = {
      res = "UI/alpha/HVGA/shop_diamond/shop_diamond_sale_1.png",
      bgRes = "UI/alpha/HVGA/shop_diamond/shop_diamond_sale_bg_1.png",
      discount = 10
    },
    ["20"] = {
      res = "UI/alpha/HVGA/shop_diamond/shop_diamond_sale_2.png",
      bgRes = "UI/alpha/HVGA/shop_diamond/shop_diamond_sale_bg_1.png",
      discount = 20
    },
    ["30"] = {
      res = "UI/alpha/HVGA/shop_diamond/shop_diamond_sale_3.png",
      bgRes = "UI/alpha/HVGA/shop_diamond/shop_diamond_sale_bg_2.png",
      discount = 30
    },
    ["40"] = {
      res = "UI/alpha/HVGA/shop_diamond/shop_diamond_sale_4.png",
      bgRes = "UI/alpha/HVGA/shop_diamond/shop_diamond_sale_bg_2.png",
      discount = 40
    },
    ["50"] = {
      res = "UI/alpha/HVGA/shop_diamond/shop_diamond_sale_5.png",
      bgRes = "UI/alpha/HVGA/shop_diamond/shop_diamond_sale_bg_2.png",
      discount = 50
    }
  }
}
shopName2IdTbl = {
  common = 1,
  special = 2,
  soSpecial = 3,
  crusade = 4,
  pvp = 5,
  star = 6,
  guild = 7,
  toy = 9,
  gvg = 10,
  dreamland = 11,
  trade = 12,
  hideStar = 18,
  legendArena = 15,
  starGate = 16,
  hideSpecial = 17,
  tarot = 19,
  diamondShop = 20
}
toId = shopName2IdTbl
type_config = {
  [toId.common] = {
    name = "common",
    goods_type = "coin",
    buy_type = "coin",
    canRefresh = function()
      if ed.player._rmb < ed.player:getShopRefreshCost(1) then
        ed.showHandyDialog("toRecharge")
        return false
      end
      return true
    end,
    refresh_coin_type = "diamond",
    refresh_coin_name = T("\233\146\187\231\159\179"),
    show_hot_tag = false,
    will_auto_exit = false,
    need_open = false,
    need_enter_refresh = true,
    do_fast_sell = true,
    level_explaination = nil,
    is_new_shop = false,
    ui_config = {
      frameRes = "UI/alpha/HVGA/shop_bg.png",
      titleBgRes = "UI/alpha/HVGA/map-title-bg.png",
      titleRes = "UI/alpha/HVGA/shop_title_1.png",
      productBgRes = "UI/alpha/HVGA/shop_product_bg.png",
      headRes = "UI/alpha/HVGA/shop_head.png",
      talkBgRes = "UI/alpha/HVGA/shop_talk_bg.png",
      noneTagRes = "UI/alpha/HVGA/shop_none_tag.png",
      titlePos = ccp(400, 375),
      headPos = ccp(144, 392),
      framePos = ccp(400, 225),
      costLabelColor = ccc3(255, 255, 255)
    }
  },
  [toId.special] = {
    name = "special",
    goods_type = "coin",
    buy_type = "coin",
    canRefresh = function()
      if ed.player._rmb < ed.player:getShopRefreshCost(2) then
        ed.showHandyDialog("toRecharge")
        return false
      end
      return true
    end,
    refresh_coin_type = "diamond",
    refresh_coin_name = T("\233\146\187\231\159\179"),
    show_hot_tag = false,
    will_auto_exit = false,
    need_open = false,
    need_enter_refresh = true,
    do_fast_sell = true,
    level_explaination = T("\231\165\158\231\167\152\229\149\134\228\186\186\229\183\178\231\187\143\233\163\152\231\132\182\232\128\140\229\142\187\239\188\140\228\184\139\230\172\161\228\185\176\228\184\156\232\165\191\229\138\168\228\189\156\232\166\129\229\191\171\229\147\166\239\188\129"),
    is_new_shop = false,
    ui_config = {
      frameRes = "UI/alpha/HVGA/shop_bg_2.png",
      titleBgRes = "UI/alpha/HVGA/shop_title_bg_2.png",
      productBgRes = "UI/alpha/HVGA/shop_product_bg_2.png",
      headRes = "UI/alpha/HVGA/shop_head_2.png",
      titleRes = "UI/alpha/HVGA/shop_title_2.png",
      talkBgRes = "UI/alpha/HVGA/shop_talk_bg.png",
      noneTagRes = "UI/alpha/HVGA/shop_none_tag.png",
      titlePos = ccp(400, 380),
      headPos = ccp(135, 388),
      framePos = ccp(400, 225),
      costLabelColor = ccc3(255, 255, 255)
    }
  },
  [toId.soSpecial] = {
    name = "soSpecial",
    goods_type = "coin",
    buy_type = "coin",
    canRefresh = function()
      if ed.player._rmb < ed.player:getShopRefreshCost(3) then
        ed.showHandyDialog("toRecharge")
        return false
      end
      return true
    end,
    refresh_coin_type = "diamond",
    refresh_coin_name = T("\233\146\187\231\159\179"),
    show_hot_tag = false,
    will_auto_exit = false,
    need_open = false,
    need_enter_refresh = true,
    do_fast_sell = true,
    level_explaination = T("\231\165\158\231\167\152\229\149\134\228\186\186\229\183\178\231\187\143\233\163\152\231\132\182\232\128\140\229\142\187\239\188\140\228\184\139\230\172\161\228\185\176\228\184\156\232\165\191\229\138\168\228\189\156\232\166\129\229\191\171\229\147\166\239\188\129"),
    is_new_shop = false,
    ui_config = {
      frameRes = "UI/alpha/HVGA/shop_bg_2.png",
      titleBgRes = "UI/alpha/HVGA/shop_title_bg_2.png",
      productBgRes = "UI/alpha/HVGA/shop_product_bg_2.png",
      headRes = "UI/alpha/HVGA/shop_head_3.png",
      titleRes = "UI/alpha/HVGA/shop_title_3.png",
      talkBgRes = "UI/alpha/HVGA/shop_talk_bg.png",
      noneTagRes = "UI/alpha/HVGA/shop_none_tag.png",
      titlePos = ccp(400, 380),
      headPos = ccp(150, 393),
      framePos = ccp(400, 225),
      costLabelColor = ccc3(255, 255, 255)
    }
  },
  [toId.crusade] = {
    name = "crusade",
    goods_type = "coin",
    buy_type = "coin",
    canRefresh = function()
      if ed.player:getCrusadeMoney() < ed.player:getShopRefreshCost(4) then
        ed.showToast(T("\230\130\168\231\154\132\233\190\153\233\179\158\231\161\172\229\184\129\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\229\136\183\230\150\176"))
        return false
      end
      return true
    end,
    refresh_coin_type = "crusadepoint",
    refresh_coin_name = T("\230\158\154\233\190\153\233\179\158\231\161\172\229\184\129"),
    show_hot_tag = true,
    will_auto_exit = false,
    need_open = true,
    need_enter_refresh = true,
    do_fast_sell = true,
    level_explaination = nil,
    is_new_shop = true,
    ui_config = {
      frameRes = "UI/alpha/HVGA/shop_bg_3.png",
      titleBgRes = "UI/alpha/HVGA/shop_title_bg_purple.png",
      productBgRes = "UI/alpha/HVGA/shop_product_bg_3.png",
      simpleProductBgRes = "UI/alpha/HVGA/shop_product_bg_4.png",
      headRes = "UI/alpha/HVGA/shop_head_tb.png",
      titleRes = "UI/alpha/HVGA/shop_title_crusade.png",
      talkBgRes = "UI/alpha/HVGA/shop_talk_bg.png",
      noneTagRes = "UI/alpha/HVGA/shop_none_tag.png",
      titlePos = ccp(400, 380),
      headPos = ccp(147, 404),
      framePos = ccp(400, 225),
      costLabelColor = ccc3(255, 255, 255)
    }
  },
  [toId.pvp] = {
    name = "pvp",
    goods_type = "coin",
    buy_type = "coin",
    canRefresh = function()
      if ed.player:getPvpMoney() < ed.player:getShopRefreshCost(5) then
        ed.showToast(T("\230\130\168\231\154\132\232\167\146\230\150\151\229\163\171\231\161\172\229\184\129\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\229\136\183\230\150\176"))
        return false
      end
      return true
    end,
    refresh_coin_type = "arenapoint",
    refresh_coin_name = T("\230\158\154\232\167\146\230\150\151\229\163\171\231\161\172\229\184\129"),
    show_hot_tag = true,
    will_auto_exit = false,
    need_open = true,
    need_enter_refresh = true,
    do_fast_sell = true,
    level_explaination = nil,
    is_new_shop = true,
    is_first_enter = {},
    ui_config = {
      frameRes = "UI/alpha/HVGA/shop_bg_3.png",
      titleBgRes = "UI/alpha/HVGA/shop_title_bg_2.png",
      productBgRes = "UI/alpha/HVGA/shop_product_bg_3.png",
      simpleProductBgRes = "UI/alpha/HVGA/shop_product_bg_4.png",
      headRes = "UI/alpha/HVGA/shop_head_panda.png",
      titleRes = "UI/alpha/HVGA/shop_title_arena.png",
      talkBgRes = "UI/alpha/HVGA/shop_talk_bg.png",
      noneTagRes = "UI/alpha/HVGA/shop_none_tag.png",
      titlePos = ccp(400, 380),
      headPos = ccp(143, 395),
      framePos = ccp(400, 225),
      costLabelColor = ccc3(255, 255, 255)
    }
  },
  [toId.guild] = {
    name = "guild",
    goods_type = "coin",
    buy_type = "coin",
    canRefresh = function()
      if ed.player:getGuildMoney() < ed.player:getShopRefreshCost(7) then
        ed.showToast(T("\230\130\168\231\154\132\229\133\132\229\188\159\228\188\154\231\161\172\229\184\129\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\229\136\183\230\150\176"))
        return false
      end
      return true
    end,
    refresh_coin_type = "guildpoint",
    refresh_coin_name = T("\230\158\154\229\133\132\229\188\159\228\188\154\231\161\172\229\184\129"),
    show_hot_tag = true,
    will_auto_exit = false,
    need_open = true,
    need_enter_refresh = true,
    do_fast_sell = true,
    level_explaination = nil,
    is_new_shop = true,
    ui_config = {
      frameRes = "UI/alpha/HVGA/shop_bg_3.png",
      titleBgRes = "UI/alpha/HVGA/shop_title_bg_guild.png",
      productBgRes = "UI/alpha/HVGA/shop_product_bg_3.png",
      simpleProductBgRes = "UI/alpha/HVGA/shop_product_bg_4.png",
      headRes = "UI/alpha/HVGA/shop_head_guild.png",
      titleRes = "UI/alpha/HVGA/shop_title_guild.png",
      talkBgRes = "UI/alpha/HVGA/shop_talk_bg.png",
      noneTagRes = "UI/alpha/HVGA/shop_none_tag.png",
      exchangeDeadlineRes = "UI/alpha/HVGA/pvp/shop_exchange_deadline.png",
      titlePos = ccp(400, 380),
      headPos = ccp(139, 414),
      framePos = ccp(400, 225),
      costLabelColor = ccc3(255, 255, 255)
    }
  },
  starshop = {
    name = "star",
    goods_type = "stone",
    buy_type = "stone",
    canRefresh = nil,
    refresh_coin_type = nil,
    refresh_coin_name = nil,
    show_hot_tag = nil,
    will_auto_exit = false,
    need_open = false,
    need_enter_refresh = false,
    do_fast_sell = true,
    level_explaination = T("\230\152\159\233\153\133\229\149\134\228\186\186\229\183\178\231\187\143\231\166\187\229\142\187\239\188\140\228\184\139\230\172\161\228\185\176\228\184\156\232\165\191\229\138\168\228\189\156\232\166\129\229\191\171\229\147\166\239\188\129"),
    is_new_shop = false,
    ui_config = {
      frameRes = "UI/alpha/HVGA/shop_star_frame.png",
      titleBgRes = nil,
      productBgRes = "UI/alpha/HVGA/shop_star_item_bg.png",
      headRes = nil,
      titleRes = "UI/alpha/HVGA/shop_star_title.png",
      talkBgRes = "UI/alpha/HVGA/shop_star_talk_bg_frame.png",
      noneTagRes = "UI/alpha/HVGA/shop_star_none_tag.png",
      titlePos = ccp(403, 382),
      headPos = nil,
      framePos = ccp(400, 220),
      costLabelColor = ccc3(150, 236, 255)
    }
  },
  [toId.hideStar] = {
    name = "starhide",
    goods_type = "stone",
    buy_type = "stone",
    canRefresh = function()
      if ed.player._rmb < ed.player:getShopRefreshCost(toId.hideStar) then
        ed.showHandyDialog("toRecharge")
        return false
      end
      return true
    end,
    refresh_coin_type = "diamond",
    refresh_coin_name = T("\233\146\187\231\159\179"),
    show_hot_tag = false,
    will_auto_exit = false,
    need_open = true,
    need_enter_refresh = true,
    do_fast_sell = false,
    level_explaination = T("\230\152\159\233\153\133\229\149\134\228\186\186\229\183\178\231\187\143\231\166\187\229\142\187\239\188\140\228\184\139\230\172\161\228\185\176\228\184\156\232\165\191\229\138\168\228\189\156\232\166\129\229\191\171\229\147\166\239\188\129"),
    is_new_shop = false,
    ui_config = {
      frameRes = "UI/alpha/HVGA/shop_star_frame.png",
      titleBgRes = nil,
      productBgRes = "UI/alpha/HVGA/shop_star_item_bg_2.png",
      headRes = nil,
      titleRes = "UI/alpha/HVGA/shop_star_title.png",
      talkBgRes = "UI/alpha/HVGA/shop_star_talk_bg_frame.png",
      noneTagRes = "UI/alpha/HVGA/shop_star_none_tag_2.png",
      titlePos = ccp(403, 382),
      headPos = nil,
      framePos = ccp(400, 220),
      costLabelColor = ccc3(150, 236, 255)
    }
  },
  [toId.gvg] = {
    name = "gvg",
    goods_type = "coin",
    buy_type = "coin",
    canRefresh = function()
      if ed.player:getPoint("gvgpoint") < ed.player:getShopRefreshCost(10) then
        ed.showToast(T("\230\130\168\231\154\132\229\190\129\230\156\141\231\161\172\229\184\129\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\229\136\183\230\150\176"))
        return false
      end
      return true
    end,
    refresh_coin_type = "gvgpoint",
    refresh_coin_name = T("\230\158\154\229\190\129\230\156\141\231\161\172\229\184\129"),
    show_hot_tag = false,
    will_auto_exit = false,
    need_open = true,
    need_enter_refresh = true,
    do_fast_sell = true,
    level_explaination = nil,
    is_new_shop = true,
    ui_config = {
      frameRes = "UI/alpha/HVGA/shop_bg_3.png",
      titleBgRes = "UI/alpha/HVGA/shop_title_bg_2.png",
      productBgRes = "UI/alpha/HVGA/shop_product_bg_3.png",
      simpleProductBgRes = "UI/alpha/HVGA/shop_product_bg_4.png",
      titleRes = "UI/alpha/HVGA/gvg/shop_title_gvg.png",
      headRes = "UI/alpha/HVGA/shop_head_gvg.png",
      talkBgRes = "UI/alpha/HVGA/shop_talk_bg.png",
      noneTagRes = "UI/alpha/HVGA/shop_none_tag.png",
      titlePos = ccp(400, 388),
      headPos = ccp(136, 431),
      framePos = ccp(400, 225),
      costLabelColor = ccc3(255, 255, 255)
    }
  },
  [toId.dreamland] = {
    name = "dreamland",
    goods_type = "coin",
    buy_type = "coin",
    canRefresh = function()
      if ed.player:getDreamlandMoney() < ed.player:getShopRefreshCost(11) then
        ed.showToast(T("\230\130\168\231\154\132\230\162\166\229\162\131\229\184\129\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\229\136\183\230\150\176"))
        return false
      end
      return true
    end,
    refresh_coin_type = "dreampoint",
    refresh_coin_name = T("\230\158\154\230\162\166\229\162\131\229\184\129"),
    will_auto_exit = false,
    need_open = true,
    need_enter_refresh = true,
    do_fast_sell = true,
    level_explaination = nil,
    is_new_shop = true,
    ui_config = {
      frameRes = "UI/alpha/HVGA/shop_bg_3.png",
      titleBgRes = "UI/alpha/HVGA/shop_title_bg_dreamland.png",
      productBgRes = "UI/alpha/HVGA/shop_product_bg_3.png",
      simpleProductBgRes = "UI/alpha/HVGA/shop_product_bg_4.png",
      headRes = "UI/alpha/HVGA/shop_head_dreamland.png",
      titleRes = "UI/alpha/HVGA/shop_title_dreamland.png",
      talkBgRes = "UI/alpha/HVGA/shop_talk_bg.png",
      noneTagRes = "UI/alpha/HVGA/shop_none_tag.png",
      titlePos = ccp(400, 380),
      headPos = ccp(128, 406),
      framePos = ccp(400, 225),
      costLabelColor = ccc3(255, 255, 255)
    }
  },
  [toId.trade] = {
    name = "bookstore",
    goods_type = "coin",
    buy_type = "coin",
    canRefresh = function()
      if ed.player:getPoint("crystal") < ed.player:getShopRefreshCost(12) then
        ed.showToast(T("\230\130\168\231\154\132\230\176\180\230\153\182\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\229\136\183\230\150\176"))
        return false
      end
      return true
    end,
    refresh_coin_type = "crystal",
    refresh_coin_name = T("\230\176\180\230\153\182"),
    will_auto_exit = false,
    need_open = true,
    need_enter_refresh = true,
    do_fast_sell = true,
    level_explaination = nil,
    is_new_shop = false,
    ui_config = {
      frameRes = "UI/alpha/HVGA/shop_bg_2.png",
      titleBgRes = "UI/alpha/HVGA/shop_title_bg_guild.png",
      productBgRes = "UI/alpha/HVGA/shop_product_bg_2.png",
      headRes = "UI/alpha/HVGA/shop_head_bookstore.png",
      titleRes = "UI/alpha/HVGA/shop_title_bookstore.png",
      talkBgRes = "UI/alpha/HVGA/shop_talk_bg.png",
      noneTagRes = "UI/alpha/HVGA/shop_none_tag.png",
      titlePos = ccp(400, 380),
      headPos = ccp(142, 403),
      framePos = ccp(400, 225),
      costLabelColor = ccc3(255, 255, 255)
    }
  },
  [toId.legendArena] = {
    name = "legendArenaShop",
    goods_type = "coin",
    buy_type = "coin",
    canRefresh = function()
      if ed.player:getPoint("legend_point") < ed.player:getShopRefreshCost(15) then
        ed.showToast(T("\230\130\168\231\154\132\228\188\160\229\165\135\229\184\129\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\229\136\183\230\150\176"))
        return false
      end
      return true
    end,
    refresh_coin_type = "legend_point",
    refresh_coin_name = T("\228\188\160\229\165\135\229\184\129"),
    will_auto_exit = false,
    need_open = true,
    need_enter_refresh = true,
    do_fast_sell = true,
    level_explaination = nil,
    is_new_shop = true,
    ui_config = {
      frameRes = "UI/alpha/HVGA/shop_bg_3.png",
      titleBgRes = "UI/alpha/HVGA/shop_title_bg_top_pvp.png",
      productBgRes = "UI/alpha/HVGA/shop_product_bg_3.png",
      simpleProductBgRes = "UI/alpha/HVGA/shop_product_bg_4.png",
      headRes = "UI/alpha/HVGA/legend_pvp/shop_head_legendpvp.png",
      titleRes = "UI/alpha/HVGA/legend_pvp/shop_title_legend_pvp.png",
      talkBgRes = "UI/alpha/HVGA/shop_talk_bg.png",
      noneTagRes = "UI/alpha/HVGA/shop_none_tag.png",
      titlePos = ccp(417, 390),
      headPos = ccp(143, 414),
      framePos = ccp(400, 225),
      costLabelColor = ccc3(255, 255, 255)
    }
  },
  [toId.starGate] = {
    name = "starGateShop",
    goods_type = "coin",
    buy_type = "coin",
    canRefresh = function()
      if ed.player:getPoint("star_point") < ed.player:getShopRefreshCost(16) then
        ed.showToast(T("\230\130\168\231\154\132\230\152\159\229\184\129\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\229\136\183\230\150\176"))
        return false
      end
      return true
    end,
    refresh_coin_type = "star_point",
    refresh_coin_name = T("\230\152\159\229\184\129"),
    will_auto_exit = false,
    need_open = true,
    need_enter_refresh = true,
    do_fast_sell = true,
    level_explaination = nil,
    is_new_shop = false,
    ui_config = {
      frameRes = "UI/alpha/HVGA/stargate/stargate_shop.png",
      titleBgRes = nil,
      productBgRes = "UI/alpha/HVGA/stargate/stargate_shop_product.png",
      headRes = "UI/alpha/HVGA/stargate/shop_head_newfv.png",
      titleRes = nil,
      talkBgRes = "UI/alpha/HVGA/shop_talk_bg.png",
      noneTagRes = "UI/alpha/HVGA/shop_none_tag.png",
      titlePos = ccp(400, 373),
      headPos = ccp(164, 384),
      framePos = ccp(400, 225),
      costLabelColor = ccc3(255, 255, 255)
    }
  },
  [toId.hideSpecial] = {
    name = "hideSpecial",
    goods_type = "coin",
    buy_type = "coin",
    canRefresh = function()
      if ed.player._rmb < ed.player:getShopRefreshCost(17) then
        ed.showHandyDialog("toRecharge")
        return false
      end
      return true
    end,
    refresh_coin_type = "diamond",
    refresh_coin_name = T("\233\146\187\231\159\179"),
    show_hot_tag = false,
    will_auto_exit = false,
    need_open = true,
    need_enter_refresh = true,
    do_fast_sell = true,
    level_explaination = nil,
    is_new_shop = false,
    ui_config = {
      frameRes = "UI/alpha/HVGA/shop_bg_3.png",
      titleBgRes = "UI/alpha/HVGA/shop_title_bg_3.png",
      productBgRes = "UI/alpha/HVGA/shop_product_bg_2.png",
      headRes = "UI/alpha/HVGA/shop_head_3.png",
      titleRes = "UI/alpha/HVGA/shop_title_3.png",
      talkBgRes = "UI/alpha/HVGA/shop_talk_bg.png",
      noneTagRes = "UI/alpha/HVGA/shop_none_tag.png",
      titlePos = ccp(400, 375),
      headPos = ccp(150, 393),
      framePos = ccp(400, 225),
      costLabelColor = ccc3(255, 255, 255)
    }
  },
  [toId.tarot] = {
    name = "tarot",
    goods_type = "coin",
    buy_type = "coin",
    canRefresh = function()
      local point = ed.player._rmb
      local need = ed.player:getShopRefreshCost(19)
      if point < need then
        ed.showHandyDialog("toRecharge")
        return false
      end
      return true
    end,
    refresh_coin_type = "diamond",
    refresh_coin_name = T("\233\146\187\231\159\179"),
    show_hot_tag = false,
    will_auto_exit = false,
    need_open = true,
    need_enter_refresh = true,
    is_new_shop = false
  },
  [toId.diamondShop] = {
    name = "diamondShop",
    goods_type = "coin",
    buy_type = "coin",
    isShowRule = true,
    refresh_coin_type = "diamond",
    refresh_coin_name = T("\233\146\187\231\159\179"),
    will_auto_exit = true,
    need_open = false,
    need_enter_refresh = false,
    do_fast_sell = false,
    level_explaination = T("\230\156\172\229\186\151\232\144\165\228\184\154\229\183\178\231\187\147\230\157\159\239\188\140\229\186\151\228\184\187\229\146\140\229\176\143\231\134\138\229\142\187\233\131\138\230\184\184\228\186\134\239\188\129"),
    not_open_explaination = T("\229\186\151\228\184\187\228\187\141\229\156\168\231\173\185\229\164\135\229\149\134\229\147\129\239\188\140\232\175\183\229\133\136\229\142\187\230\182\136\232\128\151\228\184\128\228\186\155\228\189\147\229\138\155\229\144\167"),
    soldout_explaination = T("\229\149\134\229\147\129\229\183\178\229\148\174\231\169\186\239\188\140\230\156\159\229\190\133\228\184\139\230\172\161\228\184\142\230\130\168\229\134\141\228\188\154"),
    is_new_shop = false,
    ui_config = {
      frameRes = "UI/alpha/HVGA/shop_diamond/shop_diamond_bg.png",
      titleBgRes = "UI/alpha/HVGA/shop_diamond/shop_diamond_title_bg.png",
      productBgRes = "UI/alpha/HVGA/shop_product_bg_2.png",
      headRes = "UI/alpha/HVGA/shop_head_diamond.png",
      titleRes = "UI/alpha/HVGA/shop_diamond/shop_diamond_title.png",
      talkBgRes = "UI/alpha/HVGA/shop_talk_bg.png",
      noneTagRes = "UI/alpha/HVGA/shop_none_tag.png",
      titlePos = ccp(400, 380),
      headPos = ccp(144, 414),
      headBgPos = ccp(148, 392),
      framePos = ccp(400, 225),
      costLabelColor = ccc3(118, 236, 204)
    }
  }
}

function getCoinRes(pt)
  local coinRes = {
    gold = "UI/alpha/HVGA/shop_gold_icon.png",
    diamond = "UI/alpha/1080P/common/shop_token_icon.png",
    crusadepoint = "UI/alpha/HVGA/money_dragonscale_small.png",
    arenapoint = "UI/alpha/HVGA/money_arenatoken_small.png",
    guildpoint = "UI/alpha/HVGA/money_guildtoken_small.png",
    honourpoint = "UI/alpha/HVGA/money_top_pvp_small.png",
    gvgpoint = "UI/alpha/HVGA/money_gvg_small.png",
    dreampoint = "UI/alpha/HVGA/money_dreampoint_small.png",
    gcwpoint = "UI/alpha/HVGA/money_gcw_small.png",
    wood = "UI/alpha/HVGA/warschool/resource_wood.png",
    iron = "UI/alpha/HVGA/warschool/resource_iron.png",
    crystal = "UI/alpha/HVGA/warschool/resource_crystal.png",
    raid = "UI/alpha/HVGA/guild/guild_loot_coin.png",
    legend_point = "UI/alpha/HVGA/legend_pvp/legend_pvp_coin.png",
    philstone = "UI/alpha/HVGA/money_philstone_small.png",
    star_point = "UI/alpha/HVGA/stargate/money_stargate.png",
    tarot_point = "UI/alpha/HVGA/tarot_card/tarot_point.png"
  }
  return coinRes[pt]
end

function checkMoneyEnough(pt, cost, id)
  cost = cost or 0
  if pt == "gold" then
    return cost <= ed.player._money
  elseif pt == "diamond" then
    return cost <= ed.player._rmb
  elseif pt == "crusadepoint" then
    return cost <= ed.player:getCrusadeMoney()
  elseif pt == "arenapoint" then
    return cost <= ed.player:getPvpMoney()
  elseif pt == "honourpoint" then
    return cost <= ed.player:getTopPvpMoney()
  elseif pt == "guildpoint" then
    return cost <= ed.player:getGuildMoney()
  elseif pt == "stone" then
    return cost <= (ed.player.equip_qunty[id] or 0)
  elseif pt == "gvgpoint" then
    return cost <= ed.player:getPoint("gvgpoint")
  elseif pt == "dreampoint" then
    return cost <= ed.player:getPoint("dreampoint")
  elseif pt == "gcwpoint" then
    return cost <= ed.player:getPoint("gcwpoint")
  elseif pt == "wood" or pt == "iron" or pt == "crystal" then
    return cost <= ed.player:getPoint(pt)
  elseif pt == "soulstone" then
    return cost <= ed.player:getEquipAmount(id)
  elseif pt == "raid" then
    return cost <= FBShop.FBShopMgr.getInstance():getRaidEnergy()
  elseif pt == "item_2048" then
    return cost <= ed.player:getEquipAmount(2048)
  elseif pt == "legend_point" then
    return cost <= ed.player:getLegendPoint()
  elseif pt == "star_point" then
    return cost <= ed.player:getStarPoint()
  elseif pt == "philstone" then
    return cost <= ed.player:getEquipAmount(id)
  elseif pt == "tarot_point" then
    return cost <= ed.player:getTarotPoint()
  end
  return false
end

function getBuyType(id)
  return type_config[id].buy_type
end

function getGoodsType(id)
  return type_config[id].goods_type
end

function canRefresh(id)
  local handler = type_config[id].canRefresh
  return handler()
end

function getRefreshCoinName(id)
  return type_config[id].refresh_coin_name
end

function getRefreshCoinType(id)
  return type_config[id].refresh_coin_type
end

function getLevelExplaination(id)
  return type_config[id].level_explaination
end

function getNotOpenExplaination(id)
  return type_config[id].not_open_explaination
end

function getSoldoutExplaination(id)
  return type_config[id].soldout_explaination
end

function isShowHotTag(id)
  return type_config[id].show_hot_tag
end

function willAutoExit(id)
  return type_config[id].will_auto_exit
end

function needOpen(id)
  return type_config[id].need_open
end

function needEnterRefresh(id)
  return type_config[id].need_enter_refresh
end

function needFastSell(id)
  return type_config[id].do_fast_sell
end

function getuiConfig(id)
  return type_config[id].ui_config
end

function hasRefreshButton(id)
  if type_config[id].canRefresh ~= nil then
    return true
  end
  return false
end

function hasRuleButton(id)
  if type_config[id].isShowRule then
    return true
  end
  return false
end

function getShopName(id)
  local name = ""
  if type_config[id] then
    name = type_config[id].name
  end
  return name
end

function isNewUI(id)
  return type_config[id].is_new_shop
end

function getHotTagRes(tt)
  local tag_res = {
    hot = "UI/alpha/HVGA/shop_new.png",
    old = "UI/alpha/HVGA/shop_hot.png"
  }
  return tag_res[tt]
end

function checkPackageFull(eid, amount)
  local maxAmount = ed.player:getItemMaxAmount(eid)
  if maxAmount < (ed.player.equip_qunty[eid] or 0) + amount then
    return true
  end
  return false
end

function getStarGoodsRes(st)
  local goods_res = {
    stone_green = "UI/alpha/HVGA/shop_star_box_1.png",
    stone_blue = "UI/alpha/HVGA/shop_star_box_2.png",
    stone_purple = "UI/alpha/HVGA/shop_star_box_3.png"
  }
  return goods_res[st]
end

function getStarGoodsName(st)
  local goods_name = {
    stone_green = ed.parameter.starshop_goodsname_small,
    stone_blue = ed.parameter.starshop_goodsname_middle,
    stone_purple = ed.parameter.starshop_goodsname_large
  }
  return goods_name[st]
end

local shop_config = {
  [toId.common] = {
    shopName = T("\231\153\190\232\180\167\229\176\143\229\186\151"),
    shopHeadRes = "UI/alpha/HVGA/shop_head.png",
    offx = 2,
    offy = -10
  },
  [toId.special] = {
    shopName = T("\229\156\176\231\178\190\229\149\134\228\186\186"),
    shopHeadRes = "UI/alpha/HVGA/shop_head_2.png",
    offx = -5,
    offy = -15
  },
  [toId.soSpecial] = {
    shopName = T("\233\187\145\229\184\130\232\128\129\229\164\167"),
    shopHeadRes = "UI/alpha/HVGA/shop_head_3.png",
    offx = 6,
    offy = -9
  },
  [toId.crusade] = {
    shopName = T("\232\191\156\229\190\129\232\161\165\231\187\153\231\171\153"),
    shopHeadRes = "UI/alpha/HVGA/shop_head_tb.png",
    offx = 5,
    offy = 2
  },
  [toId.pvp] = {
    shopName = T("\231\171\158\230\138\128\229\156\186\229\134\155\233\156\128\229\174\152"),
    shopHeadRes = "UI/alpha/HVGA/shop_head_panda.png",
    offx = 0,
    offy = -10
  },
  [toId.guild] = {
    shopName = T("\229\133\172\228\188\154\229\149\134\229\186\151"),
    shopHeadRes = "UI/alpha/HVGA/shop_head_guild.png",
    offx = -5,
    offy = 12
  },
  [toId.gvg] = {
    shopName = T("\230\136\152\229\156\186\229\134\155\233\156\128\229\174\152"),
    shopHeadRes = "UI/alpha/HVGA/shop_head_gvg.png",
    offx = -8,
    offy = 26
  },
  [toId.dreamland] = {
    shopName = T("\230\162\166\229\162\131\229\176\143\229\186\151"),
    shopHeadRes = "UI/alpha/HVGA/shop_head_dreamland.png",
    offx = -13,
    offy = 6
  },
  [toId.legendArena] = {
    shopName = T("\228\188\160\229\165\135\231\171\158\230\138\128\229\156\186"),
    shopHeadRes = "UI/alpha/HVGA/legend_pvp/shop_head_legendpvp.png",
    offx = 10,
    offy = 10
  },
  [toId.starGate] = {
    shopName = T("\230\183\183\228\185\177\230\152\159\233\151\168"),
    shopHeadRes = "UI/alpha/HVGA/stargate/shop_head_fv.png",
    offx = -2,
    offy = -8,
    scale = 0.7
  },
  [toId.diamondShop] = {
    shopName = T("\233\153\144\230\151\182\228\188\152\230\131\160\229\149\134\229\186\151"),
    shopHeadRes = "UI/alpha/HVGA/shop_head_diamond.png",
    offx = 10,
    offy = 10
  }
}

function getShopCfg(id)
  return shop_config[id]
end
