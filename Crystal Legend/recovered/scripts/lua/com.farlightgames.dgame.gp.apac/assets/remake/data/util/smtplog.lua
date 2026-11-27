local smtp = require("socket.smtp")
require("gzio")
ed.mailbox = "<dgamelog@sina.cn>"
ed.mailserver = "smtp.sina.cn"
ed.mailuser = "dgamelog"
ed.mailpass = "dgamelog#1954631"

function sendmailwithattachment(filename, label)
  print(filename)
  print("smtp send mail begin!")
  from = ed.mailbox
  to = ed.mailbox
  rcpt = {
    ed.mailbox
  }
  mesgt = {}
  if filename == nil then
    mesgt = {
      headers = {
        to,
        subject = "DGame-LuaCrashLog " .. label
      },
      body = "lua crashed,but no file name input!"
    }
  else
    testfileexisted = io.open(filename, "rb")
    if testfileexisted == nil then
      print("attachment not exist!")
    else
      print("attachment ok!")
    end
    mesgt = {
      headers = {
        to,
        ["content-type"] = "text/html",
        ["content-disposition"] = "attachment; filename=\"" .. filename .. "\"",
        ["content-description"] = "luaDumpLogFile",
        ["content-transfer-encoding"] = "BASE64",
        subject = "DGame-LuaCrashLog " .. label
      },
      body = ltn12.source.chain(ltn12.source.file(testfileexisted), ltn12.filter.chain(mimestuff.encode("base64"), mimestuff.wrap()))
    }
  end
  print("msg prepared!")
  r, e = smtp.send({
    server = ed.mailserver,
    user = ed.mailuser,
    password = ed.mailpass,
    from = from,
    rcpt = rcpt,
    source = smtp.message(mesgt)
  })
  print("msg sended!")
  if not r then
    print(e)
  else
    print("send ok!")
  end
end

function sendmailtext(mailbody, label)
  print("smtp send mail begin!")
  from = ed.mailbox
  to = ed.mailbox
  rcpt = {
    ed.mailbox
  }
  mesgt = {
    headers = {
      to,
      subject = "DGame-LuaCrashLog " .. label
    },
    body = mailbody .. label
  }
  print("msg prepared!")
  r, e = smtp.send({
    server = ed.mailserver,
    user = ed.mailuser,
    password = ed.mailpass,
    from = from,
    rcpt = rcpt,
    source = smtp.message(mesgt)
  })
  print("msg sended!")
  if not r then
    print(e)
  else
    print("send ok!")
  end
end

function ziplog(filename)
  local gzFile
  print("gzipStart")
  gzFile = assert(gzio.open(filename .. ".zip", "w"))
  for line in io.lines(filename) do
    local ret = gzFile:write(line .. "\n")
  end
  print("gzipEnd")
  gzFile:close()
end

function senddumpfile(logstr)
end
