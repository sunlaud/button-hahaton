function startup()
  dofile("util.lua")  
  sysinfo()
  meminfo()
  if file.exists("app.lua") then
    print("Running main app file 'app.lua'")
    dofile("app.lua")
    print("App started")
    meminfo()
  else
    print("Main app file 'app.lua' deleted or renamed")
  end
end

print("System voltage: ", adc.readvdd33() / 1000 .. "V")
print("Waiting 3 seconds before starting up...")
tmr.create():alarm(3000, tmr.ALARM_SINGLE, startup)
