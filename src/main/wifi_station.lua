led = require "led"

local connectivity_cheker = tmr.create()

function check_internet_connectivity()
  if not http_request_in_progress then
    print("checking internet connectivity...")
    http.get(config.connectivify_check_url, nil, function(code, data)
      if code == 204 then
        print("got some internet! :), will not check any more")
        led.blink_stop()
        connectivity_cheker:stop()
      else
        print("internet not found :(, will recheck later")
        connectivity_cheker:start()
        led.blink_slow()
      end
      http_request_in_progress = false 
    end)
    http_request_in_progress = true
  else
    print("another http request is in progress, skipping internet connectivity check")
    connectivity_cheker:start()
  end
end


connectivity_cheker:register(config.connectivify_check_interval_ms, tmr.ALARM_SEMI, check_internet_connectivity)



wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T)
  print("\n\tSTA - CONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..T.BSSID.."\n\tChannel: "..T.channel)
  led.blink_medium()
end)

wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(T)
  print("\n\tSTA - DISCONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..T.BSSID.."\n\treason: "..T.reason)
  if server ~= nil then
    print("closing telnet server") 
    server:close()
  end
  connectivity_cheker:stop()
  led.blink_fast()
end)

wifi.eventmon.register(wifi.eventmon.STA_AUTHMODE_CHANGE, function(T)
  print("\n\tSTA - AUTHMODE CHANGE".."\n\told_auth_mode: "..T.old_auth_mode.."\n\tnew_auth_mode: "..T.new_auth_mode)
end)

wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(T)
  print("\n\tSTA - GOT IP".."\n\tStation IP: "..T.IP.."\n\tSubnet mask: "..T.netmask.."\n\tGateway IP: "..T.gateway)
  led.blink_slow()
  check_internet_connectivity()
--  print("starting telnet server") 
--  server = startTelnetServer()
end)

wifi.eventmon.register(wifi.eventmon.STA_DHCP_TIMEOUT, function()
  print("\n\tSTA - DHCP TIMEOUT")
  connectivity_cheker:stop()
  led.blink_fast()
end)

wifi.eventmon.register(wifi.eventmon.WIFI_MODE_CHANGED, function(T)
  print("\n\tSTA - WIFI MODE CHANGED".."\n\told_mode: "..T.old_mode.."\n\tnew_mode: "..T.new_mode)
end)



cfg = {
  ssid = config.wifi_ssid, 
  pwd = config.wifi_pwd,
  auto = true,
  save = true
}

print("Starting Wi-Fi...")
wifi.setmode(wifi.STATION, save)
if config.replace_mac then
  wifi.sta.setmac(config.mac_address)
end
print("MAC address: " .. wifi.sta.getmac())
wifi.sta.config(cfg)


wifi.sta.sleeptype(wifi.MODEM_SLEEP)



