local joystick
local joystickSize = 40
joystick = display.newCircle( 0, 0 + joystickSize, joystickSize )
joystick.alpha = 0.1
joystick.x = display.safeScreenOriginX + joystickSize*1.3
joystick.y = display.safeScreenOriginY + display.safeActualContentHeight - joystickSize*1.3
joystick.isActive = false
joystick.isAvailable = true
-- Update the help text location.

joystick.bulb = display.newCircle( 0, 0, joystickSize*0.8 * 0.8 )
joystick.bulb.alpha = 0.5
joystick.bulb.x = joystick.x ; joystick.bulb.y = joystick.y
joystick.bulb.isFocus = false

local function control( event ) -- Generate food where background is touched
	local t = event.target -- joystick.bulb
	if event.phase == "began" and joystick.isActive == false then -- If joystick is not active, make it active and make it the focus.
		joystick.isActive = true
        joystick.x = event.x ; joystick.y = event.y
        joystick.bulb.x = event.x ; joystick.bulb.y = event.y
		display.getCurrentStage():setFocus( t )
		t.isFocus = true	
	elseif t.isFocus == true then -- Once the joystick (joystick.bulb) has screen focus - move the bulb - which registers a new angle.
		if event.phase == "moved" then
            joystick.angle = math.atan2( event.y - joystick.y, event.x - joystick.x)
			joystick.isActive = true
			joystick.bulb.x = event.x ; joystick.bulb.y = event.y
		else -- Event ended or joystick bulb is to far away from the joystick circle.
            joystick.isActive = false
			joystick.isAvailable = false
            joystick.x = display.safeScreenOriginX + joystickSize*1.3
            joystick.y = display.safeScreenOriginY + display.safeActualContentHeight - joystickSize*1.3
			transition.to( joystick.bulb, { time=300, x = joystick.x, y = joystick.y, transition = easing.outBounce, onComplete=
				function() 
					joystick.isAvailable = true
				end} )
			display.getCurrentStage():setFocus( nil )
			t.isFocus = false 
			joystick.isActive = false
            joystick.angle = nil
		end
	end
	return true -- Stops the touch from propogating to underlying objects.
end
joystick.bulb:addEventListener( "touch", control )

joystick.distanceBetween = function ( object, target)
	local xfactor = object.x - target.x
	local yfactor = object.y - target.y
	local distance = math.sqrt( xfactor * xfactor + yfactor * yfactor )
	return distance
end

return joystick
