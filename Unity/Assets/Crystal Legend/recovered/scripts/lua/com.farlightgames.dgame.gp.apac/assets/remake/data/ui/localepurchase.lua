local class = newclass("g")
ed.localepurchase = class
setfenv(1, class)
localeProducts = {}

function getLocaleProduct(id)
  local id = tostring(id)
  if EDFLAGIOS then
  end
  if EDFLAGANDROID then
    id = "localeproduct-" .. id
  end
  if localeProducts[id] then
    return localeProducts[id]
  end
  local p = EDGetLocaleProduct(id) or ""
  local title = string.match(p, "title:([^,]*),")
  local desc = string.match(p, "desc:([^,]*),")
  local price1 = string.match(p, "price:([^,]*%d+,%d[^,]*),")
  local price2 = string.match(p, "price:([^,]*),")
  local price = ""
  if #(price1 or "") >= #(price2 or "") then
    price = price1
  else
    price = price2
  end
  local symbol = string.match(p, "symbol:([^,]*),")
  local code = string.match(p, "code:([^,]*),")
  local pid = string.match(p, "id:([^,]*),")
  local cost
  if EDFLAGIOS then
    cost = string.format("%s%s", symbol, price)
  end
  if EDFLAGANDROID then
    cost = price
  end
  localeProducts[id] = {
    title = title,
    desc = desc,
    price = price,
    symbol = symbol,
    code = code,
    id = pid,
    cost = cost
  }
  return localeProducts[id]
end
