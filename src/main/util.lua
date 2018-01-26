boot_reasons = {
    [1] = "power-on",
    [2] = "reset (software?)",
    [3] = "hardware reset via reset pin",
    [4] = "WDT reset (watchdog timeout)",
}

reset_reasons = {
    [0] = "power-on",
    [1] = "hardware watchdog reset",
    [2] = "exception reset",
    [3] = "software watchdog reset",
    [4] = "software restart",
    [5] = "wake from deep sleep",
    [6] = "external reset",
}

function dump(t)
   for k, v in pairs(t) do
      print(k, v)
   end
end

function ls()
   local sum = 0
   for file, size in pairs(file.list()) do
      sum = sum + size
      print(file, size)
   end
   print(string.format("Total: %.2f KiB", sum / 1024))
end

function meminfo()
   print(string.format("Mem free (heap) : %.2f KiB\n", node.heap() / 1024) ..
         string.format("Mem used by lua : %.2f KiB\n", collectgarbage("count")))
end

function sysinfo()
   local majorVer, minorVer, devVer, chipid, flashid, flashsize, flashmode, flashspeed = node.info()
   local remaining, used, total=file.fsinfo()
   local boot_reason, reset_reason = node.bootreason();
   print(   "Boot reason   : "..boot_reasons[boot_reason].."\n"..
            "Reset reason  : "..reset_reasons[reset_reason].."\n"..
            "Node MCU      : "..majorVer.."."..minorVer.."."..devVer.."\n"..
            "Chip ID       : "..chipid.."\n"..
            "Flash ID      : "..flashid.."\n"..
            "Flash Size    : "..flashsize.."\n"..
            "Flash Mode    : "..flashmode.."\n"..
            "Flash Speed   : "..flashspeed.."\n"..
            string.format("Total FS size : %.2f KiB\n", total / 1024)..
            string.format("Used FS size  : %.2f KiB\n", used / 1024)..
            string.format("Free FS size  : %.2f KiB\n", remaining / 1024))
end
