local led_pin = config.led_pin
local gpio = gpio
local led = {}
local current_frequency = nil


local function led_blink_constantly(frequency)
  if current_frequency == frequency then
    return
  end
  
  if frequency == 0 then
    pwm.stop(led_pin)
    pwm.close(led_pin)  
  else
    pwm.setup(led_pin, frequency, 2)
    pwm.start(led_pin)
  end
  current_frequency = frequency
end


function led.blink_fast()
  led_blink_constantly(17)
end

function led.blink_medium()
  led_blink_constantly(7)
end

function led.blink_slow()
  led_blink_constantly(2)
end

function led.blink_stop()
  led_blink_constantly(0)
end


function led.blink_one_time(count)
  gpio.write(led_pin, gpio.HIGH)
  tmr.create():alarm(50, tmr.ALARM_SINGLE, function()
      gpio.write(led_pin, gpio.LOW)
      if count > 1 then
          tmr.create():alarm(500, tmr.ALARM_SINGLE, function()
                led.blink_one_time(count - 1)
          end)  
      end
  end)
end

function led.init()
	gpio.mode(led_pin, gpio.OUTPUT)
end

return led
