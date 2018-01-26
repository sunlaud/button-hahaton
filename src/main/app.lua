if adc.force_init_mode(adc.INIT_VDD33)
then
  node.restart()
  print("restarting to reinit ADC mode")
  return -- don't bother continuing, the restart is scheduled
end


dofile("config.lua")

led = require "led"
led.init()
led.blink_fast()

button_pin = config.button_pin
http_request_in_progress = false

function wake_up()
	print("waking up")
end

function sleep() 
  print("sleeping...")
  node.sleep({ wake_pin = button_pin, int_type = node.INT_DOWN, resume_cb = wake_up })
end

headers = "User-Agent: HaHa-Button\r\nAccept: */*\r\n"

function button_pressed()
  print("pressed")
  if not http_request_in_progress then
    local server_url = "http://" .. config.server_host .. "/wishes/BUTTON/1"
    print("sending to server: " .. server_url)
    led.blink_one_time(1)
    http.post(server_url, headers, nil, function(code, data)
      print("http results: ", code, data)
      if code ~= 200 then
        led.blink_one_time(4)
      end
      http_request_in_progress = false 
    end)

    http_request_in_progress = true
  end
end
    
function button_released()
  print("released")
  --sleep()  
end




dofile("gpio.lua")
--dofile("telnet.lua")
dofile("wifi_station.lua")




--sleep() -- node.sleep == nil, perhaps coz wifi is disabled