
do
  local DEBOUNCE_TIME_MS = 50


-- C source translated to Lua, original: from http://www.kennethkuhn.com/electronics/debounce.c

  local function debounce(sampling_period_ms, initial, func)
    local maximum = DEBOUNCE_TIME_MS / sampling_period_ms
    local integrator = (initial == 1) and maximum or 0  -- Will range from 0 to the specified MAXIMUM
    local output = initial;      -- Cleaned-up version of the input signal  
    
    return function(input)
        -- Step 1: Update the integrator based on the input signal.  Note that the integrator follows the input, 
        -- decreasing or increasing towards the limits as determined by the input state (0 or 1).
        if input == 0 then
          if integrator > 0 then
            integrator = integrator - 1
          end
        else
          if integrator < maximum then
            integrator = integrator + 1
          end
        end
         
        -- Step 2: Update the output state based on the integrator.  Note that the output will only change states
        -- if the integrator has reached a limit, either 0 or MAXIMUM.
        if integrator == 0 and output ~= 0 then
          output = 0
          func(output)
        elseif integrator >= maximum and output ~= 1 then
          output = 1
          integrator = maximum;  -- defensive code if integrator got corrupted
          func(output)
        end
    end;
  end





local pin_sampler = tmr.create()

function button_pin_went_low()
  gpio.trig(button_pin, "none")
	pin_sampler:start()
end

function button_state_changed(new_state)
  if (new_state == 0) then
    button_pressed()
  else
    pin_sampler:stop()
    gpio.trig(button_pin, "down", button_pin_went_low)
    button_released()
  end
end

local debounced = debounce(5, 1, button_state_changed)


function read_pin_state() 
  debounced(gpio.read(button_pin))
end

pin_sampler:register(5, tmr.ALARM_AUTO, read_pin_state)
gpio.mode(button_pin, gpio.INT, gpio.PULLUP)


gpio.trig(button_pin, "down", button_pin_went_low)




end











    




